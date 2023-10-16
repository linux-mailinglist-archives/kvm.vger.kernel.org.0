Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD557CB47B
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 22:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbjJPURb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 16:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjJPURa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 16:17:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59BCA1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 13:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697487400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hZtbQXcsubytl4k+2ppLTWsAsX5032GxW5VF2x3Wx24=;
        b=KwOuwMGiQ74wW1PlmCN/J5h43lZPZXrk2hBtg/aEe5XNepqL3m/yhJTLZ+NCFX0E03p8DW
        Op4YpZqW60F2Ac1s3Xt9L6VxdJkmCLVOmr249fHJVpBpM75Dk7Oo7eHYECudQBFm5Hkxte
        YAX4ykJMtt9fu/jHyoRwkDBMxPbdB8w=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-qTrGhS1uOuGtLaJPT7slIw-1; Mon, 16 Oct 2023 16:16:38 -0400
X-MC-Unique: qTrGhS1uOuGtLaJPT7slIw-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-35278d347bbso32708915ab.3
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 13:16:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697487397; x=1698092197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hZtbQXcsubytl4k+2ppLTWsAsX5032GxW5VF2x3Wx24=;
        b=rMGKEvkBG6Tyqt4XUFxeqM4mCFrQx2KM/6rN94AYoDHhSAt3QVdtMl0jD+CNSLgYAw
         uG/tbxZsPxEWHEN2p1R3m+pofoiSX0tH7N1ekTgBcF/OSgO6KB6OaqtDgJLteIdL22Yk
         IiMQZZHeJimvqyiMauHP5+eDuJ6poaDzeFgTNqhfLAdcSK1rFU8yUmL84iWbQOEaixx4
         Vx4BzG2IifGv3TjBVyjWC+luOSK6NoZQ3uX7bkJkG9AmJ3IMwEzLxbiVKw90fDwngqXB
         mHaN1qYA26mKXG8nusEBj7KDcVKAe0+epoHbI3E3eGfecapX5yUEOcNJyBXO5oOe8c5I
         Cxhw==
X-Gm-Message-State: AOJu0Yz1+eIyyBSoDGvAzhbSYS63XlAJGP+XlFtXoLxcCWoUBNDgTvwN
        yP9Ra59kEbo+DN6/r+GBC4sIbRaUA4EGjWJSetWEpErHiJplU4YYm46Dt++VRjujQ952WqhummC
        M/QTkTIKWfF5Vzsng9Dxl
X-Received: by 2002:a05:6e02:1523:b0:357:4ce1:6eaf with SMTP id i3-20020a056e02152300b003574ce16eafmr515005ilu.21.1697487397481;
        Mon, 16 Oct 2023 13:16:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzt3MBhdthL2pR/HI283yeCXF3+J3TA9mYTcl6vXV558ii/a/E4Wzo+ubEtZR8DXnkIAXrAQ==
X-Received: by 2002:a05:6e02:1523:b0:357:4ce1:6eaf with SMTP id i3-20020a056e02152300b003574ce16eafmr514991ilu.21.1697487397226;
        Mon, 16 Oct 2023 13:16:37 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id l12-20020a92290c000000b0034fe7ae6514sm3610343ilg.75.2023.10.16.13.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 13:16:36 -0700 (PDT)
Date:   Mon, 16 Oct 2023 14:16:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vfio/mtty: Fix eventfd leak
Message-ID: <20231016141635.74f8908e.alex.williamson@redhat.com>
In-Reply-To: <04d9af1d-e459-4431-bea3-679ade88f7d5@redhat.com>
References: <20231013195653.1222141-1-alex.williamson@redhat.com>
        <20231013195653.1222141-2-alex.williamson@redhat.com>
        <04d9af1d-e459-4431-bea3-679ade88f7d5@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Oct 2023 09:52:41 +0200
C=C3=A9dric Le Goater <clg@redhat.com> wrote:

> On 10/13/23 21:56, Alex Williamson wrote:
> > Found via kmemleak, eventfd context is leaked if not explicitly torn
> > down by userspace.  Clear pointers to track released contexts.  Also
> > remove unused irq_fd field in mtty structure, set but never used. =20
>=20
> This could be 2 different patches, one cleanup and one fix.

Of course.

> > Fixes: 9d1a546c53b4 ("docs: Sample driver to demonstrate how to use Med=
iated device framework.")
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >   samples/vfio-mdev/mtty.c | 28 +++++++++++++++++++++++-----
> >   1 file changed, 23 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> > index 5af00387c519..0a2760818e46 100644
> > --- a/samples/vfio-mdev/mtty.c
> > +++ b/samples/vfio-mdev/mtty.c
> > @@ -127,7 +127,6 @@ struct serial_port {
> >   /* State of each mdev device */
> >   struct mdev_state {
> >   	struct vfio_device vdev;
> > -	int irq_fd;
> >   	struct eventfd_ctx *intx_evtfd;
> >   	struct eventfd_ctx *msi_evtfd;
> >   	int irq_index;
> > @@ -938,8 +937,10 @@ static int mtty_set_irqs(struct mdev_state *mdev_s=
tate, uint32_t flags,
> >   		{
> >   			if (flags & VFIO_IRQ_SET_DATA_NONE) {
> >   				pr_info("%s: disable INTx\n", __func__);
> > -				if (mdev_state->intx_evtfd)
> > +				if (mdev_state->intx_evtfd) {
> >   					eventfd_ctx_put(mdev_state->intx_evtfd);
> > +					mdev_state->intx_evtfd =3D NULL;
> > +				}
> >   				break;
> >   			}
> >  =20
> > @@ -955,7 +956,6 @@ static int mtty_set_irqs(struct mdev_state *mdev_st=
ate, uint32_t flags,
> >   						break;
> >   					} =20
>=20
> Shouln't mdev_state->intx_evtfd value be tested before calling
> eventfd_ctx() ?

The state of mtty interrupt handling is really quite atrocious, it's a
pretty significant overhaul to really make it comply with the SET_IRQS
ioctl.  I'll see what I can do, but it's so broken that I hope you
won't insist on splitting out each fix.  Thanks,

Alex

> >   					mdev_state->intx_evtfd =3D evt;
> > -					mdev_state->irq_fd =3D fd;
> >   					mdev_state->irq_index =3D index;
> >   					break;
> >   				}
> > @@ -971,8 +971,10 @@ static int mtty_set_irqs(struct mdev_state *mdev_s=
tate, uint32_t flags,
> >   			break;
> >   		case VFIO_IRQ_SET_ACTION_TRIGGER:
> >   			if (flags & VFIO_IRQ_SET_DATA_NONE) {
> > -				if (mdev_state->msi_evtfd)
> > +				if (mdev_state->msi_evtfd) {
> >   					eventfd_ctx_put(mdev_state->msi_evtfd);
> > +					mdev_state->msi_evtfd =3D NULL;
> > +				}
> >   				pr_info("%s: disable MSI\n", __func__);
> >   				mdev_state->irq_index =3D VFIO_PCI_INTX_IRQ_INDEX;
> >   				break;
> > @@ -993,7 +995,6 @@ static int mtty_set_irqs(struct mdev_state *mdev_st=
ate, uint32_t flags,
> >   					break;
> >   				}
> >   				mdev_state->msi_evtfd =3D evt;
> > -				mdev_state->irq_fd =3D fd;
> >   				mdev_state->irq_index =3D index;
> >   			}
> >   			break;
> > @@ -1262,6 +1263,22 @@ static unsigned int mtty_get_available(struct md=
ev_type *mtype)
> >   	return atomic_read(&mdev_avail_ports) / type->nr_ports;
> >   }
> >  =20
> > +static void mtty_close(struct vfio_device *vdev)
> > +{
> > +	struct mdev_state *mdev_state =3D
> > +		container_of(vdev, struct mdev_state, vdev);
> > +
> > +	if (mdev_state->intx_evtfd) {
> > +		eventfd_ctx_put(mdev_state->intx_evtfd);
> > +		mdev_state->intx_evtfd =3D NULL;
> > +	}
> > +	if (mdev_state->msi_evtfd) {
> > +		eventfd_ctx_put(mdev_state->msi_evtfd);
> > +		mdev_state->msi_evtfd =3D NULL;
> > +	}
> > +	mdev_state->irq_index =3D -1;
> > +}
> > +
> >   static const struct vfio_device_ops mtty_dev_ops =3D {
> >   	.name =3D "vfio-mtty",
> >   	.init =3D mtty_init_dev,
> > @@ -1273,6 +1290,7 @@ static const struct vfio_device_ops mtty_dev_ops =
=3D {
> >   	.unbind_iommufd	=3D vfio_iommufd_emulated_unbind,
> >   	.attach_ioas	=3D vfio_iommufd_emulated_attach_ioas,
> >   	.detach_ioas	=3D vfio_iommufd_emulated_detach_ioas,
> > +	.close_device	=3D mtty_close,
> >   };
> >  =20
> >   static struct mdev_driver mtty_driver =3D { =20
>=20

