Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850A64C935C
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbiCASiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237095AbiCASiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:38:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEFB25EB0;
        Tue,  1 Mar 2022 10:37:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91235B81BFB;
        Tue,  1 Mar 2022 18:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9E0C340EE;
        Tue,  1 Mar 2022 18:37:23 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aQfeTqt3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646159840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VSlbgJdpoP+AY+bV5mfkN+zErWZpSrp0RJgkPDVSc0A=;
        b=aQfeTqt3Blqmd7xwmnnemPOkABs2OSRQfD3vrWDfSpclMht5sVb5NhIpVgxjRlEiCLkj7u
        TWiA9VszkWjvxE0Yx8q/qb/9de6ZpRvFOxGB1JCkF6eZfpa4GxXxMZ/IWhlVmVPlgRK2e5
        TKYSF2+nWIzlxjGcVXAAqFsV6gVdKi4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 61d2a11b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 1 Mar 2022 18:37:20 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-2dc0364d2ceso5938327b3.7;
        Tue, 01 Mar 2022 10:37:18 -0800 (PST)
X-Gm-Message-State: AOAM533aWgITWalmDDlDTyk01ub1VY3yAnLIG9sIfSRQ0gWxD6mJQdbF
        LnsLkRs33jUjOwpRvgltivZHmvFIxVgMa1kgT8I=
X-Google-Smtp-Source: ABdhPJxjsymwg5XYl+9GOoc41diKHCjvuVitOGfsmWq8BKG7jLc7Bwscjb/8sbN68Rx5awXeXGZ28M5wy+3vS8Wf7hE=
X-Received: by 2002:a81:8984:0:b0:2db:6b04:be0c with SMTP id
 z126-20020a818984000000b002db6b04be0cmr13093941ywf.2.1646159837032; Tue, 01
 Mar 2022 10:37:17 -0800 (PST)
MIME-Version: 1.0
References: <Yh4+9+UpanJWAIyZ@zx2c4.com> <223f858c-34c5-3ccd-b9e8-7585a976364d@redhat.com>
 <Yh5JwK6toc/zBNL7@zx2c4.com> <20220301121419-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220301121419-mutt-send-email-mst@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 1 Mar 2022 19:37:06 +0100
X-Gmail-Original-Message-ID: <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com>
Message-ID: <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com>
Subject: Re: propagating vmgenid outward and upward
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Laszlo Ersek <lersek@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        linux-hyperv@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alexander Graf <graf@amazon.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        adrian@parity.io,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
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

Hi Michael,

On Tue, Mar 1, 2022 at 6:17 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> Hmm okay, so it's a performance optimization... some batching then? Do
> you really need to worry about every packet? Every 64 packets not
> enough?  Packets are after all queued at NICs etc, and VM fork can
> happen after they leave wireguard ...

Unfortunately, yes, this is an "every packet" sort of thing -- if the
race is to be avoided in a meaningful way. It's really extra bad:
ChaCha20 and AES-CTR work by xoring a secret stream of bytes with
plaintext to produce a ciphertext. If you use that same secret stream
and xor it with a second plaintext and transmit that too, an attacker
can combine the two different ciphertexts to learn things about the
original plaintext.

But, anyway, it seems like the race is here to stay given what we have
_currently_ available with the virtual hardware. That's why I'm
focused on trying to get something going that's the least bad with
what we've currently got, which is racy by design. How vitally
important is it to have something that doesn't race in the far future?
I don't know, really. It seems plausible that that ACPI notifier
triggers so early that nothing else really even has a chance, so the
race concern is purely theoretical. But I haven't tried to measure
that so I'm not sure.

Jason
