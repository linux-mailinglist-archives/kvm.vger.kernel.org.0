Return-Path: <kvm+bounces-13452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32A8F896B37
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 11:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C936282D4D
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 09:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BADE1350D7;
	Wed,  3 Apr 2024 09:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cTd6vcUi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7DA13540B
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 09:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712138281; cv=none; b=JBgu8butjLQ16zxO4xJsoL4yNjHFTQQmOPMXPBrBcWFX5LAaC8vNb79AcX3KDBHCY+/LFu1DQUfuAabWMOYNgczN8Zf0eCM2jFiaJVZtJORVRc36WoRbIlIoz3zSgoURyKyVilR8jxlxWmnBt5mar6vruxg6GqZiqhQwAKc/tGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712138281; c=relaxed/simple;
	bh=8RRynYXEEsr910DpOhWgmhyIrE00u1hABv+0y3HxPJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dgx70rhborxVES6adzTuhkIb8e3wd6yL/9Bo69jACaHUr1YV0+iNl0yxe7jC9q3xFUn8TkGu+FP2FXEWMwSjN4VuJQNLGQnv57GGqa0rvf6OgH4pwL2583juuHWm5LROMSH0pq+k2ZXeiAU1kAalTwuJg205b6ABQ2HNGHTHrLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cTd6vcUi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712138278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0NkjBL5bDYnfw/9r7z0I5K4fWXu8LGwC+T3Asv+pwcA=;
	b=cTd6vcUip3O1uXuISY8o2DL1x9xfi09U/s7cAsgjY1aGYj4/R8NpEsowmv6dpEvwYf70Wh
	CzMZOUSq3OE/uNFytQ03QcP8mDBeC164w6ydC5ETlFRTsqyCZO63EXoNt4PKG14d/frfMD
	BISWoYINYT/mMdLBF2Wy5/Geo6Butm8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-YX8vnTIsO06gM4vqFmR7Vw-1; Wed, 03 Apr 2024 05:57:57 -0400
X-MC-Unique: YX8vnTIsO06gM4vqFmR7Vw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-41493ba3fcbso27969375e9.1
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 02:57:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712138276; x=1712743076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0NkjBL5bDYnfw/9r7z0I5K4fWXu8LGwC+T3Asv+pwcA=;
        b=q5U3stzaLejPmwz/nyv/h848SHHiUE4D2Lt2ZGKOzKgVuOcwpoqb8QDtnHdJqdkdqD
         06mSgHpnLTonrnoE1rFV0TWnL2ttqKTrbOMeMm6D9CLoqbIuM6koAXOgHozId5EyCip+
         3H73qHyZ4YW+OvrzKwC/vwSlbrPl+1eQcoqwKRimRDpa9YXdp/u3XoAKHRIOkFcwBKQT
         izsJYeZUYAzR7pulJ9/PxXkVkv5nn9N+WGVL3T6KlN6up5wmjeGf72ml1M/AxDDcD5/m
         BwJxkOPgwsraXV/cSbmIkPNX1zKK/uiESdg6lcVKbjeWKj/+CxjEGV1QInFMPSL5UNRN
         hM/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUzFzACAbF5bJTJaYu2Et6aubXhdusmzw+VyZmafBEAlsCIOHA3xM44K4BAz05iKMqghv4sBzS7q2Txnz0cWI4Xa9Vt
X-Gm-Message-State: AOJu0YzB2dyQ8tn8bXReQ7a7RaMvY6N5y9wd1B6nWHmaP0eWfCLJkzft
	OsoSFc09vuYSEjfpLr5JgamKNA9NCYVThUPfGjRiCd3dM7cZShS342NXQ/5L3dQ8Y4Q4H67Ht5J
	HI+aFCbK2XOW1Dls/ilFmNvRetVUt4n7tuv/e46ygGgIB8HF6uQ==
X-Received: by 2002:a05:600c:1c99:b0:414:8a28:6c89 with SMTP id k25-20020a05600c1c9900b004148a286c89mr12523545wms.31.1712138276249;
        Wed, 03 Apr 2024 02:57:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFOILQPfbGHxrOwnJYPLVzz5jLbxh1TQ7R/N3HPs9ewOGHos/rV5L9Q51JZB17uMPSq+TTRmQ==
X-Received: by 2002:a05:600c:1c99:b0:414:8a28:6c89 with SMTP id k25-20020a05600c1c9900b004148a286c89mr12523530wms.31.1712138275940;
        Wed, 03 Apr 2024 02:57:55 -0700 (PDT)
Received: from sgarzare-redhat ([185.95.145.60])
        by smtp.gmail.com with ESMTPSA id m4-20020a05600c3b0400b004161b8a0310sm4955377wms.1.2024.04.03.02.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 02:57:55 -0700 (PDT)
Date: Wed, 3 Apr 2024 11:57:50 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Zhu Lingshan <lingshan.zhu@intel.com>, Jason Wang <jasowang@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>, 
	Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	Kan Liang <kan.liang@linux.intel.com>
Subject: Re: [PATCH] vhost-vdpa: change ioctl # for VDPA_GET_VRING_SIZE
Message-ID: <qxnpqulknydwdaqn2uangg6ke6pzeo46us2xnqw37ll6m4te5m@ounccq6x7sto>
References: <41c1c5489688abe5bfef9f7cf15584e3fb872ac5.1712092759.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <41c1c5489688abe5bfef9f7cf15584e3fb872ac5.1712092759.git.mst@redhat.com>

On Tue, Apr 02, 2024 at 05:21:39PM -0400, Michael S. Tsirkin wrote:
>VDPA_GET_VRING_SIZE by mistake uses the already occupied
>ioctl # 0x80 and we never noticed - it happens to work
>because the direction and size are different, but confuses
>tools such as perf which like to look at just the number,
>and breaks the extra robustness of the ioctl numbering macros.
>
>To fix, sort the entries and renumber the ioctl - not too late
>since it wasn't in any released kernels yet.
>
>Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
>Reported-by: Namhyung Kim <namhyung@kernel.org>
>Fixes: 1496c47065f9 ("vhost-vdpa: uapi to support reporting per vq size")
>Cc: "Zhu Lingshan" <lingshan.zhu@intel.com>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>---
>
>Build tested only - userspace patches using this will have to adjust.
>I will merge this in a week or so unless I hear otherwise,
>and afterwards perf can update there header.

Fortunately, we haven't released any kernels with this yet, right?
(other than v6.9-rc*)

LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
> include/uapi/linux/vhost.h | 15 ++++++++-------
> 1 file changed, 8 insertions(+), 7 deletions(-)
>
>diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
>index bea697390613..b95dd84eef2d 100644
>--- a/include/uapi/linux/vhost.h
>+++ b/include/uapi/linux/vhost.h
>@@ -179,12 +179,6 @@
> /* Get the config size */
> #define VHOST_VDPA_GET_CONFIG_SIZE	_IOR(VHOST_VIRTIO, 0x79, __u32)
>
>-/* Get the count of all virtqueues */
>-#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
>-
>-/* Get the number of virtqueue groups. */
>-#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x81, __u32)
>-
> /* Get the number of address spaces. */
> #define VHOST_VDPA_GET_AS_NUM		_IOR(VHOST_VIRTIO, 0x7A, unsigned int)
>
>@@ -228,10 +222,17 @@
> #define VHOST_VDPA_GET_VRING_DESC_GROUP	_IOWR(VHOST_VIRTIO, 0x7F,	\
> 					      struct vhost_vring_state)
>
>+
>+/* Get the count of all virtqueues */
>+#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
>+
>+/* Get the number of virtqueue groups. */
>+#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x81, __u32)
>+
> /* Get the queue size of a specific virtqueue.
>  * userspace set the vring index in vhost_vring_state.index
>  * kernel set the queue size in vhost_vring_state.num
>  */
>-#define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x80,	\
>+#define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x82,	\
> 					      struct vhost_vring_state)
> #endif
>-- 
>MST
>
>


