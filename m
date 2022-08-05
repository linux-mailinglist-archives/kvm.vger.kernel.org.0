Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D4D58AFBC
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 20:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241286AbiHES2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 14:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241044AbiHES2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 14:28:14 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46057AC02
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 11:28:12 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id w14so3309496plp.9
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 11:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=BL/PYHLK5I+7wiyur7VePegNkP/mST9Ke3AYJabl++Q=;
        b=tdJFTEGdO8pxYVBw2cnq83O6vcICaLj2yvLQDRRG9A9d47zXB84wVRBwsOXU43t1hW
         4/mRkZXTPlYd3q85FbKoO9ebfGPX27fMTFeRobyfqmsokMPVaJg6mISKsZusoxpHLblI
         gTONAdrS9gxJcboeE+M/TdY2kchPdtHj1MrIJl2UUuFXaie+SQAG/Co69OL41AixdveB
         0eha7jmkvXnLr5h4Ytwbtz7QtJ59K9ZB5EOAnq6CH9BwSOm63jH7ojcMgI89KLuSVbgn
         tqCn6qw5tBinTfFYS5pHblMYr20iGe5B4+nS0Vhq6Bb0bF8Qu7zyEmjTiv7dEObYYmWd
         /kNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=BL/PYHLK5I+7wiyur7VePegNkP/mST9Ke3AYJabl++Q=;
        b=NkBXMXMtY3BFmBH88Lm9LeimBbRFP64PvHBg2YLCimu0oVYWR6sYJs5Q/uXfPgkVR+
         5WwrdWXi7elniWfiFixCeANLehKqq+k+6d8kyS2GmVTisV5J0mnN9RgZlRLlBSm+7cYJ
         PyB9vFYs2F1L++30Lpwz0UaMokDo0iAvP6pLMgw/gF2sNjhIiQydDrucgvlPqpO1IEnl
         qegqQM+B2beV8lefKifOEHP0LLqD+kvfu4zDwnG4GVt1tYRolfWeKn/ksdKywIMVfWUV
         Gfn2rRaMPIuPxELsEjg4pJzoTv0X5AoBNjRWLp1iDQmhZg3Z4ErhSP4+Eb3FxCZJeuXv
         GPDA==
X-Gm-Message-State: ACgBeo3N1HaBmbVsddp9ZGPs2Hkb9rYQpgxuuUnr+F9FGh54m4O8xK1r
        9xNRClZld+KcRVOtdzx3EFfxGw==
X-Google-Smtp-Source: AA6agR578z5Xu8Sliyhay78A0QY7JhxKJhO/VZC3DUCypQwsXbMc1988NiXIyOxXPtiIhj0Try5q/A==
X-Received: by 2002:a17:90b:390d:b0:1f2:4dbe:5f44 with SMTP id ob13-20020a17090b390d00b001f24dbe5f44mr9016205pjb.27.1659724092205;
        Fri, 05 Aug 2022 11:28:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 186-20020a6206c3000000b0052d4b0d0c74sm3391656pfg.70.2022.08.05.11.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 11:28:11 -0700 (PDT)
Date:   Fri, 5 Aug 2022 18:28:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Junaid Shahid <junaids@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, dmatlack@google.com
Subject: Re: [PATCH v2] kvm: x86: mmu: Always flush TLBs when enabling dirty
 logging
Message-ID: <Yu1hOJSucP3NNYM1@google.com>
References: <20220728222833.3850065-1-junaids@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728222833.3850065-1-junaids@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022, Junaid Shahid wrote:
>  	/*
> +	 * The caller will flush the TLBs after this function returns.
> +	 *

This comment is still stale, e.g. it contains a blurb that talks about skipping
the flush based on MMU-writable.

	 * So to determine if a TLB flush is truly required, KVM
	 * will clear a separate software-only bit (MMU-writable) and skip the
	 * flush if-and-only-if this bit was already clear.

My preference is to drop this comment entirely and fold it into a single mega
comment in kvm_mmu_slot_apply_flags().  More below.

>  	 * It's also safe to flush TLBs out of mmu lock here as currently this
>  	 * function is only used for dirty logging, in which case flushing TLB
>  	 * out of mmu lock also guarantees no dirty pages will be lost in
>  	 * dirty_bitmap.
>  	 */
> -	if (flush)
> -		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
>  }

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f389691d8c04..f8b215405fe3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12448,6 +12448,25 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  		} else {
>  			kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_4K);
>  		}
> +
> +		/*
> +		 * We need to flush the TLBs in either of the following cases:

Please avoid "we" and pronouns in general.  It's fairly obvious that "we" refers
to KVM in this case, but oftentimes pronouns can be ambiguous, e.g. "we" can refer
to the developer, userspace, KVM, etc...

Smushing the two comments together, how about this as fixup?

---
 arch/x86/kvm/mmu/mmu.c | 23 ------------------
 arch/x86/kvm/x86.c     | 55 ++++++++++++++++++++++++++++++------------
 2 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 14d543f8373c..749c2d39c7bc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6097,29 +6097,6 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
 		read_unlock(&kvm->mmu_lock);
 	}
-
-	/*
-	 * The caller will flush TLBs to ensure that guest writes are reflected
-	 * in the dirty bitmap before the memslot update completes, i.e. before
-	 * enabling dirty logging is visible to userspace.
-	 *
-	 * Perform the TLB flush outside the mmu_lock to reduce the amount of
-	 * time the lock is held. However, this does mean that another CPU can
-	 * now grab mmu_lock and encounter a write-protected SPTE while CPUs
-	 * still have a writable mapping for the associated GFN in their TLB.
-	 *
-	 * This is safe but requires KVM to be careful when making decisions
-	 * based on the write-protection status of an SPTE. Specifically, KVM
-	 * also write-protects SPTEs to monitor changes to guest page tables
-	 * during shadow paging, and must guarantee no CPUs can write to those
-	 * page before the lock is dropped. As mentioned in the previous
-	 * paragraph, a write-protected SPTE is no guarantee that CPU cannot
-	 * perform writes. So to determine if a TLB flush is truly required, KVM
-	 * will clear a separate software-only bit (MMU-writable) and skip the
-	 * flush if-and-only-if this bit was already clear.
-	 *
-	 * See is_writable_pte() for more details.
-	 */
 }

 static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a5e0be2c8ef..430ca4d304a7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12474,21 +12474,46 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		}

 		/*
-		 * We need to flush the TLBs in either of the following cases:
-		 *
-		 * 1. We had to clear the Dirty bits for some SPTEs
-		 * 2. We had to write-protect some SPTEs and any of those SPTEs
-		 *    had the MMU-Writable bit set, regardless of whether the
-		 *    actual hardware Writable bit was set. This is because as
-		 *    long as the SPTE is MMU-Writable, some CPU may still have
-		 *    writable TLB entries for it, even after the Writable bit
-		 *    has been cleared. For more details, see the comments for
-		 *    is_writable_pte() [specifically the case involving
-		 *    access-tracking SPTEs].
-		 *
-		 * In almost all cases, one of the above conditions will be true.
-		 * So it is simpler (and probably slightly more efficient) to
-		 * just flush the TLBs unconditionally.
+		 * Unconditionally flush the TLBs after enabling dirty logging.
+		 * A flush is almost always going to be necessary (see below),
+		 * and unconditionally flushing allows the helpers to omit
+		 * the subtly complex checks when removing write access.
+		 *
+		 * Do the flush outside of mmu_lock to reduce the amount of
+		 * time mmu_lock is held.  Flushing after dropping mmu_lock is
+		 * safe as KVM only needs to guarantee the slot is fully
+		 * write-protected before returning to userspace, i.e. before
+		 * userspace can consume the dirty status.
+		 *
+		 * Flushing outside of mmu_lock requires KVM to be careful when
+		 * making decisions based on writable status of an SPTE, e.g. a
+		 * !writable SPTE doesn't guarantee a CPU can't perform writes.
+		 *
+		 * Specifically, KVM also write-protects guest page tables to
+		 * monitor changes when using shadow paging, and must guarantee
+		 * no CPUs can write to those page before mmu_lock is dropped.
+		 * Because CPUs may have stale TLB entries at this point, a
+		 * !writable SPTE doesn't guarantee CPUs can't perform writes.
+		 *
+		 * KVM also allows making SPTES writable outside of mmu_lock,
+		 * e.g. to allow dirty logging without taking mmu_lock.
+		 *
+		 * To handle these scenarios, KVM uses a separate software-only
+		 * bit (MMU-writable) to track if a SPTE is !writable due to
+		 * a guest page table being write-protected (KVM clears the
+		 * MMU-writable flag when write-protecting for shadow paging).
+		 *
+		 * The use of MMU-writable is also the primary motivation for
+		 * the unconditional flush.  Because KVM must guarantee that a
+		 * CPU doesn't contain stale, writable TLB entries for a
+		 * !MMU-writable SPTE, KVM must flush if it encounters any
+		 * MMU-writable SPTE regardless of whether the actual hardware
+		 * writable bit was set.  I.e. KVM is almost guaranteed to need
+		 * to flush, while unconditionally flushing allows the "remove
+		 * write access" helpers to ignore MMU-writable entirely.
+		 *
+		 * See is_writable_pte() for more details (the case involving
+		 * access-tracked SPTEs is particularly relevant).
 		 */
 		kvm_arch_flush_remote_tlbs_memslot(kvm, new);
 	}

base-commit: c00bb4ce5a8aa2156b31ac6b18285e52e1762d21
--

