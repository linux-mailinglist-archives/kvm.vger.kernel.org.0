Return-Path: <kvm+bounces-29121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EBD29A3285
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 04:20:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04C71B22ABD
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 02:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30141465B8;
	Fri, 18 Oct 2024 02:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HnZrumzD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06D545948
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 02:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729218024; cv=none; b=fWUbRvsalN82MZN5fr+66AleJOonDhUg6vyHPyn5FuA8YnwE1gGzxsL3ro/EI6aU9J/MIpfdpFmA352NJjHocdsF5QpUPZ8JH5s3mh00LIvLODoPC76NOKnnqWDyb1Nf6f+pbgdKUM1TszecHXbIPnIs5CCmj7/iIGQ/eoo1jXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729218024; c=relaxed/simple;
	bh=8PKsoPgR4Ld+C0xF/qZFXE3weaPnEMpOVlDjd59wIDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A84itesz6ePa0rC/9G4ueAU9Lb7jvUS/Yq0nkVMw9J+v+JdpqU5vbS5lj99iA2IH9F0NHBkrP3MH9N5aKNCxrTdXD4LLRoSKPSwBXDXx938+965aU+PLW2l7NpN3FkOIMxC52sxyVTZUSAG2//jsjwWRAxwZmjNCTrpWQjVYLhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HnZrumzD; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729218023; x=1760754023;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8PKsoPgR4Ld+C0xF/qZFXE3weaPnEMpOVlDjd59wIDw=;
  b=HnZrumzDVRHBa7Reqx6vPkQKuFm/GKVqDzpiucwhTiTxMWNLBzru6AHQ
   6R6bJy4GCHuOTImvC6Eg4XS8fapmpLLUyavJZlbuNn8vYsyXXs3u1iM/C
   38j6fUfcG856VG9LTQGAZltCFEbFcbV6wZ/nrWOy2Arh2av+svAal1FUq
   ArtyHzxSaLOMGZf7twSUMor+uR9Ny1yOCZPOlzEnU9Ad2Yka1C3+luEZJ
   oRIaDu3BZE2dD+dhuoq6acH2R49qNWMo1E3nKfgvzfBa4Sa7MBX0ZYheD
   uKoG/Hlx7vPTPLjdsefCdrZWwm8Te50PMKlQ0AA6P8vkrZDxKNsd6jOlu
   A==;
X-CSE-ConnectionGUID: 8AbT/fHZRrm/ZSdNTNnuhA==
X-CSE-MsgGUID: g3kOMbUpSJa4t/vvcxRnUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11228"; a="28827905"
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="28827905"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 19:20:22 -0700
X-CSE-ConnectionGUID: L+YNHYlyR+6QwKMonGQkjw==
X-CSE-MsgGUID: GChpiH98T9WKlXP4N1D6Sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="83557602"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa003.jf.intel.com with ESMTP; 17 Oct 2024 19:20:14 -0700
Date: Fri, 18 Oct 2024 10:36:30 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
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
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v3 1/7] hw/core: Make CPU topology enumeration
 arch-agnostic
Message-ID: <ZxHJri+rgdGKf/0L@intel.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
 <20241012104429.1048908-2-zhao1.liu@intel.com>
 <ZxEte1KBwWuCdkb1@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxEte1KBwWuCdkb1@redhat.com>

Hi Daniel,

> > -/*
> > - * CPUTopoLevel is the general i386 topology hierarchical representation,
> > - * ordered by increasing hierarchical relationship.
> > - * Its enumeration value is not bound to the type value of Intel (CPUID[0x1F])
> > - * or AMD (CPUID[0x80000026]).
> > - */
> > -enum CPUTopoLevel {
> > -    CPU_TOPO_LEVEL_INVALID,
> > -    CPU_TOPO_LEVEL_SMT,
> > -    CPU_TOPO_LEVEL_CORE,
> > -    CPU_TOPO_LEVEL_MODULE,
> > -    CPU_TOPO_LEVEL_DIE,
> > -    CPU_TOPO_LEVEL_PACKAGE,
> > -    CPU_TOPO_LEVEL_MAX,
> > -};
> > -
> 
> snip
> 
> > @@ -18,3 +18,47 @@
> >  ##
> >  { 'enum': 'S390CpuEntitlement',
> >    'data': [ 'auto', 'low', 'medium', 'high' ] }
> > +
> > +##
> > +# @CpuTopologyLevel:
> > +#
> > +# An enumeration of CPU topology levels.
> > +#
> > +# @invalid: Invalid topology level.
> 
> Previously all topology levels were internal to QEMU, and IIUC
> this CPU_TOPO_LEVEL_INVALID appears to have been a special
> value to indicate  the cache was absent ?

Now I haven't support this logic.
x86 CPU has a "l3-cache" property, and maybe that property can be
implemented or replaced by the "invalid" level support you mentioned.

> Now we're exposing this directly to the user as a settable
> option. We need to explain what effect setting 'invalid'
> has on the CPU cache config.

If user set "invalid", QEMU will report the error message:

qemu-system-x86_64: Invalid cache topology level: invalid. The topology should match valid CPU topology level

Do you think this error message is sufficient?

Thanks,
Zhao


