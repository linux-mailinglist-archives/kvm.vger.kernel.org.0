Return-Path: <kvm+bounces-65449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 88BC2CA9D06
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 02:11:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7D6ED3014101
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 01:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A4223B63E;
	Sat,  6 Dec 2025 01:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P0f8EGub"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD67223710
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 01:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764983470; cv=none; b=bNqavGgXjkkv3uD/Vi7YJDMgkZ6RYsanLQWm/lxL6JdPIBGhAxfSWDsyzuHCTBKWzsXVxX73Ci3FXTk3xko0K3r6CZnF3tGNSPg7LkTL+I3m3YWhox8IOyy3EjtLNFrd35pizQqTujYVc9KCv4T8JUAoz/yU0+bnaLR8T5p3u7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764983470; c=relaxed/simple;
	bh=Xoj3VzQYzVhpJbx4kNzoLA3tCFxy7VEFT4XaIsLRops=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PPRBRBU/FwXdKDyGzSawAUGHcy+x8QojMEMY+5eUBjYirhhXaIlvSNq0FU0cdylCT7sbafED97+0A0KblWDLCWnIxS9F1QQIQGXo2RNkKN+Co2Bqzs3+bNx46TGlQt3y08QZMsUBBr2n4XzLwAFbUTJcYcZM2FHD22+Dfp0D3wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P0f8EGub; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29da1ea0b97so54419715ad.3
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 17:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764983468; x=1765588268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pC6DfslZcu3nvvZIIA0BpqpSQzylE5RCvOKLxGkj7nQ=;
        b=P0f8EGubhEzbIREB811oRmqYboTX0t576lIZqsFwwTeg2uQxPDM2AToOrIYQnGZmGt
         Ge1f2+4B3WPRwKi1oucFmWHHCCHbGz65EHaWjmpI9huipUg0UFfDckIimPwefGgkSDLZ
         FyZiB1QhhoeWVy5G8N8czISVFgtGHsD2p5SAYkhurK/HqMX6oB209etYOiFrRRh+UxJG
         Ye/o+pKHHt8GEITwpUrIFVZAV21mX++GIMhNpEnmgCCflYsd9LijbZOz+qYyq62rmLQy
         AmOdDxri/4/wshYu2nZBYGnZCuPnW8jgx0dGKBSJui5lE5qU6MT1BgbcwyIcP09aK3og
         r4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764983468; x=1765588268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pC6DfslZcu3nvvZIIA0BpqpSQzylE5RCvOKLxGkj7nQ=;
        b=EE4dftH6wroWDyVw42Lu7D4BuywsW8Q2ssHhfBeMb5TlYRgMJRDLaTreTIHcXUJ8yh
         tdIfa2y3D/ie8oR2hCVU1KiC/eJWMrxirYDDDpTOCWjPYwjUvDYI7OBl0i9HXkelbJ4A
         r6GRQte3T3eEfXKyxwA3YTiXSkx1ji8P3FRJdiAT3c/Hrbfqk5R2gpISii2ZbaeVTEW8
         eg0Qb2RHhbvDI4BbVuV5FyhdpHWveniVWD7JusPgx+A/tUW1hbDd7A/owQRaxRJVzF8+
         MInjP/AxxMTBIHhztJ5S6jfeuDhGKQ/9NbrxnVvMxQEW7f+W/Y1ixcQ6xGJ7DAjUCFH+
         /Q6w==
X-Forwarded-Encrypted: i=1; AJvYcCUuMoH0UM2BMO7B0OvnsKHvaLznWy7NeQluDpUZqO/UyoMjqehhkE5AcYZkvtFWaipok6w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yztt8LG2ldQdxWcPD5j9qTZklZXFBpougQzI5oCS80XRhIqzFBk
	HoQWYr2Nj7NQpe+e6LKQScQTlE0OfcJhSPz5+qDctnQnS4OLcsMMGA2OX+eSx3A0gsnBCAibYma
	+U0RpSg==
X-Google-Smtp-Source: AGHT+IHqg7v/oM3O+Iza+gbHQ+Fut3uvvdzLynuyyGHbiI9eTt5zTPTdsfs0StG85k5cWuU3XEHxZlf+cm8=
X-Received: from pldo13.prod.google.com ([2002:a17:903:8d:b0:27e:ed03:b5a5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e805:b0:295:ac6f:c899
 with SMTP id d9443c01a7336-29df5dd24f3mr8573855ad.47.1764983468487; Fri, 05
 Dec 2025 17:11:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 17:10:48 -0800
In-Reply-To: <20251206011054.494190-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206011054.494190-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206011054.494190-2-seanjc@google.com>
Subject: [PATCH v2 1/7] KVM: x86: Move kvm_rebooting to x86
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move kvm_rebooting, which is only read by x86, to KVM x86 so that it can
be moved again to core x86 code.  Add a "shutdown" arch hook to facilate
setting the flag in KVM x86.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       | 13 +++++++++++++
 arch/x86/kvm/x86.h       |  1 +
 include/linux/kvm_host.h |  2 +-
 virt/kvm/kvm_main.c      | 14 +++++++-------
 4 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c6d899d53dd..80cb882f19e2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -694,6 +694,9 @@ static void drop_user_return_notifiers(void)
 		kvm_on_user_return(&msrs->urn);
 }
 
+__visible bool kvm_rebooting;
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);
+
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
  *
@@ -13100,6 +13103,16 @@ int kvm_arch_enable_virtualization_cpu(void)
 	return 0;
 }
 
+void kvm_arch_shutdown(void)
+{
+	/*
+	 * Set kvm_rebooting to indicate that KVM has asynchronously disabled
+	 * hardware virtualization, i.e. that relevant errors and exceptions
+	 * aren't entirely unexpected.
+	 */
+	kvm_rebooting = true;
+}
+
 void kvm_arch_disable_virtualization_cpu(void)
 {
 	kvm_x86_call(disable_virtualization_cpu)();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index fdab0ad49098..40993348a967 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -54,6 +54,7 @@ struct kvm_host_values {
 	u64 arch_capabilities;
 };
 
+extern bool kvm_rebooting;
 void kvm_spurious_fault(void);
 
 #define SIZE_OF_MEMSLOTS_HASHTABLE \
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..a453fe6ce05a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1621,6 +1621,7 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+void kvm_arch_shutdown(void);
 /*
  * kvm_arch_{enable,disable}_virtualization() are called on one CPU, under
  * kvm_usage_lock, immediately after/before 0=>1 and 1=>0 transitions of
@@ -2302,7 +2303,6 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
 extern bool enable_virt_at_load;
-extern bool kvm_rebooting;
 #endif
 
 extern unsigned int halt_poll_ns;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f1f6a71b2b5f..3278ee9381bd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5586,13 +5586,15 @@ bool enable_virt_at_load = true;
 module_param(enable_virt_at_load, bool, 0444);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(enable_virt_at_load);
 
-__visible bool kvm_rebooting;
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);
-
 static DEFINE_PER_CPU(bool, virtualization_enabled);
 static DEFINE_MUTEX(kvm_usage_lock);
 static int kvm_usage_count;
 
+__weak void kvm_arch_shutdown(void)
+{
+
+}
+
 __weak void kvm_arch_enable_virtualization(void)
 {
 
@@ -5646,10 +5648,9 @@ static int kvm_offline_cpu(unsigned int cpu)
 
 static void kvm_shutdown(void)
 {
+	kvm_arch_shutdown();
+
 	/*
-	 * Disable hardware virtualization and set kvm_rebooting to indicate
-	 * that KVM has asynchronously disabled hardware virtualization, i.e.
-	 * that relevant errors and exceptions aren't entirely unexpected.
 	 * Some flavors of hardware virtualization need to be disabled before
 	 * transferring control to firmware (to perform shutdown/reboot), e.g.
 	 * on x86, virtualization can block INIT interrupts, which are used by
@@ -5658,7 +5659,6 @@ static void kvm_shutdown(void)
 	 * 100% comprehensive.
 	 */
 	pr_info("kvm: exiting hardware virtualization\n");
-	kvm_rebooting = true;
 	on_each_cpu(kvm_disable_virtualization_cpu, NULL, 1);
 }
 
-- 
2.52.0.223.gf5cc29aaa4-goog


