Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374D34A46BA
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 13:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376884AbiAaMSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 07:18:48 -0500
Received: from mail-bn1nam07on2084.outbound.protection.outlook.com ([40.107.212.84]:63651
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1376614AbiAaMSe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 07:18:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGPouC5zts+RDsqGecyan2GbPSPB+R08uxW9DnyLWtyouYkhi0NhUqWsv4kR3kZKPRJmpQRgxcj4YFKzBqcNj77dhWO17FZeUUqBMMV03ljrqis31VMwC8IcixmVcuPmY3J+qccLD+sMO7+ucaAp2tUniecHInNRq/ytdG38svIEvb2/7Y3zBbUWLCPNS6EtBNFawO/TFLGpbo3TZ+BAbzn8KEBwdr5aMedeKGDRyRVgJswGfUSbRNWXCyXTwyE1VnZE09uWqGUF54YMHE4qvFR48X5+MqqbsFFe/nkzE5vhEw0S2Dzq6bemfqRdivJ3qgBzP+cJlvkfnzY9auX9MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qkAUGuEvvwRmdTz+IOaflOY5kShX7BwVUt23TQ6jiGw=;
 b=FucY5Q/aBfPr1twih9RNIP4wLeTmoMBpbAN6nNwqByM55tP3xpD6wpnmzEF6j+85jbmvf1VkVgP1G+6UHrr8EsnnWgyY2W5zpCLro8szgbjgtAXZwFXwXMF47QU2igUHPcclZ7v6c2wUhIDy9RATfkXit0Z1DCw8VsCB9iAmJ+MpxLBWtEa3odEu0tP9KhY9rSGXMTusK55ZmV7m0XlbmLjIZAQxxPuQWlHd+GAIK1paFbI9in9PCqlfuoGC43OoEGRZJk92Il2JLIMz1uR10XCq53VqKRgMKd+yhADzXjPyQTpbx7K9nxTBa4axsLOGccJFdGAa30swJ8cR8IHSaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qkAUGuEvvwRmdTz+IOaflOY5kShX7BwVUt23TQ6jiGw=;
 b=yXAZaj9vpV8KLqQs7vh90J+RXWik7J+MLTYFh+0J8wV+0DtMemjUjFazkM2Yx2MQAg1c3d3gDu21wXQvX8idgd61aWDRTpv8gqnRt0GYtpjVIcfPS3tw1a9OxqPXfJlMixMcvhyh1dGJRoUB+pz7cAcFjfG4/ZkFcIj05r/1v2U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2477.namprd12.prod.outlook.com (2603:10b6:802:28::21)
 by SJ0PR12MB5422.namprd12.prod.outlook.com (2603:10b6:a03:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Mon, 31 Jan
 2022 12:18:31 +0000
Received: from SN1PR12MB2477.namprd12.prod.outlook.com
 ([fe80::85db:a822:eb43:fc9c]) by SN1PR12MB2477.namprd12.prod.outlook.com
 ([fe80::85db:a822:eb43:fc9c%4]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 12:18:29 +0000
Message-ID: <50bdcaf5-274d-91e0-2126-1cbc8e61b9f8@amd.com>
Date:   Mon, 31 Jan 2022 17:48:11 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bharata B Rao <bharata@amd.com>
Subject: Re: [RFC PATCH 3/6] KVM: SVM: Implement demand page pinning
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-4-nikunj@amd.com>
 <99248ffb-2c7c-ba25-5d56-2c577e58da4c@redhat.com>
 <c7918558-4eb3-0592-f3e1-9a1c4f36f7c0@amd.com>
 <ef8dcee4-8ce7-cb91-6938-feb39f0bdaba@redhat.com>
 <bd8e94d6-e2fd-16a9-273e-c2563af235df@amd.com>
 <99e39466-513b-6db9-6b3a-f40e68997cec@redhat.com>
 <6597e635-b488-3a4c-ce84-8c17d225747e@redhat.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <6597e635-b488-3a4c-ce84-8c17d225747e@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0110.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00::26)
 To SN1PR12MB2477.namprd12.prod.outlook.com (2603:10b6:802:28::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b38d836-68d0-4442-09bb-08d9e4b3ca33
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5422:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5422C7449ACE4D1FB7954F42E2259@SJ0PR12MB5422.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AEK8mlp9D02XwT+esOYPlQ22zpiZfVIDxH8bxE+9OrL4Sv3/bTCMcSONubH6C8ydZzt7YUKvpWgIARutiLjkcdYnWAjf6FQmXv9zTygoo9NAl3uIeMkkP0GRQotUppXRlxW1k4KSzGQEGBm0eeoUj3ikpeHLwjT99bj31glal2pb7FrMRd2LXtQPE3u+PFhhVn+CIXat9M7kYOvpC5GdmM3Ab7z/Ue+uNAXWSBnNahbi/z88heqAtNaiaYtFAvplfmSkPB+IsyNuhh5CvGctTxJc032kNluiCWS3AIYQatTH2JWmzqeZvuoq8zVQj93C4/Y5OTJymPEpHmE1FJyWQJ9//wIj3I5zmbftejkOPo9dw8NC02h71w3wzImX3fm6X2mFIiytKFEj4ElymIX549L0jPuuuIPkmJOKUMR5DlL3P2cRg5Icuws+AFqincnd/Ia2RZE8w4//IFkj6+JmhdrRM+xV9kOJwQBLgbUpcvNzKjJO9z6vWC6/zBAcpEbsMUM3qkAUpxJ++ooiEON/+RZM1H9tjRLtGK/j2wXzjOQRhlTygIVe8pCKAOsWUtudtpS4hF2mqkKMvuc9KLZOGkWd31/HFG+H+fJME1Hu8dWncvGFI0qdiW+b5S4cj39c+fpi24KD75fwWhvQs6u6/eTLq6VeOTVg/BQM/98OwZ55LWS9gFHC3pLI7Rn1ZNepsXCRQ6LX7qjEN8aRTl/nxJeRRXBHhBD3FR9JwQqLhZw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2477.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(30864003)(31686004)(6512007)(5660300002)(7416002)(2616005)(83380400001)(53546011)(6506007)(2906002)(26005)(6666004)(186003)(66946007)(66476007)(66556008)(8936002)(8676002)(4326008)(31696002)(6486002)(508600001)(54906003)(110136005)(316002)(38100700002)(43740500002)(45980500001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czU3ekUxYVFqSGtucU5KUmFlUllUNjBVSXRJT1ZaTC94R0VyU0Rnck82Q1BH?=
 =?utf-8?B?b2lxdFFYYTNDakVOM2FnK2ZBL3ZSZ0xyNTNRL00xcnRIMm1rTXM3ei9wM0pE?=
 =?utf-8?B?ajJ5Tjl1ZWJvTi8wTllMODBzWW5oZG03SUxmNHVKTXpVVitKSmg4Z1pMRmFY?=
 =?utf-8?B?RUlJRWg2Q1hKcThHY0RtU0ZtMUlDTTNhK2Zxd09PazNsa0xBaHVYTk1sUHBq?=
 =?utf-8?B?UFdDalQwVWQvQXhSQ0UvRTBhQTdwYVdUWjJaRXhINmdCY0oyRnVqdmkvbUZ2?=
 =?utf-8?B?NURtKzQwOWszM014Z2dXNk54aGtTUER4QUNXTThGLzNlOHIzZ28wWkcyYkVD?=
 =?utf-8?B?RTdmNkFleHg2Z3A5SVdyMUhWc3dtbzNJcE5VODdqajlWdStiYmdBSDRlY1NS?=
 =?utf-8?B?YU9TbllvaUtJVU9YZ0pqOUlkb0wzNEVFSGl5OUxmU3g5RGFzVnZsOGdKTGJy?=
 =?utf-8?B?eEdTVmtKS0FmY3pVN1lZbFJRUWZPNm1zajhlTHlBYy81OFBpZE5kaUIvS0t6?=
 =?utf-8?B?Z3Y5bDVGYnlmam1wY2d4OGY4RnpFSzEzcTRkV1pjS1BSWVZ3djVuc0t4Qkla?=
 =?utf-8?B?YVNNYUdsbGJPN0NoTG1ML1hlYk9RWXc3cGZUeFlEZVZoN2RCOUpPMUorRVNQ?=
 =?utf-8?B?bFBTM3VqcThTREFZRW54ckRvd253WHVxZUlPcUhmOGxjQmV6SzVjeU9DMWFD?=
 =?utf-8?B?R01aVTUzblM3OXBSYVpDYW1JQUR2NnlOSTVZK3l6alVUa2p1Z2RHbFVpRlFL?=
 =?utf-8?B?SFZmcjc0cDZCbkQzMEoxYlFkYkl3QU1kSnFjWlozTTR3OE5VRmVzRFBnaG9D?=
 =?utf-8?B?NkRmMlZIcG1ENzkwekZ2d3pNUmk1bWxLN2hlZFNHcU05WVJvV2dEc2E2SFYw?=
 =?utf-8?B?V1hDM3l1YUxvNURkU0hWZmdoLzlmR0dkeUNFZ2RjSHQ4enZKUSsxaXdPUzlF?=
 =?utf-8?B?N1EyMCtlSHBHcDRHY05pS1VJeC9mclFHNWNlMWsvUzM3WHVpMTJPVUNhVGpW?=
 =?utf-8?B?RzlBSUphN254VXZ2blhnNUtPb2VjWU13NUxCWFh4VTljbjBubU1oWFVTZUEx?=
 =?utf-8?B?bFB4L1VmMGtBVUtHTWV3MTYvWUlHY2RXUXd5K1l1OVVNcU92ekt5dTFOYlBW?=
 =?utf-8?B?WWNvV0JuYmp3eGJMUEtDUHRaYU5XdExwbC9iU3ZMdExPTnZUNjZCUFZOS2NU?=
 =?utf-8?B?Z0kvWWVtTnowYm9qVFdGRVJMWkJpM216dG1Qc0tIZTVWUUQwWE02L1R0MzB2?=
 =?utf-8?B?Y3RHSTVNUU12ZXErc2svVzhyalNkRGdHNzhnT2JUUmZ3dGhLSEsxbVprZjlV?=
 =?utf-8?B?NVE2b2VMa2FQVUNIakNZWU45a0NnbGxQM1dVaTZKR0d1UlVoWkdnY1BscDZy?=
 =?utf-8?B?Y0VjMDRmVkNFalYwK09IQitKZ0ptM3FOYk56K1VUcWpCaWZFL2dOOGJtSDFH?=
 =?utf-8?B?R3krcXk3VVpaclM0SXVod1VCOTNydG9CeUtwS29VdkMyQWtHNE41ejBiTEY2?=
 =?utf-8?B?UmJ0ZGdSazFDTnlZYllkRVFWbVM1d3IzbWJ1TDAvMDJrenZKcU9kcTIrVVhk?=
 =?utf-8?B?L0grL3owYnVTc1ExMDA0VisyTHhMSmpJZjBBK0U5L1ZvcmpJSWRGL05hYjVZ?=
 =?utf-8?B?b2gvdXg1UGhVL0VBb2hSdG82dVc3WEdjUTh1T05qelZ3VDR5bXVYK25WQXgr?=
 =?utf-8?B?bGh5K1dWajM2WWdzZlY3cmNkaG5XTFpmOEVvUzQvYUZaT3IzbHRSK1NIanMz?=
 =?utf-8?B?eDJtd0VsNUJXbFNMWUFubDErYTg1QXg4ckhFWVFhcTF6d3NYc2VpMlZpa052?=
 =?utf-8?B?SHdFUys2b1k1ZXdoczVmV3l4ZHZDTjAzb2s0YXg3ZVRDVHVHc2x5UkJhOTM1?=
 =?utf-8?B?Y0R5WktCUXhsVjAzZlhPUUxmUkZ2bVhFM1Y0L1pGbDQ5dDNuS29aQ25kdFhj?=
 =?utf-8?B?Ylc4UWUzcXNFOUNrUUNaTmxLb1lmQXZSUWtaSXFoZU1sRXF1WFp0bFBpeUww?=
 =?utf-8?B?R3krYnpOa1FLbktSd3BxZXBrQ3h3Q3dKYU90SVF4SmN6d2hWQS9EbThyRk1w?=
 =?utf-8?B?TXRRV0Y5STRqb0x6TlFrZTlPS2JRa05hQ1NDa2t2RkMycWZzd2V0WlV1Wjdh?=
 =?utf-8?B?THoyNjUxTU9xbitYa0NBVFRzcEVUanJ6YlhmN2VCRmhiWCtxWDVpd2tJWlZH?=
 =?utf-8?Q?ANjoil98kvu+EvnMbc8sly0=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b38d836-68d0-4442-09bb-08d9e4b3ca33
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2477.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 12:18:29.7100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eE/3UcQdGpIN3hD0zbKz0NQaL33C6oRX8bfaVNTPgqfMwYbgUq/nbhNbZqnpwFlGkKVP9OKLss1G+VDeipQL5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5422
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/31/2022 5:26 PM, David Hildenbrand wrote:
> On 28.01.22 12:08, David Hildenbrand wrote:
>> On 28.01.22 12:04, Nikunj A. Dadhania wrote:
>>> On 1/28/2022 1:57 PM, David Hildenbrand wrote:
>>>> On 28.01.22 07:57, Nikunj A. Dadhania wrote:
>>>>> On 1/26/2022 4:16 PM, David Hildenbrand wrote:
>>>>>> On 18.01.22 12:06, Nikunj A Dadhania wrote:
>>>>>>> Use the memslot metadata to store the pinned data along with the pfns.
>>>>>>> This improves the SEV guest startup time from O(n) to a constant by
>>>>>>> deferring guest page pinning until the pages are used to satisfy nested
>>>>>>> page faults. The page reference will be dropped in the memslot free
>>>>>>> path.
>>>>>>>
>>>>>>> Remove the enc_region structure definition and the code which did
>>>>>>> upfront pinning, as they are no longer needed in view of the demand
>>>>>>> pinning support.
>>>>>>>
>>>>>>> Leave svm_register_enc_region() and svm_unregister_enc_region() as stubs
>>>>>>> since qemu is dependent on this API.
>>>>>>>
>>>>>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>>>>>> ---
>>>>>>>  arch/x86/kvm/svm/sev.c | 208 ++++++++++++++++-------------------------
>>>>>>>  arch/x86/kvm/svm/svm.c |   1 +
>>>>>>>  arch/x86/kvm/svm/svm.h |   3 +-
>>>>>>>  3 files changed, 81 insertions(+), 131 deletions(-)
>>>>>>>
>>>>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>>>>> index d972ab4956d4..a962bed97a0b 100644
>>>>>>> --- a/arch/x86/kvm/svm/sev.c
>>>>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>>>>> @@ -66,14 +66,6 @@ static unsigned int nr_asids;
>>>>>>>  static unsigned long *sev_asid_bitmap;
>>>>>>>  static unsigned long *sev_reclaim_asid_bitmap;
>>>>>>>  
>>>>>>> -struct enc_region {
>>>>>>> -	struct list_head list;
>>>>>>> -	unsigned long npages;
>>>>>>> -	struct page **pages;
>>>>>>> -	unsigned long uaddr;
>>>>>>> -	unsigned long size;
>>>>>>> -};
>>>>>>> -
>>>>>>>  /* Called with the sev_bitmap_lock held, or on shutdown  */
>>>>>>>  static int sev_flush_asids(int min_asid, int max_asid)
>>>>>>>  {
>>>>>>> @@ -257,8 +249,6 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>>>>>  	if (ret)
>>>>>>>  		goto e_free;
>>>>>>>  
>>>>>>> -	INIT_LIST_HEAD(&sev->regions_list);
>>>>>>> -
>>>>>>>  	return 0;
>>>>>>>  
>>>>>>>  e_free:
>>>>>>> @@ -1637,8 +1627,6 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>>>>>>>  	src->handle = 0;
>>>>>>>  	src->pages_locked = 0;
>>>>>>>  	src->enc_context_owner = NULL;
>>>>>>> -
>>>>>>> -	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
>>>>>>>  }
>>>>>>>  
>>>>>>>  static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
>>>>>>> @@ -1861,115 +1849,13 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>>>>>>  int svm_register_enc_region(struct kvm *kvm,
>>>>>>>  			    struct kvm_enc_region *range)
>>>>>>>  {
>>>>>>> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>> -	struct enc_region *region;
>>>>>>> -	int ret = 0;
>>>>>>> -
>>>>>>> -	if (!sev_guest(kvm))
>>>>>>> -		return -ENOTTY;
>>>>>>> -
>>>>>>> -	/* If kvm is mirroring encryption context it isn't responsible for it */
>>>>>>> -	if (is_mirroring_enc_context(kvm))
>>>>>>> -		return -EINVAL;
>>>>>>> -
>>>>>>> -	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
>>>>>>> -		return -EINVAL;
>>>>>>> -
>>>>>>> -	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
>>>>>>> -	if (!region)
>>>>>>> -		return -ENOMEM;
>>>>>>> -
>>>>>>> -	mutex_lock(&kvm->lock);
>>>>>>> -	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
>>>>>>> -	if (IS_ERR(region->pages)) {
>>>>>>> -		ret = PTR_ERR(region->pages);
>>>>>>> -		mutex_unlock(&kvm->lock);
>>>>>>> -		goto e_free;
>>>>>>> -	}
>>>>>>> -
>>>>>>> -	region->uaddr = range->addr;
>>>>>>> -	region->size = range->size;
>>>>>>> -
>>>>>>> -	list_add_tail(&region->list, &sev->regions_list);
>>>>>>> -	mutex_unlock(&kvm->lock);
>>>>>>> -
>>>>>>> -	/*
>>>>>>> -	 * The guest may change the memory encryption attribute from C=0 -> C=1
>>>>>>> -	 * or vice versa for this memory range. Lets make sure caches are
>>>>>>> -	 * flushed to ensure that guest data gets written into memory with
>>>>>>> -	 * correct C-bit.
>>>>>>> -	 */
>>>>>>> -	sev_clflush_pages(region->pages, region->npages);
>>>>>>> -
>>>>>>> -	return ret;
>>>>>>> -
>>>>>>> -e_free:
>>>>>>> -	kfree(region);
>>>>>>> -	return ret;
>>>>>>> -}
>>>>>>> -
>>>>>>> -static struct enc_region *
>>>>>>> -find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
>>>>>>> -{
>>>>>>> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>> -	struct list_head *head = &sev->regions_list;
>>>>>>> -	struct enc_region *i;
>>>>>>> -
>>>>>>> -	list_for_each_entry(i, head, list) {
>>>>>>> -		if (i->uaddr == range->addr &&
>>>>>>> -		    i->size == range->size)
>>>>>>> -			return i;
>>>>>>> -	}
>>>>>>> -
>>>>>>> -	return NULL;
>>>>>>> -}
>>>>>>> -
>>>>>>> -static void __unregister_enc_region_locked(struct kvm *kvm,
>>>>>>> -					   struct enc_region *region)
>>>>>>> -{
>>>>>>> -	sev_unpin_memory(kvm, region->pages, region->npages);
>>>>>>> -	list_del(&region->list);
>>>>>>> -	kfree(region);
>>>>>>> +	return 0;
>>>>>>>  }
>>>>>>>  
>>>>>>>  int svm_unregister_enc_region(struct kvm *kvm,
>>>>>>>  			      struct kvm_enc_region *range)
>>>>>>>  {
>>>>>>> -	struct enc_region *region;
>>>>>>> -	int ret;
>>>>>>> -
>>>>>>> -	/* If kvm is mirroring encryption context it isn't responsible for it */
>>>>>>> -	if (is_mirroring_enc_context(kvm))
>>>>>>> -		return -EINVAL;
>>>>>>> -
>>>>>>> -	mutex_lock(&kvm->lock);
>>>>>>> -
>>>>>>> -	if (!sev_guest(kvm)) {
>>>>>>> -		ret = -ENOTTY;
>>>>>>> -		goto failed;
>>>>>>> -	}
>>>>>>> -
>>>>>>> -	region = find_enc_region(kvm, range);
>>>>>>> -	if (!region) {
>>>>>>> -		ret = -EINVAL;
>>>>>>> -		goto failed;
>>>>>>> -	}
>>>>>>> -
>>>>>>> -	/*
>>>>>>> -	 * Ensure that all guest tagged cache entries are flushed before
>>>>>>> -	 * releasing the pages back to the system for use. CLFLUSH will
>>>>>>> -	 * not do this, so issue a WBINVD.
>>>>>>> -	 */
>>>>>>> -	wbinvd_on_all_cpus();
>>>>>>> -
>>>>>>> -	__unregister_enc_region_locked(kvm, region);
>>>>>>> -
>>>>>>> -	mutex_unlock(&kvm->lock);
>>>>>>>  	return 0;
>>>>>>> -
>>>>>>> -failed:
>>>>>>> -	mutex_unlock(&kvm->lock);
>>>>>>> -	return ret;
>>>>>>>  }
>>>>>>>  
>>>>>>>  int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>>>>>>> @@ -2018,7 +1904,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>>>>>>>  	mirror_sev->fd = source_sev->fd;
>>>>>>>  	mirror_sev->es_active = source_sev->es_active;
>>>>>>>  	mirror_sev->handle = source_sev->handle;
>>>>>>> -	INIT_LIST_HEAD(&mirror_sev->regions_list);
>>>>>>>  	ret = 0;
>>>>>>>  
>>>>>>>  	/*
>>>>>>> @@ -2038,8 +1923,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>>>>>>>  void sev_vm_destroy(struct kvm *kvm)
>>>>>>>  {
>>>>>>>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>> -	struct list_head *head = &sev->regions_list;
>>>>>>> -	struct list_head *pos, *q;
>>>>>>>  
>>>>>>>  	WARN_ON(sev->num_mirrored_vms);
>>>>>>>  
>>>>>>> @@ -2066,18 +1949,6 @@ void sev_vm_destroy(struct kvm *kvm)
>>>>>>>  	 */
>>>>>>>  	wbinvd_on_all_cpus();
>>>>>>>  
>>>>>>> -	/*
>>>>>>> -	 * if userspace was terminated before unregistering the memory regions
>>>>>>> -	 * then lets unpin all the registered memory.
>>>>>>> -	 */
>>>>>>> -	if (!list_empty(head)) {
>>>>>>> -		list_for_each_safe(pos, q, head) {
>>>>>>> -			__unregister_enc_region_locked(kvm,
>>>>>>> -				list_entry(pos, struct enc_region, list));
>>>>>>> -			cond_resched();
>>>>>>> -		}
>>>>>>> -	}
>>>>>>> -
>>>>>>>  	sev_unbind_asid(kvm, sev->handle);
>>>>>>>  	sev_asid_free(sev);
>>>>>>>  }
>>>>>>> @@ -2946,13 +2817,90 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>>>>>>>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
>>>>>>>  }
>>>>>>>  
>>>>>>> +void sev_pin_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>>>>>>> +		  kvm_pfn_t pfn)
>>>>>>> +{
>>>>>>> +	struct kvm_arch_memory_slot *aslot;
>>>>>>> +	struct kvm_memory_slot *slot;
>>>>>>> +	gfn_t rel_gfn, pin_pfn;
>>>>>>> +	unsigned long npages;
>>>>>>> +	kvm_pfn_t old_pfn;
>>>>>>> +	int i;
>>>>>>> +
>>>>>>> +	if (!sev_guest(kvm))
>>>>>>> +		return;
>>>>>>> +
>>>>>>> +	if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn)))
>>>>>>> +		return;
>>>>>>> +
>>>>>>> +	/* Tested till 1GB pages */
>>>>>>> +	if (KVM_BUG_ON(level > PG_LEVEL_1G, kvm))
>>>>>>> +		return;
>>>>>>> +
>>>>>>> +	slot = gfn_to_memslot(kvm, gfn);
>>>>>>> +	if (!slot || !slot->arch.pfns)
>>>>>>> +		return;
>>>>>>> +
>>>>>>> +	/*
>>>>>>> +	 * Use relative gfn index within the memslot for the bitmap as well as
>>>>>>> +	 * the pfns array
>>>>>>> +	 */
>>>>>>> +	rel_gfn = gfn - slot->base_gfn;
>>>>>>> +	aslot = &slot->arch;
>>>>>>> +	pin_pfn = pfn;
>>>>>>> +	npages = KVM_PAGES_PER_HPAGE(level);
>>>>>>> +
>>>>>>> +	/* Pin the page, KVM doesn't yet support page migration. */
>>>>>>> +	for (i = 0; i < npages; i++, rel_gfn++, pin_pfn++) {
>>>>>>> +		if (test_bit(rel_gfn, aslot->pinned_bitmap)) {
>>>>>>> +			old_pfn = aslot->pfns[rel_gfn];
>>>>>>> +			if (old_pfn == pin_pfn)
>>>>>>> +				continue;
>>>>>>> +
>>>>>>> +			put_page(pfn_to_page(old_pfn));
>>>>>>> +		}
>>>>>>> +
>>>>>>> +		set_bit(rel_gfn, aslot->pinned_bitmap);
>>>>>>> +		aslot->pfns[rel_gfn] = pin_pfn;
>>>>>>> +		get_page(pfn_to_page(pin_pfn));
>>>>>>
>>>>>>
>>>>>> I assume this is to replace KVM_MEMORY_ENCRYPT_REG_REGION, which ends up
>>>>>> calling svm_register_enc_region()->sev_pin_memory(), correct?
>>>>>
>>>>> Yes, that is correct.
>>>>>>
>>>>>> sev_pin_memory() correctly checks the RLIMIT_MEMLOCK and uses
>>>>>> pin_user_pages_fast().
>>>>>>
>>>>>> I have to strongly assume that sev_pin_memory() is *wrong* as is because
>>>>>> it's supposed to supply FOLL_LONGTERM -- after all we're pinning these
>>>>>> pages possibly forever.
>>>>>>
>>>>>>
>>>>>> I might be wrong but
>>>>>>
>>>>>> 1. You are missing the RLIMIT_MEMLOCK check
>>>>>
>>>>> Yes, I will add this check during the enc_region registration.
>>>>>
>>>>>> 2. get_page() is the wong way of long-term pinning a page. You would
>>>>>> have to mimic what pin_user_pages_fast(FOLL_LONGTERM) does to eventually
>>>>>> get it right (e.g., migrate the page off of MIGRATE_CMA or ZONE_MOVABLE).
>>>>>
>>>>> Let me go through this and I will come back. Thanks for pointing this out.
>>>>
>>>> I asusme the "issue" is that KVM uses mmu notifier and does a simple
>>>> get_user_pages() to obtain the references, to drop the reference when
>>>> the entry is invalidated via a mmu notifier call. So once you intent to
>>>> long-term pin, it's already to late.
>>>>
>>>> If you could teach KVM to do a long-term pin when stumbling over these
>>>> special encrypted memory regions (requires a proper matching
>>>> unpin_user_pages() call from KVM), then you could "take over" that pin
>>>> by get_page(), and let KVM do the ordinary put_page(), while you would
>>>> do the unpin_user_pages().
>>>>
>>>
>>> The fault path looks like this in KVM x86 mmu code:
>>>
>>> direct_page_fault()
>>> -> kvm_faultin_pfn()
>>>    -> __gfn_to_pfn_memslot()
>>>       -> hva_to_pfn()
>>>          -> hva_to_pfn_{slow,fast}()
>>>             -> get_user_pages_*()      <<<<==== This is where the
>>>                                                 reference is taken
>>>
>>> Next step is to create the mappings which is done in below functions:
>>>
>>> -> kvm_tdp_mmu_map() / __direct_map()
>>>
>>>    -> Within this function (patch 1/6), I call sev_pin_spte to take an extra 
>>>       reference to pin it using get_page. 
>>>
>>>       Is it possible to use pin_user_pages(FOLL_LONGTERM) here? Wouldn't that 
>>>       be equivalent to "take over" solution that you are suggesting?
>>>
>>
>> The issue is that pin_user_pages(FOLL_LONGTERM) might have to migrate
>> the page, which will fail if there is already an additional reference
>> from get_user_pages_*().
>>
> 
> Minor addition: hva_to_pfn_{slow,fast}() *don't* take a reference,

hva_to_pfn_fast() does take a reference, not able to find in _slow() though.

->get_user_page_fast_only()
  -> get_user_pages_fast_only()
     ...
     gup_flags |= FOLL_GET | FOLL_FAST_ONLY;
     ...

> because we neither supply FOLL_GET nor FOLL_PIN. GUP users that rely on
> memory notifiers don't require refernces.
> 
> I don't know what the implications would be if you FOLL_PIN |
> FOLL_LONGTERM after already having a reference via
> hva_to_pfn_{slow,fast}() in your hand in the callpath. Migration code
> would effectively want to unmap the old page and call mmu notifiers to
> properly invalidate the KVM MMU ...
> 
> In an ideal word, you'd really do a FOLL_PIN | FOLL_LONGTERM right away,
> not doing the  get_user_pages_*()  first.
> 

I am thinking on the same line:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eff3ef64722b..fd7c878ab03d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2379,9 +2379,10 @@ static inline int check_user_page_hwpoison(unsigned long addr)
  * only part that runs if we can in atomic context.
  */
 static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
-                           bool *writable, kvm_pfn_t *pfn)
+                           bool *writable, kvm_pfn_t *pfn, bool pin_longterm)
 {
        struct page *page[1];
+       bool ret;

        /*
         * Fast pin a writable pfn only if it is a write fault request
@@ -2391,7 +2392,12 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
        if (!(write_fault || writable))
                return false;

-       if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
+       if (!pin_longterm)
+               ret = get_user_page_fast_only(addr, FOLL_WRITE, page);
+       else
+               ret = pin_user_pages_fast(addr, 1, FOLL_WRITE | FOLL_LONGTERM, page);
+
+       if (ret) {
                *pfn = page_to_pfn(page[0]);


And the pin_longterm could be determined using a memslot flags:

#define KVM_MEMSLOT_LONGTERM    (1UL << 17)

Regards
Nikunj

