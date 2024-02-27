Return-Path: <kvm+bounces-10099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81550869B87
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 17:04:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A59B41C222AD
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 16:04:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 306B3146912;
	Tue, 27 Feb 2024 16:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FlYr4XSG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB75535AE
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 16:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709049840; cv=none; b=XaFNZAp0eVJLLH1pPqxzlclekJGDdAS+0BNvmb5/d3T0zIcn7Kj63vtG2cR8AWj9LkNR4yRtq6gpTcv2ltZ1NIk3KBgtMsQBT45rKbtfbSDjHGDjh4xSg6vxR8ip/1Sbwe0xuTMyGxrwntBnVTjCps7UlyCWHtByS1zG5JfjU8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709049840; c=relaxed/simple;
	bh=a4uC/JTyOpAvVrmW4y1AlyaBbiESaUUtpRpbAEFnTQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZAfXFSV3vvLF0s69NgYlfS73X3MQfDxQW2G9e7l/0stKL44y8c0W6JtN/EQaHNoC22ywM9BsQFEDFVxHj2igKzqaW7BkMAgPwWTLgayHRmYk1d39/4V4R4N2sMY22gJiWUP1JX8AsuvbFuUXWn9uHnLii/8gNq3s/ZeGp49/X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FlYr4XSG; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709049838; x=1740585838;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=a4uC/JTyOpAvVrmW4y1AlyaBbiESaUUtpRpbAEFnTQE=;
  b=FlYr4XSGoAARZ3rytThfn+f5B/FoX1g3PqxVQblZ7M9KK/L9K2ca0EXA
   f5ymrfKCcrzke0xiPBaoX21OaP47NweurFn2EYtfY38E1cf/7QpVzwYFM
   Kf4TsUVNTZFZTkgh/5j79T3tOGb81SFzR7/twPRG1CltL7htaHmGj6og1
   FlBdYqWGK08mzfsv+qan2Lku9DRPR6i7N/sH4HfBpHBzH/du16wwF0ua5
   FkWQK5KTS+/SZyjtTB2bAUq+EGdoLTWjOIiKWFPSbkZYY/PJI/zTpCJhP
   aCPp92A2BOVHm6cvt/jswjsf2tzMX213SnGSTdwKYAmPXKJL13Vo7yYog
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3561336"
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="3561336"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 08:03:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="7049055"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 27 Feb 2024 08:03:44 -0800
Date: Wed, 28 Feb 2024 00:17:26 +0800
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
Subject: Re: [RFC 8/8] qemu-options: Add the cache topology description of
 -smp
Message-ID: <Zd4LFoegPx6EDfNy@intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
 <20240220092504.726064-9-zhao1.liu@linux.intel.com>
 <20240226154734.00000d6e@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226154734.00000d6e@Huawei.com>

Hi Jonathan,

On Mon, Feb 26, 2024 at 03:47:34PM +0000, Jonathan Cameron wrote:
> Date: Mon, 26 Feb 2024 15:47:34 +0000
> From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Subject: Re: [RFC 8/8] qemu-options: Add the cache topology description of
>  -smp
> X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
> 
> On Tue, 20 Feb 2024 17:25:04 +0800
> Zhao Liu <zhao1.liu@linux.intel.com> wrote:
> 
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 
> Hi,
> 
> A trivial comment, but also a possibly more significant one about
> whether the defaults are correctly verified.
> 
> Jonathan
> > ---
> >  qemu-options.hx | 54 ++++++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 47 insertions(+), 7 deletions(-)
> > 
> > diff --git a/qemu-options.hx b/qemu-options.hx
> > index 70eaf3256685..85c78c99a3b0 100644
> > --- a/qemu-options.hx
> > +++ b/qemu-options.hx
> > @@ -281,7 +281,9 @@ ERST
> >  
> >  DEF("smp", HAS_ARG, QEMU_OPTION_smp,
> >      "-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets]\n"
> > -    "               [,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"
> > +    "               [,dies=dies][,clusters=clusters][,modules=modules][,cores=cores]\n"
> > +    "               [,threads=threads][,l1d-cache=level][,l1i-cache=level][,l2-cache=level]\n"
> burns more characters but I'd go with
> l1d->cache=topo_level
> 
> As level for a cache has a totally different meaning!

Yes, good catch! Thanks.

> 
> > +    "               [,l3-cache=level]\n"
> >      "                set the number of initial CPUs to 'n' [default=1]\n"
> >      "                maxcpus= maximum number of total CPUs, including\n"
> >      "                offline CPUs for hotplug, etc\n"
> > @@ -290,9 +292,14 @@ DEF("smp", HAS_ARG, QEMU_OPTION_smp,
> >      "                sockets= number of sockets in one book\n"
> >      "                dies= number of dies in one socket\n"
> >      "                clusters= number of clusters in one die\n"
> > -    "                cores= number of cores in one cluster\n"
> > +    "                modules= number of modules in one cluster\n"
> > +    "                cores= number of cores in one module\n"
> >      "                threads= number of threads in one core\n"
> > -    "Note: Different machines may have different subsets of the CPU topology\n"
> > +    "                l1d-cache= topology level of L1 D-cache\n"
> > +    "                l1i-cache= topology level of L1 I-cache\n"
> > +    "                l2-cache= topology level of L2 cache\n"
> > +    "                l3-cache= topology level of L3 cache\n"
> > +    "Note: Different machines may have different subsets of the CPU and cache topology\n"
> 
> >  
> >          -smp 32,sockets=2,dies=2,modules=2,cores=2,threads=2,maxcpus=32
> >  
> > +    The following sub-option defines a CPU topology hierarchy (2 sockets
> > +    totally on the machine, 2 dies per socket, 2 modules per die, 2 cores per
> > +    module, 2 threads per core) with 3-level cache topology hierarchy (L1
> > +    D-cache per core, L1 I-cache per core, L2 cache per core and L3 cache per
> > +    die) for PC machines which support sockets/dies/modules/cores/threads.
> > +    Some members of the CPU topology option can be omitted but their values
> > +    will be automatically computed. Some members of the cache topology
> > +    option can also be omitted and target CPU will use the default topology.:
> 
> Given the default could be inconsistent I wonder if we should 'push' levels
> up.  So if L2 not defined it is set either to default of equal to max of
> l1i and l1d level. L3 either default or same level as l2.

HMM, IIUC, I think there may be the case:

User sets L2 cache as per core and omits L3 cache. In this case, if L3
is per core (as L2) by default, how could we identify if that per core
L3 is the default or from user? We need to identify this becase x86's L3
is shared at die by default and L2 is shared at core level for current
CPU models.

To resolve this issue, we can add the status field in SMPCompatProps,
e.g., has_l3_cache, just like current SMPCompatProps.has_clusters, to
explicitly indicate that the L3 cache topo is set by user.

Then other caches also need the similar fields...It doesn't look as
simple as the current default invalid topology level.
 
> Won't always correspond to a sensible system so maybe just rejecting
> cases where default isn't possible is the best plan.  However I don't
> see that verification as the checks on higher levels are gated on them
> being specified.
> 
> > +
> > +    ::
> > +
> > +        -smp 32,sockets=2,dies=2,modules=2,cores=2,threads=2,maxcpus=32,\
> > +             l1d-cache=core,l1i-cache=core,l2-cache=core,l3-cache=die
> > +
> >      The following sub-option defines a CPU topology hierarchy (2 sockets
> >      totally on the machine, 2 clusters per socket, 2 cores per cluster,
> >      2 threads per core) for ARM virt machines which support sockets/clusters
> 

