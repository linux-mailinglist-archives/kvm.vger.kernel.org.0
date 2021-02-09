Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75433315434
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 17:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhBIQpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 11:45:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233054AbhBIQn2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 11:43:28 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119GWX3V111455;
        Tue, 9 Feb 2021 11:42:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nTi6Q9KOs2xHWLvlXXaYefRSKg6TVnRWZRTYPO7NkgA=;
 b=bDmV+jqJbTjt75ejP6n7fhb/BTFBbrZXwo6VjWMJG15MyGvp8JtLoKRmRBJXykoD4HmW
 UY4kpCSDs2sL8/jn3AHJRa0Y4E/uhRBMyMjtR/fowqNt1R0RdJ8vZX6PjumfpuGSK//v
 QuuWY3BYmSlJt+MUjYAWpWyXYh0cpU/DMTNQ9A6aWBUlk9puzVkp7qW3f0X1ZYcoGBkP
 8InthzmA3vOfIaEwR1Xf4Q9ctFBz+jsXYtc1vypb1iUGGAHjscK3n6jW/Q9tJDGk+5r8
 +T5gapoR1LuIP/LF3K8m6l8sFpQ1ah0ByVqKMAKGWTAFOLgKUbuIZ8GlMAv6LvvxhnJY JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36kw0eka3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 11:42:45 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119GWm5B112860;
        Tue, 9 Feb 2021 11:42:45 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36kw0eka36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 11:42:44 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119Gan8N022522;
        Tue, 9 Feb 2021 16:42:43 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 36hskb1qy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 16:42:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119GgVS235586332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 16:42:31 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC8034C052;
        Tue,  9 Feb 2021 16:42:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D9914C04A;
        Tue,  9 Feb 2021 16:42:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.63.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 16:42:40 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] s390x: Workaround smp stop and store
 status race
To:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com
References: <20210209141554.22554-1-frankja@linux.ibm.com>
 <20210209170804.75d1fc9d@ibm-vm>
 <a361e674-fa78-8c06-0583-29f8989d5493@linux.ibm.com>
 <f0aa4cc7-03dd-5761-8cc5-ceeb834526f8@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <c87888b4-9ced-9255-e7e7-cb05219c9c21@linux.ibm.com>
Date:   Tue, 9 Feb 2021 17:42:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <f0aa4cc7-03dd-5761-8cc5-ceeb834526f8@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 phishscore=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/21 5:19 PM, Thomas Huth wrote:
> On 09/02/2021 17.14, Janosch Frank wrote:
>> On 2/9/21 5:08 PM, Claudio Imbrenda wrote:
>>> On Tue,  9 Feb 2021 09:15:54 -0500
>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>
>>>> KVM and QEMU handle a SIGP stop and store status in two steps:
>>>> 1) Stop the CPU by injecting a stop request
>>>> 2) Store when the CPU has left SIE because of the stop request
>>>>
>>>> The problem is that the SIGP order is already considered completed by
>>>> KVM/QEMU when step 1 has been performed and not once both have
>>>> completed. In addition we currently don't implement the busy CC so a
>>>> kernel has no way of knowing that the store has finished other than
>>>> checking the location for the store.
>>>>
>>>> This workaround is based on the fact that for a new SIE entry (via the
>>>> added smp restart) a stop with the store status has to be finished
>>>> first.
>>>>
>>>> Correct handling of this in KVM/QEMU will need some thought and time.
>>>
>>> do I understand correctly that you are here "fixing" the test by not
>>> triggering the KVM bug? Shouldn't we try to trigger as many bugs as
>>> possible instead?
>>
>> This is not a bug, it's missing code :-)
>>
>> We trigger a higher number of bugs by running tests and this workaround
>> does exactly that by letting Thomas use the smp test in the CI again.
> 
> Alternatively, we could use report_xfail here to make the test pass, but 
> still have the problem reported so that we do not forget to fix it later.
> 
>   Thomas
> 

I have no strong opinion on that although I'll need to have a look if
our CI flags XPASS/XFAIL as fails.
