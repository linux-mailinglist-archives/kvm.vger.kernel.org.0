Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E31588018
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237986AbiHBQQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238464AbiHBQQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:16:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A47BCF
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:14:30 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272GAA9j019938
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 16:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=L0nzOmC4TyI2nWduTOW+zc/VjdvNlzckN9KskMFr5Ec=;
 b=AvQJ+4iqNJJSJKqRMmm9qQLblAMcyoelGE5/ecjW5pjn7/bCvG1fgiOfk8XAJJRXd/tP
 /RM4EaVHns3fcyhOTOp7rQkEkzM27K1nFC0uBMyosOm/wSP9gJ+R3Fag3iSG+p5rme33
 pDau9ygNsYxyU0icc5WQO0pR5pR2owGegVZEY8qVZYEOYOvHL+al6ss7sM7tWog7ROAS
 HjEG34oBWM/mpDfehaa/jzh/2jvGDghmcMPcvtQDJtOZq5GMZdGrfR7OkFdtgxlzJhOi
 aVlao4q8TzLgcQfvDk5YMkC6SOsc+DWrGOg/Xz6/MuSuS3PVVRuq/X4S6YX8/pAQSOXl yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hq6ufgvbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 16:14:29 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 272GBnvQ026059
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 16:14:28 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hq6ufgvag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 16:14:28 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 272G8qca015970;
        Tue, 2 Aug 2022 16:14:27 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3hmv98kx6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 16:14:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 272GENZv22937960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Aug 2022 16:14:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E97BA4054;
        Tue,  2 Aug 2022 16:14:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26578A405B;
        Tue,  2 Aug 2022 16:14:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.9.152])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Aug 2022 16:14:23 +0000 (GMT)
Date:   Tue, 2 Aug 2022 18:14:20 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1] s390x: verify EQBS/SQBS is
 unavailable
Message-ID: <20220802181420.7444039f@p-imbrenda>
In-Reply-To: <20220802145102.128841-1-nrb@linux.ibm.com>
References: <20220802145102.128841-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: doHRbRO4TDpXyXN31q63J336Q1fbPDJh
X-Proofpoint-ORIG-GUID: Z060UW5cYW4Pod84m37I20s813_LINfg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_11,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 phishscore=0 suspectscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2208020075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  2 Aug 2022 16:51:02 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> QEMU doesn't provide EQBS/SQBS instructions, so we should check they
> result in an exception.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/intercept.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/s390x/intercept.c b/s390x/intercept.c
> index 9e826b6c79ad..73b06b5fc6e8 100644
> --- a/s390x/intercept.c
> +++ b/s390x/intercept.c
> @@ -197,6 +197,55 @@ static void test_diag318(void)
>  
>  }
>  
> +static inline int sqbs(u64 token)
> +{
> +	unsigned long _token = token;
> +	int cc;
> +
> +	asm volatile(
> +		"	lgr 1,%[token]\n"
> +		"	.insn   rsy,0xeb000000008a,0,0,0(0)\n"
> +		"	ipm %[cc]\n"
> +		"	srl %[cc],28\n"
> +		: [cc] "=&d" (cc)

do you really need all those extra things?

can't you just reduce this whole function to:

asm volatile("	.insn   rsy,0xeb000000008a,0,0,0(0)\n");

in the end we don't care what happens, we only want it to fail with an
operation exception

(ok maybe you need to add some clobbers to make sure things work as
they should in case the instruction is actually executed)

> +		: [token] "d" (_token)
> +		: "memory", "cc", "1");
> +
> +	return cc;
> +}
> +
> +static inline int eqbs(u64 token)
> +{
> +	unsigned long _token = token;
> +	int cc;
> +
> +	asm volatile(
> +		"	lgr 1,%[token]\n"
> +		"	.insn   rrf,0xb99c0000,0,0,0,0\n"

same here

> +		"	ipm %[cc]\n"
> +		"	srl %[cc],28\n"
> +		: [cc] "=&d" (cc)
> +		: [token] "d" (_token)
> +		: "memory", "cc", "1");
> +
> +	return cc;
> +}
> +
> +static void test_qbs(void)
> +{
> +	report_prefix_push("sqbs");
> +	expect_pgm_int();
> +	sqbs(0xffffffdeadbeefULL);
> +	check_pgm_int_code(PGM_INT_CODE_OPERATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("eqbs");
> +	expect_pgm_int();
> +	eqbs(0xffffffdeadbeefULL);
> +	check_pgm_int_code(PGM_INT_CODE_OPERATION);
> +	report_prefix_pop();
> +}

we expect those to fail only in qemu, right?
maybe this should be fenced and skip the tests when running in other
environments

> +
>  struct {
>  	const char *name;
>  	void (*func)(void);
> @@ -208,6 +257,7 @@ struct {
>  	{ "stidp", test_stidp, false },
>  	{ "testblock", test_testblock, false },
>  	{ "diag318", test_diag318, false },
> +	{ "qbs", test_qbs, false },
>  	{ NULL, NULL, false }
>  };
>  

