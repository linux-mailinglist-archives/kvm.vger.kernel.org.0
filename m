Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390FD3508E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 22:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfFDUDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 16:03:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:42568 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfFDUDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 16:03:37 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 13:03:36 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga003.jf.intel.com with ESMTP; 04 Jun 2019 13:03:36 -0700
Date:   Tue, 4 Jun 2019 13:03:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, yu-cheng.yu@intel.com
Subject: Re: [PATCH v5 5/8] KVM: VMX: Load Guest CET via VMCS when CET is
 enabled in Guest
Message-ID: <20190604200336.GC7476@linux.intel.com>
References: <20190522070101.7636-1-weijiang.yang@intel.com>
 <20190522070101.7636-6-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522070101.7636-6-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 22, 2019 at 03:00:58PM +0800, Yang Weijiang wrote:
> "Load Guest CET state" bit controls whether Guest CET states
> will be loaded at Guest entry. Before doing that, KVM needs
> to check if CPU CET feature is available to Guest.
> 
> Note: SHSTK and IBT features share one control MSR:
> MSR_IA32_{U,S}_CET, which means it's difficult to hide
> one feature from another in the case of SHSTK != IBT,
> after discussed in community, it's agreed to allow Guest
> control two features independently as it won't introduce
> security hole.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9321da538f65..1c0d487a4037 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -47,6 +47,7 @@
>  #include <asm/spec-ctrl.h>
>  #include <asm/virtext.h>
>  #include <asm/vmx.h>
> +#include <asm/cet.h>

Is this include actually needed?  I haven't attempted to compile, but a
glance everything should be in cpufeatures.h or vmx.h.

>  #include "capabilities.h"
>  #include "cpuid.h"
> @@ -2929,6 +2930,17 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  		if (!nested_vmx_allowed(vcpu) || is_smm(vcpu))
>  			return 1;
>  	}
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT)) {
> +		if (cr4 & X86_CR4_CET)
> +			vmcs_set_bits(VM_ENTRY_CONTROLS,
> +				      VM_ENTRY_LOAD_GUEST_CET_STATE);
> +		else
> +			vmcs_clear_bits(VM_ENTRY_CONTROLS,
> +					VM_ENTRY_LOAD_GUEST_CET_STATE);
> +	} else if (cr4 & X86_CR4_CET) {
> +		return 1;
> +	}

Don't we also need to check for host CET support prior to toggling
VM_ENTRY_LOAD_GUEST_CET_STATE?

>  
>  	if (to_vmx(vcpu)->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
>  		return 1;
> -- 
> 2.17.2
> 
