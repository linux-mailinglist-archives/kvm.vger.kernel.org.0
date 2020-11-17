Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A962B68C2
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 16:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgKQPci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 10:32:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15286 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727349AbgKQPch (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 10:32:37 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHF3bob179583;
        Tue, 17 Nov 2020 10:32:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yfjkJkNeQoAa98KeUAx8dV5qOjXWTE5/WR0lGduxBqE=;
 b=V1OaPAJzksYOYd3KBN1t7w5m40H6tb+ba2piDrJCnZl8rKh6qS7MsLNVnKX2EoLjHt+e
 L7GpfwV8h06wCPnIV4tM11AqSrOMKfYEfbgcmEZQniLJsyyFOxpFNqO13lx8bdIrs29o
 vjo9I/2Hrw3rutuz+usGcPU6kSr37uF0tcJ6ERFwuoyS1H4CmGgJJlHts2zROvuWjV4D
 7rOEYqPbaC5ewiWq2MML1VOUPkt6hfo/aTlK9hfQh+5+RJZz6/yBc3XDBqzZE0ZGPUCh
 WOkTDWnqVMQ7px4Ouj0+fA3Aw+eGMmbd2rADuRt0RKs8RzLsSQ3qORMKTYHlMK4iOLJ3 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vcs39etn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:32:36 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AHF3f2Q179857;
        Tue, 17 Nov 2020 10:32:35 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vcs39ery-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:32:35 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFN18G007714;
        Tue, 17 Nov 2020 15:32:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 34t6v89p74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 15:32:32 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHFVEGS47251818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 15:31:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE99242041;
        Tue, 17 Nov 2020 15:31:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 832EE42047;
        Tue, 17 Nov 2020 15:31:14 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.86.233])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 15:31:14 +0000 (GMT)
Subject: Re: [PATCH 2/2] s390/gmap: make gmap memcg aware
To:     Janosch Frank <frankja@linux.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>
References: <20201117151023.424575-1-borntraeger@de.ibm.com>
 <20201117151023.424575-3-borntraeger@de.ibm.com>
 <fd9f77d2-fdd1-d2ab-d9ca-ee914ac9deaf@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <22430706-ccb1-2df6-79ca-4db53c9d8105@de.ibm.com>
Date:   Tue, 17 Nov 2020 16:31:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <fd9f77d2-fdd1-d2ab-d9ca-ee914ac9deaf@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 phishscore=0
 mlxscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17.11.20 16:22, Janosch Frank wrote:
> On 11/17/20 4:10 PM, Christian Borntraeger wrote:
>> gmap allocations can be attributed to a process.
>>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> Acked-by: Heiko Carstens <hca@linux.ibm.com>
>> ---
>>  arch/s390/mm/gmap.c | 30 +++++++++++++++---------------
>>  1 file changed, 15 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
>> index 64795d034926..9bb2c7512cd5 100644
>> --- a/arch/s390/mm/gmap.c
>> +++ b/arch/s390/mm/gmap.c
>> @@ -2,7 +2,7 @@
>>  /*
>>   *  KVM guest address space mapping code
>>   *
>> - *    Copyright IBM Corp. 2007, 2016, 2018
>> + *    Copyright IBM Corp. 2007, 2020
> 
> Do you mean 2007 - 2020 or did you drop the 2016 and 2018?
> How does this even work?

Last time I checked this was the IBM preferred variant to define
the range. first and last contribution.

