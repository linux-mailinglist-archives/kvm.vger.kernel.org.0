Return-Path: <kvm+bounces-48294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3D19ACC5C2
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 13:48:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6024E3A284D
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 11:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 873F022B8D5;
	Tue,  3 Jun 2025 11:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ECBeJHnO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3DA154425
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 11:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748951282; cv=none; b=iVusuxsk4KGw6Zf+Ay5ZPfhImXeDN944rVeva4hWPWmo+UneEjv7zOgiqEi6rXHbv/VM96CMFZB7CQHywlIW1SZGHGqQVp2pZd8mBRHnlEn2s2id1kSstAawzviZRVJrx4zCvQHPKCmnc5ywTRzj09Ande+vEyZMEMjuM5Qz5SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748951282; c=relaxed/simple;
	bh=wFPfWtNIqyhU8/iBwm/da5MNUTLhigsz8vAWZNDTGCU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=CQ5s6VszkbEjWRacfUQXErxEOAE6gOqn2cl7BFvZyNyp7O2QpcMobRY/Ncw/+UMA1Kvrrl8u7ZTdV4bAycO5na9UiBT0wQScYF+GQylO8x0aMnlrGoDq29hay41T1iNhHfpdBq3TLrxD+wkMDIAVXeXyJ/n0R0e18qQCtL1abg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ECBeJHnO; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748951281; x=1780487281;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=wFPfWtNIqyhU8/iBwm/da5MNUTLhigsz8vAWZNDTGCU=;
  b=ECBeJHnOoVa4/XPqueQxPLCqn0asX44jIb2HDK8jWvB7ofE1ciLMF0io
   2Av9dxAvO3pCOxR/b6fHWbY8dhrhQy2yk6AmdeMOEzDj5Z50me955Ukw4
   3eC7TbU1hY4CJ4wMF/xZwmhh88Rdzq17qY3OjFuWxQLADRh0dLb9WNCRH
   89KMo1dZgjMuV8o5oD9FnZeVcMpQGXWqO4hV2PD7xyd058gvBOvnFrWDJ
   BPv0Pg+w1+DHclLR3o0NVNBRYGDn6La6Ij7P7wrBwT23CQLqH5clUvYJv
   kNhbExvlo1lErTDdrZ8PTIPjGhanQF+TAgjum9drAHqX6x6al3f6ObONI
   g==;
X-CSE-ConnectionGUID: O8R2asqYSMiO6wRvh8+okw==
X-CSE-MsgGUID: uGZUccp2SG6qtQjFOKSULQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="51055869"
X-IronPort-AV: E=Sophos;i="6.16,206,1744095600"; 
   d="scan'208";a="51055869"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 04:48:00 -0700
X-CSE-ConnectionGUID: 3fuKTgmhQ2e6/yWCId+uqg==
X-CSE-MsgGUID: jGHfrD9oRYqkMGFllyW5GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,206,1744095600"; 
   d="scan'208";a="145794207"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 04:47:58 -0700
Message-ID: <cc2dc418-8e33-4c01-9b8a-beca0a376400@intel.com>
Date: Tue, 3 Jun 2025 19:47:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Prefault memory on page state change
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Michael Roth <michael.roth@amd.com>
References: <f5411c42340bd2f5c14972551edb4e959995e42b.1743193824.git.thomas.lendacky@amd.com>
 <4a757796-11c2-47f1-ae0d-335626e818fd@intel.com>
Content-Language: en-US
In-Reply-To: <4a757796-11c2-47f1-ae0d-335626e818fd@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/3/2025 3:41 PM, Xiaoyao Li wrote:
> On 3/29/2025 4:30 AM, Tom Lendacky wrote:
>> A page state change is typically followed by an access of the page(s) and
>> results in another VMEXIT in order to map the page into the nested page
>> table. Depending on the size of page state change request, this can
>> generate a number of additional VMEXITs. For example, under SNP, when
>> Linux is utilizing lazy memory acceptance, memory is typically 
>> accepted in
>> 4M chunks. A page state change request is submitted to mark the pages as
>> private, followed by validation of the memory. Since the guest_memfd
>> currently only supports 4K pages, each page validation will result in
>> VMEXIT to map the page, resulting in 1024 additional exits.
>>
>> When performing a page state change, invoke KVM_PRE_FAULT_MEMORY for the
>> size of the page state change in order to pre-map the pages and avoid the
>> additional VMEXITs. This helps speed up boot times.
> 
> Unfortunately, it breaks TDX guest.
> 
>    kvm_hc_map_gpa_range gpa 0x80000000 size 0x200000 attributes 0x0 
> flags 0x1
> 
> For TDX guest, it uses MAPGPA to maps the range [0x8000 0000, 
> +0x0x200000] to shared. The call of KVM_PRE_FAULT_MEMORY on such range 
> leads to the TD being marked as bugged
> 
> [353467.266761] WARNING: CPU: 109 PID: 295970 at arch/x86/kvm/mmu/ 
> tdp_mmu.c:674 tdp_mmu_map_handle_target_level+0x301/0x460 [kvm]

It turns out to be a KVM bug.

The gpa passed in in KVM_PRE_FAULT_MEMORY, i.e., range->gpa has no 
indication for share vs. private. KVM directly passes range->gpa to 
kvm_tdp_map_page() in kvm_arch_vcpu_pre_fault_memory(), which is then 
assigned to fault.addr

However, fault.addr is supposed to be a gpa of real access in TDX guest, 
which means it needs to have shared bit set if the map is for shared 
access, for TDX case. tdp_mmu_get_root_for_fault() will use it to 
determine which root to be used.

For this case, the pre fault is on the shared memory, while the 
fault.addr leads to mirror_root which is for private memory. Thus it 
triggers KVM_BUG_ON().


> [353472.621399] WARNING: CPU: 109 PID: 295970 at arch/x86/kvm/../../../ 
> virt/kvm/kvm_main.c:4281 kvm_vcpu_pre_fault_memory+0x167/0x1a0 [kvm]
> 
> 
> It seems the pre map on the non MR back'ed range has issue. But I'm 
> still debugging it to understand the root cause.
> 
> 


