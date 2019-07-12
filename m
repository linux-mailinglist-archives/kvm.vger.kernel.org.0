Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D1267106
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 16:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfGLOKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 10:10:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52666 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfGLOKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 10:10:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CE40ia193220;
        Fri, 12 Jul 2019 14:07:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=F9vHBH7bxmfd3Exz2+DCAGo6VowZreYVT2luGWbO36Y=;
 b=L5+C7PJ+i6ErZ4mGphNpwQlPmp+REhtMGAXURHDX5SzsguYSI72Cqr3ux4zQv9qGTnaE
 RSBPNqCIlsGokpDHQp6+PhOOTbe0ykqvNSXDx3SKiTPRWvlLhvKYJbi4TLUYp+oHq9hF
 aSH7VG8rW77iuM2l+rqt/bJdhYK/nKGBYADD8HAbYuCzFxqT+zRtl/GgdgD9PBmtYJRZ
 m6GnZ+Gi2W+xJWZLJlATm6bN0GcH6+MRzlGj98/20EfmQ1X7YWLIDRkUBoF76itBoCbz
 Fu8yQQj4pNOM5OuX77+tY4s+1pb9yXTE/gQE+WXjNTfwCJCqXaiMlxsLMGmbDkdIx6gQ gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2tjkkq5tfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 14:07:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CE3O8b129756;
        Fri, 12 Jul 2019 14:07:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tn1j25tg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 14:07:11 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6CE78ZA022867;
        Fri, 12 Jul 2019 14:07:09 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Jul 2019 07:06:38 -0700
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
To:     Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com>
 <2791712a-9f7b-18bc-e686-653181461428@oracle.com>
 <dbbf6b05-14b6-d184-76f2-8d4da80cec75@intel.com>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <bfd62213-c7c0-4a90-b377-0de7d9557c4c@oracle.com>
Date:   Fri, 12 Jul 2019 16:06:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <dbbf6b05-14b6-d184-76f2-8d4da80cec75@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120153
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/12/19 3:51 PM, Dave Hansen wrote:
> On 7/12/19 1:09 AM, Alexandre Chartre wrote:
>> On 7/12/19 12:38 AM, Dave Hansen wrote:
>>> I don't see the per-cpu areas in here.  But, the ASI macros in
>>> entry_64.S (and asi_start_abort()) use per-cpu data.
>>
>> We don't map all per-cpu areas, but only the per-cpu variables we need. ASI
>> code uses the per-cpu cpu_asi_session variable which is mapped when an ASI
>> is created (see patch 15/26):
> 
> No fair!  I had per-cpu variables just for PTI at some point and had to
> give them up! ;)
> 
>> +    /*
>> +     * Map the percpu ASI sessions. This is used by interrupt handlers
>> +     * to figure out if we have entered isolation and switch back to
>> +     * the kernel address space.
>> +     */
>> +    err = ASI_MAP_CPUVAR(asi, cpu_asi_session);
>> +    if (err)
>> +        return err;
>>
>>
>>> Also, this stuff seems to do naughty stuff (calling C code, touching
>>> per-cpu data) before the PTI CR3 writes have been done.  But, I don't
>>> see anything excluding PTI and this code from coexisting.
>>
>> My understanding is that PTI CR3 writes only happens when switching to/from
>> userland. While ASI enter/exit/abort happens while we are already in the
>> kernel,
>> so asi_start_abort() is not called when coming from userland and so not
>> interacting with PTI.
> 
> OK, that makes sense.  You only need to call C code when interrupted
> from something in the kernel (deeper than the entry code), and those
> were already running kernel C code anyway.
> 

Exactly.

> If this continues to live in the entry code, I think you have a good
> clue where to start commenting.

Yeah, lot of writing to do... :-)
  
> BTW, the PTI CR3 writes are not *strictly* about the interrupt coming
> from user vs. kernel.  It's tricky because there's a window both in the
> entry and exit code where you are in the kernel but have a userspace CR3
> value.  You end up needing a CR3 write when you have a userspace CR3
> value when the interrupt occurred, not only when you interrupt userspace
> itself.
> 

Right. ASI is simpler because it comes from the kernel and return to the
kernel. There's just a small window (on entry) where we have the ASI CR3
but we quickly switch to the full kernel CR3.

alex.
