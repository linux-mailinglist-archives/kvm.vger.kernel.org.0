Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651A669A9B6
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 12:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjBQLG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 06:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjBQLGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 06:06:06 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2301B642E6;
        Fri, 17 Feb 2023 03:05:42 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31H91FX7015429;
        Fri, 17 Feb 2023 11:05:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sJAEhRnP/TQyp4v3xC/EVoSyF0IX9maDjAZarRdthCE=;
 b=tjJvyp9NfKgAtqZTwGD1mVDepp0A1X6fUMFzquJuCURtf0ME41gRkXH9IKXc5XkhtRl7
 HBmIDdx07M7+R9nfcGTSmDIeepWiK/cEWKSnTE7S36IfGzxXR3zgG+xdng3zsynD4l/W
 1kISUL3XS0sfa7SonktqrMIWmcMsESVVGCad8LQXQZN5hox5bNIbIaRP3j10M0vKjLcY
 AwZ6bSSOXOD+pr93x+ZnMUr6sxobUUjIz7TUWgd78TPXMiX6lTsH+NpDhfvdgIeilRdA
 nGOJtSTYHv1o63nhEsq8apZCaekLlPlyT1LeYslnfKXFGM8xkKvrQL5c9D7kEUGYpOk+ LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nt15wsn6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 11:05:29 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31H94tTb023546;
        Fri, 17 Feb 2023 11:05:29 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nt15wsn6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 11:05:29 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31GJIxbk017665;
        Fri, 17 Feb 2023 11:05:27 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6qwc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 11:05:27 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31HB5Oa636176156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Feb 2023 11:05:24 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C6892004D;
        Fri, 17 Feb 2023 11:05:24 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE5EE20040;
        Fri, 17 Feb 2023 11:05:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.12.31])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri, 17 Feb 2023 11:05:23 +0000 (GMT)
Date:   Fri, 17 Feb 2023 11:01:31 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x/spec_ex: Add test of
 EXECUTE with odd target address
Message-ID: <20230217110131.4bf670e8@p-imbrenda>
In-Reply-To: <20230215171852.1935156-3-nsg@linux.ibm.com>
References: <20230215171852.1935156-1-nsg@linux.ibm.com>
        <20230215171852.1935156-3-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FViK7t7c4uPJQOar4hEG9UXjfj_VgEms
X-Proofpoint-GUID: UxzFtg3B2WUD-y7GN4bVa9-cC_ilI7sR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_06,2023-02-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302170101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Feb 2023 18:18:52 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> The EXECUTE instruction executes the instruction at the given target
> address. This address must be halfword aligned, otherwise a
> specification exception occurs.
> Add a test for this.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/spec_ex.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> index b6764677..0cd3174f 100644
> --- a/s390x/spec_ex.c
> +++ b/s390x/spec_ex.c
> @@ -200,6 +200,30 @@ static int short_psw_bit_12_is_0(void)
>  	return 0;
>  }
>  
> +static int odd_ex_target(void)
> +{
> +	uint64_t target_addr_pre;
> +	int to = 0, from = 0x0dd;
> +
> +	asm volatile ( ".pushsection .rodata\n"
> +		"odd_ex_target_pre_insn:\n"
> +		"	.balign 2\n"
> +		"	. = . + 1\n"
> +		"	lr	%[to],%[from]\n"
> +		"	.popsection\n"
> +
> +		"	larl	%[target_addr_pre],odd_ex_target_pre_insn\n"
> +		"	ex	0,1(%[target_addr_pre])\n"
> +		: [target_addr_pre] "=&a" (target_addr_pre),
> +		  [to] "+d" (to)
> +		: [from] "d" (from)
> +	);
> +
> +	assert((target_addr_pre + 1) & 1);
> +	report(to != from, "did not perform ex with odd target");
> +	return 0;
> +}
> +
>  static int bad_alignment(void)
>  {
>  	uint32_t words[5] __attribute__((aligned(16)));
> @@ -241,6 +265,7 @@ static const struct spec_ex_trigger spec_ex_triggers[] = {
>  	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
>  	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
>  	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
> +	{ "odd_ex_target", &odd_ex_target, true, NULL },
>  	{ "bad_alignment", &bad_alignment, true, NULL },
>  	{ "not_even", &not_even, true, NULL },
>  	{ NULL, NULL, false, NULL },

