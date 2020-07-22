Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A0422A2CA
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 01:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733066AbgGVXCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 19:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729614AbgGVXCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 19:02:46 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC645C0619DC;
        Wed, 22 Jul 2020 16:02:46 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595458964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kmMueF/7HOydUTFXGR11d/8gXdHC62tpqTpaLg7E05E=;
        b=ROx4a5tLAjlr52lN9gIkrhQ8jwU0aM/EjW+ilG9YNYu8ZMIq+YUwOhOkP6EM/9nPTMOvwH
        cuhylCisGd1pD3Cxg6n9+wxb1reL4ASPhoCLLAjSO8PMik8da6lrEmCDrgTxVLwXcwS52O
        b58jPIa7X9ig0JCxR2u+CxcClZvayImtThOODsDQgmyYemaphtZ4/Fq5JLlldfKsgdzQBy
        R1GVATDLJoU9To98jbYUnGgS4bBrPZVnzvnHTKFjWtYsv95E72hoMXfc6H/LCo1eht6P2O
        O7LYXZi2lDKK+hm6b55pX/2uLJRcguYENyFnW5OWDA1qS2FNXoVMeg1M6rMU+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595458964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kmMueF/7HOydUTFXGR11d/8gXdHC62tpqTpaLg7E05E=;
        b=4UC7b1Vfgs/2s5GVhWqzeqdTDdHDyaYG83n5oj9z9aT70LdaugWTbDiS0prKc8svL7oIc+
        j+XDTUEDJzloYFAw==
To:     Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Cathy Zhang <cathy.zhang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson\, Sean J" <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kyung Min Park <kyung.min.park@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>, fenghua.yu@intel.com
Subject: Re: [PATCH v2 1/4] x86/cpufeatures: Add enumeration for SERIALIZE instruction
In-Reply-To: <20200708022102.GA25016@ranerica-svr.sc.intel.com>
References: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com> <1594088183-7187-2-git-send-email-cathy.zhang@intel.com> <CALCETrWudiF8G8r57r5i4JefuP5biG1kHg==0O8YXb-bYS-0BA@mail.gmail.com> <20200708022102.GA25016@ranerica-svr.sc.intel.com>
Date:   Thu, 23 Jul 2020 01:02:43 +0200
Message-ID: <87eep3ywz0.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ricardo Neri <ricardo.neri-calderon@linux.intel.com> writes:
> On Tue, Jul 07, 2020 at 09:36:15AM -0700, Andy Lutomirski wrote:
>> On Mon, Jul 6, 2020 at 7:21 PM Cathy Zhang <cathy.zhang@intel.com> wrote:
>> >
>> > This instruction gives software a way to force the processor to complete
>> > all modifications to flags, registers and memory from previous instructions
>> > and drain all buffered writes to memory before the next instruction is
>> > fetched and executed.
>> >
>> > The same effect can be obtained using the cpuid instruction. However,
>> > cpuid causes modification on the eax, ebx, ecx, and ecx regiters; it
>> > also causes a VM exit.
>> >
>> > A processor supports SERIALIZE instruction if CPUID.0x0x.0x0:EDX[14] is
>> > present. The CPU feature flag is shown as "serialize" in /proc/cpuinfo.
>> >
>> > Detailed information on the instructions and CPUID feature flag SERIALIZE
>> > can be found in the latest Intel Architecture Instruction Set Extensions
>> > and Future Features Programming Reference and Intel 64 and IA-32
>> > Architectures Software Developer's Manual.
>> 
>> Can you also wire this up so sync_core() uses it?
>
> I am cc'ing Fenghua, who has volunteered to work on this. Addind support
> for SERIALIZE in sync_core() should not block merging these patches,
> correct?

Come on. We are not serving KVM first before making this usable on bare
metal.

Thanks,

        tglx
