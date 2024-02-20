Return-Path: <kvm+bounces-9218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B703685C195
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 17:39:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D957D1C218F7
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 16:39:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC599768E6;
	Tue, 20 Feb 2024 16:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YzbVskrt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6F0762E0;
	Tue, 20 Feb 2024 16:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708447149; cv=none; b=px/vV4cPGyn58/Cj6TaqpNQ9FcpPgK/6zAyMDOCRBtMxmqVNDmwEULyrtrlq1qDnUtfivWV1SK6jZqxY7CEOdMfQBvIFuUofoPSd7uiZ88CczbvtNV/uEBD1tU1rdF0PuNN2b/imbndpLBNgb0dnDrGwl8cOtibWdRbwGwQz9bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708447149; c=relaxed/simple;
	bh=e/MnLbL2WYfj0Tu9rlkFT0aLALqfVP0DcRYd3sXarZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PewZ+5Bi2m5yWitK0Xz+Yk5ypoA+Q+cnLH9Pw9u93ATOCrpwBOLhYSUrFG9W6DeGLGGGk+GS/PgbJ0TiSTmtTgNWXJYHAvnoGOu6mx5hAQMCQbPthLf0wTTEncu4hIB2jCUYbHbDG+R4dOZQ0TohcZIcfhPxK0e6KSOuY9DvoJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YzbVskrt; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41KGHfn4023031;
	Tue, 20 Feb 2024 16:39:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eHMzFEoMdrKnKvn9DpCqJVv75wgKI/Ci29V6vVGpV8I=;
 b=YzbVskrtZsHJgTgawM+0gxup5gymXExKAuzkTGkoDVKfiIg07yg0SYaebcYt6Z1ye0Q4
 Q2KNpfIrPsvGiD6vpqIiEpzkLFG/SKVbrzpXpghCrWj9idFDH2qqrb55804LVhKdU58v
 tg0YHesihhpdo30kT26QcJviKOe3RhFuFUTc83vceEs6U8H4Ctqg7uNr3y9JQZgKilow
 q8QehS71wdpGCHTR2cEWBwE9NAay+oPVHQOQ1q6cI2AHCeTKbXl8iYLRSC9wdoBQpEfo
 +J9VqDRipde1VzB9dr5Xk9/TM6cL/OVGmPVoLnR/81CKXVRSBGL8CkH6jUHSMvxCTm+1 Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wcyfh0p82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Feb 2024 16:39:05 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41KGbC2F019445;
	Tue, 20 Feb 2024 16:39:05 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wcyfh0p7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Feb 2024 16:39:04 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41KFxY4w031138;
	Tue, 20 Feb 2024 16:39:04 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wb9bkrwav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Feb 2024 16:39:04 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41KGd0l066585040
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 16:39:02 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7ADC55806C;
	Tue, 20 Feb 2024 16:39:00 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E3D55805F;
	Tue, 20 Feb 2024 16:38:59 +0000 (GMT)
Received: from [9.61.172.126] (unknown [9.61.172.126])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 Feb 2024 16:38:59 +0000 (GMT)
Message-ID: <f05c83a9-bcc6-4963-98f4-72159673ba3a@linux.ibm.com>
Date: Tue, 20 Feb 2024 11:38:58 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 2/7] s390x: Add guest 2 AP test
Content-Language: en-US
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        jjherne@linux.ibm.com
References: <20240202145913.34831-1-frankja@linux.ibm.com>
 <20240202145913.34831-3-frankja@linux.ibm.com>
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20240202145913.34831-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dwAyVtmu-D7yO_j9NeWV18ulFldV-lN3
X-Proofpoint-GUID: Et5MwRzd7D-Hv2Rq0w9lgflxKsylpjay
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1011 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402200119

I made a couple of function name change suggestions, but those are not 
critical:

Acked-by: Anthony Krowiak <akrowiak@linux.ibm.com>

On 2/2/24 9:59 AM, Janosch Frank wrote:
> Add a test that checks the exceptions for the PQAP, NQAP and DQAP
> adjunct processor (AP) crypto instructions.
>
> Since triggering the exceptions doesn't require actual AP hardware,
> this test can run without complicated setup.
>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/Makefile      |   1 +
>   s390x/ap.c          | 309 ++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |   3 +
>   3 files changed, 313 insertions(+)
>   create mode 100644 s390x/ap.c
>
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 4f6c627d..6d28a5bf 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -42,6 +42,7 @@ tests += $(TEST_DIR)/exittime.elf
>   tests += $(TEST_DIR)/ex.elf
>   tests += $(TEST_DIR)/topology.elf
>   tests += $(TEST_DIR)/sie-dat.elf
> +tests += $(TEST_DIR)/ap.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   pv-tests += $(TEST_DIR)/pv-icptcode.elf
> diff --git a/s390x/ap.c b/s390x/ap.c
> new file mode 100644
> index 00000000..b3cee37a
> --- /dev/null
> +++ b/s390x/ap.c
> @@ -0,0 +1,309 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * AP instruction G2 tests
> + *
> + * Copyright (c) 2024 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +
> +#include <libcflat.h>
> +#include <interrupt.h>
> +#include <bitops.h>
> +#include <alloc_page.h>
> +#include <asm/facility.h>
> +#include <asm/time.h>
> +#include <ap.h>
> +
> +/* For PQAP PGM checks where we need full control over the input */
> +static void pqap(unsigned long grs[3])
> +{
> +	asm volatile(
> +		"	lgr	0,%[r0]\n"
> +		"	lgr	1,%[r1]\n"
> +		"	lgr	2,%[r2]\n"
> +		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
> +		::  [r0] "d" (grs[0]), [r1] "d" (grs[1]), [r2] "d" (grs[2])
> +		: "cc", "memory", "0", "1", "2");
> +}
> +
> +static void test_pgms_pqap(void)


If I saw this function name without having read the patch description, I 
wouldn't have any idea what is being tested.

Maybe test_pqap_pgm_chk?


> +{
> +	unsigned long grs[3] = {};
> +	struct pqap_r0 *r0 = (struct pqap_r0 *)grs;
> +	uint8_t *data = alloc_page();
> +	uint16_t pgm;
> +	int fails = 0;
> +	int i;
> +
> +	report_prefix_push("pqap");
> +
> +	/* Wrong FC code */
> +	report_prefix_push("invalid fc");
> +	r0->fc = 42;


Just out of curiosity, why 42? Why not some ridiculous number that will 
never be used for a function code, like 4294967295?


> +	expect_pgm_int();
> +	pqap(grs);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	memset(grs, 0, sizeof(grs));
> +	report_prefix_pop();
> +
> +	report_prefix_push("invalid gr0 bits");
> +	/*
> +	 * GR0 bits 41 - 47 are defined 0 and result in a
> +	 * specification exception if set to 1.
> +	 */
> +	for (i = 0; i < 48 - 41; i++) {
> +		grs[0] = BIT(63 - 47 + i);
> +
> +		expect_pgm_int();
> +		pqap(grs);
> +		pgm = clear_pgm_int();
> +
> +		if (pgm != PGM_INT_CODE_SPECIFICATION) {
> +			report_fail("fail on bit %d", 42 + i);
> +			fails++;
> +		}
> +	}
> +	report(!fails, "All bits tested");
> +	memset(grs, 0, sizeof(grs));
> +	fails = 0;
> +	report_prefix_pop();
> +
> +	report_prefix_push("alignment");
> +	report_prefix_push("fc=4");
> +	r0->fc = PQAP_QUERY_AP_CONF_INFO;
> +	grs[2] = (unsigned long)data;
> +	for (i = 1; i < 8; i++) {
> +		expect_pgm_int();
> +		grs[2]++;
> +		pqap(grs);
> +		pgm = clear_pgm_int();
> +		if (pgm != PGM_INT_CODE_SPECIFICATION) {
> +			report_fail("fail on bit %d", i);
> +			fails++;
> +		}
> +	}
> +	report(!fails, "All alignments tested");
> +	report_prefix_pop();
> +	report_prefix_push("fc=6");
> +	r0->fc = PQAP_BEST_AP;
> +	grs[2] = (unsigned long)data;
> +	for (i = 1; i < 8; i++) {
> +		expect_pgm_int();
> +		grs[2]++;
> +		pqap(grs);
> +		pgm = clear_pgm_int();
> +		if (pgm != PGM_INT_CODE_SPECIFICATION) {
> +			report_fail("fail on bit %d", i);
> +			fails++;
> +		}
> +	}
> +	report(!fails, "All alignments tested");
> +	report_prefix_pop();
> +	report_prefix_pop();
> +
> +	free_page(data);
> +	report_prefix_pop();
> +}
> +
> +static void test_pgms_nqap(void)


Same as above:
test_nqap_pgm_chk


> +{
> +	uint8_t gr0_zeroes_bits[] = {
> +		32, 34, 35, 40
> +	};
> +	uint64_t gr0;
> +	bool fail;
> +	int i;
> +
> +	report_prefix_push("nqap");
> +
> +	/* Registers 0 and 1 are always used, the others are even/odd pairs */
> +	report_prefix_push("spec");
> +	report_prefix_push("r1");
> +	expect_pgm_int();
> +	asm volatile (
> +		".insn	rre,0xb2ad0000,3,6\n"
> +		: : : "cc", "memory", "0", "1", "2", "3", "4", "6", "7");
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("r2");
> +	expect_pgm_int();
> +	asm volatile (
> +		".insn	rre,0xb2ad0000,2,7\n"
> +		: : : "cc", "memory", "0", "1", "2", "3", "4", "6", "7");
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("both");
> +	expect_pgm_int();
> +	asm volatile (
> +		".insn	rre,0xb2ad0000,3,7\n"
> +		: : : "cc", "memory", "0", "1", "2", "3", "4", "6", "7");
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("len==0");
> +	expect_pgm_int();
> +	asm volatile (
> +		"xgr	0,0\n"
> +		"xgr	5,5\n"
> +		".insn	rre,0xb2ad0000,2,4\n"
> +		: : : "cc", "memory", "0", "1", "2", "3", "4", "5", "6", "7");
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("gr0_zero_bits");
> +	fail = false;
> +	for (i = 0; i < ARRAY_SIZE(gr0_zeroes_bits); i++) {
> +		expect_pgm_int();
> +		gr0 = BIT_ULL(63 - gr0_zeroes_bits[i]);
> +		asm volatile (
> +			"xgr	5,5\n"
> +			"lghi	5, 128\n"
> +			"lg	0, 0(%[val])\n"
> +			".insn	rre,0xb2ad0000,2,4\n"
> +			: : [val] "a" (&gr0)
> +			: "cc", "memory", "0", "1", "2", "3", "4", "5", "6", "7");
> +		if (clear_pgm_int() != PGM_INT_CODE_SPECIFICATION) {
> +			report_fail("setting gr0 bit %d did not result in a spec exception",
> +				    gr0_zeroes_bits[i]);
> +			fail = true;
> +		}
> +	}
> +	report(!fail, "set bit gr0 pgms");
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +	report_prefix_pop();
> +}
> +
> +static void test_pgms_dqap(void)


Same as above:
test_dqap_pgm_chk


> +{
> +	uint8_t gr0_zeroes_bits[] = {
> +		33, 34, 35, 40, 41
> +	};
> +	uint64_t gr0;
> +	bool fail;
> +	int i;
> +
> +	report_prefix_push("dqap");
> +
> +	/* Registers 0 and 1 are always used, the others are even/odd pairs */
> +	report_prefix_push("spec");
> +	report_prefix_push("r1");
> +	expect_pgm_int();
> +	asm volatile (
> +		".insn	rre,0xb2ae0000,3,6\n"
> +		: : : "cc", "memory", "0", "1", "2", "3", "4", "6", "7");
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("r2");
> +	expect_pgm_int();
> +	asm volatile (
> +		".insn	rre,0xb2ae0000,2,7\n"
> +		: : : "cc", "memory", "0", "1", "2", "3", "4", "6", "7");
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("both");
> +	expect_pgm_int();
> +	asm volatile (
> +		".insn	rre,0xb2ae0000,3,7\n"
> +		: : : "cc", "memory", "0", "1", "2", "3", "4", "6", "7");
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("len==0");
> +	expect_pgm_int();
> +	asm volatile (
> +		"xgr	0,0\n"
> +		"xgr	5,5\n"
> +		".insn	rre,0xb2ae0000,2,4\n"
> +		: : : "cc", "memory", "0", "1", "2", "3", "4", "5", "6", "7");
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("gr0_zero_bits");
> +	fail = false;
> +	for (i = 0; i < ARRAY_SIZE(gr0_zeroes_bits); i++) {
> +		expect_pgm_int();
> +		gr0 = BIT_ULL(63 - gr0_zeroes_bits[i]);
> +		asm volatile (
> +			"xgr	5,5\n"
> +			"lghi	5, 128\n"
> +			"lg	0, 0(%[val])\n"
> +			".insn	rre,0xb2ae0000,2,4\n"
> +			: : [val] "a" (&gr0)
> +			: "cc", "memory", "0", "1", "2", "3", "4", "5", "6", "7");
> +		if (clear_pgm_int() != PGM_INT_CODE_SPECIFICATION) {
> +			report_info("setting gr0 bit %d did not result in a spec exception",
> +				    gr0_zeroes_bits[i]);
> +			fail = true;
> +		}
> +	}
> +	report(!fail, "set bit pgms");
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +	report_prefix_pop();
> +}
> +
> +static void test_priv(void)
> +{
> +	struct ap_config_info info = {};
> +
> +	report_prefix_push("privileged");
> +
> +	report_prefix_push("pqap");
> +	expect_pgm_int();
> +	enter_pstate();
> +	ap_pqap_qci(&info);
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +
> +	/*
> +	 * Enqueue and dequeue take too many registers so a simple
> +	 * inline assembly makes more sense than using the library
> +	 * functions.
> +	 */
> +	report_prefix_push("nqap");
> +	expect_pgm_int();
> +	enter_pstate();
> +	asm volatile (
> +		".insn	rre,0xb2ad0000,0,2\n"
> +		: : : "cc", "memory", "0", "1", "2", "3");
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("dqap");
> +	expect_pgm_int();
> +	enter_pstate();
> +	asm volatile (
> +		".insn	rre,0xb2ae0000,0,2\n"
> +		: : : "cc", "memory", "0", "1", "2", "3");
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("ap");
> +	if (!ap_check()) {
> +		report_skip("AP instructions not available");
> +		goto done;
> +	}
> +
> +	test_priv();
> +	test_pgms_pqap();
> +	test_pgms_nqap();
> +	test_pgms_dqap();
> +
> +done:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 018e4129..578375e4 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -386,3 +386,6 @@ file = sie-dat.elf
>   
>   [pv-attest]
>   file = pv-attest.elf
> +
> +[ap]
> +file = ap.elf

