Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2510B7ACE2C
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 04:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbjIYCgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 22:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbjIYCgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 22:36:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE930C2
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 19:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695609308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DJDDBFzzf0f976aKgGjgkxn+o0F4gwbckCrIwzls0H4=;
        b=AZ91qfREELBQ86AncrzAKl6tl12RjZvMFgUDY8FuRcBrK+RSqzCY36aV0a4i0htejawzQY
        QNjCJ3tzmwRmvVi+0vMocq6xY77DK+/xLm5+5i0yarKF9NJgJLLvP4A1JQSdYLayZpHAfI
        DeatChOo2sXfF8IotVmSBwn8GbAdtNk=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657--AvrP8YfOaGA3AnKXc2JFQ-1; Sun, 24 Sep 2023 22:35:07 -0400
X-MC-Unique: -AvrP8YfOaGA3AnKXc2JFQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-503c774fd61so6853707e87.3
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 19:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695609306; x=1696214106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJDDBFzzf0f976aKgGjgkxn+o0F4gwbckCrIwzls0H4=;
        b=Jylzcls/e7QQrP2/K72Y9R1e5oq5Bg+P48rMIITgTrRV1TQlRF7/SsrKSQoXDHL8Nu
         /RS0i3bRJCM+duiXlqG6IKF2iY8kT3IpWgp8ZWblNmpU81sXSb5qdfo25dR0LjWoSZH2
         9aQ2x4C6g7o+n4ieG43jndAsLfRzlDFYCaJfFAuERuRImwrxonGuRCPZJBIX3uCeL2Rp
         Ce8MUVjvU9Q4YeI5Qefwxkga1QYfZBF2Pc9mCB18nnmde6oC8DTsmPb8OQKWsmsh9MAH
         3nELYcUcGoZPFezqmtZS/6uVUQLnvfJ3Xo1De/0RxA1Ez678FFj9rQ4vSizekBJgKjVy
         61NA==
X-Gm-Message-State: AOJu0YyaPFBBmo3XortD1roWdtc4jMDsUXOmVaayCDgWYHOdR5SMWTsz
        hCNzZsGW0OrV+Cnsycv+tApwe9RHjJ7GxoiBcgWRUwEEYcSkhsdilQ9b76fQE6nIUZ9Gjkgjoml
        By5dh1XoMiZprj+b9f8oHELWyVIR0
X-Received: by 2002:a05:6512:78f:b0:4f9:5519:78b8 with SMTP id x15-20020a056512078f00b004f9551978b8mr4313433lfr.63.1695609306082;
        Sun, 24 Sep 2023 19:35:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7ePPnscYK9n57PETbG37KL/UR7SLgpvhXvkhZD4U2cOFzvg7U2Z7qqf18PhQy9Ne5wwUAakW+Lil2KUHmN5U=
X-Received: by 2002:a05:6512:78f:b0:4f9:5519:78b8 with SMTP id
 x15-20020a056512078f00b004f9551978b8mr4313419lfr.63.1695609305728; Sun, 24
 Sep 2023 19:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230921124040.145386-12-yishaih@nvidia.com> <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com> <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com> <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com> <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com> <CACGkMEvMP05yTNGE5dBA2-M0qX-GXFcdGho7_T5NR6kAEq9FNg@mail.gmail.com>
 <20230922121132.GK13733@nvidia.com>
In-Reply-To: <20230922121132.GK13733@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 25 Sep 2023 10:34:54 +0800
Message-ID: <CACGkMEsxgYERbyOPU33jTQuPDLUur5jv033CQgK9oJLW+ueG8w@mail.gmail.com>
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

On Fri, Sep 22, 2023 at 8:11=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Fri, Sep 22, 2023 at 11:01:23AM +0800, Jason Wang wrote:
>
> > > Even when it does, there is no real use case to live migrate a
> > > virtio-net function from, say, AWS to GCP.
> >
> > It can happen inside a single cloud vendor. For some reasons, DPU must
> > be purchased from different vendors. And vDPA has been used in that
> > case.
>
> Nope, you misunderstand the DPU scenario.
>
> Look at something like vmware DPU enablement. vmware runs the software
> side of the DPU and all their supported DPU HW, from every vendor,
> generates the same PCI functions on the x86. They are the same because
> the same software on the DPU side is creating them.
>
> There is no reason to put a mediation layer in the x86 if you also
> control the DPU.
>
> Cloud vendors will similarly use DPUs to create a PCI functions that
> meet the cloud vendor's internal specification.

This can only work if:

1) the internal specification has finer garin than virtio spec
2) so it can define what is not implemented in the virtio spec (like
migration and compatibility)

All of the above doesn't seem to be possible or realistic now, and it
actually has a risk to be not compatible with virtio spec. In the
future when virtio has live migration supported, they want to be able
to migrate between virtio and vDPA.

As I said, vDPA has been used for cross vendor live migration for a while.

> Regardless of DPU
> vendor.
>
> Fundamentally if you control the DPU SW and the hypervisor software
> you do not need hypervisor meditation because everything you could do
> in hypervisor mediation can just be done in the DPU. Putting it in the
> DPU is better in every regard.
>
> So, as I keep saying, in this scenario the goal is no mediation in the
> hypervisor.

That's pretty fine, but I don't think trapping + relying is not
mediation. Does it really matter what happens after trapping?

> It is pointless, everything you think you need to do there
> is actually already being done in the DPU.

Well, migration or even Qemu could be offloaded to DPU as well. If
that's the direction that's pretty fine.

Thanks

>
> Jason
>

