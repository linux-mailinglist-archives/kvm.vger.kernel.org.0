Return-Path: <kvm+bounces-18175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CAF58CFDE2
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 12:09:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFF35B22BDB
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 10:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4961813AA5F;
	Mon, 27 May 2024 10:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S1A8kgmV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12AC8830
	for <kvm@vger.kernel.org>; Mon, 27 May 2024 10:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716804583; cv=none; b=hFvWB4nCS+TnFgR7G6JRrcSaoo207z3WT7GEeMCWyJM5f2dHGwjQ9BdqScRLLCWc/2XVEIm17dpcCvkzDpDRdiPm7wK0QuFRyjbk7ejRn33ZWaDX8NcR1+m7/Hj1NfWyyqgJMcYwkvU193a9IXKj3OW56HE4rGOXz+6IRLIOfKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716804583; c=relaxed/simple;
	bh=5J8dHaMU3LQO+Etnmc1tE5Tep1M6eKHy+YAZCgxJqxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C9pSJP1IYYdDoIIuXcZdZ/YPCivnfp6xlcxyLEYBKZ0vJS2eQUMqufexMfVNVn2Z0ohtN0usIEUa8sr3BwwdgokA3cZfxbxgHanq6p44YH4Whqujf0Ej9OEMeBqzh/ix8Kq0wgQZMCgFFkOnpl60sUXW2izdwgB3XdAT5QzaRtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S1A8kgmV; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716804582; x=1748340582;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5J8dHaMU3LQO+Etnmc1tE5Tep1M6eKHy+YAZCgxJqxA=;
  b=S1A8kgmVGhw2zC1IuGodIVFZp3d312oBg/0iAv1PH4eFQ5oZ4Fvmzt66
   CCSgWNaKuuXktzd9xMCh33VTaHIXYPtMWWnyXYVXpgFbngCZlXy4EXHWx
   AmGzuTpIoFBCKdF8ypm+tNrEWC/h6AxHCEUqTYe1CdFHciaT8UicO9cj8
   iiT5IijCrGfEULT/Ut9zTRDRoLyDOVe/njraAZPGVjvsqJuw7Tqj95k+p
   n4XS1jTaoe6rk2raGeLpI2yHFfeQlHvPmpY81RiW8HmPNorG7mqhymHMa
   uDBV78jxLzvD93HxahGuCK9tLYKLBiTiXJAh9Bvf/5BkBTUMESa2JDSmn
   A==;
X-CSE-ConnectionGUID: F71jyVFERAOt7nj/Oj33/A==
X-CSE-MsgGUID: qU/DEyYESNq8wtBJEkyXaA==
X-IronPort-AV: E=McAfee;i="6600,9927,11084"; a="30625312"
X-IronPort-AV: E=Sophos;i="6.08,192,1712646000"; 
   d="scan'208";a="30625312"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2024 03:09:36 -0700
X-CSE-ConnectionGUID: M48rnGhUScyrvvdsO0jQuA==
X-CSE-MsgGUID: M+HxXaNOQ9KGLkbl3BaYaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,192,1712646000"; 
   d="scan'208";a="35324709"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 27 May 2024 03:09:21 -0700
Date: Mon, 27 May 2024 18:24:43 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [PATCH v9] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Message-ID: <ZlRfawZPkuAZCtIy@intel.com>
References: <20240409024940.180107-1-shahuang@redhat.com>
 <Zh1j9b92UGPzr1-a@redhat.com>
 <Zjyb43JqMZA+bO4r@intel.com>
 <ZjyZ1ZV7BGME_bY9@redhat.com>
 <ZkG4nlwRnvz9oUXX@intel.com>
 <d3733e25-eb1e-4c19-b77f-d68e871c9f0f@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3733e25-eb1e-4c19-b77f-d68e871c9f0f@redhat.com>

On Mon, May 27, 2024 at 02:41:01PM +0800, Shaoqin Huang wrote:
> Date: Mon, 27 May 2024 14:41:01 +0800
> From: Shaoqin Huang <shahuang@redhat.com>
> Subject: Re: [PATCH v9] arm/kvm: Enable support for
>  KVM_ARM_VCPU_PMU_V3_FILTER
> 
> Hi Zhao,
> 
> Thanks for your proposed idea. If you are willing to take the PMU Filter
> Enabling work, you can do it. I won't update this series anymore due to the
> QAPI restriction. I really appreciate if you can implement that.
>

Welcome Shaoqin, I'll cc you when I'm done with the first version (it'll
take some time).

There are also some issues that I might take up and revisit, such as
whether to place the kvm-pmu-filter in -cpu or in -kvm.

Anyway, hopefully eventually we can implement this feature for QEMU and
users can benefit from it!

Thanks,
Zhao


