Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85943DE909
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 10:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbhHCI5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 04:57:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56568 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234418AbhHCI5e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 04:57:34 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1738i3Wj130384;
        Tue, 3 Aug 2021 04:57:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qWgBjPmQuecysWTyR2rKbNyLOzIOa63hZGuvr+fZA/8=;
 b=g7g4F4x6rYx2+eurTSoYL9xCgCAiLrVQQUrV9Sog0ND4+dPOprv2+Y7JelDxEa7l6QHF
 cPCtKrAi6ROtpHd2pA7mqlsB+6s02StKqJ8r1JYOD+W6ScyGSW7b3wopIkGPejLB+AqG
 nqWmHpVThcXXPhGbznopcC5oRcAUuSoWmSy+mY+ENZczlFVfC8u1lnU2HGDt020v8aye
 1JbJw3+0UN2QC4CsClEplBuSHuWMQTXY3x3ZBS8EfnIMbCKa927y2TuhCtrHq2dEW+3N
 9tJYXsq86IOwuKEK7eoAV2wIPhdpUQWLIDW7WCIRAgSmz2Rpx8zexvdVFILQWf0J+EXM cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a718daau7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 04:57:23 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1738iVqo132875;
        Tue, 3 Aug 2021 04:57:22 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a718daat5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 04:57:22 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1738vIsv000358;
        Tue, 3 Aug 2021 08:57:20 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3a4x58p2cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 08:57:20 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1738sL6e43778332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Aug 2021 08:54:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE0C4A4066;
        Tue,  3 Aug 2021 08:57:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BAAAA4060;
        Tue,  3 Aug 2021 08:57:16 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.75.95])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Aug 2021 08:57:16 +0000 (GMT)
Subject: Re: [PATCH v3 3/3] s390x: optimization of the check for CPU topology
 change
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, gor@linux.ibm.com
References: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
 <1627979206-32663-4-git-send-email-pmorel@linux.ibm.com>
 <YQkBfal/OiI2y1lA@osiris>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <b91ce49f-c73b-bdd2-2389-8313f4baf46c@linux.ibm.com>
Date:   Tue, 3 Aug 2021 10:57:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQkBfal/OiI2y1lA@osiris>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kQ871X6WUKOpAFHY1L5HXjZ0xBv3bAYq
X-Proofpoint-ORIG-GUID: eKVm7zrIKZvdv6hlekAjrON-gjEGzkgv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-03_02:2021-08-03,2021-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/3/21 10:42 AM, Heiko Carstens wrote:
> On Tue, Aug 03, 2021 at 10:26:46AM +0200, Pierre Morel wrote:
>> Now that the PTF instruction is interpreted by the SIE we can optimize
>> the arch_update_cpu_topology callback to check if there is a real need
>> to update the topology by using the PTF instruction.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/kernel/topology.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
>> index 26aa2614ee35..741cb447e78e 100644
>> --- a/arch/s390/kernel/topology.c
>> +++ b/arch/s390/kernel/topology.c
>> @@ -322,6 +322,9 @@ int arch_update_cpu_topology(void)
>>   	struct device *dev;
>>   	int cpu, rc;
>>   
>> +	if (!ptf(PTF_CHECK))
>> +		return 0;
>> +
> 
> We have a timer which checks if topology changed and then triggers a
> call to arch_update_cpu_topology() via rebuild_sched_domains().
> With this change topology changes would get lost.

For my understanding, if PTF check return 0 it means that there are no 
topology changes.
So they could not get lost.

What did I miss?


-- 
Pierre Morel
IBM Lab Boeblingen
