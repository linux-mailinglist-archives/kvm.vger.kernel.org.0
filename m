Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282125FDCE9
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 17:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiJMPPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 11:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiJMPPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 11:15:32 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43541BC62B;
        Thu, 13 Oct 2022 08:15:28 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e733329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e733:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CF5B01EC064E;
        Thu, 13 Oct 2022 17:15:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1665674122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=BxnWw47WYQ2Rd0ryZEoZGtMXC47/yHMYat/iIrPgZcw=;
        b=afoCRuEWH+GTymUBeY2g6XheR8ovjS20OpCNHyMXhtOOr0NLl4oHSxCq6HnUtLkdAxg9zf
        GHDQQ2HadRqEIdaMl3VtOQKtHzKaIoPY7Pk1Hp4F/7Y/4BA+z2YbWUwg16pSniaeTsYX6c
        ZfNiSxF6r9SRNWZOAaxx48DAJASLFT0=
Date:   Thu, 13 Oct 2022 17:15:18 +0200
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
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Message-ID: <Y0grhk1sq2tf/tUl@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:05:01PM +0000, Ashish Kalra wrote:
> +static void snp_leak_pages(unsigned long pfn, unsigned int npages)

That function name looks wrong.

> +{
> +	WARN(1, "psc failed, pfn 0x%lx pages %d (leaking)\n", pfn, npages);
> +	while (npages--) {
> +		memory_failure(pfn, 0);
		^^^^^^^^^^^^^^^^^^^^^^

Why?

 * This function is called by the low level machine check code
 * of an architecture when it detects hardware memory corruption
 * of a page. It tries its best to recover, which includes
 * dropping pages, killing processes etc.

I don't think you wanna do that.

It looks like you want to prevent the page from being used again but not
mark it as PG_hwpoison and whatnot. PG_reserved perhaps?

> +		dump_rmpentry(pfn);
> +		pfn++;
> +	}
> +}
> +
> +static int snp_reclaim_pages(unsigned long pfn, unsigned int npages, bool locked)
> +{
> +	struct sev_data_snp_page_reclaim data;
> +	int ret, err, i, n = 0;
> +
> +	for (i = 0; i < npages; i++) {
> +		memset(&data, 0, sizeof(data));
> +		data.paddr = pfn << PAGE_SHIFT;

Oh wow, this is just silly. A struct for a single u64. Just use a

	u64 paddr;

directly. But we had this topic already...

> +
> +		if (locked)

Ew, that's never a good design - conditional locking.

> +			ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +		else
> +			ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);

<---- newline here.

> +		if (ret)
> +			goto cleanup;
> +
> +		ret = rmp_make_shared(pfn, PG_LEVEL_4K);
> +		if (ret)
> +			goto cleanup;
> +
> +		pfn++;
> +		n++;
> +	}
> +
> +	return 0;
> +
> +cleanup:
> +	/*
> +	 * If failed to reclaim the page then page is no longer safe to
> +	 * be released, leak it.
> +	 */
> +	snp_leak_pages(pfn, npages - n);

So this looks real weird: we go and reclaim pages, we hit an error
during reclaiming a page X somewhere in-between and then we go and mark
the *remaining* pages as not to be used?!

Why?

Why not only that *one* page which failed and then we continue with the
rest?!

> +	return ret;
> +}
> +
> +static inline int rmp_make_firmware(unsigned long pfn, int level)
> +{
> +	return rmp_make_private(pfn, 0, level, 0, true);
> +}

That's a silly wrapper used only once. Just do at the callsite:

	/* Mark this page as belonging to firmware */
	rc = rmp_make_private(pfn, 0, level, 0, true);

> +
> +static int snp_set_rmp_state(unsigned long paddr, unsigned int npages, bool to_fw, bool locked,
> +			     bool need_reclaim)

Tangential to the above, this is just nuts with those bool arguments.
Just look at the callsites: do you understand what they do?

	snp_set_rmp_state(paddr, npages, true, locked, false);

what does that do? You need to go up to the definition of the function,
count the arguments and see what that "true" arg stands for.

What you should do instead is, have separate helpers which do only one
thing:

	rmp_mark_pages_firmware();
	rmp_mark_pages_shared();
	rmp_mark_pages_...

and then have the *callers* issue snp_reclaim_pages() when needed. So you'd have

	rmp_mark_pages_firmware();
	rmp_mark_pages_shared()

and __snp_free_firmware_pages() would do

	rmp_mark_pages_shared();
	snp_reclaim_pages();

and so on.

And then if you need locking, the callers can decide which sev_do_cmd
variant to issue.

And then if you have common code fragments which you can unify into a
bigger helper function, *then* you can do that.

Instead of multiplexing it this way. Which makes it really hard to
follow what the code does.


> +	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT; /* Cbit maybe set in the paddr */

No side comments pls.

> +	int rc, n = 0, i;
> +
> +	for (i = 0; i < npages; i++) {
> +		if (to_fw)
> +			rc = rmp_make_firmware(pfn, PG_LEVEL_4K);
> +		else
> +			rc = need_reclaim ? snp_reclaim_pages(pfn, 1, locked) :
> +					    rmp_make_shared(pfn, PG_LEVEL_4K);
> +		if (rc)
> +			goto cleanup;
> +
> +		pfn++;
> +		n++;
> +	}
> +
> +	return 0;
> +
> +cleanup:
> +	/* Try unrolling the firmware state changes */
> +	if (to_fw) {
> +		/*
> +		 * Reclaim the pages which were already changed to the
> +		 * firmware state.
> +		 */
> +		snp_reclaim_pages(paddr >> PAGE_SHIFT, n, locked);
> +
> +		return rc;
> +	}
> +
> +	/*
> +	 * If failed to change the page state to shared, then its not safe
> +	 * to release the page back to the system, leak it.
> +	 */
> +	snp_leak_pages(pfn, npages - n);
> +
> +	return rc;
> +}

...

> +void snp_free_firmware_page(void *addr)
> +{
> +	if (!addr)
> +		return;
> +
> +	__snp_free_firmware_pages(virt_to_page(addr), 0, false);
> +}
> +EXPORT_SYMBOL(snp_free_firmware_page);

EXPORT_SYMBOL_GPL() ofc.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
