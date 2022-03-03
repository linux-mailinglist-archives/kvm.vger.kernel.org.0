Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C924CC54E
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 19:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbiCCSiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 13:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbiCCSiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 13:38:20 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DA1639F
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 10:37:30 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id s1so5405844plg.12
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 10:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R+X4H7M+LG6xqrD1uLHkuUkSn555GPzR7bQZLtF1ork=;
        b=LkS88C+V+Y/2YuBrjM1LK9lu3FTjB6y45JNMZ25CcyorbjadrcynBYaSgI2tYCEUPH
         q0Ze9253duaJTDfVRq4tj57tERA6ThBweTLeqL0MwuEVJkTdHfVuAOXvbdYcTtqlcJ48
         C5lnzNsvXzWFWr4LQfuVuoJYzStHyQwAU7OL+YGsp/hRQ1vA3ppCoVpFLLJZwjw2v1Zw
         kJGSV9bkc/aGCFIRDoPJsKXCAmTfl3+mfVNMWnCp+T21zuV7HakRxXIw9V0WaWi9d2/7
         /5BaX/7mKPhjyXrTDM4hyb3+zJJnKXQL+rB/IoyrUZwZM3S45gtH84wUogmLbrFvNHdk
         Zw1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R+X4H7M+LG6xqrD1uLHkuUkSn555GPzR7bQZLtF1ork=;
        b=xVmZMpEibT+TIWd3KQNogzN59mgzgDBNy50WoyU077wKV9l7ESed473m45VH3An4gk
         I9McBH4lK5BCWta9cGm0klKHWUhX5zL6B7jdHvuMA0jkgRzgps9o6WF4kNU+Jj2LOxLR
         +6P5U44BjBQyhlhPsbUMKhSNFldtje+7mk8pN0MXj2VhhNEnwEoN+Z9UB+t3E/4Mgi3H
         Mpz9cY3cmKqi3Ln/rOXYNYgYakMgT+UBDzf08X2PG4Ty2vbBRof0MIACg4nszGrZD1IB
         CmfHGbiTBLrwFalXKAD2fNdQKQD+lxYxV1fpTBvEDRH6bzao17ceLXN9rIF635zI1rV/
         rdmg==
X-Gm-Message-State: AOAM533eFpVG5T8xytBBn8raa4ePe1vR1fH6NhpgtZWm0e1EHxz/7JfG
        y05mmR/DVQoYK9NrvNEL5PHbPw==
X-Google-Smtp-Source: ABdhPJy69duQeB7lBaf2hRDpiszGJmlFUP4Z9Vx4bUTzYJQDX1sdMzJYTqPRiKx/9YGFi7OB96TENw==
X-Received: by 2002:a17:902:b201:b0:14d:66b5:5d69 with SMTP id t1-20020a170902b20100b0014d66b55d69mr36879757plr.95.1646332649551;
        Thu, 03 Mar 2022 10:37:29 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id s21-20020a056a00195500b004f65b15b3a0sm3234216pfk.8.2022.03.03.10.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:37:29 -0800 (PST)
Date:   Thu, 3 Mar 2022 18:37:25 +0000
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
Subject: Re: [PATCH v3 11/28] KVM: x86/mmu: WARN if old _or_ new SPTE is
 REMOVED in non-atomic path
Message-ID: <YiEK5RdxPnoGw/f0@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-12-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226001546.360188-12-seanjc@google.com>
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
> WARN if the new_spte being set by __tdp_mmu_set_spte() is a REMOVED_SPTE,
> which is called out by the comment as being disallowed but not actually
> checked.  Keep the WARN on the old_spte as well, because overwriting a
> REMOVED_SPTE in the non-atomic path is also disallowed (as evidence by
> lack of splats with the existing WARN).
> 
> Fixes: 08f07c800e9d ("KVM: x86/mmu: Flush TLBs after zap in TDP MMU PF handler")
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Mingwei Zhang <mizhang@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 8fbf3364f116..1dcdf1a4fcc1 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -640,13 +640,13 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  
>  	/*
> -	 * No thread should be using this function to set SPTEs to the
> +	 * No thread should be using this function to set SPTEs to or from the
>  	 * temporary removed SPTE value.
>  	 * If operating under the MMU lock in read mode, tdp_mmu_set_spte_atomic
>  	 * should be used. If operating under the MMU lock in write mode, the
>  	 * use of the removed SPTE should not be necessary.
>  	 */
> -	WARN_ON(is_removed_spte(iter->old_spte));
> +	WARN_ON(is_removed_spte(iter->old_spte) || is_removed_spte(new_spte));
>  
>  	kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
>  
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 
