Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C5037BDD0
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 15:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhELNQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 09:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhELNQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 09:16:53 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547CDC061574;
        Wed, 12 May 2021 06:15:45 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0bb8006edd94bc9370939d.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:b800:6edd:94bc:9370:939d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CF37F1EC0390;
        Wed, 12 May 2021 15:15:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1620825340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=HouaiwLB7JW0CgX0Su8EmjidxJaUq10O1en6i12M3XM=;
        b=ipCnfqxZwwjKD2MvlouQXF10zQ/O1Bkp/6cvunooS62Aj62G059gLZVyD+3kW04NkNGlf8
        HI+FXmRQ+v1OQfyIV2d7TsOJbom9i0mzPQQCw1sSUIM9ty1D/dFM+O+AMngMeQ90U2NUFv
        W1l7gvBtfbVrXBaV5UQoeu0Vjz4ErPs=
Date:   Wed, 12 May 2021 15:15:37 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <YJvU+RAvetAPT2XY@zn.tnic>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 03:58:43PM +0000, Ashish Kalra wrote:
> +static inline void notify_page_enc_status_changed(unsigned long pfn,
> +						  int npages, bool enc)
> +{
> +	PVOP_VCALL3(mmu.notify_page_enc_status_changed, pfn, npages, enc);
> +}

Now the question is whether something like that is needed for TDX, and,
if so, could it be shared by both.

Sean?

> +void notify_addr_enc_status_changed(unsigned long vaddr, int npages,
> +				    bool enc)

Let that line stick out.

> +{
> +#ifdef CONFIG_PARAVIRT
> +	unsigned long sz = npages << PAGE_SHIFT;
> +	unsigned long vaddr_end = vaddr + sz;
> +
> +	while (vaddr < vaddr_end) {
> +		int psize, pmask, level;
> +		unsigned long pfn;
> +		pte_t *kpte;
> +
> +		kpte = lookup_address(vaddr, &level);
> +		if (!kpte || pte_none(*kpte))
> +			return;

What does this mean exactly? On the first failure to lookup the address,
you return? Why not continue so that you can notify about the remaining
pages in [vaddr - vaddr_end)?

Also, what does it mean for the current range if the lookup fails?
Innocuous situation or do you need to signal it with a WARN or so?

> +
> +		pfn = pg_level_to_pfn(level, kpte, NULL);
> +		if (!pfn)
> +			continue;

Same here: if it hits the default case, wouldn't it make sense to
WARN_ONCE or so to catch potential misuse? Or better yet, the WARN_ONCE
should be in pg_level_to_pfn().

> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 16f878c26667..45e65517405a 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -2012,6 +2012,13 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>  	 */
>  	cpa_flush(&cpa, 0);
>  
> +	/*
> +	 * Notify hypervisor that a given memory range is mapped encrypted
> +	 * or decrypted. The hypervisor will use this information during the
> +	 * VM migration.
> +	 */
> +	notify_addr_enc_status_changed(addr, numpages, enc);

If you notify about a range then that function should be called

	notify_range_enc_status_changed

or so.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
