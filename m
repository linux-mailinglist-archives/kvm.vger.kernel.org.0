Return-Path: <kvm+bounces-10434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D3A86C1C8
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:19:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A5051F24C61
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BC332E415;
	Thu, 29 Feb 2024 07:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bC7kzl6C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5786644C94
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 07:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709191133; cv=none; b=M+/HWtLGCAsQwAZX35RDEPC1cM8m7wOc5q3G26nOXGOu4k25LoBghzC3yAzBLAagvWMuW3mdFIMajURKM0LBOwZuMu7+z2FxBoXsH2PpcNqYQ1bze3QOkNQq1RNP8SA4J5MGqnqUihav7BQ9fG+7myjWEDS050sm1biiIqIwy2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709191133; c=relaxed/simple;
	bh=FksyTE5xE6utTs6Z84kouzUz1HB+0g/sw29I3SdVZBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B9TM+9/Es6PB4oLsIAkJWOBNHwjLVyFkG/RngfE4jJjVeWniEeIZL0OgDk3XYEG74tJe4nrRZy1BHuokxik0XXqbdSYFucNAuJk/e3i8LZPTy05pftCUae7VTq0fdhucrXHAtbpAIlJYX3FDeVhaZ12idI3TQVpSJcEatLcvQVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bC7kzl6C; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709191131; x=1740727131;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FksyTE5xE6utTs6Z84kouzUz1HB+0g/sw29I3SdVZBo=;
  b=bC7kzl6CMUpHZvKyGMO90AEYx+DRBfQlGE5qayIG3Go0dZ6y1RRPBTdM
   BdFO/6PSNe2420GR7E2aSjS8eMzwTgSK81yCdhGYDP2DQ+EVIaj2z8UrH
   g9ZvMteGv5607nKHLuVW3y+PCyzcJIfoPbFIY7QdHB1N3/eWFeJLhYVK6
   oyx2epkdcOTGL5VjbeSIiexdEYmHMpYxdI2kcrdI8E33G9Cs9S8SPLe2c
   2YI9qVn8frdGpId051OE1IJeqoGj2bOmPIC0uyfO3RVZmcmYY+KQ3vy8r
   fHM6qcvH6YcNjnLQqIMHLsmmXG5t+sySmh25OkOy8umtpJlPle3or0uf3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3765925"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3765925"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 23:18:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="12422234"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa005.jf.intel.com with ESMTP; 28 Feb 2024 23:18:40 -0800
Date: Thu, 29 Feb 2024 15:32:23 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: "Moger, Babu" <babu.moger@amd.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v9 18/21] hw/i386/pc: Support smp.modules for x86 PC
 machine
Message-ID: <ZeAzB/ISM+g/XGa3@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-19-zhao1.liu@linux.intel.com>
 <3ab53ea9-be77-4ee7-9247-d89c0ec62346@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ab53ea9-be77-4ee7-9247-d89c0ec62346@amd.com>

Hi Babu,

> >  DEF("smp", HAS_ARG, QEMU_OPTION_smp,
> >      "-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets]\n"

Here the "drawers" and "books" are listed...

> > -    "               [,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"
> > +    "               [,dies=dies][,clusters=clusters][,modules=modules][,cores=cores]\n"
> > +    "               [,threads=threads]\n"
> >      "                set the number of initial CPUs to 'n' [default=1]\n"
> >      "                maxcpus= maximum number of total CPUs, including\n"
> >      "                offline CPUs for hotplug, etc\n"
> > @@ -290,7 +291,8 @@ DEF("smp", HAS_ARG, QEMU_OPTION_smp,
> >      "                sockets= number of sockets in one book\n"
> >      "                dies= number of dies in one socket\n"
> >      "                clusters= number of clusters in one die\n"
> > -    "                cores= number of cores in one cluster\n"
> > +    "                modules= number of modules in one cluster\n"
> > +    "                cores= number of cores in one module\n"
> >      "                threads= number of threads in one core\n"
> >      "Note: Different machines may have different subsets of the CPU topology\n"
> >      "      parameters supported, so the actual meaning of the supported parameters\n"
> > @@ -306,7 +308,7 @@ DEF("smp", HAS_ARG, QEMU_OPTION_smp,
> >      "      must be set as 1 in the purpose of correct parsing.\n",
> >      QEMU_ARCH_ALL)
> >  SRST
> > -``-smp [[cpus=]n][,maxcpus=maxcpus][,sockets=sockets][,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]``
> > +``-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets][,dies=dies][,clusters=clusters][,modules=modules][,cores=cores][,threads=threads]``
> 
> You have added drawers, books here. Were they missing before?
> 

...so yes, I think those 2 parameters are missed at this place.

Thank you for reviewing this.

Regards,
Zhao


