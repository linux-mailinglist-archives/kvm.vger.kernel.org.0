Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D77A4D3C82
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 23:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238452AbiCIWDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 17:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbiCIWD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 17:03:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4656EBD0;
        Wed,  9 Mar 2022 14:02:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E989EB823C9;
        Wed,  9 Mar 2022 22:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCA4C340EE;
        Wed,  9 Mar 2022 22:02:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="T1fuvT6G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646863339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=inreFAnh9tqy7Qlx+a012zOsU9dSDc7ob/YEs/Oahuw=;
        b=T1fuvT6GNklQFVlKRs5Fx3/lhU5a5lY+x4d3BmbJ1TqqIVlkrwaQIbxgmi6jwH9EAOFwCQ
        rckR7B4h3E1/mdErRIlTDIzh3wvR1gGfJ9wLYG3LURJpc1KOhyCQRKHvDssSim+a8W5OGT
        Z5JNAqH3kaCA8JlF0U6Vt+/w9ac/tRk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 168a9f66 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 9 Mar 2022 22:02:19 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id z30so7271091ybi.2;
        Wed, 09 Mar 2022 14:02:18 -0800 (PST)
X-Gm-Message-State: AOAM5321QAGWIjalmdN5yIkXmh06FE1GRZ5qPlmzgJxwoyHDGnuFgE6B
        SosUaNvGpd76yKzRtTrsvQxBOnOylnRykDM4t8k=
X-Google-Smtp-Source: ABdhPJyCUVD8T4qqYuq1h5ED6rk/6Kw1l+qk/ag1MpB3SuWxlea1B5XdqPkq5wTPm3WvOPgfJuy34sJfOcw4H5dA8AQ=
X-Received: by 2002:a25:2312:0:b0:629:60d6:7507 with SMTP id
 j18-20020a252312000000b0062960d67507mr1596488ybj.267.1646863335346; Wed, 09
 Mar 2022 14:02:15 -0800 (PST)
MIME-Version: 1.0
References: <Yh4+9+UpanJWAIyZ@zx2c4.com> <c5181fb5-38fb-f261-9de5-24655be1c749@amazon.com>
In-Reply-To: <c5181fb5-38fb-f261-9de5-24655be1c749@amazon.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 9 Mar 2022 15:02:04 -0700
X-Gmail-Original-Message-ID: <CAHmME9rTMDkE7UA3_wg87mrDVYps+YaHw+dZwF0EbM0zC4pQQw@mail.gmail.com>
Message-ID: <CAHmME9rTMDkE7UA3_wg87mrDVYps+YaHw+dZwF0EbM0zC4pQQw@mail.gmail.com>
Subject: Re: propagating vmgenid outward and upward
To:     Alexander Graf <graf@amazon.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        linux-hyperv@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        adrian@parity.io, Laszlo Ersek <lersek@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Linux PM <linux-pm@vger.kernel.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>
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

Hi Alex,

On Wed, Mar 9, 2022 at 3:10 AM Alexander Graf <graf@amazon.com> wrote:
> > The vmgenid driver basically works, though it is racy, because that ACPI
> > notification can arrive after the system is already running again. This
>
>
> I believe enough people already pointed out that this assumption is
> incorrect. The thing that is racy about VMGenID is the interrupt based
> notification.

I'm having a hard time figuring out what's different between your
statement and mine. I said that the race is due to the notification.
You said that the race is due to the notification. What subtle thing
am I missing here that would lead you to say that my assumption is
incorrect? Or did you just misread?

> The actual identifier is updated before the VM resumes
> from its clone operation, so if you match on that you will know whether
> you are in a new or old world. And that is enough to create
> transactions: Save the identifier before a "crypto transaction",
> validate before you finish, if they don't match, abort, reseed and replay.

Right. But more than just transactions, it's useful to preventing key
reuse vulnerabilities, in which case, you store the current identifier
just before an ephemeral key is generated, and then subsequently check
to see that the identifier hasn't changed before transmitting anything
related to that key.

> If you follow the logic at the beginning of the mail, you can create
> something race free if you consume the hardware VMGenID counter. You can
> not make it race free if you rely on the interrupt mechanism.

Yes, as mentioned and discussed in depth before. However, your use of
the word "counter" is problematic. Vmgenid is not a counter. It's a
unique identifier. That means you can't compare it with a single word
comparison but have to compare all of the 16 bytes. That seems
potentially expensive. It's for that reason that I suggested
augmenting the vmgenid spec with an additional word-sized _counter_
that could be mapped into the kernels and into userspaces.

> So following that train of thought, if you expose the hardware VMGenID
> to user space, you could allow user space to act race free based on
> VMGenID. That means consumers of user space RNGs could validate whether
> the ID is identical between the beginning of the crypto operation and
> the end.

Right.

> However, there are more complicated cases as well. What do you do with
> Samba for example? It needs to generate a new SID after the clone.
> That's a super heavy operation. Do you want to have smbd constantly poll
> on the VMGenID just to see whether it needs to kick off some
> administrative actions?

Were it a single word-sized integer, mapped into memory, that wouldn't
be much of a problem at all. It could constantly read this before and
after every operation. The problem is that it's 16 bytes and
understandably applications don't want to deal with that clunkiness.

> In that case, all we would need from the kernel is an easily readable
> GenID that changes

Actually, no, you need even less than that. All that's required is a
sysfs/procfs file that can be poll()'d on. It doesn't need to have any
content. When poll() returns readable, the VM has been forked. Then
userspace rngs and other things like that can call getrandom() to
receive a fresh value to mix into whatever their operation is. Since
all we're talking about here is _event notification_, all we need is
that event, which is what poll() provides.

> I'm also not a super big fan of putting all that logic into systemd. It
> means applications need to create their own notification mechanisms to
> pass that cloning notification into actual processes. Don't we have any
> mechanism that applications and libraries could use to natively get an
> event when the GenID changes?

Yes. poll() can do this. For the purposes of discussion, I've posted
an implementation of this idea here:
https://lore.kernel.org/lkml/20220309215907.77526-1-Jason@zx2c4.com/

What I'm sort of leaning toward is doing something like that patch,
and then later if vmgenid ever grows an additional word-sized counter,
moving to explore the race-free approach. Given the amount of
programming required to actually implement the race-free approach
(transactions and careful study of each case), the poll() file
approach might be a medium-grade compromise for the time being.
Evidently that's what Microsoft decided too.

Jason
