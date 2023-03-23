Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99F76C6E81
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 18:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjCWRPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 13:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCWRPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 13:15:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58673233D0;
        Thu, 23 Mar 2023 10:15:20 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32NH8E94008644;
        Thu, 23 Mar 2023 17:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=JYF/h0ZJR8wVzhPO3x4yH6w5rHSVqYekPGE4cV3n/y8=;
 b=d7SPiAmjPZ92kUHVIiFGqWSIZ3Ox8dWt+QlHyufoS7dQljJ1cp6Wd+Roy/mjP7nfKYww
 /0l4Q9BHjZKhLSvT4V2IIeGcn5yy/b2OYwcoejkS7DMBn7i4/guQ9gE2DeD2T83yMSGv
 tLXNZrqnYpDn/J2SUhhEd6k3cKLkKAPbJzvm3tKcgFelys9iI34QpJmfG4C7P2III+UO
 VKQXe9xVl5fCDpgTPphBoX+vUMS4+T3MVomEkJw6k7yBmCVWspPuFsDeAiRW7mXqdKfB
 zu/3c/lpVVlvNzmu/NV5JyCj70ZjdZzrPF+GBkLR7Odw0JTFBPSk95yqn2+2+w/JzvZy 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgk22m9qh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 17:15:19 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32NH987Q014543;
        Thu, 23 Mar 2023 17:15:19 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgk22m9p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 17:15:19 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NDlMaG014687;
        Thu, 23 Mar 2023 17:15:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3pd4x6ee7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 17:15:16 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NHFDeX61800764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 17:15:13 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07ECF20043;
        Thu, 23 Mar 2023 17:15:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C43292004E;
        Thu, 23 Mar 2023 17:15:12 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 17:15:12 +0000 (GMT)
Date:   Thu, 23 Mar 2023 16:45:12 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v7 1/2] s390x: topology: Check the
 Perform Topology Function
Message-ID: <20230323164512.4cdf985e@p-imbrenda>
In-Reply-To: <20230320085642.12251-2-pmorel@linux.ibm.com>
References: <20230320085642.12251-1-pmorel@linux.ibm.com>
        <20230320085642.12251-2-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PbJECSW63UBAwpX9nOUuc6otWAyy2fM4
X-Proofpoint-GUID: z4aVAubROBbya34Lj-ETTTvlFgddgbcQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-23_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230124
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Mar 2023 09:56:41 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We check that the PTF instruction is working correctly when
> the cpu topology facility is available.
> 
> For KVM only, we test changing of the polarity between horizontal
> and vertical and that a reset set the horizontal polarity.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/topology.c    | 180 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   3 +
>  3 files changed, 184 insertions(+)
>  create mode 100644 s390x/topology.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index e94b720..05dac04 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -40,6 +40,7 @@ tests += $(TEST_DIR)/panic-loop-pgm.elf
>  tests += $(TEST_DIR)/migration-sck.elf
>  tests += $(TEST_DIR)/exittime.elf
>  tests += $(TEST_DIR)/ex.elf
> +tests += $(TEST_DIR)/topology.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  
> diff --git a/s390x/topology.c b/s390x/topology.c
> new file mode 100644
> index 0000000..ce248f1
> --- /dev/null
> +++ b/s390x/topology.c
> @@ -0,0 +1,180 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + */
> +
> +#include <libcflat.h>
> +#include <asm/page.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/facility.h>
> +#include <smp.h>
> +#include <sclp.h>
> +#include <s390x/hardware.h>
> +
> +#define PTF_REQ_HORIZONTAL	0
> +#define PTF_REQ_VERTICAL	1
> +#define PTF_REQ_CHECK		2
> +
> +#define PTF_ERR_NO_REASON	0
> +#define PTF_ERR_ALRDY_POLARIZED	1
> +#define PTF_ERR_IN_PROGRESS	2
> +
> +extern int diag308_load_reset(u64);
> +
> +static int ptf(unsigned long fc, unsigned long *rc)
> +{
> +	int cc;
> +
> +	asm volatile(
> +		"	ptf	%1	\n"
> +		"       ipm     %0	\n"
> +		"       srl     %0,28	\n"
> +		: "=d" (cc), "+d" (fc)
> +		:
> +		: "cc");
> +
> +	*rc = fc >> 8;
> +	return cc;
> +}
> +
> +static void check_privilege(int fc)
> +{
> +	unsigned long rc;
> +
> +	report_prefix_push("Privilege");
> +	report_info("function code %d", fc);
> +	enter_pstate();
> +	expect_pgm_int();
> +	ptf(fc, &rc);
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +}
> +
> +static void check_function_code(void)
> +{
> +	unsigned long rc;
> +
> +	report_prefix_push("Undefined fc");
> +	expect_pgm_int();
> +	ptf(0xff, &rc);

please don't use magic numbers, add a new macro PTF_INVALID_FUNCTION
(or something like that)

> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +}
> +
> +static void check_reserved_bits(void)
> +{
> +	unsigned long rc;
> +
> +	report_prefix_push("Reserved bits");
> +	expect_pgm_int();
> +	ptf(0xffffffffffffff00UL, &rc);

I would like every single bit to be tested, since all of them are
required to be zero.

make a loop and test each, but please report success of failure only
once at the end. 
use a report_info in case of failure to indicate which bit failed

> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +}
> +
> +static void check_mtcr_pending(void)
> +{
> +	unsigned long rc;
> +	int cc;
> +
> +	report_prefix_push("Topology Report pending");
> +	/*
> +	 * At this moment the topology may already have changed
> +	 * since the VM has been started.
> +	 * However, we can test if a second PTF instruction
> +	 * reports that the topology did not change since the
> +	 * preceding PFT instruction.
> +	 */
> +	ptf(PTF_REQ_CHECK, &rc);
> +	cc = ptf(PTF_REQ_CHECK, &rc);
> +	report(cc == 0, "PTF check should clear topology report");
> +	report_prefix_pop();
> +}
> +
> +static void check_polarization_change(void)
> +{
> +	unsigned long rc;
> +	int cc;
> +
> +	report_prefix_push("Topology polarization check");
> +
> +	/* We expect a clean state through reset */
> +	report(diag308_load_reset(1), "load normal reset done");
> +
> +	/*
> +	 * Set vertical polarization to verify that RESET sets
> +	 * horizontal polarization back.
> +	 */
> +	cc = ptf(PTF_REQ_VERTICAL, &rc);
> +	report(cc == 0, "Set vertical polarization.");
> +
> +	report(diag308_load_reset(1), "load normal reset done");
> +
> +	cc = ptf(PTF_REQ_CHECK, &rc);
> +	report(cc == 0, "Reset should clear topology report");
> +
> +	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
> +	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
> +	       "After RESET polarization is horizontal");
> +
> +	/* Flip between vertical and horizontal polarization */
> +	cc = ptf(PTF_REQ_VERTICAL, &rc);
> +	report(cc == 0, "Change to vertical polarization.");

either here or in a new block, test that setting vertical twice in
a row will also result in a cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED

> +
> +	cc = ptf(PTF_REQ_CHECK, &rc);
> +	report(cc == 1, "Polarization change should set topology report");
> +
> +	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
> +	report(cc == 0, "Change to horizontal polarization.");

it cannot hurt to add here another check for pending reports

> +
> +	report_prefix_pop();
> +}
> +
> +static void test_ptf(void)
> +{
> +	check_privilege(PTF_REQ_HORIZONTAL);
> +	check_privilege(PTF_REQ_VERTICAL);
> +	check_privilege(PTF_REQ_CHECK);
> +	check_function_code();
> +	check_reserved_bits();
> +	check_mtcr_pending();
> +	check_polarization_change();
> +}
> +
> +static struct {
> +	const char *name;
> +	void (*func)(void);
> +} tests[] = {
> +	{ "PTF", test_ptf},
> +	{ NULL, NULL }
> +};
> +
> +int main(int argc, char *argv[])
> +{
> +	int i;
> +
> +	report_prefix_push("CPU Topology");
> +
> +	if (!test_facility(11)) {
> +		report_skip("Topology facility not present");
> +		goto end;
> +	}
> +
> +	report_info("Virtual machine level %ld", stsi_get_fc());
> +
> +	for (i = 0; tests[i].name; i++) {
> +		report_prefix_push(tests[i].name);
> +		tests[i].func();
> +		report_prefix_pop();
> +	}
> +
> +end:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 453ee9c..d0ac683 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -233,3 +233,6 @@ extra_params = -append '--parallel'
>  
>  [execute]
>  file = ex.elf
> +
> +[topology]
> +file = topology.elf

