Return-Path: <kvm+bounces-59876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 29F67BD1BEB
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 09:11:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0D9874E251F
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 07:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B57002E7F1D;
	Mon, 13 Oct 2025 07:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YIYhHAoK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF3D1C5F27
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 07:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760339483; cv=none; b=k7m/OsjgZDme4L2x3LhcQZ9AqeKquRPa5L24JAnw/kwn9cujSkTLmlwSs8PsdY2CDMyJVJGU0cNHdmao1bsNbRgeujDKeo+wfFrHOFeZ4HT0M9OWVBICE76H+RpxNcsdIIm19E4KqpyJCRGocpr5ViU6T1klZ+deRYiz1cxLpUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760339483; c=relaxed/simple;
	bh=M2Q7qIm8s1tX8Cfy27fSVfpbtAGIBwPTsmRQVLTKYgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8vFhDfdnjRZlgQQhqHpypD6gIBOB9RlIsjnFcaN72vUo5jofNMP3m2Ko9ksD9oqr0wZbaoxAX/BGg1yZEjhpcx64eUsucGFsinBs3zvV2kdRzz3x+qbU0b1o7NwUOQffeWZD3dLWpNLXwn4bvOGxqkcVOIUzS25tEHa0oWkYpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YIYhHAoK; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760339482; x=1791875482;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M2Q7qIm8s1tX8Cfy27fSVfpbtAGIBwPTsmRQVLTKYgs=;
  b=YIYhHAoKcBkgdQMs67f3SiaDPJABYtm4GmxClr+BGzLreCiYDBbTrFOC
   2o2KBPU1IgpV7Kyft5xDWZ/SG10p/+OVQxb0Mx05SmTLsSkwJXl8TlPmy
   21dLdX4Vqdw12sWndoZo2zM1FNTlJqlfpxRMg7WE/uZBbuN86Bb0WDAm2
   FId5aoKkywTOZTsJgGc5heftsDnB8fPq3loNrVpUDhlikfP+W59so4AMC
   nCnk642AK1WU19x+N7lGnpErs7lVBf33u8PD1k6wGcze4SR+A3zoVMuRN
   J26J0faWpUmvu5EbpkoCHpSchO3an9SZHLtobYPVueYZBOCBIrhBFaPoB
   w==;
X-CSE-ConnectionGUID: WkBik4o/RKymkFv5HspaWQ==
X-CSE-MsgGUID: IxAghJFlQL2em1M4QOayjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11580"; a="66326743"
X-IronPort-AV: E=Sophos;i="6.19,224,1754982000"; 
   d="scan'208";a="66326743"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 00:11:21 -0700
X-CSE-ConnectionGUID: ZKVcirKKShuVpruUzj+HVg==
X-CSE-MsgGUID: mjOFIC6rSm+e4ojnOa/P2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,224,1754982000"; 
   d="scan'208";a="181951775"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa009.fm.intel.com with ESMTP; 13 Oct 2025 00:11:17 -0700
Date: Mon, 13 Oct 2025 15:33:22 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Zhao Liu <zhao1.liu@linux.intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v9 02/21] hw/core/machine: Support modules in -smp
Message-ID: <aOyrQl4WqqU0wVc4@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-3-zhao1.liu@linux.intel.com>
 <87plwgzzc4.fsf@pond.sub.org>
 <87jz14qp57.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jz14qp57.fsf@pond.sub.org>

On Thu, Oct 09, 2025 at 01:40:36PM +0200, Markus Armbruster wrote:
> Date: Thu, 09 Oct 2025 13:40:36 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [PATCH v9 02/21] hw/core/machine: Support modules in -smp
> 
> Markus Armbruster <armbru@redhat.com> writes:
> 
> > Zhao Liu <zhao1.liu@linux.intel.com> writes:
> >
> >> From: Zhao Liu <zhao1.liu@intel.com>
> >>
> >> Add "modules" parameter parsing support in -smp.
> >>
> >> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> >> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> >
> > QAPI schema
> > Acked-by: Markus Armbruster <armbru@redhat.com>
> 
> I missed something.  The patch added @modules without updating "The
> ordering from ...":
> 
>     ##
>     # @SMPConfiguration:
>     #
>     # Schema for CPU topology configuration.  A missing value lets QEMU
>     # figure out a suitable value based on the ones that are provided.
>     #
>     # The members other than @cpus and @maxcpus define a topology of
>     # containers.
>     #
> --> # The ordering from highest/coarsest to lowest/finest is: @drawers,
> --> # @books, @sockets, @dies, @clusters, @cores, @threads.
> 
> Where does it go in this list?
> 
> The order below suggests between @clusters and @modules.

Thanks Markus! I missed this case... sorry for that.

And you're right, @module is between @clusters and @modules.

I'll submit a patch to fix this doc!

Regards,
Zhao


