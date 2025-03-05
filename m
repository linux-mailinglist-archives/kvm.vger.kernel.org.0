Return-Path: <kvm+bounces-40111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5B96A4F3F1
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 02:38:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0E513A79FF
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 01:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B260B148314;
	Wed,  5 Mar 2025 01:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EMw6sI/f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ABA3B7A8
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 01:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741138709; cv=none; b=BtGKfA+BsMDtZfUq+OLglyvQul8hQtBGOQR3+/jA5La4fQFnG3zfplsV8peeTCbAZBHNctbxWzH/9cJ3Tv43QBbdtMSooVx9e0jtBYjdpSCguswp7pyw24nKdzk7DkAOn3aEtRKORPiGLUTs3lxyFoURGFCPDht7nbxJyw2LdJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741138709; c=relaxed/simple;
	bh=K4absVKzsv8lTq4U5SKjFXUqDZfm7QdEVd3JKOxSQqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eHGTWWtQrakiALSTdvG2HpIKvQMFYi+VwUtIz7lB6Z0/E1bJUhHv6YMMN6LIVtKiWjU2WXbtSIhrNqZkyxoYXkh/00ZFqb0/6yt4+krAsK2b5cTI9ardrESX+iFVGlCOus0NOUiT7xOzpVbAwfEMUPrgvh5jLjX7aPWwjgdqT3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EMw6sI/f; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741138708; x=1772674708;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K4absVKzsv8lTq4U5SKjFXUqDZfm7QdEVd3JKOxSQqQ=;
  b=EMw6sI/fOgT1ZRBAGAmZcCheJsqzxnBm9sOsuCVeTJwZxaaij870Qkh5
   c1Fyb/TBaUi+/jITEH2CJj4FbageZSYEor+dyPbx4ItrtW4yJkAIF/3qL
   paRBbml1TVzqnBLtq35s7//5RYn1lM206hxDv6hoUWQ1Yic3ip2bZcrme
   lKNDXVuU3dMBJZcTA1uyaDdmFzXCzOKaptgTtOkXpqNfBiH6mq5Hy5jZP
   LPP4kcW/OCixhPOAd/CzuJ118wk4YXNPcOj9DlARDpp3diqmQ4k91bJf0
   lCWXy2WcW/XQjynRFp2w2umKU1EXn+7JbsoNNCwC9Z+fO4gi/8cL2u/hT
   A==;
X-CSE-ConnectionGUID: iA109u/STySV8f2mrNu72Q==
X-CSE-MsgGUID: EqiRH5dOQfe66pM7zsx7pw==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="41976198"
X-IronPort-AV: E=Sophos;i="6.14,221,1736841600"; 
   d="scan'208";a="41976198"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 17:38:27 -0800
X-CSE-ConnectionGUID: 7VCINtbaT/mZ4zjbg4es1Q==
X-CSE-MsgGUID: 2uAVGxFmTKO5RLyBpkwRtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119439029"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 17:38:23 -0800
Message-ID: <1412c575-0a04-4d36-8b7f-e722da4d291f@intel.com>
Date: Wed, 5 Mar 2025 09:38:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/10] target/i386: disable PerfMonV2 when PERFCORE
 unavailable
To: dongli.zhang@oracle.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
 khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-2-dongli.zhang@oracle.com>
 <46cd2769-aad6-4b99-aea9-426968a9d7cb@intel.com>
 <d6644767-3ed9-41be-847f-950d3666e0c6@oracle.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <d6644767-3ed9-41be-847f-950d3666e0c6@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/5/2025 6:53 AM, dongli.zhang@oracle.com wrote:
> Hi Xiaoyao,
> 
> On 3/4/25 6:40 AM, Xiaoyao Li wrote:
>> On 3/3/2025 6:00 AM, Dongli Zhang wrote:
>>> When the PERFCORE is disabled with "-cpu host,-perfctr-core", it is
>>> reflected in in guest dmesg.
>>>
>>> [    0.285136] Performance Events: AMD PMU driver.
>>
>> I'm a little confused. wWhen no perfctr-core, AMD PMU driver can still be
>> probed? (forgive me if I ask a silly question)
> 
> Intel use "cpuid -1 -l 0xa" to determine the support of PMU.
> 
> However, AMD doesn't use CPUID to determine PMU support (except AMD PMU
> PerfMonV2).
> 
> I have derived everything from Linux kernel function amd_pmu_init().
> 
> As line 1521, the PMU isn't supported by old AMD CPUs.
> 
> 1516 __init int amd_pmu_init(void)
> 1517 {
> 1518         int ret;
> 1519
> 1520         /* Performance-monitoring supported from K7 and later: */
> 1521         if (boot_cpu_data.x86 < 6)
> 1522                 return -ENODEV;
> 1523
> 1524         x86_pmu = amd_pmu;
> 1525
> 1526         ret = amd_core_pmu_init();
> 
> 
> 1. Therefore, at least 4 PMCs are available (without 'perfctr-core').
> 
> 2. With 'perfctr-core', there are 6 PMCs. (line 1410)
> 
> 1404 static int __init amd_core_pmu_init(void)
> 1405 {
> 1406         union cpuid_0x80000022_ebx ebx;
> 1407         u64 even_ctr_mask = 0ULL;
> 1408         int i;
> 1409
> 1410         if (!boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
> 1411                 return 0;
> 1412
> 1413         /* Avoid calculating the value each time in the NMI handler */
> 1414         perf_nmi_window = msecs_to_jiffies(100);
> 1415
> 1416         /*
> 1417          * If core performance counter extensions exists, we must use
> 1418          * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
> 1419          * amd_pmu_addr_offset().
> 1420          */
> 1421         x86_pmu.eventsel        = MSR_F15H_PERF_CTL;
> 1422         x86_pmu.perfctr         = MSR_F15H_PERF_CTR;
> 1423         x86_pmu.cntr_mask64     = GENMASK_ULL(AMD64_NUM_COUNTERS_CORE
> - 1, 0);
> 
> 
> 3. With PerfMonV2, extra global registers are available, as well as PMCs.
> (line 1426)
> 
> 1425         /* Check for Performance Monitoring v2 support */
> 1426         if (boot_cpu_has(X86_FEATURE_PERFMON_V2)) {
> 1427                 ebx.full = cpuid_ebx(EXT_PERFMON_DEBUG_FEATURES);
> 1428
> 1429                 /* Update PMU version for later usage */
> 1430                 x86_pmu.version = 2;
> 1431
> 1432                 /* Find the number of available Core PMCs */
> 1433                 x86_pmu.cntr_mask64 =
> GENMASK_ULL(ebx.split.num_core_pmc - 1, 0);
> 1434
> 1435                 amd_pmu_global_cntr_mask = x86_pmu.cntr_mask64;
> 1436
> 1437                 /* Update PMC handling functions */
> 1438                 x86_pmu.enable_all = amd_pmu_v2_enable_all;
> 1439                 x86_pmu.disable_all = amd_pmu_v2_disable_all;
> 1440                 x86_pmu.enable = amd_pmu_v2_enable_event;
> 1441                 x86_pmu.handle_irq = amd_pmu_v2_handle_irq;
> 1442                 static_call_update(amd_pmu_test_overflow,
> amd_pmu_test_overflow_status);
> 1443         }
> 
> 
> That's why legacy 4-PMC PMU is probed after we disable perfctr-core.
> 
> - (boot_cpu_data.x86 < 6): No PMU.
> - Without perfctr-core: 4 PMCs
> - With perfctr-core: 6 PMCs
> - PerfMonV2: PMCs (currently 6) + global PMU registers
> 
> 
> May this resolve your concern in another thread that "This looks like a KVM
> bug."? This isn't a KVM bug. It is because AMD's lack of the configuration
> to disable PMU.

It helps a lot! Yes, it doesn't a KVM bug.

Thanks for your elaborated explanation!

> Thank you very much!
> 
> Dongli Zhang
> 
>>
>>> However, the guest CPUID indicates the PerfMonV2 is still available.
>>>
>>> CPU:
>>>      Extended Performance Monitoring and Debugging (0x80000022):
>>>         AMD performance monitoring V2         = true
>>>         AMD LBR V2                            = false
>>>         AMD LBR stack & PMC freezing          = false
>>>         number of core perf ctrs              = 0x6 (6)
>>>         number of LBR stack entries           = 0x0 (0)
>>>         number of avail Northbridge perf ctrs = 0x0 (0)
>>>         number of available UMC PMCs          = 0x0 (0)
>>>         active UMCs bitmask                   = 0x0
>>>
>>> Disable PerfMonV2 in CPUID when PERFCORE is disabled.
>>>
>>> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
>>
>> Though I have above confusion of the description, the change itself looks
>> good to me. So
>>
>> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>>> Fixes: 209b0ac12074 ("target/i386: Add PerfMonV2 feature bit")
>>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>>> ---
>>> Changed since v1:
>>>     - Use feature_dependencies (suggested by Zhao Liu).
>>>
>>>    target/i386/cpu.c | 4 ++++
>>>    1 file changed, 4 insertions(+)
>>>
>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>> index 72ab147e85..b6d6167910 100644
>>> --- a/target/i386/cpu.c
>>> +++ b/target/i386/cpu.c
>>> @@ -1805,6 +1805,10 @@ static FeatureDep feature_dependencies[] = {
>>>            .from = { FEAT_7_1_EDX,             CPUID_7_1_EDX_AVX10 },
>>>            .to = { FEAT_24_0_EBX,              ~0ull },
>>>        },
>>> +    {
>>> +        .from = { FEAT_8000_0001_ECX,       CPUID_EXT3_PERFCORE },
>>> +        .to = { FEAT_8000_0022_EAX,
>>> CPUID_8000_0022_EAX_PERFMON_V2 },
>>> +    },
>>>    };
>>>      typedef struct X86RegisterInfo32 {
>>
> 


