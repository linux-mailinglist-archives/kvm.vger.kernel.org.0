Return-Path: <kvm+bounces-48940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A95E0AD4809
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 03:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9420717DA4B
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC67181ACA;
	Wed, 11 Jun 2025 01:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N9YiNPQv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B57A4685;
	Wed, 11 Jun 2025 01:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749605873; cv=none; b=DOnl7fskH6tHQC7xAIF2+eh/puxyMaPDgdqIedovZJhXGNKHvW79BS68Pj6jaOM5QQz54KMJ6qxO7Fo4Ra0lWOkH9tIbflhlpMEaIpBilIEWFTGfIhMJ+U4lBUFpPrkBIOKw9LxXqtTaC1NV0aMg5SvcnPKkuNF+zIUaVrzqM1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749605873; c=relaxed/simple;
	bh=ySBIz6b+AevIn4XXj1S6nfSdPvS3hHtJOf0Uu8vKYPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A8E0SFvckyaxAdjqP/NXKcae2cqPWMvGne/U+4qZ0cb4Dajtl6QmxC8H02vEBKAsUAe1LGU3cwRx7MPj6ic57PKrzqTq+phNc1bxYCqCsElNJLCM/aSUYE9Vr72RJP3HTyGlaP4YkwgRvPLmsDfxhPLIxwo2Uyh46W4iN1XwCZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N9YiNPQv; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749605871; x=1781141871;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ySBIz6b+AevIn4XXj1S6nfSdPvS3hHtJOf0Uu8vKYPI=;
  b=N9YiNPQv8mFOTVM3auqCRYZYhSrM8SS+ZA5XOewkWY43oqQP2P2gdEE8
   z0Ujl+sq5IRGVEI0uOBgorKWQgdx37S5z/fNNhJhnTrhYIjshWHIsvhtu
   FQajQZlW9EKunRMahPMp4OjRtP3AkQIvbr/cpzorOTMO3e/UQ/NKqytur
   HlBmn2x/PxF/mscinoBK1u9sF0wl//zV3a4y0b15HtoUhUWp8+6c2Cb4l
   ViVaKA0ppR9cAWavf+dnzVye7dzV2cJkox/JvDYg+eY6XqB/oZrUZTzmg
   EJuojD1skMu2jOrpkDYjVCjfqs9QqC1x5kqB0JlxfUXLldXmpoUuE3nS9
   Q==;
X-CSE-ConnectionGUID: rYElw3QYTpmIqkV5mqpXuA==
X-CSE-MsgGUID: Mw31z7vbShq9DjkLuFSX2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="62772240"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="62772240"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 18:37:50 -0700
X-CSE-ConnectionGUID: tI47WslSQxW58SsX+uvsBg==
X-CSE-MsgGUID: XuMszIcAQWKlYt0mKb0M7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="146915458"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 18:37:47 -0700
Message-ID: <671f2439-1101-4729-b206-4f328dc2d319@linux.intel.com>
Date: Wed, 11 Jun 2025 09:37:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
To: Xiaoyao Li <xiaoyao.li@intel.com>, rick.p.edgecombe@intel.com,
 pbonzini@redhat.com, seanjc@google.com
Cc: kvm@vger.kernel.org, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com,
 mikko.ylinen@linux.intel.com, linux-kernel@vger.kernel.org,
 kirill.shutemov@intel.com, jiewen.yao@intel.com
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/10/2025 5:16 PM, Xiaoyao Li wrote:
> On 6/10/2025 10:14 AM, Binbin Wu wrote:
>> Exit to userspace for TDG.VP.VMCALL<GetTdVmCallInfo> via a new KVM exit
>> reason to allow userspace to provide information about the support of
>> TDVMCALLs when r12 is 1 for the TDVMCALLs beyond the GHCI base API.
>>
>> GHCI spec defines the GHCI base TDVMCALLs: <GetTdVmCallInfo>, <MapGPA>,
>> <ReportFatalError>, <Instruction.CPUID>, <#VE.RequestMMIO>,
>> <Instruction.HLT>, <Instruction.IO>, <Instruction.RDMSR> and
>> <Instruction.WRMSR>. They must be supported by VMM to support TDX guests.
>>
>> For GetTdVmCallInfo
>> - When leaf (r12) to enumerate TDVMCALL functionality is set to 0,
>>    successful execution indicates all GHCI base TDVMCALLs listed above are
>>    supported.
>>
>>    Update the KVM TDX document with the set of the GHCI base APIs.
>>
>> - When leaf (r12) to enumerate TDVMCALL functionality is set to 1, it
>>    indicates the TDX guest is querying the supported TDVMCALLs beyond
>>    the GHCI base TDVMCALLs.
>>    Exit to userspace to let userspace set the TDVMCALL sub-function bit(s)
>>    accordingly to the leaf outputs.  KVM could set the TDVMCALL bit(s)
>>    supported by itself when the TDVMCALLs don't need support from userspace
>>    after returning from userspace and before entering guest. Currently, no
>>    such TDVMCALLs implemented, KVM just sets the values returned from
>>    userspace.
>>
>>    A new KVM exit reason KVM_EXIT_TDX_GET_TDVMCALL_INFO and its structure
>>    are added. Userspace is required to handle the exit reason as the initial
>>    support for TDX.
>
> It doesn't look like a good and correct design.
>
> Consider the case that userspace supports SetupEventNotifyInterrupt and returns bit 1 of leaf_output[0] as 1 to KVM, and KVM returns it to TD guest for TDVMCALL_GET_TD_VM_CALL_INFO. So TD guest treats it as SetupEventNotifyInterrupt is support. But when TD guest issues this TDVMCALL, KVM doesn't support the exit to userspace for this specific leaf and userspace doesn't have chance to handle it.
Previously, I also had the idea of setting the information based on userspace's
opt-ins.

But for simplicity, this patch set doesn't adopt the opt-in mechanism for KVM
exit reasons due to TDVMCALLs.

To resolve the issue you mentions that userspace could set a bit that KVM
doesn't support the exit to userspace, KVM could mask off the bit(s) not
supported by KVM before returning back to guest.

If we agree that it's the right time to have the opt-in, we could go the opt-in
way and KVM could set the information based on userspace's opt-ins without
exit to userspace for GetTdVmCallInfo.



