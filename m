Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8134638CAB
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 15:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiKYOrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 09:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiKYOrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 09:47:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6BCF6
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 06:47:00 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APDR9sU010827
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 14:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZDsGstFTioyoY1LmDYqGtc+ERpciHk9b/+fJ4RZHshk=;
 b=ApBtYOA8BRVxF9gP+s1JTU+M86zAemzl9XAeUUVZwev4DvzvJucJTXOvtskOkAjpMm9f
 1RbMSDYGQOjJx2oV3J3yW+abU9HCirdpQnOA0EvaGqv18G4rhHvB6SDMzNy9764nMdwa
 QHBimQErJFxS4O50sGVZEY9ekQvTY+8/C9+hOCkmjcbEebPS3qYY4xzBmHGmho2h9tJk
 6bTK5PttYPmLiLMPVJfR0C/8LRCPVGnwCy+I8gJJYi/cwjocVgpsmpJaq+u7x5K/2UaO
 ifJw9+/cejPhaH5OugcCMd3YsuZSNItE4ukooJXga2sr7Y53PKW7TveA1bOoalKGCcog YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2xktssss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 14:46:59 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APEkx9S001471
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 14:46:59 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2xktsss2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 14:46:58 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APEZVu8011901;
        Fri, 25 Nov 2022 14:46:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3kxps971jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 14:46:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APElX5S66322934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 14:47:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F4FBA405C;
        Fri, 25 Nov 2022 14:46:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 237CAA4054;
        Fri, 25 Nov 2022 14:46:51 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.0.125])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 25 Nov 2022 14:46:51 +0000 (GMT)
Date:   Fri, 25 Nov 2022 15:46:46 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: add CMM test during
 migration
Message-ID: <20221125154646.5974cb52@p-imbrenda>
In-Reply-To: <20221124134429.612467-3-nrb@linux.ibm.com>
References: <20221124134429.612467-1-nrb@linux.ibm.com>
        <20221124134429.612467-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jCmqG3ZnIHvEjo6idov0k2WouHpat-A4
X-Proofpoint-ORIG-GUID: R9oK38rRflohWcygGZmeGTHxrfiRqDWG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_06,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Nov 2022 14:44:29 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Add a test which modifies CMM page states while migration is in
> progress.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/Makefile               |   1 +
>  s390x/migration-during-cmm.c | 121 +++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg          |   5 ++
>  3 files changed, 127 insertions(+)
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
> index 000000000000..afe1f73605ba
> --- /dev/null
> +++ b/s390x/migration-during-cmm.c
> @@ -0,0 +1,121 @@
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
> +
> +/*
> + * Allocate 3 pages more than we need so we can start at different offsets. This ensures page states
> + * change on every loop iteration.
> + */
> +static uint8_t pagebuf[(NUM_PAGES + 3) * PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> +
> +static unsigned int thread_iters;
> +static int thread_should_exit;
> +static int thread_exited;
> +struct cmm_verify_result result;
> +
> +static void test_cmm_during_migration(void)
> +{
> +	uint8_t *pagebuf_start;
> +	/*
> +	 * The second CPU must not print on the console, otherwise it will race with
> +	 * the primary CPU on the SCLP buffer.
> +	 */
> +	while (!thread_should_exit) {

I don't see any mb()s here, maybe use READ_ONCE

> +		/*
> +		 * Start on a offset different from the last iteration so page states change with
> +		 * every iteration. This is why pagebuf has 3 extra pages.
> +		 */
> +		pagebuf_start = pagebuf + (thread_iters % 4) * PAGE_SIZE;
> +		cmm_set_page_states(pagebuf_start, NUM_PAGES);
> +
> +		/*
> +		 * Always increment even if the verify fails. This ensures primary CPU knows where
> +		 * we left off and can do an additional verify round after migration finished.
> +		 */
> +		thread_iters++;
> +
> +		result = cmm_verify_page_states(pagebuf_start, NUM_PAGES);
> +		if (result.verify_failed)
> +			goto out;
> +	}
> +
> +out:
> +	WRITE_ONCE(thread_exited, 1);
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
> +	WRITE_ONCE(thread_should_exit, 1);
> +
> +	while (!thread_exited)
> +		mb();
> +
> +	report_info("thread completed %u iterations", thread_iters);
> +
> +	report_prefix_push("during migration");
> +	cmm_report_verify(&result);
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
> +	assert(thread_iters > 0);
> +	result = cmm_verify_page_states(pagebuf + ((thread_iters - 1) % 4) * PAGE_SIZE, NUM_PAGES);
> +	cmm_report_verify(&result);
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

I wonder if this can be made easier to review and less error prone... 

maybe something like:

static void migrate_once(void)
{
	static bool migrated = false;

	if (migrated)
		return;
	puts("Please migrate me, then press return\n");
	migrated = true;
	(void)getchar();
}

then you can put it where needed in the code _and_ unconditionally at the end

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

