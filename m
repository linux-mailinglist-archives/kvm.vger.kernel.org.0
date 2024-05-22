Return-Path: <kvm+bounces-17909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 265E88CB8EE
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 04:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93B651F26715
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14EFA770EA;
	Wed, 22 May 2024 02:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Poqc/1zn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65856A01E
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 02:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716344916; cv=none; b=bXXhhQfuv9uZ5Dgi/dD2eCBczHWwN0BYnM/3J/PxO295pYxu3OV/KIpuT8ueVqfAWiCoUfuQQw8TtHlSLzN9GfK84xSVIKBZyUAiKnrlGY+vCzXFutQBRIFOttzQZk0VU88iBhtJvB/75kCNc0fAy7ojk9x+KPNCui0KaqGsNOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716344916; c=relaxed/simple;
	bh=GC+UWTGloN0JKxcGq9mam/rQZ0km64cIv4PDPR1uo+A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uuo3GNmegJhXn/HNerllDQ9/SdKn+jec4QEtQyyIwdqVp8ywkg0QCqKpRwmfzJWJrkCkEGbPIRLavl7LNr4SvdxWY8LTCkX2SlhcHnD0Uyd3RSRkEObL7kCKTGkYMfezniP1t5EeBHsXNvzhPazHC4QDeWPft7NJpHeinqOuXKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Poqc/1zn; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61be1fcf9abso196085307b3.1
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 19:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716344913; x=1716949713; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wkvURyajJ4AL9oNmd9DQ4HvztWk8u7XSsmW3pg5AGnY=;
        b=Poqc/1znnNeXjbLuqTZTRNZaHQY//NcqfDGV/z8D1E36CGeMx/7pdMliwcRJ6kvKjq
         XXD8RlTYPiGAFlmKgW0sAMCYqEHkN0evrmWXAvRZxmRO3JBsGF/8vZvgQfyDI8USMJEY
         YG+Q15ql8z4czenswE5X7cegE8zNHwyNmuq9p/TduwdGLhopuEuu9ZvdkKbezTKpUAoE
         BraNDLJFhB5Imfr1afEfboVdiuAbAPfL14J8327Z5Y65Ma3S8Oly/OOeuiA61CunQbk1
         H6JR1/575D2LA0zJ3pnXRYHk/aEUOCnR8hXSCfiD/DkJrYbHcF1InXujE1qZyR8S00mV
         55ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716344913; x=1716949713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wkvURyajJ4AL9oNmd9DQ4HvztWk8u7XSsmW3pg5AGnY=;
        b=l9A8rsiA4xDS17Vgt7TJBX4+kCL/TWWJ2/0jp5B6LK3PcgzZTTiBgpg5H0xXfj8fZm
         oohue3Yq/cPL6n6+3CSUeruF/ZjXB+juK96rN/mqo8R+LlaPBa+jCEsrb6Dr/zPR4zQE
         GQo73IwKzSz+dsmSn81vcdB4ZX5VKSKEH+MmgNkhbyAyr5ecjBQ1x8lnXkMKT68IPQbp
         0M86QK8ZtQgQiAAPj6h82N0+7JIxbzOAZSqn72K2uXsuGKHJfIQY71gwnXtNdu9BycLi
         qM/VyRClWrD+N6HLYco7XqSNtSONUtywYKLQAdubNPER3dpvRDDq0ZDMTa6f7Q3Z5O07
         GGZw==
X-Gm-Message-State: AOJu0YxWMxexM9cJKfgm8BnEFx/Gdh30ChNVx+1DQHmNL3ckobrZuJko
	yw2Segx/6UhxJ627H9TBmVMmVUUK60FWCU5W8F8YAkX1EKqcKVxDDH2maCPmOi3/qRVPamy6JNg
	9iA==
X-Google-Smtp-Source: AGHT+IE/M+gvR3qTPtUEzY/NuesrQrEgXujVA/JmkMkK46KNhqMBG88SboKXrNUqByP0iGpLt5/XAB15gLM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d5d1:0:b0:627:c0ac:a9e7 with SMTP id
 00721157ae682-627e48733ffmr2436997b3.5.1716344913718; Tue, 21 May 2024
 19:28:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 21 May 2024 19:28:23 -0700
In-Reply-To: <20240522022827.1690416-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522022827.1690416-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240522022827.1690416-3-seanjc@google.com>
Subject: [PATCH v2 2/6] KVM: Rename functions related to enabling
 virtualization hardware
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 97783d6987e9..8ba2861e7788 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -139,8 +139,8 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
 			.open		= kvm_no_compat_open
 #endif
-static int hardware_enable_all(void);
-static void hardware_disable_all(void);
+static int kvm_enable_virtualization(void);
+static void kvm_disable_virtualization(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -1216,7 +1216,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_arch_destroy_vm;
 
-	r = hardware_enable_all();
+	r = kvm_enable_virtualization();
 	if (r)
 		goto out_err_no_disable;
 
@@ -1259,7 +1259,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
 #endif
 out_err_no_mmu_notifier:
-	hardware_disable_all();
+	kvm_disable_virtualization();
 out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
 out_err_no_arch_destroy_vm:
@@ -1354,7 +1354,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
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
2.45.0.215.g3402c0e53f-goog


