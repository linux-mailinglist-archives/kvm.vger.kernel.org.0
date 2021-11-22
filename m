Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3771E4588B2
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 06:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhKVFJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 00:09:02 -0500
Received: from mail-bn8nam11on2041.outbound.protection.outlook.com ([40.107.236.41]:12385
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229933AbhKVFJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 00:09:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJaOZAWN19k80sjowM5pCLs+Ozxcvg/1ZoyhdAs/QiogKfq1AvBBCyxztLH4EgBrsPbpfANESJXMWck/uVNorRnuQWdM1+tkL+aRgjSAbGdJP+KjNaFCvJzd1GD8kpni1dawsECR/CqB44zIxSz8g/U4YvfX48QOzi7/gqVKMdKskeZTfKeCCnrPa+5LAW7zRoEGYW//D4qOHiSWsY0h+rZutpQ8qNgbzeQJVL+73NKJhueCusSE9JO/6ZNNS5hw75z/AEKyNV3pZXmirxXQAjHB5rTJTSB9nf13vnSBL11fKShS5zcAB0x3xlcPNZUOGEdyg0y2TxhIkHU8R3ycjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBngOOK4NblKNh1w+yIMKU3dpwB1hKBPSJwQ7z6U/Qk=;
 b=VgWbn04Wv7L253yVaQ5uPBp2vNlCpez7cX92Qk91NQfrcvKyA6yT+3UXmV0Ekk1o5MauIOPmLmK4e8kD90V1tEd//9+Tng6/knoweLMoAkXYbuQajCUWKHCHKBNDSX717zGm+uwgd8ecrWb4yMpYoc3M99FaZflsg1C1VtFrPXJz3uUM77jHVbGLASbf86iNL4qZ838oTDbsgXyViGWXyf0fg2RCbWcg8rx8E5dSKYukNwTDhcVLsCSnFoxJaijKoaCFleutkxARI0Qdo7BzmAFJ4t72qG5Gr/XYzLKcQCSy7tXFRMJhONJ1qFeOrxZszrxrcfrZqonUVacm+5bNJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBngOOK4NblKNh1w+yIMKU3dpwB1hKBPSJwQ7z6U/Qk=;
 b=LKfSgXY/SCIrgKlmTxzVut8vkPAfBakLo6Ibl0IcPKy1Vb4TGX6IE3PnPmae8hnec/+37E+nkbOIsyY/KJvRcbdnyLzh7erXKVlYE/yQXJlL1NBHh97DxvYbrJL2k/DNQiUdjebLPvUsIbkg2Z9E4DONTYSq/RXbRUA0MU+L5hY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN7PR12MB2739.namprd12.prod.outlook.com (2603:10b6:408:31::31)
 by BN8PR12MB3539.namprd12.prod.outlook.com (2603:10b6:408:9d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 05:05:50 +0000
Received: from BN7PR12MB2739.namprd12.prod.outlook.com
 ([fe80::a000:c03:95cb:b43b]) by BN7PR12MB2739.namprd12.prod.outlook.com
 ([fe80::a000:c03:95cb:b43b%4]) with mapi id 15.20.4713.024; Mon, 22 Nov 2021
 05:05:50 +0000
Message-ID: <714f04bc-ad43-0eaa-47e4-2c9fb7d8e35b@amd.com>
Date:   Mon, 22 Nov 2021 10:35:31 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty
 logging is enabled
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        nikunj@amd.com
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-13-dmatlack@google.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20211119235759.1304274-13-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0144.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::11) To BN7PR12MB2739.namprd12.prod.outlook.com
 (2603:10b6:408:31::31)
MIME-Version: 1.0
Received: from [172.31.33.50] (165.204.159.242) by PN3PR01CA0144.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:bf::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Mon, 22 Nov 2021 05:05:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88156b5d-7bbe-498c-8da2-08d9ad75bfff
X-MS-TrafficTypeDiagnostic: BN8PR12MB3539:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3539F08E619AF13F1C66E147E29F9@BN8PR12MB3539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:277;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GgMA/xdcg0YE+yFew/hFyEMKuUXKNWn/FEO9HV3cm72mR9/8ZmPLK3UF4ATrA69WyTcXH5GkW2OPTfdc1KB7aEW3uwfF0vz8uKK/GWgPNnL+9VTPk/tnkjlpG1IqNKyefl0TCMXrDamQGT9MdXj9nomjnVpGXEHsYpGCGEwFZfRFu/26kDkwVOm/KGbG+SoK02+SfEyMFZB/jckHimAauwMT6V9JRijYWShf164IPNHMjgaTqUb9ubksjdj4QEJPQLL34EltAoQnpsZIKbh9CVqw99sP3vXZVEIXxNG0mN6/RyrUGEAqZKxWbI5XMN0vsc6g/9tlrqUs3dkAVhRmRBZWtcNNENxCb/6JZ68uisndCO9EVFSwdX9s6R1CWlfbC84uM4RMHLhTJc9gBTHdAaePOJNZaSWY2NMNl9ljl8t5qJjK3lfEHEWk6T/j3Kg0MxzWQHqI9tKd/YEh/92cjBEPqZuSLi4zZV8OtsPHkLXCsviDSzvtg5wHKUtvULnG72DmfBGQYqANrQnXAxwgxqAfwcK3brWehDVTbPZoHq+EpuV9DypfcHQqUaXJV/O40b85hF2pb11H3IoHVGVSCjFdt9AlRY0URk0VEVF2thucP5ByhDz88tmM1enY4L4fk1Zyb3oC7rp+AvwPlMlCvnoR70TfpzHd80XJhugWR4PVbeqB5mXnT2JNaKU/m07xYs664oNdLBISN9WLoXtbKyf/6qurm+dx/FkZT0UmY7X6BTNYRL2aCT6EH8FMOwxz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR12MB2739.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(956004)(26005)(2616005)(7416002)(186003)(54906003)(6486002)(8676002)(6666004)(83380400001)(508600001)(31696002)(110136005)(4326008)(36756003)(2906002)(16576012)(66476007)(5660300002)(66556008)(8936002)(66946007)(31686004)(316002)(53546011)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVo1SU5UZ0NNVGZyME44dDdvK3A4UkdVQ3BETUJGb3RVWDRNUHY5Sy92eWJh?=
 =?utf-8?B?VENHZDJxd2hlblpBbmZLSFNhV1B5ekxHTE5qOHR1Wmdkc2lLT01KazlCTndm?=
 =?utf-8?B?MGlWTzVHU1NLQjRxUkFvRzhuS3MvUkpuL2FWVWFCZVgvWElISHd5N01Hcm8r?=
 =?utf-8?B?YjJIN2VwVkZuTXo5NEUrZ0xlQitmNnBFSW5wTEdwMVNVVklGWllNbmtTLzJi?=
 =?utf-8?B?bG1lWWZPSUFXTDF3YzIyYmtBemRMeEtTSlVQZzhZZlFsOWR0UjhTUVNjc0RD?=
 =?utf-8?B?M0xXZUREd1FBTmJPVUZoZi9xNzhzWlgxeTNoczlxYTZVUEd3NVZ2WGNhaUow?=
 =?utf-8?B?SHlIMHd6VG96dTBkdlFLeUI3c1RYdDM3TzQrV21xY08zSVdiUFBha0MyQUxJ?=
 =?utf-8?B?SC9NclBTMVF4RytmYVE5S2gwRURrTUR1cEFJbUV5RG51QTQzZ3Bhc0tSRFhy?=
 =?utf-8?B?M21UNytCaHFIYzNkakJEK0FuN012NkYxVFRQMFNxS0xoZWdFcmFBMnB0d2hE?=
 =?utf-8?B?Vm5nekdEK1R0am5ET2JZRHNrWkdQR0t6Y3NKNDN6eHAvdzh2eklUazlTcEF3?=
 =?utf-8?B?TTdMeEtVZmxWQ3JTSUNSTXNGa1NmNXRvVnRaWWJIVy9aZ3dCaVlwcmZQZzcy?=
 =?utf-8?B?RVVBajdvdmFaN1lyV0ZiV0U3VUdRZHlhQkR1OXZ3TVIzQU96cGViNmVhd2lO?=
 =?utf-8?B?NzFIQmVzejVERzFnSDV6YjBRV3hrejZLdWpjcU1RTitjVE5jL1RKaWc3QkYx?=
 =?utf-8?B?ZGpmeDViNFcwWmxFK0I3dm1VenNhQWVwUUkzdlg3REJULzI2eVFFazdqelhi?=
 =?utf-8?B?SGthK1c4UTN3c0poZldsMnJ3eEdvMGdvZ0FLaWkvZmJua3gwazZ3bjB4RURS?=
 =?utf-8?B?c29ZdWZZRzRHa3d2dzNsNFNGM25lbU5WNUNxc1p2Sm50SGN2Z3dhK3RRT1Z3?=
 =?utf-8?B?NGZGcFhhWkJnRk1RZW9pQXZaSGx1bWczemg5SWNBYi9YK1NDNE5KL1lhWG8y?=
 =?utf-8?B?TUgvdy83UldMN0xuL1licG4xMk1MdCtjSDJldDJQQVEvblpUZ2h2V21hcWJP?=
 =?utf-8?B?S0Zwdk43cUZGNTNNWUdaenpma096WTNaR2RrQ3o2UTAySStYaVp5aDRQM1Y2?=
 =?utf-8?B?YlV0TEE2Ykk1YzdPenhab2xnWk1ka2xTTWdGQ0MvWnRyS1NFaGwrN0hYdDNE?=
 =?utf-8?B?Z0lnQWFPcjczZ3A4N2VZTU8xOVRETVkxVjBXWlNFaEg2YjI3RHRVU1M4ajRX?=
 =?utf-8?B?aTNMQXArS0Z4RndhTWVBbCtIQmszTWl2bG5HM3NmU25XcjR3RmY0ejZxcXla?=
 =?utf-8?B?NFB6cHRzb0J3RXZBdmR2M29zZ2NMczREN1h1S3U1Umh5SkxnemV1dlNrQzQ4?=
 =?utf-8?B?TzBJNzJBbm5tL2N4M0FUN29nZW5ySGlUT2ZZMkNKYml5dkRSVVJnMXFQMHhR?=
 =?utf-8?B?T2pXRkZNcU0yQmNpY1FrSkJydHhGYlF6TnM5OVVVZ3hSNXRtZDh1YjRjSW5V?=
 =?utf-8?B?bnBzZGw0WWJiRExHWWVYdVhmZXJCOG9aOGtld0kydVRrNFZ4RXA2OWNOM3Jq?=
 =?utf-8?B?QlJrS0lvcTQyazltakhwQlRxb1o4Rnd3dEsrYzRZaG5oRUJ2N3JmS3BFWEFv?=
 =?utf-8?B?eVRhTzh1R2ZtdFBFdVlmWjdnS3k5MEFSQ2FLZjIxN2ZxSWlpcFl3RlM5MXkx?=
 =?utf-8?B?MVVzUlJVU0Y0bERhajJRRXJkREFhUUZKaGt4Sk9wMjZoL1VZWjNjSVBHZThO?=
 =?utf-8?B?S0dZbnJtRS9ueVprSkNvL3VkREF5OHk1bzZBak40eDJIT3lCWmlUcWpwVk9O?=
 =?utf-8?B?dVJOY0trTmZLUC9xVGF3ZGwxRFhDVTZjSG5ZMjNhQ3pDRkx5amQ4ckdWSXNt?=
 =?utf-8?B?bVM1SW5pd3VObWwzS0hJZ1owdzQ3c3hQUWNXemh6cGpTNndTWS9FNXNWcTRH?=
 =?utf-8?B?QlRzMzlBNFdFZHoxWFNDWjlwNnNUY1ZWeU5xVE44by9SNlJxendkNXp0azZw?=
 =?utf-8?B?SmkyNTBkQXlRZkRLdTBlMU55bEI2ZmQ5eFhneHJDOU5MVEdRS2ZBaDQzUlg1?=
 =?utf-8?B?bGN4aDJBeGFqYlY5ZWxUQmcxN2p6eTk2MDlneFJXUGlEdVViTTQyd250dXZr?=
 =?utf-8?B?dW1kSmhiZ1NEZjJHbTU4NEwyallUcXM4aTFqa01zUmJieFBWKzBUMnpyMm9n?=
 =?utf-8?Q?3BJfxK0UsJFDdhqxC9AZVvs=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88156b5d-7bbe-498c-8da2-08d9ad75bfff
X-MS-Exchange-CrossTenant-AuthSource: BN7PR12MB2739.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 05:05:49.7078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mpb9oaj6BkzRX0+R1DuhW0swJ6dDCQo1uhlqY1Y+wn+3J/CNvefeDjLWmz0MZYwqLBCQ3+bjtn+xVX3qHOQDng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/20/2021 5:27 AM, David Matlack wrote:
> When dirty logging is enabled without initially-all-set, attempt to
> split all large pages in the memslot down to 4KB pages so that vCPUs
> do not have to take expensive write-protection faults to split large
> pages.
> 
> Large page splitting is best-effort only. This commit only adds the
> support for the TDP MMU, and even there splitting may fail due to out
> of memory conditions. Failures to split a large page is fine from a
> correctness standpoint because we still always follow it up by write-
> protecting any remaining large pages.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

> +int mmu_topup_split_caches(struct kvm *kvm)
> +{
> +	struct kvm_mmu_memory_caches *split_caches = &kvm->arch.split_caches;
> +	int r;
> +
> +	assert_split_caches_invariants(kvm);
> +
> +	r = kvm_mmu_topup_memory_cache(&split_caches->page_header_cache, 1);
> +	if (r)
> +		goto out;
> +
> +	r = kvm_mmu_topup_memory_cache(&split_caches->shadow_page_cache, 1);
> +	if (r)
> +		goto out;
> +
> +	return 0;
> +
> +out:
> +	pr_warn("Failed to top-up split caches. Will not split large pages.\n");
> +	return r;
> +}
> +
> +static void mmu_free_split_caches(struct kvm *kvm)
> +{
> +	assert_split_caches_invariants(kvm);
> +
> +	kvm_mmu_free_memory_cache(&kvm->arch.split_caches.pte_list_desc_cache);
                                                              ^^^^^^^^^^^^^^
I believe this should be page_header_cache.

> +	kvm_mmu_free_memory_cache(&kvm->arch.split_caches.shadow_page_cache);
> +}

Regards
Nikunj

