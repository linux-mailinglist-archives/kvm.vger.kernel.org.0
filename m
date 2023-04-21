Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC856EAE4D
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 17:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjDUPvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 11:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjDUPv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 11:51:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F576B47D;
        Fri, 21 Apr 2023 08:51:23 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33LFgH7L010342;
        Fri, 21 Apr 2023 15:51:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=3p7TEn3zigq4RakUYbIPjib7jXKU4vfNdcj6eshVgGY=;
 b=tdJEWkD7ALOt7C5UHLagukOk34i6K+GQU+WYsdVEGZAtOgdj0b+HFgmrmVZtYemYiOT5
 JND9WsC280bUOfL5wz2PXzo/uWMc6h97oLtnzcsLNKLUC3bVvZacqznPwM12gKgpllwB
 JIVErTbrHGsV/WHN8wSNTLgO9a+mlDRDquKlEaxzvMPy3OEOzMEbaW3u+meaLLxEvMYy
 7OHXjO8YwEgfK9kC8LV1QjZxToytzkO0UocIPoNjgUso5kAaE7sCogpFggso0LPv9WrP
 lQ7EIgeaK/INpP+6drXgz5fO4zEo6LSdHUZsEmNE1Jgbg9uYcMJrWg/4fRmW5jRaTKNL 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3wc1g996-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:51:22 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33LFj5qe024247;
        Fri, 21 Apr 2023 15:51:22 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3wc1g980-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:51:22 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33LAHA3V029653;
        Fri, 21 Apr 2023 15:32:31 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pykj6c4m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:32:31 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33LFWRJU20710006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 15:32:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A78DB20049;
        Fri, 21 Apr 2023 15:32:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AEAE20043;
        Fri, 21 Apr 2023 15:32:27 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.17.52])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri, 21 Apr 2023 15:32:27 +0000 (GMT)
Date:   Fri, 21 Apr 2023 17:32:11 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        nrb@linux.ibm.com, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 6/7] s390x: pv: Add IPL reset tests
Message-ID: <20230421173211.0a47e1dc@p-imbrenda>
In-Reply-To: <20230421113647.134536-7-frankja@linux.ibm.com>
References: <20230421113647.134536-1-frankja@linux.ibm.com>
        <20230421113647.134536-7-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ngz261cuxxatjJfUpx-KhVeqsmGsoNZz
X-Proofpoint-GUID: qc14AWi0eria-kmeNxthYxxnXpcfRSAk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_08,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 impostorscore=0 spamscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Apr 2023 11:36:46 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The diag308 requires extensive cooperation between the hypervisor and
> the Ultravisor so the Ultravisor can make sure all necessary reset
> steps have been done.
> 
> Let's check if we get the correct validity errors.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile      |   2 +
>  s390x/pv-ipl.c      | 145 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   4 ++
>  3 files changed, 151 insertions(+)
>  create mode 100644 s390x/pv-ipl.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 67be5360..b5b94810 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -43,6 +43,7 @@ tests += $(TEST_DIR)/ex.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  pv-tests += $(TEST_DIR)/pv-icptcode.elf
> +pv-tests += $(TEST_DIR)/pv-ipl.elf
>  
>  ifneq ($(HOST_KEY_DOCUMENT),)
>  ifneq ($(GEN_SE_HEADER),)
> @@ -130,6 +131,7 @@ $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-icpt-112.gbin
>  $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/icpt-loop.gbin
>  $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/loop.gbin
>  $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-icpt-vir-timing.gbin
> +$(TEST_DIR)/pv-ipl.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-308.gbin
>  
>  ifneq ($(GEN_SE_HEADER),)
>  snippets += $(pv-snippets)
> diff --git a/s390x/pv-ipl.c b/s390x/pv-ipl.c
> new file mode 100644
> index 00000000..aad1275e
> --- /dev/null
> +++ b/s390x/pv-ipl.c
> @@ -0,0 +1,145 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * PV diagnose 308 (IPL) tests
> + *
> + * Copyright (c) 2023 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <sie.h>
> +#include <sclp.h>
> +#include <snippet.h>
> +#include <pv_icptdata.h>
> +#include <asm/facility.h>
> +#include <asm/uv.h>
> +
> +static struct vm vm;
> +
> +static void test_diag_308(int subcode)
> +{
> +	extern const char SNIPPET_NAME_START(asm, pv_diag_308)[];
> +	extern const char SNIPPET_NAME_END(asm, pv_diag_308)[];
> +	extern const char SNIPPET_HDR_START(asm, pv_diag_308)[];
> +	extern const char SNIPPET_HDR_END(asm, pv_diag_308)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, pv_diag_308);
> +	int size_gbin = SNIPPET_LEN(asm, pv_diag_308);
> +	uint16_t rc, rrc;
> +	char prefix[10];
> +	int cc;
> +
> +	snprintf(prefix, sizeof(prefix), "subcode %d", subcode);
> +
> +	report_prefix_push(prefix);

report_prefix_pushf

> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, pv_diag_308),
> +			SNIPPET_HDR_START(asm, pv_diag_308),
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> +
> +	/* First exit is a diag 0x500 */
> +	sie(&vm);
> +	assert(pv_icptdata_check_diag(&vm, 0x500));
> +
> +	/*
> +	 * The snippet asked us for the subcode and we answer with 0 in gr2

not always 0 I guess?

> +	 * SIE will copy gr2 to the guest
> +	 */
> +	vm.save_area.guest.grs[2] = subcode;
> +
> +	/* Continue after diag 0x500, next icpt should be the 0x308 */
> +	sie(&vm);
> +	assert(pv_icptdata_check_diag(&vm, 0x308));
> +	assert(vm.save_area.guest.grs[2] == subcode);
> +
> +	/*
> +	 * We need to perform several UV calls to emulate the subcode
> +	 * 0/1. Failing to do that should result in a validity.
> +	 *
> +	 * - Mark all cpus as stopped
> +	 * - Unshare all memory
> +	 * - Prepare the reset
> +	 * - Reset the cpus
> +	 * - Load the reset PSW
> +	 */
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report(uv_validity_check(&vm), "validity, no action");
> +
> +	/* Mark the CPU as stopped so we can unshare and reset */
> +	cc = uv_set_cpu_state(vm.sblk->pv_handle_cpu, PV_CPU_STATE_STP);
> +	report(!cc, "Set cpu stopped");
> +
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report(uv_validity_check(&vm), "validity, stopped");
> +
> +	/* Unshare all memory */
> +	cc = uv_cmd_nodata(vm.sblk->pv_handle_config,
> +			   UVC_CMD_SET_UNSHARED_ALL, &rc, &rrc);
> +	report(cc == 0 && rc == 1, "Unshare all");
> +
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report(uv_validity_check(&vm), "validity, stopped, unshared");
> +
> +	/* Prepare the CPU reset */
> +	cc = uv_cmd_nodata(vm.sblk->pv_handle_config,
> +			   UVC_CMD_PREPARE_RESET, &rc, &rrc);
> +	report(cc == 0 && rc == 1, "Prepare reset call");
> +
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report(uv_validity_check(&vm), "validity, stopped, unshared, prep reset");
> +
> +	/*
> +	 * Do the reset on the initiating cpu
> +	 *
> +	 * Reset clear for subcode 0
> +	 * Reset initial for subcode 1
> +	 */
> +	if (subcode == 0) {
> +		cc = uv_cmd_nodata(vm.sblk->pv_handle_cpu,
> +				   UVC_CMD_CPU_RESET_CLEAR, &rc, &rrc);
> +		report(cc == 0 && rc == 1, "Clear reset cpu");
> +	} else {
> +		cc = uv_cmd_nodata(vm.sblk->pv_handle_cpu,
> +				   UVC_CMD_CPU_RESET_INITIAL, &rc, &rrc);
> +		report(cc == 0 && rc == 1, "Initial reset cpu");
> +	}
> +
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report(uv_validity_check(&vm), "validity, stopped, unshared, prep reset, cpu reset");
> +
> +	/* Load the PSW from 0x0 */
> +	cc = uv_set_cpu_state(vm.sblk->pv_handle_cpu, PV_CPU_STATE_OPR_LOAD);
> +	report(!cc, "Set cpu load");
> +
> +	/*
> +	 * Check if we executed the iaddr of the reset PSW, we should
> +	 * see a diagnose 0x9c PV instruction notification.
> +	 */
> +	sie(&vm);
> +	report(pv_icptdata_check_diag(&vm, 0x9c) &&
> +	       vm.save_area.guest.grs[0] == 42,
> +	       "continue after load");
> +
> +	uv_destroy_guest(&vm);
> +	report_prefix_pop();
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("uv-sie");
> +	if (!uv_guest_requirement_checks())
> +		goto done;
> +
> +	snippet_setup_guest(&vm, true);
> +	test_diag_308(0);
> +	test_diag_308(1);
> +	sie_guest_destroy(&vm);
> +
> +done:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index e2d3478e..e08e5c84 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -223,3 +223,7 @@ file = ex.elf
>  file = pv-icptcode.elf
>  smp = 3
>  extra_params = -m 2200
> +
> +[pv-ipl]
> +file = pv-ipl.elf
> +extra_params = -m 2200

