Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97B4618F9B9
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 17:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgCWQbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 12:31:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:48804 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727546AbgCWQbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 12:31:39 -0400
IronPort-SDR: iFXscG6X/tylu1tKeCS7jZvcIQ6v4+/5LhyIrkhJqw1qGclb8KHTcuXn8p+4dVRCjoWCOtL6Vn
 kgKH8ptzLcUw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 09:31:38 -0700
IronPort-SDR: szHRtSFDap8tPDDbCZjY8IsJB86JbCOaVx3NCNFM02k1aZo2cLfAgzLVZG93EZD2pGO8Xl0/T8
 x/vNCF1+MuCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="357141639"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 23 Mar 2020 09:31:37 -0700
Date:   Mon, 23 Mar 2020 09:31:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/9] KVM: x86: Move init-only kvm_x86_ops to separate
 struct
Message-ID: <20200323163136.GO28711@linux.intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-3-sean.j.christopherson@intel.com>
 <87lfnr9sqn.fsf@vitty.brq.redhat.com>
 <20200323152909.GE28711@linux.intel.com>
 <87o8sn82ef.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8sn82ef.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 05:24:56PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Mon, Mar 23, 2020 at 01:10:40PM +0100, Vitaly Kuznetsov wrote:
> >> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> >> 
> >> > +
> >> > +	.runtime_ops = &svm_x86_ops,
> >> > +};
> >> 
> >> Unrelated to your patch but I think we can make the naming of some of
> >> these functions more consistend on SVM/VMX, in particular I'd suggest 
> >> 
> >> has_svm() -> cpu_has_svm_support()
> >> is_disabled -> svm_disabled_by_bios()
> >> ...
> >> (see below for VMX)
> >> 
> >> > +
> >> >  static int __init svm_init(void)
> >> >  {
> >> > -	return kvm_init(&svm_x86_ops, sizeof(struct vcpu_svm),
> >> > +	return kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
> >> >  			__alignof__(struct vcpu_svm), THIS_MODULE);
> >> >  }
> >> >  
> >> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >> > index 07299a957d4a..ffcdcc86f5b7 100644
> >> > --- a/arch/x86/kvm/vmx/vmx.c
> >> > +++ b/arch/x86/kvm/vmx/vmx.c
> >> > @@ -7842,11 +7842,8 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
> >> >  }
> >> >  
> >> >  static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> >> > -	.cpu_has_kvm_support = cpu_has_kvm_support,
> >> > -	.disabled_by_bios = vmx_disabled_by_bios,
> >> > -	.hardware_setup = hardware_setup,
> >> >  	.hardware_unsetup = hardware_unsetup,
> >> > -	.check_processor_compatibility = vmx_check_processor_compat,
> >> > +
> >> >  	.hardware_enable = hardware_enable,
> >> >  	.hardware_disable = hardware_disable,
> >> >  	.cpu_has_accelerated_tpr = report_flexpriority,
> >> > @@ -7981,6 +7978,15 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> >> >  	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> >> >  };
> >> >  
> >> > +static struct kvm_x86_init_ops vmx_init_ops __initdata = {
> >> > +	.cpu_has_kvm_support = cpu_has_kvm_support,
> >> > +	.disabled_by_bios = vmx_disabled_by_bios,
> >> > +	.check_processor_compatibility = vmx_check_processor_compat,
> >> > +	.hardware_setup = hardware_setup,
> >> 
> >> cpu_has_kvm_support() -> cpu_has_vmx_support()
> >> hardware_setup() -> vmx_hardware_setup()
> >
> > Preaching to the choir on this one.  The VMX functions without prefixes in
> > in particular annoy me to no end, e.g. hardware_setup().  Though the worst
> > is probably ".vcpu_create = vmx_create_vcpu", if I had a nickel for every
> > time I've tried to find vmx_vcpu_create()...
> >
> > What if we added a macro to auto-generate the common/required hooks?  E.g.:
> >
> >   static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> > 	MANDATORY_KVM_X86_OPS(vmx),
> >
> > 	.pmu_ops = &intel_pmu_ops,
> >
> > 	...
> >   };
> >
> > That'd enforce consistent naming, and would provide a bit of documentation
> > as to which hooks are optional, e.g. many of the nested hooks, and which
> > must be defined for KVM to function.
> 
> Sounds cool! (not sure that with only two implementations people won't
> call it 'over-engineered' but cool). My personal wish would just be that
> function names in function implementations are not auto-generated so
> e.g. a simple 'git grep vmx_hardware_setup' works but the way how we
> fill vmx_x86_ops in can be macroed I guess.

Ya, I was thinking of just the macro.  Even that has downsides though, e.g.
chasing kvm_x86_ops.hardware_setup() to find VMX's hardware_setup() becomes
a bit kludgy.  On the other hand, _if_ you know how the fill macro works,
getting to the implementation should be easier.
