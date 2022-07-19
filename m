Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474C057A8D3
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 23:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbiGSVR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 17:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGSVR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 17:17:27 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34B35E83F
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 14:17:25 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gn24so1584739pjb.3
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 14:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cYVp/nlRdcsoI2H32MIQGQAodRMFGI+WBzT8OOmcyxw=;
        b=FN47cqTCWHvViTc/VanAjbyeK5K6/xJChcATpbdMDsb0p1T3Zx4YfI0Q6f4L36zHnv
         lCIs8nuOTgbW6Khw0Y4RDRBZj2T3P0KYDw/0Ha6zYO/rkeTK+VkCNfPa6+Miq8T+5Mzx
         Uix3Gaq6nUWrdzSk3/Ab2+UDCu5L7gIcqx3BmoPxzvQyqLw9EiJYZeliUxnL6h4LU1Qe
         6QosoYVrSXW16f28U2CoEgMmjiPDcMXgDL6dF4bWzoYPzxtRGCdWJ2N0C76RBszyUVdi
         QOZzWPZ58UrUZoYpA8UAnhTwc2DVZpeWmjJoufq43mVhO+HZJpf6D6bn1Prl+KauGQWk
         N8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cYVp/nlRdcsoI2H32MIQGQAodRMFGI+WBzT8OOmcyxw=;
        b=ZncaT1KemNAI2Nb0Q9xgLNb/qW5Gl0elRTpW2kumeBO4ikJn1icI7qJNhFhfuMXrU3
         1HdOSgC7uALE12QHSl34w0+1BWk1IwscWcEi77UgVtFP1V1ygobxFxEq8XFJMdl5SfbL
         /bEzgSdnebsjgkpfVwNL9AfSmKXxY+DQexfs8zJPw0pfQ5+xfScRN8YCYZXjwqXbdecL
         SJr37znWgEg+gPvA6tikMbWDrMowIN7kQ89P/pL3R7ZsLRCBggW/oLGBBUaf8DRXrcKj
         vBI7/HOmOikM3NBZJ5FqI9WV4rc2iPZLVeXRAXTPHN2VLaYfyAC454Y++hTkp+cwcJLW
         h39w==
X-Gm-Message-State: AJIora/CyJc0DgJSkW37dUdVgxGcrWn1GiV0zhVoZipn8njORfDHvTdI
        7opwUx2A9pc8DYDbj0IOWkpyag==
X-Google-Smtp-Source: AGRyM1vQ+mOFc9/lMSw5mfy4zUV1zKPzskN0dv4kT8A4Pl9S50UIMnNfHHa/aU5GQShALPY4SR8vBg==
X-Received: by 2002:a17:902:f788:b0:16c:f48b:905e with SMTP id q8-20020a170902f78800b0016cf48b905emr11466413pln.60.1658265445209;
        Tue, 19 Jul 2022 14:17:25 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id n17-20020a170902e55100b0016c1b178628sm12217292plf.269.2022.07.19.14.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 14:17:24 -0700 (PDT)
Date:   Tue, 19 Jul 2022 21:17:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH V3 01/12] KVM: X86/MMU: Verify PDPTE for nested NPT in
 PAE paging mode when page fault
Message-ID: <YtcfYX5KkF0ZhLR/@google.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
 <20220521131700.3661-2-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521131700.3661-2-jiangshanlai@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 21, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> Fixes: e4e517b4be01 ("KVM: MMU: Do not unconditionally read PDPTE from guest memory")
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/paging_tmpl.h | 39 ++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index db80f7ccaa4e..6e3df84e8455 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -870,6 +870,44 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	if (is_page_fault_stale(vcpu, fault, mmu_seq))
>  		goto out_unlock;
>  
> +	/*
> +	 * When nested NPT enabled and L1 is PAE paging, mmu->get_pdptrs()
> +	 * which is nested_svm_get_tdp_pdptr() reads the guest NPT's PDPTE
> +	 * from memory unconditionally for each call.
> +	 *
> +	 * The guest PAE root page is not write-protected.

I think it's worth calling out that it's simply not feasible to write-protect
PDPTEs due to them not covering a full page.

And looking at this comment as a whole, while I love detailed comments, I think
it'd be better off to avoid referring to mmu->get_pdptrs() and use more generic
terminology when talking about KVM.

I think this is accurate?

	/*
	 * If KVM is shadowing nested NPT and L1 is using PAE paging, zap the
	 * root for the PDPTE if the cached value doesn't match the entry at the
	 * time of the page fault, and resume the guest to rebuid the root.
	 * This is effectively a variation of write-protection, where the target
	 * SPTE(s) is zapped on use instead of on write.
	 *
	 * Under SVM with NPT+PAE, the CPU does NOT cache PDPTEs and instead
	 * handles them as it would any other page table entry.  I.e. KVM can't
	 * cache PDPTEs at nested VMRUN without violating the SVM architecture.
	 *
	 * KVM doesn't write-protect PDPTEs because CR3 only needs to be 32-byte
	 * aligned and sized when using PAE paging, whereas write-protection
	 * works at page granularity.
	 */

> +	 *
> +	 * The mmu->get_pdptrs() in FNAME(walk_addr_generic) might get a value
> +	 * different from previous calls or different from the return value of
> +	 * mmu->get_pdptrs() in mmu_alloc_shadow_roots().
> +	 *
> +	 * It will cause FNAME(fetch) installs the spte in a wrong sp or links
> +	 * a sp to a wrong parent if the return value of mmu->get_pdptrs()
> +	 * is not verified unchanged since FNAME(gpte_changed) can't check
> +	 * this kind of change.
> +	 *
> +	 * Verify the return value of mmu->get_pdptrs() (only the gfn in it
> +	 * needs to be checked) and do kvm_mmu_free_roots() like load_pdptr()
> +	 * if the gfn isn't matched.
> +	 *
> +	 * Do the verifying unconditionally when the guest is PAE paging no
> +	 * matter whether it is nested NPT or not to avoid complicated code.

Doing this unconditionally just trades one architecturally incorrect behavior
with another.  Does any real world use case actually care?  Probably not.  But the
behavior is visible to software, and I don't think it costs us much to get it right.

There are a number of ways to handle this, e.g. set a flag in kvm_init_shadow_npt_mmu()
and consume it here.  We could probably even burn a bit in kvm_mmu_extended_role
since we have lots of bits to burn.  E.g.

	if (vcpu->arch.mmu->cpu_role.ext.npt_pae) {

	}


> +	 */
> +	if (vcpu->arch.mmu->cpu_role.base.level == PT32E_ROOT_LEVEL) {
> +		u64 pdpte = vcpu->arch.mmu->pae_root[(fault->addr >> 30) & 3];
> +		struct kvm_mmu_page *sp = NULL;
> +
> +		if (IS_VALID_PAE_ROOT(pdpte))
> +			sp = to_shadow_page(pdpte & PT64_BASE_ADDR_MASK);
> +
> +		if (!sp || walker.table_gfn[PT32E_ROOT_LEVEL - 2] != sp->gfn) {
> +			write_unlock(&vcpu->kvm->mmu_lock);
> +			kvm_mmu_free_roots(vcpu->kvm, vcpu->arch.mmu,
> +					   KVM_MMU_ROOT_CURRENT);
> +			goto release_clean;
> +		}
> +	}
> +
>  	r = make_mmu_pages_available(vcpu);
>  	if (r)
>  		goto out_unlock;
> @@ -877,6 +915,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  
>  out_unlock:
>  	write_unlock(&vcpu->kvm->mmu_lock);
> +release_clean:
>  	kvm_release_pfn_clean(fault->pfn);
>  	return r;
>  }
> -- 
> 2.19.1.6.gb485710b
> 
