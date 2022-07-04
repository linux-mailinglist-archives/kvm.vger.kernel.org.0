Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61944564E1B
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 09:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiGDHAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 03:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiGDHAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 03:00:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D78D5F42
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 00:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656918050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QKFiYOhVLexNLZAnyygH6JGx6im3hhRGTkcpFvcfiv0=;
        b=M4fHphM/2q+qW6AOPJSc5mh5jU9NR56MlYMu3kQ/tIrzh7zZOPd5vE+gKGlBvAlDfrguc5
        Ur0gPhwCEZVTyT10SSyMBp4rWtZlStTwDEsXo4VQw4UXSqmbFcXDq9R/k8LuHmfcQLBBgl
        Ebw6tGR9lFjBh4Cach60RQDv/xJc2n4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-aI2eDKpJMheJ1IwlNRQ6Ng-1; Mon, 04 Jul 2022 03:00:49 -0400
X-MC-Unique: aI2eDKpJMheJ1IwlNRQ6Ng-1
Received: by mail-wr1-f71.google.com with SMTP id u9-20020adfa189000000b0021b8b3c8f74so1177826wru.12
        for <kvm@vger.kernel.org>; Mon, 04 Jul 2022 00:00:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QKFiYOhVLexNLZAnyygH6JGx6im3hhRGTkcpFvcfiv0=;
        b=UiMBPs7aagJY/7pmILxPOp6QbEfMF7DbapzVqw1xrh+qOTL8ZQTrFPW7aOuZKD7A75
         x7ab5P+hahCbVJXBzkucVBO5IrVJFlh/vCOKLohjM0ABHPwMVwE+w5edI3sbkmr985eu
         0RH0muZCwt3kQIX83ZhkogY1+qVdowCHJcCttY8LafB38yZ+LfOV/FabuVgfjo/8OmUu
         38qOZ1S2HutRlMNJ1093rCqdo/qf08bJifKLgqi96Em7h8C6kFgOyoNTdD/ChPxwiXJY
         DFIjSCZiQVChME8LIS1qclpTRHvuwXWdMc8U38RL01OhY3GsFVuZKaKOfWp9F35f1Eip
         StOA==
X-Gm-Message-State: AJIora8ZxWGtPnoKJX9IvRhCJWdOngIgfT+Uv4hqpDfGj9RFGQxyJ57g
        EU5BWUFKMeVRLpjGXMxODViMrr78m/lPGzObmcD6e6Z9+H4kHmIjDgzqJWLtA5GjQSNErV9ULwo
        J6KFopVj0NFO9
X-Received: by 2002:a5d:5050:0:b0:21b:a348:7c0 with SMTP id h16-20020a5d5050000000b0021ba34807c0mr24643678wrt.184.1656918048141;
        Mon, 04 Jul 2022 00:00:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1spniD4B5iaafPVJ5gLTv4/pH5qJd/Sh/qNkdYesfjItgeUTWnDB2+innkMR9U68mUQU8qzzA==
X-Received: by 2002:a5d:5050:0:b0:21b:a348:7c0 with SMTP id h16-20020a5d5050000000b0021ba34807c0mr24643655wrt.184.1656918047895;
        Mon, 04 Jul 2022 00:00:47 -0700 (PDT)
Received: from redhat.com ([2.55.3.188])
        by smtp.gmail.com with ESMTPSA id o15-20020a05600c510f00b003971fc23185sm14891356wms.20.2022.07.04.00.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 00:00:47 -0700 (PDT)
Date:   Mon, 4 Jul 2022 03:00:42 -0400
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
Message-ID: <20220704025850-mutt-send-email-mst@kernel.org>
References: <20220629022223-mutt-send-email-mst@kernel.org>
 <CACGkMEuwvzkbPUSFueCOjit7pRJ81v3-W3SZD+7jQJN8btEFdg@mail.gmail.com>
 <20220629030600-mutt-send-email-mst@kernel.org>
 <CACGkMEvnUj622FyROUftifSB47wytPg0YAdVO7fdRQmCE+WuBg@mail.gmail.com>
 <20220629044514-mutt-send-email-mst@kernel.org>
 <CACGkMEsW02a1LeiWwUgHfVmDEnC8i49h1L7qHmeoLyJyRS6-zA@mail.gmail.com>
 <20220630043219-mutt-send-email-mst@kernel.org>
 <CACGkMEtgnHDEUOHQxqUFn2ngOpUGcVu4NSQBqfYYZRMPA2H2LQ@mail.gmail.com>
 <20220704021950-mutt-send-email-mst@kernel.org>
 <CACGkMEsVcmerW7xE01JvntnxkomxF5r4H2dQGDP8-xGNZJ87kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEsVcmerW7xE01JvntnxkomxF5r4H2dQGDP8-xGNZJ87kw@mail.gmail.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 04, 2022 at 02:40:16PM +0800, Jason Wang wrote:
> On Mon, Jul 4, 2022 at 2:22 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Jul 04, 2022 at 12:23:27PM +0800, Jason Wang wrote:
> > > > So if there are not examples of callbacks not ready after kick
> > > > then let us block callbacks until first kick. That is my idea.
> > >
> > > Ok, let me try. I need to drain my queue of fixes first.
> > >
> > > Thanks
> >
> > If we do find issues, another option is blocking callbacks until the
> > first add. A bit higher overhead as add is a more common operation
> > but it has even less of a chance to introduce regressions.
> 
> So I understand that the case of blocking until first kick but if we
> block until add it means for drivers:
> 
> virtqueue_add()
> virtio_device_ready()
> virtqueue_kick()
> 
> We probably enlarge the window in this case.
> 
> Thanks

Yes but I don't know whether any drivers call add before they are ready
to get a callback. The main thing with hardening is not to break
drivers. Primum non nocere and all that.


> >
> > > >
> > > >
> > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > >I couldn't ... except maybe bluetooth
> > > > > > > > > > > > > but that's just maintainer nacking fixes saying he'll fix it
> > > > > > > > > > > > > his way ...
> > > > > > > > > > > > >
> > > > > > > > > > > > > > And during remove(), we get another window:
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > subsysrem_unregistration()
> > > > > > > > > > > > > > /* the window */
> > > > > > > > > > > > > > virtio_device_reset()
> > > > > > > > > > > > >
> > > > > > > > > > > > > Same here.
> > > > > > > > > > >
> > > > > > > > > > > Basically for the drivers that set driver_ok before registration,
> > > > > > > > > >
> > > > > > > > > > I don't see what does driver_ok have to do with it.
> > > > > > > > >
> > > > > > > > > I meant for those driver, in probe they do()
> > > > > > > > >
> > > > > > > > > virtio_device_ready()
> > > > > > > > > subsystem_register()
> > > > > > > > >
> > > > > > > > > In remove() they do
> > > > > > > > >
> > > > > > > > > subsystem_unregister()
> > > > > > > > > virtio_device_reset()
> > > > > > > > >
> > > > > > > > > for symmetry
> > > > > > > >
> > > > > > > > Let's leave remove alone for now. I am close to 100% sure we have *lots*
> > > > > > > > of issues around it, but while probe is unavoidable remove can be
> > > > > > > > avoided by blocking hotplug.
> > > > > > >
> > > > > > > Unbind can trigger this path as well.
> > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > so
> > > > > > > > > > > we have a lot:
> > > > > > > > > > >
> > > > > > > > > > > blk, net, mac80211_hwsim, scsi, vsock, bt, crypto, gpio, gpu, i2c,
> > > > > > > > > > > iommu, caif, pmem, input, mem
> > > > > > > > > > >
> > > > > > > > > > > So I think there's no easy way to harden the notification without
> > > > > > > > > > > auditing the driver one by one (especially considering the driver may
> > > > > > > > > > > use bh or workqueue). The problem is the notification hardening
> > > > > > > > > > > depends on a correct or race-free probe/remove. So we need to fix the
> > > > > > > > > > > issues in probe/remove then do the hardening on the notification.
> > > > > > > > > > >
> > > > > > > > > > > Thanks
> > > > > > > > > >
> > > > > > > > > > So if drivers kick but are not ready to get callbacks then let's fix
> > > > > > > > > > that first of all, these are racy with existing qemu even ignoring
> > > > > > > > > > spec compliance.
> > > > > > > > >
> > > > > > > > > Yes, (the patches I've posted so far exist even with a well-behaved device).
> > > > > > > > >
> > > > > > > > > Thanks
> > > > > > > >
> > > > > > > > patches you posted deal with DRIVER_OK spec compliance.
> > > > > > > > I do not see patches for kicks before callbacks are ready to run.
> > > > > > >
> > > > > > > Yes.
> > > > > > >
> > > > > > > Thanks
> > > > > > >
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > --
> > > > > > > > > > MST
> > > > > > > > > >
> > > > > > > >
> > > > > >
> > > >
> >

