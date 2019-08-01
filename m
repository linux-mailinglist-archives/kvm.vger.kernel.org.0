Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E7D7DDA5
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 16:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731904AbfHAOSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 10:18:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:42140 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729149AbfHAOSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 10:18:03 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 07:18:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,334,1559545200"; 
   d="scan'208";a="177831661"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 01 Aug 2019 07:18:02 -0700
Date:   Thu, 1 Aug 2019 07:18:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 3/5] x86: KVM: svm: clear interrupt shadow on all paths
 in skip_emulated_instruction()
Message-ID: <20190801141802.GA6783@linux.intel.com>
References: <20190801051418.15905-1-vkuznets@redhat.com>
 <20190801051418.15905-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801051418.15905-4-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 01, 2019 at 07:14:16AM +0200, Vitaly Kuznetsov wrote:
> Regardless of the way how we skip instruction, interrupt shadow needs to be
> cleared.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 80f576e05112..7c7dff3f461f 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -784,13 +784,15 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  				EMULATE_DONE)
>  			pr_err_once("KVM: %s: unable to skip instruction\n",
>  				    __func__);
> -		return;
> +		goto clear_int_shadow;

A better fix would be to clear the interrupt shadow in x86_emulate_instruction()
after updating RIP for EMULTYPE_SKIP.  VMX has this same flaw when running
nested as handle_ept_misconfig() also expects the interrupt shadow to be
handled by kvm_emulate_instruction().  Clearing the shadow if and only if
the skipping is successful also means KVM isn't incorrectly zapping the
shadow when emulation fails.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 01e18caac825..f25521fb1c42 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6537,6 +6537,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
                kvm_rip_write(vcpu, ctxt->_eip);
                if (ctxt->eflags & X86_EFLAGS_RF)
                        kvm_set_rflags(vcpu, ctxt->eflags & ~X86_EFLAGS_RF);
+               kvm_x86_ops->set_interrupt_shadow(vcpu, 0);
                return EMULATE_DONE;
        }

>  	}
>  	if (svm->next_rip - kvm_rip_read(vcpu) > MAX_INST_SIZE)
>  		printk(KERN_ERR "%s: ip 0x%lx next 0x%llx\n",
>  		       __func__, kvm_rip_read(vcpu), svm->next_rip);
>  
>  	kvm_rip_write(vcpu, svm->next_rip);
> +
> +clear_int_shadow:
>  	svm_set_interrupt_shadow(vcpu, 0);
>  }
>  
> -- 
> 2.20.1
> 
