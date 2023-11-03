Return-Path: <kvm+bounces-499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B22A87E0480
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 15:16:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2DDC1C20F7D
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 14:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E611A29F;
	Fri,  3 Nov 2023 14:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RiBO64/J"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E9819BC3
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 14:15:58 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C90D1BC;
	Fri,  3 Nov 2023 07:15:56 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3DtQZA017690;
	Fri, 3 Nov 2023 14:15:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=vPiyZo+Xn/xzw37s4xO+UA6wHwUZbxWndPmwtUrbauM=;
 b=RiBO64/JbQoDt6yf0pgvho0ThYf/+zNiRt7waLx06f1uSD4/A8ZUHa5R+ryua3KT8VrX
 +WJ4GhLq3HTHF4jvZRyi5lBnjIJT6GwVS3Wjs5bu1nz9wE8JD7O15gBQ310VQtaxe4KJ
 +DhDWaVCRuNIwsM2tfyDaEKZPdQgQD/HDiF6Ed8gBrdKLwCV07hmooaq1D1oxHc2LipK
 0I6E2dqWj7kHwzYE9G/prRIsKN4y9IIgEmbPOUYo9IAAHqwzIsdjSjWjDzoR0XZxV6sO
 I0EUxIaZK0hDuWqhTcKGvpreOBlvS3q/x0fmCGmxwn6/wAj3VupH5uvQSt9FuGhXeQf3 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u525ygqhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 14:15:55 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A3E3hIK025217;
	Fri, 3 Nov 2023 14:14:52 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u525ygmgt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 14:14:52 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3BxnYx011576;
	Fri, 3 Nov 2023 14:14:13 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1e4me9qe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 14:14:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A3EEAJS15401498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 14:14:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0645A20040;
	Fri,  3 Nov 2023 14:14:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D84BD2004E;
	Fri,  3 Nov 2023 14:14:09 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 14:14:09 +0000 (GMT)
Date: Fri, 3 Nov 2023 14:40:47 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v7 2/8] s390x: add function to set DAT
 mode for all interrupts
Message-ID: <20231103144047.6e53b68f@p-imbrenda>
In-Reply-To: <20231103092954.238491-3-nrb@linux.ibm.com>
References: <20231103092954.238491-1-nrb@linux.ibm.com>
	<20231103092954.238491-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 61B1glxIxkSjmCUQkMlRIVeOK3zYOjXz
X-Proofpoint-GUID: ZgMfgzL75faAQcPbkIEf71hhqJpe5VHL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_13,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 spamscore=0
 mlxlogscore=723 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310240000 definitions=main-2311030120

On Fri,  3 Nov 2023 10:29:31 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> When toggling DAT or switch address space modes, it is likely that
> interrupts should be handled in the same DAT or address space mode.
> 
> Add a function which toggles DAT and address space mode for all
> interruptions, except restart interrupts.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h  | 10 ++++++----
>  lib/s390x/asm/interrupt.h |  2 ++
>  lib/s390x/interrupt.c     | 35 +++++++++++++++++++++++++++++++++++
>  lib/s390x/mmu.c           |  5 +++--
>  4 files changed, 46 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index f629b6d0a17f..5beaf15b57e7 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -84,10 +84,12 @@ struct cpu {
>  	bool in_interrupt_handler;
>  };
>  
> -#define AS_PRIM				0
> -#define AS_ACCR				1
> -#define AS_SECN				2
> -#define AS_HOME				3
> +enum address_space {
> +	AS_PRIM = 0,
> +	AS_ACCR = 1,
> +	AS_SECN = 2,
> +	AS_HOME = 3
> +};
>  
>  #define PSW_MASK_DAT			0x0400000000000000UL
>  #define PSW_MASK_IO			0x0200000000000000UL
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index 35c1145f0349..d01f8a89641a 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -83,6 +83,8 @@ void expect_ext_int(void);
>  uint16_t clear_pgm_int(void);
>  void check_pgm_int_code(uint16_t code);
>  
> +void irq_set_dat_mode(bool use_dat, enum address_space as);
> +
>  /* Activate low-address protection */
>  static inline void low_prot_enable(void)
>  {
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 3f993a363ae2..e0a1713349f6 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -9,6 +9,7 @@
>   */
>  #include <libcflat.h>
>  #include <asm/barrier.h>
> +#include <asm/mem.h>
>  #include <asm/asm-offsets.h>
>  #include <sclp.h>
>  #include <interrupt.h>
> @@ -104,6 +105,40 @@ void register_ext_cleanup_func(void (*f)(struct stack_frame_int *))
>  	THIS_CPU->ext_cleanup_func = f;
>  }
>  
> +/**
> + * irq_set_dat_mode - Set the DAT mode of all interrupt handlers, except for
> + * restart.

(here)

> + * This will update the DAT mode and address space mode of all interrupt new
> + * PSWs.
> + *
> + * Since enabling DAT needs initialized CRs and the restart new PSW is often used
> + * to initialize CRs, the restart new PSW is never touched to avoid the chicken
> + * and egg situation.
> + *
> + * @use_dat specifies whether to use DAT or not
> + * @as specifies the address space mode to use. Not set if use_dat is false.

add the colon

 * @use_dat: 
 * @as: 

and move them up there ^

with that fixed:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> + */
> +void irq_set_dat_mode(bool use_dat, enum address_space as)
> +{
> +	struct psw* irq_psws[] = {
> +		OPAQUE_PTR(GEN_LC_EXT_NEW_PSW),
> +		OPAQUE_PTR(GEN_LC_SVC_NEW_PSW),
> +		OPAQUE_PTR(GEN_LC_PGM_NEW_PSW),
> +		OPAQUE_PTR(GEN_LC_MCCK_NEW_PSW),
> +		OPAQUE_PTR(GEN_LC_IO_NEW_PSW),
> +	};
> +	struct psw *psw;
> +
> +	assert(as == AS_PRIM || as == AS_ACCR || as == AS_SECN || as == AS_HOME);
> +
> +	for (size_t i = 0; i < ARRAY_SIZE(irq_psws); i++) {
> +		psw = irq_psws[i];
> +		psw->dat = use_dat;
> +		if (use_dat)
> +			psw->as = as;
> +	}
> +}
> +
>  static void fixup_pgm_int(struct stack_frame_int *stack)
>  {
>  	/* If we have an error on SIE we directly move to sie_exit */
> diff --git a/lib/s390x/mmu.c b/lib/s390x/mmu.c
> index b474d7021d3f..9a179d6b8ec5 100644
> --- a/lib/s390x/mmu.c
> +++ b/lib/s390x/mmu.c
> @@ -12,6 +12,7 @@
>  #include <asm/pgtable.h>
>  #include <asm/arch_def.h>
>  #include <asm/barrier.h>
> +#include <asm/interrupt.h>
>  #include <vmalloc.h>
>  #include "mmu.h"
>  
> @@ -41,8 +42,8 @@ static void mmu_enable(pgd_t *pgtable)
>  	/* enable dat (primary == 0 set as default) */
>  	enable_dat();
>  
> -	/* we can now also use DAT unconditionally in our PGM handler */
> -	lowcore.pgm_new_psw.mask |= PSW_MASK_DAT;
> +	/* we can now also use DAT in all interrupt handlers */
> +	irq_set_dat_mode(true, AS_PRIM);
>  }
>  
>  /*


