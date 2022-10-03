Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C355F3995
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 01:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiJCXIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 19:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiJCXIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 19:08:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3182A705
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 16:07:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 182A1B81661
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 23:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BEAC43141
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 23:07:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="oHbNBsdR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664838472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9kVkhpjdnrE6B8B7y9+mYkzmDiKwBb8ehMPaBrwpZ6w=;
        b=oHbNBsdREjRvgKAuIkUUZ4Uy8ZlsFMqIYAhKLR47kQEaz1VifTX4qxCJ7303YE3kCyWXH1
        5opZtE4XKOudqB58J3eQoVjkCB1FAV+O2o2Y0YZ9R5xgFJ3fi7Ag7wuLEspphVHYIx6UJ4
        ed9edK5oKKD06GegNjyAPx+KRl3CJ/k=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a3a61393 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <kvm@vger.kernel.org>;
        Mon, 3 Oct 2022 23:07:51 +0000 (UTC)
Received: by mail-vs1-f50.google.com with SMTP id u189so12990636vsb.4
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 16:07:51 -0700 (PDT)
X-Gm-Message-State: ACrzQf21mjzSDMRP4hfMzhqWWWnuVFUVWmojfVmlxfHFXoh3HmCGlVDy
        lzQgWwjgIG5fLOks2R7LgLqhaqRlK8nLCJeADug=
X-Google-Smtp-Source: AMsMyM5k1EJYnricRR5QUuTKdRKqdyGtiZ4OmxJLT/TqN7IKFBk6b6vHdi/CpzdX0EljHldR1kp0XKyNaIHWlvfFLAY=
X-Received: by 2002:a05:6102:2908:b0:398:ac40:d352 with SMTP id
 cz8-20020a056102290800b00398ac40d352mr8425524vsb.55.1664838469902; Mon, 03
 Oct 2022 16:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <YziPyCqwl5KIE2cf@zx2c4.com> <20221003103627.947985-1-Jason@zx2c4.com>
 <b529059a-7819-e49d-e4dc-7ae79ee21ec5@amsat.org>
In-Reply-To: <b529059a-7819-e49d-e4dc-7ae79ee21ec5@amsat.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 4 Oct 2022 01:07:38 +0200
X-Gmail-Original-Message-ID: <CAHmME9pUuduiEcmi2xaY3cd87D_GNX1bkVeXNqVq6AL_e=Kt+Q@mail.gmail.com>
Message-ID: <CAHmME9pUuduiEcmi2xaY3cd87D_GNX1bkVeXNqVq6AL_e=Kt+Q@mail.gmail.com>
Subject: Re: [PATCH v2] mips/malta: pass RNG seed to to kernel via env var
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Cc:     qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Philippe,

On Tue, Oct 4, 2022 at 12:36 AM Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.or=
g> wrote:
> Send each new revision as a new top-level thread, rather than burying it
> in-reply-to an earlier revision, as many reviewers are not looking
> inside deep threads for new patches.

Will do.

> You seem to justify this commit by the kernel commit, which justifies
> itself mentioning hypervisor use... So the egg comes first before the
> chicken.

Oh, that's not really the intention. My goal is to provide sane
interfaces for preboot environments -- whether those are in a
hypervisor like QEMU or in firmware like CFE -- to pass a random seed
along to the kernel. To that end, I've been making sure there's both a
kernel side and a QEMU side, and submitting both to see what folks
think. The fact that you have some questions (below) is a good thing;
I'm glad to have your input on it.

> > +
> > +    qemu_guest_getrandom_nofail(rng_seed, sizeof(rng_seed));
> > +    for (size_t i =3D 0; i < sizeof(rng_seed); ++i) {
> > +        sprintf(rng_seed_hex + i * 2, "%02x", rng_seed[i]);
> > +    }
> > +    prom_set(prom_buf, prom_index++, "rngseed");
> > +    prom_set(prom_buf, prom_index++, "%s", rng_seed_hex);
>
> You use the firmware interface to pass rng data to an hypervisor...
>
> Look to me you are forcing one API to ease another one. From the
> FW PoV it is a lie, because the FW will only change this value if
> an operator is involved. Here PROM stands for "programmable read-only
> memory", rarely modified. Having the 'rngseed' updated on each
> reset is surprising.
>
> Do you have an example of firmware doing that? (So I can understand
> whether this is the best way to mimic this behavior here).
>
> Aren't they better APIs to have hypervisors pass data to a kernel?

So a firmware interface *is* the intended situation here. To answer
your last question first: the "standard" firmware interface for
passing these seeds is via device tree's "rng-seed" field. There's
also a EFI protocol for this. And on x86 it can be passed through the
setup_data field. And on m68k the bootinfo bootloader/firmware struct
has a BI_RNG_SEED type. There's plenty of ARM and x86 hardware that
uses device tree and EFI for this, where the firmware is involved in
generating the seeds, and in the device tree case, in mangling the
device tree to have the right values. So, to answer your first
question, yes I think this is indeed a firmware-style interface.

Right now this is obviously intended for QEMU (and other hypervisors)
to implement. Later I'm hoping that firmware environments like CFE
might gain support for setting this. (You could do so interactively
now with "setenv".) So it seems like the environment block here really
is the right way to pass this. If you have a MIPS/malta platform
alternative, I'd be happy to consider it with you, but in my look at
things so far, the fw env block seems like by far the best way of
doing this, especially so considering it's part of both real firmware
environments and QEMU, and is relatively straightforward to implement.

Jason
