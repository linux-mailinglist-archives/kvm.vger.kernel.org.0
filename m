Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E121802B0
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 17:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgCJQBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 12:01:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:31254 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbgCJQBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 12:01:31 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 09:01:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,537,1574150400"; 
   d="scan'208";a="353652216"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 10 Mar 2020 09:01:30 -0700
Date:   Tue, 10 Mar 2020 09:01:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: X86: Don't load/put guest FPU context for sleeping
 AP
Message-ID: <20200310160129.GA9305@linux.intel.com>
References: <1583823679-17648-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583823679-17648-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 03:01:19PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> kvm_load_guest_fpu() and kvm_put_guest_fpu() each consume more than 14us 
> observed by ftrace, the qemu userspace FPU is swapped out for the guest 
> FPU context for the duration of the KVM_RUN ioctl even if sleeping AP, 
> we shouldn't load/put guest FPU context for this case especially for 
> serverless scenario which sensitives to boot time.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5de2006..080ffa4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8680,7 +8680,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  
>  	vcpu_load(vcpu);
>  	kvm_sigset_activate(vcpu);
> -	kvm_load_guest_fpu(vcpu);
>  
>  	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
>  		if (kvm_run->immediate_exit) {
> @@ -8718,12 +8717,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  		}
>  	}
>  
> +	kvm_load_guest_fpu(vcpu);

Ugh, so this isn't safe on MPX capable CPUs, kvm_apic_accept_events() can
trigger kvm_vcpu_reset() with @init_event=true and try to unload guest_fpu.

We could hack around that issue, but it'd be ugly, and I'm also concerned
that calling vmx_vcpu_reset() without guest_fpu loaded will be problematic
in the future with all the things that are getting managed by XSAVE.

> +
>  	if (unlikely(vcpu->arch.complete_userspace_io)) {
>  		int (*cui)(struct kvm_vcpu *) = vcpu->arch.complete_userspace_io;
>  		vcpu->arch.complete_userspace_io = NULL;
>  		r = cui(vcpu);
>  		if (r <= 0)
> -			goto out;
> +			goto out_fpu;
>  	} else
>  		WARN_ON(vcpu->arch.pio.count || vcpu->mmio_needed);
>  
> @@ -8732,8 +8733,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  	else
>  		r = vcpu_run(vcpu);
>  
> -out:
> +out_fpu:
>  	kvm_put_guest_fpu(vcpu);
> +out:
>  	if (vcpu->run->kvm_valid_regs)
>  		store_regs(vcpu);
>  	post_kvm_run_save(vcpu);
> -- 
> 2.7.4
> 
