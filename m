Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B28C784BFB
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 23:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjHVV2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 17:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbjHVV2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 17:28:32 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2050.outbound.protection.outlook.com [40.107.101.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F6ACF0;
        Tue, 22 Aug 2023 14:28:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W5zhYuSMcuMsS83TgMlhB7C/6ufC3n5G2wW7cRYjA+xgBtlXTUeEB6dhl/lFsoAERl8UYOWvFVQX013wEZ61pn72moj9y6ijZRtzMOjkRWCktf56/YYo9K7e9oXB0WwhWl4m42kl665dRZjBV3mixwRwdi7UOSV7EMATUj4ygNTIw6v6Zyg6agMtLoiJqxANZ7JcKdhwMGXkILH2+HwHwDF1UEtjd1Seo5JVLZ4L7UxRZwHOvad4ZPIBrtbZGJCs7QH9oY6eIG02Gjs87HhJmDSjSdeZ2ptxqBOH6t534z1rfNUZaql1VvSvzLc0SR7hRt6xQFNUtRn+jILRh+8j0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5Zsg3u4+sD9T5L2aBl0Vxr10XFpmv5tb98XmG3Buoc=;
 b=g7fYZsGwGtVrVycG5fmzFSj9pTgWqvNeitlahXxTJhdyYzy68torO2DCShw5oqh+udDm1e8Os9KIYc01N9xtNThe6j7Y92vlp04H23/A+9oqFkH3GvOi5tsggrnnCM4u3XG27h3R4rV9MyUMJRvf/o1LC7ca1eV8zbLaWSceN5fJxeSN5nrDOZlXaeFrCx43ncvE7T8ijjvMDM1NShgo7eR7zrzSwxF6OrZbTlbBobcFhYAnHGb4YMD9f7Z3ZQM32HgxPnPQ1uLfEekuAW2rwjUW7ZFTWkdVzQwBjjpLHIGBKN0l8Glap4iEsqTjkihObxDRU6W26+undzyUhQu+sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5Zsg3u4+sD9T5L2aBl0Vxr10XFpmv5tb98XmG3Buoc=;
 b=zlcLN3IhQi5VczzEuTL6pmDCXlFUC4tb6frznoa1bWAaytoeUJHux7gsWflG9s/nONpvcVrqj12r2LN42CX8n88R1M0J7MDjKwQ7bE3Lcttu4Kr9IMdclVLI3llF7gg/YKvEYTTh4M73paiG44PAdhKZ/isGmkthaRaN0rPNs4o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SA1PR12MB7103.namprd12.prod.outlook.com (2603:10b6:806:2b0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Tue, 22 Aug
 2023 21:28:25 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6699.022; Tue, 22 Aug 2023
 21:28:25 +0000
Message-ID: <ecbadef3-8982-bd1f-54e6-99678c2518d1@amd.com>
Date:   Tue, 22 Aug 2023 16:28:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2] x86/sev: Make enc_dec_hypercall() accept a size
 instead of npages
Content-Language: en-US
To:     Steve Rutherford <srutherford@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, pankaj.gupta@amd.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com, bhillier@google.com
References: <20230821225859.883120-1-srutherford@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230821225859.883120-1-srutherford@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR07CA0069.namprd07.prod.outlook.com
 (2603:10b6:5:74::46) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SA1PR12MB7103:EE_
X-MS-Office365-Filtering-Correlation-Id: 571a939d-979c-47ac-fe36-08dba356b7df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PJ+1/VqTPR2Jjpni5yz3r0SBZ+4nSsvn7uW/+APIlc0X9Z4wZ/NfKNJDdEaN9fflhnJxKMlCw9xa8H1NN4wIVkVE3j0ThkzI8IIl1SQmdPE9lkZg7z4HRpg46/aQr8CuFiA+LS9ooizhiHn/6Qi97RXRGsU//34SXliqBfQAIt/gysdSQ0Nkd0U6jQueB/kYUWF3dFDjdLuMtf7ELTC8V+TS4llJxZVR2+IdRVMraeBdszXiOBC0A6rcrL2vQNQejCikDz63fNll/goJXY1u5LsLqYVqaNhlas00QcboVz3YvrdTY+HYQsw0AHo40plW4dOBxgogwBuy/+d+Pq31DnF3k3nTuf2IHa9jqhoi7ErneUr6njQwl/bUeFQI2IAJoUpqTPZAGjvKa8xHWp1DpB/kb4032kfDtpNdsdPHiK0+7/Orf8WdXyb53Q6ERDuIHxrSiuEdbL+YFP8G5mGdxQGo3oUOCkmFUXrIX4MPYFFKCR2Kryaaj/8Oc6HNFFfHg93WU975nvhQV0FzMIuhRGkQbTdkioxGd2iWDoxY/CL7FBtb38PzvIQCY7Fw0+0y/JPCb9nBbdK93j2IqzcIUfeBjzpCaSo5XrvEomzacalu8ZJf+EiUbc/y3qAoHPryFcXmz0F0vjWToHF92bkd1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199024)(186009)(1800799009)(6512007)(31696002)(6486002)(6506007)(41300700001)(53546011)(36756003)(5660300002)(26005)(7416002)(83380400001)(2906002)(2616005)(86362001)(38100700002)(8936002)(8676002)(4326008)(6666004)(66556008)(31686004)(66946007)(66476007)(110136005)(54906003)(316002)(6636002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTd0bkIzVUNmT2NKNFZxTGRhVFVMWk1YamQ5N0NwaWpxWmR2UmhSelFncE41?=
 =?utf-8?B?Ry9UMUkrYktHTE9WUFV2SWM4YUpqaXJ3QkZJcGtFN1RobjZ0Z1RkWHNLVW1h?=
 =?utf-8?B?Y0lFRjdxYzhPektSOWtVSXFMeGlMMllucDhTNldQZ2hIODRhNVpFTTgvNjND?=
 =?utf-8?B?eEI2NGJxcmtCdjBWaFovck9BNXJUbHdSR1VLTmsvcDZCSzRDL212Tmp1cTVr?=
 =?utf-8?B?V240QnBaSWoxcjlZYm94M1JtaVRIMUFVdjJqRmNKK1BHRUdma3NjMjNwSDNH?=
 =?utf-8?B?eURwQ0ZhMWI2Y0Zxd3FQNTNBZENwelFzVXZFRzdzVnpWYmduSys2WWo1bWlh?=
 =?utf-8?B?Mm8yYTdGMzEwL1R2ZmdPY3hKMnYzWFlNT3plU2FWOUlkclhMdzBBelVHcy93?=
 =?utf-8?B?eFB5MFVZcHY3c1U0SlVXcFFFM3hpKy9TZTQwbnZlMDh4NGNCdzVkNlA0bHhJ?=
 =?utf-8?B?MFpyYTBwK3J4L09xbWlpWklObGcwbUVtLzBqVjZPQW10ajFiSDQ4TjZOOXBG?=
 =?utf-8?B?NnRNMzZRd3k0RW9wc0pzWkQ4YmRPcWpCeEcrUC92dmZ0MEZ2a3R0WGMwT1pK?=
 =?utf-8?B?Q1R6cnRaUVNkQmRybm5SbkRxVlUycXVPQSt5ZmpBaklNZjdGeU56NVRWMnhR?=
 =?utf-8?B?c0pTSkhxK0kwcnpiTzQ2QXJ5Y2NCSjM5Z2hZS0diZGNCZjhvdWl6ZkgwTEFj?=
 =?utf-8?B?S3lIOVMvdGUrUm9INXU2MUlVeWZYRHgxenBPV0RMT0xtaGMzRkN1VHVmUFlZ?=
 =?utf-8?B?QXhPVHJMQ1orY2JQa0hZeldwb2JET2N4d3JreE9jMU9nbHBudzlJWTBINVY3?=
 =?utf-8?B?S25kMzlZNlhSS1M1ME9ZaTdySzA0MWF6SEkzNFc1d3dqYTdSUCtIcitBOC9O?=
 =?utf-8?B?VFF2ZUNvREFZQTkyekw5dUIwNnBnZHRSQlk5L25iQjVGbTJScm5HMTF5dGFh?=
 =?utf-8?B?dll5cWg2OW9uWVlRSGFHVFNqbUhCR1RLUWRFUXp0V2tWd0J4WVE1U0cwOEVn?=
 =?utf-8?B?bGo1dTdYRzVPWVNLY3VBeE1KdnAzRUhDZWxjcDNLaUQyRFB3NEdidlp0ZW1h?=
 =?utf-8?B?VWNzb3VxZkhHUnI1Q3R2UWpzN2VoVk0rZVV6R0o1dEMxQjlnVmZQUWJzMGRN?=
 =?utf-8?B?QUY2cDNuT1p0YXZoVVVoYnovcjNwU28rYmwzS1N1VTQ5Z1g1RFV6VFpQUWpo?=
 =?utf-8?B?S016UjlEcGRMa25zbVV5Sy81VXRXdlo1R0pkUGNGQ25jbU8xTFlNcFF0Wm1m?=
 =?utf-8?B?d3FzMHVtemdFaGI0dG9tWXNiTGdCYzI0MEF4dkZ6OG05Y0xlTzNOQjB6cjR2?=
 =?utf-8?B?dEZDVzBrNnN2U0VhWktHOThpc0pnYVE1RDQ1dEZzaUJ1VzZiRUI3dWxrRnA5?=
 =?utf-8?B?L3EwSVBxYWtlcVppdGhUSjcvYngyOFQ1KzZUWld0em5NZlIyWlBUZzRaeXYw?=
 =?utf-8?B?TW5IZERSMVlBLytscnoxbVhzcDNNbTlNL0RVb0NyVjVnS1JqMXFXeXFtbUZs?=
 =?utf-8?B?TGI5Y1pwRmR2bEZZa3laMTZlSlhERnhRQzZoMUorUldVVDdOS2sxdUwwd3Ev?=
 =?utf-8?B?MExSazhkOXdQaExHMDdXTmYzN0hBdlBreGlZc2ZQNUwvRGdIbzNtN2FldzU1?=
 =?utf-8?B?emViWTY5TEtRbWpwaG5qemtXcmxYU252eW5RYUpac3JmZXNPZUxkeXRJRHg2?=
 =?utf-8?B?SjFSV0g3aW4wdFA5ckdndHpGakZRYVF1MUNUbVREV2s1YnhWQ280QTZ4UXJw?=
 =?utf-8?B?azVSYVEvVGR3RDNaOUZzS3lOQnZNSW03T2xtVmdxcjE0UlRCRTJSQTJ5a2xt?=
 =?utf-8?B?Q2RoRkMrU0VNNHVBdXF1K0FUVVFYTUhxL0NUblRUem1yT1dKNmRaSTlQbzZ0?=
 =?utf-8?B?ckZGTlJaRTB3bXRHQXNnMzdnZzdHaVJGTldPWXlHelFYajB4ZW1XcEFIYlhK?=
 =?utf-8?B?V25icmZJUVNEaW9xL0hjekhOb3VNNFVmcW5qSUY2OHNOcVpXUXR2V1hVUFZL?=
 =?utf-8?B?OXVFaXAycmhaK1Z0cUlxZnc0R0UvenRkMXFLNUZzYWRhOUFIODc2NkN1Q25q?=
 =?utf-8?B?anBXeTZ6eWhBdnY5RzZRSFIxbzlac2lnTldyMk82YWF0K203enp5TzNsdUN0?=
 =?utf-8?Q?wX8uzmWVkzKTYaFPNYoplNU0k?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 571a939d-979c-47ac-fe36-08dba356b7df
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2023 21:28:25.1653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tQGSb7adyW2KnZqeax8eOplrdAF2yhaw3sUH4vj4dJ/cz1vj4FUqPquhW5EASI2iqHfBkg0n4OO4wMJpWCD27Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7103
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/21/23 17:58, Steve Rutherford wrote:
> enc_dec_hypercall() accepted a page count instead of a size, which
> forced its callers to round up. As a result, non-page aligned
> vaddrs caused pages to be spuriously marked as decrypted via the
> encryption status hypercall, which in turn caused consistent
> corruption of pages during live migration. Live migration requires
> accurate encryption status information to avoid migrating pages
> from the wrong perspective.
> 
> Fixes: 064ce6c550a0 ("mm: x86: Invoke hypercall when page encryption status is changed")
> Signed-off-by: Steve Rutherford <srutherford@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/include/asm/mem_encrypt.h |  6 +++---
>   arch/x86/kernel/kvm.c              |  4 +---
>   arch/x86/mm/mem_encrypt_amd.c      | 13 ++++++-------
>   3 files changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 7f97a8a97e24..473b16d73b47 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -50,8 +50,8 @@ void __init sme_enable(struct boot_params *bp);
>   
>   int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
>   int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
> -void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
> -					    bool enc);
> +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr,
> +					    unsigned long size, bool enc);
>   
>   void __init mem_encrypt_free_decrypted_mem(void);
>   
> @@ -85,7 +85,7 @@ early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0;
>   static inline int __init
>   early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
>   static inline void __init
> -early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
> +early_set_mem_enc_dec_hypercall(unsigned long vaddr, unsigned long size, bool enc) {}
>   
>   static inline void mem_encrypt_free_decrypted_mem(void) { }
>   
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 6a36db4f79fd..b8ab9ee5896c 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -966,10 +966,8 @@ static void __init kvm_init_platform(void)
>   		 * Ensure that _bss_decrypted section is marked as decrypted in the
>   		 * shared pages list.
>   		 */
> -		nr_pages = DIV_ROUND_UP(__end_bss_decrypted - __start_bss_decrypted,
> -					PAGE_SIZE);
>   		early_set_mem_enc_dec_hypercall((unsigned long)__start_bss_decrypted,
> -						nr_pages, 0);
> +						__end_bss_decrypted - __start_bss_decrypted, 0);
>   
>   		/*
>   		 * If not booted using EFI, enable Live migration support.
> diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
> index 54bbd5163e8d..6faea41e99b6 100644
> --- a/arch/x86/mm/mem_encrypt_amd.c
> +++ b/arch/x86/mm/mem_encrypt_amd.c
> @@ -288,11 +288,10 @@ static bool amd_enc_cache_flush_required(void)
>   	return !cpu_feature_enabled(X86_FEATURE_SME_COHERENT);
>   }
>   
> -static void enc_dec_hypercall(unsigned long vaddr, int npages, bool enc)
> +static void enc_dec_hypercall(unsigned long vaddr, unsigned long size, bool enc)
>   {
>   #ifdef CONFIG_PARAVIRT
> -	unsigned long sz = npages << PAGE_SHIFT;
> -	unsigned long vaddr_end = vaddr + sz;
> +	unsigned long vaddr_end = vaddr + size;
>   
>   	while (vaddr < vaddr_end) {
>   		int psize, pmask, level;
> @@ -342,7 +341,7 @@ static bool amd_enc_status_change_finish(unsigned long vaddr, int npages, bool e
>   		snp_set_memory_private(vaddr, npages);
>   
>   	if (!cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
> -		enc_dec_hypercall(vaddr, npages, enc);
> +		enc_dec_hypercall(vaddr, npages << PAGE_SHIFT, enc);
>   
>   	return true;
>   }
> @@ -466,7 +465,7 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
>   
>   	ret = 0;
>   
> -	early_set_mem_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT, enc);
> +	early_set_mem_enc_dec_hypercall(start, size, enc);
>   out:
>   	__flush_tlb_all();
>   	return ret;
> @@ -482,9 +481,9 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
>   	return early_set_memory_enc_dec(vaddr, size, true);
>   }
>   
> -void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc)
> +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, unsigned long size, bool enc)
>   {
> -	enc_dec_hypercall(vaddr, npages, enc);
> +	enc_dec_hypercall(vaddr, size, enc);
>   }
>   
>   void __init sme_early_init(void)
