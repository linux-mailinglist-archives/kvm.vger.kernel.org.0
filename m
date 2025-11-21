Return-Path: <kvm+bounces-64045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FBC4C76D34
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:57:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2BB044E556B
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00089279346;
	Fri, 21 Nov 2025 00:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DdqwL4Th"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617BA7261E;
	Fri, 21 Nov 2025 00:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763686417; cv=none; b=qpmUdFTNlc+osFbshMcu9pwgm53d7HEn7GtALbeTF7adaZl1a/Ng7MjZNQijs0JKG8AEFi/3Z3DjPYkq9PhWElqjCbMweGdko1TWzlZk+lFIvvshhia49gLjEYTk6qnBWaCUv3S9ttABHTIUb8QK0yYl1/tnQgxnk7nVtLy9aD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763686417; c=relaxed/simple;
	bh=oAnzoEKWIFj7Ramp2gA0+Sx2tCfbDCIjYuque/sxtiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BwUvjTxUIkeE76RYbEcxqmtKaLWOJ76ju+S5zEVKDMoTdE7Bv0KsFd7ERmIOs9BCay404cobZYYoQ4u/uFwAssldTJaC+liDlaisNgmEao1ucQQPayFCuyauRHcSq2fvJjZc5UNZvxvBAZhkKECzYtwdmb4FwWxDlJV7e03KrGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DdqwL4Th; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763686416; x=1795222416;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oAnzoEKWIFj7Ramp2gA0+Sx2tCfbDCIjYuque/sxtiQ=;
  b=DdqwL4ThMXv7jb/PZ3tB2m0rSE/ixC4UcDJZczjI40+I43eIqqBTQZ2w
   kG39bElnzNed8SlJ++J5scHPW3oTuN1ekm3HF3vXaNF8/ZZ3k+EOciF9M
   IeWhD2gV8Z1p58dEYhF6SAtzAbnc9f0mH4cwrUe7g1PwN86vC8Us2zcyM
   ElMIoToyw0P1ex2bLOPrCYmSIBMOfhIs16iKJG3XT9whgKyW8Q/McQuyL
   RPg10FPcE8YYUNyaI2vjnSpX/F41L/dilM9rBf9TWBykU7lpmUKIY39+T
   g+IxMZP3laL4J0vhc9MYbS1CdpQGNHqYvz14mAziY1czV36IRq6C2HQeZ
   A==;
X-CSE-ConnectionGUID: scjynysXRVSsglOV5qdS9g==
X-CSE-MsgGUID: 4vvo8TK5R8i0O6quBIJq+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="65473110"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="65473110"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:53:35 -0800
X-CSE-ConnectionGUID: zdNMnW8VSk+qJFDU8aURsQ==
X-CSE-MsgGUID: AfY7yz6GTbCaKv4nbpb1Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="190755014"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.213]) ([10.124.240.213])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:53:32 -0800
Message-ID: <4a8f9550-7c1b-4646-bdb8-04a7f1463511@linux.intel.com>
Date: Fri, 21 Nov 2025 08:53:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests patch v3 5/8] x86/pmu: Relax precise count check
 for emulated instructions tests
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Zide Chen <zide.chen@intel.com>,
 Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
 <20250903064601.32131-6-dapeng1.mi@linux.intel.com>
 <aR-WNu8iFfP1AKBX@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aR-WNu8iFfP1AKBX@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 11/21/2025 6:29 AM, Sean Christopherson wrote:
> On Wed, Sep 03, 2025, Dapeng Mi wrote:
>> Relax precise count check for emulated instructions tests on these
>> platforms with HW overcount issues.
>>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>  x86/pmu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index c54c0988..6bf6eee3 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -790,7 +790,7 @@ static void check_emulated_instr(void)
>>  
>>  	// Check that the end count - start count is at least the expected
>>  	// number of instructions and branches.
>> -	if (this_cpu_has_perf_global_ctrl()) {
>> +	if (this_cpu_has_perf_global_ctrl() && !intel_inst_overcount_flags) {
> This skips precise checking if _either_ errata is present.  IIUC, we can still do
> a precise check for branches retired on Clearwater Forest, but not for instructions
> retired.

Yes, this is correct. 


>
>>  		report(instr_cnt.count - instr_start == KVM_FEP_INSNS,
>>  		       "instruction count");
>>  		report(brnch_cnt.count - brnch_start == KVM_FEP_BRANCHES,
>> -- 
>> 2.34.1
>>

