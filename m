Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D73E58CA91
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 16:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243535AbiHHOdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 10:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243327AbiHHOdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 10:33:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E805E10FFF
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 07:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659969200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/1TLUgVlg2OyYCJ+DZaddQK6OMJhjwa3jOmWOJ1SScI=;
        b=clbVW0ltbBfk5fvvzO9LD1+p9tPIQA2Yw6GNIOQxet6V5bdcHh1TSKeF9mhPAU48emcZM9
        dCFRucpT2l1lSwletZBlFGu3AOdBGhmdo2pmI6Cq8UpWTMCc+IDtqsjV7lJrSWsHQppUb2
        WxTn1xQfJBTDdHvL0wXzyf/veBuMsQ4=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-uUca9_m6N1iFRz3AwU0Eng-1; Mon, 08 Aug 2022 10:33:18 -0400
X-MC-Unique: uUca9_m6N1iFRz3AwU0Eng-1
Received: by mail-lj1-f198.google.com with SMTP id g3-20020a2e9cc3000000b00253cc2b5ab5so2513025ljj.19
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 07:33:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=/1TLUgVlg2OyYCJ+DZaddQK6OMJhjwa3jOmWOJ1SScI=;
        b=W6IbyL+iFTcGiyqhCfP2kZgNIebtp5tPxnDhY8vI5bEOp++lxOSwCrs0/a/raXIrpY
         Q3fZmecy2kYVCIp4nMqSdhPwHpmlj3aYxOkG8MALt735A0MwVOZP1ZPWOYqTkCGeyam2
         Hj6zrObODLJ2ZaAhOpwzIZM3bURYtrB3cDWxm4+X0VwGZXXVP3qbDFYxWdPrVSbFUUV3
         Q7Hq9vXKPOR74/93S2Vx5+jjTEhcDm1z7ye3pd9DkUV4/HM3xX+ugxokg3wzpkiZNSsI
         XM/8FfqGVGOHXyMpAiMzqPPE6sLbpM9FlJHilMSiN5hizI/hnBJI4rkcRqQxwYThtezQ
         GOyw==
X-Gm-Message-State: ACgBeo0SSyJybrS8keYFoQYxkl3+XONEEEgVj5GcSOAVaZ+QTSUJMYgN
        h5XWCS5gBCkme3j1HbDaorZdvW1IxV2ITz5KhEeLVLgiEesKIv6zrgtZVHWcPfPu2nDuI2dkZjn
        /SBRVuob8emJB2BX2nMufaNyMdJmw
X-Received: by 2002:a05:6512:68a:b0:48b:9d3d:b19b with SMTP id t10-20020a056512068a00b0048b9d3db19bmr3474990lfe.174.1659969196986;
        Mon, 08 Aug 2022 07:33:16 -0700 (PDT)
X-Google-Smtp-Source: AA6agR64B2Y+NvP5GJggrT7xDmjVOaBSl5qxOdsgKfM9DJRfPYV4TZXGTwlEJml+bcB9a8mUktIhhfJarGLbZfr6iPk=
X-Received: by 2002:a05:6512:68a:b0:48b:9d3d:b19b with SMTP id
 t10-20020a056512068a00b0048b9d3db19bmr3474977lfe.174.1659969196714; Mon, 08
 Aug 2022 07:33:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220805181105.GA29848@willie-the-truck> <20220807042408-mutt-send-email-mst@kernel.org>
 <20220808101850.GA31984@willie-the-truck> <20220808083958-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220808083958-mutt-send-email-mst@kernel.org>
From:   Stefan Hajnoczi <shajnocz@redhat.com>
Date:   Mon, 8 Aug 2022 10:33:05 -0400
Message-ID: <CAD60JZOWLU2U9EoUmG6kLHMUYv0j_y4V8TOzzyk=XHQJaG38mg@mail.gmail.com>
Subject: Re: IOTLB support for vhost/vsock breaks crosvm on Android
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Will Deacon <will@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        torvalds@linux-foundation.org, ascull@google.com, maz@kernel.org,
        keirf@google.com, jiyong@google.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        crosvm-dev@chromium.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 8, 2022 at 8:46 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Aug 08, 2022 at 11:18:50AM +0100, Will Deacon wrote:
> > Hi Michael,
> >
> > On Sun, Aug 07, 2022 at 09:14:43AM -0400, Michael S. Tsirkin wrote:
> > > Will, thanks very much for the analysis and the writeup!
> >
> > No problem, and thanks for following up.
> >
> > > On Fri, Aug 05, 2022 at 07:11:06PM +0100, Will Deacon wrote:
> > > > So how should we fix this? One possibility is for us to hack crosvm to
> > > > clear the VIRTIO_F_ACCESS_PLATFORM flag when setting the vhost features,
> > > > but others here have reasonably pointed out that they didn't expect a
> > > > kernel change to break userspace. On the flip side, the offending commit
> > > > in the kernel isn't exactly new (it's from the end of 2020!) and so it's
> > > > likely that others (e.g. QEMU) are using this feature.
> > >
> > > Exactly, that's the problem.
> > >
> > > vhost is reusing the virtio bits and it's only natural that
> > > what you are doing would happen.
> > >
> > > To be precise, this is what we expected people to do (and what QEMU does):
> > >
> > >
> > > #define QEMU_VHOST_FEATURES ((1 << VIRTIO_F_VERSION_1) |
> > >                          (1 << VIRTIO_NET_F_RX_MRG) | .... )
> > >
> > > VHOST_GET_FEATURES(... &host_features);
> > > host_features &= QEMU_VHOST_FEATURES
> > > VHOST_SET_FEATURES(host_features & guest_features)
> > >
> > >
> > > Here QEMU_VHOST_FEATURES are the bits userspace knows about.
> > >
> > > Our assumption was that whatever userspace enables, it
> > > knows what the effect on vhost is going to be.
> > >
> > > But yes, I understand absolutely how someone would instead just use the
> > > guest features. It is unfortunate that we did not catch this in time.
> > >
> > >
> > > In hindsight, we should have just created vhost level macros
> > > instead of reusing virtio ones. Would address the concern
> > > about naming: PLATFORM_ACCESS makes sense for the
> > > guest since there it means "whatever access rules platform has",
> > > but for vhost a better name would be VHOST_F_IOTLB.
> > > We should have also taken greater pains to document what
> > > we expect userspace to do. I remember now how I thought about something
> > > like this but after coding this up in QEMU I forgot to document this :(
> > > Also, I suspect given the history the GET/SET features ioctl and burned
> > > wrt extending it and we have to use a new when we add new features.
> > > All this we can do going forward.
> >
> > Makes sense. The crosvm developers are also pretty friendly in my
> > experience, so I'm sure they wouldn't mind being involved in discussions
> > around any future ABI extensions. Just be aware that they _very_ recently
> > moved their mailing lists, so I think it lives here now:
> >
> > https://groups.google.com/a/chromium.org/g/crosvm-dev
> >
> > > But what can we do about the specific issue?
> > > I am not 100% sure since as Will points out, QEMU and other
> > > userspace already rely on the current behaviour.
> > >
> > > Looking at QEMU specifically, it always sends some translations at
> > > startup, this in order to handle device rings.
> > >
> > > So, *maybe* we can get away with assuming that if no IOTLB ioctl was
> > > ever invoked then this userspace does not know about IOTLB and
> > > translation should ignore IOTLB completely.
> >
> > There was a similar suggestion from Stefano:
> >
> > https://lore.kernel.org/r/20220806105225.crkui6nw53kbm5ge@sgarzare-redhat
> >
> > about spotting the backend ioctl for IOTLB and using that to enable
> > the negotiation of F_ACCESS_PLATFORM. Would that work for qemu?
>
> Hmm I would worry that this disables the feature for old QEMU :(
>
>
> > > I am a bit nervous about breaking some *other* userspace which actually
> > > wants device to be blocked from accessing memory until IOTLB
> > > has been setup. If we get it wrong we are making guest
> > > and possibly even host vulnerable.
> > > And of course just revering is not an option either since there
> > > are now whole stacks depending on the feature.
> >
> > Absolutely, I'm not seriously suggesting the revert. I just did it locally
> > to confirm the issue I was seeing.
> >
> > > Will I'd like your input on whether you feel a hack in the kernel
> > > is justified here.
> >
> > If we can come up with something that we have confidence in and won't be a
> > pig to maintain, then I think we should do it, but otherwise we can go ahead
> > and change crosvm to mask out this feature flag on the vhost side for now.
> > We mainly wanted to raise the issue to illustrate that this flag continues
> > to attract problems in the hope that it might inform further usage and/or
> > spec work in this area.
> >
> > In any case, I'm happy to test any kernel patches with our setup if you
> > want to give it a shot.
>
> Thanks!
> I'm a bit concerned that the trick I proposed changes the configuration
> where iotlb was not set up from "access to memory not allowed" to
> "access to all memory allowed". This just might have security
> implications if some application assumed the former.
> And the one Stefano proposed disables IOTLB for old QEMU versions.

Adding hacks to vhost in order to work around userspace applications
that misunderstand the vhost model seems like a it will lead to
problems.

Userspace applications need to follow the vhost model: vhost is
designed for virtqueue passthrough, but the rest of the vhost
interface is not suitable for pass through. It's similar to how VFIO
PCI passthrough needs to do a significant amount of stuff in userspace
to emulate a PCI configuration space and it won't work properly if you
pass through the physical PCI device's PCI configuration space.

The emulator has to mediate between the guest device and vhost device
because it still emulates the VIRTIO transport, configuration space,
device lifecycle, etc even when all virtqueues are passed through.

Let's document this for vhost and vDPA because it is not obvious.

Stefan

