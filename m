Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82F94F6BB1
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 22:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbiDFUxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 16:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbiDFUwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 16:52:42 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907B03D103F;
        Wed,  6 Apr 2022 12:08:57 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1ncB1K-0002ZY-U6; Wed, 06 Apr 2022 21:08:46 +0200
Message-ID: <5135b502-ce2e-babb-7812-4d4c431a5252@maciej.szmigiero.name>
Date:   Wed, 6 Apr 2022 21:08:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-6-seanjc@google.com>
 <a47217da0b6db4f1b6b6c69a9dc38350b13ac17c.camel@redhat.com>
 <YkshgrUaF4+MrrXf@google.com>
 <7caee33a-da0f-00be-3195-82c3d1cd4cb4@maciej.szmigiero.name>
 <YkzxXw1Aznv4zX0a@google.com>
 <eed1cea4-409a-f03e-5c31-e82d49bb2101@maciej.szmigiero.name>
 <Yk3Jd6xAfgVoFgLc@google.com>
Content-Language: en-US
Subject: Re: [PATCH 5/8] KVM: SVM: Re-inject INT3/INTO instead of retrying the
 instruction
In-Reply-To: <Yk3Jd6xAfgVoFgLc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6.04.2022 19:10, Sean Christopherson wrote:
> On Wed, Apr 06, 2022, Maciej S. Szmigiero wrote:
>> On 6.04.2022 03:48, Sean Christopherson wrote:
>>> On Mon, Apr 04, 2022, Maciej S. Szmigiero wrote:
>> (..)
>>>> Also, I'm not sure that even the proposed updated code above will
>>>> actually restore the L1-requested next_rip correctly on L1 -> L2
>>>> re-injection (will review once the full version is available).
>>>
>>> Spoiler alert, it doesn't.  Save yourself the review time.  :-)
>>>
>>> The missing piece is stashing away the injected event on nested VMRUN.  Those
>>> events don't get routed through the normal interrupt/exception injection code and
>>> so the next_rip info is lost on the subsequent #NPF.
>>>
>>> Treating soft interrupts/exceptions like they were injected by KVM (which they
>>> are, technically) works and doesn't seem too gross.  E.g. when prepping vmcb02
>>>
>>> 	if (svm->nrips_enabled)
>>> 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
>>> 	else if (boot_cpu_has(X86_FEATURE_NRIPS))
>>> 		vmcb02->control.next_rip    = vmcb12_rip;
>>>
>>> 	if (is_evtinj_soft(vmcb02->control.event_inj)) {
>>> 		svm->soft_int_injected = true;
>>> 		svm->soft_int_csbase = svm->vmcb->save.cs.base;
>>> 		svm->soft_int_old_rip = vmcb12_rip;
>>> 		if (svm->nrips_enabled)
>>> 			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
>>> 		else
>>> 			svm->soft_int_next_rip = vmcb12_rip;
>>> 	}
>>>
>>> And then the VMRUN error path just needs to clear soft_int_injected.
>>
>> I am also a fan of parsing EVENTINJ from VMCB12 into relevant KVM
>> injection structures (much like EXITINTINFO is parsed), as I said to
>> Maxim two days ago [1].
>> Not only for software {interrupts,exceptions} but for all incoming
>> events (again, just like EXITINTINFO).
> 
> Ahh, I saw that fly by, but somehow I managed to misread what you intended.
> 
> I like the idea of populating vcpu->arch.interrupt/exception as "injected" events.
> KVM prioritizes "injected" over other nested events, so in theory it should work
> without too much fuss.  I've ran through a variety of edge cases in my head and
> haven't found anything that would be fundamentally broken.  I think even live
> migration would work.
> 
> I think I'd prefer to do that in a follow-up series so that nVMX can be converted
> at the same time?  It's a bit absurd to add the above soft int code knowing that,
> at least in theory, simply populating the right software structs would automagically
> fix the bug.  But manually handling the soft int case first would be safer in the
> sense that we'd still have a fix for the soft int case if it turns out that populating
> vcpu->arch.interrupt/exception isn't as straightfoward as it seems.

I don't see any problem with having two patch series, the second series
depending on the first.

I planned to at least fix the bugs that I described in my previous message
(the NMI one actually breaks a real Windows guest) but that needs
knowledge how the event injection code will finally look like after the
first series of fixes.

>> However, there is another issue related to L1 -> L2 event re-injection
>> using standard KVM event injection mechanism: it mixes the L1 injection
>> state with the L2 one.
>>
>> Specifically for SVM:
>> * When re-injecting a NMI into L2 NMI-blocking is enabled in
>> vcpu->arch.hflags (shared between L1 and L2) and IRET intercept is
>> enabled.
>>
>> This is incorrect, since it is L1 that is responsible for enforcing NMI
>> blocking for NMIs that it injects into its L2.
> 
> Ah, I see what you're saying.  I think :-)  IIUC, we can fix this bug without any
> new flags, just skip the side effects if the NMI is being injected into L2.
> 
> @@ -3420,6 +3424,10 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>          struct vcpu_svm *svm = to_svm(vcpu);
> 
>          svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
> +
> +       if (is_guest_mode(vcpu))
> +               return;
> +
>          vcpu->arch.hflags |= HF_NMI_MASK;
>          if (!sev_es_guest(vcpu->kvm))
>                  svm_set_intercept(svm, INTERCEPT_IRET);
> 
> and for nVMX:
> 
> @@ -4598,6 +4598,9 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
>   {
>          struct vcpu_vmx *vmx = to_vmx(vcpu);
> 
> +       if (is_guest_mode(vcpu))
> +               goto inject_nmi;
> +
>          if (!enable_vnmi) {
>                  /*
>                   * Tracking the NMI-blocked state in software is built upon
> @@ -4619,6 +4622,7 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
>                  return;
>          }
> 
> +inject_nmi:
>          vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
>                          INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
> 

And what if it's L0 that is trying to inject a NMI into L2?
In this case is_guest_mode() is true, but the full NMI injection machinery
should be used.

>> Also, *L2* being the target of such injection definitely should not block
>> further NMIs for *L1*.
> 
> Actually, it should block NMIs for L1.  From L1's perspective, the injection is
> part of VM-Entry.  That's a single gigantic instruction, thus there is no NMI window
> until VM-Entry completes from L1's perspetive.  Any exit that occurs on vectoring
> an injected event and is handled by L0 should not be visible to L1, because from
> L1's perspective it's all part of VMRUN/VMLAUNCH/VMRESUME.  So blocking new events
> because an NMI (or any event) needs to be reinjected for L2 is correct.

I think this kind of NMI blocking will be already handled by having
the pending new NMI in vcpu->arch.nmi_pending but the one that needs
re-injecting in vcpu->arch.nmi_injected.

The pending new NMI in vcpu->arch.nmi_pending won't be handled until
vcpu->arch.nmi_injected gets cleared (that is, until re-injection is
successful).

It is incorrect however, to wait for L2 to execute IRET to unblock
L0 -> L1 NMIs or L1 -> L2 NMIs, in these two cases we (L0) just need the CPU
to vector that L2 NMI so it no longer shows in EXITINTINFO.

It is also incorrect to block L1 -> L2 NMI injection because either L1
or L2 is currently under NMI blocking: the first case is obvious,
the second because it's L1 that is supposed to take care of proper NMI
blocking for L2 when injecting an NMI there.

>> * When re-injecting a *hardware* IRQ into L2 GIF is checked (previously
>> even on the BUG_ON() level), while L1 should be able to inject even when
>> L2 GIF is off,
> 
> Isn't that just a matter of tweaking the assertion to ignore GIF if L2 is
> active?  Hmm, or deleting the assertion altogether, it's likely doing more harm
> than good at this point.

I assume this assertion is meant to catch the case when KVM itself (L0) is
trying to erroneously inject a hardware interrupt into L1 or L2, so it will
need to be skipped only for L1 -> L2 event injection.

Whether this assertion benefits outweigh its costs is debatable - don't have
a strong opinion here (BUG_ON() is for sure too strong, but WARN_ON_ONCE()
might make sense to catch latent bugs).

>> With the code in my previous patch set I planned to use
>> exit_during_event_injection() to detect such case, but if we implement
>> VMCB12 EVENTINJ parsing we can simply add a flag that the relevant event
>> comes from L1, so its normal injection side-effects should be skipped.
> 
> Do we still need a flag based on the above?  Honest question... I've been staring
> at all this for the better part of an hour and may have lost track of things.

If checking just is_guest_mode() is not enough due to reasons I described
above then we need to somehow determine in the NMI / IRQ injection handler
whether the event to be injected into L2 comes from L0 or L1.
For this (assuming we do VMCB12 EVENTINJ parsing) I think we need an extra flag.

>> By the way, the relevant VMX code also looks rather suspicious,
>> especially for the !enable_vnmi case.
> 
> I think it's safe to say we can ignore edge cases for !enable_vnmi.  It might even
> be worth trying to remove that support again (Paolo tried years ago), IIRC the
> only Intel CPUs that don't support virtual NMIs are some funky Yonah SKUs.

Ack, we could at least disable nested on !enable_vnmi.

BTW, I think that besides Yonah cores very early Core 2 CPUs also lacked
vNMI support, that's why !enable_vnmi support was reinstated.
But that's hardware even older than !nrips AMD parts.

Thanks,
Maciej
