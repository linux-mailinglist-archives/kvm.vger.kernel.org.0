Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235821E479A
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 17:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgE0PeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 11:34:17 -0400
Received: from mail-bn7nam10on2051.outbound.protection.outlook.com ([40.107.92.51]:19580
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbgE0PeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 11:34:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obh5Wg9tvZNF1JXNJ/x3PvkAi1mADjre5V49XCZTNuT56NX5Tx3Rt0FnIHmGFIiGxLxPZS2yC2Kh4nKPlPlQVXB7nHzXg+sbMJ6CiZW4LEw3d22Y7TWpAq0Ah1M8Bdrtd66Ar1lTzQGOWTxw9p4YmmZk6j5uKTWCbTtshyF8rKgjk5eu0hfMLEzHFa9bIiZBzMO6UuuxErhHflRA99hno7haoauSf4rqUa6NeSqOR2wwcSKiVrwAHsIcMytjJeGJOQ0KcxONy9AlJPxS9zg/q10G2xq176NO4L+dV5eP8k3dCSjM0X94vIQCknZG6090jGBlRvkT6YE7LnEmvVX8gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hA+W0Q8gbj4Cai2Hc26qqAhkw8JrVUFb2+upYzjUJI=;
 b=HD0/I4pKr65ga3XrevFVf2mcVnIQQTeG6Gjfc8zXWf3B3Q/94WL3BUNapGGSvuOTTjb0tCu7tvCIgxirsA3ld/vQbqhKo0lsu6gouGJ8vzP/C6AgYrVPOY4ONPJfCLDokLjej9Fgt5yLJqcxQWuWqRrjmILjWPzBP13fYISf/Qjh3NBvJ3ZpvCdLYaPvWQDARCXUEL3uSkj3soauGcUNlGLb7OMFUhu1JuF1AYcX/SXpZnWvcAOua9haFODn0pL2MPX3RDOD25jwqpZhtcUFSxaS153ch12OpcYaeL++nyUY2TzX6frl4HsmzANYBmLVoAKKfqZMuiWShOFF/ZylKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hA+W0Q8gbj4Cai2Hc26qqAhkw8JrVUFb2+upYzjUJI=;
 b=nyApV0qL5pt4vapHT7T+PSmwkc7OcR3zzuYQQdubY7HTQEBHmkafy5odT4wMzl+yvKmA4b1Abz3f7O53u6SKTRAiaoAT2GMj+v9P2omsVSn9/JoUNPKZR/jaxSeD1fNznV0NoYN29LAMQ/X7L2UD5DQTz6mh3VIxg4GBmM9OoHU=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2408.namprd12.prod.outlook.com (2603:10b6:4:b9::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.17; Wed, 27 May 2020 15:34:11 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.3021.029; Wed, 27 May
 2020 15:34:11 +0000
Subject: Re: [PATCH v3 64/75] x86/sev-es: Cache CPUID results for improved
 performance
To:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org
Cc:     hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-65-joro@8bytes.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <2ffc956a-e62d-1a5c-b735-e7b1a2bfe8b1@amd.com>
Date:   Wed, 27 May 2020 10:34:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200428151725.31091-65-joro@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0029.namprd11.prod.outlook.com
 (2603:10b6:806:6e::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR11CA0029.namprd11.prod.outlook.com (2603:10b6:806:6e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Wed, 27 May 2020 15:34:09 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9831c4ff-b481-4495-2308-08d802536731
X-MS-TrafficTypeDiagnostic: DM5PR12MB2408:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2408FAA9DEC6EC7E0129D5D9ECB10@DM5PR12MB2408.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zj+X+PBdC/ecCvj20CxcyDwqpVz9Elzucy8YSl8nhqgFOCb0srQ8HvCkptxOnuAxX9XUEc25BR0qcOnrZoFyR0ibZhqoC5NVz66uN+VP/DEz1QzfgzwUcZqvVT5fRx1Si6geSPkvwJwIhpAp0tzbieGOnoKOcVVLcA38vZTuui+kMqDGngcOmZkW8awlkdKIwufasdW0TfcwLeduThOyfNuhGVbUHwfdjTXnXZJ3UDv6ycMWUvhvgF32VimWP+MiET0W0IYhIehgrfZT9/spd3tpSbAtq/TxiYo4jsQsja568pFkPfEqsLqzpbBCwl/fJJr0AgCB1PF7lUZFC1qokYBNpviuNqbOJXO61p9bQOpVkYZC5qGgIuXX6LtSnlL5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(4326008)(6512007)(86362001)(956004)(7416002)(316002)(5660300002)(83380400001)(31686004)(66556008)(66946007)(66476007)(8936002)(2616005)(36756003)(478600001)(16526019)(31696002)(6506007)(8676002)(26005)(52116002)(2906002)(186003)(6486002)(53546011)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vUNggXcgxWEz4SCYO/EmQVLhUjlYIS8Imwfr6+gRLDygqmiwFklVw3Uwgs9S9MzR9IPK40yJpF/CVp4Pvc+zIa821//I18DRX6p60B8j38j8cZF/PY2CidvS7VOEhvqdIBYDRqSNnQi0InN3VKMbSqL2XTous5rtakbW4/EQC+4A7FM90WCW9YtGWMsNx5BS8VR1aMoR7OlBEjmmnlwx59tYKzKhN+/V9omSaAMFarNbeqQfWjMYn0YwR1fgqSOqc3Gb3FX1/PqSl3gUGghJUCHU4+USdsVV/rnhPSEs5HmR/WlU6kyc0eGwDvxq+d745OWqqkjCHF33IDrU43eI2xHieFQcyldLFY8FzhUQvJu2sqXN0YGUnCw4h0TdOGAG/7BGTxHc7qwA66p3SSo+V/eDPDFUfABS/JszPLHt1ZVkpJzdB6rf10E0suOza+RY1VSV0zzy7SCppubRq3K0HURDjen7hZILpuwRqz5vh5M=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9831c4ff-b481-4495-2308-08d802536731
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 15:34:11.4667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrzgjphEkIbFJz1iJzXiDDbdtIhl0atUGM1TxIIEuaHckjas6VSVHaxwVNd12F8v7GHqtyzrT4IWv6shZ0CEqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2408
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/28/20 10:17 AM, Joerg Roedel wrote:
> From: Mike Stunes <mstunes@vmware.com>
> 
> To avoid a future VMEXIT for a subsequent CPUID function, cache the
> results returned by CPUID into an xarray.
> 
>   [tl: coding standard changes, register zero extension]
> 
> Signed-off-by: Mike Stunes <mstunes@vmware.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> [ jroedel@suse.de: - Wrapped cache handling into vc_handle_cpuid_cached()
>                     - Used lower_32_bits() where applicable
> 		   - Moved cache_index out of struct es_em_ctxt ]
> Co-developed-by: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>   arch/x86/kernel/sev-es-shared.c |  12 ++--
>   arch/x86/kernel/sev-es.c        | 119 +++++++++++++++++++++++++++++++-
>   2 files changed, 124 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
> index 5bfc1f3030d4..cfdafe12da4f 100644
> --- a/arch/x86/kernel/sev-es-shared.c
> +++ b/arch/x86/kernel/sev-es-shared.c
> @@ -427,8 +427,8 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
>   	u32 cr4 = native_read_cr4();
>   	enum es_result ret;
>   
> -	ghcb_set_rax(ghcb, regs->ax);
> -	ghcb_set_rcx(ghcb, regs->cx);
> +	ghcb_set_rax(ghcb, lower_32_bits(regs->ax));
> +	ghcb_set_rcx(ghcb, lower_32_bits(regs->cx));
>   
>   	if (cr4 & X86_CR4_OSXSAVE)
>   		/* Safe to read xcr0 */
> @@ -447,10 +447,10 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
>   	      ghcb_is_valid_rdx(ghcb)))
>   		return ES_VMM_ERROR;
>   
> -	regs->ax = ghcb->save.rax;
> -	regs->bx = ghcb->save.rbx;
> -	regs->cx = ghcb->save.rcx;
> -	regs->dx = ghcb->save.rdx;
> +	regs->ax = lower_32_bits(ghcb->save.rax);
> +	regs->bx = lower_32_bits(ghcb->save.rbx);
> +	regs->cx = lower_32_bits(ghcb->save.rcx);
> +	regs->dx = lower_32_bits(ghcb->save.rdx);
>   
>   	return ES_OK;
>   }
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index 03095bc7b563..0303834d4811 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -19,6 +19,7 @@
>   #include <linux/memblock.h>
>   #include <linux/kernel.h>
>   #include <linux/mm.h>
> +#include <linux/xarray.h>
>   
>   #include <generated/asm-offsets.h>
>   #include <asm/cpu_entry_area.h>
> @@ -33,6 +34,16 @@
>   
>   #define DR7_RESET_VALUE        0x400
>   
> +struct sev_es_cpuid_cache_entry {
> +	unsigned long eax;
> +	unsigned long ebx;
> +	unsigned long ecx;
> +	unsigned long edx;
> +};
> +
> +static struct xarray sev_es_cpuid_cache;
> +static bool __ro_after_init sev_es_cpuid_cache_initialized;
> +
>   /* For early boot hypervisor communication in SEV-ES enabled guests */
>   static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
>   
> @@ -463,6 +474,9 @@ void __init sev_es_init_vc_handling(void)
>   		sev_es_setup_vc_stack(cpu);
>   	}
>   
> +	xa_init_flags(&sev_es_cpuid_cache, XA_FLAGS_LOCK_IRQ);
> +	sev_es_cpuid_cache_initialized = true;
> +
>   	init_vc_stack_names();
>   }
>   
> @@ -744,6 +758,91 @@ static enum es_result vc_handle_mmio(struct ghcb *ghcb,
>   	return ret;
>   }
>   
> +static unsigned long sev_es_get_cpuid_cache_index(struct es_em_ctxt *ctxt)
> +{
> +	unsigned long hi, lo;
> +
> +	/* Don't attempt to cache until the xarray is initialized */
> +	if (!sev_es_cpuid_cache_initialized)
> +		return ULONG_MAX;
> +
> +	lo = lower_32_bits(ctxt->regs->ax);
> +
> +	/*
> +	 * CPUID 0x0000000d requires both RCX and XCR0, so it can't be
> +	 * cached.
> +	 */
> +	if (lo == 0x0000000d)
> +		return ULONG_MAX;
> +
> +	/*
> +	 * Some callers of CPUID don't always set RCX to zero for CPUID
> +	 * functions that don't require RCX, which can result in excessive
> +	 * cached values, so RCX needs to be manually zeroed for use as part
> +	 * of the cache index. Future CPUID values may need RCX, but since
> +	 * they can't be known, they must not be cached.
> +	 */
> +	if (lo > 0x80000020)
> +		return ULONG_MAX;
> +
> +	switch (lo) {
> +	case 0x00000007:
> +	case 0x0000000b:
> +	case 0x0000000f:
> +	case 0x00000010:
> +	case 0x8000001d:
> +	case 0x80000020:
> +		hi = ctxt->regs->cx << 32;
> +		break;
> +	default:
> +		hi = 0;
> +	}
> +
> +	return hi | lo;
> +}
> +
> +static bool sev_es_check_cpuid_cache(struct es_em_ctxt *ctxt,
> +				     unsigned long cache_index)
> +{
> +	struct sev_es_cpuid_cache_entry *cache_entry;
> +
> +	if (cache_index == ULONG_MAX)
> +		return false;
> +
> +	cache_entry = xa_load(&sev_es_cpuid_cache, cache_index);
> +	if (!cache_entry)
> +		return false;
> +
> +	ctxt->regs->ax = cache_entry->eax;
> +	ctxt->regs->bx = cache_entry->ebx;
> +	ctxt->regs->cx = cache_entry->ecx;
> +	ctxt->regs->dx = cache_entry->edx;
> +
> +	return true;
> +}
> +
> +static void sev_es_add_cpuid_cache(struct es_em_ctxt *ctxt,
> +				   unsigned long cache_index)
> +{
> +	struct sev_es_cpuid_cache_entry *cache_entry;
> +	int ret;
> +
> +	if (cache_index == ULONG_MAX)
> +		return;
> +
> +	cache_entry = kzalloc(sizeof(*cache_entry), GFP_ATOMIC);
> +	if (cache_entry) {
> +		cache_entry->eax = ctxt->regs->ax;
> +		cache_entry->ebx = ctxt->regs->bx;
> +		cache_entry->ecx = ctxt->regs->cx;
> +		cache_entry->edx = ctxt->regs->dx;
> +
> +		/* Ignore insertion errors */
> +		ret = xa_insert(&sev_es_cpuid_cache, cache_index,
> +				cache_entry, GFP_ATOMIC);

Just realized, that on error, the cache_entry should be freed.

Thanks,
Tom

> +	}
> +}
> +
>   static enum es_result vc_handle_dr7_write(struct ghcb *ghcb,
>   					  struct es_em_ctxt *ctxt)
>   {
> @@ -895,6 +994,24 @@ static enum es_result vc_handle_trap_db(struct ghcb *ghcb,
>   	return ES_EXCEPTION;
>   }
>   
> +static enum es_result vc_handle_cpuid_cached(struct ghcb *ghcb,
> +					     struct es_em_ctxt *ctxt)
> +{
> +	unsigned long cache_index;
> +	enum es_result result;
> +
> +	cache_index = sev_es_get_cpuid_cache_index(ctxt);
> +
> +	if (sev_es_check_cpuid_cache(ctxt, cache_index))
> +		return ES_OK;
> +
> +	result = vc_handle_cpuid(ghcb, ctxt);
> +	if (result == ES_OK)
> +		sev_es_add_cpuid_cache(ctxt, cache_index);
> +
> +	return result;
> +}
> +
>   static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
>   					 struct ghcb *ghcb,
>   					 unsigned long exit_code)
> @@ -926,7 +1043,7 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
>   		result = ES_UNSUPPORTED;
>   		break;
>   	case SVM_EXIT_CPUID:
> -		result = vc_handle_cpuid(ghcb, ctxt);
> +		result = vc_handle_cpuid_cached(ghcb, ctxt);
>   		break;
>   	case SVM_EXIT_IOIO:
>   		result = vc_handle_ioio(ghcb, ctxt);
> 
