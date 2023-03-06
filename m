Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE78E6ABD8F
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 11:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjCFK7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 05:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjCFK7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 05:59:38 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAECC25E15;
        Mon,  6 Mar 2023 02:59:31 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3268cgux026487;
        Mon, 6 Mar 2023 10:59:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=EgGfEYFejJ9CdgqpQEerh4QT9/HN+lJAxFPWJTtiTzg=;
 b=jn5nNmXT1h+4P6rD/bQmHlyE2g0L1q41Cd+kcMNfVAXbPawhco5wS3QUgB8mIjS8AaXJ
 5Zi6mWRnB38cQxnT8tvijKxOZ/VyOoiWE5GrdFGWN6nDjAWhvSaVXZq0RW1HcU2XSH/u
 YzO3HmIceZR+pYiPqq5VUp5y2ckQx2odc+SF9S9m9LfzCufyRtizraMGH1sTfwxKKTsz
 FCd8fb9WhVCA5eJHjANmNPI5teIvjlUL0/3vGv5r1rVR7JIOA1/aRSUhN4CAxmbBzGq4
 /qH/ex2j7QYovXpbKmRTns9yhr8mYOrF54OOdo4W07QptRFKPQYZBuHZr5TnEQ93JQMs 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p507nrwky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 10:59:30 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 326As5jh003867;
        Mon, 6 Mar 2023 10:59:30 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p507nrwkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 10:59:30 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32649v77011365;
        Mon, 6 Mar 2023 10:59:28 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3p418v22nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 10:59:28 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 326AxOC427853308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Mar 2023 10:59:24 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7BC92004B;
        Mon,  6 Mar 2023 10:59:24 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F7E020040;
        Mon,  6 Mar 2023 10:59:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.179.29.172])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
        Mon,  6 Mar 2023 10:59:24 +0000 (GMT)
Date:   Mon, 6 Mar 2023 11:59:21 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] s390x: spec_ex: Add test for
 misaligned load
Message-ID: <20230306115921.520ed44c@p-imbrenda>
In-Reply-To: <20230301132638.3336040-1-nsg@linux.ibm.com>
References: <20230301132638.3336040-1-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SB_12QPx2DUUeffVIBAFmwoVyLj7rSeG
X-Proofpoint-ORIG-GUID: JlOTA0dXfqzlqatsqUDnYd2I1Y1xIKYr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_03,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 mlxscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303060091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  1 Mar 2023 14:26:38 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> The operand of LOAD RELATIVE LONG must be word aligned, otherwise a
> specification exception occurs. Test that this exception occurs.

you're only testing halfword misalignment; would it make sense to test
all possible misalignments? (it's only 3 of them after all)

> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
> 
> 
> Noticed while writing another test that TCG fails this requirement,
> so thought it best do document this in the form of a test.
> 
> 
>  s390x/spec_ex.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> index 42ecaed3..42e86070 100644
> --- a/s390x/spec_ex.c
> +++ b/s390x/spec_ex.c
> @@ -136,7 +136,7 @@ static int short_psw_bit_12_is_0(void)
>  	return 0;
>  }
>  
> -static int bad_alignment(void)
> +static int bad_alignment_lqp(void)
>  {
>  	uint32_t words[5] __attribute__((aligned(16)));
>  	uint32_t (*bad_aligned)[4] = (uint32_t (*)[4])&words[1];
> @@ -149,6 +149,22 @@ static int bad_alignment(void)
>  	return 0;
>  }
>  
> +static int bad_alignment_lrl(void)
> +{
> +	uint64_t r;
> +
> +	asm volatile ( ".pushsection .rodata\n"

why not declare this as a local array?

uint8_t stuff[8] __attribute__((aligned(8)));

> +		"	.balign	4\n"
> +		"	. = . + 2\n"
> +		"0:	.fill	4\n"
> +		"	.popsection\n"
> +
> +		"	lrl	%0,0b\n"
> +		: "=d" (r)

and here pass stuff + 1 or something like that?

less asm = more readable

> +	);
> +	return 0;
> +}
> +
>  static int not_even(void)
>  {
>  	uint64_t quad[2] __attribute__((aligned(16))) = {0};
> @@ -176,7 +192,8 @@ struct spec_ex_trigger {
>  static const struct spec_ex_trigger spec_ex_triggers[] = {
>  	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
>  	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
> -	{ "bad_alignment", &bad_alignment, true, NULL },
> +	{ "bad_alignment_lqp", &bad_alignment_lqp, true, NULL },
> +	{ "bad_alignment_lrl", &bad_alignment_lrl, true, NULL },
>  	{ "not_even", &not_even, true, NULL },
>  	{ NULL, NULL, false, NULL },
>  };
> 
> base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6

