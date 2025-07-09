Return-Path: <kvm+bounces-51879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C9EEAFE010
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:41:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5AFE97AE58A
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 06:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E0D26C393;
	Wed,  9 Jul 2025 06:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k6q9S1b0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B18126B2D7;
	Wed,  9 Jul 2025 06:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752043255; cv=none; b=lDw6+y4EH/aWh9L7e4epLOQg4v9poayyQ+duj+1BDZ+38pq8myzeuLX6IGYudoz/LQ3i34pd+tVACNDWKe1upqP8kX5Ed53Ptn7Oaj1+pak2axV1a74vHcona73xhOSCjmwBwStNNMhfgfBgddNxTEeYfH8hQeKfkPbMlgr89/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752043255; c=relaxed/simple;
	bh=A60mkx3Y5hsCHKpYmi2pKKiC91EnkELTL/wVOKJV8S8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fsd0V6JyG7tESv2HqtIh7vAWkew3VsD/7a3wWTpOfmcH+w5kf/87PtRcECTBRWQ6IhLZb+0XZ/TW3KsLIhiaxF/isTeuxSCnEAcVbjjaBF/DIHTjxnWezkzCWhUyYYnQJILRr2Yhsi0Tf2xq0CMbGFD8xgdiVl6MhuIo8rKCdVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k6q9S1b0; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752043254; x=1783579254;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=A60mkx3Y5hsCHKpYmi2pKKiC91EnkELTL/wVOKJV8S8=;
  b=k6q9S1b0eDbWsIYatHouVYielxyLlFMxFvhKQVo2K+qzIBtMMJdK3oid
   yg6uBpdDfDoDF8+WiG9G243+XNwyt9LUusyUrMYbK/WskUwGcHPR5jib9
   axVBqMjfOH4plkO/f88gn8KbzrPxYh3ecZURAYCm+jsDdCA/qCOuFzUWP
   ibBAR/FJGnxQ2wSNg2nFEycrtggU+NRuUYyvU4Dwc6moVlqBQ3ZTLpN4J
   YIYZMc1UxDVlqGBnFVi4Vjb0Xs1omOjc+QMT5VqYHX9LPklNwMO7ajArS
   fT3ni7wlYeqjhKFqd8Fm3+NrY0H3/I0OyFxIexC7iwD17FtWtzHdvytwN
   Q==;
X-CSE-ConnectionGUID: MRgNHLxeTeKLFy0f+OhSIA==
X-CSE-MsgGUID: ZwKurisPQe6XWiLuPDPusA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="41914975"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="41914975"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 23:40:53 -0700
X-CSE-ConnectionGUID: kIi/t9oaSPuU1kBd2ihhHA==
X-CSE-MsgGUID: ewMJn9f+ThWLi68O9tOfcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="159962867"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 23:40:50 -0700
Message-ID: <5335d070-1489-4e85-804b-b063bfda3f47@intel.com>
Date: Wed, 9 Jul 2025 14:40:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU
 has been created
To: Kai Huang <kai.huang@intel.com>, seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, thomas.lendacky@amd.com, nikunj@amd.com,
 bp@alien8.de, isaku.yamahata@intel.com, rick.p.edgecombe@intel.com,
 linux-kernel@vger.kernel.org
References: <cover.1752038725.git.kai.huang@intel.com>
 <1eaa9ba08d383a7db785491a9bdf667e780a76cc.1752038726.git.kai.huang@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <1eaa9ba08d383a7db785491a9bdf667e780a76cc.1752038726.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/2025 1:38 PM, Kai Huang wrote:
> Reject the KVM_SET_TSC_KHZ VM ioctl when there's vCPU has already been
> created.
> 
> The VM scope KVM_SET_TSC_KHZ ioctl is used to set up the default TSC
> frequency that all subsequent created vCPUs use.  It is only intended to
> be called before any vCPU is created.  Allowing it to be called after
> that only results in confusion but nothing good.
> 
> Note this is an ABI change.  But currently in Qemu (the de facto
> userspace VMM) only TDX uses this VM ioctl, and it is only called once
> before creating any vCPU, therefore the risk of breaking userspace is
> pretty low.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/x86.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 699ca5e74bba..e5e55d549468 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7194,6 +7194,10 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>   		u32 user_tsc_khz;
>   
>   		r = -EINVAL;
> +
> +		if (kvm->created_vcpus)
> +			goto out;
> +
>   		user_tsc_khz = (u32)arg;
>   
>   		if (kvm_caps.has_tsc_control &&


