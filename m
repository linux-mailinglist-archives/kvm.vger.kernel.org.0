Return-Path: <kvm+bounces-34373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA35D9FC36A
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2024 03:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 649041654F6
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2024 02:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 964C1200A0;
	Wed, 25 Dec 2024 02:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lDowklVD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453AC632
	for <kvm@vger.kernel.org>; Wed, 25 Dec 2024 02:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735095463; cv=none; b=lXRBZBUQE8z5IdZjgVE5lFjzJ1LL9KEeeJU+BPvJb9ScJJfMXBszDJGS/IgTcJU7wmIyd4iLrSGqXXfrRmv9oOUxy9QCRBllRg44rrs2W6Dsa6qwTkJhgicjaJEIxk1emYjPjjuILFxR9GvCtU18OG7dvAxq4iaOqnXeHwXrTPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735095463; c=relaxed/simple;
	bh=9A/iqk1plgz2s/gWjaqcCmE2nOGsWYjIqYnHAEJG6IU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q+gL74SOzrwNDFih+XFKDnR4HC3p1fnGA3m5JGAqC0u37cvFIWRVJUJN3h0bAyeKrvPH2bxF7ljiQ5EBikqeI0leutugDtcrozLnlXT1ulHlmr6abrfuZyvNqWgJl6dloiIC/T2bAZoYqA+6Is9WrkCUdDxeefRmj7OgMmyqjI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lDowklVD; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735095462; x=1766631462;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9A/iqk1plgz2s/gWjaqcCmE2nOGsWYjIqYnHAEJG6IU=;
  b=lDowklVD+KtnQ86lOmJYssDDbnTjM/oRYzbFHGFLCQHsUauN262jaoxk
   PYHT4JpNJ6sC09JLLDx1gyTx0LbDpCRNnfMuda1hfQeE4tP+1Q33g2tPg
   /6hZQe44Og78b+CGxHC9ahqlMDXY6j4M8PLIdBjRNRnZgmzuzzvTnY8ZT
   MKonwSfdp8gRw7xkJAbL8O4/KzkCGDPw14nMORmcbfWqASunaBshbuxNW
   0VboUxVRQKSobvMqtGn3l8yWRB/7FSZAHF8i3DoVo27uE5xpH0GvyFw1N
   iCrx+aQ8SlFhzlZzHCF+5TdkGE4HnZsy8FYJciyDMoxPQeQLnzCh17GlD
   A==;
X-CSE-ConnectionGUID: rjTr9DqASouOGkD9knRADw==
X-CSE-MsgGUID: ACBUVWQkTYenWDNYQIBzqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11296"; a="34830115"
X-IronPort-AV: E=Sophos;i="6.12,262,1728975600"; 
   d="scan'208";a="34830115"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2024 18:57:39 -0800
X-CSE-ConnectionGUID: 5lcW9VqiSXefn+HpcsTR3g==
X-CSE-MsgGUID: vAD5X8TETTaJz3x1DgAQRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103713460"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa003.fm.intel.com with ESMTP; 24 Dec 2024 18:57:36 -0800
Date: Wed, 25 Dec 2024 11:16:19 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Tao Su <tao1.su@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v5 11/11] target/i386/kvm: Replace
 ARRAY_SIZE(msr_handlers) with KVM_MSR_FILTER_MAX_RANGES
Message-ID: <Z2t5AxDxRvQ1sIO8@intel.com>
References: <20241106030728.553238-1-zhao1.liu@intel.com>
 <20241106030728.553238-12-zhao1.liu@intel.com>
 <5463356b-827f-4c9f-a76e-02cd580fe885@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5463356b-827f-4c9f-a76e-02cd580fe885@redhat.com>

On Tue, Dec 24, 2024 at 04:54:41PM +0100, Paolo Bonzini wrote:
> Date: Tue, 24 Dec 2024 16:54:41 +0100
> From: Paolo Bonzini <pbonzini@redhat.com>
> Subject: Re: [PATCH v5 11/11] target/i386/kvm: Replace
>  ARRAY_SIZE(msr_handlers) with KVM_MSR_FILTER_MAX_RANGES
> 
> On 11/6/24 04:07, Zhao Liu wrote:
> > kvm_install_msr_filters() uses KVM_MSR_FILTER_MAX_RANGES as the bound
> > when traversing msr_handlers[], while other places still compute the
> > size by ARRAY_SIZE(msr_handlers).
> > 
> > In fact, msr_handlers[] is an array with the fixed size
> > KVM_MSR_FILTER_MAX_RANGES, so there is no difference between the two
> > ways.
> > 
> > For the code consistency and to avoid additional computational overhead,
> > use KVM_MSR_FILTER_MAX_RANGES instead of ARRAY_SIZE(msr_handlers).
> 
> I agree with the consistency but I'd go the other direction.
>

OK, I'll switch to the other way.

Thanks,
Zhao


