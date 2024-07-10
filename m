Return-Path: <kvm+bounces-21335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E89F392D81B
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 20:13:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48CF6B251C7
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 18:13:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 663EB196C7B;
	Wed, 10 Jul 2024 18:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PAD7QrvC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB82195F0D
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 18:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720635208; cv=none; b=LaXgA2xTpJLF9YiXVCZJBFz2IWuT3j8hDHoEoWj3Z8n15RHYDdnFOZ+O0BP3AMITgMAJGRS6mCa6bRbIUatfGMPxa/Km4cocLdAVn3vuisGnjavgtZqsSnyHkg+C7Nbk717QgPZsbHCaicjvGCp+p8EmCMs7EqFH7VHOFU/+4gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720635208; c=relaxed/simple;
	bh=MowyvhNf6vGY6QkQdJz3UoNEMj0pRe3OT+CjdYCaGBU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZyJ6TKGjO+cCFptl+ytx4qmTeGq4XOEtFjpbxCz4aIVocQ4h6hUWZjuwH0UDGP/Olq4YR+An2crUT5WMwZrtR0UrTPNvQSIA6c6xfnP0KPAav/hXXRWylwqXOi/yTN+SaI6f/LD/gFwM8c2LKCgQeQME3qny3zLf85DByA4+414=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=PAD7QrvC; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52ea929ea56so156969e87.0
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 11:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1720635205; x=1721240005; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F+jxUeQSFPMoGDRB/Tj2AzJBbVNk2aXSQNlmGiXjDjE=;
        b=PAD7QrvCndQfdX0FM2LmbiQFvS4NyxbENbVCkw+4kc75djMbGrc/qzgGZC8hmJLeDE
         nUjfiOHewOqTvZ0X4LgJnkXvtkO4pQc4HkslY4NgVIIYgP+J50SN0pMgVbIY09799v/k
         gRVgDVsrvesl9gCgOO5OYF6bA2ssUOp/3s6IE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720635205; x=1721240005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F+jxUeQSFPMoGDRB/Tj2AzJBbVNk2aXSQNlmGiXjDjE=;
        b=r3yFa5na2K0pUPGQVnhEUWUAl6IsP1z56zoLV2h3Bzanv2Fi2FMku9tak01Uk6V8XL
         eQak4WPANzwfWz/srN1BCRYmcAgy5KTpZ3wtp/abES5rjEO2yYWXdoXgUtTaHYRilBKY
         stMTy55zMI+rsF3D3Mn3d6CE7oA+MIqubUNxXKRNZYiECogu1HIxbwHPhLGz+J4WanAl
         6etdj7LXzP2yPS8aMybu/DZu1iKUEewyQsCo45slx4jL4d95vWEgJkBJa9KiX6YT0tYs
         wVx9xazIYqFrqIWJUXJ3VFQWBxSYgxu+PALX5fjbWF1MEYRhe0tYZK/Y4ekifBQvZs+v
         qvxw==
X-Forwarded-Encrypted: i=1; AJvYcCXXyNVK2fPC1456yJNbQLJaDla0RbvPiBlpSw8B04BrAXNzrzmWxmgnKOs+wCkUbywMovzjyveY2G/OtBQMofrCWkce
X-Gm-Message-State: AOJu0YwFhFlIqlOyFKsYOAzAnQYWvnIGjy/Xogm+rrBL70scqQvY2mIX
	dpiGwvshSp+ARfr+j454MczBO0NG3Nz/odzKdZmYOx06qAI2CRmva6fOymlfc+Xr2scwF45wMpm
	Ykwfk04c=
X-Google-Smtp-Source: AGHT+IF2B17SHQhMsU43shYKXayX9gkU/5KSoEKcFBoAIAcKXG0wtDfqy2PMG96/eJzEH2kM7EcsuA==
X-Received: by 2002:a05:6512:6c3:b0:52c:e10b:cb33 with SMTP id 2adb3069b0e04-52eb99d2722mr5159202e87.50.1720635204890;
        Wed, 10 Jul 2024 11:13:24 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a7ff0c8sm180183466b.133.2024.07.10.11.13.22
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jul 2024 11:13:22 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a77cc44f8aaso3006366b.3
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 11:13:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWdjNVgJgaq+XVyZGtvc01f6chjJnDv2Nx8u6k4FDNZyZyi4N7EQDWspKLHCWV7jH5qfF/ixMeJAnFX6zcpsFt0uP0s
X-Received: by 2002:a05:6512:281d:b0:52c:cd77:fe03 with SMTP id
 2adb3069b0e04-52eb9991dcfmr5848110e87.14.1720635181335; Wed, 10 Jul 2024
 11:13:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1720611677.git.mst@redhat.com> <3d655be73ce220f176b2c163839d83699f8faf43.1720611677.git.mst@redhat.com>
In-Reply-To: <3d655be73ce220f176b2c163839d83699f8faf43.1720611677.git.mst@redhat.com>
From: Daniel Verkamp <dverkamp@chromium.org>
Date: Wed, 10 Jul 2024 11:12:34 -0700
X-Gmail-Original-Message-ID: <CABVzXAnjAdQqVNtir_8SYc+2dPC-weFRxXNMBLRcmFsY8NxBhQ@mail.gmail.com>
Message-ID: <CABVzXAnjAdQqVNtir_8SYc+2dPC-weFRxXNMBLRcmFsY8NxBhQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] virtio: fix vq # for balloon
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	Alexander Duyck <alexander.h.duyck@linux.intel.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Jason Wang <jasowang@redhat.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	linux-um@lists.infradead.org, linux-remoteproc@vger.kernel.org, 
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024 at 4:43=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> virtio balloon communicates to the core that in some
> configurations vq #s are non-contiguous by setting name
> pointer to NULL.
>
> Unfortunately, core then turned around and just made them
> contiguous again. Result is that driver is out of spec.

Thanks for fixing this - I think the overall approach of the patch looks go=
od.

> Implement what the API was supposed to do
> in the 1st place. Compatibility with buggy hypervisors
> is handled inside virtio-balloon, which is the only driver
> making use of this facility, so far.

In addition to virtio-balloon, I believe the same problem also affects
the virtio-fs device, since queue 1 is only supposed to be present if
VIRTIO_FS_F_NOTIFICATION is negotiated, and the request queues are
meant to be queue indexes 2 and up. From a look at the Linux driver
(virtio_fs.c), it appears like it never acks VIRTIO_FS_F_NOTIFICATION
and assumes that request queues start at index 1 rather than 2, which
looks out of spec to me, but the current device implementations (that
I am aware of, anyway) are also broken in the same way, so it ends up
working today. Queue numbering in a spec-compliant device and the
current Linux driver would mismatch; what the driver considers to be
the first request queue (index 1) would be ignored by the device since
queue index 1 has no function if F_NOTIFICATION isn't negotiated.

[...]
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_p=
ci_common.c
> index 7d82facafd75..fa606e7321ad 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -293,7 +293,7 @@ static int vp_find_vqs_msix(struct virtio_device *vde=
v, unsigned int nvqs,
>         struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
>         struct virtqueue_info *vqi;
>         u16 msix_vec;
> -       int i, err, nvectors, allocated_vectors, queue_idx =3D 0;
> +       int i, err, nvectors, allocated_vectors;
>
>         vp_dev->vqs =3D kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
>         if (!vp_dev->vqs)
> @@ -332,7 +332,7 @@ static int vp_find_vqs_msix(struct virtio_device *vde=
v, unsigned int nvqs,
>                         msix_vec =3D allocated_vectors++;
>                 else
>                         msix_vec =3D VP_MSIX_VQ_VECTOR;
> -               vqs[i] =3D vp_setup_vq(vdev, queue_idx++, vqi->callback,
> +               vqs[i] =3D vp_setup_vq(vdev, i, vqi->callback,
>                                      vqi->name, vqi->ctx, msix_vec);
>                 if (IS_ERR(vqs[i])) {
>                         err =3D PTR_ERR(vqs[i]);
> @@ -368,7 +368,7 @@ static int vp_find_vqs_intx(struct virtio_device *vde=
v, unsigned int nvqs,
>                             struct virtqueue_info vqs_info[])
>  {
>         struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> -       int i, err, queue_idx =3D 0;
> +       int i, err;
>
>         vp_dev->vqs =3D kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
>         if (!vp_dev->vqs)
> @@ -388,8 +388,13 @@ static int vp_find_vqs_intx(struct virtio_device *vd=
ev, unsigned int nvqs,
>                         vqs[i] =3D NULL;
>                         continue;
>                 }
> +<<<<<<< HEAD
>                 vqs[i] =3D vp_setup_vq(vdev, queue_idx++, vqi->callback,
>                                      vqi->name, vqi->ctx,
> +=3D=3D=3D=3D=3D=3D=3D
> +               vqs[i] =3D vp_setup_vq(vdev, i, callbacks[i], names[i],
> +                                    ctx ? ctx[i] : false,
> +>>>>>>> f814759f80b7... virtio: fix vq # for balloon

This still has merge markers in it.

Thanks,
-- Daniel

