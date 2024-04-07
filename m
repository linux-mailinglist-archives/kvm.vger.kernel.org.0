Return-Path: <kvm+bounces-13821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A292E89AE34
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 05:15:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D18F281860
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 03:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 325083D8E;
	Sun,  7 Apr 2024 03:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mv/aHHc3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04AB1C0DC4;
	Sun,  7 Apr 2024 03:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712459711; cv=none; b=aBRttfE2CgxJAo4WPm9iEFGP2nZSTA+eXkwKuzmdtxgtmrNRhVDAEMBMe4XVW7UQO8bOHOW4g5QUoE2FKB5Vfq5XrkcVxfwVekOMAnHhxvj4NVS9VRMIxU3sT7UCoeRo3bwR1xlsId4b610Yn9qMgJrKZWI8SHUBvHw5EoqhWBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712459711; c=relaxed/simple;
	bh=r3JuVzAk/fRJNjqmWx+17Xruq3cO3C1gGe9eOroRQSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ey8wDjqlBwTAkPFTNZ8HjKLTbCwuQ/Vt8f9IOHBONu3Io7YHo61idNBiDBKf0ER2G/gLsHZgvtJue3eUzaj47d7asNO+iz5JZQlyqJS55MnLN/yIa7x6kt7PZ5GV9F+GWkxgpwmSLRLa/O5YuVEO7R6FPICPpN0h7ditIrNOClU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mv/aHHc3; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712459709; x=1743995709;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r3JuVzAk/fRJNjqmWx+17Xruq3cO3C1gGe9eOroRQSE=;
  b=Mv/aHHc3k3XUM7ecNASCWcnzGe8+sZhk4Ip0tXdpClfR4OEUpjraqsGX
   /+6+bI4Gg74aplTP6OdBpGQiaG80oVyHYMomz1E3J6LkfSjxXMtbd7+5I
   px8XrKcH6fWhH2L29RTjTcZK6EEN7VtHyMhIFq+07UgTyrI2Bwwy6eEyI
   Cu7w2HBojivCoqRJ/w+NECZv0TrzK5h4shTq5Tyot4xanO4zBP19CSHhU
   4uk7Td70t1aOBrG1iGUPZnOCrv5hJM3/uxenR53zbHVUR58zfU/1ksimC
   fMFbQXy1nLP6tZH7eBtgh25dQm0/sSp50YCVnlv+eTfQwOmxDNiN2DJMn
   g==;
X-CSE-ConnectionGUID: yf5Xfl4nQwWNFaDPRSq4tA==
X-CSE-MsgGUID: EyAXQwjjRL+0xyl9/j0KiA==
X-IronPort-AV: E=McAfee;i="6600,9927,11036"; a="11529308"
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="11529308"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 20:15:08 -0700
X-CSE-ConnectionGUID: dZ+8LFG5SlGxTiW4ut/f6Q==
X-CSE-MsgGUID: cRFk8vZXRkaO+gbodGeSbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="57014381"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 20:15:05 -0700
Message-ID: <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
Date: Sun, 7 Apr 2024 11:15:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Wei W Wang
 <wei.w.wang@intel.com>, David Skidmore <davidskidmore@google.com>,
 Steve Rutherford <srutherford@google.com>,
 Pankaj Gupta <pankaj.gupta@amd.com>
References: <20240405165844.1018872-1-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240405165844.1018872-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/6/2024 12:58 AM, Sean Christopherson wrote:
>   - For guest MAXPHYADDR vs. GPAW, rely on KVM_GET_SUPPORTED_CPUID to enumerate
>     the usable MAXPHYADDR[2], and simply refuse to enable TDX if the TDX Module
>     isn't compatible.  Specifically, if MAXPHYADDR=52, 5-level paging is enabled,
>     but the TDX-Module only allows GPAW=0, i.e. only supports 4-level paging.

So userspace can get supported GPAW from usable MAXPHYADDR, i.e.,
CPUID(0X8000_0008).eaxx[23:16] of KVM_GET_SUPPORTED_CPUID:
  - if usable MAXPHYADDR == 52, supported GPAW is 0 and 1.
  - if usable MAXPHYADDR <= 48, supported GPAW is only 0.

There is another thing needs to be discussed. How does userspace 
configure GPAW for TD guest?

Currently, KVM uses CPUID(0x8000_0008).EAX[7:0] in struct 
kvm_tdx_init_vm::cpuid.entries[] of IOCTL(KVM_TDX_INIT_VM) to deduce the 
GPAW:

	int maxpa = 36;
	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x80000008, 0);
	if (entry)
		max_pa = entry->eax & 0xff;

	...
	if (!cpu_has_vmx_ept_5levels() && max_pa > 48)
		return -EINVAL;
	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
		td_params->eptp_controls |= VMX_EPTP_PWL_5;
		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
	} else {
		td_params->eptp_controls |= VMX_EPTP_PWL_4;
	}

The code implies that KVM allows the provided 
CPUID(0x8000_0008).EAX[7:0] to be any value (when 5level ept is 
supported). when it > 48, configure GPAW of TD to 1, otherwise to 0.

However, the virtual value of CPUID(0x8000_0008).EAX[7:0] inside TD is 
always the native value of hardware (for current TDX).

So if we want to keep this behavior, we need to document it somewhere 
that CPUID(0x8000_0008).EAX[7:0] in struct 
kvm_tdx_init_vm::cpuid.entries[] of IOCTL(KVM_TDX_INIT_VM) is only for 
configuring GPAW, not for userspace to configure virtual CPUID value for 
TD VMs.

Another option is that, KVM doesn't allow userspace to configure 
CPUID(0x8000_0008).EAX[7:0]. Instead, it provides a gpaw field in struct 
kvm_tdx_init_vm for userspace to configure directly.

What do you prefer?

> [1]https://drive.google.com/corp/drive/folders/1hm_ITeuB6DjT7dNd-6Ezybio4tRRQOlC
> [2]https://lore.kernel.org/all/20240313125844.912415-1-kraxel@redhat.com


