Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41460751B9B
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 10:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbjGMId1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 04:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbjGMIc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 04:32:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEBC3AB6;
        Thu, 13 Jul 2023 01:24:22 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36D8KvMv014355;
        Thu, 13 Jul 2023 08:24:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4+ns/2SLuFv9QINwuxqttrPjgiHM7ymtDv1Ehbyg0WQ=;
 b=BOyIqIucvIoXHcALwwQhe2lVoI4Hr5GJPf9E2GdW+THXa7Yl56n+MPpwE2rtRbnwqYgY
 pesunQBq4XyV1Uia6SbMCDycWcTIVjeOWyJsaGBPWS6FBMgIPuwS8r2FgoCZT8qOjazG
 KBGcBuNAVl9iOJ2YuMN7+np6hb8x90sYhd4wzdcZrkZSU94nWoYFukEKbRBtVfMhE5J6
 rDDI8XRc3S+PeIeMDWRf8fEqGsI80I7mnsNhFMQdxEn922CEsRP5Yx++SAeJCzOiIs/F
 9WsPS3hx2/3jFyztB9NlSU7WKKRb0zobf5+iL3gnYlonSohNSkcThlhdpb+GSYKb27Nq nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtdp8r35n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 08:24:22 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36D8LcCo017719;
        Thu, 13 Jul 2023 08:24:21 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtdp8r34s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 08:24:21 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36D5tILH028559;
        Thu, 13 Jul 2023 08:24:19 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rpy2e35cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 08:24:19 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36D8OF2C22544916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 08:24:15 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A75F12006C;
        Thu, 13 Jul 2023 08:24:15 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B88E2005A;
        Thu, 13 Jul 2023 08:24:15 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jul 2023 08:24:15 +0000 (GMT)
Date:   Thu, 13 Jul 2023 10:24:13 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v5 2/6] s390x: add function to set DAT
 mode for all interrupts
Message-ID: <20230713102413.214d37b3@p-imbrenda>
In-Reply-To: <20230712114149.1291580-3-nrb@linux.ibm.com>
References: <20230712114149.1291580-1-nrb@linux.ibm.com>
        <20230712114149.1291580-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hNnlZqMGrTWgtkf1xmecBz_WhgCK6zoQ
X-Proofpoint-ORIG-GUID: EYNk40F78dj8K5a5unAApE3YadlskV4p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_04,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 spamscore=0 mlxlogscore=885 phishscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307130069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jul 2023 13:41:45 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

[...]

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

please mention here that  as  will not be set if  dat == false

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
> +	};
> +	struct psw *psw;
> +
> +	assert(as == AS_PRIM || as == AS_ACCR || as == AS_SECN || as == AS_HOME);
> +
> +	for (size_t i = 0; i < ARRAY_SIZE(irq_psws); i++) {
> +		psw = irq_psws[i];
> +		psw->dat = dat;
> +		if (dat)
> +			psw->as = as;
> +	}
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

