Return-Path: <kvm+bounces-29155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFBCD9A38F9
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 10:45:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07DB6B21CB0
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 08:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C60C18892F;
	Fri, 18 Oct 2024 08:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jx8exFWA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16B21898FC
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 08:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729241129; cv=none; b=tvh8MQocBFf2xQu0Cqv6t64R0/cKovZVx0boFyMO1hl+Zu+Tj8WpOT6csRpllHcs2aG3cSzy6CnQgJxZ60h8yaJEVwozjlmDDppO27DakkEDswklkMxzuePBD0htZUo1G3T7RCOaNTn0bwsyh/KTYUF1eGI4dKI7e3qmNa/zczs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729241129; c=relaxed/simple;
	bh=1hzdX0SAedJp2ZbWcaKLwBlRgfiMbk9wET1obgyYSH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWl8F+iwoJzYJJu3aPdddjNwQ8f+zEBjDOTb2awv9UYnIcIIm4L8aHWjTQ/P2ig8gbFR2og8ZHunD005fyppGMBzsqmLnpMqbyZ5MPSVXNIjMdH80qE5/lBGKUU5Z0IQEbeJ+5UODGZlsg+IWpeZAF7qQQL6nV3NE3z+jTcM8R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jx8exFWA; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729241127; x=1760777127;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=1hzdX0SAedJp2ZbWcaKLwBlRgfiMbk9wET1obgyYSH0=;
  b=Jx8exFWA5KjXbG9CIppud8mW+LbzIYWS7IcpBqI3TNEQaRlVGEDIlSdz
   ZsNz6EeJTXNUDXHYfPSwPT4v3lWr0GJTAcx8Nafaxr7KuuJvy+p7rB/z8
   zIpUdoFuNCvF6H9PCwSzztosq+xvHE1CHkQc9vNGe48TE0RevF47aSLYM
   5/69MQIlw4AajPOKvdegRez0g8KSh5s2785wvArP/a9QsrdKKSXl9PpMf
   7QQU/za2G7iMaMgM3taVbbnReIowL7R4gzmm0cjPSXKraotQYqZbaA2XI
   +L88f6uvmYHev5gPXu8qRvl4+XU8dClDAWACZSvmxGdnfMYfGXtAObx1Y
   g==;
X-CSE-ConnectionGUID: n+2t/yYjRf66Z+Zz9mI58w==
X-CSE-MsgGUID: lptJnQk7TIaNys1zvTHAsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="39305838"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="39305838"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2024 01:45:26 -0700
X-CSE-ConnectionGUID: BIYrmkbwQmuSAshnFlJ3Ug==
X-CSE-MsgGUID: vn3Ep1RJQbukF0MCtS2swQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,213,1725346800"; 
   d="scan'208";a="102105402"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa002.fm.intel.com with ESMTP; 18 Oct 2024 01:45:21 -0700
Date: Fri, 18 Oct 2024 17:01:36 +0800
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
Message-ID: <ZxIj8CWZd7u+cysK@intel.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
 <20241012104429.1048908-2-zhao1.liu@intel.com>
 <ZxEte1KBwWuCdkb1@redhat.com>
 <ZxHJri+rgdGKf/0L@intel.com>
 <ZxIUd9tMi9o1UVOS@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZxIUd9tMi9o1UVOS@redhat.com>

On Fri, Oct 18, 2024 at 08:55:35AM +0100, Daniel P. Berrangé wrote:
> Date: Fri, 18 Oct 2024 08:55:35 +0100
> From: "Daniel P. Berrangé" <berrange@redhat.com>
> Subject: Re: [PATCH v3 1/7] hw/core: Make CPU topology enumeration
>  arch-agnostic
> 
> On Fri, Oct 18, 2024 at 10:36:30AM +0800, Zhao Liu wrote:
> > Hi Daniel,
> > 
> > > > -/*
> > > > - * CPUTopoLevel is the general i386 topology hierarchical representation,
> > > > - * ordered by increasing hierarchical relationship.
> > > > - * Its enumeration value is not bound to the type value of Intel (CPUID[0x1F])
> > > > - * or AMD (CPUID[0x80000026]).
> > > > - */
> > > > -enum CPUTopoLevel {
> > > > -    CPU_TOPO_LEVEL_INVALID,
> > > > -    CPU_TOPO_LEVEL_SMT,
> > > > -    CPU_TOPO_LEVEL_CORE,
> > > > -    CPU_TOPO_LEVEL_MODULE,
> > > > -    CPU_TOPO_LEVEL_DIE,
> > > > -    CPU_TOPO_LEVEL_PACKAGE,
> > > > -    CPU_TOPO_LEVEL_MAX,
> > > > -};
> > > > -
> > > 
> > > snip
> > > 
> > > > @@ -18,3 +18,47 @@
> > > >  ##
> > > >  { 'enum': 'S390CpuEntitlement',
> > > >    'data': [ 'auto', 'low', 'medium', 'high' ] }
> > > > +
> > > > +##
> > > > +# @CpuTopologyLevel:
> > > > +#
> > > > +# An enumeration of CPU topology levels.
> > > > +#
> > > > +# @invalid: Invalid topology level.
> > > 
> > > Previously all topology levels were internal to QEMU, and IIUC
> > > this CPU_TOPO_LEVEL_INVALID appears to have been a special
> > > value to indicate  the cache was absent ?
> > 
> > Now I haven't support this logic.
> > x86 CPU has a "l3-cache" property, and maybe that property can be
> > implemented or replaced by the "invalid" level support you mentioned.
> > 
> > > Now we're exposing this directly to the user as a settable
> > > option. We need to explain what effect setting 'invalid'
> > > has on the CPU cache config.
> > 
> > If user set "invalid", QEMU will report the error message:
> > 
> > qemu-system-x86_64: Invalid cache topology level: invalid. The topology should match valid CPU topology level
> > 
> > Do you think this error message is sufficient?
> 
> If the user cannot set 'invalid' as an input, and no QEMU interface
> will emit, then ideally we would not define 'invalid' in the QAPI
> schema at all.
> 
> This woudl require us to have some internal only way to record
> "invalid", separately from the topology level, or with a magic
> internal only constant that doesn't clash with the public enum
> constants. I guess the latter would be less work e.g. we could
> "abuse" the 'MAX' constant value
> 
>    #define CPU_TOPOLOGY_LEVEL_INVALID CPU_TOPOLOGY_LEVEL_MAX
> 
> or separate it with a negative value
> 
>    #define CPU_TOPOLOGY_LEVEL_INVALID -1
>

This's a clever idea. Thank you!

Rgards,
Zhao


