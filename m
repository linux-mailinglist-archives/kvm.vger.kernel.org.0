Return-Path: <kvm+bounces-11477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B722487771A
	for <lists+kvm@lfdr.de>; Sun, 10 Mar 2024 14:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E958B1C2108F
	for <lists+kvm@lfdr.de>; Sun, 10 Mar 2024 13:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC877383A0;
	Sun, 10 Mar 2024 13:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Is6mzff7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901EC364BC
	for <kvm@vger.kernel.org>; Sun, 10 Mar 2024 13:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710077427; cv=none; b=WNU512qW/5EE4r8zQ3hoJXTaaeNkIEoR/k3gNogSq9aaup8kQWnZ8dD2shr7fueFB8C+hBdwm+XohAljAes+wye3d2Ws9wHnGTSGzUdpsFjuvRu0mxbJMxnnphmFJHf7E3bgMMgGWJdX4WvMrFbLEtc2RlhzSrfUQ5dyA7iFufE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710077427; c=relaxed/simple;
	bh=T3AsQLCTzlvB6x76yxRW5FOo6r7+SB2qVULan5I1YpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qspbWIl1M9laoOuq8qv48PIZAg3LHAtio8hl0GwjYi5JQV0RgKTv7jU6tv/g35vNWEUlzbSMe48UmL1i6xSZyjhfWD9rw/XL1+GhbSOoMCdnafuY7CoL8iEV/8TOnIgDfixYSqb8cVtI1wBh0z1wj77EAzcAM1N4zF8HxbyEW38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Is6mzff7; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710077426; x=1741613426;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T3AsQLCTzlvB6x76yxRW5FOo6r7+SB2qVULan5I1YpQ=;
  b=Is6mzff7zsyiYO3JwJ9ul5E4QkBqgC9hAJ10U6oXUKqRLojPsrdn7p86
   0spBfAs3aLGtxa4+EfuXkNHk+Lb+Rw5RFRQRRaTVCLZ3m1NS1CjeVPgDx
   Oloc8Qby5wuoRkrWAi1TUYIOsL4UGy3wpOCgmzM8sqH7p/5o1xf3dzQTL
   PhAaOojOnZhnvWVfBP9vfkHqUiavZ3jSapPy53rqmN/BNxvbWcGnjrvjn
   pNgWR/HzZ2z13nuuMjbUafSkqqZJ015xJhMYO0Yl1tnyrL2uaji1D7md2
   4n60ctJAPIszfq6rrtypjJIfZpOsvTibG8KdsdigIhy6/jaGGgLAq2bs/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11008"; a="4670917"
X-IronPort-AV: E=Sophos;i="6.07,114,1708416000"; 
   d="scan'208";a="4670917"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 06:30:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,114,1708416000"; 
   d="scan'208";a="41898789"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 10 Mar 2024 06:30:20 -0700
Date: Sun, 10 Mar 2024 21:44:08 +0800
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
	Zhao Liu <zhao1.liu@intel.com>,
	Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH v9 08/21] i386/cpu: Consolidate the use of topo_info in
 cpu_x86_cpuid()
Message-ID: <Ze25KAEvahnO2oGF@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-9-zhao1.liu@linux.intel.com>
 <89ed09f2-c139-46b1-b76a-8fa3522cc1ed@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89ed09f2-c139-46b1-b76a-8fa3522cc1ed@intel.com>

Hi Xiaoyao,

On Sat, Mar 09, 2024 at 09:48:34PM +0800, Xiaoyao Li wrote:
> Date: Sat, 9 Mar 2024 21:48:34 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v9 08/21] i386/cpu: Consolidate the use of topo_info in
>  cpu_x86_cpuid()
> 
> On 2/27/2024 6:32 PM, Zhao Liu wrote:
> > From: Zhao Liu<zhao1.liu@intel.com>
> > 
> > In cpu_x86_cpuid(), there are many variables in representing the cpu
> > topology, e.g., topo_info, cs->nr_cores and cs->nr_threads.
> > 
> > Since the names of cs->nr_cores/cs->nr_threads does not accurately
> 
> Again as in v7, please changes to "cs->nr_cores and cs->nr_threads",
> 
> "cs->nr_cores/cs->nr_threads" looks like a single variable of division
> 

I missed to change this.

Though, TBH, legitimate division operations are going to add spaces
around "/". It's also common practice to represent "or" by "/" w/t
spaces. But I'll change it in the next version to make you happy!

Thanks,
Zhao


