Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A61664809
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 19:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbjAJSDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 13:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235395AbjAJSDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 13:03:15 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC38327;
        Tue, 10 Jan 2023 10:00:48 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 65ABB1EC0528;
        Tue, 10 Jan 2023 19:00:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1673373647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=/dYhmS2NZxWY/VFZHy6ajrVuqyokrP3tFv8//sZMydY=;
        b=ks1+TdpGuJ2W4YpBrD56LtdKuPidjM6q5+mPo9BQJSn73a0oXd0+luPdORVeqezXA8KtTv
        9XReJmQFsz2UtX17EBZDvYJsT3tKTc7PXd/W75P0CGz8VjQh6VbIWF0pApMZlXnq4BUAKf
        UyNTl2EybWpgMbXpBl3MG0KyGptw9i0=
Date:   Tue, 10 Jan 2023 19:00:42 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Alexey Kardashevskiy <aik@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Huang Rui <ray.huang@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH kernel v2 2/3] KVM: SEV: Enable data breakpoints in SEV-ES
Message-ID: <Y72nyuKT+VJYiEUi@zn.tnic>
References: <20221209043804.942352-1-aik@amd.com>
 <20221209043804.942352-3-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221209043804.942352-3-aik@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 03:38:03PM +1100, Alexey Kardashevskiy wrote:
> AMD Milan (Fam 19h) introduces support for the swapping, as type 'B',

"type B" means nothing to people who don't have an intimate APM knowledge.

Let's try again, this time with a more accessible formulation:

"The debug registers are handled a bit differently when doing a world switch of a
SEV-ES guest: the guest debug registers values are saved and restored as usual
and as one would expect.

The *host* debug registers are not saved to the host save area so if the
host is doing any debug activity, that host should take care to stash its debug
registers values into the host save area before running guests.

See Table B-3. Swap Types and the AMD APM volume 2."

And now you can go into detail explaining which regs exactly and so on.

> of DR[0-3] and DR[0-3]_ADDR_MASK registers. Software enables this by
> setting SEV_FEATURES[5] (called "DebugSwap") in the VMSA which makes
> data breakpoints work in SEV-ES VMs.
>
> For type 'B' swaps the hardware saves/restores the VM state on
> VMEXIT/VMRUN in VMSA, and restores the host state on VMEXIT.

Yeah, close but I'd prefer a more detailed explanation and a reference to the
APM so that people can follow and read more info if needed.
> 
> Enable DebugSwap in VMSA but only if CPUID Fn80000021_EAX[0]
> ("NoNestedDataBp", "Processor ignores nested data breakpoints") is
> supported by the SOC as otherwise a malicious guest can cause
> the infinite #DB loop DoS.
> 
> Save DR[0-3] / DR[0-3]_ADDR_MASK in the host save area before VMRUN
> as type 'B' swap does not do this part.
> 
> Eliminate DR7 and #DB intercepts as:
> - they are not needed when DebugSwap is supported;
> - #VC for these intercepts is most likely not supported anyway and
> kills the VM.
> Keep DR7 intercepted unless DebugSwap enabled to prevent
> the infinite #DB loop DoS.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
> Changes:
> v2:
> * debug_swap moved from vcpu to module_param
> * rewrote commit log
> 
> ---
> 
> "DR7 access must remain intercepted for an SEV-ES guest" - I could not
> figure out the exact reasoning why it is there in the first place,
> IIUC this is to prevent loop of #DBs in the VM.

Let's ask Mr. Lendacky:

8d4846b9b150 ("KVM: SVM: Prevent debugging under SEV-ES")

> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index efaaef2b7ae1..800ea2a778cc 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -21,6 +21,7 @@
>  #include <asm/pkru.h>
>  #include <asm/trapnr.h>
>  #include <asm/fpu/xcr.h>
> +#include <asm/debugreg.h>
>  
>  #include "mmu.h"
>  #include "x86.h"
> @@ -52,11 +53,21 @@ module_param_named(sev, sev_enabled, bool, 0444);
>  /* enable/disable SEV-ES support */
>  static bool sev_es_enabled = true;
>  module_param_named(sev_es, sev_es_enabled, bool, 0444);
> +
> +/* enable/disable SEV-ES DebugSwap support */
> +static bool sev_es_debug_swap_enabled = true;
> +module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0644);
>  #else
>  #define sev_enabled false
>  #define sev_es_enabled false
> +#define sev_es_debug_swap false
>  #endif /* CONFIG_KVM_AMD_SEV */
>  
> +bool sev_es_is_debug_swap_enabled(void)
> +{
> +	return sev_es_debug_swap_enabled;
> +}
> +
>  static u8 sev_enc_bit;
>  static DECLARE_RWSEM(sev_deactivate_lock);
>  static DEFINE_MUTEX(sev_bitmap_lock);
> @@ -604,6 +615,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  	save->xss  = svm->vcpu.arch.ia32_xss;
>  	save->dr6  = svm->vcpu.arch.dr6;
>  
> +	if (sev_es_is_debug_swap_enabled())
> +		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
>  	pr_debug("Virtual Machine Save Area (VMSA):\n");
>  	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
>  
> @@ -2249,6 +2263,9 @@ void __init sev_hardware_setup(void)
>  out:
>  	sev_enabled = sev_supported;
>  	sev_es_enabled = sev_es_supported;
> +	if (sev_es_debug_swap_enabled)
> +		sev_es_debug_swap_enabled = sev_es_enabled &&
> +			boot_cpu_has(X86_FEATURE_NO_NESTED_DATA_BP);

check_for_deprecated_apis: WARNING: arch/x86/kvm/svm/sev.c:2268: Do not use boot_cpu_has() - use cpu_feature_enabled() instead.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
