Return-Path: <kvm+bounces-11254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A5418747AA
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 06:39:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69C83286451
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 05:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0D41BDDF;
	Thu,  7 Mar 2024 05:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GnDsIING"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9069663CF;
	Thu,  7 Mar 2024 05:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709789977; cv=fail; b=TkELZUj/JLCr0U1LdfWmh2pEQ4PoXSnR1Kgd7vs+icK/H4/DIBaomz3i7SIUCfnWp+uoyxLVyJdisSpXjWVM2v/RaNpwj4Yfwh8CChPH9z/4B5Lyd9jlttENgZ1H81Hqpr1dZjwGk098TNPwb5MnDy6nzRUOQFXT5oyvGjLcfJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709789977; c=relaxed/simple;
	bh=kEhgckVfxhKHMqLRhyHOzqL32GyyNgJijjVticVldtM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YUdq+yEHg+J9OjU/UzfOeF3CLxSfvXqWbOYDlrWTaxHSKzNbUDHbeYACPiFO/xEFF9eMYxWBdvnAJsKebOmHpW0gdo4/sSTPIW8Gyz3feXGVlbkpXvUBc0UrW1pUa9BGYi+8nQvQpzoTX/vgm2GcN95D6PsduWXAjaD8I/Y3E4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GnDsIING; arc=fail smtp.client-ip=40.107.237.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUcKC7yQ6Q0PQroGsZBxG6udhoVqfmzlkbSNlZZ2iOWxzt555cdQC1PHaEig+iunxTEV6O9z5H9sf9SEINrD66OqOwdt7ulZ+SWAtwKMvi6qvG+xp/MJAdqQVMP+z03Bb0HMJaRcqv+9F1KxVHXAatN+2SrOxcLHnpylD7hRmmcSqwBTTJGxJMLEo546nbqMrsjkZIMltvSNaav528Fgo1OutvuFyVCECVXwG3n7f+OolIOS0GQhBlcDEAK8L0kY6+8scCqpE+jXQWki9nU+JJV1yHAIMzaBNfKtIrpWDr5HWsV2SVBm/rKqtWdlaOGNJGiGg/Hz9dXvHH3E4J8M2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQtjer4xdW37uI79Rifq49VfOKxLIoOVi2Y6vZeImI0=;
 b=JzBK/sXqSQ9wi5/p2FpANzvmOR5DrSg5jlQ/pm9mHwDzm+gSbkr7m7dhBuEFaNCZerUYlIolktVwZ7GAWO9Lss/uENmRVguSGkmA1GmlZrxbhPcM7I/sx3HXIbv0WLjGwLH5kV2O30DtEIO0ns5UcORRsxNS78Mq8GSUXHGWOlzskanExLUO74rHaREe8dmnf9wS3kbIu8+7oYu39Hn+A0kaJXWEX2g4epm2LDafHS6RXq/G32qnJEkrqjY0GQYuZqznlJifrkfhdUBBvHMqUTAUhkZyXkhRuIPzq02wngfmT0jThDoASKoLyGaHF+VHLXvdlkvlpNNyDiT/QVo6sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQtjer4xdW37uI79Rifq49VfOKxLIoOVi2Y6vZeImI0=;
 b=GnDsIINGRHL3i7aUX2J7xIR7XGqFTXV5I0ydspvMRBWGfUSKHVlcxrLA8qoTxHKN8MYrgmRYMZGRFf+AVwkQN4FhpDFk0c5zcQ7GSxGiYULkz6NC9FadsylxZHKhxfdtdPKodBYF7rtMYlClOBYcHsgQYimVhPiNTZvgaZGe3xA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by SJ2PR12MB8876.namprd12.prod.outlook.com (2603:10b6:a03:539::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Thu, 7 Mar
 2024 05:39:32 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::9dcb:30:4f52:82f5]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::9dcb:30:4f52:82f5%5]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 05:39:32 +0000
Message-ID: <23a1af5f-e08d-4cf6-b4bd-8cfb6266f441@amd.com>
Date: Thu, 7 Mar 2024 11:09:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Do not mask LVTPC when handling a PMI on AMD
 platforms
To: Sean Christopherson <seanjc@google.com>, Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 mlevitsk@redhat.com, vkuznets@redhat.com, mizhang@google.com,
 tao1.su@linux.intel.com, andriy.shevchenko@linux.intel.com,
 ravi.bangoria@amd.com, ananth.narayan@amd.com, nikunj.dadhania@amd.com,
 santosh.shukla@amd.com, manali.shukla@amd.com
References: <20240301074423.643779-1-sandipan.das@amd.com>
 <CALMp9eRbOQpVsKkZ9N1VYTyOrKPWCmvi0B5WZCFXAPsSkShmEA@mail.gmail.com>
 <ZeYz7zPGcIQSH_NI@google.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <ZeYz7zPGcIQSH_NI@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0032.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::22) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|SJ2PR12MB8876:EE_
X-MS-Office365-Filtering-Correlation-Id: e76fac34-0eb5-4b0a-9ad8-08dc3e68f716
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4RuRyrYdZPla9eYpRn4Bp4MOTfiidVNUG2SwdmyKZ332i273OYU6cuU/Qu570g4wePjLyCK/QhUCD3MlQ0Nh/29QLQOwBmGaRvoWRqNAnHTcT2McrWZ+KO4qspRIIAwg6Bq7aBJfwTjt25gSFMtv172Deh8daUyJ/4DXo82glpZkRX1Fj3UeXktrBbOU6JlJVLiui+bfQ+244k3XgTpUn6Te3iOsD/b9Qb7NSMTuNB126okq38k3fqIq1weHxU8IYSiD3s0PjS8uWqKOuljU8xeAsVfzz2XgZkdMjWcUzyawuOofwopVFZB40PY0H5bOyC1z1I6/+n5HtYi1+79SChkfVrfpU+CxG+woLKmJJI+goTuUKLTcFmDOSosXCsZHpgUg+eghR33LzXbKiVARDKa4PucPrjSYOFUDZHpK/egG8yIwRW8HcXgxidnwbKX8VZGS0tnYHHoESxsTOEtMfcyOV8f8z3WDwsPY+1P3nDxFwXZF94rMcdGKfGXDKM6OoSA6HDoWwvxY1FfkXXLexqHp5Y0kbP+4eksK6YLcyaosfxvIg3n2xivnwTvK7tB4FecH0NFPf+HOdWfM4ZcIpbX8IMsvJ6EW8T68WbrJF9ElM3kTKqTL3A/NZheGUADp4KFIRie54Sel45Bs2j2m39sIitaAgbpEEcYxLZ8e76o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFM5SE0ybUxxekxPdi9GMGZ0aGY0elRIbllZeVNmRzcwSDFyOE1yVnBnV3pU?=
 =?utf-8?B?bmd5Q29RL2VIWlk3VjJ4cERhVjluaW9TcGxDUHlybEZITXp3dkVPVWUwSmZp?=
 =?utf-8?B?VW1lSGtjVktiRzVITkliTHhZVGtHUmFmYVFPS2JESkUvVGEwYXc1V0cvbVhP?=
 =?utf-8?B?eitzWVFRMGtnMHBtamFpT2pnSGVJR2hKK3pnaFJrejZCSll3ek8rbWV2Qkln?=
 =?utf-8?B?amhoZE4rV2Y5MGQyUVgxdzBqaVNvdFRWYlh6QVZjUEpPSW5tQlh3dnpnVzIv?=
 =?utf-8?B?U05vYm9PT1BRSmM5cWZXbEZCT2lFRVh3SVg3dit5eUp6a3JONE9hdmZybW1U?=
 =?utf-8?B?MDNSU2MzTnVPbTN6S250dFE0TEhENmZKUER6WFR6RW5GZ2NmVjV3bWVlWmtq?=
 =?utf-8?B?S1Z4U3MwU2QrOGdjUjdyalI3RTg4TnZneklKSHZVREM4NUdyeVJSbDB3RXE1?=
 =?utf-8?B?cWVDSi9ZRWlLdGhjRHpHZFpLRlNTVVo3TWFRT2xrMWovS1JNYlljK280L2x1?=
 =?utf-8?B?ZGd6L0R0SjNIb05hd2xVVzJBRnJzT1BMNkpocVVyYTB0OEt6UmsxNU95RGha?=
 =?utf-8?B?bGE0T0FtSHJ6SVNhQXlZbXpId2FiZmszTkJLTXEraWZ3ek1WbXF0Sk4rN2JT?=
 =?utf-8?B?eVpzOHBRd0tzVUlOK0RUWlc3UWtFRjBZTUcvOGx4cHR4UVE3OEZnV2xGS2Jw?=
 =?utf-8?B?eUhKWk1Gb3pMVm5rbVZESzVjUmpqQjlseUY5WUw3R1FHTUI3dEJlWHlGdWcy?=
 =?utf-8?B?dHh4QXhQclpjV2IvV1pSRnhOYmx4MjdlMG5PU2EvZ283c29INmFEZW1SWGRG?=
 =?utf-8?B?VXJ2ay83TkNmOGphOEVNaTRjZ0pVOVNIV09rL2hiTkc5YkNBZmRJOGtudmlX?=
 =?utf-8?B?czRoZSt0Tm9HUVVtbWVocjdOOXN4N0htVHVwQlFhdzhJa1hrY2pHM254MUNI?=
 =?utf-8?B?OGpya0dGaFJSZ1RlT01rSjI3ZHBKeW1IVGdZZlEzR2ZIWC9EUEpER05oRWdH?=
 =?utf-8?B?cVQreDFZbW5kak56b280dDBmRFdwNFVpWEF1aG1mejNublliMW5yOE1DcmV0?=
 =?utf-8?B?RmlBak9qT3Qxd0gwdUJmQXI2bENSR2RrcmxVOVhFaTZmdzd6OFhCd0RuL0lq?=
 =?utf-8?B?ZFJDWURaOFlZRFJGYTZCMzNzNFZVeFZaeHJTK2o2WkNOWm5nWWxrYWpjbW5P?=
 =?utf-8?B?aHVaMVdmVTdSVlEwWWFKVjh1K1EzZXJZTTFEWldvbFhJcEpZVWJHbTJ3RXJu?=
 =?utf-8?B?Wjh0cWVDK3FzRkdadS9HR1VObGRURitsb1pqajVSNXVCMjFkV1E4VXh2N1FU?=
 =?utf-8?B?c3FxMzdxdndSL1h2aDUrUDlMdmw4clpzZlUrdGQ4WE5uSXJiWGVGL1oxRWFQ?=
 =?utf-8?B?V25LMW9vZU1WV0tldDFJczNMWnk3bHJINFdWTHdmd3NrYVd1WlBBQmtock9l?=
 =?utf-8?B?bWMyK2tJcjN5SkYwNjFhNzlaY0pKb1VqYmdObG8ydVBDSXBWVzRpUjlvaDg5?=
 =?utf-8?B?NGNGbGRoTFkrR09iUy9nMHJjekVWeXBPdTFDRWF4T21HM29aOUJuSGJBbk5R?=
 =?utf-8?B?UGphMjlVZHJJdEJHRndGdXNyZi9ZN2xRREZHSHhiTTBQWk15VzFWTEZCdGky?=
 =?utf-8?B?aHhFd0RDdC9LUUkrYlVxNnl1dzl2UFkrZnRDRnErM1didHJYUXE4RXZHYzZ1?=
 =?utf-8?B?L1I2YmFGdU9IS3lHRlo0SnNudDQrMitING1VZTZldFFSclg4Wm9hdE5Mb3RP?=
 =?utf-8?B?Tms0ZDlFNEFrZnNDT1RBRkZSbTlISlZaZExNaGxlckJ6WDZnbExqdmZNY1RL?=
 =?utf-8?B?VzlmU1hic283aUwwY2xyN0k3OTBJOWlJeXh4anVZUlNrODd5WkQzektsUWZv?=
 =?utf-8?B?bnRTZzFrZ2ZCZW5zdmtSSDgxbURFNmxDZDI1cUR3YkFBTGV3UDYrU0JVK2Nl?=
 =?utf-8?B?cURhUGpSdlhmblY3amRZYmFUM3FLTWlOVE4wZTRtblZJMmFzSGJvd2REaUJy?=
 =?utf-8?B?bFk4TS9VNW85dElsZnZHTWZSR0lFNHBBT3JEeFNHNG9ZZnRpT0M4bHBKandS?=
 =?utf-8?B?aEQ4aGo1Y29YNThmQks0aHc4TVhCT285NzMvY3ozM284RmJMRjFrU0R6VDFo?=
 =?utf-8?Q?7aZKEmUtVH9iqFKNs6+QpMOp0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e76fac34-0eb5-4b0a-9ad8-08dc3e68f716
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 05:39:32.4109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 06C4tXg0DKE7nnpVys7qWa4egjozlz1KAvOVzFvum1jucU5ZbDdlg/SwZjE28IGs5+dv/kv3Okn8ESSPITLCjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8876

On 3/5/2024 2:19 AM, Sean Christopherson wrote:
> On Fri, Mar 01, 2024, Jim Mattson wrote:
>> On Thu, Feb 29, 2024 at 11:44 PM Sandipan Das <sandipan.das@amd.com> wrote:
>>>
>>> On AMD and Hygon platforms, the local APIC does not automatically set
>>> the mask bit of the LVTPC register when handling a PMI and there is
>>> no need to clear it in the kernel's PMI handler.
>>
>> I don't know why it didn't occur to me that different x86 vendors
>> wouldn't agree on this specification. :)
> 
> Because you're sane?  :-D
> 
>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>> index 3242f3da2457..0959a887c306 100644
>>> --- a/arch/x86/kvm/lapic.c
>>> +++ b/arch/x86/kvm/lapic.c
>>> @@ -2768,7 +2768,7 @@ int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
>>>                 trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
>>>
>>>                 r = __apic_accept_irq(apic, mode, vector, 1, trig_mode, NULL);
>>> -               if (r && lvt_type == APIC_LVTPC)
>>> +               if (r && lvt_type == APIC_LVTPC && !guest_cpuid_is_amd_or_hygon(apic->vcpu))
>>
>> Perhaps we could use a positive predicate instead:
>> guest_cpuid_is_intel(apic->vcpu)?
> 
> AFAICT, Zhaoxin follows intel behavior, so we'd theoretically have to allow for
> that too.  The many checks of guest_cpuid_is_intel() in KVM suggest that no one
> actually cares about about correctly virtualizing Zhaoxin CPUs, but it's an easy
> enough problem to solve.
> 
> I'm also very tempted to say KVM should cache the Intel vs. AMD vCPU model.  E.g.
> if userspace does something weird with guest CPUID and puts CPUID.0x0 somewhere
> other than the zeroth entry, KVM's linear walk to find a CPUID entry will make
> this a pretty slow lookup.
> 
> Then we could also encapsulate the gory details for Intel vs. Zhaoxin vs. Centaur,
> and AMD vs. Hygon, e.g.
> 
> 		if (r && lvt_type == APIC_LVTPC &&
> 		    apic->vcpu->arch.is_model_intel_compatible)

The following are excerpts from some changes that I have been working on. Instead
of a boolean flag, this saves the compatible vendor in kvm_vcpu_arch and tries
to match it against X86_VENDOR_* values. The goal is to replace
guest_cpuid_is_{intel,amd_or_hygon}() with
guest_vendor_is_compatible(vcpu, X86_VENDOR_{INTEL,AMD}). Is this viable?

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d271ba20a0b2..c4ada5b12fc3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1042,6 +1042,7 @@ struct kvm_vcpu_arch {
 #if IS_ENABLED(CONFIG_HYPERV)
        hpa_t hv_root_tdp;
 #endif
+       u8 compat_vendor;
 };

 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index adba49afb5fe..00170762e72a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -376,6 +376,13 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
        kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu->arch.cpuid_entries,
                                                    vcpu->arch.cpuid_nent));

+       if (guest_cpuid_is_intel_compatible(vcpu))
+               vcpu->arch.compat_vendor = X86_VENDOR_INTEL;
+       else if (guest_cpuid_is_amd_or_hygon(vcpu))
+               vcpu->arch.compat_vendor = X86_VENDOR_AMD;
+       else
+               vcpu->arch.compat_vendor = X86_VENDOR_UNKNOWN;
+
        /* Invoke the vendor callback only after the above state is updated. */
        static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 856e3037e74f..8c73db586231 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -120,6 +120,17 @@ static inline bool guest_cpuid_is_intel(struct kvm_vcpu *vcpu)
        return best && is_guest_vendor_intel(best->ebx, best->ecx, best->edx);
 }

+static inline bool guest_cpuid_is_intel_compatible(struct kvm_vcpu *vcpu)
+{
+       struct kvm_cpuid_entry2 *best;
+
+       best = kvm_find_cpuid_entry(vcpu, 0);
+       return best &&
+              (is_guest_vendor_intel(best->ebx, best->ecx, best->edx) ||
+               is_guest_vendor_centaur(best->ebx, best->ecx, best->edx) ||
+               is_guest_vendor_zhaoxin(best->ebx, best->ecx, best->edx));
+}
+
 static inline int guest_cpuid_family(struct kvm_vcpu *vcpu)
 {
        struct kvm_cpuid_entry2 *best;
@@ -142,6 +153,11 @@ static inline int guest_cpuid_model(struct kvm_vcpu *vcpu)
        return x86_model(best->eax);
 }

+static inline bool guest_vendor_is_compatible(struct kvm_vcpu *vcpu, u8 vendor)
+{
+       return vcpu->arch.compat_vendor == vendor;
+}
+
 static inline bool cpuid_model_is_consistent(struct kvm_vcpu *vcpu)
 {
        return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);


