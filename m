Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C9457E14B
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 14:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbiGVMI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 08:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiGVMI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 08:08:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA31CBDA17
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 05:08:26 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26MBNaSR015146;
        Fri, 22 Jul 2022 12:08:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zQ8tIUW6U8kbYxaPJDs+7r/p6iUXDTOiQaJPekbq5v8=;
 b=CcyvCSJSdrpY7jbniUe1ElmWTHlaX432TTN0o34mAI6FMA4qAi1eWcl0a95eJfvs7a9/
 3TRFB/ak6eu9JWq7O51jetBpSAX5+LyyJfqAmVHgmgiYxVeMumWZKhQZmalbiYYLURWE
 c6OEMuAtzY6rjEFFsPzEhYYH5padgDQg9yd/R4NsDI+ARMEiDY12/nBVQpkN1qhIQDdF
 2Ycqk+K1ZCl7e72lLLEPmUIaFjJDPU/aSVm7epP9/+IEesBJWixZmhAA3WV4RbowNPKi
 T1/wrZXed0tGkxANsYStDJSlhY6ZO7WF1uARrb5OSVkNwUYSAKmfEgqCKuq7nY4mMrBr eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hftyw19ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 12:08:20 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26MBQntn025941;
        Fri, 22 Jul 2022 12:08:20 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hftyw19px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 12:08:20 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26MBqsTS031310;
        Fri, 22 Jul 2022 12:08:18 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3hbmy907j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 12:08:17 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26MC8FgW17891802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 12:08:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC022A405C;
        Fri, 22 Jul 2022 12:08:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40412A405B;
        Fri, 22 Jul 2022 12:08:13 +0000 (GMT)
Received: from [9.171.62.39] (unknown [9.171.62.39])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jul 2022 12:08:12 +0000 (GMT)
Message-ID: <15df7e57-0126-850d-4ab6-309ec03a2130@linux.ibm.com>
Date:   Fri, 22 Jul 2022 14:08:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v8 08/12] s390x/cpu_topology: implementing numa for the
 s390x topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
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
 <14afa5dc-80de-c5a2-b57d-867c692b29cf@linux.ibm.com>
 <e497396a-eadf-15ae-e11c-d6a2bbbff7c7@linux.ibm.com>
 <3b2f62a7-b526-adfd-e791-f2bc2cae3ccf@linux.ibm.com>
 <4d0d25e9-fedf-728c-12e9-70e4dc04d6b7@linux.ibm.com>
 <2c0b3926-482a-9c3f-1937-1be672ba7aeb@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <2c0b3926-482a-9c3f-1937-1be672ba7aeb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M8BF2Z0EibtSmByiGT6876XoGTwnOVFk
X-Proofpoint-ORIG-GUID: XFyA818wX0HDDHJQTd8cuw_1MaRqIzfR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-22_03,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207220051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/22 13:41, Pierre Morel wrote:
> 
> 
> On 7/21/22 10:16, Janis Schoetterl-Glausch wrote:
>> On 7/21/22 09:58, Pierre Morel wrote:
>>>
>>>
> 
> ...snip...
> 
>>>
>>> You are right, numa is redundant for us as we specify the topology using the core-id.
>>> The roadmap I would like to discuss is using a new:
>>>
>>> (qemu) cpu_move src dst
>>>
>>> where src is the current core-id and dst is the destination core-id.
>>>
>>> I am aware that there are deep implication on current cpu code but I do not think it is not possible.
>>> If it is unpossible then we would need a new argument to the device_add for cpu to define the "effective_core_id"
>>> But we will still need the new hmp command to update the topology.

Why the requirement for a hmp command specifically? Would qom-set on a cpu property work?
>>>
>> I don't think core-id is the right one, that's the guest visible CPU address, isn't it?
> 
> Yes, the topology is the one seen by the guest.
> 
>> Although it seems badly named then, since multiple threads are part of the same core (ok, we don't support threads).
> 
> I guess that threads will always move with the core or... we do not support threads.
> 
>> Instead socket-id, book-id could be changed dynamically instead of being computed from the core-id.
>>
> 
> What becomes of the core-id ?

It would stay the same. It has to, right? Can't change the address as reported by STAP.
I would just be completely independent of the other ids.
