Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D996AA0E7
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 22:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbjCCVMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 16:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbjCCVMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 16:12:41 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E006514995
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 13:12:39 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z2so4062062plf.12
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 13:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677877959;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2vTEeegdhTPINe9u8on0QNbhqAjdFoxD4jGraDAyp3M=;
        b=X5f8oMagN0y5iOL5owBVe7UNBHrScztQAblkXpzHFXGWFyrzHL04vLpw0nu5Xr8mhI
         PGJ7VN7XGwoR1eqvWLrzBptviQk0tQxTzR9qstURpBWCxkHuzkGWK0SUi+ms+OwTuiWF
         IiGTmf40QCxEGmW+CjgBd2NPaWNp4IoPFE/ZqyKyQXLD4NL9gy40LWewNyuLXHyrap7f
         VKNhEqROW3pNeGz8pQ0d37UB1eLqNJ4HPQarEPQ8P5PneInQdmX+5ydCms26W9k/DDEg
         5zSreLH9gdnviNpm1iBQwelkK8iRfOemjrw45paj+xwyhAy7xg1wdxejP1Pfg7/mL217
         KxzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677877959;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2vTEeegdhTPINe9u8on0QNbhqAjdFoxD4jGraDAyp3M=;
        b=UgHb46Ktm1RL16ajYjI2UUFzgnMqPYiB9oUMSBm+2eK1qpAHlte2xOih/SPZZnqDt+
         Efy5jPVBoB67kBm/GP09pgb6tet80K2txLHY88+c678lyX54oIbdFY/LCBEOu8fK26VC
         /zYpyJX5ogcNqev4JIjJsM0q/UHx0CIhtkw4mmNbXfvJEjzI4tuXD0e8mkHiadDPf5Ji
         iy7spVxuyA7eBiJ/7S0N+cyW9paXLEjFNpI7fWLUHUq0b4PAsiYZoqTE2Wtk/BDjCn8H
         Fw0pt/k0iJRvJsZmuPu0h172IoOEQ0qX/RCIoraUarcoInj4KqvcP4Mtd40RwDwuG5pV
         L4MA==
X-Gm-Message-State: AO0yUKXFGxSLum36weZCIaP6PdLTfjkhbKcwaZ7A08aa7Q4u6DvPAnoW
        dOC7FUeQYh5EtxMSEsChTOfKPg==
X-Google-Smtp-Source: AK7set9F6pjaNdhzwq8MMN//jdCfGmqNrq24yBfre5fYv7jArKp7ZT29tIwHm5OJ7RhVM0RtP0GNhA==
X-Received: by 2002:a17:902:ef91:b0:19a:debb:58f7 with SMTP id iz17-20020a170902ef9100b0019adebb58f7mr2841800plb.13.1677877959242;
        Fri, 03 Mar 2023 13:12:39 -0800 (PST)
Received: from google.com (77.62.105.34.bc.googleusercontent.com. [34.105.62.77])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e5cb00b0019ad314189dsm1726758plf.207.2023.03.03.13.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 13:12:38 -0800 (PST)
Date:   Fri, 3 Mar 2023 21:12:34 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Subject: Re: [PATCH v3 5/8] KVM: x86: Clear all supported AMX xfeatures if
 they are not all set
Message-ID: <ZAJiwmWewMxKlRX0@google.com>
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-6-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224223607.1580880-6-aaronlewis@google.com>
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
> Be a good citizen and don't allow any of the supported AMX xfeatures[1]
> to be set if they can't all be set.  That way userspace or a guest
> doesn't fail if it attempts to set them in XCR0.
> 
> [1] CPUID.(EAX=0DH,ECX=0):EAX.XTILE_CFG[bit-17]
>     CPUID.(EAX=0DH,ECX=0):EAX.XTILE_DATA[bit-18]
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>

Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 1eff76f836a2..ac0423508b28 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -72,6 +72,9 @@ static u64 sanitize_xcr0(u64 xcr0)
>  	if ((xcr0 & mask) != mask)
>  		xcr0 &= ~XFEATURE_MASK_AVX512;
>  
> +	if ((xcr0 & XFEATURE_MASK_XTILE) != XFEATURE_MASK_XTILE)
> +		xcr0 &= ~XFEATURE_MASK_XTILE;
> +
>  	return xcr0;
>  }
>  
> -- 
> 2.39.2.637.g21b0678d19-goog
> 
