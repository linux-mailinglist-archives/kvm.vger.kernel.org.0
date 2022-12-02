Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CADC6405B5
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 12:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbiLBLVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 06:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiLBLU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 06:20:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459EFD4267
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 03:20:41 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B2AvGhC006128
        for <kvm@vger.kernel.org>; Fri, 2 Dec 2022 11:20:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1xBcU1h6e4Fampzzqac9gT28dcUBg1prz0MfWo0VRIs=;
 b=bGUJduENXza2xVZWDCbw+0N0TQJzPzRNkSt/wM4NF2jCvIDYunty8U4/Q/MWfbYK6Zlm
 2LdcX7ccJcpAYkGU5CQWqP7iYXoaGWvxiIDH0ztFcYjHOrSPhlYrnOcQhq6y+Dh5xsZZ
 xEu4kBRsGWYOTU1R7jmy4GrAmXZrxo88wrkN9yo5f8cSrDULjNLVGT4T8+jZzKaxObb6
 F4BhY7a2pCqiR+mGxb8V8keZ7LXUFC7iZgZ49uKNz8ncDrZU0rB9X2o9jXDjxvhh0V+N
 H3/IMC54khz+FI9AuA3BMAGw6HHAejW9PXzGlYxk5GBFLDuZnCyCP3dkUKO9gmU32zvj dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m77x1vbnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 11:20:41 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B2AmEH1005616
        for <kvm@vger.kernel.org>; Fri, 2 Dec 2022 11:20:41 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m77x1vbmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 11:20:41 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B2B67jf009534;
        Fri, 2 Dec 2022 11:20:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3m3ae96jk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 11:20:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B2BKZAV52691256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Dec 2022 11:20:35 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30B1A11C04C;
        Fri,  2 Dec 2022 11:20:35 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E406811C04A;
        Fri,  2 Dec 2022 11:20:34 +0000 (GMT)
Received: from [9.179.12.252] (unknown [9.179.12.252])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Dec 2022 11:20:34 +0000 (GMT)
Message-ID: <d4af0699-e3e3-3a32-b963-b10beb390f7d@linux.ibm.com>
Date:   Fri, 2 Dec 2022 12:20:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, pbonzini@redhat.com
References: <20221201084642.3747014-1-nrb@linux.ibm.com>
 <20221201084642.3747014-2-nrb@linux.ibm.com>
 <933616a6-0e1b-51e9-223e-0009d0b6b34b@linux.ibm.com>
 <166997759426.186408.182395619403215562@t14-nrb.local>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: add library for skey-related
 functions
In-Reply-To: <166997759426.186408.182395619403215562@t14-nrb.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7Giin4EHwqYiM9J5jlIOC_VIo8f5gH_W
X-Proofpoint-GUID: TXEdxieHl3L2-aP3i-YFMceoqP31Kzzf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_04,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=836 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212020086
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/22 11:39, Nico Boehr wrote:
> Quoting Janosch Frank (2022-12-02 10:03:22)
>> On 12/1/22 09:46, Nico Boehr wrote:
>>> Upcoming changes will add a test which is very similar to the existing
>>> skey migration test. To reduce code duplication, move the common
>>> functions to a library which can be re-used by both tests.
>>>
>>
>> NACK
>>
>> We're not putting test specific code into the library.
> 
> What do you mean by "test specific"? After all, it is used by two tests now, possibly more in the future.
> 
> Any alternative suggestions?

For me this is like putting kselftest macros/functions into the kernel.

The KUT library is more or less the kernel on which the tests in s390x/ 
are based on. It provides primitives which (hopefully and mostly) aren't 
specific to tests.

Yes:
Providing skey set and get functions for one or multiple pages to tests.
I.e. sske and iske wrappers.

No:
Providing multi-page skey set and verify functions that set and verify 
skeys based on a pattern which is __hardcoded__ into the function using 
the skey wrappers. I.e. you're trying to create a new layer (test 
functionality) and stuffing it into the unit test kernel library.

What you want is a separate testlib which would reside in s390x/testlib/ 
where we can store often repeated functions and macros.
