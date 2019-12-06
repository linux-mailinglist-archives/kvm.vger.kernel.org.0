Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B52114B8B
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 05:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfLFECC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 23:02:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37812 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfLFECC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 23:02:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB63xHVP090189;
        Fri, 6 Dec 2019 04:01:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=QjnQE19WTon+84la9HnCRqMJCeiE7umqQsEPFc6WIaM=;
 b=V7Y36+AZUhKtJ2NqSVT07k0Uhsox2rlco1eouttc3CTSixPb35xcN8rEyWKk0HzOBWtF
 smGhbcmny6vwDcuH0WXzr/7V7gAu34ZP1hGKBgA47kWSvQS1LHDirKlzAIa2+1yfd+Iw
 lffibD960L0LHSfU9Bct/1OEqVYUDohC55EBk8e9qn1Rg1namAnz1a360vCjjaDy0oHT
 Ca/2malY//LJjPwrm+7UWLdb0BEG+B0kTfmNutbkeu5w4n76iYYgzNTIzRVI4E+3N+Vn
 spC+/mRYUP2i6jk0t2uwROBl+vYrZdNzNpThquiXic68DSbWeZT23mIUd9rrIXOsPe/9 wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wkh2rs7qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 04:01:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB63wKja136302;
        Fri, 6 Dec 2019 04:01:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wqer9stgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 04:01:24 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB641FNr008814;
        Fri, 6 Dec 2019 04:01:19 GMT
Received: from [10.159.153.56] (/10.159.153.56)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Dec 2019 20:01:15 -0800
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
References: <20191105161737.21395-1-vkuznets@redhat.com>
 <de3cade3-c069-dc6b-1d2d-aa10abe365b8@redhat.com>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <4f835a11-1528-a04e-9e06-1b8cdb97a04d@oracle.com>
Date:   Thu, 5 Dec 2019 20:01:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <de3cade3-c069-dc6b-1d2d-aa10abe365b8@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9462 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912060032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9462 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912060033
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-11-05 3:56 p.m., Paolo Bonzini wrote:
> On 05/11/19 17:17, Vitaly Kuznetsov wrote:
>> There is also one additional piece of the information missing. A VM can be
>> sharing physical cores with other VMs (or other userspace tasks on the
>> host) so does KVM_FEATURE_TRUSTWORTHY_SMT imply that it's not the case or
>> not? It is unclear if this changes anything and can probably be left out
>> of scope (just don't do that).
>>
>> Similar to the already existent 'NoNonArchitecturalCoreSharing' Hyper-V
>> enlightenment, the default value of KVM_HINTS_TRUSTWORTHY_SMT is set to
>> !cpu_smt_possible(). KVM userspace is thus supposed to pass it to guest's
>> CPUIDs in case it is '1' (meaning no SMT on the host at all) or do some
>> extra work (like CPU pinning and exposing the correct topology) before
>> passing '1' to the guest.
>>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>   Documentation/virt/kvm/cpuid.rst     | 27 +++++++++++++++++++--------
>>   arch/x86/include/uapi/asm/kvm_para.h |  2 ++
>>   arch/x86/kvm/cpuid.c                 |  7 ++++++-
>>   3 files changed, 27 insertions(+), 9 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
>> index 01b081f6e7ea..64b94103fc90 100644
>> --- a/Documentation/virt/kvm/cpuid.rst
>> +++ b/Documentation/virt/kvm/cpuid.rst
>> @@ -86,6 +86,10 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
>>                                                 before using paravirtualized
>>                                                 sched yield.
>>   
>> +KVM_FEATURE_TRUSTWORTHY_SMT       14          set when host supports 'SMT
>> +                                              topology is trustworthy' hint
>> +                                              (KVM_HINTS_TRUSTWORTHY_SMT).
>> +
> 
> Instead of defining a one-off bit, can we make:
> 
> ecx = the set of known "hints" (defaults to edx if zero)
> 
> edx = the set of hints that apply to the virtual machine
Just to resurrect this thread, the guest could explicitly ACK
a KVM_FEATURE_DYNAMIC_HINT at init. This would allow the host
to change the hints whenever with the guest not needing to separately
ACK the changed hints.


Ankur

> 
> Paolo
> 
6
