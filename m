Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608EA66E5FC
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 19:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjAQS3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 13:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbjAQS0h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 13:26:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3EC4F869
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 09:58:09 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HHFP6W031062;
        Tue, 17 Jan 2023 17:58:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Yol5zcYT2UWas9NyFbTw0UPSVox0zawgOQRc3lmamYQ=;
 b=neJn2nB7I6wIv9cY6R6tUhLMEi3ABIjs2TX9z2sYt60eY0BxB8xsQRyVwRNu0I48Hv2X
 OWiKYehpR6iXnSxEIx1amR4hltyJ+n+z7pDbRiupCxWlMFkZg/045s9+h3mx5yZ4RXnF
 q1P7JNj9zzplg+FSgFibgTUE2+AIH6swQSAAwmGEqJ1MhA3vibPBKJXj2sIE0TYkHqMX
 /GgZHkgMEOrfV3U8YJbq+RzCbh7qrEwdw/7l7ltkXm0rclXiRSelnUTyhaLLKI+SIlbx
 NodWvbtgcOULa8I+2qJ5SpTyqbHxEE6frPjHWOaWlj14WY/RXwHaTyNQxCne9a9dEJBr sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5ywjgwam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 17:58:04 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30HHbwm8029157;
        Tue, 17 Jan 2023 17:58:03 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5ywjgwa0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 17:58:03 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30H3BPcL030494;
        Tue, 17 Jan 2023 17:58:01 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3n3m16k317-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 17:58:01 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30HHvvQh46072104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 17:57:57 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDBE920040;
        Tue, 17 Jan 2023 17:57:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6994F20043;
        Tue, 17 Jan 2023 17:57:56 +0000 (GMT)
Received: from [9.171.42.216] (unknown [9.171.42.216])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Jan 2023 17:57:56 +0000 (GMT)
Message-ID: <16a553fd-9f0f-1289-90e3-6e401d838cf4@linux.ibm.com>
Date:   Tue, 17 Jan 2023 18:57:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 05/11] s390x/cpu topology: resetting the
 Topology-Change-Report
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-6-pmorel@linux.ibm.com>
 <f2433967-3c97-e4d7-9e2f-577b24c2369a@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <f2433967-3c97-e4d7-9e2f-577b24c2369a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7AmUyFNnmRqyTTwhXkhgcFedY6aUKbXs
X-Proofpoint-GUID: xcete7MXYjvD5wL_BxnNip6IP4PKxRuP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_08,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0 mlxscore=0
 impostorscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301170140
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/23 10:00, Thomas Huth wrote:
> On 05/01/2023 15.53, Pierre Morel wrote:
>> During a subsystem reset the Topology-Change-Report is cleared
>> by the machine.
>> Let's ask KVM to clear the Modified Topology Change Report (MTCR)
>> bit of the SCA in the case of a subsystem reset.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
> ...
>> diff --git a/target/s390x/kvm/kvm_s390x.h b/target/s390x/kvm/kvm_s390x.h
>> index f9785564d0..649dae5948 100644
>> --- a/target/s390x/kvm/kvm_s390x.h
>> +++ b/target/s390x/kvm/kvm_s390x.h
>> @@ -47,5 +47,6 @@ void kvm_s390_crypto_reset(void);
>>   void kvm_s390_restart_interrupt(S390CPU *cpu);
>>   void kvm_s390_stop_interrupt(S390CPU *cpu);
>>   void kvm_s390_set_diag318(CPUState *cs, uint64_t diag318_info);
>> +int kvm_s390_topology_set_mtcr(uint64_t attr);
>>   #endif /* KVM_S390X_H */
>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>> index c98b93a15f..14798ca305 100644
>> --- a/hw/s390x/s390-virtio-ccw.c
>> +++ b/hw/s390x/s390-virtio-ccw.c
>> @@ -122,6 +122,7 @@ static void subsystem_reset(void)
>>               device_cold_reset(dev);
>>           }
>>       }
>> +    s390_cpu_topology_reset();
>>   }
> 
> Would it make sense to add a "if (s390_has_topology())" check around the 
> new line?

Yes I think you are right, otherwise we may get a warning if the kernel 
does not support resetting the topology.

> 
> Anyway:
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 
> 

Thanks,

Regards,
Pierre



-- 
Pierre Morel
IBM Lab Boeblingen
