Return-Path: <kvm+bounces-8192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC42C84C316
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 04:27:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 442941F280FC
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 03:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44F4111CB8;
	Wed,  7 Feb 2024 03:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gQQKTsnS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B32F13FF8
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 03:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707276453; cv=none; b=mX3II9r6j+lrsOkRoFtkqeoJz5cHjSkJWHaVfrdzYgdOwqD+oJAb3WZC+NIeJo8o/GRq9w6eC5U8l1A+sB14Ddzh3VQDR6r09ZvkK7mF8QNuN7GuUG7p1MH/FLqQEYhUsT0kZWRDEQYGQayGmsut9/MelCx6DP/U8EDKwB2Uvlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707276453; c=relaxed/simple;
	bh=qsE//gaQh/ELevMsklLn/ApppxOTlK4xCHYMHM46s2I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lbD+1cFicP2/6LQlLTfpxTqRMlEcCffevm2Zs4NXMixe17nhkqMa0JfZOp2EJLiDuBls96w17+xg1tbBKXv51D3XHPh8uVlb2AyhRqsJL7QOfFtuzV9dPccR/OxUm75ibNq7s/LwVSA4jJCoQyI/q87p3M10+BgZeR5rf6DH6uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gQQKTsnS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707276449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ECyPdLbuQ8n+CIX5LY9BuiN4WFH5pGMhm7CI6F18Oro=;
	b=gQQKTsnSKwv/jFr4F2rNRglH0LOq9eLjR4pd4HEkmuqaLtnwhMEE4aCXMQCcy84CPFO8ep
	y42Y6xXJfj4GGRmFWUsTqvTBSqGDyYYfq1m0sjB4gNUOLvy1gZ+1SSP+W9VRjJYGlaL8s8
	f4eraGFlKPMmogaWTw55IbqTU2GutS0=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-ae875V1xOkKn7gPwAKPLNg-1; Tue, 06 Feb 2024 22:27:27 -0500
X-MC-Unique: ae875V1xOkKn7gPwAKPLNg-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6e0519304b2so240698b3a.3
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 19:27:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707276446; x=1707881246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ECyPdLbuQ8n+CIX5LY9BuiN4WFH5pGMhm7CI6F18Oro=;
        b=feRoNCB/UdM8Z0T2+6RKQKmQULDePPmeGo57nMnA5Kkkyx1SNMC/DS2Dj99VkUFqZX
         K8mJAbbfvNvY1FCmaDTDPb2HQ1do0jY+5wOAyBA/2xp5Q24ebkB2NL4E5cimrAycr+b6
         FOT9n2e8i1JHN8a16teqZq5CEuota6+Vq9FAu+PJLE8NQUfKVZ8MfE9SWOcDnqoi+vs5
         QCgM0x4zFB/FjjxUYCdIceP/Q8ebRboYSGaFKh2hznKF72qPPeDEPz5agWrt9YvYNKOC
         CxwGwiueFZIaFVCGBPH9zw0rBlaN6b2JeYzWTM5kup1DuAA008FqHrCoqGjWyXQ501F/
         B31A==
X-Gm-Message-State: AOJu0YySbYBAdKtB7UsPL2Oy5kXyRXchXKXrhJzHyF1jiyAcFvV1795d
	QpfQJgrnZwsV8cejxXb3I0wR/nbFT3mVmQrAL1QrkMSac9OQZrA4zp1sagZxrkHlVqE9AJa3220
	SyeGkLYHgoYA9VkLdGL/d9aL+iFkkusv6bBG5Dt5rL4G2AP888HiV8ngJqTzexfoIqITMPFr60O
	EMbEa4VBISXTIfn/pIMDApFGo6
X-Received: by 2002:aa7:84c6:0:b0:6dd:84ce:4602 with SMTP id x6-20020aa784c6000000b006dd84ce4602mr1445736pfn.6.1707276446478;
        Tue, 06 Feb 2024 19:27:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEOduHPoLP4mCVG39rBl1Z8IToYghCDdc8bbnZRY4nXuhv/6H/c+FYVQ3yUyKyTYydLTVyAuvDaqusFQbjMZgQ=
X-Received: by 2002:aa7:84c6:0:b0:6dd:84ce:4602 with SMTP id
 x6-20020aa784c6000000b006dd84ce4602mr1445717pfn.6.1707276446144; Tue, 06 Feb
 2024 19:27:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240206145154.118044-1-sgarzare@redhat.com>
In-Reply-To: <20240206145154.118044-1-sgarzare@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 7 Feb 2024 11:27:14 +0800
Message-ID: <CACGkMEs-FAz7Xv7j6k3grq97q9qO18Em2bLDS4qBaCDZS7+gbQ@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: fail enabling virtqueue in certain conditions
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: virtualization@lists.linux.dev, Shannon Nelson <shannon.nelson@amd.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 6, 2024 at 10:52=E2=80=AFPM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> If VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK is not negotiated, we expect
> the driver to enable virtqueue before setting DRIVER_OK. If the driver
> tries anyway, better to fail right away as soon as we get the ioctl.
> Let's also update the documentation to make it clearer.
>
> We had a problem in QEMU for not meeting this requirement, see
> https://lore.kernel.org/qemu-devel/20240202132521.32714-1-kwolf@redhat.co=
m/

Maybe it's better to only enable cvq when the backend supports
VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK. Eugenio, any comment on this?

>
> Fixes: 9f09fd6171fe ("vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK=
 backend feature")
> Cc: eperezma@redhat.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/uapi/linux/vhost_types.h | 3 ++-
>  drivers/vhost/vdpa.c             | 4 ++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_=
types.h
> index d7656908f730..5df49b6021a7 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -182,7 +182,8 @@ struct vhost_vdpa_iova_range {
>  /* Device can be resumed */
>  #define VHOST_BACKEND_F_RESUME  0x5
>  /* Device supports the driver enabling virtqueues both before and after
> - * DRIVER_OK
> + * DRIVER_OK. If this feature is not negotiated, the virtqueues must be
> + * enabled before setting DRIVER_OK.
>   */
>  #define VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK  0x6
>  /* Device may expose the virtqueue's descriptor area, driver area and
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index bc4a51e4638b..1fba305ba8c1 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -651,6 +651,10 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa=
 *v, unsigned int cmd,
>         case VHOST_VDPA_SET_VRING_ENABLE:
>                 if (copy_from_user(&s, argp, sizeof(s)))
>                         return -EFAULT;
> +               if (!vhost_backend_has_feature(vq,
> +                       VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK) &&
> +                   (ops->get_status(vdpa) & VIRTIO_CONFIG_S_DRIVER_OK))
> +                       return -EINVAL;

As discussed, without VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK, we don't
know if parents can do vq_ready after driver_ok.

So maybe we need to keep this behaviour to unbreak some "legacy" userspace?

For example ifcvf did:

static void ifcvf_vdpa_set_vq_ready(struct vdpa_device *vdpa_dev,
                                    u16 qid, bool ready)
{
  struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);

        ifcvf_set_vq_ready(vf, qid, ready);
}

And it did:

void ifcvf_set_vq_ready(struct ifcvf_hw *hw, u16 qid, bool ready)
{
        struct virtio_pci_common_cfg __iomem *cfg =3D hw->common_cfg;

        vp_iowrite16(qid, &cfg->queue_select);
        vp_iowrite16(ready, &cfg->queue_enable);
}

Though it didn't advertise VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK?

Adding LingShan for more thought.

Thanks

>                 ops->set_vq_ready(vdpa, idx, s.num);
>                 return 0;
>         case VHOST_VDPA_GET_VRING_GROUP:
> --
> 2.43.0
>


