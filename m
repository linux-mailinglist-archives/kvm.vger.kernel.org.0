Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA745C040F
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 18:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiIUQ0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 12:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiIUQ0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 12:26:23 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6698A5709;
        Wed, 21 Sep 2022 09:09:18 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e77f329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e77f:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6BAB71EC05DE;
        Wed, 21 Sep 2022 18:07:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663776431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=LF62L5JnveC0NnOJbQNf2E4BueK3qIrzPtCOa4tW7jc=;
        b=jbp8atHUTuocYg/a9SuXYpsQj1hHAqRBvHw9B8ANYKC1PVfOwd3jEDeZhIsOkUdx2glnlw
        VDpC9JlLXobU1vjVhNnYcqSpXdCNtl9AqOeGb0jv9K3CUdgwLsemqhWEqeQMu0xwZX0HNK
        FyzRLGkZeR7H3Vvc+VtkHEtHe+PGgwQ=
Date:   Wed, 21 Sep 2022 18:07:11 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jim Mattson <jmattson@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/3] x86/cpufeatures: Introduce X86_FEATURE_NO_LMSLE
Message-ID: <Yys2r0QYWjeEXLe0@zn.tnic>
References: <20220920205922.1564814-1-jmattson@google.com>
 <20220920205922.1564814-3-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220920205922.1564814-3-jmattson@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022 at 01:59:21PM -0700, Jim Mattson wrote:
> When AMD introduced "Long Mode Segment Limit Enable" (a.k.a. "VMware
> mode"), the feature was not enumerated by a CPUID bit. Now that VMware
> has abandoned binary translation, AMD has deprecated EFER.LMSLE.
> 
> The absence of the feature *is* now enumerated by a CPUID bit (a la
> Intel's X86_FEATURE_ZERO_FCS_DCS and X86_FEATURE_FDP_EXCPTN_ONLY).
> 
> This defeature bit is already present in feature word 13, but it was
> previously anonymous. Name it X86_FEATURE_NO_LMSLE, so that KVM can
> reference it when constructing a supported guest CPUID table.
> 
> Since this bit indicates the absence of a feature, don't enumerate it
> in /proc/cpuinfo.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index ef4775c6db01..0f5a3285d8d8 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -319,6 +319,7 @@
>  #define X86_FEATURE_AMD_IBRS		(13*32+14) /* "" Indirect Branch Restricted Speculation */
>  #define X86_FEATURE_AMD_STIBP		(13*32+15) /* "" Single Thread Indirect Branch Predictors */
>  #define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* "" Single Thread Indirect Branch Predictors always-on preferred */
> +#define X86_FEATURE_NO_LMSLE		(13*32+20) /* "" EFER_LMSLE is unsupported */
>  #define X86_FEATURE_AMD_PPIN		(13*32+23) /* Protected Processor Inventory Number */
>  #define X86_FEATURE_AMD_SSBD		(13*32+24) /* "" Speculative Store Bypass Disable */
>  #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* Virtualized Speculative Store Bypass Disable */
> -- 

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
