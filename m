Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF0E619439
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 11:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiKDKJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 06:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKDKJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 06:09:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3045129818
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 03:09:37 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A48IsA8011815;
        Fri, 4 Nov 2022 10:09:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=DOikEzhjvm1chpCqhNmIbjF5HD7/MFd6glT9U6jtehE=;
 b=RJsEDOE/yLe4BHhz+TM3ROVJAgKFAEfiQgn5FytUbZzq1AJzhG6I0SXyFhS/yMEAbGKw
 A0LbPcwN9TCEkD0Nxm0Hyfz9Mz/z/vi35v73Ys+qirmGLVeWW0CGnZ+cqj2od9AKXgCl
 OjfycX0+5ll6eTARFUDPIvS7CL03strlLFUz7me18MaIcfNg0rDXZTR9FyB+uRRoxkrk
 dbH9HiyouKNar8aMtHdJI+QNXf9gXrRGfDUWsCOPOTuZH4jFQnqkJZev2SDEp1ZcHq+1
 SDSaBmvDYuN4G4Nj3D3mRorJtLFJzIEKm+eHsMpyTimc5F38Ir9lJg6KchNkia0W6TlM QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmpn9hdux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 10:09:27 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A48l2ss005680;
        Fri, 4 Nov 2022 10:09:27 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmpn9hdty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 10:09:26 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A49pNJv006375;
        Fri, 4 Nov 2022 10:09:24 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3kgut9fm3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 10:09:23 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A4A9veX52101462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Nov 2022 10:09:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E148AE051;
        Fri,  4 Nov 2022 10:09:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DA28AE045;
        Fri,  4 Nov 2022 10:09:19 +0000 (GMT)
Received: from [9.171.69.218] (unknown [9.171.69.218])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Nov 2022 10:09:19 +0000 (GMT)
Message-ID: <728a5046-bd09-8b13-05d2-984e1871c38c@linux.ibm.com>
Date:   Fri, 4 Nov 2022 11:09:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v11 09/11] s390x/cpu topology: add topology machine
 property
To:     Cornelia Huck <cohuck@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
 <20221103170150.20789-10-pmorel@linux.ibm.com> <87bkpox8cw.fsf@redhat.com>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <87bkpox8cw.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Sh01q_duHgE8q5fcEp-OrrbxBWSCRQKW
X-Proofpoint-ORIG-GUID: 7AcYBKDutY86pyEu_avo2dSnAu1Fl3qp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_06,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211040062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/3/22 18:20, Cornelia Huck wrote:
> On Thu, Nov 03 2022, Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We keep the possibility to switch on/off the topology on newer
>> machines with the property topology=[on|off].
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/boards.h                |  3 +++
>>   include/hw/s390x/cpu-topology.h    |  8 +++-----
>>   include/hw/s390x/s390-virtio-ccw.h |  1 +
>>   hw/core/machine.c                  |  3 +++
>>   hw/s390x/cpu-topology.c            | 19 +++++++++++++++++++
>>   hw/s390x/s390-virtio-ccw.c         | 28 ++++++++++++++++++++++++++++
>>   util/qemu-config.c                 |  4 ++++
>>   qemu-options.hx                    |  6 +++++-
>>   8 files changed, 66 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/hw/boards.h b/include/hw/boards.h
>> index 311ed17e18..67147c47bf 100644
>> --- a/include/hw/boards.h
>> +++ b/include/hw/boards.h
>> @@ -379,6 +379,9 @@ struct MachineState {
>>       } \
>>       type_init(machine_initfn##_register_types)
>>   
>> +extern GlobalProperty hw_compat_7_2[];
>> +extern const size_t hw_compat_7_2_len;
> 
> This still needs to go into a separate patch that introduces the 8.0
> machine types for the relevant machines... I'll probably write that
> patch soon (next week or so), you can pick it then into this series.
> 

Oh sorry, I forgot to suppress these two definitions for this series.
I do not need this for now.
I will probably need your patch introducing the 8.0 for the next spin.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
