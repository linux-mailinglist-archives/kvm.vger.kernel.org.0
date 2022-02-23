Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4504C1865
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 17:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242693AbiBWQUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 11:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234267AbiBWQUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 11:20:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A9AC2E57;
        Wed, 23 Feb 2022 08:20:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3558161991;
        Wed, 23 Feb 2022 16:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D36C340E7;
        Wed, 23 Feb 2022 16:20:04 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="UStiHDap"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645633199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mnNQghKSAwgVNaMKLb/7Trnd/MlpODo5RAJNJEkv+10=;
        b=UStiHDapBFGqlKj1XnAopIV0s/o4/wZAQt9kfn6UaRkkAF7dlnJ3QqN5tRoz/ZORj1iyB8
        vZrQhcosPVD9IGzkANuD0g+v6mzrFASmeIaYq1MLaU1R7pw64al2PYmaHQo/tzRlnilQV3
        twyhhu3J7BJ8itNYnKzpSPL2yJlYi2o=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f2b47955 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 23 Feb 2022 16:19:59 +0000 (UTC)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-2d07c4a0d06so216796747b3.13;
        Wed, 23 Feb 2022 08:19:58 -0800 (PST)
X-Gm-Message-State: AOAM532sMYVig0AJIED7HaxncuMXSE8p8sWohVSJNx6/ZVLkj0euEdTq
        m5rVDcd9iq/dXWrkcJ7jgXyexa+1tBy2PSK9AZI=
X-Google-Smtp-Source: ABdhPJzwqPvYWBp9LmD+Jha02PrV5WLBK/ki8ek/2uyVWgeaMR+4EcGUKMupw6bI8EUKZpQFGjPwDZfx/kujcdtLLBc=
X-Received: by 2002:a81:5c83:0:b0:2d2:c136:70f3 with SMTP id
 q125-20020a815c83000000b002d2c13670f3mr401327ywb.404.1645633196792; Wed, 23
 Feb 2022 08:19:56 -0800 (PST)
MIME-Version: 1.0
References: <20220223131231.403386-1-Jason@zx2c4.com> <CAHmME9ogH_mx724n_deFfva7-xPCmma1-=2Mv0JdnZ-fC4JCjg@mail.gmail.com>
In-Reply-To: <CAHmME9ogH_mx724n_deFfva7-xPCmma1-=2Mv0JdnZ-fC4JCjg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 23 Feb 2022 17:19:45 +0100
X-Gmail-Original-Message-ID: <CAHmME9o9-eBCcjJMrJSdr23VfUEfvx12e4qRdtE5Sv3+Qcf-Bg@mail.gmail.com>
Message-ID: <CAHmME9o9-eBCcjJMrJSdr23VfUEfvx12e4qRdtE5Sv3+Qcf-Bg@mail.gmail.com>
Subject: Re: [PATCH RFC v1 0/2] VM fork detection for RNG
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>, linux-s390@vger.kernel.org,
        adrian@parity.io
Cc:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>, graf@amazon.com,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Igor Mammedov <imammedo@redhat.com>, ehabkost@redhat.com,
        ben@skyportsystems.com, "Michael S. Tsirkin" <mst@redhat.com>,
        lersek@redhat.com
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

On Wed, Feb 23, 2022 at 5:08 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Wed, Feb 23, 2022 at 2:12 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > second patch is the reason this is just an RFC: it's a cleanup of the
> > ACPI driver from last year, and I don't really have much experience
> > writing, testing, debugging, or maintaining these types of drivers.
> > Ideally this thread would yield somebody saying, "I see the intent of
> > this; I'm happy to take over ownership of this part." That way, I can
> > focus on the RNG part, and whoever steps up for the paravirt ACPI part
> > can focus on that.
>
> I actually managed to test this in QEMU, and it seems to work quite well. Steps:
>
> $ qemu-system-x86_64 ... -device vmgenid,guid=auto -monitor stdio
> (qemu) savevm blah
> (qemu) quit
> $ qemu-system-x86_64 ... -device vmgenid,guid=auto -monitor stdio
> (qemu) loadvm blah
>
> Doing this successfully triggers the function to reinitialize the RNG
> with the new GUID. (It appears there's a bug in QEMU which prevents
> the GUID from being reinitialized when running `loadvm` without
> quitting first; I suppose this should be discussed with QEMU
> upstream.)
>
> So that's very positive. But I would appreciate hearing from some
> ACPI/Virt/Amazon people about this.

Because something something picture thousand words something, here's a
gif to see this working as expected:
https://data.zx2c4.com/vmgenid-appears-to-work.gif

Jason
