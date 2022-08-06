Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A5B58B4D2
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 11:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241795AbiHFJnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Aug 2022 05:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiHFJnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Aug 2022 05:43:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F6D15836;
        Sat,  6 Aug 2022 02:43:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C29460DD7;
        Sat,  6 Aug 2022 09:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D6FC433D6;
        Sat,  6 Aug 2022 09:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659778988;
        bh=DG8963oGkbXx7+vUNEIN89246XtvxOsDYOhzpif+4Bw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=io6jGK2eLDlbNgZznh0Ml+gDbu6fzixfoCSL47VciYG0jkJktTJNV5U6ODlOag2D1
         SfxqOnCxchomXiDfDdbM0boizya5mW1o3S3EKHTxSa62vxV5KUptQiEOhHO+WcPWcN
         SD4+iNrrxzIhVUabAejBiec8+aBbrkbIdrPINdHwQV7w4G3IfVE2GQqoWOv1/SE2Tu
         /d7SfuZfdemcTZCVtff9izuNa+TiDG4PZdbYRgoqt8VajXSO/P4PUyBKZh8YSTtU69
         GiWxC1GhlpfYFT9wq4bOg10Twx1ni2lKLQHQCROFKDDImoq5HacC76ngLh2Q5WkWbS
         U0SXB8xCiscdQ==
Date:   Sat, 6 Aug 2022 10:42:59 +0100
From:   Will Deacon <will@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mst@redhat.com, stefanha@redhat.com, jasowang@redhat.com,
        ascull@google.com, maz@kernel.org, keirf@google.com,
        jiyong@google.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: IOTLB support for vhost/vsock breaks crosvm on Android
Message-ID: <20220806094258.GB30268@willie-the-truck>
References: <20220805181105.GA29848@willie-the-truck>
 <CAHk-=wip-Lju3ZdNwknS6ouyw+nKXeRSnhqVyNo8WSEdk-BfGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wip-Lju3ZdNwknS6ouyw+nKXeRSnhqVyNo8WSEdk-BfGw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 05, 2022 at 03:57:08PM -0700, Linus Torvalds wrote:
> On Fri, Aug 5, 2022 at 11:11 AM Will Deacon <will@kernel.org> wrote:
> >
> > [tl;dr a change from ~18 months ago breaks Android userspace and I don't
> >  know what to do about it]
> 
> Augh.
> 
> I had hoped that android being "closer" to upstream would have meant
> that somebody actually tests android with upstream kernels. People
> occasionally talk about it, but apparently it's not actually done.
> 
> Or maybe it's done onl;y with a very limited android user space.

We do actually test every -rc with Android (and run a whole bunch of
regression tests), this is largely using x86 builds for convenience
but we've been bringing up arm64 recently and are getting increasingly
more coverage there. So this _will_ improve and relatively soon.

The kicker in this case is that we'd only catch it on systems using pKVM
(arm64 host only; upstreaming ongoing) with restricted DMA (requires
device-tree) and so it slipped through. This is made more challenging
for CI because arm64 devices don't tend to have support for nested
virtualisation and so we have to run bare-metal but, as I say, we're
getting there.

> > After some digging, we narrowed this change in behaviour down to
> > e13a6915a03f ("vhost/vsock: add IOTLB API support") and further digging
> > reveals that the infamous VIRTIO_F_ACCESS_PLATFORM feature flag is to
> > blame. Indeed, our tests once again pass if we revert that patch (there's
> > a trivial conflict with the later addition of VIRTIO_VSOCK_F_SEQPACKET
> > but otherwise it reverts cleanly).
> 
> I have to say, this smells for *so* many reasons.
> 
> Why is "IOMMU support" called "VIRTIO_F_ACCESS_PLATFORM"?

It was already renamed once (!) It used to be VIRTIO_F_IOMMU_PLATFORM...

> That seems insane, but seems fundamental in that commit e13a6915a03f
> ("vhost/vsock: add IOTLB API support")
> 
> This code
> 
>         if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
>                 if (vhost_init_device_iotlb(&vsock->dev, true))
>                         goto err;
>         }
> 
> just makes me go "What?"  It makes no sense. Why isn't that feature
> called something-something-IOTLB?
> 
> Can we please just split that flag into two, and have that odd
> "platform access" be one bit, and the "enable iommu" be an entirely
> different bit?

Something along those lines makes sense to me, but it's fiddly because
the bits being used here are part of the virtio spec and we can't freely
allocate them in Linux. I reckon it would probably be better to have a
separate mechanism to enable IOTLB and not repurpose this flag for it.
Hindsight is a wonderful thing.

> And hey, it's possible that the bit encoding is *so* incestuous that
> it's really hard to split it into two. But it really sounds to me like
> somebody mindlessly re-used a feature bit for a *completely* different
> thing. Why?
> 
> Why have feature bits at all, when you then re-use the same bit for
> two different features? It kind of seems to defeat the whole purpose.

No argument here, and it's a big part of the reason I made the effort to
write this up. Yes, we hit this in Android. Yes, we should've hit it
sooner.  But is it specific to Android? No. Anybody wanting a guest to
use the DMA API for its virtio devices is going to be setting this flag
and if they implement the same algorithm as crosvm then they're going to
hit exactly the same problem that we did.

Will
