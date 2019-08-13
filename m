Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A05B98C023
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 20:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbfHMSIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 14:08:00 -0400
Received: from mga17.intel.com ([192.55.52.151]:31145 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbfHMSIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 14:08:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 11:07:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,382,1559545200"; 
   d="scan'208";a="200566948"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 13 Aug 2019 11:07:59 -0700
Date:   Tue, 13 Aug 2019 11:07:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v4 2/7] x86: kvm: svm: propagate errors from
 skip_emulated_instruction()
Message-ID: <20190813180759.GF13991@linux.intel.com>
References: <20190813135335.25197-1-vkuznets@redhat.com>
 <20190813135335.25197-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813135335.25197-3-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 13, 2019 at 03:53:30PM +0200, Vitaly Kuznetsov wrote:
> @@ -3899,20 +3898,25 @@ static int task_switch_interception(struct vcpu_svm *svm)
>  	if (reason != TASK_SWITCH_GATE ||
>  	    int_type == SVM_EXITINTINFO_TYPE_SOFT ||
>  	    (int_type == SVM_EXITINTINFO_TYPE_EXEPT &&
> -	     (int_vec == OF_VECTOR || int_vec == BP_VECTOR)))
> -		skip_emulated_instruction(&svm->vcpu);
> +	     (int_vec == OF_VECTOR || int_vec == BP_VECTOR))) {
> +		if (skip_emulated_instruction(&svm->vcpu) != EMULATE_DONE)

This isn't broken in the current code, but it's flawed in the sense that
it assumes skip_emulated_instruction() never returns EMULATE_USER_EXIT.

Note, both SVM and VMX make the opposite assumption when handling
kvm_task_switch() and kvm_inject_realmode_interrupt().

More below...

> +			goto fail;
> +	}
>  
>  	if (int_type != SVM_EXITINTINFO_TYPE_SOFT)
>  		int_vec = -1;
>  
>  	if (kvm_task_switch(&svm->vcpu, tss_selector, int_vec, reason,
> -				has_error_code, error_code) == EMULATE_FAIL) {
> -		svm->vcpu.run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -		svm->vcpu.run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> -		svm->vcpu.run->internal.ndata = 0;
> -		return 0;
> -	}
> +				has_error_code, error_code) == EMULATE_FAIL)
> +		goto fail;
> +
>  	return 1;
> +
> +fail:
> +	svm->vcpu.run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	svm->vcpu.run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> +	svm->vcpu.run->internal.ndata = 0;
> +	return 0;
>  }
>  
>  static int cpuid_interception(struct vcpu_svm *svm)

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c6d951cbd76c..e8f797fe9d9e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6383,9 +6383,11 @@ static void kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu, int *r)
>  int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
> -	int r = EMULATE_DONE;
> +	int r;
>  
> -	kvm_x86_ops->skip_emulated_instruction(vcpu);
> +	r = kvm_x86_ops->skip_emulated_instruction(vcpu);
> +	if (unlikely(r != EMULATE_DONE))
> +		return 0;

x86_emulate_instruction() doesn't set vcpu->run->exit_reason when emulation
fails with EMULTYPE_SKIP, i.e. this will exit to userspace with garbage in
the exit_reason.

handle_ept_misconfig() also has the same (pre-existing) flaw.

Given the handle_ept_misconfig() bug and that kvm_emulate_instruction()
sets vcpu->run->exit_reason when it returns EMULATE_FAIL in the normal
case, I think it makes sense to fix the issue in x86_emulate_instruction().
That would also eliminate the need to worry about EMULATE_USER_EXIT in
task_switch_interception(), e.g. the SVM code can just return 0 when it
gets a non-EMULATE_DONE return type.

E.g.:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 07ab14d73094..73b86f81ed9c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6201,7 +6201,8 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
        if (emulation_type & EMULTYPE_NO_UD_ON_FAIL)
                return EMULATE_FAIL;

-       if (!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) == 0) {
+       if ((!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) == 0) ||
+           (emulation_type & EMULTYPE_SKIP)) {
                vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
                vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
                vcpu->run->internal.ndata = 0;
@@ -6525,8 +6526,6 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
                                return EMULATE_DONE;
                        if (ctxt->have_exception && inject_emulated_exception(vcpu))
                                return EMULATE_DONE;
-                       if (emulation_type & EMULTYPE_SKIP)
-                               return EMULATE_FAIL;
                        return handle_emulation_failure(vcpu, emulation_type);
                }
        }


As for the kvm_task_switch() handling and other cases, I think it's
possible to rework all of the functions and callers that return/handle
EMULATE_DONE to instead return 0/1, i.e. contain EMULATE_* to x86.c.
I'll put together a series, I think you've suffered more than enough scope
creep as it is :-)

>  
>  	/*
>  	 * rflags is the old, "raw" value of the flags.  The new value has
> -- 
> 2.20.1
> 
