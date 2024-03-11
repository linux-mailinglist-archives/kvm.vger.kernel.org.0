Return-Path: <kvm+bounces-11508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1454877B80
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:05:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44E9B1F21964
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 08:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 909E110A29;
	Mon, 11 Mar 2024 08:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CAl6JkHd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC3010A12
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 08:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710144346; cv=none; b=XUhplHSIxOOJs48rtM8xrMpMW8WhDlOfOJ7MZRNWOTjOPx5W6qIjnBk49ugZREPivFrr5fV/CVTxEaar0PTZsHK4YGGV0CF5rY/HubobmZvse6RzDmsCC2deYYg5gWJVNqH23hKO4ctCjHjOSymrx8/Y2XLmPut9NgCvk5yVBXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710144346; c=relaxed/simple;
	bh=F/IuLV+s9yUiWzJMY+p2Y7SPDRn/5q14hfmZENra7ig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZY+28cUth9VA7+ii71GvL1/8L5e/4a64UTUA2HGM8LfyzWDKE4F1NIeI3YTBEtB9FS1Sfi6yLWsRVojE3tJrrcBqNQUX9y4PVjm44ZZ8zVj8chgVg0AZ24Rz0ayZuhneG1xsmLAAG4s/2cXuKe+V9CYLTDY9145cEKnOfxpWelY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CAl6JkHd; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710144345; x=1741680345;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F/IuLV+s9yUiWzJMY+p2Y7SPDRn/5q14hfmZENra7ig=;
  b=CAl6JkHdJPTB9QGNsZ07ggFq1xO/ANVUcvAhr2COQkA8n86/4JN03jFT
   8T6+dIu6qjPrg1q4187D0pJABjBYw221LrSouGBYf//YB2c/WtgLz5wlQ
   cP4Z09qTIRWc8ZWhlkUBJDPIUQf1dxm3n+9NxYwZ3U9wwYFozpOPA+uHx
   VYpMtRouTscoYkoLKa0f9BLQWKDgU3uRZxLKurt69QlQQp9Ik7guNYvJ5
   LfCJu85l/uoxFTCSobwGkMXMC+RFbfalqeBSomcDkw7l9ak2kulX1FC2G
   LBI+9FZjZAjw1zjFhDqrD8d4miNwMgSmoPqqyHbH3H2qY+cuiqvGqJgJo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="4716422"
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="4716422"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 01:05:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="15687880"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 11 Mar 2024 01:05:40 -0700
Date: Mon, 11 Mar 2024 16:19:28 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
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
	qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v9 09/21] i386/cpu: Introduce bitmap to cache available
 CPU topology levels
Message-ID: <Ze6+kCvWklX8JxSE@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-10-zhao1.liu@linux.intel.com>
 <770fe9ab-c9cc-4062-b841-180036a3d050@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <770fe9ab-c9cc-4062-b841-180036a3d050@intel.com>

On Mon, Mar 11, 2024 at 02:28:17PM +0800, Xiaoyao Li wrote:
> Date: Mon, 11 Mar 2024 14:28:17 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v9 09/21] i386/cpu: Introduce bitmap to cache available
>  CPU topology levels
> 
> On 2/27/2024 6:32 PM, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > Currently, QEMU checks the specify number of topology domains to detect
> > if there's extended topology levels (e.g., checking nr_dies).
> > 
> > With this bitmap, the extended CPU topology (the levels other than SMT,
> > core and package) could be easier to detect without touching the
> > topology details.
> > 
> > This is also in preparation for the follow-up to decouple CPUID[0x1F]
> > subleaf with specific topology level.
> > 
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Thanks for your review! 

Regrads,
Zhao


