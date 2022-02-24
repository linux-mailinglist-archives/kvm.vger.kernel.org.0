Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121F64C29CE
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 11:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiBXKoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 05:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiBXKo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 05:44:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CD628F45F;
        Thu, 24 Feb 2022 02:43:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C16661686;
        Thu, 24 Feb 2022 10:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026EDC340F3;
        Thu, 24 Feb 2022 10:43:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Q7fh+TEW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645699434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sL/kUSLvWygB2PavSQ97uF3uxu/r6EDQi5d4jb1S2zQ=;
        b=Q7fh+TEWi5sqyNHkVmDL943q58viSoJlYQbQVZQfXMhTynPL2WacdLl5YlxKooAdONKJMi
        fCCFVP799XPCxIZM8rVYKf/Bg9Ma4SE0OWtmgMbcWRUJtBRM9DjJbduQMNXH5rt/qslIxH
        mCbPtnx8e7CqdbYk0ml7z+YsFxu+/O4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5641c343 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 24 Feb 2022 10:43:54 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id j12so2895444ybh.8;
        Thu, 24 Feb 2022 02:43:52 -0800 (PST)
X-Gm-Message-State: AOAM5328JViNfLn4Yk5P/FzbSfL4cAbbZewErL0acwE89G2AqVspg878
        wkXz/IV7wtU+OUsMm55dEk/GQpZRjyzNCgJ7Z/4=
X-Google-Smtp-Source: ABdhPJyD6AgYJgfomnQ4h/8Dt+RdkCcpIpTKOhmvVM8csH9TSR/juMBC9kj7EYCe29IQJZix5mE0qLTy0v0jwO0zL24=
X-Received: by 2002:a25:b905:0:b0:61e:23e4:949f with SMTP id
 x5-20020a25b905000000b0061e23e4949fmr1827124ybj.373.1645699431569; Thu, 24
 Feb 2022 02:43:51 -0800 (PST)
MIME-Version: 1.0
References: <20220223131231.403386-1-Jason@zx2c4.com> <CAHmME9ogH_mx724n_deFfva7-xPCmma1-=2Mv0JdnZ-fC4JCjg@mail.gmail.com>
 <2653b6c7-a851-7a48-f1f8-3bde742a0c9f@redhat.com>
In-Reply-To: <2653b6c7-a851-7a48-f1f8-3bde742a0c9f@redhat.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 24 Feb 2022 11:43:40 +0100
X-Gmail-Original-Message-ID: <CAHmME9ogtK-iS7Szodbf47iGGJJ7TAxtico4P_-VRRYkUtUKgw@mail.gmail.com>
Message-ID: <CAHmME9ogtK-iS7Szodbf47iGGJJ7TAxtico4P_-VRRYkUtUKgw@mail.gmail.com>
Subject: Re: [PATCH RFC v1 0/2] VM fork detection for RNG
To:     Laszlo Ersek <lersek@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
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
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        "Richard W.M. Jones" <rjones@redhat.com>
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

Hi Lazlo,

Thanks for your reply.

On Thu, Feb 24, 2022 at 9:23 AM Laszlo Ersek <lersek@redhat.com> wrote:
> QEMU's related design is documented in
> <https://git.qemu.org/?p=qemu.git;a=blob;f=docs/specs/vmgenid.txt>.

I'll link to this document on the 2/2 patch next to the other ones.

> "they can also use the data provided in the 128-bit identifier as a high
> entropy random data source"
>
> So reinitializing an RNG from it is an express purpose.

It seems like this is indeed meant to be used for RNG purposes, but
the Windows 10 RNG document says: "Windows 10 on a Hyper-V VM will
detect when the VM state is reset, retrieve a unique (not random)
value from the hypervisor." I gather from that that it's not totally
clear what the "quality" of those 128 bits are. So this patchset mixes
them into the entropy pool, but does not credit it, which is
consistent with how the RNG deals with other data where the conclusion
is, "probably pretty good but maybe not," erring on the side of
caution. Either way, it's certainly being used -- and combined with
what was there before -- to reinitialize the RNG following a VM fork.

>
> More info in the libvirt docs (see "genid"):
>
> https://libvirt.org/formatdomain.html#general-metadata

Thanks, noted in the 2/2 patch too.

> QEMU's interpretation of the VMGENID specifically as a UUID (which I
> believe comes from me) has received (valid) criticism since:
>
> https://github.com/libguestfs/virt-v2v/blob/master/docs/vm-generation-id-across-hypervisors.txt
>
> (This document also investigates VMGENID on other hypervisors, which I
> think pertains to your other message.)

Thank you very much for this reference! You're absolutely right here.
v3 will treat this as just an opaque 128-bit binary blob. There's no
point, anyway, in treating it as a UUID in the kernel, since it never
should be printed or exposed to anywhere except random.c (and my gifs,
of course :-P).

>
> > (It appears there's a bug in QEMU which prevents
> > the GUID from being reinitialized when running `loadvm` without
> > quitting first; I suppose this should be discussed with QEMU
> > upstream.)
>
> That's not (necessarily) a bug; see the end of the above-linked QEMU
> document:
>
> "There are no known use cases for changing the GUID once QEMU is
> running, and adding this capability would greatly increase the complexity."

I read that, and I think I might disagree? If you're QEMUing with the
monitor and are jumping back and forth and all around between saved
snapshots, probably those snapshots should have their RNG
reinitialized through this mechanism, right? It seems like doing that
would be the proper behavior for `guid=auto`, but not for
`guid={some-fixed-thing}`.

> > So that's very positive. But I would appreciate hearing from some
> > ACPI/Virt/Amazon people about this.
>
> I've only made some random comments; I didn't see a question so I
> couldn't attempt to answer :)

"Am I on the right track," I guess, and your reply has been very
informative. Thanks for your feedback. I'll have a v3 sent out not
before long.

Jason
