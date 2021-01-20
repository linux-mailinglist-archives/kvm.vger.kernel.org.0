Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CC12FD9D9
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 20:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390674AbhATTbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 14:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392558AbhATT3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 14:29:30 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBF3C0613D3
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 11:28:48 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id g3so13075664plp.2
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 11:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BgVVctNJwA3wm3UJR5m9Yf+ur7PRHbSI/3/vQi3SfjA=;
        b=WPraidOsuaNUCJ/jd0j8+EavJxF7bP9ZFlw3sNwqr2XBTYVBHLjpfjT2y4LoNxrhVa
         JFQWJEcZNt4502L7BDMIU+BJl76fp81G1SRKuDCNmPPfHebb8wXUstf4S1ST7AXOkL9k
         BjJoYNuYJrlokmN3Uer0SoQWPNKOATBCR7grjZFvYoH4nztz/SErm9x/unY36j5hjbh7
         +PPFywBBuIKugHtdC7knC3ZyYvuBQS05s3sY1Ylm/0ED9N6rkLIiLhQ2EKoaiv1lEIJO
         WyhsxfvRfMsqmIRXfVNYeRjmR/YGy64/pvDHOjGjCcmwdoc3cIK2Rf7GI758w46jxhaZ
         cPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BgVVctNJwA3wm3UJR5m9Yf+ur7PRHbSI/3/vQi3SfjA=;
        b=VacqW6HOgRG7px8QgC7P8TgILOpc4yATR7TAlSFKU4ZF9XQlMcyi0i3yAAcREJ0l3D
         c38lKQDICq4Q3rWl/Ssdq3X4tVxfZ53k0TnOxBhxi1N6QyNcVy7B+J79A/Fk8+eIU+24
         Cmj6qqEX80+bjvsu7EdGv+KipKbwmBLTtcjFNvLVLRDWh7rzKoHY7dUKz+mxnEKivms1
         RzD3uZpH7Jyd7xn8yD2LieHp4tkgmaTP/+OvhSIFXf5IqNolRsdlnIZwTm8ibfr4Kt3x
         FGkZ6ZGpbQV/tW1cGZ31lzcCXCKse9iGDjIFfdjPmlesxj75H22DzxgT/8m/pXsNfX7C
         ChWA==
X-Gm-Message-State: AOAM531j5OTc1vqeylAikWlqE+yarkGlzv177yM/45jiBncMVUD42i2p
        r9Q8aG76Mf3s3SdAIJ2Q7OlUiw==
X-Google-Smtp-Source: ABdhPJybxYraV4WFhm+35WjK+Iigv4LGoJmc7RUS8WhuVt27T8uq/ShumNh3YgWN5N98aQ28uDsW/w==
X-Received: by 2002:a17:90a:fc97:: with SMTP id ci23mr7387460pjb.83.1611170927926;
        Wed, 20 Jan 2021 11:28:47 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id i6sm3155406pgc.58.2021.01.20.11.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 11:28:47 -0800 (PST)
Date:   Wed, 20 Jan 2021 11:28:40 -0800
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
Subject: Re: [PATCH 05/24] kvm: x86/mmu: Fix yielding in TDP MMU
Message-ID: <YAiEaB/t/o9JvRN4@google.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-6-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112181041.356734-6-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Ben Gardon wrote:
> There are two problems with the way the TDP MMU yields in long running
> functions. 1.) Given certain conditions, the function may not yield
> reliably / frequently enough. 2.) In some functions the TDP iter risks
> not making forward progress if two threads livelock yielding to
> one another.
> 
> Case 1 is possible if for example, a paging structure was very large
> but had few, if any writable entries. wrprot_gfn_range could traverse many
> entries before finding a writable entry and yielding.
> 
> Case 2 is possible if two threads were trying to execute wrprot_gfn_range.
> Each could write protect an entry and then yield. This would reset the
> tdp_iter's walk over the paging structure and the loop would end up
> repeating the same entry over and over, preventing either thread from
> making forward progress.
> 
> Fix these issues by moving the yield to the beginning of the loop,
> before other checks and only yielding if the loop has made forward
> progress since the last yield.

I think it'd be best to split this into two patches, e.g. ensure forward
progress and then yield more agressively.  They are two separate bugs, and I
don't think that ensuring forward progress would exacerbate case #1.  I'm not
worried about breaking things so much as getting more helpful shortlogs; "Fix
yielding in TDP MMU" doesn't provide any insight into what exactly was broken.
E.g. something like:

  KVM: x86/mmu: Ensure forward progress when yielding in TDP MMU iter
  KVM: x86/mmu: Yield in TDU MMU iter even if no real work was done

> Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
> Reviewed-by: Peter Feiner <pfeiner@google.com>
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 83 +++++++++++++++++++++++++++++++-------
>  1 file changed, 69 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index b2784514ca2d..1987da0da66e 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -470,9 +470,23 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  			  gfn_t start, gfn_t end, bool can_yield)
>  {
>  	struct tdp_iter iter;
> +	gfn_t last_goal_gfn = start;
>  	bool flush_needed = false;
>  
>  	tdp_root_for_each_pte(iter, root, start, end) {
> +		/* Ensure forward progress has been made before yielding. */
> +		if (can_yield && iter.goal_gfn != last_goal_gfn &&

Make last_goal_gfn a property of the iterator, that way all this logic can be
shoved into tdp_mmu_iter_flush_cond_resched(), and the comments about ensuring
forward progress and effectively invalidating/resetting the iterator (the
comment below) can be a function comment, as opposed to being copied everywhere.
E.g. there can be a big scary warning in the function comment stating that the
caller must restart its loop if the helper yielded.

Tangentially related, the name goal_gfn is quite confusing.  "goal" and "end"
are synonyms, but "goal" is often initialized with "start", and it's not used to
terminate the walk.  Maybe next_gfn instead?  And maybe yielded_gfn, since
last_next_gfn is pretty horrendous.

> +		    tdp_mmu_iter_flush_cond_resched(kvm, &iter)) {

This isn't quite correct, as tdp_mmu_iter_flush_cond_resched() will do an
expensive remote TLB flush on every yield, even if no flush is needed.  The
cleanest solution is likely to drop tdp_mmu_iter_flush_cond_resched() and
instead add a @flush param to tdp_mmu_iter_cond_resched().  If it's tagged
__always_inline, then the callers that unconditionally pass true/false will
optimize out the conditional code.

At that point, I think it would also make sense to fold tdp_iter_refresh_walk()
into tdp_mmu_iter_cond_resched(), because really we shouldn't be mucking with
the guts of the iter except for the yield case.

> +			last_goal_gfn = iter.goal_gfn;

Another argument for both renaming goal_gfn and moving last_*_gfn into the iter:
it's not at all obvious that updating the last gfn _after_ tdp_iter_refresh_walk()
is indeed correct.

You can also avoid a local variable by doing max(iter->next_gfn, iter->gfn) when
calling tdp_iter_refresh_walk().  IMO, that's also a bit easier to understand
than an open-coded equivalent.

E.g. putting it all together, with yielded_gfn set by tdp_iter_start():

static __always_inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
						     struct tdp_iter *iter,
						     bool flush)
{
	/* Ensure forward progress has been made since the last yield. */
	if (iter->next_gfn == iter->yielded_gfn)
		return false;

	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
		if (flush)
			kvm_flush_remote_tlbs(kvm);
		cond_resched_lock(&kvm->mmu_lock);

		/*
		 * Restart the walk over the paging structure from the root,
		 * starting from the highest gfn the iterator had previously
		 * reached.  The entire paging structure, except the root, may
		 * have been completely torn down and rebuilt while we yielded.
		 */
		tdp_iter_start(iter, iter->pt_path[iter->root_level - 1],
			       iter->root_level, iter->min_level,
			       max(iter->next_gfn, iter->gfn));
		return true;
	}

	return false;
}

> +			flush_needed = false;
> +			/*
> +			 * Yielding caused the paging structure walk to be
> +			 * reset so skip to the next iteration to continue the
> +			 * walk from the root.
> +			 */
> +			continue;
> +		}
> +
>  		if (!is_shadow_present_pte(iter.old_spte))
>  			continue;
>  
