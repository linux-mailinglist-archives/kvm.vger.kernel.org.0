Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA9141190FE
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 20:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfLJTs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 14:48:27 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:39410 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbfLJTs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 14:48:27 -0500
Received: by mail-io1-f68.google.com with SMTP id c16so20105361ioh.6
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 11:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DwxtJsW57TkFgmlSNHTe89gNNRGm7zOnj8k2TTSjuU0=;
        b=A7eIr8eo/NWBMxk56FbJFGG5sC21jp/eCHM5D0+H1dV4dkVjSE1x5MB4F+PILQV2Xs
         geI67LwEJiMuBd5/Sb2n/ce/vpDjj2st2E8IrwkvEMHcsAIlLeWcV73pvHj5pH7E/fPw
         icbM/itVfufdKhypGR/jY560LsrNy3itOyDg074anuocMfzsiTeQyw6e9hqz+k57vdpY
         YZYkuAqxFSPLxmSItk3qrRF+t3y6fVzo/AqgbqUEXBQHYKUMS0S+h02bWbo5DizUN766
         xpMcNNW+S3YyV3sXKphWuNyyVDd03p0eAqR8HA8ojNb8jpGk22W8vkCceP1UyqIBA95l
         rtBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DwxtJsW57TkFgmlSNHTe89gNNRGm7zOnj8k2TTSjuU0=;
        b=sR6PEUARLuEgv87/uDEx6W9T50mN2LgBoqX2WsZPN/pin5gztvC4mbRhEYHtlekmxw
         e6ASPGU9yBomj+EObKimklCGWoJA34sXB5CcrzzYeLfWLgUy1B7HH+p13Yx5jLTcbQqR
         xWaE4RzG4m2wWdYb+Spmf9uVcdZ/kdykAn9RM0Nwkdoa7kUfLbVyX0ly52fFHP/T25hC
         fTLGhm4K9Focysr/Gy5u4QVzw8pwNAujKDbi9RDmHg2q1I1ZteF1ksNiKt/VU07bvLuY
         lkCfStLJ8Ybd7BAOKfaj0q7xVSTZyn7BgryfFT0i8eHslLdl3oUC95UGyNCr5XWgOXML
         BTCw==
X-Gm-Message-State: APjAAAWniYZNOdoh1PlNYK/QG0MntsLLsKGjFor8uRxVj6Q3nFoFufTX
        k9fjdTCDaP2RJMYjFGdaT+ffH84nBq5Nq1tS4ranABOfOMSPZg==
X-Google-Smtp-Source: APXvYqxf/Y/gNvfItvfKuYAq2QrRIJdZTOT+RNrfcSvTtwZvP+j7roXiX1CZEwNrJ6PLLcT2NMp+dYkNTP93dXBAjvI=
X-Received: by 2002:a6b:3b49:: with SMTP id i70mr26688543ioa.108.1576007305796;
 Tue, 10 Dec 2019 11:48:25 -0800 (PST)
MIME-Version: 1.0
References: <20191206231302.3466-1-krish.sadhukhan@oracle.com>
 <20191206231302.3466-2-krish.sadhukhan@oracle.com> <CALMp9eQ4_qtcO1BbraOwXHamXwi4M3AOq1NE7X84wgxxm=ismA@mail.gmail.com>
 <47daeae4-6836-9d60-729a-d5e2d5810edd@oracle.com>
In-Reply-To: <47daeae4-6836-9d60-729a-d5e2d5810edd@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 10 Dec 2019 11:48:14 -0800
Message-ID: <CALMp9eRaX-bdyxAP4C=mdSOFLjCpT+f5RTAb+DchTVktZ+_xfQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: nVMX: Check GUEST_SYSENTER_ESP and
 GUEST_SYSENTER_EIP on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 10, 2019 at 11:36 AM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 12/10/19 9:57 AM, Jim Mattson wrote:
> > On Fri, Dec 6, 2019 at 3:49 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> >> According to section "Checks on Guest Control Registers, Debug Registers, and
> >> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
> >> of nested guests:
> >>
> >>      "The IA32_SYSENTER_ESP field and the IA32_SYSENTER_EIP field must each
> >>       contain a canonical address."
> >>
> >> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> >> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> >> ---
> >>   arch/x86/kvm/vmx/nested.c | 4 ++++
> >>   1 file changed, 4 insertions(+)
> >>
> >> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >> index 0e7c9301fe86..a2d1c305a7d8 100644
> >> --- a/arch/x86/kvm/vmx/nested.c
> >> +++ b/arch/x86/kvm/vmx/nested.c
> >> @@ -2770,6 +2770,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
> >>              CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
> >>                  return -EINVAL;
> >>
> >> +       if (CC(!is_noncanonical_address(vmcs12->guest_sysenter_esp)) ||
> >> +           CC(!is_noncanonical_address(vmcs12->guest_sysenter_eip)))
> >> +               return -EINVAL;
> >> +
> > Don't the hardware checks on the corresponding vmcs02 fields suffice
> > in this case?
>
> In prepare_vmcs02(), we have the following code:
>
>          if (vmx->nested.dirty_vmcs12 || hv_evmcs) {
>                  prepare_vmcs02_rare(vmx, vmcs12);
>
> If vmcs12 is dirty, we are setting these two fields from vmcs12 and I
> thought the values needed to be checked in software. Did I miss something ?

Typically, "guest state" doesn't have to be checked in software, as
long as (a) the vmcs12 field is copied unmodified to the corresponding
vmcs02 field, and (b) the virtual CPU enforces the same constraints as
the physical CPU. In this case, if there is a problem with the guest
state, the VM-entry to vmcs02 will immediately VM-exit with "VM-entry
failure due to invalid guest state," and L0 will reflect this exit
reason to L1.

> >
> >>          if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
> >>              CC(!kvm_pat_valid(vmcs12->guest_ia32_pat)))
> >>                  return -EINVAL;
> >> --
> >> 2.20.1
> >>
