Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26AE596B4A
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 10:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbiHQIUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 04:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235084AbiHQIUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 04:20:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9C12F658
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 01:20:04 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27H7wdOj007935
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 08:20:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uVByJnnvD1BILaj6V337lp+YulMWPa9fjzezJN+dE3E=;
 b=oJvMj7CuCUxejGERr3t7FbM2H3OJJRX6++oLJF2TwViQkN7TpB7q6VGij1HZbMd6n1Gz
 rjg89I2wbVB2HkpTCVe5ueACVBsfvSCiqvI6ZF6AFIFoGFpqbqnDlOL1/OhCvFXaBWeO
 P5oQD7FnkpAyz/OcEiSgswWREItf9AYoL+g0MO/E6Gp9m5LJisGtVji5QrXKOBLZRXlU
 YDBy85s1Jxlhe15JE2Y0SFnfrh1TwV5VRD9o9eGwtLLcaP/O54+MrRVDZaUDVcfTQsK9
 lLpJz0486ylBu/x85I3zPOdWYHX3biahFuKEuPM4KwZ4Wq2+5lk13m5L+gZJpVW9qvR8 Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0vdt8hcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 08:20:03 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27H80Ohi018124
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 08:20:03 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0vdt8hbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 08:20:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27H86WCn026031;
        Wed, 17 Aug 2022 08:20:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3hx3k9c621-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 08:20:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27H8Jvwa32637270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Aug 2022 08:19:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACB03AE045;
        Wed, 17 Aug 2022 08:19:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CC96AE04D;
        Wed, 17 Aug 2022 08:19:57 +0000 (GMT)
Received: from [9.145.35.188] (unknown [9.145.35.188])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Aug 2022 08:19:57 +0000 (GMT)
Message-ID: <6556b77f-beb0-a4ad-77bf-1a8dd130fb82@linux.ibm.com>
Date:   Wed, 17 Aug 2022 10:19:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220812062151.1980937-1-nrb@linux.ibm.com>
 <20220812062151.1980937-5-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 4/4] s390x: add pgm spec interrupt loop
 test
In-Reply-To: <20220812062151.1980937-5-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0A4XCqT8GzNlSnwBAqYJwHAvIktyhFey
X-Proofpoint-GUID: 2V_EprOK5VLOrZN5A5QYAVqF8xzb6Hrs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-17_05,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208170032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/12/22 08:21, Nico Boehr wrote:
> An invalid PSW causes a program interrupt. When an invalid PSW is
> introduced in the pgm_new_psw, an interrupt loop occurs as soon as a
> program interrupt is caused.
> 
> QEMU should detect that and panic the guest, hence add a test for it.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile         |  1 +
>   s390x/panic-loop-pgm.c | 39 +++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg    |  6 ++++++
>   3 files changed, 46 insertions(+)
>   create mode 100644 s390x/panic-loop-pgm.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index e4649da50d9d..66415d0b588d 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -35,6 +35,7 @@ tests += $(TEST_DIR)/pv-attest.elf
>   tests += $(TEST_DIR)/migration-cmm.elf
>   tests += $(TEST_DIR)/migration-skey.elf
>   tests += $(TEST_DIR)/panic-loop-extint.elf
> +tests += $(TEST_DIR)/panic-loop-pgm.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
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

Hmmmmm, do we have a way to cause a pgm which looks nicer and is easier 
to understand?

We could set bit 12 in the current PSW as well or drop into problem mode 
and try a lctrlg.

> +
> +	report_fail("survived pgmint loop");

Space between pgm and int?

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
>   groups = panic
>   accel = kvm
>   timeout = 5
> +
> +[panic-loop-pgm]
> +file = panic-loop-pgm.elf
> +groups = panic
> +accel = kvm
> +timeout = 5

