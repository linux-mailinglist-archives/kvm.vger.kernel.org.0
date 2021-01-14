Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64F42F6CC9
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbhANVAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:00:16 -0500
Received: from mail-eopbgr680074.outbound.protection.outlook.com ([40.107.68.74]:26405
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728202AbhANVAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 16:00:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bn6mM/3z8TCnSD3bg2JNyFVLzvkZOSW/7XQEqXE51GXMeRO3JnAVTrq7HjLUQdc8/7fpI/btMJ3vtrU4LVCjmaWX0fpiL16MLUMKmn3PyC8ps70yVC+9sodcdwWHJzFWRNBZ927ycSl+GYakN7zk8wEHszP5EXVSjReUjvHqOLKhKwLFRd227OdtTPDHJj0YarWMC3g3FA0Lbr8POLbmoTwHgAWOuUyaN2XRcwfa5BkYK89rK2G3gsPxxuZTyK9wxwQuc9yWEfDG+wVCmOtFVc5a/Blsh5IY2OzhrnRRdUMQhaLcSgiAf/G7ajbuPG0lVQ6V9+mgFpZQx4CllRr8Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtP8ksAa3ckdPQG4KHBG2kq/bLfe36D6VQLZHXE/Ulw=;
 b=Whm67+vcfp/UZipC/uRH97KBnzdkjF4j7BVgsYQLagaGaEyhzA/w+OryYAcYY2EecvmSqJIv4gVOiSwpAxvxklH0ibib5Z2QRz3LVrxn6hbYIrg0fCT+B5++ElGeefr2+2QnEPTI2eGsR+IzZE8GizWh0velFow1bZ2gd3JQVLxQaM5jUbbg9GkYs+pxqgyxyJHWKbVfBAlRLPyMhTQ8UiY0e8aYj8Ws/HtDn+/IIGEwE0/BMqUN4LdYc+7pjFRduJh2/cjlTt4Ce6FFMQShAUqH5lJPsJtYrwvoEIUgOitYv7uoLQlIj6eFt1RqWo3AWlnLnRXfY5R9yGa5p7xSFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtP8ksAa3ckdPQG4KHBG2kq/bLfe36D6VQLZHXE/Ulw=;
 b=PXQsolbkEcmmyDGx5NmxzanAXPI+ApPBZEXdzuWGLiG8Xl3U4dXz/WC76UGBbEszYgFVkTmCm9b9BvfWvTARZ0y2yV1kL6WN5FRc7V8lDuZQMGXO5XwtZX0pv40u5vRHK+aenqQ69ZbzTwRX9iXxZVipQ1j5ka5eO68ZriRcUHY=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB4750.namprd12.prod.outlook.com (2603:10b6:805:e3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Thu, 14 Jan
 2021 20:59:24 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 20:59:24 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 03/14] KVM: SVM: Move SEV module params/variables to
 sev.c
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-4-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <c625e831-9127-2755-ff09-47b881780b5a@amd.com>
Date:   Thu, 14 Jan 2021 14:59:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210114003708.3798992-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA9PR13CA0066.namprd13.prod.outlook.com
 (2603:10b6:806:23::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR13CA0066.namprd13.prod.outlook.com (2603:10b6:806:23::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.7 via Frontend Transport; Thu, 14 Jan 2021 20:59:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 01903975-f0a1-406c-8d7e-08d8b8cf462d
X-MS-TrafficTypeDiagnostic: SN6PR12MB4750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB475033B91A10AF7BC873FAA4E5A80@SN6PR12MB4750.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wy0mlofLfhI/PpQmLlmmB6LrmuHj1O6MIw4GrjPwoQV4bwj4eVu+V2S5rnyzQQ3NZy74awh87uzq/Mn06ox5ZPN8m6FntAzNsSQKKqm0SY/pdxBSL0DWe8qrywbtutNtUY1TDOqjVc+xo/BO+J3YfON2R9Q1HYWwlZvrBUHWzhHj+1R1dGVwPdKVC7OnwCqKrrXSdYn+3PDxTb3YPEAMhcYHgcAk/1higXCOktPnTL9Lb40lrbDQ429igWQhW6FKZb7crWCtxuR6DzILogJD1verZj2uT3bFgm2BdQ1aVLqEBgV8ZWapRe3imoTYBc86RNjIdFF5Gk0CTuNXkGgg4gvmB85l2xPcgEAofewU13qcienVF01U7kyxGWg3YtTXUxJkj5Cd+kZnZtCk7nLz5h1n0StL/s/nb3F67u0u2vaVFLel1ZlQUl8vC8l2SRFJEbmi/SqlABApWL+Y5kHFVib+v4LpZ4hLNyhMMGiP+Ds=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(2906002)(2616005)(956004)(44832011)(478600001)(6512007)(66556008)(316002)(8676002)(66476007)(6506007)(52116002)(83380400001)(7416002)(110136005)(6486002)(66946007)(186003)(16526019)(31696002)(5660300002)(8936002)(31686004)(54906003)(4326008)(26005)(53546011)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OWNDQ2lObC84WmdWVFVEaU9wN2psM1ozTjBrY1RlK3FHejhnQ0sxaWx5THdT?=
 =?utf-8?B?M2Q2OER3U3pVT2l0ajZmKzJFVXRSR1kvb3RDZzBWbGpZWUsxWHVVamQ5QUNW?=
 =?utf-8?B?NTZWUzMxNU5OR3dQU0NlUU1STmwvMDF3R29jU3N1OHhKNVRNd1ZnaFJxeGJt?=
 =?utf-8?B?V3RwRFc3RXp5VEZmSloxckVNYzZJU1Uvb2xKcm84VEVIQit5MWJTbTg1aUF5?=
 =?utf-8?B?ZlFjYVhObjErYm5Femsrb01tbUNkTlAzcmRFeU1tZlFTOUF1VjZYUjFIVXpK?=
 =?utf-8?B?M0ZYbWZReVp4Tmh4SWNKbk9oNE1VWHZtUXRDaDNNR3R5alJGNm1LaGNyV1gz?=
 =?utf-8?B?R09ESDRLdkxxdWNFM1BWSGVSaEFVMi8wRU4wZnFyc2c4amJGWXFsSy9NK2Np?=
 =?utf-8?B?VE92dVh6UUpjVTRtTStUR3dLMXVuRVhVOWhMSGVDY1JMWWp3aDdsTkx0anlE?=
 =?utf-8?B?cDcxTXZhUFR4MjczcmlhUHpvTDRNNUZTUnlyVWNsZXBvSUwxRjlIaTUxR0M2?=
 =?utf-8?B?cTNLejNPWGN5bDJWV1NIRWpydEdsR213Slc5ejVGT0orQzk0ak5vOEwrQzM4?=
 =?utf-8?B?YjVoWWxxYkxqRlg0bC9uT0xWQk1TL0RiVTIwY3dHT3NYeFc4UVB5L3dkQmFa?=
 =?utf-8?B?WWdieFk5K2RCdHd5L0JvZlJqQ2F6eG45STVrOWZva1lSR3JYQ0ZJbENsN1BI?=
 =?utf-8?B?aFN6dUtiVWE2ZGdzNXRUZmJQWXFiZTdUT0tPWS9nVzI3aWFmZDQvQytDcEZJ?=
 =?utf-8?B?OGtaZzFQUjd3YWNjOW5sdWN6dWs5M3Bld085eWt0ZldKMFFVbDRLa3k1RGhB?=
 =?utf-8?B?UkJBUkxNUkxIc3gxS1lna2tXWTc2ZEtUUGJTWnhaWDBxM3RzUEU0S3gwYVlQ?=
 =?utf-8?B?RVdFT0x6ZmRtTzlLYUc2V1V0MFNONGsvbWRzVVNvdU8xZUxyMmQraHVibWlR?=
 =?utf-8?B?TTB4a2tVZkt1TXhmUkVGcHQvQ2ZORHhoMTZBOGw4OVRNNFJBalpucGdHVVM0?=
 =?utf-8?B?OVE0RlJmVlErMWNsbERHSlc5R2llTS80NC9yaEFtRjFIM3l6S1RsdC9pYnlQ?=
 =?utf-8?B?MUhTbEFyeklKVHlYVnk2czhFZmxQV054bnd4Z0E4MzErR3ZRckpQLytXRVhh?=
 =?utf-8?B?NUEvOWFxRTZLeW1jazllRTdQVUt1MDlHVGt2T2pEOE9uZUtUSlliN0pVU2NH?=
 =?utf-8?B?VG41eGoyeENUeUNSdWFzUkkvMzJsR2NKVUkxeHB6NjVNbUNlOWFHa1BXL0ph?=
 =?utf-8?B?R05iRzNQeWp3UWlWNkluTnByZFIrNVFTT2x0L0lRUFJTUzNWa2NHZWVQeHhh?=
 =?utf-8?Q?bvdr+D4UVphzZ5SODQnnT9gBBKn4piSa+1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 20:59:24.6457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 01903975-f0a1-406c-8d7e-08d8b8cf462d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SIrlXMAgCHLr9YN96TOp5rr6uHL0IMYyhMECM68sE+lYOcaVDegSN9C8LBowwdGSJrzyQkWdoQKOrPPqfkcZzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4750
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/13/21 6:36 PM, Sean Christopherson wrote:
> Unconditionally invoke sev_hardware_setup() when configuring SVM and
> handle clearing the module params/variable 'sev' and 'sev_es' in
> sev_hardware_setup().  This allows making said variables static within
> sev.c and reduces the odds of a collision with guest code, e.g. the guest
> side of things has already laid claim to 'sev_enabled'.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 11 +++++++++++
>  arch/x86/kvm/svm/svm.c | 15 +--------------
>  arch/x86/kvm/svm/svm.h |  2 --
>  3 files changed, 12 insertions(+), 16 deletions(-)


Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>


>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0eeb6e1b803d..8ba93b8fa435 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -27,6 +27,14 @@
>  
>  #define __ex(x) __kvm_handle_fault_on_reboot(x)
>  
> +/* enable/disable SEV support */
> +static int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> +module_param(sev, int, 0444);
> +
> +/* enable/disable SEV-ES support */
> +static int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> +module_param(sev_es, int, 0444);
> +
>  static u8 sev_enc_bit;
>  static int sev_flush_asids(void);
>  static DECLARE_RWSEM(sev_deactivate_lock);
> @@ -1249,6 +1257,9 @@ void __init sev_hardware_setup(void)
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
>  
> +	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev)
> +		goto out;
> +
>  	/* Does the CPU support SEV? */
>  	if (!boot_cpu_has(X86_FEATURE_SEV))
>  		goto out;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ccf52c5531fb..f89f702b2a58 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -189,14 +189,6 @@ module_param(vls, int, 0444);
>  static int vgif = true;
>  module_param(vgif, int, 0444);
>  
> -/* enable/disable SEV support */
> -int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> -module_param(sev, int, 0444);
> -
> -/* enable/disable SEV-ES support */
> -int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> -module_param(sev_es, int, 0444);
> -
>  bool __read_mostly dump_invalid_vmcb;
>  module_param(dump_invalid_vmcb, bool, 0644);
>  
> @@ -976,12 +968,7 @@ static __init int svm_hardware_setup(void)
>  		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
>  	}
>  
> -	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev) {
> -		sev_hardware_setup();
> -	} else {
> -		sev = false;
> -		sev_es = false;
> -	}
> +	sev_hardware_setup();
>  
>  	svm_adjust_mmio_mask();
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0fe874ae5498..8e169835f52a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -408,8 +408,6 @@ static inline bool gif_set(struct vcpu_svm *svm)
>  #define MSR_CR3_LONG_MBZ_MASK			0xfff0000000000000U
>  #define MSR_INVALID				0xffffffffU
>  
> -extern int sev;
> -extern int sev_es;
>  extern bool dump_invalid_vmcb;
>  
>  u32 svm_msrpm_offset(u32 msr);
