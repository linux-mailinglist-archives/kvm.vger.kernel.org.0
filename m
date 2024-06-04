Return-Path: <kvm+bounces-18739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96AD58FADFF
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 10:51:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7BD01C20CC5
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 08:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EF11142E81;
	Tue,  4 Jun 2024 08:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bh9wxrAT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E650BA39
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 08:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717491057; cv=none; b=FIrSMkBlQkZlfYS2+Zq9iIIGsqpMeU6aazCVaUfqjL029UfEAgh+kxjAzM0o0xs/2zhCdrSxqEZxFW0CK4Ml9zCe8YqdnZzOSc3Eizr5tddsB5zTTCISlV3nC+G+ny+TkmFib18bSUi2u/7fLXBtur5RVvrj5NvKjsyQEnNiFAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717491057; c=relaxed/simple;
	bh=Ap8E/rEAx1h96bUEuIBQzglwJ4IPaipb0Em35hfeCMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0Yt9dkPAG/vhmuhICGvEEi8k7GZ50Jbr43w54QwDi50Miv75smCbH0ZwTo6b4NlBPb5Da6D6idV/1gfae3zwgGPcGn8rWNlehV/FBWZu+989LgSGI7NSMuQCCqvH6UNH04fPea1gBp8ajmzSopLdGr2WlERTl8Sg8sccrmmUO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bh9wxrAT; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717491056; x=1749027056;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ap8E/rEAx1h96bUEuIBQzglwJ4IPaipb0Em35hfeCMI=;
  b=bh9wxrAT6wjgwoBCoHdj/JXXqe/OAa6Aas3k4SKSJ28lE1qPjxgYRrbL
   +jKLjD7MFb0uGQffIv5DiWTvyKZlIqWy+HLM++8ng+1J0zXDf2unzMz1X
   WW2dDCaldNz4PDxLm2gKfI7QnRTJBEqbeKckprPDwvVlw6rzoF3e0RufH
   TNAGvvTEA87Rmsl1gVHU+Pas96ZY3KjtWGfKaiCLhBnJaLaePv2IdUuWG
   7L2afCF2CmFswAwyjswns0CAfo4O1htPwf3IByGSTFs7HYM6P5nNMqiAD
   ZkqLgm8hdb8iiAMWSrPn9VpORXotQEEpDCiiZ9LAroy/Ff2yQJRHNnKuT
   g==;
X-CSE-ConnectionGUID: Ywsu6SJtQOKaFGP0O9oRCw==
X-CSE-MsgGUID: xJFwYp0/QVma1WOqvKVHpA==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="24686288"
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="24686288"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2024 01:50:55 -0700
X-CSE-ConnectionGUID: xgrFahFxRWmNqr5Axiqaqw==
X-CSE-MsgGUID: 4ZpV1M0jS6m9NzOxuga+5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="68338779"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 04 Jun 2024 01:50:50 -0700
Date: Tue, 4 Jun 2024 17:06:16 +0800
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
Subject: Re: [RFC v2 1/7] hw/core: Make CPU topology enumeration arch-agnostic
Message-ID: <Zl7ZCK0SxAFVZckX@intel.com>
References: <20240530101539.768484-1-zhao1.liu@intel.com>
 <20240530101539.768484-2-zhao1.liu@intel.com>
 <87plsyfc1r.fsf@pond.sub.org>
 <Zl7RbLrYUN0cg+t4@intel.com>
 <87zfs19jrj.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zfs19jrj.fsf@pond.sub.org>

On Tue, Jun 04, 2024 at 10:47:44AM +0200, Markus Armbruster wrote:
> Date: Tue, 04 Jun 2024 10:47:44 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [RFC v2 1/7] hw/core: Make CPU topology enumeration
>  arch-agnostic
> 
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > Hi Markus,
> >
> > On Mon, Jun 03, 2024 at 02:25:36PM +0200, Markus Armbruster wrote:
> >> Date: Mon, 03 Jun 2024 14:25:36 +0200
> >> From: Markus Armbruster <armbru@redhat.com>
> >> Subject: Re: [RFC v2 1/7] hw/core: Make CPU topology enumeration
> >>  arch-agnostic
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
> >> > helpers for topology enumeration and string conversion.
> >> >
> >> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> >> 
> >> [...]
> >> 
> >> > diff --git a/qapi/machine.json b/qapi/machine.json
> >> > index bce6e1bbc412..7ac5a05bb9c9 100644
> >> > --- a/qapi/machine.json
> >> > +++ b/qapi/machine.json
> >> > @@ -1667,6 +1667,46 @@
> >> >       '*reboot-timeout': 'int',
> >> >       '*strict': 'bool' } }
> >> >  
> >> > +##
> >> > +# @CPUTopoLevel:
> >> 
> >> I understand you're moving existing enum CPUTopoLevel into the QAPI
> >> schema.  I think the idiomatic QAPI name would be CpuTopologyLevel.
> >> Would you be willing to rename it, or would that be too much churn?
> >
> > Sure, I'll rename it as you suggested.
> >
> >> > +#
> >> > +# An enumeration of CPU topology levels.
> >> > +#
> >> > +# @invalid: Invalid topology level, used as a placeholder.
> >> > +#
> >> > +# @thread: thread level, which would also be called SMT level or logical
> >> > +#     processor level. The @threads option in -smp is used to configure
> >> > +#     the topology of this level.
> >> > +#
> >> > +# @core: core level. The @cores option in -smp is used to configure the
> >> > +#     topology of this level.
> >> > +#
> >> > +# @module: module level. The @modules option in -smp is used to
> >> > +#     configure the topology of this level.
> >> > +#
> >> > +# @cluster: cluster level. The @clusters option in -smp is used to
> >> > +#     configure the topology of this level.
> >> > +#
> >> > +# @die: die level. The @dies option in -smp is used to configure the
> >> > +#     topology of this level.
> >> > +#
> >> > +# @socket: socket level, which would also be called package level. The
> >> > +#     @sockets option in -smp is used to configure the topology of this
> >> > +#     level.
> >> > +#
> >> > +# @book: book level. The @books option in -smp is used to configure the
> >> > +#     topology of this level.
> >> > +#
> >> > +# @drawer: drawer level. The @drawers option in -smp is used to
> >> > +#     configure the topology of this level.
> >> 
> >> docs/devel/qapi-code-gen.rst section Documentation markup:
> >> 
> >>     For legibility, wrap text paragraphs so every line is at most 70
> >>     characters long.
> >> 
> >>     Separate sentences with two spaces.
> >
> > Thank you for pointing this.
> >
> > About separating sentences, is this what I should be doing?
> >
> > # @drawer: drawer level. The @drawers option in -smp is used to
> > #  configure the topology of this level.
> 
> Like this:
> 
> ##
> # @CPUTopoLevel:
> #
> # An enumeration of CPU topology levels.
> #
> # @invalid: Invalid topology level.
> #
> # @thread: thread level, which would also be called SMT level or
> #     logical processor level.  The @threads option in -smp is used to
> #     configure the topology of this level.
> #
> # @core: core level.  The @cores option in -smp is used to configure
> #     the topology of this level.
> #
> # @module: module level.  The @modules option in -smp is used to
> #     configure the topology of this level.
> #
> # @cluster: cluster level.  The @clusters option in -smp is used to
> #     configure the topology of this level.
> #
> # @die: die level.  The @dies option in -smp is used to configure the
> #     topology of this level.
> #
> # @socket: socket level, which would also be called package level.
> #     The @sockets option in -smp is used to configure the topology of
> #     this level.
> #
> # @book: book level.  The @books option in -smp is used to configure
> #     the topology of this level.
> #
> # @drawer: drawer level.  The @drawers option in -smp is used to
> #     configure the topology of this level.
> #
> # Since: 9.1
> ##
>

I see, thanks very much for your patience.


