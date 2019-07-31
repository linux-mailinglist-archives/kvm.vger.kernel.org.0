Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E4E7D202
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 01:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbfGaXhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 19:37:33 -0400
Received: from mga07.intel.com ([134.134.136.100]:54398 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729275AbfGaXhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 19:37:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 16:37:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,332,1559545200"; 
   d="scan'208";a="256368246"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 31 Jul 2019 16:37:31 -0700
Date:   Wed, 31 Jul 2019 16:37:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH RFC 3/5] x86: KVM: svm: clear interrupt shadow on all
 paths in skip_emulated_instruction()
Message-ID: <20190731233731.GA2845@linux.intel.com>
References: <20190620110240.25799-1-vkuznets@redhat.com>
 <20190620110240.25799-4-vkuznets@redhat.com>
 <CALMp9eQ85h58NMDh-yOYvHN6_2f2T-wu63f+yLnNbwuG+p3Uvw@mail.gmail.com>
 <87ftmm71p3.fsf@vitty.brq.redhat.com>
 <36a9f411-f90c-3ffa-9ee3-6ebee13a763f@redhat.com>
 <CALMp9eQLCEzfdNzdhPtCf3bD-5c6HrSvJqP7idyoo4Gf3i5O1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQLCEzfdNzdhPtCf3bD-5c6HrSvJqP7idyoo4Gf3i5O1w@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 31, 2019 at 01:27:53PM -0700, Jim Mattson wrote:
> On Wed, Jul 31, 2019 at 9:37 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 31/07/19 15:50, Vitaly Kuznetsov wrote:
> > > Jim Mattson <jmattson@google.com> writes:
> > >
> > >> On Thu, Jun 20, 2019 at 4:02 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > >>>
> > >>> Regardless of the way how we skip instruction, interrupt shadow needs to be
> > >>> cleared.
> > >>
> > >> This change is definitely an improvement, but the existing code seems
> > >> to assume that we never call skip_emulated_instruction on a
> > >> POP-SS/MOV-to-SS/STI. Is that enforced anywhere?
> > >
> > > (before I send v1 of the series) I looked at the current code and I
> > > don't think it is enforced, however, VMX version does the same and
> > > honestly I can't think of a situation when we would be doing 'skip' for
> > > such an instruction.... and there's nothing we can easily enforce from
> > > skip_emulated_instruction() as we have no idea what the instruction
> > > is...
> 
> Can't we still coerce kvm into emulating any instruction by leveraging
> a stale ITLB entry? The 'emulator' kvm-unit-test did this before the
> KVM forced emulation prefix was introduced, but I haven't checked to
> see if the original (admittedly fragile) approach still works. Also,
> for POP-SS, you could always force emulation by mapping the %rsp
> address beyond guest physical memory. The hypervisor would then have
> to emulate the instruction to provide bus-error semantics.
> 
> > I agree, I think a comment is worthwhile but we can live with the
> > limitation.
> 
> I think we can live with the limitation, but I'd really prefer to see
> a KVM exit with KVM_INTERNAL_ERROR_EMULATION for an instruction that
> kvm doesn't emulate properly. That seems better than just a comment
> that the virtual CPU doesn't behave as architected. (I realize that I
> am probably in the minority here.)

At a glance, the full emulator models behavior correctly, e.g. see
toggle_interruptibility() and setters of ctxt->interruptibility.

I'm pretty sure that leaves the EPT misconfig MMIO and APIC access EOI
fast paths as the only (VMX) path that would incorrectly handle a
MOV/POP SS.  Reading the guest's instruction stream to detect MOV/POP SS
would defeat the whole "fast path" thing, not to mention both paths aren't
exactly architecturally compliant in the first place.
