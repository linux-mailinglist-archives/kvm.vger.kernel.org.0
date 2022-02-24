Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591374C2109
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 02:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiBXBdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 20:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiBXBdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 20:33:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6364C5418C;
        Wed, 23 Feb 2022 17:32:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AAC4B82335;
        Thu, 24 Feb 2022 00:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA1DC340EF;
        Thu, 24 Feb 2022 00:54:59 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="V7d545dN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645664097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8d3NsRpLI4kLFf8ojDpxr98Y5eh/F8jlee00Sd/p97I=;
        b=V7d545dNOPMEd5ncLm8ym2715fal9qroLwbzWKHkAQuG07L2Xq/PtAu5Uoxm4f8VU5lhbD
        3y5DoR2qzvpGj14eNwxmleb7dqvUiyOcq8d9ArxGT1F/723VwrT95SQIUcrJx/WC8sed+n
        kv7oWFWx7zT6jy7GLs3bDGpihDPuZVA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 84132888 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 24 Feb 2022 00:54:56 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id bt13so773880ybb.2;
        Wed, 23 Feb 2022 16:54:56 -0800 (PST)
X-Gm-Message-State: AOAM531qT0sPs4gHYp+SAgi4YKtYcOo21e9rXURGlbXgC/UflG7RBA4B
        PRWeh9GWO8yLTIx6EDtugnEYRFGv7dGog5I9mks=
X-Google-Smtp-Source: ABdhPJwfDEOGrwvFQMit980tZnx7EEjBFOfs3eOMVbdbLdqcKU9trvqOuAKoUTWJYW+779nIWzk+clEPXGo/K05LQLA=
X-Received: by 2002:a25:b905:0:b0:61e:23e4:949f with SMTP id
 x5-20020a25b905000000b0061e23e4949fmr299097ybj.373.1645664094735; Wed, 23 Feb
 2022 16:54:54 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:71a8:b0:167:24f9:2d40 with HTTP; Wed, 23 Feb 2022
 16:54:54 -0800 (PST)
In-Reply-To: <YhbAOW/KbFW1CFkQ@sol.localdomain>
References: <20220223131231.403386-1-Jason@zx2c4.com> <20220223131231.403386-2-Jason@zx2c4.com>
 <YhbAOW/KbFW1CFkQ@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 24 Feb 2022 01:54:54 +0100
X-Gmail-Original-Message-ID: <CAHmME9oa_wE8_n8e5b=iM5v-s5dgyibm4vXMhwzc8zGd6VWZMQ@mail.gmail.com>
Message-ID: <CAHmME9oa_wE8_n8e5b=iM5v-s5dgyibm4vXMhwzc8zGd6VWZMQ@mail.gmail.com>
Subject: Re: [PATCH RFC v1 1/2] random: add mechanism for VM forks to
 reinitialize crng
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, adrian@parity.io, dwmw@amazon.co.uk,
        acatan@amazon.com, graf@amazon.com, colmmacc@amazon.com,
        sblbir@amazon.com, raduweis@amazon.com, jannh@google.com,
        gregkh@linuxfoundation.org, tytso@mit.edu
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

On 2/24/22, Eric Biggers <ebiggers@kernel.org> wrote:
> I think we should be removing cases where the base_crng key is changed
> directly
> besides extraction from the input_pool, not adding new ones.  Why not
> implement
> this as add_device_randomness() followed by crng_reseed(force=true), where
> the
> 'force' argument forces a reseed to occur even if the entropy_count is too
> low?

Because that induces a "premature next" condition which can let that
entropy, potentially newly acquired by a storm of IRQs at power-on, be
bruteforced by unprivileged userspace. I actually had it exactly the
way you describe at first, but decided that this here is the lesser of
evils and doesn't really complicate things the way an intentional
premature next would. The only thing we care about here is branching
the crng stream, and so this does explicitly that, without having to
interfere with how we collect entropy. Of course we *also* add it as
non-credited "device randomness" so that it's part of the next
reseeding, whenever that might occur.
