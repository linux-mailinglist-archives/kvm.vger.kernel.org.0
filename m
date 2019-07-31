Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA457D221
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 01:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbfGaX4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 19:56:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:41458 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfGaX4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 19:56:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 16:56:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,332,1559545200"; 
   d="scan'208";a="196581614"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jul 2019 16:56:38 -0700
Date:   Wed, 31 Jul 2019 16:56:37 -0700
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
Message-ID: <20190731235637.GB2845@linux.intel.com>
References: <20190620110240.25799-1-vkuznets@redhat.com>
 <20190620110240.25799-4-vkuznets@redhat.com>
 <CALMp9eQ85h58NMDh-yOYvHN6_2f2T-wu63f+yLnNbwuG+p3Uvw@mail.gmail.com>
 <87ftmm71p3.fsf@vitty.brq.redhat.com>
 <36a9f411-f90c-3ffa-9ee3-6ebee13a763f@redhat.com>
 <CALMp9eQLCEzfdNzdhPtCf3bD-5c6HrSvJqP7idyoo4Gf3i5O1w@mail.gmail.com>
 <20190731233731.GA2845@linux.intel.com>
 <CALMp9eRRqCLKAL4FoZVMk=fHfnrN7EnTVxR___soiHUdrHLAMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRRqCLKAL4FoZVMk=fHfnrN7EnTVxR___soiHUdrHLAMQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 31, 2019 at 04:45:21PM -0700, Jim Mattson wrote:
> On Wed, Jul 31, 2019 at 4:37 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> 
> > At a glance, the full emulator models behavior correctly, e.g. see
> > toggle_interruptibility() and setters of ctxt->interruptibility.
> >
> > I'm pretty sure that leaves the EPT misconfig MMIO and APIC access EOI
> > fast paths as the only (VMX) path that would incorrectly handle a
> > MOV/POP SS.  Reading the guest's instruction stream to detect MOV/POP SS
> > would defeat the whole "fast path" thing, not to mention both paths aren't
> > exactly architecturally compliant in the first place.
> 
> The proposed patch clears the interrupt shadow in the VMCB on all
> paths through svm's skip_emulated_instruction. If this happens at the
> tail end of emulation, it doesn't matter if the full emulator does the
> right thing.

Unless I'm missing something, skip_emulated_instruction() isn't called in
the emulation case, x86_emulate_instruction() updates %rip directly, e.g.:

	if (writeback) {
		unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
		toggle_interruptibility(vcpu, ctxt->interruptibility);
		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
		kvm_rip_write(vcpu, ctxt->eip);
		if (r == EMULATE_DONE && ctxt->tf)
			kvm_vcpu_do_singlestep(vcpu, &r);
		if (!ctxt->have_exception ||
		    exception_type(ctxt->exception.vector) == EXCPT_TRAP)
			__kvm_set_rflags(vcpu, ctxt->eflags);

		/*
		 * For STI, interrupts are shadowed; so KVM_REQ_EVENT will
		 * do nothing, and it will be requested again as soon as
		 * the shadow expires.  But we still need to check here,
		 * because POPF has no interrupt shadow.
		 */
		if (unlikely((ctxt->eflags & ~rflags) & X86_EFLAGS_IF))
			kvm_make_request(KVM_REQ_EVENT, vcpu);
	}
