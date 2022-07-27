Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D521D58230E
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 11:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiG0J1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 05:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiG0J06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 05:26:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A1914D31;
        Wed, 27 Jul 2022 02:26:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wgsh5AXaY07MACGsIc+GzXawZRzyfHHdZgD50CBsEplR6bIlvzownjJnnSERfSkaShmk07jtZGkGSke5QTU95dG5SM1WClFQttiaRROVEqxCsQNdLVver8BB6b3v56YpgKiL6NTNvMeoyfLn9bcem3isvXPffD9bbT3ZLUFJjAjuR8b0QOMwoK9u+Xq4aSuAOz+q8Fw1JN8X15Yf4Yw06vweIIw1ohLeobeCdsT+33tnC7OmSsSqlzGTG7+FaAy38gQ9pu4UTmBI4amlL9Uol0+8mWB8uCETGiUJyDKi6tXTM+GAt52IvZZwq9UqUE5XTiicTYGz9vq41WdOF/mcCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5jhVK9m5K6kx1zUe8ws7RWwq3ni/SAdIUem+LyIr2A=;
 b=kEI7T78u9JyKHlsMVJ/+Te0Vx2clULJ4keQCoeqYpCjB6pXIyidB3fUWULLSw3v2po6kdF/verZh8ONNHCRCu1HcCdZTblPipp6QSi8FTQ1ZEoz8BT1FYjnqcigD6n4292+Wq+M4f429ci/xxXN3cIF+0QC7Q8wE4LcafSu9P+nH8aW4OCW/73qV9q9mSOrqQKXYRxqulUKPJ1tmJTuyk5pzt6wJ4+G7QpRP+sB/MtTeY/uymU+c3kB0IGuJJfuM+E98QeU8c8PywIDNP5Mw59hkkhwuxjN/RW9bL5af5zRMo3h3SVGSxySsq7cvByHIWNG3vD4cIjYMglXH5Sm5hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5jhVK9m5K6kx1zUe8ws7RWwq3ni/SAdIUem+LyIr2A=;
 b=nHxQu0taOy852xuW185LVQU7mq3gXkBjiZBKa0tOeRXqHh2wKh7HP/JbxsFiDZzRRXevJzYEn/5caxX5RAAHQ2Pzp3wLjeVnQ0h2PCtW3fVNUaUxaYnVUCIBtK+gIr7jDXRatNTkp7uS3tsu+ijkEFJ9R/yEPqU4pM2iAFfmpXE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN0PR12MB6223.namprd12.prod.outlook.com (2603:10b6:208:3c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Wed, 27 Jul
 2022 09:26:52 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::d9f4:5879:843b:55da]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::d9f4:5879:843b:55da%8]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 09:26:52 +0000
Message-ID: <e234d307-0b05-6548-5882-c24fc32c8e77@amd.com>
Date:   Wed, 27 Jul 2022 14:56:40 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 000/102] KVM TDX basic feature support
Content-Language: en-US
To:     Chao Peng <chao.p.peng@linux.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <Ys9rcnyIZlUc76iG@google.com> <20220720145927.GA124133@chaop.bj.intel.com>
 <d0e82407-91fa-cfa4-ff86-262075d23761@amd.com>
 <20220726143259.GA323308@chaop.bj.intel.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20220726143259.GA323308@chaop.bj.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0187.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::14) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dca227b7-ff4c-401a-21f2-08da6fb22371
X-MS-TrafficTypeDiagnostic: MN0PR12MB6223:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dye4p2EqHaDQYa0DqPOUSxfCGoZgG26RVgYbZOItGAb+DY+j7pKq5uNWaRMQH81Tj1umVlCpE+9N03jcJVHstp9jtWVh+ipYzMbsC7zjevYANX22FOOYIF5nJwVa3ItAW3gy3MyciwmmB5tXAosvMKCXwwvzBGQYrEF0h6KF9QGr7y9BhnLqSmzec9rThNPOjSQl5cFuhxd7SDdmycmFJy6OrGXQfDRwycTrKs7skI8ORnfpPpkEQxVe2G0BDt0hMyx3HScUdi6JFlp87CpLhH6qI2t8UJuR0jVGk3xsflrq1TnQz9Hnq2sm2mxr/Ih+E2avqgj6hhYPYfh+hk95WfRE7zDxnX8Pi+inUBI9pfk3tNTBc1uRpDdhQitdtvY/KacmrBI3WjyeYNx2fu6/7CKTprIrNVZ5ZtsE/k/Id4Cm0F6L13o2k8ZZA9ApBsydXpLNJ+VfeGEDVj52NtiKHuJ1ZUBY53e69KBAygOvMJmusNWYipzCLdO9O26AYVeliuX4HzBFKOfVCw6Tfc1VB+6t6NjwBBuYn3XlvOoFokal39FGfC0tFAVhGVMkCu9TN2WKffMVE4pUFr6a0U4vY0h/bPtHoAvtNpHnQP73/pHCYWbMWj2kvs1IA7TYZwa0Lw67croFt1J4mQqF65P5ss2Aa3pMVOjkPjNcov7piLYywFKBc/SqRLR/X/35TGI7z8xapDYyhbdWW3T6sKp35wXzwHUwGjPr7tTv7qjGQugjENl8u8CZwrSxxFu3683jQn/kn3lSmCtxyznJfRHeMaoTq03KVbJzwf0Rd9IkfSwPkEyYSB+Ig2t/oTe8U9yBJuxSY5DtUm+a3C12FceYIAsR3gZVPJ9v8RSZHkjWvh4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(316002)(54906003)(6486002)(2616005)(31696002)(6916009)(966005)(38100700002)(186003)(2906002)(8936002)(31686004)(5660300002)(66556008)(4326008)(66476007)(36756003)(83380400001)(41300700001)(66946007)(6512007)(478600001)(53546011)(6666004)(26005)(6506007)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cExQa0lhaUVKQlllcTFmRVZQY01NbXlTZThuNDQ2YzNaNTVJSWgvK2RiaGZx?=
 =?utf-8?B?UEFYak5NT2QzUzdUZjdqNWlZZVYza2NCVHVQVmo4ZXhTOHVLNnMwMkl4QUZE?=
 =?utf-8?B?TmZBNXozTkhHMVc0eXd1QWVIWVJjOU1TZjJYU3U2bFdaZTVSTXNiV3QrYUky?=
 =?utf-8?B?ci8welg1V3ZlWkE4SEUza29peWRURU5WNGZtdmg1YjJubzNEdDQwdlRscDI3?=
 =?utf-8?B?WVN1bjRhOXY2SWMyY2dsUEVHYmdaVTBYbnQ0NHltSTNPaitia1AyYlV5UVVP?=
 =?utf-8?B?c2czdnQ1YURjRFFXdHhHanRkbTkwbC9LMm41RjdsSGZHOEJtYjVRU0xXaElv?=
 =?utf-8?B?UEJveHBYMkhOTklOZ1dIaHdJQ2lFQ0NBY3cwTXc2ZzRFdVM5anpFUk81Y1d0?=
 =?utf-8?B?QUhNTk1KZkVzSTBWQzF4di9zUEsvWkp2NWdyRktXdXFjMm1oejByWFhwRGxn?=
 =?utf-8?B?cHN6dXR5MHNaamthdmd4azlsM2Z2VFZvWXZSMkdwSzZLcGh2ZndoT1REVHJ3?=
 =?utf-8?B?N1A0dHNyOUhFalo3dG1UNUVTV2hoTXlQRzhnOGNCYWI2d2RLNHdwVjAwMGFI?=
 =?utf-8?B?RmhmZEhTUllFSXhkWUJ3djBESUlzcFlTQkdSRlI3Y3ZnR0lvdmdNQkw2RUtI?=
 =?utf-8?B?OGFSeEY3VDA4RGt0V2ZFaWNLTUdBYlhYWG16YVNmQS85WjVLSlVQcWJFekpN?=
 =?utf-8?B?eTZNNnNUN0pUR0dvSS90WVp2dlRqTTZnNVFZSmowY2JjU1FoOHNOcS9tYk83?=
 =?utf-8?B?N1J5YWdMN1dzNkVnb09uN2kweU90Q1hwSGFQemV5TEJqZ3I4WkUwenN5VTZV?=
 =?utf-8?B?RkhjbjZwRUs1QUpiQkwyYk5sT3hCQitWUmZrMW5lU0Fkb2VkaVRuSzgzemZV?=
 =?utf-8?B?bG9qYmF4MVR2aS9taWlOc3M4aHVwd0FzdzdkMWFxVmVIVDNMN09wM25WN2ps?=
 =?utf-8?B?MUdtTnl2SlNGcjFEL0pEbmtPdWcyUjFDRGdFcW1GMVh2emg5ZmNzMi9BSElE?=
 =?utf-8?B?YlROVmRqdVBZalZ4S1JKQ0RLMEdKM01JdUVYR2JhUmRDN3pQTVV5Y3E4SGNC?=
 =?utf-8?B?N1ZtZ3MxSkMvejV0cldaSzhWZHBlbFl6Y1hjY0FNMWl5RHFVV2lYNys1dE00?=
 =?utf-8?B?bE14emp1TG9kQ2FhV0lkeHl4OUdSMXdYM3NPYm5sbFNtNWtIT3pqKzFhS2xs?=
 =?utf-8?B?WWZvZ3c4SnBMYURySjQ0OWZBU3Q3cWo2UTQyeFI2Qll4SWdzMjB3d1FsN1Bm?=
 =?utf-8?B?RDNQdE9vSm1aengvTXNCSnBqcldkRTZGQnl1TkhPak9sRGhXTU9uVVZuVnFY?=
 =?utf-8?B?MFpuRmdyT2pmWmNUMmtpYVhKYnU0RUdnUjV4cE0wVTFrdzBXWG1MWlpLazhk?=
 =?utf-8?B?NUlNWGxiOEhIM1JJYXJUSytSYnRxRzhMVG9Xc2ZQZzB3TklHd2V0V2lrNUNm?=
 =?utf-8?B?a3pudE1rd0d1ZE03TWd0UEpCbUxBdHUwTlo5b2JwUjJ2TlAwZ2ZreE1DZlRt?=
 =?utf-8?B?T0tFQkU5elFVVEE5SnF3SWxDTzF2MENyeUYyMHc2WEx3cGkvUzR4bGVEUFBj?=
 =?utf-8?B?M1JCTDAzbzdhRTk0U0t6aisxYWxjcFhDOGtZYnVLT1NlV2VBUnJpeWJxTTFn?=
 =?utf-8?B?VzE5VWprcWp4cVN6Y3VpdnZ0aTBpdGg0VFhZYXc2aEpWd3U3L2srYWFIODFk?=
 =?utf-8?B?ZHBBNzdDN0lBMktoWVZhSmcxa2xDY2tSaDlJbVQ4TjBVQ0pETE1kK011WTZj?=
 =?utf-8?B?MDF5S1B2Z3BpSkkwbTBiMHlld0RPQXltdjluM21Bank3L1VYejZBQWRTZHJ2?=
 =?utf-8?B?Q2sxRWZVZ0dNVjk0QTJpS2pEc05FbDN1bW9pZGVydndrUEZzcTBhVlkxNklZ?=
 =?utf-8?B?TFFPWnphQVZ1YnIzRVIzN2E0YlpzdXdlUC9XdXljdkVMaXI4UmZ1aFpiSFZz?=
 =?utf-8?B?SnVacWZpMk5EWkxVK040bWM5Ylcza2EzTXJIQ1M5VzlwcGVqc0hjd0JlL1Qy?=
 =?utf-8?B?bGxsenoxYXN5dEh0Y0xlY3YxTHY4MDdwbDRyOUJRTStybk8vV0dLY1hvZXNE?=
 =?utf-8?B?K0VKR205OHNDZ2NBNkpLMm5rZHlNckpuWDJsOGRoQ0ZnWXdVTmFDdUFoZG5W?=
 =?utf-8?Q?qWBf1Nzf76mesASjkKr1Z0+02?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dca227b7-ff4c-401a-21f2-08da6fb22371
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 09:26:51.9105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H5DKgDd7E9WV27PV859Uk5LJcg1O2oqU+B8nTFTarWpq6IXEsw2jXQnJdUZ1c4qkh2KIySLLRcBVYT5eVxK63g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6223
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/2022 8:02 PM, Chao Peng wrote:
> On Mon, Jul 25, 2022 at 07:16:24PM +0530, Nikunj A. Dadhania wrote:
>> On 7/20/2022 8:29 PM, Chao Peng wrote:
>>> On Thu, Jul 14, 2022 at 01:03:46AM +0000, Sean Christopherson wrote:
>>> ...
>>>>
>>>> Option D). track shared regions in an Xarray, update kvm_arch_memory_slot.lpage_info
>>>> on insertion/removal to (dis)allow hugepages as needed.
>>>>
>>>>   + efficient on KVM page fault (no new lookups)
>>>>   + zero memory overhead (assuming KVM has to eat the cost of the Xarray anyways)
>>>>   + straightforward to implement
>>>>   + can (and should) be merged as part of the UPM series
>>>>
>>>> I believe xa_for_each_range() can be used to see if a given 2mb/1gb range is
>>>> completely covered (fully shared) or not covered at all (fully private), but I'm
>>>> not 100% certain that xa_for_each_range() works the way I think it does.
>>>
>>> Hi Sean,
>>>
>>> Below is the implementation to support 2M as you mentioned as option D.
>>> It's based on UPM v7 xarray code: https://lkml.org/lkml/2022/7/6/259
>>>
>>> Everything sounds good, the only trick bit is inc/dec disallow_lpage. If
>>> we still treat it as a count, it will be a challenge to make the inc/dec
>>> balanced. So in this patch I stole a bit for the purpose, looks ugly.
>>>
>>> Any feedback is welcome.
>>>
>>> Thanks,
>>> Chao
>>>
>>> -----------------------------------------------------------------------
>>> From: Chao Peng <chao.p.peng@linux.intel.com>
>>> Date: Wed, 20 Jul 2022 11:37:18 +0800
>>> Subject: [PATCH] KVM: Add large page support for private memory
>>>
>>> Update lpage_info when handling KVM_MEMORY_ENCRYPT_{UN,}REG_REGION.
>>>
>>> Reserve a bit in disallow_lpage to indicate a large page has
>>> private/share pages mixed.
>>>
>>> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
>>> ---
>>
>>
>>> +static void update_mem_lpage_info(struct kvm *kvm,
>>> +				  struct kvm_memory_slot *slot,
>>> +				  unsigned int attr,
>>> +				  gfn_t start, gfn_t end)
>>> +{
>>> +	unsigned long lpage_start, lpage_end;
>>> +	unsigned long gfn, pages, mask;
>>> +	int level;
>>> +
>>> +	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
>>> +		pages = KVM_PAGES_PER_HPAGE(level);
>>> +		mask = ~(pages - 1);
>>> +		lpage_start = start & mask;
>>> +		lpage_end = end & mask;
>>> +
>>> +		/*
>>> +		 * We only need to scan the head and tail page, for middle pages
>>> +		 * we know they are not mixed.
>>> +		 */
>>> +		update_mixed(lpage_info_slot(lpage_start, slot, level),
>>> +			     mem_attr_is_mixed(kvm, attr, lpage_start,
>>> +							  lpage_start + pages));
>>> +
>>> +		if (lpage_start == lpage_end)
>>> +			return;
>>> +
>>> +		for (gfn = lpage_start + pages; gfn < lpage_end; gfn += pages) {
>>> +			update_mixed(lpage_info_slot(gfn, slot, level), false);
>>> +		}
>>
>> Boundary check missing here for the case when gfn reaches lpage_end.
>>
>> 		if (gfn == lpage_end)
>> 			return;
> 
> In this case, it's actually the tail page that I want to scan for with
> below code.

What if you do not have the tail lpage?

For example: memslot base_gfn = 0x1000 and npages is 0x800, so memslot range
is 0x1000 to 0x17ff.

Assume a case when this function is called with start = 1000 and end = 1800.
For 2M, page mask is 0x1ff. start and end both are 2M aligned.

First update_mixed takes care of 0x1000-0x1200
Loop update_mixed: goes over from 0x1200 - 0x1800, there are no pages left
for last update_mixed to process.

> 
> It's also possible I misunderstand something here.
> 
> Chao
>>
>>> +
>>> +		update_mixed(lpage_info_slot(lpage_end, slot, level),
>>> +			     mem_attr_is_mixed(kvm, attr, lpage_end,
>>> +							  lpage_end + pages));

lpage_info_slot some times causes a crash, as I noticed that
lpage_info_slot() returns out-of-bound index.

Regards
Nikunj


