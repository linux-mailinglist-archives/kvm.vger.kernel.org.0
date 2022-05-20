Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A6852EDCF
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350108AbiETOI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241098AbiETOI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:08:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6414A15F6D9;
        Fri, 20 May 2022 07:08:26 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KCtic1031529;
        Fri, 20 May 2022 14:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MGGMzZOKMBu4hltnvWVkXaudLADdjxsANAFJvW2fHew=;
 b=pj7WQvEOgggsgTJZ27HTw8sZ3fuq9bzqL8OmQ1hdilOyh63B0Mj0Fut4TzfYy6uZltMw
 zvB3in+S1pDBuUIzeKTILnKiT77OTRY9VoBhbBXEdHSkghotor4F81TrdkHGXhVUc9FN
 6V21yqw/FrjppwfcAILwLjM0ClBAj+pH5IAlcf/NYnRcWC1rpGbPLJzJM+K0mCeTvdsd
 Wkj27V0c57tBqAnFxMiyASB4ShYLdUYdL+XeL3ye0hqKPABKBHk9XG07TtQm4y+yKPm5
 evVDtsCg/qjTo2YY7BwyUMgjrjSgsc+nZ0P8nrx6J8XASQYS+ElBdRmDgZoOZGeVtIRi 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g6be39tye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 14:08:25 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24KDOSjd030210;
        Fri, 20 May 2022 14:08:24 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g6be39txu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 14:08:24 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24KDqtLq030117;
        Fri, 20 May 2022 14:08:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3g2428ysca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 14:08:22 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24KE8JLA58130852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 14:08:19 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D542F4C046;
        Fri, 20 May 2022 14:08:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 759A94C044;
        Fri, 20 May 2022 14:08:19 +0000 (GMT)
Received: from [9.171.74.155] (unknown [9.171.74.155])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 May 2022 14:08:19 +0000 (GMT)
Message-ID: <5e1924d9-9594-55f2-00db-414374dc3c7d@linux.ibm.com>
Date:   Fri, 20 May 2022 16:08:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH] s390x: Ignore gcc 12 warnings for low
 addresses
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
References: <20220516144332.3785876-1-scgl@linux.ibm.com>
 <20220517140206.6a58760f@p-imbrenda>
 <15aee36c-de22-5f2a-d32b-b74cddebfc1c@redhat.com>
 <79585ac9-61cc-52a6-6df4-ca1530dbbc9f@linux.ibm.com>
 <52befa6f-409c-8ace-7aa7-7aa7837d6584@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <52befa6f-409c-8ace-7aa7-7aa7837d6584@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GqUam7w4QyRCDeKARZ5UTg_durKHrB8d
X-Proofpoint-GUID: JbilgRTp99rUfUlZCRY1mdl-8ozCUqNo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_04,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 suspectscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205200099
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/22 11:46, Thomas Huth wrote:
> On 18/05/2022 13.07, Janis Schoetterl-Glausch wrote:
>> On 5/17/22 18:09, Thomas Huth wrote:
>>> On 17/05/2022 14.02, Claudio Imbrenda wrote:
>>>> On Mon, 16 May 2022 16:43:32 +0200
>>>> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
>>>>
>>>>> gcc 12 warns if a memory operand to inline asm points to memory in the
>>>>> first 4k bytes. However, in our case, these operands are fine, either
>>>>> because we actually want to use that memory, or expect and handle the
>>>>> resulting exception.
>>>>> Therefore, silence the warning.
>>>>
>>>> I really dislike this
>>>
>>> I agree the pragmas are ugly. But maybe we should mimic what the kernel
>>> is doing here?
>>>
>>> $ git show 8b202ee218395
>>> commit 8b202ee218395319aec1ef44f72043e1fbaccdd6
>>> Author: Sven Schnelle <svens@linux.ibm.com>
>>> Date:   Mon Apr 25 14:17:42 2022 +0200
>>>
>>>      s390: disable -Warray-bounds
>>>          gcc-12 shows a lot of array bound warnings on s390. This is caused
>>>      by the S390_lowcore macro which uses a hardcoded address of 0.
>>>          Wrapping that with absolute_pointer() works, but gcc no longer knows
>>>      that a 12 bit displacement is sufficient to access lowcore. So it
>>>      emits instructions like 'lghi %r1,0; l %rx,xxx(%r1)' instead of a
>>>      single load/store instruction. As s390 stores variables often
>>>      read/written in lowcore, this is considered problematic. Therefore
>>>      disable -Warray-bounds on s390 for gcc-12 for the time being, until
>>>      there is a better solution.
>>>
>>> ... so we should maybe disable it in the Makefile, too, until the
>>> kernel folks found a nicer solution?
>>>
>>>   Thomas
>>>
>>
>> Neat, wasn't aware of that commit.
>>
>> I don't think we need to concern ourselves with performance in this case and can define
>>
>> +#define HIDE_PTR(ptr)                          \
>> +({                                             \
>> +       uint64_t __ptr;                         \
>> +       asm ("" : "=d" (__ptr) : "0" (ptr));    \
>> +       (typeof(ptr))__ptr;                     \
>> +})
>> +
>>
>> in some header (which?).
>>
>> Another alternative would be to define some extern symbols for the addresses we want to use.
>> It might be nice to have a symbol for the lowcore anyway, then we can get rid of
>>
>> static struct lowcore *lc;
>> struct lowcore *lc = (struct lowcore *)0x0;
>> ...
>>
>> in a bunch of tests.
> 
> I like that idea.
> 
>> And use that symbol to derive the addresses we want to use.
>> emulator.c uses -1 to generate an addressing exception, we either need another symbol for
>> that or use another invalid address. (Can't get to -1 from lowcore/0 because the max array
>> size is signed int64 max)
> 
> Maybe use INT64_MAX or something similar? Would that work?

I did it slightly different than in my prototype --- used a pointer instead of an array,
doesn't matter then.
> 
>  Thomas
> 

