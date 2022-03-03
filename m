Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3EB24CC48E
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 19:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbiCCSDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 13:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbiCCSDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 13:03:46 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C531D58E53
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 10:03:00 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id o8so5194054pgf.9
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 10:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wXD0lhGUV6Vx3hh95xkovDLgtCU6APmz+b2GdNRK/RE=;
        b=FJGxFbCw7rR/LPeZm/NArRHGbcHesjph3Kn69m3nm4Ldw+bkSYNkB9UDLmP2cLig+3
         0Cas7VySBXv/Qia8DpH6SN4hcCxp1d9oUaSqjwH7Bcpw/9WfqrQTMpJIlS8ay8nejHQI
         aNvsrbWJzHi5lYbNkVPet7DtSxiWXOKRNNnEyEWmVz7H1eqXV5CR4TvD4rD6yg3V+2Q1
         vaMxCup0T74m95+9RcrL3WxXlgtPKg/k+OqiNJ28BmNC7/3udEXINC60cK6h87hY6wdO
         HmhLodYFKRjUokEQOLdujdsdQOBI7sVAEM26SmVbRejKhcUrDeBdpbZyRXJrel+Q+Iqm
         Gm9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wXD0lhGUV6Vx3hh95xkovDLgtCU6APmz+b2GdNRK/RE=;
        b=dBsjd2TSt3zqlUp5XH/1bhW8KtaFT3q2ip2QrWmaChSvXKvfdWYjgkA2BB0BiqSuzg
         CSV7e6PtklhzLj1UHoP2eER+aHngnNdNkcTI9XndcA2R3BmqkITJBvU5dgwD8hyOi7Sf
         Xx5xOxcG1Dt2obwAOfJdYiJV4Zy0PFkN5DHAfLrU2sYPS9uYZ/Jwvp096ace3wGGw0/M
         egyAb1rrNnpkOF/1izvNsod3LCLHSvmnTTLFdF/bHoFgZpV73zSztexCepc5nPKUQU/D
         jUpY+GyhX/q1eIDu473ZQmc68EpVMQ1Fb7a41httZYyQXcOZhQ7ooPyGyq5W7ls9LmAY
         XlDg==
X-Gm-Message-State: AOAM531eXv40dVs2+8HLoQJHTUkbBKZGRT5PqjIcnf5jez8FLs10wE5Y
        RjpCLINYr+TodbMObXaET5Ov4Q==
X-Google-Smtp-Source: ABdhPJwyyVoqEon5C25c9UJr9TiVongdLYU8rJ02W4Fdis8eick2r/9zAfe+AM1teTuAyCKBFX08lA==
X-Received: by 2002:a63:5124:0:b0:375:9f87:f881 with SMTP id f36-20020a635124000000b003759f87f881mr28381432pgb.578.1646330579563;
        Thu, 03 Mar 2022 10:02:59 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id h22-20020a056a001a5600b004f41a2a6cf9sm3060866pfv.134.2022.03.03.10.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:02:59 -0800 (PST)
Date:   Thu, 3 Mar 2022 18:02:55 +0000
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
Subject: Re: [PATCH v3 07/28] KVM: x86/mmu: Check for !leaf=>leaf, not PFN
 change, in TDP MMU SP removal
Message-ID: <YiECz6ZB+wuzMomy@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-8-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226001546.360188-8-seanjc@google.com>
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
> Look for a !leaf=>leaf conversion instead of a PFN change when checking
> if a SPTE change removed a TDP MMU shadow page.  Convert the PFN check
> into a WARN, as KVM should never change the PFN of a shadow page (except
> when its being zapped or replaced).
> 
> From a purely theoretical perspective, it's not illegal to replace a SP
> with a hugepage pointing at the same PFN.  In practice, it's impossible
> as that would require mapping guest memory overtop a kernel-allocated SP.
> Either way, the check is odd.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 189f21e71c36..848448b65703 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -505,9 +505,12 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  
>  	/*
>  	 * Recursively handle child PTs if the change removed a subtree from
> -	 * the paging structure.
> +	 * the paging structure.  Note the WARN on the PFN changing without the
> +	 * SPTE being converted to a hugepage (leaf) or being zapped.  Shadow
> +	 * pages are kernel allocations and should never be migrated.
>  	 */
> -	if (was_present && !was_leaf && (pfn_changed || !is_present))
> +	if (was_present && !was_leaf &&
> +	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
>  		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
>  }
>  
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 
