Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB37A4CC5
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 01:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbfIAXzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Sep 2019 19:55:42 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44957 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729213AbfIAXzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Sep 2019 19:55:41 -0400
Received: by mail-io1-f65.google.com with SMTP id j4so25711277iog.11
        for <kvm@vger.kernel.org>; Sun, 01 Sep 2019 16:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q3IPluDPUhxJYqHllocfAsB4f1zm+9hu2o+uKDYOSHI=;
        b=IYup7NpoVS1+GCDE/ltmxhIMglSD4iM+H7q4GhF0QRRVUmODPAgyUhEPhoGRHdmTl7
         4g425S/DvvfnQMd87plnXjs+o/0TJTyFt04iuUZYF47IrLF9ukblBXRRvhiVsEWr3AJc
         eZ8BtvLkSUXGaBkkduRAKjRrPhDyRoBjxDugY5YF/F1EgX02CPJFHFW4o/yywddHtCT+
         U9FqckQ3QBU5NL1d1UpA3PbuHIJHzOWAAtbCIGDkfXiZhpuoQD2cU4CvtM+o2AarmZWs
         RN/Flp0Bc7ACuku3R0KGRhIrUniDJSyPeoX/lsj64iVo5DcCG8cfR/uJ5UOp7jRGVQdN
         ugzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q3IPluDPUhxJYqHllocfAsB4f1zm+9hu2o+uKDYOSHI=;
        b=AJ3Bd1DSVEgjHx+CtvRLoL69sKGC+Q5ZDyoW68n/26qdy3MjggsUolSvARCMI2MDjI
         H2oQLq6jgrigcmF8WB3A3mMt2c7JmybIJ7X5PrEUkyC2U1IVZtFFmaNrLhqGultZbX4o
         QLO8dE5C2lqEbgWC27skumTWkwgPSIWWtAHgF8zJUwbO/91CE+mUVLUq4YuuxpBgDYqZ
         GihRhU0RnelGPgqZyw3z1xGh3mQKDe3CypjEXdr/ocVmscDm5SiXgp5Nv9xxhsZTnMLZ
         7i5IA3nh3fNSSTtD3mOOZsvOyp2Rh/P6JS+w49l7gd+n2BrhthL/pebUgEphIvRF5qy+
         Bg7g==
X-Gm-Message-State: APjAAAVcFfoi/R2qtFrLb+sW71/zjaUwmxBiNiG7InJUig8XGBg35Epn
        hh0mr1x4FGUkHGIAvdK4BhkPcz3xtgniD2KgBUxvqw==
X-Google-Smtp-Source: APXvYqxTkwZ01OsvKp5POMJgG8brPnCS/z1LiMEve3lTX+I6AXjCUsmJ/UaJSCMRbDa15s8J57UmRKIvuJvpmhqTsho=
X-Received: by 2002:a5d:8e15:: with SMTP id e21mr9476421iod.296.1567382140544;
 Sun, 01 Sep 2019 16:55:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-2-krish.sadhukhan@oracle.com> <CALMp9eQxdF5tJLWaWu+0t0NjhSiJfowo1U6MDkjB_zYNRKiyKw@mail.gmail.com>
 <e35e7c1f-e5c8-5f98-771e-302cf8dfba7f@oracle.com>
In-Reply-To: <e35e7c1f-e5c8-5f98-771e-302cf8dfba7f@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sun, 1 Sep 2019 16:55:27 -0700
Message-ID: <CALMp9eQedgJLP9iFW+L3sWZTZmC7aMtg5HBoAbSVMCGax3D==A@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: nVMX: Check GUEST_DEBUGCTL on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 30, 2019 at 4:26 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
>
> On 08/29/2019 03:12 PM, Jim Mattson wrote:
> > On Thu, Aug 29, 2019 at 2:25 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> >> According to section "Checks on Guest Control Registers, Debug Registers, and
> >> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
> >> of nested guests:
> >>
> >>      If the "load debug controls" VM-entry control is 1, bits reserved in the
> >>      IA32_DEBUGCTL MSR must be 0 in the field for that register. The first
> >>      processors to support the virtual-machine extensions supported only the
> >>      1-setting of this control and thus performed this check unconditionally.
> >>
> >> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> >> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> >> ---
> >>   arch/x86/kvm/vmx/nested.c | 4 ++++
> >>   arch/x86/kvm/x86.h        | 6 ++++++
> >>   2 files changed, 10 insertions(+)
> >>
> >> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >> index 46af3a5e9209..0b234e95e0ed 100644
> >> --- a/arch/x86/kvm/vmx/nested.c
> >> +++ b/arch/x86/kvm/vmx/nested.c
> >> @@ -2677,6 +2677,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
> >>              !nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4))
> >>                  return -EINVAL;
> >>
> >> +       if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
> >> +           !kvm_debugctl_valid(vmcs12->guest_ia32_debugctl))
> >> +               return -EINVAL;
> >> +
> >>          if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
> >>              !kvm_pat_valid(vmcs12->guest_ia32_pat))
> >>                  return -EINVAL;
> >> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> >> index a470ff0868c5..28ba6d0c359f 100644
> >> --- a/arch/x86/kvm/x86.h
> >> +++ b/arch/x86/kvm/x86.h
> >> @@ -354,6 +354,12 @@ static inline bool kvm_pat_valid(u64 data)
> >>          return (data | ((data & 0x0202020202020202ull) << 1)) == data;
> >>   }
> >>
> >> +static inline bool kvm_debugctl_valid(u64 data)
> >> +{
> >> +       /* Bits 2, 3, 4, 5, 13 and [31:16] are reserved */
> >> +       return ((data & 0xFFFFFFFFFFFF203Cull) ? false : true);
> >> +}
> > This should actually be consistent with the constraints in kvm_set_msr_common:
> >
> > case MSR_IA32_DEBUGCTLMSR:
> >          if (!data) {
> >                  /* We support the non-activated case already */
> >                  break;
> >          } else if (data & ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_BTF)) {
> >                  /* Values other than LBR and BTF are vendor-specific,
> >                     thus reserved and should throw a #GP */
> >                  return 1;
> >          }
> >
> > Also, as I said earlier...
> >
> > I'd rather see this built on an interface like:
> >
> > bool kvm_valid_msr_value(u32 msr_index, u64 value);
>
> Yes, I forgot to do it. Will send a patch for this...
>
> >
> > Strange that we allow IA32_DEBUGCTL.BTF, since kvm_vcpu_do_singlestep
> > ignores it. And vLBR still isn't a thing, is it?
>
> Yes, DEBUGCTLMSR_LBR isn't used.
> Good catch !
>
> >
> > It's a bit scary to me that we allow any architecturally legal
> > IA32_DEBUGCTL bits to be set today. There's probably a CVE in there
> > somewhere.
> Is it appropriate to disable those two bits as well, then ?

IA32_DEBUGCTL.BTF is just broken, and should be fixed.
IA32_DEBUGCTL.LBR is probably a long way from actually working, but
IIRC, Windows gets cranky if it can't set the bit.
