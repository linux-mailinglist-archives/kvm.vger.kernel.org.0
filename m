Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751156D0BCE
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 18:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjC3Qug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 12:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbjC3Qtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 12:49:42 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6286E19D;
        Thu, 30 Mar 2023 09:48:50 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UFf4Cn007521;
        Thu, 30 Mar 2023 16:48:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=E0TY+LGhsbV3nEV2m3CDeyjahuv5tBRPV8Oe4cX/vhU=;
 b=CDsafkI33XIZ/XOytScQc9ppp1ZR58eUe5q0WclMRI4HaH5DNzztQV4Ut6XcoDqaDLoo
 C3akrgRALwjyd8kWb45oXamldSk87HKyBXo/pbtom9xD9y7NbJnnSofZFj9l4Atid6An
 J2bdnACjsnnwG7hahanuwffQ4Ort/RDn+ruW5uE2oMzh7/pBo5k8xJiKtVCJJzfRTfeS
 B07+umuVGQ4ALcCqZca5IwGqFFHm7mFljDuDXoptxpWyNd91aeAetik7kw7K8014Ot/s
 Srereb75Br3NSnDg54KUJQMDCgBinWIEt0Thr1tuu7J0h38I8MFQle/DxvhtAaJg1wES TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmq6n457e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:28 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32UGUmE0003997;
        Thu, 30 Mar 2023 16:48:28 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmq6n456w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:27 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32TLdN4S005448;
        Thu, 30 Mar 2023 16:48:26 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6p347-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 16:48:26 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32UGmMY614222002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 16:48:22 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 995FA2004B;
        Thu, 30 Mar 2023 16:48:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AD7220040;
        Thu, 30 Mar 2023 16:48:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 30 Mar 2023 16:48:22 +0000 (GMT)
Date:   Thu, 30 Mar 2023 18:44:47 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 4/5] s390x: ap: Add pqap aqic tests
Message-ID: <20230330184447.1751e2b0@p-imbrenda>
In-Reply-To: <20230330114244.35559-5-frankja@linux.ibm.com>
References: <20230330114244.35559-1-frankja@linux.ibm.com>
        <20230330114244.35559-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MMg9bJmv1UfaNr81EEkZR9LJyeZ8tJin
X-Proofpoint-ORIG-GUID: QDhRnXY9YRwl_SBmmsTmx2qAw1i3clco
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_09,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300130
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Mar 2023 11:42:43 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's check if we can enable/disable interrupts and if all errors are
> reported if we specify bad addresses for the notification indication
> byte.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/ap.c | 33 +++++++++++++++++++++++++++++
>  lib/s390x/ap.h | 11 ++++++++++
>  s390x/ap.c     | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 100 insertions(+)
> 
> diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
> index 8d7f2992..aaf5b4b9 100644
> --- a/lib/s390x/ap.c
> +++ b/lib/s390x/ap.c
> @@ -51,6 +51,39 @@ int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
>  	return cc;
>  }
>  
> +int ap_pqap_aqic(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
> +		 struct ap_qirq_ctrl aqic, unsigned long addr)
> +{
> +	struct pqap_r0 r0 = {};
> +	int cc;
> +
> +	/*
> +	 * AP-Queue Interruption Control
> +	 *
> +	 * Enables/disables interrupts for a APQN
> +	 *
> +	 * Inputs: 0,1,2
> +	 * Outputs: 1 (APQSW)
> +	 * Synchronous
> +	 */
> +	r0.ap = ap;
> +	r0.qn = qn;
> +	r0.fc = PQAP_QUEUE_INT_CONTRL;
> +	asm volatile(
> +		"	lgr	0,%[r0]\n"
> +		"	lgr	1,%[aqic]\n"
> +		"	lgr	2,%[addr]\n"
> +		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
> +		"	stg	1, %[apqsw]\n"
> +		"	ipm	%[cc]\n"
> +		"	srl	%[cc],28\n"
> +		: [apqsw] "=T" (*apqsw), [cc] "=&d" (cc)
> +		: [r0] "d" (r0), [aqic] "d" (aqic), [addr] "d" (addr)
> +		: "cc", "memory", "0", "2");
> +
> +	return cc;
> +}
> +
>  int ap_pqap_qci(struct ap_config_info *info)
>  {
>  	struct pqap_r0 r0 = { .fc = PQAP_QUERY_AP_CONF_INFO };
> diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
> index 59595eba..3f9e2eb6 100644
> --- a/lib/s390x/ap.h
> +++ b/lib/s390x/ap.h
> @@ -79,6 +79,15 @@ struct pqap_r2 {
>  } __attribute__((packed))  __attribute__((aligned(8)));
>  _Static_assert(sizeof(struct pqap_r2) == sizeof(uint64_t), "pqap_r2 size");
>  
> +struct ap_qirq_ctrl {
> +	uint64_t res0 : 16;
> +	uint64_t ir    : 1;	/* ir flag: enable (1) or disable (0) irq */
> +	uint64_t res1 : 44;
> +	uint64_t isc   : 3;	/* irq sub class */
> +} __attribute__((packed))  __attribute__((aligned(8)));
> +_Static_assert(sizeof(struct ap_qirq_ctrl) == sizeof(uint64_t),
> +	       "struct ap_qirq_ctrl size");
> +
>  #define AP_SETUP_NOINSTR	-1
>  #define AP_SETUP_NOAPQN		1
>  
> @@ -86,4 +95,6 @@ int ap_setup(uint8_t *ap, uint8_t *qn);
>  int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
>  		 struct pqap_r2 *r2);
>  int ap_pqap_qci(struct ap_config_info *info);
> +int ap_pqap_aqic(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
> +		 struct ap_qirq_ctrl aqic, unsigned long addr);
>  #endif
> diff --git a/s390x/ap.c b/s390x/ap.c
> index 20b4e76e..31dcfe29 100644
> --- a/s390x/ap.c
> +++ b/s390x/ap.c
> @@ -292,6 +292,55 @@ static void test_priv(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_pqap_aqic(void)
> +{
> +	struct ap_queue_status apqsw = {};
> +	static uint8_t not_ind_byte;
> +	struct ap_qirq_ctrl aqic = {};
> +	struct pqap_r2 r2 = {};
> +
> +	int cc;
> +
> +	report_prefix_push("pqap");
> +	report_prefix_push("aqic");
> +
> +	ap_pqap_tapq(apn, qn, &apqsw, &r2);
> +
> +	aqic.ir = 1;
> +	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, 0);
> +	report(cc == 3 && apqsw.rc == 6, "invalid addr 0");
> +
> +	aqic.ir = 1;
> +	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, -1);
> +	report(cc == 3 && apqsw.rc == 6, "invalid addr -1");
> +
> +	aqic.ir = 0;
> +	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
> +	report(cc == 3 && apqsw.rc == 7, "disable");

maybe call it "disable but never enabled"

> +
> +	aqic.ir = 1;
> +	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
> +	report(cc == 0 && apqsw.rc == 0, "enable");
> +
> +	do {
> +		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
> +	} while (cc == 0 && apqsw.irq_enabled == 0);

you do this a lot, would it be worth it abstracting it?

ap_pqap_wait_for_irq(..., false); 

(try to find a better name though)

> +
> +	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
> +	report(cc == 3 && apqsw.rc == 7, "enable while enabled");
> +
> +	aqic.ir = 0;
> +	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
> +	assert(cc == 0 && apqsw.rc == 0);
> +
> +	do {
> +		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
> +	} while (cc == 0 && apqsw.irq_enabled == 1);

ap_pqap_wait_for_irq(..., true); 

and here test disable again "disable after disable"

> +
> +	report_prefix_pop();
> +	report_prefix_pop();
> +}
> +
>  int main(void)
>  {
>  	int setup_rc = ap_setup(&apn, &qn);
> @@ -307,6 +356,13 @@ int main(void)
>  	test_pgms_nqap();
>  	test_pgms_dqap();
>  
> +	/* The next tests need queues */
> +	if (setup_rc == AP_SETUP_NOAPQN) {
> +		report_skip("No APQN available");
> +		goto done;
> +	}
> +	test_pqap_aqic();
> +
>  done:
>  	report_prefix_pop();
>  	return report_summary();

