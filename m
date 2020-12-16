Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46182DBF1C
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 12:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgLPK7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 05:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgLPK7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 05:59:53 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FE1C061794
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 02:59:12 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id n16so1699838wmc.0
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 02:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lzxWfptX4BKMRnrPgmvlCAhfzeZueon8Z3MF5SLFZEE=;
        b=cZecBOVDcIAJcBNHKfUDrWzrwFzo1Ri01V3J4FCJbe1sZYodiOxt065aRGRm9c20kE
         OANI5ydHhk0fersfRdn6Q6g7zhpDGPdqbFwnQm+L+2iUqdNxeGhmKbv6cNaUzt7zENEY
         5I21dRsnazqR6z9MKB6IjCzaa3CHJlRrG05llU9nPuXhz57aDaU38yISimJ3zwU3BQ8A
         YjQZn7najPsBMfgwB2StrCcEO6PSt8NWnqTdN14fZUZI+qfYLPEZ/9dhKRW7//0tpFiz
         YdJBXdTQ637+tylKToFLfvHAh4CKB1gwjSTW2hsBowSDL0rAQny0BNtkAwAf184meMdQ
         FMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lzxWfptX4BKMRnrPgmvlCAhfzeZueon8Z3MF5SLFZEE=;
        b=IAaNW01DSaIsvdwiGDzWmVH25/Bial6DW5CPKV8xhWGNpB5jRYqi5akWbvV8uOAxgc
         qgvu1xKayrk26guk3CAGKm5GBByQmmtPhUPpqsh4T0SX6OAVOB1jPeWIL6fgJECW2A98
         IQgfDZ1frEPAxsZ0yItcN+YKH3wuqepsBhxfDy6dRJH2/47r4KHrW5JCA7xAjmkv2qfH
         RCDqtEHiaXNwLqIA0rcUZG1GRxT8sqrsEDm7aWN5IdepNQbaKiKZtjr0sBa58p5rH3yK
         oHSwOB2pUlsS5FkeEVh34w/glp57cglB9eBCElheiDTrI6rtXXMITu/B/ap9kAspFFz7
         Vfcw==
X-Gm-Message-State: AOAM532Yn3NA5q1tpMMHk5NXRfYuW4UuOnL45XjXMFm5v/FJLO5RAo6O
        0rnCzMQHgPp/4BZC7qotTEgEP9CHN5WauQ==
X-Google-Smtp-Source: ABdhPJwMbMjvF+SQtZUWn90z1HMQr34dUeTi7uDzMvGRdaq1MTs0DkRZ02Evh3UHUq6MTI0JHu0jxg==
X-Received: by 2002:a1c:7218:: with SMTP id n24mr2750496wmc.186.1608116351362;
        Wed, 16 Dec 2020 02:59:11 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id h29sm2632534wrc.68.2020.12.16.02.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 02:59:10 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v2 03/24] target/mips/cpu: Introduce isa_rel6_available()
 helper
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-4-f4bug@amsat.org>
 <508441db-8748-1b55-5f39-e6a778c0bdc0@linaro.org>
 <40e8df0f-01ab-6693-785b-257b8d3144bf@amsat.org>
 <af357960-40f2-b9e6-485f-d1cf36a4e95d@flygoat.com>
 <b1e8b44c-ae6f-786c-abe0-9a03eb5d3d63@flygoat.com>
 <5977d0f5-7e62-5f8a-d4ec-284f6f1af81d@amsat.org>
Message-ID: <c969a2ab-95bc-8a83-6d59-0037ba725c2a@amsat.org>
Date:   Wed, 16 Dec 2020 11:59:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <5977d0f5-7e62-5f8a-d4ec-284f6f1af81d@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/20 11:50 AM, Philippe Mathieu-Daudé wrote:
> On 12/16/20 4:14 AM, Jiaxun Yang wrote:
>> 在 2020/12/16 上午10:50, Jiaxun Yang 写道:
>>>
>>>
>>> TBH I do think it doesn't sounds like a good idea to make 32-bit
>>> and 64-bit different. In fact ISA_MIPS32R6 is always set for targets
>>> with ISA_MIPS64R6.
>>>
>>> We're treating MIPS64R6 as a superset of MIPS32R6, and ISA_MIPS3
>>> is used to tell if a CPU supports 64-bit.

I suppose you are talking about the CPU definitions
(CPU_MIPS32R6/CPU_MIPS64R6).

> 
> Which is why I don't understand why they are 2 ISA_MIPS32R6/ISA_MIPS64R6
> definitions.

My comment is about the ISA definitions:

#define ISA_MIPS32        0x0000000000000020ULL
#define ISA_MIPS32R2      0x0000000000000040ULL
#define ISA_MIPS64        0x0000000000000080ULL
#define ISA_MIPS64R2      0x0000000000000100ULL
#define ISA_MIPS32R3      0x0000000000000200ULL
#define ISA_MIPS64R3      0x0000000000000400ULL
#define ISA_MIPS32R5      0x0000000000000800ULL
#define ISA_MIPS64R5      0x0000000000001000ULL
#define ISA_MIPS32R6      0x0000000000002000ULL
#define ISA_MIPS64R6      0x0000000000004000ULL

> 
>>>
>>> FYI:
>>> https://commons.wikimedia.org/wiki/File:MIPS_instruction_set_family.svg
>>
>> Just add more cents here...
>> The current method we handle R6 makes me a little bit annoying.
>>
>> Given that MIPS is backward compatible until R5, and R6 reorganized a lot
>> of opcodes, I do think decoding procdure of R6 should be dedicated from
>> the rest,
>> otherwise we may fall into the hell of finding difference between R6 and
>> previous
>> ISAs, also I've heard some R6 only ASEs is occupying opcodes marked as
>> "removed in R6", so it doesn't looks like a wise idea to check removed
>> in R6
>> in helpers.
> 
> I'm not sure I understood well your comment, but I also find how
> R6 is handled messy...
> 
> I'm doing this removal (from helper to decoder) with the decodetree
> conversion.
> 
>> So we may end up having four series of decodetrees for ISA
>> Series1: MIPS-II, MIPS32, MIPS32R2, MIPS32R5 (32bit "old" ISAs)
>> Series2: MIPS-III, MIPS64, MIPS64R2, MIPS64R5 (64bit "old" ISAs)
>>
>> Series3: MIPS32R6 (32bit "new" ISAs)
>> Series4: MIPS64R6 (64bit "new" ISAs)
> 
> Something like that, I'm starting by converting the messier leaves
> first, so the R6 and ASEs. My approach is from your "series4" to
> "series1" last.
> 
> Regards,
> 
> Phil.
> 
