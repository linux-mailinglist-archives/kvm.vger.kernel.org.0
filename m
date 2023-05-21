Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7425070ADD1
	for <lists+kvm@lfdr.de>; Sun, 21 May 2023 13:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjEULsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 May 2023 07:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjEUK1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 May 2023 06:27:45 -0400
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580D31B4;
        Sun, 21 May 2023 03:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
        t=1684664572; bh=6bQqYSey8mS2bTEsYB7j3/EUnIUGLpRwZkXxTWoD9rQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=e/1lu6zFvq9gZwsA5LHrtocFnFCvkiEPoJNeF6vuul9CazKzepVyurhpWa92JOZ2L
         /2pqbG54GdOaxAV/eeAfPycxn8rTx451i7Won0bqOqw44l6TiqanJwbfRd2G00oPYj
         wZHlfJ3hZ2/pEQr/NeiEXCXpfKfNzifluSSH6P28=
Received: from [100.100.57.122] (unknown [58.34.185.106])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 571376006F;
        Sun, 21 May 2023 18:22:52 +0800 (CST)
Message-ID: <4529ee5b-364a-7819-c727-71cf94057b8b@xen0n.name>
Date:   Sun, 21 May 2023 18:22:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
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
From:   WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <02f07d8e-e1c2-2ec0-59c3-f5b4ef0463dc@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/5/18 10:56, maobibo wrote:
> Hi Paolo & Huacai,
> 
> Sorry to bother you, I do not know flow of kernel code reviewing and merging.
> 
> I want to know who should give a reviewed-by comments for these piece of code
> about loongarch kvm patch. It should be kvm maintainer or LoongArch maintianer?
> And any suggestion is welcome.

IMO the series should get its R-b from kvm maintainers (because it's kvm 
after all), and ideally also Acked-by from arch/loongarch maintainers 
(because it contains arch-specific code), according to common sense.

But in order for the various maintainers/reviewers to effectively 
review, maybe the LoongArch ISA manual Volume 3 (containing details 
about the virtualization extension) should be put out soon. AFAIK Huacai 
has access to it, by being a Loongson employee, but I don't know if he 
can review this series in the public without violating NDAs; Loongson 
outsiders like me and the kvm reviewers can only trust the commit 
messages and comments for the time being.

(BTW, how do people usually deal with pre-release hardware wit 
documentation not out yet? I suppose similar situations like this should 
turn up fairly often.)

Aside from this, there's another point: use of undocumented instructions 
in raw form with ".word". This currently doesn't work in LLVM/Clang, 
thus will slightly set back the ongoing ClangBuiltLinux enablement 
effort (currently all such usages in arch/loongarch are related to 
"invtlb" which has perfect support, and can be removed). AFAIK, such 
practice dates back to the LoongISA times, when the Loongson extended 
opcodes weren't supported by the upstream MIPS toolchains for some 
reason; but LoongArch is independent and not bounded by anyone else now, 
so it's better in terms of maintainability to just add the instructions 
to the toolchains. People will not be inconvenienced by having to use 
bleeding-edge LoongArch toolchains because upstream LoongArch devs have 
always been doing this.

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/

