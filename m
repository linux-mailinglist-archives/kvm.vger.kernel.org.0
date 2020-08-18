Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B0724897C
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 17:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgHRPUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 11:20:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:44079 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgHRPUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 11:20:53 -0400
IronPort-SDR: mvh9hYmyrQQ5RjD4Dk5aKrlW9DvPpY9ru1VzS20wEX/FKHQntDmp2tZvy86M0gb9qXaHbykP/O
 GB0f0hVaGlaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="134447637"
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="134447637"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 08:20:53 -0700
IronPort-SDR: tU6Q6gTJoKe1pKfFsG80dKVijjfk9vXA6qTvOjxrs5kJgGLAQ8vLQ3jkRBhxIJBOwJIxSHuDrS
 w5EutOqTGtNw==
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="441257359"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 08:20:49 -0700
Date:   Tue, 18 Aug 2020 08:20:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Shier <pshier@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: nVMX: Update VMCS02 when L2 PAE PDPTE updates
 detected
Message-ID: <20200818152048.GA15390@linux.intel.com>
References: <20200818004314.216856-1-pshier@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818004314.216856-1-pshier@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 17, 2020 at 05:43:14PM -0700, Peter Shier wrote:
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/vmx/vmx.c          | 11 +++++++++++
>  arch/x86/kvm/x86.c              |  2 ++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5ab3af7275d8..c9971c5d316f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1227,6 +1227,7 @@ struct kvm_x86_ops {
>  	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
>  
>  	void (*migrate_timers)(struct kvm_vcpu *vcpu);
> +	void (*load_pdptrs)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 46ba2e03a892..b8e36ea077dc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2971,6 +2971,16 @@ static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
>  	vpid_sync_context(to_vmx(vcpu)->vpid);
>  }
>  
> +static void vmx_load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> +{
> +	if (enable_ept && is_guest_mode(vcpu)) {
> +		vmcs_write64(GUEST_PDPTR0, mmu->pdptrs[0]);
> +		vmcs_write64(GUEST_PDPTR1, mmu->pdptrs[1]);
> +		vmcs_write64(GUEST_PDPTR2, mmu->pdptrs[2]);
> +		vmcs_write64(GUEST_PDPTR3, mmu->pdptrs[3]);
> +	}
> +}
> +
>  static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
> @@ -8005,6 +8015,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
>  	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
>  	.migrate_timers = vmx_migrate_timers,
> +	.load_pdptrs = vmx_load_pdptrs,
>  };
>  
>  static __init int hardware_setup(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 599d73206299..e52c2d67ba0a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -769,7 +769,8 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
>  	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
>  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
>  
> +	if (kvm_x86_ops.load_pdptrs)
> +		kvm_x86_ops.load_pdptrs(vcpu, mmu);
>  out:
>  
>  	return ret;
> -- 

I'd prefer to handle this on the switch from L2->L1.  It avoids adding a
kvm_x86_ops and yet another sequence of four VMWRITEs, e.g. I think this
will do the trick.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9c74a732b08d..67465f0ca1b9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4356,6 +4356,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
        if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
                kvm_vcpu_flush_tlb_current(vcpu);

+       if (enable_ept && is_pae_paging(vcpu))
+               ept_load_pdptrs(vcpu);
+
        leave_guest_mode(vcpu);

        if (nested_cpu_has_preemption_timer(vmcs12))
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 40f5a3923d5b..aa1f259ee47a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -320,6 +320,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx);
 void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long cr3);
+void ept_load_pdptrs(struct kvm_vcpu *vcpu);
 void ept_save_pdptrs(struct kvm_vcpu *vcpu);
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
