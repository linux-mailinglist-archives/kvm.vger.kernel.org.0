Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EE124E1B8
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 22:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgHUUBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 16:01:05 -0400
Received: from terminus.zytor.com ([198.137.202.136]:45731 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbgHUT4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 15:56:35 -0400
Received: from [IPv6:2601:646:8600:3281:31ed:317b:19eb:7465] ([IPv6:2601:646:8600:3281:31ed:317b:19eb:7465])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 07LJu1g2490486
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 21 Aug 2020 12:56:01 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 07LJu1g2490486
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020072401; t=1598039762;
        bh=YhPQH5SfS558trRCShnnsO2tTvQs+aQ7LNSaONIhSVQ=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=JhIrT7IfAsETgop44uuwFTNUnMwupA0yzOfUgEhoBRrWZ+s1qh5LWta4eL4B6uuxf
         QAyCo2COB2ZV7dIR2I2cEQ3Rve1ZuNwUMgUINAmd8p4qi/0hQd0Pwe3631KXUQZtT2
         r5ODdcEls1s7kJt1fEiOEa29FqIkAqGUT7MNzvPUyMQliMzmu+IxEj0ELjydA/6fW0
         YfYBnTjdD48WBubISraGGRNPKRXf2/nCf0kb9n44Lp8O4vwqhk+LRQwKJ5H1o+evHC
         fcy+jtKalN/exSfRIRsJsk2/oaJhUeUDx884p33xMmmuBGdb4ka2kyhfq2Ur9ll1dR
         1gTGLtKjy6GcA==
Date:   Fri, 21 Aug 2020 12:55:53 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <87r1s0gxfj.fsf@nanos.tec.linutronix.de>
References: <20200821025050.32573-1-sean.j.christopherson@intel.com> <20200821074743.GB12181@zn.tnic> <3eb94913-662d-5423-21b1-eaf75635142a@redhat.com> <87r1s0gxfj.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] x86/entry/64: Disallow RDPID in paranoid entry if KVM is enabled
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
From:   hpa@zytor.com
Message-ID: <5120CF63-12EB-4701-B303-C0A96201F5A2@zytor.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On August 21, 2020 2:28:32 AM PDT, Thomas Gleixner <tglx@linutronix=2Ede> w=
rote:
>On Fri, Aug 21 2020 at 10:09, Paolo Bonzini wrote:
>> On 21/08/20 09:47, Borislav Petkov wrote:
>>> On Thu, Aug 20, 2020 at 07:50:50PM -0700, Sean Christopherson wrote:
>>>> +	 * Disallow RDPID if KVM is enabled as it may consume a guest's
>TSC_AUX
>>>> +	 * if an NMI arrives in KVM's run loop=2E  KVM loads guest's
>TSC_AUX on
>>>> +	 * VM-Enter and may not restore the host's value until the CPU
>returns
>>>> +	 * to userspace, i=2Ee=2E KVM depends on the kernel not using
>TSC_AUX=2E
>>>>  	 */
>>> And frankly, this is really unfair=2E The kernel should be able to use
>any
>>> MSR=2E IOW, KVM needs to be fixed here=2E I'm sure it context-switches
>other
>>> MSRs so one more MSR is not a big deal=2E
>>
>> The only MSR that KVM needs to context-switch manually are XSS and
>> SPEC_CTRL=2E  They tend to be the same on host and guest in which case
>> they can be optimized away=2E
>>
>> All the other MSRs (EFER and PAT are those that come to mind) are
>> handled by the microcode and thus they don't have the slowness of
>> RDMSR/WRMSR
>>
>> One more MSR *is* a big deal: KVM's vmentry+vmexit cost is around
>1000
>> cycles, adding 100 clock cycles for 2 WRMSRs is a 10% increase=2E
>
>We all know that MSRs are slow, but as a general rule I have to make it
>entirely clear that the kernel has precedence over KVM=2E
>
>If the kernel wants to use an MSR for it's own purposes then KVM has to
>deal with that and not the other way round=2E Preventing the kernel from
>using a facility freely is not an option ever=2E
>
>The insanities of KVM performance optimizations have bitten us more
>than
>once=2E
>
>For this particular case at hand I don't care much and we should just
>rip the whole RDPID thing out unconditionally=2E We still have zero
>numbers about the performance difference vs=2E LSL=2E
>
>Thanks,
>
>        tglx

It is hardly going to be a performance difference for paranoid entry, whic=
h is hopefully rare enough that it falls into the noise=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
