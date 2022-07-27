Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8AA583153
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 19:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243123AbiG0R5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 13:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238698AbiG0R51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 13:57:27 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AAF6B247;
        Wed, 27 Jul 2022 10:01:44 -0700 (PDT)
Received: from zn.tnic (p200300ea970f4fe3329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:970f:4fe3:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F050F1EC04DA;
        Wed, 27 Jul 2022 19:01:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1658941298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=RWJzFBq0WyV6tQ+ZqLZ1AEB5KdQiAYWTFZnp9js+IYk=;
        b=E1jfg4k4GTyDy4tx4WSwNylGy++reaewl6nh/UZAIdvOu54O6BrtIP6SOogm1scyjOXkAm
        8OhwlXGLsnG/RMNgmC8aGcjmXcdcrTMVKMEdygb4vDnz8FHsZzd0q5O65TP4M8EaAActq7
        gUMbQ6dBJ9jj5WGbPtQGg33bagoOLwQ=
Date:   Wed, 27 Jul 2022 19:01:34 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 07/49] x86/sev: Invalid pages from direct map
 when adding it to RMP table
Message-ID: <YuFvbm/Zck9Tr5pq@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:03:07PM +0000, Ashish Kalra wrote:

> Subject: x86/sev: Invalid pages from direct map when adding it to RMP table

"...: Invalidate pages from the direct map when adding them to the RMP table"

> +static int restore_direct_map(u64 pfn, int npages)
> +{
> +	int i, ret = 0;
> +
> +	for (i = 0; i < npages; i++) {
> +		ret = set_direct_map_default_noflush(pfn_to_page(pfn + i));

set_memory_p() ?

> +		if (ret)
> +			goto cleanup;
> +	}
> +
> +cleanup:
> +	WARN(ret > 0, "Failed to restore direct map for pfn 0x%llx\n", pfn + i);

Warn for each pfn?!

That'll flood dmesg mightily.

> +	return ret;
> +}
> +
> +static int invalid_direct_map(unsigned long pfn, int npages)
> +{
> +	int i, ret = 0;
> +
> +	for (i = 0; i < npages; i++) {
> +		ret = set_direct_map_invalid_noflush(pfn_to_page(pfn + i));

As above, set_memory_np() doesn't work here instead of looping over each
page?

> @@ -2462,11 +2494,38 @@ static int rmpupdate(u64 pfn, struct rmpupdate *val)
>  	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>  		return -ENXIO;
>  
> +	level = RMP_TO_X86_PG_LEVEL(val->pagesize);
> +	npages = page_level_size(level) / PAGE_SIZE;
> +
> +	/*
> +	 * If page is getting assigned in the RMP table then unmap it from the
> +	 * direct map.
> +	 */
> +	if (val->assigned) {
> +		if (invalid_direct_map(pfn, npages)) {
> +			pr_err("Failed to unmap pfn 0x%llx pages %d from direct_map\n",

"Failed to unmap %d pages at pfn 0x... from the direct map\n"

> +			       pfn, npages);
> +			return -EFAULT;
> +		}
> +	}
> +
>  	/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
>  	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
>  		     : "=a"(ret)
>  		     : "a"(paddr), "c"((unsigned long)val)
>  		     : "memory", "cc");
> +
> +	/*
> +	 * Restore the direct map after the page is removed from the RMP table.
> +	 */
> +	if (!ret && !val->assigned) {
> +		if (restore_direct_map(pfn, npages)) {
> +			pr_err("Failed to map pfn 0x%llx pages %d in direct_map\n",

"Failed to map %d pages at pfn 0x... into the direct map\n"

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
