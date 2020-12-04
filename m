Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586572CF720
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 23:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgLDWyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 17:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgLDWyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 17:54:33 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827DDC0613D1
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 14:53:52 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id q16so7465409edv.10
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 14:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fOou7mK0Qu+I/f018YEWl9EP2eVxzfmaBKE/XryaKjY=;
        b=G+K8eXpA50NShrNQc4lccUPRZhDp0mYelupp0t2TfGcuHpg/qrFsf6+l4mJd5N04GB
         qbH15GnH0Cldt4kK2GhqR8PA2Dpz8qaIFWcTzhDF8YLADgvoRYmdK4mBSXvx3cSgFJue
         d+POD7QD/Ptnxpo5nBnIG2v+LUOP/QJLTNGaha4WAwvvkQ+Rfxi62nF0DDWDozYfVyWh
         ydvPsESRVD3C4WgonbwndEmEwOimENEdtvrjTwfiifwfZiGRT2sbyAkhaLhBM9cYnw83
         56Cpgg1zVlwBU29CKt/amEKwtVd6zFCJXy2YGz+NKcRE6z2/T2EJFgGreY9/KZwu8+qE
         C84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fOou7mK0Qu+I/f018YEWl9EP2eVxzfmaBKE/XryaKjY=;
        b=X71riENO6fFOq/IR4ROHOSxQmkDi7LuceMBNc2XAfPtViB+sMt3gfSCav925AUxrYa
         WjcoAQ5dzwKMEup//ctnm1ZdO6GsCsC4WMvS/Y3zk0XNEQnqAh1uabRb3jEcCpL+O0Ei
         m3w3qtZXTRgt2za9Lv0o9yqNLvDUeSA8OVucxh3rd4uhrzFnAmD2ARDbFv+4J8UwQN5c
         Z+qqNfggciwui/anMFvAPDHhwA/Yl/hXuC3KZcpMjh6FQbMboL4rWX1jvHFo9YxFBPCx
         lJHbdqv5/aOdccE/HvH7KCl/YmPkk3ZOv6wGSaLlR6dLgLClzAC8e1IZ9DmwC1XaJhwK
         gn6Q==
X-Gm-Message-State: AOAM532eCQrvb7fWxiIp/nFK5/FSfKHvhJ+I8VCBW8wjJaIMT3Llqnam
        BPEwL/xFbs3A7cQVArYHjbw=
X-Google-Smtp-Source: ABdhPJyCtMG2T2tN8qF3DYlnpL+hWgn7L0rkCPDCteBfBJDnp1X+8kPOuQUECEjgruurm/Oro+8kGQ==
X-Received: by 2002:aa7:d354:: with SMTP id m20mr9567371edr.195.1607122431282;
        Fri, 04 Dec 2020 14:53:51 -0800 (PST)
Received: from [192.168.1.36] (111.red-88-21-205.staticip.rima-tde.net. [88.21.205.111])
        by smtp.gmail.com with ESMTPSA id qh23sm3761184ejb.71.2020.12.04.14.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 14:53:50 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH 9/9] target/mips: Explode gen_msa_branch() as
 gen_msa_BxZ_V/BxZ()
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-10-f4bug@amsat.org>
 <42cae1ae-46aa-1207-dac7-1076b3422a7f@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <c314aed2-9f39-89f7-c4f7-6b3e7c094996@amsat.org>
Date:   Fri, 4 Dec 2020 23:53:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <42cae1ae-46aa-1207-dac7-1076b3422a7f@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/4/20 6:04 PM, Richard Henderson wrote:
> On 12/2/20 12:44 PM, Philippe Mathieu-Daudé wrote:
>> +static bool gen_msa_BxZ(DisasContext *ctx, int df, int wt, int s16, bool if_not)
>> +{
>> +    check_msa_access(ctx);
>> +
>> +    if (ctx->hflags & MIPS_HFLAG_BMASK) {
>> +        generate_exception_end(ctx, EXCP_RI);
>> +        return true;
>> +    }
>> +
>> +    gen_check_zero_element(bcond, df, wt);
>> +    if (if_not) {
>> +        tcg_gen_setcondi_tl(TCG_COND_EQ, bcond, bcond, 0);
>> +    }
> 
> Since gen_check_zero_element already produces a boolean, this is better as
> 
>   tcg_gen_xori_tl(bcond, bcond, if_not);
> 
> where tcg_gen_xori_tl already contains the if.

Ah, got it.

> 
>>      case OPC_BNZ_D:
>> -        gen_check_zero_element(bcond, df, wt);
>> -        tcg_gen_setcondi_tl(TCG_COND_EQ, bcond, bcond, 0);
>> +        gen_msa_BxZ(ctx, df, wt, s16, true);
> 
> ... oops, that'd be for a follow-up patch, to make this patch just code movement.

Yes, will follow. I'm tempted to inline gen_check_zero_element (actually
move gen_msa_BxZ as gen_check_zero_element prologue/epilogue). Not sure
gen_check_zero_element() can be reused later though.

> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Thanks!

> 
> r~
> 
