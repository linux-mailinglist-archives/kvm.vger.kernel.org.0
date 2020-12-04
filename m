Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DE72CF3C3
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 19:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgLDSPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgLDSPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:15:44 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C28C0613D1
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 10:15:04 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id s75so4061016oih.1
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 10:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xit7dWkZ/uWg67R5ypkMG8vhmSpZMrHrrLkUOGYkvmQ=;
        b=kwTU2ej5wtGAKMk/t/SF8HMCWQMT90z6Er7H5JjodPi/gdzGi98p/VeIPuI4ij07Dm
         4VRUdbDVQE1hFGYSVpAuX9p2rRAcaTO/1fhYcrKZbqIIhSkVqeQIegHcfzCfmLmbzU60
         esWmyU3vAatDrjvne9Modl4Xv2HQRicbGf1uyk/3Luo0jk0lfWCR/NuUhuInU8yClaYF
         OMP7acLniEQW0ctS42ZmEYsqBxn5cQckXwwcC4JmS/ITj+pJOb6jdbsNdvyoIegn7ArU
         UDEd7tgUooi4zmfTECherwojRZ6ykhq4Vbt0/NlC7griNWmlBEmTT4Ddqg7qnMpaUWpd
         x6Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xit7dWkZ/uWg67R5ypkMG8vhmSpZMrHrrLkUOGYkvmQ=;
        b=kstwGf0Ia/NtVraNT9YTJeDHA5sFmtVOTPkCLNPQ+n3mG06lJTzdRbNb62AT0CVy4l
         5xjedsyw4j9KfJbbRZD5XGatw5984n7WT8qbmhnrnJ/P/1YfYYFI7Qsh/88cX25sv8OM
         0DuK6fuaY6fHxC/mIUI90K3UJFWM0dvboO0dIWZ647Cz/NWSzNm/tVICp0gXLkyGQY22
         zrH8DnDKQE+3yKBouol+fJEOsGcsbM6eoq9e8idqXRHIKDgOFStXpSoWdMnqmmkjaTSF
         eHCWQ2E0DzwSvjVgVpG7XPSxSTZzPMudaLr9WtoR22EfIBMy/Cx3I0Zkl0P9tpkkAj4B
         Jzhg==
X-Gm-Message-State: AOAM533u1cXunB5TncVWmVFond+kRFDPh0c1PQKCOhECw3eD+BqeKZJJ
        UKcCfDQfOcjq8HLYa41kcynW6lxyE2epScGn
X-Google-Smtp-Source: ABdhPJwVGvS0KlNyzMEZr8Io3h0bNxMNQr8vTAObJ3nFQlo5BijMVIWuY6ycWapMvlNTr1CF8HRDhA==
X-Received: by 2002:aca:d514:: with SMTP id m20mr4060984oig.22.1607105703333;
        Fri, 04 Dec 2020 10:15:03 -0800 (PST)
Received: from [172.24.51.127] (168.189-204-159.bestelclientes.com.mx. [189.204.159.168])
        by smtp.gmail.com with ESMTPSA id w22sm778355otq.22.2020.12.04.10.15.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 10:15:02 -0800 (PST)
Subject: Re: [PATCH 7/9] target/mips: Extract msa_translate_init() from
 mips_tcg_init()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-8-f4bug@amsat.org>
 <9a103671-d4e7-bcff-c600-931655efbd2b@linaro.org>
 <1d04e931-015b-116f-f189-3d24e015b087@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <39c6980e-f02c-9eb2-f85e-e8bd26c0920f@linaro.org>
Date:   Fri, 4 Dec 2020 12:15:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1d04e931-015b-116f-f189-3d24e015b087@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/4/20 11:23 AM, Philippe Mathieu-Daudé wrote:
> On 12/4/20 5:30 PM, Richard Henderson wrote:
>> On 12/2/20 12:44 PM, Philippe Mathieu-Daudé wrote:
>>> Extract the logic initialization of the MSA registers from
>>> the generic initialization.
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>>> ---
>>>  target/mips/translate.c | 35 ++++++++++++++++++++---------------
>>>  1 file changed, 20 insertions(+), 15 deletions(-)
>>
>> Why?
> 
> msa_wr_d[] registers are only used by MSA, so in the next series
> that allows me to move the 'static msa_wr_d[]' in msa_translate.c,
> without having to declare them global with extern.

Ah, sure.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
