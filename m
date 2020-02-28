Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD8E174209
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 23:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgB1WgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 17:36:24 -0500
Received: from mga14.intel.com ([192.55.52.115]:63859 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgB1WgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 17:36:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 14:36:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,497,1574150400"; 
   d="scan'208";a="411545131"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 28 Feb 2020 14:36:22 -0800
Date:   Fri, 28 Feb 2020 14:36:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Mohammed Gamal <mgamal@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: VMX: Add guest physical address check in EPT
 violation and misconfig
Message-ID: <20200228223622.GK2329@linux.intel.com>
References: <20200227172306.21426-1-mgamal@redhat.com>
 <20200227172306.21426-3-mgamal@redhat.com>
 <CALMp9eR7heTGQ6zwYrK5rJ-xs_wKqz49gfcNtaEC7S6J7n2aFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eR7heTGQ6zwYrK5rJ-xs_wKqz49gfcNtaEC7S6J7n2aFQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 27, 2020 at 09:55:32AM -0800, Jim Mattson wrote:
> On Thu, Feb 27, 2020 at 9:23 AM Mohammed Gamal <mgamal@redhat.com> wrote:
> >
> > Check guest physical address against it's maximum physical memory. If
> Nit: "its," without an apostrophe.
> 
> > the guest's physical address exceeds the maximum (i.e. has reserved bits
> > set), inject a guest page fault with PFERR_RSVD_MASK.

Wish I had actually read this series when it first flew by, just spent
several hours debugging this exact thing when running the "access" test.

> > Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 63aaf44edd1f..477d196aa235 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5162,6 +5162,12 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
> >         gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> >         trace_kvm_page_fault(gpa, exit_qualification);
> >
> > +       /* Check if guest gpa doesn't exceed physical memory limits */
> > +       if (gpa >= (1ull << cpuid_maxphyaddr(vcpu))) {

Add a helper for this, it's easier than copy-pasting the comment and code
everywhere.  BIT_ULL() is also handy.

static inline bool kvm_mmu_is_illegal_gpa(gpa_t gpa)
{
	return (gpa < BIT_ULL(cpuid_maxphyaddr(vcpu)));
}

> > +               kvm_inject_rsvd_bits_pf(vcpu, gpa);
> 
> Even if PFERR_RSVD_MASK is set in the page fault error code, shouldn't
> we set still conditionally set:
>     PFERR_WRITE_MASK - for an attempted write
>     PFERR_USER_MASK - for a usermode access
>     PFERR_FETCH_MASK - for an instruction fetch

Yep.  Move this down below where error_code is calculated.  Then the code
should be something like this.  Not fun to handle this with EPT :-(

Note, VMCS.GUEST_LINEAR_ADDRESS isn't guaranteed to be accurate, e.g. if
the guest is putting bad gpas into Intel PT, but I don't think we have any
choice but to blindly cram it in and hope for the best.

	if (unlikely(kvm_mmu_is_illegal_gpa(vcpu, gpa))) {
		/* Morph the EPT error code into a #PF error code. */
		error_code &= ~(PFERR_USER_MASK | PFERR_GUEST_FINAL_MASK |
				PFERR_GUEST_PAGE_MASK);
		if (vmx_get_cpl(vcpu) == 3)
			error_code |= PFERR_USER_MASK;
		error_code |= PFERR_PRESENT_MASK;

		kvm_inject_rsvd_bits_pf(vcpu, vmcs_readl(GUEST_LINEAR_ADDRESS),
					error_code);

		return 1;
	}

 
> > +               return 1;
> > +       }
> > +
> >         /* Is it a read fault? */
> >         error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
> >                      ? PFERR_USER_MASK : 0;
> > @@ -5193,6 +5199,13 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
> >          * nGPA here instead of the required GPA.
> >          */
> >         gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> > +
> > +       /* Check if guest gpa doesn't exceed physical memory limits */
> > +       if (gpa >= (1ull << cpuid_maxphyaddr(vcpu))) {
> > +               kvm_inject_rsvd_bits_pf(vcpu, gpa);
> 
> And here as well?

This shouldn't happen.  If KVM creates a bad EPTE for an illegal GPA, we
done goofed up.  I.e.

	if (WARN_ON_ONCE(kvm_mmu_is_illegal_gpa(vcpu, gpa))) {
		vcpu->run->blah = blah;
		return 0;
	}

> 
> > +               return 1;
> > +       }
> > +
> >         if (!is_guest_mode(vcpu) &&
> >             !kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
> >                 trace_kvm_fast_mmio(gpa);
> > --
> > 2.21.1
> >
