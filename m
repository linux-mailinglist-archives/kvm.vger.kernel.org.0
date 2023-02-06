Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E6668BFB4
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 15:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjBFONp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 09:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjBFONb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 09:13:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380B1C657
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 06:12:52 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316DqNR4023244;
        Mon, 6 Feb 2023 14:12:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=K9bXKa5/UTcdZdo4qTag6GoNPwNiRJjt75VYr8TlVPs=;
 b=D+aSQfUb1154TFSyAitIcyE5H49uJy94SZDwYVwgOchcZV/NotgXydc78WI31/DEjzUW
 CnP/mi4ItVJ8gxDtHzKJtKUeCq81xHfJ2wgOgo3d8Xu4fBPGRhwL/PV70ecp4nL2Ne65
 62L+ONXrXSrGd8mF62KR7ibnT61LMBEOlAVfowjU1K2JIzhipVe7zT7XfE8Qfl7GiHbO
 G6jrHRbNvnu+cSFP4eUOYaUAdC8fuZJhD40ZxupW62x3Lq/y1gCDqJVHrYYDkZ6WYfaX
 ThG44J9Rj7MNc/4mxIwTnCCHNXl8YTIO8hp2rEG4INDiCmGRcFM+aeC4pGkSHnWh5W7f 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk1abkx3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 14:12:24 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 316DtZxU023402;
        Mon, 6 Feb 2023 14:12:24 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk1abkx2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 14:12:23 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 315GPFoi011173;
        Mon, 6 Feb 2023 14:12:21 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3nhf06srse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 14:12:20 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316ECHTg21758532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 14:12:17 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C77E20049;
        Mon,  6 Feb 2023 14:12:17 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0218420043;
        Mon,  6 Feb 2023 14:12:16 +0000 (GMT)
Received: from [9.171.30.242] (unknown [9.171.30.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Feb 2023 14:12:15 +0000 (GMT)
Message-ID: <61ce96bb-35d9-cb9d-439f-1188e06c8ae6@linux.ibm.com>
Date:   Mon, 6 Feb 2023 15:12:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v15 09/11] machine: adding s390 topology to query-cpu-fast
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-10-pmorel@linux.ibm.com>
 <cce946c3-aa78-b9a2-79af-a2cf1ce32355@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <cce946c3-aa78-b9a2-79af-a2cf1ce32355@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PCYAk7KnkPIMKFxZQyBxA9jtKGnFhakc
X-Proofpoint-GUID: 51Vbgip_3WnoLWYgxU30eRq_ODtU_zri
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_07,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 impostorscore=0 spamscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302060121
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/6/23 13:38, Thomas Huth wrote:
> On 01/02/2023 14.20, Pierre Morel wrote:
>> S390x provides two more topology containers above the sockets,
>> books and drawers.
> 
> books and drawers are already handled via the entries in 
> CpuInstanceProperties, so this sentence looks like a wrong leftover now?

yes it is

> 
> I'd suggest talking about "dedication" and "polarity" instead?

OK.

> 
>> Let's add these CPU attributes to the QAPI command query-cpu-fast.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   qapi/machine.json          | 13 ++++++++++---
>>   hw/core/machine-qmp-cmds.c |  2 ++
>>   2 files changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/qapi/machine.json b/qapi/machine.json
>> index 3036117059..e36c39e258 100644
>> --- a/qapi/machine.json
>> +++ b/qapi/machine.json
>> @@ -53,11 +53,18 @@
>>   #
>>   # Additional information about a virtual S390 CPU
>>   #
>> -# @cpu-state: the virtual CPU's state
>> +# @cpu-state: the virtual CPU's state (since 2.12)
>> +# @dedicated: the virtual CPU's dedication (since 8.0)
>> +# @polarity: the virtual CPU's polarity (since 8.0)
>>   #
>>   # Since: 2.12
>>   ##
>> -{ 'struct': 'CpuInfoS390', 'data': { 'cpu-state': 'CpuS390State' } }
>> +{ 'struct': 'CpuInfoS390',
>> +    'data': { 'cpu-state': 'CpuS390State',
>> +              'dedicated': 'bool',
>> +              'polarity': 'int'
>> +    }
>> +}
>>   ##
>>   # @CpuInfoFast:
>> @@ -70,7 +77,7 @@
>>   #
>>   # @thread-id: ID of the underlying host thread
>>   #
>> -# @props: properties describing to which node/socket/core/thread
>> +# @props: properties describing to which 
>> node/drawer/book/socket/core/thread
> 
> I think this hunk should rather be moved to patch 1 now.

yes it should.
Thanks.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
