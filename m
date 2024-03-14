Return-Path: <kvm+bounces-11788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED44A87BA45
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 10:20:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C84928720A
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 09:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59706CDB7;
	Thu, 14 Mar 2024 09:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uDhVQ5XO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E17EEC4;
	Thu, 14 Mar 2024 09:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710408034; cv=fail; b=fRDEGHjEzE32t+dlla6n/28Yqf/toFfUza6W8R4pCzQ7hyfbKVQmgjBzlnjfKk8FhlixEtoMRaTtxmROivvQAjWGNPJqtOmbhUMH+4BbwDHxZm6VquiHjGlPcoW4uQwp5lP2U9d4RZW8uw1DkvRu/ZgWfw323WIDT34eWd5//sw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710408034; c=relaxed/simple;
	bh=IL977RCTZtkYFOtIDJ/7v7AizyWegmZz/+kggeyr1cI=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VGK6lfIcostbYqcjnuEo9nGNHX6vkVW2UAnjK6CpzGW8BqX2mLFWNLBlwhg9H0tD+Lo1NhGaIo0hfNhDoFB0CEijmtXAPo5mn/f26Op+S2u+ucBMHYIsIwOcbE2YtdQh7fuUQWVywCfsUBjUnTYln1uDnXyCd5Gasw53AxNJPeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uDhVQ5XO; arc=fail smtp.client-ip=40.107.95.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzfWB4eKKV0QBClJPnZXZQr83CInV04CHOKPyWmd+al0l7x+LZ0SnuAfEhUQKo6+Sw7FFX2iBNUpkpoVYhMdmA8l1Ip2sKtvN/BwaEJyTwYe7mXj1RKQlhH6uzjTkd/S19DTcSC+8OGwvZwuS5FHg4eWkNRQipkg7mHOWuPknh/AZzzqQbKKSmAJxWYVjbahCnlc5D3Q2gQ3xalovG+aYha21HhCpzUyRTQLKrqv7fzFL9Dtl7s+FAhg24/5lZk4RivY5oEwCS2SVH1PnxlWUGlkxjoKyLj5cffps6xcuzG+v21nJhi1VMrSUdQEz9c96YJZOna9ANNhM2wm16MFhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7TvnqSFdWTv729xcYeXZrsJAmEG4+DkYy771Uur0gQY=;
 b=lYsx/rL0m14admYUAN0wGqdWZSG50Mbyv6gWt1VGJ3/wZvNzYiIB+quHrKJLgUN+bAVGdjphg2QipUcBFyaJsMGwG1zu8+dJHCySaB20uuxtktjJTYNu/EVydQD6dd3uLhQKeA1nnfY10Sn8gcqCGuz/xbSxzjodIKN9H3pmVoSdFtlYzj0mtwMMHPUmB+I6ASodIElSjmSePG+0IWxv4HOENnKcr3ipSDAttbu8y3L51T/rSXCcwmzEpTe+W7YRVIuxFpMayIjk8YXzQuvcOyt68VQHwI0OF694os5iFG6ppvF7mufkF1BvlWnt8+anuGYxhGtCQAqD7oqr2SMr9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7TvnqSFdWTv729xcYeXZrsJAmEG4+DkYy771Uur0gQY=;
 b=uDhVQ5XOQtlVRSo7fK/wEU6qi8ireFPjgRBcwSbrEebkVLt2oXLol/ztoWmQ0/dsI6SpU1Si+Ax/mbY61Zgo6R1sOmBIwo08CESx2FN/a0dgO45noVFLDkQfFHyWdWBkj8Bh4NfJ+kCeCGWrRoYF/lo3FlPamPawEAnkzP3f5JY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by IA1PR12MB6257.namprd12.prod.outlook.com (2603:10b6:208:3e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21; Thu, 14 Mar
 2024 09:20:29 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::f2b6:1034:76e8:f15a]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::f2b6:1034:76e8:f15a%6]) with mapi id 15.20.7386.017; Thu, 14 Mar 2024
 09:20:29 +0000
Message-ID: <d2a95b5c-4c93-47b1-bb5b-ef71370be287@amd.com>
Date: Thu, 14 Mar 2024 10:20:23 +0100
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
 <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com> <ZfHKoxVMcBAMqcSC@google.com>
 <93df19f9-6dab-41fc-bbcd-b108e52ff50b@amd.com> <ZfHhqzKVZeOxXMnx@google.com>
 <c84fcf0a-f944-4908-b7f6-a1b66a66a6bc@amd.com>
In-Reply-To: <c84fcf0a-f944-4908-b7f6-a1b66a66a6bc@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0152.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::6) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|IA1PR12MB6257:EE_
X-MS-Office365-Filtering-Correlation-Id: 42061182-1fb5-4a2d-1d19-08dc4407fdc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6gLqpdGOUxYHpc6pyZiE7QiL8DL8+npujBxXkHPWNtFRJp7pnFJKmMyvabphSpzAS2FTM91+ZBYGjsKLLhMqzXjgsjNBelxKxh5fAHIwp60LKDC3hzlUgaFx+jazgXvRuQ61ICIPNugFqB71cOUTeqpkDwDkS9+rQ5wZ6rH0dswkSr2iPz9xv9m2wweDDQF/Xv+1lbR7v6GyVINZwyrXfJPW7OnIUEXlWBkNTnLUqpTejkBnssApcnD7PT2iRL2UJr3jp3Tu3lOgDna+08yHl2f6FzK+uFjdq3rqUWQHLyIDqhz2DT2DBmTTQI4110jK3g71IqB94g46eGPx1pke+C1iu4mPAuRJHWyt3QI75ptv6ZHOCXQCBkbzOW7cdCylYmbEF1PnUvoeTRVPkzpxesqHsJzMTq+g4W7MNd0gBylkm2MReNnRr/U3XEVa4NYH+xCdtOUsPuR4jce3Pn1KPC3Kpda0QCZDM7I4I0u656cxgZenwJIopZ7i1RHR9g98JLTAk5h8utrMGJNpHvyJ9L3+ONTGfKu3XU/TD1ChRCR4XnLABqqdTc9SXC1E2nPyL5riRQsGw0oI1Y4k46mnvPqsH39v7Lly6MpvffaAZkeP41Tzoe9YuwfzDNZCzK4P
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QTZ6dWJ0dTVoTlhSajFhUWJvbEZaeVAzQW1DNXEzZWNFT3ZGdzZEbXVpOTFY?=
 =?utf-8?B?R0UxUS9QUDRrd0pDeHBSRDV6UlVyT214d1YxN0ltMkxsRVdSUWhYanZyb2ox?=
 =?utf-8?B?WC9lS2M0cHFhTnlvUldKdW1TRDBISXFaVjUxeitZMm13MGpLLzRweGVZOUxp?=
 =?utf-8?B?TFBrWGVMRFFwRDQycjhWVmRNUUpwb0FhazNLbmxnWjU1YWUrZUdSeHRYRFBo?=
 =?utf-8?B?WnF1YzVjV0toZCtXVjFkWVVCamZXanZibkxHUjlFRWF6V1hDRWlHUWhhY2lJ?=
 =?utf-8?B?SGtpeU1qWUxDYnlWMGZjRmhzdDBNNCtlU1dZSTQwdVZSRWV0WTl2VUN0U2Y2?=
 =?utf-8?B?RGtZZXNJUVVFcDBGeWFpSVZxVDExdDdRTERwbVVqano4aEE4cjJSN0dnMWQy?=
 =?utf-8?B?YmxJZzM1VGlYdmJjcVdlbDJjK1cwUVkwUWZNN3Bxd0V5aWt4STJsek9EMzlj?=
 =?utf-8?B?czdscmt5MXh4NlhkakVxSVF2VUJEYSs3TlROc0NBQmtuNTFKUnUwQWp5aEp0?=
 =?utf-8?B?ajZuVVc0cWUxV0F2OUczSkhXOXNHSXNGRVh0UkU5VkRIbTYzazFHeEZ6UEJh?=
 =?utf-8?B?bS9vdnNjMTNyaER5S0VDTkJzVDVOeXVzVkRNUzZpNE94UitLV3hIRkFqVmt4?=
 =?utf-8?B?dnQ5U2dGOVRnanJUTWVZVGJzaitwWVVObERDNW8wQlY5VjVzNGU5SEVWTG5v?=
 =?utf-8?B?aEhvODRFeUQ4bE5yeERJeCtzS0tIVWFmcHU5bE5KSG5WMWNHOTc5YlBuOHV0?=
 =?utf-8?B?dEsxRE93ZjBFcE9iYnl0S0lUY3JFVzY2YUZYOGN1dEdaVVlLYzNmeXRJeDhH?=
 =?utf-8?B?ejZ5TFhJTThkSml2bm1FVFJxeUtlTVhNc3h2N2FEanFkcFdiZUVwc1RIT0xP?=
 =?utf-8?B?V2JlYzBZc2xicUROYVZ1OHJVZStaZkZvQlNLMG9jcER6OW9sWnlRTG1wNmlC?=
 =?utf-8?B?ZXY3bHlwQ0lINk01eHQyWnlVSWFiZTRsWHlYK1NTNFQrMFU2TkhiZlV5dVcy?=
 =?utf-8?B?MG5TVVRmejA2YUl4OG5UQk01S1EzM2hqRWJlOFpRZlBDa0E4VGVxMFFxN3Nz?=
 =?utf-8?B?ZXpwL1VRYUlpQVViYnplYnJwTjQvb0loVGc5R1BhdWhtY1haRFJRY2MwaUF5?=
 =?utf-8?B?TUh4Z3UzRDY2WHhvdWl5M0NHS3RQR3VYdzcrREVVRmMyRk1wWlBQc1pxei9v?=
 =?utf-8?B?MzdpZmtaZXphS2xQcmc2UmNhTFN0TWdjWTVkSXczUTUxeGtqSytYZmkveWI2?=
 =?utf-8?B?V1BJN2c3UFlSRy9pWjlwQkhDU0R4ZVdNRnJjMmhmTVlaVEZxUnQ1MjhiMVdo?=
 =?utf-8?B?NWw5bnpXV21YMWFmMmFQZlZ3UlFSVWVqL1dHWGpTclFxRFFlWnhhNGxCRmd1?=
 =?utf-8?B?dUpxV3RIWnZNYkova3NYSm1mUDJCYUlkcGtySEh3dm03NEY0Vm9CNkVrZjR2?=
 =?utf-8?B?Sm9yNzgxUTBEOGFUSm8vMUttR2EvM2dkdlBSNzd1eXZQR1U4dG1USDU2WE5B?=
 =?utf-8?B?VktIRFNzQXN1VUpZTG1hY3JIQTVtQTFqMDc2cXBrcFNLRURaRWhwQVRuSXJq?=
 =?utf-8?B?VTQ2d3ZlajlvWnJmalZNK1pCRXhGeFhuZjYxY2U4OS9zeFp4aGhyelBTdTNV?=
 =?utf-8?B?VVU4eXZBNGJHbUdvTlhlWnFMRys0VGpwRTZwN1lJY3cxcFlGWXlGaWxwOXlU?=
 =?utf-8?B?dzkzeXNBbnh6YmFKdXhiaVlPV0RzRlU4T3FZL2htNXg1bDkxSDhCK2dkanU0?=
 =?utf-8?B?SW5nMW9MVUJYbWM0YzBwblh0ekp4OHlxTGV4VXFobE1zLzJJeXYrcVpkdkM1?=
 =?utf-8?B?SmIzQ09vUFVnenJMQXlhZWhvVDRKQnk3LzRqMHpFa1RJd2JpM0xBN1d2SXJv?=
 =?utf-8?B?aXRyV1ZGY2R1dnppakR5Z3JzOFptRmg0bFEwNGx5UUVJYlBURU01M0lEVERw?=
 =?utf-8?B?dVhoajEza0NLNWZ4UURyRGo3ZGJmeGlFMUU0RnhZU3NXd3laQ0t1UDB4bnk0?=
 =?utf-8?B?OVlUTnFrYVlUbnhkMzlUbWFyNUphNERWM3Z6NWo0bVo5Rzl0NnVvamQ1S0Jp?=
 =?utf-8?B?clF2UVcycnZJQ0tqT0h6ZlZYUTRISlJBbnltRGllRXUzdjJEN0cwbjhVZk02?=
 =?utf-8?Q?9FVS6GlUv3sV7feX5FfEqYSvp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42061182-1fb5-4a2d-1d19-08dc4407fdc4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 09:20:29.3956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pJyWkeUdGvxkddqkUyYeBtwEGtVPkbHGyaQ1RKxrz4WyiZV8qMTnraj4HexsDPZ9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6257

Sending that out once more since the AMD email servers have converted it 
to HTML mail once more :(

Grrr,
Christian.

Am 14.03.24 um 10:18 schrieb Christian König:
> Am 13.03.24 um 18:26 schrieb Sean Christopherson:
>> On Wed, Mar 13, 2024, Christian König wrote:
>>> Am 13.03.24 um 16:47 schrieb Sean Christopherson:
>>>> [SNIP]
>>>>> It can trivially be that userspace only maps 4KiB of some 2MiB piece of
>>>>> memory the driver has allocate.
>>>>>
>>>>>> I.e. Christoph is (implicitly) saying that instead of modifying KVM to play nice,
>>>>>> we should instead fix the TTM allocations.  And David pointed out that that was
>>>>>> tried and got NAK'd.
>>>>> Well as far as I can see Christoph rejects the complexity coming with the
>>>>> approach of sometimes grabbing the reference and sometimes not.
>>>> Unless I've wildly misread multiple threads, that is not Christoph's objection.
>>>>   From v9 (https://lore.kernel.org/all/ZRpiXsm7X6BFAU%2Fy@infradead.org):
>>>>
>>>>     On Sun, Oct 1, 2023 at 11:25 PM Christoph Hellwig<hch@infradead.org>   wrote:
>>>>     >
>>>>     > On Fri, Sep 29, 2023 at 09:06:34AM -0700, Sean Christopherson wrote:
>>>>     > > KVM needs to be aware of non-refcounted struct page memory no matter what; see
>>>>     > > CVE-2021-22543 and, commit f8be156be163 ("KVM: do not allow mapping valid but
>>>>     > > non-reference-counted pages").  I don't think it makes any sense whatsoever to
>>>>     > > remove that code and assume every driver in existence will do the right thing.
>>>>     >
>>>>     > Agreed.
>>>>     >
>>>>     > >
>>>>     > > With the cleanups done, playing nice with non-refcounted paged instead of outright
>>>>     > > rejecting them is a wash in terms of lines of code, complexity, and ongoing
>>>>     > > maintenance cost.
>>>>     >
>>>>     > I tend to strongly disagree with that, though.  We can't just let these
>>>>     > non-refcounted pages spread everywhere and instead need to fix their
>>>>     > usage.
>>> And I can only repeat myself that I completely agree with Christoph here.
>> I am so confused.  If you agree with Christoph, why not fix the TTM allocations?
>
> Because the TTM allocation isn't broken in any way.
>
> See in some configurations TTM even uses the DMA API for those 
> allocations and that is actually something Christoph coded.
>
> What Christoph is really pointing out is that absolutely nobody should 
> put non-refcounted pages into a VMA, but again this isn't something 
> TTM does. What TTM does instead is to work with the PFN and puts that 
> into a VMA.
>
> It's just that then KVM comes along and converts the PFN back into a 
> struct page again and that is essentially what causes all the 
> problems, including CVE-2021-22543.
>
>>>>> And I have to agree that this is extremely odd.
>>>> Yes, it's odd and not ideal.  But with nested virtualization, KVM _must_ "map"
>>>> pfns directly into the guest via fields in the control structures that are
>>>> consumed by hardware.  I.e. pfns are exposed to the guest in an "out-of-band"
>>>> structure that is NOT part of the stage-2 page tables.  And wiring those up to
>>>> the MMU notifiers is extremely difficult for a variety of reasons[*].
>>>>
>>>> Because KVM doesn't control which pfns are mapped this way, KVM's compromise is
>>>> to grab a reference to the struct page while the out-of-band mapping exists, i.e.
>>>> to pin the page to prevent use-after-free.
>>> Wait a second, as far as I know this approach doesn't work correctly in all
>>> cases. See here as well:https://lwn.net/Articles/930667/
>>>
>>> The MMU notifier is not only to make sure that pages don't go away and
>>> prevent use after free, but also that PTE updates correctly wait for ongoing
>>> DMA transfers.
>>>
>>> Otherwise quite a bunch of other semantics doesn't work correctly either.
>>>
>>>> And KVM's historical ABI is to support
>>>> any refcounted page for these out-of-band mappings, regardless of whether the
>>>> page was obtained by gup() or follow_pte().
>>> Well see the discussion from last year the LWN article summarizes.
>> Oof.  I suspect that in practice, no one has observed issues because the pages
>> in question are heavily used by the guest and don't get evicted from the page cache.
>
> Well in this case I strongly suggest to block the problematic cases.
>
> It just sounds like KVM never run into problems because nobody is 
> doing any of those problematic cases. If that's true it should be 
> doable to change the UAPI and say this specific combination is 
> forbidden because it could result in data corruption.
>
>>> I'm not an expert for KVM but as far as I can see what you guys do here is
>>> illegal and can lead to corruption.
>>>
>>> Basically you can't create a second channel to modify page content like
>>> that.
>> Well, KVM can, it just needs to honor mmu_notifier events in order to be 100%
>> robust.
>
> Yeah, completely agree.
>
>> That said, while this might be motivation to revisit tying the out-of-band mappings
>> to the mmu_notifier, it has no bearing on the outcome of Christoph's objection.
>> Because (a) AIUI, Christoph is objecting to mapping non-refcounted struct page
>> memory *anywhere*, and (b) in this series, KVM will explicitly disallow non-
>> refcounted pages from being mapped in the out-of-band structures (see below).
>>
>>>> Thus, to support non-refouncted VM_PFNMAP pages without breaking existing userspace,
>>>> KVM resorts to conditionally grabbing references and disllowing non-refcounted
>>>> pages from being inserted into the out-of-band mappings.
>>> Why not only refcount the pages when out of band mappings are requested?
>> That's also what this series effectively does.  By default, KVM will disallow
>> inserting *any* non-refcounted memory into the out-of-band mappings.
>
> Ok than that's basically my inconvenient. I can't really criticize the 
> KVM patch because I don't really understand all the details.
>
> I'm only pointing out from a very high level view how memory 
> management works and that I see some conflict with what KVM does.
>
> As far as I can tell the cleanest approach for KVM would be to have 
> two completely separate handlings:
>
> 1. Using GUP to handle the out-of-band mappings, this one grabs 
> references and honors all the GUP restrictions with the appropriate 
> flags. When VM_PFNMAP is set then those mappings will be rejected. 
> That should also avoid any trouble with file backed mappings.
>
> 2. Using follow_pte() plus an MMU notifier and this one can even 
> handle VMAs with the VM_PFNMAP and VM_IO flag set.
>
>> "By default" because there are use cases where the guest memory pool is hidden
>> from the kernel at boot, and is fully managed by userspace.  I.e. userspace is
>> effectively responsible/trusted to not free/change the mappings for an active
>> guest.
>
> Wow, could that potentially crash the kernel?
>
> Cheers,
> Christian.


