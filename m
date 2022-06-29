Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE11455FB10
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 10:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbiF2Iwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 04:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiF2Iwt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 04:52:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A4283CFEF
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 01:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656492766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tjHgFOOMuwf6AeuJnxaWU75Wb4tjTVtbPHKN66dUZeM=;
        b=SejwiNU6/ldjq8ODuv4TePqwzD6DDkhtnd2fA3i8nKWH1aaRR7CBe/sRWEda4MUK1gRrE4
        kIpU7PQoqdjovYS9Dx2i7JhH+SX7XAwxUyks92OkrtrKTG9w2ldD63Hpe+Vw+QH+qUTEgQ
        8NkYRHLkf2gKNlKecSFY0Y0oDl7jlHc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-HI5AFK6cPQe8i6TOe5WjgA-1; Wed, 29 Jun 2022 04:52:45 -0400
X-MC-Unique: HI5AFK6cPQe8i6TOe5WjgA-1
Received: by mail-wm1-f69.google.com with SMTP id j19-20020a05600c191300b003a048196712so5064503wmq.4
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 01:52:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tjHgFOOMuwf6AeuJnxaWU75Wb4tjTVtbPHKN66dUZeM=;
        b=FiDuii8VAzp214yMbpO/Xz3Po4B1pR7fhQUur5T+GokvCwEKUGYppQFTiIaYib36/f
         p7I2V0vDc8DHWpcabURk+OPS+bay9rEed6x3nnKbatj7KzMdRa39Ddr1Gj+wusSMd+Ck
         Q2x/6ADkiqMwk1CDWYaPn9w6hM6Ud9cleuVQ4wvA8xZaHf9Of5AdWB7y1IPR5nnPUyrD
         oeQd0IfrkN1eRmlZh7JlT2gluP0yC0WWV97/9IeNSXWQtkkdziflYUjqFRNMmmELY0nK
         1bez8z85ABtyBxDBUxX7T85oLH0PRD5OPueuYGa94C6EODEeNYD/ZHCBflBesS76CjuN
         xpLg==
X-Gm-Message-State: AJIora8qHt9KLNwt4iyvwKuOHXGzudRkOMB31pasmHM/dEt3hXZkZHSK
        zduTeZKeNpxZ/oRApbNh6HIG/oRT4MpTZudZOBcr7zOfNpQgIvPs2dhslSZVmaDo4h9v7jE3KRa
        RLZL9Oh+T+cXJ
X-Received: by 2002:adf:d1e9:0:b0:21b:c8f8:3c16 with SMTP id g9-20020adfd1e9000000b0021bc8f83c16mr1873037wrd.659.1656492763818;
        Wed, 29 Jun 2022 01:52:43 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tnrgKv64tg1zyPl055DmvcOx5lZT7xnZAKvFjKTcNvVC5btuOpowGMnA/4sz0hlWnQATLe7A==
X-Received: by 2002:adf:d1e9:0:b0:21b:c8f8:3c16 with SMTP id g9-20020adfd1e9000000b0021bc8f83c16mr1873015wrd.659.1656492763509;
        Wed, 29 Jun 2022 01:52:43 -0700 (PDT)
Received: from redhat.com ([2.52.23.204])
        by smtp.gmail.com with ESMTPSA id l20-20020a05600c4f1400b003a02b9c47e4sm2953183wmq.27.2022.06.29.01.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 01:52:42 -0700 (PDT)
Date:   Wed, 29 Jun 2022 04:52:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH V3] virtio: disable notification hardening by default
Message-ID: <20220629044514-mutt-send-email-mst@kernel.org>
References: <CACGkMEvrDXDN7FH1vKoYCob2rkxUsctE_=g61kzHSZ8tNNr6vA@mail.gmail.com>
 <20220627053820-mutt-send-email-mst@kernel.org>
 <CACGkMEvcs+9_SHmO1s3nyzgU7oq7jhU2gircVVR3KDsGDikh5Q@mail.gmail.com>
 <20220628004614-mutt-send-email-mst@kernel.org>
 <CACGkMEsC4A+3WejLSOZoH3enXtai=+JyRNbxcpzK4vODYzhaFw@mail.gmail.com>
 <CACGkMEvu0D0XD7udz0ebVjNM0h5+K9Rjd-5ed=PY_+-aduzG2g@mail.gmail.com>
 <20220629022223-mutt-send-email-mst@kernel.org>
 <CACGkMEuwvzkbPUSFueCOjit7pRJ81v3-W3SZD+7jQJN8btEFdg@mail.gmail.com>
 <20220629030600-mutt-send-email-mst@kernel.org>
 <CACGkMEvnUj622FyROUftifSB47wytPg0YAdVO7fdRQmCE+WuBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEvnUj622FyROUftifSB47wytPg0YAdVO7fdRQmCE+WuBg@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 04:34:36PM +0800, Jason Wang wrote:
> On Wed, Jun 29, 2022 at 3:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Jun 29, 2022 at 03:02:21PM +0800, Jason Wang wrote:
> > > On Wed, Jun 29, 2022 at 2:31 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Wed, Jun 29, 2022 at 12:07:11PM +0800, Jason Wang wrote:
> > > > > On Tue, Jun 28, 2022 at 2:17 PM Jason Wang <jasowang@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, Jun 28, 2022 at 1:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > >
> > > > > > > On Tue, Jun 28, 2022 at 11:49:12AM +0800, Jason Wang wrote:
> > > > > > > > > Heh. Yea sure. But things work fine for people. What is the chance
> > > > > > > > > your review found and fixed all driver bugs?
> > > > > > > >
> > > > > > > > I don't/can't audit all bugs but the race between open/close against
> > > > > > > > ready/reset. It looks to me a good chance to fix them all but if you
> > > > > > > > think differently, let me know
> > > > > > > >
> > > > > > > > > After two attempts
> > > > > > > > > I don't feel like hoping audit will fix all bugs.
> > > > > > > >
> > > > > > > > I've started the auditing and have 15+ patches in the queue. (only
> > > > > > > > covers bluetooth, console, pmem, virtio-net and caif). Spotting the
> > > > > > > > issue is not hard but the testing, It would take at least the time of
> > > > > > > > one release to finalize I guess.
> > > > > > >
> > > > > > > Absolutely. So I am looking for a way to implement hardening that does
> > > > > > > not break existing drivers.
> > > > > >
> > > > > > I totally agree with you to seek a way without bothering the drivers.
> > > > > > Just wonder if this is possbile.
> > > > > >
> > > > > > >
> > > > > > >
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > The reason config was kind of easy is that config interrupt is rarely
> > > > > > > > > > > vital for device function so arbitrarily deferring that does not lead to
> > > > > > > > > > > deadlocks - what you are trying to do with VQ interrupts is
> > > > > > > > > > > fundamentally different. Things are especially bad if we just drop
> > > > > > > > > > > an interrupt but deferring can lead to problems too.
> > > > > > > > > >
> > > > > > > > > > I'm not sure I see the difference, disable_irq() stuffs also delay the
> > > > > > > > > > interrupt processing until enable_irq().
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > Absolutely. I am not at all sure disable_irq fixes all problems.
> > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > Consider as an example
> > > > > > > > > > >     virtio-net: fix race between ndo_open() and virtio_device_ready()
> > > > > > > > > > > if you just defer vq interrupts you get deadlocks.
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > I don't see a deadlock here, maybe you can show more detail on this?
> > > > > > > > >
> > > > > > > > > What I mean is this: if we revert the above commit, things still
> > > > > > > > > work (out of spec, but still). If we revert and defer interrupts until
> > > > > > > > > device ready then ndo_open that triggers before device ready deadlocks.
> > > > > > > >
> > > > > > > > Ok, I guess you meant on a hypervisor that is strictly written with spec.
> > > > > > >
> > > > > > > I mean on hypervisor that starts processing queues after getting a kick
> > > > > > > even without DRIVER_OK.
> > > > > >
> > > > > > Oh right.
> > > > > >
> > > > > > >
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > So, thinking about all this, how about a simple per vq flag meaning
> > > > > > > > > > > "this vq was kicked since reset"?
> > > > > > > > > >
> > > > > > > > > > And ignore the notification if vq is not kicked? It sounds like the
> > > > > > > > > > callback needs to be synchronized with the kick.
> > > > > > > > >
> > > > > > > > > Note we only need to synchronize it when it changes, which is
> > > > > > > > > only during initialization and reset.
> > > > > > > >
> > > > > > > > Yes.
> > > > > > > >
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > If driver does not kick then it's not ready to get callbacks, right?
> > > > > > > > > > >
> > > > > > > > > > > Sounds quite clean, but we need to think through memory ordering
> > > > > > > > > > > concerns - I guess it's only when we change the value so
> > > > > > > > > > >         if (!vq->kicked) {
> > > > > > > > > > >                 vq->kicked = true;
> > > > > > > > > > >                 mb();
> > > > > > > > > > >         }
> > > > > > > > > > >
> > > > > > > > > > > will do the trick, right?
> > > > > > > > > >
> > > > > > > > > > There's no much difference with the existing approach:
> > > > > > > > > >
> > > > > > > > > > 1) your proposal implicitly makes callbacks ready in virtqueue_kick()
> > > > > > > > > > 2) my proposal explicitly makes callbacks ready via virtio_device_ready()
> > > > > > > > > >
> > > > > > > > > > Both require careful auditing of all the existing drivers to make sure
> > > > > > > > > > no kick before DRIVER_OK.
> > > > > > > > >
> > > > > > > > > Jason, kick before DRIVER_OK is out of spec, sure. But it is unrelated
> > > > > > > > > to hardening
> > > > > > > >
> > > > > > > > Yes but with your proposal, it seems to couple kick with DRIVER_OK somehow.
> > > > > > >
> > > > > > > I don't see how - my proposal ignores DRIVER_OK issues.
> > > > > >
> > > > > > Yes, what I meant is, in your proposal, the first kick after rest is a
> > > > > > hint that the driver is ok (but actually it could not).
> > > > > >
> > > > > > >
> > > > > > > > > and in absence of config interrupts is generally easily
> > > > > > > > > fixed just by sticking virtio_device_ready early in initialization.
> > > > > > > >
> > > > > > > > So if the kick is done before the subsystem registration, there's
> > > > > > > > still a window in the middle (assuming we stick virtio_device_ready()
> > > > > > > > early):
> > > > > > > >
> > > > > > > > virtio_device_ready()
> > > > > > > > virtqueue_kick()
> > > > > > > > /* the window */
> > > > > > > > subsystem_registration()
> > > > > > >
> > > > > > > Absolutely, however, I do not think we really have many such drivers
> > > > > > > since this has been known as a wrong thing to do since the beginning.
> > > > > > > Want to try to find any?
> > > > > >
> > > > > > Yes, let me try and update.
> > > > >
> > > > > This is basically the device that have an RX queue, so I've found the
> > > > > following drivers:
> > > > >
> > > > > scmi, mac80211_hwsim, vsock, bt, balloon.
> > > >
> > > > Looked and I don't see it yet. Let's consider
> > > > ./net/vmw_vsock/virtio_transport.c for example. Assuming we block
> > > > callbacks until the first kick, what is the issue with probe exactly?
> > >
> > > We need to make sure the callback can survive when it runs before sub
> > > system registration.
> >
> > With my proposal no - only if we also kick before registration.
> > So I do not see the issue yet.
> >
> > Consider ./net/vmw_vsock/virtio_transport.c
> >
> > kicks: virtio_transport_send_pkt_work,
> > virtio_vsock_rx_fill, virtio_vsock_event_fill
> >
> > which of these triggers before we are ready to
> > handle callbacks?
> 
> So:
> 
> virtio_vsock_vqs_init()
>     virtio_device_ready()
>     virtio_vsock_rx_fill() /* kick there */
> rcu_assign_pointer(the_virtio_vsock, vsock)
> 
> It means at least virtio_vsock_rx_done()/virtio_vsock_workqueue needs
> to survive. I don't say it has a bug but we do need to audit the code
> in this case. The implication is: the virtqueue callback should be
> written with no assumption that the driver has registered in the
> subsystem. We don't or can't assume all drivers are written in this
> way.


I thought you said you audited code and found bugs.

My claim is that simply because qemu starts processing
packets immediately upon kick, if bugs like this
existed we would have noticed by now.

In this case the_virtio_vsock is used for xmit things,
callbacks do not seem to use it at all.

> >
> >
> > > >
> > > >
> > > > > >
> > > > > > >I couldn't ... except maybe bluetooth
> > > > > > > but that's just maintainer nacking fixes saying he'll fix it
> > > > > > > his way ...
> > > > > > >
> > > > > > > > And during remove(), we get another window:
> > > > > > > >
> > > > > > > > subsysrem_unregistration()
> > > > > > > > /* the window */
> > > > > > > > virtio_device_reset()
> > > > > > >
> > > > > > > Same here.
> > > > >
> > > > > Basically for the drivers that set driver_ok before registration,
> > > >
> > > > I don't see what does driver_ok have to do with it.
> > >
> > > I meant for those driver, in probe they do()
> > >
> > > virtio_device_ready()
> > > subsystem_register()
> > >
> > > In remove() they do
> > >
> > > subsystem_unregister()
> > > virtio_device_reset()
> > >
> > > for symmetry
> >
> > Let's leave remove alone for now. I am close to 100% sure we have *lots*
> > of issues around it, but while probe is unavoidable remove can be
> > avoided by blocking hotplug.
> 
> Unbind can trigger this path as well.
> 
> >
> >
> > > >
> > > > > so
> > > > > we have a lot:
> > > > >
> > > > > blk, net, mac80211_hwsim, scsi, vsock, bt, crypto, gpio, gpu, i2c,
> > > > > iommu, caif, pmem, input, mem
> > > > >
> > > > > So I think there's no easy way to harden the notification without
> > > > > auditing the driver one by one (especially considering the driver may
> > > > > use bh or workqueue). The problem is the notification hardening
> > > > > depends on a correct or race-free probe/remove. So we need to fix the
> > > > > issues in probe/remove then do the hardening on the notification.
> > > > >
> > > > > Thanks
> > > >
> > > > So if drivers kick but are not ready to get callbacks then let's fix
> > > > that first of all, these are racy with existing qemu even ignoring
> > > > spec compliance.
> > >
> > > Yes, (the patches I've posted so far exist even with a well-behaved device).
> > >
> > > Thanks
> >
> > patches you posted deal with DRIVER_OK spec compliance.
> > I do not see patches for kicks before callbacks are ready to run.
> 
> Yes.
> 
> Thanks
> 
> >
> > > >
> > > >
> > > > --
> > > > MST
> > > >
> >

