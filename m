Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D71E100B0
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 22:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfD3UTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 16:19:45 -0400
Received: from mga17.intel.com ([192.55.52.151]:12514 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbfD3UTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 16:19:44 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 13:19:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,414,1549958400"; 
   d="scan'208";a="342226031"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga005.fm.intel.com with ESMTP; 30 Apr 2019 13:19:44 -0700
Date:   Tue, 30 Apr 2019 13:19:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: x86: Drop "caching" of always-available GPRs
Message-ID: <20190430201943.GA4868@linux.intel.com>
References: <20190430173619.15774-1-sean.j.christopherson@intel.com>
 <e61c4c2f-867a-131d-b59e-0e54970b2f90@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e61c4c2f-867a-131d-b59e-0e54970b2f90@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 30, 2019 at 10:03:59PM +0200, Paolo Bonzini wrote:
> On 30/04/19 19:36, Sean Christopherson wrote:
> > KVM's GPR caching logic is unconditionally emitted for all GPR accesses
> > (that go through the accessors), even when the register being accessed
> > is fixed and always available.  This bloats KVM due to the instructions
> > needed to test and set the available/dirty bitmaps, and to conditionally
> > invoke the .cache_reg() callback.  The latter is especially painful when
> > compiling with retpolines.
> > 
> > Eliminate the unnecessary overhead by:
> > 
> >  - Adding dedicated accessors for every GPR
> >  - Omitting the caching logic for GPRs that are always available
> >  - Preventing use of the unoptimized versions for fixed accesses
> > 
> > The last patch is an opportunistic clean up of VMX, which has gradually
> > acquired a bad habit of sprinkling in direct access to GPRs.
> 
> Another related cleanup is to replace these with the direct accessors:
> 
> arch/x86/kvm/vmx/nested.c:	vmcs12->guest_rsp = kvm_register_read(vcpu, VCPU_REGS_RSP);
> arch/x86/kvm/vmx/nested.c:	vmcs12->guest_rip = kvm_register_read(vcpu, VCPU_REGS_RIP);
> arch/x86/kvm/x86.c:	regs->rsp = kvm_register_read(vcpu, VCPU_REGS_RSP);
> arch/x86/kvm/svm.c:	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, hsave->save.rsp);
> arch/x86/kvm/svm.c:	kvm_register_write(&svm->vcpu, VCPU_REGS_RIP, hsave->save.rip);
> arch/x86/kvm/svm.c:	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, nested_vmcb->save.rsp);
> arch/x86/kvm/svm.c:	kvm_register_write(&svm->vcpu, VCPU_REGS_RIP, nested_vmcb->save.rip);
> arch/x86/kvm/vmx/nested.c:	kvm_register_write(vcpu, VCPU_REGS_RSP, vmcs12->guest_rsp);
> arch/x86/kvm/vmx/nested.c:	kvm_register_write(vcpu, VCPU_REGS_RIP, vmcs12->guest_rip);
> arch/x86/kvm/vmx/nested.c:	kvm_register_write(vcpu, VCPU_REGS_RSP, vmcs12->host_rsp);
> arch/x86/kvm/vmx/nested.c:	kvm_register_write(vcpu, VCPU_REGS_RIP, vmcs12->host_rip);
> arch/x86/kvm/x86.c:	kvm_register_write(vcpu, VCPU_REGS_RSP, regs->rsp);
> 
> I can take care of this.  I have applied patches 1 and 3.  I didn't apply
> patch 2 for the reasons I mentioned in my reply, and because I am not sure
> if it works properly---it should have flagged the above occurrences,
> shouldn't it?

I squeezed the cleanup into patch 2.  I should have called that out in the
changelog but didn't for whatever reason.  Probably would have been even
better to do the refactor in a separate patch.  Sorry :(
