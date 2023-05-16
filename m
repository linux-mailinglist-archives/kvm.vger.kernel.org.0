Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45DA705507
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 19:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjEPRar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 13:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjEPRan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 13:30:43 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7877B35BC;
        Tue, 16 May 2023 10:30:42 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GHLZPF031845;
        Tue, 16 May 2023 17:30:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=7xMOC1IuE8cNbuHlH1BRvtjy8UdshLHidP97vg6KXBQ=;
 b=KOWwNnLhdq9u+nOxJqRfGQFMbxfGa0iF6YOMHck8TIRyaUVofAUEzseN5luek6nHPRYD
 vQAR4922DoDCTKgBpGK6DrdQBKVbTc5oVwee4lHldCrr2GPPNVEmRL9DorhQOtzHgxOt
 Tss+pCVF8qsuw2k5k4gq9bo1p0GVjWLqUylq+UO7wIF26vWKAth0Q9m1K/otAzDs8C5T
 kf2SelKeFUZdfXhju/zCgXI6afKLNoHco+cmtwN3IqjSzvex6rE7zmAA1IhXnTkF5rzj
 cVFlIQsomkD5/efHoHJiWyPDzFlORVsYuy77+FXLiWsaGmjpiJ4XVd87i0veuK7Dviqm 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qme5mr63p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 17:30:40 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34GHQAIp011150;
        Tue, 16 May 2023 17:30:40 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qme5mr62s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 17:30:40 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34G7Zhql028201;
        Tue, 16 May 2023 17:30:38 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qj264ss3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 17:30:38 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34GHUZp024183324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 May 2023 17:30:35 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B7B320043;
        Tue, 16 May 2023 17:30:35 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2D5F20040;
        Tue, 16 May 2023 17:30:34 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 16 May 2023 17:30:34 +0000 (GMT)
Date:   Tue, 16 May 2023 19:17:24 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/6] s390x: add function to set DAT
 mode for all interrupts
Message-ID: <20230516191724.0b9809ac@p-imbrenda>
In-Reply-To: <20230516130456.256205-2-nrb@linux.ibm.com>
References: <20230516130456.256205-1-nrb@linux.ibm.com>
        <20230516130456.256205-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NOelFF3dq1uqmxvo6-7oHRKoILZ3ArZh
X-Proofpoint-GUID: _kwpX2z66qk9PMLfGMW9HjObjEz8NPq8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_09,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 mlxlogscore=709 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 impostorscore=0 clxscore=1015 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160145
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 May 2023 15:04:51 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> When toggling DAT or switch address space modes, it is likely that
> interrupts should be handled in the same DAT or address space mode.
> 
> Add a function which toggles DAT and address space mode for all
> interruptions, except restart interrupts.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  lib/s390x/asm/interrupt.h |  4 ++++
>  lib/s390x/interrupt.c     | 38 ++++++++++++++++++++++++++++++++++++++
>  lib/s390x/mmu.c           |  5 +++--
>  3 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index 35c1145f0349..55759002dce2 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -83,6 +83,10 @@ void expect_ext_int(void);
>  uint16_t clear_pgm_int(void);
>  void check_pgm_int_code(uint16_t code);
>  
> +#define IRQ_DAT_ON	true
> +#define IRQ_DAT_OFF	false
> +void irq_set_dat_mode(bool dat, uint64_t as);
> +
>  /* Activate low-address protection */
>  static inline void low_prot_enable(void)
>  {
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 3f993a363ae2..1180ec44d72f 100644
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
> @@ -104,6 +105,43 @@ void register_ext_cleanup_func(void (*f)(struct stack_frame_int *))
>  	THIS_CPU->ext_cleanup_func = f;
>  }
>  
> +/**
> + * irq_set_dat_mode - Set the DAT mode of all interrupt handlers, except for
> + * restart.
> + * This will update the DAT mode and address space mode of all interrupt new
> + * PSWs.
> + *
> + * Since enabling DAT needs initalized CRs and the restart new PSW is often used
> + * to initalize CRs, the restart new PSW is never touched to avoid the chicken
> + * and egg situation.
> + *
> + * @dat specifies whether to use DAT or not
> + * @as specifies the address space mode to use - one of AS_PRIM, AS_ACCR,
> + * AS_SECN or AS_HOME.
> + */
> +void irq_set_dat_mode(bool dat, uint64_t as)
> +{
> +	struct psw* irq_psws[] = {
> +		OPAQUE_PTR(GEN_LC_EXT_NEW_PSW),
> +		OPAQUE_PTR(GEN_LC_SVC_NEW_PSW),
> +		OPAQUE_PTR(GEN_LC_PGM_NEW_PSW),
> +		OPAQUE_PTR(GEN_LC_MCCK_NEW_PSW),
> +		OPAQUE_PTR(GEN_LC_IO_NEW_PSW),
> +		NULL /* sentinel */
> +	};
> +
> +	assert(as == AS_PRIM || as == AS_ACCR || as == AS_SECN || as == AS_HOME);
> +
> +	for (struct psw *irq_psw = irq_psws[0]; irq_psw != NULL; irq_psw++) {

just call it psw, or cur_psw, it's a little confusing otherwise

add in arch_def.c:

#define PSW_MASK_AS 0x0000C00000000000UL

> +		if (!dat)
> +			irq_psw->mask &= ~PSW_MASK_DAT;

cur_psw->mask &= ~(PSW_MASK_DAT | PSW_MASK_AS);
if (dat)
	cur_psw->mask |=  PSW_MASK_DAT | BIT_ULL(63 - 16);


alternatively, you can redefine psw with a bitfield (as you mentioned
offline):

cur_psw->mask.dat = dat;
if (dat)
	cur_psw->mask.as = as;

> +		else
> +			irq_psw->mask |= PSW_MASK_DAT | as << (63 - 16);

otherwise here you're ORing stuff to other stuff, if you had 3 and you
OR 0 you get 3, but you actually want 0

> +	}
> +
> +	mb();

what's the purpose of this?

> +}
> +
>  static void fixup_pgm_int(struct stack_frame_int *stack)
>  {
>  	/* If we have an error on SIE we directly move to sie_exit */
> diff --git a/lib/s390x/mmu.c b/lib/s390x/mmu.c
> index b474d7021d3f..199bd3fbc9c8 100644
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
> +	irq_set_dat_mode(IRQ_DAT_ON, AS_PRIM);
>  }
>  
>  /*

