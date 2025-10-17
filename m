Return-Path: <kvm+bounces-60243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 95089BE5E6A
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 02:33:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0B70F346979
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 00:33:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C05521FF4C;
	Fri, 17 Oct 2025 00:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CB1L57Zq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC61B209F5A
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 00:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661172; cv=none; b=i7gTi8bV47psfC+68bu0ldLNIz7ZxY1PVYzLJ+geyqG/oh5YOP/dBfuCGwe+Gm4sfNVYdh0GZVpIbJe8J+89ss9Q8UIMPDDZPwSf1viNjaXLwPLQzhThUMnGTyyvmCAgOolMro2rr5WFAIyoNYHNvObCLxQPAp+SbTw9AHl78Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661172; c=relaxed/simple;
	bh=yTxeKi5ytBqSGu+K0Aiq0a5C1Z+QgeX31iG3pFbDjT8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R1kZ0xQdg8STCwQIuoiB7KacJaz8enNLf4drKRs56ZzWRX69ppVVlb1mER8QIhJUjP1NGirOF6MxYUb2GrwSa60bd6BBSfw422DQQKtOgnq3TPYuGok8oM9ZKhTXbkEYRBpBBEbb1I3O3LlZbmtMohwc0pdj//NMw5edl7Q6JR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CB1L57Zq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bcb779733so615728a91.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661170; x=1761265970; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLjI+VHvWwq1NOed3zBHwZiL3R2UZSybOuIS4LQq3Jk=;
        b=CB1L57ZquaYl4KXQN3zJ9b1sxYAobCnU/4SwIG4P8kOr8y047n4gj9NLZeS3l032Gj
         WCGo/HyjzW/3FcD6PXLtzO85/Ms6ShfWN2VKqro37Rw2igFXptf58hlCH66dU566PPDa
         pnTLfhEr42qw3kz9sok77Axzo35exHQK1oiN6cU9v8TFZou6NecfHXTduvDdOnymx+P9
         r/xWwHySLO3WowSk4UUpfYJljm83shK4pUhMKq/nP1FBZH2QDfefsEMLnU2sQ8bbGtCX
         8tuW3mmMd10VZirLLaGfl7eEKtEcBSG8SWMBHGMU7KIJcFELliZIhRIIKWWLPG4CgJlm
         oZ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661170; x=1761265970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZLjI+VHvWwq1NOed3zBHwZiL3R2UZSybOuIS4LQq3Jk=;
        b=A2bbVAeMZKnAgIBwE9GIBkxgxmIlqPBgiOlIm5+UqTu+SeVylo5z822YsGALV4QkIm
         odoE0vQX9uqk6f5pUHqzjWxWXuYITiicVFmOyLjJsHnXpD1olqyMF+oRjW6Jpz/q/GtU
         6BSp+1O+LPRleIXCIwwtQXHqK3JlTnqOu4gV2zaaIDfb6421rBIwlGc8vc2ZjoENmO02
         ahh9XHGEZUON/8KXbFFveEfWaG9bRFo97tfJkuyEq+e+Wzl1Hy9qTNT6gBMT2dU3Crll
         ZxEBRr3NxVnpNqfC/EPNCOhemNxzEXAWgshL7jUmREOUvcdPVrK57rMQWWE3jJqYRcN/
         9YNw==
X-Forwarded-Encrypted: i=1; AJvYcCXvD4nTGVZaZgeT8Ol4px6cfX429OAmLQHWQiAhJbeusQSrhh4P7jhSTWvAVPx/xXdNAZg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVeFK3uxbEdQbpMPnQG53zzUNg0EkNBMwdPNCIrvlZExUVHh0K
	ZcwznRI71FVxgh6Pfp1gsj02K+maKvD9VwZSkNkgBEpkkKYQNCgVh8mnD2tIqttmWViG+qpxTxp
	yHiSh6w==
X-Google-Smtp-Source: AGHT+IHzipqFwGOQM14+hMbE6MDd7f/rMR4PzXuvuqV/70HQDUX00eM7uGkCf4DwDHKPsPDEwqW7PjFGoNU=
X-Received: from pjbse5.prod.google.com ([2002:a17:90b:5185:b0:33b:51fe:1a88])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ccd:b0:327:734a:ae7a
 with SMTP id 98e67ed59e1d1-33bcf87ac05mr2025384a91.11.1760661170081; Thu, 16
 Oct 2025 17:32:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:19 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-2-seanjc@google.com>
Subject: [PATCH v3 01/25] KVM: Make support for kvm_arch_vcpu_async_ioctl() mandatory
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
	Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Implement kvm_arch_vcpu_async_ioctl() "natively" in x86 and arm64 instead
of relying on an #ifdef'd stub, and drop HAVE_KVM_VCPU_ASYNC_IOCTL in
anticipation of using the API on x86.  Once x86 uses the API, providing a
stub for one architecture and having all other architectures opt-in
requires more code than simply implementing the API in the lone holdout.

Eliminating the Kconfig will also reduce churn if the API is renamed in
the future (spoiler alert).

No functional change intended.

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
index f21d1b7f20f8..785aaaee6a5d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1828,6 +1828,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
2.51.0.858.gf9c4a03a3a-goog


