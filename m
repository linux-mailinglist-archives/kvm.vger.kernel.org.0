Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE87C246EA4
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 19:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgHQReV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 13:34:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:14710 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730675AbgHQReK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 13:34:10 -0400
IronPort-SDR: waWDAcoRZtBPoTZNoJChtvzVFCGzIAR4Zzidbs57rf6CZW/F42is/z/d9I9On8PHy33Bc4U7Sn
 v1RG3JHVj+oQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="152168693"
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="152168693"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 10:34:09 -0700
IronPort-SDR: HG2n+zw0gztWeeAYlTL7GL50fhqL0ogiM+soswTPuxhFIdIgz7fb+V7+CAtYNSPFNaOfJDxqVP
 3ldHTtml9dxQ==
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="319787242"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 10:34:08 -0700
Date:   Mon, 17 Aug 2020 10:34:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH] kvm: nVMX: flush TLB when decoded insn != VM-exit reason
Message-ID: <20200817173407.GG22407@linux.intel.com>
References: <20200616224305.44242-1-oupton@google.com>
 <20200813170331.GI29439@linux.intel.com>
 <CAOQ_QsiVV7Btj5yJ5Dpqxf3V7OuHY3N9b1xW6rrZjyv6dOC8ig@mail.gmail.com>
 <20200813235940.GA4327@linux.intel.com>
 <CAOQ_Qsj2jw+tGkJkRdaQXPrSKhzu-b=SPneBToCz2DrMM3ZYOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_Qsj2jw+tGkJkRdaQXPrSKhzu-b=SPneBToCz2DrMM3ZYOg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 14, 2020 at 09:56:33AM -0500, Oliver Upton wrote:
> On Thu, Aug 13, 2020 at 6:59 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Thu, Aug 13, 2020 at 03:44:08PM -0500, Oliver Upton wrote:
> > > On Thu, Aug 13, 2020 at 12:03 PM Sean Christopherson
> > > > > +      *
> > > > > +      * Rather than synthesizing a VM-exit into L1 for every possible
> > > > > +      * instruction just flush the TLB, resume L2, and let hardware generate
> > > > > +      * the appropriate VM-exit.
> > > > > +      */
> > > > > +     vmx_flush_tlb_gva(vcpu, kvm_rip_read(vcpu));
> > > >
> > > > This is wrong, it should flush kvm_get_linear_rip(vcpu).
> > > >
> > >
> > > I do not believe that the aim of this patch will work anymore, since:
> > >
> > > 1dbf5d68af6f ("KVM: VMX: Add guest physical address check in EPT
> > > violation and misconfig")
> > >
> > > Since it is possible to get into the emulator on any instruction that
> > > induces an EPT violation, we'd wind up looping when we believe the
> > > instruction needs to exit to L1 (TLB flush, resume guest, hit the same
> > > EPT violation. Rinse, wash, repeat).
> >
> > kvm_get_linear_rip() doesn't walk any page tables, it simply accounts for a
> > non-zero CS.base when !64-bit mode.  If we really wanted to, this could use
> > the emulation context's cached _eip, but I don't see any value in that since
> > both GUEST_CS_* and GUEST_RIP will already be cached by KVM.
> >
> > unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)
> > {
> >         if (is_64_bit_mode(vcpu))
> >                 return kvm_rip_read(vcpu);
> >         return (u32)(get_segment_base(vcpu, VCPU_SREG_CS) +
> >                      kvm_rip_read(vcpu));
> > }
> 
> Sorry, I was a tad imprecise. I haven't any issues with your
> suggestion. Rather, I believe that my overall patch is ineffective.
> 
> Suppose we had an EPT violation for a GPA that exceeded the guest's
> MAXPHYADDR. Let's also say that the EPT violation occurred on the
> memory operand of an LMSW instruction. Per the aforementioned patch,
> we will dive into the emulator. Since we check intercepts before
> reading the operand out of memory, we will fall through to the default
> case, set intercepted = true, flush TLB and resume.

Hrm.  The new invocation of kvm_emulate_instruction() feels incomplete from
the perspective that it doesn't have a flag that states "this should always
cause a #PF, freak out if it doesn't".  Such a flag would allow keeping this
approach as this interception logic could bail early if it is set, knowing
that the emulator will inject a #PF or bail to userspace (or something like
that).
