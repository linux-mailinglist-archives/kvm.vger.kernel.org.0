Return-Path: <kvm+bounces-11725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AC7787A552
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 10:55:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 417CF282298
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 09:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6160838DE6;
	Wed, 13 Mar 2024 09:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wysOCko2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40BC20B02;
	Wed, 13 Mar 2024 09:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710323747; cv=fail; b=FSVcKiQtrrACUj+aoEXFYoYv+yDgnE0wVvdt+KXnr7dVFbA5SNP4zAsFXLk/T2JF/9IYZRBuWFQftEAL6SbodSM9PCi+ojlcyRxxD3gfe3mwatcR2a8g0SXzqRVX3b9blPW48KcvZN+X89I1/CUciBoV7rZRo0MdTqujmBLcIHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710323747; c=relaxed/simple;
	bh=s33k/v+Wm30obHB6Vj8dynsDZSdwhhj7wvveWRl5590=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FIXRzUXk1e4FIYN/42EJ19hoN3suFvbaiLiFEylGNUxK3xw4XAbHylLMUHUSELzfcEOmkxk6NoaZmodt6rugfdacq+s/bHDaIUkbC61EwBkly5Qw4Q5WpdZsOkqZYW3aeCAKXVK91LWzltap+qN+hXfJNfz+UgXV85iXb095/tY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wysOCko2; arc=fail smtp.client-ip=40.107.244.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CURiuy2nDq5XZOKY+tiAhBMH6XkB+Z1wC5AzqambayF8V/2f2SgySpnvrMvpS/+Wk4Yz5iZdUvL6cFIvksOmpvvwCStaEARNuMvJj1a9gMRRJCH3TDD5+OpVf3EpP1wimq6G+yFpgVVGR5tZUEgwH2JG/DAFw0X773lerH1rmiMRgbluHUoeF5mjQCK6hOr83LqP4wgas4J7rtpzeQzxsMTIeNZavleL8IV8daAT0zEYojjMC7QPFTGdl8peIq+HNuVUhpSYanMuEsxFZOITkeU8uPuGVKUqSw1NHvMXiRPLvNz7N1syAT+VGzFhkESJZ5EhJf2Z53vXENG4Tdzwnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vaSIvjuX1uY1dr5j7vaX4VGM9ebFhj4HmhIXJ2NjAhs=;
 b=R2wmUu1k4grjVxspPt8DUfE/Qsjf4xoZcL236chkwb7JfD6aYMQQHx7ATMJPRy6R7dYEfl8XyyHJEy4cfSYb+Rj3jG2Qow/jhJJglTQt18/A71AlRHLWzsLYl9y7elkCtpCd935Mu1A3U+S1KyPwHnhfKQkJ0E8i5KhptXH6u8rxYubMqtBVUcnbO4x7d/Qoi3mVqwKlTu5s6aodbuJt+BSyG7EvFZDK/9MyREJfF1vr68+aqaR2Vs3HcGggsiy+7BYh87y4orGb6ZhJr1+3K7Y71kxa6MyHa5UdIqHxgB0Dg7gfDxYwccEsa5tz9vriU1T7PIpE9dxzXkN5mzk0mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vaSIvjuX1uY1dr5j7vaX4VGM9ebFhj4HmhIXJ2NjAhs=;
 b=wysOCko2dNvY78ywWMb8hgDTgiYB30WWZR7Y8aMh7ScbuSHGZI5ZR2TXsB+MzFP+Gkx0MIB0K3I3G7nPleyx62WyYdDctb/F1K3VqS+K3jKutZT31jvRPt8tW3/6p9sNSgLpY1tURJ4gj6Fc15izKZ62MTzsLGaletCW93OsURA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH0PR12MB7959.namprd12.prod.outlook.com (2603:10b6:510:282::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Wed, 13 Mar
 2024 09:55:43 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::f2b6:1034:76e8:f15a]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::f2b6:1034:76e8:f15a%6]) with mapi id 15.20.7362.031; Wed, 13 Mar 2024
 09:55:43 +0000
Message-ID: <72285e50-6ffc-4f24-b97b-8c381b1ddf8e@amd.com>
Date: Wed, 13 Mar 2024 10:55:35 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
Content-Language: en-US
To: David Stevens <stevensd@chromium.org>,
 Christoph Hellwig <hch@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240229025759.1187910-1-stevensd@google.com>
 <ZeCIX5Aw5s1L0YEh@infradead.org>
 <CAD=HUj7fT2CVXLfi5mty0rSzpG_jK9fhcKYGQnTf_H8Hg-541Q@mail.gmail.com>
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <CAD=HUj7fT2CVXLfi5mty0rSzpG_jK9fhcKYGQnTf_H8Hg-541Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::17) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH0PR12MB7959:EE_
X-MS-Office365-Filtering-Correlation-Id: 958297a2-cca4-4905-74d9-08dc4343bf69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pRXqycJTw4dO1RcUIlUtUUkKcSvDkpT7ymkmdORWo0EwBh2C/4S3/MYjABbNOkaS/vhV9zLMPwtFl2SQS+XaWxwgbHa5bTPAgwwH/2+gaXj4GiLrV29L7CRKT8dj/eUhHvRHbDY6sASr4YNZzl+F4PXE6XhrX/Yey9P5pP6CvkpjcDTXd6WrfeFCw0h1dRq0UvgIXvW5aB7VIyAJUCoxlcunPIyP7eW4CmEl8zvtQyRrrhPruTw0EGi4d3s6suaFG/Yne05fTSz5dgvOKuVWvlr0Sjx+4+BYxlDUuzC9ogyE4oHkMtgMjxGs8QwICnRsfQs0xdsXZywTj/yytLmVxOOKaoBzeLLS80jFEnG4A8Gh1wfTIaTwPL4FlumoDad5SQj5NF9CaQTQuOKr9EXGFvhrSQ16ykv0XUu75PsBEAJ8Rzl7khb6b2qNeGYqyuNM62XetMwDTdQT42mMI4zbh1JROmsZlsppQRb6E0tPUW3rfOA3IIqXOvInbVD0U/6F9MuYjYMlGJF+WGUNzfZo0OOkgviviAwkmiuKOSfNIQeWo7wE/0Ad1evIfE0ojul2lWXsWLc1ZrQMAveNpSCAyhJva3JNCzwzx0WHbq/ls78XCFMbTmDbtTTvoNL5+ZxU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHRiaHRjTytkcWdjMXplcVg4QzNSTUVBaC9EdWJOWSswTGUvNDJ2NXA3WXZG?=
 =?utf-8?B?NlN1L0JlV1ZuZ2k3ZFlpMFRDQWdzdGR0clpCdmYvOVdtZHE2bEpHZTlLbXVJ?=
 =?utf-8?B?bUxmc0Jsdm80TEZRUUwreWtlK3NnL0NObm1WV3Fzbkk2eGx2NGlMOUZJUzY3?=
 =?utf-8?B?aG40OUNtL3dxWDRZT1UxVU9uODR2R3llUkVIZkZHYkRpc0pTcHcwLzQ0UG4x?=
 =?utf-8?B?WnpHdncxNm8rK3dpK1pUOG9MMEhTcW1hM3NncllObmI2N1JEVlJZdlRJZUYw?=
 =?utf-8?B?SHo3OFY2WXpOTFovbGpQYWFyWEpPNFE5YXV1UVd2ZmZBMnhnM0xXcTJTVnlN?=
 =?utf-8?B?YjhjQzcvVjVndUVEN2VIak5mV0RwTDlMbDNsTlkrRmhvZFVGY1pVbk02Y2xu?=
 =?utf-8?B?WVFvUmZ1NSs5K0R2MHFmNjYxZ0JsSVBMUGpBOUg1c1NzbnBXU2o5blh6cTFF?=
 =?utf-8?B?WGxQTzVBODNtelkzSWtBdjRCcGVMWlI2cm5Dd2pIK1c2Y29vTXBPbHNUSEpl?=
 =?utf-8?B?VloxR2VOQk82eTgvT3lLYVVLWTRuWEVrUXFISWJ4T0dvUi9SZEh4c0VNb2Q0?=
 =?utf-8?B?bVMrem5DZUFrUXlqdmsrK0ZUY1pDenc5amNZeHErOC9rWlF3YWU2VXl1M0VJ?=
 =?utf-8?B?R1BNaG1ocCsxSUtHOVRTMzRHRmhMMEoxa29sdTZqSXdYNW9rdmhUdUJBdzJr?=
 =?utf-8?B?VFpHSzY4SE9SaXVRY1RyZnljSFBkc0d1L3g1S2NVVkVnT2l0cHFud1JXUjYr?=
 =?utf-8?B?SlI4TDVGeGFscGx0eVNQejJtRWJiY3dmNjJlV2RxaldFS0QzMzJQTTVCZGVK?=
 =?utf-8?B?VEJGSGE1VlBZbCs3dUpnTk82N0dDOWpSYVVkNjQ0d3MzTFF4MVNwaU1aeGhq?=
 =?utf-8?B?d0p6UHl0dUZUd0FmOCt3M3kwdW02SVdHdXJYR3lNd1pLVktRTHZIa2xMZDVV?=
 =?utf-8?B?K3NteXUvNmtRNGkxU1dsZzV4Y21NMFdzSURSWlhMbmFScUlDWk9LVUVlQ0gr?=
 =?utf-8?B?ak1OTVpoTHpjYW1QOWphZFdaUWc4Zm10SjhFUm9NYWJaaVA1QSttZ1J5cERL?=
 =?utf-8?B?RGN5eEdjL29nT0VRODNPdU1ld2xLTGNYL2FaNTJkdDd0b054SXBZODVKVlF1?=
 =?utf-8?B?T1lKaWdPeDhGL0xVQXJFNUZzV3ZyRGFlVUxSa203L055b3orT2NaTnVTVXBY?=
 =?utf-8?B?TzI3SUhHYVRERmp4bVhyd081NGNGZm5DbURlejRxeU8rRTB5ZitTV1FOMmNh?=
 =?utf-8?B?bEk1SnR3c0M1Y1RaTmtwNCtlMVpYNU9Wa29kRG0vOUxaWlIwZGF3dlFtcFBy?=
 =?utf-8?B?cGpxZXFjYjJnVW9kODJLSUZ4a1huV1hBR2JQWHlFK3hzZ1JFWUZQL0xjNWUr?=
 =?utf-8?B?bDd3OWpsVk51N1VXVUxOSVcvUzNrU0ptRVBITHY4eVdHdDEzSmNwQlJnWFhS?=
 =?utf-8?B?a0RpTzdQQldvczdDeHRGeGR6am1yVzJkZnFERFRtK3BYdVBMT3FZVzBSRXVK?=
 =?utf-8?B?NWJOTnJSb1BpeTN0TmJMZ1RjN2Yyd2lUYmZ6Q1BteUNTOGVtTCtWNjNKZzFl?=
 =?utf-8?B?QllMT0pLdTFwK3VScUpaazdnRkpkZHBSYkhZZTYxZ3Q1c2Q2L0tNK3pqYUsz?=
 =?utf-8?B?TFBaK0dHS2NydEJLZ3duWUZwWFlEcHJIbGdIWFJWZG1pTVNrU0NtS3VEMEhz?=
 =?utf-8?B?VmNqejUvTnFjbEMwcXgxb0swUlVGcjBpRFVHRDJ2anBieWNoQVNjemNBWFRK?=
 =?utf-8?B?VEdZNDhDY2ZNVm5ZVjBOUHlKdHdSc09zQW1KSzhHY1lRN2poOE1wLytOSDdu?=
 =?utf-8?B?YVl3R00vS1JRTkc5UkxPTFpMRmVudi9UUXpmR1V1dEdWd21iM29FZDhZV3JH?=
 =?utf-8?B?c09pUUNSSDNvTDVtVnl4L0VwNG5KbDF4M0t0K3llUC9HcklKVnRrMm5DYzJQ?=
 =?utf-8?B?NG14Y3ErMEpmV21VaU40R2xoUXJmbE90WHpxbVFWSlB4dmEzNDFESUwwdGdE?=
 =?utf-8?B?QW9lZ29HejI5czMxT21CTTZhZStwK250QTd4UEtYbWp1WGcwQ2kvbkRodWZQ?=
 =?utf-8?B?UU9RTHhhNUNrdXg1NFFCNzJuQkFvMFR3S0MrWkZwSWdIRjd5KzIzTnROelh0?=
 =?utf-8?Q?j1L2ioa5DD5iqwy56tDJUx0Ix?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 958297a2-cca4-4905-74d9-08dc4343bf69
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2024 09:55:43.5386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y6pLEz/Y8P1swhmWPx0Ho3jN4AZfbBwluX9hxWWSDAVxW3jrZCrKgIxeQ9tiEX93
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7959

Am 13.03.24 um 05:55 schrieb David Stevens:
> On Thu, Feb 29, 2024 at 10:36 PM Christoph Hellwig <hch@infradead.org> wrote:
>> On Thu, Feb 29, 2024 at 11:57:51AM +0900, David Stevens wrote:
>>> Our use case is virtio-gpu blob resources [1], which directly map host
>>> graphics buffers into the guest as "vram" for the virtio-gpu device.
>>> This feature currently does not work on systems using the amdgpu driver,
>>> as that driver allocates non-compound higher order pages via
>>> ttm_pool_alloc_page().
>> .. and just as last time around that is still the problem that needs
>> to be fixed instead of creating a monster like this to map
>> non-refcounted pages.
>>
> Patches to amdgpu to have been NAKed [1] with the justification that
> using non-refcounted pages is working as intended and KVM is in the
> wrong for wanting to take references to pages mapped with VM_PFNMAP
> [2].
>
> The existence of the VM_PFNMAP implies that the existence of
> non-refcounted pages is working as designed. We can argue about
> whether or not VM_PFNMAP should exist, but until VM_PFNMAP is removed,
> KVM should be able to handle it. Also note that this is not adding a
> new source of non-refcounted pages, so it doesn't make removing
> non-refcounted pages more difficult, if the kernel does decide to go
> in that direction.

Well, the meaning of VM_PFNMAP is that you should not touch the 
underlying struct page the PTE is pointing to. As far as I can see this 
includes grabbing a reference count.

But that isn't really the problem here. The issue is rather that KVM 
assumes that by grabbing a reference count to the page that the driver 
won't change the PTE to point somewhere else.. And that is simply not true.

So what KVM needs to do is to either have an MMU notifier installed so 
that updates to the PTEs on the host side are reflected immediately to 
the PTEs on the guest side.

Or (even better) you use hardware functionality like nested page tables 
so that we don't actually need to update the guest PTEs when the host 
PTEs change.

And when you have either of those two functionalities the requirement to 
add a long term reference to the struct page goes away completely. So 
when this is done right you don't need to grab a reference in the first 
place.

Regards,
Christian.

>
> -David
>
> [1] https://lore.kernel.org/lkml/8230a356-be38-f228-4a8e-95124e8e8db6@amd.com/
> [2] https://lore.kernel.org/lkml/594f1013-b925-3c75-be61-2d649f5ca54e@amd.com/


