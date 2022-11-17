Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0666362D849
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 11:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239199AbiKQKlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 05:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbiKQKlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 05:41:44 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE30C1107;
        Thu, 17 Nov 2022 02:41:42 -0800 (PST)
Received: from zn.tnic (p200300ea9733e7de329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7de:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2C4431EC06BD;
        Thu, 17 Nov 2022 11:41:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668681701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VZAcVZayDy4r9kIQCe5t8cqMCHyxQifoQLXXlW222ns=;
        b=Ecamaqv5Aa0cAbQK56xL7xpDsTMWrF2BTeX4UDqEHponKzbhhOylHZgj2B5vAUCNgJ2N8M
        b7JuGlWCjIZuAGBhrNdT2VHvwxQxnL5ak0jwPDzWQiFfOoB8DplwP4e2QKB1av9UF0ZqoU
        uuWYJIJnXKVo/vfmvGeWWsbTFNUg/+4=
Date:   Thu, 17 Nov 2022 11:41:40 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, stable@kernel.org
Subject: Re: [PATCH] x86/sev: Add SEV-SNP guest feature negotiation support
Message-ID: <Y3YP5FQ6OHzVFKbp@zn.tnic>
References: <20221117044433.244656-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221117044433.244656-1-nikunj@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022 at 10:14:33AM +0530, Nikunj A Dadhania wrote:
> SEV_STATUS indicates features that hypervisor has enabled. Guest

"... which the hypervisor has ..."

> kernel may not support all the features that the hypervisor has
> enabled. If the hypervisor has enabled an unsupported feature,
> notify the hypervisor and terminate the boot.

This sentence needs expanding: why is the policy of the guest kernel
such that it must terminate if the hypervisor has enabled unsupported
features?

You allude to that in the comments below but this needs to be explained
here too.

> More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
> 
> [1] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
> 
> Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
> CC: Michael Roth <michael.roth@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: <stable@kernel.org>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/boot/compressed/sev.c   | 18 +++++++++++++
>  arch/x86/include/asm/msr-index.h | 46 +++++++++++++++++++++++++++++---
>  2 files changed, 61 insertions(+), 3 deletions(-)

Btw, how did you test this patch?

In file included from ./arch/x86/include/asm/msr.h:5,
                 from ./arch/x86/include/asm/processor.h:22,
                 from ./arch/x86/include/asm/cpufeature.h:5,
                 from ./arch/x86/include/asm/thread_info.h:53,
                 from ./include/linux/thread_info.h:60,
                 from ./arch/x86/include/asm/elf.h:8,
                 from ./include/linux/elf.h:6,
                 from arch/x86/boot/compressed/misc.h:24,
                 from arch/x86/boot/compressed/sev.c:13:
arch/x86/boot/compressed/sev.c: In function ‘snp_guest_feature_supported’:
./arch/x86/include/asm/msr-index.h:602:37: error: ‘MSR_AMD64_SNP_BIT13_RESERVED_ENABLED’ undeclared (first use in this function); did you mean ‘MSR_AMD64_SNP_BIT13_RESERVED’?
  602 |                                     MSR_AMD64_SNP_BIT13_RESERVED_ENABLED |      \
      |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./arch/x86/include/asm/msr-index.h:602:37: note: in definition of macro ‘SNP_GUEST_SUPPORT_REQUIRED’
  602 |                                     MSR_AMD64_SNP_BIT13_RESERVED_ENABLED |      \
      |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./arch/x86/include/asm/msr-index.h:602:37: note: each undeclared identifier is reported only once for each function it appears in
  602 |                                     MSR_AMD64_SNP_BIT13_RESERVED_ENABLED |      \
      |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./arch/x86/include/asm/msr-index.h:602:37: note: in definition of macro ‘SNP_GUEST_SUPPORT_REQUIRED’
  602 |                                     MSR_AMD64_SNP_BIT13_RESERVED_ENABLED |      \
      |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./arch/x86/include/asm/msr-index.h:604:37: error: ‘MSR_AMD64_SNP_BIT15_RESERVED_ENABLED’ undeclared (first use in this function); did you mean ‘MSR_AMD64_SNP_BIT15_RESERVED’?
  604 |                                     MSR_AMD64_SNP_BIT15_RESERVED_ENABLED |      \
      |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./arch/x86/include/asm/msr-index.h:604:37: note: in definition of macro ‘SNP_GUEST_SUPPORT_REQUIRED’
  604 |                                     MSR_AMD64_SNP_BIT15_RESERVED_ENABLED |      \
      |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./arch/x86/include/asm/msr-index.h:605:37: error: ‘MSR_AMD64_SNP_MASK_RESERVED_ENABLED’ undeclared (first use in this function); did you mean ‘MSR_AMD64_SNP_MASK_RESERVED’?
  605 |                                     MSR_AMD64_SNP_MASK_RESERVED_ENABLED)
      |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./arch/x86/include/asm/msr-index.h:605:37: note: in definition of macro ‘SNP_GUEST_SUPPORT_REQUIRED’
  605 |                                     MSR_AMD64_SNP_MASK_RESERVED_ENABLED)
      |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
make[2]: *** [scripts/Makefile.build:250: arch/x86/boot/compressed/sev.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/x86/boot/Makefile:116: arch/x86/boot/compressed/vmlinux] Error 2
make: *** [arch/x86/Makefile:283: bzImage] Error 2

It seems like you're new to this kernel hacking business - please
remember that it is absolutely mandatory that patches must be properly
tested before sending them upstream.

> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
> index c93930d5ccbd..847d26e761a6 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -270,6 +270,17 @@ static void enforce_vmpl0(void)
>  		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_NOT_VMPL0);
>  }
>  
> +static bool snp_guest_feature_supported(void)
> +{
> +	u64 guest_support = SNP_GUEST_SUPPORT_REQUIRED & ~SNP_GUEST_SUPPORT_AVAILABLE;
> +
> +	/*
> +	 * Return true when SEV features that hypervisor has enabled are
> +	 * also supported by SNP guest kernel
> +	 */

That comment is kinda obvious.

> +	return !(sev_status & guest_support);
> +}
> +
>  void sev_enable(struct boot_params *bp)
>  {
>  	unsigned int eax, ebx, ecx, edx;
> @@ -335,6 +346,13 @@ void sev_enable(struct boot_params *bp)
>  		if (!(get_hv_features() & GHCB_HV_FT_SNP))
>  			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
>  
> +		/*
> +		 * Terminate the boot if hypervisor has enabled a feature
> +		 * unsupported by the guest.
> +		 */
> +		if (!snp_guest_feature_supported())
> +			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
> +
>  		enforce_vmpl0();
>  	}
>  
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 4a2af82553e4..d33691b4cb24 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -567,9 +567,49 @@
>  #define MSR_AMD64_SEV_ENABLED_BIT	0
>  #define MSR_AMD64_SEV_ES_ENABLED_BIT	1
>  #define MSR_AMD64_SEV_SNP_ENABLED_BIT	2
> -#define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
> -#define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
> -#define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
> +#define MSR_AMD64_SEV_ENABLED				BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
> +#define MSR_AMD64_SEV_ES_ENABLED			BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
> +#define MSR_AMD64_SEV_SNP_ENABLED			BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
> +#define MSR_AMD64_SNP_VTOM_ENABLED			BIT_ULL(3)
> +#define MSR_AMD64_SNP_REFLECT_VC_ENABLED		BIT_ULL(4)
> +#define MSR_AMD64_SNP_RESTRICTED_INJ_ENABLED		BIT_ULL(5)
> +#define MSR_AMD64_SNP_ALT_INJ_ENABLED			BIT_ULL(6)
> +#define MSR_AMD64_SNP_DEBUG_SWAP_ENABLED		BIT_ULL(7)
> +#define MSR_AMD64_SNP_PREVENT_HOST_IBS_ENABLED		BIT_ULL(8)
> +#define MSR_AMD64_SNP_BTB_ISOLATION_ENABLED		BIT_ULL(9)
> +#define MSR_AMD64_SNP_VMPL_SSS_ENABLED			BIT_ULL(10)
> +#define MSR_AMD64_SNP_SECURE_TSC_ENABLED		BIT_ULL(11)
> +#define MSR_AMD64_SNP_VMGEXIT_PARAM_ENABLED		BIT_ULL(12)
> +#define MSR_AMD64_SNP_IBS_VIRT_ENABLED			BIT_ULL(14)
> +#define MSR_AMD64_SNP_VMSA_REG_PROTECTION_ENABLED	BIT_ULL(16)
> +#define MSR_AMD64_SNP_SMT_PROTECTION_ENABLED		BIT_ULL(17)
> +/* Prevent hypervisor to enable undefined feature bits */
> +#define MSR_AMD64_SNP_BIT13_RESERVED			BIT_ULL(13)
> +#define MSR_AMD64_SNP_BIT15_RESERVED			BIT_ULL(15)
> +#define MSR_AMD64_SNP_MASK_RESERVED			GENMASK_ULL(63, 18)

So I don't like this:

if you're going to enforce those bits, shouldn't that enforcement happen
after *all* those above have been added to the kernel first?

Because right now it will be dead code.

So what's the actual purpose of this patch?

> +/*
> + * Features that needs enlightened guest and cannot be supported with
> + * unmodified SNP guest kernel. This is subset of SEV_FEATURES.
> + */
> +#define SNP_GUEST_SUPPORT_REQUIRED (MSR_AMD64_SNP_VTOM_ENABLED |		\
> +				    MSR_AMD64_SNP_REFLECT_VC_ENABLED |		\
> +				    MSR_AMD64_SNP_RESTRICTED_INJ_ENABLED |	\
> +				    MSR_AMD64_SNP_ALT_INJ_ENABLED |		\
> +				    MSR_AMD64_SNP_VMPL_SSS_ENABLED |		\
> +				    MSR_AMD64_SNP_SECURE_TSC_ENABLED |		\
> +				    MSR_AMD64_SNP_VMGEXIT_PARAM_ENABLED |	\
> +				    MSR_AMD64_SNP_BIT13_RESERVED_ENABLED |	\
> +				    MSR_AMD64_SNP_VMSA_REG_PROTECTION_ENABLED | \
> +				    MSR_AMD64_SNP_BIT15_RESERVED_ENABLED |	\
> +				    MSR_AMD64_SNP_MASK_RESERVED_ENABLED)
> +/*
> + * Subset of SNP_GUEST_SUPPORT_REQUIRED, advertising the features that are
> + * supported in this enlightened guest kernel. As and when new features are
> + * added in the guest kernel, corresponding bit for this feature needs to be
> + * added as part of SNP_GUEST_SUPPORT_AVAILABLE.
> + */
> +#define SNP_GUEST_SUPPORT_AVAILABLE (0)

The reserved bits 13 and 15 trivially belong here already no?

And I don't like that AVAILABLE thing either. I think this all should be
concentrated in this single function snp_guest_feature_supported() - it
should be called

snp_guest_supports_all_required_features()

or so, so that the name says what it does and there you can pick those
apart and say yes or no at the end.

I'm also not sure you need each single bit defined separately but rather
test a mask instead first.

Also, having "_ENABLED" at the end of each bit name is too much - the
name is enough.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
