Return-Path: <kvm+bounces-69068-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MDpIB3kxdmkyNQEAu9opvQ
	(envelope-from <kvm+bounces-69068-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 16:06:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E22811FD
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 16:06:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 76BD0301AB88
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 15:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA12D324B34;
	Sun, 25 Jan 2026 15:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="QAoLzSNw"
X-Original-To: kvm@vger.kernel.org
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A979331BC84;
	Sun, 25 Jan 2026 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769353523; cv=none; b=rPXfts7dP2MgK06HFf9AQpYg25tjPM/emUoY+1DyYeIXkgDjyD/cBxuBF7eB2aPusWlHf+hAL0btHwEheDBz8rQUgGrdZg3Va2MSjDRzEDQ2WPZge9Gb/p3SO5fgiQF7fV96441fF7Mua3UiNJpavxBgSiUqa3Dw71WNczNaP4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769353523; c=relaxed/simple;
	bh=+HYGC9MkxCv0GMPldzg0W9scvCudKS8glLZcufmFJuk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=erkvx0mHxOhvZyv1zdJxvwRYyNtsopNlW9o4NuJCyttiGqTMnpA8PH7RTsglKGozPbw5q/LXUU00nSAJRIZRSQFHuljPHaRz6buqddBeYkwLHkGj0e30es1A/hoKkwcP9ubwyTCSzwENJTcyXtfMN/ihR2b/zCihQ6e0XQXBOOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=QAoLzSNw; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769353511; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=mf2rWU47N7BSYXT74kTz7Bi679iF6CzJnW0oUTiOa7k=;
	b=QAoLzSNwAGDHd76qnbtyYwmEYEXPv/CphY9Wcqmp17ni/1E15qvVFvuy0a9tE3BLQvoDU/MceGpQLLwygrjPVeAA7L5sx2KOZQ/wpffa7NLoyAtHo2MSiZPPpmm8va7wEpH7IMn8XZFwT8ONVwGvhs5/n4wvhNMz9z3SmLm0Wqg=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WxlpgUb_1769353508 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 25 Jan 2026 23:05:09 +0800
From: fangyu.yu@linux.alibaba.com
To: pbonzini@redhat.com,
	corbet@lwn.net,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	radim.krcmar@oss.qualcomm.com,
	andrew.jones@oss.qualcomm.com
Cc: guoren@kernel.org,
	ajones@ventanamicro.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH v3 2/2] RISC-V: KVM: add KVM_CAP_RISCV_SET_HGATP_MODE
Date: Sun, 25 Jan 2026 23:04:50 +0800
Message-Id: <20260125150450.27068-3-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260125150450.27068-1-fangyu.yu@linux.alibaba.com>
References: <20260125150450.27068-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69068-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fangyu.yu@linux.alibaba.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	FROM_NO_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.alibaba.com:mid,linux.alibaba.com:dkim]
X-Rspamd-Queue-Id: B8E22811FD
X-Rspamd-Action: no action

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

This capability allows userspace to explicitly select the HGATP mode
for the VM. The selected mode must be less than or equal to the max
HGATP mode supported by the hardware. This capability must be enabled
before creating any vCPUs, and can only be set once per VM.

Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
---
 Documentation/virt/kvm/api.rst | 18 ++++++++++++++++++
 arch/riscv/kvm/vm.c            | 26 ++++++++++++++++++++++++--
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 01a3abef8abb..9d0794b174c7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8765,6 +8765,24 @@ helpful if user space wants to emulate instructions which are not
 This capability can be enabled dynamically even if VCPUs were already
 created and are running.
 
+7.47 KVM_CAP_RISCV_SET_HGATP_MODE
+---------------------------------
+
+:Architectures: riscv
+:Type: VM
+:Parameters: args[0] contains the requested HGATP mode
+:Returns:
+  - 0 on success.
+  - -EINVAL if args[0] is outside the range of HGATP modes supported by the
+    hardware.
+  - -EBUSY if vCPUs have already been created for the VM, if the VM has any
+    non-empty memslots, or if the capability has already been set for the VM.
+
+This capability allows userspace to explicitly select the HGATP mode for
+the VM. The selected mode must be less than or equal to the maximum HGATP
+mode supported by the hardware. This capability must be enabled before
+creating any vCPUs, and can only be set once per VM.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 4b2156df40fc..7bc9b193dcaa 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -202,6 +202,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_GPA_BITS:
 		r = kvm_riscv_gstage_gpa_bits(&kvm->arch);
 		break;
+	case KVM_CAP_RISCV_SET_HGATP_MODE:
+		r = IS_ENABLED(CONFIG_64BIT) ? 1 : 0;
+		break;
 	default:
 		r = 0;
 		break;
@@ -212,12 +215,31 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 {
+	if (cap->flags)
+		return -EINVAL;
+
 	switch (cap->cap) {
 	case KVM_CAP_RISCV_MP_STATE_RESET:
-		if (cap->flags)
-			return -EINVAL;
 		kvm->arch.mp_state_reset = true;
 		return 0;
+	case KVM_CAP_RISCV_SET_HGATP_MODE:
+#ifdef CONFIG_64BIT
+		if (cap->args[0] < HGATP_MODE_SV39X4 ||
+		    cap->args[0] > kvm_riscv_gstage_mode(kvm_riscv_gstage_max_pgd_levels))
+			return -EINVAL;
+
+		if (kvm->arch.gstage_mode_user_initialized || kvm->created_vcpus ||
+		    !kvm_are_all_memslots_empty(kvm))
+			return -EBUSY;
+
+		kvm->arch.gstage_mode_user_initialized = true;
+		kvm->arch.kvm_riscv_gstage_pgd_levels =
+				3 + cap->args[0] - HGATP_MODE_SV39X4;
+		kvm_debug("VM (vmid:%lu) using SV%lluX4 G-stage page table format\n",
+			  kvm->arch.vmid.vmid,
+			  39 + (cap->args[0] - HGATP_MODE_SV39X4) * 9);
+#endif
+		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dddb781b0507..00c02a880518 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -974,6 +974,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
 #define KVM_CAP_ARM_SEA_TO_USER 245
 #define KVM_CAP_S390_USER_OPEREXEC 246
+#define KVM_CAP_RISCV_SET_HGATP_MODE 247
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.50.1


