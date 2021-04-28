Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A7336D4EB
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 11:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237915AbhD1Jo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 05:44:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23824 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230032AbhD1Jo1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 05:44:27 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13S9ZDwr051198;
        Wed, 28 Apr 2021 05:43:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hJ4fm10qSmUbQx0QNf2CKKbZbbiE7SHjxfgTeXNiJT4=;
 b=ksWdTqgqiTypWulUiVMoV0hUhOed6od2mJs0gFH4H6B7bIBzrscLpCSkJ66jWq2RbMOI
 FVRVN6uE/dul0RVTc8fkOUWNacjY+tHbAo6cEw1QLMQhGcnkLmiss5tz2BrrRFEzYDcn
 i495ZH1hgi+fMdso8aOILMOOaJ445gu8FY53xXhKF5erfLIDAB1K3XVvi83xJpDP5vnk
 Wen+v3fAZ1CPhoC0/d6QSZP428jLin0GyA63MTytf/0kJwnznPBgPgXUSD39eOV5qPVr
 dKds4aQqI55wumSEnvicKt0asFwz7OGkr4yryLy/q/K1B/kDrA77I1spTWLUz2V1VUHx Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3874rbh6jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 05:43:05 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13S9ZWNE052305;
        Wed, 28 Apr 2021 05:43:05 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3874rbh6gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 05:43:04 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13S9Rsan014762;
        Wed, 28 Apr 2021 09:43:01 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 384akh9t0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 09:43:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13S9gwOp27328874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Apr 2021 09:42:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B7D34C058;
        Wed, 28 Apr 2021 09:42:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B75EA4C046;
        Wed, 28 Apr 2021 09:42:57 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.77.184])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Apr 2021 09:42:57 +0000 (GMT)
Subject: Re: sched: Move SCHED_DEBUG sysctl to debugfs
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     bristot@redhat.com, bsegall@google.com, dietmar.eggemann@arm.com,
        greg@kroah.com, gregkh@linuxfoundation.org, joshdon@google.com,
        juri.lelli@redhat.com, linux-kernel@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        rostedt@goodmis.org, valentin.schneider@arm.com,
        vincent.guittot@linaro.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210412102001.287610138@infradead.org>
 <20210427145925.5246-1-borntraeger@de.ibm.com>
 <YIkgzUWEPaXQTCOv@hirez.programming.kicks-ass.net>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <da373590-f0d7-e3a2-cef9-4527fc9f3056@de.ibm.com>
Date:   Wed, 28 Apr 2021 11:42:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YIkgzUWEPaXQTCOv@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PyXbuBWVM482jVdeQbSsfmd6tzxziNh_
X-Proofpoint-GUID: djE4eMa3yGFYgmAh-pNPbb-NDwd3AfuR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-28_03:2021-04-27,2021-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28.04.21 10:46, Peter Zijlstra wrote:
[..]
> The right thing to do here is to analyze the situation and determine why
> migration_cost needs changing; is that an architectural thing, does s390
> benefit from less sticky tasks due to its cache setup (the book caches
> could be absorbing some of the penalties here for example). Or is it
> something that's workload related, does KVM intrinsically not care about
> migrating so much, or is it something else.

So lets focus on the performance issue.

One workload where we have seen this is transactional workload that is
triggered by external network requests. So every external request
triggered a wakup of a guest and a wakeup of a process in the guest.
The end result was that KVM was 40% slower than z/VM (in terms of
transactions per second) while we had more idle time.
With smaller sched_migration_cost_ns (e.g. 100000) KVM was as fast
as z/VM.

So to me it looks like that the wakeup and reschedule to a free CPU
was just not fast enough. It might also depend where I/O interrupts
land. Not sure yet.

