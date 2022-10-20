Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E088F605AD1
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiJTJOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiJTJOd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:14:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A8C5FCA
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:14:15 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K9Cflb022939
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:14:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=6fGoVO4/+87uVVWvAZWdmDuNTz+qlq3J8BDd9uh3VMw=;
 b=FV4yIl5F8gBnNHbL4+SSa39lC/4SVPYlj2yyUr3keFY+TgE3e0Jm7PgU+8MKzzSY1sFL
 dF+1cnDLPYUBg6ZecOTm+M4Qif8gD29dat46AIyW58jdnrSqFp0hQcAC5GnW+B032rcx
 oJRrhZMheq414Oj3MSkquCru1nEyLF/tE0ed2DdVl/MXE+8e99DzM+5qvyiKqHVSipM0
 Iqk0rXWp9/+i6nEE5AUquF6YF6Sw8uSxscdY4LcV56XlEJP+24Fc1G3S9ed0pYNbsxkH
 nhQs6z1cHwXJA/0KGqr0m3oWertuamsdnO/+hcp2ylRNca3m7cnJ4iwh4in1BD+eIGYv Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb3g7r18d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:14:15 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K9EFSS032520
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:14:15 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb3g7r12v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:14:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K95C8o016426;
        Thu, 20 Oct 2022 09:14:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg98nc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:14:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K9E30k3736148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 09:14:03 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3B42AE051;
        Thu, 20 Oct 2022 09:14:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A62AAE045;
        Thu, 20 Oct 2022 09:14:03 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 09:14:03 +0000 (GMT)
Date:   Thu, 20 Oct 2022 11:14:01 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/7] s390x: snippets: asm: Add a macro
 to write an exception PSW
Message-ID: <20221020111401.34912a70@p-imbrenda>
In-Reply-To: <20221020090009.2189-2-frankja@linux.ibm.com>
References: <20221020090009.2189-1-frankja@linux.ibm.com>
        <20221020090009.2189-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WGLsGzbxBdTmXmVP7dLEBJUrEpHRYY76
X-Proofpoint-GUID: I28lKibxrY-AW_SHVmoXgeM-OtiI9zUW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Oct 2022 09:00:03 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Setting exception new PSWs is commonly needed so let's add a macro for
> that.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/snippets/asm/macros.S              | 28 ++++++++++++++++++++++++
>  s390x/snippets/asm/snippet-pv-diag-288.S |  4 ++--
>  s390x/snippets/asm/snippet-pv-diag-500.S |  6 ++---
>  3 files changed, 32 insertions(+), 6 deletions(-)
>  create mode 100644 s390x/snippets/asm/macros.S
> 
> diff --git a/s390x/snippets/asm/macros.S b/s390x/snippets/asm/macros.S
> new file mode 100644
> index 00000000..667fb6dc
> --- /dev/null
> +++ b/s390x/snippets/asm/macros.S
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Commonly used assembly macros
> + *
> + * Copyright (c) 2022 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +#include <asm/asm-offsets.h>
> +
> +/*
> + * Writes a PSW to addr_psw, useful for exception PSWs in lowcore
> + *
> + * reg is the scratch register used for temporary storage, it's NOT restored
> + * The psw address part is defined via psw_new_addr
> + * The psw mask part is always 64 bit
> + */
> +.macro SET_PSW_NEW_ADDR reg, psw_new_addr, addr_psw
> +larl	\reg, psw_mask_64
> +stg	\reg, \addr_psw
> +larl	\reg, \psw_new_addr
> +stg	\reg, \addr_psw + 8
> +.endm
> +
> +.section .rodata
> +psw_mask_64:
> +	.quad	0x0000000180000000
> diff --git a/s390x/snippets/asm/snippet-pv-diag-288.S b/s390x/snippets/asm/snippet-pv-diag-288.S
> index aaee3cd1..63f2113b 100644
> --- a/s390x/snippets/asm/snippet-pv-diag-288.S
> +++ b/s390x/snippets/asm/snippet-pv-diag-288.S
> @@ -8,6 +8,7 @@
>   *  Janosch Frank <frankja@linux.ibm.com>
>   */
>  #include <asm/asm-offsets.h>
> +#include "macros.S"
>  .section .text
>  
>  /* Clean and pre-load registers that are used for diag 288 */
> @@ -19,8 +20,7 @@ lghi	%r1, 2
>  lghi	%r2, 3
>  
>  /* Let's jump to the pgm exit label on a PGM */
> -larl	%r4, exit_pgm
> -stg     %r4, GEN_LC_PGM_NEW_PSW + 8
> +SET_PSW_NEW_ADDR 4, exit_pgm, GEN_LC_PGM_NEW_PSW
>  
>  /* Execute the diag288 */
>  diag	%r0, %r2, 0x288
> diff --git a/s390x/snippets/asm/snippet-pv-diag-500.S b/s390x/snippets/asm/snippet-pv-diag-500.S
> index 8dd66bd9..f4d75388 100644
> --- a/s390x/snippets/asm/snippet-pv-diag-500.S
> +++ b/s390x/snippets/asm/snippet-pv-diag-500.S
> @@ -8,6 +8,7 @@
>   *  Janosch Frank <frankja@linux.ibm.com>
>   */
>  #include <asm/asm-offsets.h>
> +#include "macros.S"
>  .section .text
>  
>  /* Clean and pre-load registers that are used for diag 500 */
> @@ -21,10 +22,7 @@ lghi	%r3, 3
>  lghi	%r4, 4
>  
>  /* Let's jump to the next label on a PGM */
> -xgr	%r5, %r5
> -stg	%r5, GEN_LC_PGM_NEW_PSW
> -larl	%r5, next
> -stg	%r5, GEN_LC_PGM_NEW_PSW + 8
> +SET_PSW_NEW_ADDR 5, next, GEN_LC_PGM_NEW_PSW
>  
>  /* Execute the diag500 */
>  diag	0, 0, 0x500

