Return-Path: <kvm+bounces-61530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A17BC2221B
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:10:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D1C41887AA4
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC14374AC9;
	Thu, 30 Oct 2025 20:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bYKjgnh1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD1D36E37C
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 20:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855003; cv=none; b=m/qjWpZngo88GJ84stVB8+Zi7y8H17uC7vAyFyrk+vGHMC2MbjHk2VoBsW2OlSWTcRTWYgwMXRKDHtO4MGazD09sWtwG5xKwXv0QfgCx5IiD811559Bxm628nVmASKQZTEiNC7UDVvqBNgxXFxlxOQfkxwzb8FTfPd8SmqnIfxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855003; c=relaxed/simple;
	bh=GwQR3WqNM/N4V33I9/zWw/yrZtqHSbqQBGNXQvrrL5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KJOVSqP4E4YOnAE77MVkGm8LNzAjDj8HNAmgExotcLFioX/CROEf7bG8cknGwXLcI9+MFiYQSE7G1bClMfNh9Z88pwXCtosaEUymw6tkDTQ0Pzx1p0VDkh0u6q82HC7a2xG+5QAhhDrcW74YW0TwJt7vGJft6qcROfO6ZK+TG0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bYKjgnh1; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3408686190eso460172a91.3
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 13:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855002; x=1762459802; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vdmNuA/XJs18gaKKFpEA0E3nq9J2Wf2NR2DLPMRdiiE=;
        b=bYKjgnh1Vh/jEn22JEbUAmJst/MSEMzOB5OLqAK8X0lsqpyPLP2gCEYHNdf+G7Y8ge
         fIgUTJ4o2Z4eTJNa3bOx+CsWjqM8CrPNEYIdAuuWVF6iTkKzBpND+B9MAf4FawrRpscN
         X/5pMjE7fzmO0oq+z6c3nowf9qQyMr+G6INdHltqmszTWZFD0BURYaxvE1Z6dEkCGdhw
         NGeAMiTQS4WTRDkChFjYwITJSZUK2o0hgp6XSuB5c4rBjiFlOrU8kqqtLpmJuR2YQ7Xo
         Pt5Frprq+rlSFNStnCh4ESRMFN/QIFxxAsEYJh4S4Tml3blfkNP8BgO7E5AngZxZ6A3k
         9RhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855002; x=1762459802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vdmNuA/XJs18gaKKFpEA0E3nq9J2Wf2NR2DLPMRdiiE=;
        b=acgety4Ft3UGE5ROoCFicaN4bAsAdOUif6PHapSpia1+fPaavjQRM7oXqK51nVvkM7
         3BP8bsdFps79TvYQCBY8zdsMrH8SfzAbp8/fMSxenYyas8cetj/sJmDfbfpf9B/7/ca/
         oEIwsbtNtfjJpYFZA32KXwW76Y7ZThTc0aharZXcJskQwJqbhw3z5pq0aXpGnjNCkHMa
         vOvrI4YnL/nXEG043CCO9EPuazqWzEEbadVkarRlxWQVM5waXwqy86t4gsmJ28XfAf7L
         4ABGp0R2HEFwrRUXNPOQw/ie1Ds0gc6st95nY7m2l78PdqwFcf4M0gDMsiLnaPspMLnK
         i/Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXt0v+dD8XcSWtW44abcqpNr7gOEcezVPT8y6+Ms8iuwrkokAnOdiWYlAKO27rpQFjUMkY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqtYOqsn+j8PlV5DZcpFr8kOPX1KIcF/ZZ8JLer9/G/Nm63y8a
	NuvvbsN9wOYQEbuhY6IJkef0iV3PtH0/X3Mq4SJiW1VkBcP1VoEv7Ana/1e9qDPcPrubBhnAEm2
	/NtgduQ==
X-Google-Smtp-Source: AGHT+IHCp67ng7EPL926/aDQ0svpDIsDoj6OeGfyMpf/ofykocac96hQIKqfmRloHmNuNLaZynEjzDSP6Us=
X-Received: from pjvm17.prod.google.com ([2002:a17:90a:de11:b0:33d:79bb:9fd5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b92:b0:334:2a38:2a05
 with SMTP id 98e67ed59e1d1-34082fc64a4mr1360357a91.8.1761855001643; Thu, 30
 Oct 2025 13:10:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:24 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-2-seanjc@google.com>
Subject: [PATCH v4 01/28] KVM: Make support for kvm_arch_vcpu_async_ioctl() mandatory
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Implement kvm_arch_vcpu_async_ioctl() "natively" in x86 and arm64 instead
of relying on an #ifdef'd stub, and drop HAVE_KVM_VCPU_ASYNC_IOCTL in
anticipation of using the API on x86.  Once x86 uses the API, providing a
stub for one architecture and having all other architectures opt-in
requires more code than simply implementing the API in the lone holdout.

Eliminating the Kconfig will also reduce churn if the API is renamed in
the future (spoiler alert).

No functional change intended.

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c       |  6 ++++++
 arch/loongarch/kvm/Kconfig |  1 -
 arch/mips/kvm/Kconfig      |  1 -
 arch/powerpc/kvm/Kconfig   |  1 -
 arch/riscv/kvm/Kconfig     |  1 -
 arch/s390/kvm/Kconfig      |  1 -
 arch/x86/kvm/x86.c         |  6 ++++++
 include/linux/kvm_host.h   | 10 ----------
 virt/kvm/Kconfig           |  3 ---
 9 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 870953b4a8a7..ef5bf57f79b7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1835,6 +1835,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	return r;
 }
 
+long kvm_arch_vcpu_async_ioctl(struct file *filp, unsigned int ioctl,
+			       unsigned long arg)
+{
+	return -ENOIOCTLCMD;
+}
+
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
index ae64bbdf83a7..ed4f724db774 100644
--- a/arch/loongarch/kvm/Kconfig
+++ b/arch/loongarch/kvm/Kconfig
@@ -25,7 +25,6 @@ config KVM
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_MSI
 	select HAVE_KVM_READONLY_MEM
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index ab57221fa4dd..cc13cc35f208 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	select EXPORT_UASM
 	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_MMIO
 	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_GENERIC_HARDWARE_ENABLING
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 2f2702c867f7..c9a2d50ff1b0 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -20,7 +20,6 @@ if VIRTUALIZATION
 config KVM
 	bool
 	select KVM_COMMON
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_VFIO
 	select HAVE_KVM_IRQ_BYPASS
 
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index c50328212917..77379f77840a 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -23,7 +23,6 @@ config KVM
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_MSI
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select HAVE_KVM_READONLY_MEM
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select KVM_COMMON
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index cae908d64550..96d16028e8b7 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -20,7 +20,6 @@ config KVM
 	def_tristate y
 	prompt "Kernel-based Virtual Machine (KVM) support"
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_ASYNC_PF
 	select KVM_ASYNC_PF_SYNC
 	select KVM_COMMON
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4b5d2d09634..ca5ba2caf314 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7240,6 +7240,12 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 	return 0;
 }
 
+long kvm_arch_vcpu_async_ioctl(struct file *filp, unsigned int ioctl,
+			       unsigned long arg)
+{
+	return -ENOIOCTLCMD;
+}
+
 int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5bd76cf394fa..7186b2ae4b57 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2437,18 +2437,8 @@ static inline bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_HAVE_KVM_NO_POLL */
 
-#ifdef CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL
 long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			       unsigned int ioctl, unsigned long arg);
-#else
-static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
-					     unsigned int ioctl,
-					     unsigned long arg)
-{
-	return -ENOIOCTLCMD;
-}
-#endif /* CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL */
-
 void kvm_arch_guest_memory_reclaimed(struct kvm *kvm);
 
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 5f0015c5dd95..267c7369c765 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -78,9 +78,6 @@ config HAVE_KVM_IRQ_BYPASS
        tristate
        select IRQ_BYPASS_MANAGER
 
-config HAVE_KVM_VCPU_ASYNC_IOCTL
-       bool
-
 config HAVE_KVM_VCPU_RUN_PID_CHANGE
        bool
 
-- 
2.51.1.930.gacf6e81ea2-goog


