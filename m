Return-Path: <kvm+bounces-22115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B80193A2A5
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 16:24:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDF881F23897
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 14:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726EB154445;
	Tue, 23 Jul 2024 14:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ip0hVT8K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA9C15252E
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 14:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721744688; cv=none; b=M1tzBtp3qjKRtZ3kzKWlIr7nA+bVyswP6P0b/FVCJ3daY2G3aYRQHnN9JixMqyQA+Uqw0LLrvl36sAGiMmiKwd+roPENw7WIU7PbzbzHHPlksSZo3JFYQDlctkbeTE7zVVRObOqGm0H/ousTyGwFfxvvGS1FmtKtaH38VuS6rjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721744688; c=relaxed/simple;
	bh=596BeOYL/C3YYG4gWapj0nT35ULqFklo7XcRsaU+a60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h/zuzbhZ3POR/RPRGiE/OBAyVANGapQI0xizeIXEFwQZs/ObojSnduqoq/XQC0DfXDOH7+lcdnoMrDvIdGFLMoG0S7gBM0UTFy7slqTtAzD98Bq6MM8NWDw8k107jYzt/on+/QnCETY8CBIdZ6JkYsvqHa8S4JFGP/hWMSy0zPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ip0hVT8K; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721744687; x=1753280687;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=596BeOYL/C3YYG4gWapj0nT35ULqFklo7XcRsaU+a60=;
  b=Ip0hVT8KboKNeM1+ONPD6TlGC/FqQh9ot5b+cV+gWWtqueO9vINjJLhv
   JkMjopENQZh4kZq4jINErLQ+clu3Unn5E7zCDEsV3qjo4nynVwUxwGjzz
   3hDBD7iU0rVS1Cdoe/jgs5wnt0MdruOMqTd9cF3Z7a1rpTpnFHEiFIy39
   4/WaaJQBh+fuQp7al7TmYonFq5pBs6PQrOJ8Pbo5hEE53MUeDBPIF0p/Q
   AQ4zAUxzgUK34BgVxWGP48y/88wg1Ye6xTKL0N/Wx76ykGXfOlsJONp70
   dLo+Anbxdq0Lg22pKPGghn1Et97PGupEUZOCPSok1eLOwmKnlvvhfIXFC
   g==;
X-CSE-ConnectionGUID: n3yfzvPkQmSSa5L4lBRUFA==
X-CSE-MsgGUID: h4dQp9l0QUeYOv/zDDVLXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11142"; a="41900224"
X-IronPort-AV: E=Sophos;i="6.09,230,1716274800"; 
   d="scan'208";a="41900224"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2024 07:24:47 -0700
X-CSE-ConnectionGUID: hXBJ3rbPRQalpxStCGyFjw==
X-CSE-MsgGUID: 4ge7qOlyTr2QSQ3s+KE7WA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,230,1716274800"; 
   d="scan'208";a="52188455"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 23 Jul 2024 07:24:41 -0700
Date: Tue, 23 Jul 2024 22:40:25 +0800
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
Message-ID: <Zp/A2W5A0BqjRjR2@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
 <20240704031603.1744546-2-zhao1.liu@intel.com>
 <875xsx4l13.fsf@pond.sub.org>
 <Zp5mRrjuZWnE+9gz@intel.com>
 <87ed7kwh2x.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ed7kwh2x.fsf@pond.sub.org>

On Tue, Jul 23, 2024 at 12:14:30PM +0200, Markus Armbruster wrote:
> Date: Tue, 23 Jul 2024 12:14:30 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [PATCH 1/8] hw/core: Make CPU topology enumeration
>  arch-agnostic
> 
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > Hi Markus,
> >
> > On Mon, Jul 22, 2024 at 03:24:24PM +0200, Markus Armbruster wrote:
> >> Date: Mon, 22 Jul 2024 15:24:24 +0200
> >> From: Markus Armbruster <armbru@redhat.com>
> >> Subject: Re: [PATCH 1/8] hw/core: Make CPU topology enumeration
> >>  arch-agnostic
> >> 
> >> One little thing...
> >> 
> >> Zhao Liu <zhao1.liu@intel.com> writes:
> >> 
> >> > Cache topology needs to be defined based on CPU topology levels. Thus,
> >> > define CPU topology enumeration in qapi/machine.json to make it generic
> >> > for all architectures.
> >> >
> >> > To match the general topology naming style, rename CPU_TOPO_LEVEL_SMT
> >> > and CPU_TOPO_LEVEL_PACKAGE to CPU_TOPO_LEVEL_THREAD and
> >> > CPU_TOPO_LEVEL_SOCKET.
> >> >
> >> > Also, enumerate additional topology levels for non-i386 arches, and add
> >> > a CPU_TOPO_LEVEL_DEFAULT to help future smp-cache object de-compatibilize
> >> > arch-specific cache topology settings.
> >> >
> >> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> >> 
> >> [...]
> >> 
> >> > diff --git a/qapi/machine-common.json b/qapi/machine-common.json
> >> > index fa6bd71d1280..82413c668bdb 100644
> >> > --- a/qapi/machine-common.json
> >> > +++ b/qapi/machine-common.json
> >> > @@ -5,7 +5,7 @@
> >> >  # See the COPYING file in the top-level directory.
> >> >  
> >> >  ##
> >> > -# = Machines S390 data types
> >> > +# = Common machine types
> >> >  ##
> >> >  
> >> >  ##
> >> > @@ -19,3 +19,48 @@
> >> >  { 'enum': 'CpuS390Entitlement',
> >> >    'prefix': 'S390_CPU_ENTITLEMENT',
> >> >    'data': [ 'auto', 'low', 'medium', 'high' ] }
> >> > +
> >> > +##
> >> > +# @CpuTopologyLevel:
> >> > +#
> >> > +# An enumeration of CPU topology levels.
> >> > +#
> >> > +# @invalid: Invalid topology level.
> >> > +#
> >> > +# @thread: thread level, which would also be called SMT level or
> >> > +#     logical processor level.  The @threads option in
> >> > +#     SMPConfiguration is used to configure the topology of this
> >> > +#     level.
> >> > +#
> >> > +# @core: core level.  The @cores option in SMPConfiguration is used
> >> > +#     to configure the topology of this level.
> >> > +#
> >> > +# @module: module level.  The @modules option in SMPConfiguration is
> >> > +#     used to configure the topology of this level.
> >> > +#
> >> > +# @cluster: cluster level.  The @clusters option in SMPConfiguration
> >> > +#     is used to configure the topology of this level.
> >> > +#
> >> > +# @die: die level.  The @dies option in SMPConfiguration is used to
> >> > +#     configure the topology of this level.
> >> > +#
> >> > +# @socket: socket level, which would also be called package level.
> >> > +#     The @sockets option in SMPConfiguration is used to configure
> >> > +#     the topology of this level.
> >> > +#
> >> > +# @book: book level.  The @books option in SMPConfiguration is used
> >> > +#     to configure the topology of this level.
> >> > +#
> >> > +# @drawer: drawer level.  The @drawers option in SMPConfiguration is
> >> > +#     used to configure the topology of this level.
> >> > +#
> >> > +# @default: default level.  Some architectures will have default
> >> > +#     topology settings (e.g., cache topology), and this special
> >> > +#     level means following the architecture-specific settings.
> >> > +#
> >> > +# Since: 9.1
> >> > +##
> >> > +{ 'enum': 'CpuTopologyLevel',
> >> > +  'prefix': 'CPU_TOPO_LEVEL',
> >> 
> >> Why set a 'prefix'?
> >> 
> >
> > Because my previous i386 commit 6ddeb0ec8c29 ("i386/cpu: Introduce bitmap
> > to cache available CPU topology levels") introduced the level
> > enumeration with such prefix. For naming consistency, and to shorten the
> > length of the name, I've used the same prefix here as well.
> >
> > I've sensed that you don't like the TOPO abbreviation and I'll remove the
> > prefix :-).
> 
> Consistency is good, but I'd rather achieve it by consistently using
> "topology".
> 
> I never liked the 'prefix' feature much.  We have it because the mapping
> from camel case to upper case with underscores is heuristical, and can
> result in something undesirable.  See commit 351d36e454c (qapi: allow
> override of default enum prefix naming).  Using it just to shorten
> generated identifiers is a bad idea.

Thanks for your clarification! I see, I will drop the prefix.

Regards,
Zhao



