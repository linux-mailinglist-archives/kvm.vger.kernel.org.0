Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5E5590E4C
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 11:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbiHLJma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 05:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiHLJm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 05:42:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E45386C15
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 02:42:27 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27C8v93E000350
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:42:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=IMmELkm2rH9m6fyGbyUbqCcU5nPJdzZkHo1d3W53cDE=;
 b=UL5QvEdPUnco+pnMZOMeeBve4WG2sy7HG0VoBfLyU15EommeZudq/1T4JHTVlhZsRStD
 QWXlfTn8v506ukNqECF/JHITvkBW7pXV6w24QptldyTnZIObZqwPjShThzo4dJhHnhg5
 pxppoVHO31tfA6oJUSe/lkh25PaJAt4Ob+H4qgIE1K0FdsH1zQhgdhcMuGdySo//hoe7
 Jm1kIDV/gbhtzj+RGw2Do3fowHE32ufg+uVxsc1HdW1CnHsc4tflZgBtgZHZ0EGtzaSt
 ykxM54fmADP4ASmPPUYCmTarWlwMZeNBJ6OZv1tg6C0Oi4bTcLTls48gxEb2pKxEeLpg zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwkt7s6fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:42:27 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27C9Tdhv009120
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:42:26 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwkt7s6e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 09:42:26 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27C9Mct0020678;
        Fri, 12 Aug 2022 09:42:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3huww0th3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 09:42:23 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27C9gKA229360588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 09:42:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33937AE04D;
        Fri, 12 Aug 2022 09:42:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0AEDAE045;
        Fri, 12 Aug 2022 09:42:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.179])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Aug 2022 09:42:19 +0000 (GMT)
Date:   Fri, 12 Aug 2022 11:42:17 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 4/4] s390x: add pgm spec interrupt
 loop test
Message-ID: <20220812114217.6bc401a7@p-imbrenda>
In-Reply-To: <20220812062151.1980937-5-nrb@linux.ibm.com>
References: <20220812062151.1980937-1-nrb@linux.ibm.com>
        <20220812062151.1980937-5-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QbNfPCZbWCQKwXJY9aKOTKFesS3McyQ-
X-Proofpoint-ORIG-GUID: eicAu_vSAr9sOsgYlKpSkEMos_vaw3b0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_06,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120026
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Aug 2022 08:21:51 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> An invalid PSW causes a program interrupt. When an invalid PSW is
> introduced in the pgm_new_psw, an interrupt loop occurs as soon as a
> program interrupt is caused.
> 
> QEMU should detect that and panic the guest, hence add a test for it.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/Makefile         |  1 +
>  s390x/panic-loop-pgm.c | 39 +++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg    |  6 ++++++
>  3 files changed, 46 insertions(+)
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
> index 000000000000..f3b23d67159c
> --- /dev/null
> +++ b/s390x/panic-loop-pgm.c
> @@ -0,0 +1,39 @@
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
> +int main(void)
> +{
> +	report_prefix_push("panic-loop-pgm");
> +
> +	if (!host_is_qemu() || host_is_tcg()) {
> +		report_skip("QEMU-KVM-only test");
> +		goto out;
> +	}
> +
> +	expect_pgm_int();
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

