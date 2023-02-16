Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAAF699A3F
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 17:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjBPQje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 11:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBPQjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 11:39:32 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5361E3B872;
        Thu, 16 Feb 2023 08:39:31 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id bp15so3446801lfb.13;
        Thu, 16 Feb 2023 08:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676565569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hl8TkXjDUuINBql4o4AzCQpBWalus571qjEm8zEtAl8=;
        b=Q+1mB6OD6oZI8cLbrQkfpwDvFsR/TXzS4KWXgdCDmFL5U3qypgZyAd/G5VYXsfvupZ
         Y3wPtzlskIrA3Y/QuR0xdosznwk5tzV1uD00VxHKxh5cA48S3yFVViCCHzYgVdp/F0yY
         ELtwAgIzYCe0zyIkWbCDC9zmyRHMqmMHXMLe5uo6KjHaApEnvmwx+PJQLFdsDd52Unyb
         dRH4E60DEFsuMmh/Emw7URM+GUVTJfvkBR9shpuppu+qQVkkv/u8fZ14fgMCNTywvfR4
         cbPv8qHIU6VOwkzTSgOrMF5QdnUOqiOWmm12wfh+VbCPbJq5wqbSQWElQIowj007MKJE
         2PtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676565569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hl8TkXjDUuINBql4o4AzCQpBWalus571qjEm8zEtAl8=;
        b=BBPbazG7yuHAg4IDjlymZy1IlUEYMwRxyBhnzVHtxacD9cZrMMOKnSE40ITqvhirSB
         iZCV21l07NGe802ruY+MlVzfJNDANsc2QhC4lQPFVPk/yN8SoZ7+gbOjEYayYc23CrSp
         6EJ88hJtoNkT5ESYeTLgmI/PF2Me0JJQRunvYaP8MPY9fhP4LOkB84sGxFk/BMCecD9H
         czJSG0DyeGARjPkNNrxmo0+uor/OMC9cdaakCB3c3cu5s+6S92gURr12/IfSzyGFcUdg
         P5ysHibkJb6bjIDQkyB3gKyjACjk7dX1n7BWU1Zq5Nw8z2Cb18qytUhuAl9CPD1HSa1+
         46lQ==
X-Gm-Message-State: AO0yUKVxdWnh2+YoeWkmUgsGEVlDzrIyChEqm9Tf6ZJ1IVVP2yEwT+Yb
        VtM5N+bAJokQ8IfDwpY1sXNr+IMunQs=
X-Google-Smtp-Source: AK7set+0/k1CnD9VK7tSUUfut8czHczIQQPqzWVgN3d77QcaVE1QwuT0kyEzV0eH9r3nCD0D16WKdQ==
X-Received: by 2002:ac2:43b9:0:b0:4db:3847:12ed with SMTP id t25-20020ac243b9000000b004db384712edmr1547125lfl.6.1676565569541;
        Thu, 16 Feb 2023 08:39:29 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id x16-20020ac259d0000000b004d0b1327b75sm353279lfn.61.2023.02.16.08.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 08:39:29 -0800 (PST)
Date:   Thu, 16 Feb 2023 18:39:26 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 044/113] KVM: x86/tdp_mmu: Make
 handle_changed_spte() return value
Message-ID: <20230216183926.00003f48@gmail.com>
In-Reply-To: <7cbce6eff935d9d64fa4638f5f6085ac1b8de9bb.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <7cbce6eff935d9d64fa4638f5f6085ac1b8de9bb.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 08:31:52 -0800
isaku.yamahata@intel.com wrote:

Some typos below:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX operation can fail with TDX_OPERAND_BUSY when multiple vcpu try to
                                                             vcpus
> operation on same TDX resource like Secure EPT.  It doesn't spin and returns
  operate

> busy error to VMM so that VMM has to take action, e.g. retry or whatever.
> 
> Because TDP MMU uses read spin lock for scalability, spinlock around seam
> call busts TDP MMU effort.  The other option is to let SEAMCALL fail and
> page fault handler should retry.  Make handle_changed_spte() and its caller
> return values so that kvm page fault handler can return on such cases. This
> patch makes it return only zero.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 72 +++++++++++++++++++++++++-------------
>  1 file changed, 47 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7ab498b80214..4fb07f91e5d6 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -349,9 +349,9 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>  	return __pa(root->spt);
>  }
>  
> -static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> -				u64 old_spte, u64 new_spte, int level,
> -				bool shared);
> +static int __must_check handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> +					    u64 old_spte, u64 new_spte, int level,
> +					    bool shared);
>  
>  static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
>  {
> @@ -445,6 +445,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>  	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(pt));
>  	int level = sp->role.level;
>  	gfn_t base_gfn = sp->gfn;
> +	int ret;
>  	int i;
>  
>  	trace_kvm_mmu_prepare_zap_page(sp);
> @@ -516,8 +517,14 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>  			old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte,
>  							  REMOVED_SPTE, level);
>  		}
> -		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
> -				    old_spte, REMOVED_SPTE, level, shared);
> +		ret = handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
> +					  old_spte, REMOVED_SPTE, level, shared);
> +		/*
> +		 * We are removing page tables.  Because in TDX case we don't
> +		 * zap private page tables except tearing down VM.  It means
> +		 * no race condition.
> +		 */
> +		WARN_ON_ONCE(ret);
>  	}
>  
>  	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
> @@ -538,9 +545,9 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>   * Handle bookkeeping that might result from the modification of a SPTE.
>   * This function must be called for all TDP SPTE modifications.
>   */
> -static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> -				  u64 old_spte, u64 new_spte, int level,
> -				  bool shared)
> +static int __must_check __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> +					      u64 old_spte, u64 new_spte, int level,
> +					      bool shared)
>  {
>  	bool was_present = is_shadow_present_pte(old_spte);
>  	bool is_present = is_shadow_present_pte(new_spte);
> @@ -576,7 +583,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  	}
>  
>  	if (old_spte == new_spte)
> -		return;
> +		return 0;
>  
>  	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
>  
> @@ -605,7 +612,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  			       "a temporary removed SPTE.\n"
>  			       "as_id: %d gfn: %llx old_spte: %llx new_spte: %llx level: %d",
>  			       as_id, gfn, old_spte, new_spte, level);
> -		return;
> +		return 0;
>  	}
>  
>  	if (is_leaf != was_leaf)
> @@ -624,17 +631,25 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  	if (was_present && !was_leaf &&
>  	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
>  		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
> +
> +	return 0;
>  }
>  
> -static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> -				u64 old_spte, u64 new_spte, int level,
> -				bool shared)
> +static int __must_check handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> +					    u64 old_spte, u64 new_spte, int level,
> +					    bool shared)
>  {
> -	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
> -			      shared);
> +	int ret;
> +
> +	ret = __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
> +				    shared);
> +	if (ret)
> +		return ret;
> +
>  	handle_changed_spte_acc_track(old_spte, new_spte, level);
>  	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
>  				      new_spte, level);
> +	return 0;
>  }
>  
>  /*
> @@ -653,12 +668,14 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>   * * -EBUSY - If the SPTE cannot be set. In this case this function will have
>   *            no side-effects other than setting iter->old_spte to the last
>   *            known value of the spte.
> + * * -EAGAIN - Same to -EBUSY. But the source is from callbacks for private spt
>   */
> -static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
> -					  struct tdp_iter *iter,
> -					  u64 new_spte)
> +static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
> +						       struct tdp_iter *iter,
> +						       u64 new_spte)
>  {
>  	u64 *sptep = rcu_dereference(iter->sptep);
> +	int ret;
>  
>  	/*
>  	 * The caller is responsible for ensuring the old SPTE is not a REMOVED
> @@ -677,15 +694,16 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
>  		return -EBUSY;
>  
> -	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> -			      new_spte, iter->level, true);
> -	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
> +	ret = __handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> +				    new_spte, iter->level, true);
> +	if (!ret)
> +		handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
>  
> -	return 0;
> +	return ret;
>  }
>  

----

> -static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
> -					  struct tdp_iter *iter)
> +static inline int __must_check tdp_mmu_zap_spte_atomic(struct kvm *kvm,
> +						       struct tdp_iter *iter)
>  {
>  	int ret;
>  
----

The above part doesn't belong to this patch.

> @@ -750,6 +768,8 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>  			      u64 old_spte, u64 new_spte, gfn_t gfn, int level,
>  			      bool record_acc_track, bool record_dirty_log)
>  {
> +	int ret;
> +
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  
>  	/*
> @@ -763,7 +783,9 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>  
>  	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
>  
> -	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
> +	ret = __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
> +	/* Because write spin lock is held, no race.  It should success. */
> +	WARN_ON_ONCE(ret);
>  
>  	if (record_acc_track)
>  		handle_changed_spte_acc_track(old_spte, new_spte, level);

