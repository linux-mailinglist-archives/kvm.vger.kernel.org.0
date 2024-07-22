Return-Path: <kvm+bounces-22054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C13939016
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 15:46:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43E092819C2
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 13:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E2F16CD33;
	Mon, 22 Jul 2024 13:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YMwQ0Whr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7AC322E
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 13:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721655969; cv=none; b=AFiUciOmf4Re9A1aA9Z4bRVQqAszGUT9wjpk+uLQJF/bssKxkZbfpcXBMLmq2/O6MLS79uz9QKzJLb3dKc1b+AsjiGQ/XrQOXLoKFn+Hvsz5YE25K6CRsBVCNtoY11C2ygr0nAdZen8wagFM2wTBooSKXHz5J7kIrgB1nNXvg30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721655969; c=relaxed/simple;
	bh=0VBpJCAF/a++txWiiz/0DTFqCVwBxK6I/Uf6ZwYzsFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OcHu9OennSTQPe32G8pNRNZG8UUoHaQPWZH7mMFgvj74UoHJAWNgVcZnD/v1kzMXhbaYs/C0ir37ZIwSSV2kkcPcrbMQFr1KK1BkGMP2gmVo9IQScwMqzNX2i6/WlVpvREnuVgRrdKSGBUokREI1Fft81NGqmER2vBKZOmO/dqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YMwQ0Whr; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721655964; x=1753191964;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0VBpJCAF/a++txWiiz/0DTFqCVwBxK6I/Uf6ZwYzsFM=;
  b=YMwQ0Whr3MnAs0BYnhP9VXcVLtMKJ1FCDcE/B9aYYk2hx8/ykYYR6acQ
   OIzo0qRZV/Yk0de4VUIz3cBan/NJOKyH7esMZSMpyFbarXJjjOTPivuMN
   ElypYDX+98Aj0KKq1Q/G0umGNEnmRIWXuik49Kk6Vr6XV+O8tKf0GnyyR
   eW13Pn7+SHjsCaRGg95wv3bjFNcl667OGHOyv6Xso9u1uqYXzwkfWV0HZ
   o+PJBouYuM6FQ5ZOpTPwAl0j8r3BIWHkidwVBJI45uXClo70g+dDi5Dc4
   tHLP10NPNFQfkh1+rfJXm/rFx2ah/zPXRQq2K/cvIF5ROoGp3OhTaazX/
   Q==;
X-CSE-ConnectionGUID: 5EV1JxJwRYiuOIBFW/tD+g==
X-CSE-MsgGUID: yaQK3KQ6RNSBtHt2wXq1fQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11140"; a="19353451"
X-IronPort-AV: E=Sophos;i="6.09,228,1716274800"; 
   d="scan'208";a="19353451"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2024 06:46:04 -0700
X-CSE-ConnectionGUID: KKANULJsSICbrZipe8omdg==
X-CSE-MsgGUID: A6QV4KAqQ76bUFCb7lKS1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,228,1716274800"; 
   d="scan'208";a="51954848"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 22 Jul 2024 06:45:59 -0700
Date: Mon, 22 Jul 2024 22:01:42 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
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
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH 1/8] hw/core: Make CPU topology enumeration arch-agnostic
Message-ID: <Zp5mRrjuZWnE+9gz@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
 <20240704031603.1744546-2-zhao1.liu@intel.com>
 <875xsx4l13.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875xsx4l13.fsf@pond.sub.org>

Hi Markus,

On Mon, Jul 22, 2024 at 03:24:24PM +0200, Markus Armbruster wrote:
> Date: Mon, 22 Jul 2024 15:24:24 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [PATCH 1/8] hw/core: Make CPU topology enumeration
>  arch-agnostic
> 
> One little thing...
> 
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > Cache topology needs to be defined based on CPU topology levels. Thus,
> > define CPU topology enumeration in qapi/machine.json to make it generic
> > for all architectures.
> >
> > To match the general topology naming style, rename CPU_TOPO_LEVEL_SMT
> > and CPU_TOPO_LEVEL_PACKAGE to CPU_TOPO_LEVEL_THREAD and
> > CPU_TOPO_LEVEL_SOCKET.
> >
> > Also, enumerate additional topology levels for non-i386 arches, and add
> > a CPU_TOPO_LEVEL_DEFAULT to help future smp-cache object de-compatibilize
> > arch-specific cache topology settings.
> >
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 
> [...]
> 
> > diff --git a/qapi/machine-common.json b/qapi/machine-common.json
> > index fa6bd71d1280..82413c668bdb 100644
> > --- a/qapi/machine-common.json
> > +++ b/qapi/machine-common.json
> > @@ -5,7 +5,7 @@
> >  # See the COPYING file in the top-level directory.
> >  
> >  ##
> > -# = Machines S390 data types
> > +# = Common machine types
> >  ##
> >  
> >  ##
> > @@ -19,3 +19,48 @@
> >  { 'enum': 'CpuS390Entitlement',
> >    'prefix': 'S390_CPU_ENTITLEMENT',
> >    'data': [ 'auto', 'low', 'medium', 'high' ] }
> > +
> > +##
> > +# @CpuTopologyLevel:
> > +#
> > +# An enumeration of CPU topology levels.
> > +#
> > +# @invalid: Invalid topology level.
> > +#
> > +# @thread: thread level, which would also be called SMT level or
> > +#     logical processor level.  The @threads option in
> > +#     SMPConfiguration is used to configure the topology of this
> > +#     level.
> > +#
> > +# @core: core level.  The @cores option in SMPConfiguration is used
> > +#     to configure the topology of this level.
> > +#
> > +# @module: module level.  The @modules option in SMPConfiguration is
> > +#     used to configure the topology of this level.
> > +#
> > +# @cluster: cluster level.  The @clusters option in SMPConfiguration
> > +#     is used to configure the topology of this level.
> > +#
> > +# @die: die level.  The @dies option in SMPConfiguration is used to
> > +#     configure the topology of this level.
> > +#
> > +# @socket: socket level, which would also be called package level.
> > +#     The @sockets option in SMPConfiguration is used to configure
> > +#     the topology of this level.
> > +#
> > +# @book: book level.  The @books option in SMPConfiguration is used
> > +#     to configure the topology of this level.
> > +#
> > +# @drawer: drawer level.  The @drawers option in SMPConfiguration is
> > +#     used to configure the topology of this level.
> > +#
> > +# @default: default level.  Some architectures will have default
> > +#     topology settings (e.g., cache topology), and this special
> > +#     level means following the architecture-specific settings.
> > +#
> > +# Since: 9.1
> > +##
> > +{ 'enum': 'CpuTopologyLevel',
> > +  'prefix': 'CPU_TOPO_LEVEL',
> 
> Why set a 'prefix'?
> 

Because my previous i386 commit 6ddeb0ec8c29 ("i386/cpu: Introduce bitmap
to cache available CPU topology levels") introduced the level
enumeration with such prefix. For naming consistency, and to shorten the
length of the name, I've used the same prefix here as well.

I've sensed that you don't like the TOPO abbreviation and I'll remove the
prefix :-).

Thanks,
Zhao



