Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16BA4C2A9F
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 12:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbiBXLQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 06:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbiBXLQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 06:16:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAAF294552;
        Thu, 24 Feb 2022 03:15:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D5696177F;
        Thu, 24 Feb 2022 11:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E0CC340F0;
        Thu, 24 Feb 2022 11:15:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="K0Ba/2BM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645701345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tSMJNlgM3iQSZttf3O5yP1K/Zb4cUmNelvTABLfdcOs=;
        b=K0Ba/2BM/9pExBbaS5Oj8SCJvlvp0LQGyiNAiXDyooG/U9BeyX+5o7RLqsETF26O3Q8oLJ
        fCsXilmRI7pxc/CYm3kU+fXPDMl1Uchh4ynDmuSO5MbVs6Ufz3QiiawdfSIvm5FepEXDsh
        cYBAB6wdHUlLLl0Wob5vRSfu6n86I28=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 954041ba (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 24 Feb 2022 11:15:45 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id g6so3016428ybe.12;
        Thu, 24 Feb 2022 03:15:43 -0800 (PST)
X-Gm-Message-State: AOAM5315RL/lzYI/NtRNh7x5Px9BdD0ydiHXo8b3FpyEVFwamOhtB+0p
        gx0/jUlkmeQ1PWrF6jia5iAIhGQNRHDmWJyyjDU=
X-Google-Smtp-Source: ABdhPJwcyLWv29eKkR/4qn6wxUASneof9Mw7kmR85HjE16vurz2uO8LCL0/vq/6Jg597pXgN7D3peAt9nzCkEAyuvVw=
X-Received: by 2002:a25:d116:0:b0:61d:e8c9:531e with SMTP id
 i22-20020a25d116000000b0061de8c9531emr1860406ybg.637.1645701342951; Thu, 24
 Feb 2022 03:15:42 -0800 (PST)
MIME-Version: 1.0
References: <20220223131231.403386-1-Jason@zx2c4.com> <20220223131231.403386-2-Jason@zx2c4.com>
 <YhbAOW/KbFW1CFkQ@sol.localdomain> <CAHmME9oa_wE8_n8e5b=iM5v-s5dgyibm4vXMhwzc8zGd6VWZMQ@mail.gmail.com>
 <YhbfDQ2ernjrRNRX@sol.localdomain>
In-Reply-To: <YhbfDQ2ernjrRNRX@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 24 Feb 2022 12:15:32 +0100
X-Gmail-Original-Message-ID: <CAHmME9rUD5QrgQMpoOCjv3crWFwn+BXXx9Dm0e2Kv4cJCYS+AQ@mail.gmail.com>
Message-ID: <CAHmME9rUD5QrgQMpoOCjv3crWFwn+BXXx9Dm0e2Kv4cJCYS+AQ@mail.gmail.com>
Subject: Re: [PATCH RFC v1 1/2] random: add mechanism for VM forks to
 reinitialize crng
To:     Eric Biggers <ebiggers@kernel.org>
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
        "Theodore Ts'o" <tytso@mit.edu>
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

Hey Eric,

On Thu, Feb 24, 2022 at 2:27 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Feb 24, 2022 at 01:54:54AM +0100, Jason A. Donenfeld wrote:
> > On 2/24/22, Eric Biggers <ebiggers@kernel.org> wrote:
> > > I think we should be removing cases where the base_crng key is changed
> > > directly
> > > besides extraction from the input_pool, not adding new ones.  Why not
> > > implement
> > > this as add_device_randomness() followed by crng_reseed(force=true), where
> > > the
> > > 'force' argument forces a reseed to occur even if the entropy_count is too
> > > low?
> >
> > Because that induces a "premature next" condition which can let that
> > entropy, potentially newly acquired by a storm of IRQs at power-on, be
> > bruteforced by unprivileged userspace. I actually had it exactly the
> > way you describe at first, but decided that this here is the lesser of
> > evils and doesn't really complicate things the way an intentional
> > premature next would. The only thing we care about here is branching
> > the crng stream, and so this does explicitly that, without having to
> > interfere with how we collect entropy. Of course we *also* add it as
> > non-credited "device randomness" so that it's part of the next
> > reseeding, whenever that might occur.
>
> Can you make sure to properly explain this in the code?

The carousel keeps turning, and after I wrote to you last night I kept
thinking about the matter. Here's how it breaks down:

Injection method:
- Assumes existing pool of entropy is still sacred.
- Assumes base_crng timestamp is representative of pool age.
- Result: Mixes directly into base_crng to avoid premature-next of pool.

Input pool method:
- Assumes existing pool of entropy is old / out of date / used by a
different fork, so not sacred.
- Assumes base_crng timestamp is tied to irrelevant entropy pool.
- Result: Force-drains input pool, causing intentional premature-next.

Which of these assumptions better models the situation? I started in
the input pool method camp, then by the time I posted v1, was
concerned about power-on IRQs, but now I think relying at all on
snapshotted entropy represents the biggest issue. And judging from
your email, it appears that you do too. So v3 of this patchset will
switch back to the input pool method, per your suggestion.

As a plus, it means we go through the RDSEED'd extraction algorithm
too, which always helps.

Jason
