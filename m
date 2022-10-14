Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493655FF488
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 22:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbiJNU10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 16:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbiJNU1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 16:27:23 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E491C1177
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 13:27:20 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id h185so5258905pgc.10
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 13:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+UEsOAndO33n5xImeJNTvyfBdBqXe1KC5LWIrPoqWNs=;
        b=JQ79iqzSOqg0Bur5Ypadql7lmKQ5+ybc5D/asdZJnrcm5xu8IOdQQFYOM206SbSK98
         aovABu1c+hkUhwjwLDjs7wMWQzQ/nZCDAWsuLwztXfbSLyF9xtLlkZy5T/y+LK4Dqn6Z
         QIh9F8BSVlXdIeHXagAFCdB/YwR7BacRr4rzBB3xeh0T+ftlhUFAg8atZvS+8e3nceDk
         sV5Zf7QEKOU14h0SszzkqnzXrNn5HcUCfjddfSYWJEMfp8xpzqwU5XQZFsjjjgia/XsL
         2aTVbwOTQ73mNe7yr9FaH2+q6Nl75lfvrR2kylK54M8PexjMt8J83CJw6jC8VFbPXVhn
         VEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+UEsOAndO33n5xImeJNTvyfBdBqXe1KC5LWIrPoqWNs=;
        b=7Sobv/dFSPWyXjC3I1eusZGDccw6LfxhNynmQwOVWk4xrUYYw6cpxDOMY3wIG8A6wO
         BjFPm0Y3OZphNaRYeM2dHoe99UOr/TYZSx6/ysHdjLzaSonux+X00yahqRLTmkY8gbkV
         P411PB/wTQc7g717zzJhcogdvBM0Qx9cM9IVM33TEu7Y5S3Bbjqx6K3n9H5xxJX50fVl
         44fyXTX+ugtyRp62c3uQxDmi3I16Gqt9Zo6eTJ/mSxolPaBvuqLcOcoFwdeADk23ionJ
         SRdKrWhakCqbuBhTBfFYasFIFE7oSJtc/g6v3mtKK+nBq6Js4JQczydShfm/Kwa2sXpS
         KJwg==
X-Gm-Message-State: ACrzQf2TXjWhqjC4DMROBU64zIOxCjHLbmCWDSRVGpV3l5WpoLVfm84m
        f28nQ4F25qL2kQZKhWF1XRbEPaGaErDpwQ==
X-Google-Smtp-Source: AMsMyM7BBOr2ZvF64i0NTeL0ox3f/cbc2qck7JToyIKdsJL67GvfmsARuYjWeDCZgj09VHLaS6I6yA==
X-Received: by 2002:a17:902:d2ce:b0:185:3f05:acf4 with SMTP id n14-20020a170902d2ce00b001853f05acf4mr6643607plc.35.1665779229355;
        Fri, 14 Oct 2022 13:27:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h8-20020a056a00000800b0053ebe7ffddcsm2095332pfk.116.2022.10.14.13.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 13:27:08 -0700 (PDT)
Date:   Fri, 14 Oct 2022 20:27:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     John Allen <john.allen@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, x86@kernel.org, thomas.lendacky@amd.com
Subject: Re: [RFC PATCH] x86/sev-es: Include XSS value in GHCB CPUID request
Message-ID: <Y0nGGeCK+/FPOZej@google.com>
References: <20221012204716.204904-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012204716.204904-1-john.allen@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 12, 2022, John Allen wrote:
> When a guest issues a cpuid instruction for Fn0000000D_x0B
> (CetUserOffset), KVM will intercept and need to access the guest

s/KVM will/the hypervisor may

> XSS value.

Heh, "need" is debatable.

> For SEV-ES, this is encrypted and needs to be
> included in the GHCB to be visible to the hypervisor. The rdmsr
> instruction needs to be called directly as the code may be used in early
> boot in which case the rdmsr wrappers should be avoided as they are
> incompatible with the decompression boot phase.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
> This patch is logically part of the SVM guest shadow stack support series seen
> here:
> https://lore.kernel.org/all/20221012203910.204793-1-john.allen@amd.com/
> 
> Sending this patch separately from the main series as it should apply to the
> tip tree as opposed to the kvm tree as this patch is related to guest kernel
> support.
> ---
>  arch/x86/kernel/sev-shared.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 3a5b0c9c4fcc..34469fac03f0 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -887,6 +887,21 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
>  		/* xgetbv will cause #GP - use reset value for xcr0 */
>  		ghcb_set_xcr0(ghcb, 1);
>  
> +	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd) {

IIRC, XCR0 and XSS are only needed for sub-leafs 0 and 1, i.e. this and the code
above don't need to expose XCR0/XSS to the host for ECX > 1.

FWIW, I think it's ridiculous that the guest willingly exposes state to the host,
it's not _that_ difficult to do the math in the guest.

> +		unsigned long lo, hi;
> +		u64 xss;
> +
> +		/*
> +		 * Since vc_handle_cpuid may be used during early boot, the
> +		 * rdmsr wrappers are incompatible and should not be used.
> +		 * Invoke the instruction directly.
> +		 */
> +		asm volatile("rdmsr" : "=a" (lo), "=d" (hi)
> +				    : "c" (MSR_IA32_XSS));

Doesn't __rdmsr() do what you want?  But even that seems unnecessary, isn't the
current XSS available in xfeatures_mask_supervisor()?

> +		xss = (hi << 32) | lo;
> +		ghcb_set_xss(ghcb, xss);
> +	}
> +
>  	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
>  	if (ret != ES_OK)
>  		return ret;
> -- 
> 2.34.3
> 
