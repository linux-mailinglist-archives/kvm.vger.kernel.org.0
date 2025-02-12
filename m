Return-Path: <kvm+bounces-37946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D586A31C2D
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 03:40:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9426A1889C20
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 02:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DCE21D5CC5;
	Wed, 12 Feb 2025 02:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H8x+T+/U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20E617996;
	Wed, 12 Feb 2025 02:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739328003; cv=none; b=kBwIy+Wazpu4eWeOy813aKv9H81qpskH9b+XkRnliwJZAxW8VotdSIqg8XH5H/0KiOYfoqKO/cDTQg8nWj/17RiPSiD/ZzZKOoj0ZFerxyTxsDaTeyAkbUr1VkHsQOn+lK5k3z0PNVJxCxNdNrEFCoqNrB/N15yULWuWBJKPy78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739328003; c=relaxed/simple;
	bh=VSxaYJSp4WgI/pL55ynDVo4C2Xt2d0ehnWxBDBjl1w8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hx5kKYZ5rq9QJgF9IqVLSic6x+TlnZmqe2PtMZ5BEIi828L5fFqW1xnrDPov8KpKOhXNpZkpxtIF0eFisTemnJkCRKKIaAV0hln2QsKF+u7H/441ectFQJeXSsUeckIYtA3WT2Q64lmT614hG/pTly0M9dtSq3aBwnRyZ3DG51E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H8x+T+/U; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739328002; x=1770864002;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VSxaYJSp4WgI/pL55ynDVo4C2Xt2d0ehnWxBDBjl1w8=;
  b=H8x+T+/UGCTN09DigQlxZ3zijC/fI3lyi6BVEOVi/yN5YP0TRfQuauYE
   49zqazs4Me5Hxuk27qdcJJn3l/NwMgr8VKU+7i2k7rx4UQB7yyfXjqA3l
   b3lQrW41lb/uLa63aZ7wG4xhnhJEyBKdRZ4s9kzUJ1MddyIb6cJvMbXPj
   zfPqZcU55A6NiM3h4iAHOCJ9eUxSKJwWo4ni7ooRHFmidWSJX04wJPN7Z
   nm+at/3MiCtRoI/B0Ow6OOouyFmVKgMKcb0qJm4ELNxQTzKChI0Pevj3S
   VHVCGm7auJwiwHlSSnyXzYpxbjbNI5HimH5CgxK7hpP8j9XK12J0GzN13
   Q==;
X-CSE-ConnectionGUID: UD16/daKQwe0SXGFVUn5/A==
X-CSE-MsgGUID: p6I/j/HiQCeATR5xshAKNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="40091534"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="40091534"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 18:40:01 -0800
X-CSE-ConnectionGUID: rvjKxpzgRb+OyCdLiZPFyw==
X-CSE-MsgGUID: JQkgZWi9SbCInrbIucRWhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112549842"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 18:39:58 -0800
Message-ID: <fd496d85-b24f-4c6f-a6c9-3c0bd6784a1d@linux.intel.com>
Date: Wed, 12 Feb 2025 10:39:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] KVM: TDX: Handle TDX PV MMIO hypercall
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, linux-kernel@vger.kernel.org
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-9-binbin.wu@linux.intel.com>
 <Z6wHZdQ3YtVhmrZs@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z6wHZdQ3YtVhmrZs@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/12/2025 10:28 AM, Chao Gao wrote:
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index f13da28dd4a2..8f3147c6e602 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -849,8 +849,12 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
>> 		if (tdvmcall_exit_type(vcpu))
>> 			return EXIT_REASON_VMCALL;
>>
>> -		if (tdvmcall_leaf(vcpu) < 0x10000)
>> +		if (tdvmcall_leaf(vcpu) < 0x10000) {
>> +			if (tdvmcall_leaf(vcpu) == EXIT_REASON_EPT_VIOLATION)
>> +				return EXIT_REASON_EPT_MISCONFIG;
> IIRC, a TD-exit may occur due to an EPT MISCONFIG. Do you need to distinguish
> between a genuine EPT MISCONFIG and a morphed one, and handle them differently?
It will be handled separately, which will be in the last section of the KVM
basic support.  But the v2 of "the rest" section is on hold because there is
a discussion related to MTRR MSR handling:
https://lore.kernel.org/all/20250201005048.657470-1-seanjc@google.com/
Want to send the v2 of "the rest" section after the MTRR discussion is
finalized.

For the genuine EPT misconfig handling, you can refer to the patch on the
full KVM branch:
https://github.com/intel/tdx/commit/e576682ac586f994bf54eb11b357f3e835d3c042




