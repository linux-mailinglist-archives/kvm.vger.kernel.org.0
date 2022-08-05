Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6191058B287
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 00:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241439AbiHEW5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 18:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241268AbiHEW52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 18:57:28 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FE112A8A
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 15:57:27 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id w19so7357984ejc.7
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 15:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=NC4cysuywW8XEpGdMjzU9OYVRS8Z3YSMAD203AMlbrk=;
        b=PNM6Y8lm9ttp+NtlMA+qdF4huhKjki+bO3qHRvhBcY+z3fHP/eUCW5t5Gi/UerFvRG
         kz0DAnJwoIcevopFDxtDsQgEAG8CrQpDfXEGOJ1PH0xz1l7AMECbSvLvUELV++v9xVlY
         H/TFMy3P0J0tlCY9z9/FBqus6oF44i1nNmUY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=NC4cysuywW8XEpGdMjzU9OYVRS8Z3YSMAD203AMlbrk=;
        b=zemAsd1ZAHE4b4R2iG0WbdVdE85ppyyJpnKroQy0dqgU5gZZNxOU0mf4MEhtDozBoH
         yQ4XAFJCpfwvsL8Qa69yIYK3V+ckVgcUdICN2V32o1oP1gNxDpWSTecb3dej4bqFbolK
         sZZZ/dcMrpHpsDc0QU36oIINBkEH0Z0RyvrInMIHHo18EhT/08ObNq2ZzdUnVWm4OWax
         +vc39MAti2i/P1HYSpfvzAd1AuJldiSZ9kb3+dlcreeD4MPPSAuCRWqCylUR/jbaGuNR
         FDEtZqB8QQvEb5njiQNc6qji/7vMg6t0au0qvT05UT0R0nJpTAuOoyEeFJWvs1xK63F+
         /hZg==
X-Gm-Message-State: ACgBeo05sjR8HK7VYz9DDBSCUN4IE25csncTmwwUo7vhHK+vaVwlxCLc
        xBUDeaJBJ3EKDhTtbgjckekuD1raPgqD2j8A
X-Google-Smtp-Source: AA6agR6mw5jYu1F0R+KiLd/LA7Fiammv2ND5bA29mPPepypCPSqBWj6JtzvwmBBr5wzIWg9uZgw4sw==
X-Received: by 2002:a17:906:8c7:b0:730:c1a9:e187 with SMTP id o7-20020a17090608c700b00730c1a9e187mr6653501eje.55.1659740245650;
        Fri, 05 Aug 2022 15:57:25 -0700 (PDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id cx20-20020a05640222b400b0043d7b19abd0sm578532edb.39.2022.08.05.15.57.25
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 15:57:25 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id v131-20020a1cac89000000b003a4bb3f786bso4591451wme.0
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 15:57:25 -0700 (PDT)
X-Received: by 2002:a05:600c:1d94:b0:3a4:ffd9:bb4a with SMTP id
 p20-20020a05600c1d9400b003a4ffd9bb4amr5768966wms.8.1659740244625; Fri, 05 Aug
 2022 15:57:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220805181105.GA29848@willie-the-truck>
In-Reply-To: <20220805181105.GA29848@willie-the-truck>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 5 Aug 2022 15:57:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=wip-Lju3ZdNwknS6ouyw+nKXeRSnhqVyNo8WSEdk-BfGw@mail.gmail.com>
Message-ID: <CAHk-=wip-Lju3ZdNwknS6ouyw+nKXeRSnhqVyNo8WSEdk-BfGw@mail.gmail.com>
Subject: Re: IOTLB support for vhost/vsock breaks crosvm on Android
To:     Will Deacon <will@kernel.org>
Cc:     mst@redhat.com, stefanha@redhat.com, jasowang@redhat.com,
        ascull@google.com, maz@kernel.org, keirf@google.com,
        jiyong@google.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 5, 2022 at 11:11 AM Will Deacon <will@kernel.org> wrote:
>
> [tl;dr a change from ~18 months ago breaks Android userspace and I don't
>  know what to do about it]

Augh.

I had hoped that android being "closer" to upstream would have meant
that somebody actually tests android with upstream kernels. People
occasionally talk about it, but apparently it's not actually done.

Or maybe it's done onl;y with a very limited android user space.

The whole "we notice that something that happened 18 months ago broke
our environment" is kind of broken.

> After some digging, we narrowed this change in behaviour down to
> e13a6915a03f ("vhost/vsock: add IOTLB API support") and further digging
> reveals that the infamous VIRTIO_F_ACCESS_PLATFORM feature flag is to
> blame. Indeed, our tests once again pass if we revert that patch (there's
> a trivial conflict with the later addition of VIRTIO_VSOCK_F_SEQPACKET
> but otherwise it reverts cleanly).

I have to say, this smells for *so* many reasons.

Why is "IOMMU support" called "VIRTIO_F_ACCESS_PLATFORM"?

That seems insane, but seems fundamental in that commit e13a6915a03f
("vhost/vsock: add IOTLB API support")

This code

        if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
                if (vhost_init_device_iotlb(&vsock->dev, true))
                        goto err;
        }

just makes me go "What?"  It makes no sense. Why isn't that feature
called something-something-IOTLB?

Can we please just split that flag into two, and have that odd
"platform access" be one bit, and the "enable iommu" be an entirely
different bit?

Now, since clearly nobody runs Android on newer kernels, I do think
that the actual bit number choice should probably be one that makes
the non-android use case binaries continue to work. And then the
android system binaries that use this could maybe be compiled to know
about *both* bits,. and work regardless?

I'm also hoping that maybe Google android people could actually do
some *testing*? I know, that sounds like a lot to ask, but humor me.
Even if the product team runs stuff that is 18 months old, how about
the dev team have a machine or two that actually tests current
kernels, so that it's not a "oh, a few years have passed, and now we
notice that a change doesn't work for us" situation any more.

Is that really too much to ask for a big company like google?

And hey, it's possible that the bit encoding is *so* incestuous that
it's really hard to split it into two. But it really sounds to me like
somebody mindlessly re-used a feature bit for a *completely* different
thing. Why?

Why have feature bits at all, when you then re-use the same bit for
two different features? It kind of seems to defeat the whole purpose.

                 Linus
