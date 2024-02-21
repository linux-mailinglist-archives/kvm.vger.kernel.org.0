Return-Path: <kvm+bounces-9285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B78F85D17B
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 08:36:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6452284764
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3207539879;
	Wed, 21 Feb 2024 07:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="F5Cid1O8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B844624B57
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 07:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708500961; cv=fail; b=XnhyPpVvzvDuP5ovGTNGXgrY5nt07GheYXBjGV01O6AsQo+9wuqhopu8zGYYWLrXkXMmu9Q15FtiRbFlng+tmGewv5nqxOr0eh8vuFD9EBhFDw7xB5mBExibtA0AAPVqz0adP3KQrzWQeqPpHqmV1PbQVS5WqHBdhbNPxu4tmRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708500961; c=relaxed/simple;
	bh=WLXSnxcTgFbxOsUNOob3mjdXY6EVR+pF/abHE5lczeM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fwJcvo5593dYciFjXlnBsqHuvUkykiNmwtyr2XqkZDC9fogQwHlE322VsdwrMrH4Do/KKe/JokjR5eS0TwQSFtWSsf45Ch6PHt6OE17bXn/DRNUq8vIEYwovhKmGnSwTW85D0MwJk2e0a26vXUOz6vx+h3W0XYo+kV37iOMOudc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=F5Cid1O8; arc=fail smtp.client-ip=40.107.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOZw0gkTbDC3wgM/cANp7VpjgvvUb1rYKEEGXCDb/i35tpJrVvAEvLgE4PQXdB+XbWbdc1ig84B5IB4w4AP4TR0ZGPxjvcr9WrsZswwZQh89xCPgXGF3MaucdUPb4o8PNXOANbgb6j+Aeiy22ZEhbf0zb4+kz0o1kLvVNEmn4NOH/JOykgIG7wviv8bCCaZPJ4rLWbZaSxygWtoWT3XzlQ9R5zKbAxxi01kigCDu9GxWpfeZZorYlQks8ntzOLtpY9L5L5vnZpnPx1YZayz4inqHdHpkEFW3RpUn5cr3jFSIokFGAEjnawyPoNTwMnEQTvBiqYuyPzyq8nfkqnEMsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCHVMPa5L+0zRkQPfWqpfpz/GOagsZ9IxyJP9qXLS/o=;
 b=HRu5lQLwWu94qT1wtIxRS/yBr/qpspU+fiiVyoqv4N0nCznu4sokvRKSKVFaos4GR7sMZwN+jGsVWmkOyntUYMhk+fE7Np/6GRvqC4WuTpOZcXAKdRkMx2LOMzbtVF9jHtsFuCoafoqL7G0Bta/n3PQ+TGzBp/Ax3zhAsH0QzjWFAN/W+BBFDeACiSQUwZJz6u4HV6w+FVe/sJZI2Qgq6Nul/FDIVNGPfSqMPpKmrqqY2rbod7I2uloY8eqeLxznjwz43Sy6gEuIbf6d4caK9OAwRRCECNp9JRyKEAkpX8rJllVHJmUvk0LuRqRz4j3XC1ig9v+Emdf7fj9fiWJ0tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCHVMPa5L+0zRkQPfWqpfpz/GOagsZ9IxyJP9qXLS/o=;
 b=F5Cid1O8CSwFuiHOcsVEPtxjwHoZ0kr0bKCDKXIZqgHGHeyFgpmCkbiuADpLzR83OVCI9ydDm38kyoegZ8MHMX9c9KlzS9smoeAEDC2rtRbsvPR0/0MsGclEOIgYVPybfjZkESBu+4/xaiq0luseF6Ca7x15A1uSb5GALmlca4g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2810.namprd12.prod.outlook.com (2603:10b6:5:41::21) by
 BL1PR12MB5285.namprd12.prod.outlook.com (2603:10b6:208:31f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Wed, 21 Feb
 2024 07:35:57 +0000
Received: from DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::79dd:1401:e772:985d]) by DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::79dd:1401:e772:985d%6]) with mapi id 15.20.7316.018; Wed, 21 Feb 2024
 07:35:57 +0000
Message-ID: <f21d4fb1-3bd2-b129-287d-ecd959dbb72e@amd.com>
Date: Wed, 21 Feb 2024 08:35:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 00/14] Improve KVM + userfaultfd performance via
 KVM_EXIT_MEMORY_FAULTs on stage-2 faults
Content-Language: en-US
To: Axel Rasmussen <axelrasmussen@google.com>,
 Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com,
 jthoughton@google.com, dmatlack@google.com, peterx@redhat.com,
 nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
References: <20240215235405.368539-1-amoorthy@google.com>
 <1f67639d-c6a2-1f36-b086-eb65fa2ab275@amd.com>
 <CAF7b7mrsVogiXwcjP_kNp4KviGa3sfhr2HXP2JD1T4y-OO6Zqg@mail.gmail.com>
 <CAJHvVcjmg8i8ebMEK2gE2hMg9c98zyUr_xPCrsDKvY-3fUZTUQ@mail.gmail.com>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <CAJHvVcjmg8i8ebMEK2gE2hMg9c98zyUr_xPCrsDKvY-3fUZTUQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0215.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::19) To DM6PR12MB2810.namprd12.prod.outlook.com
 (2603:10b6:5:41::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2810:EE_|BL1PR12MB5285:EE_
X-MS-Office365-Filtering-Correlation-Id: 42ad1536-2484-405f-bbfa-08dc32afbe10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9+z7DNO2ddoZjU5y1004Fdtafk2jdJNEihfvpGfVuyQ2gGyu2Mf6sxgLovQvPZycAkQdURFSGrKf7c16GPkrp94RQ6ZYjsU/iMGjuYySP3XBmbrOPWPsdlTYV12oIE/ywNBSfXksITwn2HQyU/CyGWMqC7ytihN3NY33fihuGuVSdTjeeFnGI0+wBxOfQ0PrrF98ZGhlhdojvuDyC3nV5sNl5jEBb83DC3bM09erkWsM4Ye/NP5Ldo9k4iOV3WbX3epeKo6kM8KLqFerg9Fk9WXnY43CPNwzs9zxno/I3RsesdB2fmSXvR+n2v23etoPcwhbs/xzoxm6sIhU2Ca7OunyiVWji9q8ygxsaLJ6umVF/U33lcyCJ0qT31uzZeU65DgKCLhUK6LfLljtPKI+bDbjMMDgNe4jPOiiIcGMdVFxCpruaRChKLbYOuDwYQng8cwPcvBBms4W6Se3+MJRxWF4lXfZ3BZIRDd0NYJhVXDy7z4sU6dbN9WtJJxe2JwrhIAD9zMX7DT5u9K/O4jIwiwQnKBlIGMpEv/B5jnCCaA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2810.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0x1SnlZc3pMNzBYQUJzcjh1ajVkVUozRFA4RXNRWWJibGNjTjFtaDgrK21m?=
 =?utf-8?B?WnV1VzRsT1RFbngvSDZQbXh4RFcxcVVrVlhRUjFRQ2dyRHFQVU5wOE42MFBr?=
 =?utf-8?B?c2lhV2UrL0NLSElHaGtVd0p2UUNLZ3lLenpKTjNMeW9LTTNrS2VMNTZRZ2po?=
 =?utf-8?B?UXFCbWZicjJSZkdiZzdLYjY0Q0VZcDZlN3FsUld4Z2NDUzUwUlo5WDhTbWw1?=
 =?utf-8?B?SU1OUE1EOHo1KzM5dEQrZ0lZajUyWkJrQ3Uya2lZT3BMT1ZLN1pOdzVUQWY2?=
 =?utf-8?B?ZmtndFQ1YUdCZHROTXZ1WTVTMk9obU9LZ3U4aUJaVFk3T2pKcG14b0NzZXBt?=
 =?utf-8?B?bE12MTQ5REZka0pUcHlkVHI5UFJ2VUplVlRuV2Z3bGhYUk1uOHJ0WFM4NUdi?=
 =?utf-8?B?dGsxaEx5Qlo0YWs3bGl3aE9rYnhtMDZUWXZjVTIvc3ZtY29idS94Zm4zalN6?=
 =?utf-8?B?d3ZwUjZHa1ByVHBhUTJpSU5UTXlRN3FlUGd3UkFOd1UrcTFhd3dDejNpUDZN?=
 =?utf-8?B?ZDJ3OUpFMkRYVG1KeGswK3hWQmUrNytkZXREcGFTQms2Mk95TDJkUTBjclNs?=
 =?utf-8?B?ZDcwQlBCdlMrRzBmc3VvazdZTzgwNmtiSjZJMk9Ma2JUUFdTTUZUSi93eG5S?=
 =?utf-8?B?bTMveTJGWkpkRHh6bHpzbGFmS1BRODR4ajNYUEZ3Z2ZhVktuc2hoY2lMK2pG?=
 =?utf-8?B?RzJnY2w1ZWR3aVpTUUF2amxxb1hxN1ZCalA5QytYSmpCbzF3NXNyUmRSd25F?=
 =?utf-8?B?REJVWjVFY2FJWWxrZXVUMkY1TkFuL3ZZV2hyYlZYOFRCdnJYSVh1VHhWZ1pR?=
 =?utf-8?B?eW1nU01XamZXSXVoRG9UQ1BVUnA2L25YYUg2MFlNRnZYR0pJOHBXQzdDMWVP?=
 =?utf-8?B?a1pndW5pTWs4TEFzZ3VIa1Z2bmVCdmVkVFdkUFZUVDRRWDk2MDZINmdxTmV2?=
 =?utf-8?B?aW5hSE90REJoeGlUYWQwUFlWT2JrV2szeGZET2syLzVtbkd4OUlsOTBuQ2Z4?=
 =?utf-8?B?bFdFQ1Vhd1JZRmZnZXBGNzY0bnZzS0JSUnBZb0xsaUZwWmhWN3FySlZsUjVY?=
 =?utf-8?B?NTdZc2JHZHZUeVFSMnhIQW1MVUlPa0haV0lZbkYvNkVjbHhGN3J3N0hjLzEw?=
 =?utf-8?B?V0VIZWpBeXdDU2tKVXBnZCtWOUowQUh0cDRBb3UxL2lGZ0VMWjJ3dnF1TlR5?=
 =?utf-8?B?eHZ3SWRzSUcyOUVNQm1ZL0tyZlFJSHUwT0hYMmlGb255Q0N3Qm5iWEFWYnBI?=
 =?utf-8?B?dkdYSkZsUFQ3Wk9zNUJYcG5UNTB1ZFNIV1M3Tng1Rm1LcktYOTRzZUJNcW53?=
 =?utf-8?B?bUM1TnBJNWJmK1BRYm5QeWk0OEl4UzlnN09WTTZIdlh5aEJLaEpmb3JDWEky?=
 =?utf-8?B?UHZGaG8wdUdLQUQ0cnp1dkVvNzRUN0NOZDVGNzdYclc5QjhYTmhxRFhyelNC?=
 =?utf-8?B?MFA3ZkE5WDcwejJ0U016M2pUdHJYYy9jRmNxeW1RaFlMMzNqYXFKMG82RnpJ?=
 =?utf-8?B?SlE2WHhjSG03MllhTWNoQkl0aEJUblV5NDFOY24wQnQycCtBVFpjVHdBRkZY?=
 =?utf-8?B?ZlBlOWNBRUU1YzN4NzUwY0ppQ0JpZnlvWGU4Q0sxbnJYSGtIZXBPd3Rlcm1m?=
 =?utf-8?B?RVkyQWRlREhxdGZCdWYzM1JoTUpkY2RVclY0bUtoZnFZYWxYSG50MmpRNVRj?=
 =?utf-8?B?UTBpdzNsN2N3R283Zno5RDVaQ210Mjc4Ylg2TnZrWE43cTZJUnFSTk9NMnFm?=
 =?utf-8?B?M3owdWMwNVJXaElwYURXYm44RVA5SzIvTkJPaXgvT3RXZ3p4Tkg1Um9KanpJ?=
 =?utf-8?B?aFZ0UUdHaXZOOU8zZkJSbStKaElWaHpDNlhibkRLTGEwMk0vSGpqTFBidDNI?=
 =?utf-8?B?aVp2Q2Z1TXN3SFRXbUlUUlV4ZGNjakZUbklwUVVzU0E0NnNEOUU2dGV0QTQv?=
 =?utf-8?B?MEVnZHRWdkNONEJPcFFTL05KSlM2MEV5dXFJVkEyWm8rTDZFUm55YTN1aXp2?=
 =?utf-8?B?cHh3eUhML0d4cU5aajN6eWJhTGkrTFpRQWpHUkd2WDYrK01lT3p6UmxhQ3Vs?=
 =?utf-8?B?Z1A3QTFNcWpFb095Zlc3R3dKMHBuN1B6QkFDbDg1S2ltaytpQVhVUGpXWkU1?=
 =?utf-8?Q?ao++/LoIegX260Ra+51WL8uVd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42ad1536-2484-405f-bbfa-08dc32afbe10
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2810.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 07:35:57.1358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lSWIFS4JxWBbMrFuRlhNFMXqD0sL6mwJhDNceVzRErWmb3ivRUepHhJJFBSnFIAoLtpSJR6wAppE/mB2cPaJRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5285


>>> On 2/16/2024 12:53 AM, Anish Moorthy wrote:
>>>> This series adds an option to cause stage-2 fault handlers to
>>>> KVM_MEMORY_FAULT_EXIT when they would otherwise be required to fault in
>>>> the userspace mappings. Doing so allows userspace to receive stage-2
>>>> faults directly from KVM_RUN instead of through userfaultfd, which
>>>> suffers from serious contention issues as the number of vCPUs scales.
>>>
>>> Thanks for your work!
>>
>> :D
>>
>>>
>>> So, this is an alternative approach userspace like Qemu to do post copy
>>> live migration using KVM_MEMORY_FAULT_EXIT instead of userfaultfd which
>>> seems slower with more vCPU's.
>>>
>>> Maybe I am missing some things here, just curious how userspace VMM e.g
>>> Qemu would do memory copy with this approach once the page is available
>>> from remote host which was done with UFFDIO_COPY earlier?
>>
>> This new capability is meant to be used *alongside* userfaultfd during
>> post-copy: it's not a replacement. KVM_RUN can generate page faults
>> from outside the stage-2 fault handlers (IIUC instruction emulation is
>> one source), and these paths are unchanged: so it's important that
>> userspace still UFFDIO_REGISTERs KVM's mapping and reads from the UFFD
>> to catch these guest accesses. But with the new
>> KVM_MEM_EXIT_ON_MISSING memslot flag set, the stage-2 handlers will
>> report needing to fault in memory via KVM_MEMORY_FAULT_EXIT instead of
>> queuing onto the UFFD.
>>
>> In the workloads I've tested, the vast majority of guest-generated
>> page faults (99%+) come from the stage-2 handlers. So this series
>> "solves" the issue of contention on the UFFD file descriptor by
>> (mostly) sidestepping it.
>>
>> As for how userspace actually uses the new functionality: when a vCPU
>> thread receives a KVM_MEMORY_FAULT_EXIT for an unfetched page during
>> post-copy it might
>>
>> (a) Fetch the page
>> (b) Install the page into KVM's mapping via UFFDIO_COPY (don't
>> necessarily need to UFFDIO_WAKE!)
>> (c) Call KVM_RUN to re-enter the guest and retry the access. The
>> stage-2 fault handler will fire again but almost certainly won't
>> KVM_MEMORY_FAULT_EXIT now (since the UFFDIO_COPY will have mapped the
>> page), so the guest can continue.
>>
>> and userspace can continue using some thread(s) to
>>
>> (a) Read page faults from the UFFD.
>> (b) Install the page using UFFDIO_COPY + UFFDIO_WAKE
>> (c) goto (a)
>>
>> to make sure it catches everything. The combination of these two things
>> adds up to more performant "uffd-based" postcopy.
>>
>> I'm of course skimming over some details (e.g.: when two vCPU threads
>> race to fetch a page one of them should probably MADV_POPULATE_WRITE
>> somehow), but I hope this is helpful. My patch to the KVM demand
>> paging self test might also clarify things a bit [1].
> 
> One other small detail is, you can equally use UFFDIO_CONTINUE,
> depending on how the rest of the live migration implementation works.
> 
> Really briefly, this series should be viewed as an alternate (and more
> scalable) mechanism to find out that a fault occurred. The way
> userspace then *resolves* the fault (whether via UFFDIO_COPY or
> UFFDIO_CONTINUE) can remain the same as before.
> 

That clarifies. Thank you!

Best regards,
Pankaj


