Return-Path: <kvm+bounces-1619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E31857EA7F8
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 01:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 117A41C209FB
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 00:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE8D46AE;
	Tue, 14 Nov 2023 00:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VumYyGzC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2001D440F
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 00:57:42 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5E6D51;
	Mon, 13 Nov 2023 16:57:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHQNsYjapjIOvAcUfJ7H9K8k69VqGh6WJb630sYp1c0rYh8GqiUlsr5KQSXbkm7RMCMDvh9GVw1Ah1+OjefUhTRRoOqqKcY936K60ZS6kwPD8FFamPiIoXsBTQF1ECarGgIZ9lMe0OYzaBOR92IGHAmbFlDwmW3WAWCwjgfKcbQhKVOe+S7no15UQ2/a83UY79Z4XH9xdbly6wJ+sQRxN2pewOnNiGXXEla6c/nH60bJvmuyyHXMeYwP9chO1CltoHU5qEiBkwNLZGI4SuuMeM5FkOqRqpza/pOy7sV+D7cLVqx4tIOaNUNuUFNjKDQ5nDfDSRfgcVp3cZ0QlHPUqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J6y1jei7nFWXhWMzYGBZb3vLPn0CIxYrvBKAZklq0nE=;
 b=MGnGLkJjFpe8o5/roJaR59YJr8/dp059YLfh+trJLr/Od7hLYgikewEIxhKk8oqMy4ErhtsDRP/3bAlD0f6Rg94isTvihXQcYpOIgdtEx7ncqq7HqJIJqqHrh56ytc5oYMutvk9SYqz0tUW4TVqiyIQRkus4XPviHgi/51u7iAuWSbjMWyoZRADiD6W+quQK3dh4kImhLFwqbmsQElf/pGJKi4GalTksPAPJ5c3NpzLA+k7Z6n2v/gWhA5PKJNHmxZGDWG1yfUj3AUBOCpS2Bptq/x4kCYDe2L+soS+N43FUdu2hUVHBf1US1sbpPV8fWXloh2AtB0xEZc0lsIlZXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6y1jei7nFWXhWMzYGBZb3vLPn0CIxYrvBKAZklq0nE=;
 b=VumYyGzC4kawbNZxf3/uRX4zYp1i+LeyEG2LTd/uXJ44vDkXATHjmrWHKyDqmlMlDg5xri2RhfmW3TRKg5wk5kIJWFPNewUM3TdTmH7nIvN1bplXNhfWu09vXB3VNkPX6lEFAXV1hNruCjedEnllBc9pPpI71zYjWwVxQoI54+w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CY5PR12MB6431.namprd12.prod.outlook.com (2603:10b6:930:39::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Tue, 14 Nov
 2023 00:57:37 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::3112:5f54:2e51:cf89]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::3112:5f54:2e51:cf89%5]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 00:57:37 +0000
Message-ID: <51bf9fed-2bad-4eb1-bbc7-239200bff668@amd.com>
Date: Tue, 14 Nov 2023 11:57:34 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: TDISP enablement
Content-Language: en-US
To: Samuel Ortiz <sameo@rivosinc.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org, linux-pci@vger.kernel.org
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
 <ZVG3fREeTQqvHLb/@vermeer> <58a60211-1edc-4238-b4a3-fe7faf3b6458@amd.com>
 <ZVI8Y8VICy/SwYy5@vermeer>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZVI8Y8VICy/SwYy5@vermeer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0116.namprd13.prod.outlook.com
 (2603:10b6:806:24::31) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CY5PR12MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: a845dd74-f0ec-41a1-ffed-08dbe4acb1d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4nc2YkyRRr5dS8kgPgoJ/PDCI/J/VUtnLHl4CYIyDX9r4yXaXE1hyVgJ8+91IfJdsM6/nxtnVSeKfr82Gb4ZyF0PBbuwR0CigQO8oJyTvzT7c8OyKBYRp7crJPNDRtuAvn8oGF6V8ov6PpOyJLWGScrShY4ifonzpIjC5DxCn7REl4lXpnt5ZvbtcKdH2v/L1QTBxn1zSaViPJWuC+X6+QSukJDxueLYTP1sl7c4Qdsie/BjL9wK/4bEbPIVNqVEj5DQ4lsIaNJPqXpz9uBVW+aUgPXrsaH+7BT/pSvMObYGrp+ymcBTDEMyVx02eRLUS0B5ZTvziWq499YahKinlyrekDPzu2LrAqFJSU74crdywv4rECJNpTyxZ7C+tfiCup0ThnkjY3em3Y+4YHHoolIQ9EIvL5Qp4Y2alLeOrxxz/itcV1zLSAlqQG0Lh/AZ1nwpYE/x+YC2jczlD6ZypgEKVfWyKgSOeacc83ZjdWBl0wFH6yvJfkjwndKcsqB9dw19wA16sq2nt9XJR7OcNBDS+8lyWIPlL3xXgx3sTr0fRrfMwFjRBy/S5+n5zJaXW8uXuXlN0i76TWWl+ZYd+qKpVB6xyT+NhMEaz8luPJA84V2dkY0lto2aZABhJOqFdWIev8XJRWHqN4D6lzjaSw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(396003)(376002)(136003)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(53546011)(41300700001)(26005)(6506007)(6916009)(6486002)(478600001)(6666004)(316002)(6512007)(30864003)(2616005)(5660300002)(31696002)(83380400001)(36756003)(8936002)(2906002)(8676002)(7116003)(4326008)(66946007)(66476007)(66556008)(31686004)(38100700002)(3480700007)(66899024)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXRYdHpXUHJkeVJaeklBZmhvVmNza0d3Tm50TjRmdmVIKzBBVFZ2ekNNVG1D?=
 =?utf-8?B?MkZzbG53MGlMd3lTc3NhSFVKNlhzdGFaSDNkZHNBVE8xdzZqclRhV2JJWVp3?=
 =?utf-8?B?OEd5T2l6Z1NtNlFRcnlFREI5UEN2NytOdmVtbXA3Mm83eXordEJadGRkSFVD?=
 =?utf-8?B?aWJZSW1EWGJSTGpGaGgzdGRPeTdJMkt3enVWdnFRclRmaDNRR2RuTHZLcW9n?=
 =?utf-8?B?dHdxSXNJZFpnVnlZTkFCU0hSd3kzL2ZQTDNLdGs0OXRpT0RwcDVkMmk4Zkw4?=
 =?utf-8?B?OEJiQStyNnZTUFNZNER0YnZOaHE5WkNaa090anZYY0tlTXRMaDhCNW1xTG5m?=
 =?utf-8?B?WTZGcHdqZVFUQnhwTFUxQkJKYXIzbVpwN3dra1JYZ1FqV1ltVlJkQ1hDRnZY?=
 =?utf-8?B?VFlUSVI0OTExUnJLZXZvZHVBakVabVQ3Ty9GYUh2c0k0UDFaT2NwRHFJRlgv?=
 =?utf-8?B?MlVPZTVTTHVVRnRmV3lSMTg0TWJyRXJZbWtITXZOUTJlQUhFR0lyVndMVGxv?=
 =?utf-8?B?MDE1Q3B6ajdEakZvNlMzc3RIK2M5MTZOa3oxWkxteExDM0pVMzJCQVpESHBl?=
 =?utf-8?B?aWtMdjVvbnA3SkdEUWkwY0x4eG9oNElBV0lGdTMydTBFYUJyeTYzUFJGOUh3?=
 =?utf-8?B?N3JucHZGM3hpd0JJL3FmVGE2cUJLK0lWa21RdFBOUXl0cDV4cDZLOWthV3NU?=
 =?utf-8?B?WnJSVW9xQ2dITFdXSExpM2hzMG83RXkzakZ3UnVIbjBSelpNa1NuSVpuM0lu?=
 =?utf-8?B?OU1lWjdZSWoybkE5MUF2NXFEK0tpeGhiQmo4Mk5FWWppMnBuK3F1SGlYRVRq?=
 =?utf-8?B?bVQ5em16cENSNWdwRkR5MjZlSDVJNWRvMTlRZy8rK0hXNWkrYmhSd1E1S004?=
 =?utf-8?B?aXp0SW5kcGRFMkNTS3VQZzJBS09sNXZzN3FCNlQvTVpQcXpNbVpBbFJZL3pL?=
 =?utf-8?B?MGRxeXRWc2x6NVQvRVpMdGhWTW5pOFRBUjFDRTdWMFVPNldLRUJXL2U0VjV0?=
 =?utf-8?B?cE8wZ04wM2wvMGRXTE1tZVh4VkkveGxXdllDRGR0YWFJYW9FS1NGQy9DWUpO?=
 =?utf-8?B?RUF2clJBNlFVK1RLTFNINWcwTmhnNmhwamloS3lZMzB2akpITGpSWm1yTTNp?=
 =?utf-8?B?OGNRNVlpaTVJTXVXb1ozcUFMV1FvWkhNYnJuMEk0YUpMQUJZb0F1ck1TaDY4?=
 =?utf-8?B?b08yZ0k0VFNIdHN5VmdhZEpLNDdiZlFXTWZkYkhFV2JtcGVONnlKSkFsTEhN?=
 =?utf-8?B?cm5xUFNhalVRa09UYm9KZGhMalM5WXNuQWVjTllOaUVsT0l4SEtWR3NFMFp3?=
 =?utf-8?B?VzN6amhTbFRNcjB5TG5Ub0hoTGl1dGhhcWJ0bGppUUZQWHhqWWFqU0RMM2lh?=
 =?utf-8?B?ZjZnbno4Q1hyeTg3M2ZZRURGcWRjRnd4dkZUT3hrNGxJYmpCSVRLZnVZbXQr?=
 =?utf-8?B?UkNPMnBPOHByZHdwRlFzMzNEUHlPbDBzdlJYSDY3a1lGNThGWnprTHRENTJH?=
 =?utf-8?B?UnRyd2tOemhYUEhtWDNIenB1V3BCdHYwcksyVTlja3ZuTHBvQkd3WVR6d1F3?=
 =?utf-8?B?U2xxZWtyTUQ4ZzZhOEJseDRVN1J6dSsvNlhKVkJJUTh2cTRlVjErZW50eU0r?=
 =?utf-8?B?SHF0a1hOQmMwLzVGSHk5b3dVSE4xTHJXc21nMmVtYU5kSk1mclVLanpZMWIw?=
 =?utf-8?B?aTFmN0JHU1JNY0U3MFh0cWdicVErNjI4Uk41eUlFblkwem5tYWhKRkdPZG4r?=
 =?utf-8?B?NGxQQVA1R2JhblkrZHVhbEdSZnRaTE9rT25SdE44Z2ZBa0xlUllnaWR1MVQ3?=
 =?utf-8?B?L2U3YVNuNW03Uk9JdGdQdWkzVkhsYno3UDVnTkhtTHcxa1VUVDVnYTcvUFNP?=
 =?utf-8?B?ZVFoa1lIU01ST0U0U05wOXNLenViUGhmOG9zbjNkWVFNMXlTSEN0R3ZyNnMv?=
 =?utf-8?B?dENBTy9jSHhlaEE0TEtIRWZnOXNxbkNLOWJqSnorbE4yMkc3VXBYdmsxRkJa?=
 =?utf-8?B?MzNURkpFRG5lK3EzSUNuZ0J1dllnZkltLzhuQTQ5aXF4MndCWldCOG96eDVK?=
 =?utf-8?B?N0RmQWV4S1hIQkFZMTQzamxFVlRvcUV5NWo0RDc4b0QyQkhSL0dSM0lmTEFR?=
 =?utf-8?Q?PZnc/t2RGROdvTQwEUoEk8mxq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a845dd74-f0ec-41a1-ffed-08dbe4acb1d5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 00:57:37.3209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fLGX+yQpXwRlUSMWu+qvm8UlUKKxC2LeLNhXPhzBf8t1l2Eizuqw1iBV5KBwsYdO+pHSFn/Y+icuSHrBO394JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6431


On 14/11/23 02:10, Samuel Ortiz wrote:
> On Mon, Nov 13, 2023 at 05:46:35PM +1100, Alexey Kardashevskiy wrote:
>>
>> On 13/11/23 16:43, Samuel Ortiz wrote:
>>> Hi Alexey,
>>>
>>> On Wed, Nov 01, 2023 at 09:56:11AM +1100, Alexey Kardashevskiy wrote:
>>>> Hi everyone,
>>>>
>>>> Here is followup after the Dan's community call we had weeks ago.
>>>>
>>>> Our (AMD) goal at the moment is TDISP to pass through SRIOV VFs to
>>>> confidential VMs without trusting the HV and with enabled IDE (encryption)
>>>> and IOMMU (performance, compared to current SWIOTLB). I am aware of other
>>>> uses and vendors and I spend hours unsuccessfully trying to generalize all
>>>> this in a meaningful way.
>>>>
>>>> The AMD SEV TIO verbs can be simplified as:
>>>>
>>>> - device_connect - starts CMA/SPDM session, returns measurements/certs, runs
>>>> IDE_KM to program the keys;
>>>> - device_reclaim - undo the connect;
>>>> - tdi_bind - transition the TDI to TDISP's LOCKED and RUN states, generates
>>>> interface report;
>>>
>>>   From a VF to TVM use case, I think tdi_bind should only transition to
>>> LOCKED, but not RUN. RUN should only be reached once the TVM approves
>>> the device, and afaiu this is a host call.
>>
>> What is the point in separating these? What is that thing which requires the
>> device to be in LOCKED but not RUN state (besides the obvious
>> START_INTERFACE_REQUEST)?
> 
> Because they're two very different steps of the TDI assignment into a
> TVM.
> TDISP moves to RUN upon TVM accepting the TDI into its TCB.
> LOCKED is typically driven by the host, in order to lock the TDI
> configuration while the TVM verifies, attest and accept or reject it
> from its TCB.
> 
> When the TSM moves the TDI to RUN, by TVM request, all IO paths (DMA and
> MMIO) are supposed to be functional. I understand most architectures
> have ways to prevent TDIs from accessing access confidential memory
> regardless of their TDISP state, but a TDI in the RUN state should not
> be forbidden from DMA'ing the TVM confidential memory. Preventing it
> from doing so should be an error case, not the nominal flow.

There is always a driver which has to enable the device and tell it 
where it can DMA to/from anyway so the RUN state does not really let the 
device start doing things once it is moved to RUN (except may be P2P but 
this is not in our focus atm).


>>>> - tdi_info - read measurements/certs/interface report;
>>>> - tdi_validate - unlock TDI's MMIO and IOMMU (or invalidate, depends on the
>>>> parameters).
>>>
>>> That's equivalent to the TVM accepting the TDI, and this should
>>> transition the TDI from LOCKED to RUN.
>>
>> Even if the device was in RUN, it would not work until the validation is
>> done == RMP+IOMMU are updated by the TSM.
> 
> Right, and that makes sense from a security perspective. But a device in
> the RUN state will expect IO to work, because it's a TDISP semantic for
> it being accepted into the TVM and as such the TVM allowed access to its
> confidential memory.

I've read about RUN that "TDI resources are operational and permitted to 
be accessed and managed by the TVM". They are, the TDI setup is done at 
this point. It is the TVM's responsibility to request the RC side of 
things to be configured.


>> This may be different for other
>> architectures though, dunno. RMP == reverse map table, an SEV SNP thing used
>> for verifying memory accesses.
>>
>>
>>>> The first 4 called by the host OS, the last two by the TVM ("Trusted VM").
>>>> These are implemented in the AMD PSP (platform processor).
>>>> There are CMA/SPDM, IDE_KV, TDISP in use.
>>>>
>>>> Now, my strawman code does this on the host (I simplified a bit):
>>>> - after PCI discovery but before probing: walk through all TDISP-capable
>>>> (TEE-IO in PCIe caps) endpoint devices and call device_connect;
>>>
>>> Would the host call device_connect unconditionally for all TEE-IO device
>>> probed on the host? Wouldn't you want to do so only before the first
>>> tdi_bind for a TDI that belongs to the physical device?
>>
>>
>> Well, in the SEV TIO, device_connect enables IDE which has value for the
>> host on its own.
> 
> Ok, that makes sense to me. And the TSM would be responsible for
> supporting this. Then TDISP is exercised on a particular TDI for the
> device when this TDI is passed through to a specific TVM.
>
>>
>>>> - when drivers probe - it is all set up and the device measurements are
>>>> visible to the driver;
>>>> - when constructing a TVM, tdi_bind is called;
>>>
>>> Here as well, the tdi_bind could be asynchronous to e.g. support hot
>>> plugging TDIs into TVMs.
>>
>>
>> I do not really see a huge difference between starting a VM with already
>> bound TDISP device or hotplugging a device - either way the host calls
>> tdi_bind and it does not really care about what the guest is doing at that
>> moment and when the guest sees a TDISP device - it is always bound.
> 
> I agree. What I meant is that bind can be called at TVM construction
> time, or asynchronously whenever the host decides to attach a TDI to the
> previously constructed TVM.

+1.

>>>> and then in the TVM:
>>>> - after PCI discovery but before probing: walk through all TDIs (which will
>>>> have TEE IO bit set) and call tdi_info, verify the report, if ok - call
>>>> tdi_validate;
>>>
>>> By verify you mean verify the reported MMIO ranges? With support from
>>> the TSM?
>>
>> The tdi_validate call to the PSP FW (==TSM) asks the PSP to validate the
>> MMIO values and enable them in the RMP.
> 
> Sounds good.
> 
>>> We discussed that a few times, but the device measurements and
>>> attestation report should also be attested, i.e. run against a relying
>>> party. The kernel may not be the right place for that, and I'm proposing
>>> for the guest kernel to rely on a user space component and offload the
>>> attestation part to it. This userspace component would then
>>> synchronously return to the guest kernel with an attestation result.
>>
>> What bothers me here is that the userspace works when PCI is probed so when
>> the userspace is called for attestation - the device is up and running and
>> hosting the rootfs.
> 
> I guess you're talking about a use case where one would pass a storage
> device through, and that device would hold the guest rootfs?
> With the approach we're proposing, attestation would be optional and
> upon the kernel's decision. In that case, the kernel would not require
> userspace to run attestation (because there is no userspace...) but the
> actual guest attestation would still happen whenever the guest would
> want to fetch an attestation gated secret. And that attestation flow
> would include the storage device attestation report, because it's part
> of the guest TCB. So, eventually, the device would be attested, but not
> right when the device is attached to the guest.
> 
>> The userspace will need a knob which transitions the
>> device into the trusted state (switch SWIOTLB to direct DMA, for example). I
>> guess if the userspace is initramdisk, it could still reload the driver
>> which is not doing useful work just yet...
>>
>>
>>>> - when drivers probe - it is all set up and the driver decides if/which DMA
>>>> mode to use (SWIOTLB or direct), or panic().
>>>>
>>>
>>> When would it panic?
>>
>> When attestation failed.
> 
> Attestation failure should only trigger a rejection from the TVM, i.e.
> the TDI would not be probed. That should be reported back to the host,
> who may decide to call unbind on that TDI (and thus moved it back to
> UNLOCKED).
> 
>>>> Uff. Too long already. Sorry. Now, go to the problems:
>>>>
>>>> If the user wants only CMA/SPDM,
>>>
>>> By user here, you mean the user controlling the host? Or the TVM
>>> user/owner? I assume the former.
>>
>> Yes, the physical host owner.
>>
>>>> the Lukas'es patched will do that without
>>>> the PSP. This may co-exist with the AMD PSP (if the endpoint allows multiple
>>>> sessions).
>>>>
>>>> If the user wants only IDE, the AMD PSP's device_connect needs to be called
>>>> and the host OS does not get to know the IDE keys. Other vendors allow
>>>> programming IDE keys to the RC on the baremetal, and this also may co-exist
>>>> with a TSM running outside of Linux - the host still manages trafic classes
>>>> and streams.
>>>>
>>>> If the user wants TDISP for VMs, this assumes the user does not trust the
>>>> host OS and therefore the TSM (which is trusted) has to do CMA/SPDM and IDE.
>>>>
>>>> The TSM code is not Linux and not shared among vendors. CMA/SPDM and IDE
>>>> seem capable of co-existing, TDISP does not.
>>>
>>> Which makes sense, TDISP is not designed to be used outside of the
>>> TEE-IO VFs assigned to TVM use case.
>>>
>>>>
>>>> However there are common bits.
>>>> - certificates/measurements/reports blobs: storing, presenting to the
>>>> userspace (results of device_connect and tdi_bind);
>>>> - place where we want to authenticate the device and enable IDE
>>>> (device_connect);
>>>> - place where we want to bind TDI to a TVM (tdi_bind).
>>>>
>>>> I've tried to address this with my (poorly named) drivers/pci/pcie/tdisp.ko
>>>> and a hack for VFIO PCI device to call tdi_bind.
>>>>
>>>> The next steps:
>>>> - expose blobs via configfs (like Dan did configfs-tsm);
>>>> - s/tdisp.ko/coco.ko/;
>>>> - ask the audience - what is missing to make it reusable for other vendors
>>>> and uses?
>>>
>>> The connect-bind-run flow is similar to the one we have defined for
>>> RISC-V [1]. There we are defining the TEE-IO flows for RISC-V in
>>> details, but nothing there is architectural and could somehow apply to
>>> other architectures.
>>
>> Yeah, it is good one!
> 
> Thanks. Comments and improvements proposal are welcome.
> 
>> I am still missing the need to have sbi_covg_start_interface() as a separate
>> step though. Thanks,
> 
> Just to reiterate: start_interface is a guest call into the TSM, to let
> it know that it accepts the TDI. That makes the TSM do two things:
> 
> 1. Enable the MMIO and DMA mappings.
> 2. Move the TDI to RUN.
> 
> After that call, the TDI is usable from a TVM perspective. Before that
> call it is not, but its configuration and state are locked.
Right. I still wonder what bad thing can happen if we move to RUN before 
starting the TVM (I suspect there is something), or it is all about 
semantics (for the AMD TIO usecase, at least)?


> Cheers,
> Samuel.

-- 
Alexey



