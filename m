Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D502D3616
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbgLHWUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgLHWUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:20:03 -0500
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D703FC0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:19:17 -0800 (PST)
Received: by mail-oo1-xc44.google.com with SMTP id i7so4397623oot.8
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xDwpGT726xRhONIQmJXT523muASAVX9eu2F70HGWcbA=;
        b=WKFvmq3yj7KNStVoPvwp8EW1UxKQo/+nbYIZGO+Uz8aP8rTQzjxpkNeIKlBYC7OvPQ
         LiT3QrHV5aqU49z4I+Sol2r9TXasSyPoBCy3krkLIBcCevAnyqAzN4eCivZuVZvrG8Fn
         n0+bO+U+Kg08gD48KjDVlnBhj56b/vKMnfERDVoUhbwZAKuaBv+C2t0icWSi0K/BMcie
         wFCBENXPXIZzbnF3Zimleg7wzdMfSOiVbVdgI1gJAnad4sIohpLcaUUhpZLmAeuOaz+o
         /Gx5buFn4AL8yZv5jSq7l3w553TjOZKmDqktJLamcVfM06RxUlxhHFme5G/lfoRHU2gP
         0TYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xDwpGT726xRhONIQmJXT523muASAVX9eu2F70HGWcbA=;
        b=DSkhd3qv2VB+1AZ3gJjSCxGHbf1NinD7XsOYVywfTlp6XINkQ5bGCei17LTj9wRy6K
         Tw6A3AXDALbXRQgqXA1hVHByD1M4MzGZJiypj//YxUpTS8TqNBc0yk4sOUWvEHwGxd3t
         kYy+SGmxQzPuB8X7Jd+96neaO/tG6Vb829/COF89KzMlTEWQBK7pvUq1261A4IQ2nJhN
         59OVnNZBnjTMquIMwhw4hZTzWi16AL7vmR9D8SWcDm0doHlB6nrFhxxwRnLt8pxvWj+3
         ZuXn7MUL7kzMrDPx3O5OzTFheV6sG1w0wFj2jEBT8inZqQTP849cWidLeS+prCJ29qxW
         X8oA==
X-Gm-Message-State: AOAM533PCXQ9Gd81o8E1izbMz6Ti5Vt7Y9aKA2ZeWDtGFuJOm5Oq8UMs
        304poCOylVCKJ/Uvj3zpDJbgXg==
X-Google-Smtp-Source: ABdhPJypmq/3QKljpyXxtaI0epcFY9NspamoM+y0fpQMw/M3ONAHUme4ODDeN8AC699XzUZsFykXqg==
X-Received: by 2002:a4a:ded4:: with SMTP id w20mr103760oou.49.1607465956716;
        Tue, 08 Dec 2020 14:19:16 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id v123sm29263oie.20.2020.12.08.14.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:19:16 -0800 (PST)
Subject: Re: [PATCH 14/19] target/mips: Move mmu_init() functions to
 tlb_helper.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-15-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <22e61d04-d118-1c25-40f7-476861c66825@linaro.org>
Date:   Tue, 8 Dec 2020 16:19:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-15-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/internal.h           |  1 +
>  target/mips/tlb_helper.c         | 46 ++++++++++++++++++++++++++++++
>  target/mips/translate_init.c.inc | 48 --------------------------------
>  3 files changed, 47 insertions(+), 48 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
