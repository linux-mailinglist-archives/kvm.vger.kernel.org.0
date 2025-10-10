Return-Path: <kvm+bounces-59791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E371BCEA95
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 00:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC03C545ADC
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 22:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DCBF27465C;
	Fri, 10 Oct 2025 22:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BNAexpgr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4FD26D4C3
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 22:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760133857; cv=none; b=WeT3/u1oEICgjUaSgDJePOGAKqLZNCqoPm1U7K3nkexHQ1upAQOKB6rHTxFljaMksDZBOf2rGBHwjIfDkoYU/r6uzsvaZexISOrVLKX80pOey32apRkGJsd+ickWLqzAjxiPX3cCqRPvGCIUBhmALsbb89y4GcNjvJB7a70bm8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760133857; c=relaxed/simple;
	bh=k87yQH9+YVWOfAaGz3Va94k/Gwr8XEqVVfGOd4ZqQ/Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pnPqGHXwYRTdmwRzveh74gLr9hTsXo/sa7T4SKUY7KbKxaqdC/uQswtURQCA6vFQNDQnA1aAwPOu0qTQglyAmkWe8veMazsFBnT24p+s3NABUsno+VReifA04zWcc6gLOzsQ4AqtZJs7rC2TSO8KKKHzgO3qn1mKuKXesrMkSgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BNAexpgr; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-26985173d8eso102114675ad.1
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 15:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760133855; x=1760738655; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TMJXvlXA1cDcb2WQ8PSsGJctU1UOziaEnt5kch+0994=;
        b=BNAexpgrLltI7n+Pa05bxx2c927AHFxGM/i11Vpl8gvkgepODOf3VphciAQuQQZ9HM
         tQZ7QXgf9aUKn6rhy7JAtpIHucKxUS476Qns6WV1vZk2O2DcjKEgA4MZikV5/PE7Siib
         XRJVc0S1O7DAJc+hgUk/+Lq9IU2xQIe3oWc19zN9s1jUYgdwUKUV2vuJOAYyx4AMq26Y
         noDyl8duEV0kcV3Ik66hh6vXRfQpJE110raelnm/HHkG5bLsgEcL7d+m/sYdni7P18LG
         UNxH6YSRnwxWh5HtwUa//NW5zESnsi104KMlwLIB0g+dGDUFkK4sW1I3pvjRnS12TKz4
         oqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760133855; x=1760738655;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TMJXvlXA1cDcb2WQ8PSsGJctU1UOziaEnt5kch+0994=;
        b=Y9hrm/PJsJHFIKLwWB25gDSy4uxYG59gUWMRS+mXdPAr4GtGnuxJUp1PDZeMjT0wKX
         h9udkYzmhb+Dq98zoTDOau7aEYEYL2lpw36aYipAmnO4TC+mk3sSRrDYc/breavggsI1
         1I5lJYD4iEkjqrZypAXF4ii8MoFII955nkRysvLivFFX3JAMAum2KCVC+18ea8TYgLwo
         QNe/NXAcH44Nv/KlWBNACv4x74PpJ8Qy8BrCNmgfaCY7n/e2v+jCNxU8GUMAtPFTOrTW
         Uvbh4YSKkXXW81ppHx94JhhaBjKc39anWI7vtFFosuIo1FL9GaWZFL5BpJbHCWPXxrBe
         as+g==
X-Forwarded-Encrypted: i=1; AJvYcCU+8Gl0hs4l4uheY/3tBxUilRc+FtvW9Ut1J4Yjcr2PccRrSg4/OCJnjzpJz6+rMBmkqEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnNAfCKlxH7RCk/Dc70feYp5eU9e7U5a5PYMHROtJS+Ns6E0J2
	1GQzGsCYev6oMdcWlZd98ANljo/PaxE3CtFCDrzCZke3c6JflFPvpNMTh6eptjvsIFXYpGj9TQq
	2K8K6/g==
X-Google-Smtp-Source: AGHT+IHNYzmR/zadwiOJpJhr8iNmpspKjqy20SQCMReg8yB3TyDldvjJ6wlBF/kks5eUjIWgGLk3JxejU+Y=
X-Received: from plqt8.prod.google.com ([2002:a17:902:a5c8:b0:27e:4187:b4d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d60f:b0:269:ba61:222e
 with SMTP id d9443c01a7336-29027303330mr167280205ad.53.1760133854771; Fri, 10
 Oct 2025 15:04:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Oct 2025 15:03:59 -0700
In-Reply-To: <20251010220403.987927-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251010220403.987927-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <20251010220403.987927-2-seanjc@google.com>
Subject: [RFC PATCH 1/4] KVM: x86: Move kvm_rebooting to x86
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Xin Li <xin@zytor.com>, 
	Kai Huang <kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       | 13 +++++++++++++
 arch/x86/kvm/x86.h       |  1 +
 include/linux/kvm_host.h |  2 +-
 virt/kvm/kvm_main.c      | 14 +++++++-------
 4 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe3dc3eb4331..910a51370768 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -705,6 +705,9 @@ static void drop_user_return_notifiers(void)
 		kvm_on_user_return(&msrs->urn);
 }
 
+__visible bool kvm_rebooting;
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);
+
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
  *
@@ -13076,6 +13079,16 @@ int kvm_arch_enable_virtualization_cpu(void)
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
index f3dc77f006f9..d2ebe3232f55 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -54,6 +54,7 @@ struct kvm_host_values {
 	u64 arch_capabilities;
 };
 
+extern bool kvm_rebooting;
 void kvm_spurious_fault(void);
 
 #define SIZE_OF_MEMSLOTS_HASHTABLE \
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 680ca838f018..c4f18e6b1604 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1619,6 +1619,7 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+void kvm_arch_shutdown(void);
 /*
  * kvm_arch_{enable,disable}_virtualization() are called on one CPU, under
  * kvm_usage_lock, immediately after/before 0=>1 and 1=>0 transitions of
@@ -2300,7 +2301,6 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
 extern bool enable_virt_at_load;
-extern bool kvm_rebooting;
 #endif
 
 extern unsigned int halt_poll_ns;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b7a0ae2a7b20..4b61889289f0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5571,13 +5571,15 @@ bool enable_virt_at_load = true;
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
 
@@ -5631,10 +5633,9 @@ static int kvm_offline_cpu(unsigned int cpu)
 
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
@@ -5643,7 +5644,6 @@ static void kvm_shutdown(void)
 	 * 100% comprehensive.
 	 */
 	pr_info("kvm: exiting hardware virtualization\n");
-	kvm_rebooting = true;
 	on_each_cpu(kvm_disable_virtualization_cpu, NULL, 1);
 }
 
-- 
2.51.0.740.g6adb054d12-goog


