Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA67791976
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 16:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237331AbjIDOLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 10:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjIDOLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 10:11:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE20C6;
        Mon,  4 Sep 2023 07:11:32 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 384E8U1E014343;
        Mon, 4 Sep 2023 14:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zx9s4nr9xPNGO957zvWk6oOb8KoVuhnUNTWYPvr9+tY=;
 b=V1Jf+vtunSy8D9bCD3+fX2T2Hy3wYz9II6G8aH0SJ+++msvFRm2ckkUCfy9yYF2xVYGu
 Oh+sXoFEBJU9fLOr+7vh4Kl+G34ig+1dyGYks33557snCE2C02B+uZn+8RSxjaYYU6pf
 OTw2ZZGPwkiOlbnuGUMxGslukiLM713E9DIMxNH1wu5qxesuiiHZU0guY3r8LtSeTQ63
 LbpsDsjSFmE/mpvkwkx8kDnufFFCOpq3mKMEZPIQ8OhGXuo2Rhc/1WPdnDbuYedIBYzX
 jrYtcx5Gn+BZS0MyWiqnT9BQXoua4ufCv/q9YGp4diS2Bq0ZGVYBOBQkpBhx9mJMpwyv pg== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw6p8w5m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 14:11:31 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 384DtE31011130;
        Mon, 4 Sep 2023 14:11:31 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3svj31amrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 14:11:31 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 384EBRY627656880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Sep 2023 14:11:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D63B20043;
        Mon,  4 Sep 2023 14:11:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9605120040;
        Mon,  4 Sep 2023 14:11:26 +0000 (GMT)
Received: from [9.171.43.82] (unknown [9.171.43.82])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  4 Sep 2023 14:11:26 +0000 (GMT)
Message-ID: <1f5636f6-18f3-442a-4a60-62440d4907af@linux.ibm.com>
Date:   Mon, 4 Sep 2023 16:11:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v4] KVM: s390: fix gisa destroy operation might lead to
 cpu stalls
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Michael Mueller <mimu@linux.vnet.ibm.com>
References: <20230901105823.3973928-1-mimu@linux.ibm.com>
 <169381110909.97137.16554568711338641072@t14-nrb>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <169381110909.97137.16554568711338641072@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -IGfxAbo9aKu1BM81IINUAyCdlcp9YdN
X-Proofpoint-ORIG-GUID: -IGfxAbo9aKu1BM81IINUAyCdlcp9YdN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-04_07,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 adultscore=0 spamscore=0 clxscore=1015 malwarescore=0 mlxlogscore=474
 impostorscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309040126
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04.09.23 09:05, Nico Boehr wrote:
> Quoting Michael Mueller (2023-09-01 12:58:23)
> [...]
>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>> index 9bd0a873f3b1..96450e5c4b6f 100644
>> --- a/arch/s390/kvm/interrupt.c
>> +++ b/arch/s390/kvm/interrupt.c
> [...]
>>   static inline void gisa_set_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
>>   {
>>          set_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
>> @@ -3202,11 +3197,12 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
>>   
>>          if (!gi->origin)
>>                  return;
>> -       if (gi->alert.mask)
>> -               KVM_EVENT(3, "vm 0x%pK has unexpected iam 0x%02x",
>> -                         kvm, gi->alert.mask);
>> -       while (gisa_in_alert_list(gi->origin))
>> -               cpu_relax();
>> +       WARN(gi->alert.mask != 0x00,
>> +            "unexpected non zero alert.mask 0x%02x",
>> +            gi->alert.mask);
>> +       gi->alert.mask = 0x00;
>> +       if (gisa_set_iam(gi->origin, gi->alert.mask))
>> +               process_gib_alert_list();
> 
> I am not an expert for the GISA, so excuse my possibly stupid question:
> process_gib_alert_list() starts the timer. So can gisa_vcpu_kicker()
> already be running before we reach hrtimer_cancel() below? Is this fine?

You are right, It cannnot be running in that situation because 
gisa_vcpu_kicker() has returned with HRTIMER_NORESTART and no vcpus are 
defined anymore.

There is another case when the gisa specific timer is started not only 
in the process_gib_alert() case but also when a vcpu of the guest owning 
the gisa is put into wait state, see kvm_s390_handle_wait(). Thus yes, 
it could be running already in that situation. I remember having seen 
this situation when I write the gisa/gib code. But that's case in 
process_gib_alert_list()

It does not hurt to have the hrtimer_cancel() here but I don't want to 
add a change to this patch. Eventually a new one.

Thanks for asking!

> 
>>          hrtimer_cancel(&gi->timer);
>>          gi->origin = NULL;
>>          VM_EVENT(kvm, 3, "gisa 0x%pK destroyed", gisa);
