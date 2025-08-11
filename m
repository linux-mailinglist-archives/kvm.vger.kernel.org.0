Return-Path: <kvm+bounces-54366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4B0CB1FF0B
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 08:12:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 585D216992A
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 06:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15AF32D8360;
	Mon, 11 Aug 2025 06:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BN4UWneN"
X-Original-To: kvm@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBD42D5C9F;
	Mon, 11 Aug 2025 06:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754892685; cv=none; b=WE7ks0ZTTmhDfW3w02MFMupaGsdv6oGpjqG3km3X2n1V+MSK3tB74D8ScvG2CCJ9Kdvbj85O6Zr/5rCwxh9RsUIehFBEFpyiW2dQ05/rkKXb74v44HeAFH5HoxE6/LUMh0Lh78MEqzL5B1L8YuNU681LFVhCgfbXOp2/2gEBZUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754892685; c=relaxed/simple;
	bh=Ov9Ov+ktpF2ZZ1j0AFTGQpIp0s2TcvExe7S1kk/HsVg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P8bVS3IgD7SUFCxEHcogQR/C+MME5VqHfgcegcDXmYU791rx15zjrKgZLjIRgl72PN8hJbF2vd4Q6hcSxyCP5tXGjlNoS4HENsoee/o02iEkeFofBSAGxEestuOyOMFSmrLzF/0EaC8Iasmt4wpzG/6jrvzJgArk6g/0kFvhOmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BN4UWneN; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754892678; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=JlGDH5MhkH4wQ0znvBetGKXo3m7u1SGgHzon2WgQpFY=;
	b=BN4UWneNvSBPAfLQVEsNVi6RTr6ni+AbqzEFojOj9/pZvyTGsCGuBU3WHlayX7FYcytgrYs7Ysj5F4MDcikB3NOH7laWiYg/38NQizE9/urLKVVV5WyglBP17iizx2d+ebgV6txiBBfY/khZ8k26YW1C8dW3hl6s7pFWSgEMkEo=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WlP-v9j_1754892673 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 Aug 2025 14:11:14 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	atishp@atishpatra.org,
	tjeznach@rivosinc.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	sunilvl@ventanamicro.com,
	rafael.j.wysocki@intel.com,
	tglx@linutronix.de,
	ajones@ventanamicro.com
Cc: guoren@linux.alibaba.com,
	guoren@kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [RFC PATCH 3/6] RISC-V: KVM: Add a xarray to record host irq msg
Date: Mon, 11 Aug 2025 14:11:01 +0800
Message-Id: <20250811061104.10326-4-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250811061104.10326-1-fangyu.yu@linux.alibaba.com>
References: <20250811061104.10326-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

In the irq bypass scenario,the host interrupt comes from VFIO, and
it is an enabled MSI/MSI-X interrupt.  Due to the  reconfiguration
of the PCI-e BAR space during the irq bypass process,this host irq
will not be triggered in the host system.

We can use this host irq as a notice MSI in IOMMU MRIF mode.

Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
---
 arch/riscv/kvm/aia_imsic.c | 69 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index e91164742fd0..58807e68a3dd 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -60,6 +60,9 @@ struct imsic {
 	struct imsic_mrif *swfile;
 	phys_addr_t swfile_pa;
 	raw_spinlock_t swfile_extirq_lock;
+
+	bool mrif_support;
+	struct xarray hostirq_array;	/* Attached host irq array */
 };
 
 #define imsic_vs_csr_read(__c)			\
@@ -740,6 +743,57 @@ void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
 	kvm_riscv_aia_free_hgei(old_vsfile_cpu, old_vsfile_hgei);
 }
 
+static int kvm_arch_update_irqfd_unset(struct kvm *kvm, unsigned int host_irq)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long tmp;
+
+	kvm_for_each_vcpu(tmp, vcpu, kvm) {
+		struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
+		struct msi_msg *curr = xa_load(&imsic->hostirq_array, host_irq);
+
+		if (!curr)
+			continue;
+
+		xa_erase(&imsic->hostirq_array, host_irq);
+		kfree(curr);
+		break;
+	}
+
+	return irq_set_vcpu_affinity(host_irq, NULL);
+}
+
+static struct msi_msg *kvm_arch_update_irqfd_hostirq(struct imsic *imsic,
+						     unsigned int host_irq, int *ret,
+						     struct kvm_kernel_irq_routing_entry *e)
+{
+	struct msi_msg *priv_msg = xa_load(&imsic->hostirq_array, host_irq);
+
+	if (!priv_msg) {
+		priv_msg = kzalloc(sizeof(*priv_msg), GFP_KERNEL);
+		if (!priv_msg) {
+			*ret = -ENOMEM;
+			goto out;
+		}
+
+		struct msi_msg host_msg, *curr;
+
+		get_cached_msi_msg(host_irq, &host_msg);
+		priv_msg[0] = host_msg;
+		curr = xa_cmpxchg(&imsic->hostirq_array, host_irq,
+				NULL, priv_msg, GFP_ATOMIC);
+		if (WARN_ON_ONCE(curr)) {
+			*ret = xa_err(curr) ? : -EBUSY;
+			kfree(priv_msg);
+			goto out;
+		}
+	}
+	*ret = 0;
+
+out:
+	return priv_msg;
+}
+
 int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
 				  uint32_t guest_irq, bool set)
 {
@@ -750,7 +804,7 @@ int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
 	int idx, ret = -ENXIO;
 
 	if (!set)
-		return irq_set_vcpu_affinity(host_irq, NULL);
+		return kvm_arch_update_irqfd_unset(kvm, host_irq);
 
 	idx = srcu_read_lock(&kvm->irq_srcu);
 	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
@@ -795,6 +849,11 @@ int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
 
 			vcpu_info.msi_addr_pattern = tppn & ~vcpu_info.msi_addr_mask;
 			vcpu_info.gpa = target;
+			vcpu_info.host_irq = host_irq;
+			vcpu_info.host_msg =
+				    kvm_arch_update_irqfd_hostirq(imsic, host_irq, &ret, e);
+			if (ret)
+				goto out;
 
 			read_lock_irqsave(&imsic->vsfile_lock, flags);
 
@@ -848,6 +907,10 @@ static int kvm_riscv_vcpu_irq_update(struct kvm_vcpu *vcpu)
 		if (!irqfd->producer)
 			continue;
 		host_irq = irqfd->producer->irq;
+		vcpu_info.host_irq = host_irq;
+		vcpu_info.host_msg = xa_load(&imsic->hostirq_array, host_irq);
+		if (!vcpu_info.host_msg)
+			continue;
 
 		if (imsic->vsfile_cpu < 0) {
 			vcpu_info.hpa = imsic->swfile_pa;
@@ -855,6 +918,7 @@ static int kvm_riscv_vcpu_irq_update(struct kvm_vcpu *vcpu)
 		} else {
 			vcpu_info.mrif = false;
 		}
+
 		ret = irq_set_vcpu_affinity(host_irq, &vcpu_info);
 		if (ret) {
 			spin_unlock_irq(&kvm->irqfds.lock);
@@ -1195,6 +1259,9 @@ int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *vcpu)
 	imsic->swfile_pa = page_to_phys(swfile_page);
 	raw_spin_lock_init(&imsic->swfile_extirq_lock);
 
+	xa_init(&imsic->hostirq_array);
+	imsic->mrif_support = false;
+
 	/* Setup IO device */
 	kvm_iodevice_init(&imsic->iodev, &imsic_iodoev_ops);
 	mutex_lock(&kvm->slots_lock);
-- 
2.49.0


