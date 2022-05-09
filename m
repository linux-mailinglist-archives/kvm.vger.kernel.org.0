Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B561851FEF4
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 16:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236782AbiEIOEY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 10:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbiEIOEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 10:04:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD5425D111;
        Mon,  9 May 2022 07:00:20 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249DIZ2l022847;
        Mon, 9 May 2022 14:00:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=GCG2rlKVLr0r6VGT3WgTUZon/losVo5DYBG+7mGe84g=;
 b=d+PBHCPvejhms6LMgCaMdRJt5veLyauwdnAqlj9A5idXs1NPmD4uVy7MKljE3wZBBPSc
 +80YBdL5gYVJ/oG5p8FQRvzpXw0fxqwxAZ60sb+yrqloWVCLiHIneNsBjwoPYhdqhEdE
 zKEzbKD2fXw0fZx987TaoapztJZZFWzpjwOVWttpLIymric7INcDfilt+jZXsTvS8il4
 gDJo7A5EgmgBLLhPZ5Qa1rzbBjudaicNK0e/q2sOXp2o7ZBUQbIVJco1Dw7ka+wHMSWG
 TVBuRc0Oc/J0LM1E7ByU1yjzCazlqjyDjklzfc3m3rH5d+2ddZ8yheKgEGH8gLiutuYO Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy3qsgwy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 14:00:20 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 249DpEaW021996;
        Mon, 9 May 2022 14:00:19 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy3qsgwwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 14:00:19 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 249DlIe6010322;
        Mon, 9 May 2022 14:00:17 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3fwgd8j1np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 14:00:17 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 249E0FRd44761482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 May 2022 14:00:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E72D242049;
        Mon,  9 May 2022 14:00:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 970DB42041;
        Mon,  9 May 2022 14:00:14 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.58])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 May 2022 14:00:14 +0000 (GMT)
Date:   Mon, 9 May 2022 15:58:21 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add cmm migration test
Message-ID: <20220509155821.07279b39@p-imbrenda>
In-Reply-To: <20220509120805.437660-3-nrb@linux.ibm.com>
References: <20220509120805.437660-1-nrb@linux.ibm.com>
        <20220509120805.437660-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m_--h1WZ0740ChKYcwhWQzfApP3K9ats
X-Proofpoint-ORIG-GUID: 8HHYBadBncQmpWS_pZ18Cs6FQvGBsyvf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_03,2022-05-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205090077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  9 May 2022 14:08:05 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> When a VM is migrated, we expect the page states to be preserved. Add a test
> which checks for that.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/Makefile        |  1 +
>  s390x/cmm-migration.c | 78 +++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg   |  4 +++
>  3 files changed, 83 insertions(+)
>  create mode 100644 s390x/cmm-migration.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index a8e04aa6fe4d..8ac0afdfd994 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -32,6 +32,7 @@ tests += $(TEST_DIR)/epsw.elf
>  tests += $(TEST_DIR)/adtl-status.elf
>  tests += $(TEST_DIR)/migration.elf
>  tests += $(TEST_DIR)/pv-attest.elf
> +tests += $(TEST_DIR)/cmm-migration.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  
> diff --git a/s390x/cmm-migration.c b/s390x/cmm-migration.c
> new file mode 100644
> index 000000000000..4a7b50e40fc6
> --- /dev/null
> +++ b/s390x/cmm-migration.c
> @@ -0,0 +1,78 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * CMM migration tests (ESSA)
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +
> +#include <libcflat.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/page.h>
> +#include <asm/cmm.h>
> +#include <bitops.h>
> +
> +#define NUM_PAGES 128
> +static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> +
> +static void test_migration(void)
> +{
> +	int i, state_mask, actual_state;
> +	/*
> +	 * Maps ESSA actions to states the page is allowed to be in after the
> +	 * respective action was executed.
> +	 */
> +	int allowed_essa_state_masks[4] = {
> +		BIT(ESSA_USAGE_STABLE),					/* ESSA_SET_STABLE */
> +		BIT(ESSA_USAGE_UNUSED),					/* ESSA_SET_UNUSED */
> +		BIT(ESSA_USAGE_VOLATILE),				/* ESSA_SET_VOLATILE */
> +		BIT(ESSA_USAGE_VOLATILE) | BIT(ESSA_USAGE_POT_VOLATILE) /* ESSA_SET_POT_VOLATILE */
> +	};
> +
> +	for (i = 0; i < NUM_PAGES; i++) {
> +		switch(i % 4) {
> +			case 0:
> +				essa(ESSA_SET_STABLE, (unsigned long)pagebuf[i]);
> +			break;
> +			case 1:
> +				essa(ESSA_SET_UNUSED, (unsigned long)pagebuf[i]);
> +			break;
> +			case 2:
> +				essa(ESSA_SET_VOLATILE, (unsigned long)pagebuf[i]);
> +			break;
> +			case 3:
> +				essa(ESSA_SET_POT_VOLATILE, (unsigned long)pagebuf[i]);
> +			break;

const int essa_commands[4] = {ESSA_SET_STABLE, ESSA_SET_UNUSED, ...

for (i = 0; i < NUM_PAGES; i++)
	essa(essa_commands[i % 4], ...

I think it would look more compact and more readable

> +		}
> +	}
> +
> +	puts("Please migrate me, then press return\n");
> +	(void)getchar();
> +
> +	for (i = 0; i < NUM_PAGES; i++) {
> +		actual_state = essa(ESSA_GET_STATE, (unsigned long)pagebuf[i]);
> +		/* extract the usage state in bits 60 and 61 */
> +		actual_state = (actual_state >> 2) & 0x3;
> +		state_mask = allowed_essa_state_masks[i % ARRAY_SIZE(allowed_essa_state_masks)];
> +		report(BIT(actual_state) & state_mask, "page %d state: expected_mask=0x%x actual_mask=0x%lx", i, state_mask, BIT(actual_state));
> +	}
> +}
> +
> +int main(void)
> +{
> +	bool has_essa = check_essa_available();
> +
> +	report_prefix_push("cmm-migration");
> +	if (!has_essa) {
> +		report_skip("ESSA is not available");
> +		goto done;
> +	}
> +
> +	test_migration();
> +done:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index b456b2881448..625026d90e52 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -176,3 +176,7 @@ extra_params = -cpu qemu,gs=off,vx=off
>  file = migration.elf
>  groups = migration
>  smp = 2
> +
> +[cmm-migration]
> +file = cmm-migration.elf
> +groups = migration

