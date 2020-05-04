Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BCF1C3D00
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 16:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgEDO3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 10:29:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:10186 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728486AbgEDO3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 10:29:38 -0400
IronPort-SDR: DqN//+WXfewpoXY2ugTjMm6t3xEP6iMEgcDRBevVPTDROxHjOT1GLpmnt35r8z7hdIfr1sngUp
 8urm3+dscnVg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 07:29:37 -0700
IronPort-SDR: iDqMIApWMrLvqyrp4b+noLJWhA1sSSJaN1o4qQFAscjAq2F3HVn8fIQsk4NZNSGa3ScNI5X32X
 sl3/q3dfiOoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,352,1583222400"; 
   d="scan'208";a="460683383"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 04 May 2020 07:29:33 -0700
Date:   Mon, 4 May 2020 07:29:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        KarimAllah Raslan <karahmed@amazon.de>
Subject: Re: [PATCH v2] KVM: nVMX: Skip IBPB when switching between vmcs01
 and vmcs02
Message-ID: <20200504142933.GA16949@linux.intel.com>
References: <20200501163117.4655-1-sean.j.christopherson@intel.com>
 <1de7b016-8bc9-23d4-7f8b-145c30d7e58a@amazon.com>
 <9d0d09da-3920-16d6-11ae-51b864171b66@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d0d09da-3920-16d6-11ae-51b864171b66@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 03:12:36PM +0200, Paolo Bonzini wrote:
> On 04/05/20 14:01, Alexander Graf wrote:
> > I like the WARN_ON :). It should be almost free during execution, but
> > helps us catch problems early.
> 
> Yes, it's nice.  I didn't mind the "buddy" argument either, but if we're 
> going to get a bool I prefer positive logic so I'd like to squash this:

I don't love need_ibpb as a param name, it doesn't provide any information
as to why the IBPB is needed.  But, I can't come up with anything better
that isn't absurdly long because e.g. "different_guest" isn't necessarily
true in the vmx_vcpu_load() path.

What about going the @buddy route and adding the comment and WARN in
vmx_vcpu_load_vmcs()?  E.g.

        prev = per_cpu(current_vmcs, cpu);
        if (prev != vmx->loaded_vmcs->vmcs) {
                per_cpu(current_vmcs, cpu) = vmx->loaded_vmcs->vmcs;
                vmcs_load(vmx->loaded_vmcs->vmcs);

                /*
                 * No indirect branch prediction barrier needed when switching
		 * the active VMCS within a guest, e.g. on nested VM-Enter.
		 * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
                 */
                if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
                        indirect_branch_prediction_barrier();
        }

> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b57420f3dd8f..299393750a18 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -304,7 +304,13 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
>  	prev = vmx->loaded_vmcs;
>  	WARN_ON_ONCE(prev->cpu != cpu || prev->vmcs != per_cpu(current_vmcs, cpu));
>  	vmx->loaded_vmcs = vmcs;
> -	vmx_vcpu_load_vmcs(vcpu, cpu, true);
> +
> +	/*
> +	 * This is the same guest from our point of view, so no
> +	 * indirect branch prediction barrier is needed.  The L1
> +	 * guest can protect itself with retpolines, IBPB or IBRS.
> +	 */
> +	vmx_vcpu_load_vmcs(vcpu, cpu, false);
>  	vmx_sync_vmcs_host_state(vmx, prev);
>  	put_cpu();
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 669e14947ba9..0f9c8d2dd7f6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1311,7 +1311,7 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  		pi_set_on(pi_desc);
>  }
>  
> -void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu, bool nested_switch)
> +void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu, bool need_ibpb)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	bool already_loaded = vmx->loaded_vmcs->cpu == cpu;
> @@ -1336,7 +1336,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu, bool nested_switch)
>  	if (per_cpu(current_vmcs, cpu) != vmx->loaded_vmcs->vmcs) {
>  		per_cpu(current_vmcs, cpu) = vmx->loaded_vmcs->vmcs;
>  		vmcs_load(vmx->loaded_vmcs->vmcs);
> -		if (!nested_switch)
> +		if (need_ibpb)
>  			indirect_branch_prediction_barrier();
>  	}
>  
> @@ -1378,7 +1378,7 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> -	vmx_vcpu_load_vmcs(vcpu, cpu, false);
> +	vmx_vcpu_load_vmcs(vcpu, cpu, true);
>  
>  	vmx_vcpu_pi_load(vcpu, cpu);
>  
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index fa61dc802183..e584ee9b3e94 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -320,7 +320,7 @@ struct kvm_vmx {
>  };
>  
>  bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
> -void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu, bool nested_switch);
> +void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu, bool need_ibpb);
>  void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>  int allocate_vpid(void);
>  void free_vpid(int vpid);
> 
> 
> Paolo
> 
