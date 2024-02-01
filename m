Return-Path: <kvm+bounces-7650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95191844F39
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 03:44:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAFCC1C2399E
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62CF3A1AB;
	Thu,  1 Feb 2024 02:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kbefS1Q/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3933239FEE
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 02:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706755450; cv=none; b=YYOHpslhqcFL0COK0pnBjFc9m7LqZEjmx+W4Uu+1zrhzTvrG3qZlbe9lBR0kNy5hoAdt5peLdbcLh+aG0a+IHUrpZm8N01nMkfX51Z0jTjpRcHQQsSuZWFWxHNPzqvnT/6u9sCzgx2oGHcEjo6hg4+aoXcwCg8WGBX+/JHynwwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706755450; c=relaxed/simple;
	bh=Yc3gR68rS4/B0kEheqFMJGBIql3pAV51T/Q4R/eXbuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hCHeh6WYHtALYBBF81ZQPegf5gClug43PpIaGVSQBcd9pnwntl+e9r3z5AvhwdkTyOm6L0UOyMuSvHFLZqhv3fpalyiD1/VS4D+5w0wpHUUW8NZ6NkeKEFW+YZltdzwaMLEBJbV+tVuXamPvrymOmHNYNyr14YbHbV/5/eSNgyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kbefS1Q/; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706755448; x=1738291448;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Yc3gR68rS4/B0kEheqFMJGBIql3pAV51T/Q4R/eXbuk=;
  b=kbefS1Q/8pm3VqGaZez6yZomzcZMNSy8JXdYSEJDhaGSPoZqiHJMn+AT
   jt/yvy4dnyGtUGMlXXEzyraS2TspxJ/IQB2n9jWz5RQwODjYTm6AZgIzR
   S7Rb6rpElmDM9wg0Rv9vmIvbC51Nj0h0Sx/4EsS5VVlESCHek25O2SZWA
   uFg5xjGoi1D9UkEV0/SDS3Ip1haqOS+5clELmaD8QpnF98wRn2elaJvqn
   30eb48g2xS6uo4tKNViXrcUtT6alD4j0RSpGTunr+wEd416YbeZBKNnBn
   vQbV/97dsA5+9ZpwIWsEcWExetZJjKeCQoQBqpu0j1EHQslWImMDxE+uL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="407506887"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="407506887"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 18:44:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="788810725"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="788810725"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga002.jf.intel.com with ESMTP; 31 Jan 2024 18:44:02 -0800
Date: Thu, 1 Feb 2024 10:57:32 +0800
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
Message-ID: <ZbsInI6Z66edm3eH@intel.com>
References: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
 <Zbog2vDrrWFbujrs@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zbog2vDrrWFbujrs@redhat.com>

Hi Daniel,

On Wed, Jan 31, 2024 at 10:28:42AM +0000, Daniel P. Berrangé wrote:
> Date: Wed, 31 Jan 2024 10:28:42 +0000
> From: "Daniel P. Berrangé" <berrange@redhat.com>
> Subject: Re: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
> 
> On Wed, Jan 31, 2024 at 06:13:29PM +0800, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>

[snip]

> > However, after digging deeper into the description and use cases of
> > cluster in the device tree [3], I realized that the essential
> > difference between clusters and modules is that cluster is an extremely
> > abstract concept:
> >   * Cluster supports nesting though currently QEMU doesn't support
> >     nested cluster topology. However, modules will not support nesting.
> >   * Also due to nesting, there is great flexibility in sharing resources
> >     on clusters, rather than narrowing cluster down to sharing L2 (and
> >     L3 tags) as the lowest topology level that contains cores.
> >   * Flexible nesting of cluster allows it to correspond to any level
> >     between the x86 package and core.
> > 
> > Based on the above considerations, and in order to eliminate the naming
> > confusion caused by the mapping between general cluster and x86 module
> > in v7, we now formally introduce smp.modules as the new topology level.
> 
> What is the Linux kernel calling this topology level on x86 ?
> It will be pretty unfortunate if Linux and QEMU end up with
> different names for the same topology level.
> 

Now Intel's engineers in the Linux kernel are starting to use "module"
to refer to this layer of topology [4] to avoid confusion, where
previously the scheduler developers referred to the share L2 hierarchy
collectively as "cluster".

Looking at it this way, it makes more sense for QEMU to use the
"module" for x86.

[4]: https://lore.kernel.org/lkml/20231116142245.1233485-3-kan.liang@linux.intel.com/

Thanks,
Zhao


