Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61A1590E11
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 11:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237967AbiHLJ32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 05:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237811AbiHLJ3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 05:29:24 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEEFA99CE
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 02:29:22 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27C9DiUY002221
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:29:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=9qMIFBWfJmwwq00NgZd6jvpmtluAvfP9hl3x2xRMfN8=;
 b=Vrbt7MUpF/kd7QCeOpXeoaGpw0jeJC0d3bEunnfrWFkcY9va4n0Jy9xB4+BH3d6sDc1t
 M2VCizUOkapq2f+8w6tTYxiqnPwhzoWE4lFWmltQWpwzcpuhKtZUZG/ovTKqibmOlBml
 /iwN37UAZLp+hXkqppEMbJF3Ex9WxAl6eAhXcVqfcRL5DGBzdWjR+ewavnNxKbG6+86G
 XANKw93Unu2EjdGlcbDSSgfLvlLAhZY67lTvUKroDNsHJvtO5WJg0+yBVp9M25WbI765
 WVK20PoEHuv4twDTzenJG8jAX9f80KifaJ5AJIwvhEB4doTecWN8hB9BXwMog9RAyPGj bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwm1rrbe5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:29:21 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27C9E7o0002942
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:29:20 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwm1rrbdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 09:29:20 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27C9NWsW000671;
        Fri, 12 Aug 2022 09:29:19 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3huww0tg6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 09:29:18 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27C9TFdM29360608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 09:29:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CD5842041;
        Fri, 12 Aug 2022 09:29:15 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45C9C42049;
        Fri, 12 Aug 2022 09:29:15 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.179])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Aug 2022 09:29:15 +0000 (GMT)
Date:   Fri, 12 Aug 2022 11:29:12 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 3/4] s390x: add extint loop test
Message-ID: <20220812112912.3cd788f0@p-imbrenda>
In-Reply-To: <20220812062151.1980937-4-nrb@linux.ibm.com>
References: <20220812062151.1980937-1-nrb@linux.ibm.com>
        <20220812062151.1980937-4-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mgkZGrKnsInyHz5yGCVqvgWv12clBX88
X-Proofpoint-ORIG-GUID: NJtDfVISqxPxDYWH6W7C1DEbFPh9d97r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_06,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 adultscore=0 spamscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208120024
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Aug 2022 08:21:50 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> The CPU timer interrupt stays pending as long as the CPU timer value is
> negative. This can lead to interruption loops when the ext_new_psw mask
> has external interrupts enabled.
> 
> QEMU is able to detect this situation and panic the guest, so add a test
> for it.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  s390x/Makefile            |  1 +
>  s390x/panic-loop-extint.c | 59 +++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg       |  6 ++++
>  3 files changed, 66 insertions(+)
>  create mode 100644 s390x/panic-loop-extint.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index efd5e0c13102..e4649da50d9d 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -34,6 +34,7 @@ tests += $(TEST_DIR)/migration.elf
>  tests += $(TEST_DIR)/pv-attest.elf
>  tests += $(TEST_DIR)/migration-cmm.elf
>  tests += $(TEST_DIR)/migration-skey.elf
> +tests += $(TEST_DIR)/panic-loop-extint.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  
> diff --git a/s390x/panic-loop-extint.c b/s390x/panic-loop-extint.c
> new file mode 100644
> index 000000000000..79d3f84a89ff
> --- /dev/null
> +++ b/s390x/panic-loop-extint.c
> @@ -0,0 +1,59 @@
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
> +#include <hardware.h>
> +#include <bitops.h>
> +
> +static void ext_int_cleanup(struct stack_frame_int *stack)
> +{
> +	/*
> +	 * Since we form a loop of ext interrupts, this code should never be
> +	 * executed. In case it is executed, something went wrong and we want to
> +	 * print a failure.
> +	 *
> +	 * Because the CPU timer subclass mask is still enabled, the CPU timer
> +	 * interrupt will fire every time we enable external interrupts,
> +	 * preventing us from printing the failure on the console. To avoid
> +	 * this, clear the CPU timer subclass mask here.
> +	 */
> +	stack->crs[0] &= ~BIT(CTL0_CPU_TIMER);
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("panic-loop-extint");
> +
> +	if (!host_is_qemu() || host_is_tcg()) {
> +		report_skip("QEMU-KVM-only test");
> +		goto out;
> +	}
> +
> +	expect_ext_int();
> +	lowcore.ext_new_psw.mask |= PSW_MASK_EXT;
> +
> +	load_psw_mask(extract_psw_mask() | PSW_MASK_EXT);

you can use the recently introduced psw_mask_set_bits(PSW_MASK_EXT)

> +
> +	register_ext_cleanup_func(ext_int_cleanup);
> +
> +	cpu_timer_set_ms(10);
> +	ctl_set_bit(0, CTL0_CPU_TIMER);
> +	mdelay(2000);
> +
> +	register_ext_cleanup_func(NULL);
> +
> +	report_fail("survived extint loop");
> +
> +out:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index f7b1fc3dbca1..b1b25f118ff6 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -185,3 +185,9 @@ groups = migration
>  [migration-skey]
>  file = migration-skey.elf
>  groups = migration
> +
> +[panic-loop-extint]
> +file = panic-loop-extint.elf
> +groups = panic
> +accel = kvm
> +timeout = 5

