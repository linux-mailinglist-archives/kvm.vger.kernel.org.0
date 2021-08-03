Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6105B3DE9AD
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 11:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbhHCJ3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 05:29:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234506AbhHCJ3P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 05:29:15 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17393GN0031484;
        Tue, 3 Aug 2021 05:29:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UILdCH9TbqXhalafFZPDT3vaUsZmTFhkVUnO9SjA1X0=;
 b=PZIRkwRgPxZVB6+ENEKsVVg6h5pfiekRRcodccQd2wlAQHgaPoiUqJUDuNxfPUNDonls
 BD1fkoL39Q5DGEqRLzYvKU3qqbPUwq9HCoGEpfnOOJdX1X6lHCiKLTMg3Wu49SNTq9i8
 q7/cV0dvePL60IPFjK4E9ZfoXz1wHEpGRHEshZB3sRRD7NU90Vt3LgGlr54wAgztY4bW
 DXZ3772LcmRoangAb131lH9pP6zRzGVUMdZ6vySrP8U4Djb8aUNPJhXufbue19s5yb8t
 IBq6QaaBaXd31TzT+Q4lHHvVJB0d74dH1owjctGIsqNSfo/k6CBtuJcF48VrmXKfaEio 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a72321p5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 05:29:03 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1739S7L7125676;
        Tue, 3 Aug 2021 05:29:03 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a72321p50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 05:29:03 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1739Rf7X026178;
        Tue, 3 Aug 2021 09:29:01 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3a4x58e3mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 09:29:01 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1739SveI13238650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Aug 2021 09:28:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D2EAA4072;
        Tue,  3 Aug 2021 09:28:57 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25DB9A4064;
        Tue,  3 Aug 2021 09:28:57 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.75.95])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Aug 2021 09:28:57 +0000 (GMT)
Subject: Re: [PATCH v3 3/3] s390x: optimization of the check for CPU topology
 change
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, gor@linux.ibm.com
References: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
 <1627979206-32663-4-git-send-email-pmorel@linux.ibm.com>
 <YQkBfal/OiI2y1lA@osiris>
 <b91ce49f-c73b-bdd2-2389-8313f4baf46c@linux.ibm.com>
Message-ID: <a9a236c0-d248-6be5-883b-c21744d106ea@linux.ibm.com>
Date:   Tue, 3 Aug 2021 11:28:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <b91ce49f-c73b-bdd2-2389-8313f4baf46c@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mJ8rvJHq_yohVcKJQoqyPjvtS2cQUpHg
X-Proofpoint-ORIG-GUID: P84lBv9HCnT072TERb52I71CdIo5k0Jo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-03_02:2021-08-03,2021-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 clxscore=1015 impostorscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108030062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/3/21 10:57 AM, Pierre Morel wrote:
> 
> 
> On 8/3/21 10:42 AM, Heiko Carstens wrote:
>> On Tue, Aug 03, 2021 at 10:26:46AM +0200, Pierre Morel wrote:
>>> Now that the PTF instruction is interpreted by the SIE we can optimize
>>> the arch_update_cpu_topology callback to check if there is a real need
>>> to update the topology by using the PTF instruction.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   arch/s390/kernel/topology.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
>>> index 26aa2614ee35..741cb447e78e 100644
>>> --- a/arch/s390/kernel/topology.c
>>> +++ b/arch/s390/kernel/topology.c
>>> @@ -322,6 +322,9 @@ int arch_update_cpu_topology(void)
>>>       struct device *dev;
>>>       int cpu, rc;
>>> +    if (!ptf(PTF_CHECK))
>>> +        return 0;
>>> +
>>
>> We have a timer which checks if topology changed and then triggers a
>> call to arch_update_cpu_topology() via rebuild_sched_domains().
>> With this change topology changes would get lost.
> 
> For my understanding, if PTF check return 0 it means that there are no 
> topology changes.
> So they could not get lost.
> 
> What did I miss?
> 
> 
I missed that PTF clears the MCTR... and only one of the two calls will 
return 1 while we need both to return 1...


-- 
Pierre Morel
IBM Lab Boeblingen
