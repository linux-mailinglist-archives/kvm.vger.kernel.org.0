Return-Path: <kvm+bounces-48957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1671CAD48C2
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 04:18:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4348A189E6A7
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 02:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC98917A2EE;
	Wed, 11 Jun 2025 02:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IvOBX4R1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B557EEA8;
	Wed, 11 Jun 2025 02:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749608283; cv=none; b=klv+qylV3R8O3Emg3cUhEkGDcPrB/7s2bOlKxbPN+goFOTdptwsS4iIirK78RkjwKk+5hghq436JeOircshw7C/65cl5owAQxFUtzXb0rJUovFWMASfLyK2mT5e9FsQplH4m+qRex7ek3+Kg28abHFmOo7VcEXBJNITJTi0YzZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749608283; c=relaxed/simple;
	bh=nlsM+8sEbyXEDvl2JW+7GpNSPVkWeolTmnKE44gtbXQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ud373nZLCFr3PH8I7f2OM28ckVJBuL1+ypuVOWoq9YZWf4T2yG9BhrJDWbXWm4cuPULlhBSIXBpaZgOgYDT5OnWK37oy9HByzDlIwj1FSO3JuZRhY+j7Vp1z81DmZoWXf3t1pgQoZ01e0k1OhxQvvNBMsa7B+KlvNHxFU/YTpEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IvOBX4R1; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749608281; x=1781144281;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nlsM+8sEbyXEDvl2JW+7GpNSPVkWeolTmnKE44gtbXQ=;
  b=IvOBX4R12QrrDPZpD9G3/GClgeuG6l4CCYsjluv55MssPwn0/5dxvGzW
   of3YCPGTE0ZahM3udMaNTHD++tD633UiPebCOIr8nrt/FKnXCPWt0LB2s
   T7PZCS6jrJcIngDJnlEoJENat/72w5mTLc5yhwobCeHuDQODu7KyeqTxB
   9ILgK4nnCMb1NXbYxWvdBE2TdPcCnLGvDDX+MD1rfIXpWSyt8g5piRt0h
   Z2uhVfAgdhICPpf0BDpGUjorsdwKBVFmwl4E1dVZQ9XEM932j6Jmrx2s+
   uassgJq1XFaoo472VEpqr6htL7NqNJUfc+4D0VPvi96OkSpmfrF1ZIddy
   A==;
X-CSE-ConnectionGUID: NUAeLOo1Tual47QNu1qQBw==
X-CSE-MsgGUID: 3Hs6Fq3ISXOu4Px8p1Kg1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51839487"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="51839487"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:18:01 -0700
X-CSE-ConnectionGUID: hnr0ZpFLSQm18fH1hUjmiQ==
X-CSE-MsgGUID: W+6kwMfGRomCDlSD+x5EcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="146921495"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:17:56 -0700
Message-ID: <7f17ca58-5522-45de-9dae-6a11b1041317@intel.com>
Date: Wed, 11 Jun 2025 10:17:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
To: Binbin Wu <binbin.wu@linux.intel.com>, rick.p.edgecombe@intel.com,
 pbonzini@redhat.com, seanjc@google.com
Cc: kvm@vger.kernel.org, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com,
 mikko.ylinen@linux.intel.com, linux-kernel@vger.kernel.org,
 kirill.shutemov@intel.com, jiewen.yao@intel.com
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
 <671f2439-1101-4729-b206-4f328dc2d319@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <671f2439-1101-4729-b206-4f328dc2d319@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/11/2025 9:37 AM, Binbin Wu wrote:
> 
> 
> On 6/10/2025 5:16 PM, Xiaoyao Li wrote:
>> On 6/10/2025 10:14 AM, Binbin Wu wrote:
>>> Exit to userspace for TDG.VP.VMCALL<GetTdVmCallInfo> via a new KVM exit
>>> reason to allow userspace to provide information about the support of
>>> TDVMCALLs when r12 is 1 for the TDVMCALLs beyond the GHCI base API.
>>>
>>> GHCI spec defines the GHCI base TDVMCALLs: <GetTdVmCallInfo>, <MapGPA>,
>>> <ReportFatalError>, <Instruction.CPUID>, <#VE.RequestMMIO>,
>>> <Instruction.HLT>, <Instruction.IO>, <Instruction.RDMSR> and
>>> <Instruction.WRMSR>. They must be supported by VMM to support TDX 
>>> guests.
>>>
>>> For GetTdVmCallInfo
>>> - When leaf (r12) to enumerate TDVMCALL functionality is set to 0,
>>>    successful execution indicates all GHCI base TDVMCALLs listed 
>>> above are
>>>    supported.
>>>
>>>    Update the KVM TDX document with the set of the GHCI base APIs.
>>>
>>> - When leaf (r12) to enumerate TDVMCALL functionality is set to 1, it
>>>    indicates the TDX guest is querying the supported TDVMCALLs beyond
>>>    the GHCI base TDVMCALLs.
>>>    Exit to userspace to let userspace set the TDVMCALL sub-function 
>>> bit(s)
>>>    accordingly to the leaf outputs.  KVM could set the TDVMCALL bit(s)
>>>    supported by itself when the TDVMCALLs don't need support from 
>>> userspace
>>>    after returning from userspace and before entering guest. 
>>> Currently, no
>>>    such TDVMCALLs implemented, KVM just sets the values returned from
>>>    userspace.
>>>
>>>    A new KVM exit reason KVM_EXIT_TDX_GET_TDVMCALL_INFO and its 
>>> structure
>>>    are added. Userspace is required to handle the exit reason as the 
>>> initial
>>>    support for TDX.
>>
>> It doesn't look like a good and correct design.
>>
>> Consider the case that userspace supports SetupEventNotifyInterrupt 
>> and returns bit 1 of leaf_output[0] as 1 to KVM, and KVM returns it to 
>> TD guest for TDVMCALL_GET_TD_VM_CALL_INFO. So TD guest treats it as 
>> SetupEventNotifyInterrupt is support. But when TD guest issues this 
>> TDVMCALL, KVM doesn't support the exit to userspace for this specific 
>> leaf and userspace doesn't have chance to handle it.
> Previously, I also had the idea of setting the information based on 
> userspace's
> opt-ins.
> 
> But for simplicity, this patch set doesn't adopt the opt-in mechanism 
> for KVM
> exit reasons due to TDVMCALLs.
> 
> To resolve the issue you mentions that userspace could set a bit that KVM
> doesn't support the exit to userspace, KVM could mask off the bit(s) not
> supported by KVM before returning back to guest.

silently mask off the value provided from userspace is not a stable ABI 
from userspace perspective. A kvm cap to report what value is 
allowed/supported is still helpful.

> If we agree that it's the right time to have the opt-in, we could go the 
> opt-in
> way and KVM could set the information based on userspace's opt-ins without
> exit to userspace for GetTdVmCallInfo.

Let's see what Paolo and Sean will say.


