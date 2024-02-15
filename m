Return-Path: <kvm+bounces-8805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 971F98569C9
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 17:43:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EECB284CFD
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 16:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A21135A71;
	Thu, 15 Feb 2024 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pay7+0N6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579EB13473A
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 16:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708015383; cv=none; b=tiQCVzkIDtk2vE732xwLRSAwijypMYmQyszdsOwURJV6SLa1ZetZVtYC0UC8giZNzt4i73ja5CAdFIRRXwMYafRUTPtIjUVt5cISu4wntP/07S12RAMQopZso6FmVbKR5csnechqHho3r7VWqSM1HACvCjZnNml74w0XLRfftVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708015383; c=relaxed/simple;
	bh=XTsgmHI9ChQanMOP9tgHrBGrhFpVYXOUCPSt3Lg0oeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZH20tdBHIz+HPPs+Ou1wTr+1mVB+k/24phZljPxJNX/Ei8r6N024OND0d79vtvnwmLHialcKduEK9uCz7kF2+KhVFZcdB3Ld0pWJoAtP63iLpw/TE0PoQXROpOopeOkawcCs5e+u1afYgyYOfTUSVQj3QuMXS80GYLGrk/+79zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pay7+0N6; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708015383; x=1739551383;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=XTsgmHI9ChQanMOP9tgHrBGrhFpVYXOUCPSt3Lg0oeA=;
  b=Pay7+0N6Y7WMtgds8vZkLCEf8zf+FT4+lUxWhHOx7bp56KR3TY2++X9c
   GedGSXBAAjGzS3GFR2eeR7Xnm7rQiP89GWv4ElYkU4tzTRh7pjy/o25oK
   Y5oEmVR7TgtQbMh5hNgl+tk1GPJsKkaGmn5vCE6nGUGTXahHikaUZO9kY
   q3qECb6mClYCIsBuQX09RFRXUaVsTTtBVoUUkL9e6yk4J6tfB6HrlfZML
   f7aC6XbG6XeULunXhKfUB5hRbBlE+uW3fhrIqI0jjY1OfYfxZo2sTszU9
   Unx6PxTwFKX783s9G6ikfejEG7ish21zEiv9CHIAglz4hHXy5QCObHOBV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10985"; a="2231905"
X-IronPort-AV: E=Sophos;i="6.06,162,1705392000"; 
   d="scan'208";a="2231905"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2024 08:43:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10985"; a="912192235"
X-IronPort-AV: E=Sophos;i="6.06,162,1705392000"; 
   d="scan'208";a="912192235"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmsmga002.fm.intel.com with ESMTP; 15 Feb 2024 08:42:57 -0800
Date: Fri, 16 Feb 2024 00:56:34 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
Message-ID: <Zc5CQlA20gTePwu6@intel.com>
References: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
 <Zbog2vDrrWFbujrs@redhat.com>
 <ZbsInI6Z66edm3eH@intel.com>
 <ZbtirK-orqCb5sba@redhat.com>
 <ZbvCktGZFj4v3I/P@intel.com>
 <ZcUG0Uc8KylEQhUW@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZcUG0Uc8KylEQhUW@redhat.com>

Hi Daniel,

On Thu, Feb 08, 2024 at 04:52:33PM +0000, Daniel P. Berrangé wrote:
> Date: Thu, 8 Feb 2024 16:52:33 +0000
> From: "Daniel P. Berrangé" <berrange@redhat.com>
> Subject: Re: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
> 
> On Fri, Feb 02, 2024 at 12:10:58AM +0800, Zhao Liu wrote:
> > Hi Daniel,
> > 
> > On Thu, Feb 01, 2024 at 09:21:48AM +0000, Daniel P. Berrangé wrote:
> > > Date: Thu, 1 Feb 2024 09:21:48 +0000
> > > From: "Daniel P. Berrangé" <berrange@redhat.com>
> > > Subject: Re: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
> > > 
> > > On Thu, Feb 01, 2024 at 10:57:32AM +0800, Zhao Liu wrote:
> > > > Hi Daniel,
> > > > 
> > > > On Wed, Jan 31, 2024 at 10:28:42AM +0000, Daniel P. Berrangé wrote:
> > > > > Date: Wed, 31 Jan 2024 10:28:42 +0000
> > > > > From: "Daniel P. Berrangé" <berrange@redhat.com>
> > > > > Subject: Re: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
> > > > > 
> > > > > On Wed, Jan 31, 2024 at 06:13:29PM +0800, Zhao Liu wrote:
> > > > > > From: Zhao Liu <zhao1.liu@intel.com>
> > > > 
> > > > [snip]
> > > > 
> > > > > > However, after digging deeper into the description and use cases of
> > > > > > cluster in the device tree [3], I realized that the essential
> > > > > > difference between clusters and modules is that cluster is an extremely
> > > > > > abstract concept:
> > > > > >   * Cluster supports nesting though currently QEMU doesn't support
> > > > > >     nested cluster topology. However, modules will not support nesting.
> > > > > >   * Also due to nesting, there is great flexibility in sharing resources
> > > > > >     on clusters, rather than narrowing cluster down to sharing L2 (and
> > > > > >     L3 tags) as the lowest topology level that contains cores.
> > > > > >   * Flexible nesting of cluster allows it to correspond to any level
> > > > > >     between the x86 package and core.
> > > > > > 
> > > > > > Based on the above considerations, and in order to eliminate the naming
> > > > > > confusion caused by the mapping between general cluster and x86 module
> > > > > > in v7, we now formally introduce smp.modules as the new topology level.
> > > > > 
> > > > > What is the Linux kernel calling this topology level on x86 ?
> > > > > It will be pretty unfortunate if Linux and QEMU end up with
> > > > > different names for the same topology level.
> > > > > 
> > > > 
> > > > Now Intel's engineers in the Linux kernel are starting to use "module"
> > > > to refer to this layer of topology [4] to avoid confusion, where
> > > > previously the scheduler developers referred to the share L2 hierarchy
> > > > collectively as "cluster".
> > > > 
> > > > Looking at it this way, it makes more sense for QEMU to use the
> > > > "module" for x86.
> > > 
> > > I was thinking specificially about what Linux calls this topology when
> > > exposing it in sysfs and /proc/cpuinfo. AFAICT, it looks like it is
> > > called 'clusters' in this context, and so this is the terminology that
> > > applications and users are going to expect.
> > 
> > The cluster related topology information under "/sys/devices/system/cpu/
> > cpu*/topology" indicates the L2 cache topology (CPUID[0x4]), not module
> > level CPU topology (CPUID[0x1f]).
> > 
> > So far, kernel hasn't exposed module topology related sysfs. But we will
> > add new "module" related information in sysfs. The relevant patches are
> > ready internally, but not posted yet.
> > 
> > In the future, we will use "module" in sysfs to indicate module level CPU
> > topology, and "cluster" will be only used to refer to the l2 cache domain
> > as it is now.
> 
> So, if they're distinct concepts both relevant to x86 CPUs, then from
> the QEMU POV, should this patch series be changing the -smp arg to
> allowing configuration of both 'clusters' and 'modules' for x86 ?

Though the previous versions use "clusters" parameter, they, like the
current "modules" version, are just to add a CPU topology level to the
x86 CPU.

> 
> An earlier version of this series just supported 'clusters', and this
> changed to 'modules', but your description of Linux reporting both
> suggests QEMU would need both.
>

Given the cluster support for x86, i.e. the L2 cache topology support,
we want to introduce a different cache topology configuration way than
CPU topology and avoid using the "cluster" as cache topology name (this
avoids the confusion of -smp "clusters" which is a CPU topology since
ARM also just treats "cluster" as a CPU topology level in QEMU other
than cache topology level).

BTW, for cache topology, may I ask for your advice? Currently, I can
think of 2 options:

1. Hacked the -smp as:

-smp cpus=4,sockets=2,cores=2,threads=1, \
     l3-cache=socket,l2-cache=core,l1-i-cache=core,l1-d-cache=core

For this way, I just parsed the extended -smp and store the cache
topology in such structue:

typedef struct CacheTopology {
    CPUTopoLevel l1i;
    CPUTopoLevel l1d;
    CPUTopoLevel l2;
    CPUTopoLevel l3;
} CacheTopology;

This way is just used for smp cache topology. For the heterogeneous/hybrid
cache topology, I think it can be expanded based on the QOM CPU topology
[4] as:

    -accel kvm -cpu host \
    -device cpu-socket,id=sock0 \
    -device cpu-die,id=die0,parent=sock0 \
    -device cpu-module,id=module0,parent=die0 \
    -device cpu-module,id=module1,parent=die0 \
    -device cpu-core,id=core0,parent=module0,nr-threads=2 \
    -device cpu-core,id=core1,parent=module1,nr-threads=1 \
    -device cpu-core,id=core2,parent=module1,nr-threads=1 \
    -device cache,id=cache0,parent=die0,level=3,type=unified \
    -device cache,id=cache1,parent=core0,level=2,type=unified \
    -device cache,id=cache2,parent=core0,level=1,type=data \
    -device cache,id=cache3,parent=core0,level=1,type=inst \
    -device cache,id=cache4,parent=module1,level=2,type=unified \
    -device cache,id=cache5,parent=core1,level=1,type=data \
    -device cache,id=cache6,parent=core1,level=1,type=inst \
    -device cache,id=cache5,parent=core2,level=1,type=data \
    -device cache,id=cache6,parent=core2,level=1,type=inst \

In the module0, the l2 (x86's cluster) is shared at core0 (core level).
And in the module1, the l2 is shared for core1 and core 2 (at module
level).

[4]: https://lore.kernel.org/qemu-devel/20231130144203.2307629-1-zhao1.liu@linux.intel.com/


2. But recently I realized maybe there's another option, which is just
to introduce a new option "-cache" like "-numa" to configure cache
topology.

In "-cache", we could accept the CPU list as the parameter:

    -cache cache,cacheid=0,level=2,type=unified,cpus=0-1 \
    -cache cache,cacheid=1,level=2,type=unified,cpus=2-3 \

or CPU topology ids as the parameters:

    -cache cache,cache-id=0,level=2,type=unified \
    -cache cache,cache-id=1,level=2,type=unified \
    -cache cpu,cache-id=0,socket-id=0,die-id=0,module-id=0,core-id=0 \
    -cache cpu,cache-id=1,socket-id=0,die-id=0,module-id=1 \


Hmmm, Daniel, which of the above two options do you prefer?

Thanks,
Zhao


