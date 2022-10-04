Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0B65F42AE
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 14:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiJDMIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 08:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiJDMIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 08:08:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6440B56035
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 05:08:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F31356141D
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 12:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22448C43140
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 12:08:29 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gRviq8OZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664885304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1WYt3tfkX9Y5rRqCgl8ykZPiYtnObjXtCPj2ZYZkv2E=;
        b=gRviq8OZXumIsHKAp+55iJ6mhFOLS4w0Iy8PYuDrNuWCXspASxGMgIhjGgPujY7bDgvPIk
        LICpvGQb/S+wYvMoQcyAIcpy+CcZv9mVfQnYT0gIHQ18RruTryuq/E37u8yh2NuJQl/AWh
        KTfc02vBOXDGrcQBaVk9dNy8cUxpB9U=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f0ff765b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <kvm@vger.kernel.org>;
        Tue, 4 Oct 2022 12:08:24 +0000 (UTC)
Received: by mail-ed1-f54.google.com with SMTP id g27so1645455edf.11
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 05:08:24 -0700 (PDT)
X-Gm-Message-State: ACrzQf3qAK+pD3qOHcHOiKsPAwDSzo2UC2nrQeuSxq+xCNNVlpjviQCn
        SqXe7dkmF9CZQPWMDctGDCiH+PulMrVVl32hNS8=
X-Google-Smtp-Source: AMsMyM6BMdjJJcr8LU8PJBRqQCcMaMFITxM1njNh6QZDxPUMM/LicFeGQoUwzFKZkTo397iDntXyFpo+B3LTBokdWbc=
X-Received: by 2002:a50:c31b:0:b0:458:cc93:8000 with SMTP id
 a27-20020a50c31b000000b00458cc938000mr12939127edb.264.1664885301896; Tue, 04
 Oct 2022 05:08:21 -0700 (PDT)
MIME-Version: 1.0
References: <YziPyCqwl5KIE2cf@zx2c4.com> <20221003103627.947985-1-Jason@zx2c4.com>
 <b529059a-7819-e49d-e4dc-7ae79ee21ec5@amsat.org> <CAHmME9pUuduiEcmi2xaY3cd87D_GNX1bkVeXNqVq6AL_e=Kt+Q@mail.gmail.com>
 <YzwM+KhUG0bg+P2e@zx2c4.com> <CAFEAcA9KsooNnYxiqQG-RHustSx0Q3-F8ibpQbXbwxDCA+2Fhg@mail.gmail.com>
 <CAHmME9qmSX=QmBa-k4T1U=Gnz-EtahnYxLmOewpN85H9TqNSmA@mail.gmail.com>
 <CAFEAcA9-_qmtJgy_WRJT5TUKMm_60U53Mb9a+_BqUnQSS7PPcg@mail.gmail.com>
 <CAHmME9qDN_m6+6R3OiNueHc0qEcvptpO9+0HxZ713knZ=8fkoQ@mail.gmail.com> <e687e447-c790-5628-377a-fa3ee8ad3@eik.bme.hu>
In-Reply-To: <e687e447-c790-5628-377a-fa3ee8ad3@eik.bme.hu>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 4 Oct 2022 14:08:09 +0200
X-Gmail-Original-Message-ID: <CAHmME9o+wbEVXdP1jK3z5s+U5JM2Ljrky_daCfpNr3A7dRw09A@mail.gmail.com>
Message-ID: <CAHmME9o+wbEVXdP1jK3z5s+U5JM2Ljrky_daCfpNr3A7dRw09A@mail.gmail.com>
Subject: Re: [PATCH v2] mips/malta: pass RNG seed to to kernel via env var
To:     BALATON Zoltan <balaton@eik.bme.hu>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 4, 2022 at 1:39 PM BALATON Zoltan <balaton@eik.bme.hu> wrote:
>
> On Tue, 4 Oct 2022, Jason A. Donenfeld wrote:
> > On Tue, Oct 4, 2022 at 1:03 PM Peter Maydell <peter.maydell@linaro.org> wrote:
> >> What I'm asking, I guess, is why you're messing with this board
> >> model at all if you haven't added this functionality to u-boot.
> >> This is just an emulation of an ancient bit of MIPS hardware, which
> >> nobody really cares about very much I hope.
> >
> > I think most people emulating MIPS would disagree. This is basically a
> > reference platform for most intents and purposes. As I mentioned, this
> > involves `-kernel` -- the thing that's used when you explicitly opt-in
> > to not using a bootloader, so when you sign up for QEMU arranging the
> > kernel image and its environment. Neglecting to pass an RNG seed would
> > be a grave mistake.
> >
> >> I'm not saying this is a bad patch -- I'm just saying that
> >> QEMU should not be in the business of defining bootloader-to-kernel
> >> interfaces if it can avoid it, so usually the expectation is
> >> that we are just implementing interfaces that are already
> >> defined, documented and implemented by a real bootloader and kernel.
> >
> > Except that's not really the way things have ever worked here. The
> > kernel now has the "rngseed" env var functionality, which is useful
> > for a variety of scenarios -- kexec, firmware, and *most importantly*
> > for QEMU. Don't block progress here.
> >
> >> -kernel generally means "emulate the platform's boot loader"
> >
> > And here, a platform bootloader could pass this, just as is the case
> > with m68k's BI_RNG_SEED or x86's setup_data RNG SEED or device tree's
> > rng-seed or EFI's LINUX_EFI_RANDOM_SEED_TABLE_GUID or MIPS' "rngseed"
> > fw environment variable. These are important facilities to have.
> > Bootloaders and hypervisors alike must implement them. *Do not block
> > progress here.*
>
> Cool dowm. Peter does not want to block progress here. What he said was
> that the malta is (or should be) emulating a real piece of hardware so
> adding some stuff to it which is not on that real hardware may not be
> preferred. If you want to experiment with generic mips hardware maybe you
> need a virt board instead that is free from such restrictions to emulate a
> real hardware. Some archs already have such board and there seems to be
> loongson3-virt but no generic mips virt machine yet. Defining and
> implementing such board may be more than you want to do for this but maybe
> that would be a better way to go.

This is the bikeshed suggestion that puts along the path of nothing
ever getting done. This is an interface that's available for real
firmware; there's no reason not to implement it here. It's the same
situation as the MIPS boston board setting the rng-seed device tree
property. There's nothing new or unusual about this, and it fits with
how things work elsewhere on the architecture and QEMU at large.
Besides, "malta" is the de facto platform used for emulating MIPS.

Again, this is obvious progress blocking in action. Look how it's done
elsewhere; look at how it's done in this patch; there's no difference.
This patch is boring and unoffensive. We don't need to waste time
bikeshedding it.

Jason
