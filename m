Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87FA5775A0
	for <lists+kvm@lfdr.de>; Sun, 17 Jul 2022 12:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiGQKCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jul 2022 06:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGQKCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jul 2022 06:02:12 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF31D263A;
        Sun, 17 Jul 2022 03:02:09 -0700 (PDT)
Received: from zn.tnic (p200300ea97297694329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9729:7694:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 07EB11EC04E4;
        Sun, 17 Jul 2022 12:02:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1658052124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=pMBoFPf5zDKeGeoUjhUKzQOtOyWqwWe2PwvFxR7Ybz0=;
        b=VBdnYo50dmMvcVd+D94GdtPzBbGMJ6NxpJQtZVPOezfqfXJ6M5R3i+e/n8S9lpC18Nsq6u
        5uaMHBVqABfE/H2QVzI55teoCuxVFSn4P6jMP1ac/cgA13L9mu8cPoPjU16avwZutPkzQ6
        6+Mw4Wb1O6LHny7Va6tY063Rqcor2Og=
Date:   Sun, 17 Jul 2022 12:01:59 +0200
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
Subject: Re: [PATCH Part2 v6 03/49] x86/sev: Add the host SEV-SNP
 initialization support
Message-ID: <YtPeF0r69UbwNTMJ@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f4eef289aba5067582d0d3535299c22a4e5c4c4.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8f4eef289aba5067582d0d3535299c22a4e5c4c4.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:02:01PM +0000, Ashish Kalra wrote:
> +/*
> + * The first 16KB from the RMP_BASE is used by the processor for the
> + * bookkeeping, the range need to be added during the RMP entry lookup.

needs

> +static int __snp_enable(unsigned int cpu)
> +{
> +	u64 val;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return 0;
> +
> +	rdmsrl(MSR_AMD64_SYSCFG, val);
> +
> +	val |= MSR_AMD64_SYSCFG_SNP_EN;
> +	val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
> +
> +	wrmsrl(MSR_AMD64_SYSCFG, val);
> +
> +	return 0;
> +}
> +
> +static __init void snp_enable(void *arg)
> +{
> +	__snp_enable(smp_processor_id());
> +}

Get rid of that silly wrapper - you're not even using that @cpu argument.

> +static bool get_rmptable_info(u64 *start, u64 *len)
> +{
> +	u64 calc_rmp_sz, rmp_sz, rmp_base, rmp_end, nr_pages;
> +
> +	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
> +	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
> +
> +	if (!rmp_base || !rmp_end) {
> +		pr_info("Memory for the RMP table has not been reserved by BIOS\n");

pr_err

> +		return false;
> +	}
> +
> +	rmp_sz = rmp_end - rmp_base + 1;
> +
> +	/*
> +	 * Calculate the amount the memory that must be reserved by the BIOS to
> +	 * address the full system RAM. The reserved memory should also cover the

"... address the whole RAM."

> +	 * RMP table itself.
> +	 *
> +	 * See PPR Family 19h Model 01h, Revision B1 section 2.1.4.2 for more
> +	 * information on memory requirement.

That section number will change over time - if you want to refer to some
section just use its title so that people can at least grep for the
relevant text.

> +	 */
> +	nr_pages = totalram_pages();
> +	calc_rmp_sz = (((rmp_sz >> PAGE_SHIFT) + nr_pages) << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;

use totalram_pages() directly and get rid of nr_pages.

> +
> +	if (calc_rmp_sz > rmp_sz) {
> +		pr_info("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
> +			calc_rmp_sz, rmp_sz);

pr_err

> +		return false;
> +	}
> +
> +	*start = rmp_base;
> +	*len = rmp_sz;
> +
> +	pr_info("RMP table physical address 0x%016llx - 0x%016llx\n", rmp_base, rmp_end);

"RMP table physical address range: ...[0x.. - 0x..]"

> +
> +	return true;
> +}
> +
> +static __init int __snp_rmptable_init(void)

s/int/bool/

> +{
> +	u64 rmp_base, sz;
> +	void *start;
> +	u64 val;
> +
> +	if (!get_rmptable_info(&rmp_base, &sz))
> +		return 1;
> +
> +	start = memremap(rmp_base, sz, MEMREMAP_WB);
> +	if (!start) {
> +		pr_err("Failed to map RMP table 0x%llx+0x%llx\n", rmp_base, sz);
							^^^^^^

either write the size in decimal or do a normal interval.

> +		return 1;
> +	}
> +
> +	/*
> +	 * Check if SEV-SNP is already enabled, this can happen if we are coming from

Who is "we"?

Pls get rid of all "we" in the comments and use passive formulations.

> +	 * kexec boot.
> +	 */
> +	rdmsrl(MSR_AMD64_SYSCFG, val);
> +	if (val & MSR_AMD64_SYSCFG_SNP_EN)
> +		goto skip_enable;
> +
> +	/* Initialize the RMP table to zero */
> +	memset(start, 0, sz);

Do I understand it correctly that in the kexec case the second, kexec-ed
kernel is reusing the previous kernel's RMP table so it should not be
cleared?

> +
> +	/* Flush the caches to ensure that data is written before SNP is enabled. */
> +	wbinvd_on_all_cpus();
> +
> +	/* Enable SNP on all CPUs. */
> +	on_each_cpu(snp_enable, NULL, 1);
> +
> +skip_enable:
> +	rmptable_start = (unsigned long)start;
> +	rmptable_end = rmptable_start + sz;
> +
> +	return 0;
> +}
> +
> +static int __init snp_rmptable_init(void)
> +{
> +	if (!boot_cpu_has(X86_FEATURE_SEV_SNP))

cpu_feature_enabled

> +		return 0;
> +
> +	if (!iommu_sev_snp_supported())
> +		goto nosnp;
> +
> +	if (__snp_rmptable_init())
> +		goto nosnp;
> +
> +	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
> +
> +	return 0;
> +
> +nosnp:
> +	setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
> +	return 1;
> +}
> +
> +/*
> + * This must be called after the PCI subsystem. This is because before enabling
> + * the SNP feature we need to ensure that IOMMU supports the SEV-SNP feature.
> + * The iommu_sev_snp_support() is used for checking the feature, and it is
> + * available after subsys_initcall().

I'd much more appreciate here a short formulation explaining why is
IOMMU needed for SNP rather than the obvious.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
