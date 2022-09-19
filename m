Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFB35BCED1
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 16:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiISObm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 10:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiISObk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 10:31:40 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7400F19C06;
        Mon, 19 Sep 2022 07:31:38 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e79d329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e79d:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 686171EC0230;
        Mon, 19 Sep 2022 16:31:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663597892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=aOFLwruiG67vJseMHd1aWtOXV4a+xdwAVmA/Tm3D62A=;
        b=MF31u7W0nciM6gYqCIXOPlJ8PFI3wvqW3+y/53XxRIsto/JsN4N9wwAsYownZNlxxJirxK
        kPEgRIyry9VZN8H5PB/O+2qeF/5ohzv9ZKiaOKNQktePrMBligl79aCa7043gwsOXH1iDd
        TEDaelCyuNn5racZYOJ3D5E8Wd/QHbU=
Date:   Mon, 19 Sep 2022 16:31:32 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        Kees Cook <keescook@chromium.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-perf-users@vger.kernel.org,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] perf/x86/intel/lbr: use setup_clear_cpu_cap
 instead of clear_cpu_cap
Message-ID: <Yyh9RDbaRqUR1XSW@zn.tnic>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
 <20220718141123.136106-2-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220718141123.136106-2-mlevitsk@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022 at 05:11:19PM +0300, Maxim Levitsky wrote:
> clear_cpu_cap(&boot_cpu_data) is very similar to setup_clear_cpu_cap
> except that the latter also sets a bit in 'cpu_caps_cleared' which
> later clears the same cap in secondary cpus, which is likely
> what is meant here.
> 
> Fixes: 47125db27e47 ("perf/x86/intel/lbr: Support Architectural LBR")
> 
> Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/events/intel/lbr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
> index 13179f31fe10fa..b08715172309a7 100644
> --- a/arch/x86/events/intel/lbr.c
> +++ b/arch/x86/events/intel/lbr.c
> @@ -1860,7 +1860,7 @@ void __init intel_pmu_arch_lbr_init(void)
>  	return;
>  
>  clear_arch_lbr:
> -	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_ARCH_LBR);
> +	setup_clear_cpu_cap(X86_FEATURE_ARCH_LBR);

setup_clear_cpu_cap() has a very specific purpose - see
apply_forced_caps().

This whole call sequence is an early_initcall() which is way after the
whole CPU features picking apart happens.

So what is actually this fixing?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
