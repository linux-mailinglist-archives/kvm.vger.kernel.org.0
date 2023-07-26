Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912C4763F53
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 21:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjGZTQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 15:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjGZTQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 15:16:07 -0400
Received: from newman.cs.utexas.edu (newman.cs.utexas.edu [128.83.139.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F258D2719
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 12:16:03 -0700 (PDT)
X-AuthUser: ysohail
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
        s=default; t=1690398961;
        bh=d9AHuy6GF4k2dbeYTPVke4RlDooCQdQSYfKs+mOspVk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Zk+MxWZxZ/23oNaAMmiyheE+n3JcJfx7pDhas4aQS7YsuL6iuMg3zp0nL6oMafNLu
         WnEEm0KBtQnCgm6qi17dR1tXVnnvMEvXx5RNTx0kL63UKBy5K5ucTjVSB7VsQWlFx5
         WyxU17ztzER5JVMTikcGfQq2kjAnSUzu4ot+HMfU=
Received: from [192.168.0.202] (71-138-92-128.lightspeed.hstntx.sbcglobal.net [71.138.92.128])
        (authenticated bits=0)
        by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id 36QJG0jC023258
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Jul 2023 14:16:01 -0500
Message-ID: <27f998f5-748b-c356-9bb6-813573c758e5@cs.utexas.edu>
Date:   Wed, 26 Jul 2023 14:16:00 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: KVM_EXIT_FAIL_ENTRY with hardware_entry_failure_reason = 7
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <7b5f626c-9f48-15e2-8f7a-1178941db048@cs.utexas.edu>
 <ZMFVLiC3YvPY3bSP@google.com>
Content-Language: en-US
From:   Yahya Sohail <ysohail@cs.utexas.edu>
In-Reply-To: <ZMFVLiC3YvPY3bSP@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Wed, 26 Jul 2023 14:16:01 -0500 (CDT)
X-Virus-Scanned: clamav-milter 0.103.8 at newman
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/23 12:17, Sean Christopherson wrote:
>> If so, what fields in the kvm_run struct should I check that could cause such
>> an issue?
> 
> Heh, all of them.  I'm only somewhat joking.  Root causing "invalid control field"
> errors on bare metal is painfully difficult, bordering on impossible if you don't
> have something to give you a hint as to what might be going wrong.

I suppose that's what I was expecting, but was hoping it could be 
narrowed down a bit. Could the values of the CPU control registers or 
other special registers set with KVM_SET_SREGS also cause this error 
(with hardware_entry_failure_reason = 7)? I'd expect this not to be 
possible because I don't think the CPU registers are part of the VMCS, 
but I'm not very familiar with VMX.

I do know that the emulator I'm copying state from likely doesn't 
consider all bits in the control fields, so it's possible that they're 
in an invalid state. When I ran the model before with the value for cr0 
copied out of the emulator I also got KVM_EXIT_FAIL_ENTRY, but with a 
different value for hardware_entry_failure_reason = 0x80000021. I fixed 
this by changing the value of cr0 to be (hopefully) valid.

> If you can, try running a nested setup, i.e. run a normal Linux guest as your L1
> VM (L0 is bare metal), and then run your problematic x86 emulator VM within that
> L1 guest (that's your L2).  Then, in L0 (your bare metal host), enable the
> kvm_nested_vmenter_failed tracepoint.
> 
> The kvm_nested_vmenter_failed tracepoint logs all VM-Enter failures that _KVM_
> detects when L1 attempts a nested VM-Enter from L1 to L2.  If you're at all lucky,
> KVM in L0 (acting a the CPU from L1's perspective) will detect the invalid state
> and explicitly log which consistency check failed.

I did this and had an interesting result. Instead of exiting with 
KVM_EXIT_FAIL_ENTRY, it exited with KVM_EXIT_UNkNOWN, and 
hardware_exit_reason = 0. I also didn't get anything logged from the 
kvm_nested_vmenter_failed trace point. When I checked the value of rip 
after KVM_RUN, it was the same as the starting value, so it probably 
failed without executing any instructions.

I then tried setting the kvm_nested_vmexit tracepoint to see if I could 
get any more information about the vmexit. When the vmexit occurred, I 
got a line in the log that looked like this:

CPU 3/KVM-9310    [013] ....  6076.453278: kvm_nested_vmexit: vcpu 3 
reason EPT_VIOLATION rip 0x103c00 info1 0x0000000000000781 info2 
0x000000008000030d intr_info 0x00000000 error_code 0x00000000

It appears this occurred due to an EPT_VIOLATION. I have some questions:
I believe an EPT_VIOLATION is caused by trying to access physical memory 
that is not mapped. Is that correct? Also, could this be the same error 
that causes the KVM_EXIT_FAIL_ENTRY when running the VM as L1, or must 
that be a separate issue?

I know that the paging code of the emulator the state is from is a 
little suspect (in fact, one of my reasons to get this VM working in KVM 
is to help debug the emulator), and it is possible that the page tables 
of the VM are not setup properly and are mapping linear addresses to 
unexpected physical addresses and causing an EPT_VIOLATION. I'll have to 
look into that further.

Thanks for the help,
Yahya Sohail
