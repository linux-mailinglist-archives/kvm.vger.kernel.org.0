Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A664C2A08
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 11:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbiBXK6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 05:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbiBXK6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 05:58:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FC815FCA3;
        Thu, 24 Feb 2022 02:57:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95309616A3;
        Thu, 24 Feb 2022 10:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B6CC340E9;
        Thu, 24 Feb 2022 10:57:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Aev4oP76"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645700268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l9uFhoNHD0ubvFpgP+CfgQfLWDk0rbzVcNs9eAAzOOE=;
        b=Aev4oP76SM7Ky5tVHBurpSFk24ePStDVbpz4sUcYrWj/NVQsvMbzkZERrzKlvWiREIkUjg
        pns/T3HQBI1W+E7V4L0ZxLhtdwhTycvyPky5RJ4kmyYS40PqhCMFfq2I7AWj1l2AbnW3gZ
        2IoA6U4VwICTXSzBigeWX4GouwiGKE4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4fcbc003 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 24 Feb 2022 10:57:48 +0000 (UTC)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-2d79394434dso20276797b3.5;
        Thu, 24 Feb 2022 02:57:46 -0800 (PST)
X-Gm-Message-State: AOAM530cAMgmcgZdTTGMm6D/VzoaOJA3qcwRN458+R+czbfdmZ8cDRfH
        gokMg0kKECaG4Otet9xnByjVuwDwZePzfDHPetY=
X-Google-Smtp-Source: ABdhPJwN40erEHMdIbnTWhaEGW2JI+hoWIa30mje4icqtRKOBfnV+2qG9wPZOdlYssF87EiAylHOO7YqwwX1PQC4yTE=
X-Received: by 2002:a81:5a83:0:b0:2ca:287c:6b5d with SMTP id
 o125-20020a815a83000000b002ca287c6b5dmr1747645ywb.2.1645700265594; Thu, 24
 Feb 2022 02:57:45 -0800 (PST)
MIME-Version: 1.0
References: <20220223131231.403386-1-Jason@zx2c4.com> <CAHmME9ogH_mx724n_deFfva7-xPCmma1-=2Mv0JdnZ-fC4JCjg@mail.gmail.com>
 <2653b6c7-a851-7a48-f1f8-3bde742a0c9f@redhat.com> <YhdkD4S7Erzl98So@redhat.com>
In-Reply-To: <YhdkD4S7Erzl98So@redhat.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 24 Feb 2022 11:57:34 +0100
X-Gmail-Original-Message-ID: <CAHmME9qRrLHwOjD+_xkGC7-BMVdzO95=DzhCo8KvDNa0JXVybA@mail.gmail.com>
Message-ID: <CAHmME9qRrLHwOjD+_xkGC7-BMVdzO95=DzhCo8KvDNa0JXVybA@mail.gmail.com>
Subject: Re: [PATCH RFC v1 0/2] VM fork detection for RNG
To:     =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc:     Laszlo Ersek <lersek@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>, linux-s390@vger.kernel.org,
        adrian@parity.io, "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>, graf@amazon.com,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Igor Mammedov <imammedo@redhat.com>, ehabkost@redhat.com,
        ben@skyportsystems.com, "Michael S. Tsirkin" <mst@redhat.com>,
        "Richard W.M. Jones" <rjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022 at 11:56 AM Daniel P. Berrang=C3=A9 <berrange@redhat.c=
om> wrote:
> IIRC this part of the QEMU doc was making an implicit assumption
> about the way QEMU is to be used by mgmt apps doing snapshots.
>
> Instead of using the 'loadvm' command on the existing running QEMU
> process, the doc seems to tacitly expect the management app will
> throwaway the existing QEMU process and spawn a brand new QEMU
> process to load the snapshot into, thus getting the new GUID on
> the QEMU command line.

Right, exactly. The "there are no known use cases" bit I think just
forgot about one very common use case that perhaps just wasn't in use
by the original author. So I'm pretty sure this remains a QEMU bug.

Jason
