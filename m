Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530613260CE
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 11:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhBZKDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 05:03:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230421AbhBZKDC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Feb 2021 05:03:02 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11Q9X8qW026108
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 05:02:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LuM3iSasXJRVOIyGXYeegA4P+EbcUsj+z0ijOGnVLVA=;
 b=azIVq8QvbmyyODzT4Jmwgd4yQ2dsq9CjHrt5rWMhKrcUhH+3yFaWHd2Cl1pxCmDnNNg5
 s8fgNePTmJpi5d3757kFYtdRY7wIcEr28LwUSjbpdji+SFejEMURXRL4FtgrCFyFtAYP
 Rrw5b75979AYHlft6DIDgVWFfN6V+jg021TpUcJX/pyDWNhZZQDjYDq7+Sn5iQhKpP8Z
 7Y7pSLvNiCUJizXDJsFADiNAQ/h9wIMu/o/XogSYz1AiLeTdGBu8ilcdGc5DQIv0zYN9
 s9TbAz5hsTJ6ch1BAHpyZKrAhy35uTpWnN3o/Ve9U3s0LbBz7XlDNmKAePaCiGdgmgOk /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xphumst1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 05:02:21 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11Q9XZ2e026879
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 05:02:20 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xphumsrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 05:02:20 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11Q9swYW006933;
        Fri, 26 Feb 2021 10:02:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 36tt28aqan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 10:02:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11QA2F6T61735378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 10:02:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 495FC11C04A;
        Fri, 26 Feb 2021 10:02:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E723711C058;
        Fri, 26 Feb 2021 10:02:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.91.176])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Feb 2021 10:02:14 +0000 (GMT)
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
 <1613669204-6464-6-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 5/5] s390x: css: testing measurement
 block format 1
Message-ID: <3041cee9-a5b8-1745-5455-f7728ae4d232@linux.ibm.com>
Date:   Fri, 26 Feb 2021 11:02:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1613669204-6464-6-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-26_02:2021-02-24,2021-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 priorityscore=1501 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/21 6:26 PM, Pierre Morel wrote:
> Measurement block format 1 is made available by the extended
> measurement block facility and is indicated in the SCHIB by
> the bit in the PMCW.
> 
> The MBO is specified in the SCHIB of each channel and the MBO
> defined by the SCHM instruction is ignored.
> 
> The test of the MB format 1 is just skipped if the feature is
> not available.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     | 16 ++++++++++++++
>  lib/s390x/css_lib.c | 25 ++++++++++++++++++++-
>  s390x/css.c         | 53 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 93 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index dabe54a..1e5e4b5 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -387,4 +387,20 @@ struct measurement_block_format0 {
>  	uint32_t initial_cmd_resp_time;
>  };
>  
> +struct measurement_block_format1 {
> +	uint32_t ssch_rsch_count;
> +	uint32_t sample_count;
> +	uint32_t device_connect_time;
> +	uint32_t function_pending_time;
> +	uint32_t device_disconnect_time;
> +	uint32_t cu_queuing_time;
> +	uint32_t device_active_only_time;
> +	uint32_t device_busy_time;
> +	uint32_t initial_cmd_resp_time;
> +	uint32_t irq_delay_time;
> +	uint32_t irq_prio_delay_time;
> +};
> +
> +void msch_with_wrong_fmt1_mbo(unsigned int schid, uint64_t mb);
> +
>  #endif
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 4c8a6ae..1f09f93 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -298,7 +298,7 @@ static bool schib_update_mb(int schid, uint64_t mb, uint16_t mbi,
>  			pmcw->flags2 &= ~PMCW_MBF1;
>  
>  		pmcw->mbi = mbi;
> -		schib.mbo = mb;
> +		schib.mbo = mb & ~0x3f;
>  	} else {
>  		pmcw->flags &= ~(PMCW_MBUE | PMCW_DCTME);
>  	}
> @@ -527,3 +527,26 @@ void enable_io_isc(uint8_t isc)
>  	value = (uint64_t)isc << 24;
>  	lctlg(6, value);
>  }
> +
> +void msch_with_wrong_fmt1_mbo(unsigned int schid, uint64_t mb)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int cc;
> +
> +	/* Read the SCHIB for this subchannel */
> +	cc = stsch(schid, &schib);
> +	if (cc) {> +		report(0, "stsch: sch %08x failed with cc=%d", schid, cc);
> +		return;
> +	}
> +
> +	/* Update the SCHIB to enable the measurement block */
> +	pmcw->flags |= PMCW_MBUE;
> +	pmcw->flags2 |= PMCW_MBF1;
> +	schib.mbo = mb;
> +
> +	/* Tell the CSS we want to modify the subchannel */
> +	expect_pgm_int();
> +	cc = msch(schid, &schib);
> +	check_pgm_int_code(PGM_INT_CODE_OPERAND);

Why would you expect a PGM in a library function are PGMs normal for IO
instructions? oO

Is this a test function which should be part of your test file in
s390x/*.c or is it part of the IO library which should:

 - Abort if an initialization failed and we can assume that future tests
are now useless
 - Return an error so the test can report an error
 - Return success

> +}
> diff --git a/s390x/css.c b/s390x/css.c
> index b65aa89..576df48 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -257,6 +257,58 @@ end:
>  	report_prefix_pop();
>  }
>  
> +/*
> + * test_schm_fmt1:
> + * With measurement block format 1 the mesurement block is
> + * dedicated to a subchannel.
> + */
> +static void test_schm_fmt1(void)
> +{
> +	struct measurement_block_format1 *mb1;
> +
> +	report_prefix_push("Format 1");
> +
> +	if (!test_device_sid) {
> +		report_skip("No device");
> +		goto end;
> +	}
> +
> +	if (!css_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK)) {
> +		report_skip("Extended measurement block not available");
> +		goto end;
> +	}
> +
> +	/* Allocate zeroed Measurement block */
> +	mb1 = alloc_io_mem(sizeof(struct measurement_block_format1), 0);
> +	if (!mb1) {
> +		report_abort("measurement_block_format1 allocation failed");
> +		goto end;
> +	}
> +
> +	schm(NULL, 0); /* Stop any previous measurement */
> +	schm(0, SCHM_MBU);
> +
> +	/* Expect error for non aligned MB */
> +	report_prefix_push("Unaligned MB origin");
> +	msch_with_wrong_fmt1_mbo(test_device_sid, (uint64_t)mb1 + 1);
> +	report_prefix_pop();
> +
> +	/* Clear the measurement block for the next test */
> +	memset(mb1, 0, sizeof(*mb1));
> +
> +	/* Expect success */
> +	report_prefix_push("Valid MB address and index");
> +	report(start_measure((u64)mb1, 0, true) &&
> +	       mb1->ssch_rsch_count == SCHM_UPDATE_CNT,
> +	       "SSCH measured %d", mb1->ssch_rsch_count);
> +	report_prefix_pop();
> +
> +	schm(NULL, 0); /* Stop the measurement */
> +	free_io_mem(mb1, sizeof(struct measurement_block_format1));
> +end:
> +	report_prefix_pop();
> +}
> +
>  static struct {
>  	const char *name;
>  	void (*func)(void);
> @@ -268,6 +320,7 @@ static struct {
>  	{ "sense (ssch/tsch)", test_sense },
>  	{ "measurement block (schm)", test_schm },
>  	{ "measurement block format0", test_schm_fmt0 },
> +	{ "measurement block format1", test_schm_fmt1 },

Output will then be:
"measurement block format1: Format 1: Report message"

Wouldn't it make more sense to put the format 0 and 1 tests into
test_schm() so we'd have:
"measurement block (schm): Format 0: Report message" ?

>  	{ NULL, NULL }
>  };
>  
> 

