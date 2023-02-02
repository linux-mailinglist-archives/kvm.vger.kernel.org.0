Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F34687C0A
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 12:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjBBLRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 06:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjBBLRQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 06:17:16 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522DF8B363;
        Thu,  2 Feb 2023 03:16:43 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 40F4B1EC069A;
        Thu,  2 Feb 2023 12:16:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1675336591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=uvIi+Jx60bAKZN/jWrmPW8ftCneMWCqwRu7t5YqCP6A=;
        b=VnhgzffYvCsw8bh+fg0k2U0T6Z3TNXxqbpnwhrQo53m3rVqxJxfuRf2qalw08ZdGttXzmS
        eidLqdR/beaGLg4/8THaXR8t9Ifu0BDQnyxlBIx/42WtxL3O6a7xqtaAHrhg5gC6cc/Ozy
        V2Iyhp9ReyT77PiDvfz2bpjHqKwMYsU=
Date:   Thu, 2 Feb 2023 12:16:27 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v7 14/64] x86/sev: Add the host SEV-SNP
 initialization support
Message-ID: <Y9ubi0i4Z750gdMm@zn.tnic>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-15-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-15-michael.roth@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:40:06PM -0600, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The memory integrity guarantees of SEV-SNP are enforced through a new
> structure called the Reverse Map Table (RMP). The RMP is a single data
> structure shared across the system that contains one entry for every 4K
> page of DRAM that may be used by SEV-SNP VMs. The goal of RMP is to
> track the owner of each page of memory. Pages of memory can be owned by
> the hypervisor, owned by a specific VM or owned by the AMD-SP. See APM2
> section 15.36.3 for more detail on RMP.
> 
> The RMP table is used to enforce access control to memory. The table itself
> is not directly writable by the software. New CPU instructions (RMPUPDATE,
> PVALIDATE, RMPADJUST) are used to manipulate the RMP entries.
> 
> Based on the platform configuration, the BIOS reserves the memory used
> for the RMP table. The start and end address of the RMP table must be
> queried by reading the RMP_BASE and RMP_END MSRs. If the RMP_BASE and
> RMP_END are not set then disable the SEV-SNP feature.
> 
> The SEV-SNP feature is enabled only after the RMP table is successfully
> initialized.
> 
> Also set SYSCFG.MFMD when enabling SNP as SEV-SNP FW >= 1.51 requires
> that SYSCFG.MFMD must be se

			   set.
> 
> RMP table entry format is non-architectural and it can vary by processor
> and is defined by the PPR. Restrict SNP support on the known CPU model
> and family for which the RMP table entry format is currently defined for.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-b: Ashish Kalra <ashish.kalra@amd.com>
	     ^^

Somebody ate a 'y' here. :)

> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/disabled-features.h |   8 +-
>  arch/x86/include/asm/msr-index.h         |  11 +-
>  arch/x86/kernel/sev.c                    | 180 +++++++++++++++++++++++
>  3 files changed, 197 insertions(+), 2 deletions(-)

...

> +static __init int __snp_rmptable_init(void)

Why is this one carved out of snp_rmptable_init() ?

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
> +		pr_err("Failed to map RMP table addr 0x%llx size 0x%llx\n", rmp_base, sz);
> +		return 1;
> +	}
> +
> +	/*
> +	 * Check if SEV-SNP is already enabled, this can happen in case of
> +	 * kexec boot.
> +	 */
> +	rdmsrl(MSR_AMD64_SYSCFG, val);
> +	if (val & MSR_AMD64_SYSCFG_SNP_EN)
> +		goto skip_enable;
> +
> +	/* Initialize the RMP table to zero */

Useless comment.

> +	memset(start, 0, sz);
> +
> +	/* Flush the caches to ensure that data is written before SNP is enabled. */
> +	wbinvd_on_all_cpus();
> +
> +	/* MFDM must be enabled on all the CPUs prior to enabling SNP. */
> +	on_each_cpu(mfd_enable, NULL, 1);
> +
> +	/* Enable SNP on all CPUs. */
> +	on_each_cpu(snp_enable, NULL, 1);

What happens if someone boots the machine with maxcpus=N, where N is
less than all CPUs on the machine? The hotplug notifier should handle it
but have you checked that it works fine?

> +skip_enable:
> +	rmptable_start = (unsigned long)start;
> +	rmptable_end = rmptable_start + sz - 1;
> +
> +	return 0;
> +}
> +
> +static int __init snp_rmptable_init(void)
> +{
> +	int family, model;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return 0;
> +
> +	family = boot_cpu_data.x86;
> +	model  = boot_cpu_data.x86_model;

Looks useless - just use boot_cpu_data directly below.

> +
> +	/*
> +	 * RMP table entry format is not architectural and it can vary by processor and
> +	 * is defined by the per-processor PPR. Restrict SNP support on the known CPU
> +	 * model and family for which the RMP table entry format is currently defined for.
> +	 */
> +	if (family != 0x19 || model > 0xaf)
> +		goto nosnp;
> +
> +	if (amd_iommu_snp_enable())
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
> +	return -ENOSYS;
> +}

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
