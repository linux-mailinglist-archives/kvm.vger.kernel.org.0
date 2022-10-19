Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685DF604CA7
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiJSQCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbiJSQB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:01:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB71179985
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:01:22 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JFbdAB002475;
        Wed, 19 Oct 2022 15:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=y23RtZhyLQR/2hVyh4Ixo9I32DmeyqDhpA/NhTLbs7s=;
 b=mnFqWEsdQv8O6rVnfEhgtokzO4E46g0qM2JfCXBgTOhQtbZWxhnKSYxbnsqgKaFz3DXr
 5NcBBf2j9MQxtCfeGLqHid5iD/wYzS1p1TNT4PR1Bhcwh5i19fBJsr3sV9e31Sf59hvN
 Nti6n8kP6lhYXOqnueaGAVp88zapwN74j9jB1HtVBvn9Dp20RjINvp6vZksod6y0bjy2
 jnV2e23vVkge+cBNqy1Bj+2zBKt7OvVn3/s3M0MV9TJ3do8RMat0twbOkKg4CoQ3cWyW
 FgGsAz0dxYJCASIkPlmgw70Ok9f0Kl+K18bmUnWjaRPTt4op1spJ4YXr8WZ48CzXovgZ jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kakvmrsuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 15:48:27 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JFbqGY008319;
        Wed, 19 Oct 2022 15:48:26 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kakvmrsu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 15:48:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JFZNPW001042;
        Wed, 19 Oct 2022 15:48:24 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg97brr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 15:48:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JFmsx849152292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 15:48:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC4FA42047;
        Wed, 19 Oct 2022 15:48:20 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5086A42041;
        Wed, 19 Oct 2022 15:48:20 +0000 (GMT)
Received: from [9.152.222.245] (unknown [9.152.222.245])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 15:48:20 +0000 (GMT)
Message-ID: <637596be-cbde-e690-0461-6953f6420b38@linux.ibm.com>
Date:   Wed, 19 Oct 2022 17:48:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v10 6/9] s390x/cpu topology: add topology-disable machine
 property
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
 <20221012162107.91734-7-pmorel@linux.ibm.com>
 <08bbd6f8-6ae3-4a28-66ed-d5a290c1a30d@kaod.org> <87y1tcjibw.fsf@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <87y1tcjibw.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JCpyfSQQBjsJnXlbB64M3YUB-du5PhtZ
X-Proofpoint-ORIG-GUID: fh8JpW5cnvXPtDLIMTn8oDyKd2CFEQKa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_09,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/19/22 11:03, Cornelia Huck wrote:
> On Tue, Oct 18 2022, Cédric Le Goater <clg@kaod.org> wrote:
> 
>> On 10/12/22 18:21, Pierre Morel wrote:
>>> S390 CPU topology is only allowed for s390-virtio-ccw-7.3 and
>>> newer S390 machines.
>>> We keep the possibility to disable the topology on these newer
>>> machines with the property topology-disable.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>    include/hw/boards.h                |  3 ++
>>>    include/hw/s390x/cpu-topology.h    | 18 +++++++++-
>>>    include/hw/s390x/s390-virtio-ccw.h |  2 ++
>>>    hw/core/machine.c                  |  5 +++
>>>    hw/s390x/s390-virtio-ccw.c         | 53 +++++++++++++++++++++++++++++-
>>>    util/qemu-config.c                 |  4 +++
>>>    qemu-options.hx                    |  6 +++-
>>>    7 files changed, 88 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/hw/boards.h b/include/hw/boards.h
>>> index 311ed17e18..67147c47bf 100644
>>> --- a/include/hw/boards.h
>>> +++ b/include/hw/boards.h
>>> @@ -379,6 +379,9 @@ struct MachineState {
>>>        } \
>>>        type_init(machine_initfn##_register_types)
>>>    
>>> +extern GlobalProperty hw_compat_7_2[];
>>> +extern const size_t hw_compat_7_2_len;
>>
>> QEMU 7.2 is not out yet.
> 
> Yes, and the introduction of the new compat machines needs to go into a
> separate patch. I'm usually preparing that patch while QEMU is in
> freeze, but feel free to cook up a patch earlier if you need it.

OK, Thanks, I understand I put it in a separate file so it can be 
adapted at the moment the series will need to be merged.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
