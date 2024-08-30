Return-Path: <kvm+bounces-25443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D857965667
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 06:37:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36A8E284FEF
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 04:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A901537D0;
	Fri, 30 Aug 2024 04:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JOyRlJYP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DB61531C1
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 04:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724992575; cv=none; b=TtcaKL0/9keFjV4cSKjulMa+79g410HwfgK+xSpruolYm5gbieVu6C7X24MwBFWbSBLxrxLNa+kWrGIMkKJOFbQciKKrlKh3ImoZBlbngAQt8kKYygS5BUn9laCv52rsDMb358zoYn73Kv3+GZoz2w3u8pUyaqsP9Pbhsb38azg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724992575; c=relaxed/simple;
	bh=Ay9SwyBhQKf/bJhFYzZ+fphWlTDNZl+aCWQe7lQ9kpE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S0XHnqRz8lEAFMN4DLma4wLVPzFIDos5GkGNLQ4W0FwjfQX78GpAh0Ky7RR9NWjh7f6CCy4A27zu0mxCAv3hZ06JLK9u7dfU6r/9PUUsInL4JlMPN1Sv9iv+S3e6foUpsgKR0itAIMkzhJQLd0BuuKmsV1SRsONVctU8fNgXe0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JOyRlJYP; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e11796af1d0so1983770276.3
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 21:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724992572; x=1725597372; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4AvpSvtVzfUJU2EyYm3Go6nn4YoocTvqWptP53nqH8c=;
        b=JOyRlJYPVWPz/tmu9O5dlRE2ubWr7MlsdMyAViEEnB5joXrvgXr/IxphE/IEupeVl/
         OXsAHA3u+U9z2VoDbXETV03ZnyBj0dGuqLEqR5Dq+0vGvi9IBiy0L7ahehZjDx0bZLSG
         ZtpR6KsAdXUhaQlputuROUDp+uTOnqiv6nD847havE/vza7GenJwBqXM9akx4WWILDAJ
         FKEpSDepnFCVngqO6xpfgjQOl+qxRi8ev8LiBf8ggVqdg7HcyPBhrsxngep2tWRohcgb
         /QCpA71zwQVW12gO0amRVODOLGd6T8rVKXk17vmuimVh4b3wllf1qxMUeXCWx49ukZUt
         8xfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724992572; x=1725597372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4AvpSvtVzfUJU2EyYm3Go6nn4YoocTvqWptP53nqH8c=;
        b=j/5G48zs67Dc25hO7ko905cHOb3oVJb1K4Hu+lLMoxMpjdeJ4EL8BNw49RG17/8y5D
         8ClgdC807cYHVpVIF6u0S8AHSeaSm9+d97JavOm2tPDh4lyxx8OQaGXCc0QZx+hDgimi
         eYu7X+HQRyBz85mnN2VC9j5agoBgCqyfEjms0iC3hwcNMX2LtWy1+pEF5bRRog4Yrfwy
         NiqETBPWOi0t/us4y/iYNR2CH6v+3eciUFn25kHlfKVERtX4O9r4hXtGwQcx4jocN7l6
         kimDW5VJy1LVlgLK5KiFKdxpYL9WpyACVHnKz2BpKUiv/S3NsLSndWC1bAOm+DmnBYhs
         nyuw==
X-Gm-Message-State: AOJu0Yz5kvHJwcwr3/fApOGPPd5reR7LzU94GDfSu+5ryUA2YdAGzMjI
	mDYQFkP7hR5/7ApKW1hKJ2L3htoLltz2b82qB7bj7NTFDWA+Ak23IDrKydYT3xoREEaPofUE9Ds
	JbA==
X-Google-Smtp-Source: AGHT+IEqi40cTWXbweDgNMrKLwg/O/OjOvSbekL8sfwlxBmHg+Y/0Rt/XOEiqVKMWjM4o4ZWNOIk2YltGh0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:18d:0:b0:e11:6fcc:b656 with SMTP id
 3f1490d57ef6-e1a7a197ademr2073276.6.1724992572547; Thu, 29 Aug 2024 21:36:12
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Aug 2024 21:35:54 -0700
In-Reply-To: <20240830043600.127750-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240830043600.127750-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240830043600.127750-5-seanjc@google.com>
Subject: [PATCH v4 04/10] KVM: Rename arch hooks related to per-CPU
 virtualization enabling
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Farrah Chen <farrah.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename the per-CPU hooks used to enable virtualization in hardware to
align with the KVM-wide helpers in kvm_main.c, and to better capture that
the callbacks are invoked on every online CPU.

No functional change intended.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c      | 6 +++---
 arch/loongarch/kvm/main.c | 4 ++--
 arch/mips/kvm/mips.c      | 4 ++--
 arch/riscv/kvm/main.c     | 4 ++--
 arch/x86/kvm/x86.c        | 6 +++---
 include/linux/kvm_host.h  | 4 ++--
 virt/kvm/kvm_main.c       | 4 ++--
 7 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9bef7638342e..9c8f5390ec63 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2163,7 +2163,7 @@ static void cpu_hyp_uninit(void *discard)
 	}
 }
 
-int kvm_arch_hardware_enable(void)
+int kvm_arch_enable_virtualization_cpu(void)
 {
 	/*
 	 * Most calls to this function are made with migration
@@ -2183,7 +2183,7 @@ int kvm_arch_hardware_enable(void)
 	return 0;
 }
 
-void kvm_arch_hardware_disable(void)
+void kvm_arch_disable_virtualization_cpu(void)
 {
 	kvm_timer_cpu_down();
 	kvm_vgic_cpu_down();
@@ -2379,7 +2379,7 @@ static int __init do_pkvm_init(u32 hyp_va_bits)
 
 	/*
 	 * The stub hypercalls are now disabled, so set our local flag to
-	 * prevent a later re-init attempt in kvm_arch_hardware_enable().
+	 * prevent a later re-init attempt in kvm_arch_enable_virtualization_cpu().
 	 */
 	__this_cpu_write(kvm_hyp_initialized, 1);
 	preempt_enable();
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 844736b99d38..27e9b94c0a0b 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -261,7 +261,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	return -ENOIOCTLCMD;
 }
 
-int kvm_arch_hardware_enable(void)
+int kvm_arch_enable_virtualization_cpu(void)
 {
 	unsigned long env, gcfg = 0;
 
@@ -300,7 +300,7 @@ int kvm_arch_hardware_enable(void)
 	return 0;
 }
 
-void kvm_arch_hardware_disable(void)
+void kvm_arch_disable_virtualization_cpu(void)
 {
 	write_csr_gcfg(0);
 	write_csr_gstat(0);
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index b5de770b092e..52e1f275351e 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -125,12 +125,12 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-int kvm_arch_hardware_enable(void)
+int kvm_arch_enable_virtualization_cpu(void)
 {
 	return kvm_mips_callbacks->hardware_enable();
 }
 
-void kvm_arch_hardware_disable(void)
+void kvm_arch_disable_virtualization_cpu(void)
 {
 	kvm_mips_callbacks->hardware_disable();
 }
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index bab2ec34cd87..f3427f6de608 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -20,7 +20,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	return -EINVAL;
 }
 
-int kvm_arch_hardware_enable(void)
+int kvm_arch_enable_virtualization_cpu(void)
 {
 	csr_write(CSR_HEDELEG, KVM_HEDELEG_DEFAULT);
 	csr_write(CSR_HIDELEG, KVM_HIDELEG_DEFAULT);
@@ -35,7 +35,7 @@ int kvm_arch_hardware_enable(void)
 	return 0;
 }
 
-void kvm_arch_hardware_disable(void)
+void kvm_arch_disable_virtualization_cpu(void)
 {
 	kvm_riscv_aia_disable();
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 70219e406987..1182baf0d487 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -355,7 +355,7 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
 
 	/*
 	 * Disabling irqs at this point since the following code could be
-	 * interrupted and executed through kvm_arch_hardware_disable()
+	 * interrupted and executed through kvm_arch_disable_virtualization_cpu()
 	 */
 	local_irq_save(flags);
 	if (msrs->registered) {
@@ -12512,7 +12512,7 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
-int kvm_arch_hardware_enable(void)
+int kvm_arch_enable_virtualization_cpu(void)
 {
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
@@ -12608,7 +12608,7 @@ int kvm_arch_hardware_enable(void)
 	return 0;
 }
 
-void kvm_arch_hardware_disable(void)
+void kvm_arch_disable_virtualization_cpu(void)
 {
 	kvm_x86_call(hardware_disable)();
 	drop_user_return_notifiers();
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 79a6b1a63027..63e46a5f3812 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1514,8 +1514,8 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
-int kvm_arch_hardware_enable(void);
-void kvm_arch_hardware_disable(void);
+int kvm_arch_enable_virtualization_cpu(void);
+void kvm_arch_disable_virtualization_cpu(void);
 #endif
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fbdd2e46e65b..b000f221abfb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5584,7 +5584,7 @@ static int kvm_enable_virtualization_cpu(void)
 	if (__this_cpu_read(virtualization_enabled))
 		return 0;
 
-	if (kvm_arch_hardware_enable()) {
+	if (kvm_arch_enable_virtualization_cpu()) {
 		pr_info("kvm: enabling virtualization on CPU%d failed\n",
 			raw_smp_processor_id());
 		return -EIO;
@@ -5609,7 +5609,7 @@ static void kvm_disable_virtualization_cpu(void *ign)
 	if (!__this_cpu_read(virtualization_enabled))
 		return;
 
-	kvm_arch_hardware_disable();
+	kvm_arch_disable_virtualization_cpu();
 
 	__this_cpu_write(virtualization_enabled, false);
 }
-- 
2.46.0.469.g59c65b2a67-goog


