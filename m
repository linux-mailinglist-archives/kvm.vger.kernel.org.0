Return-Path: <kvm+bounces-59148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 326FEBAC820
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:35:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C498A485963
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 694AB2FFF9E;
	Tue, 30 Sep 2025 10:32:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71D572FF66F;
	Tue, 30 Sep 2025 10:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759228338; cv=none; b=ti7Ql5OWsGXn1+QBmJCXDiDwE563ceqSHSjDQEwKRWmr3XUV8CFdVPaMjAbTbSWTNlRCD6k2us2Jrb3j+1xdAl2zppDitf1FUYlkjnCVfGxlXl6kSIoMywG5KfzLyz2a2dYkwPtvG3v/8bCXhR5+g+aETjM3/IWAXHpPIMU8kDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759228338; c=relaxed/simple;
	bh=oFezU3XGjLcTfoUCYITrerDtbr6dbbwBkizSu3A7CoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rsjs8TMoT0P29fZlJKjcWcOHiSskz5D6NwkzyWi5fs9TZiu+IijPU/Ym57YbWeH7LUu5tbFQk+dF2DcoGQZbfJ7Shka3lk4DfdmmuHQA6VTuu70P5gW9fytfb3LgwjWig9vyipEmpoy0DzLNj2KRswY4pY+OrZT3w3NHXA8z+cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 101E0202C;
	Tue, 30 Sep 2025 03:32:09 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AEC283F66E;
	Tue, 30 Sep 2025 03:32:15 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	will@kernel.org,
	oliver.upton@linux.dev,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	tabba@google.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH kvmtool v4 10/15] arm64: psci: Implement CPU_SUSPEND
Date: Tue, 30 Sep 2025 11:31:25 +0100
Message-ID: <20250930103130.197534-12-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930103130.197534-1-suzuki.poulose@arm.com>
References: <20250930103130.197534-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Implement support for PSCI CPU_SUSPEND, leveraging in-kernel suspend
emulation (i.e. a WFI state). Eagerly resume the vCPU for any wakeup
event.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 kvm-cpu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kvm-cpu.c b/kvm-cpu.c
index 7362f2e9..d718ef60 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -143,6 +143,16 @@ void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task)
 	mutex_unlock(&task_lock);
 }
 
+static void handle_wakeup(struct kvm_cpu *vcpu)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state = KVM_MP_STATE_RUNNABLE,
+	};
+
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+		die_perror("KVM_SET_MP_STATE failed");
+}
+
 int kvm_cpu__start(struct kvm_cpu *cpu)
 {
 	sigset_t sigset;
@@ -236,6 +246,9 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
 				 */
 				kvm__reboot(cpu->kvm);
 				goto exit_kvm;
+			case KVM_SYSTEM_EVENT_WAKEUP:
+				handle_wakeup(cpu);
+				break;
 			};
 			break;
 		default: {
-- 
2.43.0


