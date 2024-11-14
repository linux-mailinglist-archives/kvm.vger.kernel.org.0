Return-Path: <kvm+bounces-31866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E7A69C8F9C
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:23:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D432B288E81
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E48C19597F;
	Thu, 14 Nov 2024 16:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="DZIjfuan"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF0419E982
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601148; cv=none; b=UYkBko5P9FUSwLZBMOO2YOxJWvc7ZZjduSc+bdZEyEhBWZ+wjRbpGKEoYbmBdb6TKZ6ERuUqDPFRvVWYJGX3BzRGvCHjK+P3SzlbmVYLWss/Tj/9oruEC2+Vb/OQ3LXP71P2ILdOdkhpCF3h3F16DOPzllM4m3LlbbVV1HD+PFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601148; c=relaxed/simple;
	bh=UESyK8Uc8qhnyUFE7sWCeUfzwrVwuw9Qm2LYqZNp+fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tk4cCE6KJKBvvCk3jrjNXccEERZF6NAtTMMRWyvUpy7FsciZpHg6YsLvbRmufeb//+5marDcssx8KcyfNPGIfNIJBwaiein21BdlJFmkNH7bRnf9IZqwJbVIMdiN3cOfuLvaCRuEp+2VfVddTf2GV3aW8e5KA2Mz/GU/xorPTV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=DZIjfuan; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-37d50fad249so606911f8f.1
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 08:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1731601145; x=1732205945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JmyAZwFmuLjn3p39hRK9ePQAJ1PSqwbQ6F/1nOHrEzM=;
        b=DZIjfuancE62FVd5pElzCWaDhWZzUbPRjpUcOwPOqX3NUfD2KqxBkWC0qie5IovXOt
         +oSnJDvYreXF7KKEaNIKY6qECF6rsme87Xqvq39u1k51nyLwODtS8Zjz1n+w+Oo0vXb4
         sWNV5sR7+f/HaCTksTzicGELUlkwxAD0yPsc9NHCpXYV5Jq4FSatznfSLaBhjYp+hwFR
         T/CJETXvKVjCwFikKNY9OyDOEtW5f9q978eTDWeIMMY4cTfKZ/1v+fdJ/1UAJQgf4HBn
         A+qRrBVNrYfLUJYRoYITLqP7Ijj5FzTLZvX0xzniGCSckHjSY/TObd/moVJL999r8QpQ
         a8Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731601145; x=1732205945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JmyAZwFmuLjn3p39hRK9ePQAJ1PSqwbQ6F/1nOHrEzM=;
        b=vCq1NsqJcikmfCZleIZEPCwTDT+8zQOHQLsL7d7HB8TneO/qoN19LMeuPsuNrNK0pg
         swNFBbRLOrcjJT83wwB8uhU0FwFGZ3RkXuyUtjTVNIf5eqT86RuN+LFC8ZmGD/ddbq+g
         bfbTywAzt+lt4jFZxJTl2gd5bjIWvaTbz5zZupOo9Ma8YQwV6ovFvojb44SUKkCVPOk+
         Sa+L4FedKoEYOI8sAK1YmXc0Htw2rPQFL2iuerbtfvDKYvWS6wEy4o3liiec4pachzaY
         mGyozYMpUezX89nxEqVtql6TTFYabazs5lXld4kxJWa0b80lfToK5inoM2GjfzlStKSp
         +mGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdF6W3ICoZqwW8w8Y7/hzVg9RRLV+qdV1CGT/o8Bwr37x9+EgIX3Og5QZd2f9xN8J18r8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBQZSo9QglNqbLxQSbByrVsfeExXzvv6lcEqrdRpdbuEvXPxxO
	iOEz4ZBMIteQ8doMFCn3EcgD0mATm+pwKXsDcdDVf8mskXNjkIgxodK/We8hHEs=
X-Google-Smtp-Source: AGHT+IEn3qlHsw/D0PT2IEwLbgj1uEV7tnlyKBH8z2H1adqlOAImJaC/GmimW4BKxNwCPjE/Y1igiA==
X-Received: by 2002:a05:6000:210e:b0:382:424:94fe with SMTP id ffacd0b85a97d-382042495edmr11613726f8f.36.1731601144686;
        Thu, 14 Nov 2024 08:19:04 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae161d8sm1901964f8f.78.2024.11.14.08.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:19:04 -0800 (PST)
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
Subject: [RFC PATCH 10/15] RISC-V: KVM: Add irqbypass skeleton
Date: Thu, 14 Nov 2024 17:18:55 +0100
Message-ID: <20241114161845.502027-27-ajones@ventanamicro.com>
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

Add all the functions needed to wire up irqbypass support.
kvm_arch_update_irqfd_routing() is left unimplemented, so return
false from kvm_arch_has_irq_bypass().

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h |  3 ++
 arch/riscv/kvm/Kconfig            |  1 +
 arch/riscv/kvm/aia_imsic.c        |  6 ++++
 arch/riscv/kvm/vm.c               | 60 +++++++++++++++++++++++++++++++
 4 files changed, 70 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 35eab6e0f4ae..fef7422939f6 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -114,6 +114,9 @@ struct kvm_arch {
 
 	/* AIA Guest/VM context */
 	struct kvm_aia aia;
+
+#define __KVM_HAVE_ARCH_ASSIGNED_DEVICE
+	atomic_t assigned_device_count;
 };
 
 struct kvm_cpu_trap {
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 333d95da8ebe..9a4feb1e671d 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -21,6 +21,7 @@ config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support (EXPERIMENTAL)"
 	depends on RISCV_SBI && MMU
 	select HAVE_KVM_IRQCHIP
+	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_MSI
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index a8085cd8215e..64b1f3713dd5 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -727,6 +727,12 @@ void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
 	kvm_riscv_aia_free_hgei(old_vsfile_cpu, old_vsfile_hgei);
 }
 
+int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
+				  uint32_t guest_irq, bool set)
+{
+	return -ENXIO;
+}
+
 int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 7396b8654f45..9c5837518c1a 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -11,6 +11,9 @@
 #include <linux/module.h>
 #include <linux/uaccess.h>
 #include <linux/kvm_host.h>
+#include <linux/kvm_irqfd.h>
+
+#include <asm/kvm_aia.h>
 
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS()
@@ -55,6 +58,63 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_riscv_aia_destroy_vm(kvm);
 }
 
+void kvm_arch_start_assignment(struct kvm *kvm)
+{
+	atomic_inc(&kvm->arch.assigned_device_count);
+}
+EXPORT_SYMBOL_GPL(kvm_arch_start_assignment);
+
+void kvm_arch_end_assignment(struct kvm *kvm)
+{
+	atomic_dec(&kvm->arch.assigned_device_count);
+}
+EXPORT_SYMBOL_GPL(kvm_arch_end_assignment);
+
+bool noinstr kvm_arch_has_assigned_device(struct kvm *kvm)
+{
+	return arch_atomic_read(&kvm->arch.assigned_device_count);
+}
+EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
+
+bool kvm_arch_has_irq_bypass(void)
+{
+	return false;
+}
+
+int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
+				     struct irq_bypass_producer *prod)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	int ret;
+
+	irqfd->producer = prod;
+	kvm_arch_start_assignment(irqfd->kvm);
+	ret = kvm_arch_update_irqfd_routing(irqfd->kvm, prod->irq, irqfd->gsi, true);
+	if (ret)
+		kvm_arch_end_assignment(irqfd->kvm);
+
+	return ret;
+}
+
+void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
+				      struct irq_bypass_producer *prod)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	int ret;
+
+	WARN_ON(irqfd->producer != prod);
+	irqfd->producer = NULL;
+
+	ret = kvm_arch_update_irqfd_routing(irqfd->kvm, prod->irq, irqfd->gsi, false);
+	if (ret)
+		pr_info("irq bypass consumer (token %p) unregistration fails: %d\n",
+			irqfd->consumer.token, ret);
+
+	kvm_arch_end_assignment(irqfd->kvm);
+}
+
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irql,
 			  bool line_status)
 {
-- 
2.47.0


