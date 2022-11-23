Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B23635F91
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 14:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237184AbiKWN25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 08:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbiKWN2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 08:28:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87BFE098;
        Wed, 23 Nov 2022 05:07:44 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANBDWM9029481;
        Wed, 23 Nov 2022 13:07:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=UpeM83Nyfeedx92a9CK9WQeo+2YuYhwIHLCyxc/JTko=;
 b=r8M/J8N4T5VIC8CnvOP8KES9L9m/GvelE4CZt886kOiXWWAyqDd928pYbLBga/RSq3w9
 aLqeRvrqW18DE7WzwKLNTN+gLbJ1j1TB8Q25nQVQRbmnRtLIgVRsd978SWCA9L67VmPf
 myEru7b/No7ntr0MZbc12uLwljrWePiFQGn+aCbc1eWN2OH+eIgEj+6TuRZkIhwFl2LI
 N5ohRJ+kgyIN7H/Xz7+ru9j8rhCXkk7PH+/oI0wm2PXO2fXFSXdvkUQzcSlhwqCvIBYa
 KWYax73Lq7XIaqEkDts5eBrapgcXKXvhJj3wXfiwx1yvpFy5tS68XV5p8VbrTb8INMpm zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100sx6xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:43 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ANBo7Ul025441;
        Wed, 23 Nov 2022 13:07:43 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100sx6wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AND5H7W009565;
        Wed, 23 Nov 2022 13:07:41 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3kxpdhwrtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:41 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AND7c3b35521270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 13:07:38 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C621A405F;
        Wed, 23 Nov 2022 13:07:38 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A718A405B;
        Wed, 23 Nov 2022 13:07:38 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 13:07:38 +0000 (GMT)
Date:   Wed, 23 Nov 2022 14:01:18 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 5/5] lib: s390x: Handle debug prints for
 SIE exceptions correctly
Message-ID: <20221123140118.25114940@p-imbrenda>
In-Reply-To: <20221123084656.19864-6-frankja@linux.ibm.com>
References: <20221123084656.19864-1-frankja@linux.ibm.com>
        <20221123084656.19864-6-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ka7sFnv4pWgyM00-IxyK6p_TG9Gp0xPe
X-Proofpoint-ORIG-GUID: 0E2yiOZXOfbiDzBZzj0jfRBbQzh-u_Hl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=971 adultscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Nov 2022 08:46:56 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> When we leave SIE due to an exception, we'll still have guest values
> in registers 0 - 13 and that's not clearly portraied in our debug
> prints. So let's fix that.

wouldn't it be cleaner to restore the registers in the interrupt
handler? (I thought we were already doing it)

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/interrupt.c | 46 ++++++++++++++++++++++++++++++++++++++-----
>  lib/s390x/sie.h       |  2 ++
>  s390x/cpu.S           |  6 ++++--
>  3 files changed, 47 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index dadb7415..ff47c2c2 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -9,6 +9,7 @@
>   */
>  #include <libcflat.h>
>  #include <asm/barrier.h>
> +#include <asm/asm-offsets.h>
>  #include <sclp.h>
>  #include <interrupt.h>
>  #include <sie.h>
> @@ -188,9 +189,12 @@ static void print_storage_exception_information(void)
>  	}
>  }
>  
> -static void print_int_regs(struct stack_frame_int *stack)
> +static void print_int_regs(struct stack_frame_int *stack, bool sie)
>  {
> +	struct kvm_s390_sie_block *sblk;
> +
>  	printf("\n");
> +	printf("%s\n", sie ? "Guest registers:" : "Host registers:");
>  	printf("GPRS:\n");
>  	printf("%016lx %016lx %016lx %016lx\n",
>  	       stack->grs1[0], stack->grs1[1], stack->grs0[0], stack->grs0[1]);
> @@ -198,24 +202,56 @@ static void print_int_regs(struct stack_frame_int *stack)
>  	       stack->grs0[2], stack->grs0[3], stack->grs0[4], stack->grs0[5]);
>  	printf("%016lx %016lx %016lx %016lx\n",
>  	       stack->grs0[6], stack->grs0[7], stack->grs0[8], stack->grs0[9]);
> -	printf("%016lx %016lx %016lx %016lx\n",
> -	       stack->grs0[10], stack->grs0[11], stack->grs0[12], stack->grs0[13]);
> +
> +	if (sie) {
> +		sblk = (struct kvm_s390_sie_block *)stack->grs0[12];
> +		printf("%016lx %016lx %016lx %016lx\n",
> +		       stack->grs0[10], stack->grs0[11], sblk->gg14, sblk->gg15);
> +	} else {
> +		printf("%016lx %016lx %016lx %016lx\n",
> +		       stack->grs0[10], stack->grs0[11], stack->grs0[12], stack->grs0[13]);
> +	}
> +
>  	printf("\n");
>  }
>  
>  static void print_pgm_info(struct stack_frame_int *stack)
>  
>  {
> -	bool in_sie;
> +	bool in_sie, in_sie_gregs;
> +	struct vm_save_area *vregs;
>  
>  	in_sie = (lowcore.pgm_old_psw.addr >= (uintptr_t)sie_entry &&
>  		  lowcore.pgm_old_psw.addr <= (uintptr_t)sie_exit);
> +	in_sie_gregs = (lowcore.pgm_old_psw.addr >= (uintptr_t)sie_entry_gregs &&
> +			lowcore.pgm_old_psw.addr <= (uintptr_t)sie_exit_gregs);
>  
>  	printf("\n");
>  	printf("Unexpected program interrupt %s: %#x on cpu %d at %#lx, ilen %d\n",
>  	       in_sie ? "in SIE" : "",
>  	       lowcore.pgm_int_code, stap(), lowcore.pgm_old_psw.addr, lowcore.pgm_int_id);
> -	print_int_regs(stack);
> +
> +	/*
> +	 * If we fall out of SIE before loading the host registers,
> +	 * then we need to do it here so we print the host registers
> +	 * and not the guest registers.
> +	 *
> +	 * Back tracing is actually not a problem since SIE restores gr15.
> +	 */
> +	if (in_sie_gregs) {
> +		print_int_regs(stack, true);
> +		vregs = *((struct vm_save_area **)(stack->grs0[13] + __SF_SIE_SAVEAREA));
> +
> +		/*
> +		 * The grs are not linear on the interrupt stack frame.
> +		 * We copy 0 and 1 here and 2 - 15 with the memcopy below.
> +		 */
> +		stack->grs1[0] = vregs->host.grs[0];
> +		stack->grs1[1] = vregs->host.grs[1];
> +		/*  2 - 15 */
> +		memcpy(stack->grs0, &vregs->host.grs[2], sizeof(stack->grs0) - 8);
> +	}
> +	print_int_regs(stack, false);
>  	dump_stack();
>  
>  	/* Dump stack doesn't end with a \n so we add it here instead */
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index a27a8401..147cb0f2 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -273,6 +273,8 @@ struct vm {
>  
>  extern void sie_entry(void);
>  extern void sie_exit(void);
> +extern void sie_entry_gregs(void);
> +extern void sie_exit_gregs(void);
>  extern void sie64a(struct kvm_s390_sie_block *sblk, struct vm_save_area *save_area);
>  void sie(struct vm *vm);
>  void sie_expect_validity(struct vm *vm);
> diff --git a/s390x/cpu.S b/s390x/cpu.S
> index 45bd551a..9155b044 100644
> --- a/s390x/cpu.S
> +++ b/s390x/cpu.S
> @@ -82,7 +82,8 @@ sie64a:
>  	# Store scb and save_area pointer into stack frame
>  	stg	%r2,__SF_SIE_CONTROL(%r15)	# save control block pointer
>  	stg	%r3,__SF_SIE_SAVEAREA(%r15)	# save guest register save area
> -
> +.globl sie_entry_gregs
> +sie_entry_gregs:
>  	# Load guest's gprs, fprs and fpc
>  	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>  	ld	\i, \i * 8 + SIE_SAVEAREA_GUEST_FPRS(%r3)
> @@ -121,7 +122,8 @@ sie_exit:
>  	.endr
>  	lfpc	SIE_SAVEAREA_HOST_FPC(%r14)
>  	lmg	%r0,%r14,SIE_SAVEAREA_HOST_GRS(%r14)	# restore kernel registers
> -
> +.globl sie_exit_gregs
> +sie_exit_gregs:
>  	br	%r14
>  
>  	.align	8

