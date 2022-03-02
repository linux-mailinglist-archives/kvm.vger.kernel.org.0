Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77574CA8E2
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 16:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243418AbiCBPQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 10:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238706AbiCBPQC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 10:16:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DE77A9A4;
        Wed,  2 Mar 2022 07:15:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E0CDB8201F;
        Wed,  2 Mar 2022 15:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DC6C340F3;
        Wed,  2 Mar 2022 15:15:16 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PrJYbD8F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646234111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c2+g9iY2kmOPNGlwq4HTp4cL3j+BBDr1ikH+kZn25AM=;
        b=PrJYbD8Fnoy4mGXIi1mWsWP0JlowLbGfyu65vF64zRUm7wfHjgWuQvm035UMHldfWg8C6+
        2W833v7XdwuAhY9m17hwAQ9USvfLLKKS5HL/fTNftLFhewLNbc9NnZVHtb/cr8uBEtMRUa
        cda240n0kEtLvK24u/t+b8CZZzfM5Y0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b8578db1 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 2 Mar 2022 15:15:11 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id f5so3952735ybg.9;
        Wed, 02 Mar 2022 07:15:10 -0800 (PST)
X-Gm-Message-State: AOAM530Sda4dhRYY3XADBKIgW1rpjMzagxM8xbtMeJDLetydikSbGYWn
        lpQtHctjiDPHQs+/A4qmeOiKZEDTMa1GOTZuMgw=
X-Google-Smtp-Source: ABdhPJxC05/AAXh+YCK7fweN+Ucl339GX4StItE4YIRyT3kzm+lXQKWGnocyrzXFrNcMQt/oaChmv0FlidEIh2Gaffs=
X-Received: by 2002:a5b:6cf:0:b0:61e:1371:3cda with SMTP id
 r15-20020a5b06cf000000b0061e13713cdamr29389927ybq.235.1646234107996; Wed, 02
 Mar 2022 07:15:07 -0800 (PST)
MIME-Version: 1.0
References: <Yh4+9+UpanJWAIyZ@zx2c4.com> <223f858c-34c5-3ccd-b9e8-7585a976364d@redhat.com>
 <Yh5JwK6toc/zBNL7@zx2c4.com> <20220301121419-mutt-send-email-mst@kernel.org>
 <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com>
 <20220302031738-mutt-send-email-mst@kernel.org> <CAHmME9pf-bjnZuweoLqoFEmPy1OK7ogEgGEAva1T8uVTufhCuw@mail.gmail.com>
 <20220302074503-mutt-send-email-mst@kernel.org> <Yh93UZMQSYCe2LQ7@zx2c4.com> <20220302092149-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220302092149-mutt-send-email-mst@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 2 Mar 2022 16:14:56 +0100
X-Gmail-Original-Message-ID: <CAHmME9rf7hQP78kReP2diWNeX=obPem=f8R-dC7Wkpic2xmffg@mail.gmail.com>
Message-ID: <CAHmME9rf7hQP78kReP2diWNeX=obPem=f8R-dC7Wkpic2xmffg@mail.gmail.com>
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

On Wed, Mar 2, 2022 at 3:46 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> I just don't see how "value changed while it was read" is so different
> from "value changed one clock after it was read".  Since we don't detect
> the latter I don't see why we should worry about the former.

The "barrier" is at the point where the plaintext has been chosen AND
the nonce for a given keypair has been selected. So, if you have
plaintext in a buffer, and a key in a buffer, and the nonce for that
encryption in a buffer, and then after those are all selected, you
check to see if the vmgenid has changed since the birth of that key,
then you're all set. If it changes _after_ that point of check (your
"one clock after"), it doesn't matter: you'll just be
double-transmitting the same ciphertext, which is something that flaky
wifi sometimes does _anyway_ (and attackers can do intentionally), so
network protocols already are resilient to replay. This is the same
case you asked about earlier, and then answered yourself, when you
were wondering about reaching down into qdiscs.

Jason
