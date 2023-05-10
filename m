Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50366FDA65
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 11:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbjEJJGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 05:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236952AbjEJJFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 05:05:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002CC3C11;
        Wed, 10 May 2023 02:05:30 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34A8m1Wa009673;
        Wed, 10 May 2023 09:05:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UWWruU5P3pJ9qk3SguX7rH7dczyZ8QQS5Qe2ItUDfhc=;
 b=bWa6LRzUH3lg4WEQhKOlrkTQbRsqtmwr3QHkrMX/6vfrjU5Iva00cWws+q9fO9bCh9Mh
 BzsqGuvNG2mN9c8D+r42tD0cby64kQwBYBVViduJ9wwaFSa5nrZWGOlMEVp8yexlnmQn
 IiSPY300rP9bKkoBOKTRd7xJXPmIe6DIl1A4zqc4fmZZH2DtNnp3ofy0LsVzUbS/1HoE
 w2tWfRZ+sHdZg6rQP/Nw8wqQ5NZsASwuUS/PwZ6+7ssC2QHe7UY9qzISmu3w+zNXt5PV
 ShmElvd/Ut7OiBiCvJGLIl7rdPqiycotp8G++azaosuTLDcO90kn/1yihC8X5/s1EsOv jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg82v0jkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 09:05:30 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34A8nILC013000;
        Wed, 10 May 2023 09:04:54 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg82v0h61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 09:04:53 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34A7Nj1E028260;
        Wed, 10 May 2023 09:03:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qf896rxhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 09:03:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34A93trk21561926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 09:03:55 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40F2D20043;
        Wed, 10 May 2023 09:03:55 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D545220040;
        Wed, 10 May 2023 09:03:54 +0000 (GMT)
Received: from [9.171.18.209] (unknown [9.171.18.209])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 10 May 2023 09:03:54 +0000 (GMT)
Message-ID: <3b5cce0a-b344-be8a-7432-704fe9e84d8f@linux.ibm.com>
Date:   Wed, 10 May 2023 11:03:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests PATCH v3 1/9] s390x: uv-host: Fix UV init test
 memory allocation
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
References: <20230502130732.147210-1-frankja@linux.ibm.com>
 <20230502130732.147210-2-frankja@linux.ibm.com>
 <168370871258.331309.6187452257634029708@t14-nrb>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <168370871258.331309.6187452257634029708@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dNnRhQoK6fCfHugFSCj9aBpXfK3pgJP7
X-Proofpoint-GUID: X-xNwndfI6zcOnSMh7mkxTnM2YLGd1dp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100070
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/23 10:51, Nico Boehr wrote:
> Quoting Janosch Frank (2023-05-02 15:07:24)
>> The init memory has to be above 2G and 1M aligned but we're currently
>> aligning on 2G which means the allocations need a lot of unused
>> memory.
> 
> I know I already gave my R-b here, but...
> 
>> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
>> index 33e6eec6..9dfaebd7 100644
>> --- a/s390x/uv-host.c
>> +++ b/s390x/uv-host.c
>> @@ -500,14 +500,17 @@ static void test_config_create(void)
>>   static void test_init(void)
>>   {
>>          int rc;
>> -       uint64_t mem;
>> +       uint64_t tmp;
>>   
>> -       /* Donated storage needs to be over 2GB */
>> -       mem = (uint64_t)memalign_pages_flags(SZ_1M, uvcb_qui.uv_base_stor_len, AREA_NORMAL);
> 
> ...maybe out of coffee, but can you point me to the place where we're aligning
> to 2G here? I only see alignment to 1M and your change only seems to rename
> mem to tmp:
> 
>> +       /*
>> +        * Donated storage needs to be over 2GB, AREA_NORMAL does that
>> +        * on s390x.
>> +        */

This comment explains it :)
Its a re-name of mem to tmp and an extension of this comment so it makes 
more sense.

>> +       tmp = (uint64_t)memalign_pages_flags(SZ_1M, uvcb_qui.uv_base_stor_len, AREA_NORMAL);


