Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62856357BF0
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 07:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhDHFpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 01:45:12 -0400
Received: from mga05.intel.com ([192.55.52.43]:2609 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhDHFpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 01:45:11 -0400
IronPort-SDR: iRypAiR1zl2IuM8EGZ68/BLKz0LoujW69JKlC7S/jNWFihE6TO/9xwTJW9TVnAVvLFSS8GnRWf
 uWWzXdGWuCjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="278733420"
X-IronPort-AV: E=Sophos;i="5.82,205,1613462400"; 
   d="scan'208";a="278733420"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 22:45:01 -0700
IronPort-SDR: qTjaQBstkxQVWVQ/bVTG5fLh20BYCsTgy9hiaAihMjTMO9WdlfREfWnQdQAN6RZ3AejJYjWbhR
 7aGrbOHGWK6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,205,1613462400"; 
   d="scan'208";a="380118203"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 07 Apr 2021 22:44:58 -0700
Message-ID: <ecd9610db49386f9fa38abf46a4fbaa8d1d342cb.camel@linux.intel.com>
Subject: Re: [RFC PATCH 05/12] kvm/vmx: Add KVM support on KeyLocker
 operations
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chang.seok.bae@intel.com,
        kvm@vger.kernel.org, robert.hu@intel.com
Date:   Thu, 08 Apr 2021 13:44:57 +0800
In-Reply-To: <YGs557flJQr1Cbkb@google.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
         <1611565580-47718-6-git-send-email-robert.hu@linux.intel.com>
         <YGs557flJQr1Cbkb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-04-05 at 16:25 +0000, Sean Christopherson wrote:
> On Mon, Jan 25, 2021, Robert Hoo wrote:
> > On each VM-Entry, we need to resotre vCPU's IWKey, stored in
> > kvm_vcpu_arch.
> 
> ...
> 
> > +static int get_xmm(int index, u128 *mem_ptr)
> > +{
> > +	int ret = 0;
> > +
> > +	asm ("cli");
> > +	switch (index) {
> > +	case 0:
> > +		asm ("movdqu %%xmm0, %0" : : "m"(*mem_ptr));
> > +		break;
> > +	case 1:
> > +		asm ("movdqu %%xmm1, %0" : : "m"(*mem_ptr));
> > +		break;
> > +	case 2:
> > +		asm ("movdqu %%xmm2, %0" : : "m"(*mem_ptr));
> > +		break;
> > +	case 3:
> > +		asm ("movdqu %%xmm3, %0" : : "m"(*mem_ptr));
> > +		break;
> > +	case 4:
> > +		asm ("movdqu %%xmm4, %0" : : "m"(*mem_ptr));
> > +		break;
> > +	case 5:
> > +		asm ("movdqu %%xmm5, %0" : : "m"(*mem_ptr));
> > +		break;
> > +	case 6:
> > +		asm ("movdqu %%xmm6, %0" : : "m"(*mem_ptr));
> > +		break;
> > +	case 7:
> > +		asm ("movdqu %%xmm7, %0" : : "m"(*mem_ptr));
> > +		break;
> > +#ifdef CONFIG_X86_64
> > +	case 8:
> > +		asm ("movdqu %%xmm8, %0" : : "m"(*mem_ptr));
> > +		break;
> > +	case 9:
> > +		asm ("movdqu %%xmm9, %0" : : "m"(*mem_ptr));
> > +		break;
> > +	case 10:
> > +		asm ("movdqu %%xmm10, %0" : : "m"(*mem_ptr));
> > +		break;
> > +	case 11:
> > +		asm ("movdqu %%xmm11, %0" : : "m"(*mem_ptr));
> > +		break;
> > +	case 12:
> > +		asm ("movdqu %%xmm12, %0" : : "m"(*mem_ptr));
> > +		break;
> > +	case 13:
> > +		asm ("movdqu %%xmm13, %0" : : "m"(*mem_ptr));
> > +		break;
> > +	case 14:
> > +		asm ("movdqu %%xmm14, %0" : : "m"(*mem_ptr));
> > +		break;
> > +	case 15:
> > +		asm ("movdqu %%xmm15, %0" : : "m"(*mem_ptr));
> > +		break;
> > +#endif
> > +	default:
> > +		pr_err_once("xmm index exceeds");
> 
> That error message is not remotely helpful.  If this theoretically
> reachable,
> make it a WARN.

At this moment, not theoretically reachable.
It's my habit to always worry for future careless callers.
OK, remove it.
> 
> > +		ret = -1;
> > +		break;
> > +	}
> > +	asm ("sti");a
> 
> Don't code IRQ disabling/enabling.  Second, why are IRQs being
> disabled in this
> low level helper?

Looks it's unnecessary. Going to remove it.
> 
> > +
> > +	return ret;
> > +}
> > +
> > +static void vmx_load_guest_iwkey(struct kvm_vcpu *vcpu)
> > +{
> > +	u128 xmm[3] = {0};
> > +
> > +	if (vcpu->arch.iwkey_loaded) {
> 
> Loading the IWKey is not tied to the guest/host context
> switch.  IIUC, the intent
> is to leave the IWKey in hardware while the host is running.  I.e.
> KVM should be
> able to track which key is current resident in hardware separately
> from the
> guest/host stuff.

In current phase, guest and host can only exclusively use Key Locker,
so, more precisely saying, KVM should be able to track which guest
IWKey is in hardware.
Yes your point is right, load a vCPU's IWKey is not necessary every
time enter guest, e.g. no vCPU switching happened.
My above implementation is simply the logic, but your suggestion is
more efficiency-saving.
I'm going to implement this in next version: only load vCPU's IWKey on
its switching to another pCPU.
> 
> And loading the IWKey only on VM-Enter iff the guest loaded a key
> means KVM is
> leaking one VM's IWKey to all other VMs with KL enabled but that
> haven't loaded
> their own IWKey. To prevent leaking a key, KVM would need to load the
> new vCPU's
> key, even if it's "null", if the old vCPU _or_ the new vCPU has
> loaded a key.

Right. Thanks for your careful review.
> 
> > +		bool clear_cr4 = false;
> > +		/* Save origin %xmm */
> > +		get_xmm(0, &xmm[0]);
> > +		get_xmm(1, &xmm[1]);
> > +		get_xmm(2, &xmm[2]);
> > +
> > +		asm ("movdqu %0, %%xmm0;"
> > +		     "movdqu %1, %%xmm1;"
> > +		     "movdqu %2, %%xmm2;"
> > +		     : : "m"(vcpu->arch.iwkey.integrity_key),
> > +		     "m"(vcpu->arch.iwkey.encryption_key[0]),
> > +		     "m"(vcpu->arch.iwkey.encryption_key[1]));
> > +		if (!(cr4_read_shadow() & X86_CR4_KEYLOCKER)) {
> 
> Presumably this should assert that CR4.KL=0, otherwise it means the
> guest's key
> is effectively being leaked to userspace.

OK, for current phase of host/guest exclusively have Key Locker
feature.
> 
> > +			cr4_set_bits(X86_CR4_KEYLOCKER);
> > +			clear_cr4 = true;
> > +		}
> > +		asm volatile(LOADIWKEY : : "a" (0x0));
> > +		if (clear_cr4)
> > +			cr4_clear_bits(X86_CR4_KEYLOCKER);
> > +		/* restore %xmm */
> > +		asm ("movdqu %0, %%xmm0;"
> > +		     "movdqu %1, %%xmm1;"
> > +		     "movdqu %2, %%xmm2;"
> > +		     : : "m"(xmm[0]),
> > +		     "m"(xmm[1]),
> > +		     "m"(xmm[2]));
> > +	}
> > +}
> > +
> >  void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -1260,6 +1361,9 @@ void vmx_prepare_switch_to_guest(struct
> > kvm_vcpu *vcpu)
> >  #endif
> >  
> >  	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base,
> > gs_base);
> > +
> > +	vmx_load_guest_iwkey(vcpu);
> > +
> >  	vmx->guest_state_loaded = true;
> >  }
> >  

