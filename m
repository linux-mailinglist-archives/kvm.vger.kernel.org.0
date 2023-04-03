Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651516D5200
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 22:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbjDCUHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 16:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbjDCUH2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 16:07:28 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21874216
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 13:06:39 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id d11-20020a05600c3acb00b003ef6e6754c5so15122775wms.5
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 13:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680552398;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kF4VeBaBHNKaM8RaKCVCnZB9/48vA23/7ebrFFgjUXc=;
        b=qmgAnzR2/m2dpq+eSZD57DdAnRX2IormgfE1/Cz052IMdbBftBt7AhMPAJeOnd5sGc
         HSQwngBHIwoLyLlFc0BxesEHeoz/CgFzlCP1C9eRSfTXb49EfMhcK/mxCaKq1JGZaa+4
         Yc8Z2uFM88w35mAnSXf/cRUxru6X+0OwvIle91lK73TI/wyDJ6jN70hiOHHMbTwA1Udk
         I4n8WPxdohvGe4fuikmsp+QHcq2ctNhKFIZb1pSrBN8Y145kYsEKVVKOWqNC2gW1iLBa
         Q6+a8E8yCcpV5ize7ztYkgREWZa7Zt5a0Qi2WiuTodOsRXVmWAHf1HPMNGPTiMqKCb+5
         6fMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680552398;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kF4VeBaBHNKaM8RaKCVCnZB9/48vA23/7ebrFFgjUXc=;
        b=1vGKyCq/4S+XW1KPPYJty+xt787swCPX78eVbVDrqG7Py4Sx2xobgNVPOY9kBQa8qJ
         pxsVUgNTGV/KZwGg7L97ZK8fNeDKlkOE8rvTo2akOnZt6ZAbWK2HCPIZs/MmK+GXwDFv
         WVbxHYQMg1GDPP2I544ADb6z/Cj70CRG27Jq9nY9jS2JiGAxMR+hOVH1XyGBiIMC9tdT
         M8d0vwLuRpqj4JS3WUxTCVYedoBhQhHkusqh58j3Sjql8dBMHUbbPHgv3+Cj21gC5JCI
         PcHh2Z8pdzHXJYMcctas80x0JN8mKNvmqA50d7HH1JGsybxNGHJczwndhLaSw6P8ozUz
         ojYA==
X-Gm-Message-State: AAQBX9d26gbv7B39I0gleTVLjX0mGs8NTiWTx0hjTp0TCF8vQmpFF0d9
        KYdnol0J0juqGWyH+ecW0xNde44nRrmlgk0dXt1ywQ==
X-Google-Smtp-Source: AKy350ZvaqGsNDDkE3HEX3lbDnV94GZ8xrZMF70qEX3HG3fCZSm/mFiDAdY1UW6wEh8qnAiUGedviQ==
X-Received: by 2002:a7b:c450:0:b0:3ed:f966:b272 with SMTP id l16-20020a7bc450000000b003edf966b272mr466982wmi.9.1680552398071;
        Mon, 03 Apr 2023 13:06:38 -0700 (PDT)
Received: from ?IPV6:2003:f6:af22:1600:2f4c:bf50:182f:1b04? (p200300f6af2216002f4cbf50182f1b04.dip0.t-ipconnect.de. [2003:f6:af22:1600:2f4c:bf50:182f:1b04])
        by smtp.gmail.com with ESMTPSA id iw13-20020a05600c54cd00b003ef6988e54csm19953897wmb.15.2023.04.03.13.06.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 13:06:37 -0700 (PDT)
Message-ID: <4f77d3a6-ed17-051e-5aa3-17fc3ab6dc7f@grsecurity.net>
Date:   Mon, 3 Apr 2023 22:06:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH v3 3/4] x86/access: Forced emulation
 support
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20230403105618.41118-1-minipli@grsecurity.net>
 <20230403105618.41118-4-minipli@grsecurity.net>
 <dc285a74-9cce-2886-f8aa-f10e1a94f6f5@grsecurity.net>
 <ZCsjp0666b9DOj+n@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZCsjp0666b9DOj+n@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.04.23 21:06, Sean Christopherson wrote:
> On Mon, Apr 03, 2023, Mathias Krause wrote:
>> On 03.04.23 12:56, Mathias Krause wrote:
>>> Add support to enforce access tests to be handled by the emulator, if
>>> supported by KVM. Exclude it from the ac_test_exec() test, though, to
>>> not slow it down too much.
>>
>> I tend to read a lot of objdumps and when initially looking at the
>> generated code it was kinda hard to recognize the FEP instruction, as
>> the FEP actually decodes to UD2 followed by some IMUL instruction that
>> lacks a byte, so when objdump does its linear disassembly, it eats a
>> byte from the to-be-emulated instruction. Like, "FEP; int $0xc3" would
>> decode to:
>>    0:	0f 0b                	ud2
>>    2:	6b 76 6d cd          	imul   $0xffffffcd,0x6d(%rsi),%esi
>>    6:	c3                   	retq
>> This is slightly confusing, especially when the shortened instruction is
>> actually a valid one as above ("retq" vs "int $0xc3").
>>
>> I have the below diff to "fix" that. It adds 0x3e to the FEP which would
>> restore objdump's ability to generate a proper disassembly that won't
>> destroy the to-be-emulated instruction. As 0x3e decodes to the DS prefix
>> byte, which the emulator assumes by default anyways, this should mostly
>> be a no-op. However, it helped me to get a proper code dump.a
> 
> I agree that the objdump output is annoying, but I don't love the idea of cramming
> in a prefix that's _mostly_ a nop.
> 
> Given that FEP utilizes extremely specialized, off-by-default KVM code, what about
> reworking FEP in KVM itself to play nice with objdump (and other disasm tools)?
> E.g. "officially" change the magic prefix to include a trailing 0x3e.  Though IMO,
> even better would be a magic value that decodes to a multi-byte nop, e.g.
> 0F 1F 44 00 00.  The only "requirement" is that the magic value doesn't get
> false positives, and I can't imagine any of our test environments generate a ud2
> followed by a multi-byte nop.

Well, the above is a bad choice, actually, as that mirrors what GNU as
might generate when asked to generate a 5-byte NOP, e.g. for filling the
inter-function gap. And if there is a UD2 as last instruction and we're
unlucky to hit it, e.g. because we're hitting some UBSAN instrumented
error handling, we'll instead trigger "forced emulation" in KVM and
fall-through to the next function. Have fun debugging that! ;P

$ echo 'foo: ret; ud2; .balign 8; baz: int3' | as - && objdump -d
[...]
0000000000000000 <foo>:
   0:	c3                   	retq
   1:	0f 0b                	ud2
   3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000000008 <baz>:
   8:	cc                   	int3

> 
> Keeping KVM-Unit-Tests and KVM synchronized on the correct FEP value would be a
> pain, but disconnects between KVM and KUT are nothing new.

Nah, that would be an ABI break, IMO a no-go. What I was suggesting was
pretty much the patch: change selective users in KUT to make them
objdump-friendly. The FEP as-is is ABI, IMO, and cannot be changed any
more. We could add a FEP2 that's more objdump-friedly, but there's
really no need to support yet another byte combination in KVM itself. It
can all be handled by its users, e.g. in KUT as proposed with the 0x3e
suffix.

But, as I said, it's mostly just me trying to read disassembly and I see
others don't have the need to. So this doesn't need to lead anywhere.
But I thought I bring it up, in case there's others questioning why some
of the KUT code dumps look so weird in objdump ;)

Thanks,
Mathias
