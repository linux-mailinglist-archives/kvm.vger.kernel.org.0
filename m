Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AB66C11CC
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 13:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjCTMWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 08:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjCTMWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 08:22:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C170279A8;
        Mon, 20 Mar 2023 05:22:34 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KB0ZO1014838;
        Mon, 20 Mar 2023 12:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=q30xcZcyW9HS9T3U40sGiO/497mwSLcozHs0I2JkQhw=;
 b=tAZitl6eXJQecbJiNbMsdakakYN/ArAtKoW8IHiLOl16lD0PNe2WNv3N3cllUfbuaoIY
 QmiG90HZDzpyBywS6WG3NphffFzXYlxQOKQZ9tUYz/hp0CHLol6oCKHneyQE6P/MP+4r
 7T7re0pqJzAjLLwNgvFOADCa1nZUW7FBgE8+Y4VvAcohZvNg9GH3eYvouluEaGxtDGrG
 SnrTQotWCFeSBls0FDmyjtIi2pG7BdbvUrCnWjxytvtYsUMlVzwg5pjePBughvuyi/2H
 +bDRDA/rH/HEQyKAlDqfVtc0mlYy/Vb0+FNpti00SB0/R8uhipqpN8Kv08bkE/vSKwsp Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdqcafy50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 12:22:32 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32KAxHJm004954;
        Mon, 20 Mar 2023 12:22:32 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdqcafy48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 12:22:32 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32K47DYp015074;
        Mon, 20 Mar 2023 12:22:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pd4jfb7wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 12:22:29 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32KCMQrE16515762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 12:22:26 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39A5320040;
        Mon, 20 Mar 2023 12:22:26 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF6EF2004B;
        Mon, 20 Mar 2023 12:22:25 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 20 Mar 2023 12:22:25 +0000 (GMT)
Date:   Mon, 20 Mar 2023 13:22:24 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] s390x: spec_ex: Add test for
 misaligned load
Message-ID: <20230320132224.4b4c36d1@p-imbrenda>
In-Reply-To: <20230301132638.3336040-1-nsg@linux.ibm.com>
References: <20230301132638.3336040-1-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CrU1C4Tm20Lw7I51P09jTp5PosTuqOv8
X-Proofpoint-ORIG-GUID: FDH9akeLtTVJHOUsfeaUwtQhLno8Spr0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_08,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 impostorscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  1 Mar 2023 14:26:38 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> The operand of LOAD RELATIVE LONG must be word aligned, otherwise a
> specification exception occurs. Test that this exception occurs.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

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
> +		"	.balign	4\n"
> +		"	. = . + 2\n"
> +		"0:	.fill	4\n"
> +		"	.popsection\n"
> +
> +		"	lrl	%0,0b\n"
> +		: "=d" (r)
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

