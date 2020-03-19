Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE4418BD1B
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 17:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgCSQxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 12:53:44 -0400
Received: from mail-eopbgr80083.outbound.protection.outlook.com ([40.107.8.83]:38629
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727222AbgCSQxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 12:53:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZef/2tsNl6MxIxfE1CbaD9+1sksmj6fvGiEBPATJqUVsRc9+ovj1gz//UCzHiT8+il5LJlHYOoJxaAZTA3TRMo/2JMjmcH8bBcD+mIw3cjGQFMWAdBSe7EzufCPZUeou6oEFImlX2RbpmxcTmnXQbkzjszG+NqOBhoTFAwfsNxbJkQ3itO2b/dL8UxL63nxgxtwE+XBCenuOgBYy45+fV2nGCC3bV2b+7NTQ4tAncw5Ines8gPkDBQApxSTNdojWRA2AbQbXgMS3PIjxgWu8Gfxm43PDRX5h+mPZFLhKHZezJlis7k29t/C3CesnMf04eDD+2BRIVVFLHugoQVwqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZ0s8owviYsusXyvUDUfUHFHaKT1YiXj0BQeYZAy0YY=;
 b=n28yURmwhm+i+AMmtYvr4uCuv0V6pR28KOoRc+XkdFk30hUYpIQeur1DBgcTPZXhEKw/FKgYioJwAUVRPRE1uFAlPtbKci31tmlmva7jq7f1hAMBiCwLgCx2kg8LmWL6FB+3TwUepoy39GYho41tURhO6YtmJF6k5qP6WAsI9W7sVrP4gFdWgFcLoghDM6Fx+H5O0fx+oG+hWf6cpwaxv/BpJCiuszdRlbOsJwCYnzo5uSBJ3m26CbkpTCumeKxk7wy5K4qZKMaM4GBo6vw6OCv5ZJhrVk9gVzxDxmVriStPBNrhH0rHCpLO6bxIUgfUm/I7VFeYmFVmiHOgOy5vrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nextfour.com; dmarc=pass action=none header.from=nextfour.com;
 dkim=pass header.d=nextfour.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NextfourGroupOy.onmicrosoft.com;
 s=selector2-NextfourGroupOy-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZ0s8owviYsusXyvUDUfUHFHaKT1YiXj0BQeYZAy0YY=;
 b=ThNhDcHQitJVyhyOQfhRsuDGQpd7MIEpvL4cTS4xHE/+ApHopXtgNbC0B+DagqPXcSGmE64hZPHf2YynN87qA7dLcjhoewTHk+teckk6arnudh2ml89hK22xiznfyFOqfRJPIKvdtcZLDnWmlRyoXV2N09oecIB+N6DET2VB/e4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=mika.penttila@nextfour.com; 
Received: from VI1PR03MB3775.eurprd03.prod.outlook.com (52.134.21.155) by
 VI1PR03MB4301.eurprd03.prod.outlook.com (20.177.51.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Thu, 19 Mar 2020 16:53:33 +0000
Received: from VI1PR03MB3775.eurprd03.prod.outlook.com
 ([fe80::ed88:2188:604c:bfcc]) by VI1PR03MB3775.eurprd03.prod.outlook.com
 ([fe80::ed88:2188:604c:bfcc%7]) with mapi id 15.20.2835.017; Thu, 19 Mar 2020
 16:53:32 +0000
Subject: Re: [PATCH 70/70] x86/sev-es: Add NMI state tracking
To:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org
Cc:     hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-71-joro@8bytes.org>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
Message-ID: <d5cdbf9a-2f5f-cb2b-9c52-61fd844e3f3b@nextfour.com>
Date:   Thu, 19 Mar 2020 18:53:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200319091407.1481-71-joro@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: HE1PR09CA0051.eurprd09.prod.outlook.com
 (2603:10a6:7:3c::19) To VI1PR03MB3775.eurprd03.prod.outlook.com
 (2603:10a6:803:2b::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.121] (91.145.109.188) by HE1PR09CA0051.eurprd09.prod.outlook.com (2603:10a6:7:3c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Thu, 19 Mar 2020 16:53:31 +0000
X-Originating-IP: [91.145.109.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c0a6a5a-f9c9-4e5c-a06e-08d7cc260e94
X-MS-TrafficTypeDiagnostic: VI1PR03MB4301:
X-Microsoft-Antispam-PRVS: <VI1PR03MB43018754D9FEEED24670340383F40@VI1PR03MB4301.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0347410860
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(366004)(39830400003)(376002)(199004)(186003)(16526019)(508600001)(31696002)(7416002)(86362001)(2906002)(36756003)(54906003)(4326008)(5660300002)(16576012)(316002)(52116002)(2616005)(26005)(8936002)(956004)(31686004)(81166006)(66946007)(66556008)(81156014)(6486002)(8676002)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR03MB4301;H:VI1PR03MB3775.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nextfour.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iuXf9ibzd+QZYIwB2G9/90RphBGjBBUTmaxoQlNEtsgFkKoGw4/KfiLbOTa1vhuI+JWcdtbuU/ylVXFkc1iQsXlQ6zD7dZMog10H1lddF+GmwM//HqK3Uz/M0qx/u7dPH2ZMiTmaVSK4WnO8qUuWVAvoWTvSLb5xtkQ94/KeElr+cM+IxVN6uU85MaVXGGvqS0N3Ikplc+4ygbRrlP5LvD5YpVxhanBN+bJvX/9SCYqD3c40qzZJHjNRInjVaa4tA5wvJdeDmH/3dPLgG5y+Z0/TQRWZ6cvG5SX8c1RyMrzfAFAjnyOzbJpl5Yef2wEjKKZf0l88vZP2JMUb7jFZm6EA2P4v+D/cQk1MbnbB0OqLeMEcKbouTQsJsK3UJ8jCvKjINKaW72Lid6fiO06U+4olJnjca6BAeERHgojUJ0AJoRWwS8n1t5Ktjhze90ss
X-MS-Exchange-AntiSpam-MessageData: lMvGmqnDKCDPPnX+IRG0RkvUkTzGVB8vkaIny3a8Wk0lfrg73GRXWQYNLCg2oiiNsCFTk67WlCN9gvLvm9MbLBGb/EGL2zZnSaJtauyrM3/z7v+EdkYG5shUjItF0RX4BTHcEDg5gUnMTYdWa9ZxMg==
X-OriginatorOrg: nextfour.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c0a6a5a-f9c9-4e5c-a06e-08d7cc260e94
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2020 16:53:32.6726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 972e95c2-9290-4a02-8705-4014700ea294
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /wcwYeyCxZO9tH12LTs3vwO5BRg5j7lldcwPc2zfYYYPTLvxfV8Gq9Q+usGFd7uYiLHxqjD2A8++v9Ze1nGZXHXScQOJa7t2IsYZLRvcuqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB4301
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi!

On 19.3.2020 11.14, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
>
> Keep NMI state in SEV-ES code so the kernel can re-enable NMIs for the
> vCPU when it reaches IRET.
>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>   arch/x86/entry/entry_64.S       | 48 +++++++++++++++++++++++++++++++++
>   arch/x86/include/asm/sev-es.h   | 27 +++++++++++++++++++
>   arch/x86/include/uapi/asm/svm.h |  1 +
>   arch/x86/kernel/nmi.c           |  8 ++++++
>   arch/x86/kernel/sev-es.c        | 31 ++++++++++++++++++++-
>   5 files changed, 114 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 729876d368c5..355470b36896 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -38,6 +38,7 @@
>   #include <asm/export.h>
>   #include <asm/frame.h>
>   #include <asm/nospec-branch.h>
> +#include <asm/sev-es.h>
>   #include <linux/err.h>
>   
>   #include "calling.h"
> @@ -629,6 +630,13 @@ SYM_INNER_LABEL(swapgs_restore_regs_and_return_to_usermode, SYM_L_GLOBAL)
>   	ud2
>   1:
>   #endif
> +
> +	/*
> +	 * This code path is used by the NMI handler, so check if NMIs
> +	 * need to be re-enabled when running as an SEV-ES guest.
> +	 */
> +	SEV_ES_IRET_CHECK
> +
>   	POP_REGS pop_rdi=0
>   
>   	/*
> @@ -1474,6 +1482,8 @@ SYM_CODE_START(nmi)
>   	movq	$-1, %rsi
>   	call	do_nmi
>   
> +	SEV_ES_NMI_COMPLETE
> +
>   	/*
>   	 * Return back to user mode.  We must *not* do the normal exit
>   	 * work, because we don't want to enable interrupts.
> @@ -1599,6 +1609,7 @@ nested_nmi_out:
>   	popq	%rdx
>   
>   	/* We are returning to kernel mode, so this cannot result in a fault. */
> +	SEV_ES_NMI_COMPLETE
>   	iretq
>   
>   first_nmi:
> @@ -1687,6 +1698,12 @@ end_repeat_nmi:
>   	movq	$-1, %rsi
>   	call	do_nmi
>   
> +	/*
> +	 * When running as an SEV-ES guest, jump to the SEV-ES NMI IRET
> +	 * path.
> +	 */
> +	SEV_ES_NMI_COMPLETE
> +
>   	/* Always restore stashed CR3 value (see paranoid_entry) */
>   	RESTORE_CR3 scratch_reg=%r15 save_reg=%r14
>   
> @@ -1715,6 +1732,9 @@ nmi_restore:
>   	std
>   	movq	$0, 5*8(%rsp)		/* clear "NMI executing" */
>   
> +nmi_return:
> +	UNWIND_HINT_IRET_REGS
> +
>   	/*
>   	 * iretq reads the "iret" frame and exits the NMI stack in a
>   	 * single instruction.  We are returning to kernel mode, so this
> @@ -1724,6 +1744,34 @@ nmi_restore:
>   	iretq
>   SYM_CODE_END(nmi)
>   
> +#ifdef CONFIG_AMD_MEM_ENCRYPT

> +SYM_CODE_START(sev_es_iret_user)


What makes kernel jump here? Can't see this referenced from anywhere?


> +	UNWIND_HINT_IRET_REGS offset=8
> +	/*
> +	 * The kernel jumps here directly from
> +	 * swapgs_restore_regs_and_return_to_usermode. %rsp points already to
> +	 * trampoline stack, but %cr3 is still from kernel. User-regs are live
> +	 * except %rdi. Switch to user CR3, restore user %rdi and user gs_base
> +	 * and single-step over IRET
> +	 */
> +	SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi
> +	popq	%rdi
> +	SWAPGS
> +	/*
> +	 * Enable single-stepping and execute IRET. When IRET is
> +	 * finished the resulting #DB exception will cause a #VC
> +	 * exception to be raised. The #VC exception handler will send a
> +	 * NMI-complete message to the hypervisor to re-open the NMI
> +	 * window.
> +	 */
> +sev_es_iret_kernel:
> +	pushf
> +	btsq $X86_EFLAGS_TF_BIT, (%rsp)
> +	popf
> +	iretq
> +SYM_CODE_END(sev_es_iret_user)
> +#endif
> +
>   #ifndef CONFIG_IA32_EMULATION
>   /*
>    * This handles SYSCALL from 32-bit code.  There is no way to program
> diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
> index 63acf50e6280..d866adb3e6d4 100644
> --- a/arch/x86/include/asm/sev-es.h
> +++ b/arch/x86/include/asm/sev-es.h
> @@ -8,6 +8,8 @@
>   #ifndef __ASM_ENCRYPTED_STATE_H
>   #define __ASM_ENCRYPTED_STATE_H
>   
> +#ifndef __ASSEMBLY__
> +
>   #include <linux/types.h>
>   #include <asm/insn.h>
>   
> @@ -82,11 +84,36 @@ struct real_mode_header;
>   
>   #ifdef CONFIG_AMD_MEM_ENCRYPT
>   int sev_es_setup_ap_jump_table(struct real_mode_header *rmh);
> +void sev_es_nmi_enter(void);
>   #else /* CONFIG_AMD_MEM_ENCRYPT */
>   static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
>   {
>   	return 0;
>   }
> +static inline void sev_es_nmi_enter(void) { }
> +#endif /* CONFIG_AMD_MEM_ENCRYPT*/
> +
> +#else /* !__ASSEMBLY__ */
> +
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#define SEV_ES_NMI_COMPLETE		\
> +	ALTERNATIVE	"", "callq sev_es_nmi_complete", X86_FEATURE_SEV_ES_GUEST
> +
> +.macro	SEV_ES_IRET_CHECK
> +	ALTERNATIVE	"jmp	.Lend_\@", "", X86_FEATURE_SEV_ES_GUEST
> +	movq	PER_CPU_VAR(sev_es_in_nmi), %rdi
> +	testq	%rdi, %rdi
> +	jz	.Lend_\@
> +	callq	sev_es_nmi_complete
> +.Lend_\@:
> +.endm
> +
> +#else  /* CONFIG_AMD_MEM_ENCRYPT */
> +#define	SEV_ES_NMI_COMPLETE
> +.macro	SEV_ES_IRET_CHECK
> +.endm
>   #endif /* CONFIG_AMD_MEM_ENCRYPT*/
>   
> +#endif /* __ASSEMBLY__ */
> +
>   #endif
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
> index 20a05839dd9a..0f837339db66 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -84,6 +84,7 @@
>   /* SEV-ES software-defined VMGEXIT events */
>   #define SVM_VMGEXIT_MMIO_READ			0x80000001
>   #define SVM_VMGEXIT_MMIO_WRITE			0x80000002
> +#define SVM_VMGEXIT_NMI_COMPLETE		0x80000003
>   #define SVM_VMGEXIT_AP_HLT_LOOP			0x80000004
>   #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
>   #define		SVM_VMGEXIT_SET_AP_JUMP_TABLE			0
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index 54c21d6abd5a..7312a6d4d50f 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -37,6 +37,7 @@
>   #include <asm/reboot.h>
>   #include <asm/cache.h>
>   #include <asm/nospec-branch.h>
> +#include <asm/sev-es.h>
>   
>   #define CREATE_TRACE_POINTS
>   #include <trace/events/nmi.h>
> @@ -510,6 +511,13 @@ NOKPROBE_SYMBOL(is_debug_stack);
>   dotraplinkage notrace void
>   do_nmi(struct pt_regs *regs, long error_code)
>   {
> +	/*
> +	 * For SEV-ES the kernel needs to track whether NMIs are blocked until
> +	 * IRET is reached, even when the CPU is offline.
> +	 */
> +	if (sev_es_active())
> +		sev_es_nmi_enter();
> +
>   	if (IS_ENABLED(CONFIG_SMP) && cpu_is_offline(smp_processor_id()))
>   		return;
>   
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index 3c22f256645e..409a7a2aa630 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -37,6 +37,7 @@ struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
>    */
>   struct ghcb __initdata *boot_ghcb;
>   static DEFINE_PER_CPU(unsigned long, cached_dr7) = DR7_RESET_VALUE;
> +DEFINE_PER_CPU(bool, sev_es_in_nmi) = false;
>   
>   struct ghcb_state {
>   	struct ghcb *ghcb;
> @@ -270,6 +271,31 @@ static phys_addr_t vc_slow_virt_to_phys(struct ghcb *ghcb, long vaddr)
>   /* Include code shared with pre-decompression boot stage */
>   #include "sev-es-shared.c"
>   
> +void sev_es_nmi_enter(void)
> +{
> +	this_cpu_write(sev_es_in_nmi, true);
> +}
> +
> +void sev_es_nmi_complete(void)
> +{
> +	struct ghcb_state state;
> +	struct ghcb *ghcb;
> +
> +	ghcb = sev_es_get_ghcb(&state);
> +
> +	vc_ghcb_invalidate(ghcb);
> +	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_NMI_COMPLETE);
> +	ghcb_set_sw_exit_info_1(ghcb, 0);
> +	ghcb_set_sw_exit_info_2(ghcb, 0);
> +
> +	sev_es_wr_ghcb_msr(__pa(ghcb));
> +	VMGEXIT();
> +
> +	sev_es_put_ghcb(&state);
> +
> +	this_cpu_write(sev_es_in_nmi, false);
> +}
> +
>   static u64 sev_es_get_jump_table_addr(void)
>   {
>   	struct ghcb_state state;
> @@ -891,7 +917,10 @@ static enum es_result vc_handle_vmmcall(struct ghcb *ghcb,
>   static enum es_result vc_handle_db_exception(struct ghcb *ghcb,
>   					     struct es_em_ctxt *ctxt)
>   {
> -	do_debug(ctxt->regs, 0);
> +	if (this_cpu_read(sev_es_in_nmi))
> +		sev_es_nmi_complete();
> +	else
> +		do_debug(ctxt->regs, 0);
>   
>   	/* Exception event, do not advance RIP */
>   	return ES_RETRY;

