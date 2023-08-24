Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C79786B13
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 11:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234715AbjHXJFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 05:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240023AbjHXJEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 05:04:43 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660481705;
        Thu, 24 Aug 2023 02:04:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Va/TMPPPBD0qi3iTPXdPNpiBTYcBE8NNQmOTj0bjK7okYERC7mZS5zTObnk4sMnrn3ZWlsuUQ0JGuGYHak10UthOHI+M1M0DtbJOwEWnv64hBrvwMstJCqP06d2e/DpYCaIYKF5IueljhowZcZVrN2hTOB9jKzLjue8yLO9dn/BWeJ6B9FgyLXnPqY1XUaSiu+Ude/hwpSstvG4NKawyiNdMGzy/xa97E6jC1szxMmXHqI/50RlzxOBioG/7EYkoxsrgRbDTKoiB2HnojkfsQ6AA6Tncvc4Q3jd4pUl08L5ixJhM8ks7jX7gRjA4SM0WcTJeXvCR8iMNt68yrZMEiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvDbfOR57QD54hEn25mM0t6Lsxq4dNmdYkqbChfIunM=;
 b=S+i8iWzscv2Dnu/9e3tg8KRIjv5pAjeS0ntSydIRdzVMD28EHFI7rupR86Xnx9vVm9LC9BdwaqLzEpJpklGKE8cO+Lcz4Omywz7QDX47gS+JDNDVw9GiH7pfa1G145CA6d5J0cXi/TAph8Y3uECjEgRp02E1zFLLoF8xzoP39X2978d0P6V4ZDWokiaUWdqvGDZvK/pZPlvP9nMHO4/lSCBk43XcEDWXmv1JjisMFNxU4Z8q5fpfcspw/2OV1A5cH+iEeqHDnEadGYawr/28UfVhgiJNzLCS6y1YAZrvnhLqZcbWE8UhnQIo/KSZFfLtOWevdis26TCc/TmfK5/HVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvDbfOR57QD54hEn25mM0t6Lsxq4dNmdYkqbChfIunM=;
 b=xKZUu6zilX93u6xRhxITqef5oNeGMVGCzytw2FDNVF8RQY6/AIpM5L5CCeLKsgktrNmQb59qby6Sa/iAYV4XCUumd2anoqpiJ+uHNL+RbYnQtWNUXbsWwFLw+hEaOsq+655kVlFDuvCnhDR0wR/GvEpfL/4P1WPxvr7atWC2Bgc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2810.namprd12.prod.outlook.com (2603:10b6:5:41::21) by
 IA1PR12MB6187.namprd12.prod.outlook.com (2603:10b6:208:3e5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Thu, 24 Aug
 2023 09:04:38 +0000
Received: from DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::52dc:b225:8fec:154c]) by DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::52dc:b225:8fec:154c%4]) with mapi id 15.20.6699.026; Thu, 24 Aug 2023
 09:04:38 +0000
Message-ID: <23cfdd53-597e-45c3-9bd1-dbb1be506137@amd.com>
Date:   Thu, 24 Aug 2023 11:04:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2] x86/sev: Make enc_dec_hypercall() accept a size
 instead of npages
Content-Language: en-US
To:     Steve Rutherford <srutherford@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, thomas.lendacky@amd.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com, bhillier@google.com
References: <20230821225859.883120-1-srutherford@google.com>
From:   "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20230821225859.883120-1-srutherford@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0179.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::19) To DM6PR12MB2810.namprd12.prod.outlook.com
 (2603:10b6:5:41::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2810:EE_|IA1PR12MB6187:EE_
X-MS-Office365-Filtering-Correlation-Id: 925a9cce-ce80-4994-f0c7-08dba48124b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d5s0bsNjtOvkJ60Y4Tx1WjyiRiAsTHvyE6sRuo3kspYkjqdJzfpklarU52qIjo1N9qLU5m+3Fm90k536GrjD26I/MoCHbqenjnalFn5p68YOf0U14+5mRwKGVbGVwWdx8lIdg3+IQcjpNGli9H36eX0+AZWHDToSYAdm0c45JEhZ56LJROFiVPe+NeHfbEplYxw7pn6RE/gHhl+suqE8qjYUv8x/Nmtw/cNs4yXNZxpOshsJ3KAzAH1o+SkZ6V3aUt0iFL4ho/iwSv4w4sjhhHYT4NbUxd4NTJj/rL4DTo32uowPF7NjL9C+wqIkawSK2pf/rrGLT2LacQy/RPyAjGCYVwvCqkCeIofG08YAGDUYA/GDaka/NNpUEMsNazN30f5lD00LRqVVzyYMxLq+OpGFmH8rPuWqQ9d2G8gxGT06DOTrAppH/UtbVSgc8khxEym/AS+fT8rKw0VPiOXZgxHjxDyDXPx69hfPsCD+r5wWoR/eOcyTS6KFBAyhdNC8GXpkGkC+pjU+tFjRWMHRPdSnWJJ1tvZ2dzWPEpvOOA9KMwKPTbJFSSD2JlDy+W3wq/hnyXKSgFkJv6YK+Qk1u6t2pBR8Gdtvvqouc08xbk6a7oyhpzaBtFk/q4XeSnoD0UF2FeIw8nrJ0ENuAIqJEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2810.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(346002)(136003)(396003)(186009)(1800799009)(451199024)(2616005)(5660300002)(4326008)(8676002)(8936002)(36756003)(83380400001)(7416002)(26005)(6666004)(38100700002)(66556008)(66946007)(66476007)(54906003)(6636002)(316002)(110136005)(478600001)(31686004)(53546011)(41300700001)(2906002)(6512007)(6506007)(86362001)(31696002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3VwOFV6UFY3RGJ0VXBqZGFnT2hkMjlUbGVYMEpkMERkWWlCMDFGTGlzOVZy?=
 =?utf-8?B?QnJOcU1NZFA1S2syRm4rdnVxbkUySlRSa05EdWE1UE9lbzFFVG1LS0l3TWVG?=
 =?utf-8?B?dEZLendtS2tUQyt6NXFXMkF0MVBQaWF6ZjJ0aS9XMDNZTzJqb3lURmpXdkFL?=
 =?utf-8?B?LzNIOUtHdlU5SkZPNzNOTVZZbDM2citFU3p3QmJiSVpLK0JnQjZvY3lnRGkv?=
 =?utf-8?B?OUV0aFVTWnVDWjNYVzNHRVc5amdYeXEzRkNkL0RGbkpSTTMxUEE0V3lleDd2?=
 =?utf-8?B?UjR0Tis0ZDkvSW1PWjRYMUFtR3d3WkhXMG5xa0RsKy84SmJrSnlLdjdKMjM5?=
 =?utf-8?B?ZHNINFBiNFRIMFRPVnJ2TW9XTWIvTEM4N3lFR08rNUVZdGo1K2s0djBXNmJM?=
 =?utf-8?B?TE5hQ3FqR2FFbjVaQWN6UW5aQzhlaEY4UW9WK25INVZtdERGWW1pcEw4cWVv?=
 =?utf-8?B?dVQ5RWM5WVI5YkVWb25OQ3hTQmhITjRXMTg3eTA2bUs4WURaK1FMdU0xTDlK?=
 =?utf-8?B?dER2c1NXR1lUTlFta3pDMm1icjRKVHY5eTNGTEZZNWZhSVZUSGxSMmhmRGpE?=
 =?utf-8?B?QzV2Y2p4SVVTQ1FnVld6bFkxTGZMeE9kYldsZHF6SWNQVHUvYUZ5MXAxRnNK?=
 =?utf-8?B?Wmk3NW5HSGFEOUV4NzV0Rnh3R3FQR1YwcTZrZ0ZoUmk5UEVUQk50Y2RPZEdy?=
 =?utf-8?B?bWtpdytEWlIwRVJDZ3J4cnkvR3dWV3I2ckN1K1V2RGgrS2ZySHFKZnJEL0Fa?=
 =?utf-8?B?M3J5SXJRanNaSzhFUm5hbmNrOFNxS2lpNWkyTmw1Z0ZoNnRXMnVUbTY3NVdP?=
 =?utf-8?B?aS9XRk5mOEZ5cFNscmM0dnphd0t0YlR1T0p5R2F3SDE0cS9xR2VEMEtYNHdL?=
 =?utf-8?B?eU9hNFdFdXdVYUtnTndrV3JJQXNlbTVQbUd5VDJDMWxLOHM2VXVFR09mTFVB?=
 =?utf-8?B?eHladkFXY1hVWUpPVDNCbUJJZWNFaUVpU0NJRmFVckdxL0VSYVBMc2pOQUdF?=
 =?utf-8?B?M0RMc1V2MzVRb1N1UXM1UFFvWjliVThOSFpMRTdIdXAySjc1UEVxYkFPN2gw?=
 =?utf-8?B?OGdyRVV5MjZMMlp0VW85YzVvVEJvYTJvL1ZPcDlkaXh5eVNRUVF0VUdKWXJ6?=
 =?utf-8?B?STlVb0tmampIN2N2SXlGcmRPOWkrWWNMSmhxU1gzNGhnenltcFFyVjk3ZW1r?=
 =?utf-8?B?NmFjL0ExMUt2bDVtOWpOMUd6V09GNkFNSzJSQytUQkJjSFZCWm44WE4zT3Bu?=
 =?utf-8?B?Q3hjZEVQYmJVOUFNclAxeUVkQlFLcWxaQ2lDajl0aHBpemtBWHRvN3BQck9N?=
 =?utf-8?B?VEw1OGZPQmtrRVpJdTdSUWF5RzBHTC83dS82dzNFbWJ2UmZWdmZpQlFWemNO?=
 =?utf-8?B?RFVCc1hBckpKTjVYcWtKRWdHcGxuN3dlNWYvR2xtNW1lSDJic2xlcjcwZElB?=
 =?utf-8?B?VzVpdm9lSlRmWmh6clA5b2MrTHNodE5IWGlkUGEyWTRKRFRaQ3ZBQXFzbSs0?=
 =?utf-8?B?czE3cjM5d0VZZ2ZHVDhoNFVsQk54Smw0ZWM2TUZIR3hSU0JldDJraTdZMFF2?=
 =?utf-8?B?cnJjZzYyT09QSVk2Mzc2MENQQW1NQ0w5a0V5NGgraks2cmNpK3NPNnNEWUk0?=
 =?utf-8?B?RkkvWnE4c3pwV2hNOXdDdkw0ampBbFZNYWYvT2RmOGg1UXJFNWFFODlKVFBZ?=
 =?utf-8?B?TDZmdlhHZDdPNk1ybXJodldOMUNYL0N5bTcvcTRVOVJzY3AwNEVtSllPRS93?=
 =?utf-8?B?NmNJa1RaTCtNT01mdk1sQjVhV3pYU05JRERpNVNtODlXc2dlSGdQaDdjVmNa?=
 =?utf-8?B?R244NC93YThTMXN3S09pL3hVL1dod09jU21DMHkrdUM3NWhjcGd6ejYyVU10?=
 =?utf-8?B?RWY1ZVFkdjc0N3lIeTQyaG9kOThsUjd1ZTNxVldvMTVBMVRHR2lTd2oyQitM?=
 =?utf-8?B?NkU4SlFaZ0RWYlhNbmRLYm5VZ3NDcng0VzVialU4dE56cXloZ1ZqNFFhVzlQ?=
 =?utf-8?B?V2M4bDlxRjZEUVRUQllkZm9GZlhzYjRUT09lbVZ6QTIrREk1N21EYWZVZytl?=
 =?utf-8?B?SmZxZldNSVM5ZUtodlZRdE9Ma2hmc2pyKzZ6MFpDVjh6dnpRcFZjU2hOcld5?=
 =?utf-8?Q?4ywhv8AobnPEaHkE4pIEsTjJG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 925a9cce-ce80-4994-f0c7-08dba48124b7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2810.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2023 09:04:37.9831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmufeuHSOMdNFBHwJS/R9t2GX+B6QI2vVAqB3BaljRVLBeJJkLg01+SKIuAVX4VEFIFbAvgCTwU06hsQXjPIgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6187
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/22/2023 12:58 AM, Steve Rutherford wrote:
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

Also had this thought to avoid passing the page boundaries calculation 
with npages in-place of existing size based, but no strong opinions.

This seems even better. Thanks!

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
