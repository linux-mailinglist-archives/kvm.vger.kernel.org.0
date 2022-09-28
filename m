Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0385EDD2F
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 14:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbiI1MxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 08:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbiI1MxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 08:53:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB844AD4C
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 05:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664369575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qw69+PrzJ+2+9QRJKVTJ19LmNv5Ecvv+R+yRw3efh/0=;
        b=C1gylgAl/IM42+Z26Jvffj03XwIOuVJv/HRLZl7lsmAghcChAG3UNwkoB0JEotI0Ywp1Eq
        OVPx0Qy1U3Ia3jl0WIFUJ51mwywopvh86INC83wXGAdHXZt+RqRiXkaN/k03RYXXzF/FCw
        eVSvU7Lk1Ks8zWduWh3mXXEBaRe7nkY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-638-KJ1ANH8uPkaLOZD2sspZTg-1; Wed, 28 Sep 2022 08:52:54 -0400
X-MC-Unique: KJ1ANH8uPkaLOZD2sspZTg-1
Received: by mail-wm1-f69.google.com with SMTP id 84-20020a1c0257000000b003b4be28d7e3so1181725wmc.0
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 05:52:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Qw69+PrzJ+2+9QRJKVTJ19LmNv5Ecvv+R+yRw3efh/0=;
        b=c3NvZ78jjodwiX0RuiJ9SiuaW6ORjbmc1FSwy5BzIYxOJ5n2teZkC5/KkjoDPCVWYz
         vhU3fh4L3M935Ni5e+NU2Yov4G4K54WYvUMDeyAjaaVfIzCgSFVasAcK1zyJ52m0cdX7
         WQ8ssu9JZB4dqZoqg1wnvv1c3chzzJpMUJHpqmhQyB5Um8jMVpp9FfAX+snjJhCWkbBP
         HQTObjP16rhc8DjFIGn4+eOdHZy9gVkrm/OolT9hR6e5xgRL9/nBV4V83ibm9owRwbsa
         pMQjuvbuLdMuglxSxdORssbYJxhxIv3S83p3rEjqe1JbhMqLYKs62u04pe/chrhhBjZe
         VJyw==
X-Gm-Message-State: ACrzQf1QADXlcnmMGqGIZE7+uzUpohhaQdrlCQZ8JldtWq/lA3s9OLta
        hzNCzD0cicK6oPxYS6d3QCeQKv3LpgNi9kgRCGBZSsqTQfqBT1UJX9GTq8o7pSLTKjZNd2vA8Y/
        zXK10uRKm/v0P
X-Received: by 2002:a5d:49c8:0:b0:22a:35a1:1755 with SMTP id t8-20020a5d49c8000000b0022a35a11755mr19562608wrs.180.1664369573149;
        Wed, 28 Sep 2022 05:52:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7ZQ+POWxq2bVQSaNUD4B0CIXYpDRJ5eA85WTdHeL+eMv35Rdf6vBmDpYViCv+zorjgMYiiRA==
X-Received: by 2002:a5d:49c8:0:b0:22a:35a1:1755 with SMTP id t8-20020a5d49c8000000b0022a35a11755mr19562584wrs.180.1664369572851;
        Wed, 28 Sep 2022 05:52:52 -0700 (PDT)
Received: from ?IPV6:2003:cb:c704:1100:add9:5f61:6b94:7540? (p200300cbc7041100add95f616b947540.dip0.t-ipconnect.de. [2003:cb:c704:1100:add9:5f61:6b94:7540])
        by smtp.gmail.com with ESMTPSA id co4-20020a0560000a0400b00228d6bc8450sm5090561wrb.108.2022.09.28.05.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 05:52:52 -0700 (PDT)
Message-ID: <dfe26896-6469-fa3c-744e-67c81efbee93@redhat.com>
Date:   Wed, 28 Sep 2022 14:52:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <YxtOEgJhe4EcAJsE@google.com>
 <5f0345d2-d4d1-f4fe-86ba-6e22561cb6bd@redhat.com>
 <37b3162e-7b3a-919f-80e2-f96eca7d4b4c@redhat.com>
 <dfcbdf1d-b078-ec6c-7706-6af578f79ec2@redhat.com>
 <55d7f0bd-ace1-506b-ea5b-105a86290114@redhat.com>
 <f753391e-7bdc-bada-856a-87344e75bd74@redhat.com>
 <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
 <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
 <YzIZhn47brWBfQah@google.com>
 <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
 <YzMdjSkKaJ8HyWXh@google.com>
 <b3dc9505-9a5c-a631-065a-85bf86b1d071@redhat.com>
 <e3a7ab12e3941e17c033e172eb063cc645d70eb4.camel@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
In-Reply-To: <e3a7ab12e3941e17c033e172eb063cc645d70eb4.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.09.22 13:14, Maxim Levitsky wrote:
> On Wed, 2022-09-28 at 11:11 +0200, Emanuele Giuseppe Esposito wrote:
>>
>> Am 27/09/2022 um 17:58 schrieb Sean Christopherson:
>>> On Tue, Sep 27, 2022, Emanuele Giuseppe Esposito wrote:
>>>> Am 26/09/2022 um 23:28 schrieb Sean Christopherson:
>>>>> On Mon, Sep 26, 2022, David Hildenbrand wrote:
>>>>>> As Sean said "This is an awful lot of a complexity to take on for something
>>>>>> that appears to be solvable in userspace."
>>>>>
>>>>> And if the userspace solution is unpalatable for whatever reason, I'd like to
>>>>> understand exactly what KVM behavior is problematic for userspace.  E.g. the
>>>>> above RHBZ bug should no longer be an issue as the buggy commit has since been
>>>>> reverted.
>>>>
>>>> It still is because I can reproduce the bug, as also pointed out in
>>>> multiple comments below.
>>>
>>> You can reproduce _a_ bug, but it's obviously not the original bug, because the
>>> last comment says:
>>>
>>>    Second, indeed the patch was reverted and somehow accepted without generating
>>>    too much noise:
>>>
>>>    ...
>>>
>>>    The underlying issue of course as we both know is still there.
>>>
>>>    You might have luck reproducing it with this bug
>>>
>>>    https://bugzilla.redhat.com/show_bug.cgi?id=1855298
>>>
>>>    But for me it looks like it is 'working' as well, so you might have
>>>    to write a unit test to trigger the issue.
>>>
>>>>> If the issue is KVM doing something nonsensical on a code fetch to MMIO, then I'd
>>>>> much rather fix _that_ bug and improve KVM's user exit ABI to let userspace handle
>>>>> the race _if_ userspace chooses not to pause vCPUs.
>>>>>
>>>>
>>>> Also on the BZ they all seem (Paolo included) to agree that the issue is
>>>> non-atomic memslots update.
>>>
>>> Yes, non-atomic memslot likely results in the guest fetching from a GPA without a
>>> memslot.  I'm asking for an explanation of exactly what happens when that occurs,
>>> because it should be possible to adjust KVM and/or QEMU to play nice with the
>>> fetch, e.g. to resume the guest until the new memslot is installed, in which case
>>> an atomic update isn't needed.
>>>
>>> I assume the issue is that KVM exits with KVM_EXIT_INTERNAL_ERROR because the
>>> guest is running at CPL=0, and QEMU kills the guest in response.  If that's correct,
>>> then that problem can be solved by exiting to userspace with KVM_EXIT_MMIO instead
>>> of KVM_EXIT_INTERNAL_ERROR so that userspace can do something sane in response to
>>> the MMIO code fetch.
>>>
>>> I'm pretty sure this patch will Just Work for QEMU, because QEMU simply resumes
>>> the vCPU if mmio.len==0.  It's a bit of a hack, but I don't think it violates KVM's
>>> ABI in any way, and it can even become "official" behavior since KVM x86 doesn't
>>> otherwise exit with mmio.len==0.
>>>
>>> Compile tested only...
>>
>> So basically you are just making KVM catch the failed
>> kvm_vcpu_read_guest_page() by retuning mmio.len = 0 to QEMU which
>> basically ends up in doing nothing and retry again executing the
>> instruction?
>>
>> I wonder if there are some performance implications in this, but it's
>> definitely simpler than what I did.
>>
>> Tested on the same failing machine used for the BZ, fixes the bug.
>>
>> Do you want me to re-send the patch on your behalf (and add probably a
>> small documentation on Documentation/virt/kvm/api.rst)?
>>
>> Emanuele
>>> ---
>>> From: Sean Christopherson <seanjc@google.com>
>>> Date: Tue, 27 Sep 2022 08:16:03 -0700
>>> Subject: [PATCH] KVM: x86: Exit to userspace with zero-length MMIO "read" on
>>>   MMIO fetch
>>>
>>> Exit to userspace with KVM_EXIT_MMIO if emulation fails due to not being
>>> able to fetch instruction bytes, e.g. if the resolved GPA isn't backed by
>>> a memslot.  If userspace is manipulating memslots without pausing vCPUs,
>>> e.g. to emulate BIOS relocation, then a vCPU may fetch while there is no
>>> valid memslot installed.  Depending on guest context, KVM will either
>>> exit to userspace with KVM_EXIT_INTERNAL_ERROR (L1, CPL=0) or simply
>>> resume the guest (L2 or CPL>0), neither of which is desirable as exiting
>>> with "emulation error" effectively kills the VM, and resuming the guest
>>> doesn't provide userspace an opportunity to react the to fetch.
>>>
>>> Use "mmio.len == 0" to indicate "fetch".  This is a bit of a hack, but
>>> there is no other way to communicate "fetch" to userspace without
>>> defining an entirely new exit reason, e.g. "mmio.is_write" is a boolean
>>> and not a flag, and there is no known use case for actually supporting
>>> code fetches from MMIO, i.e. there's no need to allow userspace to fill
>>> in the instruction bytes.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>   arch/x86/kvm/emulate.c     | 2 ++
>>>   arch/x86/kvm/kvm_emulate.h | 1 +
>>>   arch/x86/kvm/x86.c         | 9 ++++++++-
>>>   3 files changed, 11 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>>> index f092c54d1a2f..e141238d93b0 100644
>>> --- a/arch/x86/kvm/emulate.c
>>> +++ b/arch/x86/kvm/emulate.c
>>> @@ -5353,6 +5353,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>>>   done:
>>>   	if (rc == X86EMUL_PROPAGATE_FAULT)
>>>   		ctxt->have_exception = true;
>>> +	if (rc == X86EMUL_IO_NEEDED)
>>> +		return EMULATION_IO_FETCH;
>>>   	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
>>>   }
>>>   
>>> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
>>> index 89246446d6aa..3cb2e321fcd2 100644
>>> --- a/arch/x86/kvm/kvm_emulate.h
>>> +++ b/arch/x86/kvm/kvm_emulate.h
>>> @@ -516,6 +516,7 @@ bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
>>>   #define EMULATION_OK 0
>>>   #define EMULATION_RESTART 1
>>>   #define EMULATION_INTERCEPTED 2
>>> +#define EMULATION_IO_FETCH 3
>>>   void init_decode_cache(struct x86_emulate_ctxt *ctxt);
>>>   int x86_emulate_insn(struct x86_emulate_ctxt *ctxt);
>>>   int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index aa5ab0c620de..7eb72694c601 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -7129,8 +7129,13 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
>>>   		bytes = (unsigned)PAGE_SIZE - offset;
>>>   	ret = kvm_vcpu_read_guest_page(vcpu, gpa >> PAGE_SHIFT, val,
>>>   				       offset, bytes);
>>> -	if (unlikely(ret < 0))
>>> +	if (unlikely(ret < 0)) {
>>> +		vcpu->run->mmio.phys_addr = gpa;
>>> +		vcpu->run->mmio.len = 0;
>>> +		vcpu->run->mmio.is_write = 0;
>>> +		vcpu->run->exit_reason = KVM_EXIT_MMIO;
>>>   		return X86EMUL_IO_NEEDED;
>>> +	}
>>>   
>>>   	return X86EMUL_CONTINUE;
>>>   }
>>> @@ -8665,6 +8670,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>>   		r = x86_decode_emulated_instruction(vcpu, emulation_type,
>>>   						    insn, insn_len);
>>>   		if (r != EMULATION_OK)  {
>>> +			if (r == EMULATION_IO_FETCH)
>>> +				return 0;
>>>   			if ((emulation_type & EMULTYPE_TRAP_UD) ||
>>>   			    (emulation_type & EMULTYPE_TRAP_UD_FORCED)) {
>>>   				kvm_queue_exception(vcpu, UD_VECTOR);
>>>
>>> base-commit: 39d9b48cc777bdf6d67d01ed24f1f89b13f5fbb2
>>>
> 
> Note that AFAIK, there is another case (and probably more), if TDP is disabled,
> and MMU root is in mmio, we kill the guest.
> 
> 
> mmu_alloc_shadow_roots -> mmu_check_root
> 
> 
> I used to have few hacks in KVM to cope with this, but AFAIK,
> I gave up on it, because the issue would show up again and again.

IIRC, s390x can have real problems if we temporarily remove a memslot. 
In case the emulation/interpretation code tries accessing guest memory 
and fails because there is no memslot describing that portion of guest RAM.

Note that resizing/merging/splitting currently shouldn't happen on 
s390x, though. But resizing of memslots might happen in the near future 
with virtio-mem in QEMU.

-- 
Thanks,

David / dhildenb

