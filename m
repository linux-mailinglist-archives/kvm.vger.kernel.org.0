Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B3A64063C
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 12:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiLBL5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 06:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbiLBL5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 06:57:04 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC06FD78E6
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 03:56:17 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B2BEFU6023783
        for <kvm@vger.kernel.org>; Fri, 2 Dec 2022 11:56:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CmjZ7fQhgRKUPtpKrXTsMlqqfFlkxUvYZ5XDuAqlImM=;
 b=eDD9LihkW4zD7LHR44VWCmQm8d8HgAJ5o4MxBs3BO0fbYdFdyiDNVmAYbZdN8A9RuyUf
 HL2dC6QZWKiNw+wisJmb2uG50e5NMAwCpkPo5d13cd/rPlB0w/C0pCWiXj4+pxv03gvd
 fR07LiMKKtwBX6i67ZKOPclZtVkgbpm2TdlJvL2ucPgXRnzqEg7lMv/jHWxbiV41WrwN
 ZPLbUDAl/od0Cm4x/ETRKtBkG6Lzr5HH+ckzzCp1j+lZvkHl5Fi3M79to8FLzQeB09Tx
 fRpHOAbBkdxO2ng340RRQ+05/Kvp3ybMUUBLP/8OMcpile2cyn6+seeXDkkcjl/RWPdd rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7ekgbbfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 11:56:16 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B2BmcFZ029213
        for <kvm@vger.kernel.org>; Fri, 2 Dec 2022 11:56:16 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7ekgbbfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 11:56:16 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B2BpIKh011473;
        Fri, 2 Dec 2022 11:56:14 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3m3a2hxm9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 11:56:14 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B2BuBGw57409896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Dec 2022 11:56:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4412311C052;
        Fri,  2 Dec 2022 11:56:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 038E911C04C;
        Fri,  2 Dec 2022 11:56:11 +0000 (GMT)
Received: from [9.179.12.252] (unknown [9.179.12.252])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Dec 2022 11:56:10 +0000 (GMT)
Message-ID: <cab7aa32-0d97-abe1-47f2-4d08c7aec6f0@linux.ibm.com>
Date:   Fri, 2 Dec 2022 12:56:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, pbonzini@redhat.com
References: <20221201084642.3747014-1-nrb@linux.ibm.com>
 <20221201084642.3747014-2-nrb@linux.ibm.com>
 <933616a6-0e1b-51e9-223e-0009d0b6b34b@linux.ibm.com>
 <7a05af7b-96e0-7914-1415-62443f6646dd@redhat.com>
 <166997789077.186408.11144216448246779334@t14-nrb.local>
 <49c289b2-c7d7-7aec-c975-e056cb42927e@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: add library for skey-related
 functions
In-Reply-To: <49c289b2-c7d7-7aec-c975-e056cb42927e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: N4R4MX2kq2ce0mJjH2h8yLYt5q946Sas
X-Proofpoint-ORIG-GUID: K0jPkA3qC-srmocW7fG7jr1ANA2xxzFv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_04,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212020089
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/22 12:32, Thomas Huth wrote:
> On 02/12/2022 11.44, Nico Boehr wrote:
>> Quoting Thomas Huth (2022-12-02 10:09:03)
>>> On 02/12/2022 10.03, Janosch Frank wrote:
>>>> On 12/1/22 09:46, Nico Boehr wrote:
>>>>> Upcoming changes will add a test which is very similar to the existing
>>>>> skey migration test. To reduce code duplication, move the common
>>>>> functions to a library which can be re-used by both tests.
>>>>>
>>>>
>>>> NACK
>>>>
>>>> We're not putting test specific code into the library.
>>>
>>> Do we need a new file (in the third patch) for the new test at all, or could
>>> the new test simply be added to s390x/migration-skey.c instead?
>>
>> Mh, not quite. One test wants to change storage keys *before* migrating, the other *while* migrating. Since we can only migrate once, it is not obvious to me how we could do that in one run.
>>
>> Speaking of one run, what we could do is add a command line argument which decides which test to run and then call the same test with different arguments in unittests.cfg.
> 
> Yes, that's what I had in mind - use a command line argument to select the
> test ... should be OK as long as both variants are listed in unittests.cfg,
> shouldn't it?
> 
>    Thomas
> 


@Thomas @Claudio:
I see two possible solutions if we want a "testlib" at some point (which 
for the record I don't have anything against):

Putting the files into lib/s390x/testlib/* which will then be part of 
our normal lib.
That's a minimal effort solution. It still puts those files into lib/* 
but they are at least contained in a directory.

Putting the files into s390x/testlib/* and creating a proper new lib.
Which means we'd need a few more lines of makefile changes.


None of that is a huge amount of work.
