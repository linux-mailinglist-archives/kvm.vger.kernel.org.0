Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10AD7FC9D4
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 16:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfKNPWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 10:22:37 -0500
Received: from mga12.intel.com ([192.55.52.136]:34667 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbfKNPWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 10:22:36 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 07:22:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="214560663"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 14 Nov 2019 07:22:35 -0800
Date:   Thu, 14 Nov 2019 07:22:35 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/2] KVM: X86: Single target IPI fastpath
Message-ID: <20191114152235.GC24045@linux.intel.com>
References: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
 <6c2c7bbb-39f4-2a77-632e-7730e9887fc5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c2c7bbb-39f4-2a77-632e-7730e9887fc5@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 14, 2019 at 12:58:56PM +0100, Paolo Bonzini wrote:
> Ok, it's not _so_ ugly after all.
> 
> > ---
> >  arch/x86/kvm/vmx/vmx.c   | 39 +++++++++++++++++++++++++++++++++++++--
> >  include/linux/kvm_host.h |  1 +
> >  2 files changed, 38 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 5d21a4a..5c67061 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5924,7 +5924,9 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
> >  		}
> >  	}
> >  
> > -	if (exit_reason < kvm_vmx_max_exit_handlers
> > +	if (vcpu->fast_vmexit)
> > +		return 1;
> > +	else if (exit_reason < kvm_vmx_max_exit_handlers
> 
> Instead of a separate vcpu->fast_vmexit, perhaps you can set exit_reason
> to vmx->exit_reason to -1 if the fast path succeeds.

Actually, rather than make this super special case, what about moving the
handling into vmx_handle_exit_irqoff()?  Practically speaking that would
only add ~50 cycles (two VMREADs) relative to the code being run right
after kvm_put_guest_xcr0().  It has the advantage of restoring the host's
hardware breakpoints, preserving a semi-accurate last_guest_tsc, and
running with vcpu->mode set back to OUTSIDE_GUEST_MODE.  Hopefully it'd
also be more intuitive for people unfamiliar with the code.

> 

> > +			if (ret == 0)
> > +				ret = kvm_skip_emulated_instruction(vcpu);
> 
> Please move the "kvm_skip_emulated_instruction(vcpu)" to
> vmx_handle_exit, so that this basically is
> 
> #define EXIT_REASON_NEED_SKIP_EMULATED_INSN -1
> 
> 	if (ret == 0)
> 		vcpu->exit_reason = EXIT_REASON_NEED_SKIP_EMULATED_INSN;
> 
> and handle_ipi_fastpath can return void.

I'd rather we add a dedicated variable to say the exit has already been
handled.  Overloading exit_reason is bound to cause confusion, and that's
probably a best case scenario.

> > +		};
> > +	};
> > +
> > +	return ret;
> > +}
> > +
> >  static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -6615,6 +6645,12 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  				  | (1 << VCPU_EXREG_CR3));
> >  	vcpu->arch.regs_dirty = 0;
> >  
> > +	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
> > +	vcpu->fast_vmexit = false;
> > +	if (!is_guest_mode(vcpu) &&
> > +		vmx->exit_reason == EXIT_REASON_MSR_WRITE)
> > +		vcpu->fast_vmexit = handle_ipi_fastpath(vcpu);
> 
> This should be done later, at least after kvm_put_guest_xcr0, because
> running with partially-loaded guest state is harder to audit.  The best
> place to put it actually is right after the existing vmx->exit_reason
> assignment, where we already handle EXIT_REASON_MCE_DURING_VMENTRY.
> 
> >  	pt_guest_exit(vmx);
> >  
> >  	/*
> > @@ -6634,7 +6670,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  	vmx->nested.nested_run_pending = 0;
> >  	vmx->idt_vectoring_info = 0;
> >  
> > -	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
> >  	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
> >  		kvm_machine_check();
> >  
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 719fc3e..7a7358b 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -319,6 +319,7 @@ struct kvm_vcpu {
> >  #endif
> >  	bool preempted;
> >  	bool ready;
> > +	bool fast_vmexit;
> >  	struct kvm_vcpu_arch arch;
> >  	struct dentry *debugfs_dentry;
> >  };
> > 
> 
