Return-Path: <kvm+bounces-23017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05724945AD5
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 11:21:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B375283C44
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 09:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B69C1DAC69;
	Fri,  2 Aug 2024 09:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jD8uaHs4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EC91DAC5F
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 09:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722590481; cv=none; b=j6W/ewrurzWIHzO0jYXfSmm1dgCuj7w0QNgBV4iMfvbxSmoE9miW+rTDXD3M3vak6qfchbapZbb8LWhneUK7k4h/bOvh9q5i2rtpyeenZegjLMfYr5Ea7l8GyQZQ1k5wTL5+rGwGqvQLiizXeQ7Ub3FNsmuGZjnSIXtF7Qz0uCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722590481; c=relaxed/simple;
	bh=7Ylgc3CpS+KKKaRf0YkWoRkezg56OZwlHf9RcSjeBPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JciJbZf80B0nGgHDFfNv7ZdxDpWtRHsvRbBDXmcnPtgaGvUfYiUUI2vGxNzCmfPB/+6o3OEv2JPjrFyA48boyDJ+mTXm3urRY9VVMMzuibZq+ghCamHOZ/ulVkh+lmqdrRw8F7nABqxWZ83tKex8pPOWz8mBddsxMFl0jgytAXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jD8uaHs4; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722590479; x=1754126479;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7Ylgc3CpS+KKKaRf0YkWoRkezg56OZwlHf9RcSjeBPQ=;
  b=jD8uaHs4uXg5vs2ir59wgyXeY7G9WRox+PQY0XlGbjdXAHDcsg+RMrWS
   xFJWiBD3vnjSnegKblM+7OEZsPw0EWXPg8FODa7Ll9AC6Ca4NvlC4pwMs
   leDMUZOnyugd75q8BVK2KYm27uZLqj/398WMhSv6ySRhcSnI1fNdTLtwv
   hUsu0vrkU8suxb3d/so60WAcPFGZ08xyMa/0COYUMAzfXbvA2S3evR0Xm
   9E3RsP4oh1GR8TtANrQ46eaWT055BYcsWAIAbAyIcdn/rMStcpxs1TDrL
   9XluqtkAQOwsHxGFTcMHKeqjJwp70euN75my+gpbbXo0aDXUuMIv5ll4U
   g==;
X-CSE-ConnectionGUID: 2oz9PxUMRnuIsr9T98GPyw==
X-CSE-MsgGUID: R/K9k9NFQk++d6y4qHiRiw==
X-IronPort-AV: E=McAfee;i="6700,10204,11151"; a="31973468"
X-IronPort-AV: E=Sophos;i="6.09,257,1716274800"; 
   d="scan'208";a="31973468"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2024 02:21:19 -0700
X-CSE-ConnectionGUID: HX7qJS+PSha7LUgrRP/K9A==
X-CSE-MsgGUID: tuxTmRO+Rcy99EjBNQzK3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,257,1716274800"; 
   d="scan'208";a="56109681"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 02 Aug 2024 02:21:12 -0700
Date: Fri, 2 Aug 2024 17:37:00 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>, Yuan Yao <yuan.yao@intel.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [RFC 0/5] accel/kvm: Support KVM PMU filter
Message-ID: <ZqyovJZkOjm6HZFv@intel.com>
References: <20240710045117.3164577-1-zhao1.liu@intel.com>
 <b10545d1-8e81-44f0-8e13-eee393ea4d1b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b10545d1-8e81-44f0-8e13-eee393ea4d1b@redhat.com>

Hello Shaoqin,

On Fri, Aug 02, 2024 at 05:01:47PM +0800, Shaoqin Huang wrote:
> Date: Fri, 2 Aug 2024 17:01:47 +0800
> From: Shaoqin Huang <shahuang@redhat.com>
> Subject: Re: [RFC 0/5] accel/kvm: Support KVM PMU filter
> 
> Hi Zhao,
> 
> On 7/10/24 12:51, Zhao Liu wrote:
> > Hi QEMU maintainers, arm and PMU folks,
> > 
> > I picked up Shaoqing's previous work [1] on the KVM PMU filter for arm,
> > and now is trying to support this feature for x86 with a JSON-compatible
> > API.
> > 
> > While arm and x86 use different KVM ioctls to configure the PMU filter,
> > considering they all have similar inputs (PMU event + action), it is
> > still possible to abstract a generic, cross-architecture kvm-pmu-filter
> > object and provide users with a sufficiently generic or near-consistent
> > QAPI interface.
> > 
> > That's what I did in this series, a new kvm-pmu-filter object, with the
> > API like:
> > 
> > -object '{"qom-type":"kvm-pmu-filter","id":"f0","events":[{"action":"allow","format":"raw","code":"0xc4"}]}'
> > 
> > For i386, this object is inserted into kvm accelerator and is extended
> > to support fixed-counter and more formats ("x86-default" and
> > "x86-masked-entry"):
> > 
> > -accel kvm,pmu-filter=f0 \
> > -object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","x86-fixed-counter":{"action":"allow","bitmap":"0x0"},"events":[{"action":"allow","format":"x86-masked-entry","select":"0xc4","mask":"0xff","match":"0","exclude":true},{"action":"allow","format":"x86-masked-entry","select":"0xc5","mask":"0xff","match":"0","exclude":true}]}'
> 
> What if I want to create the PMU Filter on ARM to deny the event range
> [0x5,0x10], and allow deny event 0x13, how should I write the json?
>

Cuurently this doesn't support the event range (since the raw format of
x86 event cannot be said to be continuous).

So with the basic support, we need to configure events one by one:

-object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","events":[{"action":"allow","format":"raw","code":"0x5"},{"action":"allow","format":"raw","select":"0x6"},{"action":"allow","format":"raw","code":"0x7"},{"action":"allow","format":"raw","code":"0x8"},{"action":"allow","format":"raw","code":"0x9"},{"action":"allow","format":"raw","code":"0x10"},{"action":"deny","format":"raw","code":"0x13"}]}'

This one looks a lot more complicated, but in the future, arm could
further support event-range (maybe implement event-range via mask), but
I think this could be arch-specific format since not all architectures'
events are continuous.

Additional, I'm a bit confused by your example, and I hope you can help
me understand that: when configuring 0x5~0x10 to be allow, isn't it true
that all other events are denied by default, so denying 0x13 again is a
redundant operation? What is the default action for all other events
except 0x5~0x10 and 0x13?

If we specify action as allow for 0x5~0x10 and deny for the rest by
default, then there is no need to set an action for each event but only
a global one (as suggested by Dapeng), so the above command line can be
simplified as:

-object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","events":[{"format":"raw","code":"0x5"},{"format":"raw","select":"0x6"},{"format":"raw","code":"0x7"},{"format":"raw","code":"0x8"},{"format":"raw","code":"0x9"},{"format":"raw","code":"0x10"}]}'

Thanks,
Zhao


