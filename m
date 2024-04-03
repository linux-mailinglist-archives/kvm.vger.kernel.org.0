Return-Path: <kvm+bounces-13422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8369489645D
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 08:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 243AC1F22587
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 06:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B59352F9E;
	Wed,  3 Apr 2024 06:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Carb0pZQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B388C4D13B
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 06:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712124514; cv=none; b=IJV2Tf59ayiClFf0VHlhg5ibQ/VZiD/RpmsU8pR+tFCQM7djfVkOn/9pBjST/75oiht4Jy3REWfxubqH7uKlsyknumAFN2Hy4sxdB+1w2uqmr523dhZ/KSB8uUSXa7KxwbXA8PuttU+s5y5J3eKw+eAAt7UT7m/wm7CquT7FYtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712124514; c=relaxed/simple;
	bh=n+K/WKHKa56zG0gtzaNGqEcUES/pcfC2imzCQDemtFA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gXinvMSOEQ0/5EMMwbBCKRM05iMrxxOdnrC4efi0kgeyvtzfhtvqBUQv0v+a8UUfsmJXLj7C52zzn2yVzTx8fPcYMO7EAC5TB7QOJ28q3qgz5IHNos2rCti28J8OBmVGrEVkF47D405/N9uTRu2W04Kd6x8W9xUAK/qMP1N1HSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Carb0pZQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712124511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dKiObTP8y8JIszvzACHMM1F2zBJdbISLN+XkZvP60BM=;
	b=Carb0pZQmaAU8cEFbY1jKHRcL51vs3qvVNVDS3RIMAnXHNeiroiHHF99HCaE65JkCWL6o3
	orC481Dwhk/jBTTGwbeSFJpPiej1zdMRGkI3iGS45b9Aspju1830DNJNRtInuHRp3YetQM
	Gio+3AbsS6X3yHoMU1e9UMWtrsyYhY0=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-J0s6tzk8OYSYrRVo0pMxdg-1; Wed, 03 Apr 2024 02:08:30 -0400
X-MC-Unique: J0s6tzk8OYSYrRVo0pMxdg-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-dce775fa8adso10258273276.1
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 23:08:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712124509; x=1712729309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dKiObTP8y8JIszvzACHMM1F2zBJdbISLN+XkZvP60BM=;
        b=MFxAaDoMGW1OKtWB/GNXLy20NM8ejcLpI3MJxJjIjGPb+9fNyHS5HMLLgEbB7KRnEg
         BUYzyXjDv8oISlkjbbQkLaCmbpoW9TVHe9ovq+oQmSRadyX0JFhEOBmry+aB0okQBfu+
         6T7C7chLz2DpSs1eY5/9ptj1FkD7feZYDu1mXPOyz1ilGXHysT47gZXif+Y8RUCdbYP2
         BUiCJXC1jAFmnAeUnNJyumGhO0eNvQ4J0ttLv8L2HSFJsfyfyJ2V7KhiK97vekl6oEFg
         gIUw1u2HD7iH/QSzF275Ef8G0APVQo27qthGAwRh2SdthjwjazyX6CBfD6lYFNtRFVC1
         Tr3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVZAarMMlyihfI7XLenC8LaHbZFTALM2xE+yBwWTowSrL80n/lU9qPsNP1rrVxPS6QGdeXzhajnrKtBnQZJ7H/e6HPB
X-Gm-Message-State: AOJu0YzIcPVV5NIGyAoe4usqXBNNWwTHN1nWMOyiJF7uUsPFiGaDe4Ql
	uf2abq3PCLQNqBSLQAibyiSYAJMLWWfjRixLC0wvojKGLp7NvbT2hgV/ThJD9TujAW6Vs65K8nt
	dJ33BgctkMWfCr7eIN5sLimg9Ybmm3a+y5KXYeC/1imJCxMjHJgEtZ2shTi9uigOv3Y3HqhLcbZ
	dcqbDi6YOB/KPyXol0gZ0MCCly
X-Received: by 2002:a25:8d81:0:b0:dc7:4ad4:c977 with SMTP id o1-20020a258d81000000b00dc74ad4c977mr11567593ybl.25.1712124509552;
        Tue, 02 Apr 2024 23:08:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLucByfZxTlPvL5mn2OuVfkSkFpPoYO9hN2EI2zakPuPYMkYPkNEVffrYwZ3CRZp1u0dhS7qJEshPNUUMJLuQ=
X-Received: by 2002:a25:8d81:0:b0:dc7:4ad4:c977 with SMTP id
 o1-20020a258d81000000b00dc74ad4c977mr11567576ybl.25.1712124509222; Tue, 02
 Apr 2024 23:08:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <41c1c5489688abe5bfef9f7cf15584e3fb872ac5.1712092759.git.mst@redhat.com>
In-Reply-To: <41c1c5489688abe5bfef9f7cf15584e3fb872ac5.1712092759.git.mst@redhat.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 3 Apr 2024 08:07:53 +0200
Message-ID: <CAJaqyWd+MsOc=ac_Ns=L0xtQ9iTX-0_sbREokRQnnjr_aHF6fQ@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: change ioctl # for VDPA_GET_VRING_SIZE
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Zhu Lingshan <lingshan.zhu@intel.com>, 
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>, 
	Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	Kan Liang <kan.liang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 2, 2024 at 11:21=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
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
> Fixes: 1496c47065f9 ("vhost-vdpa: uapi to support reporting per vq size")
> Cc: "Zhu Lingshan" <lingshan.zhu@intel.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

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


