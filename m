Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88BF2CDC2A
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 18:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731494AbgLCRPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 12:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgLCRPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 12:15:44 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CE3C061A52
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 09:15:04 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id z13so685338ooa.5
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 09:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hXx5nPk6f0nIshK1/z7rNnx3MUbK/8ladJ1lmi1aEHE=;
        b=U6PJxWj1QGUbxZIRp0BlZ7R0McGRuurWqKShKO8ibIfNSD8nSK0+w3VRezFy/OfnU7
         zKyk3OCiYOe+vt9EO1pKDqY5QiAGHIqDXD3mrhGMEnrleD/BqFLmDYlIFQr2fv3erDlj
         I05ccOWAptQtfwITxUKChl3jnLkz1ihUysfQ6ExQXVkjfnL1JSqoAMJKgU8AlvrKCEcb
         NrUrGDGTGvSq4a+cHD4C6sZDG4p8Fbi7qCbbLYqW3vC7U44pvk7+s6EbdHlyFUnWgyjL
         NAOqJiuv8BivNU6BSF7UPXBpyTwNeA6dPSk0rD54Q2o3uQaN4MvHfSjung67cQUKNR5v
         JWBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hXx5nPk6f0nIshK1/z7rNnx3MUbK/8ladJ1lmi1aEHE=;
        b=fHLgyy+d+qy6Sn/uEH8L8u7kSdx/jk3BA5DRVbgslDaokIAN5Woq/hB5pnp5nsrIGL
         3XMhdOzO9goUcZoQsqAtEmKCxBrSZPNdpUanafPzcyNKn6+/9SWjqk/LEXDe2Y3HJXIa
         cBI8dH6QCDwO0Wp+v1F1uf6GExAG+R/Uc8IjCO33uUAoXOeSvEh8+e0ewEGxFurHBGLu
         Ekfbk51ahkkax4vmUOzZ5YK39CmyKyMYdUns/WqJa8zlrclp25YKRbD3vpMmZxX5wNrE
         zpSwOhbtkYyPcV/A4kw+WoSDM5kkIfH7au8HMy9i003oyj8fTGH9PD8MrTfvjQ1+Y3+u
         MIfg==
X-Gm-Message-State: AOAM532vpPzDteFJP0cPTemrw59Tq5JsgB3ol3QNy6gyi/DI8dMcohGf
        6ITkd2IrsdroECCkGqM+Ztdk1MmyqqagWA1N
X-Google-Smtp-Source: ABdhPJxnksoLRBZqWW7iNXzEWsoO52JG7O8CRmGa4cunrxEjx1v1+7B4wVXBxhIZLdsCmJYfuvzqjA==
X-Received: by 2002:a4a:cf08:: with SMTP id l8mr34254oos.29.1607015703995;
        Thu, 03 Dec 2020 09:15:03 -0800 (PST)
Received: from [172.24.51.127] (168.189-204-159.bestelclientes.com.mx. [189.204.159.168])
        by smtp.gmail.com with ESMTPSA id 11sm352188oty.65.2020.12.03.09.15.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 09:15:03 -0800 (PST)
Subject: Re: [PATCH 4/9] target/mips: Simplify MSA TCG logic
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-5-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <cb9fb1cd-095b-51cd-9ec7-fd9f1dfb0e5c@linaro.org>
Date:   Thu, 3 Dec 2020 11:14:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201202184415.1434484-5-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/20 12:44 PM, Philippe Mathieu-Daudé wrote:
> Only decode MSA opcodes if MSA is present (implemented).
> 
> Now than check_msa_access() will only be called if MSA is
> present, the only way to have MIPS_HFLAG_MSA unset is if
> MSA is disabled (bit CP0C5_MSAEn cleared, see previous
> commit). Therefore we can remove the 'reserved instruction'
> exception.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

