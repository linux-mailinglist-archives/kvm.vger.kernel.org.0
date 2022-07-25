Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26D5580814
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 01:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237256AbiGYXVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 19:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiGYXVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 19:21:16 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935CE20BD2
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:21:14 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y9so11722710pff.12
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0J10v/gN05c0XPVlyhtn3J/dtEhGpocLRFSrLCnCBj0=;
        b=gR7k1N6CgbPFEi8PXlnSvID8googNudETfrM8zK7hB9n7FErKqiwtDQJlQBUiIOxyg
         DLZ+iyA08LsKUtLdwaGkdlFKJkZzSteHi18VOAcz2Ngs2c3SOu9KYeppEKtMkE5DgcEJ
         W7TatbgCSXddVbZ5mCqTrIhxVicRLfQDuZMSeCVkwUYrv74kkg/A2jraTVxHW8jggCjl
         AjmUzDtaBQOCD5pQdvReL2DVs+hvrnVYt/krIzE7v5FsjTafO9B2lu6OTeobFjCLXCbC
         PYKkpq6wxoE1vaU61+98qoFxH6nqb19Tne8BbiX1krUfG1Tx+Xs8M4vFVK6AUTPo7Uju
         +YBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0J10v/gN05c0XPVlyhtn3J/dtEhGpocLRFSrLCnCBj0=;
        b=A85OcmGSm8uecQDk+1x21Lc2PrWrUiT3uQJZ8ACmTcyD4qqYrLR1ePKlaxTl+DGQ28
         LTlzUVCmzp+1bkrFaFTLSou1HPGUxZwIJ3X4EOi9YIqWQ/nWl8L5wBIPh/9xDZdTR0q6
         6OSyePr24/5+V31OHgEzCKBTW2bPYzviEsnoF7m2P23x2XlG1lNgT/6+Uk6kDq82XWbP
         ib3tgHbyTUXhGZgFUiMt0ihtnr296ng2pCI649qLQ96lI3FxLSMlvg/p+aB9YHY188qg
         ry01+xAY43PjFEnp/7ldIdCtefzdgCQinoqw1tWv5h35mNyrsJ+wnD1iVbm+LNNYs8Qr
         J6TQ==
X-Gm-Message-State: AJIora93GP3zl21zskcTrfU53SY72W5quQOjvXx1ArDp0gydAqiZG46H
        Eo3lCZlz2i5dzsGmyiqwpSiEuYr+uhoMyw==
X-Google-Smtp-Source: AGRyM1uMDBqKBpAb3P6BwbBzNyUbC78EwtQ3wdVR6vjG4t0bM5QoJWvGFkmQ1wHEZW8lij98KqOA6g==
X-Received: by 2002:a63:4f0c:0:b0:41a:716c:b84f with SMTP id d12-20020a634f0c000000b0041a716cb84fmr12448992pgb.408.1658791273815;
        Mon, 25 Jul 2022 16:21:13 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id z11-20020aa7990b000000b005281d926733sm10066536pff.199.2022.07.25.16.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 16:21:12 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:21:08 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: Track the number of TDP MMU pages,
 but not the actual pages
Message-ID: <Yt8lZGrU0wqrPi5j@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <20220723012325.1715714-5-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723012325.1715714-5-seanjc@google.com>
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

On Sat, Jul 23, 2022 at 01:23:23AM +0000, Sean Christopherson wrote:
> Track the number of TDP MMU "shadow" pages instead of tracking the pages
> themselves. With the NX huge page list manipulation moved out of the common
> linking flow, elminating the list-based tracking means the happy path of
> adding a shadow page doesn't need to acquire a spinlock and can instead
> inc/dec an atomic.
> 
> Keep the tracking as the WARN during TDP MMU teardown on leaked shadow
> pages is very, very useful for detecting KVM bugs.
> 
> Tracking the number of pages will also make it trivial to expose the
> counter to userspace as a stat in the future, which may or may not be
> desirable.
> 
> Note, the TDP MMU needs to use a separate counter (and stat if that ever
> comes to be) from the existing n_used_mmu_pages. The TDP MMU doesn't bother
> supporting the shrinker nor does it honor KVM_SET_NR_MMU_PAGES (because the
> TDP MMU consumes so few pages relative to shadow paging), and including TDP
> MMU pages in that counter would break both the shrinker and shadow MMUs,
> e.g. if a VM is using nested TDP.
> 
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Reviewed-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/include/asm/kvm_host.h | 11 +++--------
>  arch/x86/kvm/mmu/tdp_mmu.c      | 19 +++++++++----------
>  2 files changed, 12 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 246b69262b93..5c269b2556d6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1271,6 +1271,9 @@ struct kvm_arch {
>  	 */
>  	bool tdp_mmu_enabled;
>  
> +	/* The number of TDP MMU pages across all roots. */
> +	atomic64_t tdp_mmu_pages;

This is the number of non-root TDP MMU pages, right?

> +
>  	/*
>  	 * List of struct kvm_mmu_pages being used as roots.
>  	 * All struct kvm_mmu_pages in the list should have
> @@ -1291,18 +1294,10 @@ struct kvm_arch {
>  	 */
>  	struct list_head tdp_mmu_roots;
>  
> -	/*
> -	 * List of struct kvmp_mmu_pages not being used as roots.
> -	 * All struct kvm_mmu_pages in the list should have
> -	 * tdp_mmu_page set and a tdp_mmu_root_count of 0.
> -	 */
> -	struct list_head tdp_mmu_pages;
> -
>  	/*
>  	 * Protects accesses to the following fields when the MMU lock
>  	 * is held in read mode:
>  	 *  - tdp_mmu_roots (above)
> -	 *  - tdp_mmu_pages (above)
>  	 *  - the link field of struct kvm_mmu_pages used by the TDP MMU
>  	 *  - possible_nx_huge_pages;
>  	 *  - the possible_nx_huge_page_link field of struct kvm_mmu_pages used
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 626c40ec2af9..fea22dc481a0 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -29,7 +29,6 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>  	kvm->arch.tdp_mmu_enabled = true;
>  	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
>  	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
> -	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
>  	kvm->arch.tdp_mmu_zap_wq = wq;
>  	return 1;
>  }
> @@ -54,7 +53,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  	/* Also waits for any queued work items.  */
>  	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
>  
> -	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
> +	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
>  	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
>  
>  	/*
> @@ -386,16 +385,18 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>  static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
>  			      bool shared)
>  {
> +	atomic64_dec(&kvm->arch.tdp_mmu_pages);
> +
> +	if (!sp->nx_huge_page_disallowed)
> +		return;
> +
>  	if (shared)
>  		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  	else
>  		lockdep_assert_held_write(&kvm->mmu_lock);
>  
> -	list_del(&sp->link);
> -	if (sp->nx_huge_page_disallowed) {
> -		sp->nx_huge_page_disallowed = false;
> -		untrack_possible_nx_huge_page(kvm, sp);
> -	}
> +	sp->nx_huge_page_disallowed = false;
> +	untrack_possible_nx_huge_page(kvm, sp);
>  
>  	if (shared)
>  		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> @@ -1132,9 +1133,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  		tdp_mmu_set_spte(kvm, iter, spte);
>  	}
>  
> -	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
> -	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +	atomic64_inc(&kvm->arch.tdp_mmu_pages);
>  
>  	return 0;
>  }
> -- 
> 2.37.1.359.gd136c6c3e2-goog
> 
