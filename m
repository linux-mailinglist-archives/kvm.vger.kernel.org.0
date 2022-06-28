Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A55855D2ED
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345036AbiF1Kzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 06:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbiF1Kzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 06:55:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E51031939;
        Tue, 28 Jun 2022 03:55:31 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S9mvee030323;
        Tue, 28 Jun 2022 10:55:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cuh2ZQnoMInqJAzyup+RfWxxZ7oeCbu+JXFC0qMA7RY=;
 b=RhPmtVddx6G8RI/bMjJpOzmAGLH5+WBAVylQMwzIccbU6dZhUcoSthOSMoObhBX7RWkc
 Vw1UIKFzS6U3Sxy3q7RaB69y20T/J+tzdnGC3ZElK1bW4msTm+xf9xsH8owvxoVb2p4B
 POq/gJi+7JV/wCiMIUwgMbxgL8TEbysFWPXZFJd4hPQ9UYY86cOSOrlIP3E/7d+Sm4JL
 b+UnKWaw6aTJFHUB4a5imNGDUPJPinzSA49ywq3xCjjh0R6Z9/ZDDA9CknJUH6YOs75e
 lUkbA9PiXeYAl5TPipOyyBevCat7GhwzJ6rc+HznS9t+N6oCumk1tSEW+A+XEdIjfUXD rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyybh9u8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 10:55:30 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25S9pqBw002972;
        Tue, 28 Jun 2022 10:55:30 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyybh9u7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 10:55:30 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SAqhVK006671;
        Tue, 28 Jun 2022 10:55:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3gwt08ug6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 10:55:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SAtPxJ13566250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 10:55:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02DBCAE04D;
        Tue, 28 Jun 2022 10:55:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47B45AE045;
        Tue, 28 Jun 2022 10:55:24 +0000 (GMT)
Received: from [9.171.41.104] (unknown [9.171.41.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 10:55:24 +0000 (GMT)
Message-ID: <c5129b4a-b662-7643-2031-941da75e1e20@linux.ibm.com>
Date:   Tue, 28 Jun 2022 12:59:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v10 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
 <20220620125437.37122-3-pmorel@linux.ibm.com>
 <207a01aa-d92c-4a17-7b2f-aed59da4ce09@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <207a01aa-d92c-4a17-7b2f-aed59da4ce09@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PiSIzzJc2JbIVRMdEkfK9b5gMUYQF7wx
X-Proofpoint-GUID: g-O0L7XBKId20wioDZDLeo-m7nTqehtf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_05,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/28/22 10:59, Janis Schoetterl-Glausch wrote:
> On 6/20/22 14:54, Pierre Morel wrote:
>> We report a topology change to the guest for any CPU hotplug.
>>
>> The reporting to the guest is done using the Multiprocessor
>> Topology-Change-Report (MTCR) bit of the utility entry in the guest's
>> SCA which will be cleared during the interpretation of PTF.
>>
>> On every vCPU creation we set the MCTR bit to let the guest know the
>> next time he uses the PTF with command 2 instruction that the
>> topology changed and that he should use the STSI(15.1.x) instruction
>> to get the topology details.
>>
>> STSI(15.1.x) gives information on the CPU configuration topology.
>> Let's accept the interception of STSI with the function code 15 and
>> let the userland part of the hypervisor handle it when userland
>> support the CPU Topology facility.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h | 11 ++++++++---
>>   arch/s390/kvm/kvm-s390.c         | 27 ++++++++++++++++++++++++++-
>>   arch/s390/kvm/priv.c             | 15 +++++++++++----
>>   arch/s390/kvm/vsie.c             |  3 +++
>>   4 files changed, 48 insertions(+), 8 deletions(-)
>>
> [...]
> 
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 8fcb56141689..95b96019ca8e 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -1691,6 +1691,25 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>>   	return ret;
>>   }
>>
>> +/**
>> + * kvm_s390_sca_set_mtcr
> 
> I wonder if there is a better name, kvm_s390_report_topology_change maybe?

OK, for me, with a good name I can suppress a comment.


-- 
Pierre Morel
IBM Lab Boeblingen
