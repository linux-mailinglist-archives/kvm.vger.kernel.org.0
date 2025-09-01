Return-Path: <kvm+bounces-56417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E762B3DAF4
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 09:26:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02FBC179C32
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD6126B942;
	Mon,  1 Sep 2025 07:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rdy6yo+k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8761E5219;
	Mon,  1 Sep 2025 07:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756711556; cv=none; b=SgHMVj9ME6YVlxHMW8yX+gmL3WQ08U6grrojyqHIJjMWZ2lEsnYWknrwBWVwaTB6rmx0Sc0wtVoT3SV/sLZXYjIy5SDUC1vSz6u9EYbagGJi/SWPWbywkTcl4TG0ptKbs+J267ZaES40sKrXJGBVliH5VSUrRPDq1YW1oJ+5ONE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756711556; c=relaxed/simple;
	bh=Dja798vbVuspbvR37CMf7VerA9fgpeJEgIVNNNoyGm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XUI4f1gvMohoSP2dQ1zmG/ehF1qxZkaIhFjAvCYk9kHqmuEk7cP1jnuBUiHkxAZALyL/yvW2yJxzdGTtCZPN7QcDJTqLlSAa7T5EK5BhNZlbq+4Us3Dm4G2hxpTKolfh2qFuezcxkmg9UpPKHDkxQ2XDh5aTZ4xrE/BcFORJWmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rdy6yo+k; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756711554; x=1788247554;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Dja798vbVuspbvR37CMf7VerA9fgpeJEgIVNNNoyGm4=;
  b=Rdy6yo+kkdSeEMY5hrBxUTwPtbkjh++vUewgLWzDQZo/d/WLEP0HAGHs
   OUYoWfuaqRNRQ/BfLNe/SyCZNMNcbsKzfvY+S8VYyfMB7IhZ8NArwSrHV
   ZLJKLawuW40XzF9MDp97bxOHj8q1ebTMnI11xTSNqyP6iz7nWgHN4oBns
   qC2/XTGTmVlrol6BWhp64CHh3lyahg3V2/C7JKtwb1PgeQD55YOZKE0ka
   leMY66KTIaVbj9H6Sh3+DJdv7hIv2xHqGE5B52CMfswInPP/n6om+R+DS
   QpBAP87efNQzUCYVEnwxW8bYkheb94oyeYm6efNxKIVMXMC+k2iAP0NtV
   Q==;
X-CSE-ConnectionGUID: uZGHV3lpSMaIJxLlbUeFOA==
X-CSE-MsgGUID: 2Tw7lMdCQ6CMJflThReGaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11539"; a="62729045"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="62729045"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 00:22:49 -0700
X-CSE-ConnectionGUID: u9ITx0L5QAuRhhvDx/T8Zw==
X-CSE-MsgGUID: k+TY8wmlSwSWdbzoQjjxJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="170438849"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 00:22:48 -0700
Message-ID: <fbdcca61-e9c4-47fc-b629-7a46ad35cd24@intel.com>
Date: Mon, 1 Sep 2025 15:22:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] KVM: x86: Add support for RDMSR/WRMSRNS w/
 immediate on Intel
To: Xin Li <xin@zytor.com>, Binbin Wu <binbin.wu@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
References: <20250805202224.1475590-1-seanjc@google.com>
 <20250805202224.1475590-5-seanjc@google.com>
 <424e2aaa-04df-4c7e-a7f9-c95f554bd847@intel.com>
 <849dd787-8821-41f1-8eef-26ede3032d90@linux.intel.com>
 <c4bc61da-c42c-453d-b484-f970b99cb616@zytor.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <c4bc61da-c42c-453d-b484-f970b99cb616@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/1/2025 3:04 PM, Xin Li wrote:
> On 8/31/2025 11:34 PM, Binbin Wu wrote:
>>> We need to inject #UD for !guest_cpu_has(X86_FEATURE_MSR_IMM)
>>>
>>
>> Indeed.
> 
> Good catch!
> 
>>
>> There is a virtualization hole of this feature for the accesses to the 
>> MSRs not
>> intercepted. IIUIC, there is no other control in VMX for this feature. 
>> If the
>> feature is supported in hardware, the guest will succeed when it 
>> accesses to the
>> MSRs not intercepted even when the feature is not exposed to the 
>> guest, but the
>> guest will get #UD when access to the MSRs intercepted if KVM injects 
>> #UD.
> 
> hpa mentioned this when I just started the work.  But I managed to forget
> it later... Sigh!
> 
>>
>> But I guess this is the guest's fault by not following the CPUID, KVM 
>> should
>> still follow the spec?
> 
> I think we should still inject #UD when a MSR is intercepted by KVM.
> 

For handle_wrmsr_imm(), it seems we need to check 
guest_cpu_cap_has(X86_FEATURE_WRMSRNS) as well, since immediate form of 
MSR write is only supported on WRMSRNS instruction.

It leads to another topic, do we need to bother checking the opcode of 
the instruction on EXIT_REASON_MSR_WRITE and inject #UD when it is 
WRMSRNS instuction and !guest_cpu_cap_has(X86_FEATURE_WRMSRNS)?

WRMSRNS has virtualization hole as well, but KVM at least can emulate 
the architectural behavior when the write on MSRs are not pass through.

