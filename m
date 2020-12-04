Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91DC2CF297
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 18:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388418AbgLDRFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 12:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388350AbgLDRFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 12:05:05 -0500
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78620C061A51
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 09:04:25 -0800 (PST)
Received: by mail-oo1-xc42.google.com with SMTP id i30so1527066ooh.9
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 09:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hTPg26qSlQ0Wt4a7Q2DVHA9ywXVsdidYmAYQESPvOpc=;
        b=yUfH4HLnaPLj/bj23j6PlInUtfkiPhPRrQfHrsd3Sw3xsdx7QwhKI4HCdD79yncGCT
         YNwJA0jjAazJLC6oGKBKL6YoLmnoFlaTE+vmmJx50H9GXy6wheWn/Nd3r1VkKZOfO+4o
         aw/WQoeCUQVR0nj1W5AUPlYT/9/jeoQJ5akiDwA0KdBD7CCT5Oth6nm/7E/5RO9gDnAm
         zAO/+sJvIihd8jvDD/jeW3zlcfC9PuCG3Y4QCk6MecrBxbAZVOsvH+UacP7naqCnoigu
         KnRd2oVIiSCtyb5S1UM+RjU8nSi3M5J6UZoX3D8Raq+u4uUf+3KaeJJ4nZ0R3EReIRsg
         PbxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hTPg26qSlQ0Wt4a7Q2DVHA9ywXVsdidYmAYQESPvOpc=;
        b=BAN0k3hV6wPVgLhjGHp2Jfj4oMyOupQGxvfhw7CCyT8XoM0ckeHmYZvQeNjceL0Zts
         r0WWC4560hJe8SLkSQZULiStaXXC1Lzv6tAqycI/HNpCPIOrmUJHRAHDN4MxyAfyLTRt
         rOvSMUZcKqcDADI5Coxz1maNI7BfrLq2zR8xhHbMZ2BfX/rZGC9yeEU/2h37EccWvTEJ
         zrhQ6xEVrv9j2Gzg5DJpg/1li/mcOQ7brwSdGYlaE61RSRzqSC3/dP5QK40DkLXB+qkB
         52hdHklWsboMKCadpNwMAVijPZPi2Uwhe0ap6dS9mWg8bQbXS90bz9VfnCwZwKuSlLte
         6PPA==
X-Gm-Message-State: AOAM530hIn/6S2j5IY24r5YeThsKTRu2HiCTUNigg84ibETdGI5gnTbt
        ojlhnN0yUbEYJIJRJHIw+4AHzQ==
X-Google-Smtp-Source: ABdhPJy4q3B4QJYlZT7E1LAtFwmT8C+d9xLTbZiCqg4LrHUEaa160NBMRONNgpJdKcksd4W5kDflAg==
X-Received: by 2002:a4a:e972:: with SMTP id i18mr4165976ooe.17.1607101464886;
        Fri, 04 Dec 2020 09:04:24 -0800 (PST)
Received: from [172.24.51.127] (168.189-204-159.bestelclientes.com.mx. [189.204.159.168])
        by smtp.gmail.com with ESMTPSA id o63sm757962ooa.10.2020.12.04.09.04.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 09:04:24 -0800 (PST)
Subject: Re: [PATCH 9/9] target/mips: Explode gen_msa_branch() as
 gen_msa_BxZ_V/BxZ()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-10-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <42cae1ae-46aa-1207-dac7-1076b3422a7f@linaro.org>
Date:   Fri, 4 Dec 2020 11:04:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201202184415.1434484-10-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/20 12:44 PM, Philippe Mathieu-Daudé wrote:
> +static bool gen_msa_BxZ(DisasContext *ctx, int df, int wt, int s16, bool if_not)
> +{
> +    check_msa_access(ctx);
> +
> +    if (ctx->hflags & MIPS_HFLAG_BMASK) {
> +        generate_exception_end(ctx, EXCP_RI);
> +        return true;
> +    }
> +
> +    gen_check_zero_element(bcond, df, wt);
> +    if (if_not) {
> +        tcg_gen_setcondi_tl(TCG_COND_EQ, bcond, bcond, 0);
> +    }

Since gen_check_zero_element already produces a boolean, this is better as

  tcg_gen_xori_tl(bcond, bcond, if_not);

where tcg_gen_xori_tl already contains the if.

>      case OPC_BNZ_D:
> -        gen_check_zero_element(bcond, df, wt);
> -        tcg_gen_setcondi_tl(TCG_COND_EQ, bcond, bcond, 0);
> +        gen_msa_BxZ(ctx, df, wt, s16, true);

... oops, that'd be for a follow-up patch, to make this patch just code movement.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
