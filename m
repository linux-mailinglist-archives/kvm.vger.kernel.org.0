Return-Path: <kvm+bounces-10097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9BEF869AA9
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 16:42:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 723461F2492D
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 15:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A965C145FF8;
	Tue, 27 Feb 2024 15:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NlctizNb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599AF14532C
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 15:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709048533; cv=none; b=dLotPEVJZdRShwbhumK77htHJV1aCVgGgXObJ9lSLl0bz/QFtZlmv9tLUW8lmjElnMkPFnGdTuSfCkBRe9AhhBVt13U4CCkOt72Irjfv89Mmxi3cz857DYXWIMQcadvnpD/FBiqU+kzogTqy5n6zpBvqqXojFAjjY/sQtyMEPKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709048533; c=relaxed/simple;
	bh=PpopX1xgqsSGu+ibkHdRkgrvQaMYRWvsytFX1WWOZtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKNXIAFouI7VZIQRwrEmltPXP0kZ5uc0O+o7M5WceKTtnaISFSaT91wTHmDVDvMHBr8UE6akbtP2pEpvGhuRrdWIlZUSU4OHn62vUjNPYv728stu5ypNuObJVLr8Avw4Q5MUkpctGVDok4O5irTAxVW6wV7YCE+aOPkgSdtTnxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NlctizNb; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709048533; x=1740584533;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PpopX1xgqsSGu+ibkHdRkgrvQaMYRWvsytFX1WWOZtI=;
  b=NlctizNbh0TM2EooCxcI5xF0yKTbKWJJW5J9AbznCwNHFn0c9lMbj8Ko
   97r3HzCaXVG41xAqgZbTTrfpKSFaHzsqQVtgNRaC90PFkyYhU7e/8ZWTY
   8E57qndJaBRRVCAv6dW+Aet/HXWjH1N8WHNZxmpal4wxj78DS5zKdxWb9
   D8t9p3386nF86A2CkBZKQ/6oAlLThCdmnIkR1BvdMJFiI8g5FSUpJB49S
   zB+LsO129DG5nKi/tjx3AVfDdVw+yeFQ2i3+cfuc5rcp/aGVsffN3K8a9
   +rP7ORbm2W/WRAf3aDWaX4D1XeL3Y7zYH/+S+N1+F2nH8dULZF4kW8ZkP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3513682"
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="3513682"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 07:42:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="11697786"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 27 Feb 2024 07:42:04 -0800
Date: Tue, 27 Feb 2024 23:55:46 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Daniel P =?utf-8?B?LiBCZXJyYW5n77+9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?utf-8?B?QmVubu+/vWU=?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC 4/8] hw/core: Add cache topology options in -smp
Message-ID: <Zd4GAhwpw/w0QUth@intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
 <20240220092504.726064-5-zhao1.liu@linux.intel.com>
 <20240226153947.00006fd6@Huawei.com>
 <Zd2pWVH4/eo3HM8j@intel.com>
 <20240227105145.0000106d@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227105145.0000106d@Huawei.com>

On Tue, Feb 27, 2024 at 10:51:45AM +0000, Jonathan Cameron wrote:
> Date: Tue, 27 Feb 2024 10:51:45 +0000
> From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Subject: Re: [RFC 4/8] hw/core: Add cache topology options in -smp
> X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
> 
> On Tue, 27 Feb 2024 17:20:25 +0800
> Zhao Liu <zhao1.liu@linux.intel.com> wrote:
> 
> > Hi Jonathan,
> > 
> > > Hi Zhao Liu
> > > 
> > > I like the scheme.  Strikes a good balance between complexity of description
> > > and systems that actually exist. Sure there are systems with more cache
> > > levels etc but they are rare and support can be easily added later
> > > if people want to model them.  
> > 
> > Thanks for your support!
> > 
> > [snip]
> > 
> > > > +static int smp_cache_string_to_topology(MachineState *ms,  
> > > 
> > > Not a good name for a function that does rather more than that.  
> > 
> > What about "smp_cache_get_valid_topology()"?
> 
> Looking again, could we return the CPUTopoLevel? I think returning
> CPU_TOPO_LEVEL_INVALID will replace -1/0 returns and this can just
> be smp_cache_string_to_topology() as you have it in this version.
> 
> The check on the return value becomes a little more more complex
> and I think you want to squash CPU_TOPO_LEVEL_MAX down so we only
> have one invalid value to check at callers..  E.g.
> 
> static CPUTopoLevel smp_cache_string_to_topolgy(MachineState *ms,
>                                                 char *top_str,
>                                                 Error **errp)
> {
>     CPUTopoLevel topo = string_to_cpu_topo(topo_str);
> 
>     if (topo == CPU_TOPO_LEVEL_MAX || topo == CPU_TOP?O_LEVEL_INVALID) {
>         return CPU_TOPO_LEVEL_INVALID;
>     }
> 
>     if (!machine_check_topo_support(ms, topo) {
>         error_setg(errp,
>                    "Invalid cache topology level: %s. "
>                    "The cache topology should match the CPU topology level",
> //Break string like this to make it as grep-able as possible!
>                    topo_str);
>         return CPU_TOPO_LEVEL_INVALID;
>     }
> 
>     return topo;
> 
> }                
> 
> 
> The checks then become != CPU_TOPO_LEVEL_INVALID at each callsite.
>

Good idea! This makes the code clearer. Let me try this way. Thanks!


