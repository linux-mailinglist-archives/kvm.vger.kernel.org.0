Return-Path: <kvm+bounces-21920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D5D937488
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 09:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 353861F215F0
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 07:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7155820E;
	Fri, 19 Jul 2024 07:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GHUPYltO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071A71A269
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 07:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721375417; cv=none; b=Ie9QEpCTuLxUrO/ET1XvugmyoSBL6fPm3NPJ5Y8QO4LJPx/2zkmMoOCOX5S/76avNxoDo3wGWvlHYkrcNQoNLQcIAaDT3iiUW84jG5csn2sDavw4bBHxY04lGpaYgIvcclmJbCNJF9qU3F2jJ343SqO2HvdQcQEwnhw6rwMRsTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721375417; c=relaxed/simple;
	bh=3/vbqqtnyoZjZHVhP0NSLivHQVdRUyM0SUlkoxVrgT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hrJvd+VZknO2y4X5Xk0VPsdvbt/MebgHZxYRQZqHYvCBorOxYnvIosgenesz4OXTZ4jVCq9UPySeSIgYljatbjPCQt2fBb/XtzG6eWoOXRlUcFMB7bzJrM8/7tKbQXZWqf/E3oHMyKKGOt1MUqT6mZDh8XJrYGNu1GlfrpvxXUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GHUPYltO; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721375415; x=1752911415;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=3/vbqqtnyoZjZHVhP0NSLivHQVdRUyM0SUlkoxVrgT4=;
  b=GHUPYltO+kimD4muFrA7t5NruqYqa7LCub13o6sDBYjgoL1fkJ3iR+xf
   DWuSVB9ZOG9E5ozjEvI1U9nuZ1MW2oT2MOuF4rbYUPpMGcvoIG06nG3iB
   kEgNeU2JYUeO7kHr4RTtDsf7r+IQ/qjcRqFXOcvu+u6ducSM1cFzUC7Rd
   s+ZTn3t+mZ1HGU4TSQnQ9e6i0mGQ8ZRbCRrXKPlIZenHc5nc7n60lrH4p
   tIs9zo7h6MhSKVFPAtruWVU2+BNiE01Bd+PpyHH5IlNa68usE6s3YT4Vy
   /czKCXvox+JqUnh3L1JBFuEeRpRVhsd/S8yoDmrcP+D0sXXdQ79cR1YP6
   g==;
X-CSE-ConnectionGUID: NxILkGRzSUaNWNWVhX/Rig==
X-CSE-MsgGUID: a9JoOoOJS8eH0t/adRMHHA==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="36411621"
X-IronPort-AV: E=Sophos;i="6.09,220,1716274800"; 
   d="scan'208";a="36411621"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2024 00:50:13 -0700
X-CSE-ConnectionGUID: a9Pt3gQlTYCuAXzoAN+kdg==
X-CSE-MsgGUID: TI4hGxCyRC63/xeKPE3m2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,220,1716274800"; 
   d="scan'208";a="51632627"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 19 Jul 2024 00:50:07 -0700
Date: Fri, 19 Jul 2024 16:05:50 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
	Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eauger@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>, Yuan Yao <yuan.yao@intel.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Jim Mattson <jmattson@google.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC 0/5] accel/kvm: Support KVM PMU filter
Message-ID: <ZpoeXq+p+m7TMnw7@intel.com>
References: <20240710045117.3164577-1-zhao1.liu@intel.com>
 <738c5474-a568-4a48-8c8e-b0f11b17a187@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <738c5474-a568-4a48-8c8e-b0f11b17a187@linux.intel.com>

Also ping Shaoqin and Eric,

Hopefully I can get your input on interface design to align with the
Arm requirements together!


On Thu, Jul 18, 2024 at 01:27:48PM +0800, Mi, Dapeng wrote:
> Date: Thu, 18 Jul 2024 13:27:48 +0800
> From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
> Subject: Re: [RFC 0/5] accel/kvm: Support KVM PMU filter
> 
> 
> On 7/10/2024 12:51 PM, Zhao Liu wrote:
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
> 
> I'm not sure why the action is defined to event scope instead of the entire
> filter scope. At least for x86 arch, the action is defined to filter scope
> in KVM. Do other archs support event scope's action? If the action can be
> defined to filter scope, the code could be simplified much.

Yeah, that's fine for x86.

@Shaoqin, hi Shaoqin, if I use a global action for all events, is this
Okay for Arm?

I suppose this should work, since the interface here needs to enumerate
events one by one, and doesn't support a continuous enumeration format
(0x0-0x3) like the previous implementation. Right?

> >
> > For i386, this object is inserted into kvm accelerator and is extended
> > to support fixed-counter and more formats ("x86-default" and
> > "x86-masked-entry"):
> >
> > -accel kvm,pmu-filter=f0 \
> > -object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","x86-fixed-counter":{"action":"allow","bitmap":"0x0"},"events":[{"action":"allow","format":"x86-masked-entry","select":"0xc4","mask":"0xff","match":"0","exclude":true},{"action":"allow","format":"x86-masked-entry","select":"0xc5","mask":"0xff","match":"0","exclude":true}]}'
> >
> > This object can still be added as the property to the arch CPU if it is
> > desired as a per CPU feature (as Shaoqin did for arm before).
> >
> > Welcome your feedback and comments!
> >
> >
> > Introduction
> > ============
> >
> >
> > Formats supported in kvm-pmu-filter
> > -----------------------------------
> >
> > This series supports 3 formats:
> >
> > * raw format (general format).
> >
> >   This format indicates the code that has been encoded to be able to
> >   index the PMU events, and which can be delivered directly to the KVM
> >   ioctl. For arm, this means the event code, and for i386, this means
> >   the raw event with the layout like:
> >
> >       select high bit | umask | select low bits
> >
> > * x86-default format (i386 specific)
> >
> >   x86 commonly uses select&umask to identify PMU events, and this format
> >   is used to support the select&umask. Then QEMU will encode select and
> >   umask into a raw format code.
> >
> > * x86-masked-entry (i386 specific)
> >
> >   This is a special format that x86's KVM_SET_PMU_EVENT_FILTER supports.
> >
> >
> > Hexadecimal value string
> > ------------------------
> >
> > In practice, the values associated with PMU events (code for arm, select&
> > umask for x86) are often expressed in hexadecimal. Further, from linux
> > perf related information (tools/perf/pmu-events/arch/*/*/*.json), x86/
> > arm64/riscv/nds32/powerpc all prefer the hexadecimal numbers and only
> > s390 uses decimal value.
> >
> > Therefore, it is necessary to support hexadecimal in order to honor PMU
> > conventions.
> >
> > However, unfortunately, standard JSON (RFC 8259) does not support
> > hexadecimal numbers. So I can only consider using the numeric string in
> > the QAPI and then parsing it to a number.
> >
> > To achieve this, I defined two versions of PMU-related structures in
> > kvm.json:
> >  * a native version that accepts numeric values, which is used for
> >    QEMU's internal code processing,
> >
> >  * and a variant version that accepts numeric string, which is used to
> >    receive user input.
> >
> > kvm-pmu-filter object will take care of converting the string version
> > of the event/counter information into the numeric version.
> >
> > The related implementation can be found in patch 1.
> >
> >
> > CPU property v.s. KVM property
> > ------------------------------
> >
> > In Shaoqin's previous implementation [1], KVM PMU filter is made as a
> > arm CPU property. This is because arm uses a per CPU ioctl
> > (KVM_SET_DEVICE_ATTR) to configure KVM PMU filter.
> >
> > However, for x86, the dependent ioctl (KVM_SET_PMU_EVENT_FILTER) is per
> > VM. In the meantime, considering that for hybrid architecture, maybe in
> > the future there will be a new per vCPU ioctl, or there will be
> > practices to support filter fixed counter by configuring CPUIDs.
> >
> > Based on the above thoughts, for x86, it is not appropriate to make the
> > current per-VM ioctl-based PMU filter a CPU property. Instead, I make it
> > a kvm property and configure it via "-accel kvm,pmu-filter=obj_id".
> >
> > So in summary, it is feasible to use the KVM PMU filter as either a CPU
> > or a KVM property, depending on whether it is used as a CPU feature or a
> > VM feature.
> >
> > The kvm-pmu-filter object, as an abstraction, is general enough to
> > support filter configurations for different scopes (per-CPU or per-VM).
> 
> Per my understanding, the cpus sharing same uarch should share same perf
> events filter. Not sure if there is real requirement to support different
> filters on the CPUs with same arch.
 
The main consideration here is also to align with the underlying ioctl
of the PMU filter, Arm's ioctl is per vCPU and I'm not sure if there
will be a difference between CPUs in the feature.

But this I think could be an arch-specific implementation, x86 needs per
VM then use ¡°-accel kvm,pmu-filter=obj_id¡±, Arm if it does need per vCPU
then it can be set for Arm CPUs via ¡°-cpu host,pmu-filter=obj_id¡±. So
the generic part is this kvm-pmu-filter object itself, where exactly it
should be placed/inserted can be decided by the architecture itself.

Hi @Eric and @Shaoqin, do you agree?


Best Regards,
Zhao


