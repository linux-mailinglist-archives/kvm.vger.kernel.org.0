Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E10377E0F
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhEJIYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:24:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230045AbhEJIYm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:24:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620635017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SXcRAMdTTq9agHinpVnDEOoIRb3gzFTcgg5wrqSzOlM=;
        b=eEmAtJRvlMZjlTnbNd1UQ/VmufILT4vi1fX0sVADaahEh7WkMdS3rbB7FJZOZ17fmPm3nb
        P5G/aU4MnkCj14yeWvx/kGiV4k6V/owZ+SKZWy6qzEKLFq9EfkSY/6WkjYy4I9U+igPdji
        P2zeqLw4WyTjcrktrNpQMXxSWLZ0vnU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-rSDw5w2JMAaCVrbGwFX9SA-1; Mon, 10 May 2021 04:23:35 -0400
X-MC-Unique: rSDw5w2JMAaCVrbGwFX9SA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34B76107ACC7;
        Mon, 10 May 2021 08:23:34 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20CB55D9CA;
        Mon, 10 May 2021 08:23:30 +0000 (UTC)
Message-ID: <db161b4dd7286870db5adb9324e4941f0dc3f098.camel@redhat.com>
Subject: Re: [PATCH 08/15] KVM: VMX: Configure list of user return MSRs at
 module init
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:23:29 +0300
In-Reply-To: <20210504171734.1434054-9-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-9-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> Configure the list of user return MSRs that are actually supported at
> module init instead of reprobing the list of possible MSRs every time a
> vCPU is created.  Curating the list on a per-vCPU basis is pointless; KVM
> is completely hosed if the set of supported MSRs changes after module init,
> or if the set of MSRs differs per physical PCU.
> 
> The per-vCPU lists also increase complexity (see __vmx_find_uret_msr()) and
> creates corner cases that _should_ be impossible, but theoretically exist
> in KVM, e.g. advertising RDTSCP to userspace without actually being able to
> virtualize RDTSCP if probing MSR_TSC_AUX fails.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 61 ++++++++++++++++++++++++++++--------------
>  arch/x86/kvm/vmx/vmx.h | 10 ++++++-
>  2 files changed, 50 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 42e4bbaa299a..68454b0de2b1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -461,7 +461,7 @@ static unsigned long host_idt_base;
>   * support this emulation, IA32_STAR must always be included in
>   * vmx_uret_msrs_list[], even in i386 builds.
>   */
> -static const u32 vmx_uret_msrs_list[] = {
> +static u32 vmx_uret_msrs_list[] = {
>  #ifdef CONFIG_X86_64
>  	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
>  #endif
> @@ -469,6 +469,12 @@ static const u32 vmx_uret_msrs_list[] = {
>  	MSR_IA32_TSX_CTRL,
>  };
>  
> +/*
> + * Number of user return MSRs that are actually supported in hardware.
> + * vmx_uret_msrs_list is modified when KVM is loaded to drop unsupported MSRs.
> + */
> +static int vmx_nr_uret_msrs;
> +
>  #if IS_ENABLED(CONFIG_HYPERV)
>  static bool __read_mostly enlightened_vmcs = true;
>  module_param(enlightened_vmcs, bool, 0444);
> @@ -700,9 +706,16 @@ static inline int __vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
>  {
>  	int i;
>  
> -	for (i = 0; i < vmx->nr_uret_msrs; ++i)
> +	/*
> +	 * Note, vmx->guest_uret_msrs is the same size as vmx_uret_msrs_list,
> +	 * but is ordered differently.  The MSR is matched against the list of
> +	 * supported uret MSRs using "slot", but the index that is returned is
> +	 * the index into guest_uret_msrs.
> +	 */
> +	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
>  		if (vmx_uret_msrs_list[vmx->guest_uret_msrs[i].slot] == msr)
>  			return i;
> +	}
>  	return -1;
>  }
>  
> @@ -6929,18 +6942,10 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  			goto free_vpid;
>  	}
>  
> -	BUILD_BUG_ON(ARRAY_SIZE(vmx_uret_msrs_list) != MAX_NR_USER_RETURN_MSRS);
> +	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
> +		vmx->guest_uret_msrs[i].data = 0;
>  
> -	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i) {
> -		u32 index = vmx_uret_msrs_list[i];
> -		int j = vmx->nr_uret_msrs;
> -
> -		if (kvm_probe_user_return_msr(index))
> -			continue;
> -
> -		vmx->guest_uret_msrs[j].slot = i;
I don't see anything initalizing the .slot after this patch.
Now this code is removed later which masks this bug, 
but for the bisect sake, I think that this patch 
should still be fixed.

Other than this minor bug:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



> -		vmx->guest_uret_msrs[j].data = 0;
> -		switch (index) {
> +		switch (vmx_uret_msrs_list[i]) {
>  		case MSR_IA32_TSX_CTRL:
>  			/*
>  			 * TSX_CTRL_CPUID_CLEAR is handled in the CPUID
> @@ -6954,15 +6959,14 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  			 * host so that TSX remains always disabled.
>  			 */
>  			if (boot_cpu_has(X86_FEATURE_RTM))
> -				vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
> +				vmx->guest_uret_msrs[i].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
>  			else
> -				vmx->guest_uret_msrs[j].mask = 0;
> +				vmx->guest_uret_msrs[i].mask = 0;
>  			break;
>  		default:
> -			vmx->guest_uret_msrs[j].mask = -1ull;
> +			vmx->guest_uret_msrs[i].mask = -1ull;
>  			break;
>  		}
> -		++vmx->nr_uret_msrs;
>  	}
>  
>  	err = alloc_loaded_vmcs(&vmx->vmcs01);
> @@ -7821,17 +7825,34 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
>  };
>  
> +static __init void vmx_setup_user_return_msrs(void)
> +{
> +	u32 msr;
> +	int i;
> +
> +	BUILD_BUG_ON(ARRAY_SIZE(vmx_uret_msrs_list) != MAX_NR_USER_RETURN_MSRS);
> +
> +	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i) {
> +		msr = vmx_uret_msrs_list[i];
> +
> +		if (kvm_probe_user_return_msr(msr))
> +			continue;
> +
> +		kvm_define_user_return_msr(vmx_nr_uret_msrs, msr);
> +		vmx_uret_msrs_list[vmx_nr_uret_msrs++] = msr;
> +	}
> +}
> +
>  static __init int hardware_setup(void)
>  {
>  	unsigned long host_bndcfgs;
>  	struct desc_ptr dt;
> -	int r, i, ept_lpage_level;
> +	int r, ept_lpage_level;
>  
>  	store_idt(&dt);
>  	host_idt_base = dt.address;
>  
> -	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i)
> -		kvm_define_user_return_msr(i, vmx_uret_msrs_list[i]);
> +	vmx_setup_user_return_msrs();
>  
>  	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
>  		return -EIO;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 008cb87ff088..d71ed8b425c5 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -245,8 +245,16 @@ struct vcpu_vmx {
>  	u32                   idt_vectoring_info;
>  	ulong                 rflags;
>  
> +	/*
> +	 * User return MSRs are always emulated when enabled in the guest, but
> +	 * only loaded into hardware when necessary, e.g. SYSCALL #UDs outside
> +	 * of 64-bit mode or if EFER.SCE=1, thus the SYSCALL MSRs don't need to
> +	 * be loaded into hardware if those conditions aren't met.
> +	 * nr_active_uret_msrs tracks the number of MSRs that need to be loaded
> +	 * into hardware when running the guest.  guest_uret_msrs[] is resorted
> +	 * whenever the number of "active" uret MSRs is modified.
> +	 */
>  	struct vmx_uret_msr   guest_uret_msrs[MAX_NR_USER_RETURN_MSRS];
> -	int                   nr_uret_msrs;
>  	int                   nr_active_uret_msrs;
>  	bool                  guest_uret_msrs_loaded;
>  #ifdef CONFIG_X86_64






