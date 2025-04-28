Return-Path: <kvm+bounces-44566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F88EA9F022
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 14:01:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD4E45A0ECC
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 12:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D12326F469;
	Mon, 28 Apr 2025 11:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fLKyy379"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81EA267B1B
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 11:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745841479; cv=none; b=odjXly3KGEV0ia2pvELs9GJNBqREMk7prWNPA74Xe1at50jqGHbTOjBVVYiBqsFUL6nc8qqKX9tJufrhSRtz9/s6khzzIghB2z8PFxLgzG7EFuZxYe6jWXLSuCYq6z+9atMBKKdXa/OC3dFX6qLKj1HbQxvTmXmcDu03DD/4Y60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745841479; c=relaxed/simple;
	bh=J4OW/u3Xz7UsUzctFrQjOAlfQdbWrTwt0nwQ7Hi3dTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/Dcl/NcQC2XutzcWjZOb++O1UXGteL3ECaF1fRExxZtiplfsAxFmLQ4ciNOrFTDYSu602+WPNPr/qXR3QqverXuTku/61a9oVom1RXBM9J5xlfQicQA7qoG8ShYC6llROrWMUg8XTxb3bA9JpjZpZqsl0xoH2aggIFjqINtM80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fLKyy379; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85618C4CEE9;
	Mon, 28 Apr 2025 11:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745841479;
	bh=J4OW/u3Xz7UsUzctFrQjOAlfQdbWrTwt0nwQ7Hi3dTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLKyy379RuaJI1Is6RL1jFCp2X9Mke6ZHC2kzpLWQoQlK99tEc38l8M7+2udiSbfM
	 xRhXzfdQJhgpcjVNK5pXdiCjInzAjSWDglZ6Cf44JLaSCver6XhlfKWOcPFZ/8wf1w
	 WD80ZYUlF8US0YrwNUyo+w1shziFmWtmmF/e77yBGEUxffLnzk+VdBD6D1u7TwirWn
	 ue/D9OjXfaYpqXUufdSTlOqsEeQ1zM3FR2iN2wz6hba+IgU1aalG+Yxlr2UEvyAw0W
	 HWJD8Dm9ztEpkJyHXWsZ0rDyL9wl5RKhRZjtmJmbaqSuFj3iOFbprY6WZKFxsZ0x8+
	 78Slv4i3qFqdg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH kvmtool v3 2/3] cpu: vmexit: Retry KVM_RUN ioctl on EINTR and EAGAIN
Date: Mon, 28 Apr 2025 17:27:44 +0530
Message-ID: <20250428115745.70832-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250428115745.70832-1-aneesh.kumar@kernel.org>
References: <20250428115745.70832-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When KVM_RUN fails with EINTR or EAGAIN, we should retry the ioctl
without checking kvm_run->exit_reason. These errors don't indicate a
valid VM exit, hence exit_reason may contain stale or undefined values.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/kvm/kvm-cpu.h |  2 +-
 kvm-cpu.c             | 17 ++++++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
index 8f76f8a1123a..72cbb86e6cef 100644
--- a/include/kvm/kvm-cpu.h
+++ b/include/kvm/kvm-cpu.h
@@ -16,7 +16,7 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu);
 void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu);
 void kvm_cpu__setup_cpuid(struct kvm_cpu *vcpu);
 void kvm_cpu__enable_singlestep(struct kvm_cpu *vcpu);
-void kvm_cpu__run(struct kvm_cpu *vcpu);
+int kvm_cpu__run(struct kvm_cpu *vcpu);
 int kvm_cpu__start(struct kvm_cpu *cpu);
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu);
 int kvm_cpu__get_endianness(struct kvm_cpu *vcpu);
diff --git a/kvm-cpu.c b/kvm-cpu.c
index 40041a22b3fe..7abbdcebf075 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -35,27 +35,32 @@ void kvm_cpu__enable_singlestep(struct kvm_cpu *vcpu)
 		pr_warning("KVM_SET_GUEST_DEBUG failed");
 }
 
-void kvm_cpu__run(struct kvm_cpu *vcpu)
+/*
+ * return value -1 if we need to call the kvm_cpu__run again without checking
+ * exit_reason. return value 0 results in taking action based on exit_reason.
+ */
+int kvm_cpu__run(struct kvm_cpu *vcpu)
 {
 	int err;
 
 	if (!vcpu->is_running)
-		return;
+		return -1;
 
 	err = ioctl(vcpu->vcpu_fd, KVM_RUN, 0);
 	if (err < 0) {
 		switch (errno) {
 		case EINTR:
 		case EAGAIN:
-			return;
+			return -1;
 		case EFAULT:
 			if (vcpu->kvm_run->exit_reason == KVM_EXIT_MEMORY_FAULT)
-				return;
+				return 0;
 			/* fallthrough */
 		default:
 			die_perror("KVM_RUN failed");
 		}
 	}
+	return 0;
 }
 
 static void kvm_cpu_signal_handler(int signum)
@@ -179,7 +184,9 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
 		if (cpu->task)
 			kvm_cpu__run_task(cpu);
 
-		kvm_cpu__run(cpu);
+		if (kvm_cpu__run(cpu) == -1)
+			/* retry without an exit_reason check */
+			continue;
 
 		switch (cpu->kvm_run->exit_reason) {
 		case KVM_EXIT_UNKNOWN:
-- 
2.43.0


