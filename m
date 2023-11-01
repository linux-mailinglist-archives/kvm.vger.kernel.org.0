Return-Path: <kvm+bounces-268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D63F7DDB02
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 03:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B73341C20D08
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 02:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433D0EDD;
	Wed,  1 Nov 2023 02:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SywK1OcB"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10A2643
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 02:33:55 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41166BD;
	Tue, 31 Oct 2023 19:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698806031; x=1730342031;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VM1SwW2sLu8vpMwvfts1qGcCzaC89DFJLSyEUxN/3V0=;
  b=SywK1OcBVlIQEOm5zXQ/162dpRwHOdgGfDeFZFPG3HA6g4mLmtp9HSdF
   PjvT4PpE2ElXlMdP1Qc2LZBp65yuWedZ4DBv3/pEuiB1V4/a5Ku8qiZJz
   Uj78sjgQmSF8O6gcteqiyn+JqAN6BmEPCitSbipK2ko4EJcN0/UJGFpdS
   toiveEoOm9RyGH2f/MMVSvWhy1WanRJA4QBs2f/E7+dQZgovCUexga/so
   14PNTysd1/JifGak2fNzak1UJNRNLzVcVwPjEh5oL7dnJ6wuVBQljpnLY
   8IBRm8Ei5XFmckDQmGJ+io04XkwSxek+umLJmXLd9UBjPcJYoKQSmkZg0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="373468510"
X-IronPort-AV: E=Sophos;i="6.03,266,1694761200"; 
   d="scan'208";a="373468510"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 19:33:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,266,1694761200"; 
   d="scan'208";a="2041477"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.12.33]) ([10.93.12.33])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 19:33:48 -0700
Message-ID: <28796dd3-ac4e-4a38-b9e1-f79533b2a798@linux.intel.com>
Date: Wed, 1 Nov 2023 10:33:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v2 4/5] x86: pmu: Support validation for
 Intel PMU fixed counter 3
Content-Language: en-US
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Like Xu <like.xu.linux@gmail.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20231031092921.2885109-1-dapeng1.mi@linux.intel.com>
 <20231031092921.2885109-5-dapeng1.mi@linux.intel.com>
 <CALMp9eQ4Xj5D-kgqVMKUNmdF37rLcMRXyDYdQU339sRCKZ7d9A@mail.gmail.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eQ4Xj5D-kgqVMKUNmdF37rLcMRXyDYdQU339sRCKZ7d9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/1/2023 2:47 AM, Jim Mattson wrote:
> On Tue, Oct 31, 2023 at 2:22 AM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>> Intel CPUs, like Sapphire Rapids, introduces a new fixed counter
>> (fixed counter 3) to counter/sample topdown.slots event, but current
>> code still doesn't cover this new fixed counter.
>>
>> So this patch adds code to validate this new fixed counter can count
>> slots event correctly.
> I'm not convinced that this actually validates anything.
>
> Suppose, for example, that KVM used fixed counter 1 when the guest
> asked for fixed counter 3. Wouldn't this test still pass?


Per my understanding, as long as the KVM returns a valid count in the 
reasonable count range, we can think KVM works correctly. We don't need 
to entangle on how KVM really uses the HW, it could be impossible and 
unnecessary.

Yeah, currently the predefined valid count range may be some kind of 
loose since I want to cover as much as hardwares and avoid to cause 
regression. Especially after introducing the random jump and clflush 
instructions, the cycles and slots become much more hard to predict. 
Maybe we can have a comparable restricted count range in the initial 
change, and we can loosen the restriction then if we encounter a failure 
on some specific hardware. do you think it's better? Thanks.


>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>   x86/pmu.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index 6bd8f6d53f55..404dc7b62ac2 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -47,6 +47,7 @@ struct pmu_event {
>>          {"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
>>          {"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 500*N},
>>          {"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 300*N},
>> +       {"fixed 4", MSR_CORE_PERF_FIXED_CTR0 + 3, 1*N, 5000*N},
>>   };
>>
>>   char *buf;
>> --
>> 2.34.1
>>

