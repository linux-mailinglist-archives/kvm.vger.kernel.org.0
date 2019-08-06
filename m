Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853E48358A
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 17:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbfHFPpk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 11:45:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:16580 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbfHFPpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 11:45:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 08:45:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="165020924"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 06 Aug 2019 08:45:39 -0700
Date:   Tue, 6 Aug 2019 08:45:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 3/5] x86: KVM: clear interrupt shadow on EMULTYPE_SKIP
Message-ID: <20190806154539.GE27766@linux.intel.com>
References: <20190806060150.32360-1-vkuznets@redhat.com>
 <20190806060150.32360-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806060150.32360-4-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 06, 2019 at 08:01:48AM +0200, Vitaly Kuznetsov wrote:
> When doing x86_emulate_instruction(EMULTYPE_SKIP) interrupt shadow has to
> be cleared if and only if the skipping is successful.
> 
> There are two immediate issues:
> - In SVM skip_emulated_instruction() we are not zapping interrupt shadow
>   in case kvm_emulate_instruction(EMULTYPE_SKIP) is used to advance RIP
>   (!nrpip_save).
> - In VMX handle_ept_misconfig() when running as a nested hypervisor we
>   (static_cpu_has(X86_FEATURE_HYPERVISOR) case) we forget to clear

Redundant 'we'.  Might be worth adding a blurb in the changelog to note
that this intentionally doesn't handle "MOV/POP SS" as skip-emulation of
those instructions can only occur if the guest is doing something silly.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

>   interrupt shadow.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c6d951cbd76c..eac8253d84d2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6537,6 +6537,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
>  		kvm_rip_write(vcpu, ctxt->_eip);
>  		if (ctxt->eflags & X86_EFLAGS_RF)
>  			kvm_set_rflags(vcpu, ctxt->eflags & ~X86_EFLAGS_RF);
> +		kvm_x86_ops->set_interrupt_shadow(vcpu, 0);
>  		return EMULATE_DONE;
>  	}
>  
> -- 
> 2.20.1
> 
