Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB8F21E315
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 00:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGMWiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 18:38:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:5700 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgGMWiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 18:38:15 -0400
IronPort-SDR: 44qvSvFyo2lKePg1IkSrTkh6K5bjZHrKtX7eDSAFhv+QIGKhPskQLOqp/pk2qRQvcBcJAFSORs
 gJ6Evsj2karQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="146224462"
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="146224462"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 15:38:15 -0700
IronPort-SDR: IpyIMX0t1rB8a1TTalxn/v1J7mpdLo6d6Z5VYqRXv0StGB90ulFvBo7C0zNAGwuavejuV4PmA3
 OlO8yrVixS9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="429551992"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 13 Jul 2020 15:38:14 -0700
Date:   Mon, 13 Jul 2020 15:38:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/9] KVM: nSVM: introduce
 nested_svm_load_cr3()/nested_npt_enabled()
Message-ID: <20200713223814.GG29725@linux.intel.com>
References: <20200710141157.1640173-1-vkuznets@redhat.com>
 <20200710141157.1640173-6-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710141157.1640173-6-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 04:11:53PM +0200, Vitaly Kuznetsov wrote:
> As a preparatory change for implementing nested specifig PGD switch for

s/specifig/specific

> nSVM (following nVMX' nested_vmx_load_cr3()) instead of relying on

nVMX's

> kvm_set_cr3() introduce nested_svm_load_cr3().

The changelog isn't all that helpful to understanding the actual change.
All this is doing is wrapping kvm_set_cr3(), but that's not at all obvious
from reading the above.

E.g.

  Add nested_svm_load_cr3() as a pass-through to kvm_set_cr3() as a
  preparatory change for implementing nested specific PGD switch for nSVM,
  (following nVMx's nested_vmx_load_cr3()).

> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 5e6c988a4e6b..180929f3dbef 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -311,6 +311,21 @@ static void nested_vmcb_save_pending_event(struct vcpu_svm *svm,
>  	nested_vmcb->control.exit_int_info = exit_int_info;
>  }
>  
> +static inline bool nested_npt_enabled(struct vcpu_svm *svm)
> +{
> +	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
> +}
> +
> +/*
> + * Load guest's cr3 at nested entry. @nested_npt is true if we are
> + * emulating VM-Entry into a guest with NPT enabled.
> + */
> +static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
> +			       bool nested_npt)

IMO the addition of nested_npt_enabled() should be a separate patch, and
the additoin of @nested_npt should be in patch 7.

Hypothetically speaking, if nested_npt_enabled() is inaccurate at the call
site in nested_prepare_vmcb_save(), then this patch is technically wrong
even though it doesn't introduce a bug.  Given that the call site of
nested_svm_load_cr3() is moved in patch 7, I don't see any value in adding
the placeholder parameter early.

> +{
> +	return kvm_set_cr3(vcpu, cr3);
> +}
> +
>  static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
>  {
>  	/* Load the nested guest state */
> @@ -324,7 +339,8 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
>  	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
>  	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
>  	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
> -	(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
> +	(void)nested_svm_load_cr3(&svm->vcpu, nested_vmcb->save.cr3,
> +				  nested_npt_enabled(svm));
>  
>  	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
>  	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
> @@ -343,7 +359,8 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
>  static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
>  {
>  	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
> -	if (svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
> +
> +	if (nested_npt_enabled(svm))
>  		nested_svm_init_mmu_context(&svm->vcpu);
>  
>  	/* Guest paging mode is active - reset mmu */
> -- 
> 2.25.4
> 
