Return-Path: <kvm+bounces-11366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 890C08761D4
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 11:20:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E8631F223CA
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 10:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC39D54BCB;
	Fri,  8 Mar 2024 10:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Eq5SZJ1F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25BC54799;
	Fri,  8 Mar 2024 10:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709893179; cv=none; b=mfEK2Akvgi4JLJs1E2ljHbCyZLL6A0bC9d3jj7tEXBlHjOZf/FK4za7unw2QOqV8A66TXrf+kdrer0JL9NSFl2AmQBiB5a7UZpI8OdESZ7Nv9CtSyIlAb2LNMIUtaAgacfEjEMzLHB1M/8qCALdUK2+XkqrNchubT6lNXnnX3L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709893179; c=relaxed/simple;
	bh=Q1N/xDWWH1N2mESqkCTav+THxX2BdxiFo16ZnUREngs=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=POGS/UDqb84+5zwiTJwWAbmSnXRS2YYcEMRxCkGpHuapONjG/+fF9+GeoGYwJispQiBKudCdq3MwMd/KmNsovT0vtfsaiKapEotZpzY1o4YIQh51V7KS2B7RklI98Lo0YpNA/HYl8NEbxywFb1mpCIOjZot+ykbsnQk3QcJrDtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Eq5SZJ1F; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709893176; x=1741429176;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Q1N/xDWWH1N2mESqkCTav+THxX2BdxiFo16ZnUREngs=;
  b=Eq5SZJ1FtflK6578guuCz2itE8EOTVh/TvQG7hfRR24a4duSyDLwvfyd
   MjyV9Db3mNPjqRcYmPruJnz6gZc1r22CZRDmN3XVo+s7Sd+kCjtmAisZl
   uStNmLQ3uqOEYMy8Oa/o2qnu5nE6UK8r/MVdIUgAZOuUP60ieP/Y5LVFE
   8Fb7FZsqr+xzFrcyY2267fzdCwjG4Gr4S+VT1moJuk5/JfR9R0ivP7/Wb
   g5vJtCUqnyYl/Zjq0g3cgEp/fZNuNd27JXqw/squ779oLIIqs+AaJFYTH
   OwWPLJ1xmdBIaACfiPenIDvg9LxyaO7Hy6QFALJXlAn7addtHYsFZSeWx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="22132934"
X-IronPort-AV: E=Sophos;i="6.07,109,1708416000"; 
   d="scan'208";a="22132934"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 02:19:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,109,1708416000"; 
   d="scan'208";a="15004974"
Received: from ijarvine-desk1.ger.corp.intel.com (HELO localhost) ([10.245.244.186])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 02:19:27 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 8 Mar 2024 12:19:21 +0200 (EET)
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
    Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
    Johannes Berg <johannes@sipsolutions.net>, 
    Hans de Goede <hdegoede@redhat.com>, Vadim Pasternak <vadimp@nvidia.com>, 
    Bjorn Andersson <andersson@kernel.org>, 
    Mathieu Poirier <mathieu.poirier@linaro.org>, 
    Cornelia Huck <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, 
    Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
    Vasily Gorbik <gor@linux.ibm.com>, 
    Alexander Gordeev <agordeev@linux.ibm.com>, 
    Christian Borntraeger <borntraeger@linux.ibm.com>, 
    Sven Schnelle <svens@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
    Jason Wang <jasowang@redhat.com>, linux-um@lists.infradead.org, 
    platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
    linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH vhost v1 2/4] virtio: vring_create_virtqueue: pass struct
 instead of multi parameters
In-Reply-To: <20240306114615.88770-3-xuanzhuo@linux.alibaba.com>
Message-ID: <8f77a787-0bb7-96ad-0dac-f8ef36879ae3@linux.intel.com>
References: <20240306114615.88770-1-xuanzhuo@linux.alibaba.com> <20240306114615.88770-3-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 6 Mar 2024, Xuan Zhuo wrote:

> Now, we pass multi parameters to vring_create_virtqueue. These parameters
> may from transport or from driver.
> 
> vring_create_virtqueue is called by many places.
> Every time, we try to add a new parameter, that is difficult.
> 
> If parameters from the driver, that should directly be passed to vring.
> Then the vring can access the config from driver directly.
> 
> If parameters from the transport, we squish the parameters to a
> structure. That will be helpful to add new parameter.
> 
> Because the virtio_uml.c changes the name, so change the "names" inside
> the virtio_vq_config from "const char *const *names" to
> "const char **names".
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

> @@ -60,38 +61,25 @@ struct virtio_device;
>  struct virtqueue;
>  struct device;
>  
> +struct vq_transport_config {
> +	unsigned int num;
> +	unsigned int vring_align;
> +	bool weak_barriers;
> +	bool may_reduce_num;
> +	bool (*notify)(struct virtqueue *vq);
> +	struct device *dma_dev;
> +};

kerneldoc is missing from this struct too.

It would be generally helpful if you are proactive when somebody comments 
your series by checking if there are similar cases within your series,
instead of waiting them to be pointed out for you specificly.

-- 
 i.


