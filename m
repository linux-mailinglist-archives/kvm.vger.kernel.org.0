Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734EF785A12
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 16:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbjHWOJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 10:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235725AbjHWOJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 10:09:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1EFE46;
        Wed, 23 Aug 2023 07:09:32 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37NE29sV007815;
        Wed, 23 Aug 2023 14:09:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gQEw0xdajA/W3lvXPDeHpDwLOln67dkokBz3PqDiKgw=;
 b=r2F481dT5iWs8fNOR359u+d7DZnJurKeCYZ7KojcdruGgQKfwOwtqEE9QgcrARb9Q8CN
 PRz7kND6TcijMqDIra5tKWQ/dyTXVIX1Nz13865DdufTibwPw83CuYqew0xpCyZtjPWs
 72EG3d6NPrYNfd9TWTDPrK1Wrq2MqEJl0Bu/YmLSLLdmKxToBA9PAD/9XZHTUP8KJQkC
 ikRr57F588L4YPDR4XdBtRKCO/ianiKQSmiIJnbR2ebvPFe9eyunOai3M8evd5dlWwPz
 7Cv6bhhMz2ceFYZUR/XxbjUoSxgmdOz6Ot9ndO1w9a30d6OJhd1GfzbFTB+A810N+cgE qg== 
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3snkh5gc0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Aug 2023 14:09:32 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37NCCJ8I020117;
        Wed, 23 Aug 2023 14:09:30 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sn22aeut6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Aug 2023 14:09:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37NE9Rgg19137026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Aug 2023 14:09:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7A8F20040;
        Wed, 23 Aug 2023 14:09:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33CDB2004D;
        Wed, 23 Aug 2023 14:09:27 +0000 (GMT)
Received: from [9.179.28.253] (unknown [9.179.28.253])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 23 Aug 2023 14:09:27 +0000 (GMT)
Message-ID: <e144381d-4ff3-d7b6-5624-813ea22f196a@linux.ibm.com>
Date:   Wed, 23 Aug 2023 16:09:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH] KVM: s390: fix gisa destroy operation might lead to cpu
 stalls
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
References: <20230823124140.3839373-1-mimu@linux.ibm.com>
 <ZOYIWuq3iqLjDd+q@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <ZOYIWuq3iqLjDd+q@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cadWjTE0dJc1Py02hQ48CuH-rp9PDpxU
X-Proofpoint-GUID: cadWjTE0dJc1Py02hQ48CuH-rp9PDpxU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-23_09,2023-08-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 spamscore=0 clxscore=1015
 mlxlogscore=679 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2308100000 definitions=main-2308230128
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23.08.23 15:23, Alexander Gordeev wrote:
> On Wed, Aug 23, 2023 at 02:41:40PM +0200, Michael Mueller wrote:
> ...
>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>> index 9bd0a873f3b1..73153bea6c24 100644
>> --- a/arch/s390/kvm/interrupt.c
>> +++ b/arch/s390/kvm/interrupt.c
>> @@ -3205,8 +3205,10 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
>>   	if (gi->alert.mask)
>>   		KVM_EVENT(3, "vm 0x%pK has unexpected iam 0x%02x",
>>   			  kvm, gi->alert.mask);
>> -	while (gisa_in_alert_list(gi->origin))
>> -		cpu_relax();
>> +	while (gisa_in_alert_list(gi->origin)) {
>> +		KVM_EVENT(3, "vm 0x%pK gisa in alert list during destroy", kvm);
>> +		process_gib_alert_list();
> 
> process_gib_alert_list() has two nested loops and neither of them
> does cpu_relax(). I guess, those are needed instead of one you remove?

Calling function process_gib_alert_list() guarantees the gisa
is taken out of the alert list immediately and thus the potential
endless loop on gisa_in_alert_list() is solved. The issue surfaced
with the following patch that accidently disabled the GAL interrupt
processing on the host that normaly handles the alert list.
The patch has been reverted from devel and will be re-applied in v2.

88a096a7a460 Revert "s390/airq: remove lsi_mask from airq_struct"
a9d17c5d8813 s390/airq: remove lsi_mask from airq_struct

Does that make sense for you?

> 
>> +	}
>>   	hrtimer_cancel(&gi->timer);
>>   	gi->origin = NULL;
>>   	VM_EVENT(kvm, 3, "gisa 0x%pK destroyed", gisa);
