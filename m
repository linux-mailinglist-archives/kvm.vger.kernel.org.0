Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19589580380
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 19:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbiGYR1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 13:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiGYR1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 13:27:43 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5123883
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 10:27:42 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f65so10950526pgc.12
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 10:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ubAxl0my88HM3GmYZevPQlu/lUIA0qiTU8VxHnKR8Hw=;
        b=tBiLLsKzs/OKeGcvEWF3nYOJbuSMyPx/GYM9hobG5gOC5AaB4gsIN9gVkmHzJ/JFyY
         t6xvyPC7E0py4mFOpYha0hLT/iFiRP3DVamdKI8PaGTC76UReIii+ydlmknRmM/zvV8/
         6HbfK+wr5TAzJWW0fkfmEOUvYh/zKC3TfJ5tY36M/htiqSaOzDHl/keEAKWbMwpACPGZ
         vuKQRewOM359dVBosrR7roUo+2UU0Sk4qMSvL8tn297nmmFpjQUHKmnaEcxeKwlB4Hhw
         ARfiHPzKzc6clByWuKy6Kn/FSf88FbRY1Bv6S1VrnfMGX5yttzymsPCcZYDVQYi74YMa
         SO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ubAxl0my88HM3GmYZevPQlu/lUIA0qiTU8VxHnKR8Hw=;
        b=4jTugAmqeHtJYfa0Wy454dfnHs3/jp9AJW47EZdSubquwmdkv/PFeWmrx+fraJz9Nd
         abEHtYjIBGNEfZrWjkyQsXSeasc104B+uoztVeF9smmp+AL/zDzfbdcr/uwj43h3XaMQ
         uQ2dPGNwRhEULbF2brKgZZS+US42innzl4nsIZyX8S++IMwwTdw/MetL3yMWR/VSZw6U
         Nvk/rVff9OB4T11/MqdL8T3RIOeS/3i4CciKwAwStUj2AjwyzpxB7xNGrHdrX8eLyFlh
         Hk/wReiX+3HTGTdojNyRDHkSOls0DUr/Dz7S7HYsJwfMqeY8/NBJZnRbE6JFMxnRTPMt
         UQDA==
X-Gm-Message-State: AJIora8LcqLNSwIuEtY1lUz7SUKiPXtX5+T1Lcx5e2QY99WS8rn1j2Ox
        gT+jS7aWLq7qbFFJd/oPRXRoJw==
X-Google-Smtp-Source: AGRyM1vGGWp/S5lcBBHudhav6VzcyjMQX5V/aftTWwymKkgbBlwQ/h/h59moLsKC0CH6DeRUSLJEJg==
X-Received: by 2002:a05:6a00:198e:b0:52b:e4c:19d8 with SMTP id d14-20020a056a00198e00b0052b0e4c19d8mr13750489pfl.47.1658770061722;
        Mon, 25 Jul 2022 10:27:41 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id m4-20020a170902db0400b0016c4cbefea3sm9588976plx.218.2022.07.25.10.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 10:27:40 -0700 (PDT)
Date:   Mon, 25 Jul 2022 10:27:35 -0700
From:   David Matlack <dmatlack@google.com>
To:     Junaid Shahid <junaids@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Subject: Re: [PATCH] kvm: x86: mmu: Always flush TLBs when enabling dirty
 logging
Message-ID: <Yt7Sh/aN1dlXN21N@google.com>
References: <20220723024116.2724796-1-junaids@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723024116.2724796-1-junaids@google.com>
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

On Fri, Jul 22, 2022 at 07:41:16PM -0700, Junaid Shahid wrote:
> When A/D bits are not available, KVM uses a software access tracking
> mechanism, which involves making the SPTEs inaccessible. However,
> the clear_young() MMU notifier does not flush TLBs. So it is possible
> that there may still be stale, potentially writable, TLB entries.
> This is usually fine, but can be problematic when enabling dirty
> logging, because it currently only does a TLB flush if any SPTEs were
> modified. But if all SPTEs are in access-tracked state, then there
> won't be a TLB flush, which means that the guest could still possibly
> write to memory and not have it reflected in the dirty bitmap.
> 
> So just unconditionally flush the TLBs when enabling dirty logging.
> We could also do something more sophisticated if needed, but given
> that a flush almost always happens anyway, so just making it
> unconditional doesn't seem too bad.
> 
> Signed-off-by: Junaid Shahid <junaids@google.com>

Wow, nice catch. I have some suggestions to word-smith the comments, but
otherwise:

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c  | 28 ++++++++++------------------
>  arch/x86/kvm/mmu/spte.h |  9 +++++++--
>  arch/x86/kvm/x86.c      |  7 +++++++
>  3 files changed, 24 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 52664c3caaab..f0d7193db455 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6058,27 +6058,23 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>  				      const struct kvm_memory_slot *memslot,
>  				      int start_level)
>  {
> -	bool flush = false;
> -
>  	if (kvm_memslots_have_rmaps(kvm)) {
>  		write_lock(&kvm->mmu_lock);
> -		flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
> -					  start_level, KVM_MAX_HUGEPAGE_LEVEL,
> -					  false);
> +		slot_handle_level(kvm, memslot, slot_rmap_write_protect,
> +				  start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
>  		write_unlock(&kvm->mmu_lock);
>  	}
>  
>  	if (is_tdp_mmu_enabled(kvm)) {
>  		read_lock(&kvm->mmu_lock);
> -		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
> +		kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
>  		read_unlock(&kvm->mmu_lock);
>  	}
>  
>  	/*
> -	 * Flush TLBs if any SPTEs had to be write-protected to ensure that
> -	 * guest writes are reflected in the dirty bitmap before the memslot
> -	 * update completes, i.e. before enabling dirty logging is visible to
> -	 * userspace.
> +	 * The caller will flush TLBs to ensure that guest writes are reflected
> +	 * in the dirty bitmap before the memslot update completes, i.e. before
> +	 * enabling dirty logging is visible to userspace.
>  	 *
>  	 * Perform the TLB flush outside the mmu_lock to reduce the amount of
>  	 * time the lock is held. However, this does mean that another CPU can
> @@ -6097,8 +6093,6 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>  	 *
>  	 * See is_writable_pte() for more details.
>  	 */
> -	if (flush)
> -		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
>  }
>  
>  static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
> @@ -6468,32 +6462,30 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
>  void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
>  				   const struct kvm_memory_slot *memslot)
>  {
> -	bool flush = false;
> -
>  	if (kvm_memslots_have_rmaps(kvm)) {
>  		write_lock(&kvm->mmu_lock);
>  		/*
>  		 * Clear dirty bits only on 4k SPTEs since the legacy MMU only
>  		 * support dirty logging at a 4k granularity.
>  		 */
> -		flush = slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
> +		slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
>  		write_unlock(&kvm->mmu_lock);
>  	}
>  
>  	if (is_tdp_mmu_enabled(kvm)) {
>  		read_lock(&kvm->mmu_lock);
> -		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
> +		kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
>  		read_unlock(&kvm->mmu_lock);
>  	}
>  
>  	/*
> +	 * The caller will flush the TLBs after this function returns.
> +	 *
>  	 * It's also safe to flush TLBs out of mmu lock here as currently this
>  	 * function is only used for dirty logging, in which case flushing TLB
>  	 * out of mmu lock also guarantees no dirty pages will be lost in
>  	 * dirty_bitmap.
>  	 */
> -	if (flush)
> -		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
>  }
>  
>  void kvm_mmu_zap_all(struct kvm *kvm)
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index ba3dccb202bc..ec3e79ac4449 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -330,7 +330,7 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
>  }
>  
>  /*
> - * An shadow-present leaf SPTE may be non-writable for 3 possible reasons:
> + * A shadow-present leaf SPTE may be non-writable for 4 possible reasons:
>   *
>   *  1. To intercept writes for dirty logging. KVM write-protects huge pages
>   *     so that they can be split be split down into the dirty logging
> @@ -348,6 +348,8 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
>   *     read-only memslot or guest memory backed by a read-only VMA. Writes to
>   *     such pages are disallowed entirely.
>   *
> + *  4. To track the Accessed status for SPTEs without A/D bits.
> + *
>   * To keep track of why a given SPTE is write-protected, KVM uses 2
>   * software-only bits in the SPTE:

Drop the "2"  now that we're also covering access-tracking here.

>   *
> @@ -358,6 +360,8 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
>   *  shadow_host_writable_mask, aka Host-writable -
>   *    Cleared on SPTEs that are not host-writable (case 3 above)
>   *
> + * In addition, is_acc_track_spte() is true in the case 4 above.

The section describes the PTE bits so I think it'd be useful to
explicilty call out SHADOW_ACC_TRACK_SAVED_MASK here. e.g.

  SHADOW_ACC_TRACK_SAVED_MASK, aka access-tracked -
    Contains the R/X bits from the SPTE when it is being access-tracked,
    otherwise 0. Note that the W-bit is also cleared when an SPTE is being
    access-tracked, but it is not saved in the saved-mask. The W-bit is
    restored based on the Host/MMU-writable bits when a write is attempted.

> + *
>   * Note, not all possible combinations of PT_WRITABLE_MASK,
>   * shadow_mmu_writable_mask, and shadow_host_writable_mask are valid. A given
>   * SPTE can be in only one of the following states, which map to the
> @@ -378,7 +382,8 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
>   * shadow page tables between vCPUs. Write-protecting an SPTE for dirty logging
>   * (which does not clear the MMU-writable bit), does not flush TLBs before
>   * dropping the lock, as it only needs to synchronize guest writes with the
> - * dirty bitmap.
> + * dirty bitmap. Similarly, the clear_young() MMU notifier also does not flush
> + * TLBs even though the SPTE can become non-writable because of case 4.

The reader here may not be familier with clear_young() and the rest of
this comment does not explain what clear_young() has to do with
access-tracking. So I would suggest tweaking the wording here to make
things a bit more clear:

  Write-protecting an SPTE for access-tracking via the clear_young()
  MMU notifier also does not flush the TLB under the MMU lock.

>   *
>   * So, there is the problem: clearing the MMU-writable bit can encounter a
>   * write-protected SPTE while CPUs still have writable mappings for that SPTE
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f389691d8c04..8e33e35e4da4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12448,6 +12448,13 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  		} else {
>  			kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_4K);
>  		}
> +
> +		/*
> +		 * Always flush the TLB even if no PTEs were modified above,
> +		 * because it is possible that there may still be stale writable
> +		 * TLB entries for non-AD PTEs from a prior clear_young().

s/non-AD/access-tracked/ and s/PTE/SPTE/

> +		 */
> +		kvm_arch_flush_remote_tlbs_memslot(kvm, new);
>  	}
>  }
>  
> 
> base-commit: a4850b5590d01bf3fb19fda3fc5d433f7382a974
> -- 
> 2.37.1.359.gd136c6c3e2-goog
> 
