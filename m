Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE1358EA47
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 12:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiHJKKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 06:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiHJKKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 06:10:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535F3248
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 03:10:12 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A9ZACE022906
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:10:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=+9PkvhyVas3EOn4D42OmWn3xIeZFiscM4QOO+p+/NFY=;
 b=Ouvef4k3uPlFjGP+GSyq8Uz2mfXdnBGoQiX+r4RRpEC/HLxWDR8hiFv9JM4VUioeBJGv
 JLRJSQZ238jqPDpyJUk0SIAa0hYWQCGqSXZ5yN8/a9orKEO+t7v0RgC0+gaWUSbk1/fa
 sWEeXFGxgRF06m6JJHiaLjLuqGY1ILHsx361rRB+/G4ah33v/0kdAXr5EfmGwf7hgxq2
 vRBegqRjCU+GTx40a7kOkxbzyU4LNgi3Q9jTx08jO2ajxu4LozXiH6OxeSN5CO6J7ENq
 GGRZZLjK6UJoyvesZRqR81/tuUc4L4tTuUQgYCgBCqvCLxaT5M+OKQm7L1stlwQFtc+2 eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv31vmv39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:10:11 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27A9anwi030168
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:10:11 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv31vmv2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 10:10:11 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27AA8Y4G030130;
        Wed, 10 Aug 2022 10:10:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3huww0rp4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 10:10:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27AAA52t28049836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 10:10:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97F31A4051;
        Wed, 10 Aug 2022 10:10:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41305A4040;
        Wed, 10 Aug 2022 10:10:05 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.105])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 10:10:05 +0000 (GMT)
Date:   Wed, 10 Aug 2022 12:10:00 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 4/4] s390x: add pgm spec interrupt
 loop test
Message-ID: <20220810121000.03637eac@p-imbrenda>
In-Reply-To: <20220722060043.733796-5-nrb@linux.ibm.com>
References: <20220722060043.733796-1-nrb@linux.ibm.com>
        <20220722060043.733796-5-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YnYZVA0dhgy--KWYgg0bnT1tDjH-4qUl
X-Proofpoint-ORIG-GUID: YxPhIdrk7az5WlNLhxZhSP97YVEnVvqR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_05,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100031
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Jul 2022 08:00:43 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> An invalid PSW causes a program interrupt. When an invalid PSW is
> introduced in the pgm_new_psw, an interrupt loop occurs as soon as a
> program interrupt is caused.
> 
> QEMU should detect that and panic the guest, hence add a test for it.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/Makefile         |  1 +
>  s390x/panic-loop-pgm.c | 53 ++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg    |  6 +++++
>  3 files changed, 60 insertions(+)
>  create mode 100644 s390x/panic-loop-pgm.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index e4649da50d9d..66415d0b588d 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -35,6 +35,7 @@ tests += $(TEST_DIR)/pv-attest.elf
>  tests += $(TEST_DIR)/migration-cmm.elf
>  tests += $(TEST_DIR)/migration-skey.elf
>  tests += $(TEST_DIR)/panic-loop-extint.elf
> +tests += $(TEST_DIR)/panic-loop-pgm.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  
> diff --git a/s390x/panic-loop-pgm.c b/s390x/panic-loop-pgm.c
> new file mode 100644
> index 000000000000..68934057a251
> --- /dev/null
> +++ b/s390x/panic-loop-pgm.c
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Program interrupt loop test
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <bitops.h>
> +#include <asm/interrupt.h>
> +#include <asm/barrier.h>
> +#include <hardware.h>
> +
> +static void pgm_int_handler(void)
> +{
> +	/*
> +	 * return to pgm_old_psw. This gives us the chance to print the return_fail
> +	 * in case something goes wrong.
> +	 */
> +	asm volatile (
> +		"lpswe %[pgm_old_psw]\n"
> +		:
> +		: [pgm_old_psw] "Q"(lowcore.pgm_old_psw)
> +		: "memory"
> +	);
> +}

same consideration here as in the previous patch

> +
> +int main(void)
> +{
> +	report_prefix_push("panic-loop-pgm");
> +
> +	if (!host_is_qemu() || host_is_tcg()) {
> +		report_skip("QEMU-KVM-only test");
> +		goto out;
> +	}
> +
> +	lowcore.pgm_new_psw.addr = (uint64_t) pgm_int_handler;
> +	/* bit 12 set is invalid */
> +	lowcore.pgm_new_psw.mask = extract_psw_mask() | BIT(63 - 12);
> +	mb();
> +
> +	/* cause a pgm int */
> +	*((int *)-4) = 0x42;
> +	mb();
> +
> +	report_fail("survived pgmint loop");
> +
> +out:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index b1b25f118ff6..f9f102abfa89 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -191,3 +191,9 @@ file = panic-loop-extint.elf
>  groups = panic
>  accel = kvm
>  timeout = 5
> +
> +[panic-loop-pgm]
> +file = panic-loop-pgm.elf
> +groups = panic
> +accel = kvm
> +timeout = 5

