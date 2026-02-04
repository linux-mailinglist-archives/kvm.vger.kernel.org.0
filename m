Return-Path: <kvm+bounces-70200-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YKpuJ/1Ng2lrlAMAu9opvQ
	(envelope-from <kvm+bounces-70200-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 14:47:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6096CE6A2C
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 14:47:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B4E29303388F
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 13:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0C323ED12E;
	Wed,  4 Feb 2026 13:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="p8L3brfY"
X-Original-To: kvm@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82073392827;
	Wed,  4 Feb 2026 13:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770212736; cv=none; b=nHFzo9WfUF8T0EsbSL8XHkScJnFZZpEcCRhjkFwlC3/KP6pbkx7wB6O1MV3Vulg8f5Zabvf9TD1cp8nkYQu7TfclwYFXgEK9/1ltzlK/fWQLQOqjrbtN2XxBV8KyurGsmovq0y/qWczq+fUpiN5ChUuULBGwiKyj3hcLkFnFT7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770212736; c=relaxed/simple;
	bh=6AoUWFoe1qTdaPzHfdR8hNXmzBqZ37rlpHoBFd6gM1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T6z11rme227JXTTxJQeYbpF6aPt5Zstu+FNfNzL22wmfbyTUtPnZERwhuI4AMMJYzVmv/bKtxvkmlw1EJsPD8aAIpdbRzE38bAd8xXbXp2qpkN2k9pkhngK9Wf1fUnmQNbI9qi5d1aQS+/Pl083ly32tVnhRoxsZ3acc7ZXmYTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=p8L3brfY; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770212724; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=5R42yBenU3WsqPgksKfBN/gXqqDJrrdf2h4U39oXsd8=;
	b=p8L3brfYKi6VejGdkPtQhQstAeQ2lIpJfXKDrlXjdyndWuit/nXBGn/lM605LeSCM1tkTZy8Rs0IReLS0FJr1+VbCm3boFg2JrCNIA6Zelr6QTz++3/XotT3TYsjcaA11jKGNDKCWMW6GR0FHpfmozvARvKAauXaLgtiR7l5e7A=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WyXBzAg_1770212721 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Feb 2026 21:45:22 +0800
From: fangyu.yu@linux.alibaba.com
To: pbonzini@redhat.com,
	corbet@lwn.net,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: guoren@kernel.org,
	radim.krcmar@oss.qualcomm.com,
	andrew.jones@oss.qualcomm.com,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH v5 3/3] RISC-V: KVM: add KVM_CAP_RISCV_SET_HGATP_MODE
Date: Wed,  4 Feb 2026 21:45:07 +0800
Message-Id: <20260204134507.33912-4-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260204134507.33912-1-fangyu.yu@linux.alibaba.com>
References: <20260204134507.33912-1-fangyu.yu@linux.alibaba.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70200-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_NO_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fangyu.yu@linux.alibaba.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.alibaba.com:mid,linux.alibaba.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,alibaba.com:email]
X-Rspamd-Queue-Id: 6096CE6A2C
X-Rspamd-Action: no action

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

Add a VM capability that allows userspace to select the G-stage page table
format by setting HGATP.MODE on a per-VM basis.

Userspace enables the capability via KVM_ENABLE_CAP, passing the requested
HGATP.MODE in args[0]. The request is rejected with -EINVAL if the mode is
not supported by the host, and with -EBUSY if the VM has already been
committed (e.g. vCPUs have been created or any memslot is populated).

KVM_CHECK_EXTENSION(KVM_CAP_RISCV_SET_HGATP_MODE) returns a bitmask of the
HGATP.MODE formats supported by the host.

Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
---
 Documentation/virt/kvm/api.rst | 27 +++++++++++++++++++++++++++
 arch/riscv/kvm/vm.c            | 19 +++++++++++++++++--
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 01a3abef8abb..62dc120857c1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8765,6 +8765,33 @@ helpful if user space wants to emulate instructions which are not
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
+    non-empty memslots.
+
+This capability allows userspace to explicitly select the HGATP mode for
+the VM. The selected mode must be supported by both KVM and hardware. This
+capability must be enabled before creating any vCPUs or memslots.
+
+If this capability is not enabled, KVM will select the default HGATP mode
+automatically. The default is the highest HGATP.MODE value supported by
+hardware.
+
+``KVM_CHECK_EXTENSION(KVM_CAP_RISCV_SET_HGATP_MODE)`` returns a bitmask of
+HGATP.MODE values supported by the host. A return value of 0 indicates that
+the capability is not supported. Supported-mode bitmask use HGATP.MODE
+encodings as defined by the RISC-V privileged specification, such as Sv39x4
+corresponds to HGATP.MODE=8, so userspace should test bitmask & BIT(8).
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 4b2156df40fc..7d1e1d257df5 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -202,6 +202,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_GPA_BITS:
 		r = kvm_riscv_gstage_gpa_bits(&kvm->arch);
 		break;
+	case KVM_CAP_RISCV_SET_HGATP_MODE:
+		r = kvm_riscv_get_hgatp_mode_mask();
+		break;
 	default:
 		r = 0;
 		break;
@@ -212,12 +215,24 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 
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
+		if (!kvm_riscv_hgatp_mode_is_valid(cap->args[0]))
+			return -EINVAL;
+
+		if (kvm->created_vcpus || !kvm_are_all_memslots_empty(kvm))
+			return -EBUSY;
+#ifdef CONFIG_64BIT
+		kvm->arch.kvm_riscv_gstage_pgd_levels =
+				3 + cap->args[0] - HGATP_MODE_SV39X4;
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


