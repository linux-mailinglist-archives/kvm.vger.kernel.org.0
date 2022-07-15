Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F7257626B
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 15:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbiGOND3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 09:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiGOND1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 09:03:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2F77A524
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 06:03:26 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26FCpWTm002622;
        Fri, 15 Jul 2022 13:03:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2H+tHaJRqScRiBH9w0S03Fbfj+PL+zDQ9VjClxb/DgM=;
 b=T/UNcpwNPtXrrEcxgfpyaL4dIfA2tFO1I3+W3HvNFePLGD1ryiR34oq5V/1MwBAa2++1
 EQ8I/FhV0wF3nAzvQ0dcfODMxXhh7qLDzWaHkaiZXQlSIkSx+b4T1ZDxdpCILWzUh/aV
 QRw5F7PLPoWgBO9CjIkbvn72n+9yr42No6HBubWA3wdBWdILkU+Rt+30Dkhd99va5yQd
 DJrHP6JYhS9n7sTK0TtADfkyV4/wPnGKsiJRRETd9lyRoh1uqYblXqrBNrqDGQlZiD55
 u/QX8hG58T8wLspNEoCaMQkubwP6AxzVbNmQbCJWlQ0jNsfcXVUdMFC6ek9DCxIv8p9V IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hb8m1ga61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 13:03:21 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26FCpm7d003749;
        Fri, 15 Jul 2022 13:03:19 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hb8m1ga2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 13:03:18 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26FCoP2u023314;
        Fri, 15 Jul 2022 13:03:14 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3h71a90e9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 13:03:14 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26FD3BVj21430720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jul 2022 13:03:11 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C596CAE04D;
        Fri, 15 Jul 2022 13:03:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C28B7AE053;
        Fri, 15 Jul 2022 13:03:10 +0000 (GMT)
Received: from [9.171.83.230] (unknown [9.171.83.230])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Jul 2022 13:03:10 +0000 (GMT)
Message-ID: <14afa5dc-80de-c5a2-b57d-867c692b29cf@linux.ibm.com>
Date:   Fri, 15 Jul 2022 15:07:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v8 08/12] s390x/cpu_topology: implementing numa for the
 s390x topology
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <20220620140352.39398-9-pmorel@linux.ibm.com>
 <3a821cd1-b8a0-e737-5279-8ef55e58a77f@linux.ibm.com>
 <b1e89718-232c-2b0b-2133-102ab7b4dad4@linux.ibm.com>
 <b30eb75a-5a0b-3428-b812-95a2884914e4@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <b30eb75a-5a0b-3428-b812-95a2884914e4@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zIQbZmNOFZkl2KrHE8hhJylLNVqSO-hb
X-Proofpoint-GUID: lmSEBrctIWi6wd8IrcSpquHoJCTjVV2S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_05,2022-07-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0 suspectscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207150057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/15/22 11:11, Janis Schoetterl-Glausch wrote:
> On 7/14/22 22:17, Pierre Morel wrote:
>>
>>
>> On 7/14/22 16:57, Janis Schoetterl-Glausch wrote:
>>> On 6/20/22 16:03, Pierre Morel wrote:
>>>> S390x CPU Topology allows a non uniform repartition of the CPU
>>>> inside the topology containers, sockets, books and drawers.
>>>>
>>>> We use numa to place the CPU inside the right topology container
>>>> and report the non uniform topology to the guest.
>>>>
>>>> Note that s390x needs CPU0 to belong to the topology and consequently
>>>> all topology must include CPU0.
>>>>
>>>> We accept a partial QEMU numa definition, in that case undefined CPUs
>>>> are added to free slots in the topology starting with slot 0 and going
>>>> up.
>>>
>>> I don't understand why doing it this way, via numa, makes sense for us.
>>> We report the topology to the guest via STSI, which tells the guest
>>> what the topology "tree" looks like. We don't report any numa distances to the guest.
>>> The natural way to specify where a cpu is added to the vm, seems to me to be
>>> by specify the socket, book, ... IDs when doing a device_add or via -device on
>>> the command line.
>>>
>>> [...]
>>>
>>
>> It is a choice to have the core-id to determine were the CPU is situated in the topology.
>>
>> But yes we can chose the use drawer-id,book-id,socket-id and use a core-id starting on 0 on each socket.
>>
>> It is not done in the current implementation because the core-id implies the socket-id, book-id and drawer-id together with the smp parameters.
>>
>>
> Regardless of whether the core-id or the combination of socket-id, book-id .. is used to specify where a CPU is
> located, why use the numa framework and not just device_add or -device ?

You are right, at least we should be able to use both.
I will work on this.

> 
> That feels way more natural since it should already just work if you can do hotplug.
> At least with core-id and I suspect with a subset of your changes also with socket-id, etc.

yes, it already works with core-id

> 
> Whereas numa is an awkward fit since it's for specifying distances between nodes, which we don't do,
> and you have to use a hack to get it to specify which CPUs to plug (via setting arch_id to -1).
> 

Is it only for this?

-- 
Pierre Morel
IBM Lab Boeblingen
