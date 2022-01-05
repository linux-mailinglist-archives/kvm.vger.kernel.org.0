Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213F0484B9A
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 01:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236703AbiAEATQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 19:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235658AbiAEATP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 19:19:15 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30502C061761
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 16:19:14 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v16so32605832pjn.1
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 16:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bCYC+miH07d2FRj/9RDaoq4iu2pPUYuQlZAVya3JhmE=;
        b=Iwymnl1zJiosKX/c+o4bVhBug5326kUXLzuiPG4g/pyiPA186c5gZYi6Zv0/0oqZxU
         JHu0jGEAry4CQgHagoJT4XC85+cx8RO50BxIRT80HM40g93V/mRCuWu8mHsmkX/seDlk
         miV2pJuQ7HTRjRZpwmqyLPBnKVLoxALMN5ZUI3THCBLDMqpINLd2fddswGI0gKpXKzjK
         SR7wO0Bq2/y11Ff5HHkhCy1aj9ybIPbjGpR6Ew1pBA7dPaqFNPtALfM1CWCLvevOampX
         2SgC7NUgqnIsF2eneVQDpsOOKRIWzlu3xvTLh4FT98ftuj5AZJm/iSR9LZgB5g7PVaSG
         JD/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bCYC+miH07d2FRj/9RDaoq4iu2pPUYuQlZAVya3JhmE=;
        b=KvlNly9vnfYerrJykRQXSxSdh1LgrrnfFigTNLsA+M4N41NCoaTzv27ySZTpLHbeg0
         gvsitooSFG36Ojp5XkstY6xU2ZO7yeL0C2C0hLiTfxDMmJ9gZBNMbg0I7EcKnlSvbLfu
         aeUzurUrPIECR4WwvYXQORcZn0l7Bcmb7AhmbE6OOhi0h4oxX7oqAFwCPNVvlXR8ffot
         ysGA5NdFP2k9Tby3Z4WlwHXO8uv5sgno1LOvGNspccV2SaKa5wqpuYR5Zdj7dlI87ZoQ
         W5Bx+fsaE5nUqS837BRzMw+c791T4RyT4C9uZwXaxPvpMmt5wsyoet6E/Jo44i5jHsGZ
         RdQg==
X-Gm-Message-State: AOAM530rJ2m3t2RVXxjPBD2lt6m3wdWak8R+gIMHNYtmVdkyCCdczgAi
        0q4zYtoKyUQA35ecXzKY4AR3vQ==
X-Google-Smtp-Source: ABdhPJyyb9m0o1XsNVK984pIMcr3630Yvm/JhWz60G2MPpWJIps77gyQYyQEGx3IgVvYN0Sq7SR3vg==
X-Received: by 2002:a17:903:32c6:b0:149:7e3d:e493 with SMTP id i6-20020a17090332c600b001497e3de493mr40310837plr.13.1641341953459;
        Tue, 04 Jan 2022 16:19:13 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id 13sm43874012pfm.161.2022.01.04.16.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 16:19:12 -0800 (PST)
Date:   Wed, 5 Jan 2022 00:19:09 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v2 25/30] KVM: x86/mmu: Zap roots in two passes to avoid
 inducing RCU stalls
Message-ID: <YdTj/eHur+9Vqdw6@google.com>
References: <20211223222318.1039223-1-seanjc@google.com>
 <20211223222318.1039223-26-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223222318.1039223-26-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 23, 2021 at 10:23:13PM +0000, Sean Christopherson wrote:
> When zapping a TDP MMU root, perform the zap in two passes to avoid
> zapping an entire top-level SPTE while holding RCU, which can induce RCU
> stalls.  In the first pass, zap SPTEs at PG_LEVEL_1G, and then
> zap top-level entries in the second pass.
> 
> With 4-level paging, zapping a PGD that is fully populated with 4kb leaf
> SPTEs take up to ~7 or so seconds (time varies based number of kernel
> config, CPUs, vCPUs, etc...).  With 5-level paging, that time can balloon
> well into hundreds of seconds.
> 
> Before remote TLB flushes were omitted, the problem was even worse as
> waiting for all active vCPUs to respond to the IPI introduced significant
> overhead for VMs with large numbers of vCPUs.
> 
> By zapping 1gb SPTEs (both shadow pages and hugepages) in the first pass,
> the amount of work that is done without dropping RCU protection is
> strictly bounded, with the worst case latency for a single operation
> being less than 100ms.
> 
> Zapping at 1gb in the first pass is not arbitrary.  First and foremost,
> KVM relies on being able to zap 1gb shadow pages in a single shot when
> when repacing a shadow page with a hugepage.

When dirty logging is disabled, zap_collapsible_spte_range() does the
bulk of the work zapping leaf SPTEs and allows yielding. I guess that
could race with a vCPU faulting in the huge page though and the vCPU
could do the bulk of the work.

Are there any other scenarios where KVM relies on zapping 1GB worth of
4KB SPTEs without yielding?

In any case, 100ms is a long time to hog the CPU. Why not just do the
safe thing and zap each level? 4K, then 2M, then 1GB, ..., then root
level. The only argument against it I can think of is performance (lots
of redundant walks through the page table). But I don't think root
zapping is especially latency critical.

> Zapping a 1gb shadow page
> that is fully populated with 4kb dirty SPTEs also triggers the worst case
> latency due writing back the struct page accessed/dirty bits for each 4kb
> page, i.e. the two-pass approach is guaranteed to work so long as KVM can
> cleany zap a 1gb shadow page.
> 
>   rcu: INFO: rcu_sched self-detected stall on CPU
>   rcu:     52-....: (20999 ticks this GP) idle=7be/1/0x4000000000000000
>                                           softirq=15759/15759 fqs=5058
>    (t=21016 jiffies g=66453 q=238577)
>   NMI backtrace for cpu 52
>   Call Trace:
>    ...
>    mark_page_accessed+0x266/0x2f0
>    kvm_set_pfn_accessed+0x31/0x40
>    handle_removed_tdp_mmu_page+0x259/0x2e0
>    __handle_changed_spte+0x223/0x2c0
>    handle_removed_tdp_mmu_page+0x1c1/0x2e0
>    __handle_changed_spte+0x223/0x2c0
>    handle_removed_tdp_mmu_page+0x1c1/0x2e0
>    __handle_changed_spte+0x223/0x2c0
>    zap_gfn_range+0x141/0x3b0
>    kvm_tdp_mmu_zap_invalidated_roots+0xc8/0x130
>    kvm_mmu_zap_all_fast+0x121/0x190
>    kvm_mmu_invalidate_zap_pages_in_memslot+0xe/0x10
>    kvm_page_track_flush_slot+0x5c/0x80
>    kvm_arch_flush_shadow_memslot+0xe/0x10
>    kvm_set_memslot+0x172/0x4e0
>    __kvm_set_memory_region+0x337/0x590
>    kvm_vm_ioctl+0x49c/0xf80
> 
> Reported-by: David Matlack <dmatlack@google.com>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 27 ++++++++++++++++++++++-----
>  1 file changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index aec97e037a8d..2e28f5e4b761 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -809,6 +809,18 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  	gfn_t end = tdp_mmu_max_gfn_host();
>  	gfn_t start = 0;
>  
> +	/*
> +	 * To avoid RCU stalls due to recursively removing huge swaths of SPs,
> +	 * split the zap into two passes.  On the first pass, zap at the 1gb
> +	 * level, and then zap top-level SPs on the second pass.  "1gb" is not
> +	 * arbitrary, as KVM must be able to zap a 1gb shadow page without
> +	 * inducing a stall to allow in-place replacement with a 1gb hugepage.
> +	 *
> +	 * Because zapping a SP recurses on its children, stepping down to
> +	 * PG_LEVEL_4K in the iterator itself is unnecessary.
> +	 */
> +	int zap_level = PG_LEVEL_1G;
> +
>  	/*
>  	 * The root must have an elevated refcount so that it's reachable via
>  	 * mmu_notifier callbacks, which allows this path to yield and drop
> @@ -825,12 +837,9 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  
>  	rcu_read_lock();
>  
> -	/*
> -	 * No need to try to step down in the iterator when zapping an entire
> -	 * root, zapping an upper-level SPTE will recurse on its children.
> -	 */
> +start:
>  	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
> -				   root->role.level, start, end) {
> +				   zap_level, start, end) {
>  retry:
>  		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
>  			continue;
> @@ -838,6 +847,9 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  		if (!is_shadow_present_pte(iter.old_spte))
>  			continue;
>  
> +		if (iter.level > zap_level)
> +			continue;
> +
>  		if (!shared) {
>  			tdp_mmu_set_spte(kvm, &iter, 0);
>  		} else if (!tdp_mmu_set_spte_atomic(kvm, &iter, 0)) {
> @@ -846,6 +858,11 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  		}
>  	}
>  
> +	if (zap_level < root->role.level) {
> +		zap_level = root->role.level;
> +		goto start;
> +	}

This is probably just person opinion but I find the 2 iteration goto
loop harder to understand than just open-coding the 2 passes.

e.g.

  static void tdp_mmu_zap_root(...)
  {
          /*
           * To avoid RCU stalls due to recursively removing huge swaths of SPs,
           * split the zap into two passes.  On the first pass, zap at the 1gb
           * level, and then zap top-level SPs on the second pass.  "1gb" is not
           * arbitrary, as KVM must be able to zap a 1gb shadow page without
           * inducing a stall to allow in-place replacement with a 1gb hugepage.
           *
           * Because zapping a SP recurses on its children, stepping down to
           * PG_LEVEL_4K in the iterator itself is unnecessary.
           */
          tdp_mmu_zap_root_level(..., PG_LEVEL_1G);
          tdp_mmu_zap_root_level(..., root->role.level);
  }

Or just go ahead and zap each level from 4K up to root->role.level as I
mentioned above.

> +
>  	rcu_read_unlock();
>  }
>  
> -- 
> 2.34.1.448.ga2b2bfdf31-goog
> 
