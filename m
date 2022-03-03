Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B424CC53B
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 19:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiCCSdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 13:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiCCSdY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 13:33:24 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9381F522DE
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 10:32:38 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id g7-20020a17090a708700b001bb78857ccdso8467838pjk.1
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 10:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qlq96R215BtY25bFBdaZHI6jV8wr7yu7isAUDVtrQE0=;
        b=qAfGtS76c92RQqU8Iu7Z5bVP+avIc0p+d2zENWbdn2G9bzL8wRAZa77fg3x4PC4SG8
         nnhLA6bqf1frGFlJoe9B4ilFPtAwKxRWT+ViTNtEiTQ4rnoZ1zzV9kC5nHYCEchPRVfW
         zFEzcSpmeeiA+j4AjC3h1FZ4W4hu51mKJT/YMdzohotDMndW6Fs4fD4uXssbYlFgdQ8i
         HIsMeWytVwJrgQ8LgwKqigJRePl7S6bhW8OFJO9acXsGKWlpEG4sk6Jl4gy3Dzjjsakc
         bB36HsveW28/R2iEtgxjhROweEiXlWXJLkCI6N9CyK1Ertupe2Rsb23JQLSpQgGPCkYZ
         7Z/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qlq96R215BtY25bFBdaZHI6jV8wr7yu7isAUDVtrQE0=;
        b=neKmYVQnf5t72Km0HxO4wo5HlJn1OAlE0ObRYqz+e4Yy+Io/Ta0haNVbbAhmd7b/OB
         lXg2B9rV4AonwiPcHdEhC+1eLa2V/Pg5a6QWPUHMkWmQ0eQwwmAuagay6uhhsZ78zapm
         I4RnN4SKcg29LjSokKKpwTfMnBgiiMpsBc5F61WufBp4lXyWqptWLdeafHZbO+TBpMMP
         lCBoYQUiuLe1iF0DUiDQKvAxYVhULtNW4EMcmpTyBw9OD+7oN2/X5yHeLESCkRPuNnfU
         kzKXf6wcvAuqzQ9jsbOrm/5SEnl1eIqMxss31xu4smayMu1tNPcuTr+9mM4wzAQOKSfK
         PGFg==
X-Gm-Message-State: AOAM531jNbkZx4UHRYT1OVN/btq5WwSuqvhoh+f+ZJBlT6ub7jT7onTK
        rSAi5INLGHkFx342iS5503PHGg==
X-Google-Smtp-Source: ABdhPJwyg/A9nYoWk0Ps+PUZ0B1bjHvXI3Xgmy5L95q6ZM17I2TvS4qW1peMROSqv+qmomJYnTLVYQ==
X-Received: by 2002:a17:902:8b87:b0:14b:47b3:c0a2 with SMTP id ay7-20020a1709028b8700b0014b47b3c0a2mr37003074plb.51.1646332357832;
        Thu, 03 Mar 2022 10:32:37 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id il17-20020a17090b165100b001bcd92fd355sm2932280pjb.28.2022.03.03.10.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:32:37 -0800 (PST)
Date:   Thu, 3 Mar 2022 18:32:33 +0000
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
Subject: Re: [PATCH v3 09/28] KVM: x86/mmu: Drop RCU after processing each
 root in MMU notifier hooks
Message-ID: <YiEJwT+o9DvPOu6H@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-10-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226001546.360188-10-seanjc@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 26, 2022, Sean Christopherson wrote:
> Drop RCU protection after processing each root when handling MMU notifier
> hooks that aren't the "unmap" path, i.e. aren't zapping.  Temporarily
> drop RCU to let RCU do its thing between roots, and to make it clear that
> there's no special behavior that relies on holding RCU across all roots.
> 
> Currently, the RCU protection is completely superficial, it's necessary
> only to make rcu_dereference() of SPTE pointers happy.  A future patch
> will rely on holding RCU as a proxy for vCPUs in the guest, e.g. to
> ensure shadow pages aren't freed before all vCPUs do a TLB flush (or
> rather, acknowledge the need for a flush), but in that case RCU needs to
> be held until the flush is complete if and only if the flush is needed
> because a shadow page may have been removed.  And except for the "unmap"
> path, MMU notifier events cannot remove SPs (don't toggle PRESENT bit,
> and can't change the PFN for a SP).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 634a2838e117..4f460782a848 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1100,18 +1100,18 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
>  	struct tdp_iter iter;
>  	bool ret = false;
>  
> -	rcu_read_lock();
> -
>  	/*
>  	 * Don't support rescheduling, none of the MMU notifiers that funnel
>  	 * into this helper allow blocking; it'd be dead, wasteful code.
>  	 */
>  	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
> +		rcu_read_lock();
> +
>  		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
>  			ret |= handler(kvm, &iter, range);
> -	}
>  
> -	rcu_read_unlock();
> +		rcu_read_unlock();
> +	}
>  
>  	return ret;
>  }
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 
