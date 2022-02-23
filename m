Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9E34C18CD
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 17:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242913AbiBWQhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 11:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239792AbiBWQhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 11:37:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1603D48B;
        Wed, 23 Feb 2022 08:36:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1168AB81EB0;
        Wed, 23 Feb 2022 16:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D506C340F0;
        Wed, 23 Feb 2022 16:36:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="dBbUnj8Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645634199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bHA9wsYJ+CM1DPnmNfQ6U6t4ARYsrAUZwd944SZ1sxQ=;
        b=dBbUnj8Ql1rn7FAM9tUx7QOeccnJ0Z+J90QA2NRMB22oXGOrYQ4THPe1b9gNNNzuDc2Rbg
        WFKaEvpmre/V326ePYzLARj899oTaO940Lp4D0jow0owG2+cfPO43/K8JgfsXjhbfX6w3C
        pTSz8qk0fkkwt5cQUp8mR9mxmGFUdSM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 12a21bdc (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 23 Feb 2022 16:36:39 +0000 (UTC)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-2d07ae0b1c4so217495627b3.11;
        Wed, 23 Feb 2022 08:36:36 -0800 (PST)
X-Gm-Message-State: AOAM531ZzDp8T9MDua0yyllGNbHUpN0ZeGck1o7sIP1h4pYFj2M9G5Mx
        sWaLNfG8d1sE/I1Oz64kjt2fk4WE/OsZ6f/VtJQ=
X-Google-Smtp-Source: ABdhPJxStncU0YhKj17fIfB92poX/i/hhH2go/+XupHLqAIG9vQtznWxOa4DHx+xY4+pyQBawqCM+CsOCCrLmtJDEw8=
X-Received: by 2002:a81:184c:0:b0:2d7:607f:4b00 with SMTP id
 73-20020a81184c000000b002d7607f4b00mr423650ywy.499.1645634196037; Wed, 23 Feb
 2022 08:36:36 -0800 (PST)
MIME-Version: 1.0
References: <20220223131231.403386-1-Jason@zx2c4.com> <20220223131231.403386-3-Jason@zx2c4.com>
In-Reply-To: <20220223131231.403386-3-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 23 Feb 2022 17:36:25 +0100
X-Gmail-Original-Message-ID: <CAHmME9oWUJr3fYKFOy=aRdd0uE8H8ke9o+KXde0zAnAwnWUPMA@mail.gmail.com>
Message-ID: <CAHmME9oWUJr3fYKFOy=aRdd0uE8H8ke9o+KXde0zAnAwnWUPMA@mail.gmail.com>
Subject: Re: [PATCH RFC v1 2/2] drivers/virt: add vmgenid driver for
 reinitializing RNG
To:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        linux-hyperv@vger.kernel.org
Cc:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>, graf@amazon.com,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Igor Mammedov <imammedo@redhat.com>, ehabkost@redhat.com,
        KVM list <kvm@vger.kernel.org>, adrian@parity.io,
        ben@skyportsystems.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        lersek@redhat.com, linux-s390@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>
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

Adding the Hyper-V people to this:

On Wed, Feb 23, 2022 at 2:13 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> VM Generation ID is a feature from Microsoft, described at
> <https://go.microsoft.com/fwlink/?LinkId=260709>, and supported by
> Hyper-V and QEMU. Its usage is described in Microsoft's RNG whitepaper,
> <https://aka.ms/win10rng>, as:
>
>     If the OS is running in a VM, there is a problem that most
>     hypervisors can snapshot the state of the machine and later rewind
>     the VM state to the saved state. This results in the machine running
>     a second time with the exact same RNG state, which leads to serious
>     security problems.  To reduce the window of vulnerability, Windows
>     10 on a Hyper-V VM will detect when the VM state is reset, retrieve
>     a unique (not random) value from the hypervisor, and reseed the root
>     RNG with that unique value.  This does not eliminate the
>     vulnerability, but it greatly reduces the time during which the RNG
>     system will produce the same outputs as it did during a previous
>     instantiation of the same VM state.
>
> Linux has the same issue, and given that vmgenid is supported already by
> multiple hypervisors, we can implement more or less the same solution.
> So this commit wires up the vmgenid ACPI notification to the RNG's newly
> added add_vmfork_randomness() function.
>
> This driver builds on prior work from Adrian Catangiu at Amazon, and it
> is my hope that that team can resume maintenance of this driver.

If any of you have some experience with the Hyper-V side of this
protocol, could you take a look at this and see if it matches the way
this is supposed to work? It appears to work fine with QEMU's
behavior, at least, but I know Hyper-V has a lot of additional
complexities.

Thanks,
Jason
