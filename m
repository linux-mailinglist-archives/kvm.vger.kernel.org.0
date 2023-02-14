Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BC3696E86
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 21:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjBNU1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 15:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBNU1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 15:27:33 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39B431F4BD;
        Tue, 14 Feb 2023 12:27:32 -0800 (PST)
Received: from [192.168.2.1] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id 73C8020E61A8;
        Tue, 14 Feb 2023 12:27:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 73C8020E61A8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1676406451;
        bh=rOqM1HFumqofo+SZahw5/IduCPNn1tyaSUwoU/GT9kc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fIyH1pr7mrT7SFj1vT7IF5Bvy6WRHAxdiIaS4n7Da54Ad4YVROj5Aa00J8rwudFdL
         aNkcHaOBxHDsCauz2UQq0E9hqfetWOpkeVATZEM1IWqB6IW1G5czQ89ikFg+cGmddW
         NUvjSZmFIpfgF2Vo2fKA7iu8IkskB2fymP1NxZnw=
Message-ID: <20d189fc-8d20-8083-b448-460cc0420151@linux.microsoft.com>
Date:   Tue, 14 Feb 2023 21:27:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: "KVM: x86/mmu: Overhaul TDP MMU zapping and flushing" breaks SVM
 on Hyper-V
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tianyu Lan <ltykernel@gmail.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
References: <43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com>
 <Y+p1j7tYT+16MX6B@google.com>
 <35ff8f48-2677-78ea-b5f3-329c75ce65c9@redhat.com>
 <Y+qLe42h9ZPRINrG@google.com>
 <CABgObfaZQOvt6v0yGz3MR7FBU7DcrTTGmS6M8RWCX0uy6WML1Q@mail.gmail.com>
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <CABgObfaZQOvt6v0yGz3MR7FBU7DcrTTGmS6M8RWCX0uy6WML1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-20.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13/02/2023 20:56, Paolo Bonzini wrote:
> On Mon, Feb 13, 2023 at 8:12 PM Sean Christopherson <seanjc@google.com> wrote:
>>> My reading of the spec[1] is that HV_X64_NESTED_ENLIGHTENED_TLB will cause
>>> svm_flush_tlb_current to behave (in Intel parlance) as an INVVPID rather
>>> than an INVEPT.
>>
>> Oh!  Good catch!  Yeah, that'll be a problem.
>>
>>> So svm_flush_tlb_current has to be changed to also add a
>>> call to HvCallFlushGuestPhysicalAddressSpace.  I'm not sure if that's a good
>>> idea though.
>>
>> That's not strictly necessary, e.g. flushes from kvm_invalidate_pcid() and
>> kvm_post_set_cr4() don't need to effect a full flush.  I believe the virtual
>> address flush is also sufficient for avic_activate_vmcb().  Nested (from KVM's
>> perspective, i.e. running L3) can just be mutually exclusive with
>> HV_X64_NESTED_ENLIGHTENED_TLB.
>>
>> That just leaves kvm_mmu_new_pgd()'s force_flush_and_sync_on_reuse and the
>> aforementioned kvm_mmu_load().
>>
>> That said, the above cases where a virtual address flush is sufficient are
>> rare operations when using NPT, so adding a new KVM_REQ_TLB_FLUSH_ROOT or
>> whatever probably isn't worth doing.
>>
>>> First, that's a TLB shootdown rather than just a local thing;
>>> flush_tlb_current is supposed to be relatively cheap, and there would be a
>>> lot of them because of the unconditional calls to
>>> nested_svm_transition_tlb_flush on vmentry/vmexit.
>>
>> This isn't a nested scenario for KVM though.
> 
> Yes, but svm_flush_tlb_current() *is* also used in nested scenarios so
> it's like you said below---you would have to disable enlightened TLB
> when EFER.SVME=1 or something like that.
> 
>>> Depending on the performance results of adding the hypercall to
>>> svm_flush_tlb_current, the fix could indeed be to just disable usage of
>>> HV_X64_NESTED_ENLIGHTENED_TLB.
>>
>> Minus making nested SVM (L3) mutually exclusive, I believe this will do the trick:
>>
>> +       /* blah blah blah */
>> +       hv_flush_tlb_current(vcpu);
>> +
> 
> Yes, it's either this or disabling the feature.
> 
> Paolo

Combining the two sub-threads: both of the suggestions:

a) adding a hyperv_flush_guest_mapping(__pa(root->spt) after kvm_tdp_mmu_get_vcpu_root_hpa's call to tdp_mmu_alloc_sp()
b) adding a hyperv_flush_guest_mapping(vcpu->arch.mmu->root.hpa) to svm_flush_tlb_current()

appear to work in my test case (L2 vm startup until panic due to missing rootfs).

But in both these cases (and also when I completely disable HV_X64_NESTED_ENLIGHTENED_TLB)
the runtime of an iteration of the test is noticeably longer compared to tdp_mmu=0.

So in terms of performance the ranking is (fastest to slowest):
1. tdp_mmu=0 + enlightened TLB
2. tdp_mmu=0 + no enlightened TLB
3. tdp_mmu=1 (enlightened TLB makes minimal difference)
