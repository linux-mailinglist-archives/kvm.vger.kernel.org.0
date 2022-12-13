Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3AC064BBA3
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 19:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbiLMSME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 13:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbiLMSMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 13:12:03 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C8F38AC
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 10:12:02 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id n65-20020a17090a2cc700b0021bc5ef7a14so4475902pjd.0
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 10:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xYi2wzTmS91DztQJWezxrVaIvtUxCOobhUQC7IX33rE=;
        b=kzONbnqS8z1JFK2IXGaoi5GJ1pMCpT4PlXC5FNkIw6q63bTQvlcxZVIW6PmmNPFJ7k
         N2G7aePg8uGeKvZTxGksUo3W5fmyABmk90UxNaawnPN/wgR22eBiFbXGa0UUlXTFqVXG
         6HK26llME9zlneTl7iwUD8/2W4Inh5m6n25C4rMGRVU9sXr3B350R73dLotmClxPqqHN
         xbb6Q9ZqogS3kOrCcqeKYy7uBWf7Se7vxfBXeJzGi0cJuv/YWQjOSpRzlf7NXDXBhFdA
         zUKIrHHDTuRH+THLudLnEaEAA05w+JB1aaMxDrhwRckrbW/BLDveKaq+RgRmQuGm4GUW
         7bNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xYi2wzTmS91DztQJWezxrVaIvtUxCOobhUQC7IX33rE=;
        b=2SPM9aNucoZoHwyAf7bBMlIVcQ9AkfzWzxBVU9tTDj3qU0lK5c0dO9cDDnDCXsu3p2
         u07rQM0hCoSffXItBlgToGXCwcGTPzgD1cPX31xhlUc/XjYSiB3qEBJkV+U8x89ht0J2
         vMt8kteWKD8MrvhwnDFmDwyHcAoJ5y1PdV/w9b6s3dcYv8phpNTQWUXkaZDrujQqwuFq
         /cscolvPeAR8poIrKpra5z5oUY9ER6OtLD1qFaub4MKFVPVVeqM5eD0tNXjItSxLRtiG
         AM2FGIG4ncTDyqWQ7jF4EsmdUKzipPYpx00A5Kzf46ed4AX4rbrdBOT4ug6X5K1nn1MW
         QD3A==
X-Gm-Message-State: ANoB5pmjrUWFs/njbU/0SmYslzDHtCfam2fHw9vx6+yw6OjwsnNCAPmO
        MEGMuAh0ORGwafzxzyhLrAHiNg==
X-Google-Smtp-Source: AA0mqf44lsJ2QxarRPDgYalommUaCZ6IBecGxCtP56AfA+m5g0H4m391m+K+ZKD138lxt5j/42c8nQ==
X-Received: by 2002:a17:902:c381:b0:189:a3de:ea2d with SMTP id g1-20020a170902c38100b00189a3deea2dmr373519plg.2.1670955121681;
        Tue, 13 Dec 2022 10:12:01 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n15-20020a170902e54f00b00186ff402508sm154628plf.281.2022.12.13.10.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 10:12:00 -0800 (PST)
Date:   Tue, 13 Dec 2022 18:11:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] kvm: x86/mmu: Reduce the update to the spte in
 FNAME(sync_page)
Message-ID: <Y5jAbS4kwRAdrWwM@google.com>
References: <20221212153205.3360-1-jiangshanlai@gmail.com>
 <20221212153205.3360-2-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212153205.3360-2-jiangshanlai@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 12, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> Sometimes when the guest updates its pagetable, it adds only new gptes
> to it without changing any existed one, so there is no point to update
> the sptes for these existed gptes.
>
> Also when the sptes for these unchanged gptes are updated, the AD
> bits are also removed since make_spte() is called with prefetch=true
> which might result unneeded TLB flushing.

If either of the proposed changes is kept, please move this to a separate patch.
Skipping updates for PTEs with the same protections is separate logical change
from skipping updates when making the SPTE writable.

Actually, can't we just pass @prefetch=false to make_spte()?  FNAME(prefetch_invalid_gpte)
has already verified the Accessed bit is set in the GPTE, so at least for guest
correctness there's no need to access-track the SPTE.  Host page aging is already
fuzzy so I don't think there are problems there.

> Do nothing if the permissions are unchanged or only write-access is
> being added.

I'm pretty sure skipping the "make writable" case is architecturally wrong.  On a
#PF, any TLB entries for the faulting virtual address are required to be removed.
That means KVM _must_ refresh the SPTE if a vCPU takes a !WRITABLE fault on an
unsync page.  E.g. see kvm_inject_emulated_page_fault().

> Only update the spte when write-access is being removed.  Drop the SPTE
> otherwise.

Correctness aside, there needs to be far more analysis and justification for a
change like this, e.g. performance numbers for various workloads.

> ---
>  arch/x86/kvm/mmu/paging_tmpl.h | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index e5662dbd519c..613f043a3e9e 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -1023,7 +1023,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
>  		u64 *sptep, spte;
>  		struct kvm_memory_slot *slot;
> -		unsigned pte_access;
> +		unsigned old_pte_access, pte_access;
>  		pt_element_t gpte;
>  		gpa_t pte_gpa;
>  		gfn_t gfn;
> @@ -1064,6 +1064,23 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  			continue;
>  		}
>  
> +		/*
> +		 * Drop the SPTE if the new protections would result in access
> +		 * permissions other than write-access is changing.  Do nothing
> +		 * if the permissions are unchanged or only write-access is
> +		 * being added.  Only update the spte when write-access is being
> +		 * removed.
> +		 */
> +		old_pte_access = kvm_mmu_page_get_access(sp, i);
> +		if (old_pte_access == pte_access ||
> +		    (old_pte_access | ACC_WRITE_MASK) == pte_access)
> +			continue;
> +		if (old_pte_access != (pte_access | ACC_WRITE_MASK)) {
> +			drop_spte(vcpu->kvm, &sp->spt[i]);
> +			flush = true;
> +			continue;
> +		}
> +
>  		/* Update the shadowed access bits in case they changed. */
>  		kvm_mmu_page_set_access(sp, i, pte_access);
>  
> -- 
> 2.19.1.6.gb485710b
> 
