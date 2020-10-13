Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA4F28C6C9
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 03:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgJMBdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 21:33:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:3762 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728093AbgJMBdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 21:33:51 -0400
IronPort-SDR: iOlmkTXxcELRtvg1uJ+2GzV9FjHZg8/vYP/fWEJvv+qCAQCG5HZecLzDFE7ckQV8zCil95d56s
 H67A/q5b77xw==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165041736"
X-IronPort-AV: E=Sophos;i="5.77,369,1596524400"; 
   d="scan'208";a="165041736"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 18:33:50 -0700
IronPort-SDR: x9utqNXKIYN+/Rg99JVwHdLkO+tQIKs6ku4O+BIIak0czbdJMQ1k4KskilWb/ZTaRmZvAyja5i
 puCyjYh75Mfg==
X-IronPort-AV: E=Sophos;i="5.77,369,1596524400"; 
   d="scan'208";a="313634462"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 18:33:50 -0700
Date:   Mon, 12 Oct 2020 18:33:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Cathy Avery <cavery@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wei.huang2@amd.com,
        mlevitsk@redhat.com
Subject: Re: [PATCH v2 2/2] KVM: SVM: Use a separate vmcb for the nested L2
 guest
Message-ID: <20201013013349.GB10366@linux.intel.com>
References: <20201011184818.3609-1-cavery@redhat.com>
 <20201011184818.3609-3-cavery@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201011184818.3609-3-cavery@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 11, 2020 at 02:48:18PM -0400, Cathy Avery wrote:
> @@ -628,8 +620,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	nested_vmcb->control.pause_filter_thresh =
>  		svm->vmcb->control.pause_filter_thresh;
>  
> -	/* Restore the original control entries */
> -	copy_vmcb_control_area(&vmcb->control, &hsave->control);
> +	nested_svm_vmloadsave(svm->nested.vmcb02, svm->vmcb01);
> +
> +	svm->vmcb = svm->vmcb01;
> +	svm->vmcb_pa = svm->vmcb01_pa;

I very highly recommend adding a helper to switch VMCB.  Odds are very good
there will be more than just these two lines of boilerplate code for changing
the active VMCB.

>  
>  	/* On vmexit the  GIF is set to false */
>  	svm_set_gif(svm, false);

...

> @@ -1121,16 +1102,24 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	if (!(save.cr0 & X86_CR0_PG))
>  		return -EINVAL;
>  
> +	svm->nested.vmcb02->control = svm->vmcb01->control;
> +	svm->nested.vmcb02->save = svm->vmcb01->save;
> +	svm->vmcb01->save = save;
> +
> +	WARN_ON(svm->vmcb == svm->nested.vmcb02);

I'm pretty sure this is user triggerable.  AFAIK, nothing prevents calling
svm_set_nested_state() while L2 is active, e.g. VMX explicitly (and forcefully)
kicks the vCPU out of L2 in vmx_set_nested_state().

> +
> +	svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
> +
> +	svm->vmcb = svm->nested.vmcb02;
> +	svm->vmcb_pa = svm->nested.vmcb02_pa;
> +
>  	/*
> -	 * All checks done, we can enter guest mode.  L1 control fields
> -	 * come from the nested save state.  Guest state is already
> -	 * in the registers, the save area of the nested state instead
> -	 * contains saved L1 state.
> +	 * All checks done, we can enter guest mode. L2 control fields will
> +	 * be the result of a combination of L1 and userspace indicated
> +	 * L12.control. The save area of L1 vmcb now contains the userspace
> +	 * indicated L1.save.
>  	 */
> -	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
> -	hsave->save = save;
>  
> -	svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
>  	load_nested_vmcb_control(svm, &ctl);
>  	nested_prepare_vmcb_control(svm);
>  
