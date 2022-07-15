Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B9F575EAD
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 11:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbiGOJhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 05:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiGOJhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 05:37:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984827E801
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 02:37:04 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26F9L155023838;
        Fri, 15 Jul 2022 09:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=hHkJwfzeLBmYwITq3FLrRhWxZDJ1l3voZwfL8aQ7Tvs=;
 b=nV9BOU8INoI6AryeGUB5RoMZJVk1Ew2LDMU4PaNJUz1+MLPz//cEtCgQT1CL1sZp/OoN
 3Ys8jKlpbRPXZ6A3vBW9UdP8dFJ/x5mR38ypKnYigtNGFjOSkMkAZPO4qqA+3pbNu7s1
 654WV6MBlDIRHyT4NcjPiQB/FxC9wweImy0y0EE9ywkErfWQHSJeHDm2nl3kEw1W8t52
 gB2vVSq3Qv/2VdaWbjtB+y1E2iVNjFYuAWcBMscVtrYE05NOYW9G57z5gse768QeZyOF
 BeriqGN5Cum2GbmO8X/OP/G5S1PoYuOEdyk7nAsko5IoA850y5RFhTWL1Oi2lf/qk1vo 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hb5ha0abt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 09:36:58 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26F9MJLq031017;
        Fri, 15 Jul 2022 09:36:58 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hb5ha0aa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 09:36:57 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26F9MLBw019320;
        Fri, 15 Jul 2022 09:31:55 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3h8ncnhk7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 09:31:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26F9Vqds21168596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jul 2022 09:31:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFFADA405C;
        Fri, 15 Jul 2022 09:31:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DEC7A405B;
        Fri, 15 Jul 2022 09:31:50 +0000 (GMT)
Received: from [9.171.51.176] (unknown [9.171.51.176])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Jul 2022 09:31:49 +0000 (GMT)
Message-ID: <df9e6199-21e5-7044-8793-9b088c5ff29c@linux.ibm.com>
Date:   Fri, 15 Jul 2022 11:31:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v8 00/12] s390x: CPU Topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <6ad0e006-72ee-3e24-48ed-fc8dd49db130@linux.ibm.com>
 <9c554788-aa51-d0fb-193b-f01ad266b256@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <9c554788-aa51-d0fb-193b-f01ad266b256@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VmYqrcW33A95e4oYh2AZ5TU_uk8ulQOc
X-Proofpoint-GUID: v6MDRO7YAFbdGd-9lTq1hmsYb11U8WcD
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_03,2022-07-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 malwarescore=0
 adultscore=0 phishscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207150041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/14/22 22:05, Pierre Morel wrote:
> 
> 
> On 7/14/22 20:43, Janis Schoetterl-Glausch wrote:
>> On 6/20/22 16:03, Pierre Morel wrote:
>>> Hi,
>>>
>>> This new spin is essentially for coherence with the last Linux CPU
>>> Topology patch, function testing and coding style modifications.
>>>
>>> Forword
>>> =======
>>>
>>> The goal of this series is to implement CPU topology for S390, it
>>> improves the preceeding series with the implementation of books and
>>> drawers, of non uniform CPU topology and with documentation.
>>>
>>> To use these patches, you will need the Linux series version 10.
>>> You find it there:
>>> https://lkml.org/lkml/2022/6/20/590
>>>
>>> Currently this code is for KVM only, I have no idea if it is interesting
>>> to provide a TCG patch. If ever it will be done in another series.
>>>
>>> To have a better understanding of the S390x CPU Topology and its
>>> implementation in QEMU you can have a look at the documentation in the
>>> last patch or follow the introduction here under.
>>>
>>> A short introduction
>>> ====================
>>>
>>> CPU Topology is described in the S390 POP with essentially the description
>>> of two instructions:
>>>
>>> PTF Perform Topology function used to poll for topology change
>>>      and used to set the polarization but this part is not part of this item.
>>>
>>> STSI Store System Information and the SYSIB 15.1.x providing the Topology
>>>      configuration.
>>>
>>> S390 Topology is a 6 levels hierarchical topology with up to 5 level
>>>      of containers. The last topology level, specifying the CPU cores.
>>>
>>>      This patch series only uses the two lower levels sockets and cores.
>>>           To get the information on the topology, S390 provides the STSI
>>>      instruction, which stores a structures providing the list of the
>>>      containers used in the Machine topology: the SYSIB.
>>>      A selector within the STSI instruction allow to chose how many topology
>>>      levels will be provide in the SYSIB.
>>>
>>>      Using the Topology List Entries (TLE) provided inside the SYSIB we
>>>      the Linux kernel is able to compute the information about the cache
>>>      distance between two cores and can use this information to take
>>>      scheduling decisions.
>>
>> Do the socket, book, ... metaphors and looking at STSI from the existing
>> smp infrastructure even make sense?
> 
> Sorry, I do not understand.
> I admit the cover-letter is old and I did not rewrite it really good since the first patch series.
> 
> What we do is:
> Compute the STSI from the SMP + numa + device QEMU parameters .
> 
>>
>> STSI 15.1.x reports the topology to the guest and for a virtual machine,
>> this topology can be very dynamic. So a CPU can move from from one topology
>> container to another, but the socket of a cpu changing while it's running seems
>> a bit strange. And this isn't supported by this patch series as far as I understand,
>> the only topology changes are on hotplug.
> 
> A CPU changing from a socket to another socket is the only case the PTF instruction reports a change in the topology with the case a new CPU is plug in.

Can a CPU actually change between sockets right now?
The socket-id is computed from the core-id, so it's fixed, is it not?

> It is not expected to appear often but it does appear.
> The code has been removed from the kernel in spin 10 for 2 reasons:
> 1) we decided to first support only dedicated and pinned CPU> 2) Christian fears it may happen too often due to Linux host scheduling and could be a performance problem

This seems sensible, but now it seems too static.
For example after migration, you cannot tell the guest which CPUs are in the same socket, book, ...,
unless I'm misunderstanding something.
And migration is rare, but something you'd want to be able to react to.
And I could imaging that the vCPUs are pinned most of the time, but the pinning changes occasionally.

> 
> So yes now we only have a topology report on vCPU plug.
> 
> 
> 
> 
> 
> 
> 
>>
> 

