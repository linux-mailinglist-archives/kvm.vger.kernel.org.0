Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694B06AA10D
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 22:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbjCCVXc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 16:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjCCVXa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 16:23:30 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07552CC33
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 13:23:30 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so7468079pjb.3
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 13:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677878609;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J13QPDCD8erOXLzAP87eHVLFoCiKXjrrledHT75DlE8=;
        b=mpAYCLzvihPhqmQf5R0abRG/qfPnWg50bmlf0Dwd+T7Kvl+XrjewYeCAVm21NTOE4Z
         OV0x4ZQbGveGseJvZKklQbcgKkBmVdgsrXycBggO3SMIEu5qFQTv9gZpp1f5cDz928Hr
         EqPa+anfhgNFsSyeXk8TpNQymp/5QpTA9x37YneDOZL29beD0AAn4+1DKKwLbFRTSw/K
         0+H+IBejr/QcbpB3aHzutgfplnE65nWLo+dZkXPdzO/om33BfOQ6DrBYF2puuMyL+bcp
         mNbPwjNPpa+iTPuPFyVNj4tEGAMkUT5mZZhdxSxfEgietBHFJL/psq5YdOH62ULenLYi
         i1NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677878609;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J13QPDCD8erOXLzAP87eHVLFoCiKXjrrledHT75DlE8=;
        b=kAaPntK8bNwsOf1CjgKHQPN2E0udWiJ1CMt793AYwFnP0m6i925HXjIkxOoIL9uNM1
         m/+cJmsfVB8kohtvyvUnD+wWPd2eU2BfTT5VZBSwTrZbAi1To66JIlahVp4/ccoDbvOt
         lUYpLsHthJzk7eMRQlVUmRtGjIFrpDsE7OKTyzfZzoXMqMQY+YsvIOhCZHxRMNKKrPx8
         2worLLxlNyRuUyGIIxMocd3mRy50feNoXtgf9HZYrooRUNINBBrGlz+SLWvbri93vrqE
         dHa+Nei58bOk4liqMY9NCGtyrzC5sXPOUuSGCANH+vVEX/zjvXpuBGjSczxxsEU0IXVz
         DeWA==
X-Gm-Message-State: AO0yUKWAjVtKLcj5CzMAF6+MPf9hkMK6jz6fQDsOzBbBBDjKsaLg038v
        GW/sk86cs+u9QoEQPjvORUTQhQ==
X-Google-Smtp-Source: AK7set8wDlQmB+2LkMhcIApEDe7dX/+rc1CGwIPHnpf6/crOMMw35lb2DinfXiFQpaHrf0/DRwKjPA==
X-Received: by 2002:a17:902:f54c:b0:19a:8304:21eb with SMTP id h12-20020a170902f54c00b0019a830421ebmr7698974plf.6.1677878609293;
        Fri, 03 Mar 2023 13:23:29 -0800 (PST)
Received: from google.com (77.62.105.34.bc.googleusercontent.com. [34.105.62.77])
        by smtp.gmail.com with ESMTPSA id e8-20020a170902cf4800b0019a96d3b456sm1962346plg.44.2023.03.03.13.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 13:23:28 -0800 (PST)
Date:   Fri, 3 Mar 2023 21:23:24 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Subject: Re: [PATCH v3 2/8] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
Message-ID: <ZAJlTCWx8fpNp0Wi@google.com>
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-3-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224223607.1580880-3-aaronlewis@google.com>
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

On Fri, Feb 24, 2023, Aaron Lewis wrote:
> Be a good citizen and don't allow any of the supported MPX xfeatures[1]
> to be set if they can't all be set.  That way userspace or a guest
> doesn't fail if it attempts to set them in XCR0.
> 
> [1] CPUID.(EAX=0DH,ECX=0):EAX.BNDREGS[bit-3]
>     CPUID.(EAX=0DH,ECX=0):EAX.BNDCSR[bit-4]
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e1165c196970..b2e7407cd114 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -60,9 +60,22 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>  	return ret;
>  }
>  
> +static u64 sanitize_xcr0(u64 xcr0)
> +{
> +	u64 mask;
> +
> +	mask = XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR;
> +	if ((xcr0 & mask) != mask)
> +		xcr0 &= ~mask;
> +
> +	return xcr0;
> +}

Is it better to put sanitize_xcr0() into the previous patch? If we do
that, this one will be just adding purely the MPX related logic and thus
cleaner I think.
> +
>  u64 kvm_permitted_xcr0(void)
>  {
> -	return kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
> +	u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
> +
> +	return sanitize_xcr0(permitted_xcr0);
>  }
>  
>  /*
> -- 
> 2.39.2.637.g21b0678d19-goog
> 
