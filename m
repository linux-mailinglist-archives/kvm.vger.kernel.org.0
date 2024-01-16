Return-Path: <kvm+bounces-6324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF76582E9F0
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 08:22:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 529CA1F23D54
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 07:22:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756EF111AD;
	Tue, 16 Jan 2024 07:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fDMbOinz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DA110A3E;
	Tue, 16 Jan 2024 07:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705389749; x=1736925749;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FvGk1HmdhKajQzv0fF9VWQN31pqLokcU8AiwCx1bmjs=;
  b=fDMbOinzKkz75+xTtHrdfGPIeIb8fjUoYT4UWKxqhPh+2sO4/HiUd+8B
   d5BNaJ0VHhGQ/V7vFcDycHQ+63mAN8+99zWFnGkzBIadPs2bypOXeaDua
   Kjo9kSRtqPn83RB+ky96A/m8hAkZfzkI//dkdTPKnZuq2jbmQmTkT+thM
   VBLY86ao0Hl/n0WtJ9NtpcFyzWTeCeUJVN077Cp6DWfqnZIBTQrRM5mm1
   lcM5KAZbrbCTtuiFcdaUDg4zd+94Hr6P85NLG3vB8Y+nYkE7ROmrp544O
   OklSE4ylG6sKwAODQBaC4VV0KUbVKjb3WgQb3CHCoq6XEzsXtgjWAvIPU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="7144664"
X-IronPort-AV: E=Sophos;i="6.04,198,1695711600"; 
   d="scan'208";a="7144664"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 23:22:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="957055072"
X-IronPort-AV: E=Sophos;i="6.04,198,1695711600"; 
   d="scan'208";a="957055072"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga005.jf.intel.com with ESMTP; 15 Jan 2024 23:22:24 -0800
Date: Tue, 16 Jan 2024 15:22:23 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	peterz@infradead.org, chao.gao@intel.com,
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com, john.allen@amd.com
Subject: Re: [PATCH v8 26/26] KVM: nVMX: Enable CET support for nested guest
Message-ID: <20240116072223.zzniln3rcxybxxqi@yy-desk-7060>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <20231221140239.4349-27-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231221140239.4349-27-weijiang.yang@intel.com>
User-Agent: NeoMutt/20171215

On Thu, Dec 21, 2023 at 09:02:39AM -0500, Yang Weijiang wrote:
> Set up CET MSRs, related VM_ENTRY/EXIT control bits and fixed CR4 setting
> to enable CET for nested VM.
>
> vmcs12 and vmcs02 needs to be synced when L2 exits to L1 or when L1 wants
> to resume L2, that way correct CET states can be observed by one another.
>
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 57 +++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/vmx/vmcs12.c |  6 +++++
>  arch/x86/kvm/vmx/vmcs12.h | 14 +++++++++-
>  arch/x86/kvm/vmx/vmx.c    |  2 ++
>  4 files changed, 76 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 468a7cf75035..dee718c65255 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -691,6 +691,28 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>  					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
>
> +	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_U_CET, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_S_CET, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_PL0_SSP, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_PL1_SSP, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_PL2_SSP, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
> +
>  	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>
>  	vmx->nested.force_msr_bitmap_recalc = false;
> @@ -2506,6 +2528,17 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
>  		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>  			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
> +
> +		if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE) {
> +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
> +				vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
> +				vmcs_writel(GUEST_INTR_SSP_TABLE,
> +					    vmcs12->guest_ssp_tbl);
> +			}
> +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
> +			    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT))
> +				vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
> +		}
>  	}
>
>  	if (nested_cpu_has_xsaves(vmcs12))
> @@ -4344,6 +4377,15 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
>  	vmcs12->guest_pending_dbg_exceptions =
>  		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
>
> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
> +		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
> +		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +	}
> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
> +	    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT)) {
> +		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
> +	}
> +
>  	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
>  }
>
> @@ -4569,6 +4611,16 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>  	if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
>  		vmcs_write64(GUEST_BNDCFGS, 0);
>
> +	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_CET_STATE) {
> +		if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
> +			vmcs_writel(HOST_SSP, vmcs12->host_ssp);

Shuold be GUEST_xxx here.

Now KVM does "vmexit" from L2 to L1, thus should sync
vmcs01's guest state with vmcs12's host state, so KVM
can emulate "vmexit" from L2 -> L1 directly by vmlaunch
with vmcs01.

> +			vmcs_writel(HOST_INTR_SSP_TABLE, vmcs12->host_ssp_tbl);

Ditto.

> +		}
> +		if (guest_can_use(vcpu, X86_FEATURE_SHSTK) ||
> +		    guest_can_use(vcpu, X86_FEATURE_IBT))
> +			vmcs_writel(HOST_S_CET, vmcs12->host_s_cet);

Ditto.

> +	}
> +
>  	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) {
>  		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
>  		vcpu->arch.pat = vmcs12->host_ia32_pat;
> @@ -6840,7 +6892,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
>  		VM_EXIT_HOST_ADDR_SPACE_SIZE |
>  #endif
>  		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
> -		VM_EXIT_CLEAR_BNDCFGS;
> +		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
>  	msrs->exit_ctls_high |=
>  		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
>  		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
> @@ -6862,7 +6914,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
>  #ifdef CONFIG_X86_64
>  		VM_ENTRY_IA32E_MODE |
>  #endif
> -		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
> +		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
> +		VM_ENTRY_LOAD_CET_STATE;
>  	msrs->entry_ctls_high |=
>  		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
>  		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
> index 106a72c923ca..4233b5ca9461 100644
> --- a/arch/x86/kvm/vmx/vmcs12.c
> +++ b/arch/x86/kvm/vmx/vmcs12.c
> @@ -139,6 +139,9 @@ const unsigned short vmcs12_field_offsets[] = {
>  	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
>  	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
>  	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
> +	FIELD(GUEST_S_CET, guest_s_cet),
> +	FIELD(GUEST_SSP, guest_ssp),
> +	FIELD(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),
>  	FIELD(HOST_CR0, host_cr0),
>  	FIELD(HOST_CR3, host_cr3),
>  	FIELD(HOST_CR4, host_cr4),
> @@ -151,5 +154,8 @@ const unsigned short vmcs12_field_offsets[] = {
>  	FIELD(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip),
>  	FIELD(HOST_RSP, host_rsp),
>  	FIELD(HOST_RIP, host_rip),
> +	FIELD(HOST_S_CET, host_s_cet),
> +	FIELD(HOST_SSP, host_ssp),
> +	FIELD(HOST_INTR_SSP_TABLE, host_ssp_tbl),
>  };
>  const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs12_field_offsets);
> diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
> index 01936013428b..3884489e7f7e 100644
> --- a/arch/x86/kvm/vmx/vmcs12.h
> +++ b/arch/x86/kvm/vmx/vmcs12.h
> @@ -117,7 +117,13 @@ struct __packed vmcs12 {
>  	natural_width host_ia32_sysenter_eip;
>  	natural_width host_rsp;
>  	natural_width host_rip;
> -	natural_width paddingl[8]; /* room for future expansion */
> +	natural_width host_s_cet;
> +	natural_width host_ssp;
> +	natural_width host_ssp_tbl;
> +	natural_width guest_s_cet;
> +	natural_width guest_ssp;
> +	natural_width guest_ssp_tbl;
> +	natural_width paddingl[2]; /* room for future expansion */
>  	u32 pin_based_vm_exec_control;
>  	u32 cpu_based_vm_exec_control;
>  	u32 exception_bitmap;
> @@ -292,6 +298,12 @@ static inline void vmx_check_vmcs12_offsets(void)
>  	CHECK_OFFSET(host_ia32_sysenter_eip, 656);
>  	CHECK_OFFSET(host_rsp, 664);
>  	CHECK_OFFSET(host_rip, 672);
> +	CHECK_OFFSET(host_s_cet, 680);
> +	CHECK_OFFSET(host_ssp, 688);
> +	CHECK_OFFSET(host_ssp_tbl, 696);
> +	CHECK_OFFSET(guest_s_cet, 704);
> +	CHECK_OFFSET(guest_ssp, 712);
> +	CHECK_OFFSET(guest_ssp_tbl, 720);
>  	CHECK_OFFSET(pin_based_vm_exec_control, 744);
>  	CHECK_OFFSET(cpu_based_vm_exec_control, 748);
>  	CHECK_OFFSET(exception_bitmap, 752);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c802e790c0d5..7ddd3f6fe8ab 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7732,6 +7732,8 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
>  	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
>  	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
>  	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
> +	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
> +	cr4_fixed1_update(X86_CR4_CET,	      edx, feature_bit(IBT));
>
>  	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
>  	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
> --
> 2.39.3
>
>

