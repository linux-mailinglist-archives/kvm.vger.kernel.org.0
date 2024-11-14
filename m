Return-Path: <kvm+bounces-31869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0881E9C9004
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:43:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3077B3CCDB
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7462D1AE00E;
	Thu, 14 Nov 2024 16:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="SC7VkfU8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC3C1ABEA5
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601153; cv=none; b=I1FHPgEuNhpbKOWq8Yqrvubt/6OribeOeiHoPyONwanY6d73hMzZLRXhZmzYfUohv+Y/tDJfCQkci/QanUuYpLX707raOl6uqAhamKF1Gu34VRvQMAFYzNTfLXtLyUtxHznDrMABFZgZMGUudGPur30v/vq4g9Ictp0ew/uMC2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601153; c=relaxed/simple;
	bh=u/8uTbD/TLPDkTbsVh/aqh2UnYJ2kwaG/0urCXnRHYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRrgz1MIROxws9YmEmu3v4NNLkTqGTpt8bPFq0iiOOM1wi4Rw+5SRrFXurHdLyQTSh1VKFtCbxpMCxpWoGQxYDneNG7FvALuywB5UE+DD0lRXDT4akS73PaYKDDOwxrf1mQUNfa4guGo4ehWvV5nGGsBx2mQOSHySBvoFnX0INs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=SC7VkfU8; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-431481433bdso7140915e9.3
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 08:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1731601149; x=1732205949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFFBRicSLcryUXTcW4czNg2bW4hUi+sNV0Va2EAONJ0=;
        b=SC7VkfU8iCwbc2eSLPG+OBq+8zDTAbBnyQFRomHLnoBBL8w5k/cunsMQcnUg8y4i1B
         YQk2Cv/U3Oz+LSb2FqutN2bPvz/0jDC9oMA+s+VGrBjq+0fkqx/cd7mle9RylTbXPjCf
         Om8zoFn8V8o7zApeEkK11GrI45GNxJM+Xrw02JuJeIu/J2Ce9EZahrKRKDE/9rvm8CAg
         Aa0yQm5LNVPom/5ZSC5vX1IHp51INaBrhBCGGuOX6rWz+cMGptD4MIG2rPSj1lfI+ULX
         NKm9PflpQJMQCI+PhnvQ9SfUQYXKQdOcmrKZ7yxzZ10RcFovtR9zJf+dWn+bc9Ua3ECJ
         EtrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731601149; x=1732205949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pFFBRicSLcryUXTcW4czNg2bW4hUi+sNV0Va2EAONJ0=;
        b=ZVDnAwylqJeI4mcoPYPHTsct+HeKkVy7T40puh0g/5FHrvw+YyHTi/4iXKry4tu3w6
         56g/Eyw8KNnOsmnX08hS5DZl/8wwnY9/IOCNSQq4y3rA0062cXcQduNAGuMsH7wOQUbS
         Sc6an6dQZ6EakQ9UKsxvqoR01M8D/8mN0TNqVbzEe0+l0mCkGK/wv86PmZfe2QBZm6xq
         E0ANNxW/9EyI9V/qzUH2FpHEOxLqzj3b+2YmHPN2qdhAsx9egVq5FUFPWTZpHFhoVD//
         6ocW0IJIVZy0ZTJTt7ruGmzrc6y+0OOKIVAFgc5sHuRs/8sDMwgdG6CQLKOjTEF+ezem
         sISA==
X-Forwarded-Encrypted: i=1; AJvYcCUuoSVxwg2f9qp0tZmbTYllkUxpf2S9GY4QrAe/V6T1zYGk6HDshA5L5S2NztI4vbJtqxY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx1CUDstwtnOmQU8x72v97hEC5hLuOBEuSAMHW+4Y/B5TzVITL
	3gl1oSPXJa/r4CVMo64CDpfNxEXQtEWTTFcQ7fRxZSq/JgZCmPbVhWaHJs8xM7U=
X-Google-Smtp-Source: AGHT+IFGPNdzokCF0Smmz2HXrxBVONdHjbl61VaRzcWcWTFU5SBB8vXJqki1qLp7dZUHNDK1wlI75g==
X-Received: by 2002:a05:600c:a48:b0:431:5f1c:8359 with SMTP id 5b1f17b1804b1-432d4ab9134mr73117815e9.15.1731601149016;
        Thu, 14 Nov 2024 08:19:09 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da28b76fsm29185835e9.28.2024.11.14.08.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:19:08 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: tjeznach@rivosinc.com,
	zong.li@sifive.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	tglx@linutronix.de,
	alex.williamson@redhat.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Subject: [RFC PATCH 13/15] RISC-V: KVM: Add guest file irqbypass support
Date: Thu, 14 Nov 2024 17:18:58 +0100
Message-ID: <20241114161845.502027-30-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114161845.502027-17-ajones@ventanamicro.com>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement kvm_arch_update_irqfd_routing() which makes
irq_set_vcpu_affinity() calls whenever the assigned device updates
its target addresses and whenever the hypervisor has migrated a
VCPU to another CPU (which requires changing the guest interrupt
file).

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/aia_imsic.c | 132 ++++++++++++++++++++++++++++++++++++-
 arch/riscv/kvm/vm.c        |   2 +-
 2 files changed, 130 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 64b1f3713dd5..6a7c23e25f79 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -11,11 +11,13 @@
 #include <linux/bitmap.h>
 #include <linux/irqchip/riscv-imsic.h>
 #include <linux/kvm_host.h>
+#include <linux/kvm_irqfd.h>
 #include <linux/math.h>
 #include <linux/spinlock.h>
 #include <linux/swab.h>
 #include <kvm/iodev.h>
 #include <asm/csr.h>
+#include <asm/irq.h>
 
 #define IMSIC_MAX_EIX	(IMSIC_MAX_ID / BITS_PER_TYPE(u64))
 
@@ -676,6 +678,14 @@ static void imsic_swfile_update(struct kvm_vcpu *vcpu,
 	imsic_swfile_extirq_update(vcpu);
 }
 
+static u64 kvm_riscv_aia_msi_addr_mask(struct kvm_aia *aia)
+{
+	u64 group_mask = BIT(aia->nr_group_bits) - 1;
+
+	return (group_mask << (aia->nr_group_shift - IMSIC_MMIO_PAGE_SHIFT)) |
+	       (BIT(aia->nr_hart_bits + aia->nr_guest_bits) - 1);
+}
+
 void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
@@ -730,7 +740,120 @@ void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
 int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
 				  uint32_t guest_irq, bool set)
 {
-	return -ENXIO;
+	struct irq_data *irqdata = irq_get_irq_data(host_irq);
+	struct kvm_irq_routing_table *irq_rt;
+	struct kvm_vcpu *vcpu;
+	unsigned long tmp, flags;
+	int idx, ret = -ENXIO;
+
+	if (!set)
+		return irq_set_vcpu_affinity(host_irq, NULL);
+
+	idx = srcu_read_lock(&kvm->irq_srcu);
+	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
+	if (guest_irq >= irq_rt->nr_rt_entries ||
+	    hlist_empty(&irq_rt->map[guest_irq])) {
+		pr_warn_once("no route for guest_irq %u/%u (broken user space?)\n",
+			     guest_irq, irq_rt->nr_rt_entries);
+		goto out;
+	}
+
+	kvm_for_each_vcpu(tmp, vcpu, kvm) {
+		struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
+		gpa_t ippn = vcpu->arch.aia_context.imsic_addr >> IMSIC_MMIO_PAGE_SHIFT;
+		struct kvm_aia *aia = &kvm->arch.aia;
+		struct kvm_kernel_irq_routing_entry *e;
+
+		hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
+			struct msi_msg msg[2] = {
+			{
+				.address_hi = e->msi.address_hi,
+				.address_lo = e->msi.address_lo,
+				.data = e->msi.data,
+			},
+			};
+			struct riscv_iommu_vcpu_info vcpu_info = {
+				.msi_addr_mask = kvm_riscv_aia_msi_addr_mask(aia),
+				.group_index_bits = aia->nr_group_bits,
+				.group_index_shift = aia->nr_group_shift,
+			};
+			gpa_t target, tppn;
+
+			if (e->type != KVM_IRQ_ROUTING_MSI)
+				continue;
+
+			target = ((gpa_t)e->msi.address_hi << 32) | e->msi.address_lo;
+			tppn = target >> IMSIC_MMIO_PAGE_SHIFT;
+
+			WARN_ON(target & (IMSIC_MMIO_PAGE_SZ - 1));
+
+			if (ippn != tppn)
+				continue;
+
+			vcpu_info.msi_addr_pattern = tppn & ~vcpu_info.msi_addr_mask;
+			vcpu_info.gpa = target;
+
+			read_lock_irqsave(&imsic->vsfile_lock, flags);
+
+			if (WARN_ON_ONCE(imsic->vsfile_cpu < 0)) {
+				read_unlock_irqrestore(&imsic->vsfile_lock, flags);
+				goto out;
+			}
+
+			vcpu_info.hpa = imsic->vsfile_pa;
+
+			ret = irq_set_vcpu_affinity(host_irq, &vcpu_info);
+			if (ret) {
+				read_unlock_irqrestore(&imsic->vsfile_lock, flags);
+				goto out;
+			}
+
+			irq_data_get_irq_chip(irqdata)->irq_write_msi_msg(irqdata, msg);
+
+			read_unlock_irqrestore(&imsic->vsfile_lock, flags);
+		}
+	}
+
+	ret = 0;
+out:
+	srcu_read_unlock(&kvm->irq_srcu, idx);
+	return ret;
+}
+
+static int kvm_riscv_vcpu_irq_update(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
+	struct kvm_aia *aia = &kvm->arch.aia;
+	u64 mask = kvm_riscv_aia_msi_addr_mask(aia);
+	u64 target = vcpu->arch.aia_context.imsic_addr;
+	struct riscv_iommu_vcpu_info vcpu_info = {
+		.msi_addr_pattern = (target >> IMSIC_MMIO_PAGE_SHIFT) & ~mask,
+		.msi_addr_mask = mask,
+		.group_index_bits = aia->nr_group_bits,
+		.group_index_shift = aia->nr_group_shift,
+		.gpa = target,
+		.hpa = imsic->vsfile_pa,
+	};
+	struct kvm_kernel_irqfd *irqfd;
+	int host_irq, ret;
+
+	spin_lock_irq(&kvm->irqfds.lock);
+
+	list_for_each_entry(irqfd, &kvm->irqfds.items, list) {
+		if (!irqfd->producer)
+			continue;
+		host_irq = irqfd->producer->irq;
+		ret = irq_set_vcpu_affinity(host_irq, &vcpu_info);
+		if (ret) {
+			spin_unlock_irq(&kvm->irqfds.lock);
+			return ret;
+		}
+	}
+
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+	return 0;
 }
 
 int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
@@ -797,14 +920,17 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
 	if (ret)
 		goto fail_free_vsfile_hgei;
 
-	/* TODO: Update the IOMMU mapping ??? */
-
 	/* Update new IMSIC VS-file details in IMSIC context */
 	write_lock_irqsave(&imsic->vsfile_lock, flags);
+
 	imsic->vsfile_hgei = new_vsfile_hgei;
 	imsic->vsfile_cpu = vcpu->cpu;
 	imsic->vsfile_va = new_vsfile_va;
 	imsic->vsfile_pa = new_vsfile_pa;
+
+	/* Update the IOMMU mapping */
+	kvm_riscv_vcpu_irq_update(vcpu);
+
 	write_unlock_irqrestore(&imsic->vsfile_lock, flags);
 
 	/*
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 9c5837518c1a..5f697d9a37da 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -78,7 +78,7 @@ EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
 
 bool kvm_arch_has_irq_bypass(void)
 {
-	return false;
+	return true;
 }
 
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
-- 
2.47.0


