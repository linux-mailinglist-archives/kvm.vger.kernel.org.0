Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1959F1C1720
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 16:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbgEAN6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 09:58:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:36124 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729056AbgEAN6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 09:58:08 -0400
IronPort-SDR: RX3DI9x4mD/fhpQ3WD4U8cFbrGgp9RbFDm91AkRJzEVpG0HzYadB2kUey+h5oulT8YRAF3jenK
 V6fGXNkWL+jg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 06:58:08 -0700
IronPort-SDR: knsFNte1Ij/9pahofbnrAp9hjTgz3vSsDOZ/0cHq9olR4r9VJn5PrEntWcf/J7/oTOdZ93Rvzu
 PwskZe3XyjOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,339,1583222400"; 
   d="scan'208";a="250024208"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 01 May 2020 06:58:07 -0700
Date:   Fri, 1 May 2020 06:58:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        KarimAllah Raslan <karahmed@amazon.de>
Subject: Re: [PATCH] KVM: nVMX: Skip IBPB when switching between vmcs01 and
 vmcs02
Message-ID: <20200501135806.GA3798@linux.intel.com>
References: <20200430204123.2608-1-sean.j.christopherson@intel.com>
 <853bea8c-41b8-ba3e-0a7c-c5df3b5dac9e@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <853bea8c-41b8-ba3e-0a7c-c5df3b5dac9e@amazon.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 30, 2020 at 11:22:20PM +0200, Alexander Graf wrote:
> 
> On 30.04.20 22:41, Sean Christopherson wrote:
> >
> >diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >index 3ab6ca6062ce..818dd8ba5e9f 100644
> >--- a/arch/x86/kvm/vmx/vmx.c
> >+++ b/arch/x86/kvm/vmx/vmx.c
> >@@ -1311,10 +1311,12 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
> >                 pi_set_on(pi_desc);
> >  }
> >
> >-void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
> >+void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
> >+                       struct loaded_vmcs *buddy)
> >  {
> >         struct vcpu_vmx *vmx = to_vmx(vcpu);
> >         bool already_loaded = vmx->loaded_vmcs->cpu == cpu;
> >+       struct vmcs *prev;
> >
> >         if (!already_loaded) {
> >                 loaded_vmcs_clear(vmx->loaded_vmcs);
> >@@ -1333,10 +1335,12 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
> >                 local_irq_enable();
> >         }
> >
> >-       if (per_cpu(current_vmcs, cpu) != vmx->loaded_vmcs->vmcs) {
> >+       prev = per_cpu(current_vmcs, cpu);
> >+       if (prev != vmx->loaded_vmcs->vmcs) {
> >                 per_cpu(current_vmcs, cpu) = vmx->loaded_vmcs->vmcs;
> >                 vmcs_load(vmx->loaded_vmcs->vmcs);
> >-               indirect_branch_prediction_barrier();
> >+               if (!buddy || buddy->vmcs != prev)
> >+                       indirect_branch_prediction_barrier();
> 
> I fail to understand the logic here though. What exactly are you trying to
> catch? We only do the barrier when the current_vmcs as loaded by
> vmx_vcpu_load_vmcs is different from the vmcs of the context that was
> issuing the vmcs load.
> 
> Isn't this a really complicated way to say "Don't flush for nested"? Why not
> just make it explicit and pass in a bool that says "nested = true" from
> vmx_switch_vmcs()? Is there any case I'm missing where that would be unsafe?o

I don't think so, the 'buddy' check was added out of paranoia, and partly
because I was rushing.  I originally had a 'bool nested_switch' as well.

I think I like the boolean approach better, the above check should never
fail in the nested switch case.  I'll add a WARN in vmx_switch_vmcs() with
a note in the patch to let Paolo know it's likely paranoia and can be
ripped out at his discretion.
