Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538764CC513
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 19:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbiCCSZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 13:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbiCCSZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 13:25:48 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E591E1A41C9
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 10:25:02 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id n15so5370548plf.4
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 10:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4ZWHmx7szIFAdemFtNlU8I4rxfNJcdbQ9/5ouoRecWo=;
        b=WQ0WjqaCorFcNDc/RJ6X12JdgR0t+nWufEwGfm4dkI+CiEmkvQO71QzvoTaH4xxevS
         y9ls4zJuMlR6qBtcE2lMqPWHJd0BRxESjEA0IzSDFRTmTMF+HBd2N+V8mdDnyN43rTRj
         GB+3ktwF1PPetBWSl2GXImn81fdfW+5EvgIL4uA3qfxGIYVb3/xpWG9Dkj7ZwhUiwsHx
         9pLPJ1R2L1IxIcAi7FcyPjGLrHCljPThSJZi92/aYFeceyyAa2bOw8jyLldfTATcosne
         LrEkdixwm7VVCUxr44fMK5b5iIawvZ/ZIhAlnZB4R/QP9OIll5Y/jnVEXzIJIyMkfalE
         CUpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4ZWHmx7szIFAdemFtNlU8I4rxfNJcdbQ9/5ouoRecWo=;
        b=QBym2liunwA9tLMA7VkmAAXY3DU4U1sFWrBK3KlATQTDr2W36mGrj3s5VIbAssxuvS
         wMTHsYqnukxY9MIyJmxkEd7TQChh+97hPL7lBBCnfK+qYbDxHMCYhxqb3B6VU4hs2Jlq
         x0k/CXhqnu+/mj0hCsgV8HeAgrTvUZ/3CHwFQDtAVz/zaRyga298tc1f8iht5GuvikvE
         8xSNTuFgWHznX0P3LeYyQH6At54Dv75dnBokjEJtVYeHeODg2b5DcM4r1WZ8xvJW2qaf
         96LCQvkWJnCTPQhWRtjgvXb4sAc2gcHmDQUgO/N6/n0RnWKpIA9CNja8mOqiqUVRct13
         Qo6Q==
X-Gm-Message-State: AOAM532Ra3BnenrVT8z1YsKSCc5nq21dgxgpn3gLvSlXzEoX0kHUbI4e
        cgQ5YYYFRDnlAGFfJIjj3bsVoQ==
X-Google-Smtp-Source: ABdhPJwnNrjdurM6slIPKmpmR7VuRUrAX6G36QZFx1mOQGB7tMEQh38sxM3MSj9uDd3wT/ZjLwaL2w==
X-Received: by 2002:a17:90b:4d90:b0:1be:f6a9:c4d0 with SMTP id oj16-20020a17090b4d9000b001bef6a9c4d0mr6617469pjb.129.1646331902176;
        Thu, 03 Mar 2022 10:25:02 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id g4-20020a625204000000b004f1063e3d6csm3076565pfb.125.2022.03.03.10.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:25:01 -0800 (PST)
Date:   Thu, 3 Mar 2022 18:24:58 +0000
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
Message-ID: <YiEH+jRUe/Iqfcts@google.com>
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
