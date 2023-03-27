Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CB36CAEAD
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 21:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjC0TcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 15:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjC0TcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 15:32:22 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BA930C0;
        Mon, 27 Mar 2023 12:32:16 -0700 (PDT)
Received: from zn.tnic (p5de8e687.dip0.t-ipconnect.de [93.232.230.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 280CE1EC06BB;
        Mon, 27 Mar 2023 21:32:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1679945535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LLhvGH+bUvhv78NgxBIICIWnnuwm6XkOZBqekmu7i8Q=;
        b=hbBJWP/YPO2mkYrsiC6Oe3oPjt5w1stXXPOB2ayqmhrMKWOW9o6MMnicDJaYsufX6qlpnx
        TR+FPtxI+uALQnbnYoHKKfc3sieg0rMMkVjjddO89qMX/Z+3sE9udL7sQTu3c/7guNgeuk
        R4GBn3fTApmIvFSUVQKmzgUuwPz7/YA=
Date:   Mon, 27 Mar 2023 21:32:10 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Brian Gerst <brgerst@gmail.com>,
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
Message-ID: <20230327193210.GCZCHvOmg0aT+CWorC@fat_crate.local>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
 <20230321194008.785922-9-usama.arif@bytedance.com>
 <20230322224735.GAZBuFh9ld6FuYEyoH@fat_crate.local>
 <70628793e6777d07f27f43152df497e780925d18.camel@infradead.org>
 <20230323085138.GAZBwTGly7iOlvxrD4@fat_crate.local>
 <4dbdd277c4b26ae4b971a910209a3279f79f6837.camel@infradead.org>
 <CAMzpN2guz4HTQ8uir9Q=xrUpCYyBfuG2zGSJsakaqY7_OvxCPQ@mail.gmail.com>
 <20230327174746.GBZCHWwqIa4+nj1/qR@fat_crate.local>
 <e0e76d1de1e90aafa2d14f95648fff2569b21a73.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e0e76d1de1e90aafa2d14f95648fff2569b21a73.camel@infradead.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 07:14:27PM +0100, David Woodhouse wrote:
> Shouldn't the rest of head64.c have the stack protector disabled, for
> similar reasons?

Not aware of any reason to that so far...

> Hm, doesn't most of that just go away (or at least become "Already
> Broken; Someone Else's Problem™") if you just concede to put your new C
> function into head64.c along with a whole bunch of other existing
> CONFIG_AMD_MEM_ENCRYPT support?

If it were only that, maybe, but we have to do the stack __va() thing as
Tom explained. So the jumping-through-hoops just to have a simple
function in C is not worth it... IMNSVHO, that is.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
