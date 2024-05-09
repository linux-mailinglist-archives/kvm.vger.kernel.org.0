Return-Path: <kvm+bounces-17080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C457D8C092D
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 03:32:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 61C9BB20EF7
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 01:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C63E13C80A;
	Thu,  9 May 2024 01:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ndcQM0pZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59A613C66A;
	Thu,  9 May 2024 01:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715218181; cv=none; b=tW1ou7GTEmaUo54CurqYJ4FBxazRhpy2sRxdnYb1APQ/HYPkLZL/yqptof7FccFFi2q5Jo1Q9teDNvcF/072GN3XkxAVu+P6jw1ozWmH3hL38BeKZYODR5x+lE8g80I+qS/TXuIqhgBX0m/o+qKbLlUug0otk1muJI5idK0XVDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715218181; c=relaxed/simple;
	bh=h2q9UinH3FLb86zSa+KvqiciZkUTckzeXurWUdlD+hs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gM/3E2Nzru5nmerV5DLtWJPBxJ3VApwlFIkV+8C8U9wkpqp9QgxdTuqfzuQruLdO3rfu1tv+uPqVrM7wdjcQlQj4XetMNpAeQ2LgUz8IQMCd9ocj79CBM1OVi0dUJzH0xM3iuER1uYO/CXzw381JoirL20alUqHodsbHZlnjm94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ndcQM0pZ; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715218179; x=1746754179;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h2q9UinH3FLb86zSa+KvqiciZkUTckzeXurWUdlD+hs=;
  b=ndcQM0pZSp32+L9qaefI2FRYnfrWqYq1wo85iCAUgwsrha+bvhguEUHC
   d6EfsDgEbkCbvcUIMFQGZUWXiu0Is39MfxHUKzxoxkEqLanXiLlC2aKCw
   vK8jcMt+u5svCelpc954+HR64u2b/3APDgPH+LKOEWkOoR/X4TZXW2P2z
   V82L2SuRUNkOKHOFWLS7E2cWUXwBDqIFTQQcPjoE+nvAqIUElwC6DnwGP
   k58UyzdKQmVtVPQ6w0XOtWA1aItBppjkpL6kaRBm935deMuivqyMdYtc+
   d/drHAVKx2alkRCwBRc8SGnQzpq7Lo+iNJYk3sZ72hue2aB7QWHmyTs08
   A==;
X-CSE-ConnectionGUID: 5tTgrGx/TjOtm9It6OKH4g==
X-CSE-MsgGUID: zK850LTGQO68hZ5+aBwFUg==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="10981708"
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="10981708"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 18:29:39 -0700
X-CSE-ConnectionGUID: PaNpWDQbQNa/IRfrEDreDg==
X-CSE-MsgGUID: EirwGQE0QpaMThWSnHbOGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="29600479"
Received: from fabia14x-mobl1.amr.corp.intel.com (HELO [10.124.48.85]) ([10.124.48.85])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 18:29:37 -0700
Message-ID: <e7bc3989-154b-42cb-9a6b-83b395f5d0ee@intel.com>
Date: Wed, 8 May 2024 18:29:36 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/54] KVM: x86/pmu: Avoid legacy vPMU code when
 accessing global_ctrl in passthrough vPMU
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
 Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-27-mizhang@google.com>
 <d19e06e7-ed97-4361-a628-014e5670cf22@intel.com>
 <9b93c6bb-0182-4729-a935-2c05f1160a73@linux.intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <9b93c6bb-0182-4729-a935-2c05f1160a73@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/8/2024 5:43 PM, Mi, Dapeng wrote:
> 
> On 5/9/2024 5:48 AM, Chen, Zide wrote:
>>
>> On 5/5/2024 10:29 PM, Mingwei Zhang wrote:
>>> Avoid calling into legacy/emulated vPMU logic such as reprogram_counters()
>>> when passthrough vPMU is enabled. Note that even when passthrough vPMU is
>>> enabled, global_ctrl may still be intercepted if guest VM only sees a
>>> subset of the counters.
>>>
>>> Suggested-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>>> ---
>>>  arch/x86/kvm/pmu.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>>> index bd94f2d67f5c..e9047051489e 100644
>>> --- a/arch/x86/kvm/pmu.c
>>> +++ b/arch/x86/kvm/pmu.c
>>> @@ -713,7 +713,8 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>  		if (pmu->global_ctrl != data) {
>>>  			diff = pmu->global_ctrl ^ data;
>>>  			pmu->global_ctrl = data;
>>> -			reprogram_counters(pmu, diff);
>>> +			if (!is_passthrough_pmu_enabled(vcpu))
>>> +				reprogram_counters(pmu, diff);
>> Since in [PATCH 44/54], reprogram_counters() is effectively skipped in
>> the passthrough case, is this patch still needed?
> Zide, reprogram_counters() and reprogram_counter() are two different
> helpers. Both they need to be skipped in passthrough mode.

Yes, but this is talking about reprogram_counters() only.  passthrough
mode is being checked inside and outside the function call, which is
redundant.

