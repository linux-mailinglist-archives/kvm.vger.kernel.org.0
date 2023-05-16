Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88509705502
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 19:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbjEPRan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 13:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbjEPRal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 13:30:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35354F7;
        Tue, 16 May 2023 10:30:40 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GH9BG1019087;
        Tue, 16 May 2023 17:30:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZCC9vxMr9joRi3dfenpx5oloFZIV+OcEGd7qoO8+S44=;
 b=dm/Fm+Vrr8wKhkGRCFEMZ5D1IWxlaflft29mhy005ZRMsYlZ2t2wb7R8YiFDm/ND4MSY
 PjuN3xHa7tKj5Q7qvz9CiBsJwoQM1wz1xbXoUaaet8aQHyfmiU+MBZh51wgjZahV8rjD
 8Sq0WgmHx/c46B+x6UkMQFJ11lnANlKLWc4qm3LHMpaQfsFbkbCmVBCkAKXnt10Y1DiW
 W2CPDnZb10jBKUdpkCvD7MhvKMvqXx+T1DNPJ98r0mM/m9OWS45d62eqngCcyIYuh+hr
 r9X21nKLYzyDwlz34Y7d1I56Z0ySDrdOoECGwM4vUjwuMGmIriorlF9eeSElT0A+t7Bw bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qmdc51gkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 17:30:39 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34GH9J16020068;
        Tue, 16 May 2023 17:30:39 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qmdc51gjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 17:30:39 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34G67uZH005223;
        Tue, 16 May 2023 17:30:37 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qj264ss3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 17:30:36 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34GHUXW019595788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 May 2023 17:30:33 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E0852004B;
        Tue, 16 May 2023 17:30:33 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F52C20043;
        Tue, 16 May 2023 17:30:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 16 May 2023 17:30:33 +0000 (GMT)
Date:   Tue, 16 May 2023 19:30:18 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 5/6] s390x: lib: sie: don't reenter
 SIE on pgm int
Message-ID: <20230516193018.2e6cab64@p-imbrenda>
In-Reply-To: <20230516130456.256205-6-nrb@linux.ibm.com>
References: <20230516130456.256205-1-nrb@linux.ibm.com>
        <20230516130456.256205-6-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3d70aQGzdrSMKYvO5BQwBmw-JcnG6oqj
X-Proofpoint-GUID: P8i_mVAuNP93zFYn5K2Jmrwwj8f1-Xi_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_09,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 mlxlogscore=514 malwarescore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160145
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 May 2023 15:04:55 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> At the moment, when a PGM int occurs while in SIE, we will just reenter
> SIE after the interrupt handler was called.
> 
> This is because sie() has a loop which checks icptcode and re-enters SIE
> if it is zero.
> 
> However, this behaviour is quite undesirable for SIE tests, since it
> doesn't give the host the chance to assert on the PGM int. Instead, we
> will just re-enter SIE, on nullifing conditions even causing the
> exception again.
> 
> In sie(), check whether a pgm int code is set in lowcore. If it has,
> exit the loop so the test can react to the interrupt. Add a new function
> read_pgm_int_code() to obtain the interrupt code.
> 
> Note that this introduces a slight oddity with sie and pgm int in
> certain cases: If a PGM int occurs between a expect_pgm_int() and sie(),
> we will now never enter SIE until the pgm_int_code is cleared by e.g.
> clear_pgm_int().
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  lib/s390x/asm/interrupt.h |  1 +
>  lib/s390x/interrupt.c     | 15 +++++++++++++++
>  lib/s390x/sie.c           |  4 +++-
>  lib/s390x/sie.h           |  1 -
>  4 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index 55759002dce2..2d7eb1907458 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -81,6 +81,7 @@ void handle_svc_int(void);
>  void expect_pgm_int(void);
>  void expect_ext_int(void);
>  uint16_t clear_pgm_int(void);
> +uint16_t read_pgm_int_code(void);
>  void check_pgm_int_code(uint16_t code);
>  
>  #define IRQ_DAT_ON	true
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 2e5309cee40f..82b4259d433c 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -60,6 +60,21 @@ uint16_t clear_pgm_int(void)
>  	return code;
>  }
>  
> +/**
> + * read_pgm_int_code - Get the program interruption code of the last pgm int
> + * on the current CPU.
> + *
> + * This is similar to clear_pgm_int(), except that it doesn't clear the
> + * interruption information from lowcore.
> + *
> + * Returns 0 when none occured.
> + */
> +uint16_t read_pgm_int_code(void)

could this whole function go in the header as static inline?

> +{
> +	mb();

is the mb really needed?

> +	return lowcore.pgm_int_code;
> +}
> +
>  /**
>   * check_pgm_int_code - Check the program interrupt code on the current CPU.
>   * @code the expected program interrupt code on the current CPU
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index ffa8ec91a423..632740edd431 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -13,6 +13,7 @@
>  #include <libcflat.h>
>  #include <sie.h>
>  #include <asm/page.h>
> +#include <asm/interrupt.h>
>  #include <libcflat.h>
>  #include <alloc_page.h>
>  
> @@ -65,7 +66,8 @@ void sie(struct vm *vm)
>  	/* also handle all interruptions in home space while in SIE */
>  	irq_set_dat_mode(IRQ_DAT_ON, AS_HOME);
>  
> -	while (vm->sblk->icptcode == 0) {
> +	/* leave SIE when we have an intercept or an interrupt so the test can react to it */
> +	while (vm->sblk->icptcode == 0 && !read_pgm_int_code()) {
>  		sie64a(vm->sblk, &vm->save_area);
>  		sie_handle_validity(vm);
>  	}
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index 0b00fb709776..147cb0f2a556 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -284,6 +284,5 @@ void sie_handle_validity(struct vm *vm);
>  void sie_guest_sca_create(struct vm *vm);
>  void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
>  void sie_guest_destroy(struct vm *vm);
> -bool sie_had_pgm_int(struct vm *vm);

... ?

>  
>  #endif /* _S390X_SIE_H_ */

