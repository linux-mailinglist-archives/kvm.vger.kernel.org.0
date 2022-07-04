Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052F2564FC1
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 10:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiGDIca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 04:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbiGDIc3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 04:32:29 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC9FB483;
        Mon,  4 Jul 2022 01:32:28 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2648CLxU006927;
        Mon, 4 Jul 2022 08:32:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3r7RwSlD2+XPQwynUu5psOoq5b3t5QEyphK3BXPVCSU=;
 b=jl2Cq+R5I/7Nqk/hKVi6q6GZLjm03qE3SRmWxhfaztkwPeIYTLDx6szgJcIn3XgrYPhn
 o2c8BZhJnY1j+aGMxUZsaildIY2l3gn4J7xnhFY9f6BjvMqKmH0piR1rf+NMQfeovT0o
 9jIHN538ew1Y8iIUV4KHg9RQK/OGgtDSLchip31vYQTi9LzzcBeGHa/JS64Sjmv62SY2
 fC/V2/wqLM6RPHpDzSr+MgOkJQgrO8ABm5azTAXMEdGQTi/R3JM2E+WByVHPw/NLfsLa
 lBdFfjwLKRc2ch2kvZZDFNYIjDQtk6mQtsnj3lMYbtN6i/UuDV5RrxdZqAm8GE59Yw+n BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3vg60eje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 08:32:27 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2648R4Gi008910;
        Mon, 4 Jul 2022 08:32:27 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3vg60ehy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 08:32:27 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2648Kxgw012348;
        Mon, 4 Jul 2022 08:32:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3h2d9hstau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 08:32:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2648WMxd25166298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jul 2022 08:32:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFA9B4203F;
        Mon,  4 Jul 2022 08:32:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAE5942045;
        Mon,  4 Jul 2022 08:32:21 +0000 (GMT)
Received: from [9.145.190.147] (unknown [9.145.190.147])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jul 2022 08:32:21 +0000 (GMT)
Message-ID: <4fcdf87c-1ae6-6494-4999-da6b49c6891b@linux.ibm.com>
Date:   Mon, 4 Jul 2022 10:32:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220630113059.229221-1-nrb@linux.ibm.com>
 <20220630113059.229221-3-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/3] s390x: add extint loop test
In-Reply-To: <20220630113059.229221-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qXGKkFS-6fUle3BoRkpycDOzM8NKobyE
X-Proofpoint-GUID: jLZ2Xo9rPN57v2-Za-w72Eij-UF1oLps
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207040034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/22 13:30, Nico Boehr wrote:
> The CPU timer interrupt stays pending as long as the CPU timer value is
> negative. This can lead to interruption loops when the ext_new_psw mask
> has external interrupts enabled.
> 
> QEMU is able to detect this situation and panic the guest, so add a test
> for it.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile      |  1 +
>   s390x/extint-loop.c | 64 +++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |  4 +++
>   3 files changed, 69 insertions(+)
>   create mode 100644 s390x/extint-loop.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index efd5e0c13102..92a020234c9f 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -34,6 +34,7 @@ tests += $(TEST_DIR)/migration.elf
>   tests += $(TEST_DIR)/pv-attest.elf
>   tests += $(TEST_DIR)/migration-cmm.elf
>   tests += $(TEST_DIR)/migration-skey.elf
> +tests += $(TEST_DIR)/extint-loop.elf

I'd suggest giving these tests a "panic" prefix. panic-loop-extint.c 
panic-loop-pgm.c

>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> diff --git a/s390x/extint-loop.c b/s390x/extint-loop.c
> new file mode 100644
> index 000000000000..5276d86a156f
> --- /dev/null
> +++ b/s390x/extint-loop.c
> @@ -0,0 +1,64 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * External interrupt loop test
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <asm/interrupt.h>
> +#include <asm/barrier.h>
> +#include <asm/time.h>
> +
> +static void ext_int_handler(void)
> +{
> +	/*
> +	 * return to ext_old_psw. This gives us the chance to print the return_fail
> +	 * in case something goes wrong.
> +	 */
> +	asm volatile (
> +		"lpswe %[ext_old_psw]\n"
> +		:
> +		: [ext_old_psw] "Q"(lowcore.ext_old_psw)
> +		: "memory"
> +	);
> +}
> +
> +static void start_cpu_timer(int64_t timeout_ms)

cpu_timer_set

> +{
> +#define CPU_TIMER_US_SHIFT 12

The clock and the timer use the same shift so maybe we can rename or 
reuse time.h constants?

We could rename STCK_SHIFT_US to TIMING_S390_SHIFT_US since we need that 
for the TOD, todcmp and cputimer.

> +	int64_t timer_value = (timeout_ms * 1000) << CPU_TIMER_US_SHIFT;
> +	asm volatile (
> +		"spt %[timer_value]\n"
> +		:
> +		: [timer_value] "Q" (timer_value)
> +	);
> +}
> +
> +int main(void)
> +{
> +	struct psw ext_new_psw_orig;
> +
> +	report_prefix_push("extint-loop");

This is a QEMU only test so I think we should fence other hypervisors.

> +
> +	ext_new_psw_orig = lowcore.ext_new_psw;
> +	lowcore.ext_new_psw.addr = (uint64_t)ext_int_handler;
> +	lowcore.ext_new_psw.mask |= PSW_MASK_EXT;
> +
> +	load_psw_mask(extract_psw_mask() | PSW_MASK_EXT);
> +	ctl_set_bit(0, CTL0_CLOCK_COMPARATOR);
> +
> +	start_cpu_timer(1);
> +
> +	mdelay(2000);
> +
> +	/* restore previous ext_new_psw so QEMU can properly terminate */
> +	lowcore.ext_new_psw = ext_new_psw_orig;
> +
> +	report_fail("survived extint loop");
> +
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 8e52f560bb1e..7d408f2d5310 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -184,3 +184,7 @@ groups = migration
>   [migration-skey]
>   file = migration-skey.elf
>   groups = migration
> +
> +[extint-loop]
> +file = extint-loop.elf
> +groups = panic

