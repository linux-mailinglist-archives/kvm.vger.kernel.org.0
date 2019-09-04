Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA8DA900B
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389627AbfIDSHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 14:07:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50078 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388413AbfIDSHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 14:07:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x84I6miL013249;
        Wed, 4 Sep 2019 18:07:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kbqUtlKdJhb/qZW3xkP94Rkc50sC2FA36wdyAkQ0VHE=;
 b=iOgCYiXonnoqVXt97H03uACeDb0rj87eOqdqVBsom1mDgFS6Gh2aiL8lwilSax2fwIl1
 MXXFHFkWKtiKyvyR91SVmjMvcgHsxVtK6Rc5QyxgDydl+8OT2Z+tvvFr95jlqSSdr2GD
 6Tnf60huH8vJYxUoQoHbwVmvoEj1C5hzW5p9W1jRzhRA8uFD1W/giRRjXQzi/EQofNDM
 R6nP2NxXh5zoGRDQUNYmL7J1gMUu+xg6Idhlq7mvSewvYKoAlT06jEsp7MzZ1Lyr3iyh
 B05uXq1JdR49HK7XLQ2qLRkb1FASzZuD+UVNyrESwNT89hW2ryDOeMdlvlEZuLwPDAJN xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2utj8p0041-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 18:07:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x84I49hF083223;
        Wed, 4 Sep 2019 18:05:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2usu53f4y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 18:05:09 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x84I58V0008735;
        Wed, 4 Sep 2019 18:05:08 GMT
Received: from [10.159.229.95] (/10.159.229.95)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Sep 2019 11:05:08 -0700
Subject: Re: [PATCH 2/4] KVM: nVMX: Check GUEST_DR7 on vmentry of nested
 guests
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-3-krish.sadhukhan@oracle.com>
 <CALMp9eSekWEvvgwhMXWOtRZG1saQDOaKr+_4AacuM9JtH5guww@mail.gmail.com>
 <a4882749-a5cc-f8cd-4641-dd61314e6312@oracle.com>
 <CALMp9eTBPRT+Re9rZzmutAiy62qSMQRfMrnyiYkNHkCKDy-KPQ@mail.gmail.com>
 <CALMp9eRWSvg22JPUKOssOHwOq=uXn6GumXP1-LB2ZiYbd0N6bQ@mail.gmail.com>
 <e229bea2-acb2-e268-6281-d8e467c3282e@oracle.com>
 <CALMp9eTObQkBrKpN-e=ejD8E5w3WpbcNkXt2gJ46xboYwR+b7Q@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <e8a4477c-b3a9-b4e4-1283-99bdaf7aa29b@oracle.com>
Date:   Wed, 4 Sep 2019 11:05:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTObQkBrKpN-e=ejD8E5w3WpbcNkXt2gJ46xboYwR+b7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9370 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9370 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040181
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/4/19 9:44 AM, Jim Mattson wrote:
> On Tue, Sep 3, 2019 at 5:59 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>>
>>
>> On 09/01/2019 05:33 PM, Jim Mattson wrote:
>>
>> On Fri, Aug 30, 2019 at 4:15 PM Jim Mattson <jmattson@google.com> wrote:
>>
>> On Fri, Aug 30, 2019 at 4:07 PM Krish Sadhukhan
>> <krish.sadhukhan@oracle.com> wrote:
>>
>> On 08/29/2019 03:26 PM, Jim Mattson wrote:
>>
>> On Thu, Aug 29, 2019 at 2:25 PM Krish Sadhukhan
>> <krish.sadhukhan@oracle.com> wrote:
>>
>> According to section "Checks on Guest Control Registers, Debug Registers, and
>> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
>> of nested guests:
>>
>>       If the "load debug controls" VM-entry control is 1, bits 63:32 in the DR7
>>       field must be 0.
>>
>> Can't we just let the hardware check guest DR7? This results in
>> "VM-entry failure due to invalid guest state," right? And we just
>> reflect that to L1?
>>
>> Just trying to understand the reason why this particular check can be
>> deferred to the hardware.
>>
>> The vmcs02 field has the same value as the vmcs12 field, and the
>> physical CPU has the same requirements as the virtual CPU.
>>
>> Actually, you're right. There is a problem. With the current
>> implementation, there's a priority inversion if the vmcs12 contains
>> both illegal guest state for which the checks are deferred to
>> hardware, and illegal entries in the VM-entry MSR-load area. In this
>> case, we will synthesize a "VM-entry failure due to MSR loading"
>> rather than a "VM-entry failure due to invalid guest state."
>>
>> There are so many checks on guest state that it's really compelling to
>> defer as many as possible to hardware. However, we need to fix the
>> aforesaid priority inversion. Instead of returning early from
>> nested_vmx_enter_non_root_mode() with EXIT_REASON_MSR_LOAD_FAIL, we
>> could induce a "VM-entry failure due to MSR loading" for the next
>> VM-entry of vmcs02 and continue with the attempted vmcs02 VM-entry. If
>> hardware exits with EXIT_REASON_INVALID_STATE, we reflect that to L1,
>> and if hardware exits with EXIT_REASON_INVALID_STATE, we reflect that
>> to L1 (along with the appropriate exit qualification).
>>
>>
>> Looking at nested_vmx_exit_reflected(), it seems we do return to L1 if the error is EXIT_REASON_INVALID_STATE. So if we fix the priority inversion, this should work then ?
> Yes.
>
>> The tricky part is in undoing the successful MSR writes if we reflect
>> EXIT_REASON_INVALID_STATE to L1. Some MSR writes can't actually be
>> undone (e.g. writes to IA32_PRED_CMD), but maybe we can get away with
>> those. (Fortunately, it's illegal to put x2APIC MSRs in the VM-entry
>> MSR-load area!) Other MSR writes are just a bit tricky to undo (e.g.
>> writes to IA32_TIME_STAMP_COUNTER).
>>
>>
>> Let's say that the priority inversion issue is fixed. In the scenario in which the Guest state is fine but the VM-entry MSR-Load area contains an illegal entry,  you are saying that the induced "VM-entry failure due to MSR loading"  will be caught during the next VM-entry of vmcs02. So how far does the attempted VM-entry of vmcs02  continue with an illegal MSR-Load entry and how do get to the next VM-entry of vmcs02 ?
> Sorry; I don't understand the questions.


Let's say that all guest state checks are deferred to hardware and that 
they all will pass. Now, the VM-entry MSR-load area contains an illegal 
entry and we modify nested_vmx_enter_non_root_mode() to induce a 
"VM-entry failure due to MSR loading" for the next VM-entry of vmcs02. I 
wanted to understand how that induced error ultimately leads to a 
VM-entry failure ?


>> There are two other scenarios there:
>>
>>      1. Guest state is illegal and VM-entry MSR-Load area contains an illegal entry
>>      2. Guest state is illegal but VM-entry MSR-Load area is fine
>>
>> In these scenarios, L2 will exit to L1 with EXIT_REASON_INVALID_STATE and finally this will be returned to L1 userspace. Right ?  If so, we do we care about reverting MSR-writes  because the SDM section 26.8 say,
>>
>>          "Processor state is loaded as would be done on a VM exit (see Section 27.5)"
> I'm not sure how the referenced section of the SDM is relevant. Are
> you assuming that every MSR in the VM-entry MSR load area also appears
> in the VM-exit MSR load area? That certainly isn't the case.
>
>> Alternatively, we could perform validity checks on the entire vmcs12
>> VM-entry MSR-load area before writing any of the MSRs. This may be
>> easier, but it would certainly be slower. We would have to be wary of
>> situations where processing an earlier entry affects the validity of a
>> later entry. (If we take this route, then we would also have to
>> process the valid prefix of the VM-entry MSR-load area when we reflect
>> EXIT_REASON_MSR_LOAD_FAIL to L1.)
> Forget this paragraph. Even if all of the checks pass, we still have
> to undo all of the MSR-writes in the event of a deferred "VM-entry
> failure due to invalid guest state."
>
>> Note that this approach could be extended to permit the deferral of
>> some control field checks to hardware as well.
>>
>>
>> Why can't the first approach be used for VM-entry controls as well ?
> Sorry; I don't understand this question either.


Since you mentioned,

     "Note that this approach could be extended to permit the deferral 
of some control field checks..."

So it seemed that only the second approach was applicable to deferring 
VM-entry control checks to hardware. Hence I asked why the first 
approach can't be used.


>
>>   As long as the control
>> field is copied verbatim from vmcs12 to vmcs02 and the virtual CPU
>> enforces the same constraints as the physical CPU, deferral should be
>> fine. We just have to make sure that we induce a "VM-entry failure due
>> to invalid guest state" for the next VM-entry of vmcs02 if any
>> software checks on guest state fail, rather than immediately
>> synthesizing an "VM-entry failure due to invalid guest state" during
>> the construction of vmcs02.
>>
>>
>> Is it OK to keep this Guest check in software for now and then remove it once we have a solution in place ?
> Why do you feel that getting the priority correct is so important for
> this one check in particular? I'd be surprised if any hypervisor ever
> assembled a VMCS that failed this check.
