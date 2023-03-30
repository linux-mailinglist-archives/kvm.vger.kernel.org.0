Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA936D0BCB
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 18:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjC3Qub (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 12:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbjC3Qti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 12:49:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31EB1026B;
        Thu, 30 Mar 2023 09:48:45 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UGfhv7030918;
        Thu, 30 Mar 2023 16:48:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=RHCwF8Eg+szLlw8GjFqPhavsqbhSspfnYnf5TBMRDKk=;
 b=ZbA49Yv5Lg1HUkOmHIvT4plysE9AMb3jQsrWD32cf/HHerexFv54MR5ka7b0y9+leMZh
 C42rerGJTWQd09kP6DERsMUSiR0ebYOCWEgfgoWwJpTP+Orr4P7IaPM6PTLlcd0OLTMu
 T5m0hmWq78bzeeLbgYj0eD5xP3QWHMueCA8CqpB3y71R4JJr8DgsEhxzCECsUXt8i4PI
 SQ/GNjIjZNNfzyMK+LVbR5OXfKoCQvmxqhViD1WvQi0nmxZLPriwlA5ElJct6Lp6sDkb
 MAFOxWNbhqKWkLZuTZLhietu6HWfJAyQorEHNiqwqm5g368OoVZpfer3dPnjVWEwZSQ7 hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pndwb0jxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:25 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32UGNK7B014695;
        Thu, 30 Mar 2023 16:48:24 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pndwb0jwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:24 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32TLlYre019418;
        Thu, 30 Mar 2023 16:48:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6p343-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:22 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32UGmJNx13042372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 16:48:19 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5830220043;
        Thu, 30 Mar 2023 16:48:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2052D2004E;
        Thu, 30 Mar 2023 16:48:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 30 Mar 2023 16:48:19 +0000 (GMT)
Date:   Thu, 30 Mar 2023 18:48:10 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 5/5] s390x: ap: Add reset tests
Message-ID: <20230330184810.5b08034b@p-imbrenda>
In-Reply-To: <20230330114244.35559-6-frankja@linux.ibm.com>
References: <20230330114244.35559-1-frankja@linux.ibm.com>
        <20230330114244.35559-6-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: e4OTi2iuQQSPKt_j79yhb4144DUWjZc9
X-Proofpoint-GUID: RHr9pp755V-AMHoO5O2lrzUtphsJG6sQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_09,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501 bulkscore=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303300130
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Mar 2023 11:42:44 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Test if the IRQ enablement is turned off on a reset or zeroize PQAP.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---

[...]

> diff --git a/s390x/ap.c b/s390x/ap.c
> index 31dcfe29..47b4f832 100644
> --- a/s390x/ap.c
> +++ b/s390x/ap.c
> @@ -341,6 +341,57 @@ static void test_pqap_aqic(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_pqap_resets(void)
> +{
> +	struct ap_queue_status apqsw = {};
> +	static uint8_t not_ind_byte;
> +	struct ap_qirq_ctrl aqic = {};
> +	struct pqap_r2 r2 = {};
> +
> +	int cc;
> +
> +	report_prefix_push("pqap");
> +	report_prefix_push("rapq");
> +
> +	/* Enable IRQs which the resets will disable */
> +	aqic.ir = 1;
> +	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
> +	report(cc == 0 && apqsw.rc == 0, "enable");
> +
> +	do {
> +		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
> +	} while (cc == 0 && apqsw.irq_enabled == 0);

same story here as in the previous patch, waiting for interrupts 

> +	report(apqsw.irq_enabled == 1, "IRQs enabled");
> +
> +	ap_pqap_reset(apn, qn, &apqsw);
> +	cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
> +	assert(!cc);
> +	report(apqsw.irq_enabled == 0, "IRQs have been disabled");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("zapq");
> +
> +	/* Enable IRQs which the resets will disable */
> +	aqic.ir = 1;
> +	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
> +	report(cc == 0 && apqsw.rc == 0, "enable");
> +
> +	do {
> +		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
> +	} while (cc == 0 && apqsw.irq_enabled == 0);

and here

> +	report(apqsw.irq_enabled == 1, "IRQs enabled");
> +
> +	ap_pqap_reset_zeroize(apn, qn, &apqsw);
> +	cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
> +	assert(!cc);
> +	report(apqsw.irq_enabled == 0, "IRQs have been disabled");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +}
> +
>  int main(void)
>  {
>  	int setup_rc = ap_setup(&apn, &qn);
> @@ -362,6 +413,7 @@ int main(void)
>  		goto done;
>  	}
>  	test_pqap_aqic();
> +	test_pqap_resets();
>  
>  done:
>  	report_prefix_pop();

