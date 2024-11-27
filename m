Return-Path: <kvm+bounces-32561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FAB09DA3F2
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 09:30:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65659284F75
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 08:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5346189919;
	Wed, 27 Nov 2024 08:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GOc38dii"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E44C133
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 08:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732696249; cv=none; b=BgyCLfGtDntKHpxke5f1k2Qqm2Q22s8ukXMRM1RbWsioLGLwz8v+P1iQAIQoogonLQiSiJ3z4LhQev2b0hBI4LqI0i+buDwmviM9zIv/FSF8M+i0tMq3pZtTwAH9VmVZR6I1aXdzpyzq7qsKCGVGk76F//7HnjxwBHhs2SmDnTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732696249; c=relaxed/simple;
	bh=Eoz0Q8Mkl/Pr7C3Gb8h9/rvKIVaHswPcRREVkWgCHFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXEvwTtIzPo9Pki3OBJa2zuJkD5Oo81LPC5ZvDKyaZTw+aa3GdJa11eTPZv7YXljwhzSdsreE7adNCcLUOLSKBfazdt7MM4lRFJHhpppp2hlIr+DuflKde7VqL0B4uJXL6LZZ/japtNg2DTPr9UASad1nvTz/4VmvmkPWWS2qGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GOc38dii; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732696247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4MUFVXWBRckkMqy36xXoK5Hu73zQLVLWkWdXnXLcAfI=;
	b=GOc38diim1rsdgIwrNU68kOakEz33NPfBZ+7Zk1f3qLFBlTMZpCaH8wzJ1W/ynxm+wlZQI
	7SSnLPNHYlLTtrqAuGsA3q6zWWG9GpMvFXsJaYFJc+qRh0Z6L2Oa/MNqZP0MkEAmW6mUjQ
	E+GTJOdyWS9fNs/0ZQFL07n9tLy3vkQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-z4limpNeNTuoFHnS-JvuwA-1; Wed, 27 Nov 2024 03:30:45 -0500
X-MC-Unique: z4limpNeNTuoFHnS-JvuwA-1
X-Mimecast-MFC-AGG-ID: z4limpNeNTuoFHnS-JvuwA
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-434a6483514so13948215e9.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 00:30:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732696244; x=1733301044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4MUFVXWBRckkMqy36xXoK5Hu73zQLVLWkWdXnXLcAfI=;
        b=OulOnasiuwrT2Q01esBWyhlwPnFY8QpNpdKimWOHpOgzyLupHss/+yoq4rxoAXjOy8
         oHfA/zCp2LHVac+awHU3zxsGVu3n/Ka8keuXeuw4eIYyTufhbLmatE2AdNuVlqOgQJB+
         RiE2BXkLg3t6Qmmbdo4McRpoYFI1OlBvBRMRIQIuafu9wLmlwn+e+ZTkY/WrFmlkFryW
         zbZea+OtWLfwyf6n+eKKtO3xC2k7bWaurpx76JuHOHGhBVrqvMgcis/sO5a1Zxbb1PAu
         Qe+WuSfSlXAKxt8+Dj/ScOsVUShwgOg7/CG/ZeIvRB66oF2/9SeO9N1T8V4ex/9/dxql
         U3KA==
X-Gm-Message-State: AOJu0YxlHIN6UJZE5k64jwFEBXyF+fvMF/O8I7YFe42m3Bjnvq5gVC3i
	C5mWkzF/JuAWY3KcO1ZIg1k95dH2tS78k3wuz4MrYspjcAK/UFskDfMHemZqG3HDsrFx/62ZpcW
	ZBD9JMpBVC/QEhPurNDFKgSfmOcMQFkCc649ZrmbZCYYyqtce6Q==
X-Gm-Gg: ASbGncuV0WaLlqyuGcC5v6VGkDKOeT5YPO3a1T7NkQyMukUchoc+mKac2B6b/+5hXxC
	wuLKU+UGdrUzk15MG0e60iBluPLRbx4V9ukcslVX2zpVljPzd8j/Ht4gVodIHIUunt5XIIekWid
	MsRKxeSHMGMcQTI6FWmX/CQFS4zAOp7rgRreOWLuLLlFd1nbGMtBpVsHG3qZ6ZoaKyL7Wr+fMX1
	evvS6CmCNz37V+fe/SgbQ74rsEcgSYGpNAGpuxaG/Vo
X-Received: by 2002:a05:600c:198c:b0:434:a386:6ae with SMTP id 5b1f17b1804b1-434a9db7cf7mr17738165e9.7.1732696244300;
        Wed, 27 Nov 2024 00:30:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH2ADNx1yo7XqVN38+hjrq+uT0dwvOn8CIAZOqDBS7VnrgJbvD/98tIaKuZzdGb8T2i4UE1fg==
X-Received: by 2002:a05:600c:198c:b0:434:a386:6ae with SMTP id 5b1f17b1804b1-434a9db7cf7mr17737925e9.7.1732696243978;
        Wed, 27 Nov 2024 00:30:43 -0800 (PST)
Received: from redhat.com ([2a02:14f:1f6:a902:b9b1:2d24:8c60:30dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434aa74ea95sm13552115e9.5.2024.11.27.00.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 00:30:43 -0800 (PST)
Date: Wed, 27 Nov 2024 03:30:39 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	colin.i.king@gmail.com, dtatulea@nvidia.com, eperezma@redhat.com,
	huangwenyu1998@gmail.com, jasowang@redhat.com, mgurtovoy@nvidia.com,
	philipchen@chromium.org, si-wei.liu@oracle.com
Subject: Re: [GIT PULL] virtio: features, fixes, cleanups
Message-ID: <20241127032948-mutt-send-email-mst@kernel.org>
References: <20241126163144-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241126163144-mutt-send-email-mst@kernel.org>

On Tue, Nov 26, 2024 at 04:31:51PM -0500, Michael S. Tsirkin wrote:
> 
> I was hoping to get vhost threading compat fixes in but no luck.
> A very quiet merge cycle - I guess it's a sign we got a lot merged
> last time, and everyone is busy testing. Right, guys?

You will get a merge conflict with net, resolution is here:

https://lore.kernel.org/all/20241118172605.19ee6f25@canb.auug.org.au/


> The following changes since commit 83e445e64f48bdae3f25013e788fcf592f142576:
> 
>   vdpa/mlx5: Fix error path during device add (2024-11-07 16:51:16 -0500)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> 
> for you to fetch changes up to 6a39bb15b3d1c355ab198d41f9590379d734f0bb:
> 
>   virtio_vdpa: remove redundant check on desc (2024-11-12 18:07:46 -0500)
> 
> ----------------------------------------------------------------
> virtio: features, fixes, cleanups
> 
> A small number of improvements all over the place.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> ----------------------------------------------------------------
> Colin Ian King (1):
>       virtio_vdpa: remove redundant check on desc
> 
> Max Gurtovoy (2):
>       virtio_fs: add informative log for new tag discovery
>       virtio_fs: store actual queue index in mq_map
> 
> Philip Chen (1):
>       virtio_pmem: Add freeze/restore callbacks
> 
> Si-Wei Liu (2):
>       vdpa/mlx5: Fix PA offset with unaligned starting iotlb map
>       vdpa/mlx5: Fix suboptimal range on iotlb iteration
> 
> Wenyu Huang (1):
>       virtio: Make vring_new_virtqueue support packed vring
> 
>  drivers/nvdimm/virtio_pmem.c |  24 +++++
>  drivers/vdpa/mlx5/core/mr.c  |  12 +--
>  drivers/virtio/virtio_ring.c | 227 +++++++++++++++++++++++--------------------
>  drivers/virtio/virtio_vdpa.c |   3 +-
>  fs/fuse/virtio_fs.c          |  13 +--
>  5 files changed, 159 insertions(+), 120 deletions(-)


