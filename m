Return-Path: <kvm+bounces-30281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DBAC9B8C11
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 08:30:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BAD31C21FDC
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 07:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E076155C9A;
	Fri,  1 Nov 2024 07:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IHyeCStH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2912D1547D5
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 07:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730446180; cv=none; b=jLs7WGRZFMHyJ9T1J4lSsq9lJa+yLhzrSrzLdBwLju7n9jrdmTPQO+4dgK3P9Ul64koNMOsiiN/nSAPhEA2IPVc3p7cDjy0cTCa7g/xgoTm4leCqsPr7HksLIvo7LggkW0Fb/s63TqmrNQrkevtJF3eJsO9AVyDNjkH/UK3rnG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730446180; c=relaxed/simple;
	bh=zCzp/PIGXKybGMdD7zEqjUO7m3TWYTbL84DThcBzMAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gfDAq5mK2xHiKQ1YiORVlsI3SoFHTzYBn7fzHmHOJhey4GBZBIlZcptSrnXa8srjM1/LXwBFGtTKJcpxQkG5TirBWSZVTfa1Ceezi9ZKTjU9h/xRYvZNJNMuH/qbEgCAjcygTqCaZzfI0jsBrDUhGeGDDRYGpuJf3DYISV8KYFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IHyeCStH; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730446178; x=1761982178;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zCzp/PIGXKybGMdD7zEqjUO7m3TWYTbL84DThcBzMAc=;
  b=IHyeCStH3MOSCCtL8TGTW1sT9oWQZEboHLq5zPHcP8QbAciLl/ujJLvM
   ARo4bspnG1g/Rr6vsdCnCNbnYegMgiKt5DPC6unL5TYmLNO4eRG26pZrH
   Ft2CTPlQPKCfyS77A1uLp95ANS2lEO5jl6jmkwR1ihSoK5zFjLpR/JyPs
   64FYW1E2oOJNayWff2622HZmZ6VhWtbyYm6tKqVvx+d7BRsJzDcVqSfSQ
   8hfhsmBNaCrlY87v2JVdIrFkWnH4n9Wy9TQPqZOtTXoPcfpgOVMkKfsWJ
   K51mFJ50cE1IZToGACKt32XxpmtIwbdsHtFX8aHXCX6RDQgy1SEj6sg4g
   Q==;
X-CSE-ConnectionGUID: wFp9rUR/SbqlH6ntlkRF9w==
X-CSE-MsgGUID: p36ziF2pTUeqrG4pCApLfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41310655"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41310655"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 00:29:38 -0700
X-CSE-ConnectionGUID: ZWPcl3ReTdugymNGnBrg4Q==
X-CSE-MsgGUID: XL2yI9d/Rymo5iSQ9iMIIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,249,1725346800"; 
   d="scan'208";a="82777507"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 01 Nov 2024 00:29:33 -0700
Date: Fri, 1 Nov 2024 15:47:22 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>
Cc: Daniel P =?utf-8?B?LiBCZXJyYW5n77+9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?utf-8?B?QmVubu+/vWU=?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH v4 2/9] hw/core: Make CPU topology enumeration
 arch-agnostic
Message-ID: <ZySHimCbA3qqmjCB@intel.com>
References: <20241022135151.2052198-1-zhao1.liu@intel.com>
 <20241022135151.2052198-3-zhao1.liu@intel.com>
 <31e8dc51-f70f-44eb-a768-61cfa50eed5b@linaro.org>
 <ZyQ/QJnTPvo9wO+H@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyQ/QJnTPvo9wO+H@intel.com>

On Fri, Nov 01, 2024 at 10:38:56AM +0800, Zhao Liu wrote:
> Date: Fri, 1 Nov 2024 10:38:56 +0800
> From: Zhao Liu <zhao1.liu@intel.com>
> Subject: Re: [PATCH v4 2/9] hw/core: Make CPU topology enumeration
>  arch-agnostic
> 
> Hi Phil,
> 
> > > -static uint32_t cpuid1f_topo_type(enum CPUTopoLevel topo_level)
> > > +static uint32_t cpuid1f_topo_type(enum CpuTopologyLevel topo_level)
> > >   {
> > >       switch (topo_level) {
> > > -    case CPU_TOPO_LEVEL_INVALID:
> > > +    case CPU_TOPOLOGY_LEVEL_INVALID:
> > 
> > Since we use an enum, I'd rather directly use CPU_TOPOLOGY_LEVEL__MAX.
> >
> > Or maybe in this case ...
> > 
> > >           return CPUID_1F_ECX_TOPO_LEVEL_INVALID;
> > > -    case CPU_TOPO_LEVEL_SMT:
> > > +    case CPU_TOPOLOGY_LEVEL_THREAD:
> > >           return CPUID_1F_ECX_TOPO_LEVEL_SMT;
> > > -    case CPU_TOPO_LEVEL_CORE:
> > > +    case CPU_TOPOLOGY_LEVEL_CORE:
> > >           return CPUID_1F_ECX_TOPO_LEVEL_CORE;
> > > -    case CPU_TOPO_LEVEL_MODULE:
> > > +    case CPU_TOPOLOGY_LEVEL_MODULE:
> > >           return CPUID_1F_ECX_TOPO_LEVEL_MODULE;
> > > -    case CPU_TOPO_LEVEL_DIE:
> > > +    case CPU_TOPOLOGY_LEVEL_DIE:
> > >           return CPUID_1F_ECX_TOPO_LEVEL_DIE;
> > >       default:
> >            /* Other types are not supported in QEMU. */
> >            g_assert_not_reached();
> > 
> > ... return CPUID_1F_ECX_TOPO_LEVEL_INVALID as default.
> 
> I prefer the first way you mentioned since I want "default" to keep
> to detact unimplemented levels.
> 
 
Ah, when I started working on it, I realized that clearing
CPU_TOPOLOGY_LEVEL_INVALID would reduce the readability of the
encode_topo_cpuid1f(). The encoding rules for the 0x1f leaf are somewhat
complex, so I want the topology (and names) in encode_topo_cpuid1f() to
be as consistent with the spec as possible. Therefore, I will keep this
name! :)


