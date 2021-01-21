Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63852FDE5A
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731693AbhAUBA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390717AbhAUAGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 19:06:15 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B1FC061757
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 16:05:35 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id m6so310717pfk.1
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 16:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nuUfS7QyWVj4DqwW9jCtE7Cofep4078qimVCK4eE9us=;
        b=FaSud171o3vOuOM0uB1Kd6T1FIQPuwqWSDp4jWK5idu1oYbdBmkSaioYKvyaIH+fQT
         OOKPxICsR8vywWuGQN+vQCEN1juEVrH+sKF6MmpEnEERJ1cvGIwzfeQ1XRAY7mbwCeo6
         4e1qKDWKTACh6KOb3sHYD9bsDrf+du94dGY3W0NeYE1meXS3ItT56giLk3XuO2SAeQgv
         DqwTdJBJaQI7aZU0ixu92VFq6vUD40xyr+f/ikmroAqd49uxwAepBAiYTYeKRsi66Po2
         55F13YZtXlnT0ug7RT5mbKq6bcE/nDNqR5x8DY3TcfkeEbCjOdBlGn41chF/kHA25/GO
         Povw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nuUfS7QyWVj4DqwW9jCtE7Cofep4078qimVCK4eE9us=;
        b=sIL+JxrPctovPaTwid4gGL/daBheUFo1V+ziHbjWSHfv6R54nIydkRZNmdNuWga4tD
         6zB0yrmMH+ELtYVamqjs3zUutB1sJIAbFy8jB6TYtl+BPVYU7n0RpmqE31rKPAyDC5pa
         y/YX6+cmajsdS1lVOn2T+KWJKbHtQQ4k6wsPirD4GzGecYeG7QcihlDUWOa59fflRjCH
         IgE/ai0xNJLhCi/Jb7F1W9yQMqPirMQ5qCLVMmw4IKwyONuphx2M8uNtkU4nWtbkvEee
         0bAaHA9Zou+Jrqt9fjGeMPUkixeWMTTq12eQjT7b9Wp+4V2XnUU929fotWKNAtnqS0Y4
         xKwQ==
X-Gm-Message-State: AOAM5327DreJ2TIGZogZdMKoFksKpAMmm7NXj0Ws6CrYrUc87RpHJDGq
        B9BelX7wLhxHUO5UUtAkss6m8A==
X-Google-Smtp-Source: ABdhPJy5aaOb0eiFrvHiqL3IEGUX+5Xp5mJH52u1xlaSOoIb//HjAcMVDEcm88yUhvyroR7teN4rfw==
X-Received: by 2002:a65:6290:: with SMTP id f16mr11781319pgv.69.1611187534208;
        Wed, 20 Jan 2021 16:05:34 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a189sm3587518pfd.117.2021.01.20.16.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 16:05:33 -0800 (PST)
Date:   Wed, 20 Jan 2021 16:05:26 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 22/24] kvm: x86/mmu: Flush TLBs after zap in TDP MMU PF
 handler
Message-ID: <YAjFRoCPB9anInnj@google.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-23-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112181041.356734-23-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Ben Gardon wrote:
> When the TDP MMU is allowed to handle page faults in parallel there is
> the possiblity of a race where an SPTE is cleared and then imediately
> replaced with a present SPTE pointing to a different PFN, before the
> TLBs can be flushed. This race would violate architectural specs. Ensure
> that the TLBs are flushed properly before other threads are allowed to
> install any present value for the SPTE.
> 
> Reviewed-by: Peter Feiner <pfeiner@google.com>
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/spte.h    | 16 +++++++++-
>  arch/x86/kvm/mmu/tdp_mmu.c | 62 ++++++++++++++++++++++++++++++++------
>  2 files changed, 68 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 2b3a30bd38b0..ecd9bfbccef4 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -130,6 +130,20 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
>  					  PT64_EPT_EXECUTABLE_MASK)
>  #define SHADOW_ACC_TRACK_SAVED_BITS_SHIFT PT64_SECOND_AVAIL_BITS_SHIFT
>  
> +/*
> + * If a thread running without exclusive control of the MMU lock must perform a
> + * multi-part operation on an SPTE, it can set the SPTE to FROZEN_SPTE as a
> + * non-present intermediate value. This will guarantee that other threads will
> + * not modify the spte.
> + *
> + * This constant works because it is considered non-present on both AMD and
> + * Intel CPUs and does not create a L1TF vulnerability because the pfn section
> + * is zeroed out.
> + *
> + * Only used by the TDP MMU.
> + */
> +#define FROZEN_SPTE (1ull << 59)

I dislike FROZEN, for similar reasons that I disliked "disconnected".  The SPTE
isn't frozen in the sense that it's temporarily immutable, rather it's been
removed but hasn't been flushed and so can't yet be reused.  Given that
FROZEN_SPTEs are treated as not-preset SPTEs, there's zero chance that this can
be extended in the future to be a generic temporarily freeze mechanism.

Mabye REMOVED_SPTE to match earlier feedback?

> +
>  /*
>   * In some cases, we need to preserve the GFN of a non-present or reserved
>   * SPTE when we usurp the upper five bits of the physical address space to
> @@ -187,7 +201,7 @@ static inline bool is_access_track_spte(u64 spte)
>  
>  static inline int is_shadow_present_pte(u64 pte)

Waaaay off topic, I'm going to send a patch to have this, and any other pte
helpers that return an int, return a bool.  While futzing around with ideas I
managed to turn this into a nop by doing

	return pte & SPTE_PRESENT;

which is guaranteed to be 0 if SPTE_PRESENT is a bit > 31.  I'm sure others will
point out that I'm a heathen for not doing !!(pte & SPTE_PRESENT), but still...

>  {
> -	return (pte != 0) && !is_mmio_spte(pte);
> +	return (pte != 0) && !is_mmio_spte(pte) && (pte != FROZEN_SPTE);

For all other checks, I'd strongly prefer to add a helper, e.g. is_removed_spte()
or whatever.  That way changing the implementation won't be as painful, and we
can add assertions and whatnot if we break things.  Especially since FROZEN_SPTE
is a single bit, which makes it look like a flag even though it's used as a full
64-bit constant.

For this, I worry that is_shadow_present_pte() is getting bloated.  It's also a
bit unfortunate that it's bloated for the old MMU, without any benefit. That
being said, most that bloat is from the existing MMIO checks.  Looking
elsewhere, TDX's SEPT also has a similar concept that may or may not need to
hook is_shadow_present_pte().

Rather than bundle MMIO SPTEs into the access-tracking flags and have a bunch of
special cases for not-present SPTEs, what if we add an explicit flag to mark
SPTEs as present (or not-present)?  Defining SPTE_PRESENT instead of
SPTE_NOT_PRESENT might require a few more changes, but it would be the most
optimal for is_shadow_present_pte().

I'm thinking something like this (completely untested):

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index c51ad544f25b..86f6c84569c4 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -38,7 +38,7 @@ static u64 generation_mmio_spte_mask(u64 gen)
        u64 mask;

        WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
-       BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_SPECIAL_MASK);
+       BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_MMIO);

        mask = (gen << MMIO_SPTE_GEN_LOW_SHIFT) & MMIO_SPTE_GEN_LOW_MASK;
        mask |= (gen << MMIO_SPTE_GEN_HIGH_SHIFT) & MMIO_SPTE_GEN_HIGH_MASK;
@@ -86,7 +86,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
                     bool can_unsync, bool host_writable, bool ad_disabled,
                     u64 *new_spte)
 {
-       u64 spte = 0;
+       u64 spte = SPTE_PRESENT;
        int ret = 0;

        if (ad_disabled)
@@ -247,7 +247,7 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask)
        BUG_ON((u64)(unsigned)access_mask != access_mask);
        WARN_ON(mmio_value & (shadow_nonpresent_or_rsvd_mask << SHADOW_NONPRESENT_OR_RSVD_MASK_LEN));
        WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
-       shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
+       shadow_mmio_value = mmio_value | SPTE_MMIO;
        shadow_mmio_access_mask = access_mask;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index ecd9bfbccef4..465e43d34034 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -5,18 +5,15 @@

 #include "mmu_internal.h"

+/* Software available bits for present SPTEs. */
 #define PT_FIRST_AVAIL_BITS_SHIFT 10
 #define PT64_SECOND_AVAIL_BITS_SHIFT 54

-/*
- * The mask used to denote special SPTEs, which can be either MMIO SPTEs or
- * Access Tracking SPTEs.
- */
+/* The mask used to denote Access Tracking SPTEs.  Note, val=3 is available. */
 #define SPTE_SPECIAL_MASK (3ULL << 52)
 #define SPTE_AD_ENABLED_MASK (0ULL << 52)
 #define SPTE_AD_DISABLED_MASK (1ULL << 52)
 #define SPTE_AD_WRPROT_ONLY_MASK (2ULL << 52)
-#define SPTE_MMIO_MASK (3ULL << 52)

 #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
 #define PT64_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
@@ -55,12 +52,16 @@
 #define SPTE_HOST_WRITEABLE    (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
 #define SPTE_MMU_WRITEABLE     (1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))

+#define SPTE_REMOVED           BIT_ULL(60)
+#define SPTE_MMIO              BIT_ULL(61)
+#define SPTE_PRESENT           BIT_ULL(62)
+
 /*
  * Due to limited space in PTEs, the MMIO generation is a 18 bit subset of
  * the memslots generation and is derived as follows:
  *
  * Bits 0-8 of the MMIO generation are propagated to spte bits 3-11
- * Bits 9-17 of the MMIO generation are propagated to spte bits 54-62
+ * Bits 9-17 of the MMIO generation are propagated to spte bits 52-60
  *
  * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
  * the MMIO generation number, as doing so would require stealing a bit from
@@ -73,8 +74,8 @@
 #define MMIO_SPTE_GEN_LOW_START                3
 #define MMIO_SPTE_GEN_LOW_END          11

-#define MMIO_SPTE_GEN_HIGH_START       PT64_SECOND_AVAIL_BITS_SHIFT
-#define MMIO_SPTE_GEN_HIGH_END         62
+#define MMIO_SPTE_GEN_HIGH_START       52
+#define MMIO_SPTE_GEN_HIGH_END         60

 #define MMIO_SPTE_GEN_LOW_MASK         GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
                                                    MMIO_SPTE_GEN_LOW_START)
@@ -162,7 +163,7 @@ extern u8 __read_mostly shadow_phys_bits;

 static inline bool is_mmio_spte(u64 spte)
 {
-       return (spte & SPTE_SPECIAL_MASK) == SPTE_MMIO_MASK;
+       return spte & SPTE_MMIO;
 }

 static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
@@ -199,9 +200,9 @@ static inline bool is_access_track_spte(u64 spte)
        return !spte_ad_enabled(spte) && (spte & shadow_acc_track_mask) == 0;
 }

-static inline int is_shadow_present_pte(u64 pte)
+static inline bool is_shadow_present_pte(u64 pte)
 {
-       return (pte != 0) && !is_mmio_spte(pte) && (pte != FROZEN_SPTE);
+       return pte & SPTE_PRESENT;
 }

 static inline int is_large_pte(u64 pte)


>  }
>  
>  static inline int is_large_pte(u64 pte)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7b12a87a4124..5c9d053000ad 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -429,15 +429,19 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  	 */
>  	if (!was_present && !is_present) {
>  		/*
> -		 * If this change does not involve a MMIO SPTE, it is
> -		 * unexpected. Log the change, though it should not impact the
> -		 * guest since both the former and current SPTEs are nonpresent.
> +		 * If this change does not involve a MMIO SPTE or FROZEN_SPTE,

For comments and error message, I think we should avoid using the exact constant
name, and instead call them "removed SPTE", similar to MMIO SPTE.  That will
help reduce thrash and/or stale comments if the name changes.

> +		 * it is unexpected. Log the change, though it should not
> +		 * impact the guest since both the former and current SPTEs
> +		 * are nonpresent.
>  		 */
> -		if (WARN_ON(!is_mmio_spte(old_spte) && !is_mmio_spte(new_spte)))
> +		if (WARN_ON(!is_mmio_spte(old_spte) &&
> +			    !is_mmio_spte(new_spte) &&
> +			    new_spte != FROZEN_SPTE))
>  			pr_err("Unexpected SPTE change! Nonpresent SPTEs\n"
>  			       "should not be replaced with another,\n"
>  			       "different nonpresent SPTE, unless one or both\n"
> -			       "are MMIO SPTEs.\n"
> +			       "are MMIO SPTEs, or the new SPTE is\n"
> +			       "FROZEN_SPTE.\n"
>  			       "as_id: %d gfn: %llx old_spte: %llx new_spte: %llx level: %d",
>  			       as_id, gfn, old_spte, new_spte, level);
>  		return;
