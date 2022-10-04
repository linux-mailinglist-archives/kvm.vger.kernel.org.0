Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132F55F4124
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 12:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiJDK4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 06:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJDK4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 06:56:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD7653D17
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 03:56:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D503B819BB
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 10:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031F3C4347C
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 10:56:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="lkoijxx6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664880998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MbnnjNY7dxJhffw13LHqXbU48FSn6xKQZKhnAvC3CFI=;
        b=lkoijxx6++bD3micmSQcQS5Ld9Mf/CVveeDuPLmMsc9xuQD375j+l7i80e2HdwsVmTiCM6
        d3iAxno005kddg0mN3iw03IYVAHB8UifxjOh0yTOJw14t/DlXFMsmevfLh/v4kZ+X/omtf
        XSOFwOvn2CpciOx0LnO9F1KXudwQyTU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 801820c4 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <kvm@vger.kernel.org>;
        Tue, 4 Oct 2022 10:56:38 +0000 (UTC)
Received: by mail-vs1-f47.google.com with SMTP id 126so14178705vsi.10
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 03:56:38 -0700 (PDT)
X-Gm-Message-State: ACrzQf2ngEXCT/Yt7FqNoVvBWDrEKJ/t9QhNYX391CUDfVIXyyK9feNR
        pyZgybctTmJ/XiiKn0GfbGOyF8jVn+0+RNA5ERo=
X-Google-Smtp-Source: AMsMyM7XQIZG2kXHjqnHshSCHXVxCui3CUEyreoKg9UfOJo/mhjRL60uhsMTKYA+dv7W+k/BJh/9ui9OTwNYpdruLJg=
X-Received: by 2002:a67:d81e:0:b0:398:2c98:229b with SMTP id
 e30-20020a67d81e000000b003982c98229bmr10590301vsj.73.1664880996229; Tue, 04
 Oct 2022 03:56:36 -0700 (PDT)
MIME-Version: 1.0
References: <YziPyCqwl5KIE2cf@zx2c4.com> <20221003103627.947985-1-Jason@zx2c4.com>
 <b529059a-7819-e49d-e4dc-7ae79ee21ec5@amsat.org> <CAHmME9pUuduiEcmi2xaY3cd87D_GNX1bkVeXNqVq6AL_e=Kt+Q@mail.gmail.com>
 <YzwM+KhUG0bg+P2e@zx2c4.com> <CAFEAcA9KsooNnYxiqQG-RHustSx0Q3-F8ibpQbXbwxDCA+2Fhg@mail.gmail.com>
In-Reply-To: <CAFEAcA9KsooNnYxiqQG-RHustSx0Q3-F8ibpQbXbwxDCA+2Fhg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 4 Oct 2022 12:56:25 +0200
X-Gmail-Original-Message-ID: <CAHmME9qmSX=QmBa-k4T1U=Gnz-EtahnYxLmOewpN85H9TqNSmA@mail.gmail.com>
Message-ID: <CAHmME9qmSX=QmBa-k4T1U=Gnz-EtahnYxLmOewpN85H9TqNSmA@mail.gmail.com>
Subject: Re: [PATCH v2] mips/malta: pass RNG seed to to kernel via env var
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
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

On Tue, Oct 4, 2022 at 12:53 PM Peter Maydell <peter.maydell@linaro.org> wrote:
>
> On Tue, 4 Oct 2022 at 11:40, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > And just to give you some idea that this truly is possible from firmware
> > and I'm not just making it up, consider this patch to U-Boot:
> >
> > u-boot:
> > diff --git a/arch/mips/lib/bootm.c b/arch/mips/lib/bootm.c
> > index cab8da4860..27f3ee68c0 100644
> > --- a/arch/mips/lib/bootm.c
> > +++ b/arch/mips/lib/bootm.c
> > @@ -211,6 +211,8 @@ static void linux_env_legacy(bootm_headers_t *images)
> >                 sprintf(env_buf, "%un8r", gd->baudrate);
> >                 linux_env_set("modetty0", env_buf);
> >         }
> > +
> > +       linux_env_set("rngseed", "4142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f60");
> >  }
> >
>
> >
> > So, as you can see, it works perfectly. Thus, setting this in QEMU
> > follows *exactly* *the* *same* *pattern* as every other architecture
> > that allows for this kind of mechanism. There's nothing weird or unusual
> > or out of place happening here.
>
> I think the unusual thing here is that this patch isn't
> "this facility is implemented by u-boot [commit whatever,
> docs whatever], and here is the patch adding it to QEMU's
> handling of the same interface". That is, for boards like
> Malta the general expectation is that we're emulating
> a piece of real hardware and the firmware/bootloader
> that it would be running, so "this is a patch that
> implements an interface that the real bootloader doesn't
> have" is a bit odd.

Except it's not different from other platforms that get bootloader
seeds as such. A bootloader can easily pass this; QEMU most certainly
should pass this. (I sincerely hope you're not arguing in favor of
holding back progress in this area for yet another decade.)

Jason
