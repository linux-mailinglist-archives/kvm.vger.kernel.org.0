Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF38735EE55
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 09:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbhDNH2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 03:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbhDNH2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 03:28:18 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284E5C061574;
        Wed, 14 Apr 2021 00:27:57 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0e8f000e4e88675fafc1c1.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:8f00:e4e:8867:5faf:c1c1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 92DF41EC03A0;
        Wed, 14 Apr 2021 09:27:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618385275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=IpAXtilQ8p4ZDwtbgeb9KY0InAhzSGPotnUZhB4cNj8=;
        b=PRoaDLAcfw3/VXz/8um/bqMiuphYBfVtO/QHxkisG7n+E6ohJaHWrOTl/XmVS+u7Oi1jMg
        1BtlNLPFnD14kHk92JIc8F+sVTd2kdCI08nwudSJVSv79/ZrcNG6frZ924I0Vgn66j+RMZ
        V3yrWXEYnsl1JuB/lTK5p5U0kiXBDw4=
Date:   Wed, 14 Apr 2021 09:27:47 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 01/30] x86: Add the host SEV-SNP initialization
 support
Message-ID: <20210414072747.GA15722@zn.tnic>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-2-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324170436.31843-2-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 12:04:07PM -0500, Brijesh Singh wrote:
> @@ -538,6 +540,10 @@
>  #define MSR_K8_SYSCFG			0xc0010010
>  #define MSR_K8_SYSCFG_MEM_ENCRYPT_BIT	23
>  #define MSR_K8_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_K8_SYSCFG_MEM_ENCRYPT_BIT)
> +#define MSR_K8_SYSCFG_SNP_EN_BIT	24
> +#define MSR_K8_SYSCFG_SNP_EN		BIT_ULL(MSR_K8_SYSCFG_SNP_EN_BIT)
> +#define MSR_K8_SYSCFG_SNP_VMPL_EN_BIT	25
> +#define MSR_K8_SYSCFG_SNP_VMPL_EN	BIT_ULL(MSR_K8_SYSCFG_SNP_VMPL_EN_BIT)
>  #define MSR_K8_INT_PENDING_MSG		0xc0010055
>  /* C1E active bits in int pending message */
>  #define K8_INTP_C1E_ACTIVE_MASK		0x18000000

Ok, I believe it is finally time to make this MSR architectural and drop
this silliness with "K8" in the name. If you wanna send me a prepatch which
converts all like this:

MSR_K8_SYSCFG -> MSR_AMD64_SYSCFG

I'll gladly take it. If you prefer me to do it, I'll gladly do it.

> @@ -44,12 +45,16 @@ u64 sev_check_data __section(".data") = 0;
>  EXPORT_SYMBOL(sme_me_mask);
>  DEFINE_STATIC_KEY_FALSE(sev_enable_key);
>  EXPORT_SYMBOL_GPL(sev_enable_key);
> +DEFINE_STATIC_KEY_FALSE(snp_enable_key);
> +EXPORT_SYMBOL_GPL(snp_enable_key);
>  
>  bool sev_enabled __section(".data");
>  
>  /* Buffer used for early in-place encryption by BSP, no locking needed */
>  static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
>  
> +static unsigned long rmptable_start, rmptable_end;

__ro_after_init I guess.

> +
>  /*
>   * When SNP is active, this routine changes the page state from private to shared before
>   * copying the data from the source to destination and restore after the copy. This is required
> @@ -528,3 +533,82 @@ void __init mem_encrypt_init(void)
>  	print_mem_encrypt_feature_info();
>  }
>  
> +static __init void snp_enable(void *arg)
> +{
> +	u64 val;
> +
> +	rdmsrl_safe(MSR_K8_SYSCFG, &val);

Why is this one _safe but the wrmsr isn't? Also, _safe returns a value -
check it pls and return early.

> +
> +	val |= MSR_K8_SYSCFG_SNP_EN;
> +	val |= MSR_K8_SYSCFG_SNP_VMPL_EN;
> +
> +	wrmsrl(MSR_K8_SYSCFG, val);
> +}
> +
> +static __init int rmptable_init(void)
> +{
> +	u64 rmp_base, rmp_end;
> +	unsigned long sz;
> +	void *start;
> +	u64 val;
> +
> +	rdmsrl_safe(MSR_AMD64_RMP_BASE, &rmp_base);
> +	rdmsrl_safe(MSR_AMD64_RMP_END, &rmp_end);

Ditto, why _safe if you're checking CPUID?

> +
> +	if (!rmp_base || !rmp_end) {
> +		pr_info("SEV-SNP: Memory for the RMP table has not been reserved by BIOS\n");
> +		return 1;
> +	}
> +
> +	sz = rmp_end - rmp_base + 1;
> +
> +	start = memremap(rmp_base, sz, MEMREMAP_WB);
> +	if (!start) {
> +		pr_err("SEV-SNP: Failed to map RMP table 0x%llx-0x%llx\n", rmp_base, rmp_end);
			^^^^^^^

That prefix is done by doing

#undef pr_fmt
#define pr_fmt(fmt)     "SEV-SNP: " fmt

before the SNP-specific functions.

> +		return 1;
> +	}
> +
> +	/*
> +	 * Check if SEV-SNP is already enabled, this can happen if we are coming from kexec boot.
> +	 * Do not initialize the RMP table when SEV-SNP is already.
> +	 */

comment can be 80 cols wide.

> +	rdmsrl_safe(MSR_K8_SYSCFG, &val);

As above.

> +	if (val & MSR_K8_SYSCFG_SNP_EN)
> +		goto skip_enable;
> +
> +	/* Initialize the RMP table to zero */
> +	memset(start, 0, sz);
> +
> +	/* Flush the caches to ensure that data is written before we enable the SNP */
> +	wbinvd_on_all_cpus();
> +
> +	/* Enable the SNP feature */
> +	on_each_cpu(snp_enable, NULL, 1);

What happens if you boot only a subset of the CPUs and then others get
hotplugged later? IOW, you need a CPU hotplug notifier which enables the
feature bit on newly arrived CPUs.

Which makes me wonder whether it makes sense to have this in an initcall
and not put it instead in init_amd(): the BSP will do the init work
and the APs coming in will see that it has been enabled and only call
snp_enable().

Which solves the hotplug thing automagically.

> +
> +skip_enable:
> +	rmptable_start = (unsigned long)start;
> +	rmptable_end = rmptable_start + sz;
> +
> +	pr_info("SEV-SNP: RMP table physical address 0x%016llx - 0x%016llx\n", rmp_base, rmp_end);

			  "RMP table at ..."

also, why is this issued in skip_enable? You want to issue it only once,
on enable.

also, rmp_base and rmp_end look redundant - you can simply use
rmptable_start and rmptable_end.

Which reminds me - that function needs to check as the very first thing
on entry whether SNP is enabled and exit if so - there's no need to read
MSR_AMD64_RMP_BASE and MSR_AMD64_RMP_END unnecessarily.

> +
> +	return 0;
> +}
> +
> +static int __init mem_encrypt_snp_init(void)
> +{
> +	if (!boot_cpu_has(X86_FEATURE_SEV_SNP))
> +		return 1;
> +
> +	if (rmptable_init()) {
> +		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
> +		return 1;
> +	}
> +
> +	static_branch_enable(&snp_enable_key);
> +
> +	return 0;
> +}
> +/*
> + * SEV-SNP must be enabled across all CPUs, so make the initialization as a late initcall.

Is there any particular reason for this to be a late initcall?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
