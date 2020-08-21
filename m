Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F255424D173
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 11:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgHUJ2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 05:28:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55596 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728423AbgHUJ2e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 05:28:34 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598002112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VU2HxPgLNLazukFoPOzD00O9Xl1vG0JgE6354eT+dVU=;
        b=QJOfX/Y6wXrHej6IcmnqxUyPMKZwipi+Xyftmz4lK2aD3g7bG1juDXdgGKzPq7dSSKOBb/
        ssYMMYJzJcs0p+Dt3HVBXnkIc3psWtjrTBhzlA3Iprqy7alQorOGSs+u1UbzF3UVMjR2qz
        tkKaw+4khq2l3aHWmFGYN4nDWjyCd6EB0W8YEAkcmSfuefo71OkMXu5sUFWQHrJhnNjKkG
        K5Rkxf7G/dYyteCM488T2Okxy27aatHvOrAmC5fSlyQldDGCn9HL4kxIFcqT949przTCHw
        EJ+4jVKy28pHAAxB8+IS8kmt4SfZihamvMCbj7P9eo1MlB4JH56745dW12Erog==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598002112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VU2HxPgLNLazukFoPOzD00O9Xl1vG0JgE6354eT+dVU=;
        b=voT2OdXpJOLurUTBKVhdXgyagX/vUxVwvyPvxG0AEg7NKcs9BVoP/kLLId2AntIxI1k3Oq
        sd9gY9jeYgvgrlBQ==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/entry/64: Disallow RDPID in paranoid entry if KVM is enabled
In-Reply-To: <3eb94913-662d-5423-21b1-eaf75635142a@redhat.com>
References: <20200821025050.32573-1-sean.j.christopherson@intel.com> <20200821074743.GB12181@zn.tnic> <3eb94913-662d-5423-21b1-eaf75635142a@redhat.com>
Date:   Fri, 21 Aug 2020 11:28:32 +0200
Message-ID: <87r1s0gxfj.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21 2020 at 10:09, Paolo Bonzini wrote:
> On 21/08/20 09:47, Borislav Petkov wrote:
>> On Thu, Aug 20, 2020 at 07:50:50PM -0700, Sean Christopherson wrote:
>>> +	 * Disallow RDPID if KVM is enabled as it may consume a guest's TSC_AUX
>>> +	 * if an NMI arrives in KVM's run loop.  KVM loads guest's TSC_AUX on
>>> +	 * VM-Enter and may not restore the host's value until the CPU returns
>>> +	 * to userspace, i.e. KVM depends on the kernel not using TSC_AUX.
>>>  	 */
>> And frankly, this is really unfair. The kernel should be able to use any
>> MSR. IOW, KVM needs to be fixed here. I'm sure it context-switches other
>> MSRs so one more MSR is not a big deal.
>
> The only MSR that KVM needs to context-switch manually are XSS and
> SPEC_CTRL.  They tend to be the same on host and guest in which case
> they can be optimized away.
>
> All the other MSRs (EFER and PAT are those that come to mind) are
> handled by the microcode and thus they don't have the slowness of
> RDMSR/WRMSR
>
> One more MSR *is* a big deal: KVM's vmentry+vmexit cost is around 1000
> cycles, adding 100 clock cycles for 2 WRMSRs is a 10% increase.

We all know that MSRs are slow, but as a general rule I have to make it
entirely clear that the kernel has precedence over KVM.

If the kernel wants to use an MSR for it's own purposes then KVM has to
deal with that and not the other way round. Preventing the kernel from
using a facility freely is not an option ever.

The insanities of KVM performance optimizations have bitten us more than
once.

For this particular case at hand I don't care much and we should just
rip the whole RDPID thing out unconditionally. We still have zero
numbers about the performance difference vs. LSL.

Thanks,

        tglx
