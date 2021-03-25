Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A81348B9A
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 09:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCYId5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 04:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhCYIdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 04:33:49 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0915AC06174A;
        Thu, 25 Mar 2021 01:33:49 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u21so1481071ejo.13;
        Thu, 25 Mar 2021 01:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DG509l2PkxXN6P5FW9KJ6L3L9tjWoNFCQPMWavCi9Hs=;
        b=tYybAzNy2NJo3wOuiJxIdKRRldKtZkmP54NEIFJOjVWqt5vDY0mWJEVte52k+D5F9g
         KuhhXqVwsMGv945KMjdwiCOPNqqIdnpA/3JZB77lGOEVYLq0EqJHW96JpSMeLRDd5ANg
         Pc9h1j+q7noYVzO/eAO/yuZCH3oxmRVrtxtrOnhNiNBn86yaeRWpmji6tG+4QLfcbO5O
         gxxJMJPTHWR+EDZRYSsvS0lMj95/e/3FrcdfQSy1R9r/jqSOErOX+d3S+iUv54yzkCo7
         k+DjloO4LDmLImGYsOkYz3t1chIGYyE9R1R21fiZm/ttuWr7zVHUjNQaozBJl7Cgf7AJ
         EGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DG509l2PkxXN6P5FW9KJ6L3L9tjWoNFCQPMWavCi9Hs=;
        b=rfbhBtRnabieveC8ywnbtao0rNn+MPHYAT0JjfoIn704dwwhKmjv6Rv6pMYaIpYslj
         fOa8/dlE25fUF5mXkxw5Qu6vh930RfB1EAItXkMWsD1FjjvvyxdhvwBrikvLjk7J6J0t
         XKtrU9h6sRtukOaHq+6l+H7RFAH0wDscczIzW49OwIrO4l3Gx1l+Myn97RDdwsCfvBx0
         sr3AGleDNsMn6xXx9qaY6nsNJPbGPLW4IbXnGkub8Gm2lsYA4xby5w/DFNWI4IMKoaHO
         VfEqxnNmUGiURWZAopP9Y12u0SQ9/PXaxRiPasPI4BcZ+g81CVJJV5kmGjmD5hK4Kytm
         UiMQ==
X-Gm-Message-State: AOAM5326BQ9kSoZzmwNkSGif/s+aHuUmFkqMZWgZYh7GWg7m2wWs6xrB
        EZNCtyzdAHPJMTuuL0S71qdfeMa4+ivUZJHjLA==
X-Google-Smtp-Source: ABdhPJxE48sFuEwRba6GyLkITt2RlEq+yfl8Kvnhs2WOF1NKQsIeTXnTgoPtATA5mLeluNTQqo3HbEklGWm3WC37epk=
X-Received: by 2002:a17:906:f210:: with SMTP id gt16mr8092558ejb.206.1616661227783;
 Thu, 25 Mar 2021 01:33:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210323084515.1346540-1-vkuznets@redhat.com> <CAB5KdObQ7t4aXFsYioNdVfNt6B+ChJLB5dKsWxAtoXMYpgSoBA@mail.gmail.com>
 <87czvny7pw.fsf@vitty.brq.redhat.com>
In-Reply-To: <87czvny7pw.fsf@vitty.brq.redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Thu, 25 Mar 2021 16:33:08 +0800
Message-ID: <CAB5KdObOS1V=oGxSeiNfifHYO_20LopiJ2-M-44xA6OTjGa9Qg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/vPMU: Forbid writing to MSR_F15H_PERF MSRs when
 guest doesn't have X86_FEATURE_PERFCTR_CORE
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Wei Huang <wei.huang2@amd.com>, Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25, 2021 at 4:10 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Haiwei Li <lihaiwei.kernel@gmail.com> writes:
>
> > On Tue, Mar 23, 2021 at 4:48 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >>
> >> MSR_F15H_PERF_CTL0-5, MSR_F15H_PERF_CTR0-5 MSRs are only available when
> >> X86_FEATURE_PERFCTR_CORE CPUID bit was exposed to the guest. KVM, however,
> >> allows these MSRs unconditionally because kvm_pmu_is_valid_msr() ->
> >> amd_msr_idx_to_pmc() check always passes and because kvm_pmu_set_msr() ->
> >> amd_pmu_set_msr() doesn't fail.
> >>
> >> In case of a counter (CTRn), no big harm is done as we only increase
> >> internal PMC's value but in case of an eventsel (CTLn), we go deep into
> >> perf internals with a non-existing counter.
> >>
> >> Note, kvm_get_msr_common() just returns '0' when these MSRs don't exist
> >> and this also seems to contradict architectural behavior which is #GP
> >> (I did check one old Opteron host) but changing this status quo is a bit
> >> scarier.
> >
> > When msr doesn't exist, kvm_get_msr_common() returns KVM_MSR_RET_INVALID
> > in `default:` and kvm_complete_insn_gp() will inject #GP to guest.
> >
>
> I'm looking at the following in kvm_get_msr_common():
>
>         switch (msr_info->index) {
>         ...
>         case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
>         ...
>                 if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
>                         return kvm_pmu_get_msr(vcpu, msr_info);
>                 msr_info->data = 0;
>                 break;
>         ...
>         }
>         return 0;
>
> so it's kind of 'always exists' or am I wrong?

I am sorry. You are right. You were talking about `MSR_F15H_PERF_CTL0
... MSR_F15H_PERF_CTR5`.
I thought you were talking about the registers not catched in
kvm_get_msr_common().

>
> > Also i have wrote a kvm-unit-test, tested both on amd EPYC and intel
> > CascadeLake. A #GP error was printed.
> > Just like:
> >
> > Unhandled exception 13 #GP at ip 0000000000400420
> > error_code=0000      rflags=00010006      cs=00000008
> > rax=0000000000000000 rcx=0000000000000620 rdx=00000000006164a0
> > rbx=0000000000009500
> > rbp=0000000000517490 rsi=0000000000616ae0 rdi=0000000000000001
> >  r8=0000000000000001  r9=00000000000003f8 r10=000000000000000d
> > r11=0000000000000000
> > r12=0000000000000000 r13=0000000000000000 r14=0000000000000000
> > r15=0000000000000000
> > cr0=0000000080000011 cr2=0000000000000000 cr3=000000000040b000
> > cr4=0000000000000020
> > cr8=0000000000000000
> > STACK: @400420 400338
>
> Did this happen on read or write? The later is expected, the former is
> not. Could you maybe drop your code here, I'd like to see what's going
> on.

I did a bad test. The msr tested is not catched in
kvm_get_msr_common(). As said, I misunderstood
what you meant.

I have tested your patch and replied. If you have any to test, I'm
glad to help. :)

--
Haiwei Li
