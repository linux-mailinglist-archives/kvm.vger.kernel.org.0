Return-Path: <kvm+bounces-13423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8810D896478
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 08:21:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF932B22172
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 06:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC54552F68;
	Wed,  3 Apr 2024 06:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MRUt4V79"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F37645;
	Wed,  3 Apr 2024 06:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712125245; cv=none; b=CZFmVEOQt5XbhYzm3OsldCgwyyHuvOUhedFBf+FRjSxNgQEiVh6ZuayV3CB2WdJrQz1PDRVDOY8Xxk7dw7XPnpUIvWrtkyrRwVG1wcYw68gVFJSs124iwP46l/Gl+GDRtITU85F3QdlwkyQlxfudUlrG6tnYq2WFHY5IoNbAX2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712125245; c=relaxed/simple;
	bh=JpP/EDsMSxDuAaZti2qzwzDnAIQsAXrHMUrBgeEJ/Qk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mgj9PrJMh9yCa6iEXsf8u7RscUlMTqPbiszG9OAXaEJn5rwYKZth1fiFlaib9/iyGYekFBWSjU0PuSkC9b8JxCckpZVCQWt08j9PUFAbWVGd80n3LjHYl0OPAaoUdYInzLCtSF6j02QXqYXhGBM1h2OWJVVmd4e/0geLHfYGya8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MRUt4V79; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712125243; x=1743661243;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JpP/EDsMSxDuAaZti2qzwzDnAIQsAXrHMUrBgeEJ/Qk=;
  b=MRUt4V79NBZ+BeHW+YxWuepAWZe9sZ1q9oc3AcphXNijuE44Al0B4LbO
   27F85VsRS7J0fal203h+lQ3AqWRLxvnVTHciAfkAFqLpHVeJMzx4O3Lha
   8zgDpqgnjB5ujSQhhkcmY+D/n70/byUBKsoW2G7KD+RB79X3InjMuQSl3
   sN2SNH7olqajdgVbIQAszjMszpRHfUroebh87fJP5OO6pcs4ql3B2Mulo
   3E5XBz80k41rK1I+r17mtSfOCozvLhKthRtqMFmWWzmMzqH3ZNP10Mfqt
   bcZ7pHVMorLzijgMAJ8wTYedQXU3eecoWbZMor2aa2Xo40ei/IHNMlEti
   w==;
X-CSE-ConnectionGUID: RON7XNj6TDuF+Iei/Ti7vA==
X-CSE-MsgGUID: McJnjiTdTs2c0XZvQvbxug==
X-IronPort-AV: E=McAfee;i="6600,9927,11032"; a="7492471"
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="7492471"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 23:20:43 -0700
X-CSE-ConnectionGUID: TsR1QIiURJmbYigYH81a0Q==
X-CSE-MsgGUID: jxr6We+rSRi5gdycU53sEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="23023367"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.124.249.198]) ([10.124.249.198])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 23:20:40 -0700
Message-ID: <81ba4f68-21b7-48bf-94ae-8cd72880fed6@intel.com>
Date: Wed, 3 Apr 2024 14:20:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost-vdpa: change ioctl # for VDPA_GET_VRING_SIZE
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Jason Wang <jasowang@redhat.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 Adrian Hunter <adrian.hunter@intel.com>, Ian Rogers <irogers@google.com>,
 Jiri Olsa <jolsa@kernel.org>, Kan Liang <kan.liang@linux.intel.com>
References: <41c1c5489688abe5bfef9f7cf15584e3fb872ac5.1712092759.git.mst@redhat.com>
Content-Language: en-US
From: "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <41c1c5489688abe5bfef9f7cf15584e3fb872ac5.1712092759.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/3/2024 5:21 AM, Michael S. Tsirkin wrote:
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

Reviewed-by: Zhu Lingshan <lingshan.zhu@intel.com>

Thanks for the fix and sorry for the mess, I should read the whole header file to check whether
the number is available.

> ---
>
> Build tested only - userspace patches using this will have to adjust.
> I will merge this in a week or so unless I hear otherwise,
> and afterwards perf can update there header.
>
>   include/uapi/linux/vhost.h | 15 ++++++++-------
>   1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index bea697390613..b95dd84eef2d 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -179,12 +179,6 @@
>   /* Get the config size */
>   #define VHOST_VDPA_GET_CONFIG_SIZE	_IOR(VHOST_VIRTIO, 0x79, __u32)
>   
> -/* Get the count of all virtqueues */
> -#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
> -
> -/* Get the number of virtqueue groups. */
> -#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x81, __u32)
> -
>   /* Get the number of address spaces. */
>   #define VHOST_VDPA_GET_AS_NUM		_IOR(VHOST_VIRTIO, 0x7A, unsigned int)
>   
> @@ -228,10 +222,17 @@
>   #define VHOST_VDPA_GET_VRING_DESC_GROUP	_IOWR(VHOST_VIRTIO, 0x7F,	\
>   					      struct vhost_vring_state)
>   
> +
> +/* Get the count of all virtqueues */
> +#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
> +
> +/* Get the number of virtqueue groups. */
> +#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x81, __u32)
> +
>   /* Get the queue size of a specific virtqueue.
>    * userspace set the vring index in vhost_vring_state.index
>    * kernel set the queue size in vhost_vring_state.num
>    */
> -#define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x80,	\
> +#define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x82,	\
>   					      struct vhost_vring_state)
>   #endif


