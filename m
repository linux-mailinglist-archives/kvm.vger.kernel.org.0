Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773AA6CC82C
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 18:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbjC1Qi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 12:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjC1QiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 12:38:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC1BEFBA
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:38:14 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SEg7tF009825
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 16:38:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=LyZl9hbVb5eUt8jg2Q7W6m3d1PRuVPetdX5Za6TAcM8=;
 b=CHnVYZjXlYREXIvycyoqJsbxYXwO25GbGobKL5A9kFuy7CL55ENV2cJdFOgsjAupoVwx
 jg14e9l5ZfwlZ6Vez3patLyD/2UPVXW0zaufbhCwDpyn+8OwtTdyjsoWeaDrMFCn9b8j
 9abAl3S3uAg8E0HqoO6xi6GYzNzyu58NsYGLmBG5/zUobgH4digcx6JJeTQobuPJjRCQ
 0B0Doq0S1ZMFAQW2QYmo14twezyIf8ALFlGIZipr4f8XKmPp+8nLpqi17B1a6zXsBs9Z
 A/oiuTsl7sQkzV6v0r+PzCHFE940hlJavQcyDC40RttRCz2okL0aGksQ9ykA58UUtoAM uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pm27qub7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 16:38:14 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32SEgQdZ011136
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 16:38:14 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pm27qub2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 16:38:13 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32S1o4iB032379;
        Tue, 28 Mar 2023 16:38:00 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6m557-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 16:38:00 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32SGbvYD48693714
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 16:37:57 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0CDA20049;
        Tue, 28 Mar 2023 16:37:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8A3820040;
        Tue, 28 Mar 2023 16:37:56 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 28 Mar 2023 16:37:56 +0000 (GMT)
Date:   Tue, 28 Mar 2023 18:37:24 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: pv: Add IPL reset tests
Message-ID: <20230328183724.388e2548@p-imbrenda>
In-Reply-To: <20230324120431.20260-4-frankja@linux.ibm.com>
References: <20230324120431.20260-1-frankja@linux.ibm.com>
        <20230324120431.20260-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ADDG5GOk8kUwmc8CKrkcVgZi-1Xmx_KQ
X-Proofpoint-ORIG-GUID: LDByC1Qo7x-AfJdf8yjpWb9Z6gS2Rl71
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0
 adultscore=0 clxscore=1015 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280130
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Mar 2023 12:04:31 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The diag308 requires extensive cooperation between the hypervisor and
> the Ultravisor so the Ultravisor can make sure all necessary reset
> steps have been done.
> 
> Let's check if we get the correct validity errors.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile                           |   2 +
>  s390x/pv-ipl.c                           | 246 +++++++++++++++++++++++
>  s390x/snippets/asm/snippet-pv-diag-308.S |  67 ++++++
>  3 files changed, 315 insertions(+)
>  create mode 100644 s390x/pv-ipl.c
>  create mode 100644 s390x/snippets/asm/snippet-pv-diag-308.S
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 858f5af4..e8559a4e 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -42,6 +42,7 @@ tests += $(TEST_DIR)/exittime.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  pv-tests += $(TEST_DIR)/pv-icptcode.elf
> +pv-tests += $(TEST_DIR)/pv-ipl.elf
>  
>  ifneq ($(HOST_KEY_DOCUMENT),)
>  ifneq ($(GEN_SE_HEADER),)
> @@ -124,6 +125,7 @@ $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-icpt-1
>  $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-icpt-loop.gbin
>  $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-loop.gbin
>  $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-icpt-vir-timing.gbin
> +$(TEST_DIR)/pv-ipl.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-308.gbin
>  
>  ifneq ($(GEN_SE_HEADER),)
>  snippets += $(pv-snippets)
> diff --git a/s390x/pv-ipl.c b/s390x/pv-ipl.c
> new file mode 100644
> index 00000000..d17cf59d
> --- /dev/null
> +++ b/s390x/pv-ipl.c
> @@ -0,0 +1,246 @@
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
> +#include <asm/facility.h>
> +#include <asm/uv.h>
> +
> +static struct vm vm;
> +
> +static void setup_gbin(void)
> +{
> +	extern const char SNIPPET_NAME_START(asm, snippet_pv_diag_308)[];
> +	extern const char SNIPPET_NAME_END(asm, snippet_pv_diag_308)[];
> +	extern const char SNIPPET_HDR_START(asm, snippet_pv_diag_308)[];
> +	extern const char SNIPPET_HDR_END(asm, snippet_pv_diag_308)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_diag_308);
> +	int size_gbin = SNIPPET_LEN(asm, snippet_pv_diag_308);
> +
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_308),
> +			SNIPPET_HDR_START(asm, snippet_pv_diag_308),
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> +}
> +
> +static void test_diag_308_1(void)
> +{
> +	uint16_t rc, rrc;
> +	int cc;
> +
> +	report_prefix_push("subcode 1");
> +	setup_gbin();
> +
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x500,
> +	       "intercept values diag 500");
> +	/* The snippet asked us for the subcode and we answer with 1 in gr2 */
> +	vm.save_area.guest.grs[2] = 1;
> +
> +	/* Continue after diag 0x500, next icpt should be the 0x308 */
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x308,
> +	       "intercept values diag 0x308");
> +	report(vm.save_area.guest.grs[2] == 1,
> +	       "subcode 1");
> +
> +	/*
> +	 * We need to perform several UV calls to emulate the subcode
> +	 * 1. Failing to do that should result in a validity.
> +	 *
> +	 * - Mark all cpus as stopped
> +	 * - Unshare all
> +	 * - Prepare for reset
> +	 * - Reset the cpus, calling one gets an initial reset
> +	 * - Load the reset PSW
> +	 */
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity no UVCs");

didn't you introduce a new function in patch 1 to check for PV validity?

> +
> +	/* Mark the CPU as stopped so we can unshare and reset */
> +	cc = uv_set_cpu_state(vm.sblk->pv_handle_cpu, PV_CPU_STATE_STP);
> +	report(!cc, "Set cpu stopped");
> +
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity stopped");
> +
> +	/* Unshare all memory */
> +	cc = uv_cmd_nodata(vm.sblk->pv_handle_config,
> +			   UVC_CMD_SET_UNSHARED_ALL, &rc, &rrc);
> +	report(cc == 0 && rc == 1, "Unshare all");
> +
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report((sie_get_validity(&vm) & 0xff00) == 0x2000,
> +	       "validity stopped, unshared");
> +
> +	/* Prepare the CPU reset */
> +	cc = uv_cmd_nodata(vm.sblk->pv_handle_config,
> +			   UVC_CMD_PREPARE_RESET, &rc, &rrc);
> +	report(cc == 0 && rc == 1, "Prepare reset call");
> +
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report((sie_get_validity(&vm) & 0xff00) == 0x2000,
> +	       "validity stopped, unshared, prepare");
> +
> +	/* Do the reset */
> +	cc = uv_cmd_nodata(vm.sblk->pv_handle_cpu,
> +			   UVC_CMD_CPU_RESET_INITIAL, &rc, &rrc);
> +	report(cc == 0 && rc == 1, "Initial reset cpu");
> +
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report((sie_get_validity(&vm) & 0xff00) == 0x2000,
> +	       "validity stopped, unshared, prepare, reset");
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
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x9c &&
> +	       vm.save_area.guest.grs[0] == 42,
> +	       "intercept values after diag 0x308");
> +
> +
> +	uv_destroy_guest(&vm);
> +	report_prefix_pop();
> +}
> +
> +static void test_diag_308_0(void)
> +{

this function seems a clone of the previous, with very minimal changes,
can't you merge them?

> +	uint16_t rc, rrc;
> +	int cc;
> +
> +	report_prefix_push("subcode 0");
> +	setup_gbin();
> +
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x500,
> +	       "intercept values diag 500");
> +	/* The snippet asked us for the subcode and we answer with 0 in gr2 */
> +	vm.save_area.guest.grs[2] = 0;
> +
> +	/* Continue after diag 0x500, next icpt should be the 0x308 */
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x308,
> +	       "intercept values");
> +	report(vm.save_area.guest.grs[2] == 0,
> +	       "subcode 0");
> +
> +	/*
> +	 * We need to perform several UV calls to emulate the subcode
> +	 * 0. Failing to do that should result in a validity.
> +	 *
> +	 * - Mark all cpus as stopped
> +	 * - Unshare all memory
> +	 * - Prepare the reset
> +	 * - Reset the cpus
> +	 * - Load the reset PSW
> +	 */
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity, no action");
> +
> +	/* Mark the CPU as stopped so we can unshare and reset */
> +	cc = uv_set_cpu_state(vm.sblk->pv_handle_cpu, PV_CPU_STATE_STP);
> +	report(!cc, "Set cpu stopped");
> +
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity, stopped");
> +
> +	/* Unshare all memory */
> +	cc = uv_cmd_nodata(vm.sblk->pv_handle_config,
> +			   UVC_CMD_SET_UNSHARED_ALL, &rc, &rrc);
> +	report(cc == 0 && rc == 1, "Unshare all");
> +
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity stopped, unshared");
> +
> +	/* Prepare the CPU reset */
> +	cc = uv_cmd_nodata(vm.sblk->pv_handle_config,
> +			   UVC_CMD_PREPARE_RESET, &rc, &rrc);
> +	report(cc == 0 && rc == 1, "Prepare reset call");
> +
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity stopped, unshared, prep reset");
> +
> +	/* Do the reset */
> +	cc = uv_cmd_nodata(vm.sblk->pv_handle_cpu,
> +			   UVC_CMD_CPU_RESET_CLEAR, &rc, &rrc);
> +	report(cc == 0 && rc == 1, "Clear reset cpu");
> +
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity stopped, unshared, prep reset, cpu reset");
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
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x9c &&
> +	       vm.save_area.guest.grs[0] == 42,

you are checking for DIAGs a lot, maybe it's worth adding a helper
function like for validity

something like:
report(uv_diag_check(&vm, 0x9c) && ... 

> +	       "intercept values");
> +
> +	uv_destroy_guest(&vm);
> +	report_prefix_pop();
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("uv-sie");
> +	if (!test_facility(158)) {
> +		report_skip("UV Call facility unavailable");
> +		goto done;
> +	}
> +	if (!sclp_facilities.has_sief2) {
> +		report_skip("SIEF2 facility unavailable");
> +		goto done;
> +	}
> +	/*
> +	 * Some of the UV memory needs to be allocated with >31 bit
> +	 * addresses which means we need a lot more memory than other
> +	 * tests.
> +	 */
> +	if (get_ram_size() < (SZ_1M * 2200UL)) {

I think it makes sense to put this in a macro. first, so that it isn't
a magic value, and second so that you have a single point where you can
change it if it ever needs to be changed in the future 

> +		report_skip("Not enough memory. This test needs about 2200MB of memory");

then you can do "%luMB" and use the macro here ^

> +		goto done;
> +	}
> +
> +	snippet_setup_guest(&vm, true);
> +	test_diag_308_0();
> +	test_diag_308_1();
> +	sie_guest_destroy(&vm);
> +
> +done:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/snippets/asm/snippet-pv-diag-308.S b/s390x/snippets/asm/snippet-pv-diag-308.S
> new file mode 100644
> index 00000000..58c96173
> --- /dev/null
> +++ b/s390x/snippets/asm/snippet-pv-diag-308.S
> @@ -0,0 +1,67 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Diagnose 0x308 snippet used for PV IPL and reset testing
> + *
> + * Copyright (c) 2023 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +#include <asm/asm-offsets.h>
> +.section .text
> +
> +/* Sets a reset PSW with the given PSW address */
> +.macro SET_RESET_PSW_ADDR label
> +lgrl	%r5, reset_psw
> +larl	%r6, \label
> +ogr	%r5, %r6
> +stg	%r5, 0
> +.endm
> +
> +/* Does a diagnose 308 with the given subcode */

but it seems you are not actually using this macro?

> +.macro DIAG308 subcode
> +xgr	%r3, %r3
> +lghi	%r3, \subcode
> +diag	1, 3, 0x308
> +.endm
> +
> +sam64
> +
> +/* Execute the diag500 which will set the subcode we execute in gr2 */
> +diag	0, 0, 0x500
> +
> +/*
> + * A valid PGM new PSW can be a real problem since we never fall out
> + * of SIE and therefore effectively loop forever. 0 is a valid PSW
> + * therefore we re-use the reset_psw as this has the short PSW
> + * bit set which is invalid for a long PSW like the exception new
> + * PSWs.
> + *
> + * For subcode 0/1 there are no PGMs to consider.
> + */
> +lgrl   %r5, reset_psw
> +stg    %r5, GEN_LC_PGM_NEW_PSW
> +
> +/* Clean registers that are used */
> +xgr	%r0, %r0
> +xgr	%r1, %r1
> +xgr	%r3, %r3
> +xgr	%r4, %r4
> +xgr	%r5, %r5
> +xgr	%r6, %r6
> +
> +/* Subcode 0 - Modified Clear */
> +SET_RESET_PSW_ADDR done
> +diag	%r0, %r2, 0x308
> +
> +/* Should never be executed because of the reset PSW */
> +diag	0, 0, 0x44
> +
> +done:
> +lghi	%r1, 42
> +diag	%r1, 0, 0x9c
> +
> +
> +	.align	8
> +reset_psw:
> +	.quad	0x0008000180000000

