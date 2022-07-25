Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102CF580767
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 00:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237150AbiGYWcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 18:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiGYWcv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 18:32:51 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4580525C63
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:32:50 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id g12so11691256pfb.3
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BVhEfj2NX6XfnNodrUcmhiFdLX4Ha82fSBERbdY55+8=;
        b=NV6f/72clT6Ko9/zM5O5xT4zurwGc53oEQ+AALKh+rEpXBWqOdwlFjXgpxRQN1bgBN
         YAhuLztI6CaoO/ChgVwCeh8uoEwYygkI6U8IzxCFMtW3c8J5+mjs+CodzN3C83uKPXAf
         q6bviekcJhvkY0qyCgVzUehYxzw4W9LqoBw/wWl8DILoKAGdc72kRO4kyBwsbovRaZsO
         AVYUBCppSNdK4wjV7NH7tk2XlNn6HaMJwWj+If0NechGXJvIkjK4vGEn1pjlkvhl/skW
         t4YO7/0sx33CYK4m25sSwwYUWPRVSapWJmpgbvWajl7sym7KKmIzh2cR0CaanPb3YC5O
         eetA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BVhEfj2NX6XfnNodrUcmhiFdLX4Ha82fSBERbdY55+8=;
        b=JcdhnwiGP23JMxwL0PQ/6mUfvYFjkYUa3aQvs/CmaDNf4+YMaBrzJ8BJIR7PjmSW9R
         w8ZwDupEvChv6FLbdRE2t5KVVNSkgziEAs27vp/n72JetnToIPBvAE+/seBXdd9x1ur+
         jx8958+qcX73nSiWcuBhVqSnTobxPOdcB/eg1WDRn6c+GFCybxYPITMEqq8ll35NiPbq
         8l6l+Zv3CIr8crLdgLzWsDIlOwWSf6IUsRXxdAcRCTBIB0wa4Ad6HIxK1bABBUD3iPUO
         61pxfGefkc0xZWNVtoH6mJuCylp30anih46wCKADFgwKhw6PtFESj0m/hrd8yJv/iNlw
         WSZA==
X-Gm-Message-State: AJIora/GcY363G28TQipLsOYnyGeu2OuCESiMhd2kExtbbwtfGGf8PR/
        e1g2KqoeRq3brSjg/jTvAQg9mknMMzgDkA==
X-Google-Smtp-Source: AGRyM1vw49VKexSknHkmnUgaju4zexqBi9lkhBgZVDU1wim/X0h6Nfe3iwTLXWthbumMoGjb+JF/vQ==
X-Received: by 2002:a05:6a00:23d4:b0:52a:e5c1:caa7 with SMTP id g20-20020a056a0023d400b0052ae5c1caa7mr14870233pfc.62.1658788369519;
        Mon, 25 Jul 2022 15:32:49 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j10-20020a170902690a00b0016d5cf36ff8sm5073129plk.274.2022.07.25.15.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 15:32:49 -0700 (PDT)
Date:   Mon, 25 Jul 2022 22:32:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Junaid Shahid <junaids@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH] kvm: x86: mmu: Always flush TLBs when enabling dirty
 logging
Message-ID: <Yt8aDZDmu/yAwHHC@google.com>
References: <20220723024116.2724796-1-junaids@google.com>
 <Yt7Sh/aN1dlXN21N@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yt7Sh/aN1dlXN21N@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 25, 2022, David Matlack wrote:
> On Fri, Jul 22, 2022 at 07:41:16PM -0700, Junaid Shahid wrote:
> > When A/D bits are not available, KVM uses a software access tracking
> > mechanism, which involves making the SPTEs inaccessible. However,
> > the clear_young() MMU notifier does not flush TLBs. So it is possible
> > that there may still be stale, potentially writable, TLB entries.
> > This is usually fine, but can be problematic when enabling dirty
> > logging, because it currently only does a TLB flush if any SPTEs were
> > modified. But if all SPTEs are in access-tracked state, then there
> > won't be a TLB flush, which means that the guest could still possibly
> > write to memory and not have it reflected in the dirty bitmap.
> > 
> > So just unconditionally flush the TLBs when enabling dirty logging.
> > We could also do something more sophisticated if needed, but given
> > that a flush almost always happens anyway, so just making it
> > unconditional doesn't seem too bad.
> > 
> > Signed-off-by: Junaid Shahid <junaids@google.com>

...

> > @@ -6097,8 +6093,6 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> >  	 *
> >  	 * See is_writable_pte() for more details.
> >  	 */
> > -	if (flush)
> > -		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> >  }
> >  
> >  static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
> > @@ -6468,32 +6462,30 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> >  void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
> >  				   const struct kvm_memory_slot *memslot)
> >  {
> > -	bool flush = false;
> > -
> >  	if (kvm_memslots_have_rmaps(kvm)) {
> >  		write_lock(&kvm->mmu_lock);
> >  		/*
> >  		 * Clear dirty bits only on 4k SPTEs since the legacy MMU only
> >  		 * support dirty logging at a 4k granularity.
> >  		 */
> > -		flush = slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
> > +		slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
> >  		write_unlock(&kvm->mmu_lock);
> >  	}
> >  
> >  	if (is_tdp_mmu_enabled(kvm)) {
> >  		read_lock(&kvm->mmu_lock);
> > -		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
> > +		kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
> >  		read_unlock(&kvm->mmu_lock);
> >  	}
> >  
> >  	/*
> > +	 * The caller will flush the TLBs after this function returns.
> > +	 *
> >  	 * It's also safe to flush TLBs out of mmu lock here as currently this
> >  	 * function is only used for dirty logging, in which case flushing TLB
> >  	 * out of mmu lock also guarantees no dirty pages will be lost in
> >  	 * dirty_bitmap.
> >  	 */
> > -	if (flush)
> > -		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> >  }
> >  
> >  void kvm_mmu_zap_all(struct kvm *kvm)
> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index ba3dccb202bc..ec3e79ac4449 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -330,7 +330,7 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
> >  }
> >  
> >  /*
> > - * An shadow-present leaf SPTE may be non-writable for 3 possible reasons:
> > + * A shadow-present leaf SPTE may be non-writable for 4 possible reasons:
> >   *
> >   *  1. To intercept writes for dirty logging. KVM write-protects huge pages
> >   *     so that they can be split be split down into the dirty logging
> > @@ -348,6 +348,8 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
> >   *     read-only memslot or guest memory backed by a read-only VMA. Writes to
> >   *     such pages are disallowed entirely.
> >   *
> > + *  4. To track the Accessed status for SPTEs without A/D bits.
> > + *
> >   * To keep track of why a given SPTE is write-protected, KVM uses 2
> >   * software-only bits in the SPTE:
> 
> Drop the "2"  now that we're also covering access-tracking here.

Hmm, I would reword the whole comment.  If a SPTE is write-protected for dirty
logging, and then access-protected for access-tracking, the SPTE is "write-protected"
for two separate reasons.

 *  4. To emulate the Accessed bit for SPTEs without A/D bits.  Note, in this
 *     case, the SPTE is access-protected, not just write-protected!
 *
 * For cases #1 and #4, KVM can safely make such SPTEs writable without taking
 * mmu_lock as capturing the Accessed/Dirty doesn't require taking mmu_lock.
 * To differentiate #1 and #4 from #2 and #3, KVM uses two software-only bits
 * in the SPTE:

> > @@ -358,6 +360,8 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
> >   *  shadow_host_writable_mask, aka Host-writable -
> >   *    Cleared on SPTEs that are not host-writable (case 3 above)
> >   *
> > + * In addition, is_acc_track_spte() is true in the case 4 above.
> 
> The section describes the PTE bits so I think it'd be useful to
> explicilty call out SHADOW_ACC_TRACK_SAVED_MASK here. e.g.
> 
>   SHADOW_ACC_TRACK_SAVED_MASK, aka access-tracked -
>     Contains the R/X bits from the SPTE when it is being access-tracked,
>     otherwise 0. Note that the W-bit is also cleared when an SPTE is being
>     access-tracked, but it is not saved in the saved-mask. The W-bit is
>     restored based on the Host/MMU-writable bits when a write is attempted.
> 
> > + *
> >   * Note, not all possible combinations of PT_WRITABLE_MASK,
> >   * shadow_mmu_writable_mask, and shadow_host_writable_mask are valid. A given
> >   * SPTE can be in only one of the following states, which map to the
> > @@ -378,7 +382,8 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
> >   * shadow page tables between vCPUs. Write-protecting an SPTE for dirty logging
> >   * (which does not clear the MMU-writable bit), does not flush TLBs before
> >   * dropping the lock, as it only needs to synchronize guest writes with the
> > - * dirty bitmap.
> > + * dirty bitmap. Similarly, the clear_young() MMU notifier also does not flush
> > + * TLBs even though the SPTE can become non-writable because of case 4.
> 
> The reader here may not be familier with clear_young() and the rest of
> this comment does not explain what clear_young() has to do with
> access-tracking. So I would suggest tweaking the wording here to make
> things a bit more clear:
> 
>   Write-protecting an SPTE for access-tracking via the clear_young()
>   MMU notifier also does not flush the TLB under the MMU lock.

As above, the "write-protecting" part is going to confuse readers though.  I like
Junaid's wording of "can become non-writable".

> >   * So, there is the problem: clearing the MMU-writable bit can encounter a
> >   * write-protected SPTE while CPUs still have writable mappings for that SPTE
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f389691d8c04..8e33e35e4da4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12448,6 +12448,13 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
> >  		} else {
> >  			kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_4K);
> >  		}
> > +
> > +		/*
> > +		 * Always flush the TLB even if no PTEs were modified above,
> > +		 * because it is possible that there may still be stale writable
> > +		 * TLB entries for non-AD PTEs from a prior clear_young().
> 
> s/non-AD/access-tracked/ and s/PTE/SPTE/

If we go the "always flush" route, I would word the comment to explicitly call out
that the alternative would be to check if the SPTE is MMU-writable.

But my preference would actually be to keep the conditional flushing.  Not because
I think it will provide better performance (probably the opposite if anything),
but because it documents the dependencies/rules in code, and because "always flush"
reads like it's working around a KVM bug.  It's not a super strong preference though.

Partially, I think it'd be this?

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8e477333a263..23cb23e0913c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1169,8 +1169,8 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 {
        u64 spte = *sptep;

-       if (!is_writable_pte(spte) &&
-           !(pt_protect && is_mmu_writable_spte(spte)))
+       /* <comment about MMU-writable and access-tracking?> */
+       if (!is_mmu_writable_spte(spte))
                return false;

        rmap_printk("spte %p %llx\n", sptep, *sptep);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 40ccb5fba870..e217a8481686 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1350,15 +1350,14 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)

 /*
  * Remove write access from all SPTEs at or above min_level that map GFNs
- * [start, end). Returns true if an SPTE has been changed and the TLBs need to
- * be flushed.
+ * [start, end). Returns true if TLBs need to be flushed.
  */
 static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
                             gfn_t start, gfn_t end, int min_level)
 {
        struct tdp_iter iter;
        u64 new_spte;
-       bool spte_set = false;
+       bool flush = false;

        rcu_read_lock();

@@ -1371,39 +1370,43 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,

                if (!is_shadow_present_pte(iter.old_spte) ||
                    !is_last_spte(iter.old_spte, iter.level) ||
-                   !(iter.old_spte & PT_WRITABLE_MASK))
+                   !is_mmu_writable_spte(iter.old))
+                       continue;
+
+               /* <comment about access-tracking> */
+               flush = true;
+
+               if (!(iter.old_spte & PT_WRITABLE_MASK))
                        continue;

                new_spte = iter.old_spte & ~PT_WRITABLE_MASK;

                if (tdp_mmu_set_spte_atomic(kvm, &iter, new_spte))
                        goto retry;
-
-               spte_set = true;
        }

        rcu_read_unlock();
-       return spte_set;
+       return flush;
 }

 /*
  * Remove write access from all the SPTEs mapping GFNs in the memslot. Will
  * only affect leaf SPTEs down to min_level.
- * Returns true if an SPTE has been changed and the TLBs need to be flushed.
+ * Returns true if the TLBs need to be flushed.
  */
 bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
                             const struct kvm_memory_slot *slot, int min_level)
 {
        struct kvm_mmu_page *root;
-       bool spte_set = false;
+       bool flush = false;

        lockdep_assert_held_read(&kvm->mmu_lock);

        for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
-               spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
+               flush |= wrprot_gfn_range(kvm, root, slot->base_gfn,
                             slot->base_gfn + slot->npages, min_level);

-       return spte_set;
+       return flush;
 }

 static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
