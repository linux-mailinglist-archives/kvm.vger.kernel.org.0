Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DE06CAC24
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 19:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjC0RsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 13:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbjC0Rr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 13:47:57 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A061998;
        Mon, 27 Mar 2023 10:47:54 -0700 (PDT)
Received: from zn.tnic (p5de8e687.dip0.t-ipconnect.de [93.232.230.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BDDD41EC0529;
        Mon, 27 Mar 2023 19:47:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1679939272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=PHYrWpJG1Eo5CYWlM+Samk6UV4vi/6VkdcGtjWhhz3E=;
        b=LZDmm7cVkLs74Dbe0DlzjSdfqAT+3TtQyaFNdMA9us8RBVGTPJxp7kGYP2nSIqFdZmO3IM
        w0iesHwUQJ63xT/yaLzE24dVC1hIvYleoyD1KsNXozhyootNzO7SsmvB+B8Pkbtna1ALRl
        9cvTub7Xj+bhQZHfg5y4hrUDIh6Hbtc=
Date:   Mon, 27 Mar 2023 19:47:46 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brian Gerst <brgerst@gmail.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, tglx@linutronix.de,
        kim.phillips@amd.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, arjan@linux.intel.com, mingo@redhat.com,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, Sabin Rapan <sabrapan@amazon.com>
Subject: Re: [PATCH v16 8/8] x86/smpboot: Allow parallel bringup for SEV-ES
Message-ID: <20230327174746.GBZCHWwqIa4+nj1/qR@fat_crate.local>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
 <20230321194008.785922-9-usama.arif@bytedance.com>
 <20230322224735.GAZBuFh9ld6FuYEyoH@fat_crate.local>
 <70628793e6777d07f27f43152df497e780925d18.camel@infradead.org>
 <20230323085138.GAZBwTGly7iOlvxrD4@fat_crate.local>
 <4dbdd277c4b26ae4b971a910209a3279f79f6837.camel@infradead.org>
 <CAMzpN2guz4HTQ8uir9Q=xrUpCYyBfuG2zGSJsakaqY7_OvxCPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMzpN2guz4HTQ8uir9Q=xrUpCYyBfuG2zGSJsakaqY7_OvxCPQ@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023 at 10:23:02AM -0400, Brian Gerst wrote:
> Making sure that the stack protector is either disabled or properly
> set up, and disabling any instrumentation/profiling/debug crap that
> isn't initialized yet.

Lemme dump brain of what Tom and I were talking about today so that it
is documented somewhere.

* re: stack protector: I was thinking to mark this function

 __attribute__((no_stack_protector))

but gcc added the function attribute way later:

~/src/gcc/gcc.git> git tag --contains 346b302d09c1e6db56d9fe69048acb32fbb97845
basepoints/gcc-12
basepoints/gcc-13
releases/gcc-11.1.0
releases/gcc-11.2.0
releases/gcc-11.3.0
releases/gcc-12.1.0
releases/gcc-12.2.0

which means, that function would have to live somewhere in a file which
has stack protector disabled. One possible place would be
arch/x86/mm/mem_encrypt_identity.c which is kinda related.

* re: stack: in order to be able to call a C function that early, we'd
have to put the VA of the initial stack back into %rsp as we switch
pagetables a bit earlier in there (thx Tom).

So by then, doing all that cargo-cult just in order to not have a bunch
of lines in asm doesn't sound all that great anymore.

* The __head per-function attribute is easily solved by lifting the
__head define into a common header.

So meh, dunno. I guess we can do the asm thing for now, until a cleaner
solution without too many warts presents itself.

As to exporting cc_vendor:

https://lore.kernel.org/r/20230318115634.9392-1-bp@alien8.de

I'll redo those and the SEV-ES patch won't have to add cc_get_vendor().

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
