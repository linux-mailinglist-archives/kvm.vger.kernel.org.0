Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C6D7ADF1B
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 20:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbjIYShv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 14:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbjIYSht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 14:37:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9389AE5D
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 11:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695666974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9QTtIYYHWfEcLyk0XfMvD4aeQXydfx9aR6gAzWJA9sc=;
        b=Gax4jKvxuyB5gJpkHztSeiQwosM74rzIyQqSm1Z8F65DhSojcXKeNBkAghxC+G13mCasZr
        BHMcs3XzQVLyvmgvmRKnIM0+cRpIOqaVRDuea3HXpfmQ2oUHD1WDbIl82G2LYILQSI2YW8
        VTpI2Cqq9q9JmXBCaoLR/zfGnYPbOtg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-WENyhmY8OImM-G-X8eV-EA-1; Mon, 25 Sep 2023 14:36:13 -0400
X-MC-Unique: WENyhmY8OImM-G-X8eV-EA-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7742bab9c0cso543084885a.3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 11:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695666973; x=1696271773;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9QTtIYYHWfEcLyk0XfMvD4aeQXydfx9aR6gAzWJA9sc=;
        b=xUFx/qHv7Rzz6BfdAKvlzY5+ErfoHb6votVl7Zdf2CCsPh9ev72zN9d5DUN/TgHtmQ
         90feP9u0Yi10nzGvjP54pXbS1eJsGi+GQmcN1ZC3JWz+LzSjd3FyTbdioX2Fkw1tA6o2
         LINokyU2kNlTv+WJkYnMRzvz1zQkXv7VWN9kspHN9CftlnkZCSGP9Um7v6gmKmtgUWTs
         +vv4lZMBBDFJGyDwMLZSJzX1N4pPuWkBges8Iier8L8zak6n4lzghB2gyPBCV4CtCabb
         EpGwc09jTymCO5K/+lk8AEsLVxnivMFWYftu3QBv13xS1k53nnX00FdP4+yEO69yHMP/
         my6w==
X-Gm-Message-State: AOJu0YzWUUg7ZIF9cIa/1VKuqZRCf6qbTQ6Dk3V74nsKElCk9j8ktchY
        GenZFzWL+Up2CYUykq9YIO5tF0otQL5UWIuYZjacTIb5fdXB8g2ZRtgHjVBRiGOKzH/8LuyVp9o
        uXD+gbFSNTEsH
X-Received: by 2002:a05:620a:a1e:b0:774:20bb:2473 with SMTP id i30-20020a05620a0a1e00b0077420bb2473mr6273054qka.25.1695666972785;
        Mon, 25 Sep 2023 11:36:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENA1Z6IBxdDt1EQwITwUpLlUd61ItWx3IkukntUNf42RhNhR7OkvLvX5TddUXhiG8q1YL1sQ==
X-Received: by 2002:a05:620a:a1e:b0:774:20bb:2473 with SMTP id i30-20020a05620a0a1e00b0077420bb2473mr6273037qka.25.1695666972432;
        Mon, 25 Sep 2023 11:36:12 -0700 (PDT)
Received: from redhat.com ([185.184.228.174])
        by smtp.gmail.com with ESMTPSA id j30-20020a05620a001e00b0076d74da4481sm741437qki.23.2023.09.25.11.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 11:36:11 -0700 (PDT)
Date:   Mon, 25 Sep 2023 14:36:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230925141713-mutt-send-email-mst@kernel.org>
References: <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com>
 <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEuX5HJVBOw9E+skr=K=QzH3oyHK8gk-r0hAvi6Wm7OA7Q@mail.gmail.com>
 <PH0PR12MB5481ED78F7467EEB0740847EDCFCA@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PH0PR12MB5481ED78F7467EEB0740847EDCFCA@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 08:26:33AM +0000, Parav Pandit wrote:
> 
> 
> > From: Jason Wang <jasowang@redhat.com>
> > Sent: Monday, September 25, 2023 8:00 AM
> > 
> > On Fri, Sep 22, 2023 at 8:25 PM Parav Pandit <parav@nvidia.com> wrote:
> > >
> > >
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Friday, September 22, 2023 5:53 PM
> > >
> > >
> > > > > And what's more, using MMIO BAR0 then it can work for legacy.
> > > >
> > > > Oh? How? Our team didn't think so.
> > >
> > > It does not. It was already discussed.
> > > The device reset in legacy is not synchronous.
> > 
> > How do you know this?
> >
> Not sure the motivation of same discussion done in the OASIS with you and others in past.
> 
> Anyways, please find the answer below.
> 
> About reset,
> The legacy device specification has not enforced below cited 1.0 driver requirement of 1.0.
> 
> "The driver SHOULD consider a driver-initiated reset complete when it reads device status as 0."
>  
> [1] https://ozlabs.org/~rusty/virtio-spec/virtio-0.9.5.pdf

Basically, I think any drivers that did not read status (linux pre 2011)
before freeing memory under DMA have a reset path that is racy wrt DMA, since 
memory writes are posted and IO writes while not posted have completion
that does not order posted transactions, e.g. from pci express spec:
        D2b
        An I/O or Configuration Write Completion 37 is permitted to pass a Posted Request.
having said that there were a ton of driver races discovered on this
path in the years since, I suspect if one cares about this then
just avoiding stress on reset is wise.



> > > The drivers do not wait for reset to complete; it was written for the sw
> > backend.
> > 
> > Do you see there's a flush after reset in the legacy driver?
> > 
> Yes. it only flushes the write by reading it. The driver does not get _wait_ for the reset to complete within the device like above.

One can thinkably do that wait in hardware, though. Just defer completion until
read is done.

> Please see the reset flow of 1.x device as below.
> In fact the comment of the 1.x device also needs to be updated to indicate that driver need to wait for the device to finish the reset.
> I will send separate patch for improving this comment of vp_reset() to match the spec.
> 
> static void vp_reset(struct virtio_device *vdev)
> {
>         struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>         struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> 
>         /* 0 status means a reset. */
>         vp_modern_set_status(mdev, 0);
>         /* After writing 0 to device_status, the driver MUST wait for a read of
>          * device_status to return 0 before reinitializing the device.
>          * This will flush out the status write, and flush in device writes,
>          * including MSI-X interrupts, if any.
>          */
>         while (vp_modern_get_status(mdev))
>                 msleep(1);
>         /* Flush pending VQ/configuration callbacks. */
>         vp_synchronize_vectors(vdev);
> }
> 
> 
> > static void vp_reset(struct virtio_device *vdev) {
> >         struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> >         /* 0 status means a reset. */
> >         vp_legacy_set_status(&vp_dev->ldev, 0);
> >         /* Flush out the status write, and flush in device writes,
> >          * including MSi-X interrupts, if any. */
> >         vp_legacy_get_status(&vp_dev->ldev);
> >         /* Flush pending VQ/configuration callbacks. */
> >         vp_synchronize_vectors(vdev);
> > }
> > 
> > Thanks
> > 
> > 
> > 
> > > Hence MMIO BAR0 is not the best option in real implementations.
> > >
> 

