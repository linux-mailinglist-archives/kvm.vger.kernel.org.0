Return-Path: <kvm+bounces-63674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B41C6CEFF
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 07:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D270334E02F
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 06:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 507E9328614;
	Wed, 19 Nov 2025 06:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TQDkUn1V";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="g7yEL0VI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32369326D51
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 06:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763533588; cv=none; b=OvGXhlPWlTAsQYuRmhPPnNRd3VXSpsAxzz68+MrOSjNkzwYSE0c6PLpsDJhaUE5N9/PTT6OD1CYlK7XPVHS5dU8caJutp6DqrIxm457ALarzYVUr98V/3BT9aD6T5odRvqBWwvV9rbTtMOjQmsGjJU8Y5PxwMjpDeH0YLy1G7ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763533588; c=relaxed/simple;
	bh=5EDc/f+VmsHhTS8Xoex2CMoDeMz7q9mQHhQgB7L90Ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UhA06uts4dhj5Kf31ibjUgvMB2707nHHwSCtSjlDcFA+TdPIbYcPElqRbt5sWw5e1iBxysYlnS+YiElWH2dPIXa48WO4JlQd8aOI2W51BXquRuxmQzBZ/YN3m3cF/8aj0wCWjiaCjMsSSihJKHvxoDrW/BblrUul4bGBSHzR41g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TQDkUn1V; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=g7yEL0VI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763533585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y1HKVzAgxx7i6yZ83N1XooYE8usn83cITm9aQzQHukg=;
	b=TQDkUn1VKSwF9yJmeweZA4zpBTOsPsKYd12OzkXuunT3HwJeAGeemzYJy4EyE1K7hmjAoF
	ZXoAGz+gqwaT2FQjP73qiIWLWwZvTMHIHtgoElu4kEr/SGnGlk5lIbU4fbdtJGOnHbhjYL
	CFdn92vV9tAnaHqJFdQnJY3qOwadr48=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-SKEpIN4APe2N-Wem2VQsog-1; Wed, 19 Nov 2025 01:26:23 -0500
X-MC-Unique: SKEpIN4APe2N-Wem2VQsog-1
X-Mimecast-MFC-AGG-ID: SKEpIN4APe2N-Wem2VQsog_1763533582
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477a95586f1so12645835e9.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763533582; x=1764138382; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=y1HKVzAgxx7i6yZ83N1XooYE8usn83cITm9aQzQHukg=;
        b=g7yEL0VI2JbRyVQg5jLA7SxM2YqkQc+8obmmUwZX9fPJQ/QirrvAKksAPU3j8kGmIJ
         kycnioDgDr4GreC5j/r7+1zP4evqyk3yZVlKv1iqDjkVRMIdLHizCkZLRUp8GUyJrJSh
         C8GXJkVOrYz6ECiuh7/qwF6mAAnrmw2Lw1PAaNdv58HtGkyMOLS0MbsRZlZx3IypbDIC
         Jxw3UcUz39p52HbH/T3Wag3qwPoUAckcdsgyRa0U7KW5Pp2YvIOxOMoCTbHzmBJhipNh
         RZUXsiUfdsIo/y1k8Nfpw+7GaNo4AADQI9N6VupDwU9Ytm7/BOacX1KPvIKDmLnTTbRM
         aczA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763533582; x=1764138382;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y1HKVzAgxx7i6yZ83N1XooYE8usn83cITm9aQzQHukg=;
        b=DAEZKiK9lv8Bp+iH7dRcRScI5kc00lbK/J3ELcTMXqyvEaSBj7q1xTxoIoU0oX1S1l
         vCeiHlxXuzJf9TyQ9FIRGRKrez9BHEwes3DA3lsd4W9W/vuWbQ4xUKrnOAm0vzJ07VlU
         Gh7AcghBvai2l4JOLgN55CBS792gENaHmUeWmS7Lt651QvrEnhH94s8THPuUwXhIj49F
         AU+t8N4T47ZMycMQfAt9uTCzBUP96iRKyCS873YD0lB15lPEpxCZC0rWBkoYNCQIxtNZ
         ItcU6sahK2mvPFnPUmE+LyEHVzV4W/VMLI4OwEbOyI5h/CwXgXWP5HcLFOxgTarQ87j0
         7+Ww==
X-Forwarded-Encrypted: i=1; AJvYcCWKXu0L4Gi3FpzqKPdSRhmKWUR2stqU9WXljmb565tLJedEq/PjkzKb/gJE44g7My2rRiw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJO/N8K1S9+kxVa5LYoJqkl45JFHSIVQ4ViCzZueq44dSIAGnm
	MJsoC3lRzIodFq6KTH+R+fb1ycpwuReckOpMgXD47NNUnOAxe1A16tGo8E9GT5o53vebIeD+ahz
	j0iwghfSaNFrDgBBx6QWlyw7xom6P73uC89h1wEOEYSrPSN2tPxDndw==
X-Gm-Gg: ASbGnctQAv9iX/RdecjdISTrhJhNfQsiht6RPdnXlBMV2yZ7WqK+1Vzs5wKmapf/UiK
	VjlOnUkoOpLFOGErX5dI3zhMKE1FiAF0oXuzm12USkSgKJvotvVTBYM+6xX9XaoOO55BgfZUPHN
	7rscOt/pPzr04nH+kHOoilvqMzfb1zwQEgsLZDoMTiTCl2ifQvRFd78SBPpPEVxsm/IRrHV2YwY
	A46214YPmJ3EKmNUMT2XSkONbOR3+XtJzsJVRbP+7K2DoICaLouellVTcayV4g0XbfXuCo84Ig8
	Ldw16t+0zMmePnHy0MdofPRjy42N2t2llWaTvWgth30iFyQNPwIkM9Un/xzJf5FEavINp6lPi+W
	jr+mbv7y7Wr0H8jSjecGIzj6Kb8rzOQ==
X-Received: by 2002:a5d:64e7:0:b0:429:cd3f:f45f with SMTP id ffacd0b85a97d-42b5933dc54mr17627887f8f.7.1763533581542;
        Tue, 18 Nov 2025 22:26:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGHbEIgDvwzU/PwaPvTTi3zQKc9nOXwTgJs02XEdEtPndPNL32NuK0ZEl+WnP3eYo21GNBnmw==
X-Received: by 2002:a5d:64e7:0:b0:429:cd3f:f45f with SMTP id ffacd0b85a97d-42b5933dc54mr17627860f8f.7.1763533581006;
        Tue, 18 Nov 2025 22:26:21 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f206e2sm36522931f8f.41.2025.11.18.22.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 22:26:20 -0800 (PST)
Date: Wed, 19 Nov 2025 01:26:17 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mike Christie <michael.christie@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: [PATCH v4 2/2] vhost: switch to arrays of feature bits
Message-ID: <20251119012322-mutt-send-email-mst@kernel.org>
References: <cover.1763278904.git.mst@redhat.com>
 <17c98c7304b6d78d2d59893ba7295c2f64ab1224.1763278904.git.mst@redhat.com>
 <CACGkMEu28fHr7Bo5Zm4chwOj-xBmTYcHM3TfXRx8OZ3OhO8q8Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEu28fHr7Bo5Zm4chwOj-xBmTYcHM3TfXRx8OZ3OhO8q8Q@mail.gmail.com>

On Wed, Nov 19, 2025 at 10:03:58AM +0800, Jason Wang wrote:
> On Sun, Nov 16, 2025 at 3:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > The current interface where caller has to know in which 64 bit chunk
> > each bit is, is inelegant and fragile.
> > Let's simply use arrays of bits.
> > By using unroll macros text size grows only slightly.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/vhost/net.c   | 34 +++++++++++++++++++---------------
> >  drivers/vhost/scsi.c  |  9 ++++++---
> >  drivers/vhost/test.c  | 10 ++++++++--
> >  drivers/vhost/vhost.h | 42 ++++++++++++++++++++++++++++++++++--------
> >  drivers/vhost/vsock.c | 10 ++++++----
> >  5 files changed, 73 insertions(+), 32 deletions(-)
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index d057ea55f5ad..00d00034a97e 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -69,15 +69,15 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
> >
> >  #define VHOST_DMA_IS_DONE(len) ((__force u32)(len) >= (__force u32)VHOST_DMA_DONE_LEN)
> >
> > -static const u64 vhost_net_features[VIRTIO_FEATURES_U64S] = {
> > -       VHOST_FEATURES |
> > -       (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
> > -       (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
> > -       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> > -       (1ULL << VIRTIO_F_RING_RESET) |
> > -       (1ULL << VIRTIO_F_IN_ORDER),
> > -       VIRTIO_BIT(VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO) |
> > -       VIRTIO_BIT(VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO),
> > +static const int vhost_net_features[] = {
> > +       VHOST_FEATURES,
> > +       VHOST_NET_F_VIRTIO_NET_HDR,
> > +       VIRTIO_NET_F_MRG_RXBUF,
> > +       VIRTIO_F_ACCESS_PLATFORM,
> > +       VIRTIO_F_RING_RESET,
> > +       VIRTIO_F_IN_ORDER,
> > +       VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO,
> > +       VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO
> >  };
> >
> >  enum {
> > @@ -1734,14 +1734,14 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
> >                         return -EFAULT;
> >                 return vhost_net_set_backend(n, backend.index, backend.fd);
> >         case VHOST_GET_FEATURES:
> > -               features = vhost_net_features[0];
> > +               features = VHOST_FEATURES_U64(vhost_net_features, 0);
> >                 if (copy_to_user(featurep, &features, sizeof features))
> >                         return -EFAULT;
> >                 return 0;
> >         case VHOST_SET_FEATURES:
> >                 if (copy_from_user(&features, featurep, sizeof features))
> >                         return -EFAULT;
> > -               if (features & ~vhost_net_features[0])
> > +               if (features & ~VHOST_FEATURES_U64(vhost_net_features, 0))
> >                         return -EOPNOTSUPP;
> >
> >                 virtio_features_from_u64(all_features, features);
> > @@ -1753,9 +1753,13 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
> >                 /* Copy the net features, up to the user-provided buffer size */
> >                 argp += sizeof(u64);
> >                 copied = min(count, (u64)VIRTIO_FEATURES_U64S);
> > -               if (copy_to_user(argp, vhost_net_features,
> > -                                copied * sizeof(u64)))
> > -                       return -EFAULT;
> > +
> > +               {
> > +                       const DEFINE_VHOST_FEATURES_ARRAY(features, vhost_net_features);
> > +
> > +                       if (copy_to_user(argp, features, copied * sizeof(u64)))
> > +                               return -EFAULT;
> > +               }
> 
> Any reason to use a standalone block here?

Just so we can name the variable "features", as well as
having the declaration stand out a bit more.


> >
> >                 /* Zero the trailing space provided by user-space, if any */
> >                 if (clear_user(argp, size_mul(count - copied, sizeof(u64))))
> > @@ -1784,7 +1788,7 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
> >                 }
> >
> >                 for (i = 0; i < VIRTIO_FEATURES_U64S; i++)
> > -                       if (all_features[i] & ~vhost_net_features[i])
> > +                       if (all_features[i] & ~VHOST_FEATURES_U64(vhost_net_features, i))
> >                                 return -EOPNOTSUPP;
> >
> >                 return vhost_net_set_features(n, all_features);
> > diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> > index 98e4f68f4e3c..04fcbe7efd77 100644
> > --- a/drivers/vhost/scsi.c
> > +++ b/drivers/vhost/scsi.c
> > @@ -197,11 +197,14 @@ enum {
> >  };
> >
> >  /* Note: can't set VIRTIO_F_VERSION_1 yet, since that implies ANY_LAYOUT. */
> > -enum {
> > -       VHOST_SCSI_FEATURES = VHOST_FEATURES | (1ULL << VIRTIO_SCSI_F_HOTPLUG) |
> > -                                              (1ULL << VIRTIO_SCSI_F_T10_PI)
> > +static const int vhost_scsi_features[] = {
> > +       VHOST_FEATURES,
> > +       VIRTIO_SCSI_F_HOTPLUG,
> > +       VIRTIO_SCSI_F_T10_PI
> >  };
> >
> > +#define VHOST_SCSI_FEATURES VHOST_FEATURES_U64(vhost_scsi_features, 0)
> > +
> >  #define VHOST_SCSI_MAX_TARGET  256
> >  #define VHOST_SCSI_MAX_IO_VQ   1024
> >  #define VHOST_SCSI_MAX_EVENT   128
> > diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> > index 42c955a5b211..af727fccfe40 100644
> > --- a/drivers/vhost/test.c
> > +++ b/drivers/vhost/test.c
> > @@ -308,6 +308,12 @@ static long vhost_test_set_backend(struct vhost_test *n, unsigned index, int fd)
> >         return r;
> >  }
> >
> > +static const int vhost_test_features[] = {
> > +       VHOST_FEATURES
> > +};
> > +
> > +#define VHOST_TEST_FEATURES VHOST_FEATURES_U64(vhost_test_features, 0)
> > +
> >  static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
> >                              unsigned long arg)
> >  {
> > @@ -328,14 +334,14 @@ static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
> >                         return -EFAULT;
> >                 return vhost_test_set_backend(n, backend.index, backend.fd);
> >         case VHOST_GET_FEATURES:
> > -               features = VHOST_FEATURES;
> > +               features = VHOST_TEST_FEATURES;
> >                 if (copy_to_user(featurep, &features, sizeof features))
> >                         return -EFAULT;
> >                 return 0;
> >         case VHOST_SET_FEATURES:
> >                 if (copy_from_user(&features, featurep, sizeof features))
> >                         return -EFAULT;
> > -               if (features & ~VHOST_FEATURES)
> > +               if (features & ~VHOST_TEST_FEATURES)
> >                         return -EOPNOTSUPP;
> >                 return vhost_test_set_features(n, features);
> >         case VHOST_RESET_OWNER:
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index 621a6d9a8791..d8f1af9a0ff1 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -14,6 +14,7 @@
> >  #include <linux/atomic.h>
> >  #include <linux/vhost_iotlb.h>
> >  #include <linux/irqbypass.h>
> > +#include <linux/unroll.h>
> >
> >  struct vhost_work;
> >  struct vhost_task;
> > @@ -279,14 +280,39 @@ void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
> >                                 eventfd_signal((vq)->error_ctx);\
> >         } while (0)
> >
> > -enum {
> > -       VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
> > -                        (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> > -                        (1ULL << VIRTIO_RING_F_EVENT_IDX) |
> > -                        (1ULL << VHOST_F_LOG_ALL) |
> > -                        (1ULL << VIRTIO_F_ANY_LAYOUT) |
> > -                        (1ULL << VIRTIO_F_VERSION_1)
> > -};
> > +#define VHOST_FEATURES \
> > +       VIRTIO_F_NOTIFY_ON_EMPTY, \
> > +       VIRTIO_RING_F_INDIRECT_DESC, \
> > +       VIRTIO_RING_F_EVENT_IDX, \
> > +       VHOST_F_LOG_ALL, \
> > +       VIRTIO_F_ANY_LAYOUT, \
> > +       VIRTIO_F_VERSION_1
> > +
> > +static inline u64 vhost_features_u64(const int *features, int size, int idx)
> > +{
> > +       unsigned long res = 0;
> 
> Should this be u64?

Ugh. Yes.

> > +
> > +       unrolled_count(VIRTIO_FEATURES_BITS)
> > +       for (int i = 0; i < size; ++i) {
> > +               int bit = features[i];
> > +
> > +               if (virtio_features_chk_bit(bit) && VIRTIO_U64(bit) == idx)
> > +                       res |= VIRTIO_BIT(bit);
> > +       }
> > +       return res;
> > +}
> > +
> > +#define VHOST_FEATURES_U64(features, idx) \
> > +       vhost_features_u64(features, ARRAY_SIZE(features), idx)
> > +
> > +#define DEFINE_VHOST_FEATURES_ARRAY_ENTRY(idx, features) \
> > +       [idx] = VHOST_FEATURES_U64(features, idx),
> > +
> > +#define DEFINE_VHOST_FEATURES_ARRAY(array, features) \
> > +       u64 array[VIRTIO_FEATURES_U64S] = { \
> > +               UNROLL(VIRTIO_FEATURES_U64S, \
> > +                      DEFINE_VHOST_FEATURES_ARRAY_ENTRY, features) \
> > +       }
> >
> >  /**
> >   * vhost_vq_set_backend - Set backend.
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > index ae01457ea2cd..16662f2b87c1 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -29,12 +29,14 @@
> >   */
> >  #define VHOST_VSOCK_PKT_WEIGHT 256
> >
> > -enum {
> > -       VHOST_VSOCK_FEATURES = VHOST_FEATURES |
> > -                              (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> > -                              (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
> > +static const int vhost_vsock_features[] = {
> > +       VHOST_FEATURES,
> > +       VIRTIO_F_ACCESS_PLATFORM,
> > +       VIRTIO_VSOCK_F_SEQPACKET
> >  };
> >
> > +#define VHOST_VSOCK_FEATURES VHOST_FEATURES_U64(vhost_vsock_features, 0)
> > +
> >  enum {
> >         VHOST_VSOCK_BACKEND_FEATURES = (1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2)
> >  };
> > --
> > MST
> >
> 
> Thanks


