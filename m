Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7012B635CDB
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 13:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbiKWM22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 07:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237686AbiKWM1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 07:27:37 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA2265840
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 04:26:09 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANCLSNK010121
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 12:26:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=NMGNzR7a1ZGRO/Cn31xyp/l4ZUXXVekDqBc5a549v7c=;
 b=kMIkRL6rcGxNDXUXdXxlX2Y8pziYWuaElTOkUyy4V1+uBNqMGWAqi6WxgFJm7mI6Efec
 5nFBNueiAaxZuPi2vq/z0Vc5MZHg5OzXG45QMuUket8vWJLH8FNGywNrSaV11qKe94Ed
 +lfaFl5SsmWkwWO5iZmzLJKFM9vzpm5YYH241hJcmhNvBXZNadVvZqgi6PPQI9/RGZ+7
 m/ATSs+RZT5U0s3S0Q8Dmwqb+AYwMgv1yYzzxNk0IiPVZIPiDD6Bob45Jj0zabNO4iNc
 7HGvRg31rTLnS1FUl5OrkoVKyccLH9abo+g7DLOxAeFqhqnMFGYVL3vtP4L8e8JNSOTx 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10w5ttwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 12:26:09 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ANBJAp2014305
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 12:26:08 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10w5ttvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 12:26:08 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ANCKMeD016388;
        Wed, 23 Nov 2022 12:26:06 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3kxps9459t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 12:26:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ANCQ36R6750792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 12:26:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73A1D4C04E;
        Wed, 23 Nov 2022 12:26:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46DC74C04A;
        Wed, 23 Nov 2022 12:26:03 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 12:26:03 +0000 (GMT)
Date:   Wed, 23 Nov 2022 13:25:55 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add CMM test during
 migration
Message-ID: <20221123132555.38e68669@p-imbrenda>
In-Reply-To: <20221122161243.214814-3-nrb@linux.ibm.com>
References: <20221122161243.214814-1-nrb@linux.ibm.com>
        <20221122161243.214814-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WWz6A7eBuT_oeIDhs86-hlI_iFcxfrk-
X-Proofpoint-ORIG-GUID: bOZq-3VcKczYe7PVjXGMuzF7-d22yce3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Nov 2022 17:12:43 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Add a test which modifies CMM page states while migration is in
> progress.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/Makefile               |   1 +
>  s390x/migration-during-cmm.c | 111 +++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg          |   5 ++
>  3 files changed, 117 insertions(+)
>  create mode 100644 s390x/migration-during-cmm.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 401cb6371cee..64c7c04409ae 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
>  tests += $(TEST_DIR)/panic-loop-pgm.elf
>  tests += $(TEST_DIR)/migration-sck.elf
>  tests += $(TEST_DIR)/exittime.elf
> +tests += $(TEST_DIR)/migration-during-cmm.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  
> diff --git a/s390x/migration-during-cmm.c b/s390x/migration-during-cmm.c
> new file mode 100644
> index 000000000000..3c96283d7b00
> --- /dev/null
> +++ b/s390x/migration-during-cmm.c
> @@ -0,0 +1,111 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Perform CMMA actions while migrating.
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +
> +#include <libcflat.h>
> +#include <smp.h>
> +#include <asm-generic/barrier.h>
> +
> +#include "cmm.h"
> +
> +#define NUM_PAGES 128

is 128 enough to allow multiple iterations of the thread?

> +
> +static uint8_t pagebuf[NUM_PAGES * PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> +
> +static int thread_iters;

please make all ints unsigned unless you really need them signed

> +static int thread_should_exit;
> +static int thread_exited;

(these are fine as is, since they are only used as flags)

> +static bool verification_failure_occured;
> +struct cmm_verify_result result;
> +
> +static void test_cmm_during_migration(void)
> +{
> +	/*
> +	 * The second CPU must not print on the console, otherwise it will race with
> +	 * the primary CPU on the SCLP buffer.
> +	 */
> +	while (!thread_should_exit) {
> +		cmm_set_page_states(pagebuf, NUM_PAGES);

I would do (pagebuf + (thread_iters % 4) * PAGE_SIZE

this way you will actually change the values for each page at each
iteration (will need a bigger buffer)

> +		if (!cmm_verify_page_states(pagebuf, NUM_PAGES, &result)) {
> +			verification_failure_occured = true;
> +			goto out;
> +		}
> +		thread_iters++;
> +	}
> +
> +out:
> +	thread_exited = 1;
> +}
> +
> +int main(void)
> +{
> +	bool has_essa = check_essa_available();
> +	struct psw psw;
> +
> +	report_prefix_push("migration-during-cmm");
> +	if (!has_essa) {
> +		report_skip("ESSA is not available");
> +		goto error;
> +	}
> +
> +	if (smp_query_num_cpus() == 1) {
> +		report_skip("need at least 2 cpus for this test");
> +		goto error;
> +	}
> +
> +	psw.mask = extract_psw_mask();
> +	psw.addr = (unsigned long)test_cmm_during_migration;
> +	smp_cpu_setup(1, psw);
> +
> +	puts("Please migrate me, then press return\n");
> +	(void)getchar();
> +
> +	thread_should_exit = 1;

I would use WRITE_ONCE, otherwise you probably need a mb() here

> +
> +	while (!thread_exited)
> +		mb();
> +
> +	report_info("thread completed %d iterations", thread_iters);
> +
> +	report_prefix_push("during migration");
> +	if (verification_failure_occured)
> +		cmm_report_verify_fail(&result);
> +	else
> +		report_pass("page states matched");
> +	report_prefix_pop();
> +
> +	/*
> +	 * Verification of page states occurs on the thread. We don't know if we
> +	 * were still migrating during the verification.
> +	 * To be sure, make another verification round after the migration
> +	 * finished to catch page states which might not have been migrated
> +	 * correctly.
> +	 */
> +	report_prefix_push("after migration");
> +	if (!cmm_verify_page_states(pagebuf, NUM_PAGES, &result))

pagebuf + ((thread_iters - 1) % 4) * PAGE_SIZE

> +		cmm_report_verify_fail(&result);
> +	else
> +		report_pass("page states matched");
> +	report_prefix_pop();
> +
> +	goto done;
> +
> +error:
> +	/*
> +	 * If we just exit and don't ask migrate_cmd to migrate us, it
> +	 * will just hang forever. Hence, also ask for migration when we
> +	 * skip this test alltogether.
> +	 */
> +	puts("Please migrate me, then press return\n");
> +	(void)getchar();
> +
> +done:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 3caf81eda396..f6889bd4da01 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -208,3 +208,8 @@ groups = migration
>  [exittime]
>  file = exittime.elf
>  smp = 2
> +
> +[migration-during-cmm]
> +file = migration-during-cmm.elf
> +groups = migration
> +smp = 2

