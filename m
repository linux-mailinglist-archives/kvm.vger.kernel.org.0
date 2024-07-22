Return-Path: <kvm+bounces-22032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50B049389ED
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 09:18:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 750C41C20B19
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 07:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21D8E1B977;
	Mon, 22 Jul 2024 07:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kDg3kfSn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772441803D
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 07:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721632688; cv=none; b=LPxguVUuuTqGkvvyczaDSVW+RE2ft1IdCWOd1tWLJGvaGp9xyu3tz6ukOq7fCnrJNwipWgI9/y/2k7AYhOd/2MApGz/GkCVeN3FOLX7QbqdV/uqVdmdk3pi2AC0JKWIDOS4Dscqz4v0hn+NZt7FJSqZA1pM0BD3eeRauzjlHwmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721632688; c=relaxed/simple;
	bh=PWz4Ht0qlbweAS5o60cJFbGqE0cijiCuaXDbGXRSJ3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J0SLHVIyKAPnGE6FMaBXwC1lpz55pK8yf6y6hKgiAqvZ35fBghn5OJdwO4WYRMm1gC04iS6OrWOOqyr4+I/ljokvmZB5oMvqHaqE57zl6FvGtc+iHERG4CnA2pgy3VaQXnbSWdTw2ISJfiWD7fMF2KRjtxn9w5CkbCQO+dRECy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kDg3kfSn; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721632686; x=1753168686;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=PWz4Ht0qlbweAS5o60cJFbGqE0cijiCuaXDbGXRSJ3Q=;
  b=kDg3kfSn+VTRejVyKVOD9+Eh4gbIzwrVTAw2kWLlmdTIUhq09ffZRnmx
   1MvKaip/KqgIYCvKZOr78dR7z6TO3FGhnsYioRHTUkDrISI0h3lyXCJEC
   HEOj0AupncgrOXTsg6qgSItUPgp59Y7Uosg++UNglNdbEbGFFZMFwLXri
   ++wbp7/zpyWd9tQOoZlBxMWaS9Wq5Tr77v4LU5S2fz+nx8WV1x2ZUXHmd
   bq42FdDgyoAEucSkY1FAL6eulf/fvuhts6AyqLjcX1LP8pZbg14Rtrjvt
   07I4A9YZcZ3DbPOnm+JWgn6yLeHb2Axy4DB8IDxZ4Ri7YMovnTObfm49J
   w==;
X-CSE-ConnectionGUID: KdKM9nETQqOK5F1HytLokQ==
X-CSE-MsgGUID: uWHF3TO0S/yh3uGaxoZ/Vg==
X-IronPort-AV: E=McAfee;i="6700,10204,11140"; a="29843694"
X-IronPort-AV: E=Sophos;i="6.09,227,1716274800"; 
   d="scan'208";a="29843694"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2024 00:17:59 -0700
X-CSE-ConnectionGUID: S294LoMoTdKgKC7BnmarJQ==
X-CSE-MsgGUID: cpwVM0ovRbS97rMy+BQXAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,227,1716274800"; 
   d="scan'208";a="56350156"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 22 Jul 2024 00:17:53 -0700
Date: Mon, 22 Jul 2024 15:33:37 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Zhao Liu <zhao1.liu@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH 0/8] Introduce SMP Cache Topology
Message-ID: <Zp4LUSXlwXqI880x@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240704031603.1744546-1-zhao1.liu@intel.com>

Hi Daniel and Markus,

A gentle ping. Would you kindly have a look at this version of the API
design? If it could meet your satisfaction, I¡¯ll continue iterating.

Thanks,
Zhao

On Thu, Jul 04, 2024 at 11:15:55AM +0800, Zhao Liu wrote:
> Date: Thu, 4 Jul 2024 11:15:55 +0800
> From: Zhao Liu <zhao1.liu@intel.com>
> Subject: [PATCH 0/8] Introduce SMP Cache Topology
> X-Mailer: git-send-email 2.34.1
> 
> Hi all,
> 
> Since the previous RFC v2, I've reimplemented smp-cache object based on
> Daniel's comment (thanks Daniel!), which is both flexible to support
> current cache topology requirements and extensible.
> 
> So, I officially convert the RFC to PATCH.
> 
> Background on smp cache topology can be found in the previous RFC v2
> cover letter:
> 
> https://lore.kernel.org/qemu-devel/20240530101539.768484-1-zhao1.liu@intel.com/
> 
> The following content focuses on this series implementation of the
> smp-cache object.
> 
> 
> About smp-cache
> ===============
> 
> In fact, the smp-cache object introduced in this series is a bit
> different from Daniel's original suggestion. Instead of being integrated
> into -smp, it is created explicitly via -object, and the smp-cache
> property is added to -machine to link to this object.
> 
> An example is as follows:
> 
> -object '{"qom-type":"smp-cache","id":"cache0","caches":[{"name":"l1d","topo":"core"},{"name":"l1i","topo":"core"},{"name":"l2","topo":"module"},{"name":"l3","topo":"socket"}]}'
> -machine smp-cache=cache0
> 
> 
> Such the design change is based on the following 2 reasons:
>  * Defining the cache with a JSON list is very extensible and can
>    support more cache properties.
> 
>  * But -smp, as the sugar of machine property "smp", is based on keyval
>    format, and doesn't support options with JSON format. Thus it's not
>    possible to add a JSON format based option to -smp/-machine for now.
> 
> So, I decoupled the creation of the smp-cache object from the -machine
> to make both -machine and -object happy!
> 
> 
> Welcome your feedback!
> 
> 
> Thanks and Best Regards,
> Zhao
> ---
> Changelog:
> 
> Main changes since RFC v2:
>  * Dropped cpu-topology.h and cpu-topology.c since QAPI has the helper
>    (CpuTopologyLevel_str) to convert enum to string. (Markus)
>  * Fixed text format in machine.json (CpuTopologyLevel naming, 2 spaces
>    between sentences). (Markus)
>  * Added a new level "default" to de-compatibilize some arch-specific
>    topo settings. (Daniel)
>  * Moved CpuTopologyLevel to qapi/machine-common.json, at where the
>    cache enumeration and smp-cache object would be added.
>    - If smp-cache object is defined in qapi/machine.json, storage-daemon
>      will complain about the qmp cmds in qapi/machine.json during
>      compiling.
>  * Referred to Daniel's suggestion to introduce cache JSON list, though
>    as a standalone object since -smp/-machine can't support JSON.
>  * Linked machine's smp_cache to smp-cache object instead of a builtin
>    structure. This is to get around the fact that the keyval format of
>    -machine can't support JSON.
>  * Wrapped the cache topology level access into a helper.
>  * Split as a separate commit to just include compatibility checking and
>    topology checking.
>  * Allow setting "default" topology level even though the cache
>    isn't supported by machine. (Daniel)
>  * Rewrote the document of smp-cache object.
> 
> Main changes since RFC v1:
>  * Split CpuTopology renaimg out of this RFC.
>  * Use QAPI to enumerate CPU topology levels.
>  * Drop string_to_cpu_topo() since QAPI will help to parse the topo
>    levels.
>  * Set has_*_cache field in machine_get_smp(). (JeeHeng)
>  * Use "*_cache=topo_level" as -smp example as the original "level"
>    term for a cache has a totally different meaning. (Jonathan)
> ---
> Zhao Liu (8):
>   hw/core: Make CPU topology enumeration arch-agnostic
>   qapi/qom: Introduce smp-cache object
>   hw/core: Add smp cache topology for machine
>   hw/core: Check smp cache topology support for machine
>   i386/cpu: Support thread and module level cache topology
>   i386/cpu: Update cache topology with machine's configuration
>   i386/pc: Support cache topology in -machine for PC machine
>   qemu-options: Add the description of smp-cache object
> 
>  MAINTAINERS                 |   2 +
>  hw/core/machine-smp.c       |  86 ++++++++++++++++++++++++++++++
>  hw/core/machine.c           |  22 ++++++++
>  hw/core/meson.build         |   1 +
>  hw/core/smp-cache.c         | 103 ++++++++++++++++++++++++++++++++++++
>  hw/i386/pc.c                |   4 ++
>  include/hw/boards.h         |  11 +++-
>  include/hw/core/smp-cache.h |  27 ++++++++++
>  include/hw/i386/topology.h  |  18 +------
>  qapi/machine-common.json    |  97 ++++++++++++++++++++++++++++++++-
>  qapi/qapi-schema.json       |   4 +-
>  qapi/qom.json               |   3 ++
>  qemu-options.hx             |  58 ++++++++++++++++++++
>  target/i386/cpu.c           |  83 +++++++++++++++++++++--------
>  target/i386/cpu.h           |   4 +-
>  15 files changed, 478 insertions(+), 45 deletions(-)
>  create mode 100644 hw/core/smp-cache.c
>  create mode 100644 include/hw/core/smp-cache.h
> 
> -- 
> 2.34.1
> 

