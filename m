Return-Path: <kvm+bounces-52260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1677EB034EF
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 05:20:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C324176C94
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 03:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B631E5B82;
	Mon, 14 Jul 2025 03:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U5gw4PFN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17759BE4A;
	Mon, 14 Jul 2025 03:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752463214; cv=none; b=T+5TakWEtYDgO5pcUBNh8XstbGQyEPvkL9IJKmo0ToHn1l5HDcE4QC1wf68h8efm1m6b4DZkgfQvXMEcmApjtfSFivWlwOM5eWJ1lt18UndlonvLgJn12se3IVWQsxJU1KaPGrjl4ZbEgCrsW7RmQ9tyiTvPbZrV1ab3vHZOuFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752463214; c=relaxed/simple;
	bh=tcn1GO9tcnkz5xuh+C1NWSfQ89jGjB/xyI/3lDc+SsA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YAvGbpfaF01WKdTHI5GBwOjKgZ49IZIU2OL1aKtPF0Zk90J1LkQWcyqVP861aPqewBfS5P0ofkM+TxKe1n2CeirIBK6AWnEbosO1Eu0cyCDli723RctErUpCEt01O8klsU0Bjkrxa6YALMgUdrpLw1ANtAuyiYSJJ9BxRgQJ+3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U5gw4PFN; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752463212; x=1783999212;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tcn1GO9tcnkz5xuh+C1NWSfQ89jGjB/xyI/3lDc+SsA=;
  b=U5gw4PFNIfbBA2WusrE8sFlDGJGzKhPgl6pbKit8u1AAlZnXAKYzaNk5
   YsadZFlkLqW+8eJMSZDXH7InPWk9DnfeSHzbmz15kVXEhilIPBj7eu3de
   X/nG+EBvFUpYAVz2KbiSg3NUO0TB0kkslsgZ9weGpjAuSrKHlgBx+2iNF
   Jbnoiykk3AX8ciU9EgYvA7+ffZ5vQ1OTeiAeXnWqCfmTjj/fSixJP6qee
   UW6e6EaKr+5prs8YR1Ns29xh2O55KLCQjk4gw3A1kpd5zFmREMqE6KtZs
   //46xXrd0ZOe3E8ZPkVYvZOnFv3kFGKSp07D1jFUI1hlzU5mf2FFsvSJA
   w==;
X-CSE-ConnectionGUID: jgzObkzbQwWwqz7Y28H6og==
X-CSE-MsgGUID: q6VNLVDSTQede8VWszpVHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54618422"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="54618422"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 20:20:12 -0700
X-CSE-ConnectionGUID: 9VMJp6EYRK6Ki/tWNX+Stg==
X-CSE-MsgGUID: p4PkuAAfQm2kCmoCIpy2Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="157312424"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 20:20:08 -0700
Message-ID: <3ef581f1-1ff1-4b99-b216-b316f6415318@intel.com>
Date: Mon, 14 Jul 2025 11:20:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <175088949072.720373.4112758062004721516.b4-ty@google.com>
 <aF1uNonhK1rQ8ViZ@google.com>
 <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
 <aHEMBuVieGioMVaT@google.com>
 <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
 <aHEdg0jQp7xkOJp5@google.com>
 <b5df4f84b473524fc3abc33f9c263372d0424372.camel@intel.com>
 <aHGYvrdX4biqKYih@google.com>
 <a29d4a7f319f95a45f775270c75ccf136645fad4.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <a29d4a7f319f95a45f775270c75ccf136645fad4.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/12/2025 7:17 AM, Edgecombe, Rick P wrote:
> On Fri, 2025-07-11 at 16:05 -0700, Sean Christopherson wrote:
>>> Zero the reserved area in struct kvm_tdx_capabilities so that fields added
>>> in
>>> the reserved area won't disturb any userspace that previously had garbage
>>> there.
>>
>> It's not only about disturbing userspace, it's also about actually being able
>> to repurpose the reserved fields in the future without needing *another* flag
>> to tell userspace that it's ok to read the previously-reserved fields.  I care
>> about this much more than I care about userspace using reserved fields as
>> scratch space.
> 
> If, before calling KVM_TDX_CAPABILITIES, userspace zeros the new field that it
> knows about, but isn't sure if the kernel does, it's the same no?
> 
> Did you see that the way KVM_TDX_CAPABILITIES is implemented today is a little
> weird? It actually copies the whole struct kvm_tdx_capabilities from userspace
> and then sets some fields (not reserved) and then copies it back. So userspace
> can zero any fields it wants to know about before calling KVM_TDX_CAPABILITIES.
> Then it could know the same things as if the kernel zeroed it.
> 
> I was actually wondering if we want to change the kernel to zero reserved, if it
> might make more sense to just copy caps->cpuid.nent field from userspace, and
> then populate the whole thing starting from a zero'd buffer in the kernel.

+1 to zero the whole buffer of *caps in the kernel.

current code seems to have issue on the 
caps->kernel_tdvmcallinfo_1_r11/kernel_tdvmcallinfo_1_r12/user_tdvmcallinfo_1_r12, 
as KVM cannot guarantee zero'ed value are returned to userspace.

