Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE266CCB35
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 22:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjC1UHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 16:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjC1UHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 16:07:52 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738DB3A80;
        Tue, 28 Mar 2023 13:07:30 -0700 (PDT)
Received: from zn.tnic (p5de8e687.dip0.t-ipconnect.de [93.232.230.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EA9441EC0338;
        Tue, 28 Mar 2023 22:07:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1680034049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=oKdrTofyNMhqgonYPtcUFPursqcJed5p9iWqgPvlUv8=;
        b=Uhho4MMUmurp416gdQL7sryvkLqZDiWjF3Kfs8kHJ2TBPN7gNR+Ck5Z3Tv2WzkziVYGxfV
        CsZZVDBePQq9Zbq6hN/woB6FV22qLMBj5e2ik+8Wy2BHm/iAj1774PdVFdqYPAN5EqASs6
        t7XJRN87/P/+Ly8Fk15CYFqRBIqO688=
Date:   Tue, 28 Mar 2023 22:07:25 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, arjan@linux.intel.com, mingo@redhat.com,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>,
        Sabin Rapan <sabrapan@amazon.com>
Subject: Re: [PATCH v17 8/8] x86/smpboot: Allow parallel bringup for SEV-ES
Message-ID: <20230328200725.GHZCNI/dHoUMwhsfiC@fat_crate.local>
References: <20230328195758.1049469-1-usama.arif@bytedance.com>
 <20230328195758.1049469-9-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230328195758.1049469-9-usama.arif@bytedance.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023 at 08:57:58PM +0100, Usama Arif wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Enable parallel bringup for SEV-ES guests. The APs can't actually
> execute the CPUID instruction directly during early startup, but they
> can make the GHCB call directly instead, just as the VC trap handler
> would do.
> 
> Thanks to Sabin for talking me through the way this works.
> 
> Suggested-by: Sabin Rapan <sabrapan@amazon.com>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/coco/core.c              |  5 ++++
>  arch/x86/include/asm/coco.h       |  1 +
>  arch/x86/include/asm/sev-common.h |  3 +++
>  arch/x86/include/asm/smp.h        |  5 +++-
>  arch/x86/kernel/head_64.S         | 30 ++++++++++++++++++++++++
>  arch/x86/kernel/smpboot.c         | 39 ++++++++++++++++++++++++++-----
>  6 files changed, 76 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> index 49b44f881484..0bab38efb15a 100644
> --- a/arch/x86/coco/core.c
> +++ b/arch/x86/coco/core.c
> @@ -129,6 +129,11 @@ u64 cc_mkdec(u64 val)
>  }
>  EXPORT_SYMBOL_GPL(cc_mkdec);
>  
> +enum cc_vendor cc_get_vendor(void)
> +{
> +	return vendor;
> +}
> +
>  __init void cc_set_vendor(enum cc_vendor v)
>  {
>  	vendor = v;
> diff --git a/arch/x86/include/asm/coco.h b/arch/x86/include/asm/coco.h
> index 3d98c3a60d34..0428d9712c96 100644
> --- a/arch/x86/include/asm/coco.h
> +++ b/arch/x86/include/asm/coco.h
> @@ -12,6 +12,7 @@ enum cc_vendor {
>  };
>  
>  void cc_set_vendor(enum cc_vendor v);
> +enum cc_vendor cc_get_vendor(void);
>  void cc_set_mask(u64 mask);
>  
>  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM

You don't need those hunks adding cc_set_vendor() anymore:

https://git.kernel.org/tip/5ae57743f578725a5dadb6f31d7798ee55e6e967

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
