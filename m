Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA31B4BA459
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 16:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242464AbiBQP2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 10:28:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242461AbiBQP2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 10:28:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE722B0B2D
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 07:28:03 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HF5tFi004681;
        Thu, 17 Feb 2022 15:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=spb1gV+AdlPHRM6izRJU90u5Cd+oTWDax0XxdWdD78M=;
 b=U+FgaJ9uF0IGdJeHD/Yi8Pu7j2pXwtPkfoIrJ7++HtU3WfX1Hzlz4rnDLvSQRI4zwXVj
 pLKJ1YaE4JexdT9XLtlmC9agmmtDCEEHNtsqc4KEfRuUggkVv+rJhiaq5oHRlaNA5V6H
 TpD1aUzIvMFATPJ2Gy7Ywg2z+sNdsh2ctAtOUkabcP/4eYmdczVkj9L44xAUMx++iZOq
 GLPHcsL/edNPSFbCA8q6aZfzeFyKThYagZ91qYo7YjjddLM6AQnvpoAwDYx3PR9x+0Xy
 dX9RSlW6KmhTvmuE7RM3ZnKqVrjgutih8vH+KdsgTfYZn1pfb7BTAT3hfpM5zwxtXQV7 JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9pp9m0bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 15:27:59 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HFFdeQ026319;
        Thu, 17 Feb 2022 15:27:58 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9pp9m0an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 15:27:58 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HFNTaY002057;
        Thu, 17 Feb 2022 15:27:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3e645k9j1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 15:27:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HFRqNB41746822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 15:27:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C818EA4065;
        Thu, 17 Feb 2022 15:27:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFD66A405B;
        Thu, 17 Feb 2022 15:27:51 +0000 (GMT)
Received: from [9.171.42.121] (unknown [9.171.42.121])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 15:27:51 +0000 (GMT)
Message-ID: <acc9b68e-a456-2136-0371-b815c8585a08@linux.ibm.com>
Date:   Thu, 17 Feb 2022 16:30:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v6 08/11] s390x: topology: Adding drawers to CPU topology
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     qemu-s390x@nongnu.org, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        david@redhat.com, eblake@redhat.com, cohuck@redhat.com,
        richard.henderson@linaro.org, qemu-devel@nongnu.org,
        armbru@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, philmd@redhat.com
References: <20220217134125.132150-1-pmorel@linux.ibm.com>
 <20220217134125.132150-9-pmorel@linux.ibm.com> <Yg5ZpEisMK1uWqQH@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <Yg5ZpEisMK1uWqQH@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d9Fn8DDq_0XV91C3amArzoV74KS-7Hm5
X-Proofpoint-ORIG-GUID: -ozAfusuXgSnr76iRMimNBJ1sP2lxWVJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/17/22 15:20, Daniel P. Berrangé wrote:
> On Thu, Feb 17, 2022 at 02:41:22PM +0100, Pierre Morel wrote:
>> S390 CPU topology may have up to 5 topology containers.
>> The first container above the cores is level 2, the sockets,
>> and the level 3, containing sockets are the books.
>>
>> We introduce here the drawers, drawers is the level containing books.
>>
>> Let's add drawers, level4, containers to the CPU topology.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   hw/core/machine-smp.c      | 33 ++++++++++++++++++++++++++-------
>>   hw/core/machine.c          |  2 ++
>>   hw/s390x/s390-virtio-ccw.c |  1 +
>>   include/hw/boards.h        |  4 ++++
>>   qapi/machine.json          |  7 ++++++-
>>   softmmu/vl.c               |  3 +++
>>   6 files changed, 42 insertions(+), 8 deletions(-)
> 
> Needs to update -smp args in qemu-options.hx too.
> 

Oh, right!

Thanks

>>

...snip...

>> index 73206f811a..fa6bde5617 100644
>> --- a/qapi/machine.json
>> +++ b/qapi/machine.json
>> @@ -866,13 +866,14 @@
>>   # a CPU is being hotplugged.
>>   #
>>   # @node-id: NUMA node ID the CPU belongs to
>> +# @drawer-id: drawer number within node/board the CPU belongs to
>>   # @book-id: book number within node/board the CPU belongs to
>>   # @socket-id: socket number within node/board the CPU belongs to
> 
> So the lack of change here implies that 'socket-id' is unique
> across multiple  books/drawers. Is that correct, as its differnt
> from semantics for die-id/core-id/thread-id which are scoped
> to within the next level of the topology ?

Hum, no I forgot to update and it needs a change.
What about

# @book-id: book number within node/board/drawer the CPU belongs to
# @socket-id: socket number within node/board/book the CPU belongs to

?

> 
>>   # @die-id: die number within socket the CPU belongs to (since 4.1)
>>   # @core-id: core number within die the CPU belongs to
>>   # @thread-id: thread number within core the CPU belongs to
>>   #
>> -# Note: currently there are 6 properties that could be present
>> +# Note: currently there are 7 properties that could be present
>>   #       but management should be prepared to pass through other
>>   #       properties with device_add command to allow for future
>>   #       interface extension. This also requires the filed names to be kept in
>> @@ -882,6 +883,7 @@
>>   ##
>>   { 'struct': 'CpuInstanceProperties',
>>     'data': { '*node-id': 'int',
>> +            '*drawer-id': 'int',
>>               '*book-id': 'int',
>>               '*socket-id': 'int',
>>               '*die-id': 'int',
> 
> Regards,
> Daniel
> 

Thanks a lot,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
