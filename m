Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1937C6C00
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 13:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347160AbjJLLOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 07:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjJLLOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 07:14:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBB791
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 04:14:07 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39CBCbZ8025489
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 11:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cWq3nOFne35IE+tdqKEQZNLVznNqaYnhxq6QGqSxmHE=;
 b=Rbz9OxY2sYChe1+JzcVJylZN0R9/BpyWmiseaURPzeAS97LE3ZM4spAxzgRqPzWK6IEr
 eoGcj86Org/8ovYBDG4/QYPP11CX4lZ0Q6ZbyA9vHvGQ4WSkfwtsZdCgNUlbVpU47Ml2
 5q002YVW+uxzWqRGG7TZRbkQjZ+ONx7qI2g5XEHc2kIvB4LS0bO1hZzLS8ljZDaoMmb3
 xLSbKUYT+AGCzlTr7X2dsDCCct6xUShXtzS202DdFNUBkg4FFAL8WIg3LXYW7GKMPgZJ
 T65ijDHzkr2JQMIFDkx8jtxRHbpC9w/lqc4EmYukhItcfVJJxkJ86Ioew8ye3p8dZ2VR DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tpfqk04bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 11:14:02 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39CBCjv9026217
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 11:13:57 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tpfqk03y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Oct 2023 11:13:57 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39C9aQp7025863;
        Thu, 12 Oct 2023 11:13:51 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkjnnq1yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Oct 2023 11:13:51 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39CBDmpS9437894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Oct 2023 11:13:48 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04F5820043;
        Thu, 12 Oct 2023 11:13:48 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D538E20040;
        Thu, 12 Oct 2023 11:13:47 +0000 (GMT)
Received: from [9.152.224.76] (unknown [9.152.224.76])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 12 Oct 2023 11:13:47 +0000 (GMT)
Message-ID: <2e437f51-bf74-4d9e-a753-f21e5490b1cc@linux.ibm.com>
Date:   Thu, 12 Oct 2023 13:13:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 1/3] lib: s390x: hw: Provide early detect
 host
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
References: <20231010073855.26319-1-frankja@linux.ibm.com>
 <20231010073855.26319-2-frankja@linux.ibm.com>
 <20231010124029.70abcb0a@p-imbrenda>
 <95f2e807-6b7f-4e24-a018-a041a2f7ce00@linux.ibm.com>
 <20231010134230.0d7a0156@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20231010134230.0d7a0156@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sWA3BeVGn8g6je966syXlltGDq2iOfmg
X-Proofpoint-GUID: gepQRxNn3OiXayG72zNyJzQ6MbRwuuZp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-12_05,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 adultscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310120091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/23 13:42, Claudio Imbrenda wrote:
> On Tue, 10 Oct 2023 13:03:08 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 10/10/23 12:40, Claudio Imbrenda wrote:
>>> On Tue, 10 Oct 2023 07:38:53 +0000
>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>    
>>>> For early sclp printing it's necessary to know if we're under LPAR or
>>>> not so we can apply compat SCLP ASCII transformations.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>    lib/s390x/hardware.c | 8 ++++++++
>>>>    lib/s390x/hardware.h | 1 +
>>>>    2 files changed, 9 insertions(+)
>>>>
>>>> diff --git a/lib/s390x/hardware.c b/lib/s390x/hardware.c
>>>> index 2bcf9c4c..d5a752c0 100644
>>>> --- a/lib/s390x/hardware.c
>>>> +++ b/lib/s390x/hardware.c
>>>> @@ -52,6 +52,14 @@ static enum s390_host do_detect_host(void *buf)
>>>>    	return HOST_IS_UNKNOWN;
>>>>    }
>>>>    
>>>> +enum s390_host detect_host_early(void)
>>>> +{
>>>> +	if (stsi_get_fc() == 2)
>>>> +		return HOST_IS_LPAR;
>>>> +
>>>> +	return HOST_IS_UNKNOWN;
>>>> +}
>>>> +
>>>>    enum s390_host detect_host(void)
>>>>    {
>>>>    	static enum s390_host host = HOST_IS_UNKNOWN;
>>>> diff --git a/lib/s390x/hardware.h b/lib/s390x/hardware.h
>>>> index 86fe873c..5e5a9d90 100644
>>>> --- a/lib/s390x/hardware.h
>>>> +++ b/lib/s390x/hardware.h
>>>> @@ -24,6 +24,7 @@ enum s390_host {
>>>>    };
>>>>    
>>>>    enum s390_host detect_host(void);
>>>> +enum s390_host detect_host_early(void);
>>>
>>> I wonder if it weren't easier to fix detect_host so it can be used
>>> early....
>>>    
>>
>> Problem is, where do you start and where do you end?
>>
>> We could statically allocate a page but why did we add the current
>> version then? (The old version did that if I remember correctly).
> 
> the old version also allocated pages, and was a hodgepodge of various
> functions replicating the same behaviour, many calling the others. the
> main goal of the current version was to make it more readable and
> maintainable.
> 
> a possible fix could also involve allocating the buffer on the stack of
> do_detect_host(), so it's not taking up memory permanently.
> 

We have 64k of stack and since we're calling this from the setup code a 
huge part should be free. I'll have a look at this.

