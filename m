Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE1EA44753
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbfFMQ6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:58:45 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43732 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729873AbfFMAmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 20:42:46 -0400
Received: by mail-oi1-f194.google.com with SMTP id w79so13109789oif.10;
        Wed, 12 Jun 2019 17:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nzfgSWaDyWQ7VYFEA2FnSpF180XqoXN/iBONghZdkoM=;
        b=h+1NR0mKWIopBaYt5fDVT1IjV39CbGYd8VsFUNeDRYd+ZrL/wB937Mnqd0OLXohUOZ
         f0p6idhAJ9VbwAburlhluuM+NOcUa59YvqgIGIKJSljFTBFXQh+2At5Ya0+k1b9o2Dm2
         7dXZwo7/AIywLr6AnTNr33L3fRbGeTii7QWWRDq+/FosBKcGNAwMDsx1LDRgh6qnsJ97
         7nspxr7U8Mu2LMOXWjnbmnK8HI1z0unWb6lpqTrieIjxBFhf7WMUJxJCrz2Vg2010Ilq
         8pwrqYj7Wn1dLVQWJvOmoKbRxuEg8c9RfTg3iI6SgP0IrbaWUeCmN0KmeXeptTegDv5u
         ZN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nzfgSWaDyWQ7VYFEA2FnSpF180XqoXN/iBONghZdkoM=;
        b=iEISjYc9XeE3vRWeta5VhKKQrqv8D7IPVbeuD1XB2rwJE6Vq5otBy7cpSB24w+sSPr
         Ho0Mfh/Sg0Uak9TfIfvTtmFIwHV/Y5q4b13RISzEzp8aSH6xFTX6STaBqyjKnrnIjfth
         kaiiqPL3xkwj3Bw051X2uTVcOtW4SqLaUcjpJ1FRzntmoOpvG3K6b1acd2J278/fMqp2
         2Ag8ihFZ9wKEkDF48rWPl7jDjsrgT+Y7k06GpSDiBFAJ2oy9raidKqSzH1uvKQxeW7Bi
         dlKLbbpC4XB2PquL56mxb2sETbGux+CjQcnMuqBg7OEqcjqqMSbDsq5LaT+noEZUaXU/
         rCWQ==
X-Gm-Message-State: APjAAAWztaLrNhxg48IQpCd5ab350QEPFZDuZ7/fx1vUysgUKcuAK1e7
        WhjCTFjLTEtr+eKS1K8NsJu00T/ILjOL0LEqSWM=
X-Google-Smtp-Source: APXvYqwmARrJG1lRaE0H4jiNgrJRy7gpduTn2xibtdvc0yq/mKt4J1wyqShWwfSNQuT9EuDT4PI4PTpPDdfmXhaz0Us=
X-Received: by 2002:aca:b9d4:: with SMTP id j203mr1279874oif.5.1560386565463;
 Wed, 12 Jun 2019 17:42:45 -0700 (PDT)
MIME-Version: 1.0
References: <1560238451-19495-1-git-send-email-wanpengli@tencent.com>
 <1560238451-19495-2-git-send-email-wanpengli@tencent.com> <20190612160123.GH20308@linux.intel.com>
In-Reply-To: <20190612160123.GH20308@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 13 Jun 2019 08:43:28 +0800
Message-ID: <CANRm+CyyCq5keLokqu5ZZodnyvd-AmGejY_O3Gz2pcGWBrz=WA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] KVM: X86: Dynamic allocate core residency msr state
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jun 2019 at 00:01, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Jun 11, 2019 at 03:34:07PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Dynamic allocate core residency msr state. MSR_CORE_C1_RES is unreadabl=
e
> > except for ATOM platform, so it is ignore here.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 11 +++++++++++
> >  arch/x86/kvm/vmx/vmx.c          |  5 +++++
> >  2 files changed, 16 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 15e973d..bd615ee 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -538,6 +538,15 @@ struct kvm_vcpu_hv {
> >       cpumask_t tlb_flush;
> >  };
> >
> > +#define NR_CORE_RESIDENCY_MSRS 3
> > +
> > +struct kvm_residency_msr {
> > +     s64 value;
> > +     u32 index;
> > +     bool delta_from_host;
> > +     bool count_with_host;
> > +};
> > +
> >  struct kvm_vcpu_arch {
> >       /*
> >        * rip and regs accesses must go through
> > @@ -785,6 +794,8 @@ struct kvm_vcpu_arch {
> >
> >       /* AMD MSRC001_0015 Hardware Configuration */
> >       u64 msr_hwcr;
> > +
> > +     struct kvm_residency_msr *core_cstate_msrs;
>
> Why are these in kvm_vcpu_arch?  AFAICT they're only wired up for VMX.

They can be used by SVM later though I'm too busy to do that.

Regards,
Wanpeng Li
