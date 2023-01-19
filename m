Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995686747BD
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 01:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjATAAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 19:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjATAAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 19:00:21 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4211A3172;
        Thu, 19 Jan 2023 15:59:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HETXra6MRfl+J/41Y19XPT60K4+M0TqTOQpToYtU03o+WJT/i+JeyR1u2mJdAhWlC7CWDG+UI0qO4fFXwTvwc0cwlxsMWGFKowdC5OlSCdPttZn6H9L9mFF9fZY8/ZCGireyXM5vcn3z5X33ssltnSlZlPyFEVplf7/QDHJjnjwB4azEHBZ1/Fo2XZzojBbZsNRadTE9JF80r22cD4K0jsAYxMwE997EmG1dtTvs1SbsBnq/oQpSshyXIcY0mbE0t9TF2RxVPmm6V3D5X838h5rqUgeDzoaVuDa8e12ZsR4rZQUAPDvq+2hZ00tE4Veea2tG3iSvishHQ2aTiJ36+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DsdydGFy4ZFV0BlNDm0Bj2ev35qfS3MjhmfwjHCj//U=;
 b=lrIYHQRNhKaJILRcOh6XFW8aTg3ugTdgUljDxXkvHO/iCEjJFO/EbeGDIPuJZ9pO3H2I9l0e1MhXiNpaDMCGsmMmoFKbWOT4MLpQwl84rAW1yeD+VpOxEKtmhycI8Bxnvu7JsW2x3+mTrd5sQl8duNE6WMOpu8B1fGbIKgjq6ltDqGRLCGJlhKFelpps3Va2BnXDkdEeTsttrnEtVD3RIZw/iP/VAMpGRuZ6IpEeUMKwkHfXWAX0YhWxu7xA2dGgmvRdADGG4mTx1SSniL+r54EEQxVaKYDIf2T+TmCr1M68n/UVQ+xkrb9z/qjlgwGoSsOmAW2uCpL4+vVqnjnf0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DsdydGFy4ZFV0BlNDm0Bj2ev35qfS3MjhmfwjHCj//U=;
 b=h4N6rLAleyIKXOzbio+rMKKRrEmF3V4GeKmyAvdaEFb1enlJyio0RPiW+mQizIPbCqV7JpIkuGExi5pJyO9EAZMGG91KKIEU3snGIPPI//bAQWOOZugJoFixzZ0wCsc5I/lQB3zOy1irjaRm1aWsnAHPXVjTUeP56aTmTRuALoE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Thu, 19 Jan
 2023 23:59:12 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5986.023; Thu, 19 Jan 2023
 23:59:12 +0000
Message-ID: <2f786856-982a-1012-f680-9a6c5faee6ea@amd.com>
Date:   Thu, 19 Jan 2023 17:59:05 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 14/64] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
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
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20230118155502.GB24742@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:208:335::10) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SA0PR12MB4447:EE_
X-MS-Office365-Filtering-Correlation-Id: ebeb8d1c-60b0-43cc-f4f8-08dafa792997
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RzAr1NAFq+rcM6Lnk+BVnYOvnerxvDXHi8qf1N2RBSEMDE8jMaVIAnKK8w6lp+L2AkmfrJnOBuPuQCY65WIIXz/oiL82cjueA2HFPtgvWtIPVvP9CyJy7k9vcT5EMlzl+pFLKjtQvfEuD55thbFEnze9sn6ccn7Av0h3NgNxn3dsflrO/f8gWODrYYzo+n1rv4s7gnKx53wLUxUBX/BcJNIxJojxvlTm1CdfZ2HuQcJldPIlEB1Pp2RcBroW5SKmCVmG4mxu3Q4Qx5iBsaSsq4PceeyEWPKapYHvj178huZ+cAaxVbYt88cyKRug0dlp3RyTc5xgWoMSlz1LrPloTZbNH9dMrBoFJ2VsMkqsBdNzSLLF3YTdVmKYm9EgWHqBV3K9SxBPdq8IYcHJ4bMkj08rtRlFLb3GPh8NpYq18Z2y1ohKeFzLHZBy0mgaLaqfgs9CPLfEbxu+vqRioUokYaHNLO2PZbD5rh0e9kfPNeRVCGM/JgAlxSkATSIWCiG7NXxwZbh/FOCF8URQaBMhz1zdWSBg7uUiQkCbenFt/TmorfQ8yG2JqK/FiRF9gBORSTJYKIANj6r5/HYLtRvOM7AGC56WaQGTlbjoYk3AQMOQSqCjYgoQeNbAdFgcKbz7qyVEKiFWB4hTG4mX753ma6f6dUgO7SimWNzmIQNvFIKhHCGCxqG9AfeXUeuGRfbmt2NZpZEw9IhwqbMcXR55ykRNPOLQw5z02NsDXdkdNAk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199015)(2616005)(41300700001)(36756003)(5660300002)(7406005)(8936002)(7416002)(316002)(66556008)(66476007)(8676002)(66946007)(4326008)(26005)(186003)(6512007)(38100700002)(31696002)(86362001)(2906002)(83380400001)(478600001)(6506007)(6666004)(31686004)(6486002)(110136005)(6636002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Kyt5VzZKVjZ3Sk9BWjFDMzNTYStQN3kvcWd3ZitHbUsxT3dlbjNwcXVsam9S?=
 =?utf-8?B?QXA3cWMxWEc5dEhKcEZLa3MvaXd6NFRiNWkwd0oyVFU0MTJFTUhjZ2xmNHR6?=
 =?utf-8?B?ajYxc21xRGloK0V5a2x3VzBqekVZa0RQTW5pZG5BTjV3NStTSm5pMUVoenlm?=
 =?utf-8?B?enNhZ1ZOYmhRSEdkMWZaNHJHdVRSR1M1ZG5TNlRoTyt5VUFrVWV4NFBWT2pD?=
 =?utf-8?B?REpOMzFSdWlZV1pFdWo4THd5ampGM2Z5Y2NYRTc2dVFwYVhJRk05TGZoK0cr?=
 =?utf-8?B?ZFd3VVJtUVF4cS8vb09vcjJtcCtmL083MXpHQzRoZlZWb2RubVorN0ZnU1lU?=
 =?utf-8?B?Njhzek5aeU84eXZnSjgxMVlBeFQyV0szOTNyaHZsSk00SCtHSzQxK3hsVHYx?=
 =?utf-8?B?eFRheEpVaTk5SXdZVVBLd2JPSjNvTzRlTWJxYlNoL05tcnJ5VWF4Y09hTnlG?=
 =?utf-8?B?czFudDcxVFgzUnlWSlEvZGFmblk3K2JBczVBSWR3d2l2YmRLakx1WkYrS3JQ?=
 =?utf-8?B?MjZUQ3kwUEEycHM2SGQvRVc1NDRkenV0WlovTzgzdWd5Tkova3c5eFBvcHJC?=
 =?utf-8?B?MkZXMDI3ZGFzVFBqODlZZEM1S0F0TWdPOU5zYmdpR3ExaUdDUm03T3lxSHpE?=
 =?utf-8?B?Rjd2SUJpYkZBRXo1QUkwS0U2cE0zR0Z6OEtIaGJ3Vk9uQjNzUXhTM1B3Rzdn?=
 =?utf-8?B?Q0MzYlp3LzQ4dmJWQ2p3WGlBYXloYUx5QjZXa2tISEx3T2sya1o4NVpKcUFO?=
 =?utf-8?B?SUZuWlJVOEZFNzZOQmpUUDd1QUgrYzNERjdYQjZXOEw1MXlYd0UwTmEwbytJ?=
 =?utf-8?B?Nnl4WTdqZWprcVViTWYrN0FlTGUyKytjTXQxQ0lkWmJxcmNoZWkya25LNWpH?=
 =?utf-8?B?WkNHWUNLdHZXeVZuUUZvRmo2SWRBbWQ0T2FtT3RuUmt3d20zdlZxeFhVaUVY?=
 =?utf-8?B?alpmSklLTnkzUXVnejJ4ZndROXRhemJJZDNud2F5N3duaGZYVk9uclR1Zm5C?=
 =?utf-8?B?ZGpvcnRWdWJTUjkrOXVzZzArZnN5T1k1aGpLK3lmTG90Y0xxSXMrTExyWUQr?=
 =?utf-8?B?M2tZcEZkMkIwSDRML2VDSTZqNTlKVWJuUFpJWjVCcFdyam1XSENweTlkOGdI?=
 =?utf-8?B?SGJhMm1XeGZZQVR4dzIvOUw4L2ZBYjVwRk0zS3lZVXNwNFkvUDJoL2tHRlJL?=
 =?utf-8?B?OW9rd1NaS2R3Q2IvNlJDMEk0akpvYlJkbVhrZVNYNG9JOWxhRG9tRnJmL01y?=
 =?utf-8?B?ZWs2c2JTMXdxbzJicjNPTUVucUxPdy83ZzNsRmlrWkd3a1BtVjVmbUIvUWpY?=
 =?utf-8?B?eWpDRlBSeWpVclVmZmd3QjJqZnJwT1JDalI0MjFBSy9oUlBiaTJldlhzQ0sx?=
 =?utf-8?B?VDl4aEhoTEZEV2s3UWdqZEJyV1N2RnJzcld0RkJZSmJuaXJCWEFURG5XVXdu?=
 =?utf-8?B?bFliOUJJa0NaTDNJVzRCTWJMWDJncDBIK1V0bnlmQVdGVWJsckdaSVlLMkcv?=
 =?utf-8?B?N21UUVIycHhHbUJCdkFLOUhjYzM5ZGtNRjR4akVMRWJZYS9uQlBVcWNkWDRE?=
 =?utf-8?B?aFFmZ2M5WU8vdGtibGNySUJsdkM0VkZHcG9uS0xZTWhBNkdURE8xWlpWeWdR?=
 =?utf-8?B?NWppYjdhRFRuZWhubnpBWmZiMk44VEdmQ2tic2ZrSGVIaVpaTEdxc1hCbWZq?=
 =?utf-8?B?NFlQS2lsY01JeTNzd3RpT2tGbndmZTJEUHpqU1ZibXVvOHVHNkNVWDU5Nnps?=
 =?utf-8?B?bGU5SFBQaDNrbmFwWmt5a29MTHVlcEtJampXN0w3S0w1aDBiaWJRY3ZhbGk3?=
 =?utf-8?B?NkZlUmZXYkw3R2hnV1dyNnF5a2V3SGRXMld6eDRwQWIxNEk0WE0xYkY1NCti?=
 =?utf-8?B?Zml2Z1crYlBnc2YweVhJRjAwaHErcEppQkdYbFhrcjdjYXZ3Ni9Wck9FbVY3?=
 =?utf-8?B?NlpCQlBhMXJEcTQ3QnFvYnR5WEFLWU1rbk9FZWFvVnAxY29sVXNHRHRzaXIz?=
 =?utf-8?B?cnRoTmdrenEwc0FtWHJuUTU0bGtiTlVmazg0c1JQd2x5d2ljbU9JMkFkZ3BY?=
 =?utf-8?B?RHBFWmZXK3VMbzhyek9uQ1drenliSVUrOXlibXphWTMxZm8wSEo1RG5mV2pS?=
 =?utf-8?Q?196rMZAwOBDTr/0lDODac63XV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebeb8d1c-60b0-43cc-f4f8-08dafa792997
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 23:59:12.3563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EqauPo4RXJoEG+lpi8BTKLH8BNfzHBtlUGyaOlNFeMH8Pw4QPeU5dJbEN5HtKHoaAn167zQJB+Y29KPCVR0Zpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4447
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Jeremi,

On 1/18/2023 9:55 AM, Jeremi Piotrowski wrote:
> On Wed, Dec 14, 2022 at 01:40:06PM -0600, Michael Roth wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> The memory integrity guarantees of SEV-SNP are enforced through a new
>> structure called the Reverse Map Table (RMP). The RMP is a single data
>> structure shared across the system that contains one entry for every 4K
>> page of DRAM that may be used by SEV-SNP VMs. The goal of RMP is to
>> track the owner of each page of memory. Pages of memory can be owned by
>> the hypervisor, owned by a specific VM or owned by the AMD-SP. See APM2
>> section 15.36.3 for more detail on RMP.
>>
>> The RMP table is used to enforce access control to memory. The table itself
>> is not directly writable by the software. New CPU instructions (RMPUPDATE,
>> PVALIDATE, RMPADJUST) are used to manipulate the RMP entries.
>>
>> Based on the platform configuration, the BIOS reserves the memory used
>> for the RMP table. The start and end address of the RMP table must be
>> queried by reading the RMP_BASE and RMP_END MSRs. If the RMP_BASE and
>> RMP_END are not set then disable the SEV-SNP feature.
>>
>> The SEV-SNP feature is enabled only after the RMP table is successfully
>> initialized.
>>
>> Also set SYSCFG.MFMD when enabling SNP as SEV-SNP FW >= 1.51 requires
>> that SYSCFG.MFMD must be se
>>
>> RMP table entry format is non-architectural and it can vary by processor
>> and is defined by the PPR. Restrict SNP support on the known CPU model
>> and family for which the RMP table entry format is currently defined for.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-b: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   arch/x86/include/asm/disabled-features.h |   8 +-
>>   arch/x86/include/asm/msr-index.h         |  11 +-
>>   arch/x86/kernel/sev.c                    | 180 +++++++++++++++++++++++
>>   3 files changed, 197 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
>> index 33d2cd04d254..9b5a2cc8064a 100644
>> --- a/arch/x86/include/asm/disabled-features.h
>> +++ b/arch/x86/include/asm/disabled-features.h
>> @@ -87,6 +87,12 @@
>>   # define DISABLE_TDX_GUEST	(1 << (X86_FEATURE_TDX_GUEST & 31))
>>   #endif
>>   
>> +#ifdef CONFIG_AMD_MEM_ENCRYPT
>> +# define DISABLE_SEV_SNP	0
>> +#else
>> +# define DISABLE_SEV_SNP	(1 << (X86_FEATURE_SEV_SNP & 31))
>> +#endif
>> +
>>   /*
>>    * Make sure to add features to the correct mask
>>    */
>> @@ -110,7 +116,7 @@
>>   			 DISABLE_ENQCMD)
>>   #define DISABLED_MASK17	0
>>   #define DISABLED_MASK18	0
>> -#define DISABLED_MASK19	0
>> +#define DISABLED_MASK19	(DISABLE_SEV_SNP)
>>   #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
>>   
>>   #endif /* _ASM_X86_DISABLED_FEATURES_H */
>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>> index 10ac52705892..35100c630617 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -565,6 +565,8 @@
>>   #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
>>   #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
>>   #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
>> +#define MSR_AMD64_RMP_BASE		0xc0010132
>> +#define MSR_AMD64_RMP_END		0xc0010133
>>   
>>   #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
>>   
>> @@ -649,7 +651,14 @@
>>   #define MSR_K8_TOP_MEM2			0xc001001d
>>   #define MSR_AMD64_SYSCFG		0xc0010010
>>   #define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT	23
>> -#define MSR_AMD64_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
>> +#define MSR_AMD64_SYSCFG_MEM_ENCRYPT		BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
>> +#define MSR_AMD64_SYSCFG_SNP_EN_BIT		24
>> +#define MSR_AMD64_SYSCFG_SNP_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
>> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT	25
>> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)
>> +#define MSR_AMD64_SYSCFG_MFDM_BIT		19
>> +#define MSR_AMD64_SYSCFG_MFDM			BIT_ULL(MSR_AMD64_SYSCFG_MFDM_BIT)
>> +
>>   #define MSR_K8_INT_PENDING_MSG		0xc0010055
>>   /* C1E active bits in int pending message */
>>   #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
>> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
>> index a428c62330d3..687a91284506 100644
>> --- a/arch/x86/kernel/sev.c
>> +++ b/arch/x86/kernel/sev.c
>> @@ -22,6 +22,9 @@
>>   #include <linux/efi.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/io.h>
>> +#include <linux/cpumask.h>
>> +#include <linux/iommu.h>
>> +#include <linux/amd-iommu.h>
>>   
>>   #include <asm/cpu_entry_area.h>
>>   #include <asm/stacktrace.h>
>> @@ -38,6 +41,7 @@
>>   #include <asm/apic.h>
>>   #include <asm/cpuid.h>
>>   #include <asm/cmdline.h>
>> +#include <asm/iommu.h>
>>   
>>   #define DR7_RESET_VALUE        0x400
>>   
>> @@ -57,6 +61,12 @@
>>   #define AP_INIT_CR0_DEFAULT		0x60000010
>>   #define AP_INIT_MXCSR_DEFAULT		0x1f80
>>   
>> +/*
>> + * The first 16KB from the RMP_BASE is used by the processor for the
>> + * bookkeeping, the range needs to be added during the RMP entry lookup.
>> + */
>> +#define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
>> +
>>   /* For early boot hypervisor communication in SEV-ES enabled guests */
>>   static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
>>   
>> @@ -69,6 +79,9 @@ static struct ghcb *boot_ghcb __section(".data");
>>   /* Bitmap of SEV features supported by the hypervisor */
>>   static u64 sev_hv_features __ro_after_init;
>>   
>> +static unsigned long rmptable_start __ro_after_init;
>> +static unsigned long rmptable_end __ro_after_init;
>> +
>>   /* #VC handler runtime per-CPU data */
>>   struct sev_es_runtime_data {
>>   	struct ghcb ghcb_page;
>> @@ -2260,3 +2273,170 @@ static int __init snp_init_platform_device(void)
>>   	return 0;
>>   }
>>   device_initcall(snp_init_platform_device);
>> +
>> +#undef pr_fmt
>> +#define pr_fmt(fmt)	"SEV-SNP: " fmt
>> +
>> +static int __mfd_enable(unsigned int cpu)
>> +{
>> +	u64 val;
>> +
>> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>> +		return 0;
>> +
>> +	rdmsrl(MSR_AMD64_SYSCFG, val);
>> +
>> +	val |= MSR_AMD64_SYSCFG_MFDM;
>> +
>> +	wrmsrl(MSR_AMD64_SYSCFG, val);
>> +
>> +	return 0;
>> +}
>> +
>> +static __init void mfd_enable(void *arg)
>> +{
>> +	__mfd_enable(smp_processor_id());
>> +}
>> +
>> +static int __snp_enable(unsigned int cpu)
>> +{
>> +	u64 val;
>> +
>> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>> +		return 0;
>> +
>> +	rdmsrl(MSR_AMD64_SYSCFG, val);
>> +
>> +	val |= MSR_AMD64_SYSCFG_SNP_EN;
>> +	val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
>> +
>> +	wrmsrl(MSR_AMD64_SYSCFG, val);
>> +
>> +	return 0;
>> +}
>> +
>> +static __init void snp_enable(void *arg)
>> +{
>> +	__snp_enable(smp_processor_id());
>> +}
>> +
>> +static bool get_rmptable_info(u64 *start, u64 *len)
>> +{
>> +	u64 calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
>> +
>> +	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
>> +	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
>> +
>> +	if (!rmp_base || !rmp_end) {
>> +		pr_err("Memory for the RMP table has not been reserved by BIOS\n");
>> +		return false;
>> +	}
>> +
>> +	rmp_sz = rmp_end - rmp_base + 1;
>> +
>> +	/*
>> +	 * Calculate the amount the memory that must be reserved by the BIOS to
>> +	 * address the whole RAM. The reserved memory should also cover the
>> +	 * RMP table itself.
>> +	 */
>> +	calc_rmp_sz = (((rmp_sz >> PAGE_SHIFT) + totalram_pages()) << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
> 
> Since the rmptable is indexed by page number, I believe this check should be
> using max_pfn:
> 
>      calc_rmp_sz = (max_pfn << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
> 
> This accounts for holes/offsets in the memory map which lead to the top of
> memory having pfn > totalram_pages().
> 

I agree that this check should use max. addressable pfn to account for 
holes in the physical address map. The BIOS will probably also be 
computing RMP table size to cover the entire physical memory, which 
should be max. addressable PFN.

But, then we primarly need to check that all available RAM pages are 
covered by the RMP table, so the above check is sufficient for that, right ?

Also, i assume that max_pfn will take into account any hotplugged memory 
as i do know that totalram_pages() handles hotplugged memory.

Thanks,
Ashish

>> +
>> +	if (calc_rmp_sz > rmp_sz) {
>> +		pr_err("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
>> +		       calc_rmp_sz, rmp_sz);
>> +		return false;
>> +	}
>> +
>> +	*start = rmp_base;
>> +	*len = rmp_sz;
>> +
>> +	pr_info("RMP table physical address [0x%016llx - 0x%016llx]\n", rmp_base, rmp_end);
>> +
>> +	return true;
>> +}
>> +
