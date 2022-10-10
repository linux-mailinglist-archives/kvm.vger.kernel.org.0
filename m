Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 786325FA2AB
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 19:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJJRVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 13:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiJJRVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 13:21:19 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C0F4E840
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 10:21:18 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29AFqPmP011513;
        Mon, 10 Oct 2022 17:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rBobT44tksVqkzpbV2Rgwf7mNkTDcFc5A+kgFq6iwAA=;
 b=bzhT7XI4GT8o/PXNTmI5VUKupZm3dMU18JRxVS6R4nvpzxZfgU9l4oCSHzZDLXTobska
 RTdYwRzhs5ntWBVsMdbm1eib0+t4ASG7MwFU6de+Mxx0TVi2DaQUplppPd69Du1ndlBR
 Xov2Qp7OszJEcV5PWi2dg4WiPYiBOH/ge9pePtdkh163nnPiA/M0D/i//SfWIjfbCgLJ
 wpZ+xa9YDOLMuMB5amI1raedduXq0R4EquHdNmiDZx6E81LG1qkyBrMWvLhWuxGHmzxI
 t+/iKl3+KmXmK+9EB9P72a0nzYehYB8tuZTZUOQFSQLPd47NvRBnwOYiNj44GzqgA9yF JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3jvm4gbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 17:20:39 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29AGkYlt030874;
        Mon, 10 Oct 2022 17:20:39 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3jvm4gap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 17:20:39 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29AH549S025869;
        Mon, 10 Oct 2022 17:20:37 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3k30u9j9pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 17:20:37 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29AHKXZX8258230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 17:20:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4458AE045;
        Mon, 10 Oct 2022 17:20:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0141AE051;
        Mon, 10 Oct 2022 17:20:32 +0000 (GMT)
Received: from [9.171.50.118] (unknown [9.171.50.118])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Oct 2022 17:20:32 +0000 (GMT)
Message-ID: <95d0c5d1-f623-c0a7-bcf6-9bb1fa71fdd4@linux.ibm.com>
Date:   Mon, 10 Oct 2022 19:20:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v9 01/10] s390x/cpus: Make absence of multithreading clear
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-2-pmorel@linux.ibm.com> <YzSOaczjJAgjrHG9@redhat.com>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <YzSOaczjJAgjrHG9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uJS5HPbcWPCOgoQ_bwTOKvwXn296G67X
X-Proofpoint-ORIG-GUID: -iXfmWCf9CXYXmdjGd6Y2lisXqlEV1Wy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-10_10,2022-10-10_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210100101
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/28/22 20:11, Daniel P. Berrangé wrote:
> On Fri, Sep 02, 2022 at 09:55:22AM +0200, Pierre Morel wrote:
>> S390x do not support multithreading in the guest.
>> Do not let admin falsely specify multithreading on QEMU
>> smp commandline.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   hw/s390x/s390-virtio-ccw.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>> index 70229b102b..b5ca154e2f 100644
>> --- a/hw/s390x/s390-virtio-ccw.c
>> +++ b/hw/s390x/s390-virtio-ccw.c
>> @@ -86,6 +86,9 @@ static void s390_init_cpus(MachineState *machine)
>>       MachineClass *mc = MACHINE_GET_CLASS(machine);
>>       int i;
>>   
>> +    /* Explicitely do not support threads */
>> +    assert(machine->smp.threads == 1);
> 
> What is the functional effect for currently released QEMU versions
> if a user has set threads == 2  for an s390 machine ?  Is the
> threads setting simply ignored ?

It is not ignored, the number of CPUs per sockets seen by the guest is 
cores*threads

> 
> If we want to eliminate this mistake, then there's two possible
> options
> 
>    * If it had no effect, treat this like a deprecation process
>      where we print a warning for 2 releases, and then turn the
>      warning into an error. Gives a little grace to fix the config
>      mistakes some users might have made, at a time convenient to
>      them.
> 
> Or
> 
>    * If it had effect and we need migration compatibility then forbid
>      threads > 1 only for new machine type versions, so existing
>      deployed guests are not changed.
> 
> With regards,
> Daniel

Thanks for your comments Daniel.
I will need to forbid threads > 1 for new machine.

regards,
Pierre




-- 
Pierre Morel
IBM Lab Boeblingen
