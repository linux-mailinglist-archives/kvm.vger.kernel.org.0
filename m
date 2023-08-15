Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5FE77CE0B
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 16:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237607AbjHOO1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 10:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237699AbjHOO06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 10:26:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F35173F;
        Tue, 15 Aug 2023 07:26:52 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FEIXec005144;
        Tue, 15 Aug 2023 14:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YzXD0RWMonie1ep61G3AawK33CW56LRZOVkUSEaN81s=;
 b=cyVcVbkfEAkRyDQZGWGLv5CFz7SpMy0Lrz4R1/5i3xcXYpN10Bmqv06A3O2zHchOIeHJ
 Gvb9aa7WSkz5WSy8C4Zv8v8tQtSNZXi4ZAiVH6Zwnw6M2ZIH6GtS0SgrsgtkErVwxZ0K
 /EnKSZ7Dg/Ttj01PJAyvH+1rB21X1Sbsy/YZ5BcePt1zbzcwpQkfJaptI2Za+rFKR6z2
 XNWU2e9TGpEbTfw3bykarehFUFmztCZh6Y5G8H2jgwXogtSBRbn2uBU8RpjGBT7jRr6K
 B/sGU2xD6SdaNiFhxyU8uu1HOArjCfa9C+tY7TnR8SPPh5efGyHhWiAMUbP9z9NEQSR0 Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgb0w85m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 14:26:52 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FELGxe012393;
        Tue, 15 Aug 2023 14:26:51 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgb0w85k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 14:26:51 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FDXrBm007839;
        Tue, 15 Aug 2023 14:26:50 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3senwk55y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 14:26:49 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FEQkW917695402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 14:26:46 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEB362004E;
        Tue, 15 Aug 2023 14:26:46 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BA862004B;
        Tue, 15 Aug 2023 14:26:46 +0000 (GMT)
Received: from [9.171.12.89] (unknown [9.171.12.89])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 14:26:46 +0000 (GMT)
Message-ID: <86ce9c6c-b33c-5f8e-b260-4add28608b7e@linux.ibm.com>
Date:   Tue, 15 Aug 2023 16:26:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [kvm-unit-tests PATCH v5 6/6] s390x: add a test for SIE without
 MSO/MSL
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        David Hildenbrand <dhildenb@redhat.com>
References: <20230712114149.1291580-1-nrb@linux.ibm.com>
 <20230712114149.1291580-7-nrb@linux.ibm.com>
 <1aac769e-7523-a858-8286-35625bfb0145@redhat.com>
 <168932372015.12187.10530769865303760697@t14-nrb>
 <fd822214-ce34-41dd-d0b6-d43709803958@redhat.com>
 <168933116940.12187.12275217086609823396@t14-nrb>
 <000b74d7-0b4f-d2b5-81b4-747c99a2df42@redhat.com>
 <169087269702.10672.8933292419680416340@t14-nrb>
 <0fc509e0-7c58-fc97-45bc-319d126417c2@redhat.com>
 <6815b8a5-c501-9d76-7032-1b388ed75669@linux.ibm.com>
 <02b01a3a-368a-c7f5-1f9a-fc3139078109@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <02b01a3a-368a-c7f5-1f9a-fc3139078109@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gmxZ3ixMRL8ehO_-9wo8jLdERNLpY53M
X-Proofpoint-ORIG-GUID: lGgQa9SSP5eoEbe5VoYWIULbNJcOVwVI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_14,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2308150125
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/15/23 16:07, Thomas Huth wrote:
> On 15/08/2023 13.30, Janosch Frank wrote:
>> On 8/14/23 16:59, Thomas Huth wrote:
>>> On 01/08/2023 08.51, Nico Boehr wrote:
>>>> Quoting Thomas Huth (2023-07-14 12:52:59)
>>>> [...]
>>>>> Maybe add $(SRCDIR)/s390x to INCLUDE_PATHS in the s390x/Makefile ?
>>>>
>>>> Yeah, that would work, but do we want that? I'd assume that it is a
>>>> concious decision not to have tests depend on one another.
>>>
>>> IMHO this would still be OK ... Janosch, Claudio, what's your opinion on
>>> this?
>>
>> And the headers are then ONLY available via snippets/* ?
>> Pardon my question, not enough cycles, too much work.
> 
> No, it's about being able to #include "snippets/c/sie-dat.h" from
> s390x/sie-dat.c, so that guest and host code can share some #defines.
> 
>    Thomas
> 


I'm fine with that.
