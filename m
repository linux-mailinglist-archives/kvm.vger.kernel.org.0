Return-Path: <kvm+bounces-23943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D30094FDCE
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 08:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3320FB2384D
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 06:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA7F43165;
	Tue, 13 Aug 2024 06:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GlFSO6VE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236B7381B8
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 06:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723530387; cv=none; b=tvR9i3ZLUqylH+7LHKvdW5g0AoqcpWCaeqr4q8kYiJyo9cM9Kb783C94DJI6Izm0peQRIcPLyAY3IDuCwkiut/q1K+GIfvyvYaNlanbFgVCyqkRUY1BD3SpophDCCn4L9wOZsqd4wZvbgHFUFv7l52dYkjwX28c7NOQcOKSZ1Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723530387; c=relaxed/simple;
	bh=z11k9/2dZSsWNeKMT/eTZ5hgojGyvlyRrk8ZA0dU1Pk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=osDIlO466UsWn42S72CEo2Ey2dbqLOGLAAffnzok5inxIVvUsJPZ+S3dOlBJfEe2DZZ3VMGDp0JZWOo43pOjnoP2/uQxgL0peefRKbkizIAqi5jLQjZ+avHeM/bNBgxGPIjzNdE6O3CxhWJUX3G6mWGFugsLMe7VotnuDUyOHjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GlFSO6VE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723530384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/+1NdbA2w9xTyXuvlnpdZMCH9uHX+JdiWBK5zQ7c8Ig=;
	b=GlFSO6VE/K8K5j88WC8iFwhYvgoPbsIkhCHUk7Zthx4R+0a6T+Pmo83enZVSYl+Sijmb04
	ThR1eJCmWhmCdnjKeBwC+gGfoVEC7O7BBRgZUlfUmwfwYu5t7g2tpbFOh/bQZhAyc/zcEF
	NGrs75A21R5zKxDFkqSE93uUrssNXl4=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-2wD1OSUKPmWT6JKnBRVSuA-1; Tue, 13 Aug 2024 02:26:21 -0400
X-MC-Unique: 2wD1OSUKPmWT6JKnBRVSuA-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7109d532601so4789561b3a.3
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 23:26:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723530380; x=1724135180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+1NdbA2w9xTyXuvlnpdZMCH9uHX+JdiWBK5zQ7c8Ig=;
        b=NMA/i7I+exMrYpfPV+DjTk+iZ3Onwyxt2tpK2GRTXKabCGxlyy1Z7g35mRdxuWEmy2
         pdWgzUcoeogFsZhLhHgjCXKKk+ENTqfAse3DXSJlujMx6Wz1v8jiauBZK+YIf04RFxi0
         XqCD+bphrUwOcV175otbGpNpaMOcjtbvPgaEl1yDcAS9/Rr/wBkKzUEuzE3AV10OjT4v
         JG69pETAnPG46drH//jU6w4KJ8l70jGJ48i37zWAmX1gG6BHw8KxGxYef3dt5L6g2gz+
         NKkKiXodC+TleUUnulhXGUPDDCKSxVYkLPD9UTVW6TeVxRH4XMabwl/PwhMSi3jb9BTP
         Gp3g==
X-Forwarded-Encrypted: i=1; AJvYcCV4FGsyTD5fEBuc+2jT0D52dH8GgxkvRmnQzxaorssOTjYKvIN+TPEPvV0ofPLmtpsPehVpxfbmWYK5pzpmQPmM1Z75
X-Gm-Message-State: AOJu0YwlIC4tW9gmRr8NUVNPDvX+/xJfU/QOGQxCApisLX+bX68oHj1c
	T1l14kyHIjlCE8OqzPKhVLNPgGETaqDFcg1PxgZjqTVH0YTBRFNOokuAabUExElTIbrh/oPmQ8K
	7jfMIUr9mYW/wavy2RQDoetGevNWEpK3rFcvIxzn7TnMLts2+AfAkPba+p5lVZXq3GOw6TZVLJg
	29vnhil97LSzzRThszVck11dZk
X-Received: by 2002:a05:6a20:d521:b0:1c6:f213:83b with SMTP id adf61e73a8af0-1c8d759479fmr3489564637.37.1723530379978;
        Mon, 12 Aug 2024 23:26:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFopEJBlYstjGCBUbkbkaEQoKLTASbBt41MNZwlAjPX+uIybIJEIIPhsS6+4J/MoFLwBa1wfojohNxemgd72HU=
X-Received: by 2002:a05:6a20:d521:b0:1c6:f213:83b with SMTP id
 adf61e73a8af0-1c8d759479fmr3489538637.37.1723530379372; Mon, 12 Aug 2024
 23:26:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240808082044.11356-1-jasowang@redhat.com> <9da68127-23d8-48a4-b56f-a3ff54fa213c@nvidia.com>
 <CACGkMEshq0=djGQ0gJe=AinZ2EHSpgE6CykspxRgLS_Ok55FKw@mail.gmail.com>
 <CACGkMEvAVM+KLpq7=+m8q1Wajs_FSSfftRGE+HN16OrFhqX=ow@mail.gmail.com> <ede5a20f-0314-4281-9100-89a265ff6411@nvidia.com>
In-Reply-To: <ede5a20f-0314-4281-9100-89a265ff6411@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 13 Aug 2024 14:26:08 +0800
Message-ID: <CACGkMEtVMq83rK9ykrN3OvGDYKg6L1Jnpa2wsnfDEbswpcnM1g@mail.gmail.com>
Subject: Re: [RFC PATCH] vhost_vdpa: assign irq bypass producer token correctly
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: mst@redhat.com, lingshan.zhu@intel.com, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2024 at 7:22=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
>
>
> On 12.08.24 08:49, Jason Wang wrote:
> > On Mon, Aug 12, 2024 at 1:47=E2=80=AFPM Jason Wang <jasowang@redhat.com=
> wrote:
> >>
> >> On Fri, Aug 9, 2024 at 2:04=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia=
.com> wrote:
> >>>
> >>>
> >>>
> >>> On 08.08.24 10:20, Jason Wang wrote:
> >>>> We used to call irq_bypass_unregister_producer() in
> >>>> vhost_vdpa_setup_vq_irq() which is problematic as we don't know if t=
he
> >>>> token pointer is still valid or not.
> >>>>
> >>>> Actually, we use the eventfd_ctx as the token so the life cycle of t=
he
> >>>> token should be bound to the VHOST_SET_VRING_CALL instead of
> >>>> vhost_vdpa_setup_vq_irq() which could be called by set_status().
> >>>>
> >>>> Fixing this by setting up  irq bypass producer's token when handling
> >>>> VHOST_SET_VRING_CALL and un-registering the producer before calling
> >>>> vhost_vring_ioctl() to prevent a possible use after free as eventfd
> >>>> could have been released in vhost_vring_ioctl().
> >>>>
> >>>> Fixes: 2cf1ba9a4d15 ("vhost_vdpa: implement IRQ offloading in vhost_=
vdpa")
> >>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> >>>> ---
> >>>> Note for Dragos: Please check whether this fixes your issue. I
> >>>> slightly test it with vp_vdpa in L2.
> >>>> ---
> >>>>  drivers/vhost/vdpa.c | 12 +++++++++---
> >>>>  1 file changed, 9 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> >>>> index e31ec9ebc4ce..388226a48bcc 100644
> >>>> --- a/drivers/vhost/vdpa.c
> >>>> +++ b/drivers/vhost/vdpa.c
> >>>> @@ -209,11 +209,9 @@ static void vhost_vdpa_setup_vq_irq(struct vhos=
t_vdpa *v, u16 qid)
> >>>>       if (irq < 0)
> >>>>               return;
> >>>>
> >>>> -     irq_bypass_unregister_producer(&vq->call_ctx.producer);
> >>>>       if (!vq->call_ctx.ctx)
> >>>>               return;
> >>>>
> >>>> -     vq->call_ctx.producer.token =3D vq->call_ctx.ctx;
> >>>>       vq->call_ctx.producer.irq =3D irq;
> >>>>       ret =3D irq_bypass_register_producer(&vq->call_ctx.producer);
> >>>>       if (unlikely(ret))
> >>>> @@ -709,6 +707,12 @@ static long vhost_vdpa_vring_ioctl(struct vhost=
_vdpa *v, unsigned int cmd,
> >>>>                       vq->last_avail_idx =3D vq_state.split.avail_in=
dex;
> >>>>               }
> >>>>               break;
> >>>> +     case VHOST_SET_VRING_CALL:
> >>>> +             if (vq->call_ctx.ctx) {
> >>>> +                     vhost_vdpa_unsetup_vq_irq(v, idx);
> >>>> +                     vq->call_ctx.producer.token =3D NULL;
> >>>> +             }
> >>>> +             break;
> >>>>       }
> >>>>
> >>>>       r =3D vhost_vring_ioctl(&v->vdev, cmd, argp);
> >>>> @@ -747,13 +751,14 @@ static long vhost_vdpa_vring_ioctl(struct vhos=
t_vdpa *v, unsigned int cmd,
> >>>>                       cb.callback =3D vhost_vdpa_virtqueue_cb;
> >>>>                       cb.private =3D vq;
> >>>>                       cb.trigger =3D vq->call_ctx.ctx;
> >>>> +                     vq->call_ctx.producer.token =3D vq->call_ctx.c=
tx;
> >>>> +                     vhost_vdpa_setup_vq_irq(v, idx);
> >>>>               } else {
> >>>>                       cb.callback =3D NULL;
> >>>>                       cb.private =3D NULL;
> >>>>                       cb.trigger =3D NULL;
> >>>>               }
> >>>>               ops->set_vq_cb(vdpa, idx, &cb);
> >>>> -             vhost_vdpa_setup_vq_irq(v, idx);
> >>>>               break;
> >>>>
> >>>>       case VHOST_SET_VRING_NUM:
> >>>> @@ -1419,6 +1424,7 @@ static int vhost_vdpa_open(struct inode *inode=
, struct file *filep)
> >>>>       for (i =3D 0; i < nvqs; i++) {
> >>>>               vqs[i] =3D &v->vqs[i];
> >>>>               vqs[i]->handle_kick =3D handle_vq_kick;
> >>>> +             vqs[i]->call_ctx.ctx =3D NULL;
> >>>>       }
> >>>>       vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
> >>>>                      vhost_vdpa_process_iotlb_msg);
> >>>
> >>> No more crashes, but now getting a lot of:
> >>>  vhost-vdpa-X: vq Y, irq bypass producer (token 00000000a66e28ab) reg=
istration fails, ret =3D  -16
> >>>
> >>> ... seems like the irq_bypass_unregister_producer() that was removed
> >>> might still be needed somewhere?
> >>
> My statement above was not quite correct. The error comes from the
> VQ irq being registered twice:
>
> 1) VHOST_SET_VRING_CALL ioctl gets called for vq 0. VQ irq is unregistere=
d
>    (vhost_vdpa_unsetup_vq_irq() and re-registered (vhost_vdpa_setup_vq_ir=
q())
>    successfully. So far so good.
>
> 2) set status !DRIVER_OK -> DRIVER_OK happens. VQ irq setup is done
>    once again (vhost_vdpa_setup_vq_irq()). As the producer unregister
>    was removed in this patch, the register will complain because the prod=
ucer
>    token already exists.

I see. I think it's probably too tricky to try to register/unregister
a producer during set_vring_call if DRIVER_OK is not set.

Does it work if we only do vhost_vdpa_unsetup/setup_vq_irq() if
DRIVER_OK is set in vhost_vdpa_vring_ioctl() (on top of this patch)?

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 388226a48bcc..ab441b8ccd2e 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -709,7 +709,9 @@ static long vhost_vdpa_vring_ioctl(struct
vhost_vdpa *v, unsigned int cmd,
                break;
        case VHOST_SET_VRING_CALL:
                if (vq->call_ctx.ctx) {
-                       vhost_vdpa_unsetup_vq_irq(v, idx);
+                       if (ops->get_status(vdpa) &
+                           VIRTIO_CONFIG_S_DRIVER_OK)
+                               vhost_vdpa_unsetup_vq_irq(v, idx);
                        vq->call_ctx.producer.token =3D NULL;
                }
                break;
@@ -752,7 +754,9 @@ static long vhost_vdpa_vring_ioctl(struct
vhost_vdpa *v, unsigned int cmd,
                        cb.private =3D vq;
                        cb.trigger =3D vq->call_ctx.ctx;
                        vq->call_ctx.producer.token =3D vq->call_ctx.ctx;
-                       vhost_vdpa_setup_vq_irq(v, idx);
+                       if (ops->get_status(vdpa) &
+                           VIRTIO_CONFIG_S_DRIVER_OK)
+                               vhost_vdpa_setup_vq_irq(v, idx);
                } else {
                        cb.callback =3D NULL;
                        cb.private =3D NULL;

>
>
> >> Probably, but I didn't see this when testing vp_vdpa.
> >>
> >> When did you meet those warnings? Is it during the boot or migration?
> During boot, on the first 2 VQs only (so before the QPs are resized).
> Traffic does work though when the VM is booted.

Right.

>
> >
> > Btw, it would be helpful to check if mlx5_get_vq_irq() works
> > correctly. I believe it should return an error if the virtqueue
> > interrupt is not allocated. After a glance at the code, it seems not
> > straightforward to me.
> >
> I think we're good on that front:
> mlx5_get_vq_irq() returns EOPNOTSUPP if the vq irq is not allocated.

Good to know that.

Thanks

>
>
> Thanks,
> Dragos
>


