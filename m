Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D222441D1
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 01:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgHMX7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 19:59:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:25117 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgHMX7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 19:59:43 -0400
IronPort-SDR: ui1FfeLzvUMBC53GarRORti6/Csus1obBqNlOKdJDUfREcYyEYZlprLqbsKtpZnmqDNUJZ8qiC
 pbW/UtA8tjJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9712"; a="153564185"
X-IronPort-AV: E=Sophos;i="5.76,310,1592895600"; 
   d="scan'208";a="153564185"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2020 16:59:42 -0700
IronPort-SDR: ozi2KAtml8F61J6OauJYnHc5KFeCKaePUjMuYNDLVUrn6U49nkuYERNi0NTCdnJFvpK74ntBs/
 X8TRa34IqidA==
X-IronPort-AV: E=Sophos;i="5.76,310,1592895600"; 
   d="scan'208";a="470398296"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2020 16:59:42 -0700
Date:   Thu, 13 Aug 2020 16:59:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH] kvm: nVMX: flush TLB when decoded insn != VM-exit reason
Message-ID: <20200813235940.GA4327@linux.intel.com>
References: <20200616224305.44242-1-oupton@google.com>
 <20200813170331.GI29439@linux.intel.com>
 <CAOQ_QsiVV7Btj5yJ5Dpqxf3V7OuHY3N9b1xW6rrZjyv6dOC8ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QsiVV7Btj5yJ5Dpqxf3V7OuHY3N9b1xW6rrZjyv6dOC8ig@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 03:44:08PM -0500, Oliver Upton wrote:
> On Thu, Aug 13, 2020 at 12:03 PM Sean Christopherson
> > > +      *
> > > +      * Rather than synthesizing a VM-exit into L1 for every possible
> > > +      * instruction just flush the TLB, resume L2, and let hardware generate
> > > +      * the appropriate VM-exit.
> > > +      */
> > > +     vmx_flush_tlb_gva(vcpu, kvm_rip_read(vcpu));
> >
> > This is wrong, it should flush kvm_get_linear_rip(vcpu).
> >
> 
> I do not believe that the aim of this patch will work anymore, since:
> 
> 1dbf5d68af6f ("KVM: VMX: Add guest physical address check in EPT
> violation and misconfig")
> 
> Since it is possible to get into the emulator on any instruction that
> induces an EPT violation, we'd wind up looping when we believe the
> instruction needs to exit to L1 (TLB flush, resume guest, hit the same
> EPT violation. Rinse, wash, repeat).

kvm_get_linear_rip() doesn't walk any page tables, it simply accounts for a
non-zero CS.base when !64-bit mode.  If we really wanted to, this could use
the emulation context's cached _eip, but I don't see any value in that since
both GUEST_CS_* and GUEST_RIP will already be cached by KVM.

unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)
{
        if (is_64_bit_mode(vcpu))
                return kvm_rip_read(vcpu);
        return (u32)(get_segment_base(vcpu, VCPU_SREG_CS) +
                     kvm_rip_read(vcpu));
}



> 
> > > +     return X86EMUL_RETRY_INSTR;
> > >  }
> > >
> > >  #ifdef CONFIG_X86_64
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 00c88c2f34e4..2ab47485100f 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -6967,7 +6967,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > >
> > >       r = x86_emulate_insn(ctxt);
> > >
> > > -     if (r == EMULATION_INTERCEPTED)
> > > +     if (r == EMULATION_INTERCEPTED || r == EMULATION_RETRY_INSTR)
> > >               return 1;
> > >
> > >       if (r == EMULATION_FAILED) {
> > > --
> > > 2.27.0.290.gba653c62da-goog
> > >
