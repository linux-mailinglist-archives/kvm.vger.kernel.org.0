Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AD857E0F6
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 13:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbiGVLni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 07:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiGVLni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 07:43:38 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CC7B5C90;
        Fri, 22 Jul 2022 04:43:37 -0700 (PDT)
Received: from zn.tnic (p200300ea97297665329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9729:7665:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 44D461EC0666;
        Fri, 22 Jul 2022 13:43:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1658490211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ksPuM1kYKnp5lVqg/WP+CGQc5Ka79BDAGC9xOepY/I8=;
        b=mW4n+A9CpNvcdQwAqKcXgvmWOsDSsNK3ZD5SmnfCZUkjkfe4FTPiMGByOVdN9xu29mX4vg
        pFroZSFFP4rbGAhPtmfUnFmR9JtI+IhRnclmU7b32N1MUY18t1EisNbMnXk5rhk37BO1X8
        3cSBJR8ssvT+wIkx5YmH4eak7buGyi4=
Date:   Fri, 22 Jul 2022 13:43:30 +0200
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
Subject: Re: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Message-ID: <YtqNYudg6uj6Rlem@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:02:33PM +0000, Ashish Kalra wrote:
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 25c7feb367f6..59e7ec6b0326 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -65,6 +65,8 @@
>   * bookkeeping, the range need to be added during the RMP entry lookup.
>   */
>  #define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
> +#define RMPENTRY_SHIFT			8
> +#define rmptable_page_offset(x)	(RMPTABLE_CPU_BOOKKEEPING_SZ + (((unsigned long)x) >> RMPENTRY_SHIFT))
>  
>  /* For early boot hypervisor communication in SEV-ES enabled guests */
>  static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
> @@ -2386,3 +2388,44 @@ static int __init snp_rmptable_init(void)
>   * available after subsys_initcall().
>   */
>  fs_initcall(snp_rmptable_init);
> +
> +static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
> +{
> +	unsigned long vaddr, paddr = pfn << PAGE_SHIFT;
> +	struct rmpentry *entry, *large_entry;
> +
> +	if (!pfn_valid(pfn))
> +		return ERR_PTR(-EINVAL);
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return ERR_PTR(-ENXIO);

That test should happen first.

> +	vaddr = rmptable_start + rmptable_page_offset(paddr);

Wait, what does that macro do?

It takes the physical address and gives the offset from the beginning of
the RMP table in VA space?

So why don't you do

	entry = rmptable_entry(paddr)

instead which simply gives you directly the entry in the RMP table with
which you can work further?

Instead of this macro doing half the work and then callers having to add
the RMP start address and cast.

And make it small function so that you can have typechecking too, while
at it.

> +	if (unlikely(vaddr > rmptable_end))
> +		return ERR_PTR(-ENXIO);
> +
> +	entry = (struct rmpentry *)vaddr;
> +
> +	/* Read a large RMP entry to get the correct page level used in RMP entry. */
> +	vaddr = rmptable_start + rmptable_page_offset(paddr & PMD_MASK);
> +	large_entry = (struct rmpentry *)vaddr;
> +	*level = RMP_TO_X86_PG_LEVEL(rmpentry_pagesize(large_entry));
> +
> +	return entry;
> +}
> +
> +/*
> + * Return 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
> + * and -errno if there is no corresponding RMP entry.
> + */
> +int snp_lookup_rmpentry(u64 pfn, int *level)
> +{
> +	struct rmpentry *e;
> +
> +	e = __snp_lookup_rmpentry(pfn, level);
> +	if (IS_ERR(e))
> +		return PTR_ERR(e);
> +
> +	return !!rmpentry_assigned(e);
> +}
> +EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
> diff --git a/include/linux/sev.h b/include/linux/sev.h
> new file mode 100644
> index 000000000000..1a68842789e1
> --- /dev/null
> +++ b/include/linux/sev.h

Why is this header in the linux/ namespace and not in arch/x86/ ?

All that stuff in here doesn't have any meaning outside of x86...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
