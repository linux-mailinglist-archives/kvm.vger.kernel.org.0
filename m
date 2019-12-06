Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D18115835
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 21:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfLFUb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 15:31:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47908 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbfLFUb0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 15:31:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6KTUCc140204;
        Fri, 6 Dec 2019 20:31:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4nf1xKRn/USEHl15TdqwrDmyONfL6v+Du/F1d+Pr7+A=;
 b=Is/2io88nqEO+7vVxnk1NivaVaTP/E03UwABfCBvwkLELnLoOD2RXb32A7NRCF9DG5Lv
 irxff3HSlunuvSCKhFflOq3ymHv7Rs3cJMJ2gYXOUE5jQ07h+yQ/SQDI8xxGXttlUWBx
 MOpPDfpw+z2Pkstcvr3LXWwnQeEPosvRJtWcmYylPmYTDxfh3I1dcsMG0IbuPHAeW+sz
 xDX1BVr/63MTFcAf6QG69afDinjxkKTMTXuo21zEd5MMeL9YFTfKFPfp2KWgvWW3ZhBK
 iGGdX990wNjburHJU6545Zj3aYK2jjBHDcYX6pxcTX6tYq+LhU19xrUP05H2tNpAjT8T Lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wkfuuxdmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 20:31:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6KTTUA194845;
        Fri, 6 Dec 2019 20:31:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wqt45bap0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 20:31:02 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB6KUqJc024064;
        Fri, 6 Dec 2019 20:30:58 GMT
Received: from [10.156.74.184] (/10.156.74.184)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Dec 2019 12:30:52 -0800
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20191105161737.21395-1-vkuznets@redhat.com>
 <de3cade3-c069-dc6b-1d2d-aa10abe365b8@redhat.com>
 <4f835a11-1528-a04e-9e06-1b8cdb97a04d@oracle.com>
 <87wob9d0t3.fsf@vitty.brq.redhat.com>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <2e16b707-f020-22a3-a618-4960db917dfa@oracle.com>
Date:   Fri, 6 Dec 2019 12:31:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <87wob9d0t3.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912060164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912060164
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/6/19 5:46 AM, Vitaly Kuznetsov wrote:
> Ankur Arora <ankur.a.arora@oracle.com> writes:
> 
>> On 2019-11-05 3:56 p.m., Paolo Bonzini wrote:
>>> On 05/11/19 17:17, Vitaly Kuznetsov wrote:
>>>> There is also one additional piece of the information missing. A VM can be
>>>> sharing physical cores with other VMs (or other userspace tasks on the
>>>> host) so does KVM_FEATURE_TRUSTWORTHY_SMT imply that it's not the case or
>>>> not? It is unclear if this changes anything and can probably be left out
>>>> of scope (just don't do that).
>>>>
>>>> Similar to the already existent 'NoNonArchitecturalCoreSharing' Hyper-V
>>>> enlightenment, the default value of KVM_HINTS_TRUSTWORTHY_SMT is set to
>>>> !cpu_smt_possible(). KVM userspace is thus supposed to pass it to guest's
>>>> CPUIDs in case it is '1' (meaning no SMT on the host at all) or do some
>>>> extra work (like CPU pinning and exposing the correct topology) before
>>>> passing '1' to the guest.
>>>>
>>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>>> ---
>>>>    Documentation/virt/kvm/cpuid.rst     | 27 +++++++++++++++++++--------
>>>>    arch/x86/include/uapi/asm/kvm_para.h |  2 ++
>>>>    arch/x86/kvm/cpuid.c                 |  7 ++++++-
>>>>    3 files changed, 27 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
>>>> index 01b081f6e7ea..64b94103fc90 100644
>>>> --- a/Documentation/virt/kvm/cpuid.rst
>>>> +++ b/Documentation/virt/kvm/cpuid.rst
>>>> @@ -86,6 +86,10 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
>>>>                                                  before using paravirtualized
>>>>                                                  sched yield.
>>>>    
>>>> +KVM_FEATURE_TRUSTWORTHY_SMT       14          set when host supports 'SMT
>>>> +                                              topology is trustworthy' hint
>>>> +                                              (KVM_HINTS_TRUSTWORTHY_SMT).
>>>> +
>>>
>>> Instead of defining a one-off bit, can we make:
>>>
>>> ecx = the set of known "hints" (defaults to edx if zero)
>>>
>>> edx = the set of hints that apply to the virtual machine
>>>
>> Just to resurrect this thread, the guest could explicitly ACK
>> a KVM_FEATURE_DYNAMIC_HINT at init. This would allow the host
>> to change the hints whenever with the guest not needing to separately
>> ACK the changed hints.
> 
> (I apologize for dropping the ball on this, I'm intended to do RFCv2 in
> a nearby future)
> 
> Regarding this particular hint (let's call it 'no nonarchitectural
> coresharing' for now) I don't see much value in communicating change to
> guest when it happens. Imagine our host for some reason is not able to
> guarantee that anymore e.g. we've migrated to a host with less pCPUs
> and/or special restrictions and have to start sharing. What we, as a
> guest, are supposed to do when we receive a notification? "You're now
> insecure, deal with it!" :-) Equally, I don't see much value in
> pre-acking such change. "I'm fine with becoming insecure at some point".
True, for that use-case pre-ACK seems like exactly the thing you would
not want.
I do see some value in the guest receiving the notification though.
Maybe it could print a big fat printk or something :). Or, it could
change to a different security-policy-that-I-just-made-up.


> If we, however, discuss other hints such 'pre-ACK' mechanism may make
> sense, however, I'd make it an option to a 'challenge/response'
> protocol: if host wants to change a hint it notifies the guest and waits
> for an ACK from it (e.g. a pair of MSRs + an interrupt). I, however,
My main reason for this 'pre-ACK' approach is some discomfort with
changing the CPUID edx from under the guest.

The MSR+interrupt approach would work as well but then we have the
same set of hints spread across CPUID and the MSR. What do you think
is the right handling for a guest that refuses to ACK the MSR?

> have no good candidate from the existing hints which would require guest
> to ACK (e.g revoking PV EOI would probably do but why would we do that?)
> As I said before, challenge/response protocol is needed if we'd like to
> make TSC frequency change the way Hyper-V does it (required for updating
> guest TSC pages in nested case) but this is less and less important with
> the appearance of TSC scaling. I'm still not sure if this is an
> over-engineering or not. We can wait for the first good candidate to
> decide.
As we've discussed offlist, the particular hint I'm interested in is
KVM_HINT_REALTIME. That's not a particularly good candidate though
because there's no correctness problem if the host does switch it
off suddenly.


Ankur
