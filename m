Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED0D9660C9
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 22:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfGKUnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 16:43:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41774 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfGKUnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 16:43:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BKcTBi021280;
        Thu, 11 Jul 2019 20:42:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=tSjzKrUHQ1knMz+gwb7wzYG6sENMAxSGm0UkDSdi7as=;
 b=rFWTCChF0oyIYzpmE5gque0fCM7T3jAST9DCJqUh+t3gKYfiFuveoO4uVhdNJh06LnTd
 DKd8tWqs4dflR8Ey8detui0SFtEDZzR/WM6dPbb6hO37tOHhCEi0732WX+HW0Fo60voZ
 Ezy1Hkp+Iuf5ZFtxRFZk4luBgxE+6viMmigJOwH+6Vmw1NBmmoyGKJ4K0b42CDgdVQTJ
 ymmQku8IXTD35TjXu/FxCCu5vs6kFW+NiIDzvIbzZhB9P8PxXHol/uCuvV5pYgYQy9f9
 aC1eSLXjTydoTYPA7XSnTPJ7LSiXNZzdy+b7f+W3XYYN8zAbC44UBjKC88OYPqYeF1AK bA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2tjkkq28mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 20:42:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BKbdeo158183;
        Thu, 11 Jul 2019 20:42:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tnc8tpsaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 20:42:14 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6BKg4ou031753;
        Thu, 11 Jul 2019 20:42:10 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Jul 2019 13:42:04 -0700
Subject: Re: [RFC v2 02/26] mm/asi: Abort isolation on interrupt, exception
 and context switch
To:     Mike Rapoport <rppt@linux.ibm.com>,
        Andi Kleen <andi@firstfloor.org>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        jan.setjeeilers@oracle.com, liran.alon@oracle.com,
        jwadams@google.com, graf@amazon.de, rppt@linux.vnet.ibm.com
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <1562855138-19507-3-git-send-email-alexandre.chartre@oracle.com>
 <874l3sz5z4.fsf@firstfloor.org> <20190711201706.GB20140@rapoport-lnx>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <09fee00d-37a6-0895-7964-0e8a2d5b17d6@oracle.com>
Date:   Thu, 11 Jul 2019 22:41:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190711201706.GB20140@rapoport-lnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907110228
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110228
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/11/19 10:17 PM, Mike Rapoport wrote:
> On Thu, Jul 11, 2019 at 01:11:43PM -0700, Andi Kleen wrote:
>> Alexandre Chartre <alexandre.chartre@oracle.com> writes:
>>>   	jmp	paranoid_exit
>>> @@ -1182,6 +1196,16 @@ ENTRY(paranoid_entry)
>>>   	xorl	%ebx, %ebx
>>>   
>>>   1:
>>> +#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
>>> +	/*
>>> +	 * If address space isolation is active then abort it and return
>>> +	 * the original kernel CR3 in %r14.
>>> +	 */
>>> +	ASI_START_ABORT_ELSE_JUMP 2f
>>> +	movq	%rdi, %r14
>>> +	ret
>>> +2:
>>> +#endif
>>
>> Unless I missed it you don't map the exception stacks into ASI, so it
>> has likely already triple faulted at this point.
> 
> The exception stacks are in the CPU entry area, aren't they?
>   

That's my understanding, stacks come from tss in the CPU entry area and
the CPU entry area is part for the core ASI mappings (see patch 15/26).

alex.
