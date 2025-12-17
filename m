Return-Path: <kvm+bounces-66142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 832BDCC7170
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:31:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3030B3044A78
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 10:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A508354ACE;
	Wed, 17 Dec 2025 10:14:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 557C1352FB9;
	Wed, 17 Dec 2025 10:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966458; cv=none; b=ZwUsSCt3PWOKzgpMG2JIgW41vKEw3kTgYwweeMsbV2T1lOwMWcUSEQA1eF2mUHYM2zVsp/x/t3BvdYs//dHxWIoqZqcbR31tQtB/cGmAph/g2pZah00Udt5LWMyYX+UsR6VQ+lXPAYOg3wRYaznJQZFMXjedUPIotkdNAE+7nWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966458; c=relaxed/simple;
	bh=XdMhdL5+HSw7jPMzdY9ChFWc/FA1kfirxCDN9/AkECE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wr517XDwcW9hUCAtMVlgJN7WFGB5zRQovazr6Bz9Bk6IDNWtOtwae7yZqRJiUktqzYmQiyi+liDRhwfnBrP0MDyTWH9YgaBCzVOOlOKAa9p0z6s6lot7klVwkJahiwRQgPZp0MFrxPjaLNNoXpQYTBHnzyASA3fK/sqxzMGg4Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF7D71517;
	Wed, 17 Dec 2025 02:14:09 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 422343F73B;
	Wed, 17 Dec 2025 02:14:13 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v12 31/46] arm64: RMI: support RSI_HOST_CALL
Date: Wed, 17 Dec 2025 10:11:08 +0000
Message-ID: <20251217101125.91098-32-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251217101125.91098-1-steven.price@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joey Gouly <joey.gouly@arm.com>

Forward RSI_HOST_CALLS to KVM's HVC handler.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
Changes since v7:
 * Avoid turning a negative return from kvm_smccc_call_handler() into a
   error response to the guest. Instead propogate the error back to user
   space.
Changes since v4:
 * Setting GPRS is now done by kvm_rec_enter() rather than
   rec_exit_host_call() (see previous patch - arm64: RME: Handle realm
   enter/exit). This fixes a bug where the registers set by user space
   were being ignored.
---
 arch/arm64/kvm/rmi-exit.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
index b4843f094615..7eff6967530c 100644
--- a/arch/arm64/kvm/rmi-exit.c
+++ b/arch/arm64/kvm/rmi-exit.c
@@ -116,6 +116,19 @@ static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
 	return -EFAULT;
 }
 
+static int rec_exit_host_call(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	vcpu->stat.hvc_exit_stat++;
+
+	for (i = 0; i < REC_RUN_GPRS; i++)
+		vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
+
+	return kvm_smccc_call_handler(vcpu);
+}
+
 static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
 {
 	struct realm_rec *rec = &vcpu->arch.rec;
@@ -183,6 +196,8 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
 		return rec_exit_psci(vcpu);
 	case RMI_EXIT_RIPAS_CHANGE:
 		return rec_exit_ripas_change(vcpu);
+	case RMI_EXIT_HOST_CALL:
+		return rec_exit_host_call(vcpu);
 	}
 
 	kvm_pr_unimpl("Unsupported exit reason: %u\n",
-- 
2.43.0


