Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B318534336
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 20:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242960AbiEYSmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 14:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbiEYSmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 14:42:40 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63122A186
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 11:42:39 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 31so19577238pgp.8
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 11:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q9rdEw4EiaN0h3XRnvbyQ5yD4IVKylGzvNFxDdbXbEg=;
        b=MoWbhovX3aT7pTvWx1p4xM98j55ukFvcXkinxfJOhYUQ4eMHUU7mFu4Ju1h6srogw1
         M5Ke0Ilftxg6UjyuvZP0o49a//6i/hpK6UiKQ2GfmQrAD10dOj5Tdiwa7l5nI3MzP6S0
         lTNBukHBRbPPjlrS9Yqjgj8S3FhScsPCYJeBT4Y5mzr4iIqpiqwo5qYUjHx4U5PHz19G
         zNPs9Hu6JTGPMvHEtbwjsbYiYmQg9X+xeo4O0FF6WIqssCwvOIlnUh8q2QMBe1w+XZSS
         ODAYdhFFBVPOFqWq4/Q2ntmT0ldq84277baVgYnaeqBTjdM0fQxqRuXEnYBQ5GvG51I7
         7ZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q9rdEw4EiaN0h3XRnvbyQ5yD4IVKylGzvNFxDdbXbEg=;
        b=3NqXrXSpoOs4Ewdfdml0yKMWrjJjEkszLR3m2Xj1MJLvtvDcFeZjQDNmDQxt/FgZyQ
         cyvTROks+TtdgW56yXs4RH62qTSi+DyWBM+eUokODEGjTZ5FRaHXeFJrXqaHCLIuMepN
         8YMj+yTSO9YAK4c1ijm3t25NRf9zcgw7u4uTZgGbuLLf+dHiE4bwDyBXIuEiIxvFx9An
         T6IpXILG5lv/R5pYuznculB+/xSJ7I4lzTlaV7k7f148w9tz0IVeWA/zBeGgzcw2B4Dd
         rrNNcmFk2TGX+1yvQwD7X584cOvt0PIGH8/DpREyMusnZEc7rga+XQGeUuuFpf2L+mDR
         10vQ==
X-Gm-Message-State: AOAM531H4ZtLenrE+b9KwvKKXJ7tePc3SsJfGUJuDCZziGDyAB+v77TZ
        +1zR+QHEA7wpEi63emwobUGw2+Z4ymqszw==
X-Google-Smtp-Source: ABdhPJy9v5v85XcGtTP2riFWS85jNSG/040f61d5az3Fl6w0qIbqK8AQUMu9/NeKkzMshBUBKpae/w==
X-Received: by 2002:a63:7c4e:0:b0:380:8ae9:c975 with SMTP id l14-20020a637c4e000000b003808ae9c975mr30540800pgn.25.1653504158764;
        Wed, 25 May 2022 11:42:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b11-20020a62a10b000000b0050dc76281aesm11828625pff.136.2022.05.25.11.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 11:42:38 -0700 (PDT)
Date:   Wed, 25 May 2022 18:42:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Venkatesh Srinivas <venkateshs@chromium.org>
Cc:     kvm@vger.kernel.org, marcorr@google.com
Subject: Re: [PATCH v2 1/2] KVM: Inject #GP on invalid write to APIC_SELF_IPI
 register
Message-ID: <Yo54m3UlJNImnepr@google.com>
References: <20220525173933.1611076-1-venkateshs@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525173933.1611076-1-venkateshs@chromium.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022, Venkatesh Srinivas wrote:
> From: Marc Orr <marcorr@google.com>
> 
> From: Venkatesh Srinivas <venkateshs@chromium.org>

Only Marc should have an explicit From:.  git am processes only the first From:,
e.g. your From: line ends up in the changelog.

> The upper bytes of the x2APIC APIC_SELF_IPI register are reserved.

Uber nit, please be more precise than "upper bytes".  The comment about "Bits 7:0"
saved me from having to lookup up APIC_VECTOR_MASK, but it'd be nice to have that
in the changelog.

E.g.

  Inject a #GP if the guest attempts to set reserved bits in the x2APIC-only
  Self-IPI register.  Bits 7:0 hold the vector, all other bits are reserved.

> Inject a #GP into the guest if any of these reserved bits are set.
> 
> Signed-off-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
> ---
>  arch/x86/kvm/lapic.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 21ab69db689b..6f8522e8c492 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2169,10 +2169,16 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  		break;
>  
>  	case APIC_SELF_IPI:
> -		if (apic_x2apic_mode(apic))
> -			kvm_apic_send_ipi(apic, APIC_DEST_SELF | (val & APIC_VECTOR_MASK), 0);
> -		else
> +		/*
> +		 * Self-IPI exists only when x2APIC is enabled.  Bits 7:0 hold
> +		 * the vector, everything else is reserved.
> +		 */
> +		if (!apic_x2apic_mode(apic) || (val & ~APIC_VECTOR_MASK)) {
>  			ret = 1;
> +			break;
> +		}
> +		kvm_lapic_reg_write(apic, APIC_ICR,
> +				    APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
>  		break;
>  	default:
>  		ret = 1;
> -- 
> 2.36.1.124.g0e6072fb45-goog
> 
