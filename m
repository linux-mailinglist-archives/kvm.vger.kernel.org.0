Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FC9596497
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 23:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbiHPV0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 17:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237602AbiHPV0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 17:26:01 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7178C03F
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 14:26:00 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c2so1977557plo.3
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 14:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=YW4gaI9bZ79ZEbN8yGf5ro64E62Sovy61NVVdY7Og44=;
        b=rqynHNggd2YUR1hHqfnY4kHE6q4l06wUxgKol2uk3AXZAkPKJ6GCA6i6JKCKU3TyOd
         ixAB1qYGxjp0hRNUKRyzKAl9Ybt4yVzKbU/GYN3+m1M0vFU6E6jup7BlUVby6RSLgn7S
         tX8hPasgNQXkoqLrBc/wIMRSt6hi5d5nkw3j5YPnRPJZlrq9JDfMw+f3ffMg5X5801D8
         jcBi0FeF/UDIZB1pn16sq9vu6AoNH/wucRvm03C58lmNVFdmxXj3AbIKS8Dlc3/keCFy
         hpiaVnAJI/9L17u9HdlQsLRZJ/bNVmmNR9b6pDQuWptQrBLIv7LlzVea72VXPpNhH2RA
         ZIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=YW4gaI9bZ79ZEbN8yGf5ro64E62Sovy61NVVdY7Og44=;
        b=h9HoAlOBD7O+zWvHSaZ0JoFm9RBTLvo1f5TdHAcn8382988PIOao5+ubxoprx74Jxb
         QOsU6Q75mXL6ufkdJrHVeiCdhzwKr3XH0Y5yx8aOkKMTHGGzPwO5Qe+fJmmCuFEMb35G
         lir1Ifixq9mZsQHeFvKxsIYDKXyRxA+wjpi/mpAphg+AOrjOYVHzEOI3ignlGO4dtXz8
         F74p5ivFVF75ypoo9a0YTbT1GvwIquM3JzuyCB4JmtevcBQHIHDgWCsjVNhMzEsoZpCh
         AoPbYwGuVZZpePARYXBeFGtwNJlJLxG/ou4bmlWxj63eNAqvJS+MciPIyTsQaXC0GnKs
         HEtg==
X-Gm-Message-State: ACgBeo2BVNfC+w7/wlQqE2ez1UkuFiIN0LYOkVtQIWSmIEaEzWKkJQIo
        RYpv9oDIIBiSTgkGv4q7PDDZsA==
X-Google-Smtp-Source: AA6agR5kWMjTJaLkP3cwLt1KNseoukitW2UCq4gW5ygNgbaN7LjIcqnHCzUwWtcp4JPm4ZCa19c0aQ==
X-Received: by 2002:a17:902:b948:b0:172:800a:cda8 with SMTP id h8-20020a170902b94800b00172800acda8mr4297396pls.90.1660685160253;
        Tue, 16 Aug 2022 14:26:00 -0700 (PDT)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id f9-20020a655509000000b0041d5001f0ecsm8194202pgr.43.2022.08.16.14.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:25:59 -0700 (PDT)
Date:   Tue, 16 Aug 2022 21:25:56 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>, y@google.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 4/8] KVM: x86/mmu: Properly account NX huge page
 workaround for nonpaging MMUs
Message-ID: <YvwLZJsCdqgDa18/@google.com>
References: <20220805230513.148869-1-seanjc@google.com>
 <20220805230513.148869-5-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805230513.148869-5-seanjc@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 05, 2022, Sean Christopherson wrote:
> Account and track NX huge pages for nonpaging MMUs so that a future
> enhancement to precisely check if a shadow page can't be replaced by a NX
> huge page doesn't get false positives.  Without correct tracking, KVM can
> get stuck in a loop if an instruction is fetching and writing data on the
> same huge page, e.g. KVM installs a small executable page on the fetch
> fault, replaces it with an NX huge page on the write fault, and faults
> again on the fetch.
> 
> Alternatively, and perhaps ideally, KVM would simply not enforce the
> workaround for nonpaging MMUs.  The guest has no page tables to abuse
> and KVM is guaranteed to switch to a different MMU on CR0.PG being
> toggled so there's no security or performance concerns.  However, getting
> make_spte() to play nice now and in the future is unnecessarily complex.
> 
> In the current code base, make_spte() can enforce the mitigation if TDP
> is enabled or the MMU is indirect, but make_spte() may not always have a
> vCPU/MMU to work with, e.g. if KVM were to support in-line huge page
> promotion when disabling dirty logging.
> 
> Without a vCPU/MMU, KVM could either pass in the correct information
> and/or derive it from the shadow page, but the former is ugly and the
> latter subtly non-trivial due to the possibility of direct shadow pages
> in indirect MMUs.  Given that using shadow paging with an unpaged guest
> is far from top priority _and_ has been subjected to the workaround since
> its inception, keep it simple and just fix the accounting glitch.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c  |  2 +-
>  arch/x86/kvm/mmu/spte.c | 12 ++++++++++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 53d0dafa68ff..345b6b22ab68 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3123,7 +3123,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			continue;
>  
>  		link_shadow_page(vcpu, it.sptep, sp);
> -		if (fault->is_tdp && fault->huge_page_disallowed)
> +		if (fault->huge_page_disallowed)
>  			account_nx_huge_page(vcpu->kvm, sp,
>  					     fault->req_level >= it.level);
>  	}
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 7314d27d57a4..52186b795bce 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -147,6 +147,18 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	if (!prefetch)
>  		spte |= spte_shadow_accessed_mask(spte);
>  
> +	/*
> +	 * For simplicity, enforce the NX huge page mitigation even if not
> +	 * strictly necessary.  KVM could ignore the mitigation if paging is
> +	 * disabled in the guest, as the guest doesn't have an page tables to
> +	 * abuse.  But to safely ignore the mitigation, KVM would have to
> +	 * ensure a new MMU is loaded (or all shadow pages zapped) when CR0.PG
> +	 * is toggled on, and that's a net negative for performance when TDP is
> +	 * enabled.  When TDP is disabled, KVM will always switch to a new MMU
> +	 * when CR0.PG is toggled, but leveraging that to ignore the mitigation
> +	 * would tie make_spte() further to vCPU/MMU state, and add complexity
> +	 * just to optimize a mode that is anything but performance critical.
> +	 */
>  	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
>  	    is_nx_huge_page_enabled(vcpu->kvm)) {
>  		pte_access &= ~ACC_EXEC_MASK;
> -- 
> 2.37.1.559.g78731f0fdb-goog
> 
