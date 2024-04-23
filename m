Return-Path: <kvm+bounces-15730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7DA28AFB9E
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 00:16:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A8281F238A3
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 22:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E66145341;
	Tue, 23 Apr 2024 22:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sVYUNGM6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F98144D22
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 22:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713910534; cv=none; b=A/jle2UtVktsW7VGu8UpnNIrg+i6+jua5qbdU5dQQn7S8J72COCKaSW+Nprg7nl7r+4lVDP+07gCiZahVIBg/doBRRAH9rQdt0Yy7W8UjYvwWOxuSMWBUBMqmG/DK2eSga6JrQy/XPJXUAWBElhQtyuzktX21ShkMUcZkisd1dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713910534; c=relaxed/simple;
	bh=atYTvf09fqL9ha661bdOuC+yFRm+cZOt2NIycoIfOcs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ioVAd0mJeZb4gqJOF8eoF2MOaBOM1w9dlg2CADLiQbMTREJlK84rPKW9RJHqaC9hYdOrBrobLqDWB5ENzdsL3FaL0Hohlxz3MtC9TM8iktLY9Dn9zCRhr9ELBf8Yn1btFUULsqF5rfEW+21LjRTzyALeJEE6WyVNx0HQVHikogU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sVYUNGM6; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26845cdso10425178276.3
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 15:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713910532; x=1714515332; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/Ov/h5WRaO17YiHCSMWPKBysku7bCvXf02PCWZZe35g=;
        b=sVYUNGM6iqW09x3ixx9CAGUJaXBOXyl/kgW3o6EOOThlR7ZPZYhw3qxjEHmhcPHdTG
         PMEKYYaKdozNuptPMG4GPRLOS5XKg9rCxWL3KWNx6US9RJnRUKVzOYHbzyELT4rJ5ODm
         NTFd9asOkoYx7SQZHlzbnl3OeKaBWnsjgesPETs+LfzO+XdLXByNAc1z4x25q15NZpGE
         S+C+5RMp5BoTch88SO+udPQ94kvoenxa8iee/oRJ1cKjjgfXTBbXWX6+DKN5fOYRLTQm
         xckp4lDhSNI14C+sMJL3xhRh8xR9JM1UZPyGz4vbRgQHA0uAe87AUUqe6VY+4zuGcKW2
         smvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713910532; x=1714515332;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Ov/h5WRaO17YiHCSMWPKBysku7bCvXf02PCWZZe35g=;
        b=fIbmOedSCteKC9Jmh+OVdO/1e6cJFNl6jK173USHO4lwROUfyfLJlwA3627eJvzwmm
         /4CvqhUKF5UxGGHb/fTGdYfg7XyLYnLUqDZTkTc7wRnYkoqbi336r/4KX2cDJMBmNAey
         DW7B6RTlxuj5IZUXb9Jvb2Nny8Kb1q8gCW+RPXfEgbGJTthPMg+49yA2MoRw2Lpyy7fp
         nzdpfP1Z0KABEaeVIhc9+fMYwNN1ziHKVwLw5jFmHOV0nGdWhivQBacpn8cUFi4PRXEX
         sSoSrM45MKmCvRjLrG43Y4jDgjIsLtmWOPFDwKgVShgDW8Ny9lRIA1oec1rsSrmgp6cu
         o4Mw==
X-Gm-Message-State: AOJu0YznF22eO3guxzYQjtOGJ6UAAaFre6xQPNSp1aTlWO38S6/e3ZJJ
	DaggRB8D1SBDKrvB0WXz0OEHwY7nIoXlRICHu3J59c1sAkUCtGvuR0L6l806+Le9Jio2+aWCKSV
	hKA==
X-Google-Smtp-Source: AGHT+IEmD1+6roxoXhIronX3rlceU8QCd+Mk3yJr2hIjlvf+8Ry/DNq9i7zuRlIDXRbOpGegy5H5VsrZf0U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:110e:b0:dd9:1702:4837 with SMTP id
 o14-20020a056902110e00b00dd917024837mr313112ybu.3.1713910532321; Tue, 23 Apr
 2024 15:15:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 23 Apr 2024 15:15:21 -0700
In-Reply-To: <20240423221521.2923759-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423221521.2923759-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423221521.2923759-5-seanjc@google.com>
Subject: [PATCH 4/4] KVM: x86: Move shadow_phys_bits into "kvm_host", as "maxphyaddr"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move shadow_phys_bits into "struct kvm_host_values", i.e. into KVM's
global "kvm_host" variable, so that it is automatically exported for use
in vendor modules.  Rename the variable/field to maxphyaddr to more
clearly capture what value it holds, now that it's used outside of the
MMU (and because the "shadow" part is more than a bit misleading as the
variable is not at all unique to shadow paging).

Recomputing the raw/true host.MAXPHYADDR on every use can be subtly
expensive, e.g. it will incur a VM-Exit on the CPUID if KVM is running as
a nested hypervisor.  Vendor code already has access to the information,
e.g. by directly doing CPUID or by invoking kvm_get_shadow_phys_bits(), so
there's no tangible benefit to making it MMU-only.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h      | 27 +--------------------------
 arch/x86/kvm/mmu/mmu.c  |  2 +-
 arch/x86/kvm/mmu/spte.c | 24 +++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.c  | 14 ++++++--------
 arch/x86/kvm/vmx/vmx.h  |  2 +-
 arch/x86/kvm/x86.h      |  7 +++++++
 6 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index ef970aea26e7..0d63637f46d7 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -57,12 +57,6 @@ static __always_inline u64 rsvd_bits(int s, int e)
 	return ((2ULL << (e - s)) - 1) << s;
 }
 
-/*
- * The number of non-reserved physical address bits irrespective of features
- * that repurpose legal bits, e.g. MKTME.
- */
-extern u8 __ro_after_init shadow_phys_bits;
-
 static inline gfn_t kvm_mmu_max_gfn(void)
 {
 	/*
@@ -76,30 +70,11 @@ static inline gfn_t kvm_mmu_max_gfn(void)
 	 * than hardware's real MAXPHYADDR.  Using the host MAXPHYADDR
 	 * disallows such SPTEs entirely and simplifies the TDP MMU.
 	 */
-	int max_gpa_bits = likely(tdp_enabled) ? shadow_phys_bits : 52;
+	int max_gpa_bits = likely(tdp_enabled) ? kvm_host.maxphyaddr : 52;
 
 	return (1ULL << (max_gpa_bits - PAGE_SHIFT)) - 1;
 }
 
-static inline u8 kvm_get_shadow_phys_bits(void)
-{
-	/*
-	 * boot_cpu_data.x86_phys_bits is reduced when MKTME or SME are detected
-	 * in CPU detection code, but the processor treats those reduced bits as
-	 * 'keyID' thus they are not reserved bits. Therefore KVM needs to look at
-	 * the physical address bits reported by CPUID.
-	 */
-	if (likely(boot_cpu_data.extended_cpuid_level >= 0x80000008))
-		return cpuid_eax(0x80000008) & 0xff;
-
-	/*
-	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
-	 * custom CPUID.  Proceed with whatever the kernel found since these features
-	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).
-	 */
-	return boot_cpu_data.x86_phys_bits;
-}
-
 u8 kvm_mmu_get_max_tdp_level(void);
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 12ad01929dce..c30bffa441cf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4933,7 +4933,7 @@ static void reset_rsvds_bits_mask_ept(struct kvm_vcpu *vcpu,
 
 static inline u64 reserved_hpa_bits(void)
 {
-	return rsvd_bits(shadow_phys_bits, 63);
+	return rsvd_bits(kvm_host.maxphyaddr, 63);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 927f4abbe973..d49a3f928b0b 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -43,7 +43,25 @@ u64 __read_mostly shadow_acc_track_mask;
 u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
-u8 __ro_after_init shadow_phys_bits;
+static u8 __init kvm_get_host_maxphyaddr(void)
+{
+	/*
+	 * boot_cpu_data.x86_phys_bits is reduced when MKTME or SME are detected
+	 * in CPU detection code, but the processor treats those reduced bits as
+	 * 'keyID' thus they are not reserved bits. Therefore KVM needs to look at
+	 * the physical address bits reported by CPUID, i.e. the raw MAXPHYADDR,
+	 * when reasoning about CPU behavior with respect to MAXPHYADDR.
+	 */
+	if (likely(boot_cpu_data.extended_cpuid_level >= 0x80000008))
+		return cpuid_eax(0x80000008) & 0xff;
+
+	/*
+	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
+	 * custom CPUID.  Proceed with whatever the kernel found since these features
+	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).
+	 */
+	return boot_cpu_data.x86_phys_bits;
+}
 
 void __init kvm_mmu_spte_module_init(void)
 {
@@ -56,7 +74,7 @@ void __init kvm_mmu_spte_module_init(void)
 	 */
 	allow_mmio_caching = enable_mmio_caching;
 
-	shadow_phys_bits = kvm_get_shadow_phys_bits();
+	kvm_host.maxphyaddr = kvm_get_host_maxphyaddr();
 }
 
 static u64 generation_mmio_spte_mask(u64 gen)
@@ -492,7 +510,7 @@ void kvm_mmu_reset_all_pte_masks(void)
 	 * 52-bit physical addresses then there are no reserved PA bits in the
 	 * PTEs and so the reserved PA approach must be disabled.
 	 */
-	if (shadow_phys_bits < 52)
+	if (kvm_host.maxphyaddr < 52)
 		mask = BIT_ULL(51) | PT_PRESENT_MASK;
 	else
 		mask = 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cb1bd9aebac4..185b07bbbc16 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8337,18 +8337,16 @@ static void __init vmx_setup_me_spte_mask(void)
 	u64 me_mask = 0;
 
 	/*
-	 * kvm_get_shadow_phys_bits() returns shadow_phys_bits.  Use
-	 * the former to avoid exposing shadow_phys_bits.
-	 *
 	 * On pre-MKTME system, boot_cpu_data.x86_phys_bits equals to
-	 * shadow_phys_bits.  On MKTME and/or TDX capable systems,
+	 * kvm_host.maxphyaddr.  On MKTME and/or TDX capable systems,
 	 * boot_cpu_data.x86_phys_bits holds the actual physical address
-	 * w/o the KeyID bits, and shadow_phys_bits equals to MAXPHYADDR
-	 * reported by CPUID.  Those bits between are KeyID bits.
+	 * w/o the KeyID bits, and kvm_host.maxphyaddr equals to
+	 * MAXPHYADDR reported by CPUID.  Those bits between are KeyID bits.
 	 */
-	if (boot_cpu_data.x86_phys_bits != kvm_get_shadow_phys_bits())
+	if (boot_cpu_data.x86_phys_bits != kvm_host.maxphyaddr)
 		me_mask = rsvd_bits(boot_cpu_data.x86_phys_bits,
-			kvm_get_shadow_phys_bits() - 1);
+				    kvm_host.maxphyaddr - 1);
+
 	/*
 	 * Unlike SME, host kernel doesn't support setting up any
 	 * MKTME KeyID on Intel platforms.  No memory encryption
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 90f9e4434646..e7343023fbce 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -723,7 +723,7 @@ static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
 		return true;
 
 	return allow_smaller_maxphyaddr &&
-	       cpuid_maxphyaddr(vcpu) < kvm_get_shadow_phys_bits();
+	       cpuid_maxphyaddr(vcpu) < kvm_host.maxphyaddr;
 }
 
 static inline bool is_unrestricted_guest(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e69fff7d1f21..a88c65d3ea26 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -34,6 +34,13 @@ struct kvm_caps {
 };
 
 struct kvm_host_values {
+	/*
+	 * The host's raw MAXPHYADDR, i.e. the number of non-reserved physical
+	 * address bits irrespective of features that repurpose legal bits,
+	 * e.g. MKTME.
+	 */
+	u8 maxphyaddr;
+
 	u64 efer;
 	u64 xcr0;
 	u64 xss;
-- 
2.44.0.769.g3c40516874-goog


