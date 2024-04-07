Return-Path: <kvm+bounces-13820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D919B89AE30
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 05:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F2A5282744
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 03:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A6D9BA42;
	Sun,  7 Apr 2024 03:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lq1lBg3j"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAED848E
	for <kvm@vger.kernel.org>; Sun,  7 Apr 2024 03:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712459580; cv=none; b=I3iy4Ei+9XVjJQZnee4htolG73/i9AP7BP/niQblmBqR+sOzneWgnkaSNxplaRcreGykHN1PDvJcLh+lW5/V4LL8OZsVYtehy6h2bUjWR/xLF34n9rjjCl8B3hN+i/oHAEzeLYMgbVCfwIo5+IL60yklLNu1RPlE2Np0byA//QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712459580; c=relaxed/simple;
	bh=TiIS2U0Z+wfIv7YPyJrbBALHfW6m6U5jca6+YzZuA6Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YDaBd5SP/tr459NMrk+cUyW/aDAsJvI9uHAp93VT//sfcijO3u7X6IetgwnIuP30U2CQIkGi3MdczTJcbDqAcJIZ48P/lfrk6qB7+Ma2But2psUa/S4PQ0pc8EBWTMadt+WTfMh43Z67TQoV9GujBAfUGsqrOWUbm4iPSRr9ikU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lq1lBg3j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712459577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MJmu/t6Sirl2odpSd1zSsNcSzxnsR4Ufnqv6dslmQe4=;
	b=Lq1lBg3jJm4jSUZ/GIybfSzzCE26MTKnCVqw0hSGyOdu24+V6lWeAYxS/TkDmBJ77QmJLZ
	kpHGTc1SAkhKphabBVWH/1aLJ+lY9Ahi/x13TStguXFh4teN8N2U21QE5+BuDJeSd6f/O+
	MRsp/dwwQXaBBH1pqoe3/XaPqWl5ih8=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-h4EuRbgDPPSm6fBaYy66xA-1; Sat, 06 Apr 2024 23:12:55 -0400
X-MC-Unique: h4EuRbgDPPSm6fBaYy66xA-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-22ee151dc4bso1299972fac.1
        for <kvm@vger.kernel.org>; Sat, 06 Apr 2024 20:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712459575; x=1713064375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJmu/t6Sirl2odpSd1zSsNcSzxnsR4Ufnqv6dslmQe4=;
        b=aYyIe0BYpajWWfxxznM3ger8cm5TYwrdlWpSzFzggQUFy39virMazRWf3PZL10PKHZ
         uSXpxizX4lUNcnmfJsCcgpRCb84UyjUatxKgBav4ccAykYv7Fvsa2IZwf0vvFcr1xBSs
         uzwduvj7BiCy2gH0Gx5/ABOUn52brw1ayVsfkj7NJGhZvQr4cslSjKGhKvz0+mXLlkTW
         S66glr8WGY2ct1Q7AtbiH02yhE3X1vHtsl0iUz6/sz/CXuNBVrVhpVNembBBU2wLJun/
         2bC2yDAkYuI6b0u7BKWgBE/dxKncV1GqWeXNN7mlbufSt6304jyOyI8U9zbKaQelQqXK
         yBhw==
X-Forwarded-Encrypted: i=1; AJvYcCX5FKYi30jsT30XskrrYJ9jCAQ5TcIUH4YOAtSXwh6ojJKAqnNXMRqE4ehw2ZA/XNh3osl81PDHrQVmPgKkePqKkjmO
X-Gm-Message-State: AOJu0YxePOoA/99NXiD+DY8zIwe4LBcEnWvESxC/JCO9WUeZ7aT9fm2O
	9EfokwfySyfXv+eKNK64JvP6tkUCxUo39+CrH6nJ1S2E+2vtVPKYeSDIYJVaXyWhAuioYMZBDyd
	z1FjtZ0Cr8VSOqFgv7ff/+f7UfTdz1b5T6SAxgC8U7Xl6A8GD0Q9dDnK3vtT2oWOlMcDjgxrVvb
	2hIvrZf8d9Y9ncBeFDFm4aC1pk
X-Received: by 2002:a05:6871:6a5:b0:22e:ae01:db2f with SMTP id l37-20020a05687106a500b0022eae01db2fmr5926313oao.36.1712459575188;
        Sat, 06 Apr 2024 20:12:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxJaq7stpKgMSraYoLMx3TodA+2coKA76eR/QIAcIB6lXcpj5+7p+9fIFMZ3XBRdEPZlKh8jIwI46m3wMubro=
X-Received: by 2002:a05:6871:6a5:b0:22e:ae01:db2f with SMTP id
 l37-20020a05687106a500b0022eae01db2fmr5926294oao.36.1712459574910; Sat, 06
 Apr 2024 20:12:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <41c1c5489688abe5bfef9f7cf15584e3fb872ac5.1712092759.git.mst@redhat.com>
In-Reply-To: <41c1c5489688abe5bfef9f7cf15584e3fb872ac5.1712092759.git.mst@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Sun, 7 Apr 2024 11:12:43 +0800
Message-ID: <CACGkMEuBt9BvUSr0hhSx4obX9SmiZgze8eK7Omujx1LBDgWz4A@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: change ioctl # for VDPA_GET_VRING_SIZE
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Zhu Lingshan <lingshan.zhu@intel.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Ian Rogers <irogers@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Kan Liang <kan.liang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 3, 2024 at 5:21=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> VDPA_GET_VRING_SIZE by mistake uses the already occupied
> ioctl # 0x80 and we never noticed - it happens to work
> because the direction and size are different, but confuses
> tools such as perf which like to look at just the number,
> and breaks the extra robustness of the ioctl numbering macros.
>
> To fix, sort the entries and renumber the ioctl - not too late
> since it wasn't in any released kernels yet.
>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Reported-by: Namhyung Kim <namhyung@kernel.org>
> Fixes: x ("vhost-vdpa: uapi to support reporting per vq size")
> Cc: "Zhu Lingshan" <lingshan.zhu@intel.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>
> Build tested only - userspace patches using this will have to adjust.
> I will merge this in a week or so unless I hear otherwise,
> and afterwards perf can update there header.
>
>  include/uapi/linux/vhost.h | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index bea697390613..b95dd84eef2d 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -179,12 +179,6 @@
>  /* Get the config size */
>  #define VHOST_VDPA_GET_CONFIG_SIZE     _IOR(VHOST_VIRTIO, 0x79, __u32)
>
> -/* Get the count of all virtqueues */
> -#define VHOST_VDPA_GET_VQS_COUNT       _IOR(VHOST_VIRTIO, 0x80, __u32)
> -
> -/* Get the number of virtqueue groups. */
> -#define VHOST_VDPA_GET_GROUP_NUM       _IOR(VHOST_VIRTIO, 0x81, __u32)
> -
>  /* Get the number of address spaces. */
>  #define VHOST_VDPA_GET_AS_NUM          _IOR(VHOST_VIRTIO, 0x7A, unsigned=
 int)
>
> @@ -228,10 +222,17 @@
>  #define VHOST_VDPA_GET_VRING_DESC_GROUP        _IOWR(VHOST_VIRTIO, 0x7F,=
       \
>                                               struct vhost_vring_state)
>
> +
> +/* Get the count of all virtqueues */
> +#define VHOST_VDPA_GET_VQS_COUNT       _IOR(VHOST_VIRTIO, 0x80, __u32)
> +
> +/* Get the number of virtqueue groups. */
> +#define VHOST_VDPA_GET_GROUP_NUM       _IOR(VHOST_VIRTIO, 0x81, __u32)
> +
>  /* Get the queue size of a specific virtqueue.
>   * userspace set the vring index in vhost_vring_state.index
>   * kernel set the queue size in vhost_vring_state.num
>   */
> -#define VHOST_VDPA_GET_VRING_SIZE      _IOWR(VHOST_VIRTIO, 0x80,       \
> +#define VHOST_VDPA_GET_VRING_SIZE      _IOWR(VHOST_VIRTIO, 0x82,       \
>                                               struct vhost_vring_state)
>  #endif
> --
> MST
>


