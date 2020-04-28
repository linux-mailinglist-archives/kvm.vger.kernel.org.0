Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BE81BD045
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 00:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgD1W7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 18:59:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:34722 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgD1W7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 18:59:49 -0400
IronPort-SDR: 17JYpusfx3wqeAcXgrT20D8bbng2g8fPPxAmysmfymBQjzl8HAaFuEuDfGJGqJG6sDgsKjn7iz
 i2EixqJ7V3OA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 15:59:49 -0700
IronPort-SDR: FvwbRXz7kliL1mLjNirEPURHs2TcLkEdMsEFv0ZhSYG0aC/xjPkrz/fN1UKWCYn78sFrTzxOnA
 Lv9+xwG2tQMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,328,1583222400"; 
   d="scan'208";a="246656016"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 28 Apr 2020 15:59:49 -0700
Date:   Tue, 28 Apr 2020 15:59:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 09/13] KVM: nVMX: Prioritize SMI over nested IRQ/NMI
Message-ID: <20200428225949.GP12735@linux.intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
 <20200423022550.15113-10-sean.j.christopherson@intel.com>
 <CALMp9eSuYqeVmWhb6q7T5DAW_Npbuin_N1+sbWjvcu0zTqiwsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eSuYqeVmWhb6q7T5DAW_Npbuin_N1+sbWjvcu0zTqiwsQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 03:04:02PM -0700, Jim Mattson wrote:
> On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Check for an unblocked SMI in vmx_check_nested_events() so that pending
> > SMIs are correctly prioritized over IRQs and NMIs when the latter events
> > will trigger VM-Exit.  This also fixes an issue where an SMI that was
> > marked pending while processing a nested VM-Enter wouldn't trigger an
> > immediate exit, i.e. would be incorrectly delayed until L2 happened to
> > take a VM-Exit.
> >
> > Fixes: 64d6067057d96 ("KVM: x86: stubs for SMM support")
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 1fdaca5fd93d..8c16b190816b 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3750,6 +3750,12 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> >                 return 0;
> >         }
> >
> > +       if (vcpu->arch.smi_pending && !is_smm(vcpu)) {
> > +               if (block_nested_events)
> > +                       return -EBUSY;
> > +               goto no_vmexit;
> > +       }
> > +
> 
> From the SDM, volume 3:
> 
> • System-management interrupts (SMIs), INIT signals, and higher
> priority events take priority over MTF VM exits.
> 
> I think this block needs to be moved up.

Hrm.  It definitely needs to be moved above the preemption timer, though I
can't find any public documentation about the preemption timer's priority.
Preemption timer is lower priority than MTF, ergo it's not in the same
class as SMI.

Regarding SMI vs. MTF and #DB trap, to actually prioritize SMIs above MTF
and #DBs, we'd need to save/restore MTF and pending #DBs via SMRAM.  I
think it makes sense to take the easy road and keep SMI after the traps,
with a comment to say it's technically wrong but not worth fixing.
