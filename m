Return-Path: <kvm+bounces-10980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9170F872023
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:29:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2028A284D59
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A7F85C61;
	Tue,  5 Mar 2024 13:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="jY8OimRt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2108.outbound.protection.outlook.com [40.107.102.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8E78592E;
	Tue,  5 Mar 2024 13:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709645367; cv=fail; b=X+lMGOPRnhFAwa9ZajZwckxez2aMYgSiyE4RreWgMmoPQ0n7Od/sUgIgWzkJKtzRmd19fHPJf2eNnUVilDLBUl5tbfjzvhg+mVU3KgryH6oia1I4i2gf59UshQ52EDjhsRlLH2ecpv38wWD+OE9XFbu7ZWlxTCM/blwtKYEd1BQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709645367; c=relaxed/simple;
	bh=RRouLKs6YHQ3X/5+nEXplzMSQ/233NPWd3s6SJGmpU8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hW2GBmktW5YuWDZV38tGe5q4YyRcnfIyx+Lm22bJzWVgVOK4r98VzVUrE7xR+WQROrUE07Cjs4qHVuEqO05jPgKl8Joj/MNqGTHkEDEyWP8KN7SIXclH2W2e90UmDit7W8Rd944SrXs0OlK4L7/r/MuW6EaN+H1hXjJyrO4vers=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=jY8OimRt; arc=fail smtp.client-ip=40.107.102.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PxoGYH4xq/zxOXCxsNHubnc06oZ8jmpbJ/nVvuYgkPE2sCxs/+bHt3IndT4584z/eMaVVX/n5rDt8I1pcRrFUj1n8kbmdLsz96JEWoAhddqA9hY6RZgNQf01vvSgBO0z+IzNOWhZyZ2KodtOaGC24YmJCSb7RVXzv8Om8P6c9QCOfNnfLhAypMSfJNYHFK8Zgs2DtkTgzNRCg53EeUir8e2pS89yy88R2oAMUgnBKABY5buV2QNvDGm1dWI0zznS4pCKD5fBWMxObUkupSys758HaF7KTrJHWf7SEs/t27cdAh5bcR3RjoDm9MddsruZoVjLoC8QHPrLwDv3LHT2/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D/OOi4egTqEyQCQPrXZdfS0oQjURoevaCknh5NdrOJ4=;
 b=kUBmqcw/JrnnUU3WJOfCW8Z2HdABK9bBhogcuHXxUH68STBbEVz/c+P1QzLx2+TcRQ3JBZrlM8gAOhHbyRwMsXIMboNQLdSD4R9KIpmKqbefzHvodkSRcjQga1IYVA7m4wbvIMoVeokEk1CzeDaM+soZgVKTtRWqDn6POGPfBj4XeNclbLU3psfEQcwY0XBqt86i2Q6A9P1zE7NmA4PNydkXxrYxyRuKt8zVjEFguowwBIvqBSyc2WlT7lJ4Jh2nEaZ5o9WlzUHdtbMH5V2DPK2bs45WOFJTGWZeQyyjzsZWU1dWcWkMsKMjG/XUI7yljka1Tjj6dhKwsjxIqVmvcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/OOi4egTqEyQCQPrXZdfS0oQjURoevaCknh5NdrOJ4=;
 b=jY8OimRtNnQ8kVL/oSy2XOs/wFnNu7Fv1boq/Nz+b8Apz94E+v0H15K4AZuK/sxBbGM4volX6j8tY6cJPPtM4GrdI9PSyeK22euu9LsDy7SxhTvXfRl6JSEMzVKd9u/fs4e/cDRzCDlJWhFRuDkLJ3IEARzcRSKcbTuexMT053Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 CH3PR01MB8246.prod.exchangelabs.com (2603:10b6:610:17e::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.36; Tue, 5 Mar 2024 13:29:17 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9%3]) with mapi id 15.20.7339.035; Tue, 5 Mar 2024
 13:29:17 +0000
Message-ID: <6685c3a6-2017-4bc2-ad26-d11949097050@os.amperecomputing.com>
Date: Tue, 5 Mar 2024 18:59:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] kvm: nv: Optimize the unmapping of shadow S2-MMU
 tables.
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 oliver.upton@linux.dev, darren@os.amperecomputing.com,
 d.scott.phillips@amperecomputing.com
References: <20240305054606.13261-1-gankulkarni@os.amperecomputing.com>
 <86sf150w4t.wl-maz@kernel.org>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86sf150w4t.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0053.namprd13.prod.outlook.com
 (2603:10b6:610:b2::28) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|CH3PR01MB8246:EE_
X-MS-Office365-Filtering-Correlation-Id: bb29e10c-9688-4134-c200-08dc3d1841a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ddnAqEPv38GE/wVimnuKMFHGApW6jD7LxFfs9oRcuDQLGAUS0BsSC2TJK6nrxaerU5PtiE5v+NClMMVJnQHFz+kzjN82NfOW5SXJVz2k1XbYc6o6r1nKhVtsri/L6xhSycS/Ipt079hWc8aFcL8zniQoRWUdDC5VprAucWyTC2alInlnM4k9QdjleD8FK7LtPMHCmte4SgFTNW3VXPWbWMF/XS69T8P3+dayXhDxP6xTIgj14eFeA9+BtTfpl/4peEhM4DBdTCYXTtwqZ/H/GfQTW9JxGY8j++WVqdPSwyehZ3vCrTmfEF4Z7vgxKtk55RHpfNJABDYInj7WCDhj/1Z5+RxtqGc0+cWIknqZLUcV++7fnbFTZwM3AQREqRhm9GEcPvkJ7o4TR9uuCK7TdMuZbu1ExfOVz9Cc5hOEhADyIzHmTFrGVmidQiLAOkeUWkw/w+sG2i6dOfxm1fJ6ZSr/bVRYyqGWi3fAvXm3PERy+7faztMhkJ8gNHFUZcn8XvbW5akokwLhVjm4foj2AuNt2XqRPkYuZJfhD2H32fJlxi8wX51vCbeTqDBSM4MSiADMAyz+Nvky+8EZQ7VL6IPd2k8aArZS5FWNOkczac5XWtDcatZezmb/ElelW1Dyr/lmMUhC8FBzyNpgLZXS5UB3MPf86BmbnyXq9Gs2Xxo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MTNuZnk3QUJCMUNQdDY2THRCZnFUZDhrVnJFa2RPYWFWbzBQYmdzaFNHalQy?=
 =?utf-8?B?Ym5kczVCU0I5VWtDeHpvTFJNdW8xUkd0U1VxY3RuU01aUVBqc09lTFJ0Mldy?=
 =?utf-8?B?a25zWUlmeEFVNEc1RWxGWXNqdUhyTnJLODUvTFpCbVlqWWdsWmFFd2JQQm14?=
 =?utf-8?B?QlcyWHdnSDZNZXhFM0JCVUNxTFJBNHFWdUhDN1dLN01DZzZyL2Z1aDlaVWh2?=
 =?utf-8?B?S1FQMzhtbUdxNkE3M2o5ZGpIby9ocVRuU0xIcUVRSlNwbk0ySytQL013VGdU?=
 =?utf-8?B?dSs3eEhDM0tEV2xWdEV4ME5pNHVRVFE0QWpYeGk0aFU5bDJmcUhmNUt2V0lS?=
 =?utf-8?B?K1pmbTA3bTl2TXIzUVdzdVgzSnVhSlFjZWk5U1VkdS8xbC92MUJib0VYY1RK?=
 =?utf-8?B?b3hOT0pSSWRWcy9ZMGRIMmpWR0lWdUwxWFRBdzRGNVhLSDhqdktLOHBWMkk5?=
 =?utf-8?B?aTJhS0cvZ0d5am12SDRwZG1lYkRkQmp2ZVYwZ0srczBzWEhLMWNqOTRoNTll?=
 =?utf-8?B?WDQxN1NheDdjRHlBOFJreFRuT0g0cjdRdEtIdzlObmg4VFlYL3pUQlpDVE1M?=
 =?utf-8?B?YmtSTTM2ZXJVSGo5VFN4Y3NLbjlyZ256amg2a3U5TGE3UGVDYjZaREZhY1R0?=
 =?utf-8?B?bGFJWVQ0Ukt4ak82V2huUzhBeng0ZnQ0bWdjZmJkUjlnR092T2J2c0tiUmht?=
 =?utf-8?B?V1dKNGNuSmxzWWNBNVZDWDNOUEdWVVB4NEN6VjJiUnRZUC9TUWg2UGxWSE1H?=
 =?utf-8?B?RHNzS3pGWUQ0MWZ4L1FSclE3SUROUVg1SGxPU25UOFdwUXhCVFphNUNHcldu?=
 =?utf-8?B?VXUzUTBGZ2RnZ0Q5ZXV0ZW5USGFMYTRwaE5GSHFra3RrZjU2R2tsNndIR21V?=
 =?utf-8?B?REpabm1yTFpFb3dRcjVXdkZMalZLOGxnWEJXNWtCNC9PbUh4NXcvd3ZQb3FB?=
 =?utf-8?B?RXFKak84dXZsMjRRajVFUjVtb1VxS3ZocnFvK01NckdhNHdaOWlKUzV0Z2R0?=
 =?utf-8?B?N2s2YXdiOURFajR4WkVUaW1BejRmUk5NQWQyS3RmVXozWG4xajFyaCtpQzNQ?=
 =?utf-8?B?d2hrQXVCeDBKRFdKUGEydFRlcWh3bi9zNk1CRHUrUTZ5cE91ZG9DM0JTVFVQ?=
 =?utf-8?B?dlM2YXdtRHdwa096RWpiWHgyWG5KRHd3emxLTC9QWHBMMjhMRHhLZ3JleExl?=
 =?utf-8?B?UG8rSzAyOElGRnRFQ2VVVDZBM0tqc29LUHBKVHY2ZnRZY1o0TG1JV1FTZktn?=
 =?utf-8?B?Vjg4MHNFNjg5eU9IeXV5VTEzdUpKaVhBWng5c25kUWxQSC8rNWR4bU02TmpU?=
 =?utf-8?B?bW9GSDNyU1F6akpVTkIvMm5jRHFtem5UNy9FZEpMNVdwdk9SNm9zd0M5R09Q?=
 =?utf-8?B?bVhrYkpmOGpOMmxTNG4wdFJEV2pXanJqS0VEYzYzWU5ZMEFLWUgwMWk4dHgv?=
 =?utf-8?B?dmM5YUkwSEVjaUp4NWpnTFBCUWdMOTN1a0orQ1U1SHlPekdIUnpOd1pCZ25P?=
 =?utf-8?B?QnlTL2YwWW5WVWF3RU9zQXVaa0NGRUpEMkY5OVJtbUljM0x1TWFMcE9YY05G?=
 =?utf-8?B?WnkvR0xtVkw5SElZR1hvUjNQaVFFZmZYR0JqQmhIN0xCdnVvTGMzbW5Dc1VV?=
 =?utf-8?B?c3hsSG11dW9UaGMzRldwNGhJTXB1UGxxOE1PNnkzZ3ZZaklMRkFvTEIreHAz?=
 =?utf-8?B?YzZwZzlETEZnMk5udWc4bGh4bjRPdE93YkVzMDltcTlqb0xlYVA5V0Zmc2xo?=
 =?utf-8?B?VHlKNmx0azFpQTNoM3dnK0RGUURraU93T1NNWFhTWm1PU2hKeTRDQnBRWWs2?=
 =?utf-8?B?cEE3Sjg5Z2VPWEdsa0RtVS91b1d2UE1FTkpoM05zK1V0NEg3MHg1UXFQV2lj?=
 =?utf-8?B?RFlaSnpWcmNWM2lQT0drYlNPbWludWJVRVdRL1ZkMXk4ekNDcG5JbFhUaEw2?=
 =?utf-8?B?dHp1SHd1NmxIT214RUo5NVBUSnBoWS82SzdvelBGZHAzMkNCMGFpaGQ5VFhv?=
 =?utf-8?B?bGpiaVRZZ3Q4N2pmM1R2bkptYTcxVXJiUmI1enhLUjA3bHhYc0c3MDhMWVVC?=
 =?utf-8?B?aUR0Z0tGVC9uY0FUTW96VGRKWU8xd00yS2RETk1SQW4vMXNndkk0QVAvbU1w?=
 =?utf-8?B?UGR3RG41SmxXSUNWeU10L2d4c0JZMXAvOXRHenVmbUlYU05qcThpRmgyYkdP?=
 =?utf-8?Q?7tEGS1LVoVNNlML/Naz8rw0H5T41rFs+2Ef8nfyLQSW6?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb29e10c-9688-4134-c200-08dc3d1841a0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 13:29:17.0449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 18oRFzqsORAD28o7j3BvMJXsj4ZS//aIVaVKXUgjHIAIIohPd5AMgwVoerHenkoprlCmJ7eF4QUqfoXAE/AYNfF8gIgUiHY8APwm/nh54k8flw2z1LBNgPP1p2R5+0h2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR01MB8246



On 05-03-2024 04:43 pm, Marc Zyngier wrote:
> [re-sending with kvmarm@ fixed]
> 
> On Tue, 05 Mar 2024 05:46:06 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>> As per 'commit 178a6915434c ("KVM: arm64: nv: Unmap/flush shadow stage 2
> 
> $ git describe --contains 178a6915434c --match=v\*
> fatal: cannot describe '178a6915434c141edefd116b8da3d55555ea3e63'
> 

My bad(I would have been more verbose), I missed to mention that this 
patch is on top of NV-V11 patch series.

> This commit simply doesn't exist upstream. It only lives in a
> now deprecated branch that will never be merged.
> 
>> page tables")', when ever there is unmap of pages that
>> are mapped to L1, they are invalidated from both L1 S2-MMU and from
>> all the active shadow/L2 S2-MMU tables. Since there is no mapping
>> to invalidate the IPAs of Shadow S2 to a page, there is a complete
>> S2-MMU page table walk and invalidation is done covering complete
>> address space allocated to a L2. This has performance impacts and
>> even soft lockup for NV(L1 and L2) boots with higher number of
>> CPUs and large Memory.
>>
>> Adding a lookup table of mapping of Shadow IPA to Canonical IPA
>> whenever a page is mapped to any of the L2. While any page is
>> unmaped, this lookup is helpful to unmap only if it is mapped in
>> any of the shadow S2-MMU tables. Hence avoids unnecessary long
>> iterations of S2-MMU table walk-through and invalidation for the
>> complete address space.
> 
> All of this falls in the "premature optimisation" bucket. Why should
> we bother with any of this when not even 'AT S1' works correctly,

Hmm, I am not aware of this, is this something new issue of V11?

> making it trivial to prevent a guest from making forward progress? You
> also show no numbers that would hint at a measurable improvement under
> any particular workload.

This patch is avoiding long iterations of unmap which was resulting in 
soft-lockup, when tried L1 and L2 with 192 cores.
Fixing soft lockup isn't a required fix for feature enablement?

> 
> I am genuinely puzzled that you are wasting valuable engineering time
> on *this*.
> 
>>
>> Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h |   5 ++
>>   arch/arm64/include/asm/kvm_host.h    |  14 ++++
>>   arch/arm64/include/asm/kvm_nested.h  |   4 +
>>   arch/arm64/kvm/mmu.c                 |  19 ++++-
>>   arch/arm64/kvm/nested.c              | 113 +++++++++++++++++++++++++++
>>   5 files changed, 152 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 5173f8cf2904..f503b2eaedc4 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -656,4 +656,9 @@ static inline bool kvm_is_shadow_s2_fault(struct kvm_vcpu *vcpu)
>>   		vcpu->arch.hw_mmu->nested_stage2_enabled);
>>   }
>>   
>> +static inline bool kvm_is_l1_using_shadow_s2(struct kvm_vcpu *vcpu)
>> +{
>> +	return (vcpu->arch.hw_mmu != &vcpu->kvm->arch.mmu);
>> +}
> 
> Isn't that the very definition of "!in_hyp_ctxt()"? You are abusing

"!in_hyp_ctxt()" isn't true for non-NV case also?
This function added to know that L1 is NV enabled and using shadow S2.

> the hw_mmu pointer to derive something, but the source of truth is the
> translation regime, as defined by HCR_EL2.{E2H,TGE} and PSTATE.M.
> 

OK, I can try HCR_EL2.{E2H,TGE} and PSTATE.M instead of hw_mmu in next 
version.

>> +
>>   #endif /* __ARM64_KVM_EMULATE_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 8da3c9a81ae3..f61c674c300a 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -144,6 +144,13 @@ struct kvm_vmid {
>>   	atomic64_t id;
>>   };
>>   
>> +struct mapipa_node {
>> +	struct rb_node node;
>> +	phys_addr_t ipa;
>> +	phys_addr_t shadow_ipa;
>> +	long size;
>> +};
>> +
>>   struct kvm_s2_mmu {
>>   	struct kvm_vmid vmid;
>>   
>> @@ -216,6 +223,13 @@ struct kvm_s2_mmu {
>>   	 * >0: Somebody is actively using this.
>>   	 */
>>   	atomic_t refcnt;
>> +
>> +	/*
>> +	 * For a Canonical IPA to Shadow IPA mapping.
>> +	 */
>> +	struct rb_root nested_mapipa_root;
> 
> Why isn't this a maple tree? If there is no overlap between mappings
> (and it really shouldn't be any), why should we use a bare-bone rb-tree?
> 
>> +	rwlock_t mmu_lock;
> 
> Hell no. We have plenty of locking already, and there is no reason why
> this should gain its own locking. I can't see a case where you would
> take this lock outside of holding the *real* mmu_lock -- extra bonus
> point for the ill-chosen name.

OK, this should be avoided with maple tree.
> 
>> +
>>   };
>>   
>>   static inline bool kvm_s2_mmu_valid(struct kvm_s2_mmu *mmu)
>> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
>> index da7ebd2f6e24..c31a59a1fdc6 100644
>> --- a/arch/arm64/include/asm/kvm_nested.h
>> +++ b/arch/arm64/include/asm/kvm_nested.h
>> @@ -65,6 +65,9 @@ extern void kvm_init_nested(struct kvm *kvm);
>>   extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
>>   extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
>>   extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
>> +extern void add_shadow_ipa_map_node(
>> +		struct kvm_s2_mmu *mmu,
>> +		phys_addr_t ipa, phys_addr_t shadow_ipa, long size);
>>   
>>   union tlbi_info;
>>   
>> @@ -123,6 +126,7 @@ extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
>>   extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
>>   extern void kvm_nested_s2_wp(struct kvm *kvm);
>>   extern void kvm_nested_s2_unmap(struct kvm *kvm);
>> +extern void kvm_nested_s2_unmap_range(struct kvm *kvm, struct kvm_gfn_range *range);
>>   extern void kvm_nested_s2_flush(struct kvm *kvm);
>>   int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>>   
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 61bdd8798f83..3948681426a0 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1695,6 +1695,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   					     memcache,
>>   					     KVM_PGTABLE_WALK_HANDLE_FAULT |
>>   					     KVM_PGTABLE_WALK_SHARED);
>> +		if ((nested || kvm_is_l1_using_shadow_s2(vcpu)) && !ret) {
> 
> I don't understand this condition. If nested is non-NULL, it's because
> we're using a shadow S2. So why the additional condition?

No, nested is set only for L2, for L1 it is not.
To handle L1 shadow S2 case, I have added this condition.

> 
>> +			struct kvm_s2_mmu *shadow_s2_mmu;
>> +
>> +			ipa &= ~(vma_pagesize - 1);
>> +			shadow_s2_mmu = lookup_s2_mmu(vcpu);
>> +			add_shadow_ipa_map_node(shadow_s2_mmu, ipa, fault_ipa, vma_pagesize);
>> +		}
>>   	}
>>   
>>   	/* Mark the page dirty only if the fault is handled successfully */
>> @@ -1918,7 +1925,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>>   			     (range->end - range->start) << PAGE_SHIFT,
>>   			     range->may_block);
>>   
>> -	kvm_nested_s2_unmap(kvm);
>> +	kvm_nested_s2_unmap_range(kvm, range);
>>   	return false;
>>   }
>>   
>> @@ -1953,7 +1960,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>>   			       PAGE_SIZE, __pfn_to_phys(pfn),
>>   			       KVM_PGTABLE_PROT_R, NULL, 0);
>>   
>> -	kvm_nested_s2_unmap(kvm);
>> +	kvm_nested_s2_unmap_range(kvm, range);
>>   	return false;
>>   }
>>   
>> @@ -2223,12 +2230,18 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
>>   void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>>   				   struct kvm_memory_slot *slot)
>>   {
>> +	struct kvm_gfn_range range;
>> +
>>   	gpa_t gpa = slot->base_gfn << PAGE_SHIFT;
>>   	phys_addr_t size = slot->npages << PAGE_SHIFT;
>>   
>> +	range.start = gpa;
>> +	range.end = gpa + size;
>> +	range.may_block = true;
>> +
>>   	write_lock(&kvm->mmu_lock);
>>   	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
>> -	kvm_nested_s2_unmap(kvm);
>> +	kvm_nested_s2_unmap_range(kvm, &range);
>>   	write_unlock(&kvm->mmu_lock);
>>   }
>>   
>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>> index f88d9213c6b3..888ec9fba4a0 100644
>> --- a/arch/arm64/kvm/nested.c
>> +++ b/arch/arm64/kvm/nested.c
>> @@ -565,6 +565,88 @@ void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
>>   	write_unlock(&kvm->mmu_lock);
>>   }
>>   
>> +/*
>> + * Create a node and add to lookup table, when a page is mapped to
>> + * Canonical IPA and also mapped to Shadow IPA.
>> + */
>> +void add_shadow_ipa_map_node(struct kvm_s2_mmu *mmu,
>> +			phys_addr_t ipa,
>> +			phys_addr_t shadow_ipa, long size)
>> +{
>> +	struct rb_root *ipa_root = &(mmu->nested_mapipa_root);
>> +	struct rb_node **node = &(ipa_root->rb_node), *parent = NULL;
>> +	struct mapipa_node *new;
>> +
>> +	new = kzalloc(sizeof(struct mapipa_node), GFP_KERNEL);
>> +	if (!new)
>> +		return;
>> +
>> +	new->shadow_ipa = shadow_ipa;
>> +	new->ipa = ipa;
>> +	new->size = size;
>> +
>> +	write_lock(&mmu->mmu_lock);
>> +
>> +	while (*node) {
>> +		struct mapipa_node *tmp;
>> +
>> +		tmp = container_of(*node, struct mapipa_node, node);
>> +		parent = *node;
>> +		if (new->ipa < tmp->ipa) {
>> +			node = &(*node)->rb_left;
>> +		} else if (new->ipa > tmp->ipa) {
>> +			node = &(*node)->rb_right;
>> +		} else {
>> +			write_unlock(&mmu->mmu_lock);
>> +			kfree(new);
>> +			return;
>> +		}
>> +	}
>> +
>> +	rb_link_node(&new->node, parent, node);
>> +	rb_insert_color(&new->node, ipa_root);
>> +	write_unlock(&mmu->mmu_lock);
> 
> All this should be removed in favour of simply using a maple tree.
> 

Thanks for the suggestion to use maple tree. I will use it in next 
version, which help to avoid the locks.

>> +}
>> +
>> +/*
>> + * Iterate over the lookup table of Canonical IPA to Shadow IPA.
>> + * Return Shadow IPA, if the page mapped to Canonical IPA is
>> + * also mapped to a Shadow IPA.
>> + *
>> + */
>> +bool get_shadow_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa, phys_addr_t *shadow_ipa, long *size)
> 
> static?

It should be, thanks.
> 
>> +{
>> +	struct rb_node *node;
>> +	struct mapipa_node *tmp = NULL;
>> +
>> +	read_lock(&mmu->mmu_lock);
>> +	node = mmu->nested_mapipa_root.rb_node;
>> +
>> +	while (node) {
>> +		tmp = container_of(node, struct mapipa_node, node);
>> +
>> +		if (tmp->ipa == ipa)
> 
> What guarantees that the mapping you have for L1 has the same starting
> address as the one you have for L2? L1 could have a 2MB mapping and L2
> only 4kB *in the middle*.

IIUC, when a page is mapped to 2MB in L1, it won't be
mapped to L2 and we iterate with the step of PAGE_SIZE and we should be 
hitting the L2's IPA in lookup table, provided the L2 page falls in 
unmap range.

> 
>> +			break;
>> +		else if (ipa > tmp->ipa)
>> +			node = node->rb_right;
>> +		else
>> +			node = node->rb_left;
>> +	}
>> +
>> +	read_unlock(&mmu->mmu_lock);
> 
> Why would you drop the lock here....
> 
>> +
>> +	if (tmp && tmp->ipa == ipa) {
>> +		*shadow_ipa = tmp->shadow_ipa;
>> +		*size = tmp->size;
>> +		write_lock(&mmu->mmu_lock);
> 
> ... if taking it again here? What could have changed in between?
> 
>> +		rb_erase(&tmp->node, &mmu->nested_mapipa_root);
>> +		write_unlock(&mmu->mmu_lock);
>> +		kfree(tmp);
>> +		return true;
>> +	}
>> +	return false;
>> +}
> 
> So simply hitting in the reverse mapping structure *frees* it? Meaning
> that you cannot use it as a way to update a mapping?

Freeing it since this page already unmapped/migrated on host and will be 
done on shadow S2 after this lookup. I should have considered other 
cases as well, as Oliver mentioned.

> 
>> +
>>   /* Must be called with kvm->mmu_lock held */
>>   struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu)
>>   {
>> @@ -674,6 +756,7 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
>>   	mmu->tlb_vttbr = 1;
>>   	mmu->nested_stage2_enabled = false;
>>   	atomic_set(&mmu->refcnt, 0);
>> +	mmu->nested_mapipa_root = RB_ROOT;
>>   }
>>   
>>   void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
>> @@ -760,6 +843,36 @@ void kvm_nested_s2_unmap(struct kvm *kvm)
>>   	}
>>   }
>>   
>> +void kvm_nested_s2_unmap_range(struct kvm *kvm, struct kvm_gfn_range *range)
>> +{
>> +	int i;
>> +	long size;
>> +	bool ret;
>> +
>> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>> +
>> +		if (kvm_s2_mmu_valid(mmu)) {
>> +			phys_addr_t shadow_ipa, start, end;
>> +
>> +			start = range->start << PAGE_SHIFT;
>> +			end = range->end << PAGE_SHIFT;
>> +
>> +			while (start < end) {
>> +				size = PAGE_SIZE;
>> +				/*
>> +				 * get the Shadow IPA if the page is mapped
>> +				 * to L1 and also mapped to any of active L2.
>> +				 */
> 
> Why is L1 relevant here?

We do map while L1 boots(early stage) in shadow S2, at that moment
if the L1 mapped page is unmapped/migrated we do need to unmap from L1's 
S2 table also.

> 
>> +				ret = get_shadow_ipa(mmu, start, &shadow_ipa, &size);
>> +				if (ret)
>> +					kvm_unmap_stage2_range(mmu, shadow_ipa, size);
>> +				start += size;
>> +			}
>> +		}
>> +	}
>> +}
>> +
>>   /* expects kvm->mmu_lock to be held */
>>   void kvm_nested_s2_flush(struct kvm *kvm)
>>   {
> 
> There are a bunch of worrying issues with this patch. But more
> importantly, this looks like a waste of effort until the core issues
> that NV still has are solved, and I will not consider anything of the
> sort until then.

OK thanks for letting us know, I will pause the work on V2 of this patch 
until then.

> 
> I get the ugly feeling that you are trying to make it look as if it
> was "production ready", which it won't be for another few years,
> specially if the few interested people (such as you) are ignoring the
> core issues in favour of marketing driven features ("make it fast").
> 

What are the core issues (please forgive me if you mentioned already)? 
certainly we will prioritise them than this.

> Thanks,
> 
> 	M.
> 

Thanks,
Ganapat

