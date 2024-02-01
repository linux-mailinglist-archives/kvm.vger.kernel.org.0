Return-Path: <kvm+bounces-7738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3869B845C62
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:01:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8B86295982
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850B515A485;
	Thu,  1 Feb 2024 15:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iO7nvVrr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BC85F47B
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 15:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706803054; cv=none; b=NXJPLMMW5xcnbaAmJgGRu+f9+iozICAXuGcsBew3VN6QUOjyHvBCCP/Q/j5acKIPXQX/ZWDM5s44XNrHf/hdeBeHcBYko8WNX3u8uMfoj1s65LdVmHX0seHoEFy/G7vdb6cx+ajeONIA/+NHa3l4WWSbtmaCIKL9eZD8hAlCsLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706803054; c=relaxed/simple;
	bh=h1q4KvAJn4CIoLG3naX5sp1wYlxPpERj17PvK1eyhmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBbGOCq6bOHaG51ULEpD2NnNvNnb8LtRAQjzGo56a/FDigJYuG76WuS2nLND1fh/e8yjrtqQTtNr7wnSh2eXcjkFPojftWv+mF7CNArUCXUeyCDpcG53p2SZd6OjCoGIoDHNS1MNP1qBUshw2CFphYbGEJVIS8RhrQkL7qAbLz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iO7nvVrr; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706803053; x=1738339053;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=h1q4KvAJn4CIoLG3naX5sp1wYlxPpERj17PvK1eyhmQ=;
  b=iO7nvVrrg0hsfCaDOUkcEdQW+UbMSI+eV0Siryd8Q6uYREWis1K8ROoT
   I/MY0pkPFfDwwl3cTbRfF7Aly/yAFbCcF1e1GyM40AkLIWSlxHA3e2mcr
   JDittyr4aznBWIPqRG0BmU9xVEFEUJOPLdYV55V7X5SfcBaE0uWMwBRxo
   H9Fu6WZA04XzJVt8rHk7M3y81azKCG8LJEBAR3M8l0TlrB9fiHRGxomTJ
   Nw8s1v0t+uhwtyWst5fHPjb6pfoTbuijDGZnADwURZJs8su5du16vqyKU
   rD2Map7mxqIoPsEY0w2Ikp1wR3QoWKrE01xpSmQ2Vl1hVlXmawzawLqfC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="3792438"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="3792438"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 07:57:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="4440963"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 01 Feb 2024 07:57:28 -0800
Date: Fri, 2 Feb 2024 00:10:58 +0800
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
Message-ID: <ZbvCktGZFj4v3I/P@intel.com>
References: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
 <Zbog2vDrrWFbujrs@redhat.com>
 <ZbsInI6Z66edm3eH@intel.com>
 <ZbtirK-orqCb5sba@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZbtirK-orqCb5sba@redhat.com>

Hi Daniel,

On Thu, Feb 01, 2024 at 09:21:48AM +0000, Daniel P. Berrangé wrote:
> Date: Thu, 1 Feb 2024 09:21:48 +0000
> From: "Daniel P. Berrangé" <berrange@redhat.com>
> Subject: Re: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
> 
> On Thu, Feb 01, 2024 at 10:57:32AM +0800, Zhao Liu wrote:
> > Hi Daniel,
> > 
> > On Wed, Jan 31, 2024 at 10:28:42AM +0000, Daniel P. Berrangé wrote:
> > > Date: Wed, 31 Jan 2024 10:28:42 +0000
> > > From: "Daniel P. Berrangé" <berrange@redhat.com>
> > > Subject: Re: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
> > > 
> > > On Wed, Jan 31, 2024 at 06:13:29PM +0800, Zhao Liu wrote:
> > > > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > [snip]
> > 
> > > > However, after digging deeper into the description and use cases of
> > > > cluster in the device tree [3], I realized that the essential
> > > > difference between clusters and modules is that cluster is an extremely
> > > > abstract concept:
> > > >   * Cluster supports nesting though currently QEMU doesn't support
> > > >     nested cluster topology. However, modules will not support nesting.
> > > >   * Also due to nesting, there is great flexibility in sharing resources
> > > >     on clusters, rather than narrowing cluster down to sharing L2 (and
> > > >     L3 tags) as the lowest topology level that contains cores.
> > > >   * Flexible nesting of cluster allows it to correspond to any level
> > > >     between the x86 package and core.
> > > > 
> > > > Based on the above considerations, and in order to eliminate the naming
> > > > confusion caused by the mapping between general cluster and x86 module
> > > > in v7, we now formally introduce smp.modules as the new topology level.
> > > 
> > > What is the Linux kernel calling this topology level on x86 ?
> > > It will be pretty unfortunate if Linux and QEMU end up with
> > > different names for the same topology level.
> > > 
> > 
> > Now Intel's engineers in the Linux kernel are starting to use "module"
> > to refer to this layer of topology [4] to avoid confusion, where
> > previously the scheduler developers referred to the share L2 hierarchy
> > collectively as "cluster".
> > 
> > Looking at it this way, it makes more sense for QEMU to use the
> > "module" for x86.
> 
> I was thinking specificially about what Linux calls this topology when
> exposing it in sysfs and /proc/cpuinfo. AFAICT, it looks like it is
> called 'clusters' in this context, and so this is the terminology that
> applications and users are going to expect.

The cluster related topology information under "/sys/devices/system/cpu/
cpu*/topology" indicates the L2 cache topology (CPUID[0x4]), not module
level CPU topology (CPUID[0x1f]).

So far, kernel hasn't exposed module topology related sysfs. But we will
add new "module" related information in sysfs. The relevant patches are
ready internally, but not posted yet.

In the future, we will use "module" in sysfs to indicate module level CPU
topology, and "cluster" will be only used to refer to the l2 cache domain
as it is now.

> 
> I think it would be a bad idea for QEMU to diverge from this and call
> it modules.
>

This patch set mainly tries to configure the module level CPU topology
for Guest, which will be aligned with the future module information in
the sysfs, so that it doesn't violate the kernel x86 arch's definition
or current end users' expectation for x86's cluster.

Thanks,
Zhao


