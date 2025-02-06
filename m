Return-Path: <kvm+bounces-37457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81D9BA2A3C1
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 10:01:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDA63162F46
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 09:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 517412253F7;
	Thu,  6 Feb 2025 09:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LnwjaH5l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB4215B10D
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 09:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738832498; cv=none; b=jXy4sJ2Z1XD0nweinnY0Su59DZUUKhXuEYq6c7EdnLM0OENi96l8NExcfMj9Ke5zbqyqU9V7yU4vEOe021ghQdNP/tNi1bjwwrlrtfuPyNav8+eBh3VJQdDWT8cJCCCYI78VAFAM3exAF8nknDyo/SQEftqJmaADIyJ9lekTHRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738832498; c=relaxed/simple;
	bh=rMALyY/WIFqAgbBKM3q53b9XJsK7ZRIByn6rqRUhu8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W0s9/ObCPYII2iB+1AecUZfmbkOV1Kq/OpJi6i9rOcxw9q8ACsst6fQ2c5XnN5Szi6xzVt0ATgXl0NTpDAQcBM6bTo3HQDik9/eH0sXupeRouTr2h5jrVCsi3MOkLGM7oqtW6eILeKupEldBxh7cV3H3kjkuD5BWQ3kPwrGf+eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LnwjaH5l; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738832497; x=1770368497;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rMALyY/WIFqAgbBKM3q53b9XJsK7ZRIByn6rqRUhu8w=;
  b=LnwjaH5lvHrklWT/iMDwk3gP53fy7JODwC2A1wyr1/eFeDE40JMFkv+T
   2XazLh1zxyZHzER/8tp+1/cFpmt1jWzQFCcYVabnmkCVPZLoPdDIdn4UR
   btVU2Gd5FRr+/gvtMkHJAVz6wuuqSCIlIDCp7HqRXdlvAuprgN2t2YyB8
   q56UWcIVc10p+CbE36YkvSnVZVcwPkfgvWlzLeH2v0XqPWNlY40cfAVyH
   1jUDQZv6Ui/DI5IrMNvJL+Oyd6am28N4vrSWneV2MSX2IWkPuiamUzndc
   Dl9xhW+QYQVsS316nCm3j9QcyHRotWgX1BCvobAZGaYdSg/NOEDYyPXHC
   g==;
X-CSE-ConnectionGUID: 19qBH3aLRTi4ru8ZP+2sVQ==
X-CSE-MsgGUID: LwX8UdSCR2mU6iwNUAYASw==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="61900825"
X-IronPort-AV: E=Sophos;i="6.13,264,1732608000"; 
   d="scan'208";a="61900825"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 01:01:36 -0800
X-CSE-ConnectionGUID: 2tQmAu0RQlOmzipqpMkvsQ==
X-CSE-MsgGUID: gd5jUwzyRUOwXXjOul4/Xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="148351839"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa001.jf.intel.com with ESMTP; 06 Feb 2025 01:01:33 -0800
Date: Thu, 6 Feb 2025 17:21:01 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v7 RESEND 0/5] i386: Support SMP Cache Topology
Message-ID: <Z6R+/R66Gs2uNBez@intel.com>
References: <20250110145115.1574345-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110145115.1574345-1-zhao1.liu@intel.com>

Hi Paolo,

A kindly ping. (I dropped the cache per thread; do you think this version
is ok?)

Thanks,
Zhao

On Fri, Jan 10, 2025 at 10:51:10PM +0800, Zhao Liu wrote:
> Date: Fri, 10 Jan 2025 22:51:10 +0800
> From: Zhao Liu <zhao1.liu@intel.com>
> Subject: [PATCH v7 RESEND 0/5] i386: Support SMP Cache Topology
> X-Mailer: git-send-email 2.34.1
> 
> Hi folks,
> 
> This is my v7 resend version (updated the commit message of origin
> v7's Patch 1).
> 
> Compared with v6 [1], v7 dropped the "thread" level cache topology
> (cache per thread):
> 
>  - Patch 1 is the new patch to reject "thread" parameter for smp-cache.
>  - Ptach 2 dropped cache per thread support.
>  (Others remain unchanged.)
> 
> There're several reasons:
> 
>  * Currently, neither i386 nor ARM have real hardware support for per-
>    thread cache.
>  * ARM can't support thread level cache in device tree. [2].
> 
> So it is unnecessary to support it at this moment, even though per-
> thread cache might have potential scheduling benefits for VMs without
> CPU affinity.
> 
> In the future, if there is a clear demand for this feature, the correct
> approach would be to add a new control field in MachineClass.smp_props
> and enable it only for the machines that require it.
> 
> 
> This series is based on the master branch at commit aa3a285b5bc5 ("Merge
> tag 'mem-2024-12-21' of https://github.com/davidhildenbrand/qemu into
> staging").
> 
> Smp-cache support of ARM side can be found at [3].
> 
> 
> Background
> ==========
> 
> The x86 and ARM (RISCV) need to allow user to configure cache properties
> (current only topology):
>  * For x86, the default cache topology model (of max/host CPU) does not
>    always match the Host's real physical cache topology. Performance can
>    increase when the configured virtual topology is closer to the
>    physical topology than a default topology would be.
>  * For ARM, QEMU can't get the cache topology information from the CPU
>    registers, then user configuration is necessary. Additionally, the
>    cache information is also needed for MPAM emulation (for TCG) to
>    build the right PPTT. (Originally from Jonathan)
> 
> 
> About smp-cache
> ===============
> 
> The API design has been discussed heavily in [4].
> 
> Now, smp-cache is implemented as a array integrated in -machine. Though
> -machine currently can't support JSON format, this is the one of the
> directions of future.
> 
> An example is as follows:
> 
> smp_cache=smp-cache.0.cache=l1i,smp-cache.0.topology=core,smp-cache.1.cache=l1d,smp-cache.1.topology=core,smp-cache.2.cache=l2,smp-cache.2.topology=module,smp-cache.3.cache=l3,smp-cache.3.topology=die
> 
> "cache" specifies the cache that the properties will be applied on. This
> field is the combination of cache level and cache type. Now it supports
> "l1d" (L1 data cache), "l1i" (L1 instruction cache), "l2" (L2 unified
> cache) and "l3" (L3 unified cache).
> 
> "topology" field accepts CPU topology levels including "core", "module",
> "cluster", "die", "socket", "book", "drawer" and a special value
> "default". (Note, now, in v7, smp-cache doesn't support "thread".)
> 
> The "default" is introduced to make it easier for libvirt to set a
> default parameter value without having to care about the specific
> machine (because currently there is no proper way for machine to
> expose supported topology levels and caches).
> 
> If "default" is set, then the cache topology will follow the
> architecture's default cache topology model. If other CPU topology level
> is set, the cache will be shared at corresponding CPU topology level.
> 
> [1]: Patch v6: https://lore.kernel.org/qemu-devel/20241219083237.265419-1-zhao1.liu@intel.com/
> [2]: Gap of cache per thread for ARM: https://lore.kernel.org/qemu-devel/20250110114100.00002296@huawei.com/T/#m50c37fa5d372feac8e607c279cd446da3e22a12c
> [3]: ARM smp-cache: https://lore.kernel.org/qemu-devel/20250102152012.1049-1-alireza.sanaee@huawei.com/
> [4]: API disscussion: https://lore.kernel.org/qemu-devel/8734ndj33j.fsf@pond.sub.org/
> 
> Thanks and Best Regards,
> Zhao
> ---
> Alireza Sanaee (1):
>   i386/cpu: add has_caches flag to check smp_cache configuration
> 
> Zhao Liu (4):
>   hw/core/machine: Reject thread level cache
>   i386/cpu: Support module level cache topology
>   i386/cpu: Update cache topology with machine's configuration
>   i386/pc: Support cache topology in -machine for PC machine
> 
>  hw/core/machine-smp.c |  9 ++++++
>  hw/i386/pc.c          |  4 +++
>  include/hw/boards.h   |  3 ++
>  qemu-options.hx       | 30 +++++++++++++++++-
>  target/i386/cpu.c     | 71 ++++++++++++++++++++++++++++++++++++++++++-
>  5 files changed, 115 insertions(+), 2 deletions(-)
> 
> -- 
> 2.34.1
> 

