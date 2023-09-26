Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA6D7AE4A1
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 06:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbjIZEit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 00:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjIZEis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 00:38:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670D597
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 21:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695703080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jIXu104+alAzcIDHfWvNLkJCYvCCr7ayQGmGcfYWdz0=;
        b=JnfQi+OjJzjwftaEpxnb8aHGBUwSytS3sOWdB/MPm+iWgW7nPZk9Mk4wkmb9qgquRaIS6a
        TjdVtT/fO2XAKIGzFVYT/Uy/aBiPpIe+rFs08sMEDg5Fuft7SwkqG6QHFWK0xA87e2j/HK
        uFrplwocSYMWXk9QymbLb8oH1EBieqQ=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-F5TLUEYcNyyK6_q6-tC6UA-1; Tue, 26 Sep 2023 00:37:59 -0400
X-MC-Unique: F5TLUEYcNyyK6_q6-tC6UA-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5043c0cbb62so9074045e87.1
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 21:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695703078; x=1696307878;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jIXu104+alAzcIDHfWvNLkJCYvCCr7ayQGmGcfYWdz0=;
        b=vH0gBcvD5PRM66sy83OL87/b9ACKFiYNAe9yMg0NDlAXkhO1IJbj/278JkPYQlJW8z
         KkBJg2NtFTJBJiXM+IZJ/jaV3TLkl4AUMRPXPfXzYcknpydkHAH1H/M5BhYu66Wg9Fz/
         fQMWLexQ1KYTH23rQOw0ZHJ7qbksFm3UPfpft7N7D4PYeundbAYhwkhjdXSzjK+uFts5
         i8XzDCsDXVsmpoPY22Kc5mYsZkDUrnVXbm7nWDv5y4RaI4xX2+Q9wrPafKQCxxNlIe1z
         9qcj1LpOGOhcRQAVDCXZKAjb4NGDIB0F9c29pN1GA70ZEJXvoiWHomfZkI7MbP43U15g
         1XcQ==
X-Gm-Message-State: AOJu0YxM6QS294aud8hIgyA/0e4cMQJlApzrvCgevgPiWNmmuHV1VKL1
        BxmPn/iH5/GCKJNo3SYAnuZRaKQ2Di8ebhBWiennQg5IW9ZHrUUOk9XBfOnCQteE1/19O4I9XCm
        pnC5Q0AdfveOrE6G4ptCLrHqvAsSo
X-Received: by 2002:a05:6512:a94:b0:501:bd6f:7c1e with SMTP id m20-20020a0565120a9400b00501bd6f7c1emr9556495lfu.33.1695703077773;
        Mon, 25 Sep 2023 21:37:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6fg22JDRfkI0jhFU9MmEF3Bwe3Da7PTw70+uY/H4x2Cbgvk9Z6LgoHNmSUWBAU+OAEnEVz9UzAJRrF9IwIBo=
X-Received: by 2002:a05:6512:a94:b0:501:bd6f:7c1e with SMTP id
 m20-20020a0565120a9400b00501bd6f7c1emr9556484lfu.33.1695703077534; Mon, 25
 Sep 2023 21:37:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230921141125.GM13733@nvidia.com> <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com> <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com> <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com> <CACGkMEvMP05yTNGE5dBA2-M0qX-GXFcdGho7_T5NR6kAEq9FNg@mail.gmail.com>
 <20230922121132.GK13733@nvidia.com> <CACGkMEsxgYERbyOPU33jTQuPDLUur5jv033CQgK9oJLW+ueG8w@mail.gmail.com>
 <20230925122607.GW13733@nvidia.com>
In-Reply-To: <20230925122607.GW13733@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 26 Sep 2023 12:37:46 +0800
Message-ID: <CACGkMEv9xaMi_Hxex02QUkLD95+1nWBRJz9g8sfQGzN8gkxt=w@mail.gmail.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 8:26=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Mon, Sep 25, 2023 at 10:34:54AM +0800, Jason Wang wrote:
>
> > > Cloud vendors will similarly use DPUs to create a PCI functions that
> > > meet the cloud vendor's internal specification.
> >
> > This can only work if:
> >
> > 1) the internal specification has finer garin than virtio spec
> > 2) so it can define what is not implemented in the virtio spec (like
> > migration and compatibility)
>
> Yes, and that is what is happening. Realistically the "spec" isjust a
> piece of software that the Cloud vendor owns which is simply ported to
> multiple DPU vendors.
>
> It is the same as VDPA. If VDPA can make multiple NIC vendors
> consistent then why do you have a hard time believing we can do the
> same thing just on the ARM side of a DPU?

I don't. We all know vDPA can do more than virtio.

>
> > All of the above doesn't seem to be possible or realistic now, and it
> > actually has a risk to be not compatible with virtio spec. In the
> > future when virtio has live migration supported, they want to be able
> > to migrate between virtio and vDPA.
>
> Well, that is for the spec to design.

Right, so if we'd consider migration from virtio to vDPA, it needs to
be designed in a way that allows more involvement from hypervisor
other than coupling it with a specific interface (like admin
virtqueues).

>
> > > So, as I keep saying, in this scenario the goal is no mediation in th=
e
> > > hypervisor.
> >
> > That's pretty fine, but I don't think trapping + relying is not
> > mediation. Does it really matter what happens after trapping?
>
> It is not mediation in the sense that the kernel driver does not in
> any way make decisions on the behavior of the device. It simply
> transforms an IO operation into a device command and relays it to the
> device. The device still fully controls its own behavior.
>
> VDPA is very different from this. You might call them both mediation,
> sure, but then you need another word to describe the additional
> changes VPDA is doing.
>
> > > It is pointless, everything you think you need to do there
> > > is actually already being done in the DPU.
> >
> > Well, migration or even Qemu could be offloaded to DPU as well. If
> > that's the direction that's pretty fine.
>
> That's silly, of course qemu/kvm can't run in the DPU.

KVM can't for sure but part of Qemu could. This model has been used.

>
> However, we can empty qemu and the hypervisor out so all it does is
> run kvm and run vfio. In this model the DPU does all the OVS, storage,
> "VPDA", etc. qemu is just a passive relay of the DPU PCI functions
> into VM's vPCI functions.
>
> So, everything VDPA was doing in the environment is migrated into the
> DPU.

It really depends on the use cases. For example, in the case of DPU
what if we want to provide multiple virtio devices through a single
VF?

>
> In this model the DPU is an extension of the hypervisor/qemu
> environment and we shift code from x86 side to arm side to increase
> security, save power and increase total system performance.

That's pretty fine.

Thanks

>
> Jason
>

