Return-Path: <kvm+bounces-19105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CEE56900EAA
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 02:07:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD7561C21ABB
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 00:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C991EE57E;
	Sat,  8 Jun 2024 00:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XN9w915w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C776125
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 00:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717805210; cv=none; b=b/SS8pmYTNCHzrYHRZ8XKXwY+7tzcq/bZnbsT59kSUguXPEJXNvTmSMmXnGhlKG9DsqzwFgYqHPdtE3/7izsohB93ZJS2AQrbMg86onXuJmbOQipJSdUeN5m6vR4EUp38gN4/WaAbx3rxqlVTYSGXDcSB5lx8ZvgXqU0PRSYTHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717805210; c=relaxed/simple;
	bh=/RdPxhM/6HHEDqv6agcyx/TVxEplMU6sNYeT51ttpZo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ho/tOvI4mq7DhXnl1Kk7NTTPFF70nLj0x4DOwvH0/lSeEKwfvny4pVBh5hZ6es4vAKftER3Gen2wZSyOBRClO2WcSGGHe/K1c+IpnSBmrU5hpH3j05Nn6AOew1CfF3YHQliAKBpMe2ATJbEBh0bmLXI0dk3FNDnG2ZMydJE2REA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XN9w915w; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6c8f99fef10so2451608a12.3
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 17:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717805208; x=1718410008; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6oG2p3ebAbUpQGVelwukytqESKts/k/4HZBdB34fsng=;
        b=XN9w915wTqmJxdAJuxOU5fYBHAZax4NN4UM5MbF4XPV9bM6ZLVN6FIFi6CnRAB3pH5
         K43mDknMSeIhi9n4Ip7vTad1YOhRDj0wWXkuAoI+UiRWML/5k9r6LwGSSkHVRsCQ6AiP
         OcX08mykLh9sZzbizs1yvGvZv84WXLhMQQlpmDev5BjcHmkDS+tknAcjxqiz4ZM+/GHC
         hAbWxX28+a8YdU3ASeXaqvIzsF/xFcUlZPgJGLQVhEd+oxQcF0T40gqxfGO0rTA09SdD
         89LVFiLod3R9M/qadwWXczNfCTxc1QuJCyVB89MG2G2b90EV+BfVVwwUt5h9u9GsfYro
         HKag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717805208; x=1718410008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6oG2p3ebAbUpQGVelwukytqESKts/k/4HZBdB34fsng=;
        b=PSuWr4bRgOiYBwPdUhJhWk060I23JUn+35nkhrQ7SYk7M4V4/GAQgCKq93SMtId6Fu
         jrs77s0T7e/hMf+7p0YON/invcQB/w7VoBjrBeyVrePAqTNshlLC9W5bJ5G61fRwzyXO
         dRsZNugDgJHG8jlJLvR9uYhtmcRjVkah97hFEkmflO5DyFWquB/5pBMp5BU72wTYe5cD
         sqIfQktmO9Mr4pjraGBbCbnsiUK2ECcW/QNi+aHUdI/AOI+duLId2jeWoD4j38Nw4M83
         J827/PrgpyHO8QMSw3kcxAQEGuGRacf6J2SDnrw3gkRNU+k6+4DVq2aAQyuI478oaCsu
         s4HQ==
X-Gm-Message-State: AOJu0YwBS2lkLbr+A2Equk+KtvZp29V2GLJoikubY3Ulo7nZjaKJLEUW
	Q43PtCQuN3tQE3fO6Zwr4SazUJqvQZkrckgyxGmWvcIAXXaINlyOKj51dSMAaJilwOlm81HvfRj
	vHA==
X-Google-Smtp-Source: AGHT+IFF8X6W+8keGGC1Re8qrc+mhMogVqkIz1hWPolngotghqPZz/mK4Jjg1VkUoBzN/qU5TGWbg7vW83I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:5c85:0:b0:65b:7bff:881b with SMTP id
 41be03b00d2f7-6e15ebbfb56mr9302a12.8.1717805207578; Fri, 07 Jun 2024 17:06:47
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 17:06:34 -0700
In-Reply-To: <20240608000639.3295768-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240608000639.3295768-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240608000639.3295768-4-seanjc@google.com>
Subject: [PATCH v3 3/8] KVM: Rename functions related to enabling
 virtualization hardware
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename the various functions that enable virtualization to prepare for
upcoming changes, and to clean up artifacts of KVM's previous behavior,
which required manually juggling locks around kvm_usage_count.

Drop the "nolock" qualifier from per-CPU functions now that there are no
"nolock" implementations of the "all" variants, i.e. now that calling a
non-nolock function from a nolock function isn't confusing (unlike this
sentence).

Drop "all" from the outer helpers as they no longer manually iterate
over all CPUs, and because it might not be obvious what "all" refers to.
Instead, use double-underscores to communicate that the per-CPU functions
are helpers to the outer APIs.

Opportunistically prepend "kvm" to all functions to help make it clear
that they are KVM helpers, but mostly there's no reason not to.

Lastly, use "virtualization" instead of "hardware", because while the
functions do enable virtualization in hardware, there are a _lot_ of
things that KVM enables in hardware.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f6b114f42433..98e52d12f137 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -138,8 +138,8 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
 			.open		= kvm_no_compat_open
 #endif
-static int hardware_enable_all(void);
-static void hardware_disable_all(void);
+static int kvm_enable_virtualization(void);
+static void kvm_disable_virtualization(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -1215,7 +1215,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_arch_destroy_vm;
 
-	r = hardware_enable_all();
+	r = kvm_enable_virtualization();
 	if (r)
 		goto out_err_no_disable;
 
@@ -1258,7 +1258,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
 #endif
 out_err_no_mmu_notifier:
-	hardware_disable_all();
+	kvm_disable_virtualization();
 out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
 out_err_no_arch_destroy_vm:
@@ -1353,7 +1353,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #endif
 	kvm_arch_free_vm(kvm);
 	preempt_notifier_dec();
-	hardware_disable_all();
+	kvm_disable_virtualization();
 	mmdrop(mm);
 }
 
@@ -5502,7 +5502,7 @@ static DEFINE_PER_CPU(bool, hardware_enabled);
 static DEFINE_MUTEX(kvm_usage_lock);
 static int kvm_usage_count;
 
-static int hardware_enable_nolock(void)
+static int __kvm_enable_virtualization(void)
 {
 	if (__this_cpu_read(hardware_enabled))
 		return 0;
@@ -5524,10 +5524,10 @@ static int kvm_online_cpu(unsigned int cpu)
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
 	 * errors when scheduled to this CPU.
 	 */
-	return hardware_enable_nolock();
+	return __kvm_enable_virtualization();
 }
 
-static void hardware_disable_nolock(void *junk)
+static void __kvm_disable_virtualization(void *ign)
 {
 	if (!__this_cpu_read(hardware_enabled))
 		return;
@@ -5539,7 +5539,7 @@ static void hardware_disable_nolock(void *junk)
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
-	hardware_disable_nolock(NULL);
+	__kvm_disable_virtualization(NULL);
 	return 0;
 }
 
@@ -5558,7 +5558,7 @@ static void kvm_shutdown(void)
 	 */
 	pr_info("kvm: exiting hardware virtualization\n");
 	kvm_rebooting = true;
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	on_each_cpu(__kvm_disable_virtualization, NULL, 1);
 }
 
 static int kvm_suspend(void)
@@ -5574,7 +5574,7 @@ static int kvm_suspend(void)
 	lockdep_assert_not_held(&kvm_usage_lock);
 	lockdep_assert_irqs_disabled();
 
-	hardware_disable_nolock(NULL);
+	__kvm_disable_virtualization(NULL);
 	return 0;
 }
 
@@ -5583,7 +5583,7 @@ static void kvm_resume(void)
 	lockdep_assert_not_held(&kvm_usage_lock);
 	lockdep_assert_irqs_disabled();
 
-	WARN_ON_ONCE(hardware_enable_nolock());
+	WARN_ON_ONCE(__kvm_enable_virtualization());
 }
 
 static struct syscore_ops kvm_syscore_ops = {
@@ -5592,7 +5592,7 @@ static struct syscore_ops kvm_syscore_ops = {
 	.shutdown = kvm_shutdown,
 };
 
-static int hardware_enable_all(void)
+static int kvm_enable_virtualization(void)
 {
 	int r;
 
@@ -5635,7 +5635,7 @@ static int hardware_enable_all(void)
 	return r;
 }
 
-static void hardware_disable_all(void)
+static void kvm_disable_virtualization(void)
 {
 	guard(mutex)(&kvm_usage_lock);
 
@@ -5646,12 +5646,12 @@ static void hardware_disable_all(void)
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 }
 #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
-static int hardware_enable_all(void)
+static int kvm_enable_virtualization(void)
 {
 	return 0;
 }
 
-static void hardware_disable_all(void)
+static void kvm_disable_virtualization(void)
 {
 
 }
-- 
2.45.2.505.gda0bf45e8d-goog


