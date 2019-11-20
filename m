Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42AE51041AF
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 18:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbfKTRCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 12:02:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:33587 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729936AbfKTRC3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 12:02:29 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 09:02:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,222,1571727600"; 
   d="scan'208";a="381430404"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 20 Nov 2019 09:02:28 -0800
Date:   Wed, 20 Nov 2019 09:02:28 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI
 fastpath
Message-ID: <20191120170228.GC32572@linux.intel.com>
References: <1574145389-12149-1-git-send-email-wanpengli@tencent.com>
 <09CD3BD3-1F5E-48DA-82ED-58E3196DBD83@oracle.com>
 <CANRm+CxZ5Opj44Aj+LL18nVSuU63hXpt9U9E3jJEQP67Hx6WMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CxZ5Opj44Aj+LL18nVSuU63hXpt9U9E3jJEQP67Hx6WMg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 20, 2019 at 11:49:36AM +0800, Wanpeng Li wrote:
> On Tue, 19 Nov 2019 at 20:11, Liran Alon <liran.alon@oracle.com> wrote:
> > > +
> > > +static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu, u32 *exit_reason)
> > > {
> > >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> > >
> > > @@ -6231,6 +6263,8 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> > >               handle_external_interrupt_irqoff(vcpu);
> > >       else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
> > >               handle_exception_nmi_irqoff(vmx);
> > > +     else if (vmx->exit_reason == EXIT_REASON_MSR_WRITE)
> > > +             *exit_reason = handle_ipi_fastpath(vcpu);
> >
> > 1) This case requires a comment as the only reason it is called here is an
> > optimisation.  In contrast to the other cases which must be called before
> > interrupts are enabled on the host.
> >
> > 2) I would rename handler to handle_accel_set_msr_irqoff().  To signal this
> > handler runs with host interrupts disabled and to make it a general place
> > for accelerating WRMSRs in case we would require more in the future.
> 
> Yes, TSCDEADLINE/VMX PREEMPTION TIMER is in my todo list after this merged
> upstream, handle all the comments in v3, thanks for making this nicer
> further. :)

Handling those is very different than what is being proposed here though.
For this case, only the side effect of the WRMSR is being expedited, KVM
still goes through the heavy VM-Exit handler path to handle emulating the
WRMSR itself.

To truly expedite things like TSCDEADLINE, the entire emulation of WRMSR
would need be handled without going through the standard VM-Exit handler,
which is a much more fundamental change to vcpu_enter_guest() and has
different requirements.  For example, keeping IRQs disabled is pointless
for generic WRMSR emulation since the interrupt will fire as soon as KVM
resumes the guest, whereas keeping IRQs disabled for processing ICR writes
is a valid optimization since recognition of the IPI on the dest vCPU
isn't dependent on KVM resuming the current vCPU.

Rather than optimizing full emulation flows one at a time, i.e. exempting
the ICR case, I wonder if we're better off figuring out a way to improve
the performance of VM-Exit handling at a larger scale, e.g. avoid locking
kvm->srcu unnecessarily, Andrea's retpolin changes, etc...

Oh, a random thought, this fast path needs to be skipped if KVM is
running L2, i.e. is_guest_mode(vcpu) is true.
