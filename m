Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9316F1906
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 15:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346183AbjD1NMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 09:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346152AbjD1NMM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 09:12:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C236182;
        Fri, 28 Apr 2023 06:11:44 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33SD7Zdn032522;
        Fri, 28 Apr 2023 13:11:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kulgARyI9rEQ2/6zpqmMTLHlA8mJvVKXysWRrfyqMV4=;
 b=E1E5alZJMNRi3zEsPMG5pWYjGsVYN8Bsg4XL+GFNyYLt1OTFfHxHINlHod5Kv+eSd8wV
 1NmMZoB6qtA1AZX59cKM45sn8hN+OqBSK+awsgnfU1Jd87PtPiWExf63tQLah551h59r
 efecyYaMWqTACJ5cmBn0ReKMWKsTdSyqo/qq3Nq16cpmOG1dVj2J98ZBJepC0nVDtE0g
 wBnrJcqkEHxmo+LDzHy0rUFLDOHPLOVMC+mpnsD/2XndsJ61b19ZBLRgMJ6WHNBoDjyL
 LYjIthhjz19XiBpW4P5IBPypwyWM6T7OoPyuQPpcsn42bSIxUYcR2g1aFJ38PRx3jpAe vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q8e681hq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 13:11:43 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33SD9NvD015028;
        Fri, 28 Apr 2023 13:11:03 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q8e681g82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 13:11:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33S2lkwG025183;
        Fri, 28 Apr 2023 13:10:12 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3q46ug3jnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 13:10:12 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33SDA8ru49807738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Apr 2023 13:10:08 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 929742004B;
        Fri, 28 Apr 2023 13:10:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C61920040;
        Fri, 28 Apr 2023 13:10:08 +0000 (GMT)
Received: from [9.171.23.33] (unknown [9.171.23.33])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 28 Apr 2023 13:10:08 +0000 (GMT)
Message-ID: <8122e0de-7cbb-83f2-4c3a-7a50f0d5b205@linux.ibm.com>
Date:   Fri, 28 Apr 2023 15:10:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v8 2/2] s390x: topology: Checking
 Configuration Topology Information
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
References: <20230426083426.6806-1-pmorel@linux.ibm.com>
 <20230426083426.6806-3-pmorel@linux.ibm.com>
 <168258524358.99032.14388431972069131423@t14-nrb>
 <25a9c3d6-43be-6a08-a32e-5abc520e8c62@linux.ibm.com>
 <168266833708.15302.621201335459420614@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <168266833708.15302.621201335459420614@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 810AKfQT2mjr7TawDHFsdzsqDOp8H6HK
X-Proofpoint-ORIG-GUID: 8enFklzDtoL_29nG7gWWo24HMQApMmDi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_04,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304280107
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/28/23 09:52, Nico Boehr wrote:
> Quoting Pierre Morel (2023-04-27 16:50:16)
> [...]
>>>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>>>> index fc3666b..375e6ce 100644
>>>> --- a/s390x/unittests.cfg
>>>> +++ b/s390x/unittests.cfg
>>>> @@ -221,3 +221,6 @@ file = ex.elf
>>>>    
>>>>    [topology]
>>>>    file = topology.elf
>>>> +# 3 CPUs on socket 0 with different CPU TLE (standard, dedicated, origin)
>>>> +# 1 CPU on socket 2
>>>> +extra_params = -smp 1,drawers=3,books=3,sockets=4,cores=4,maxcpus=144 -cpu z14,ctop=on -device z14-s390x-cpu,core-id=1,entitlement=low -device z14-s390x-cpu,core-id=2,dedicated=on -device z14-s390x-cpu,core-id=10 -device z14-s390x-cpu,core-id=20 -device z14-s390x-cpu,core-id=130,socket-id=0,book-id=0,drawer-id=0 -append '-drawers 3 -books 3 -sockets 4 -cores 4'
>>> If I got the command line right, all CPUs are on the same drawer with this command line, aren't they? If so, does it make sense to run with different combinations, i.e. CPUs on different drawers, books etc?
>> OK, I will add some CPU on different drawers and books.
> just to clarify: What I meant is adding an *additional* entry to unittests.cfg. Does it make sense in your opinion? I just want more coverage for different scenarios we may have.

Ah OK, yes even better.

In this test I chose the values randomly, I can add 2 other tests like

- once with the maximum of CPUs like:

[topology-2]
file = topology.elf
extra_params = -smp drawers=3,books=4,sockets=5,cores=4,maxcpus=240  
-append '-drawers 3 -books 4 -sockets 5 -cores 4'


or having 8 different TLE on the same socket

[topology-2]

file = topology.elf
extra_params = -smp 1,drawers=2,books=2,sockets=2,cores=30,maxcpus=240  
-append '-drawers 2 -books 2 -sockets 2 -cores 30' -cpu z14,ctop=on 
-device 
z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=2,entitlement=low 
-device 
z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=3,entitlement=medium 
-device 
z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=4,entitlement=high 
-device 
z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=5,entitlement=high,dedicated=on 
-device 
z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=65,entitlement=low 
-device 
z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=66,entitlement=medium 
-device 
z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=67,entitlement=high 
-device 
z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=68,entitlement=high,dedicated=on


What do you think is the best ?

Regards,

Pierre






