Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13EA738FDF
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 21:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjFUTRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 15:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjFUTQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 15:16:54 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0438C210A;
        Wed, 21 Jun 2023 12:16:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKp3UoBy7m7JSNB4wKKORwQUkw8SMKq6CUYvYwoufGEQDqh7GbG1gvNrD6GvaBwNVx33pTq0htOZ+Wr69YSvIUsbxyB+8oxBxIBkhN9wGwOUF1isA/Uc1vo3/3mtFLF8NTwA5NM7oe7N3HkZiKdH40oa8X2SKLLQEIeEhY17KFuELPj5YoZ1Tg6zFOJRwmd5KpN4Zf735sd+d6tOwzm57j4erkyazPYSKoft+axtusWnSRGxo8OpP012Ne2Ry7njIYn1OwbX3SIh9tFQSKVKuNxS4AjrxjblXLenopW1Ba+c7Rn4PwIlQzJPtsm/a7bFW2QM1MLgzjQ1hGCi1uD2uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n1H8lK2pRbt8W7Gi+X5hdaax+tbrfENpsVxM/BExCho=;
 b=Nl19nX/8yJaWoBD0di4LS4iGUF/FWdwqEgEoqnbmZ8iJpQPcgldNLT7Br1JK4Yt7caisohGFDyay598BqtUL+CFopbFC1zPtTjpgEA6kBM5I4ndGudMCYcpR1qDavKuBXGJC2fex5X01fSAktTrorC9skN3dBMUzSEsc8TwD+cOZWcdNQfvTQXSFDj6acNmzmSxyBH3OqYQNQD1gemIggbGF7kYUeaZ8+Y7OsPrGlhOv72o918CP+xKgs0hzKxhSe+rUE9irug0y/+8vJOWdNCPUpvnSM42iadTaZapKaMOZ7jbfIh0VUw4kuXJMJhwFS2Oi83SPn1N+o9FCVZVvzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n1H8lK2pRbt8W7Gi+X5hdaax+tbrfENpsVxM/BExCho=;
 b=mh/TR7xi2MPyMXgASTicC6wVHMrz3/MqTEwHUKaa10+xpDsN3a9Zci1njqGWW2lvwSTmgCVAvFsivfjIkemR7zLy71DgEz0DRRFo9bcH5p7CyRd91oUwcaXQCoU0UwxWw0CPhFzVAbjX5ofuLhMet/FV27pkqya0yxZnRrbvzSo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by CO6PR12MB5412.namprd12.prod.outlook.com (2603:10b6:5:35e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 19:16:02 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3a3:dcda:be6b:c6fe]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3a3:dcda:be6b:c6fe%7]) with mapi id 15.20.6521.020; Wed, 21 Jun 2023
 19:16:02 +0000
Message-ID: <34e2d332-5daa-f479-25db-a71bf98536d2@amd.com>
Date:   Wed, 21 Jun 2023 14:15:58 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v9 07/51] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, nikunj.dadhania@amd.com,
        liam.merwick@oracle.com, zhi.a.wang@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-8-michael.roth@amd.com>
 <20230621094236.GZZJLGDAicp1guNPvD@fat_crate.local>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20230621094236.GZZJLGDAicp1guNPvD@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS0PR17CA0019.namprd17.prod.outlook.com
 (2603:10b6:8:191::8) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|CO6PR12MB5412:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b6d1bc7-96c4-4cd4-7470-08db728bf3be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Oc6T2W9Bs3G6DJfM+2P+5l2QQFETSchwg4BlMr92KCE0mchozuck9UOMNF9uufBsSuL4aF6V3FzU4e4LExEdXDzVK/6uw5MDxNmYJwjk/efsCTKK3mGr65Mw4nscOWusfa844lVJCZaONS+F+5eBmbFWIvkcn+qygumxcaDtcPKuVHXikygqLHYLGwZNPd4UORv937uFIuML5pf4zK1j1swQAoWRRLIg81NFumWlKu+DN4DCCVd2NYrckOnVsCCjJvH7LxAe7mqXKzsgXyJ9zFTuMu8FEjILIzCLTwBcvAPGiILaKEaPmmrTT40pjj2kJfCGdaIhKreGCFhE5Ghr8Vf4u830uOuneq8pP0LyuqQPPShWW88f+nlQabkr21NXiSflGqjdqvq6AawM4uxZl/ZUOTIJcJk5OFTYzc9Yoau+UW9U/EkwhTVPH+7Ek5Xjbva8A0ByKw7ypIpq+x41viWSasSt+rQkIWL1TXErF9fEdVq5ifCUwzNVaLGUYPLGGLTsb+IWVpk/h77fYIsCZTwxRmmQw2UcESKpMb3EDNKmYZk9ikRls1jGBFGTT29grNf/WScePdduLBxJn41OW19fKT1qvYnf/Lh3rIOe5nS95luakBP7Ln8vU/3/st/e2xom3tBhDzJyWZO1jb/zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(451199021)(36756003)(38100700002)(86362001)(31686004)(31696002)(6486002)(41300700001)(8676002)(5660300002)(7406005)(7416002)(26005)(966005)(8936002)(6506007)(53546011)(186003)(2616005)(478600001)(83380400001)(2906002)(316002)(6666004)(4326008)(110136005)(66946007)(6636002)(6512007)(66476007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1JYMWJQa282dDBDWnFCYVU0TEUyR2pVKzFFY0dtMVZlclBDUEV1RmZTSDJ1?=
 =?utf-8?B?R2V6QTd5eEYvV014cy95ZmxjTkRhZndndnlwRHJENHZTMlVIem5PQUt5c2lC?=
 =?utf-8?B?ckRFREZldVZ5VnAzd3dGTndnRTNaWTRZenNnVVFHVFpya2J3L2xDYnFwMk5x?=
 =?utf-8?B?ekFDNW1ORE1NSmN4My84Q3doTGVFZWFqV3ZRYjlxdWEyOE0yVDNwOWR5YnNB?=
 =?utf-8?B?MUpOb3B2S2xKOXZ3a0w2SHpuZHhncG9HS0F4NFFQWDI2bHBDOG5GcThRYVUr?=
 =?utf-8?B?R2xFVW81a1F3VHh0OC95NmhEaDdZTHl2UmVKc2hzRjFOV0I2VkFmTEFBS0NI?=
 =?utf-8?B?eXpGUDhWeWJ5NDNpUHZhb2pEeTR1cWZoQ2N3OWptTElaQzFFa1ZTRjRpTlVZ?=
 =?utf-8?B?anBlcGlFdjZQMDNBZEtTWXdJUzdOSmxPbFlNd3BDM3d1Q1l4WVc4YzVJMVY4?=
 =?utf-8?B?ZWJOK1cvN0lqbjdrV05TV2JPNUtsVmh2b0h0T2hMaG1VcU50bXFXSjJQdkRF?=
 =?utf-8?B?L0NqZ0JhS0JzeFRNZHR5Znp6S3ZDVE9pVXFGR3dXcDg3Rk9EbWdjc3dHeWx0?=
 =?utf-8?B?S2JBOHlxYk5ZWlZ4cEdUOU1QYkY1eXg4clFidWd6Q2g3ZXpmbWFjc0txd0ZG?=
 =?utf-8?B?blJRellEKzFnRHhJNlcvNDJiMGhuUE5yVUNjeTh1dEpEY21xbU93UUVqVkdR?=
 =?utf-8?B?UGVhVitCald0VEtSbzl0MnVQWWZHQjVDb3RsN2FxbDNnNmJic1NvZHNObVJQ?=
 =?utf-8?B?ODNTUnYrN1gwWUg1SE1lcmRIZkxqWUxKdnVuMDZCYW9iT055ZFArZVVuVGU4?=
 =?utf-8?B?NzZqUWZyeUZzWGdNWWxDNVk2MkdDaHhSSEZDeFZRQ2JaWmErTXZwTXBYc0Iw?=
 =?utf-8?B?Q3U4MFkxUUZnNVlTV0p4YzE4SHg5ZG80Uk43WGx2eVFVcDEvRFhFcDBCb3Vt?=
 =?utf-8?B?L1VsYk9sVERMZGVKK0RsQmQwVGlNRWxFeGw4ZWFCOWlCNVc5TzhBY1EzUjV5?=
 =?utf-8?B?c1BDbzV0WEd3OUhrTFlVS01PdElLVDIrRWFZY1pialhXTEFOekJrOEZnd1JS?=
 =?utf-8?B?cDNVSVJZZm5tZXhnQzlMOW8raDBJUHRpY215eWJFUEZPUklIeEd1WDgzVzh6?=
 =?utf-8?B?Ylo3WXBNejB3a3FkR1N3YmZCTFJ3SEM2WUE3QTQ0MnFRWHZFNDF6ZHQ1Uzdt?=
 =?utf-8?B?czdtQk42OUNQY25zR3FSY0NheE9lWm5QUEhUUUY4ejVHVDZkK0orcmdjbW9P?=
 =?utf-8?B?WG8rd2xxSFIvbEJBUDBPRUFvSXJFcUtZc014bXVvNmR5YkVFallzWnQyMVdY?=
 =?utf-8?B?ZyszYlpxUzAvMWx3UEdlYmVNVXNvSVY3ZjVqQldZSWhPWkZuNXl1MitqdXkz?=
 =?utf-8?B?UGNYdFU4VVQ0OUZQUnVsYUREMktCZzA0L3cxcmJ4WHRkbE10WDFOWkZTS0Vh?=
 =?utf-8?B?TDlOUHFmT1FidHI4Ukx4NXNVbU8rMFQ1Rnk4L281MzFhNzEwR2FpRlQybWNR?=
 =?utf-8?B?UnR3bzRDSy9IRUZQbllBVTBySmtqa1ZTREpLZmlIRDBLd1dFZzY5b3cxc2xm?=
 =?utf-8?B?TU5GTkkwOGZwMkxubjBVRjFHUlAxcGg4R0VDeWMwS2ZmSDlMWmdTUCt4elBr?=
 =?utf-8?B?R0ZCNmxHZURBZ1NnMy9Hd3ZCM1BtVVNlVEZ5aXhZY3ZGbWFoeWUvTXVraXlm?=
 =?utf-8?B?K09TQW8wRUhVMHhuSzVnUUlIRytiSXNDZCtWTjdHSE5UZXNzVHptSWFNSjF5?=
 =?utf-8?B?U3RMSnkyLzhtVFhKSyttVmh5eVU1WVlNWjFhdUpMK2gzdFNRL0tWRUJYU0hS?=
 =?utf-8?B?dkhiM1E3czJGakZLbVQ0YXpBamxxaFIxZTRVeDRnZURQdC9QclRRa1RuMVYr?=
 =?utf-8?B?QldoYldMbms2aTNTU1N2RTFGbWxTbmlyTEwwUCs1aEkxWEYyOGJESDhNNXVC?=
 =?utf-8?B?Q1RQTEpRZXNlZGlKeGo1NlprTGZ6dHFwbmQxbE9vY2xvRUFueHhzU2lxZk9V?=
 =?utf-8?B?NW9Xc3FOSnZzeFgzcW5neXN0NzBIc09OUFF6WlJiUmkvRVpzUjVJYlloTEky?=
 =?utf-8?B?M1E0em44UTU0Rm5VVllTMGpHdmhEYXdJZ2x3Mm1yRFMxazZMQkhPa2RSQVR3?=
 =?utf-8?Q?dmv27mFPK8H1RFnzU0ZSGHY7M?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b6d1bc7-96c4-4cd4-7470-08db728bf3be
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 19:16:02.1212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +aaL4Mqes33Dy9UqpvBmgeSHStrDnif9de8LoLKoWObA81NCZ0HbyB3ySc7qwXoswgkrodp85a53cGgfDNoZ0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5412
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris,

On 6/21/2023 4:42 AM, Borislav Petkov wrote:
> On Sun, Jun 11, 2023 at 11:25:15PM -0500, Michael Roth wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> The memory integrity guarantees of SEV-SNP are enforced through a new
>> structure called the Reverse Map Table (RMP). The RMP is a single data
>> structure shared across the system that contains one entry for every 4K
>> page of DRAM that may be used by SEV-SNP VMs. APM2 section 15.36 details
> 
> Rather say 'APM v2, section "Secure Nested Paging (SEV-SNP)"' because
> the numbering is more likely to change than the name in the future. With
> the name, people can find it faster.
> 
>> a number of steps needed to detect/enable SEV-SNP and RMP table support
>> on the host:
>>
>>   - Detect SEV-SNP support based on CPUID bit
>>   - Initialize the RMP table memory reported by the RMP base/end MSR
>>     registers and configure IOMMU to be compatible with RMP access
>>     restrictions
>>   - Set the MtrrFixDramModEn bit in SYSCFG MSR
>>   - Set the SecureNestedPagingEn and VMPLEn bits in the SYSCFG MSR
>>   - Configure IOMMU
>>
>> RMP table entry format is non-architectural and it can vary by
>> processor. It is defined by the PPR. Restrict SNP support to CPU
>> models/families which are compatible with the current RMP table entry
>> format to guard against any undefined behavior when running on other
>> system types. Future models/support will handle this through an
>> architectural mechanism to allow for broader compatibility.
> 
> I'm guessing this is all for live migration between SNP hosts. If so,
> then there will have to be a guest API to handle the differences.

This is basically for the RMP table entry format/structure definition in
arch/x86/coco/sev/host.c, as this is non-architectural it is defined in 
a .c file instead of a header file, so that the structure remains 
private (and restricted to that file) to the SNP host code and not 
exposed to the rest of the kernel.

As mentioned in the comments above, future CPU models may support RMP 
table accesses in an architectural way.

> 
>> SNP host code depends on CONFIG_KVM_AMD_SEV config flag, which may be
>> enabled even when CONFIG_AMD_MEM_ENCRYPT isn't set, so update the
>> SNP-specific IOMMU helpers used here to rely on CONFIG_KVM_AMD_SEV
>> instead of CONFIG_AMD_MEM_ENCRYPT.
> 
> Does that mean that even on CONFIG_AMD_MEM_ENCRYPT=n kernels, host SNP
> can function?
> 

Yes, host SNP is supposed to function with CONFIG_AMD_MEM_ENCRYPT=n.

CONFIG_AMD_MEM_ENCRYPT=y is needed for SNP guest.

> Do we even want that?
> 
> I'd expect that a host SNP kernel should have SME enabled too even
> though it is not absolutely necessary.

Yes, we typically test host SNP kernel with SME enabled.

Thanks,
Ashish

> 
>> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> Co-developed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> [mdr: rework commit message to be clearer about what patch does, squash
>>        in early_rmptable_check() handling from Tom]
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   arch/x86/coco/Makefile                   |   1 +
>>   arch/x86/coco/sev/Makefile               |   3 +
>>   arch/x86/coco/sev/host.c                 | 212 +++++++++++++++++++++++
>>   arch/x86/include/asm/disabled-features.h |   8 +-
>>   arch/x86/include/asm/msr-index.h         |  11 +-
>>   arch/x86/include/asm/sev.h               |   2 +
>>   arch/x86/kernel/cpu/amd.c                |  19 ++
>>   drivers/iommu/amd/init.c                 |   2 +-
>>   include/linux/amd-iommu.h                |   2 +-
>>   9 files changed, 256 insertions(+), 4 deletions(-)
>>   create mode 100644 arch/x86/coco/sev/Makefile
>>   create mode 100644 arch/x86/coco/sev/host.c
> 
> Ignored review comments here:
> 
> https://lore.kernel.org/r/Y9ubi0i4Z750gdMm@zn.tnic
> 
> Ignoring this one for now too.
> 
