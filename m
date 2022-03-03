Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD374CC56B
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 19:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbiCCSsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 13:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbiCCSsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 13:48:50 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6958E5E14A
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 10:48:00 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id p17so5449652plo.9
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 10:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p7fhDS5lYFCTZC+D85sVdozKwDtg+g9RjPaejvj9554=;
        b=dB8mtC6VM7kHHTyoxH5/QJKjVMIR277NeZ85hG44JH5v/jSPveyQlMXnFAYPTeYTE+
         ru5G4JV6wDdcmKBn+lXnLb80ODe/fPvo7IUv8V652dQ9pDmcwshSm6WF4DlrMM+TUG6m
         K25VJuCVmRJhJxpNV6RgHsJ1XrNuRy5u9xtSsAWRANJjUIf6clAsoKR7Ihkc/yyVfTCC
         RzWOiLSmppt17Tpj6GkIU3wJgEBeLVsUIss+hlqeM384Y1MUHkRgro+yyTr5Ebc+LEYw
         2XvoC87Dw3DYUxxA+Eoq4kstx+IhPRq9ilBEkvAYicr5zEqX4mZZuDosiAk+z8InzQv0
         uVLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p7fhDS5lYFCTZC+D85sVdozKwDtg+g9RjPaejvj9554=;
        b=qUnPOWTcLqUcOL+QIqlxoZxFtT9Ei6Tli4F1xzJeQG/yqeu89FuBQ7aropgNO9kOIF
         ghaGrfA5kgjWxKxcyp38x2m+g1SOumiCV6Txi6c78abU+Mz4Te3r32fUDlSk/r/wI5k0
         7JQSaLUQZnbHIVvh6XKQdzklisqoDa6HCVlWtzrNwShcolEcbPGIDZIyggw5IakqAuJf
         vm4jzV5uPW2rehy25/B0aLvr77Ync+kMI4OkHCsQc9by/7d5HDcGlGA6ly3WzZuu08/K
         V2dcS5ZpUletYEYcb5pV5Vrc+YsILrJZCe/pldtsrfle3AAd1nG+/hNxamr1L7C/mnZX
         pU5Q==
X-Gm-Message-State: AOAM532z3Pe86ycyeE4c8oGIdLgbxFCDJEGnNG/dvAd9Gd7L2QlSn1PF
        0EAS/0XaN5mrIm+bEX0xh90nxA==
X-Google-Smtp-Source: ABdhPJymlZyWv19HlXRmNhb0DuWfd4UTVZi8t9hyR5Fg/bFTNpoepuiPPT4hR9BqH07InBiRmc61Bg==
X-Received: by 2002:a17:902:a613:b0:151:7d6d:aa69 with SMTP id u19-20020a170902a61300b001517d6daa69mr16183298plq.89.1646333279704;
        Thu, 03 Mar 2022 10:47:59 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id i128-20020a626d86000000b004f3f2929d7asm3095289pfc.217.2022.03.03.10.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:47:59 -0800 (PST)
Date:   Thu, 3 Mar 2022 18:47:55 +0000
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
Subject: Re: [PATCH v3 12/28] KVM: x86/mmu: Refactor low-level TDP MMU set
 SPTE helper to take raw vals
Message-ID: <YiENWyDecwhlwJRi@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-13-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226001546.360188-13-seanjc@google.com>
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
> Refactor __tdp_mmu_set_spte() to work with raw values instead of a
> tdp_iter objects so that a future patch can modify SPTEs without doing a
> walk, and without having to synthesize a tdp_iter.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Mingwei Zhang <mizhang@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 51 +++++++++++++++++++++++---------------
>  1 file changed, 31 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 1dcdf1a4fcc1..9e8ba6f12ebf 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -617,9 +617,13 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>  
>  /*
>   * __tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
> - * @kvm: kvm instance
> - * @iter: a tdp_iter instance currently on the SPTE that should be set
> - * @new_spte: The value the SPTE should be set to
> + * @kvm:	      KVM instance
> + * @as_id:	      Address space ID, i.e. regular vs. SMM
> + * @sptep:	      Pointer to the SPTE
> + * @old_spte:	      The current value of the SPTE
> + * @new_spte:	      The new value that will be set for the SPTE
> + * @gfn:	      The base GFN that was (or will be) mapped by the SPTE
> + * @level:	      The level _containing_ the SPTE (its parent PT's level)
>   * @record_acc_track: Notify the MM subsystem of changes to the accessed state
>   *		      of the page. Should be set unless handling an MMU
>   *		      notifier for access tracking. Leaving record_acc_track
> @@ -631,12 +635,10 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>   *		      Leaving record_dirty_log unset in that case prevents page
>   *		      writes from being double counted.
>   */
> -static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
> -				      u64 new_spte, bool record_acc_track,
> -				      bool record_dirty_log)
> +static void __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> +			       u64 old_spte, u64 new_spte, gfn_t gfn, int level,
> +			       bool record_acc_track, bool record_dirty_log)
>  {
> -	WARN_ON_ONCE(iter->yielded);
> -
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  
>  	/*
> @@ -646,39 +648,48 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>  	 * should be used. If operating under the MMU lock in write mode, the
>  	 * use of the removed SPTE should not be necessary.
>  	 */
> -	WARN_ON(is_removed_spte(iter->old_spte) || is_removed_spte(new_spte));
> +	WARN_ON(is_removed_spte(old_spte) || is_removed_spte(new_spte));
>  
> -	kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
> +	kvm_tdp_mmu_write_spte(sptep, new_spte);
> +
> +	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
>  
> -	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> -			      new_spte, iter->level, false);
>  	if (record_acc_track)
> -		handle_changed_spte_acc_track(iter->old_spte, new_spte,
> -					      iter->level);
> +		handle_changed_spte_acc_track(old_spte, new_spte, level);
>  	if (record_dirty_log)
> -		handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
> -					      iter->old_spte, new_spte,
> -					      iter->level);
> +		handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
> +					      new_spte, level);
> +}
> +
> +static inline void _tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
> +				     u64 new_spte, bool record_acc_track,
> +				     bool record_dirty_log)
> +{
> +	WARN_ON_ONCE(iter->yielded);
> +
> +	__tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep, iter->old_spte,
> +			   new_spte, iter->gfn, iter->level,
> +			   record_acc_track, record_dirty_log);
>  }
>  
>  static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>  				    u64 new_spte)
>  {
> -	__tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
> +	_tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
>  }
>  
>  static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
>  						 struct tdp_iter *iter,
>  						 u64 new_spte)
>  {
> -	__tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
> +	_tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
>  }
>  
>  static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
>  						 struct tdp_iter *iter,
>  						 u64 new_spte)
>  {
> -	__tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
> +	_tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
>  }
>  
>  #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 
