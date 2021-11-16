Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA99453B04
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhKPUjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:39:04 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54912 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhKPUjD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:39:03 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637094964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7XMMD+98XQDTijC1O0p6zbcme1OE0jdwczk1KLw1JOs=;
        b=dDyO7+EvG86gufOoXYubDHjIlCmeX7/aFLtNX3uXfQ1QgrHOH5HvpJLGXPsXXe0fUD+Onq
        7RmcbsX/Qt+hpjVjXGMhXV80UXqyICDbKlG87iWP0ByR12OI9gBglVlGtiO3LUGWOIVRi0
        2pYJ4y69bIT1hhgxLPggZfPiw3Z0pIOYUFnCm4/T+pQ70/Xw1uOeGjop3eExghq19xVfwt
        ZI6O0KspUX0/PVsJZtc5uF+Dbw4tpb+7wG+d2DUlxx6jwnPcpPWsPQa/wHaKK6ebGGPs5S
        81qwR9jhkxuNQiKEwaFhHyaWs/18T0yCsC3mPwE3749CgqcgOQwGNbBUMCB2Jg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637094964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7XMMD+98XQDTijC1O0p6zbcme1OE0jdwczk1KLw1JOs=;
        b=YoB9wfk7mpwxAgN6yqjfyuMAPnyAegQGDqaIuBzPmClN9HKGYOc7Vud2LI7/EsYUrPvD74
        UpMa4UPU8vDDBrDg==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Re: Thoughts of AMX KVM support based on latest kernel
In-Reply-To: <04978d6d-8e1a-404d-b30d-402a7569c1f0@redhat.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <87k0h85m65.ffs@tglx> <YZPWsICdDTZ02UDu@google.com> <87ee7g53rp.ffs@tglx>
 <04978d6d-8e1a-404d-b30d-402a7569c1f0@redhat.com>
Date:   Tue, 16 Nov 2021 21:36:03 +0100
Message-ID: <87zgq34z4c.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On Tue, Nov 16 2021 at 20:49, Paolo Bonzini wrote:
> On 11/16/21 19:55, Thomas Gleixner wrote:
>> We can do that, but I'm unhappy about this conditional in schedule(). So
>> I was asking for doing a simple KVM only solution first:
>> 
>> vcpu_run()
>>          kvm_load_guest_fpu()
>>              wrmsrl(XFD, guest_fpstate->xfd);
>>              XRSTORS
>>            
>>          do {
>> 
>>             local_irq_disable();
>> 
>>             if (test_thread_flag(TIF_NEED_FPU_LOAD))
>> 		switch_fpu_return()
>>                    wrmsrl(XFD, guest_fpstate->xfd);
>> 
>>             do {
>>                  vmenter();              // Guest modifies XFD
>>             } while (reenter);
>> 
>>             update_xfd_state();          // Restore consistency
>> 
>>             local_irq_enable();
>> 
>> and check how bad that is for KVM in terms of overhead on AMX systems.
>
> I agree, this is how we handle SPEC_CTRL for example and it can be 
> extended to XFD.

SPEC_CTRL is different because it's done right after each VMEXIT.

XFD can be done lazy when breaking out of the exit fastpath loop before
enabling interrupts.

> We should first do that, then switch to the MSR lists. 
>   Hacking into schedule() should really be the last resort.
>
>>            local_irq_enable();     <- Problem starts here
>> 
>>            preempt_enable();	   <- Becomes wider here
>
> It doesn't become that much wider because there's always preempt 
> notifiers.  So if it's okay to save XFD in the XSAVES wrapper and in 
> kvm_arch_vcpu_put(), that might be already remove the need to do it 
> schedule().

Did not think about preemption notifiers. Probably because I hate
notifiers with a passion since I had to deal with the CPU hotplug
notifier trainwreck.

But yes that would work. So the places to do that would be:

1) kvm_sched_out() -> kvm_arch_vcpu_put()
2) kernel_fpu_begin_mask()
3) kvm_put_guest_fpu()

But I really would start with the trivial version I suggested because
that's already in the slow path and not at every VMEXIT.

I'd be really surprised if that RDMSR is truly noticeable within all the
other crud this path is doing.

Thanks,

        tglx
