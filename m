Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236254C43D5
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 12:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240211AbiBYLpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 06:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236551AbiBYLpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 06:45:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA6F1E149B;
        Fri, 25 Feb 2022 03:45:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E729AB82F54;
        Fri, 25 Feb 2022 11:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E1CC340F1;
        Fri, 25 Feb 2022 11:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645789499;
        bh=SyCcd5YyTFEoGeGsYaB35HytNVv8VEbM/zH5Nnq5ve0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UA1J9wUChl+3NAGjvYQsIrCIUKBsdCbyK5N29bUZyjGQnA02heNKfk5Dn2ZJtsylZ
         9yYbb0x00luCWmM2biJtE3AMv+3fjLudhyN3RgkQGTuu/0I1x2ovnW1dPI3lnLxVJ3
         XxcGmvFsgCD2uLuXqn1Wbv9aNHrfJeUc2RgB6i1ZhSLktnz/2oQLcDrI2/LsQ2aLHO
         awHBMZueY5I2cnfWxiWttBCdi00+NNONLvKnPxCrw5IAbNIjVw4kVWJ4aEeHnRLIYv
         dCsjPUKcTSKtcbgbStHoaD9JR8YEUdt6SHv6X5/DbVPxKjDmCuo0FZ5JQLYGgW40Vu
         Za6rCXxmqRQ0Q==
Received: by mail-yb1-f182.google.com with SMTP id j12so5302420ybh.8;
        Fri, 25 Feb 2022 03:44:59 -0800 (PST)
X-Gm-Message-State: AOAM533QxHiLljL1RfxGwoMdJrXcSr7S6555MHVzTjYLE0A/DB36f2V+
        WYHb6Zey8Go2Np+SH6p88OdkFcAkps3L51Sai6w=
X-Google-Smtp-Source: ABdhPJw20WQ6OeE6e3QFGaeduOMLc1gtByftoR3pgLNQmEnrN6vNG+m6AxxfV6mUzDPnla1p5Et4lg45CPQ/LSYqTqY=
X-Received: by 2002:a25:6c43:0:b0:61d:e94b:3c55 with SMTP id
 h64-20020a256c43000000b0061de94b3c55mr6880234ybc.224.1645789498678; Fri, 25
 Feb 2022 03:44:58 -0800 (PST)
MIME-Version: 1.0
References: <20220224133906.751587-1-Jason@zx2c4.com> <20220224133906.751587-2-Jason@zx2c4.com>
 <CAMj1kXGuh62A8=43NjSMLRkux_TCFULXtw5a1C5w=gy9A8dO6w@mail.gmail.com> <CAHmME9r_WZ7hTaPpq=JKzVj-9bfnbE=J_z+aMHzrjPv=6y2_CA@mail.gmail.com>
In-Reply-To: <CAHmME9r_WZ7hTaPpq=JKzVj-9bfnbE=J_z+aMHzrjPv=6y2_CA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 25 Feb 2022 12:44:47 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF9-JcjRoUgJgdVZo0Q6E5GezH1YGtE4H-u-kMjGHzQgg@mail.gmail.com>
Message-ID: <CAMj1kXF9-JcjRoUgJgdVZo0Q6E5GezH1YGtE4H-u-kMjGHzQgg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] random: add mechanism for VM forks to reinitialize crng
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-hyperv@vger.kernel.org, KVM list <kvm@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        adrian@parity.io, "Woodhouse, David" <dwmw@amazon.co.uk>,
        Alexander Graf <graf@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, ben@skyportsystems.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Feb 2022 at 12:44, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Fri, Feb 25, 2022 at 12:26 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Thu, 24 Feb 2022 at 14:39, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > When a VM forks, we must immediately mix in additional information to
> > > the stream of random output so that two forks or a rollback don't
> > > produce the same stream of random numbers, which could have catastrophic
> > > cryptographic consequences. This commit adds a simple API, add_vmfork_
> > > randomness(), for that, by force reseeding the crng.
> > >
> > > This has the added benefit of also draining the entropy pool and setting
> > > its timer back, so that any old entropy that was there prior -- which
> > > could have already been used by a different fork, or generally gone
> > > stale -- does not contribute to the accounting of the next 256 bits.
> > >
> > > Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> > > Cc: Theodore Ts'o <tytso@mit.edu>
> > > Cc: Jann Horn <jannh@google.com>
> > > Cc: Eric Biggers <ebiggers@google.com>
> > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> >
> > Acked-by: Ard Biesheuvel <ardb@kernel.org>
>
> Okay if I treat this as a Reviewed-by instead?

Sure no problem.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
