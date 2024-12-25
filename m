Return-Path: <kvm+bounces-34372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9125C9FC367
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2024 03:55:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AC75165198
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2024 02:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 140AC200A0;
	Wed, 25 Dec 2024 02:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oALNnpdh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4757125D5
	for <kvm@vger.kernel.org>; Wed, 25 Dec 2024 02:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735095331; cv=none; b=C0CwbB4LifkLY9YC8kicxOLp4xWZLzheNcQLf5AAGLa6tkYXHBOGKfvlNN05ZGZEhggXIizMuDJyz1Q7gPkLiD+hf5wGrX3xLtYFWa0rUiZy7Cq2TjwU/n05tAk+ymhEHGkT9PxrM1FyZV+c+B9qDeReQcQUQfVO+i8o26RLnQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735095331; c=relaxed/simple;
	bh=AfZndZCwwqW8fGGdg4N+iydft+loycjq6e2Cmi6ZLNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bHK8z1jHyaWhOus0B0CUXtzhWIRe4AgYCRjmPurD0GRunAIx2YEqHy1C6ENuRestUjp6wQ60FSqLBVj//vFPmTHgWnpOsTHKZTjZdwUyeCA0ToPhDBB+jzxXLG7xWAIS83W+IMzOqieGXSyejBqyvcy5mXlYRQ541Gu/PNX8EBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oALNnpdh; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735095329; x=1766631329;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AfZndZCwwqW8fGGdg4N+iydft+loycjq6e2Cmi6ZLNc=;
  b=oALNnpdh+6QpgG+tD9cTUh08sx8p2MIfF7UEjQPMpVjC7eBwYlfpaRkr
   1238rMrZ066YRsvSJDsrnuxuiowj15K38s2mWMwnuxDT1asWgKXlmZVIW
   rINuebvXhl+gCGRvtE8Rts0LfZgQYvvKySWIjbDwQK4o+48lg3rQI4/TG
   SYE+0aQ8B/lGp89Xj0BcSmIiTx8+AyePRF6DzKpnbxfm+V0mXrQPeQFj+
   N4tuHxAMAHxNDbR/qXcW7/Eal28h+ia3gGB5O1HyFN/AO8g++kKzKdSys
   g1o0DXQHuMHZxiaZCom+Ysu3grkn/58oWb4SsoxfuieGSovfoARcIzJe5
   g==;
X-CSE-ConnectionGUID: aR5mwK64RXGZkwg7Ykhh7w==
X-CSE-MsgGUID: y88HrRhWSoSr3PGOzCxmeA==
X-IronPort-AV: E=McAfee;i="6700,10204,11296"; a="34829824"
X-IronPort-AV: E=Sophos;i="6.12,262,1728975600"; 
   d="scan'208";a="34829824"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2024 18:55:29 -0800
X-CSE-ConnectionGUID: Re400YvoSVakUHYQANkjHw==
X-CSE-MsgGUID: lz2Iy1CiSdyF96ned8+x0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103712908"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa003.fm.intel.com with ESMTP; 24 Dec 2024 18:55:26 -0800
Date: Wed, 25 Dec 2024 11:14:09 +0800
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
Subject: Re: [PATCH v5 10/11] target/i386/kvm: Clean up error handling in
 kvm_arch_init()
Message-ID: <Z2t4gSUU2ix1EKF1@intel.com>
References: <20241106030728.553238-1-zhao1.liu@intel.com>
 <20241106030728.553238-11-zhao1.liu@intel.com>
 <ff866f4c-766c-4637-ba73-bbbdd4b15a2c@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff866f4c-766c-4637-ba73-bbbdd4b15a2c@redhat.com>

On Tue, Dec 24, 2024 at 04:53:36PM +0100, Paolo Bonzini wrote:
> Date: Tue, 24 Dec 2024 16:53:36 +0100
> From: Paolo Bonzini <pbonzini@redhat.com>
> Subject: Re: [PATCH v5 10/11] target/i386/kvm: Clean up error handling in
>  kvm_arch_init()
> 
> On 11/6/24 04:07, Zhao Liu wrote:
> > Currently, there're following incorrect error handling cases in
> > kvm_arch_init():
> > * Missed to handle failure of kvm_get_supported_feature_msrs().
> > * Missed to return when kvm_vm_enable_disable_exits() fails.
> 
> At least in these two cases I think it was intentional to avoid hard
> failures.  It's probably not a very likely case and I think your patch is
> overall a good idea.

I have the idea to clean up the abort()/exit() in KVM and instead use
@errp to handle failure cases. However, this would be a big change, so
this patch only makes a small change, as a first step.

Thanks,
Zhao


