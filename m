Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5D169FF69
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 00:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbjBVX1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 18:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBVX13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 18:27:29 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2087.outbound.protection.outlook.com [40.107.102.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F898460A0;
        Wed, 22 Feb 2023 15:27:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5dp9wcV6/tu/CXlnhzjvxYIxTEcVSQNcEsGPJh4Auyp/UaPvSJc3/RAuMAC+a0ZNI7WgVZ4w/o3WiI1qWw/Lkb0sJlTA8Kve0y7aC69e2aKwA7D9Hw6KAXJ5fyEo3Jy33JAZEK9nmZEUcYq8W0b1nm1abNji4QxbWbzBdtmvXZ9KMRx+aTGn+3Q5CkQB/b/M8a4CpfHPbaxW74Bczmr6aCQBhnmoFLSTeq7cAtPjCfStNVe0q9cIJEEwq4AMVA9z6eCsXYkxsAPxDp84uoMrFdsUWPGgEkDsOWDZ6eng9R+cnPQh/RTyE37qbSw5UjNDrMq5fI+LZul2Fy4DD6drg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjnxTOTnWfHD4VMqEEOJ/wG2ku05IRUYrD1CwLJcWuM=;
 b=inKMvf00IC+gUiXL8t4RG3qcA08XlaGbP3TpccTzaSsuiyfistjQcFA0A2iQ6LnnA6G9UpWKbI3asSXaHEf3HHl1Kl/tJHN6depI9N9u6ZvWm3JM7xlIBLLMEUfsaI0e8J2QKaenEDeX3cqQTeECgqlKAueX5r1hv+HqjVl5l5aP4r5usao3+ampAOLPmSG8cdww7auGrpVN72sHvLtYBULgo0MQXlwhE1hTh6UvElSBvnf51hSfCr06jOdtuC1S+WboomVwTKA9/0mM7cmZwuY7ByRviasS4E45Bfe2GtRviH44PKuMZW93kf+MUh0YMoQdSOcdG0PL0fqSGABBvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjnxTOTnWfHD4VMqEEOJ/wG2ku05IRUYrD1CwLJcWuM=;
 b=CrzpnZUOOa+lBBnUhMsqPdC4imzesSysCE1xjE2gM5YLcCHJyvSrSJYbdSTXy5wRLyEPEJCThI5iI4olXIDG3lbJeWjBPzpCMc0hx1DoJCcwedGlezhNLIXUxegyN/qUEeU8moYsYg34vn/78ak5Izmi5BDzOedTu6Z22ph30ic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM4PR12MB5770.namprd12.prod.outlook.com (2603:10b6:8:61::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 23:27:25 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3%7]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 23:27:25 +0000
Message-ID: <a5e18a33-3012-de13-705d-9c69c9acedab@amd.com>
Date:   Wed, 22 Feb 2023 17:27:18 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v8 10/56] x86/cpufeatures: Add SEV-SNP CPU feature
Content-Language: en-US
To:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        nikunj.dadhania@amd.com, Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-11-michael.roth@amd.com>
 <856ded9e-facd-fe6d-2f71-bb0cf5b1d546@linux.intel.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <856ded9e-facd-fe6d-2f71-bb0cf5b1d546@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR20CA0005.namprd20.prod.outlook.com
 (2603:10b6:610:58::15) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM4PR12MB5770:EE_
X-MS-Office365-Filtering-Correlation-Id: ad76a276-08e3-441c-8a3b-08db152c5a9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nuCbzd6Tg7MPedAInA3Mq0zxzHN/DSdeJ8BqhaAtR5bVbTAeyLCn8FsWxmOvERhJUT7tbWMlt7z+6m/+OXSg6TUj06K+4pkU/Qg7UrA3Bq+ppJ3RvGjv6pP9Eqm2PhlyuiT5B4Fep+X1o0OS5TRu4G6OkuszXb/DcgERA8AhF5m6SXQOAoh8VF9FpazgRPgWqLyhF2L7Cm4oqfPPAvyrulPJdoh7TcqlvS0nPdY1bNCfip4BeSa14VepZ8YVWCwziru3/MiUac0oYj/CcXgMKg3JSs5Cmw8gRdjiXsSstwb7saC2SAUqELNzse6l39gSZV6AIJ5JTaak8YnBfD5dAuH1YDQ57let+RyamnGECpeFAxcf+gxXM/G4cWDjs5d+aHenOOziAVRwFkdMdQ2KAQYyEwVcf7AbrUUUYA07rKy309na+K5AHGAd8v3kHqDVc3leVRoKHVZx4jhX2LLbKnKhCPnRY3IDICFnrcBctWx8r7MPSKmtiFvFqqY2xXSIRgt798hfrxojxWw5jOqvTRkiTKmZOKz4Xe9dtIZwbI6BPeWxYTRQEZZn93MnDt5yBSKakrQa0yDgR74Gn+aA5FIrDj+X78BFLlD8oDfRTAW0TYnlxG0TtHWji2llL3PGlnEgwqUa0c91urTS681dWVeOhoAoNJVHPnuRYjzz48Y+TItx1ffjUUUMc9jQwts45XdBPhNHYdmmDxVUBRWIxRQME+rSpzG0K8xP5qYUj8U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199018)(31696002)(31686004)(316002)(54906003)(110136005)(41300700001)(5660300002)(26005)(86362001)(478600001)(966005)(6486002)(8936002)(7406005)(7416002)(66476007)(4326008)(66946007)(8676002)(66556008)(2906002)(38100700002)(6512007)(6506007)(53546011)(6666004)(83380400001)(2616005)(36756003)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3UzNVdiMUVRUFBpK0JubHltMXNtd2ZFSi92ZXJJRDBXdUwrVTVoWWQ5ZDVG?=
 =?utf-8?B?anBhTHVVdEE2Z1lXN1RuUnlSVHBiemNMN0RJUGpzczRRRXk3d3N2bWRweVVi?=
 =?utf-8?B?WC9XM0ZzSEVKU3Uva2dVOEtQUGdWZGlKVnRyQkxuTUNwK2VVVU90Mk9ZbDlU?=
 =?utf-8?B?dVpjY3BrckV4djdJYlN1UzhFbVdyKzVWeFl5WWh4emdPZEZ3ZlNhV1RLazgv?=
 =?utf-8?B?cTdFYzhZbDQxRXpjT1YyS2g1Z0RBaHo2dGJaZ1JsSEROSm5HYllKN2VWaC9X?=
 =?utf-8?B?V3NtQzV3YmNML3IwQ0x1M0xFa3VTekRnclpCOHFwZExpcGVxUXd0L2FUem1Q?=
 =?utf-8?B?QWErV0ZLa0ZhNytmQjVsejVxTGFIK2x5MnUwTUFmTG91Q1lGQ0loL0hyanBR?=
 =?utf-8?B?eE5nNXhXMExmRHN0ZTdQUjFXVUpTUzg5aEl3bFFJUkY5MmlQUjNqTkdoSCt1?=
 =?utf-8?B?OTNyZnMzTDhIOEJhMmVIOUd6NFk3cDNwVTQzNDhQNHFFYXZqZGFTbnRMMGZE?=
 =?utf-8?B?L2xVK2w0UVEwSzZ5S3R6UElKNmNrNU9wY243TER6SUxNYzJPa09tOTFsSk1W?=
 =?utf-8?B?ODRUTnl5Uzhrb2lORDhQM20zZnlSRjNaN3p2WWFjZXpUMXhrYzEvSGF3d2Rp?=
 =?utf-8?B?VnJENUtqcExoekJEMTFTU1V2QUx2NlM0NDk1bHFiblA0YWcydkRQSDlFWFdV?=
 =?utf-8?B?WkNibEdwNUVKcGlSR3I3Rk1mL2dPSVB1YTUrcFZqWnFPdXJEM1ZZdU1hZnVp?=
 =?utf-8?B?NVFBMUIzc1d2ZTEzeXdVZ3NCNGJqU3BIMFY2UXkveVpTUGh0TTFGeXVCWjlG?=
 =?utf-8?B?K2tka2VPaVhRcXZKU2RvZWlMcFRTanVibXNqVU5aRWZnOFppYXZrT0h6Zkt3?=
 =?utf-8?B?VkcwODBTOW8wTlZmalovZGZuZUNtb0hINnlXM0E5R3ZQUEVOa0xNdmp3aE5n?=
 =?utf-8?B?NUdDREVGclM5R3ZOeHhVcVQ2RXN5MGpBbERVenhPMUlMZlhTK3hXbTJaaFVP?=
 =?utf-8?B?eGFiVHNXMFRTWDQ3UExDMTNUZEJQYzVBR0tDZEtKcEU0Z2hPWUVTbFU2OUp1?=
 =?utf-8?B?VFFRU3pOUWlHUXI1TXA5Q2M1MWVHaFNkeWJNWVNjOFFYKzQyOVVZM21pdjJX?=
 =?utf-8?B?blFsRTRnM2kybWpkbWhObGF3UGpTb3hvdk9TdkRDZlc3ZkFEckc0bDRxbFI1?=
 =?utf-8?B?OWpKWjFhemF2cHZlenk0emk3dFZ6Y1pkUEp6SlcxS0FJWCsrZ0FKNVRyeXJI?=
 =?utf-8?B?QmtYbWJnNE9GeGdFVEs2azkvclBYclYwV3Buc2F4aHlidys5cWp0cHJTVXd0?=
 =?utf-8?B?ME44bnJzWTZyQkQ0dVVNYU1HSmlzWUhST3BSOW5kRHBxcW9HcWlGR0VTS2R3?=
 =?utf-8?B?Q0dBTFdHRkw1NnAyNU4rY3JqNmhBWXhCbjJxQ1pIWEd0ZU1sU2ZJODJoYnN2?=
 =?utf-8?B?Q1Q3Vlc2RlBOY3pRYkEvRjhpWVFGSWozN3NjYVUvdE5DdUUyR25MbnpTWEtU?=
 =?utf-8?B?YnF1TVM3UGs2M20wMlJCV0dUU3JQaCtIaEdCQmdBeHgzQm5hWG16WlNBWFJQ?=
 =?utf-8?B?YkowWnd0MkdqM2hWeXY0ZFkvQUlzQWZFbW4vbGhJRjAxVmg3dXIyalpSOGND?=
 =?utf-8?B?TWE5RnJrVFZ2NGlyem5oYTU3bFhiMjBXSmNUV01sQkNDMUtac0U0dVB0M0xN?=
 =?utf-8?B?SFRvOFFkR21rcWp2L2QzUGhZRUtkdGp4Znk1UjAyMXlTTm8zY1ZKVzU3WUNQ?=
 =?utf-8?B?Q2k4T2Fwb3ZJRGJ4UVdNSW5EOEhZZ1lmY0Z1Z3FMVm1OZnp5RmxqY2F4VGVt?=
 =?utf-8?B?dEdxVTEyM21xa3IrSm9COStoTloxbDRra3dCYVR3QkdhendkUjQ5MHBtQ2R3?=
 =?utf-8?B?cFk0UUVFMnM4UFZBYUFsRTcrTGxoRC81TDNHd0ZKUGVCMHQwWFNsYWEwMk1m?=
 =?utf-8?B?QWcvR3dvT09NNzlmdUVSTVZaem9FUU8vQ3l3dEZ3TWRhM0xJY2YyakR5Si9m?=
 =?utf-8?B?b0MvNndwY0NXQmR5d1hXbVBPcTM3cHNMK1pVWCtTakh0eEJUTEVsZkZ0Sm1l?=
 =?utf-8?B?UjQ2WXIxUHgxWUhCWGY4dTlwK3FzNXdQU0ozTDgzTWNJenBnY3plZUZtNTk2?=
 =?utf-8?Q?9ouPWzbdtx3e21f1URKJ6HzWy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad76a276-08e3-441c-8a3b-08db152c5a9a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 23:27:24.7910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWQpkmzfZjTb91RPK1qy7Ixo/ZyBOv79AJUrloVt5KA3uZB7f28BEhuI9i7mBb/hDu7+jsMh8cMj24S5NqW+Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5770
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/21/2023 3:21 PM, Sathyanarayanan Kuppuswamy wrote:
> 
> 
> On 2/20/23 10:38 AM, Michael Roth wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> Add CPU feature detection for Secure Encrypted Virtualization with
>> Secure Nested Paging. This feature adds a strong memory integrity
>> protection to help prevent malicious hypervisor-based attacks like
>> data replay, memory re-mapping, and more.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
>> Signed-off-by: Ashish Kalra <Ashish.Kalra@amd.com>
> 
> Too many signed-off-by's. Are you missing Co-developed-by?
> 
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   arch/x86/include/asm/cpufeatures.h       | 1 +
>>   arch/x86/kernel/cpu/amd.c                | 5 +++--
>>   tools/arch/x86/include/asm/cpufeatures.h | 1 +
>>   3 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index 1419c4e04d45..480b4eaef310 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -420,6 +420,7 @@
>>   #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
>>   #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
>>   #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
>> +#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
>>   #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
>>   #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
>>   
>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index 860b60273df3..c7884198ad5b 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -558,8 +558,8 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>   	 *	      SME feature (set in scattered.c).
>>   	 *	      If the kernel has not enabled SME via any means then
>>   	 *	      don't advertise the SME feature.
>> -	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
>> -	 *            SEV and SEV_ES feature (set in scattered.c).
> 
> Did you remove the related scattered.c code mentioned above in a different patch?
>

That is part of the following commit:

commit fb35d30fe5b06cc24444f0405da8fbe0be5330d1
Author: Sean Christopherson <seanjc@google.com>
Date:   Fri Jan 22 12:40:46 2021 -0800

     x86/cpufeatures: Assign dedicated feature word for 
CPUID_0x8000001F[EAX]

     Collect the scattered SME/SEV related feature flags into a dedicated
     word.  There are now five recognized features in CPUID.0x8000001F.EAX,
     with at least one more on the horizon (SEV-SNP).  Using a dedicated 
word
     allows KVM to use its automagic CPUID adjustment logic when reporting
     the set of supported features to userspace.

     No functional change intended.

     Signed-off-by: Sean Christopherson <seanjc@google.com>
     Signed-off-by: Borislav Petkov <bp@suse.de>
     Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
     Link: 
https://lkml.kernel.org/r/20210122204047.2860075-2-seanjc@google.com

Thanks,
Ashish

>> +	 *   For SEV: If BIOS has not enabled SEV then don't advertise SEV and
>> +	 *	      any additional functionality based on it.
>>   	 *
>>   	 *   In all cases, since support for SME and SEV requires long mode,
>>   	 *   don't advertise the feature under CONFIG_X86_32.
>> @@ -594,6 +594,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>   clear_sev:
>>   		setup_clear_cpu_cap(X86_FEATURE_SEV);
>>   		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
>> +		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>>   	}
>>   }
>>   
>> diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
>> index b71f4f2ecdd5..e81606fcd2ab 100644
>> --- a/tools/arch/x86/include/asm/cpufeatures.h
>> +++ b/tools/arch/x86/include/asm/cpufeatures.h
>> @@ -417,6 +417,7 @@
>>   #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
>>   #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
>>   #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
>> +#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
>>   #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
>>   #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
>>   
> 
