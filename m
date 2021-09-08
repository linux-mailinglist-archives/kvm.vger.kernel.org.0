Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6404034B3
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 09:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhIHHFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 03:05:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232184AbhIHHFq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 03:05:46 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18873ISe038599;
        Wed, 8 Sep 2021 03:04:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qDzUcZrYcDUllZjv0qQ9XzRik5hj4TNu/Hv/3igrSsU=;
 b=tt66OnUHWQoDuWXp+hhMvLrkjqSGttpd/L9X2WGAavMD61cJUbTw5qz2qJ5Af556/eZq
 P5tZv803K2J2jhCuoKdpx9jJTXkuLKQ1BfGxRD1s0ncfaTgc9WGtC4p5ZxTtBh4mTW4z
 Y7wsEmCThkNkVBuoocVJXQU1yP7jFp1fyGynS2k1zc/VW71/WWGYLdDES8f/9qL1A4UZ
 DnJPxPzNN1KkfrVk7foo7YJ1c85a4WIeGIbRJfhZKgmVdZH1H11ECBPBl+I86cQeXiRW
 TWWEi5nhnt7BIFjdPCKwPjWGsb+TlR6E4Hz9EU6FQwqP3EeV8h2XXeeYz/nj5dDr6Ud+ 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3axmvmmeap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 03:04:37 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18874bco046560;
        Wed, 8 Sep 2021 03:04:37 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3axmvmmea8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 03:04:37 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18873KNG011325;
        Wed, 8 Sep 2021 07:04:35 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3axcnp53ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 07:04:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18874V5B40829338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Sep 2021 07:04:31 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8188F11C054;
        Wed,  8 Sep 2021 07:04:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A11711C05B;
        Wed,  8 Sep 2021 07:04:31 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.79.242])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Sep 2021 07:04:30 +0000 (GMT)
Subject: Re: [PATCH v3 2/3] s390x: KVM: Implementation of Multiprocessor
 Topology-Change-Report
To:     Pierre Morel <pmorel@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, cohuck@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
 <1627979206-32663-3-git-send-email-pmorel@linux.ibm.com>
 <d85a6998-0f86-44d9-4eae-3051b65c2b4e@redhat.com>
 <59ff09e8-6975-20c2-78de-282585e2953d@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <66754109-4b35-f6e5-3db7-654d8b67392e@de.ibm.com>
Date:   Wed, 8 Sep 2021 09:04:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <59ff09e8-6975-20c2-78de-282585e2953d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m72y-ME-Qzb11RXsxOnPTr0fJxA2v3wd
X-Proofpoint-ORIG-GUID: rJ22_opFUMmURn52B54kFJDTJU_wv9Ip
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-08_02:2021-09-07,2021-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 mlxlogscore=999 suspectscore=0 impostorscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07.09.21 12:24, Pierre Morel wrote:
> 
> 
> On 9/6/21 8:37 PM, David Hildenbrand wrote:
>> On 03.08.21 10:26, Pierre Morel wrote:
>>> We let the userland hypervisor know if the machine support the CPU
>>> topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>>
>>> The PTF instruction will report a topology change if there is any change
>>> with a previous STSI_15_2 SYSIB.
>>> Changes inside a STSI_15_2 SYSIB occur if CPU bits are set or clear
>>> inside the CPU Topology List Entry CPU mask field, which happens with
>>> changes in CPU polarization, dedication, CPU types and adding or
>>> removing CPUs in a socket.
>>>
>>> The reporting to the guest is done using the Multiprocessor
>>> Topology-Change-Report (MTCR) bit of the utility entry of the guest's
>>> SCA which will be cleared during the interpretation of PTF.
>>>
>>> To check if the topology has been modified we use a new field of the
>>> arch vCPU to save the previous real CPU ID at the end of a schedule
>>> and verify on next schedule that the CPU used is in the same socket.
>>>
>>> We deliberatly ignore:
>>> - polarization: only horizontal polarization is currently used in linux.
>>> - CPU Type: only IFL Type are supported in Linux
>>> - Dedication: we consider that only a complete dedicated CPU stack can
>>>    take benefit of the CPU Topology.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>
>>
>>> @@ -228,7 +232,7 @@ struct kvm_s390_sie_block {
>>>       __u8    icptcode;        /* 0x0050 */
>>>       __u8    icptstatus;        /* 0x0051 */
>>>       __u16    ihcpu;            /* 0x0052 */
>>> -    __u8    reserved54;        /* 0x0054 */
>>> +    __u8    mtcr;            /* 0x0054 */
>>>   #define IICTL_CODE_NONE         0x00
>>>   #define IICTL_CODE_MCHK         0x01
>>>   #define IICTL_CODE_EXT         0x02
>>> @@ -246,6 +250,7 @@ struct kvm_s390_sie_block {
>>>   #define ECB_TE        0x10
>>>   #define ECB_SRSI    0x04
>>>   #define ECB_HOSTPROTINT    0x02
>>> +#define ECB_PTF        0x01
>>
>>  From below I understand, that ECB_PTF can be used with stfl(11) in the hypervisor.
>>
>> What is to happen if the hypervisor doesn't support stfl(11) and we consequently cannot use ECB_PTF? Will QEMU be able to emulate PTF fully?
> 
> Yes.

Do we want that? I do not think so. Other OSes (like zOS) do use PTF in there low level interrupt handler, so PTF must be really fast.
I think I would prefer that in that case the guest will simply not see stfle(11).
So the user can still specify the topology but the guest will have no interface to query it.
