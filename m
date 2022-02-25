Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A80A4C43CF
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 12:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240229AbiBYLpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 06:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240074AbiBYLos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 06:44:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2911E1120;
        Fri, 25 Feb 2022 03:44:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0E52B82F54;
        Fri, 25 Feb 2022 11:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15F2C340F3;
        Fri, 25 Feb 2022 11:44:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WgPgrIJv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645789447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4DOzzb5bPeBm91aTgBwVBtXqFO7gEojNByIp2VrGcGI=;
        b=WgPgrIJv+eJCiP+RNC0ak+loKvoPTiafXcrUvinRxFYUL1PWjSadCXR5waFlKO1kJmQRVA
        bdrbktrP5mLSIYYN2L/qsfe07mlZfPavWrylrtCcbbdaUL08/LxurZlwVTz+yWLW/N55rA
        SYWkCEP5k6fLWlIfwPUfFQxYxk6nlyI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3aa9ce72 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 25 Feb 2022 11:44:06 +0000 (UTC)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2d625082ae2so30552257b3.1;
        Fri, 25 Feb 2022 03:44:05 -0800 (PST)
X-Gm-Message-State: AOAM530qJIGoHy0srsRYyw2r5xApwTNNiVN+1pJOUOoNjtZa0YtVdk2K
        5iZlX1A/cphu/J1W+EkvHvWrueITpzvNwzZilz4=
X-Google-Smtp-Source: ABdhPJzv+CVGB9ScV57HLQEIPOB4K2x1NdbhDdZ7xG0urOaWpqGNRrFO4DDY8yMZvr/ISU1ydibFfeHHEc/MZpaqSq0=
X-Received: by 2002:a81:7d04:0:b0:2d0:d0e2:126f with SMTP id
 y4-20020a817d04000000b002d0d0e2126fmr6922055ywc.485.1645789444259; Fri, 25
 Feb 2022 03:44:04 -0800 (PST)
MIME-Version: 1.0
References: <20220224133906.751587-1-Jason@zx2c4.com> <20220224133906.751587-2-Jason@zx2c4.com>
 <CAMj1kXGuh62A8=43NjSMLRkux_TCFULXtw5a1C5w=gy9A8dO6w@mail.gmail.com>
In-Reply-To: <CAMj1kXGuh62A8=43NjSMLRkux_TCFULXtw5a1C5w=gy9A8dO6w@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 25 Feb 2022 12:43:53 +0100
X-Gmail-Original-Message-ID: <CAHmME9r_WZ7hTaPpq=JKzVj-9bfnbE=J_z+aMHzrjPv=6y2_CA@mail.gmail.com>
Message-ID: <CAHmME9r_WZ7hTaPpq=JKzVj-9bfnbE=J_z+aMHzrjPv=6y2_CA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] random: add mechanism for VM forks to reinitialize crng
To:     Ard Biesheuvel <ardb@kernel.org>
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
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 12:26 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 24 Feb 2022 at 14:39, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > When a VM forks, we must immediately mix in additional information to
> > the stream of random output so that two forks or a rollback don't
> > produce the same stream of random numbers, which could have catastrophic
> > cryptographic consequences. This commit adds a simple API, add_vmfork_
> > randomness(), for that, by force reseeding the crng.
> >
> > This has the added benefit of also draining the entropy pool and setting
> > its timer back, so that any old entropy that was there prior -- which
> > could have already been used by a different fork, or generally gone
> > stale -- does not contribute to the accounting of the next 256 bits.
> >
> > Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> > Cc: Theodore Ts'o <tytso@mit.edu>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Eric Biggers <ebiggers@google.com>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>

Okay if I treat this as a Reviewed-by instead?
