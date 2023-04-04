Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622986D5F46
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbjDDLks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbjDDLkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:40:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0562D48;
        Tue,  4 Apr 2023 04:40:45 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3349Tcga006375;
        Tue, 4 Apr 2023 11:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bsF8oxagEmMawsK+Yu1bn9I5dxnPLzpUmjKZfndzlE4=;
 b=LPIucXVkgxbEcylsrPZnsLfM4NHBgOx4WlvGXEtm1ev/2DU+/9NeIqJ5X8NRJr9ZK++n
 aIHX7PHOTPO2jrc6xszXRlRNLVfGLdHUF0Sj7OgDIo6rPVwxr+uHfBhbyW0UGCTbWcOm
 MLtxO+xrIqe59uqWl3UpjV/kd0d1EgYcKrJBNjX4bvD4rH6jbL2ye3k65TGplVsXJlR/
 s7QsSbQu2vzMKOLX+4GY7yhLFUFpLzwMnTBhGQoDuTQGtj0l/EMMTrlD67kKgpXBp/N1
 SKEV4stE8gnAY7vgR7rd7EWp4qC9vZ0iSDJlZAH0ecNLhvRak+BMcXeABUQh/vURk38N nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhabtyw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:40:44 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334Bd2bs000717;
        Tue, 4 Apr 2023 11:40:43 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhabtyvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:40:43 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3341PM6J004923;
        Tue, 4 Apr 2023 11:40:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ppc87ag7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:40:41 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334BecKJ48824864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:40:38 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59BC320043;
        Tue,  4 Apr 2023 11:40:38 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0408220040;
        Tue,  4 Apr 2023 11:40:38 +0000 (GMT)
Received: from [9.171.0.184] (unknown [9.171.0.184])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 11:40:37 +0000 (GMT)
Message-ID: <65b71334-3f8f-d750-d5be-4d4860af8398@linux.ibm.com>
Date:   Tue, 4 Apr 2023 13:40:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
References: <20230330114244.35559-1-frankja@linux.ibm.com>
 <20230330114244.35559-6-frankja@linux.ibm.com>
 <25d92c71-b495-9c0a-790d-d310710060d9@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 5/5] s390x: ap: Add reset tests
In-Reply-To: <25d92c71-b495-9c0a-790d-d310710060d9@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: muGzLkEVsEZfaZqUyD96HjyiPZ10wOAV
X-Proofpoint-GUID: EBJltTdUJwsSf341HUgytWoQG7SiyI1v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304040107
X-Spam-Status: No, score=-2.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/3/23 16:57, Pierre Morel wrote:
> 
> On 3/30/23 13:42, Janosch Frank wrote:
>> Test if the IRQ enablement is turned off on a reset or zeroize PQAP.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    lib/s390x/ap.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>    lib/s390x/ap.h |  4 +++
>>    s390x/ap.c     | 52 ++++++++++++++++++++++++++++++++++++++
>>    3 files changed, 124 insertions(+)
>>
>> diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
>> index aaf5b4b9..d969b2a5 100644
>> --- a/lib/s390x/ap.c
>> +++ b/lib/s390x/ap.c
>> @@ -113,6 +113,74 @@ int ap_pqap_qci(struct ap_config_info *info)
>>    	return cc;
>>    }
>>    
>> +static int pqap_reset(uint8_t ap, uint8_t qn, struct ap_queue_status *r1,
>> +		      bool zeroize)
> 
> 
> NIT. Personal opinion, I find using this bool a little obfuscating and I
> would have prefer 2 different functions.
> 
> I see you added a ap_pqap_reset() and ap_pqap_zeroize() next in the code.

Yes, because the names of the functions include the zeroize parts which 
makes it easier for developers to understand how they work instead of 
having a bool argument where they need to look up at which argument 
position it is.

> 
> Why this intermediate level?

So I don't need to repeat the function below for a different r0.fc, no?

[...]

>>    enum PQAP_FC {
>>    	PQAP_TEST_APQ,
>>    	PQAP_RESET_APQ,
>> @@ -94,6 +96,8 @@ _Static_assert(sizeof(struct ap_qirq_ctrl) == sizeof(uint64_t),
>>    int ap_setup(uint8_t *ap, uint8_t *qn);
>>    int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
>>    		 struct pqap_r2 *r2);
>> +int ap_pqap_reset(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw);
>> +int ap_pqap_reset_zeroize(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw);
>>    int ap_pqap_qci(struct ap_config_info *info);
>>    int ap_pqap_aqic(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
>>    		 struct ap_qirq_ctrl aqic, unsigned long addr);
>> diff --git a/s390x/ap.c b/s390x/ap.c
>> index 31dcfe29..47b4f832 100644
>> --- a/s390x/ap.c
>> +++ b/s390x/ap.c
>> @@ -341,6 +341,57 @@ static void test_pqap_aqic(void)
>>    	report_prefix_pop();
>>    }
>>    
>> +static void test_pqap_resets(void)
>> +{
>> +	struct ap_queue_status apqsw = {};
>> +	static uint8_t not_ind_byte;
>> +	struct ap_qirq_ctrl aqic = {};
>> +	struct pqap_r2 r2 = {};
>> +
>> +	int cc;
>> +
>> +	report_prefix_push("pqap");
>> +	report_prefix_push("rapq");
>> +
>> +	/* Enable IRQs which the resets will disable */
>> +	aqic.ir = 1;
>> +	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
>> +	report(cc == 0 && apqsw.rc == 0, "enable");
> 
> Depending on history I think we could have apqsw == 07 here.
> 
> (interrupt already set as requested)

I'd much rather grab a tapq and assert that ir == 0 so if someone alters 
the code they are responsible for giving this function a reset queue.

I'll add a comment that we expect ir == 0 for this function.

> 
> 
>> +
>> +	do {
>> +		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
> 
> 
> may be a little delay before retry as you do above for ap_reset_wait()?

Yes

> 
> 
>> +	} while (cc == 0 && apqsw.irq_enabled == 0);
>> +	report(apqsw.irq_enabled == 1, "IRQs enabled");
>> +
>> +	ap_pqap_reset(apn, qn, &apqsw);
>> +	cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
>> +	assert(!cc);
>> +	report(apqsw.irq_enabled == 0, "IRQs have been disabled");
> 
> shouldn't we check that the APQ is fine apqsw.rc == 0 ?

Isn't that covered by the assert above?

> 
> 
>> +
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("zapq");
>> +
>> +	/* Enable IRQs which the resets will disable */
>> +	aqic.ir = 1;
>> +	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
>> +	report(cc == 0 && apqsw.rc == 0, "enable");
>> +
>> +	do {
>> +		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
>> +	} while (cc == 0 && apqsw.irq_enabled == 0);
>> +	report(apqsw.irq_enabled == 1, "IRQs enabled");
>> +
>> +	ap_pqap_reset_zeroize(apn, qn, &apqsw);
>> +	cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
>> +	assert(!cc);
>> +	report(apqsw.irq_enabled == 0, "IRQs have been disabled");
>> +
>> +	report_prefix_pop();
>> +
>> +	report_prefix_pop();
>> +}
>> +
>>    int main(void)
>>    {
>>    	int setup_rc = ap_setup(&apn, &qn);
>> @@ -362,6 +413,7 @@ int main(void)
>>    		goto done;
>>    	}
>>    	test_pqap_aqic();
>> +	test_pqap_resets();
>>    
>>    done:
>>    	report_prefix_pop();

