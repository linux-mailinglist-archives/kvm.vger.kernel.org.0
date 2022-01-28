Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8867A49F3E6
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 07:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346561AbiA1G6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 01:58:06 -0500
Received: from mail-mw2nam12on2060.outbound.protection.outlook.com ([40.107.244.60]:55137
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232306AbiA1G6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 01:58:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdxLSR8c2tjMqLe4RkR6xJRR8zf6sGy/bp25KY0RhCARY+6wMd70EEJOHfctooiUqMvqyzQaXT2bwlZp8qgvz0Oho8ofVaXHwnf6oBfmE8QfbVTiMsRAFeTHSp4oTmTfYql0aWgw/T7lwyjZN/tALetSF8anlQGc13JLjPb4bMwMvKMc8OE3m2PugBzX46L9xcry9DfSH5QvnPp/0j1787hec0dNYqb+n+knC+G2x7Qfmj5jvTssTv1pUP8xQPRWw2bfjQaZYOutX5l5pUD4WYtfuEW+vCEni7XMShB1dLwIeEdisPtID14hnVtUQHc2IasTnqIE9BAsuW6Qjf7xFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wadDBWrjrdKPkg2xG9niWZfGzsiQKmvTCyTndYjtNV8=;
 b=GPNUgP3jljIINT7OjNUgodHHoOJBt0btWRmeew4QdTvXGUwpl3rSitcN6MX2TUsLHua+LdSnnbQwO7MVLP+2jtd8X5I9aAP1Hrh55d53QhvWSrfk30kVE+RMqB31xoMy3Rtv4WxhzAQsEbIuZrgacjOBhMMlVxUVBGpLva4OmIYDtNxeGBBDNHcHFjtZQPJrYTXx6IbUQW/j36i9qB+LWaUsdtCrLcxjnq6/J2ZpPoQ+EH/+lnYz+J3nWsuPfaxQTFPAmiAl1aXPfX63+X2/Z8PjlXyqaMjfmyH+vvpxyu0lfabljkkqJBfddkZOIQuztpxrOwYLB3a/wc5HHZDvvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wadDBWrjrdKPkg2xG9niWZfGzsiQKmvTCyTndYjtNV8=;
 b=hEVJNuhnyncYtcmSud922dHpol85AWgcS5JovExMcnHHsUsaansCrv8kuV6Qdi+7cxigDPHzIucM1p86DtlyITSTtF4M56x1XLYdNUgdB91wURIxRAU+GexjEjOrgCmKF7jRJSnERTal3Cyej1EAaJfnN5Z5RpXS7hcTdUQlZWQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 DM6PR12MB3436.namprd12.prod.outlook.com (2603:10b6:5:11b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.14; Fri, 28 Jan 2022 06:58:03 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::19bf:2e9b:64c3:b04b]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::19bf:2e9b:64c3:b04b%6]) with mapi id 15.20.4930.019; Fri, 28 Jan 2022
 06:58:02 +0000
Message-ID: <c7918558-4eb3-0592-f3e1-9a1c4f36f7c0@amd.com>
Date:   Fri, 28 Jan 2022 12:27:46 +0530
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
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <99248ffb-2c7c-ba25-5d56-2c577e58da4c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0154.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::24) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d872da1e-21ad-483c-f316-08d9e22b86cd
X-MS-TrafficTypeDiagnostic: DM6PR12MB3436:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3436BE89951C07B8A9EA2C17E2229@DM6PR12MB3436.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l3S5Qg9vOu46MagBn5TMcoDtqGFqCo5uTiPxGxFYLyfmWB4XC3cfOWYT3g5KAqkLoVOMTj2N2poZZictsMd6rHwydCX2yfZQ/AMuGxCAxeh2zpwRHirBVJojCziQSsiTg/xeUQO7qUGvyu2h03dtDpVpR8UI0/J18hD6SJL5x4JFl9K7YAkbt/igM0uUlDcoDFo0Ob2+hCg+naPVEwLsABEpgQeTGtUN5TwNrBK8+RW+ANaO3bwcacn4C/K7kdWQy/hKsRG5L6Nt2Gac58IbyTU06FQqMIyGawBue/LC87SCWJLFAm4BI88Odjpnv8Rwg4qdE7QxpgibxYbrTh4aKsIDj9d0MB+PKFmS2Qd3Rwe+KLlDvgQmolf/LfTbhGYuoy6EyMWxSbN9sPO6VhcoBv6jaB47tAj4GH66aiZq04mX0WKZ7Br91iSMazsNGH8QU+CVjksjg572Ikcx0ha7hk4PaLXwoxHSgubxJdwMl91GOBwpLAeMHO824E9d27/BYWjcfPEnowxTIgudRKJbgUFjZ2alDB41TrsB33E62hQkcc4C8BftZ3BnCfBj5V/aS8KLdv3R6Z0C6E6Dxier+oFNufk8ZYEb0ThS/NB/bGt69LvifmF1EQtdjNWDG8NokdaIgh3IehToh455BfnFJUASnnNyIKxHvYlomf5KpyF0wsEgUr2dOfrKyb/AHpWXcNKZBq8PUZ/nl0AIIqL7Nxqbht+ZRAXR8BaMgtX6gac=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(38100700002)(54906003)(66476007)(508600001)(66556008)(66946007)(8936002)(6486002)(8676002)(26005)(83380400001)(316002)(2906002)(36756003)(186003)(2616005)(6666004)(4326008)(6512007)(31696002)(53546011)(6506007)(5660300002)(7416002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nk9FTWptVDBLYUdXdFczTDVLWngzT1JZU2tHQSthMHFzUlJlT0VlQ3ZscUxm?=
 =?utf-8?B?b1dhOHE2bVNYdDYrRWVNQklMaTJmaDJaTE1ldFFySS9OYXBDbWQ3VVZaT0lx?=
 =?utf-8?B?Mm1KdEVURzYzclNsUnFDc1FaR05XUWowOFM3OHNQQ0gwUEMxWVlOWm5WYVBR?=
 =?utf-8?B?Tis1MldZUW5mSllPdnI2N2FMTzM4Y0ZzQ0U3WVRHL2UyczVqeDREZW51RVNm?=
 =?utf-8?B?Y0pGeU1kV2xsTlJ6OWRQK2xyWWV2SlRHSFd5bWdDb3M0bFVGWDRSYTlqUStH?=
 =?utf-8?B?eklaa0YxZk9GaElqL2Zzak1wc3VpQTcvOVlnbmpDR0Z1VnZ6WjZrOU4zVEFn?=
 =?utf-8?B?Vm9zSlhpSXZBOWFQQUQ3UTRXVW9pRXNjbzNGYTJSZzdZbWZLRjBzV3RvbE5T?=
 =?utf-8?B?UVFTN053UFE1YW1mZFUrakYzQWg4NVltV0VtN3ZnVWlzOU4rZHhnbUx5UERo?=
 =?utf-8?B?SjNoVDlsNjI5NnFGZTIzWmI4RDl0Tk02ZWZ2c1VDWU9HUWVZOFA5WjlLeXZ4?=
 =?utf-8?B?MVJFakJMSWhjcThSbU02ci9DZTNuY1o2M21mMHNIQkpDMVJkMU5BZEg0S0Ux?=
 =?utf-8?B?Q1lHK21ReEVCZ2JWQ0tHZ25iZUg2T1Q3VVdEOXF3dkNzZ2RzblFid0RtRzQy?=
 =?utf-8?B?QmtGa1g3QUFjSGV0V1ZqbHpOQUpJV1pRRXI1WDZoQ2lLdU8ySXlLc3o2MkNS?=
 =?utf-8?B?M2J3VlRqeTh6dlFIdHNGZlFOMHVSYjgwN3pJK1RSdlZOVWZhSVBsa0Z4aWtq?=
 =?utf-8?B?MjRiSDQ4ZU5oVlg4OExrek41ZnJWa0lJVld5bzJwdWtqRXcwRTBOa2xCMFQv?=
 =?utf-8?B?TUJEWCswZTZ2a2s5L1A2VEZZRVp2ZDdGRFQrODVNVGM1RGdKNlRwTmRWelJM?=
 =?utf-8?B?Sk1iMlR4RlJkNmpoVVpxSnc4VnlFaVhBYlRiNkZ0eTcvckI3UU9YZis5YWxM?=
 =?utf-8?B?NTVVc1UwNFlwemF3aHZ4dkFKU20vZk1XcUJ1UmFxV0l2QVo0OWJ2Rk9iZmE0?=
 =?utf-8?B?cVVaYWE0dlc2VkYrZUUzTStlMXIvd1RXNFlYRzliNVZyVGNqMVRnbnNlbVNN?=
 =?utf-8?B?aHVqTVhhUW9XTkV3cUs3VXp1WmU4d3ZMSTU0UnlrS1E0QUNrZWEzUlFFcFQv?=
 =?utf-8?B?REVCRXl2QlVlWHRVc0htZ2dTcTNvNFR3QjRNTk9FRFhGSzlRREowa1dQTXVi?=
 =?utf-8?B?bXhXdnBlRGZlM0hFRmhoUkFhYmU4Q3pVZjhFWWIzTDRkY0FidnpBdlF0NVFV?=
 =?utf-8?B?Q1ZsWVZxOVJGTk5vQkRseVlVY2FsVGRyNXNlUk91YVZXeklTazRPQzdCelYy?=
 =?utf-8?B?MlNOenJQWHQ4UmxSZFVGY1JKVjd0YVhpVHNJOGZYWDZRZzF1c0x0Vk94bklx?=
 =?utf-8?B?eWRrQ1ozMERYeEM3YlMwbGRncjNwUDRmd093S0Jua0VFYkpTK1V2dHZ2VU1o?=
 =?utf-8?B?eCttN01qN095REFjSS9kU3NLTDdDWGszSHBOMk5Uc2VFZk9CcnVIWklvS3hu?=
 =?utf-8?B?RTI3Nzh4ZkJIREhFYTlpWEY3OWNHWEE4UHM5MnAzcEtBOHlhRktSTm92Qk1v?=
 =?utf-8?B?cjY3VWZBN1lEYXB3UllqejVMUkFZTjBCM1duTjRqcmNnK1cyTjFWUUNHSEp2?=
 =?utf-8?B?aVY1QzBmK051VFg5NEJkM2Z2STJTa1hFZVNGRUVlZi9RdnQ4elk0RnRSTkFo?=
 =?utf-8?B?S0M0aStDa0JWUW9kZ1c4SjJUUFR0QW1VTkswSWxDYnJFQWlub2dIQ1ZKR0hZ?=
 =?utf-8?B?QTd2dWthZGl3UHVteklXM0NnL0Fxd3U4OEZrbzZ2SDRhRjNFQi96R0RiV3Nu?=
 =?utf-8?B?dXptZXNZU0M3dHZici8wTVlCVVMySWVuWTJqSkY3clNDSmw5U2NwQ3g2ZC9o?=
 =?utf-8?B?Q2J1MVVBalBFMUY1WEZzNnhsVDBqc3NMVWNySWRNNitWZEdyWFZjMjRCbFMy?=
 =?utf-8?B?bkRFVnNweTBvUDlIVW1ja3l5MHdZRmp5VytMd1JmTDJUeHMzNDAwV3BLdTBG?=
 =?utf-8?B?WnduSzZ2aytiQ1hNSHUvRmdacFVNeC81Y2ZXSEZJeDZTdWpPSGRKWmVnT0xw?=
 =?utf-8?B?MWFtV08wZlY1REtTVzBRZzVoM3dsQ1BiNi9EVTBnamhLcjRPZ2p1SHM5YXRh?=
 =?utf-8?B?UU5vWGMwVXkrdmMrYWVockwyd3VhUXRCVzlFWDVPamg5dDAvbVVtNjB6N2JH?=
 =?utf-8?Q?/0Dzzly04y47i4NrX9t6dDo=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d872da1e-21ad-483c-f316-08d9e22b86cd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 06:58:02.7125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rSU31WY4V3FY/EEGRiZD4S5Ql7AB/Sxfj+tB+ctMOyn1d3R+2czWtRB8fkbaYE+PNYEMzEuqTbiuBEJPxYAMtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3436
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/2022 4:16 PM, David Hildenbrand wrote:
> On 18.01.22 12:06, Nikunj A Dadhania wrote:
>> Use the memslot metadata to store the pinned data along with the pfns.
>> This improves the SEV guest startup time from O(n) to a constant by
>> deferring guest page pinning until the pages are used to satisfy nested
>> page faults. The page reference will be dropped in the memslot free
>> path.
>>
>> Remove the enc_region structure definition and the code which did
>> upfront pinning, as they are no longer needed in view of the demand
>> pinning support.
>>
>> Leave svm_register_enc_region() and svm_unregister_enc_region() as stubs
>> since qemu is dependent on this API.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/kvm/svm/sev.c | 208 ++++++++++++++++-------------------------
>>  arch/x86/kvm/svm/svm.c |   1 +
>>  arch/x86/kvm/svm/svm.h |   3 +-
>>  3 files changed, 81 insertions(+), 131 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index d972ab4956d4..a962bed97a0b 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -66,14 +66,6 @@ static unsigned int nr_asids;
>>  static unsigned long *sev_asid_bitmap;
>>  static unsigned long *sev_reclaim_asid_bitmap;
>>  
>> -struct enc_region {
>> -	struct list_head list;
>> -	unsigned long npages;
>> -	struct page **pages;
>> -	unsigned long uaddr;
>> -	unsigned long size;
>> -};
>> -
>>  /* Called with the sev_bitmap_lock held, or on shutdown  */
>>  static int sev_flush_asids(int min_asid, int max_asid)
>>  {
>> @@ -257,8 +249,6 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  	if (ret)
>>  		goto e_free;
>>  
>> -	INIT_LIST_HEAD(&sev->regions_list);
>> -
>>  	return 0;
>>  
>>  e_free:
>> @@ -1637,8 +1627,6 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>>  	src->handle = 0;
>>  	src->pages_locked = 0;
>>  	src->enc_context_owner = NULL;
>> -
>> -	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
>>  }
>>  
>>  static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
>> @@ -1861,115 +1849,13 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>  int svm_register_enc_region(struct kvm *kvm,
>>  			    struct kvm_enc_region *range)
>>  {
>> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> -	struct enc_region *region;
>> -	int ret = 0;
>> -
>> -	if (!sev_guest(kvm))
>> -		return -ENOTTY;
>> -
>> -	/* If kvm is mirroring encryption context it isn't responsible for it */
>> -	if (is_mirroring_enc_context(kvm))
>> -		return -EINVAL;
>> -
>> -	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
>> -		return -EINVAL;
>> -
>> -	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
>> -	if (!region)
>> -		return -ENOMEM;
>> -
>> -	mutex_lock(&kvm->lock);
>> -	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
>> -	if (IS_ERR(region->pages)) {
>> -		ret = PTR_ERR(region->pages);
>> -		mutex_unlock(&kvm->lock);
>> -		goto e_free;
>> -	}
>> -
>> -	region->uaddr = range->addr;
>> -	region->size = range->size;
>> -
>> -	list_add_tail(&region->list, &sev->regions_list);
>> -	mutex_unlock(&kvm->lock);
>> -
>> -	/*
>> -	 * The guest may change the memory encryption attribute from C=0 -> C=1
>> -	 * or vice versa for this memory range. Lets make sure caches are
>> -	 * flushed to ensure that guest data gets written into memory with
>> -	 * correct C-bit.
>> -	 */
>> -	sev_clflush_pages(region->pages, region->npages);
>> -
>> -	return ret;
>> -
>> -e_free:
>> -	kfree(region);
>> -	return ret;
>> -}
>> -
>> -static struct enc_region *
>> -find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
>> -{
>> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> -	struct list_head *head = &sev->regions_list;
>> -	struct enc_region *i;
>> -
>> -	list_for_each_entry(i, head, list) {
>> -		if (i->uaddr == range->addr &&
>> -		    i->size == range->size)
>> -			return i;
>> -	}
>> -
>> -	return NULL;
>> -}
>> -
>> -static void __unregister_enc_region_locked(struct kvm *kvm,
>> -					   struct enc_region *region)
>> -{
>> -	sev_unpin_memory(kvm, region->pages, region->npages);
>> -	list_del(&region->list);
>> -	kfree(region);
>> +	return 0;
>>  }
>>  
>>  int svm_unregister_enc_region(struct kvm *kvm,
>>  			      struct kvm_enc_region *range)
>>  {
>> -	struct enc_region *region;
>> -	int ret;
>> -
>> -	/* If kvm is mirroring encryption context it isn't responsible for it */
>> -	if (is_mirroring_enc_context(kvm))
>> -		return -EINVAL;
>> -
>> -	mutex_lock(&kvm->lock);
>> -
>> -	if (!sev_guest(kvm)) {
>> -		ret = -ENOTTY;
>> -		goto failed;
>> -	}
>> -
>> -	region = find_enc_region(kvm, range);
>> -	if (!region) {
>> -		ret = -EINVAL;
>> -		goto failed;
>> -	}
>> -
>> -	/*
>> -	 * Ensure that all guest tagged cache entries are flushed before
>> -	 * releasing the pages back to the system for use. CLFLUSH will
>> -	 * not do this, so issue a WBINVD.
>> -	 */
>> -	wbinvd_on_all_cpus();
>> -
>> -	__unregister_enc_region_locked(kvm, region);
>> -
>> -	mutex_unlock(&kvm->lock);
>>  	return 0;
>> -
>> -failed:
>> -	mutex_unlock(&kvm->lock);
>> -	return ret;
>>  }
>>  
>>  int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>> @@ -2018,7 +1904,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>>  	mirror_sev->fd = source_sev->fd;
>>  	mirror_sev->es_active = source_sev->es_active;
>>  	mirror_sev->handle = source_sev->handle;
>> -	INIT_LIST_HEAD(&mirror_sev->regions_list);
>>  	ret = 0;
>>  
>>  	/*
>> @@ -2038,8 +1923,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>>  void sev_vm_destroy(struct kvm *kvm)
>>  {
>>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> -	struct list_head *head = &sev->regions_list;
>> -	struct list_head *pos, *q;
>>  
>>  	WARN_ON(sev->num_mirrored_vms);
>>  
>> @@ -2066,18 +1949,6 @@ void sev_vm_destroy(struct kvm *kvm)
>>  	 */
>>  	wbinvd_on_all_cpus();
>>  
>> -	/*
>> -	 * if userspace was terminated before unregistering the memory regions
>> -	 * then lets unpin all the registered memory.
>> -	 */
>> -	if (!list_empty(head)) {
>> -		list_for_each_safe(pos, q, head) {
>> -			__unregister_enc_region_locked(kvm,
>> -				list_entry(pos, struct enc_region, list));
>> -			cond_resched();
>> -		}
>> -	}
>> -
>>  	sev_unbind_asid(kvm, sev->handle);
>>  	sev_asid_free(sev);
>>  }
>> @@ -2946,13 +2817,90 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
>>  }
>>  
>> +void sev_pin_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>> +		  kvm_pfn_t pfn)
>> +{
>> +	struct kvm_arch_memory_slot *aslot;
>> +	struct kvm_memory_slot *slot;
>> +	gfn_t rel_gfn, pin_pfn;
>> +	unsigned long npages;
>> +	kvm_pfn_t old_pfn;
>> +	int i;
>> +
>> +	if (!sev_guest(kvm))
>> +		return;
>> +
>> +	if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn)))
>> +		return;
>> +
>> +	/* Tested till 1GB pages */
>> +	if (KVM_BUG_ON(level > PG_LEVEL_1G, kvm))
>> +		return;
>> +
>> +	slot = gfn_to_memslot(kvm, gfn);
>> +	if (!slot || !slot->arch.pfns)
>> +		return;
>> +
>> +	/*
>> +	 * Use relative gfn index within the memslot for the bitmap as well as
>> +	 * the pfns array
>> +	 */
>> +	rel_gfn = gfn - slot->base_gfn;
>> +	aslot = &slot->arch;
>> +	pin_pfn = pfn;
>> +	npages = KVM_PAGES_PER_HPAGE(level);
>> +
>> +	/* Pin the page, KVM doesn't yet support page migration. */
>> +	for (i = 0; i < npages; i++, rel_gfn++, pin_pfn++) {
>> +		if (test_bit(rel_gfn, aslot->pinned_bitmap)) {
>> +			old_pfn = aslot->pfns[rel_gfn];
>> +			if (old_pfn == pin_pfn)
>> +				continue;
>> +
>> +			put_page(pfn_to_page(old_pfn));
>> +		}
>> +
>> +		set_bit(rel_gfn, aslot->pinned_bitmap);
>> +		aslot->pfns[rel_gfn] = pin_pfn;
>> +		get_page(pfn_to_page(pin_pfn));
> 
> 
> I assume this is to replace KVM_MEMORY_ENCRYPT_REG_REGION, which ends up
> calling svm_register_enc_region()->sev_pin_memory(), correct?

Yes, that is correct.
> 
> sev_pin_memory() correctly checks the RLIMIT_MEMLOCK and uses
> pin_user_pages_fast().
> 
> I have to strongly assume that sev_pin_memory() is *wrong* as is because
> it's supposed to supply FOLL_LONGTERM -- after all we're pinning these
> pages possibly forever.
> 
> 
> I might be wrong but
> 
> 1. You are missing the RLIMIT_MEMLOCK check

Yes, I will add this check during the enc_region registration.

> 2. get_page() is the wong way of long-term pinning a page. You would
> have to mimic what pin_user_pages_fast(FOLL_LONGTERM) does to eventually
> get it right (e.g., migrate the page off of MIGRATE_CMA or ZONE_MOVABLE).

Let me go through this and I will come back. Thanks for pointing this out.

Regards
Nikunj

