Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BE01BCFCF
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 00:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgD1WUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 18:20:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:26741 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgD1WUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 18:20:11 -0400
IronPort-SDR: 9eTYK0Ki80pHPzGB9aS+XFf+aN7x33TQ61gd+MtoBe6TQhSl6x6ulvCgjqBP9syLBYc3pPkRzI
 riZukShdDsWQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 15:20:11 -0700
IronPort-SDR: pTtCLvWjqtF4QvauuVuS6xbdBEQ8G5baHf6iF3cul0p0dYsj9BFlAPk+IeX1OIcF0eoQ3bi+nh
 s+Evr0h4QT0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,328,1583222400"; 
   d="scan'208";a="367632604"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 28 Apr 2020 15:20:10 -0700
Date:   Tue, 28 Apr 2020 15:20:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 12/13] KVM: x86: Replace late check_nested_events() hack
 with more precise fix
Message-ID: <20200428222010.GN12735@linux.intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
 <20200423022550.15113-13-sean.j.christopherson@intel.com>
 <CALMp9eTiGdYPpejAOLNz7zzqP1wPXb_zSL02F27VMHeHGzANJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTiGdYPpejAOLNz7zzqP1wPXb_zSL02F27VMHeHGzANJg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 03:12:51PM -0700, Jim Mattson wrote:
> On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 7c49a7dc601f..d9d6028a77e0 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7755,24 +7755,10 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
> >                 --vcpu->arch.nmi_pending;
> >                 vcpu->arch.nmi_injected = true;
> >                 kvm_x86_ops.set_nmi(vcpu);
> > -       } else if (kvm_cpu_has_injectable_intr(vcpu)) {
> > -               /*
> > -                * Because interrupts can be injected asynchronously, we are
> > -                * calling check_nested_events again here to avoid a race condition.
> > -                * See https://lkml.org/lkml/2014/7/2/60 for discussion about this
> > -                * proposal and current concerns.  Perhaps we should be setting
> > -                * KVM_REQ_EVENT only on certain events and not unconditionally?
> > -                */
> > -               if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
> > -                       r = kvm_x86_ops.check_nested_events(vcpu);
> > -                       if (r != 0)
> > -                               return r;
> > -               }
> > -               if (kvm_x86_ops.interrupt_allowed(vcpu)) {
> > -                       kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
> > -                                           false);
> > -                       kvm_x86_ops.set_irq(vcpu);
> > -               }
> > +       } else if (kvm_cpu_has_injectable_intr(vcpu) &&
> > +                  kvm_x86_ops.interrupt_injection_allowed(vcpu)) {
> > +               kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
> > +               kvm_x86_ops.set_irq(vcpu);
> >         }
> So, that's what this mess was all about! Well, this certainly looks better.

Right?  I can't count the number of times I've looked at this code and
wondered what the hell it was doing.

Side topic, I just realized you're reviewing my original series.  Paolo
commandeered it to extend it to SVM. https://patchwork.kernel.org/cover/11508679/

