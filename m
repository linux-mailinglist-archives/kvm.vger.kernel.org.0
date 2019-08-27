Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826A99F375
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 21:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730964AbfH0Tta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 15:49:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:27796 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbfH0Tta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 15:49:30 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 12:49:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="197377356"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 27 Aug 2019 12:49:29 -0700
Date:   Tue, 27 Aug 2019 12:49:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] KVM: x86: Don't update RIP or do single-step on faulting
 emulation
Message-ID: <20190827194928.GH27459@linux.intel.com>
References: <20190823205544.24052-1-sean.j.christopherson@intel.com>
 <CALMp9eSwxTdigRkACRgr=avg8HZh+gPXgPnwd7+CaNEEuS2tQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSwxTdigRkACRgr=avg8HZh+gPXgPnwd7+CaNEEuS2tQA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 27, 2019 at 12:12:51PM -0700, Jim Mattson wrote:
> On Fri, Aug 23, 2019 at 1:55 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -6611,12 +6611,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
> >                 unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
> >                 toggle_interruptibility(vcpu, ctxt->interruptibility);
> >                 vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
> > -               kvm_rip_write(vcpu, ctxt->eip);
> > -               if (r == EMULATE_DONE && ctxt->tf)
> > -                       kvm_vcpu_do_singlestep(vcpu, &r);
> >                 if (!ctxt->have_exception ||
> > -                   exception_type(ctxt->exception.vector) == EXCPT_TRAP)
> > +                   exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
> 
> NYC, but...
> 
> I don't think this check for "exception_type" is quite right.  A
> general detect fault (which can be synthesized by check_dr_read) is
> mischaracterized by exception_type() as a trap. Or maybe I'm missing
> something? (I often am.)

Pretty sure you're not missing anything.

And while we're poking holes in #DB emulation, int1/icebp isn't emulated
correctly as it should be reinjected with INTR_TYPE_PRIV_SW_EXCEPTION, not
as a INTR_TYPE_HARD_EXCEPTION.  The CPU automically clears DR7.GD on #DB,
unless the #DB is due to int1...
