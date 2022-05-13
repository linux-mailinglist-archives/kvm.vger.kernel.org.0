Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DF8526D30
	for <lists+kvm@lfdr.de>; Sat, 14 May 2022 00:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384886AbiEMWxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 18:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351143AbiEMWxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 18:53:11 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AE61756B7
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 15:53:11 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d22so9262367plr.9
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 15:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GQcrUD+iS10OWB2IhvHVYLyHQumXXSUypBIwcEyZKqA=;
        b=hmGpvhMrmjZTe82jZGMH34s8ZMK8DhjPEZsAWOIQX9kjLF/JR9LLibbajKK2uSWBAV
         k7MAl1nQC1idFIml998Iqf/rm2g6m3cQEgWR5E+KPYi2/g0ady2z994cjhEJpIx1iGPR
         QpLYejtbBl7CTS1JQ0bl8F9YrlzAuGqHis3QNjm7uvX+78r1dB2QgxAxASqWX0gyfQLa
         qID4GVM+faLlv94xLNqQwFa20TwYQT2zjodjB00qnsZqgczQHzdNKQzpY96X/w4VEOQI
         hgxRO+mMyd9/kFJmj55nYOkqvt2QpcTsJ77Hyw8yOBRTdD0kKorFtKGmmtnbZD4NW2kc
         12wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GQcrUD+iS10OWB2IhvHVYLyHQumXXSUypBIwcEyZKqA=;
        b=gRLFNn72I7jmBELbzglHpUz26rWsMyfy+1z0pOVUN8i30ftoM5IvaJR6qcT3c8QPQU
         eCjrifSQGacn8bxn8cmHxRfL36RRio94VqaqZOXflo4Knad/MyW6kaPkUheohG68uc2W
         tx15O++20LIwSSfMHqrvqiprl+bmItE2C/lrOfNBStGFdIzyGM/agbetf+0/FI+D/vVt
         yBafYnI4XkLRjVt5z3815nfrS8jV1z2151njMiw92v6nyqhFmYFT/fr3OYjgzhv5aExY
         PFR1wYDZW4NfqteghYewDDR2MgDUeZEcIX4DS4aK73ntUeqU0p4R6SCYVi94S2v3NXm9
         hEsA==
X-Gm-Message-State: AOAM533eurhjQFIUg0w0fKfTT7B/tsdT+0t+Hm66NNd6TdcFrOd8KRuB
        7v2zh8XGs9+0xjKCnuLIMcoGxg==
X-Google-Smtp-Source: ABdhPJxJVbTMNcQuqiRTOOsbpuFUv31e2qxiTCyjhM4qde2iDexBVBq/3c+M5f5uikLi6Un4GqFQvQ==
X-Received: by 2002:a17:90b:3445:b0:1d6:91a5:29fe with SMTP id lj5-20020a17090b344500b001d691a529femr18230208pjb.138.1652482390246;
        Fri, 13 May 2022 15:53:10 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id b10-20020a170902650a00b0015e8d4eb269sm2289156plk.179.2022.05.13.15.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 15:53:09 -0700 (PDT)
Date:   Fri, 13 May 2022 22:53:05 +0000
From:   David Matlack <dmatlack@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH V2 1/7] KVM: X86/MMU: Add using_special_root_page()
Message-ID: <Yn7hUe9nyey/CS3J@google.com>
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
 <20220503150735.32723-2-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503150735.32723-2-jiangshanlai@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 03, 2022 at 11:07:29PM +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> In some case, special roots are used in mmu.  It is often using
> to_shadow_page(mmu->root.hpa) to check if special roots are used.
> 
> Add using_special_root_page() to directly check if special roots are
> used or needed to be used even mmu->root.hpa is not set.
> 
> Prepare for making to_shadow_page(mmu->root.hpa) return non-NULL via
> using special shadow pages.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 909372762363..7f20796af351 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1711,6 +1711,14 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
>  	mmu_spte_clear_no_track(parent_pte);
>  }
>  
> +static bool using_special_root_page(struct kvm_mmu *mmu)

Could you enumerate all the scenarios that use special roots and which
roots are the special ones? I think that would help a lot with reviewing
this series and would be useful to encode in a comment, probably above
this function here, for future readers.

Also the term "special" is really vague. Maybe once you enumerate all
the scenarios a common theme will arise and we can pick a better name,
unless you have any ideas off the top of your head.

> +{
> +	if (mmu->root_role.direct)
> +		return mmu->root_role.level == PT32E_ROOT_LEVEL;
> +	else
> +		return mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL;
> +}
> +
>  static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
>  {
>  	struct kvm_mmu_page *sp;
> @@ -4241,10 +4249,10 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
>  {
>  	/*
>  	 * For now, limit the caching to 64-bit hosts+VMs in order to avoid
> -	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
> -	 * later if necessary.
> +	 * having to deal with PDPTEs.  Special roots can not be put into
> +	 * mmu->prev_roots[].
>  	 */
> -	if (VALID_PAGE(mmu->root.hpa) && !to_shadow_page(mmu->root.hpa))
> +	if (VALID_PAGE(mmu->root.hpa) && using_special_root_page(mmu))
>  		kvm_mmu_free_roots(kvm, mmu, KVM_MMU_ROOT_CURRENT);
>  
>  	if (VALID_PAGE(mmu->root.hpa))
> -- 
> 2.19.1.6.gb485710b
> 
