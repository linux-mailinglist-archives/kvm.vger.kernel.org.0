Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CD625B68A
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 00:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgIBWoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 18:44:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:7459 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbgIBWoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 18:44:09 -0400
IronPort-SDR: yYb2LRWEnovmxVusYZpk8nzGt8ICDB1QzQKWRISkyEsiZlmS3Fr338XqqtlPez6EXRFpuFlgYs
 w4hDCa/YCbHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="154996681"
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="154996681"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 15:44:07 -0700
IronPort-SDR: SgPuBa8KagMKUW23uXxcS5sth5yAXQj3CkBd39UgRDyePqw5JZKnGx4ZU3LbvuLYL1lgKr9a8x
 S1wtQdQosjJg==
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="502837008"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 15:44:07 -0700
Date:   Wed, 2 Sep 2020 15:44:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC v2 2/2] KVM: VMX: Enable bus lock VM exit
Message-ID: <20200902224405.GK11695@sjchrist-ice>
References: <20200817014459.28782-1-chenyi.qiang@intel.com>
 <20200817014459.28782-3-chenyi.qiang@intel.com>
 <87sgc1x4yn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sgc1x4yn.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 01, 2020 at 10:43:12AM +0200, Vitaly Kuznetsov wrote:
> > @@ -6809,6 +6824,19 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  	if (unlikely(vmx->exit_reason.failed_vmentry))
> >  		return EXIT_FASTPATH_NONE;
> >  
> > +	/*
> > +	 * check the exit_reason to see if there is a bus lock
> > +	 * happened in guest.
> > +	 */
> > +	if (kvm_bus_lock_exit_enabled(vmx->vcpu.kvm)) {
> > +		if (vmx->exit_reason.bus_lock_detected) {
> > +			vcpu->stat.bus_locks++;

Why bother with stats?  Every bus lock exits to userspace, having quick
stats doesn't seem all that interesting.

> > +			vcpu->arch.bus_lock_detected = true;
> > +		} else {
> > +			vcpu->arch.bus_lock_detected = false;
> 
> This is a fast path so I'm wondering if we can move bus_lock_detected
> clearing somewhere else.

Why even snapshot vmx->exit_reason.bus_lock_detected?  I don't see any
reason why vcpu_enter_guest() needs to handle the exit to userspace, e.g.
it's just as easily handled in VMX code.

> 
> > +		}
> > +	}
> > +
> >  	vmx->loaded_vmcs->launched = 1;
> >  	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
> >  
> > @@ -8060,6 +8088,9 @@ static __init int hardware_setup(void)
> >  		kvm_tsc_scaling_ratio_frac_bits = 48;
> >  	}
> >  
> > +	if (cpu_has_vmx_bus_lock_detection())
> > +		kvm_has_bus_lock_exit = true;
> > +
> >  	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
> >  
> >  	if (enable_ept)

...

> > @@ -4990,6 +4996,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >  		kvm->arch.exception_payload_enabled = cap->args[0];
> >  		r = 0;
> >  		break;
> > +	case KVM_CAP_X86_BUS_LOCK_EXIT:
> > +		if (!kvm_has_bus_lock_exit)
> > +			return -EINVAL;
> 
> ... because userspace can check for -EINVAL when enabling the cap. Or we
> can return e.g. -EOPNOTSUPP here. I don't have a strong opinion on the matter..
> 
> > +		kvm->arch.bus_lock_exit = cap->args[0];

Assuming we even want to make this per-VM, I think it'd make sense to make
args[0] a bit mask, e.g. to provide "off" and "exit" (this behavior) while
allowing for future modes, e.g. log-only.

> > +		r = 0;
> > +		break;
> >  	default:
> >  		r = -EINVAL;
> >  		break;
> > @@ -7732,12 +7744,23 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
