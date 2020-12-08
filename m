Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A6D2D3683
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbgLHWxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729455AbgLHWxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:53:53 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5379CC061794
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:53:13 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id x13so352973oto.8
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SFXsQ+ZL8smNF6MNBjq1JJdyJ4Nb7UXN76z2bTOG1U8=;
        b=QnMlTkuF6/WYt/hgzZVCUjDYQZQwTJhKKdFXCR7+n9hTKAo+F2AEjWM0wUoW/ezzcA
         oUwIgtDt67Hc6DlIF/z2M04PNXOcWZ+26GZ+2hchx40/zBtq0BXNRJaJsnptDR6UO+0+
         f1IkoG2tlYJuCIRm9UPI4OiBtlc3omNRaRiRJMAHMLwRaFt7CTVytXOdjq/sXnSj+hFJ
         DsMXayBAPY2Icy8JtDc6x2zp8h0aCSbkmPMtFlIvhXhLcR3gbP+SdWTughzgiFx65g6/
         I2/2gKcSU819Hf9BJ74oLORso/TdAog1oNPthRC5k++Qbymh7A3lVW28FYCM4KegTJ5k
         3L4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SFXsQ+ZL8smNF6MNBjq1JJdyJ4Nb7UXN76z2bTOG1U8=;
        b=bMVhwLxupchnv6t+XpoEFMtMU8xSIW7lQQxdRNH0oG+dOdsrvenc+psS8dfojAWiFU
         PFryXkAUo2Z+04cOkPC4c7U4/aLbatMgXust67dYW4hUG1BD3ngtiym1GBMEhE1NDyX2
         r8lVk+MB8ZSLwvZXd/4sSuWRRko0JPmdvevrkxSq46PM8AyA1RbXtCCogMQ46cIMN56D
         pIhtUBWjOjiyFEe1QLQm3bT9cwgfpvJXTvwiNuOAOMbVlMnF1j4pAfGEAU8vuLE/jJsi
         Qk2MJ9EDYpEkXmVnAMzGORVzgBJuZ4JxpJywXwma/poCc4LC26AxqFoyRnY5jdX9T6wz
         Ealw==
X-Gm-Message-State: AOAM533xXbQATJ2QCzquH3f6zZ2Qj+tIs7r4yElNobYlkjqXaOV8Ttn9
        6pUqssDZxMPAHXXimpjaP7+08anc1eTDLLMs
X-Google-Smtp-Source: ABdhPJzkRgh3xjn5OOZwFA+d+SVbrXddo4DcMH4bvBElqVZEudzwmZ2fOoE+obKd9dv3PXL4s0KoOw==
X-Received: by 2002:a9d:6414:: with SMTP id h20mr328025otl.28.1607467992432;
        Tue, 08 Dec 2020 14:53:12 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id q18sm88770ood.35.2020.12.08.14.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:53:11 -0800 (PST)
Subject: Re: [PATCH 1/7] target/mips/translate: Extract DisasContext structure
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
References: <20201207235539.4070364-1-f4bug@amsat.org>
 <20201207235539.4070364-2-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <030912c0-ec70-9b24-5466-e2d3e8f62dab@linaro.org>
Date:   Tue, 8 Dec 2020 16:53:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201207235539.4070364-2-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 5:55 PM, Philippe Mathieu-Daudé wrote:
> Extract DisasContext to a new 'translate.h' header so
> different translation files (ISA, ASE, extensions)
> can use it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.h | 50 +++++++++++++++++++++++++++++++++++++++++
>  target/mips/translate.c | 38 +------------------------------
>  2 files changed, 51 insertions(+), 37 deletions(-)
>  create mode 100644 target/mips/translate.h

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

