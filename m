Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4227675A77
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 17:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjATQvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 11:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjATQvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 11:51:21 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54296C13ED;
        Fri, 20 Jan 2023 08:51:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXKmT2P0ke59c2/wAqWXg8dkj1WhDckZ/2qqWodseh3d43uIq8Dfvz1Pqnt6gOuZy0FkI+NVAPDpoTpjYy92XTTvA5sEQps5jw4UAaiHkfyBIR2NKDBK/QomTGfg9PsWojtWV+LzfESMbOao2Gk9he96+YffBwD2K0w8GAAv9DY1rzKoqFZn43PWDOV4arUWXNt44TERCr1xE7Fid45IMiOfmXTiLiUpQmMvCXW0AVuLRHsSBdyaTsXb4tRkituNfhQqgwRZxWAVti16wI44BWE2jkHAFdOGBmJR18QqSk7UWn4WHU5Du27j6/hMfcn4ot2ZnfTjAuW4chM+NRhWCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jboexqpozZGmsq4ZnZS+tOYzzrbrLJjcLb97dtHdwC8=;
 b=URvzImj0eY7HZnyzCDkTKfOvniOtDJD18Ft4PSzdJoL4Oq6Df748MaR4L9scUayo/yTuMGYUjRBkypw6PL+WD3fuKQsNvcyiXlpWwHFrKs+jDK8+kBRLP7tcWhXMZrYZiuM9SXHB/InJSP5L+X+TzPe9pdJey55yEr4zGJJ7284lFowmclGtfr6Ahw9L017jeikr3EqR8dx+Jq6w+BKKmVKVTsaTxRA20vNiLLGFGM8sC4OFEnpHcJJfSGBAdOfYxKNF97ggmjheq5h7GzwKPcrwpxNvsyUwGPrA8FAlCCANdlFKPpkVxkySZG6pL0ZPldUKGnTLWG8c7wRe3XJqHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jboexqpozZGmsq4ZnZS+tOYzzrbrLJjcLb97dtHdwC8=;
 b=Mh7Bd9oF8UjdHpAZnxXTLjeH2PyyXQAiqbD3JGIrsAbtSSzqZ2jo4L01LeyHKOi0XtGQlkMLmAmVPHOGpXWuTdZBEfwNlMHkzT++r4xI6sxh0TlWFjBoB9eh0q3bp/CtshDnoiyPuw4krIJ7rR4s9lJQ+KB9S1qMRGo5tBP3DaA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM4PR12MB5215.namprd12.prod.outlook.com (2603:10b6:5:397::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 16:51:08 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5986.023; Fri, 20 Jan 2023
 16:51:08 +0000
Message-ID: <bf617582-fdb9-8d41-8794-294b8669194b@amd.com>
Date:   Fri, 20 Jan 2023 10:51:04 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 14/64] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-15-michael.roth@amd.com>
 <20230118155502.GB24742@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <2f786856-982a-1012-f680-9a6c5faee6ea@amd.com>
In-Reply-To: <2f786856-982a-1012-f680-9a6c5faee6ea@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR18CA0053.namprd18.prod.outlook.com
 (2603:10b6:610:55::33) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM4PR12MB5215:EE_
X-MS-Office365-Filtering-Correlation-Id: aa98496b-3c33-47a4-e5d7-08dafb0686de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b0a3x0aCxltOBO2PwDb3lr+bCnOTlj0aYzRh8zIkVYlSA63kXihv8DXB7r2YfUqxcy+o1IO1oFyoas0yO9prGcj4Kj+m1CZDfeISi6/ZGlw7i9cX6KQ+FIBJNTQ5YZx3Q+HfYF682PF7nup03CeztJ3Q3UzjGSb7yUnx93c3h1aA5kQbGllUtwKM+Z+Wole6v1fqFTd6ls9peQMsSfxfSJoiC00z9GCIFXL4Ms7u+rSBTde3ANVwxkgKPlS1OKgW+u8O17VybweXfK7oRnErHv6tp5FOynXg/HM6zXC4CvEiKTRk794P8BqiybC4BC63cUpLjrBnfjHMaxR2UtfEbTJyNT/st9BCt+uImgQLrtO/UtDbxxB/uZRMTM1wkrNqj+fmMPLVqWYcWuiYZoPKIXzIoe7JvAQe28dvLa47avT8hxawudMJq/+d233JLz2qmRj/W5ipXkMcKcNIfQoy/FAeoLhIiDiwk1McVJU7x/1QkvSrdP1KuKhkRJcre5PCvJfLEr/3snv8gxIdpz5B+l4MLPQUE/naZJ0SbsyuP/oDrzOGSThwgbkGBTnvxDW8tl88Diwa0QEGYQeS+dQBVw2xLwX0htkYpsf2HXisAgHzxwy+mAhSXq5mCRJdv79a8kBWeN2UL75DV/TYrXvJ/P545fCrljIYI6jSCDd2x0o+UIQiinxyarUEyeflrTx9vVibgFN9ABIyohi8o/bhgYn9UaUr/KHZQnfoMW6QiSM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199015)(6506007)(478600001)(6636002)(53546011)(31686004)(110136005)(6666004)(6486002)(66476007)(66556008)(66946007)(186003)(316002)(26005)(6512007)(4326008)(7406005)(36756003)(8936002)(2616005)(7416002)(41300700001)(5660300002)(2906002)(83380400001)(86362001)(38100700002)(8676002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGtjTWpmd3Avcjh0ZldwSlNzTzl5ZUJWWkpyZXdmVkFYcFhKZ3l1OVE0R0x2?=
 =?utf-8?B?Tzl2aU1xMGJTcDZTdjZOUzF0ZnJEU3BXSkNTZGJ1aTVFNVV2bG00TUtSVE9q?=
 =?utf-8?B?bTVnNnVDUE5pWGRxQmN5MjJabUVEbzlPdWFJS1dKUHg3Y3ozVWxFMGZtdlda?=
 =?utf-8?B?Si8vVkVDazk0Mm9LU0VNekNlZzZibHMwTEV3SEVhM3ppQ0IyaGhqcElHZVla?=
 =?utf-8?B?dk80cERoVjEvWG1GTFUvelplWEhMTlN4SmhEOE1HdUlXVTZ0SWZZUmY5WVpz?=
 =?utf-8?B?TXVtc2habW5IOG94MWtqQ3oxOWN4WjRkTU5LSUIveUx1aGJSWmYxTXMwSTY0?=
 =?utf-8?B?WGU3N2hwZ3d1VHo5RW41c0FuT1hmU0RZWktxcjhocmRlYkhQSlI1aFU1aGg5?=
 =?utf-8?B?cXdHM3hNblJNUjhJVldpbzZaQ3Y4Q2V1a2k5OU1tR1lKVjlzeGVTUWYrL21i?=
 =?utf-8?B?S3gzbW9jUk9XVGxLalNxZm9tRFN2VUhNVTQzWnZyK1pULzRIa0NjVFArOXFT?=
 =?utf-8?B?MlpHOGc5a21KTWc1YXM0emplNVhUdTVuSWtNcStsbWgzVXNkTmRDUHVZaDND?=
 =?utf-8?B?ZXZoVEE1TlhCaU44aHhjUGM2ZkZVRW1yUzhySExvdnpkN3FiNHlyaFN4SGl6?=
 =?utf-8?B?d0t1c2pGb2F6ZGFtcS9MdnNaZVc1cnBMM0RDcWh4dnVDY213WGpEOFFGdm1a?=
 =?utf-8?B?YzQza21ZK1E0R1lTZFFCTzVvdllJRWZYdjdqRm5tYnVqTnE5NXh3TXBCNEVi?=
 =?utf-8?B?dnNzQnFJRjBnTW1Sc3BUVVJzSzh1VXp4MnAzQVhtbVRPUlBkU0xFZ2xVd0wz?=
 =?utf-8?B?R1IvYkI1N0I2dXQzRm9UMkI5MTBFb3pocTVsRXVXS0tTOVZHaEt5V3pxdTgv?=
 =?utf-8?B?YTdvZ3pOcDlTU0QrNGtFTy9YNDN0US9iN1FYenR6TFRaZTNjVEhUWWpSazFo?=
 =?utf-8?B?dWl5OXd4cURITlNQUm55RGd5L08vcnBHSjZpbHVCemRzaW5wTERKeExLSGhN?=
 =?utf-8?B?SWp6MVNJUUFYSU9ZQ1FuSlpoR29CZkd3TXZrTUFFd3Q5Rk52MDIxRjJPRDh6?=
 =?utf-8?B?RGhLZmQ0czJpQ3M1R1RyNHdXQThUdjJHeEhvbHFpWTB3cTBJblpSSzR3Y2xX?=
 =?utf-8?B?R202TXlqOW45V1NVZDRXWm1Pdmp0M0Uxb05EVUVpZFp1U29HTkxKNlFNd2g0?=
 =?utf-8?B?Ny9qdGEwQzJmN0hab1RKVFlISUc1WWlzVDAra1ExaFNpSmdnMTdML2dhdXJz?=
 =?utf-8?B?WlZRZFV5S2tMMTcremhsTTRibzUrT2cvanNBUEhTc2krRFY1NTd4VHV6VjhU?=
 =?utf-8?B?R0RrTzF0czdZbTlENnMzbk81eU5zZE9HYUxBZFZ4UnpRS0d1L2dVS2dhYWhF?=
 =?utf-8?B?aDhQNENLWGRBRkdzd3cxbm40R0x4SG91TVRpMmV5R3dxTHEvdE1aUW1SaFpZ?=
 =?utf-8?B?Nnl6LzdiSGtCZDEvaGxSVWNxb3ZycHJYY2s5OGRCUC9xTTVSZWdxbTYyb2ll?=
 =?utf-8?B?T3kzTUVZN2pMaytJcGpiazZmT3pTV1BDMDFxdjUzMlRRYVd1RktxbkFhUTZU?=
 =?utf-8?B?b296SlRuVy9FZUlZOHFlSmFiaHhYQUhYUVk0UTVITnpvMG5yZTZobVB1dDZ4?=
 =?utf-8?B?UmpnY3hteVA5T2oxVmlITm9UN0t0S3NSdStsR2tQdGZHT0p0bWQvUFdvK0R1?=
 =?utf-8?B?bDFjR3JpcjUzM2ViOWt2cGJYSnRja215djFncm1GamNvRHVmanpHenE3T0tn?=
 =?utf-8?B?QnJLamlYVDExam5NUHNHdDRvZGdpb2FKYysyYlljRWV5Z04xVmlHRWIwU29M?=
 =?utf-8?B?cGEwaTZWamp5bWNBYXVLYW9HeTN5NkdCYVp5MlFha2hsb1lMSHp3bU9KUEsx?=
 =?utf-8?B?SFBZOGVWTGZTOTd5VmFSZk1JYkpvVldwZVdtSzBsNWZMb1FtcFh4SC9FTDJK?=
 =?utf-8?B?V3FhUXE0aXZUaDljaWtsM2dhQkpBd2cwY2xNcW5EMVZnd083aTM4WEdrN2RI?=
 =?utf-8?B?ZVVwWGNlbFBOOGFNL0ozbWJMdDdsZDhhUnZpUjhGRm5tZGloSEQyN2taSnZ4?=
 =?utf-8?B?b1VRU3M0UG5wMnJIdWo5Y2FEL2Z2N0tQMzhyREpOSXdZeXF1WktRNWg0YlJK?=
 =?utf-8?Q?7zW5Q2QEfzlh2LudkCUBqXFIh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa98496b-3c33-47a4-e5d7-08dafb0686de
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 16:51:08.1539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8iF0Xbjc+89VeGCRewZIwhBzYBoQmQN+02+EktyR3s8M+maabsBA4S+96854xJMzsZU0OMacuyj8gBTV81NPEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5215
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/2023 5:59 PM, Kalra, Ashish wrote:
> Hello Jeremi,
> 
> On 1/18/2023 9:55 AM, Jeremi Piotrowski wrote:
>> On Wed, Dec 14, 2022 at 01:40:06PM -0600, Michael Roth wrote:
>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>
>>> The memory integrity guarantees of SEV-SNP are enforced through a new
>>> structure called the Reverse Map Table (RMP). The RMP is a single data
>>> structure shared across the system that contains one entry for every 4K
>>> page of DRAM that may be used by SEV-SNP VMs. The goal of RMP is to
>>> track the owner of each page of memory. Pages of memory can be owned by
>>> the hypervisor, owned by a specific VM or owned by the AMD-SP. See APM2
>>> section 15.36.3 for more detail on RMP.
>>>
>>> The RMP table is used to enforce access control to memory. The table 
>>> itself
>>> is not directly writable by the software. New CPU instructions 
>>> (RMPUPDATE,
>>> PVALIDATE, RMPADJUST) are used to manipulate the RMP entries.
>>>
>>> Based on the platform configuration, the BIOS reserves the memory used
>>> for the RMP table. The start and end address of the RMP table must be
>>> queried by reading the RMP_BASE and RMP_END MSRs. If the RMP_BASE and
>>> RMP_END are not set then disable the SEV-SNP feature.
>>>
>>> The SEV-SNP feature is enabled only after the RMP table is successfully
>>> initialized.
>>>
>>> Also set SYSCFG.MFMD when enabling SNP as SEV-SNP FW >= 1.51 requires
>>> that SYSCFG.MFMD must be se
>>>
>>> RMP table entry format is non-architectural and it can vary by processor
>>> and is defined by the PPR. Restrict SNP support on the known CPU model
>>> and family for which the RMP table entry format is currently defined 
>>> for.
>>>
>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>> Signed-off-b: Ashish Kalra <ashish.kalra@amd.com>
>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>> ---
>>>   arch/x86/include/asm/disabled-features.h |   8 +-
>>>   arch/x86/include/asm/msr-index.h         |  11 +-
>>>   arch/x86/kernel/sev.c                    | 180 +++++++++++++++++++++++
>>>   3 files changed, 197 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/disabled-features.h 
>>> b/arch/x86/include/asm/disabled-features.h
>>> index 33d2cd04d254..9b5a2cc8064a 100644
>>> --- a/arch/x86/include/asm/disabled-features.h
>>> +++ b/arch/x86/include/asm/disabled-features.h
>>> @@ -87,6 +87,12 @@
>>>   # define DISABLE_TDX_GUEST    (1 << (X86_FEATURE_TDX_GUEST & 31))
>>>   #endif
>>> +#ifdef CONFIG_AMD_MEM_ENCRYPT
>>> +# define DISABLE_SEV_SNP    0
>>> +#else
>>> +# define DISABLE_SEV_SNP    (1 << (X86_FEATURE_SEV_SNP & 31))
>>> +#endif
>>> +
>>>   /*
>>>    * Make sure to add features to the correct mask
>>>    */
>>> @@ -110,7 +116,7 @@
>>>                DISABLE_ENQCMD)
>>>   #define DISABLED_MASK17    0
>>>   #define DISABLED_MASK18    0
>>> -#define DISABLED_MASK19    0
>>> +#define DISABLED_MASK19    (DISABLE_SEV_SNP)
>>>   #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
>>>   #endif /* _ASM_X86_DISABLED_FEATURES_H */
>>> diff --git a/arch/x86/include/asm/msr-index.h 
>>> b/arch/x86/include/asm/msr-index.h
>>> index 10ac52705892..35100c630617 100644
>>> --- a/arch/x86/include/asm/msr-index.h
>>> +++ b/arch/x86/include/asm/msr-index.h
>>> @@ -565,6 +565,8 @@
>>>   #define MSR_AMD64_SEV_ENABLED        
>>> BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
>>>   #define MSR_AMD64_SEV_ES_ENABLED    
>>> BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
>>>   #define MSR_AMD64_SEV_SNP_ENABLED    
>>> BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
>>> +#define MSR_AMD64_RMP_BASE        0xc0010132
>>> +#define MSR_AMD64_RMP_END        0xc0010133
>>>   #define MSR_AMD64_VIRT_SPEC_CTRL    0xc001011f
>>> @@ -649,7 +651,14 @@
>>>   #define MSR_K8_TOP_MEM2            0xc001001d
>>>   #define MSR_AMD64_SYSCFG        0xc0010010
>>>   #define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT    23
>>> -#define MSR_AMD64_SYSCFG_MEM_ENCRYPT    
>>> BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
>>> +#define MSR_AMD64_SYSCFG_MEM_ENCRYPT        
>>> BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
>>> +#define MSR_AMD64_SYSCFG_SNP_EN_BIT        24
>>> +#define MSR_AMD64_SYSCFG_SNP_EN        
>>> BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
>>> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT    25
>>> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN        
>>> BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)
>>> +#define MSR_AMD64_SYSCFG_MFDM_BIT        19
>>> +#define MSR_AMD64_SYSCFG_MFDM            
>>> BIT_ULL(MSR_AMD64_SYSCFG_MFDM_BIT)
>>> +
>>>   #define MSR_K8_INT_PENDING_MSG        0xc0010055
>>>   /* C1E active bits in int pending message */
>>>   #define K8_INTP_C1E_ACTIVE_MASK        0x18000000
>>> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
>>> index a428c62330d3..687a91284506 100644
>>> --- a/arch/x86/kernel/sev.c
>>> +++ b/arch/x86/kernel/sev.c
>>> @@ -22,6 +22,9 @@
>>>   #include <linux/efi.h>
>>>   #include <linux/platform_device.h>
>>>   #include <linux/io.h>
>>> +#include <linux/cpumask.h>
>>> +#include <linux/iommu.h>
>>> +#include <linux/amd-iommu.h>
>>>   #include <asm/cpu_entry_area.h>
>>>   #include <asm/stacktrace.h>
>>> @@ -38,6 +41,7 @@
>>>   #include <asm/apic.h>
>>>   #include <asm/cpuid.h>
>>>   #include <asm/cmdline.h>
>>> +#include <asm/iommu.h>
>>>   #define DR7_RESET_VALUE        0x400
>>> @@ -57,6 +61,12 @@
>>>   #define AP_INIT_CR0_DEFAULT        0x60000010
>>>   #define AP_INIT_MXCSR_DEFAULT        0x1f80
>>> +/*
>>> + * The first 16KB from the RMP_BASE is used by the processor for the
>>> + * bookkeeping, the range needs to be added during the RMP entry 
>>> lookup.
>>> + */
>>> +#define RMPTABLE_CPU_BOOKKEEPING_SZ    0x4000
>>> +
>>>   /* For early boot hypervisor communication in SEV-ES enabled guests */
>>>   static struct ghcb boot_ghcb_page __bss_decrypted 
>>> __aligned(PAGE_SIZE);
>>> @@ -69,6 +79,9 @@ static struct ghcb *boot_ghcb __section(".data");
>>>   /* Bitmap of SEV features supported by the hypervisor */
>>>   static u64 sev_hv_features __ro_after_init;
>>> +static unsigned long rmptable_start __ro_after_init;
>>> +static unsigned long rmptable_end __ro_after_init;
>>> +
>>>   /* #VC handler runtime per-CPU data */
>>>   struct sev_es_runtime_data {
>>>       struct ghcb ghcb_page;
>>> @@ -2260,3 +2273,170 @@ static int __init snp_init_platform_device(void)
>>>       return 0;
>>>   }
>>>   device_initcall(snp_init_platform_device);
>>> +
>>> +#undef pr_fmt
>>> +#define pr_fmt(fmt)    "SEV-SNP: " fmt
>>> +
>>> +static int __mfd_enable(unsigned int cpu)
>>> +{
>>> +    u64 val;
>>> +
>>> +    if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>>> +        return 0;
>>> +
>>> +    rdmsrl(MSR_AMD64_SYSCFG, val);
>>> +
>>> +    val |= MSR_AMD64_SYSCFG_MFDM;
>>> +
>>> +    wrmsrl(MSR_AMD64_SYSCFG, val);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static __init void mfd_enable(void *arg)
>>> +{
>>> +    __mfd_enable(smp_processor_id());
>>> +}
>>> +
>>> +static int __snp_enable(unsigned int cpu)
>>> +{
>>> +    u64 val;
>>> +
>>> +    if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>>> +        return 0;
>>> +
>>> +    rdmsrl(MSR_AMD64_SYSCFG, val);
>>> +
>>> +    val |= MSR_AMD64_SYSCFG_SNP_EN;
>>> +    val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
>>> +
>>> +    wrmsrl(MSR_AMD64_SYSCFG, val);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static __init void snp_enable(void *arg)
>>> +{
>>> +    __snp_enable(smp_processor_id());
>>> +}
>>> +
>>> +static bool get_rmptable_info(u64 *start, u64 *len)
>>> +{
>>> +    u64 calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
>>> +
>>> +    rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
>>> +    rdmsrl(MSR_AMD64_RMP_END, rmp_end);
>>> +
>>> +    if (!rmp_base || !rmp_end) {
>>> +        pr_err("Memory for the RMP table has not been reserved by 
>>> BIOS\n");
>>> +        return false;
>>> +    }
>>> +
>>> +    rmp_sz = rmp_end - rmp_base + 1;
>>> +
>>> +    /*
>>> +     * Calculate the amount the memory that must be reserved by the 
>>> BIOS to
>>> +     * address the whole RAM. The reserved memory should also cover the
>>> +     * RMP table itself.
>>> +     */
>>> +    calc_rmp_sz = (((rmp_sz >> PAGE_SHIFT) + totalram_pages()) << 4) 
>>> + RMPTABLE_CPU_BOOKKEEPING_SZ;
>>
>> Since the rmptable is indexed by page number, I believe this check 
>> should be
>> using max_pfn:
>>
>>      calc_rmp_sz = (max_pfn << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
>>
>> This accounts for holes/offsets in the memory map which lead to the 
>> top of
>> memory having pfn > totalram_pages().
>>
> 
> I agree that this check should use max. addressable pfn to account for 
> holes in the physical address map. The BIOS will probably also be 
> computing RMP table size to cover the entire physical memory, which 
> should be max. addressable PFN.
> 
> But, then we primarly need to check that all available RAM pages are 
> covered by the RMP table, so the above check is sufficient for that, 
> right ?
> 
> Also, i assume that max_pfn will take into account any hotplugged memory 
> as i do know that totalram_pages() handles hotplugged memory.
> 

But essentially you are correct, as RMP table is indexed by PFN, we have 
to take into account these physical memory holes so that we can have 
entries for the max DRAM SPA, so i will fix this to use the max. 
addressable PFN, i.e., max_pfn.

Thanks,
Ashish

> 
>>> +
>>> +    if (calc_rmp_sz > rmp_sz) {
>>> +        pr_err("Memory reserved for the RMP table does not cover 
>>> full system RAM (expected 0x%llx got 0x%llx)\n",
>>> +               calc_rmp_sz, rmp_sz);
>>> +        return false;
>>> +    }
>>> +
>>> +    *start = rmp_base;
>>> +    *len = rmp_sz;
>>> +
>>> +    pr_info("RMP table physical address [0x%016llx - 0x%016llx]\n", 
>>> rmp_base, rmp_end);
>>> +
>>> +    return true;
>>> +}
>>> +
