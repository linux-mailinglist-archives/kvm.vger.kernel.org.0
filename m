Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1236F123AB6
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 00:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfLQXVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 18:21:49 -0500
Received: from h4.fbrelay.privateemail.com ([131.153.2.45]:48270 "EHLO
        h4.fbrelay.privateemail.com." rhost-flags-OK-OK-FAIL-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbfLQXVt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Dec 2019 18:21:49 -0500
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2019 18:21:49 EST
Received: from MTA-10-1.privateemail.com (mta-10.privateemail.com [68.65.122.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id 5C3C2808C6
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 18:14:00 -0500 (EST)
Received: from MTA-10.privateemail.com (localhost [127.0.0.1])
        by MTA-10.privateemail.com (Postfix) with ESMTP id 80BAB6004E;
        Tue, 17 Dec 2019 18:13:59 -0500 (EST)
Received: from zetta.local (unknown [10.20.151.204])
        by MTA-10.privateemail.com (Postfix) with ESMTPA id E651360048;
        Tue, 17 Dec 2019 23:13:58 +0000 (UTC)
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Bonzini, Paolo" <pbonzini@redhat.com>
References: <20191120181913.GA11521@linux.intel.com>
 <7F99D4CD-272D-43FD-9CEE-E45C0F7C7910@djy.llc>
 <20191120192843.GA2341@linux.intel.com>
 <20191127152409.GC18530@linux.intel.com>
 <20191217231133.GG11771@linux.intel.com>
From:   Derek Yerger <derek@djy.llc>
Message-ID: <fbb1354f-6f07-eb59-4da3-0a7e54471cea@djy.llc>
Date:   Tue, 17 Dec 2019 18:13:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191217231133.GG11771@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/19 6:11 PM, Sean Christopherson wrote:
> On Wed, Nov 27, 2019 at 07:24:09AM -0800, Sean Christopherson wrote:
>> On Wed, Nov 20, 2019 at 11:28:43AM -0800, Sean Christopherson wrote:
>>> On Wed, Nov 20, 2019 at 02:04:38PM -0500, Derek Yerger wrote:
>>>>> Debug patch attached.  Hopefully it finds something, it took me an
>>>>> embarassing number of attempts to get correct, I kept screwing up checking
>>>>> a bit number versus checking a bit mask...
>>>>> <0001-thread_info-Add-a-debug-hook-to-detect-FPU-changes-w.patch>
>>>> Should this still be tested despite Wanpeng Li’s comments that the issue may
>>>> have been fixed in a 5.3 release candidate?
>>> Yes.
>>>
>>> The actual bug fix, commit e751732486eb3 (KVM: X86: Fix fpu state crash in
>>> kvm guest), is present in v5.2.7.
>>>
>>> Unless there's a subtlety I'm missing, commit d9a710e5fc4941 (KVM: X86:
>>> Dynamically allocate user_fpu) is purely an optimization and should not
>>> have a functional impact.
> Any update on this?  Syzkaller also appears to be hitting this[*], but it
> hasn't been able to generate a reproducer.
>
> [*] https://syzkaller.appspot.com/bug?extid=00be5da1d75f1cc95f6b
I have the kernel built and ready to test. I need the guest VM in a functioning 
state this week, so I can't test yet. I will post results as soon as they're 
available.
>
>> ---
>>
>> Any chance the below change fixes your issue?  It's a bug fix for AVX
>> corruption during signal delivery[*].  It doesn't seem like the same thing
>> you are seeing, but it's worth trying.
>>
>> [*] https://lkml.kernel.org/r/20191127124243.u74osvlkhcmsskng@linutronix.de/
>>
>>   arch/x86/include/asm/fpu/internal.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
>> index 4c95c365058aa..44c48e34d7994 100644
>> --- a/arch/x86/include/asm/fpu/internal.h
>> +++ b/arch/x86/include/asm/fpu/internal.h
>> @@ -509,7 +509,7 @@ static inline void __fpu_invalidate_fpregs_state(struct fpu *fpu)
>>   
>>   static inline int fpregs_state_valid(struct fpu *fpu, unsigned int cpu)
>>   {
>> -	return fpu == this_cpu_read_stable(fpu_fpregs_owner_ctx) && cpu == fpu->last_cpu;
>> +	return fpu == this_cpu_read(fpu_fpregs_owner_ctx) && cpu == fpu->last_cpu;
>>   }

