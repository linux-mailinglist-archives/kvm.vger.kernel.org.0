Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C7C69B140
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 17:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjBQQmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 11:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjBQQmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 11:42:49 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C73472916;
        Fri, 17 Feb 2023 08:42:42 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31HG9ReH015677;
        Fri, 17 Feb 2023 16:42:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=RXsfqh9OKheMYhHDnfbRzosWPgga/aEbqUy2oi+eRmE=;
 b=RcWa+XEj9DhYUFReDEF9Q+Swlu9iB1NjzbOOAKJs/MOFrc1JLR89YpPV+skdbQXbi8qg
 Kl896ycpDcrAggtKkOu6KnQKZRRCqMZhktnnUz+rWgTmNFPDlunaWIFyrBiJwpq9OWA0
 gkJSKDzJQsQldFaqP2cLFxVSkGZWYb7ZiL+PiF1cxnKz+EsxbY+Czxa78Rs/KKHejUOw
 RTub6ge5rOzzCjplJ+X6nVMXCB3GX45wC6CdK0iSD4Au/LU1F18qNlpHKIcpMaTI5C8s
 oK7katHM6JMiLyXNAGx0fwS904x9jOPapqn82IcIP2Vlh/+CAMclitGncwySKhxnS/Qe Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ntbesk5fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 16:42:41 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31HGVdUc011274;
        Fri, 17 Feb 2023 16:42:40 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ntbesk5eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 16:42:40 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31HBR58P031329;
        Fri, 17 Feb 2023 16:42:38 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3np29fra3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 16:42:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31HGgZPP18874892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Feb 2023 16:42:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 233C220043;
        Fri, 17 Feb 2023 16:42:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4A2920049;
        Fri, 17 Feb 2023 16:42:34 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.12.31])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri, 17 Feb 2023 16:42:34 +0000 (GMT)
Date:   Fri, 17 Feb 2023 17:42:19 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: pv: Add IPL reset tests
Message-ID: <20230217174219.71163eb5@p-imbrenda>
In-Reply-To: <20230201084833.39846-4-frankja@linux.ibm.com>
References: <20230201084833.39846-1-frankja@linux.ibm.com>
        <20230201084833.39846-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: k00zO66PM2WvS4IXeJFi-DRZiyFXBqhY
X-Proofpoint-ORIG-GUID: KEQhLq8p6GSnLBhfZ-tB5UlUOv0ZBAZ-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_11,2023-02-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302170148
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  1 Feb 2023 08:48:33 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The diag308 requires extensive cooperation between the hypervisor and
> the Ultravisor so the Ultravisor can make sure all necessary reset
> steps have been done.
> 
> Let's check if we get the correct validity errors.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---

[...]

> +
> +	/*
> +	 * We need to perform several UV calls to emulate the subcode
> +	 * 1. Failing to do that should result in a validity
> +	 *
> +	 * - Mark all cpus as stopped
> +	 * - Reset the cpus, calling one gets an initial reset
> +	 * - Load the reset PSW
> +	 * - Unshare all
> +	 * - Load the reset PSW

you forgot to mention prepare the reset, and the list does not reflect
the order things are done in the code

> +	 */
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report((sie_get_validity(&vm) & 0xff00) == 0x2000, "validity no UVCs");
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
> +	report(cc == 0 && rc == 1, "Clear reset cpu");
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

[...]

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

what about subcode 1?

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

