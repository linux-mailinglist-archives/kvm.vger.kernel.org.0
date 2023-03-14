Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF226B98EC
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 16:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjCNPZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 11:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjCNPZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 11:25:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80234A908D;
        Tue, 14 Mar 2023 08:25:41 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32EFERL0025957;
        Tue, 14 Mar 2023 15:25:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Wm26YwWDvxZ2cjPhOKwwAp4ZjZtGKPU4Nj8UAhvlyj8=;
 b=hNvxBVZHC9I0XSOmqrzKmF3rSTVb2wVIokYhMeAaMWRP99ohxieY24YnENOZRLOdGDX8
 BAMFmXYyh9SEhJ5xsb+r5BXA+CqlqwMuo8vLwc2H2GUIxAKPvgdVgvFhI/WSas+hoqQd
 Aq1g/8/T+x6CCaUdpMe3+CuTEzOTcfoXFNSpgnu96kPH+5BrtuJBI0EW1YmNw38K1ZiJ
 eab3tZxUEdllKwvZCgHJsuBvpt3TFcv/c5yfNzB85pcUBxjCQrh8SU/KYQS3vJaITLUj
 lW34Xa1vrIIDLZKsYaP1zNgZFTJzLrFhhVUtbumeuULu0vEsCp1A2KgP+Y+E5ZZF2ArI 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3paph2ajwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 15:25:40 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32EFEU8M026328;
        Tue, 14 Mar 2023 15:25:40 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3paph2ajv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 15:25:40 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32E6feD3028628;
        Tue, 14 Mar 2023 15:25:37 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3p8h96n0se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 15:25:37 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32EFPYIu43516318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 15:25:34 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 023B720043;
        Tue, 14 Mar 2023 15:25:34 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC2B720040;
        Tue, 14 Mar 2023 15:25:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 14 Mar 2023 15:25:33 +0000 (GMT)
Date:   Tue, 14 Mar 2023 16:21:55 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 2/3] s390x/spec_ex: Add test
 introducing odd address into PSW
Message-ID: <20230314162155.45e8c6f1@p-imbrenda>
In-Reply-To: <20230221174822.1378667-3-nsg@linux.ibm.com>
References: <20230221174822.1378667-1-nsg@linux.ibm.com>
        <20230221174822.1378667-3-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: p68xKc4n7a_sKDPCZXJ2TvZRu8O_Wzi9
X-Proofpoint-GUID: 2KUtO3Dgpjl30KXyMOQm3HfRk0haZdBD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_08,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Feb 2023 18:48:21 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> Instructions on s390 must be halfword aligned.
> Introducing an odd instruction address into the PSW leads to a
> specification exception when attempting to execute the instruction at
> the odd address.
> Add a test for this.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>  s390x/spec_ex.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> index 2adc5996..a26c56aa 100644
> --- a/s390x/spec_ex.c
> +++ b/s390x/spec_ex.c
> @@ -88,12 +88,23 @@ static void expect_invalid_psw(struct psw psw)
>  	invalid_psw_expected = true;
>  }
>  
> +static void clear_invalid_psw(void)
> +{
> +	expected_psw = PSW(0, 0);
> +	invalid_psw_expected = false;
> +}
> +
>  static int check_invalid_psw(void)
>  {
>  	/* Since the fixup sets this to false we check for false here. */
>  	if (!invalid_psw_expected) {
> +		/*
> +		 * Early exception recognition: pgm_int_id == 0.
> +		 * Late exception recognition: psw address has been
> +		 *	incremented by pgm_int_id (unpredictable value)
> +		 */
>  		if (expected_psw.mask == invalid_psw.mask &&
> -		    expected_psw.addr == invalid_psw.addr)
> +		    expected_psw.addr == invalid_psw.addr - lowcore.pgm_int_id)
>  			return 0;
>  		report_fail("Wrong invalid PSW");
>  	} else {
> @@ -112,6 +123,42 @@ static int psw_bit_12_is_1(void)
>  	return check_invalid_psw();
>  }
>  
> +extern char misaligned_code[];
> +asm (  ".balign	2\n"

which section will this end up in?

> +"	. = . + 1\n"
> +"misaligned_code:\n"
> +"	larl	%r0,0\n"
> +"	bcr	0xf,%r1\n"

you should just use
        br %r1
it's shorter and easier to understand

> +);
> +
> +static int psw_odd_address(void)
> +{
> +	struct psw odd = PSW_WITH_CUR_MASK((uint64_t)&misaligned_code);
> +	uint64_t executed_addr;
> +
> +	expect_invalid_psw(odd);
> +	fixup_psw.mask = extract_psw_mask();
> +	asm volatile ( "xr	%%r0,%%r0\n"
> +		"	larl	%%r1,0f\n"
> +		"	stg	%%r1,%[fixup_addr]\n"
> +		"	lpswe	%[odd_psw]\n"
> +		"0:	lr	%[executed_addr],%%r0\n"
> +	: [fixup_addr] "=&T" (fixup_psw.addr),
> +	  [executed_addr] "=d" (executed_addr)
> +	: [odd_psw] "Q" (odd)
> +	: "cc", "%r0", "%r1"
> +	);
> +
> +	if (!executed_addr) {
> +		return check_invalid_psw();
> +	} else {
> +		assert(executed_addr == odd.addr);
> +		clear_invalid_psw();
> +		report_fail("did not execute unaligned instructions");
> +		return 1;
> +	}
> +}
> +
>  /* A short PSW needs to have bit 12 set to be valid. */
>  static int short_psw_bit_12_is_0(void)
>  {
> @@ -170,6 +217,7 @@ struct spec_ex_trigger {
>  static const struct spec_ex_trigger spec_ex_triggers[] = {
>  	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
>  	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
> +	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
>  	{ "bad_alignment", &bad_alignment, true, NULL },
>  	{ "not_even", &not_even, true, NULL },
>  	{ NULL, NULL, false, NULL },

