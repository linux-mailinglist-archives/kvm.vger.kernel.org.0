Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA7D57AA61
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 01:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiGSXVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 19:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbiGSXVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 19:21:39 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEEA3D5B3
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 16:21:38 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id l124so14983093pfl.8
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 16:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v93qZgUDtdRXnHCVUsKcMneA8OJvr6RqrJM3Q32wDgQ=;
        b=tb5js8lawIeztvJzLz9iz3P+PFAxnz394ahnkedmOlU6D1yIudSmusUnR92MBtF3AB
         5G44x35fzqxlemVkDBRvgkLEWNorb1/qNb/dXorxTILgIah9EpONxyxcR+f1qS+9aj6J
         9aarj3+XrjKnwq1leyzxZd4zUV8yluegB93W3DFkz80PvBFo7Sz2O5VW5mWYOmSX5vAQ
         yKEpUZgf7eHajP3UkmEbRHtU64QebRWUWOL2MrNAMzmEfde2dLDtnKT6sqk7XTgvxc81
         Nd8bppq47owBZTKCyDOse1V2Yb1upv1xfaZEpP04BwWmNgOKNmOdpzxs5ek+X9N/F8e8
         hN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v93qZgUDtdRXnHCVUsKcMneA8OJvr6RqrJM3Q32wDgQ=;
        b=4b2TJvPUZQgtVWX+FI1cayHkFBpAhYyzBGXNLK0HWEUyO5jpvRGTPYQ3fRkVgkJQZD
         aqN5uPJQooQ45044rln5iDzkm4+zyFwwTfCHGyLkvVkjoos47IomlL3AoyOhlvbXaNN6
         nZRuVNb1x+tIWYeU2GF26n7+e2C+5OEr3mg9IiCMquAvS7fyvGHPrA1oROrbP0+pyi6T
         V3NJnAoLWesNm6fqEfvZQ+JJMMmn/ikef3jyrk47UzZGv1C+dZaXWJy1UyyM9IOzubgO
         ZJl35gGsYTQFBkrAN5hkGT4CVV3TXswddQ6DK6g+qTIwg7vIrHUfAV+sJpV/DAEYdrbj
         Vq/w==
X-Gm-Message-State: AJIora9tvSf42to7YzfiZaRvuoB74DSX+EQENA7PyE0/jtv+xKQMUaWg
        sscZiEE6mEcaYssJUC/2lJhLew==
X-Google-Smtp-Source: AGRyM1uaAXlPc2sBh6+WfYJ7/Ev2bkwV4bCZsaitx6DqYTOdrOf4Wu2XjSWCXxrM4yirDFYeR++Jsw==
X-Received: by 2002:a63:4613:0:b0:40d:91e2:e9bf with SMTP id t19-20020a634613000000b0040d91e2e9bfmr31396205pga.235.1658272897626;
        Tue, 19 Jul 2022 16:21:37 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id mi14-20020a17090b4b4e00b001f2184008c7sm9524pjb.53.2022.07.19.16.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 16:21:37 -0700 (PDT)
Date:   Tue, 19 Jul 2022 23:21:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH V3 09/12] KVM: X86/MMU: Move the verifying of NPT's PDPTE
 in FNAME(fetch)
Message-ID: <Ytc8fZL2WU4u2x6j@google.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
 <20220521131700.3661-10-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521131700.3661-10-jiangshanlai@gmail.com>
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
> 
> FNAME(page_fault) verifies PDPTE for nested NPT in PAE paging mode
> because nested_svm_get_tdp_pdptr() reads the guest NPT's PDPTE from
> memory unconditionally for each call.
> 
> The verifying is complicated and it works only when mmu->pae_root
> is always used when the guest is PAE paging.

Why is this relevant?  It's not _that_ complicated, and even if it were, I don't
see how calling that out helps the reader understand the motivation for this patch.

> Move the verifying code in FNAME(fetch) and simplify it since the local
> shadow page is used and it can be walked in FNAME(fetch) and unlinked
> from children via drop_spte().
> 
> It also allows for mmu->pae_root NOT to be used when it is NOT required

Avoid leading with pronous, "it" is ambiguous, e.g. at first I thought "it' meant
moving the code, but what "it" really means is using the iterator from the shadow
page walk instead of hardcoding a pae_root lookup.

And changing from pae_root to it.sptep needs to be explicitly called out.  It's
a subtle but important detail.  And if you call that out, then it's more obvious
why this patch is relevant to not having to use pae_root for a 64-bit host with NPT.

> to be put in a 32bit CR3.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/paging_tmpl.h | 72 ++++++++++++++++------------------
>  1 file changed, 33 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index cd6032e1947c..67c419bce1e5 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -659,6 +659,39 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  		clear_sp_write_flooding_count(it.sptep);
>  		drop_large_spte(vcpu, it.sptep);
>  
> +		/*
> +		 * When nested NPT enabled and L1 is PAE paging,
> +		 * mmu->get_pdptrs() which is nested_svm_get_tdp_pdptr() reads
> +		 * the guest NPT's PDPTE from memory unconditionally for each
> +		 * call.
> +		 *
> +		 * The guest PAE root page is not write-protected.
> +		 *
> +		 * The mmu->get_pdptrs() in FNAME(walk_addr_generic) might get
> +		 * a value different from previous calls or different from the
> +		 * return value of mmu->get_pdptrs() in mmu_alloc_shadow_roots().
> +		 *
> +		 * It will cause the following code installs the spte in a wrong
> +		 * sp or links a sp to a wrong parent if the return value of
> +		 * mmu->get_pdptrs() is not verified unchanged since
> +		 * FNAME(gpte_changed) can't check this kind of change.
> +		 *
> +		 * Verify the return value of mmu->get_pdptrs() (only the gfn
> +		 * in it needs to be checked) and drop the spte if the gfn isn't
> +		 * matched.
> +		 *
> +		 * Do the verifying unconditionally when the guest is PAE
> +		 * paging no matter whether it is nested NPT or not to avoid
> +		 * complicated code.
> +		 */
> +		if (vcpu->arch.mmu->cpu_role.base.level == PT32E_ROOT_LEVEL &&
> +		    it.level == PT32E_ROOT_LEVEL &&
> +		    is_shadow_present_pte(*it.sptep)) {
> +			sp = to_shadow_page(*it.sptep & PT64_BASE_ADDR_MASK);

For this patch, it's probably worth a

			WARN_ON_ONCE(sp->spt != vcpu->arch.mmu->pae_root);

Mostly so that when the future patch stops using pae_root for 64-bit NPT hosts,
there's a code change for this particular logic that is very much relevant to
that change.

> +			if (gw->table_gfn[it.level - 2] != sp->gfn)
> +				drop_spte(vcpu->kvm, it.sptep);
> +		}
