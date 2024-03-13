Return-Path: <kvm+bounces-11744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 26AF787AA14
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 16:09:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6ADC1F229A6
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 15:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AEB946436;
	Wed, 13 Mar 2024 15:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tdxR5ssM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEE44595B;
	Wed, 13 Mar 2024 15:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710342553; cv=fail; b=gjAmgAU+KNyUdWVGT/lDV3J+qQYZl5RqtRcsbH4bf9JjtBo3eiVxHu52sJrHti4gCPwaS9T19PvFmFXI0L5VTVvkgY8fUnUrp8KyYWwKkpWFeUQ9nNZURXHO2LIGlXpBzBWwuTdhqRqHDHswi3L32gwTOyyGRDywEWk0M/DVkoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710342553; c=relaxed/simple;
	bh=MQZcJGbDW9HgSa5JEaLU9glMYuwTx4WUgIfahqe5Pzg=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y0SpeVQEKInU35/9x5JDcrRgdi8hmeb37My9V9LpvM6VErJpRZ7PXDEb0UJAaLbRtRx+UpavlbtIQzKsXlhd3693HKkA8jEHLKOyWHHcFXHCnnrZcQgf4WIku/IaZIwsz+7Zc7T1JbcE4B1UsmF9a1sZArardjzl/n1IEXzPfDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tdxR5ssM; arc=fail smtp.client-ip=40.107.243.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mARbDwRjn240CrlQarXK85inssZMh//GhoYctpYZRwefQMzqo8MThyuTHpYS3SJdihOF0BJ0TmK7M4Q9Bu8gqZ81WpZZtl1SvYU4ubNRTOIKPQ8MSq1O51qFx9NQSftvmnoBv1p+UoidpilMoNNkniMU45iYJVb21QtAlcgegGHkY71VDyVd6RImUnYFJ0QQhQR3USfLRYLM+BmohhJCgfd1etUlynUDMmbdq4HoR0LPnnkefQYnCABhnWAPZj4OMJWN0Uc+POxH+4YyQYDz5QAXCQQTT6iaL6ZltP31/62gmpcL9ttAlnRZl9ajIlzbij+9OIKTAlhFAtlgaFjdmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=36KtOW5GHlo3f+0l+WyzUb40SBIQEqHLktcr/9Cy1Bg=;
 b=anaIFhS4a0s1FkfWAb7tyar55mCGpvEqoJXB6rieiAkZiKJXq+1EW4z1fSLW/PuhXKoGE1JCe/TWbUVparqa3/lnLrvoKaUdVu/vG5zR/iR2AXSp/ypgT/c5qgYBKnnnaUJZDe8nUOXIZrJePgx40um4ECWEj7f+RC8v1lUWvxzx0vVU3ys0w+uwhE73tOkA21Y2dtLtNV3Aa+9EuFRIUG+fWHfrmBmV50UiRu0x2F9JD5YgbaAvIU1n6Y4Shz8sDVxdNgHb7NDl6RAvg9i09azN+JCkZ2Y+xTxJOSt+KXhEnmGjIktcGMQu/hYNq/0qQJV0Miw+qtO1Ls0KrXyJfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36KtOW5GHlo3f+0l+WyzUb40SBIQEqHLktcr/9Cy1Bg=;
 b=tdxR5ssMZinaYnyT7eC0awUGumaUZpgadsoUWX9qjyvHfqVy+krvZmpdLtm+fWZAadogMvqH3uZ/40IvCyy9f4soTFwYQ+LBBCx740pOYVl9UiVpR+PQ2ps5YLEKDESFHKfYQQDwNLgx+EbpZ8qh9NPFTZZ+ypAlUeTk2LhDHkw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13)
 by SA0PR12MB7477.namprd12.prod.outlook.com (2603:10b6:806:24b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Wed, 13 Mar
 2024 15:09:09 +0000
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::ff7e:b189:da4c:dab2]) by SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::ff7e:b189:da4c:dab2%6]) with mapi id 15.20.7362.036; Wed, 13 Mar 2024
 15:09:09 +0000
Message-ID: <bfd1fd46-0790-4148-bac6-7be462347828@amd.com>
Date: Wed, 13 Mar 2024 16:09:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: David Stevens <stevensd@chromium.org>,
 Christoph Hellwig <hch@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Yu Zhang <yu.c.zhang@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240229025759.1187910-1-stevensd@google.com>
 <ZeCIX5Aw5s1L0YEh@infradead.org>
 <CAD=HUj7fT2CVXLfi5mty0rSzpG_jK9fhcKYGQnTf_H8Hg-541Q@mail.gmail.com>
 <72285e50-6ffc-4f24-b97b-8c381b1ddf8e@amd.com> <ZfGrS4QS_WhBWiDl@google.com>
 <0b109bc4-ee4c-4f13-996f-b89fbee09c0b@amd.com> <ZfG801lYHRxlhZGT@google.com>
 <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com>
In-Reply-To: <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR5P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f2::13) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5673:EE_|SA0PR12MB7477:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bc7125b-d455-424d-a64e-08dc436f8841
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1PefsbtY7XmUDpHZA9xVTdqZifpgNqq3WGyi3ZOhNmTFmr6KGeCT7IVz/Boohsr9d60oe5RpyE0HpEoGTze1w1NTsrz1PVLT1Rd3ZBN4iyyuy9AxakjMnK7eyFsMLtiFL7y0b34HucynYTby5pjLMtoZjXjc+n1ZvX5xT/O8ds5rqdUFxR9mKZIUxzbVqXHK+xt9q83K6dFbrIZ5oHNklNVgZVZm0z6YJ3zVAzqJgtrE8QZv9Qbv7F8KY2vQrs+RI/50p04ZhHXYy3bSbBW/c/it5elNbLctqKExoM69x7mmOQ8m2cjWbGlHdZXMa5+VzMyEpRjsdMVI0QYSVEJw8O8rW1i3SHqcbP0ezdcS09l4uCbF10FCjE+gisW0SmdMVk4xbVxc8O7bdhqQGDdsBSqcqBN8mpa1qFwxgwGYTo/K7zBYXxTXkfJrzH6YXWPo1mmND6aB9NDBxwQpymYM1ER8mRce49iQqQqx2KRHwpe89Z6m+i45SyS6o/Zv3Jks2SBx9HiMMVPFA3ORleosbH8aHXAg/M2SrYFsWF5BkgbZjRad3VNWZIjlPdgK/9WdBg4bO4QJIo505E9EcxKIdSBJ0hHRd/tdmmN2NwMlkXzqpvXtfMsMGXZ8vejcfr3XH7eZulKwQS6yIPdunkiD9j5UbVRGk6B1YeuHgXSYAo4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5673.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDkreDJ2bjdLNVY2QkIrWHFkbWUrSi9hd01wcVdwcjFNc0kyb3VaY1QwVlNB?=
 =?utf-8?B?dmkwYzVqbWN5Zitja1N4UlNNNXQzTER6c1dqTU9YYUp6NFR3K2g1bnI1TTAx?=
 =?utf-8?B?NS9Md1NKU3lzbDB5RkRub245ZWZtbDA2R1FTczl4YXhFajJVdzc2c1ZBeHRM?=
 =?utf-8?B?YXRSc1diMWRzK1BSUk9DVXVvS2ZmVW1RbC91M3h5ajVmZkJSTmFMV1JpTGZk?=
 =?utf-8?B?bDl1U0Y3ZjJiSmRML2FtQWc3cVBuNHRIUitibWVSTHB5RnNzNWswWDMyUUJY?=
 =?utf-8?B?L1FJMlV3dlFnNlBWc0dzdzYwTzRsMWR4UDV3a0lVNGpGMjFSeGdQZmgvOFlx?=
 =?utf-8?B?aTMrd0h1TTVrUmZ4alplOXovYWlaLzhRdWhYUnUyd1JxbVZVQStzR2xEeXo3?=
 =?utf-8?B?N2tncVN1cEhaN3FsSlp5aTNzd1AwSmJZMUhXYjM2WGxBWXZ2SytWc0RCQ2dN?=
 =?utf-8?B?WGk0OEt1OUZuSDJSQ0tkZllBUTRqdnlTQ1QzZVVvREJjUTYwVFRkRzlUVkVV?=
 =?utf-8?B?YjN3ZjhPR3JVQlhJMGZUSlhtMkVOZDF2VFJYREVhRlZMVVdMcVNlY21DV2FW?=
 =?utf-8?B?L3hWNk1DemJwaC9zdUpRS2FHazBPM3ozdU9PRXI4VU42cU9pRzVIVm82aWl4?=
 =?utf-8?B?TUVvYjJOMlJ1SjVDMlpWMUJ5MW8zSnJ6MzJ4MGJUTzd3cFVvQThmczVxdnhy?=
 =?utf-8?B?M3FBeUFEakpFRC9IYXVMY0E0TUIzakl3aXJFUy9DVFc0OUVCeG1IVXI0bkYz?=
 =?utf-8?B?aDZXaHYxaktkUC9NdklOM3RYSGhwbkUyWHVvOUJHRlk2NXVnZkt0a2NVVTNv?=
 =?utf-8?B?ZzZLQXlhc1dGemRqZUs1WGxNUEd2bXVLbXc1dmFWbzVrWVJSL2E2ZURUdWlU?=
 =?utf-8?B?QTJtcEtIYjlTSU9hR2xqd1E4WGNaeWpMUzVNMVdXRXExRENsMU8wT0Z2T0d2?=
 =?utf-8?B?V284ejBaZE4rMjE2MDZPR2g0cE1FU1B2NzFXTnk5WHVOaGRaZWRheWhubGdl?=
 =?utf-8?B?OUEwc1RQQWxKY01MZHArbkRRNUFKRGZGN0ZpdkdOR0h1UGcycU0rTVhXQzQ4?=
 =?utf-8?B?cEhpd3hSSmd5dlFUYWlsUGlINDFaTWZpLzNWbTdJNllDTGwvRVBjUU45M2Vk?=
 =?utf-8?B?NWNLTkVUQk10cTNOVDVHMURWZGROR0Jyd1cxT3RBRGZwbXlNY2J6clNsdkxR?=
 =?utf-8?B?QnZmQzJjeUJCdmhDK0tvbFJSSkU5UjhRaUIzandNT0x3T28xV2lwSHRtaDln?=
 =?utf-8?B?WUo5STAxcmI4VzRxNGxIZHBhekUvcWx6aWprVHBoaUFrUVp5K2pRUFFPOGgx?=
 =?utf-8?B?RDR3Z1VhSzZMM09LeUUxeXNvTTdtV3R1bnJxamJFMm5RV1VWeXNnc01kNkxm?=
 =?utf-8?B?aGNBbTNydE1VSGo3cWhWRzVIMlg2eGUzS2M1VDROZDltaTBYTHpNaEQzMVcy?=
 =?utf-8?B?UDV0bHMwaXpXR3QremErdDVMMDBDRFljcHZzalZwdklVV2F1dG5sTHdXZ3Ra?=
 =?utf-8?B?V2pDaHVrcDM3QXN3OHZkOWl6Ti9RdlJxYUFXaWd5cTU5Sm0xYjlTZEJGanVW?=
 =?utf-8?B?SWNRNjY0NE96M0tsMzQ2MFVkeHoxeVBWb0tKZExnTnNndllsWVZIZXdrWVR3?=
 =?utf-8?B?U0R3ME9GeTV6R3duTldrYkpQRDJIOC8vRk5MU1doYXFiTk9Wd3BBbGhaQ2dE?=
 =?utf-8?B?cFNzQVpCYlBPR25zcFdWMWxmQUhMU0VQU1MzMlcxbWM2dkM4NFh0ajRCVjJO?=
 =?utf-8?B?UkJWRkVualpEQTFKTE83ZVRiMTJnenlMR1hHZ0VCdGUyMkVQOS9zS2d3TVRP?=
 =?utf-8?B?bEtQZFl5OGRNNGFNSzF5eEl2NU4rUE5kcGRaWkxCS3oreWo0R3l3OFlFN2d4?=
 =?utf-8?B?ZjBwdUxFR0pzUS92RUtCN2s4TEdySnJOSllLSVJEZnB3ZTJrM0M2QlU4eWls?=
 =?utf-8?B?VEhGSGxmTWgvWms3dkpmQm5ocmhVN2pGM0kzM3JpYXp5NUlRZktGd2FTOHdj?=
 =?utf-8?B?c1pqLzdEVGQzSXZtSnBGQnAxdmUwT3QybnRlSDlhWDV6bFZ3bmpycHJleHRN?=
 =?utf-8?B?M2tHNGxJVjMvU3Q4ekVTOVpQQmV0cEdTN2VBNks3VCtzNDM2R2F6VVJPRUJB?=
 =?utf-8?Q?gtHYQCa0uelui4PsKCqx/SGh+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc7125b-d455-424d-a64e-08dc436f8841
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2024 15:09:09.1606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SjZDr+Z24OjnTvqrluDXQiri8zOB8CXcBv/46UcpyTo2lhF9ThY30vNQ799wbc+R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7477

Sending that once more as text only since AMD eMail has messed that up 
once more.

Regards,
Christian.

Am 13.03.24 um 16:07 schrieb Christian König:
> Am 13.03.24 um 15:48 schrieb Sean Christopherson:
>> On Wed, Mar 13, 2024, Christian König wrote:
>>> Am 13.03.24 um 14:34 schrieb Sean Christopherson:
>>>> On Wed, Mar 13, 2024, Christian König wrote:
>>>>> And when you have either of those two functionalities the requirement to add
>>>>> a long term reference to the struct page goes away completely. So when this
>>>>> is done right you don't need to grab a reference in the first place.
>>>> The KVM issue that this series is solving isn't that KVM grabs a reference, it's
>>>> that KVM assumes that any non-reserved pfn that is backed by "struct page" is
>>>> refcounted.
>>> Well why does it assumes that? When you have a MMU notifier that seems
>>> unnecessary.
>> Indeed, it's legacy code that we're trying to clean up.  It's the bulk of this
>> series.
>
> Yeah, that is the right approach as far as I can see.
>
>>>> What Christoph is objecting to is that, in this series, KVM is explicitly adding
>>>> support for mapping non-compound (huge)pages into KVM guests.  David is arguing
>>>> that Christoph's objection to _KVM_ adding support is unfair, because the real
>>>> problem is that the kernel already maps such pages into host userspace.  I.e. if
>>>> the userspace mapping ceases to exist, then there are no mappings for KVM to follow
>>>> and propagate to KVM's stage-2 page tables.
>>> And I have to agree with Christoph that this doesn't make much sense. KVM
>>> should *never* map (huge) pages from VMAs marked with VM_PFNMAP into KVM
>>> guests in the first place.
>>>
>>> What it should do instead is to mirror the PFN from the host page tables
>>> into the guest page tables.
>> That's exactly what this series does.  Christoph is objecting to KVM playing nice
>> with non-compound hugepages, as he feels that such mappings should not exist
>> *anywhere*.
>
> Well Christoph is right those mappings shouldn't exists and they also 
> don't exists.
>
> What happens here is that a driver has allocated some contiguous 
> memory to do DMA with. And then some page table is pointing to a PFN 
> inside that memory because userspace needs to provide parameters for 
> the DMA transfer.
>
> This is *not* a mapping of a non-compound hugepage, it's simply a PTE 
> pointing to some PFN. It can trivially be that userspace only maps 
> 4KiB of some 2MiB piece of memory the driver has allocate.
>
>> I.e. Christoph is (implicitly) saying that instead of modifying KVM to play nice,
>> we should instead fix the TTM allocations.  And David pointed out that that was
>> tried and got NAK'd.
>
> Well as far as I can see Christoph rejects the complexity coming with 
> the approach of sometimes grabbing the reference and sometimes not. 
> And I have to agree that this is extremely odd.
>
> What the KVM code should do instead is to completely drop grabbing 
> references to struct pages, no matter what the VMA flags are.
>
> Regards,
> Christian.


