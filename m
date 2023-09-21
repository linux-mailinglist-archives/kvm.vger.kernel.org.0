Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB7D7AA247
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbjIUVPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbjIUVOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:14:51 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2044.outbound.protection.outlook.com [40.107.8.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6B03A99;
        Thu, 21 Sep 2023 10:03:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LO42/PrvKoII8kw5Wxe6N/3e196hE2RagyBqIp7qvhVW57fvxr44E8jQzBG21RaIaHhkU6fEoItJ8svX3eBjKhhmHk24ClMR6dsluaIZ1LE0bZWAd7q2RAz68HZkhz5hFaWwD2/ABa1Tzm+D/b1IdIXi7S1WJyZsAURkjFsqxScMaR5rAUtGSvVDnN4n2vH8NweeRuzV1bShU1Kirstix1QAJyBqiv+OwoWvYG6KOrIgH9ZEjTVVvtFEssT28d+BcK11l7zXh0CMkKx69ryjazEoZhwhzGNJmERTIBWM1+/tH6w2gfMzFeJptytKh6MI1Ipw23n+SgUuzy41QNqeDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H9IV9WD6UoE+UWKkaa5daXyJPGea+Ww6mWdg7JHay50=;
 b=TC3cHOpUMcLosovSArjiG7N3ZsXlxfA8Wmcr4wKtRYSKa4Ewnh55D6J33Qn9UYGfsLXRIbXr6v0IcY3+m6ptuURJjB4fjLXyzFIi9QurVI0giXEfpSZLBhjRSiXj32uw7wRu3kn6T25WbYhaGokIT6M2pEwooIwlmslMUPpEIv9wTZwwIY6VP202VHVddxWQXPZ31CFkHMZUjiI2wTMNVlcvA7iL2LDOCLZot+EcXqzD4m8ah9V8rt3f1yMrcdNS8Mbqh8dAhsdapV/z1kC2gRvtJ/LfYq5K/vK8s+i9Bi3eqYP2Va/rbeAPPsVRjl3CaJdAwTyIqY5qusadgRl4PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9IV9WD6UoE+UWKkaa5daXyJPGea+Ww6mWdg7JHay50=;
 b=Uqg9Vq3KoSd7gphRgPNghZ4jpjiZcpXv70UocHAZTL4aia6YoOoz6RquxMWVcery9xCpXPzjodfTjhX1LzngMg5c0Nh2Fh6XSrI49t91ramDTM1DlB7QOFCPZnLVjUN8F0iZ7Gd1lb6t0XFDK3oE2L4xCc34LcBlCUfGliL+nE1SQtcs4wxpm0AhyFuDBTNMtS290h0zP6cn9x9l7Vz7Mb2UUxpjZ3PWkVHp/pHaVnP+/QsYoOV8hfx3wcXUTu/yRxWB0mOln/nnRlwdRFqiTdO/1NezXc3gmr469qTWU0ncXRnYYzIj5hbjTssMx5HTYH7V5F4WAiLqTltJD3W8Jw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AM0PR04MB6801.eurprd04.prod.outlook.com (2603:10a6:208:18d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Thu, 21 Sep
 2023 12:11:27 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61%4]) with mapi id 15.20.6813.017; Thu, 21 Sep 2023
 12:11:26 +0000
Message-ID: <8163cf98-8968-72a4-4193-1ca9f019d9ff@suse.com>
Date:   Thu, 21 Sep 2023 15:11:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v10 33/38] x86/entry: Add fred_entry_from_kvm() for VMX to
 handle IRQ/NMI
Content-Language: en-US
To:     Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-34-xin3.li@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <20230914044805.301390-34-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR08CA0253.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::26) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AM0PR04MB6801:EE_
X-MS-Office365-Filtering-Correlation-Id: f3ebf7a5-5cdd-4cd4-e24d-08dbba9be140
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YNLHD63wczbh8HeKxfw2i8WE0xaGtFTTWDIFZir5GzGUnBy12mRbcpkXcLvldydJZqpTVuYGV4XFMfFRGVfvs9dJevUIU4VY+Z3B7rGix0QAVm8AuPEvlpkgpVXPFAIYN3ej3I//EX0yA6hOQoWPOiIgWb0MTSYlx5fj052lHRMur+UjnO+B2N7ZcDJbPvXwJHcsX/SqcfV/We0isp9/HNg4LlD7ixWAwWXfi1MEksEI0OyQLIsaRc/nsLgr5hnfsPhzAVN3+rczKvd16KhisyS3VmFhukuJIsmt5pOmvL3LKI5E3uE2K3f5uCBS22Xl5gLPzgLq4HuFR7qZAcV3VMoRvx2r/HiUmNnl5bGnU3qHKJJ7qULyRtELRgokuI9bX2j7IW2UPhFZht3QWVj0l7L2C67thTb0IgqSgw1LcGu/dVylUeLgZq7ZbBeUn3SZRu0xWG1YfxRmZlvwtdP4ZECPnRl5yOa8KVK5a/HxHyqI+9luKyvO5uUsft0J7VsNra5jqyAQhB5VB9+zBhwu8yEgZV0nu4D/U60LmlFf4P8RQimLnu52W3Nq3IjN7P5ygMX5Ef4G8qf/hHETGQxHNyiUxxYOOqGl8tJbN0l9s+uCA8dl8kB9+8y6eCAOGKtul8Un7JtpXCcFbhZCR7GHmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199024)(186009)(1800799009)(31686004)(6486002)(6666004)(6506007)(38100700002)(478600001)(36756003)(31696002)(86362001)(316002)(83380400001)(7416002)(2906002)(4326008)(41300700001)(5660300002)(8676002)(66476007)(8936002)(66556008)(26005)(6512007)(2616005)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUR4RmtBclduM3llNFA2SkpxODRNcFlSZkRVYW5HR0RqN1JkSUFWUm1tandB?=
 =?utf-8?B?Z1VUbUhhUGRCOWNvSWorS1l2REltcDFTOENZY1luNFRJUU54bTY0Tlgwb1Bw?=
 =?utf-8?B?dmpqcXk4MGtDSTdDVFd1NmZUM0l1VUFYVWF3di9MWkh6QWltUjRJc09OU2tP?=
 =?utf-8?B?MUhJa0I1Nnl2SmZoOXlUUkJtK2RxTm1hYmgvbmhpOHR1ejBZNU1tM3dHdmlH?=
 =?utf-8?B?NXhjNHcwYnN4RVBZTytMZG9zTXBFZFVzQ1EvVzRPc2JwT3JBTFlzWkJJVnQy?=
 =?utf-8?B?MkdEZVZzRm9tcGEvMlI4QVp5Z1lFWEluSVdNQmxvNTBWRys3T3NQWjlnbmFz?=
 =?utf-8?B?UXNTUDluRXdSTXBoODNGWGNKR1NCVFlKN2JuYTdlaWpuTjhFUzJLdjNWbW9L?=
 =?utf-8?B?aHpBbGxCTEZuaFJGcEFQZzZkcWV5d0F4UVo3MHU4bm96WkNBL29Zb1RwWGlR?=
 =?utf-8?B?QUtnMFdDU2ZWSFFKVHZNUHVkZHNIYjFIdCtKcjFXTVVKM2xIZjFnWXhML2dL?=
 =?utf-8?B?Y3NVay9mdXZLR3NpUisyWkZBbWpTbkJRM2E1UnNaalV1cTNydEhDUWdaQit6?=
 =?utf-8?B?dDFKTTFIekIwUVZXWG5FV0o0WjJNM0UvYzZqbFBkU3pEUEZKM2V3N0xWNmlo?=
 =?utf-8?B?MDBROGtqRFlHM0pLaGxvaFFjaFNoU09OTmZ5N3BMYXRuUEJGQnhnbWtSci90?=
 =?utf-8?B?Q3Z6ejFnZnJhek1MTytLcG5aU3BITzAxSWREV1E4N2l5RDlNbHltN1BFTFpD?=
 =?utf-8?B?Z3VTVmp0eHEwbEpOSW53RlFKUXAyU0J4bVB3anQ0WTUvQUNJdGo4VytmT2hk?=
 =?utf-8?B?MDRsNDJ0Y1J4SS83bm9VR1JWd3lIZkl5algzYUoxN3NYNDZqeGx0U0EveENo?=
 =?utf-8?B?cVJGbFhwaXVsVnUyU3JxU3VXNlVvUXhmdjlRcUNWUmR6M3NQMFNBZjB3a00z?=
 =?utf-8?B?TzZ4RWtOY3VFY0xmbC9wYmg5QSs0ZHFnQ2FSa1lVZXNpeFYvR1hlclRTMTRU?=
 =?utf-8?B?VlFLWDB4UnNmbUM5dU03OUphaGo1LzJRZjIvbkZOMkYvd1BvM3B4dEZsS1RW?=
 =?utf-8?B?a0xpblZkMTVZRlRVeG4zSkFxREJBK2ZUdEFUMG9zNWpUTzdkNTBZNkYydVpN?=
 =?utf-8?B?QzdkejFPYnkxdE9mMWRLWjBSZUE1SjJ1Q3MrNjZJTUJmMG9mQWc5Y2laend0?=
 =?utf-8?B?a2ZPQ2c1cFlEbFhTRTB6M212aHg1TmZmZEQ1Wm83T2lycXlNY2NBTGViNWlO?=
 =?utf-8?B?eElYMjdHM0lHWjlpbTNWNDRvaTQrekFwWVorMVVyaG9hOTVrTWVDNjI2V0kx?=
 =?utf-8?B?aFZLbGVDSUR1QXRDQ0k0L29Na3p5RU1zYlhqVkJOUUdTd3VWc3p6SEpHOStQ?=
 =?utf-8?B?anF1c1RLVlRDWjNvYlBpakR2cGg2V25xb3pka1Z6L1NwazRmWTU2azNqZ2Za?=
 =?utf-8?B?bVdYb0hSSVRJalp0U3VKa21GQkRtQjFyU3Q4RENwUDllajFYazlnSFNxR0JB?=
 =?utf-8?B?cFEvVEp4ajNxTWhJV01vM1hZWUtUWnpNY3BqcncvcjduYWFNVE5PZ1ZhZjli?=
 =?utf-8?B?Kzc2R2NvaUtPT3FZQzZiUW5FdnZsQ3FZem05R0Ztdm5KMDJ4WHl4UXJjZFdN?=
 =?utf-8?B?Vk03OUt1RDhHZEJHTC82SW85R1FIWEYwTFg1amI5MUxQSkZReCtJckZBWGgw?=
 =?utf-8?B?c3RjUVlwRXlMZXBpNm9WVWRqeDBjYnIyNlZuMmZsdUxhc2FpKzNXd0pBYnBX?=
 =?utf-8?B?dTh1TTFGbjlGOXBtc3YyZVNGaFNWR3ZtTDNSUlpUNHVYVkR0MW8wTkJVYTFE?=
 =?utf-8?B?VUxnSTVIUmpzN0V6Z0VVQVM2bjRDc3pPSklJMUFQbXFCUFpOempiT2R0WGZr?=
 =?utf-8?B?Qk9LZ3JRdXhmemJBUEVpdldZUURRbTZ6SG9GY1hJeUFOOFIvV0UrWjI1Z1ow?=
 =?utf-8?B?VWdDL2VKdXdHMXp5cFBzdEpkTEJwdU1VVEdQbFpWTFVjUVN4cklQeWRIUmlv?=
 =?utf-8?B?djA2U1VmVWQzSXBPTEJRZzU1eHVKNE1FL1VCNHU1Q0NhTFRoWkFFUTVqWmNE?=
 =?utf-8?B?aVY0MW5VNldPaWRwQkJ5dFlZRE9rb2tFUlpzV0kycUZ2RStkU2hoWlVkSU04?=
 =?utf-8?Q?6YchFrjPBqpcK6VZ3u/9bj57B?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ebf7a5-5cdd-4cd4-e24d-08dbba9be140
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 12:11:26.7228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QG6kBdutwZxJJYRWXoPMa9WDXMLFB2mf+GLKTzKfZN5Bi32rOz9/VM+u2/KIL10SiDHeSWKfFgb8vOGsNsEDrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6801
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.09.23 г. 7:48 ч., Xin Li wrote:
> In IRQ/NMI induced VM exits, KVM VMX needs to execute the respective
> handlers, which requires the software to create a FRED stack frame,
> and use it to invoke the handlers. Add fred_irq_entry_from_kvm() for
> this job.
> 
> Export fred_entry_from_kvm() because VMX can be compiled as a module.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
> 
> Changes since v9:
> * Shove the whole thing into arch/x86/entry/entry_64_fred.S for invoking
>    external_interrupt() and fred_exc_nmi() (Sean Christopherson).
> * Correct and improve a few comments (Sean Christopherson).
> * Merge the two IRQ/NMI asm entries into one as it's fine to invoke
>    noinstr code from regular code (Thomas Gleixner).
> * Setup the long mode and NMI flags in the augmented SS field of FRED
>    stack frame in C instead of asm (Thomas Gleixner).
> * Add UNWIND_HINT_{SAVE,RESTORE} to get rid of the warning: "objtool:
>    asm_fred_entry_from_kvm+0x0: unreachable instruction" (Peter Zijlstra).
> 
> Changes since v8:
> * Add a new macro VMX_DO_FRED_EVENT_IRQOFF for FRED instead of
>    refactoring VMX_DO_EVENT_IRQOFF (Sean Christopherson).
> * Do NOT use a trampoline, just LEA+PUSH the return RIP, PUSH the error
>    code, and jump to the FRED kernel entry point for NMI or call
>    external_interrupt() for IRQs (Sean Christopherson).
> * Call external_interrupt() only when FRED is enabled, and convert the
>    non-FRED handling to external_interrupt() after FRED lands (Sean
>    Christopherson).
> ---
>   arch/x86/entry/entry_64_fred.S | 73 ++++++++++++++++++++++++++++++++++
>   arch/x86/entry/entry_fred.c    | 14 +++++++
>   arch/x86/include/asm/fred.h    | 18 +++++++++
>   3 files changed, 105 insertions(+)
> 
> diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
> index d1c2fc4af8ae..f1088d6f2054 100644
> --- a/arch/x86/entry/entry_64_fred.S
> +++ b/arch/x86/entry/entry_64_fred.S
> @@ -4,7 +4,9 @@
>    */
>   
>   #include <asm/asm.h>
> +#include <asm/export.h>
>   #include <asm/fred.h>
> +#include <asm/segment.h>
>   
>   #include "calling.h"
>   
> @@ -54,3 +56,74 @@ SYM_CODE_START_NOALIGN(asm_fred_entrypoint_kernel)
>   	FRED_EXIT
>   	ERETS
>   SYM_CODE_END(asm_fred_entrypoint_kernel)
> +
> +#if IS_ENABLED(CONFIG_KVM_INTEL)
> +SYM_FUNC_START(asm_fred_entry_from_kvm)
> +	push %rbp
> +	mov %rsp, %rbp

use FRAME_BEGIN/FRAME_END macros to ommit this code if 
CONFIG_FRAME_POINTER is disabled.

> +
> +	UNWIND_HINT_SAVE
> +
> +	/*
> +	 * Don't check the FRED stack level, the call stack leading to this
> +	 * helper is effectively constant and shallow (relatively speaking).
> +	 *
> +	 * Emulate the FRED-defined redzone and stack alignment.
> +	 */
> +	sub $(FRED_CONFIG_REDZONE_AMOUNT << 6), %rsp
> +	and $FRED_STACK_FRAME_RSP_MASK, %rsp
> +
> +	/*
> +	 * Start to push a FRED stack frame, which is always 64 bytes:
> +	 *
> +	 * +--------+-----------------+
> +	 * | Bytes  | Usage           |
> +	 * +--------+-----------------+
> +	 * | 63:56  | Reserved        |
> +	 * | 55:48  | Event Data      |
> +	 * | 47:40  | SS + Event Info |
> +	 * | 39:32  | RSP             |
> +	 * | 31:24  | RFLAGS          |
> +	 * | 23:16  | CS + Aux Info   |
> +	 * |  15:8  | RIP             |
> +	 * |   7:0  | Error Code      |
> +	 * +--------+-----------------+
> +	 */
> +	push $0				/* Reserved, must be 0 */
> +	push $0				/* Event data, 0 for IRQ/NMI */
> +	push %rdi			/* fred_ss handed in by the caller */
> +	push %rbp
> +	pushf
> +	mov $__KERNEL_CS, %rax
> +	push %rax
> +
> +	/*
> +	 * Unlike the IDT event delivery, FRED _always_ pushes an error code
> +	 * after pushing the return RIP, thus the CALL instruction CANNOT be
> +	 * used here to push the return RIP, otherwise there is no chance to
> +	 * push an error code before invoking the IRQ/NMI handler.
> +	 *
> +	 * Use LEA to get the return RIP and push it, then push an error code.
> +	 */
> +	lea 1f(%rip), %rax
> +	push %rax				/* Return RIP */
> +	push $0					/* Error code, 0 for IRQ/NMI */
> +
> +	PUSH_AND_CLEAR_REGS clear_bp=0 unwind_hint=0
> +	movq %rsp, %rdi				/* %rdi -> pt_regs */
> +	call __fred_entry_from_kvm		/* Call the C entry point */
> +	POP_REGS
> +	ERETS
> +1:
> +	/*
> +	 * Objtool doesn't understand what ERETS does, this hint tells it that
> +	 * yes, we'll reach here and with what stack state. A save/restore pair
> +	 * isn't strictly needed, but it's the simplest form.
> +	 */
> +	UNWIND_HINT_RESTORE
> +	pop %rbp

FRAME_END

> +	RET
> +
> +SYM_FUNC_END(asm_fred_entry_from_kvm)
> +EXPORT_SYMBOL_GPL(asm_fred_entry_from_kvm);
> +#endif


<snip>
