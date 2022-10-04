Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719305F421C
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 13:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiJDLkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 07:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiJDLkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 07:40:04 -0400
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806DD2C13D
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 04:39:57 -0700 (PDT)
Received: from zero.eik.bme.hu (blah.eik.bme.hu [152.66.115.182])
        by localhost (Postfix) with SMTP id 7177274632C;
        Tue,  4 Oct 2022 13:39:52 +0200 (CEST)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
        id 0601274632B; Tue,  4 Oct 2022 13:39:52 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by zero.eik.bme.hu (Postfix) with ESMTP id 03082746307;
        Tue,  4 Oct 2022 13:39:52 +0200 (CEST)
Date:   Tue, 4 Oct 2022 13:39:51 +0200 (CEST)
From:   BALATON Zoltan <balaton@eik.bme.hu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
cc:     Peter Maydell <peter.maydell@linaro.org>,
        =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        =?ISO-8859-15?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>
Subject: Re: [PATCH v2] mips/malta: pass RNG seed to to kernel via env var
In-Reply-To: <CAHmME9qDN_m6+6R3OiNueHc0qEcvptpO9+0HxZ713knZ=8fkoQ@mail.gmail.com>
Message-ID: <e687e447-c790-5628-377a-fa3ee8ad3@eik.bme.hu>
References: <YziPyCqwl5KIE2cf@zx2c4.com> <20221003103627.947985-1-Jason@zx2c4.com> <b529059a-7819-e49d-e4dc-7ae79ee21ec5@amsat.org> <CAHmME9pUuduiEcmi2xaY3cd87D_GNX1bkVeXNqVq6AL_e=Kt+Q@mail.gmail.com> <YzwM+KhUG0bg+P2e@zx2c4.com>
 <CAFEAcA9KsooNnYxiqQG-RHustSx0Q3-F8ibpQbXbwxDCA+2Fhg@mail.gmail.com> <CAHmME9qmSX=QmBa-k4T1U=Gnz-EtahnYxLmOewpN85H9TqNSmA@mail.gmail.com> <CAFEAcA9-_qmtJgy_WRJT5TUKMm_60U53Mb9a+_BqUnQSS7PPcg@mail.gmail.com>
 <CAHmME9qDN_m6+6R3OiNueHc0qEcvptpO9+0HxZ713knZ=8fkoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Probability: 8%
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Oct 2022, Jason A. Donenfeld wrote:
> On Tue, Oct 4, 2022 at 1:03 PM Peter Maydell <peter.maydell@linaro.org> wrote:
>> What I'm asking, I guess, is why you're messing with this board
>> model at all if you haven't added this functionality to u-boot.
>> This is just an emulation of an ancient bit of MIPS hardware, which
>> nobody really cares about very much I hope.
>
> I think most people emulating MIPS would disagree. This is basically a
> reference platform for most intents and purposes. As I mentioned, this
> involves `-kernel` -- the thing that's used when you explicitly opt-in
> to not using a bootloader, so when you sign up for QEMU arranging the
> kernel image and its environment. Neglecting to pass an RNG seed would
> be a grave mistake.
>
>> I'm not saying this is a bad patch -- I'm just saying that
>> QEMU should not be in the business of defining bootloader-to-kernel
>> interfaces if it can avoid it, so usually the expectation is
>> that we are just implementing interfaces that are already
>> defined, documented and implemented by a real bootloader and kernel.
>
> Except that's not really the way things have ever worked here. The
> kernel now has the "rngseed" env var functionality, which is useful
> for a variety of scenarios -- kexec, firmware, and *most importantly*
> for QEMU. Don't block progress here.
>
>> -kernel generally means "emulate the platform's boot loader"
>
> And here, a platform bootloader could pass this, just as is the case
> with m68k's BI_RNG_SEED or x86's setup_data RNG SEED or device tree's
> rng-seed or EFI's LINUX_EFI_RANDOM_SEED_TABLE_GUID or MIPS' "rngseed"
> fw environment variable. These are important facilities to have.
> Bootloaders and hypervisors alike must implement them. *Do not block
> progress here.*

Cool dowm. Peter does not want to block progress here. What he said was 
that the malta is (or should be) emulating a real piece of hardware so 
adding some stuff to it which is not on that real hardware may not be 
preferred. If you want to experiment with generic mips hardware maybe you 
need a virt board instead that is free from such restrictions to emulate a 
real hardware. Some archs already have such board and there seems to be 
loongson3-virt but no generic mips virt machine yet. Defining and 
implementing such board may be more than you want to do for this but maybe 
that would be a better way to go.

Regards,
BALATON Zoltan
