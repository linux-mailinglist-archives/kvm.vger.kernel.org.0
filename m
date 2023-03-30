Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB156D0BC6
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 18:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjC3QuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 12:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjC3Qtf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 12:49:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3100810252;
        Thu, 30 Mar 2023 09:48:44 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UFX7Rn031034;
        Thu, 30 Mar 2023 16:48:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=n6eMj0oUSAYB1Ch+Z1D+saNONRhREKlYhBDESX2FzZs=;
 b=YkSM+1wY9Bhkfhxat1RMi9Eqi3Qmaal76hBs1kPUqtyXHH3Q2ldc0bOiqEcaevQvh98Q
 CUHXBsdDdT7BISUPxYnrStupT+ZcCNC/DZkKNfFrVrgKmoA/mr1vH/6ELGFwgbJQV3Of
 pBzBwfj2/JtsQmXgCZmgza4nSQ7cDFprXK6BU4vC0Xm0n51h8BjxV4Mu56TPx5W3zjoY
 NkL1zsdazs1Jx6GrmQW/myOOXKxP0X7koFsc6d/mmJ9E2plIQTz+XIS5RsCz5ROriw0N
 T9aPBRzVvdWgUmmr1InrMWtMAHHNVP9LXu3O7kcXvBfQLrvWqnqCzukJMduOe4veyTzp Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmph9pjac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:24 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32UGaeuL037319;
        Thu, 30 Mar 2023 16:48:23 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmph9pj9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:23 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32UBLObn025710;
        Thu, 30 Mar 2023 16:48:21 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3phrk6myd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:21 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32UGmHlo11797058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 16:48:17 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC63B20043;
        Thu, 30 Mar 2023 16:48:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D29C20040;
        Thu, 30 Mar 2023 16:48:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 30 Mar 2023 16:48:17 +0000 (GMT)
Date:   Thu, 30 Mar 2023 18:40:42 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 3/5] lib: s390x: ap: Add ap_setup
Message-ID: <20230330184042.11ea308c@p-imbrenda>
In-Reply-To: <20230330114244.35559-4-frankja@linux.ibm.com>
References: <20230330114244.35559-1-frankja@linux.ibm.com>
        <20230330114244.35559-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SnYHqRqSL3JjbWxpeOUlS6QZP4xg9Wc-
X-Proofpoint-ORIG-GUID: VFSBFDcKwsjS4wmrOhRoJwDxe720DG8e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_09,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300130
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Mar 2023 11:42:42 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> For the next tests we need a valid queue which means we need to grab
> the qci info and search the first set bit in the ap and aq masks.
> 
> Let's move from the ap_check function to a proper setup function that
> also returns the first usable APQN. Later we can extend the setup to
> build a list of all available APQNs but right now one APQN is plenty.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/ap.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  lib/s390x/ap.h |  5 ++++-
>  s390x/ap.c     |  7 ++++++-
>  3 files changed, 63 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
> index 374fa210..8d7f2992 100644
> --- a/lib/s390x/ap.c
> +++ b/lib/s390x/ap.c
> @@ -13,9 +13,12 @@
>  
>  #include <libcflat.h>
>  #include <interrupt.h>
> +#include <bitops.h>
>  #include <ap.h>
>  #include <asm/time.h>
>  
> +static struct ap_config_info qci;
> +
>  int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
>  		 struct pqap_r2 *r2)
>  {
> @@ -77,7 +80,44 @@ int ap_pqap_qci(struct ap_config_info *info)
>  	return cc;
>  }
>  
> -bool ap_check(void)
> +static int ap_get_apqn(uint8_t *ap, uint8_t *qn)
> +{
> +	unsigned long *ptr;
> +	uint8_t bit;
> +	int i;
> +
> +	ap_pqap_qci(&qci);
> +	*ap = 0;
> +	*qn = 0;
> +
> +	ptr = (unsigned long *)qci.apm;

here it would be nice if qci.apm were an array of longs (as I wrote in
the first patch)

> +	for (i = 0; i < 4; i++) {
> +		bit = fls(*ptr);

fls is implemented using __builtin_clzl, which has undefined behaviour
if the input is all 0

one idea would be to abstract this and write a function that returns
the first bit set in a bit array of arbitrary size

otherwise something like:

for (i = 0; i < 4 && !*ptr; i++);
if (i >= 4)
	return -1;
*ap = 64 * i + 63 - fls(*ptr);

> +		if (bit) {
> +			*ap = i * 64 + 64 - bit;
> +			break;
> +		}
> +	}
> +	ptr = (unsigned long *)qci.aqm;

same here

> +	for (i = 0; i < 4; i++) {
> +		bit = fls(*ptr);
> +		if (bit) {
> +			*qn = i * 64 + 64 - bit;
> +			break;
> +		}
> +	}
> +
> +	if (!*ap || !*qn)
> +		return -1;
> +
> +	/* fls returns 1 + bit number, so we need to remove 1 here */

not really, you did 64 - fls() instead of 63 - fls() (but see my
comment above)

> +	*ap -= 1;
> +	*qn -= 1;
> +
> +	return 0;
> +}
> +
> +static bool ap_check(void)
>  {
>  	struct ap_queue_status r1 = {};
>  	struct pqap_r2 r2 = {};
> @@ -91,3 +131,15 @@ bool ap_check(void)
>  
>  	return true;
>  }
> +
> +int ap_setup(uint8_t *ap, uint8_t *qn)
> +{
> +	if (!ap_check())
> +		return AP_SETUP_NOINSTR;
> +
> +	/* Instructions available but no APQNs */
> +	if (ap_get_apqn(ap, qn))
> +		return AP_SETUP_NOAPQN;
> +
> +	return 0;
> +}
> diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
> index 79fe6eb0..59595eba 100644
> --- a/lib/s390x/ap.h
> +++ b/lib/s390x/ap.h
> @@ -79,7 +79,10 @@ struct pqap_r2 {
>  } __attribute__((packed))  __attribute__((aligned(8)));
>  _Static_assert(sizeof(struct pqap_r2) == sizeof(uint64_t), "pqap_r2 size");
>  
> -bool ap_check(void);
> +#define AP_SETUP_NOINSTR	-1
> +#define AP_SETUP_NOAPQN		1

this is rather ugly, maybe make it an enum?

	AP_SETUP_OK = 0,
	AP_SETUP_NOAPQN,
	AP_SETUP_NOINSTR

> +
> +int ap_setup(uint8_t *ap, uint8_t *qn);
>  int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
>  		 struct pqap_r2 *r2);
>  int ap_pqap_qci(struct ap_config_info *info);
> diff --git a/s390x/ap.c b/s390x/ap.c
> index 82ddb6d2..20b4e76e 100644
> --- a/s390x/ap.c
> +++ b/s390x/ap.c
> @@ -16,6 +16,9 @@
>  #include <asm/time.h>
>  #include <ap.h>
>  
> +static uint8_t apn;
> +static uint8_t qn;
> +
>  /* For PQAP PGM checks where we need full control over the input */
>  static void pqap(unsigned long grs[3])
>  {
> @@ -291,8 +294,10 @@ static void test_priv(void)
>  
>  int main(void)
>  {
> +	int setup_rc = ap_setup(&apn, &qn);
> +
>  	report_prefix_push("ap");
> -	if (!ap_check()) {
> +	if (setup_rc == AP_SETUP_NOINSTR) {
>  		report_skip("AP instructions not available");
>  		goto done;
>  	}

