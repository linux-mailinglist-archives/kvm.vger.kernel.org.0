Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03C25E9B7E
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 10:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiIZICp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 04:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbiIZICJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 04:02:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83845C53;
        Mon, 26 Sep 2022 00:59:34 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28Q7ArL5025180;
        Mon, 26 Sep 2022 07:59:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qVwWwHO5F57N5wbt52J88VX+qaLzg5TAP2NBWmLl0HU=;
 b=YbPaj1+i9j3X/1JD3WsOyw1HOKYahI+VvVywbKaCz6Qd9OKdDd5MqMEZ0Etl/dKK1Y/V
 AZy9gsxVYgy+fXIEYGDgZ2HwqtdzXcoIXejMWvutggqnQbYnHlV0NbxkNQk2NlpxgBoL
 sK+sckTbRflfacSe6mt1igrr+p/5ZtTgOVPDxCGNCNJXyTCFUoNmujF5OeOVbDO+PMu5
 pRUOBzBcc/4mwddqc7Dw8KLMf2Tt6UeHz1VCeL3TXsHjE+B8qGQEqHVeFMTO7SS8cag7
 bkvT4eG6hYfmbLAlfQ2m4RVw6MWqjelI4WIXxfEe2bEl8+g5gaODMfXGHtow0z7UusF6 ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jtbxr685h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 07:59:33 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28Q7m2G8002263;
        Mon, 26 Sep 2022 07:59:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jtbxr684t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 07:59:33 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28Q7q6MA013347;
        Mon, 26 Sep 2022 07:59:31 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3jssh9a3p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 07:59:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28Q7xSfT33620352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 07:59:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01FF54C046;
        Mon, 26 Sep 2022 07:59:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC2884C040;
        Mon, 26 Sep 2022 07:59:27 +0000 (GMT)
Received: from [9.171.90.15] (unknown [9.171.90.15])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 26 Sep 2022 07:59:27 +0000 (GMT)
Message-ID: <08831aac-ecaa-9cc4-3900-2b0049eec910@linux.ibm.com>
Date:   Mon, 26 Sep 2022 09:59:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [kvm-unit-tests PATCH v6 1/2] s390x: Add specification exception
 test
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220826161112.3786131-1-scgl@linux.ibm.com>
 <20220826161112.3786131-2-scgl@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220826161112.3786131-2-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iGapM5Um-OibpNz4LBVDB549yOZwY8GF
X-Proofpoint-GUID: f4JMAMcGj5-67R-3cYHQsKwiSIAzhtF3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_05,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 spamscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209260046
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/22 18:11, Janis Schoetterl-Glausch wrote:
> Generate specification exceptions and check that they occur.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Minor issues below, apart from that:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   s390x/Makefile           |   1 +
>   lib/s390x/asm/arch_def.h |   5 +
>   s390x/spec_ex.c          | 194 +++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg      |   3 +
>   4 files changed, 203 insertions(+)
>   create mode 100644 s390x/spec_ex.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index efd5e0c1..58b1bf54 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -27,6 +27,7 @@ tests += $(TEST_DIR)/uv-host.elf
>   tests += $(TEST_DIR)/edat.elf
>   tests += $(TEST_DIR)/mvpg-sie.elf
>   tests += $(TEST_DIR)/spec_ex-sie.elf
> +tests += $(TEST_DIR)/spec_ex.elf
>   tests += $(TEST_DIR)/firq.elf
>   tests += $(TEST_DIR)/epsw.elf
>   tests += $(TEST_DIR)/adtl-status.elf
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index e7ae454b..b6e60fb0 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -41,6 +41,11 @@ struct psw {
>   	uint64_t	addr;
>   };
>   
> +struct short_psw {
> +	uint32_t	mask;
> +	uint32_t	addr;
> +};
> +
>   struct cpu {
>   	struct lowcore *lowcore;
>   	uint64_t *stack;
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> new file mode 100644
> index 00000000..68469e4b
> --- /dev/null
> +++ b/s390x/spec_ex.c
> @@ -0,0 +1,194 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright IBM Corp. 2021, 2022
> + *
> + * Specification exception test.
> + * Tests that specification exceptions occur when expected.
> + *
> + * Can be extended by adding triggers to spec_ex_triggers, see comments below.
> + */
> +#include <stdlib.h>
> +#include <libcflat.h>
> +#include <bitops.h>
> +#include <asm/interrupt.h>
> +
> +/* toggled to signal occurrence of invalid psw fixup */
> +static bool invalid_psw_expected;
> +static struct psw expected_psw;
> +static struct psw invalid_psw;
> +static struct psw fixup_psw;
> +
> +/*
> + * The standard program exception handler cannot deal with invalid old PSWs,
> + * especially not invalid instruction addresses, as in that case one cannot
> + * find the instruction following the faulting one from the old PSW.
> + * The PSW to return to is set by load_psw.
> + */
> +static void fixup_invalid_psw(struct stack_frame_int *stack)
> +{
> +	/* signal occurrence of invalid psw fixup */
> +	invalid_psw_expected = false;

Hmmmm (TM), assert(invalid_psw_expected) ?

> +	invalid_psw = lowcore.pgm_old_psw;
> +	lowcore.pgm_old_psw = fixup_psw;
> +}
> +
> +/*
> + * Load possibly invalid psw, but setup fixup_psw before,
> + * so that fixup_invalid_psw() can bring us back onto the right track.
> + * Also acts as compiler barrier, -> none required in expect/check_invalid_psw
> + */
> +static void load_psw(struct psw psw)
> +{
> +	uint64_t scratch;
> +
> +	/*
> +	 * The fixup psw is current psw with the instruction address replaced by

is the current psw

> +	 * the address of the nop following the instruction loading the new psw. > +	 */
> +	fixup_psw.mask = extract_psw_mask();
> +	asm volatile ( "larl	%[scratch],0f\n"
> +		"	stg	%[scratch],%[fixup_addr]\n"
> +		"	lpswe	%[psw]\n"
> +		"0:	nop\n"
> +		: [scratch] "=&d" (scratch),
> +		  [fixup_addr] "=&T" (fixup_psw.addr)
> +		: [psw] "Q" (psw)
> +		: "cc", "memory"
> +	);
> +}
> +
> +static void load_short_psw(struct short_psw psw)
> +{
> +	uint64_t scratch;
> +
> +	fixup_psw.mask = extract_psw_mask();
> +	asm volatile ( "larl	%[scratch],0f\n"
> +		"	stg	%[scratch],%[fixup_addr]\n"
> +		"	lpsw	%[psw]\n"
> +		"0:	nop\n"
> +		: [scratch] "=&d" (scratch),
> +		  [fixup_addr] "=&T" (fixup_psw.addr)
> +		: [psw] "Q" (psw)
> +		: "cc", "memory"
> +	);
> +}
> +
> +static void expect_invalid_psw(struct psw psw)
> +{
> +	expected_psw = psw;
> +	invalid_psw_expected = true;
> +}
> +
> +static int check_invalid_psw(void)
> +{

/* Since the fixup sets this to false we check for false here. */

> +	if (!invalid_psw_expected) {
> +		if (expected_psw.mask == invalid_psw.mask &&
> +		    expected_psw.addr == invalid_psw.addr)
> +			return 0;
> +		report_fail("Wrong invalid PSW");
> +	} else {
> +		report_fail("Expected exception due to invalid PSW");
> +	}
> +	return 1;
> +}
> +

