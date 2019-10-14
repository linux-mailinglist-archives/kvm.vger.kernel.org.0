Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564CBD69F4
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 21:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388134AbfJNTPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 15:15:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:1516 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731508AbfJNTPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 15:15:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 12:15:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="346850266"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 14 Oct 2019 12:15:22 -0700
Date:   Mon, 14 Oct 2019 12:15:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Cross <dcross@google.com>, Peter Shier <pshier@google.com>
Subject: Re: [PATCH v3] KVM: nVMX: Don't leak L1 MMIO regions to L2
Message-ID: <20191014191522.GG22962@linux.intel.com>
References: <20191010232819.135894-1-jmattson@google.com>
 <20191014175936.GD22962@linux.intel.com>
 <CALMp9eS_fYjyTDG75316cdyCp6NRHAHmN2J+sTf9uxvUfiEsQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eS_fYjyTDG75316cdyCp6NRHAHmN2J+sTf9uxvUfiEsQA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 11:50:37AM -0700, Jim Mattson wrote:
> On Mon, Oct 14, 2019 at 10:59 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > > @@ -2947,19 +2947,18 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> > >                       vmx->nested.apic_access_page = NULL;
> > >               }
> > >               page = kvm_vcpu_gpa_to_page(vcpu, vmcs12->apic_access_addr);
> > > -             /*
> > > -              * If translation failed, no matter: This feature asks
> > > -              * to exit when accessing the given address, and if it
> > > -              * can never be accessed, this feature won't do
> > > -              * anything anyway.
> > > -              */
> > >               if (!is_error_page(page)) {
> > >                       vmx->nested.apic_access_page = page;
> > >                       hpa = page_to_phys(vmx->nested.apic_access_page);
> > >                       vmcs_write64(APIC_ACCESS_ADDR, hpa);
> > >               } else {
> > > -                     secondary_exec_controls_clearbit(vmx,
> > > -                             SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
> > > +                     pr_debug_ratelimited("%s: non-cacheable APIC-access address in vmcs12\n",
> > > +                                          __func__);
> >
> > Hmm, "non-cacheable" is confusing, especially in the context of the APIC,
> > which needs to be mapped "uncacheable".  Maybe just "invalid"?
> 
> "Invalid" is not correct. L1 MMIO addresses are valid; they're just
> not cacheable. Perhaps:
> 
> "vmcs12 APIC-access address references a page not backed by a memslot in L1"?

Hmm, technically is_error_page() isn't limited to a non-existent memslot,
any GFN that doesn't lead to a 'struct page' will trigger is_error_page().

Maybe just spit out what literally went wrong?  E.g something like

	pr_debug_ratelimited("%s: no backing 'struct page' for APIC-access address in vmcs12\n"

> > > +                     vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> > > +                     vcpu->run->internal.suberror =
> > > +                             KVM_INTERNAL_ERROR_EMULATION;
> > > +                     vcpu->run->internal.ndata = 0;
> > > +                     return false;
> > >               }
> > >       }
> > >
> > > @@ -3004,6 +3003,7 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> > >               exec_controls_setbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
> > >       else
> > >               exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
> > > +     return true;
> > >  }
> > >
> > >  /*
> > > @@ -3042,13 +3042,15 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
> > >  /*
> > >   * If from_vmentry is false, this is being called from state restore (either RSM
> > >   * or KVM_SET_NESTED_STATE).  Otherwise it's called from vmlaunch/vmresume.
> > > -+ *
> > > -+ * Returns:
> > > -+ *   0 - success, i.e. proceed with actual VMEnter
> > > -+ *   1 - consistency check VMExit
> > > -+ *  -1 - consistency check VMFail
> > > + *
> > > + * Returns:
> > > + *   ENTER_VMX_SUCCESS: Successfully entered VMX non-root mode
> >
> > "Enter VMX" usually refers to VMXON, e.g. the title of VMXON in the SDM is
> > "Enter VMX Operation".
> >
> > Maybe NVMX_ENTER_NON_ROOT_?
> 
> How about NESTED_VMX_ENTER_NON_ROOT_MODE_STATUS_?
> 
> > > + *   ENTER_VMX_VMFAIL:  Consistency check VMFail
> > > + *   ENTER_VMX_VMEXIT:  Consistency check VMExit
> > > + *   ENTER_VMX_ERROR:   KVM internal error
> >
> > Probably need to more explicit than VMX_ERROR, e.g. all of the VM-Fail
> > defines are prefixed with VMXERR_##.
> >
> > May ENTER_VMX_KVM_ERROR?  (Or NVMX_ENTER_NON_ROOT_KVM_ERROR).
> 
> NESTED_VMX_ENTER_NON_ROOT_MODE_STATUS_KVM_INTERNAL_ERROR?

I can't tell if you're making fun of me for being pedantic about "Enter VMX",
or if you really want to have a 57 character enum.  :-)

NESTED_VMENTER_?
