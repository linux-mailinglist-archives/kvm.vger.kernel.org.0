Return-Path: <kvm+bounces-44787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20953AA0F40
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 16:42:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23E7A5A2452
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 14:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826B2217F36;
	Tue, 29 Apr 2025 14:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S68ESh1R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4A118A93F
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 14:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745937752; cv=none; b=SxRactgL/4BRUxpfGwbwoG90XOJmUJGNth8xGGc6ZeVrG+99e6mOIN4lMVw2i1jckCoBdZZzDozrulKO8fTXl2SbGgczYSQncXlilufIji8pcU2M43ecrGngDdYAVQ6dL8dHuzeRzMlN8NM4Q+1hctdSLuX9uWVTfhQJwN8aiQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745937752; c=relaxed/simple;
	bh=0LxHhShz+iUHtHcykB8wWEuK9Cv+f1D1ki3PQHAv1VQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MDvGH9BXimYGGDO95fTv/EIlGoun49HUHWffcL88nPFVGaYF8+bOZwq9PaZEfONmJp6Rmm6yzKxnBTPBRwQmY524xzccG4iDpUsqQ5oM176k54NAvElt1xYwGI0eUGgjjsjNECI7GswrHYxffKVel9V1B+m7OecOsU75FP7bdVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S68ESh1R; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2264e5b2b7cso53844245ad.2
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 07:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745937750; x=1746542550; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K0mQvprBOwUjWra1RcKKsKm0ztaWCfR7Qydgmflcz4E=;
        b=S68ESh1Rwo1zacNCw4U7AHpScjTnPDblVdY62HaqxlR12R1GJi1+I5G3tneve4FxIJ
         1EM4cyfxD77uZvsQ8wYaDaP7/KCOsJTnOLtjtOKRFAOqctlThfpxQQlXdZQjOqWkvvDH
         BEynl3WXI6qaqlsYDuGruI/t8tHkNye5CYGbqUlQAtfNd4pzULvFYt+S5GGjDko42jMn
         09WWPkJOhqBzQVjtdR52oFIOF+kytNvhapLB97KXpFfZB/F0TJWzngarY/ugI2/1gC8D
         8KeZPMmTMHpcHujC9V0yJd/G46AdXIMGCt+CfEcmjhI/8zTXAjQnt9JhdNoweQrzhWRp
         uRmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745937750; x=1746542550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K0mQvprBOwUjWra1RcKKsKm0ztaWCfR7Qydgmflcz4E=;
        b=kc3i9wNU90yM3QzWphMk5qA2M7IBYvDSbKiw2VfudOQCvkUq9JVPDQDG5wXJ4zIxRA
         74LDM/cpsRTbVHMwZByk6DlhS/JfhpqLH56y4UXjhh3D7esiADJ0mtFfu4vDlv1UuV3J
         3iwFTWfPT6IJqoM1qUPvyRlwTT4DvyKY6SJuCki7JnoiafOt1yroHbzB3mXsUjXnhJuh
         YV58YslBO5S6OzLrRfKtMCqfh/bbrvfKqt1BbDCxzskgdqYPDXYtJ1p6VkQH5+WSjaMg
         SL6jOWL6rzwEgOYvv86aTX7B1p8xr3fZJ/Wd/IFRJ0+CuyFQJyInpgbQIfloHtyM/TqT
         ZWtw==
X-Forwarded-Encrypted: i=1; AJvYcCUMDjjCUVoUX5rfAGjZiuiIT6uzlGtvUBgN5PalMw8g+4HFbcOlPz0G2dx8yjST+5vWKOw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqZx0oRS6vnYklrTc1kd6gn9NB57mYbCUeTdKYEh/qiO7jDFyX
	NRI2Kt/soDAYWGl4g1eXZQDayq6ZzZNafPXJCZLH3a0HBitH1o5OPdxnLBwUInM6e8xO+3jlm3E
	DAw==
X-Google-Smtp-Source: AGHT+IFaYA2nZjBdonnA/rXpPPoN3V40FiXVQKx/bAbY3JC1cK3nvlrThd1tO3ngtHKoV68eaBM7lXeAEY0=
X-Received: from plqu14.prod.google.com ([2002:a17:902:a60e:b0:223:6546:744e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:11c8:b0:220:e63c:5aff
 with SMTP id d9443c01a7336-22de607539fmr50951465ad.47.1745937750352; Tue, 29
 Apr 2025 07:42:30 -0700 (PDT)
Date: Tue, 29 Apr 2025 07:42:28 -0700
In-Reply-To: <20250429061004.205839-2-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com> <20250429061004.205839-2-Neeraj.Upadhyay@amd.com>
Message-ID: <aBDlVF4qXeUltuju@google.com>
Subject: Re: [PATCH v5 01/20] KVM: x86: Move find_highest_vector() to a common header
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	francescolavra.fl@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 29, 2025, Neeraj Upadhyay wrote:
> In preparation for using find_highest_vector() in Secure AVIC
> guest APIC driver, move (and rename) find_highest_vector() to
> apic.h.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v4:
>  - No change
> 
>  arch/x86/include/asm/apic.h | 23 +++++++++++++++++++++++
>  arch/x86/kvm/lapic.c        | 23 +++--------------------
>  2 files changed, 26 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 1c136f54651c..c63c2fe8ad13 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -500,6 +500,29 @@ static inline bool is_vector_pending(unsigned int vector)
>  	return lapic_vector_set_in_irr(vector) || pi_pending_this_cpu(vector);
>  }
>  
> +#define MAX_APIC_VECTOR			256
> +#define APIC_VECTORS_PER_REG		32
> +
> +static inline int apic_find_highest_vector(void *bitmap)
> +{
> +	unsigned int regno;
> +	unsigned int vec;
> +	u32 *reg;
> +
> +	/*
> +	 * The registers in the bitmap are 32-bit wide and 16-byte
> +	 * aligned. State of a vector is stored in a single bit.
> +	 */
> +	for (regno = MAX_APIC_VECTOR / APIC_VECTORS_PER_REG - 1; regno >= 0; regno--) {
> +		vec = regno * APIC_VECTORS_PER_REG;
> +		reg = bitmap + regno * 16;
> +		if (*reg)
> +			return __fls(*reg) + vec;
> +	}

NAK.  The changelog says nothing about rewriting the logic, and I have zero desire
to review or test this for correctness.  If someone has requested that the logic be
cleaned up, then do that as a separate patch (or patches) on top, with a changelog
that justifies the change, because to my eyes this isn't an improvement.

I suspect the rewrite is in part due to REG_POS() being a KVM helper that's poorly
named for a global macro.  lapic_vector_set_in_irr() already has open coded
versions of REG_POS() and VEC_POS(), just dedup those.
 
*sigh*

And you created your own versions of those in get_reg_bitmap() and get_vec_bit().

Please slot the below in.  And if there is any more code in this series that is
duplicating existing functionality, try to figure out a clean way to share code
instead of open coding yet another version.

--
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Apr 2025 07:30:47 -0700
Subject: [PATCH] x86/apic: KVM: Deduplicate APIC vector => register+bit math

Consolidate KVM's {REG,VEC}_POS() macros and lapic_vector_set_in_irr()'s
open coded equivalent logic in anticipation of the kernel gaining more
usage of vector => reg+bit lookups.

Use lapic_vector_set_in_irr()'s math as using divides for both the bit
number and register offset makes it easier to connect the dots, and for at
least one user, fixup_irqs(), "/ 32 * 0x10" generates ever so slightly
better code with gcc-14 (shaves a whole 3 bytes from the code stream):

((v) >> 5) << 4:
  c1 ef 05           shr    $0x5,%edi
  c1 e7 04           shl    $0x4,%edi
  81 c7 00 02 00 00  add    $0x200,%edi

(v) / 32 * 0x10:
  c1 ef 05           shr    $0x5,%edi
  83 c7 20           add    $0x20,%edi
  c1 e7 04           shl    $0x4,%edi

Keep KVM's tersely named macros as "wrappers" to avoid unnecessary churn
in KVM, and because the shorter names yield more readable code overall in
KVM.

No functional change intended (clang-19 and gcc-14 generate bit-for-bit
identical code for all of kvm.ko).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/apic.h | 7 +++++--
 arch/x86/kvm/lapic.h        | 4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index c903d358405d..7082826030ba 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -488,11 +488,14 @@ static inline void apic_setup_apic_calls(void) { }
 
 extern void apic_ack_irq(struct irq_data *data);
 
+#define APIC_VECTOR_TO_BIT_NUMBER(v) ((v) % 32)
+#define APIC_VECTOR_TO_REG_OFFSET(v) ((v) / 32 * 0x10)
+
 static inline bool lapic_vector_set_in_irr(unsigned int vector)
 {
-	u32 irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
+	u32 irr = apic_read(APIC_IRR + APIC_VECTOR_TO_REG_OFFSET(vector));
 
-	return !!(irr & (1U << (vector % 32)));
+	return !!(irr & (1U << APIC_VECTOR_TO_BIT_NUMBER(vector)));
 }
 
 static inline bool is_vector_pending(unsigned int vector)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index e33c969439f7..13a4bc60e292 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -145,8 +145,8 @@ void kvm_lapic_exit(void);
 
 u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
 
-#define VEC_POS(v) ((v) & (32 - 1))
-#define REG_POS(v) (((v) >> 5) << 4)
+#define VEC_POS(v) APIC_VECTOR_TO_BIT_NUMBER(v)
+#define REG_POS(v) APIC_VECTOR_TO_REG_OFFSET(v)
 
 static inline void kvm_lapic_clear_vector(int vec, void *bitmap)
 {

base-commit: 810a8562c8a326765a35e7c2415bd052cca9dd2a
--

