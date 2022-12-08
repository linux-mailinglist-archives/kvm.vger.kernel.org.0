Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CA86473FD
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 17:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiLHQOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 11:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiLHQOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 11:14:18 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCF9AD9A1;
        Thu,  8 Dec 2022 08:14:17 -0800 (PST)
Received: from zn.tnic (p200300ea9733e73d329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e73d:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B3B291EC0532;
        Thu,  8 Dec 2022 17:14:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1670516055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=mpSVni1jvdroIaME7GDcDgKKXd+H1uRbJlRgfrdVzGw=;
        b=bk2RCHcHGaBATFGvr0rM4hh4UhD2PsnE+7uwvI86VoueRGXu865kH6uhLuAk6OnMlNuQ6H
        GNWhLlubf2p4CYu7iu/CQ+QqwRigFnwU/ZlP3jtehiubqxduggk3uTrUIFsX3+xhO/Kdp1
        pVoF9IxM75f6IBCIBt8mCEzZtchkTtE=
Date:   Thu, 8 Dec 2022 17:14:11 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/cpu: Process all CPUID dependencies after
 identifying CPU info
Message-ID: <Y5INU3o+SFReGkLz@zn.tnic>
References: <20221203003745.1475584-1-seanjc@google.com>
 <20221203003745.1475584-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221203003745.1475584-2-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 03, 2022 at 12:37:43AM +0000, Sean Christopherson wrote:
> Process all CPUID dependencies to ensure that a dependent is disabled if
> one or more of its parent features is unsupported.

Just out of curiosity: this is some weird guest configuration, right?
Not addressing a real hw issue...

> As is, cpuid_deps is
> processed if an only if a feature is explicitly disabled via
> clear_cpu_cap(), which makes it annoying/dangerous to use cpuid_deps for
> features whose parent(s) do not always have explicit processing.
> 
> E.g. VMX and SGX depend on the synthetic X86_FEATURE_MSR_IA32_FEAT_CTL,
> but there is no common location to clear MSR_IA32_FEAT_CTL, and so
> consumers of VMX and SGX are forced to check MSR_IA32_FEAT_CTL on top
> of the dependent feature.
> 
> Manually clearing X86_FEATURE_MSR_IA32_FEAT_CTL is the obvious
> alternative, but it's subtly more difficult that updating
> init_ia32_feat_ctl().  CONFIG_IA32_FEAT_CTL depends on any of
> CONFIG_CPU_SUP_{INTEL,CENATUR,ZHAOXIN}, but init_ia32_feat_ctl() is
> invoked if and only if the actual CPU type matches one of the
> aforementioned CPU_SUP_* types. E.g. running a kernel built with
> 
>   CONFIG_CPU_SUP_INTEL=y
>   CONFIG_CPU_SUP_AMD=y
>   # CONFIG_CPU_SUP_HYGON is not set
>   # CONFIG_CPU_SUP_CENTAUR is not set
>   # CONFIG_CPU_SUP_ZHAOXIN is not set
> 
> on a Cenatur or Zhaoxin CPU will leave X86_FEATURE_VMX set but not set

Typo fix for the committer: Centaur

> X86_FEATURE_MSR_IA32_FEAT_CTL, and will never call init_ia32_feat_ctl()
> to give the kernel a convenient opportunity to clear
> X86_FEATURE_MSR_IA32_FEAT_CTL.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/cpufeature.h |  1 +
>  arch/x86/kernel/cpu/common.c      |  6 ++++++
>  arch/x86/kernel/cpu/cpuid-deps.c  | 10 ++++++++++
>  3 files changed, 17 insertions(+)

...

> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index bf4ac1cb93d7..094fc69dba63 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1887,6 +1887,12 @@ static void identify_cpu(struct cpuinfo_x86 *c)
>  
>  	ppin_init(c);
>  
> +	/*
> +	 * Apply CPUID dependencies to ensure dependent features are disabled
> +	 * if a parent feature is unsupported but wasn't explicitly disabled.
> +	 */
> +	apply_cpuid_deps(c);

I'd probably call that resolve_cpuid_deps()...

But yeah, that init path would need cleaning up at some point - all
kinds of init detection functions have been hastily slapped there over
the years...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
