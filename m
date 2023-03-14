Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990116B98EA
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 16:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjCNPZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 11:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjCNPZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 11:25:41 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7BAA8C70;
        Tue, 14 Mar 2023 08:25:39 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32EFFwGq002628;
        Tue, 14 Mar 2023 15:25:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4oBjoSbYqa0ntnou0ubU5Y4LljcSpfbwFcfsJaSk+2U=;
 b=JCAI715jm8PabtazTJDlUZiMsv7NSKkm3tnoSRyKM/vC3q90aKP9nYLkSVhliCc72Tjp
 SZgqtPI1LrYLfG5/P1u/XSqGHoIN4P6VzDchfe3+KIUAp0Ym6xuwQpI83x/yd8LjvyLN
 p1ArwivSXV91poBRQHWTlNV1O7/qpWDy0ESZf7pPgl/RHzY82nMsmrDAAV10NOEkPyxy
 ETDAimPCgO2//tdIVKoO0Yv4Z0M/Im8V4lKF3qhNkTJyPtz4RD9vEUuzJYVED5fUIbxy
 fgks+jNDaF6C56AgP39TdzfPkZauKi4AJGvelCBAo2ulOK+Jzezg3vz08RdvdKIvjb5u Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pampuwt5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 15:25:38 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32EFG7cN003824;
        Tue, 14 Mar 2023 15:25:37 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pampuwt4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 15:25:37 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32E8ZuYc001600;
        Tue, 14 Mar 2023 15:25:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3p8h96n03u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 15:25:35 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32EFPWG645023598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 15:25:32 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 410532004D;
        Tue, 14 Mar 2023 15:25:32 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0949820040;
        Tue, 14 Mar 2023 15:25:32 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 14 Mar 2023 15:25:31 +0000 (GMT)
Date:   Tue, 14 Mar 2023 16:25:26 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x/spec_ex: Add test of
 EXECUTE with odd target address
Message-ID: <20230314162526.519364c5@p-imbrenda>
In-Reply-To: <20230221174822.1378667-4-nsg@linux.ibm.com>
References: <20230221174822.1378667-1-nsg@linux.ibm.com>
        <20230221174822.1378667-4-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9fGDDANFMBRhaWPcGoh6y22LbQDh_6FC
X-Proofpoint-GUID: F2-DBhITQRKJmHrf7MmeIh-T9imHShsu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_08,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 mlxscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Feb 2023 18:48:22 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> The EXECUTE instruction executes the instruction at the given target
> address. This address must be halfword aligned, otherwise a
> specification exception occurs.
> Add a test for this.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>  s390x/spec_ex.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> index a26c56aa..dd097f9b 100644
> --- a/s390x/spec_ex.c
> +++ b/s390x/spec_ex.c
> @@ -177,6 +177,30 @@ static int short_psw_bit_12_is_0(void)
>  	return 0;
>  }
>  
> +static int odd_ex_target(void)
> +{
> +	uint64_t pre_target_addr;
> +	int to = 0, from = 0x0dd;
> +
> +	asm volatile ( ".pushsection .rodata\n"

and this should go in a .text.something subsection, as we discussed
offline

> +		"pre_odd_ex_target:\n"

shouldn't the label be after the align?

> +		"	.balign	2\n"

(i.e. here)

> +		"	. = . + 1\n"
> +		"	lr	%[to],%[from]\n"
> +		"	.popsection\n"
> +
> +		"	larl	%[pre_target_addr],pre_odd_ex_target\n"
> +		"	ex	0,1(%[pre_target_addr])\n"
> +		: [pre_target_addr] "=&a" (pre_target_addr),
> +		  [to] "+d" (to)
> +		: [from] "d" (from)
> +	);
> +
> +	assert((pre_target_addr + 1) & 1);
> +	report(to != from, "did not perform ex with odd target");
> +	return 0;
> +}
> +
>  static int bad_alignment(void)
>  {
>  	uint32_t words[5] __attribute__((aligned(16)));
> @@ -218,6 +242,7 @@ static const struct spec_ex_trigger spec_ex_triggers[] = {
>  	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
>  	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
>  	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
> +	{ "odd_ex_target", &odd_ex_target, true, NULL },
>  	{ "bad_alignment", &bad_alignment, true, NULL },
>  	{ "not_even", &not_even, true, NULL },
>  	{ NULL, NULL, false, NULL },

