Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA1570B344
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 04:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjEVChg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 May 2023 22:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjEVChe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 May 2023 22:37:34 -0400
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC86FBF;
        Sun, 21 May 2023 19:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
        t=1684723048; bh=2I37PoGTbZtIxILPqHRdtx9Ofw+v5h7+2+yuRe0uyXY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=KFsw6ekVQ3j3EjS4tBu9id9rY9133f1FoEeQzmnSPT1tW3x+0upklnWahcL7jgR6s
         RejJ0t8pcMOsGfbHRJUmPGc1SGQOYabX+Pu0nu3x1VWtVzNKUdsSdcTxJ6jMiqMYZI
         O9MTUADUpalQgYNg+EYrgio/RiRNJ471E+pxKZ1Q=
Received: from [100.100.57.122] (unknown [58.34.185.106])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 114F4600DA;
        Mon, 22 May 2023 10:37:27 +0800 (CST)
Message-ID: <90b2fc60-af26-4ba6-f775-7db2514a62f4@xen0n.name>
Date:   Mon, 22 May 2023 10:37:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH v10 00/30] Add KVM LoongArch support
Content-Language: en-US
To:     maobibo <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>,
        Tianrui Zhao <zhaotianrui@loongson.cn>
References: <20230515021522.2445551-1-zhaotianrui@loongson.cn>
 <02f07d8e-e1c2-2ec0-59c3-f5b4ef0463dc@loongson.cn>
 <4529ee5b-364a-7819-c727-71cf94057b8b@xen0n.name>
 <99371487-717a-64d6-1c3d-aaeaee6f20db@loongson.cn>
From:   WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <99371487-717a-64d6-1c3d-aaeaee6f20db@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/5/22 09:39, maobibo wrote:
> 
> 
> 在 2023/5/21 18:22, WANG Xuerui 写道:
>> On 2023/5/18 10:56, maobibo wrote:
>>> <snip>
>> (BTW, how do people usually deal with pre-release hardware wit documentation not out yet? I suppose similar situations like this should turn up fairly often.)
> Manual is actually one issue, however it does not prevent the review
> process. There are some drivers for *fruit* devices, I can not find
> the hw manual also.  With the manual, it helps to review and points
> out the further and detailed issues.

There's a *slight* difference: the certain vendor you've mentioned is 
historically uncooperative in providing the documentation, so outside 
contributors had to reverse-engineer and document the HW themselves; but 
in Loongson's case, you *are* the vendor, so you are probably in a 
position that can make everyone's life easier by at least pushing for 
the docs release...

>>
>> Aside from this, there's another point: use of undocumented instructions in raw form with ".word". This currently doesn't work in LLVM/Clang <snip>
> As for one new architecture, it is normal to use .word or .insn, instruction
> will update for the first few years and also compiler may be not supported
> timely. The other arch has the same phenomenon if you grep "\.insn", also
> llvm on LoongArch supports ".word" directives.
> 
> After three or five years, we will remove these ".insn" macro when hw and
> compiler is matured.

Sorry for the confusion at my side; `.word` certainly works, what 
doesn't work currently seems to be the `parse_r` helper. I know because 
I've tried in the last week with latest LLVM/Clang snapshot. And you 
can't write ergonomic inline asm with proper register allocator 
awareness without the helper; the LoongArch assembler isn't capable of 
assembling in a certain encoding format. With RISC-V `.insn` you can do 
things like `.insn r 0xNN, 0, 0, a0, a1, a2`, but you cannot simply e.g. 
express gcsrxchg with `.insn DJK 0x05000000, a0, a1, a2` because no such 
instruction format convention has been standardized. (The notation 
demonstrated here is taken from [1].)

In any case, it seems best to at least wait for the documentation 
release a little bit, or you should state clearly that this is not going 
to happen soon, so people can properly manage their expectation and 
prioritize. (For example, if I know docs and/or assembler support for 
the virtualization extension won't come soon, then I'd work on 
supporting the .word idiom before other things. Otherwise there are more 
important things than that.)

[1]: https://github.com/loongson/LoongArch-Documentation/pull/56

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/

