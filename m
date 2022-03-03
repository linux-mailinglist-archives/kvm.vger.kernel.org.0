Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC5F4CC541
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 19:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiCCSfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 13:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiCCSfR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 13:35:17 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6BB198ED1
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 10:34:31 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id c1so5287954pgk.11
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 10:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XQpQ3m9Rtf9LR3kz2qxftzIEj8ln513NcB495ceelT4=;
        b=M5BhchOGalZGDRNQ28oPcuwRqgRGSqglUZdoWjpLy3sC+QzcDMziJuStaAuWnKqEte
         VfGea+ht08trhrgvxja+7R93F6wCLTlRKf031phcl8xVdGQxcl10cL6Gbc933gkxEJ0g
         5CIl+mfyE+C3w5C+XqH3jArZpySK8h8+G298Sf3QDOL53I2+O8QFHGiH5MrLwviWYs+l
         rMP1HlY7C0FNGovaC5YtuxQlyP/dTApMgKYxg6Uyinc7WODYETqOOqj7EOJ5GJ/+a5KY
         LCD6Q2+2/9M3ynLRpG30/UtpZjAPr6QzfNyYRvwxDlqcS74KgF2PXciuTmeKrBZeNoNB
         Gs9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XQpQ3m9Rtf9LR3kz2qxftzIEj8ln513NcB495ceelT4=;
        b=W/zVQCP6QNjSEmrF+ALp/jhCh/qZJU+rLaxnzRvalhm5kVRNWBjPukP7oOej6YI1RQ
         b0pk3VRdpwRXVj6bkiqJZ7CpERExDr4itt8gFEyLsivs2LHnyR7qdnXrVy6M8r0hPbCi
         YSfqWteYQeqGRHkF/Y9NR+GhdGIRYP+nT8ms3lmXPhIE1GA1GCvYJZvwNs0KPG2KK3lk
         yLUcipX5lGdReQRYrgRGk7ooToBGLfSdItI3kABDGlvqjdKd/X4eacn7/zhZsGxidAWn
         YYLIqrvrngjuKGS5U0zqTlVuaoKMZIEkmPDjhnE8E/RgXbMT91WaBnMzFg/X/u9R52UF
         aU5A==
X-Gm-Message-State: AOAM531AHOMHqLduycD/0nIjobhLk4doFrB1FWs7Od6EmvavIBIDEkew
        hkFpEuGe7tfqOLQvEQnIQ8+SxQ==
X-Google-Smtp-Source: ABdhPJwRlvLAnUe1lC1N9KpiIAr5rmHMQ/l2+L9QYcnBtMn1NZ+C4a6+SgfevSpdd+zmMY+kUokQmQ==
X-Received: by 2002:a05:6a00:7c6:b0:4e1:799:7a2 with SMTP id n6-20020a056a0007c600b004e1079907a2mr39059440pfu.25.1646332470420;
        Thu, 03 Mar 2022 10:34:30 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id t41-20020a056a0013a900b004e167af0c0dsm3210601pfg.89.2022.03.03.10.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:34:29 -0800 (PST)
Date:   Thu, 3 Mar 2022 18:34:26 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 10/28] KVM: x86/mmu: Add helpers to read/write TDP MMU
 SPTEs and document RCU
Message-ID: <YiEKMnVgRNC861Yu@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-11-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226001546.360188-11-seanjc@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 26, 2022, Sean Christopherson wrote:
> Add helpers to read and write TDP MMU SPTEs instead of open coding
> rcu_dereference() all over the place, and to provide a convenient
> location to document why KVM doesn't exempt holding mmu_lock for write
> from having to hold RCU (and any future changes to the rules).
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_iter.c |  6 +++---
>  arch/x86/kvm/mmu/tdp_iter.h | 16 ++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c  |  6 +++---
>  3 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index be3f096db2eb..6d3b3e5a5533 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -12,7 +12,7 @@ static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
>  {
>  	iter->sptep = iter->pt_path[iter->level - 1] +
>  		SHADOW_PT_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
> -	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
> +	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
>  }
>  
>  static gfn_t round_gfn_for_level(gfn_t gfn, int level)
> @@ -89,7 +89,7 @@ static bool try_step_down(struct tdp_iter *iter)
>  	 * Reread the SPTE before stepping down to avoid traversing into page
>  	 * tables that are no longer linked from this entry.
>  	 */
> -	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
> +	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
>  
>  	child_pt = spte_to_child_pt(iter->old_spte, iter->level);
>  	if (!child_pt)
> @@ -123,7 +123,7 @@ static bool try_step_side(struct tdp_iter *iter)
>  	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
>  	iter->next_last_level_gfn = iter->gfn;
>  	iter->sptep++;
> -	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
> +	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
>  
>  	return true;
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index 216ebbe76ddd..bb9b581f1ee4 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -9,6 +9,22 @@
>  
>  typedef u64 __rcu *tdp_ptep_t;
>  
> +/*
> + * TDP MMU SPTEs are RCU protected to allow paging structures (non-leaf SPTEs)
> + * to be zapped while holding mmu_lock for read.  Holding RCU isn't required for
> + * correctness if mmu_lock is held for write, but plumbing "struct kvm" down to
> + * the lower depths of the TDP MMU just to make lockdep happy is a nightmare, so
> + * all accesses to SPTEs are done under RCU protection.
> + */
> +static inline u64 kvm_tdp_mmu_read_spte(tdp_ptep_t sptep)
> +{
> +	return READ_ONCE(*rcu_dereference(sptep));
> +}
> +static inline void kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 val)
> +{
> +	WRITE_ONCE(*rcu_dereference(sptep), val);
> +}
> +
>  /*
>   * A TDP iterator performs a pre-order walk over a TDP paging structure.
>   */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4f460782a848..8fbf3364f116 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -609,7 +609,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>  	 * here since the SPTE is going from non-present
>  	 * to non-present.
>  	 */
> -	WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
> +	kvm_tdp_mmu_write_spte(iter->sptep, 0);
>  
>  	return 0;
>  }
> @@ -648,7 +648,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>  	 */
>  	WARN_ON(is_removed_spte(iter->old_spte));
>  
> -	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
> +	kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
>  
>  	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
>  			      new_spte, iter->level, false);
> @@ -1046,7 +1046,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			 * because the new value informs the !present
>  			 * path below.
>  			 */
> -			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> +			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
>  		}
>  
>  		if (!is_shadow_present_pte(iter.old_spte)) {
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 
