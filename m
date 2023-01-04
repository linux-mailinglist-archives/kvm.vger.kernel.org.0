Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E5365D9E5
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 17:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239119AbjADQdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 11:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235235AbjADQdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 11:33:41 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2353E165A5
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 08:33:40 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id b2so36370984pld.7
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 08:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=liVr0lNiRFopmvyiIU8An9agqe2F7znhRZcvHmy9hvw=;
        b=NEGmZCUmm49sGz/d2iEIOZ22V8GhjoQFpD4qyw5p77tVDI1zEVyXuJOetlNXwcUjOX
         74y+7SCgU+St1G2t/n25/mrjv5D0N4CRc6Al273Xeipkr1Aeo+kJVucmSirZn1/m0a33
         y3lqXfKgRCBvimOZ+PMdUQ0jMw1OBKs+TPRiUqvgNGTlC7ZLf8RqZ+thA/ul9zr/SCvn
         zUeFdeQAmSihdKwIRRUlF1ZzjOkar96/PiKS3EsH+t1ySfaywHJoT4TaCi0QouvihIjT
         2Fjhowz/rSpeVg7KGDXfrHlsyMfimF+uMyrlRKqio1N5FAMAlg27ciJlDfpr1WPzCxIG
         fk5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=liVr0lNiRFopmvyiIU8An9agqe2F7znhRZcvHmy9hvw=;
        b=y2kHhCXShGoka/Gp0Tdvbf6f53sC/BgcXCToQTLCvldCPvrq0hrCHQ/KVLyAH7jBpZ
         PaJvNfGK7b+b4+KF+M0vwNbbfBHHH9wcEB7g4y243EUVgrtCXCcyA9/zd/pTtuv90/iS
         ufoMFUbnEkYmhKKOIUcb/0cYD5CiCY49o5hEv1K2TatZr2Y6rbTREISPAxaQMJlhJYzz
         r55Ywkcj+SnoIulxDYdYwHLS5FBf+OAG/ut5HLobWA6cYrc6TVohSqprVtIUdovTzSiN
         Y58amwYDVrX7iTf2zys8uH9ugAGlpi3y4qyK43ItpOdMpkncB3G0gY9i/Wa00/J2mKWx
         0Fbw==
X-Gm-Message-State: AFqh2kp5tj4nQcY6278r7ExMyxHiPl079YJ1pK7kSKakp5J6AQ3X+LBm
        EMYtc8n41H+wtFYQZsJjdrpQ3Q==
X-Google-Smtp-Source: AMrXdXtsthN9JBcjYD/Sfw70NKODeC/VVIZna0eV8DUkD0z+wStJkxWUwhwIRsBQkkxGRa400/75Ow==
X-Received: by 2002:a17:902:dad0:b0:191:1543:6b2f with SMTP id q16-20020a170902dad000b0019115436b2fmr4295598plx.3.1672850019439;
        Wed, 04 Jan 2023 08:33:39 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ix7-20020a170902f80700b00192a04bc620sm13161022plb.295.2023.01.04.08.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 08:33:38 -0800 (PST)
Date:   Wed, 4 Jan 2023 16:33:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v2 2/6] KVM: x86: Clear all supported AVX-512 xfeatures
 if they are not all set
Message-ID: <Y7WqXkjW16aA3gaT@google.com>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-3-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230162442.3781098-3-aaronlewis@google.com>
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

On Fri, Dec 30, 2022, Aaron Lewis wrote:
> Be a good citizen and don't allow any of the supported AVX-512
> xfeatures[1] to be set if they can't all be set.  That way userspace or
> a guest doesn't fail if it attempts to set them in XCR0.

The form letter shortlog+changelo+code doesn't fit AVX-512.  There's only one
AVX512 flag, SSE and AVX and are pure prerequisites and exist independently of
AVX512.

> It's important to note that in order to set any of the AVX-512
> xfeatures, the SSE[bit-1] and AVX[bit-2] must also be set.
> 
> [1] CPUID.(EAX=0DH,ECX=0):EAX.OPMASK[bit-5]
>     CPUID.(EAX=0DH,ECX=0):EAX.ZMM_Hi256[bit-6]
>     CPUID.(EAX=0DH,ECX=0):EAX.ZMM_Hi16_ZMM[bit-7]
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2431c46d456b4..89ad8cd865173 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -862,6 +862,10 @@ static u64 sanitize_xcr0(u64 xcr0) {
>  	if ((xcr0 & mask) != mask)
>  		xcr0 &= ~mask;
>  
> +	mask = XFEATURE_MASK_SSE | XFEATURE_MASK_YMM | XFEATURE_MASK_AVX512;

Checking AVX512 is unnecessary.  If it's not set, the AND-NOT is a nop.

> +	if ((xcr0 & mask) != mask)
> +		xcr0 &= ~XFEATURE_MASK_AVX512;

This can be:

	if (!(xcr0 & XFEATURE_MASK_SSE) || !(xcr0 & XFEATURE_MASK_YMM))
		xcr0 &= ~XFEATURE_MASK_AVX512

to better capture the dependency.
