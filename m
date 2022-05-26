Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69B3535277
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346263AbiEZRTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344596AbiEZRTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:19:01 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0ECC4D623
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:18:56 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id b5so1957427plx.10
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V0pfiPZgs3vjBTfCx//XPB7dYQbXVCDX+Z0OvTUN8LU=;
        b=cYX29rbwuu9an9HDg02FWiM3C+9RzX0hdPe4/CShrZt2mcA5/h8n4WiswlIgxW7Czr
         +IERzHwpaICymUhokNBTT/j/1CZb0FNrenKu5j/VIHmv9cM9L7awyYt+9q47aOLbCjCt
         5gS8khR2JDykMzshPWO5T2cE1gdhoCDI6WO5WK9GbNSDNzUSofD6RNVt3DW41/LVVBDl
         KW/DR0vdWqb3H3g40wfF+68uqaBLt/4PuQdiQh0RkP5/4a+D+ounZGY+ODtBQMWj3suQ
         8+IdyXL51+c2wLXTgOlZm0V17KrebupvWxWbkORTTTC6WmtonV89NrrJyGVlzCpctCMA
         eFag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V0pfiPZgs3vjBTfCx//XPB7dYQbXVCDX+Z0OvTUN8LU=;
        b=IfHFKnGr+fu7s1Id+4Rb+P/cj1pBO37YnKc4Ij7hSfcDdV5Dl15pnmZ+K2ZRl8GeRS
         WtVWNkqZgQ4hgA0ILQ/u2DjJfnfq4F3pOHmc2nnMehOC5uOZRtghE1GdMSeSxvRpBf+J
         fohJHx3IiahRdU9Heu6gQDkP0imNC5AMxfgppz6tTHDMxG9+BmBJ0y0C9eWH7TqcP5Ek
         d97Mo9PyiUs9xogCjYFYXmRMkwZON0obxQAmi5Cvxjy5LXvbshWwuCL9/us+SasGfpCA
         ZDoCpCWvFEx3BJBhFgjK/NMNhpLctheTwdzwj1sxjWOarJun3JdRSqiATdNa/0yzaKaK
         cBbA==
X-Gm-Message-State: AOAM531O+2K+VcLDhSSNvJtOGqBQ1HeI4y1UYgIbpiANjtrSI5ksRYP2
        Qu8mQKC2KvBsqNbtKt5HEduVmg==
X-Google-Smtp-Source: ABdhPJyHlt/YmuX36CwuGvEbzkn6qLWFYeovAOpGNQZ1X8u3K0ILAFnbw+q0veQ5CUKAUb1xRNVErQ==
X-Received: by 2002:a17:902:ce91:b0:163:75a3:8e85 with SMTP id f17-20020a170902ce9100b0016375a38e85mr4535612plg.125.1653585536194;
        Thu, 26 May 2022 10:18:56 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id a19-20020a17090ad81300b001e26519097fsm736596pjv.11.2022.05.26.10.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 10:18:55 -0700 (PDT)
Date:   Thu, 26 May 2022 17:18:51 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Venkatesh Srinivas <venkateshs@chromium.org>, kvm@vger.kernel.org,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: mmu: spte_write_protect optimization
Message-ID: <Yo+2e2wYUnDbpcTQ@google.com>
References: <20220525191229.2037431-1-venkateshs@chromium.org>
 <Yo6MacceCSi9zSmU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo6MacceCSi9zSmU@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022 at 08:07:05PM +0000, Sean Christopherson wrote:
> +Ben and David
> 
> On Wed, May 25, 2022, Venkatesh Srinivas wrote:
> > From: Junaid Shahid <junaids@google.com>
> > 
> > This change uses a lighter-weight function instead of mmu_spte_update()
> > in the common case in spte_write_protect(). This helps speed up the
> > get_dirty_log IOCTL.
> 
> When upstreaming our internal patches, please rewrite the changelogs to meet
> upstream standards.  If that requires a lot of effort, then by all means take
> credit with a Co-developed-by or even making yourself the sole author with a
> Suggested-by for the original author.
> 
> There is subtly a _lot_ going on in this patch, and practically none of it is
> explained.
> 
> > Performance: dirty_log_perf_test with 32 GB VM size
> >              Avg IOCTL time over 10 passes
> >              Haswell: ~0.23s vs ~0.4s
> >              IvyBridge: ~0.8s vs 1s
> > 
> > Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
> > Signed-off-by: Junaid Shahid <junaids@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++++++++-----
> >  1 file changed, 21 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index efe5a3dca1e0..a6db9dfaf7c3 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1151,6 +1151,22 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
> >  	}
> >  }
> >  
> > +static bool spte_test_and_clear_writable(u64 *sptep)
> > +{
> > +	u64 spte = *sptep;
> > +
> > +	if (spte & PT_WRITABLE_MASK) {
> 
> This is redundant, the caller has already verified that the spte is writable.
> 
> > +		clear_bit(PT_WRITABLE_SHIFT, (unsigned long *)sptep);
> 
> Is an unconditional atomic op faster than checking spte_has_volatile_bits()?  If
> so, that should be documented with a comment.
> 
> This also needs a comment explaining the mmu_lock is held for write and so
> WRITABLE can't be cleared, i.e. using clear_bit() instead of test_and_clear_bit()
> is acceptable.
> 
> > +		if (!spte_ad_enabled(spte))
> 
> This absolutely needs a comment explaining what's going on.  Specifically that if
> A/D bits are disabled, the WRITABLE bit doubles as the dirty flag, whereas hardware's
> DIRTY bit is untouched when A/D bits are in use.
> 
> > +			kvm_set_pfn_dirty(spte_to_pfn(spte));
> > +
> > +		return true;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> >  /*
> >   * Write-protect on the specified @sptep, @pt_protect indicates whether
> >   * spte write-protection is caused by protecting shadow page table.
> > @@ -1174,11 +1190,11 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
> >  
> >  	rmap_printk("spte %p %llx\n", sptep, *sptep);
> >  
> > -	if (pt_protect)
> > -		spte &= ~shadow_mmu_writable_mask;
> > -	spte = spte & ~PT_WRITABLE_MASK;
> > -
> > -	return mmu_spte_update(sptep, spte);
> > +	if (pt_protect) {
> > +		spte &= ~(shadow_mmu_writable_mask | PT_WRITABLE_MASK);
> > +		return mmu_spte_update(sptep, spte);
> > +	}
> > +	return spte_test_and_clear_writable(sptep);
> 
> I think rather open code the logic instead of adding a helper.  Without even more
> comments, it's not at all obvious when it's safe to use spte_test_and_clear_writable().
> And although this patch begs the question of whether or not we should do a similar
> thing for the TDP MMU's clear_dirty_gfn_range(), the TDP MMU and legacy MMU can't
> really share a helper at this time because the TDP MMU only holds mmu_lock for read.
> 
> So minus all the comments that need to be added, I think this can just be:
> 
> ---
>  arch/x86/kvm/mmu/mmu.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index efe5a3dca1e0..caf5db7f1dce 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1174,11 +1174,16 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
> 
>  	rmap_printk("spte %p %llx\n", sptep, *sptep);
> 
> -	if (pt_protect)
> -		spte &= ~shadow_mmu_writable_mask;
> -	spte = spte & ~PT_WRITABLE_MASK;
> +	if (pt_protect) {
> +		spte &= ~(shadow_mmu_writable_mask | PT_WRITABLE_MASK);
> +		return mmu_spte_update(sptep, spte);
> +	}
> 
> -	return mmu_spte_update(sptep, spte);
> +	clear_bit(PT_WRITABLE_SHIFT, (unsigned long *)sptep);
> +	if (!spte_ad_enabled(spte))
> +		kvm_set_pfn_dirty(spte_to_pfn(spte));
> +
> +	return true;
>  }
> 
>  static bool rmap_write_protect(struct kvm_rmap_head *rmap_head,
> 
> base-commit: 9fd329c0c3309a87821817ca553b449936e318a9
> --
> 
> 
> And then on the TDP MMU side, I _think_ we can do the following (again, minus
> comments).  The logic being that if something else races and clears the bit or
> zaps the SPTEs, there's no point in "retrying" because either the !PRESENT check
> and/or the WRITABLE/DIRTY bit check will fail.
> 
> The only hiccup would be clearing a REMOVED_SPTE bit, but by sheer dumb luck, past
> me chose a semi-arbitrary value for REMOVED_SPTE that doesn't use either dirty bit.
> 
> This would need to be done over two patches, e.g. to make the EPT definitions
> available to the mmu.
> 
> Ben, David, any holes in my idea?

I think the idea will work. But I also wonder if we should just change
clear_dirty_gfn_range() to run under the write lock [1]. Then we could
share the code with the shadow MMU and avoid the REMOVED_SPTE
complexity.

[1] As a general rule, it seems like large (e.g. slot-wide)
single-threaded batch operations should run under the write lock.
They will be more efficient by avoiding atomic instructions, and can
still avoid lock contention via tdp_mmu_iter_cond_resched(). e.g. Ben
and I have been talking about changing eager page splitting to always
run under the write lock.

> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 841feaa48be5..c28a0b9e2af1 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1600,6 +1600,8 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
>         }
>  }
> 
> +#define VMX_EPT_DIRTY_BIT BIT_ULL(9)
> +
>  /*
>   * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. If
>   * AD bits are enabled, this will involve clearing the dirty bit on each SPTE.
> @@ -1610,35 +1612,32 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
>  static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>                            gfn_t start, gfn_t end)
>  {
> -       struct tdp_iter iter;
> -       u64 new_spte;
> +       const int dirty_shift = ilog2(shadow_dirty_mask);
>         bool spte_set = false;
> +       struct tdp_iter iter;
> +       int bit_nr;
> +
> +       BUILD_BUG_ON(REMOVED_SPTE & PT_DIRTY_MASK);
> +       BUILD_BUG_ON(REMOVED_SPTE & VMX_EPT_DIRTY_BIT);
> 
>         rcu_read_lock();
> 
>         tdp_root_for_each_leaf_pte(iter, root, start, end) {
> -retry:
>                 if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
>                         continue;
> 
>                 if (!is_shadow_present_pte(iter.old_spte))
>                         continue;
> 
> -               if (spte_ad_need_write_protect(iter.old_spte)) {
> -                       if (is_writable_pte(iter.old_spte))
> -                               new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
> -                       else
> -                               continue;
> -               } else {
> -                       if (iter.old_spte & shadow_dirty_mask)
> -                               new_spte = iter.old_spte & ~shadow_dirty_mask;
> -                       else
> -                               continue;
> -               }
> +               if (spte_ad_need_write_protect(iter.old_spte))
> +                       bit_nr = PT_WRITABLE_SHIFT;
> +               else
> +                       bit_nr = dirty_shift;
> 
> -               if (tdp_mmu_set_spte_atomic(kvm, &iter, new_spte))
> -                       goto retry;
> +               if (!test_and_clear_bit(bit_nr, (unsigned long *)iter.sptep))
> +                       continue;
> 
> +               kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
>                 spte_set = true;
>         }
> 
