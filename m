Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504112CF313
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 18:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbgLDRYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 12:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731181AbgLDRYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 12:24:21 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EDAC061A51
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 09:23:35 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id x16so9771669ejj.7
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 09:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K+p+qHBTPYAZlOemNmAAlCb4kwszE/8ejMy4SRvtpWE=;
        b=l44vQNc7VNTaHbH8C5fxl9NLbnBkwtSZMVpE8zKLAbR7JyVFHatBdQv/sR0+B+z0zs
         4X6WqyXz6fWg5wEEeXlNTWwpMxekFoLxhE+jxBFpMK2wOfRC690GyTNgyY7hS6a7uv5U
         R5gE9a7wcOtjtoofpMKih75KY/Q2+ouJ/dD9vPkhhxPteO6+gZUDTtY+Ez4zUg5Y0YNu
         Hg0zsGIIU9DFbQrPjZuUNhkD3f5sJr+LLrliyUy3SPmgznez7RQkd4NAiDlwdY7vzOVV
         Qmo08WBdd3l2MTEmz+8eZ/FnHpHfWnO8JbG8N5UMcMp6YiAN8yazICIkyvVG4wGG9D+C
         8rbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K+p+qHBTPYAZlOemNmAAlCb4kwszE/8ejMy4SRvtpWE=;
        b=hwXaOlP8NikX1Fok8AWd7h1e+/IhNbB4jFVbS8w3/n9u+6M99P5JSdq/vHq0KM9Hzp
         Dg9gL+tzPUd8YgKZfaFjCtWt9NDsKB0eu7nC6dwANSQSkw5uUhidiIMuQ5ixjOxBRTff
         NMSZ+FnbUDdHS4NKGVQxafzcJWaG2Dry7cyGojRfHVzRZmfQK+Xs+gohlGSoMC2eXati
         9nGgbYcfE6vIPYbrDkcVG36wkias/xIuaKV7qoJQQNVBBbzzfj3SjhDxK65vhD6NMWqh
         4TZdbBNeFBm34YVidXY3dU9vdIuEHjAdw04rR/wfUvLodraLl1OK6ecJehnIZ7PAO2bm
         d49A==
X-Gm-Message-State: AOAM531rLlokhafkUL7qnrXq5lGuxnBkqD+Ng59R91AyJlBoDFIUjCS3
        rb6xbhhsT4t0jwJqw0aXTGQ=
X-Google-Smtp-Source: ABdhPJyVKED/HeIAX8B9xtA0zUqWpMNsapCx/0+M9H7ksGyTZRci/PDursmMhxWKAF8pepcCtDQlYg==
X-Received: by 2002:a17:906:d8dc:: with SMTP id re28mr8259462ejb.168.1607102613902;
        Fri, 04 Dec 2020 09:23:33 -0800 (PST)
Received: from [192.168.1.36] (111.red-88-21-205.staticip.rima-tde.net. [88.21.205.111])
        by smtp.gmail.com with ESMTPSA id s24sm3442281ejb.20.2020.12.04.09.23.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 09:23:32 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH 7/9] target/mips: Extract msa_translate_init() from
 mips_tcg_init()
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-8-f4bug@amsat.org>
 <9a103671-d4e7-bcff-c600-931655efbd2b@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <1d04e931-015b-116f-f189-3d24e015b087@amsat.org>
Date:   Fri, 4 Dec 2020 18:23:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <9a103671-d4e7-bcff-c600-931655efbd2b@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/4/20 5:30 PM, Richard Henderson wrote:
> On 12/2/20 12:44 PM, Philippe Mathieu-Daudé wrote:
>> Extract the logic initialization of the MSA registers from
>> the generic initialization.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>> ---
>>  target/mips/translate.c | 35 ++++++++++++++++++++---------------
>>  1 file changed, 20 insertions(+), 15 deletions(-)
> 
> Why?

msa_wr_d[] registers are only used by MSA, so in the next series
that allows me to move the 'static msa_wr_d[]' in msa_translate.c,
without having to declare them global with extern.

> 
>> -        fpu_f64[i] = tcg_global_mem_new_i64(cpu_env, off, msaregnames[i * 2]);
>> +        fpu_f64[i] = tcg_global_mem_new_i64(cpu_env, off, fregnames[i]);
> 
> Maybe fold this back to the previous patch?

Certainly ;)

> 
> 
> r~
> 
