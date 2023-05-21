Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054B170ADA6
	for <lists+kvm@lfdr.de>; Sun, 21 May 2023 13:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjEULpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 May 2023 07:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbjEUL2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 May 2023 07:28:38 -0400
Received: from xry111.site (xry111.site [89.208.246.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605DD19B;
        Sun, 21 May 2023 04:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1684667871;
        bh=Q26CYmvUlS+fBTmmnY0bWV8ZvrwzVZeSJzFo8/ADxRA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cjPlRo3SnYcMX+/nzK6H1iJmrb6mzETgC1X6eqv7JRPssiRUIG6tseoXXED9IvDcx
         Gzy21SjMmc39YBDXEDucNGM4yB8HMqyMKDzA9x+leMkBQjtrpV8nZXFut5uPzySYAk
         taQOMV+xU7K8xC5qkI/GluXEZiUnMnuCgINgr8gU=
Received: from localhost.localdomain (xry111.site [IPv6:2001:470:683e::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id 1A72565AEB;
        Sun, 21 May 2023 07:17:48 -0400 (EDT)
Message-ID: <aa66d0049add6a780a8f04f998a24eef25605bde.camel@xry111.site>
Subject: Re: [PATCH v10 00/30] Add KVM LoongArch support
From:   Xi Ruoyao <xry111@xry111.site>
To:     WANG Xuerui <kernel@xen0n.name>, maobibo <maobibo@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Tianrui Zhao <zhaotianrui@loongson.cn>
Date:   Sun, 21 May 2023 19:17:47 +0800
In-Reply-To: <4529ee5b-364a-7819-c727-71cf94057b8b@xen0n.name>
References: <20230515021522.2445551-1-zhaotianrui@loongson.cn>
         <02f07d8e-e1c2-2ec0-59c3-f5b4ef0463dc@loongson.cn>
         <4529ee5b-364a-7819-c727-71cf94057b8b@xen0n.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2023-05-21 at 18:22 +0800, WANG Xuerui wrote:

/* snip */

> (BTW, how do people usually deal with pre-release hardware wit=20
> documentation not out yet? I suppose similar situations like this should=
=20
> turn up fairly often.)

Intel normally releases the doc much earlier than shipping the hardware
to customers.  For example, the x86 Linear Address Masking doc has been
released in 2020 (allowing Linus himself to hack the LAM code in kernel
:), but AFAIK there is no Intel CPU models released with LAM support yet
(at least my Raptor Lake does not indicate LAM in cpuid, or maybe I'm
missing the latest server models?)

For other vendors I'm not sure.

> Aside from this, there's another point: use of undocumented instructions=
=20
> in raw form with ".word". This currently doesn't work in LLVM/Clang,=20

Hmm, is it an inherent limitation of Clang or it's simply not
implemented for LoongArch yet?  On x86_64 I tried ".byte 0x90" in the
inline assembly and Clang correctly emits a nop instruction.

> thus will slightly set back the ongoing ClangBuiltLinux enablement=20
> effort (currently all such usages in arch/loongarch are related to=20
> "invtlb" which has perfect support, and can be removed). AFAIK, such=20
> practice dates back to the LoongISA times, when the Loongson extended=20
> opcodes weren't supported by the upstream MIPS toolchains for some=20
> reason; but LoongArch is independent and not bounded by anyone else now,=
=20
> so it's better in terms of maintainability to just add the instructions=
=20
> to the toolchains. People will not be inconvenienced by having to use=20
> bleeding-edge LoongArch toolchains because upstream LoongArch devs have=
=20
> always been doing this.

Or it may be resolved by some fancy #ifdef directives.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
