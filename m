Return-Path: <kvm+bounces-21166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC14D92B48D
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 11:57:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 668BD283F32
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 09:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32CC0156220;
	Tue,  9 Jul 2024 09:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OZiJAYbo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC4426AC9
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 09:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720519053; cv=none; b=QD9dSyV3zrXSnbxeJPdIggN2SOipk08NCkbJaAZ9CqYmuzWRhxRPDntwUdeOAuPD4y9fcVLoAnR5kmcZPc7C1bEmkC0uylIoTWjfNB82sdTGFxYVtX2MqAjIOWT/DPM/+1caR9s0G9OTObCOfoviwOQ0ccLW0nYwwzNX9qBYO2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720519053; c=relaxed/simple;
	bh=ql3XWi50DdULpswcLK+rmYBSYuNy0QrKcY67jvFg2+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IL4VU4BVd0OgXu/ZLjuCI8tCQMc8CR8cZVVNemABTp/zWSkhqXIE6hgfCXXK71JOPYvL5vHRR8H37VkJkBnEf9+a6r7fek9EPMkw0zatcq0++btxkP9bj6hxpPqg0ldRJOd91sEThUxhW5aMw406ldSYwlROz6FNS0YZfdMmm9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OZiJAYbo; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720519051; x=1752055051;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ql3XWi50DdULpswcLK+rmYBSYuNy0QrKcY67jvFg2+g=;
  b=OZiJAYbo2V89XKa1Qxzy0w1P166whA8peUCvFycvVYww9nYMOVoroul3
   tCa9I5ilab96TmQt46QMt6oZSnjWUBX5rV7TunCXW0QNdaZL6qB56AFgQ
   JTFtkOaCZjgm5mbsZH/qUSZaDeZ+n8KsZUPoz11m1+T/b8I6CGpdThzw9
   xQZCBjp2cx3ZIcSstCaEauoKBo+k2dwcCG2HhrufuWfub2TldyaPiEEg3
   eBWUHlxyy0ttT4ev3PFu4QZqXQYmdpwy14OZGkL+OQ5TRjGyfIPEb4HKL
   oOpaNVmoh+tYPUVeIpPObWcF0wtAgr6mORcrSsiviGWgu6ujR4na6ESPM
   w==;
X-CSE-ConnectionGUID: 3Q9/U3FrR4yfMeaToifJLQ==
X-CSE-MsgGUID: 1oRQdBOSSoW2h62oqERl9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11127"; a="21630503"
X-IronPort-AV: E=Sophos;i="6.09,194,1716274800"; 
   d="scan'208";a="21630503"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 02:57:30 -0700
X-CSE-ConnectionGUID: ijrOueipQbWj08U6YPj+LA==
X-CSE-MsgGUID: GQMV+uZ1SlynX0EEJuSMAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,194,1716274800"; 
   d="scan'208";a="85349963"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa001.jf.intel.com with ESMTP; 09 Jul 2024 02:57:25 -0700
Date: Tue, 9 Jul 2024 18:13:04 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
Message-ID: <Zo0NMDmYKRVWe9Ht@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
 <20240704031603.1744546-3-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240704031603.1744546-3-zhao1.liu@intel.com>

> diff --git a/hw/core/smp-cache.c b/hw/core/smp-cache.c
> new file mode 100644
> index 000000000000..c0157ce51c8f
> --- /dev/null
> +++ b/hw/core/smp-cache.c
> @@ -0,0 +1,103 @@
> +/*
> + * Cache Object for SMP machine
> + *
> + * Copyright (C) 2024 Intel Corporation.
> + *
> + * Author: Zhao Liu <zhao1.liu@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or
> + * later.  See the COPYING file in the top-level directory.
> + */
> +
> +#include "qemu/osdep.h"
> +
> +#include "hw/core/smp-cache.h"
> +#include "qapi/error.h"
> +#include "qapi/qapi-visit-machine-common.h"
> +#include "qom/object_interfaces.h"
> +
> +static void
> +smp_cache_get_cache_prop(Object *obj, Visitor *v, const char *name,
> +                         void *opaque, Error **errp)
> +{
> +    SMPCache *cache = SMP_CACHE(obj);
> +    SMPCachePropertyList *head = NULL;
> +    SMPCachePropertyList **tail = &head;
> +
> +    for (int i = 0; i < SMP_CACHE__MAX; i++) {
> +        SMPCacheProperty *node = g_new(SMPCacheProperty, 1);
> +
> +        node->name = cache->props[i].name;
> +        node->topo = cache->props[i].topo;
> +        QAPI_LIST_APPEND(tail, node);
> +    }
> +
> +    if (!visit_type_SMPCachePropertyList(v, name, &head, errp)) {
> +        return;

Oops, here I shouldn't return. Whether it succeeds or not, I should
continue with the following free().

> +    }
> +    qapi_free_SMPCachePropertyList(head);
> +}

