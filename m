Return-Path: <kvm+bounces-7582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1F0D843DAF
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 12:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 202CA1C290A6
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 11:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AB217AE50;
	Wed, 31 Jan 2024 11:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eM5jKjqd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A0279DB5;
	Wed, 31 Jan 2024 11:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706699001; cv=none; b=JtyT6Ug5sdt+B0i9PrVMEUxZAsj4LQtKsLWcQFG4gIyZ11RVF2GgBHYyUaHa3GADLDFNUivn17EP9l/LO0nYBPLsOZBB97iTjnFb9lBbm041i9QwOXgTyaBR6Y5mBBpfnLjHD7zMYR9TYOcXsuvS+oR0IR+1/hWZsxhSs/oBGAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706699001; c=relaxed/simple;
	bh=w5tD2hF6VL4scoYvTlWDh0fos6f759HiGvpQ7AYLjAI=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=LXB2YG4gtWYrpN5fX2dnPPX3va06A6+fwaiGM1Fo0dt65KmOR/dI8mP/wt/kdwmkWggVvTnsAUVPkc5L3pKBDeh3c0Xs6TN96JVH1vKrtVKhXqbhuFT7IjRXXUk5UKO4aeVKO2YjsHOk42NVCzvtqb5Lq61rZ8fyyimUbwmD9pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eM5jKjqd; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706699000; x=1738235000;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=w5tD2hF6VL4scoYvTlWDh0fos6f759HiGvpQ7AYLjAI=;
  b=eM5jKjqdQm8sQ40LKnBKeQGaM5Ae/8GYvptf9z6/jB8xM3mdIlpd3lUr
   pR+lBo3dnPRjRVNvTRCt5HuT4GTlTlSstMjWxMqaTLwjKTyvL+qNqN8uR
   k8uvfQczEXlmyigYwLoWDqEkTuJP/LotRaMuWiJOg+jNtmcDGmL1nCVtS
   FNJ+xQudFGmJCruBAMYBRnBjaGDCcl9PmO1mAZR5qp/zOfaLKZdHqqGXr
   TviAAz/0wj08411W7IwKN9QyQ3yEGhtC1xO2GTYk/kjyS+IwxGNQPom8W
   7kaX+pS5O8PLVT17eziH3pGM1G74k59noIa0eobQ9x2onOAVWW7aYHD1J
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="16947160"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="16947160"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 03:03:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="30460973"
Received: from ijarvine-desk1.ger.corp.intel.com (HELO localhost) ([10.246.35.167])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 03:03:08 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Wed, 31 Jan 2024 13:03:04 +0200 (EET)
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
    Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
    Johannes Berg <johannes@sipsolutions.net>, 
    "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
    "David S. Miller" <davem@davemloft.net>, 
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
    Paolo Abeni <pabeni@redhat.com>, Hans de Goede <hdegoede@redhat.com>, 
    =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
    Vadim Pasternak <vadimp@nvidia.com>, 
    Bjorn Andersson <andersson@kernel.org>, 
    Mathieu Poirier <mathieu.poirier@linaro.org>, 
    Cornelia Huck <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, 
    Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
    Vasily Gorbik <gor@linux.ibm.com>, 
    Alexander Gordeev <agordeev@linux.ibm.com>, 
    Christian Borntraeger <borntraeger@linux.ibm.com>, 
    Sven Schnelle <svens@linux.ibm.com>, Alexei Starovoitov <ast@kernel.org>, 
    Daniel Borkmann <daniel@iogearbox.net>, 
    Jesper Dangaard Brouer <hawk@kernel.org>, 
    John Fastabend <john.fastabend@gmail.com>, 
    Benjamin Berg <benjamin.berg@intel.com>, 
    Yang Li <yang.lee@linux.alibaba.com>, linux-um@lists.infradead.org, 
    Netdev <netdev@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
    linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, 
    kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH vhost 08/17] virtio: vring_new_virtqueue(): pass struct
 instead of multi parameters
In-Reply-To: <20240130114224.86536-9-xuanzhuo@linux.alibaba.com>
Message-ID: <bcd0e35e-e9a3-48b5-fc0a-117ba997439a@linux.intel.com>
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com> <20240130114224.86536-9-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 30 Jan 2024, Xuan Zhuo wrote:

> Just like find_vqs(), it is time to refactor the
> vring_new_virtqueue(). We pass the similar struct to
> vring_new_virtqueue.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---

> diff --git a/tools/virtio/vringh_test.c b/tools/virtio/vringh_test.c
> index 98ff808d6f0c..37f8c5d34285 100644
> --- a/tools/virtio/vringh_test.c
> +++ b/tools/virtio/vringh_test.c

> @@ -391,7 +391,7 @@ static int parallel_test(u64 features,
>  				/* Swallow all notifies at once. */
>  				if (read(to_guest[0], buf, sizeof(buf)) < 1)
>  					break;
> -				
> +
>  				receives++;
>  				virtqueue_disable_cb(vq);
>  				continue;
> @@ -424,7 +424,7 @@ static int parallel_test(u64 features,
>  				continue;
>  			if (read(to_guest[0], buf, sizeof(buf)) < 1)
>  				break;
> -				
> +

Two unrelated space changes. Please remove them from this patch.


-- 
 i.


