Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667745B0BCB
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 19:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiIGRvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 13:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiIGRvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 13:51:03 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91D96EF04
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 10:51:02 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id g4so301039pgc.0
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 10:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=t2UVCZIkN3IwB0SpdzJMa+gH2wnhttedu9ICdE2/3xw=;
        b=MuuvkJV6NkTdL1mw5xuXvCfauzApb4WfEGbK5Z7oVaafwQ9jOSXF6E3GFCkj74JctM
         glDB56Cmk6wFnxwZCOBhLPDVzQBGbYt36bIE3lmVvBRdVri8zffZxDPflnAq/NeDgYgi
         P1ryPHN3fMojqSbtIb9PhOsDWo/wwfqIsL8DTkW1+vQ1kpUs8k/r9kmNKyrCjXecn4Px
         pjsKG9ykttwZwk94MmoFtdD+7hliw0ZzSr5gtuyx6n5l9/v8HERrQfZ6D3r5a0nisD6J
         vMdU49let3CQH1baMikzD8QBa+Gatl7+nMO67TbDDEKuJDNxJZT7aQTjK+yGUl7rDr3F
         dnUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=t2UVCZIkN3IwB0SpdzJMa+gH2wnhttedu9ICdE2/3xw=;
        b=S3NOtw7bCFOmnlsPH0wtd8vD9tJJ+M2As8NA8sL6WapOI0gBc2COyDPgHVBcsWH5LI
         Hu83l5K6T11rpawOhiPfq6S7fpQiMsdr1Q3k+tHbz9czhT9Mgt3yysrvIlz6zYyo+zlc
         qr9IkLe46VbFHNIPPvUePbPPsdZ0iN135czOqPCUDHal1h/L+GBIhC5TpOe19LALPN3E
         AnT3bUCaqVBraONW/+fON1U47lcPDW9oGmdOFGeMq1l+IqdP0mXxgqIC8aTxeqN0hH2k
         ewxC13hVM3bCOHiN7OeLRR7tM1DRTUMTwFO5S7JjIPHcBtJxfsZUOEA0dwBJQGXnxA2g
         zY5w==
X-Gm-Message-State: ACgBeo3J5AYEo+eIjPSEYf+HbWA1m6HQMGUOdBhMa9vtCIxgGJBhpKsq
        C4rluqhSvzbfEFl53jtyLDRKkg==
X-Google-Smtp-Source: AA6agR7zwKyRchuDMpEwLtXFFWKWXDA2OFMH73FQZbfEcnLAviM33Gdp0WCO0LoPSC/DWFvFJnmenA==
X-Received: by 2002:a63:6909:0:b0:41c:9f4f:a63c with SMTP id e9-20020a636909000000b0041c9f4fa63cmr4561551pgc.76.1662573062060;
        Wed, 07 Sep 2022 10:51:02 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id g123-20020a625281000000b0053e483de200sm3677708pfb.73.2022.09.07.10.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 10:51:01 -0700 (PDT)
Date:   Wed, 7 Sep 2022 10:50:56 -0700
From:   David Matlack <dmatlack@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing
 in kvm_set_pte_rmapp()
Message-ID: <YxjaAI0i4czLuL4L@google.com>
References: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
 <4b6f39b9617ee9be9fcddeaa0afd754f21cf2e24.1661331396.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b6f39b9617ee9be9fcddeaa0afd754f21cf2e24.1661331396.git.houwenlong.hwl@antgroup.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022 at 05:29:19PM +0800, Hou Wenlong wrote:
> When the spte of hupe page is dropped in kvm_set_pte_rmapp(),
> the whole gfn range covered by the spte should be flushed.
> However, rmap_walk_init_level() doesn't align down the gfn
> for new level like tdp iterator does, then the gfn used in
> kvm_set_pte_rmapp() is not the base gfn of huge page. And
> the size of gfn range is wrong too for huge page. Use the
> base gfn of huge page and the size of huge page for
> flushing tlbs for huge page.
> 
> Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a3578abd8bbc..3bcff56df109 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1438,7 +1438,8 @@ static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>  	}
>  
>  	if (need_flush && kvm_available_flush_tlb_with_range()) {
> -		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
> +		kvm_flush_remote_tlbs_with_address(kvm, gfn & -KVM_PAGES_PER_HPAGE(level),

Rounding down the GFN to a huge page size is a common pattern throughout
KVM. Can you introduce a common way of doing this and clean up the other
call sites?

> +						   KVM_PAGES_PER_HPAGE(level));

This eventually gets converted to kvm_flush_remote_tlbs_gfn() in a later
patch; which is even more reason to introduce
kvm_flush_remote_tlbs_gfn() in the previous patch.

>  		return false;
>  	}
>  
> -- 
> 2.31.1
> 
