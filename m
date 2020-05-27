Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E13C1E3C8D
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 10:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388231AbgE0Isg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 04:48:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:58561 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388140AbgE0Isf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 04:48:35 -0400
IronPort-SDR: XcP5UeIZU4OQ6cJPA7MEYiwH+RgdcDdSgOzf4+UKIeQL3MQogQmpFjXwhfc6N3hn6jfFtucToK
 l1yoFa1sZnRg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 01:48:35 -0700
IronPort-SDR: +bUu5hndHTBcXUQHTwGZhpMHJbL8T8hawBJAIJcfk0AX29oKFMk45IxXD1UlCQ8ydW0YMdq1sp
 J9P0gT1OcRGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,440,1583222400"; 
   d="scan'208";a="345464604"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 27 May 2020 01:48:35 -0700
Date:   Wed, 27 May 2020 01:48:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: Preserve registers modifications done before
 nested_svm_vmexit()
Message-ID: <20200527084835.GO31696@linux.intel.com>
References: <20200527082921.218601-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527082921.218601-1-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shortlog says nVMX, code says nSVM :-)

On Wed, May 27, 2020 at 10:29:21AM +0200, Vitaly Kuznetsov wrote:
> L2 guest hang is observed after 'exit_required' was dropped and nSVM
> switched to check_nested_events() completely. The hang is a busy loop when
> e.g. KVM is emulating an instruction (e.g. L2 is accessing MMIO space and
> we drop to userspace). After nested_svm_vmexit() and when L1 is doing VMRUN
> nested guest's RIP is not advanced so KVM goes into emulating the same
> instruction which cased nested_svm_vmexit() and the loop continues.

s/cased/caused?

> nested_svm_vmexit() is not new, however, with check_nested_events() we're
> now calling it later than before. In case by that time KVM has modified
> register state we may pick stale values from VMCS when trying to save

s/VMCS/VMCB

> nested guest state to nested VMCB.
> 
> VMX code handles this case correctly: sync_vmcs02_to_vmcs12() called from
> nested_vmx_vmexit() does 'vmcs12->guest_rip = kvm_rip_read(vcpu)' and this
> ensures KVM-made modifications are preserved. Do the same for nVMX.

s/nVMX/nSVM

> 
> Generally, nested_vmx_vmexit()/nested_svm_vmexit() need to pick up all
> nested guest state modifications done by KVM after vmexit. It would be
> great to find a way to express this in a way which would not require to
> manually track these changes, e.g. nested_{vmcb,vmcs}_get_field().
> 
> Co-debugged-with: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> - To certain extent we're fixing currently-pending 'KVM: SVM: immediately
>  inject INTR vmexit' commit but I'm not certain about that. We had so many
>  problems with nested events before switching to check_nested_events() that
>  what worked before could just be treated as a miracle. Miracles tend to
>  appear and disappear all of a sudden.
> ---
>  arch/x86/kvm/svm/nested.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 0f02521550b9..6b1049148c1b 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -537,9 +537,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	nested_vmcb->save.cr2    = vmcb->save.cr2;
>  	nested_vmcb->save.cr4    = svm->vcpu.arch.cr4;
>  	nested_vmcb->save.rflags = kvm_get_rflags(&svm->vcpu);
> -	nested_vmcb->save.rip    = vmcb->save.rip;
> -	nested_vmcb->save.rsp    = vmcb->save.rsp;
> -	nested_vmcb->save.rax    = vmcb->save.rax;
> +	nested_vmcb->save.rip    = kvm_rip_read(&svm->vcpu);
> +	nested_vmcb->save.rsp    = kvm_rsp_read(&svm->vcpu);
> +	nested_vmcb->save.rax    = kvm_rax_read(&svm->vcpu);
>  	nested_vmcb->save.dr7    = vmcb->save.dr7;
>  	nested_vmcb->save.dr6    = svm->vcpu.arch.dr6;
>  	nested_vmcb->save.cpl    = vmcb->save.cpl;
> -- 
> 2.25.4
> 
