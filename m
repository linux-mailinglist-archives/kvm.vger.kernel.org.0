Return-Path: <kvm+bounces-10037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08655868BAF
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:07:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84B18B2886E
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0D7131734;
	Tue, 27 Feb 2024 09:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bpnpKk3f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAFB136658
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 09:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709024811; cv=none; b=M2OLri9kOMgpMalNTFUMuwp7R61vjo9XnSXG4ypExqxmC63+USjF0fsG8Lwx+oJUcrmFbwcrRRj41V4T7TupS+0KOYhjlvgETKr5uOk/HGbQ9Uor8DXZ4k9hkUGh8RdASMH7gEEuNT6u1bVW50XacuzKX+1xDJMTol3XMsXjZh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709024811; c=relaxed/simple;
	bh=/tjKuEbL0I0vIZe6oBP5MOkBmS0O+e/IjNu+fKHM/go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXeK2nHh0EfK74OzRhRr85CLP7ddxLs7I2W/O741pJvaeg9ZHQTUrZP0RXdIDK3yRwJV6SLv5qisqpMRhTC9DQUaOGTicP2mAYROxL+HQODuVmyAn0CtybHte1EKulbPOByK1/QlptKVNBPxoURNoFlQ5r6od697Sx5RMbiLT0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bpnpKk3f; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709024810; x=1740560810;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/tjKuEbL0I0vIZe6oBP5MOkBmS0O+e/IjNu+fKHM/go=;
  b=bpnpKk3fDFLtcB0jvGt+OCme6Ja/3dxjC9Vrm+Vf7CfLSPQVzsDGrvbI
   8UN1/ZqQX+wdx5mIJzCd31NXX5erA2ANX5WnaAScHNNEfeZCOlwf36QFu
   zRKhLzrWL16kHBEiYEjzNXVfuqnujGPxoqMejqXx0qVnPkjDYhLJbVhZz
   eYUOP9+JB9cQZv9Zuw35SS46DwEH1MHvjX1StDAKs9gyYGw58M8fajiJ8
   keaT14gldG/3oPFnXUwilDaVh9SQTq9nGKoFcRohvdBOicFCVfunKM2gA
   esBFFo9OftiIMBB4UVVmN4ekZ201jqHdokhkAcB4oKK4iU3v6aTNaXT+U
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="25818612"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="25818612"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 01:06:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6839753"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa007.fm.intel.com with ESMTP; 27 Feb 2024 01:06:42 -0800
Date: Tue, 27 Feb 2024 17:20:25 +0800
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
Message-ID: <Zd2pWVH4/eo3HM8j@intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
 <20240220092504.726064-5-zhao1.liu@linux.intel.com>
 <20240226153947.00006fd6@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226153947.00006fd6@Huawei.com>

Hi Jonathan,

> Hi Zhao Liu
> 
> I like the scheme.  Strikes a good balance between complexity of description
> and systems that actually exist. Sure there are systems with more cache
> levels etc but they are rare and support can be easily added later
> if people want to model them.

Thanks for your support!

[snip]

> > +static int smp_cache_string_to_topology(MachineState *ms,
> 
> Not a good name for a function that does rather more than that.

What about "smp_cache_get_valid_topology()"?

> 
> > +                                        char *topo_str,
> > +                                        CPUTopoLevel *topo,
> > +                                        Error **errp)
> > +{
> > +    *topo = string_to_cpu_topo(topo_str);
> > +
> > +    if (*topo == CPU_TOPO_LEVEL_MAX || *topo == CPU_TOPO_LEVEL_INVALID) {
> > +        error_setg(errp, "Invalid cache topology level: %s. The cache "
> > +                   "topology should match the CPU topology level", topo_str);
> > +        return -1;
> > +    }
> > +
> > +    if (!machine_check_topo_support(ms, *topo)) {
> > +        error_setg(errp, "Invalid cache topology level: %s. The topology "
> > +                   "level is not supported by this machine", topo_str);
> > +        return -1;
> > +    }
> > +
> > +    return 0;
> > +}
> > +
> > +static void machine_parse_smp_cache_config(MachineState *ms,
> > +                                           const SMPConfiguration *config,
> > +                                           Error **errp)
> > +{
> > +    MachineClass *mc = MACHINE_GET_CLASS(ms);
> > +
> > +    if (config->l1d_cache) {
> > +        if (!mc->smp_props.l1_separated_cache_supported) {
> > +            error_setg(errp, "L1 D-cache topology not "
> > +                       "supported by this machine");
> > +            return;
> > +        }
> > +
> > +        if (smp_cache_string_to_topology(ms, config->l1d_cache,
> > +            &ms->smp_cache.l1d, errp)) {
> 
> Indent is to wrong opening bracket.
> Same for other cases.

Could you please educate me about the correct style here?
I'm unsure if it should be indented by 4 spaces.

Thanks,
Zhao


