Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4705E49F7CB
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 12:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347980AbiA1LE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 06:04:57 -0500
Received: from mail-dm6nam08on2076.outbound.protection.outlook.com ([40.107.102.76]:21680
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244072AbiA1LE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 06:04:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=USMB3+qYPJxaEosbGXBkszdNjx4wToYaF2vK01bWk/XfBAQmSlZlNEld9ULoNi3T5+4dWMN0uQxT6e7QRCAH3EOq++Dng4XTm5XNLpValCqydPZn/Ow9wLmsJuI02DsaXRx4QlsHwCUhxU6KAa9Qb+8iFosSEyIItQhKItnVnHQVLOVS6oanJd4TG1KavW4/ry7c96MbGOlPmh1Ch9Zt8gJyTaEaThhwe+UZ5+cTtTt1R4ftyyRpGPAyfI8J5QeuYQTZ1uKdTw3hjtfyX5tRlujFOCCwkJxsQeK9LZ8DQOzy2s4Vr2nBGzY3g+KHjQ/dnrOSkX/m0N7eLh9nIAcmiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y83b7UrD99BEWKF1R4DvI5Kms/J/zy6EtAg8xvMUuds=;
 b=IgTURwkFOH3fBvNIwr8JcKpZXQp6OZ+lyc4dCqWLkXhwyjE7+lz31eOkn+/xKGi9kD8E15oJksNrXYxcpuoWd5PAqvYcqpj46LJ9NSCDI3pDUfeOZA1Qt3vEoAx1Fm50vNc7kEsJCZxAx1E0zSQgm6S8Lya8leZi9BbjhOooPPBSd4i2/a8a+vLxKYgNLPPOmLhCZcHl+qN356faHmJbbkO4LLrxhX5KFqyRDCK8A5tZMUYUtzhl8aJhbGEcpaL6laMBwHpXNGyTq7IuqhCUXTIffO8q6b0WjQ3Of88BLNWiGFTTdmGJW50nAmXKEcbSo9/EovLPceEChCzML+HnXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y83b7UrD99BEWKF1R4DvI5Kms/J/zy6EtAg8xvMUuds=;
 b=ICIGbYoXtV3dg87EFjyc09fM/XuywwfZHp12A3BWmg6fhu188M9MYMVuDkI9Ddo9cD7QHZQrZhhXJZPUD0VP77cQQ1azFOR4XKHjzpjoLyWabrLD18aoZQDqxrjfWggHt8ypDoU1S5Yxxtg0IaC3DDJ26f78/+Ut3Fiv7H94iAw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 BL0PR12MB2338.namprd12.prod.outlook.com (2603:10b6:207:4c::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.15; Fri, 28 Jan 2022 11:04:51 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::19bf:2e9b:64c3:b04b]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::19bf:2e9b:64c3:b04b%6]) with mapi id 15.20.4930.019; Fri, 28 Jan 2022
 11:04:51 +0000
Message-ID: <bd8e94d6-e2fd-16a9-273e-c2563af235df@amd.com>
Date:   Fri, 28 Jan 2022 16:34:34 +0530
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
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <ef8dcee4-8ce7-cb91-6938-feb39f0bdaba@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0081.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1::21) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf394abc-9bfb-48d8-fc9f-08d9e24e01a2
X-MS-TrafficTypeDiagnostic: BL0PR12MB2338:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB2338D7117A8BBE41D2F1F8F3E2229@BL0PR12MB2338.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Zx7HRn5/C405+/20et9Z62gb2hWFWpNm6cIZ8vD8oIrwwxg+MEU5ogAwA0D64C1yQF7y8xwzUWxput9porZoW8jA7cqB12acxhoxa7awxPORO6xU4EnS7OkbwdBUrTUJ0NrF1Xph9egBGgEPy6DfJaxRJpaQwPu10r8GryqkDfMoTGEAdUC3jFrIlfSZ7099h3JE8YawsMWs6yfVJ3RRUZd4RzVsq+34rl+dUBDdCiqtT22vZ6evjq30rCQe6dv0NTc6f8LGFkWotFL56xbx76Kg+ASP4oPyU5QrOlcOvXihqMiVPTKNYJm6LOZDmy29if5rx4tX/svaJe6bft9xKM7VENkWuWU4yuOZOwrpNb3JCK5+FDr3XkCCe3seLIdvU2mIR7DzanD1n4dPl756qtxIozov/D34HDSOOmIA5WuC4ojMXBJ1//sS0kDkmuWCxsBbO5rarqQjgLrgA2yQA4B9fQKQ8O/bg5FY5vN7mge1eyqyXNInllfPtk+nrNgV+RmVSLrzcJP0k6fsM2wpkYXn7ETtZhDiXQn2pRQqCIr+HLxki1hBG+FITtex7X4rDLVo4jD/OGKwBUIfSgNjqAwXdGjZ+AUyjGAV1eA6iO/0MFUTOg4iuKw+fi8alKQTDG2fIGqFpdppPcvrHe0f1suOuooBGIjbiQbyNrian3WVZAy5rFsLW53oGQewtHAuJokhOk84GET9T+cbOXX9pAkU2by+lxUibp11exrniZv7T+1LWnvY0QwAL4TDJyk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(66946007)(83380400001)(36756003)(31686004)(26005)(2616005)(2906002)(186003)(30864003)(316002)(6506007)(6512007)(6666004)(54906003)(5660300002)(110136005)(66476007)(8676002)(8936002)(508600001)(66556008)(31696002)(53546011)(4326008)(6486002)(7416002)(43740500002)(45980500001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUV1QlhYa1ZUa01EcXVObFJWcERFajliK3lVbVJSOWw5Ym90WHZVODdpaTlx?=
 =?utf-8?B?SjgzZXNaMXA4Vjl3UWhQNGwrdDVxN01kT1ZUYlk3dTc2Y2N4YUFqcWNGMzRs?=
 =?utf-8?B?MGw2M0RUZUI0WUZRbE9DcmZWVGtBaU9xdFlLTE9rd285bkZHbStIWStUY0Nn?=
 =?utf-8?B?cWU1NFVueGZlcnNQd29semZqaEZuSEhUYjI2dUVrU0sybVBKckx2MHdiL0Nx?=
 =?utf-8?B?Rk9GelUzbGtRa1FSQ043MjI5Q2kyaHBhZjlZb1BNQzhYWEFPTmRWK2NhTTcr?=
 =?utf-8?B?VHdpTzZWY3J2MndEcVlQN2QraVZ5cVlRcElKeWlZYkNHSVB6N0lZN3ZZdk1k?=
 =?utf-8?B?UU5INlRoWG9YdllBaGZUVmV3YThiSlAwRURGMGdHcFRsWG9YM3pvVkNyQlNX?=
 =?utf-8?B?MkxlM2tFY2pCWmFnZ3FCUXp2UXYvUFI2U1AwZWdwZFBMWlFqSUcwa3k3RVFy?=
 =?utf-8?B?cWFJVEU3amc0RTMxbk1mdjRLVnVBOXVpYm54MlNCR0pUTGNNc1NsUFA3ZEY0?=
 =?utf-8?B?bFZKaVRDM3RXc0VoQVk4TTB0MFdqaFQySVRUSXNjTGxweEhwSjB5aDU1UVdu?=
 =?utf-8?B?VWRXV3R4R1NxKy80bXhIalhDRGhnLy9ORWRVS0VpM2xQTS83Ry8ycnFiRU4r?=
 =?utf-8?B?RmhXYk1HOWcrYVZNQXlOSzhBdmlhSWt4eW5KZEVXY3dOVnEvenltYlh1YWly?=
 =?utf-8?B?R0tDb2pBVXNkQ1hiV2Y5NkVuTFNOV1kwQ1ZwTU4xbm02UUIyNy9ZeGZYekxx?=
 =?utf-8?B?eDdaUmFCYzNKRjVFcjFOMlQ1VkNCeHRxak5Ock9kb29LQnFUOWtZSE9rOW9T?=
 =?utf-8?B?QnBBeUQ0eFhrcW85YnRHZ1JvYmtYRGxEdDcyM2dQd3BDZnNLcnZvSVFvVXd0?=
 =?utf-8?B?cVh3ZW5scDZDNlVCeXdQcklRSGNoemt1U2hXekpMZm5KR29la2tya29qSldO?=
 =?utf-8?B?Ym5mRFA1Z2FKS3hRQ3NiM1lsOGtDVTRhK1dLanFoQlNtSjNHbkNnRHVJZGlp?=
 =?utf-8?B?eFZNeThxclg0Y3NqOVFKbmY5R2ZBZmJvNmtIQU8wWXFmbHNodUJ4SFJvamdz?=
 =?utf-8?B?SmZobklGQktvcmNQOExpVmFPUWpOWGRRb3V0TWprSDdET2pYTTQ4cDBqTEhI?=
 =?utf-8?B?ZVRwdURzRVR3VVY4N0diV1poS0dRRVFnRHdOQTZqNUE2aktRYkQxOFFFRGhv?=
 =?utf-8?B?T1N4QXNNSVJHQ2NUeGZYa21LNHV1QUJPT2tFVWU1WFY3SUhFN1F4S3ZiT1pV?=
 =?utf-8?B?Y1dMeFVWOThOTEtVa211SUFsOHFnQVl2OFNrdWh5Qm5jek9TTWVEVlJ3U0VU?=
 =?utf-8?B?MWZxSmZhd3BLUVU3citPR0JUUi9jWWcrUFViQnRiQ2VSbVk4UFduMEJQblhU?=
 =?utf-8?B?WUNucllybkFjTmcyQUhFcEQyMXIrQVIyMHgvUjZFYUhtRnU0SHNTYnNRRGtp?=
 =?utf-8?B?TGFnZlpWcFRXQXFQL1hoQ1hIV1VqaWFwbnc3bjlyVXc0b3hGUWNTWFo4L0xU?=
 =?utf-8?B?aGhEdHFoS3R1YmY5QXRGbVQrejdCajhyMlJvNkVwYjVZM05hTUE0WUlqeCtI?=
 =?utf-8?B?SkNQM1hCdTZZd0VEZXlXOWtDdlArSDFlc1o2WHpML0FPK2FNUlVVQkNzckVi?=
 =?utf-8?B?cEdvdllqeHlmOE1HZ2lWOVpUTkZET2dXSDZ6NllCM0ViZ1MxRWFEbmo0UmRx?=
 =?utf-8?B?QWFJUy8yVHJ5WDBhUVFYdXZ0elJmdUR5ZGVuNDhQWG1XaktYYkNpbzcySUpn?=
 =?utf-8?B?U1FSenFZRG5YTGxRQ0F5K0hIcVF0WnZOd0tCNCtzUzcwWjV6RTI2TjBCM0xt?=
 =?utf-8?B?QjhvUFk4RTF6Rldidm1xOC9TK2NzeTJUR1NKVUhTVllDSmM3MUxEWWovekFO?=
 =?utf-8?B?ZFNIWlZpNjQ0M0d4ZE13SjhBaWtISURJWDJEMGVlODIyRDRFbEZWaHBsYk11?=
 =?utf-8?B?MWpXaWxOTnNDS1liV212SUJQejB5ODdGeDEwRlNwQ1dQeTRUL1lscGpNNCt6?=
 =?utf-8?B?eTNOTmQxcGpMeEdKQ2VZZmhNeTZRb01LWk1hb2NDQlJydGd0RWduRHhFLzVk?=
 =?utf-8?B?cXFKVjc3Y3pteGR6ODFMTENvMUNXaHpNUjJEVGZsOFFwZjk0V2tRSjZQMFZQ?=
 =?utf-8?B?blBSTHpNUXFHbE5La2liaEZzVitIVE1CbmFvQlJrOEFDVi80RG9ob1QreTFx?=
 =?utf-8?Q?qPLHcdSNdEkJx92uYMp1TAE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf394abc-9bfb-48d8-fc9f-08d9e24e01a2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 11:04:51.6483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QTwboUNdWNEKRatuVPwqH6uaZqtQ4lItSEZ2bD1ZAdiY1rq9LyLI9dAbxk78s+HInsdDEEmBwSDwfRWIsHIIlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2338
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/28/2022 1:57 PM, David Hildenbrand wrote:
> On 28.01.22 07:57, Nikunj A. Dadhania wrote:
>> On 1/26/2022 4:16 PM, David Hildenbrand wrote:
>>> On 18.01.22 12:06, Nikunj A Dadhania wrote:
>>>> Use the memslot metadata to store the pinned data along with the pfns.
>>>> This improves the SEV guest startup time from O(n) to a constant by
>>>> deferring guest page pinning until the pages are used to satisfy nested
>>>> page faults. The page reference will be dropped in the memslot free
>>>> path.
>>>>
>>>> Remove the enc_region structure definition and the code which did
>>>> upfront pinning, as they are no longer needed in view of the demand
>>>> pinning support.
>>>>
>>>> Leave svm_register_enc_region() and svm_unregister_enc_region() as stubs
>>>> since qemu is dependent on this API.
>>>>
>>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>>> ---
>>>>  arch/x86/kvm/svm/sev.c | 208 ++++++++++++++++-------------------------
>>>>  arch/x86/kvm/svm/svm.c |   1 +
>>>>  arch/x86/kvm/svm/svm.h |   3 +-
>>>>  3 files changed, 81 insertions(+), 131 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>> index d972ab4956d4..a962bed97a0b 100644
>>>> --- a/arch/x86/kvm/svm/sev.c
>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>> @@ -66,14 +66,6 @@ static unsigned int nr_asids;
>>>>  static unsigned long *sev_asid_bitmap;
>>>>  static unsigned long *sev_reclaim_asid_bitmap;
>>>>  
>>>> -struct enc_region {
>>>> -	struct list_head list;
>>>> -	unsigned long npages;
>>>> -	struct page **pages;
>>>> -	unsigned long uaddr;
>>>> -	unsigned long size;
>>>> -};
>>>> -
>>>>  /* Called with the sev_bitmap_lock held, or on shutdown  */
>>>>  static int sev_flush_asids(int min_asid, int max_asid)
>>>>  {
>>>> @@ -257,8 +249,6 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>>  	if (ret)
>>>>  		goto e_free;
>>>>  
>>>> -	INIT_LIST_HEAD(&sev->regions_list);
>>>> -
>>>>  	return 0;
>>>>  
>>>>  e_free:
>>>> @@ -1637,8 +1627,6 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>>>>  	src->handle = 0;
>>>>  	src->pages_locked = 0;
>>>>  	src->enc_context_owner = NULL;
>>>> -
>>>> -	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
>>>>  }
>>>>  
>>>>  static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
>>>> @@ -1861,115 +1849,13 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>>>  int svm_register_enc_region(struct kvm *kvm,
>>>>  			    struct kvm_enc_region *range)
>>>>  {
>>>> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>> -	struct enc_region *region;
>>>> -	int ret = 0;
>>>> -
>>>> -	if (!sev_guest(kvm))
>>>> -		return -ENOTTY;
>>>> -
>>>> -	/* If kvm is mirroring encryption context it isn't responsible for it */
>>>> -	if (is_mirroring_enc_context(kvm))
>>>> -		return -EINVAL;
>>>> -
>>>> -	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
>>>> -		return -EINVAL;
>>>> -
>>>> -	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
>>>> -	if (!region)
>>>> -		return -ENOMEM;
>>>> -
>>>> -	mutex_lock(&kvm->lock);
>>>> -	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
>>>> -	if (IS_ERR(region->pages)) {
>>>> -		ret = PTR_ERR(region->pages);
>>>> -		mutex_unlock(&kvm->lock);
>>>> -		goto e_free;
>>>> -	}
>>>> -
>>>> -	region->uaddr = range->addr;
>>>> -	region->size = range->size;
>>>> -
>>>> -	list_add_tail(&region->list, &sev->regions_list);
>>>> -	mutex_unlock(&kvm->lock);
>>>> -
>>>> -	/*
>>>> -	 * The guest may change the memory encryption attribute from C=0 -> C=1
>>>> -	 * or vice versa for this memory range. Lets make sure caches are
>>>> -	 * flushed to ensure that guest data gets written into memory with
>>>> -	 * correct C-bit.
>>>> -	 */
>>>> -	sev_clflush_pages(region->pages, region->npages);
>>>> -
>>>> -	return ret;
>>>> -
>>>> -e_free:
>>>> -	kfree(region);
>>>> -	return ret;
>>>> -}
>>>> -
>>>> -static struct enc_region *
>>>> -find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
>>>> -{
>>>> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>> -	struct list_head *head = &sev->regions_list;
>>>> -	struct enc_region *i;
>>>> -
>>>> -	list_for_each_entry(i, head, list) {
>>>> -		if (i->uaddr == range->addr &&
>>>> -		    i->size == range->size)
>>>> -			return i;
>>>> -	}
>>>> -
>>>> -	return NULL;
>>>> -}
>>>> -
>>>> -static void __unregister_enc_region_locked(struct kvm *kvm,
>>>> -					   struct enc_region *region)
>>>> -{
>>>> -	sev_unpin_memory(kvm, region->pages, region->npages);
>>>> -	list_del(&region->list);
>>>> -	kfree(region);
>>>> +	return 0;
>>>>  }
>>>>  
>>>>  int svm_unregister_enc_region(struct kvm *kvm,
>>>>  			      struct kvm_enc_region *range)
>>>>  {
>>>> -	struct enc_region *region;
>>>> -	int ret;
>>>> -
>>>> -	/* If kvm is mirroring encryption context it isn't responsible for it */
>>>> -	if (is_mirroring_enc_context(kvm))
>>>> -		return -EINVAL;
>>>> -
>>>> -	mutex_lock(&kvm->lock);
>>>> -
>>>> -	if (!sev_guest(kvm)) {
>>>> -		ret = -ENOTTY;
>>>> -		goto failed;
>>>> -	}
>>>> -
>>>> -	region = find_enc_region(kvm, range);
>>>> -	if (!region) {
>>>> -		ret = -EINVAL;
>>>> -		goto failed;
>>>> -	}
>>>> -
>>>> -	/*
>>>> -	 * Ensure that all guest tagged cache entries are flushed before
>>>> -	 * releasing the pages back to the system for use. CLFLUSH will
>>>> -	 * not do this, so issue a WBINVD.
>>>> -	 */
>>>> -	wbinvd_on_all_cpus();
>>>> -
>>>> -	__unregister_enc_region_locked(kvm, region);
>>>> -
>>>> -	mutex_unlock(&kvm->lock);
>>>>  	return 0;
>>>> -
>>>> -failed:
>>>> -	mutex_unlock(&kvm->lock);
>>>> -	return ret;
>>>>  }
>>>>  
>>>>  int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>>>> @@ -2018,7 +1904,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>>>>  	mirror_sev->fd = source_sev->fd;
>>>>  	mirror_sev->es_active = source_sev->es_active;
>>>>  	mirror_sev->handle = source_sev->handle;
>>>> -	INIT_LIST_HEAD(&mirror_sev->regions_list);
>>>>  	ret = 0;
>>>>  
>>>>  	/*
>>>> @@ -2038,8 +1923,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>>>>  void sev_vm_destroy(struct kvm *kvm)
>>>>  {
>>>>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>> -	struct list_head *head = &sev->regions_list;
>>>> -	struct list_head *pos, *q;
>>>>  
>>>>  	WARN_ON(sev->num_mirrored_vms);
>>>>  
>>>> @@ -2066,18 +1949,6 @@ void sev_vm_destroy(struct kvm *kvm)
>>>>  	 */
>>>>  	wbinvd_on_all_cpus();
>>>>  
>>>> -	/*
>>>> -	 * if userspace was terminated before unregistering the memory regions
>>>> -	 * then lets unpin all the registered memory.
>>>> -	 */
>>>> -	if (!list_empty(head)) {
>>>> -		list_for_each_safe(pos, q, head) {
>>>> -			__unregister_enc_region_locked(kvm,
>>>> -				list_entry(pos, struct enc_region, list));
>>>> -			cond_resched();
>>>> -		}
>>>> -	}
>>>> -
>>>>  	sev_unbind_asid(kvm, sev->handle);
>>>>  	sev_asid_free(sev);
>>>>  }
>>>> @@ -2946,13 +2817,90 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>>>>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
>>>>  }
>>>>  
>>>> +void sev_pin_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>>>> +		  kvm_pfn_t pfn)
>>>> +{
>>>> +	struct kvm_arch_memory_slot *aslot;
>>>> +	struct kvm_memory_slot *slot;
>>>> +	gfn_t rel_gfn, pin_pfn;
>>>> +	unsigned long npages;
>>>> +	kvm_pfn_t old_pfn;
>>>> +	int i;
>>>> +
>>>> +	if (!sev_guest(kvm))
>>>> +		return;
>>>> +
>>>> +	if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn)))
>>>> +		return;
>>>> +
>>>> +	/* Tested till 1GB pages */
>>>> +	if (KVM_BUG_ON(level > PG_LEVEL_1G, kvm))
>>>> +		return;
>>>> +
>>>> +	slot = gfn_to_memslot(kvm, gfn);
>>>> +	if (!slot || !slot->arch.pfns)
>>>> +		return;
>>>> +
>>>> +	/*
>>>> +	 * Use relative gfn index within the memslot for the bitmap as well as
>>>> +	 * the pfns array
>>>> +	 */
>>>> +	rel_gfn = gfn - slot->base_gfn;
>>>> +	aslot = &slot->arch;
>>>> +	pin_pfn = pfn;
>>>> +	npages = KVM_PAGES_PER_HPAGE(level);
>>>> +
>>>> +	/* Pin the page, KVM doesn't yet support page migration. */
>>>> +	for (i = 0; i < npages; i++, rel_gfn++, pin_pfn++) {
>>>> +		if (test_bit(rel_gfn, aslot->pinned_bitmap)) {
>>>> +			old_pfn = aslot->pfns[rel_gfn];
>>>> +			if (old_pfn == pin_pfn)
>>>> +				continue;
>>>> +
>>>> +			put_page(pfn_to_page(old_pfn));
>>>> +		}
>>>> +
>>>> +		set_bit(rel_gfn, aslot->pinned_bitmap);
>>>> +		aslot->pfns[rel_gfn] = pin_pfn;
>>>> +		get_page(pfn_to_page(pin_pfn));
>>>
>>>
>>> I assume this is to replace KVM_MEMORY_ENCRYPT_REG_REGION, which ends up
>>> calling svm_register_enc_region()->sev_pin_memory(), correct?
>>
>> Yes, that is correct.
>>>
>>> sev_pin_memory() correctly checks the RLIMIT_MEMLOCK and uses
>>> pin_user_pages_fast().
>>>
>>> I have to strongly assume that sev_pin_memory() is *wrong* as is because
>>> it's supposed to supply FOLL_LONGTERM -- after all we're pinning these
>>> pages possibly forever.
>>>
>>>
>>> I might be wrong but
>>>
>>> 1. You are missing the RLIMIT_MEMLOCK check
>>
>> Yes, I will add this check during the enc_region registration.
>>
>>> 2. get_page() is the wong way of long-term pinning a page. You would
>>> have to mimic what pin_user_pages_fast(FOLL_LONGTERM) does to eventually
>>> get it right (e.g., migrate the page off of MIGRATE_CMA or ZONE_MOVABLE).
>>
>> Let me go through this and I will come back. Thanks for pointing this out.
> 
> I asusme the "issue" is that KVM uses mmu notifier and does a simple
> get_user_pages() to obtain the references, to drop the reference when
> the entry is invalidated via a mmu notifier call. So once you intent to
> long-term pin, it's already to late.
> 
> If you could teach KVM to do a long-term pin when stumbling over these
> special encrypted memory regions (requires a proper matching
> unpin_user_pages() call from KVM), then you could "take over" that pin
> by get_page(), and let KVM do the ordinary put_page(), while you would
> do the unpin_user_pages().
> 

The fault path looks like this in KVM x86 mmu code:

direct_page_fault()
-> kvm_faultin_pfn()
   -> __gfn_to_pfn_memslot()
      -> hva_to_pfn()
         -> hva_to_pfn_{slow,fast}()
            -> get_user_pages_*()      <<<<==== This is where the
                                                reference is taken

Next step is to create the mappings which is done in below functions:

-> kvm_tdp_mmu_map() / __direct_map()

   -> Within this function (patch 1/6), I call sev_pin_spte to take an extra 
      reference to pin it using get_page. 

      Is it possible to use pin_user_pages(FOLL_LONGTERM) here? Wouldn't that 
      be equivalent to "take over" solution that you are suggesting?

Reference is released when direct_page_fault() completes using put_page()

Later when the SEV VM is shutting down, I can do unpin_user_pages() for the 
pinned pages.

Regards
Nikunj
