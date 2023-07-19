Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD9D759CB0
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 19:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjGSRrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 13:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGSRq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 13:46:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEAF18D
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 10:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689788771;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yNb73O2isjawz78K1ttGBkIfh5jJDHN2n3NGZYz0Juw=;
        b=b3GsBT1Dn/KV/2MMfhPbdPkGBeh6sqr488+HUX+hRsSd4uo3KYtGtTV9z7R+rxEqjv6oxF
        4FT5owl2iBTU9pe/tNlNDbu3+OSmrYSWW7PaC1gsUQZS2KjXZtQc3DDoxbsQmjfVYaJyRN
        YrPTBIRYeGCr0OlrLdmkDGuJk75cUYU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-QVQSFknCNJ-KFx-8bJh9Bg-1; Wed, 19 Jul 2023 13:46:09 -0400
X-MC-Unique: QVQSFknCNJ-KFx-8bJh9Bg-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-635325b87c9so74264556d6.1
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 10:46:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689788767; x=1690393567;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yNb73O2isjawz78K1ttGBkIfh5jJDHN2n3NGZYz0Juw=;
        b=bvqMArPMR0g35E3P9GRBgePie/dSeeheC7oPBHHgnNaL3/HEK0nj+cmAZpGjaFcR4f
         +R0kBATtNXHZnQ7qjab0MhLkmFbX7EeJ+7/9OywbesoBRdw1deuxH+dejqfGUXNaX/V4
         MwoY4UE6Mblw9Jsjgq6KgvlDYSStjBqR7Pv5917mFTBjZsqkYoDERR51hw3de7MmFCgE
         XFb8F/FhatH+b5FUYOqHyzjmdpe9hz9zOmwtAD/bla1N8h87iOJz0CWMa+j0bb6W+F+a
         BC71P7DWZwE3K+1m+5IOGwJTho5cjkutAGXfTIea4Q8kDkxCr/OKT6ek262Cx1/5JXov
         xDHQ==
X-Gm-Message-State: ABy/qLZE7yQ8cYpq638VR6aDrXM83ntDYWMA74vXHW1yKvNK6XRP7k5h
        FCE+/tzhjXFtABVHYlTRSLubUEam91tIGxGEGRyE1jAwGoroTySXtNayv7fw0kjYl4LcraidlhR
        ATaqQcRgNVxvDjOu8jyc/
X-Received: by 2002:a0c:cb8e:0:b0:62b:6f7e:f79 with SMTP id p14-20020a0ccb8e000000b0062b6f7e0f79mr16907440qvk.3.1689788767345;
        Wed, 19 Jul 2023 10:46:07 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEnUajR8taSGV4qOTfBZ3sumucQDatH1V5L1nfJ8Q1FWmgmEHvG2nspsjdxon+K24j4YwkETA==
X-Received: by 2002:a0c:cb8e:0:b0:62b:6f7e:f79 with SMTP id p14-20020a0ccb8e000000b0062b6f7e0f79mr16907427qvk.3.1689788767088;
        Wed, 19 Jul 2023 10:46:07 -0700 (PDT)
Received: from [192.168.43.95] ([37.169.27.8])
        by smtp.gmail.com with ESMTPSA id i17-20020a0cab51000000b0062df126ca11sm1626622qvb.21.2023.07.19.10.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 10:46:06 -0700 (PDT)
Message-ID: <433bb06d-5eaa-d21f-70c8-02311c06a650@redhat.com>
Date:   Wed, 19 Jul 2023 19:46:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] arm64: Define name for the bits
 used in SCTLR_EL1_RES1
Content-Language: en-US
To:     Shaoqin Huang <shahuang@redhat.com>, andrew.jones@linux.dev
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20230719031926.752931-1-shahuang@redhat.com>
 <20230719031926.752931-3-shahuang@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230719031926.752931-3-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shaoqin,

On 7/19/23 05:19, Shaoqin Huang wrote:
> Currently some fields in SCTLR_EL1 don't define a name and directly used
> in the SCTLR_EL1_RES1, that's not good now since these fields have been
> functional and have a name.
>
> According to the ARM DDI 0487J.a, define the name related to these
> fields.
>
> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  lib/arm64/asm/sysreg.h | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index c7f529d..9c68698 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -80,17 +80,26 @@ asm(
>  #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
>  
>  /* System Control Register (SCTLR_EL1) bits */
> +#define SCTLR_EL1_LSMAOE	_BITUL(29)
> +#define SCTLR_EL1_NTLSMD	_BITUL(28)
>  #define SCTLR_EL1_EE		_BITUL(25)
> +#define SCTLR_EL1_SPAN		_BITUL(23)
> +#define SCTLR_EL1_EIS		_BITUL(22)
> +#define SCTLR_EL1_TSCXT		_BITUL(20)
>  #define SCTLR_EL1_WXN		_BITUL(19)
>  #define SCTLR_EL1_I		_BITUL(12)
> +#define SCTLR_EL1_EOS		_BITUL(11)
> +#define SCTLR_EL1_SED		_BITUL(8)
> +#define SCTLR_EL1_ITD		_BITUL(7)
>  #define SCTLR_EL1_SA0		_BITUL(4)
>  #define SCTLR_EL1_SA		_BITUL(3)
>  #define SCTLR_EL1_C		_BITUL(2)
>  #define SCTLR_EL1_A		_BITUL(1)
>  #define SCTLR_EL1_M		_BITUL(0)
>  
> -#define SCTLR_EL1_RES1	(_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
> -			 _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
> +#define SCTLR_EL1_RES1	(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
> +			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
> +			 SCTLR_EL1_NTLSMD | SCTLR_EL1_LSMAOE)
>  #define INIT_SCTLR_EL1_MMU_OFF	\
>  			SCTLR_EL1_RES1
>  
The change looks good to me (although _BITULL remark still holds).

Independently on this patch the _RES1 terminology looks odd to me. For
example ESO bit is RES1 only if FEAT_ExS is not implemented. Maybe I
misunderstand why it was named that way but to me RES1 means another
thing. If confirmed we could simply drop SCTLR_EL1_RES1 which is not
used elsewhere and directly define INIT_SCTLR_EL1_MMU_OF.

Thanks

Eric

