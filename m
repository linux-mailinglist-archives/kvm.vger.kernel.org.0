Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837257641F1
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 00:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjGZWOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 18:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjGZWOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 18:14:35 -0400
Received: from newman.cs.utexas.edu (newman.cs.utexas.edu [128.83.139.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DF7270B
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 15:14:33 -0700 (PDT)
X-AuthUser: ysohail
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
        s=default; t=1690409672;
        bh=TN0K42pgxyYl3QSSiQZ/d0Jk93RMHHVqklzwWDaL9ns=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hz5WezY1ZVfbBBcKhtk4ZjQPeYrrxNFt7Tqcqv9lSqZJqfWmn7aUXl9etvCyNEotH
         QZEIUpKiFR4AiZ8BGzjraUow0VOtexpdUVIdXiGTSD9QGSF8+ovrF9MZ4VyQwppGW/
         IXeL3jZwRXTK6Voc8R0iB6N3pYJ+kwAlX+fiLL7c=
Received: from [192.168.0.202] (71-138-92-128.lightspeed.hstntx.sbcglobal.net [71.138.92.128])
        (authenticated bits=0)
        by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id 36QMEVFb035062
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Jul 2023 17:14:31 -0500
Message-ID: <7d4a5084-5e1e-22dd-c203-99f46850145a@cs.utexas.edu>
Date:   Wed, 26 Jul 2023 17:14:31 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: KVM_EXIT_FAIL_ENTRY with hardware_entry_failure_reason = 7
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <7b5f626c-9f48-15e2-8f7a-1178941db048@cs.utexas.edu>
 <ZMFVLiC3YvPY3bSP@google.com>
 <27f998f5-748b-c356-9bb6-813573c758e5@cs.utexas.edu>
 <ZMF5O6Tq1UTQHvX0@google.com>
From:   Yahya Sohail <ysohail@cs.utexas.edu>
In-Reply-To: <ZMF5O6Tq1UTQHvX0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Wed, 26 Jul 2023 17:14:32 -0500 (CDT)
X-Virus-Scanned: clamav-milter 0.103.8 at newman
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/23 14:51, Sean Christopherson wrote:
> On Wed, Jul 26, 2023, Yahya Sohail wrote:
>> On 7/26/23 12:17, Sean Christopherson wrote:
>> I do know that the emulator I'm copying state from likely doesn't consider
>> all bits in the control fields, so it's possible that they're in an invalid
>> state. When I ran the model before with the value for cr0 copied out of the
>> emulator I also got KVM_EXIT_FAIL_ENTRY, but with a different value for
>> hardware_entry_failure_reason = 0x80000021. I fixed this by changing the
>> value of cr0 to be (hopefully) valid.
> 
> What were the before and after values of CR0?

Before, CR0 was 0x80000000. It appears the paging bit was not set even 
after I "fixed" cr0. I have now made sure the paging bit and the fixed 
bits are properly set in CR0. CR0 is now equal to 0x8393870b and I get 
VM_EXIT_FAIL_ENTRY with hardware_entry_failure_reason = 0x80000021 
whether I run it as L1 or L2.

I'm also now getting this tracepoint log on my L0 when I run the VM as L2:
CPU 12/KVM-9319    [014] .... 17072.747744: kvm_nested_vmexit: vcpu 12 
reason INVALID_STATE FAILED_VMENTRY rip 0x103c00 info1 
0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 
error_code 0x00000000

>>> If you can, try running a nested setup, i.e. run a normal Linux guest as your L1
>>> VM (L0 is bare metal), and then run your problematic x86 emulator VM within that
>>> L1 guest (that's your L2).  Then, in L0 (your bare metal host), enable the
>>> kvm_nested_vmenter_failed tracepoint.
>>>
>>> The kvm_nested_vmenter_failed tracepoint logs all VM-Enter failures that _KVM_
>>> detects when L1 attempts a nested VM-Enter from L1 to L2.  If you're at all lucky,
>>> KVM in L0 (acting a the CPU from L1's perspective) will detect the invalid state
>>> and explicitly log which consistency check failed.
>>
>> I did this and had an interesting result. Instead of exiting with
>> KVM_EXIT_FAIL_ENTRY, it exited with KVM_EXIT_UNkNOWN, and
>> hardware_exit_reason = 0.
> 
> Hrm, what kernel version are you running as L1?  KVM on x86 doesn't explicitly
> return KVM_EXIT_UNKNOWN except in a few paths that I highly doubt you are hitting.
> 
>> I also didn't get anything logged from the kvm_nested_vmenter_failed trace
>> point. When I checked the value of rip after KVM_RUN, it was the same as the
>> starting value, so it probably failed without executing any instructions.
>>
>> I then tried setting the kvm_nested_vmexit tracepoint to see if I could get
>> any more information about the vmexit. When the vmexit occurred, I got a
>> line in the log that looked like this:
>>
>> CPU 3/KVM-9310    [013] ....  6076.453278: kvm_nested_vmexit: vcpu 3 reason
>> EPT_VIOLATION rip 0x103c00 info1 0x0000000000000781 info2 0x000000008000030d
>> intr_info 0x00000000 error_code 0x00000000
> 
> So getting an EPT violation VM-Exit means the VM-Entry was successful.  Are you
> running different kernel versions for L0 versus L1?  If so, it's possible that
> there's a bug (or bug fix) in one kernel and not the other.

My L0 is on 5.10.186, and L1 is on 6.1.30.

>> It appears this occurred due to an EPT_VIOLATION. I have some questions:
>> I believe an EPT_VIOLATION is caused by trying to access physical memory
>> that is not mapped. Is that correct?
> 
> Yep.  The "info1 0x0000000000000781" from above is the EXIT_QUALIFICATION field,
> which for EPT violations is equivalent to a #PF error code.  0x781 means a read
> access faulted and the mapping was !present, e.g. as opposed to the mapping
> being !readable (EPT supports execute-only mappings).
> 
> The other interesting bit is "info 0x000000008000030d", which is the vectoring
> info.  That value means that the EPT violation occurred while the CPU was trying
> to deliver a #GP in the guest.  In and of itself, that isn't fatal, but it does
> suggest that something might be going wrong in the emulator.

The state the VM is in is supposed to be the beginning of Linux boot 
(i.e. the bootloader has just jumped into the Linux entrypoint). Thus, 
the IDT is not yet setup, so I would expect there to be some errors if 
the CPU attempted to deliver a #GP to the guest.

>> Also, could this be the same error that causes the KVM_EXIT_FAIL_ENTRY when
>> running the VM as L1, or must that be a separate issue?
> 
> Maybe?  EPT violations themselves are not errors (ignore the "violation" part,
> it's not as scary as it sounds).  But if the exit to userspace is related to the
> EPT violation, I would expect uuuKVM_EXIT_MMIO, not KVM_EXIT_UNKNOWN.
> 
>> I know that the paging code of the emulator the state is from is a little
>> suspect (in fact, one of my reasons to get this VM working in KVM is to help
>> debug the emulator), and it is possible that the page tables of the VM are
>> not setup properly and are mapping linear addresses to unexpected physical
>> addresses and causing an EPT_VIOLATION. I'll have to look into that further.

I thought the EPT violation occurred when fetching the instruction, but 
if I use KVM_TRANSLATE to translate RIP into a physical address, it 
appears to translate it to the physical address I'd expect (and one 
which should be mapped). Given that the RIP address translates correctly 
in KVM, I don't think the paging system of the emulator is to blame for 
the issue.

> Turn on the kvm_page_fault tracepoint, that will give the gpa on which the fault
> occurs.

Prior to my new fix for CR0, in the log after enabling this trace point, 
I saw there was a page fault for reading the address 0x34 because it was 
not present. I think this was because the IDT address was set to 0, and 
the interrupt gate for a #GP would therefore be at address 0x34.

It seems the reason for getting a hardware_entry_failure_reason = 7 when 
running the VM as L1 was the same as the reason for getting a #GP when 
running the VM as L2. CR0 was invalid, and that caused a 
KVM_EXIT_FAIL_ENTRY when running as L1 and a #GP when running as L2. In 
the latter case, that lead to a page fault because the IDT was not yet 
present.

That being said, I'm still not sure how to go about debugging the 
VM_EXIT_FAIL_ENTRY with hardware_entry_failure_reason = 0x80000021. The 
entry in the tracepoint log (see above) of L0 (when running the VM as 
L2) does not seem to be very helpful (unlike the invalid CR0 messages I 
got before when CR0 was invalid). Is there any more information that can 
be gleaned from this log entry? Any other way to get more information as 
to what piece of state is invalid?

Thanks,
Yahya Sohail
