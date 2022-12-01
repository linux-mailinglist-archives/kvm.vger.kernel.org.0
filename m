Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A337363F640
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 18:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiLARil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 12:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiLARik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 12:38:40 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AA0A8098
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 09:38:39 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 130so2526218pfu.8
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 09:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RiLEICTVmXLErxo4PMC+ee81eNOjxAzNcaRYbtLAGkw=;
        b=XDQotCQuLafW/S8wy/HVAsoUm9o/ZHjw3XKrM+Bqn5p5E67C/pz0UVI2LUOjt79/Pg
         tEe+YhcNxbi3j1P5F7sWiW+QPKAAZ3ATZC9bo/FxHxhacBlxgvCYVKgZM276E1vaGIJJ
         CiulalEN80ekH6KOte6HvU8X4S+bG10r3XmShP3NEo6dxxa1nQdmBEGIzBAaNts/n0Wo
         KNImaF2i7wSjF5NEEa2c0wtWAgqfRP/FJHgMr9NxLMOIq9NVOYKsofvjQL3mwknLNPI+
         W53U9m5uPYCHS1C5z+T6nlHZGfXzWaNyH0l4+Wx4nAD6wyHfuDXJJbB+IWolwI+oOtsq
         pf2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RiLEICTVmXLErxo4PMC+ee81eNOjxAzNcaRYbtLAGkw=;
        b=CGfoEtkumrEuyNmQinSYK8GHGZXFQ0TFAumB8Xde3dteep82Va03jqJc0lCooHkfIN
         33x4jXa8u/a+p3m2BJ8d62hxtPkJcRW6HwhCxKhszBCZJsSoAwWo+cQXpH00p9SkfL9P
         DyDzZ9uLnAUHaEZYWtfJGFyQG+2/A5UIdIyGSZEvTF/paVVuEOLXDKqAaZT/fgcblCw0
         CGTAuE7xTsB9lQK04lyR+leOJfheb4SqtFRIjN3PK/QlJJNDvT0H0KvIwl3O9gPQXQCr
         PXBftnfQdSoWdfFwdIPFU68du2uA4V2+wFIfViQyRP7TMjkO5lkiLJks8F85GtUqnS2C
         YKiw==
X-Gm-Message-State: ANoB5pk0Ls3yi+hpZ1jH7mSqR9rZmUHLI5g2z4e0H1uYyvYGzIAb8cwL
        2IWU1oBKRpaquNCQVKWejz/DlA==
X-Google-Smtp-Source: AA0mqf7v0tWq4QtfPccpn1nakJw4PmMhrUn/LTfEkgl3bh6juHDx0gLalN7tLBfu7bRNs7/hwu9jcw==
X-Received: by 2002:a62:e80f:0:b0:574:cc3d:a23f with SMTP id c15-20020a62e80f000000b00574cc3da23fmr31204117pfi.53.1669916317425;
        Thu, 01 Dec 2022 09:38:37 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f2-20020a170902ff0200b0018975488514sm3897571plj.126.2022.12.01.09.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 09:38:37 -0800 (PST)
Date:   Thu, 1 Dec 2022 17:38:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH kernel 3/3] x86/sev: Do not handle #VC for DR7 read/write
Message-ID: <Y4jmmfrUXAzydM0G@google.com>
References: <20221201021948.9259-1-aik@amd.com>
 <20221201021948.9259-4-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201021948.9259-4-aik@amd.com>
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

On Thu, Dec 01, 2022, Alexey Kardashevskiy wrote:
> With SVM_SEV_FEAT_DEBUG_SWAP enabled, the VM should not get #VC events
> for DR7 read/write which it rather avoided.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  arch/x86/kernel/sev.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index a428c62330d3..4e91b9f8742c 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -1618,6 +1618,9 @@ static enum es_result vc_handle_dr7_write(struct ghcb *ghcb,
>  	long val, *reg = vc_insn_get_rm(ctxt);
>  	enum es_result ret;
>  
> +	if ((sev_status >> 2) & SVM_SEV_FEAT_DEBUG_SWAP)

Probably high time to add a helper/macro to convert the SEV_STATUS to the SEV_FEATURES
field.

> +		return ES_VMM_ERROR;
> +
>  	if (!reg)
>  		return ES_DECODE_FAILED;
>  
> @@ -1655,6 +1658,9 @@ static enum es_result vc_handle_dr7_read(struct ghcb *ghcb,
>  	struct sev_es_runtime_data *data = this_cpu_read(runtime_data);
>  	long *reg = vc_insn_get_rm(ctxt);
>  
> +	if ((sev_status >> 2) & SVM_SEV_FEAT_DEBUG_SWAP)
> +		return ES_VMM_ERROR;
> +
>  	if (!reg)
>  		return ES_DECODE_FAILED;
>  
> -- 
> 2.38.1
> 
