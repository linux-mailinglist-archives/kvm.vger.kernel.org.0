Return-Path: <kvm+bounces-11740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C0F587A99D
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 15:37:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 603901C21A37
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 14:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F154A04;
	Wed, 13 Mar 2024 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="m8u2UKQz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2064.outbound.protection.outlook.com [40.107.100.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A1A79DD;
	Wed, 13 Mar 2024 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710340653; cv=fail; b=qNdVRRdyTb0fufvXpdrtFljJXottFJ0+fzlLTU1UttkSOMlimnudY6bHZbyKct+MQ6QDwVG7hwu537smodVrU+UkCXg8gU1ySlGD8pUnGocOH+BNmYohs/n4m8EWGu/dbDYoJ5iFzHrzgU7sLzekXAJh07KKZZrg+Ah7R/oQ28E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710340653; c=relaxed/simple;
	bh=8uN4GSOB4YzjmY98U23xU0LQyHYHfxk+isepjZLWcqM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s3lDqEVVGhTjq91A1yrRV/L/z4e/V9FYLwZZaY4Hh5qMu/d4gmouOKLVnqEbye2d5G0dp718EaqNyHWf78rgC0rOZB3t9OtlJQjy3WSRnZPUnoB3nCxy3/Wm4EyhJ6TTQrCIzpUfs/aHL6FiAcG5UGpLeIopp5p8s4kTLQ4wCec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=m8u2UKQz; arc=fail smtp.client-ip=40.107.100.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdxuHPb1CHPv4qgKinxLx2veWYmm2FIPZTW99Os2tyM5cGXNaEH1ULoeWP9yWJAcESuwuRvc9REsu4HNpZ23JvkPknlL7gHwdD0DA5zw7knR5l509VMqTduEBpb8GZp+vx690GwvQGogeVImI/bos2q3qrjRbAYIUkm+cC2rm9KwgSzBDRvDWtFpZ3EWxwbtDcARPKqQEdIc5ZoD8qYCm74QQuGuOKG3Il1rwcXMFPVkD73wv3O0MhiH2bFcgQofOw4K4M+LAlrtZTC9nU5DnUpfuhqg70xK/9O+mmjAn8I59ED78R3J1VqgCfjboxRy54MnQlsoc+IFlgRw6sIrhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t3sM2calt0Gtq/Ha0hrZsC02wi1HPQEOlNrMwZ00iz4=;
 b=iG4hHolVaqlV8mugj19HHfpmJSsptslwDv0tsAlGFjgVQeLF51Nb120xLlKwoXHOzd/gfyK/A9g988JguXpx3kPcN+cx/g79FYnt3eVloO5LcFX3TRXtUfheBrN1mzGrYGdGbBooR76FVnCauhDqW3HEpCMo0AVar/kxTUL02bpR14Bqx6+L5xP7wqkeWLJDPHc3T9Wa5GpbVRQTgSZ16M/yhtsDZ0Tla1ssd1lBKHCRFF9HqpIxNdb0CB6w/6TA03YhJT+KWfvHXdVq/CgsGf31mKPNJjNAcBlghaJvhA8xchuPcFLXPHaTCG3991jH+h4vMjsHWq8BOTZLfqkINA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3sM2calt0Gtq/Ha0hrZsC02wi1HPQEOlNrMwZ00iz4=;
 b=m8u2UKQz9BI77791R2B0WnzpI6DCJznQtCLz6zC/wVJiUXsYMo5tOErRRCk5uAZmXFzR9ZnW8phLrAfq5SsFZ4pyZu9Lw+6d2Md9Sr21mwasrJ0EiJkElT6r7sZS87pd2xH3H4DwjeaS/Ce6V+8bHQoCDpGMJHk4Jyz33qH0iYM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13)
 by LV3PR12MB9186.namprd12.prod.outlook.com (2603:10b6:408:197::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Wed, 13 Mar
 2024 14:37:28 +0000
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::ff7e:b189:da4c:dab2]) by SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::ff7e:b189:da4c:dab2%6]) with mapi id 15.20.7362.036; Wed, 13 Mar 2024
 14:37:28 +0000
Message-ID: <0b109bc4-ee4c-4f13-996f-b89fbee09c0b@amd.com>
Date: Wed, 13 Mar 2024 15:37:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
Content-Language: en-US
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
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <ZfGrS4QS_WhBWiDl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0171.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::7) To SJ0PR12MB5673.namprd12.prod.outlook.com
 (2603:10b6:a03:42b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5673:EE_|LV3PR12MB9186:EE_
X-MS-Office365-Filtering-Correlation-Id: 91f45481-c2f7-452e-38f1-08dc436b1bb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+yBINtKzcel3XD7/Xh4J6JeaDCMp/H8Zsz5WU/j8++sMIlJIHzO9KcMuQ3xxsZLlPO4Xw6010UO1Nsg8YMwUMWK3ouIcf739lhhiAgmZbqdHMeps8udHmwhH5XcEYDd9yNmsobsYDn0LXEbwCGL9XOvfO+bFSdOjQnauMnzD+cLkPQ8sRvLHpTCt7Dd969+H7hNM1ylPeTfVKcCyfgXx5GWUlJX48UArcjHhKRXFsKEA7OKU7u2OPITW0HAMWTIVZh8VIJ+TE1LbXX4MtU6rvSmT42Dm8ApGcKSPp+sboJ9xCJ5Vnm8plfnSO7Btcd/Ykl0lMgiGw27BHLtf0DL3QJe0Dfnt+pfQx6Bu12MUePSZ4q6vXohhG4f46n49nKFCCG4DGIZ6uMVibuqlQk2mA/fYxIbx+APVd/s+Yd3FyZ/hQFplULjWoRF/MjPWc9GGe8e2orQTRg+/6sjjrgmiLexh6JvempDQPNIJllTJDLmpjKceu2xYOTxT2tV0XFV1xZRxzDQxvZdM8syWRHxT4/t8OFqDtxDDNU0z/mOavZLpRggjcriQsBVADLIJRzmh5qz5zUREGObmK3C419wT2usrbB6XiFCsDsAebo2CeXFk01aKYefuDifQZPRfURd5gk1dkUFfcMBb+Zl3FnVkX2CLgN2x/l8+rk5fJJ8j/+A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5673.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alFYMWFzbUdNdVR6cm84OFV3d01GSldVWnQraVhpeFFmWElTazhYY3NyMGwz?=
 =?utf-8?B?NlJiMktPeFNxU2RsaXcrSnU2T1VuZTBPZW9Lc2VCM3g4QXRtZ0pYN3daS1pR?=
 =?utf-8?B?VGRzczdKaGNqaExmNW5ya1pKSGpzNUxETHp0amVCa3ZVYkxuTG1DSnhXU1c1?=
 =?utf-8?B?WkI0RUpVWXdYajA4akhOc1NSdkpIVytQektSMUxoOWJJK2V2RlpMUUs1T0lx?=
 =?utf-8?B?V1Z3NmQvSEpwNFpDc29ZaEQ1S1N2K1BpamNMRjU2cnB4eWE1ZmpyWlZ2blI5?=
 =?utf-8?B?V0dkcmJxeS9ZdGtIUGw0c1gySWFUY3A0Y282WFZXRHBUVlR4Vjg0Y1JwL21m?=
 =?utf-8?B?WXc1QmVKZG5MR1ZkZFdOWGNwVGNNcnlYQ1VJc09rcVhNQ2VRNytRQ0dEeDZk?=
 =?utf-8?B?L0R2SXJXVk8rZ1Q4WXdBdHF6VXB2SVFZM0VrNTcrRmVMdmpndnF1WkoxYzBj?=
 =?utf-8?B?L3pqZ2ErU3czTk5oUEhSYkkwbDBxbTl4WHVFUXJrZ1RBWUdpeWkrY2I4ZSto?=
 =?utf-8?B?VTRPNW9SNVJFUWNTazVuVnFxTnV3N2cvVXMzWldkcjRuUDhLWEdadGc3VllP?=
 =?utf-8?B?Z0I5cCtGb0hZRHJ4UktZeEdXWlltQXVUeDZSZVRsLzJYZjhzV3FHTWNSQkJ4?=
 =?utf-8?B?R1VZYXRlR3F3U3dZUmZMU0xxUTI4NmRTNDZXcDZqbWRieUtPMUVCOUc2ZzJF?=
 =?utf-8?B?R1gwaVh5U2VuZ0VOenNYN3NUUjZQbDdySjFDeTM0czlkVUlibmhSU1FyLy94?=
 =?utf-8?B?MUYxa09SM2xLaXpQQkN5bXhQQXNSYUNZREprOTY4emxJY1h4SUVQUGpxUlFD?=
 =?utf-8?B?WlIrNWhkWFQxSEpqanJ0ZVU5d25aWWJsYjlhRDIwdUpLTjdBSVZDNThsSWo0?=
 =?utf-8?B?UTBFakFwM0NlRExmVDlBUGpaNGwxRWcvenhZb1V5OVhIZ1BEMnZNOWFXOG1F?=
 =?utf-8?B?aDA4MEN0Q2Rma0RsTjhjbUgwMENXbjFrVXVtU0tRMDFNRndYeDdkNmhjNTVT?=
 =?utf-8?B?WTVQY1RpR0dQbFpJTms2WkRHUG56TUpSN2Z1THdpMWIxajJWNUxoMUcvOGhr?=
 =?utf-8?B?SzZtYVV0OWVOWVlkVlJKVnpZMTNreTBPc2xlOUFnaTZqdzFZMDlVOFkvS21y?=
 =?utf-8?B?RFdRaEtxQkR3T0dtck1mR3BhT3E2R3VwUHZKemkzMlRzSEVvS3VkbmJDLzBn?=
 =?utf-8?B?NWJQa3JIUXVtWTVTNy9uNUZ0Ry96TTRvTTNXeGdKZ0RyT01aSmc4Q1QxMCtV?=
 =?utf-8?B?cWt2RW9wS3RsRUQ5djVsYlA3ZjU1TzduanhTL3hsTWFXNUNJNmY4NVVWSGF6?=
 =?utf-8?B?ZXlVcDZTN3NIS05hTXA5U201Qk9zS2VMYkI1aTIzRUxRay8rR1NrWGJwV1VM?=
 =?utf-8?B?VnBmVkpvRUQ4cnpQNjkrY21kNmZBMVJ4QzdNUWdYTVBzUUVzVC9ReEZUNEdv?=
 =?utf-8?B?Rlk5NmFxTEFYckdHUmt1b2tHSml1VldoSXlKdUdSZnFKeWVQNlJrUU5tMlNW?=
 =?utf-8?B?N1ZCcEJGMWJtVnIwemhhUHhlMTZlcTQvUHBiRkppZnI2NlE5SWRLTUlrWDVI?=
 =?utf-8?B?OG8wV3FWejNFZlZ0WVpqMDVSQ2tPVHg0VzJ6WXhxM2dUM0hmdEx1eENxYm5u?=
 =?utf-8?B?cFFmTyt1KzQ0bzRnZWRBM1JNeXhUYVAxQmszWFprQ0hpR3l2eTFXYnRLMW9k?=
 =?utf-8?B?SFQwcm5pUUZDQ2Jpa2NSdjk5MXg1bnphR2J4bUI5cDVxYVJDYjJHNWNrWG9J?=
 =?utf-8?B?MzdBN2p3NXJHdDNtVDg1R3hNSSs1S1pUSmtjMDYyTnVEWnlKOHZlMjNGV0VV?=
 =?utf-8?B?YWdFVzlhNzlUeG1qaDRuNVN5WXJhcEFqUDZNMzJoelJCV0NGODRZM0xKVXha?=
 =?utf-8?B?NDV4dlduWXczdEtocE5RNDlDc3IxeUFZTzNQc08wV0xiN0NjcFVJRG8raWpH?=
 =?utf-8?B?Y2hoQ1ZsRFVjc2lyckp6Y2xvcjZaL0ZaWStTUnowdURxMmlDNWZrNXRoZVBn?=
 =?utf-8?B?eDdRR2dsSmJCSEQ1QWVmNjdVYi96VVlCNEJxQ3FsaVRvN0hqRnBGbDhxOGVK?=
 =?utf-8?B?MCtWalpmc1lYSldqQ3lkZDhZbEF5WENSdzlWRVNqWlZKNngzNE9MQ3VHU2NH?=
 =?utf-8?Q?tJy+weRegPp8pbEZxF+LlBwa1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f45481-c2f7-452e-38f1-08dc436b1bb5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5673.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2024 14:37:28.8136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0BBiRzJLUgkJaE0kD2znBkQB1Txgqy9tUw7DBOzVZRKL9becUSTrP7Ooqk9ckmeH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9186

Am 13.03.24 um 14:34 schrieb Sean Christopherson:
> On Wed, Mar 13, 2024, Christian König wrote:
>> Am 13.03.24 um 05:55 schrieb David Stevens:
>>> On Thu, Feb 29, 2024 at 10:36 PM Christoph Hellwig <hch@infradead.org> wrote:
>>>> On Thu, Feb 29, 2024 at 11:57:51AM +0900, David Stevens wrote:
>>>>> Our use case is virtio-gpu blob resources [1], which directly map host
>>>>> graphics buffers into the guest as "vram" for the virtio-gpu device.
>>>>> This feature currently does not work on systems using the amdgpu driver,
>>>>> as that driver allocates non-compound higher order pages via
>>>>> ttm_pool_alloc_page().
>>>> .. and just as last time around that is still the problem that needs
>>>> to be fixed instead of creating a monster like this to map
>>>> non-refcounted pages.
>>>>
>>> Patches to amdgpu to have been NAKed [1] with the justification that
>>> using non-refcounted pages is working as intended and KVM is in the
>>> wrong for wanting to take references to pages mapped with VM_PFNMAP
>>> [2].
>>>
>>> The existence of the VM_PFNMAP implies that the existence of
>>> non-refcounted pages is working as designed. We can argue about
>>> whether or not VM_PFNMAP should exist, but until VM_PFNMAP is removed,
>>> KVM should be able to handle it. Also note that this is not adding a
>>> new source of non-refcounted pages, so it doesn't make removing
>>> non-refcounted pages more difficult, if the kernel does decide to go
>>> in that direction.
>> Well, the meaning of VM_PFNMAP is that you should not touch the underlying
>> struct page the PTE is pointing to. As far as I can see this includes
>> grabbing a reference count.
>>
>> But that isn't really the problem here. The issue is rather that KVM assumes
>> that by grabbing a reference count to the page that the driver won't change
>> the PTE to point somewhere else.. And that is simply not true.
> No, KVM doesn't assume that.
>
>> So what KVM needs to do is to either have an MMU notifier installed so that
>> updates to the PTEs on the host side are reflected immediately to the PTEs
>> on the guest side.
> KVM already has an MMU notifier and reacts accordingly.
>
>> Or (even better) you use hardware functionality like nested page tables so
>> that we don't actually need to update the guest PTEs when the host PTEs
>> change.
> That's not how stage-2 page tables work.
>
>> And when you have either of those two functionalities the requirement to add
>> a long term reference to the struct page goes away completely. So when this
>> is done right you don't need to grab a reference in the first place.
> The KVM issue that this series is solving isn't that KVM grabs a reference, it's
> that KVM assumes that any non-reserved pfn that is backed by "struct page" is
> refcounted.

Well why does it assumes that? When you have a MMU notifier that seems 
unnecessary.

> What Christoph is objecting to is that, in this series, KVM is explicitly adding
> support for mapping non-compound (huge)pages into KVM guests.  David is arguing
> that Christoph's objection to _KVM_ adding support is unfair, because the real
> problem is that the kernel already maps such pages into host userspace.  I.e. if
> the userspace mapping ceases to exist, then there are no mappings for KVM to follow
> and propagate to KVM's stage-2 page tables.

And I have to agree with Christoph that this doesn't make much sense. 
KVM should *never* map (huge) pages from VMAs marked with VM_PFNMAP into 
KVM guests in the first place.

What it should do instead is to mirror the PFN from the host page tables 
into the guest page tables. If there is a page behind that or not *must* 
be completely irrelevant to KVM.

The background here is that drivers are modifying the page table on the 
fly to point to either MMIO or real memory, this also includes switching 
the caching attributes.

The real question is why is KVM trying to grab a page reference when 
there is an MMU notifier installed.

Regards,
Christian.


