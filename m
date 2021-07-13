Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DE83C75CC
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 19:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhGMRhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 13:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhGMRhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 13:37:21 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FBEC0613E9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 10:34:31 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id p9so12551843pjl.3
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 10:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hd1cC6I5OHV5VCDUp3dibhj6CjJ47a+lGBgbKjVqLDo=;
        b=LleuEq/lqSw5USk8nmG+gJYpplLw6vMTPgb+W/T4AXU4Ii5D0O3PT1eyhcbudFfmff
         TKg6AnZdz6bJALmhn65rU5RkWnoDqnoxVw0tw8dP9uThmiDxvTDb89l7t+E8XcaKZyD3
         VcOAWoPj56sQ81fDzRL4slLRfpTI5d+DCPpaCGajnzJWpL+UVB1tXow2JH4sjLGsWGKh
         LFpEUBG8fDERCteyN3HQDkQ0nMLRGlIWJRzZm3aWLva1nl0dDcMQY97LskY5nyJrW3V8
         6B2A8ZHsQTDo04vqlaTG1NhmnmVcBq7wsxrm1vt8vsldGDPr0ksDNg/jt2ixU2lWccI5
         3Mag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hd1cC6I5OHV5VCDUp3dibhj6CjJ47a+lGBgbKjVqLDo=;
        b=SjW0UkDFa53y8jQAN+V3h87J5axDhaITStfptUPsh3xZHN3O+r3kOZjWxlJm4Xi27Z
         N52RySf7VrryL+VCwCrTQMI1pphyiFXF6d0xi61MWWTOp9Kt3m7dENJN7j5F5P9H0GEZ
         0nb5DVr7b48YBendTylw6QH+Yrsu41RwfPok7rdkJAApsNjIP3ep0bQeY9jzkCnYXln0
         YVYv2ZuERkSpnb+2Jk9TEqmDws3CNVsDzYQiWniAG4e6hC7f2DTy9QDW9F11ERhonT3p
         Vq/7MO15TTxkESH76soYA4v6Mg8/hxJvaUqxRJlW7vgdx758IaUQUzbNEF/4YY6uPd9e
         6SVA==
X-Gm-Message-State: AOAM533dTBhyyFkxVQvDE49/44CBTvJCZ3Zi/y6E/cKq3MkiQceDEJ9M
        M4eXJZXFI/S1nUyF6BjMC2fZkg==
X-Google-Smtp-Source: ABdhPJzoax2/gc1CHqtAG4G+Lr32vWff3NrNBVMUJoPXvCNFGjysNQxujHpb68AeTfZJajIcgLsexQ==
X-Received: by 2002:a17:90a:3807:: with SMTP id w7mr5207288pjb.115.1626197670459;
        Tue, 13 Jul 2021 10:34:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id pj3sm7604658pjb.35.2021.07.13.10.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 10:34:29 -0700 (PDT)
Date:   Tue, 13 Jul 2021 17:34:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bgardon@google.com
Subject: Re: [PATCH 1/2] KVM: Block memslot updates across range_start() and
 range_end()
Message-ID: <YO3OomTEhGFo2yee@google.com>
References: <20210610120615.172224-1-pbonzini@redhat.com>
 <20210610120615.172224-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610120615.172224-2-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10, 2021, Paolo Bonzini wrote:
>  static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fa7e7ebefc79..0dc0726c8d18 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -605,10 +605,13 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
>  
>  	/*
>  	 * .change_pte() must be surrounded by .invalidate_range_{start,end}(),
> -	 * and so always runs with an elevated notifier count.  This obviates
> -	 * the need to bump the sequence count.
> +	 * If mmu_notifier_count is zero, then start() didn't find a relevant
> +	 * memslot and wasn't forced down the slow path; rechecking here is
> +	 * unnecessary.
>  	 */
> -	WARN_ON_ONCE(!kvm->mmu_notifier_count);
> +	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));

The sanity check on mn_active_invalidate_count can be added in this patch, but
the optimization to return on !mmu_notifier_count should go in the next patch,
i.e. mmu_notifier_count must be non-zero since __kvm_handle_hva_range() always
takes mmu_lock at the time of this patch.

> +	if (!kvm->mmu_notifier_count)
> +		return;
>  
>  	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
>  }

...

> @@ -1281,7 +1322,21 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>  	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
>  	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
>  
> +	/*
> +	 * Do not store the new memslots while there are invalidations in
> +	 * progress (preparatory change for the next commit).
> +	 */
> +	spin_lock(&kvm->mn_invalidate_lock);
> +	prepare_to_rcuwait(&kvm->mn_memslots_update_rcuwait);
> +	while (kvm->mn_active_invalidate_count) {

Does this need a READ_ONCE()?  Or are the spin locks guaranteed to prevent the
compiler from caching mn_active_invalidate_count?

> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		spin_unlock(&kvm->mn_invalidate_lock);
> +		schedule();
> +		spin_lock(&kvm->mn_invalidate_lock);
> +	}
> +	finish_rcuwait(&kvm->mn_memslots_update_rcuwait);
>  	rcu_assign_pointer(kvm->memslots[as_id], slots);
> +	spin_unlock(&kvm->mn_invalidate_lock);
>  
>  	/*
>  	 * Acquired in kvm_set_memslot. Must be released before synchronize
> -- 
> 2.27.0
> 
> 
