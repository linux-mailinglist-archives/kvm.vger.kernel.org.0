Return-Path: <kvm+bounces-67052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DA6ACCF42C6
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 15:38:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ED41A3090DF4
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 14:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F8F27C84B;
	Mon,  5 Jan 2026 14:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qnQ8/XAE"
X-Original-To: kvm@vger.kernel.org
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53585199E94;
	Mon,  5 Jan 2026 14:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767623577; cv=none; b=dtTKLOIsQKoHOQ5w9wnptuwoTaCU3pD5Yf/Dh8WjBFEjKmZUR9qs/RGp4KhDqx1PwwjQ6kCaaVAliAu2Jbjc+AKyrJhwv4VarR1gHdzFLyRobzVcYv2PRB/b3RRYI6A8VLRG3QH2ftkCrtUPgivZjY2wZn0nW0O0/BJIqZavAW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767623577; c=relaxed/simple;
	bh=b4cE936b1RYCDSr7VXFgvtUVAS0JilSHQK2ihWwWCc0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VfwvIBOFf40xFj3vj3nYXh5ZkyjXBnfYBwaEznEGo3bml5Ll0F7n+ZEa0B1tJI6k55NLx9iU8ajwR5I9lg1H6EMCeFhaMt4tXYlhp16ilId31lmVB8Xnbn9ZwodWRWbU7KeY69i5MKH5Y/YXjxgy3/4TuBWlD7eNt/BzCbU3KTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qnQ8/XAE; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767623572; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=9x1tEfrDdtu6NZBn53IIP9pnsOoKSxBLjmTO87rJs+U=;
	b=qnQ8/XAEXRPfMM30AuSJcD+jIlq9dSET4FjNRq3BCBwVphOalx2ucV+6x7z8H5EctLyQhZRfUddM+LPhYP6PUSzaopZG6q6GRctxiwjGnX/EaQy87L2D0iuE3mFFzam+8oUIJW9/v8E8DK7/GJivL8HtoXQObGOQ7jlGpg+eEeY=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WwPuTws_1767623568 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 05 Jan 2026 22:32:51 +0800
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
	ajones@ventanamicro.com,
	rkrcmar@ventanamicro.com,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH v2] RISC-V: KVM: add KVM_CAP_RISCV_SET_HGATP_MODE
Date: Mon,  5 Jan 2026 22:32:32 +0800
Message-Id: <20260105143232.76715-3-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260105143232.76715-1-fangyu.yu@linux.alibaba.com>
References: <20260105143232.76715-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

This capability allows userspace to explicitly select the HGATP mode
for the VM. The selected mode must be less than or equal to the max
HGATP mode supported by the hardware. This capability must be enabled
before creating any vCPUs, and can only be set once per VM.

Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
---
 Documentation/virt/kvm/api.rst | 14 ++++++++++++++
 arch/riscv/kvm/vm.c            | 26 ++++++++++++++++++++++++--
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 01a3abef8abb..9e17788e3a9d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8765,6 +8765,20 @@ helpful if user space wants to emulate instructions which are not
 This capability can be enabled dynamically even if VCPUs were already
 created and are running.
 
+7.47 KVM_CAP_RISCV_SET_HGATP_MODE
+---------------------------------
+
+:Architectures: riscv
+:Type: VM
+:Parameters: args[0] contains the requested HGATP mode
+:Returns: 0 on success, -EINVAL if arg[0] is outside the range of hgatp
+          modes supported by the hardware.
+
+This capability allows userspace to explicitly select the HGATP mode for
+the VM. The selected mode must be less than or equal to the maximum HGATP
+mode supported by the hardware. This capability must be enabled before
+creating any vCPUs, and can only be set once per VM.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 4b2156df40fc..e9275023a73a 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -202,6 +202,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_GPA_BITS:
 		r = kvm_riscv_gstage_gpa_bits(&kvm->arch);
 		break;
+	case KVM_CAP_RISCV_SET_HGATP_MODE:
+#ifdef CONFIG_64BIT
+		r = 1;
+#else/* CONFIG_32BIT */
+		r = 0;
+#endif
+		break;
 	default:
 		r = 0;
 		break;
@@ -212,12 +219,27 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 {
+	if (cap->flags)
+		return -EINVAL;
 	switch (cap->cap) {
 	case KVM_CAP_RISCV_MP_STATE_RESET:
-		if (cap->flags)
-			return -EINVAL;
 		kvm->arch.mp_state_reset = true;
 		return 0;
+	case KVM_CAP_RISCV_SET_HGATP_MODE:
+#ifdef CONFIG_64BIT
+		if (cap->args[0] < HGATP_MODE_SV39X4 ||
+			cap->args[0] > kvm_riscv_gstage_max_mode)
+			return -EINVAL;
+		if (kvm->arch.gstage_mode_initialized)
+			return 0;
+		kvm->arch.gstage_mode_initialized = true;
+		kvm->arch.kvm_riscv_gstage_mode = cap->args[0];
+		kvm->arch.kvm_riscv_gstage_pgd_levels = 3 +
+		    kvm->arch.kvm_riscv_gstage_mode - HGATP_MODE_SV39X4;
+		kvm_info("using SV%lluX4 G-stage page table format\n",
+			39 + (cap->args[0] - HGATP_MODE_SV39X4) * 9);
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


