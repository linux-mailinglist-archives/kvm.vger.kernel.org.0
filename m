Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE186FC5C4
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 12:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfKNL5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 06:57:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55812 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726002AbfKNL5r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 06:57:47 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEBv426046150
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 06:57:46 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w94yk46vf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 06:57:45 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 14 Nov 2019 11:57:43 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 11:57:41 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEBvein58196134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 11:57:41 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4F4F5204F;
        Thu, 14 Nov 2019 11:57:40 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.27])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A2D915204E;
        Thu, 14 Nov 2019 11:57:40 +0000 (GMT)
Subject: Re: [PATCH v1 1/4] s390x: saving regs for interrupts
To:     David Hildenbrand <david@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com
References: <c7d6c21e-3746-b31a-aff9-d19549feb24c@linux.ibm.com>
 <CD5636A0-3C33-4DC4-9217-68A00137E3F4@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 14 Nov 2019 12:57:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <CD5636A0-3C33-4DC4-9217-68A00137E3F4@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19111411-0008-0000-0000-0000032EF672
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111411-0009-0000-0000-00004A4E04E4
Message-Id: <ef5cc0aa-d1fe-874f-8f61-863c793a23d4@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=787 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019-11-14 11:28, David Hildenbrand wrote:
>
>> Am 14.11.2019 um 11:11 schrieb Pierre Morel <pmorel@linux.ibm.com>:
>>
>> ﻿
>>> On 2019-11-13 17:12, Janosch Frank wrote:
>>>> On 11/13/19 1:23 PM, Pierre Morel wrote:
>>>> If we use multiple source of interrupts, for exemple, using SCLP console
>>>> to print information while using I/O interrupts or during exceptions, we
>>>> need to have a re-entrant register saving interruption handling.
>>>>
>>>> Instead of saving at a static place, let's save the base registers on
>>>> the stack.
>>>>
>>>> Note that we keep the static register saving that we need for the RESET
>>>> tests.
>>>>
>>>> We also care to give the handlers a pointer to the save registers in
>>>> case the handler needs it (fixup_pgm_int needs the old psw address).
>>> So you're still ignoring the FPRs...
>>> I disassembled a test and looked at all stds and it looks like printf
>>> and related functions use them. Wouldn't we overwrite test FPRs if
>>> printing in a handler?
>> If printf uses the FPRs in my opinion we should modify the compilation options for the library.
>>
>> What is the reason for printf and related functions to use floating point?
>>
> Register spilling. This can and will be done.


Hum, can you please clarify?

AFAIK register spilling is for a compiler, to use memory if it has not 
enough registers.

So your answer is for the my first sentence, meaning yes register 
spilling will be done
or
do you mean register spilling is the reason why the compiler use FPRs 
and it must be done so?

Thanks,

Pierre


>
> Cheers.
>
>> I will have a deeper look at this.
>>
>>
>> Regards,
>>
>> Pierre
>>
>>
>> -- 
>> Pierre Morel
>> IBM Lab Boeblingen
>>
-- 
Pierre Morel
IBM Lab Boeblingen

