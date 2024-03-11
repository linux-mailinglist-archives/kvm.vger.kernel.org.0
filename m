Return-Path: <kvm+bounces-11537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96249877FE9
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 13:24:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3C351C21D5D
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 12:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B4723CF6A;
	Mon, 11 Mar 2024 12:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="glmRphLn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF8D3C08F;
	Mon, 11 Mar 2024 12:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710159864; cv=none; b=kAW7MrdnWTt85E8Zo2ZQYaOUarlJ8k9b4f0ya2butp0cCP5+geHNfAup0X2NGHN+zKuR/doSgUFFWMsk2kpAOkhzcNU/YX1UW5ZKPKdxM7yv/AzCqaVQUNbTl83TuN6KB53cZEnuODwShLAs0iUECSwap8LYdOTrVLrzyaujoJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710159864; c=relaxed/simple;
	bh=uvc2srdklbEZWRyAUkveO2lIu9fiESGPXlIMmlZAhO4=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cIP8iYFrvyoJXeeeiGi5omOOUAaabXnqh3amiY0nvOm3bihWyGZmuhoSi2LWoQsGb9SUee8mmKsWerY4Jm8LRFh2V1lxbQ8TDYMxTbsAoUEs3vXgicrVsH58h2K/2WaQkfD+wP2NB6DsyvPy3zCMdpua+iESMyXO3EPfoEyZbxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=glmRphLn; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710159864; x=1741695864;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=uvc2srdklbEZWRyAUkveO2lIu9fiESGPXlIMmlZAhO4=;
  b=glmRphLnYwKimpNj4U2bNeOiXI0FMC7Widap3UUfPf4xE4ARY82B7wSe
   OeHl6cVv+d5ltsfABLaNFT7m2W+GUgbl03laIjly73TnuOv/5XL8b5uNe
   QZuue/LaF9D/gmMS2Z7dr8ar6g9/qYsRqZu2chl/eN21AvGwrEt8Mzp9C
   U/r9VgepsxliSKygZqWSRTwKotusywAP15Kv0kQ0GIgTSTVdz687GAlyM
   o4VWtAAZjNygw85d3HDaJ6qF7hk9L5cUvq6kS6VAPjvSmlR2VS0RcYeq0
   ETA52MKs978ukun3nVCeCSYxTgK/7RUYMFLcx1FgJwnLJlLA543mZB0Zp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="15956660"
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="15956660"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 05:24:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="11240984"
Received: from ijarvine-desk1.ger.corp.intel.com (HELO localhost) ([10.245.244.201])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 05:24:16 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 11 Mar 2024 14:24:11 +0200 (EET)
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
Subject: Re: [PATCH vhost v2 0/4] refactor the params of find_vqs()
In-Reply-To: <20240311072113.67673-1-xuanzhuo@linux.alibaba.com>
Message-ID: <576263bc-5e86-5288-7fc5-de214dc622dd@linux.intel.com>
References: <20240311072113.67673-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-925155278-1710159757=:1071"
Content-ID: <c2f52b25-b189-ac04-112b-c9f04d16b66f@linux.intel.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-925155278-1710159757=:1071
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <f3d0e1c1-ebcb-baa0-324b-5ca93ffa7301@linux.intel.com>

On Mon, 11 Mar 2024, Xuan Zhuo wrote:

> This pathset is splited from the
>=20
>      http://lore.kernel.org/all/20240229072044.77388-1-xuanzhuo@linux.ali=
baba.com
>=20
> That may needs some cycles to discuss. But that notifies too many people.
>=20
> But just the four commits need to notify so many people.
> And four commits are independent. So I split that patch set,
> let us review these first.
>=20
> The patch set try to  refactor the params of find_vqs().
> Then we can just change the structure, when introducing new
> features.
>=20
> Thanks.
>=20
> v2:
>   1. add kerneldoc for "struct vq_transport_config" @ilpo.jarvinen
>=20
> v1:
>   1. fix some comments from ilpo.jarvinen@linux.intel.com
>=20
>=20
> Xuan Zhuo (4):
>   virtio: find_vqs: pass struct instead of multi parameters
>   virtio: vring_create_virtqueue: pass struct instead of multi
>     parameters
>   virtio: vring_new_virtqueue(): pass struct instead of multi parameters
>   virtio_ring: simplify the parameters of the funcs related to
>     vring_create/new_virtqueue()

FWIW,

Reviewed-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>

--=20
 i.
--8323328-925155278-1710159757=:1071--

