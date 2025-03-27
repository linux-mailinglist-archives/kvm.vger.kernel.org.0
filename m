Return-Path: <kvm+bounces-42100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 407DCA72955
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 04:47:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11D227A41A8
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 03:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD6DB155322;
	Thu, 27 Mar 2025 03:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W6jtcvR1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4390E46B8
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 03:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743047253; cv=none; b=jzFcnWjUr64FqlNNOWRlV+RQoDpIjyfLJzgr0xNlVo9S3uDmONqe2NGrq2+3/2YB81fEkQHEidwiNiDpECyz+vbNBglRoD76xNA64eKItZMYX/gpP71ajdFQ+JkZMalWgeOBnD6I9X23RRP05E59i98X9nCumbRmOuu5rRQT/Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743047253; c=relaxed/simple;
	bh=jd5V66xzNMVVQpsPvdqBDVug/cTkyvdUpfxi1ZnZZRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uVR4XTkT9qym0d0khnq5aBYN/0TkOKgfGmD9sUmpOpL6fN/IjLnNNNs2Qawilv8l11t0ngtPrd6d3u07wc81+SpnSXeKuclzRiXeK5OFShhuFc3B7LY16rmGqGmM7v9tFFAJLYv3gLGnIcLGredklTttONhqIalgm3y7/yV8AFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W6jtcvR1; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743047252; x=1774583252;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jd5V66xzNMVVQpsPvdqBDVug/cTkyvdUpfxi1ZnZZRc=;
  b=W6jtcvR11M/RQD1oN2Lc7DQ8fCOb5boX8PKSuJnZWEAcDBhk52WYJKG4
   iOqTkJ1pAFmZj1xQZb1fkhuphOZyhCBfW+lAktZEE76b6dmDdHaviH+OC
   p34w4wIEJGrWHPNDsdUwV7QQvq0yKd11E1Ju73w6ncMAf2RpldHHTfhjd
   eoScbSjwSeTne6sH86GwWM6dXk/hOTg+8MJerzDvTJ6ceD0ZSW2LauaS1
   Zlml/IFom2TwQpxp1ulPgR1yzcqFgaHPYS3ATTP05rjVvK9SeJ6YjFOmO
   W/gTNhu3aMi4KtxqHIi+TYb+phjvwhy9ASOlOib3gXpXVcZlPp1yCjxIC
   g==;
X-CSE-ConnectionGUID: ooylo3DAQOm1Qsc1tkBuhg==
X-CSE-MsgGUID: 5ghQahxxSnOROAnJuf02gg==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="66825887"
X-IronPort-AV: E=Sophos;i="6.14,279,1736841600"; 
   d="scan'208";a="66825887"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 20:47:31 -0700
X-CSE-ConnectionGUID: eQQvm33XSkmb0FreCz6SXQ==
X-CSE-MsgGUID: ImzR1k+LTgCtBLUtfepdOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,279,1736841600"; 
   d="scan'208";a="124979505"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 20:47:27 -0700
Message-ID: <04f025bb-2ce8-49d9-9d94-857bd4106156@linux.intel.com>
Date: Thu, 27 Mar 2025 11:47:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] target/i386: Call KVM_CAP_PMU_CAPABILITY iotcl to
 enable/disable PMU
To: Mingwei Zhang <mizhang@google.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Zhao Liu <zhao1.liu@intel.com>,
 Zide Chen <zide.chen@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Sean Christopherson <seanjc@google.com>, Das Sandipan
 <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>,
 Dapeng Mi <dapeng1.mi@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250324123712.34096-1-dapeng1.mi@linux.intel.com>
 <20250324123712.34096-3-dapeng1.mi@linux.intel.com>
 <3a01b0d8-8f0b-4068-8176-37f61295f87f@oracle.com>
 <a8e4649d-5402-4c3a-bc86-1d1b76122541@linux.intel.com>
 <CAL715WJmj=7wO_HTSendCLAs6TAPbUyKM9gMFKLhiSKqgr1s4A@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CAL715WJmj=7wO_HTSendCLAs6TAPbUyKM9gMFKLhiSKqgr1s4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 3/27/2025 10:15 AM, Mingwei Zhang wrote:
> On Wed, Mar 26, 2025 at 5:44 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>
>> On 3/26/2025 2:46 PM, Dongli Zhang wrote:
>>> Hi Dapeng,
>>>
>>> PATCH 1-4 from the below patchset are already reviewed. (PATCH 5-10 are for PMU
>>> registers reset).
>>>
>>> https://lore.kernel.org/all/20250302220112.17653-1-dongli.zhang@oracle.com/
>>>
>>> They require only trivial modification. i.e.:
>>>
>>> https://github.com/finallyjustice/patchset/tree/master/qemu-amd-pmu-mid/v03
>>>
>>> Therefore, since PATCH 5-10 are for another topic, any chance if I re-send 1-4
>>> as a prerequisite for the patch to explicitly call KVM_CAP_PMU_CAPABILITY?
>> any option is fine for me, spiting it into two separated ones or still keep
>> in a whole patch series. I would rebase this this patchset on top of your
>> v3 patches.
>>
>>
>>> In addition, I have a silly question. Can mediated vPMU coexist with legacy
>>> perf-based vPMU, that is, something like tdp and tdp_mmu? Or the legacy
>>> perf-based vPMU is going to be purged from the most recent kernel?
>> No, they can't. As long as mediated vPMU is enabled, it would totally
>> replace the legacy perf-based vPMU. The legacy perf-based vPMU code would
>> still be kept in the kernel in near future, but the long-term target is to
>> totally remove the perf-based vPMU once mediated vPMU is mature.
> mediated vPMU will co-exist with legacy vPMU right? Mediated vPMU
> currently was constrained to SPR+ on Intel and Genoa+ on AMD. So
> legacy CPUs will have no choice but legacy vPMU.
>
> In the future, to fully replace legacy vPMU we need to solve the
> performance issue due to PMU context switching being located at VM
> enter/exit boundary. Once those limitations are resolved, and older
> x86 CPUs fade away, mediated vPMU can fully take over.

yeah, the code would co-exist in near feature or maybe longer, but mediated
vPMU and the legacy vPMU won't work concurrently, once mediated vPMU is
enabled, it would preempt the legacy vPMU.


>
> Thanks.
> -Mingwei
>>
>>> If they can coexist, how about add property to QEMU control between
>>> legacy/modern? i.e. by default use legacy and change to modern as default in the
>>> future once the feature is stable.

I don't prefer to add such property in Qemu. Whether KVM selects to enable
mediated vPMU or the legacy perf-based vPMU, it should be transparent for
Qemu. Qemu is unnecessary to know it.

Currently Qemu already has too much PMU related options, such as pmu,
lbr/arch_lbr. It's too complicated, it introduces too much dependency on
the code and user needs to take time to learn how to configure these
options correctly as well. 

We don't need more options, on the contrary we need to simplify the PMU
options in Qemu. The ideal situation is to keep only one "pmu" option which
is used to manage all these PMU features, like basic perfmon, LBR and PEBS
etc,. But it may cause back-compatible issues if remove these additional
options...


>>>
>>> Thank you very much!
>>>
>>> Dongli Zhang
>>>
>>> On 3/24/25 5:37 AM, Dapeng Mi wrote:
>>>> After introducing mediated vPMU, mediated vPMU must be enabled by
>>>> explicitly calling KVM_CAP_PMU_CAPABILITY to enable. Thus call
>>>> KVM_CAP_PMU_CAPABILITY to enable/disable PMU base on user configuration.
>>>>
>>>> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
>>>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>>> ---
>>>>  target/i386/kvm/kvm.c | 17 +++++++++++++++++
>>>>  1 file changed, 17 insertions(+)
>>>>
>>>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>>>> index f41e190fb8..d3e6984844 100644
>>>> --- a/target/i386/kvm/kvm.c
>>>> +++ b/target/i386/kvm/kvm.c
>>>> @@ -2051,8 +2051,25 @@ full:
>>>>      abort();
>>>>  }
>>>>
>>>> +static bool pmu_cap_set = false;
>>>>  int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>>>>  {
>>>> +    KVMState *s = kvm_state;
>>>> +    X86CPU *x86_cpu = X86_CPU(cpu);
>>>> +
>>>> +    if (!pmu_cap_set && kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY)) {
>>>> +        int r = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
>>>> +                                  KVM_PMU_CAP_DISABLE & !x86_cpu->enable_pmu);
>>>> +        if (r < 0) {
>>>> +            error_report("kvm: Failed to %s pmu cap: %s",
>>>> +                         x86_cpu->enable_pmu ? "enable" : "disable",
>>>> +                         strerror(-r));
>>>> +            return r;
>>>> +        }
>>>> +
>>>> +        pmu_cap_set = true;
>>>> +    }
>>>> +
>>>>      return 0;
>>>>  }
>>>>

