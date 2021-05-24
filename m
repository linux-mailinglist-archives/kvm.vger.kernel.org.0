Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B12638F28B
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhEXRwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:52:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233370AbhEXRwh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 13:52:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621878669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g1gGgCHa3fseY0u9aq89tFmjKzwO6pBLwxaqacAvRss=;
        b=Bwb2z53Iii/vfR6mlxOKdEzsvLevkrydmvxSn4/kOI70jTZFjGaBmc3bbGDP0BA/7hSrLE
        dK9YyJ6wy60pl3ElaQYmam77+OF9LRc/v/2p6BHf8iurNBX/RE0D9jFJliSc1xbu22bQ8l
        sk56B/RVCLW4idmDMwI41tfPmcFHgQA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-VxyrhlgkMc2gZjzTSm_vLA-1; Mon, 24 May 2021 13:51:07 -0400
X-MC-Unique: VxyrhlgkMc2gZjzTSm_vLA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F5BD10529D8;
        Mon, 24 May 2021 17:51:00 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F19D1001B2C;
        Mon, 24 May 2021 17:50:56 +0000 (UTC)
Message-ID: <a258f712549eb42266a8109c51032fc77e297f49.camel@redhat.com>
Subject: Re: [PATCH v3 06/12] KVM: X86: Add functions for retrieving L2 TSC
 fields from common code
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, zamsden@gmail.com,
        mtosatti@redhat.com, dwmw@amazon.co.uk
Date:   Mon, 24 May 2021 20:50:55 +0300
In-Reply-To: <20210521102449.21505-7-ilstam@amazon.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
         <20210521102449.21505-7-ilstam@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-05-21 at 11:24 +0100, Ilias Stamatis wrote:
> In order to implement as much of the nested TSC scaling logic as
> possible in common code, we need these vendor callbacks for retrieving
> the TSC offset and the TSC multiplier that L1 has set for L2.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  2 ++
>  arch/x86/include/asm/kvm_host.h    |  2 ++
>  arch/x86/kvm/svm/svm.c             | 14 ++++++++++++++
>  arch/x86/kvm/vmx/vmx.c             | 23 +++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.h             |  3 +++
>  5 files changed, 44 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 323641097f63..2063616fba1c 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -87,6 +87,8 @@ KVM_X86_OP(set_identity_map_addr)
>  KVM_X86_OP(get_mt_mask)
>  KVM_X86_OP(load_mmu_pgd)
>  KVM_X86_OP_NULL(has_wbinvd_exit)
> +KVM_X86_OP(get_l2_tsc_offset)
> +KVM_X86_OP(get_l2_tsc_multiplier)
>  KVM_X86_OP(write_l1_tsc_offset)
>  KVM_X86_OP(get_exit_info)
>  KVM_X86_OP(check_intercept)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b14c2b2b2e21..0f2cf5d1240c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1305,6 +1305,8 @@ struct kvm_x86_ops {
>  
>  	bool (*has_wbinvd_exit)(void);
>  
> +	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
> +	u64 (*get_l2_tsc_multiplier)(struct kvm_vcpu *vcpu);
>  	/* Returns actual tsc_offset set in active VMCS */
>  	u64 (*write_l1_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 05eca131eaf2..ca70e46f9194 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1082,6 +1082,18 @@ static void init_sys_seg(struct vmcb_seg *seg, uint32_t type)
>  	seg->base = 0;
>  }
>  
> +static u64 svm_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	return svm->nested.ctl.tsc_offset;
> +}
> +
> +static u64 svm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_default_tsc_scaling_ratio;
I guess this makes sense as long as we don't support nested TSC scaling on SVM.
Or put a WARN_ON here maybe instead. Doesn't matter, as I'll implement this
right after this series is done, which should be very easy.

> +}
> +
>  static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4526,6 +4538,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  
>  	.has_wbinvd_exit = svm_has_wbinvd_exit,
>  
> +	.get_l2_tsc_offset = svm_get_l2_tsc_offset,
> +	.get_l2_tsc_multiplier = svm_get_l2_tsc_multiplier,
>  	.write_l1_tsc_offset = svm_write_l1_tsc_offset,
>  
>  	.load_mmu_pgd = svm_load_mmu_pgd,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3e4dda8177bb..1c83605eccc1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1787,6 +1787,27 @@ static void setup_msrs(struct vcpu_vmx *vmx)
>  	vmx->guest_uret_msrs_loaded = false;
>  }
>  
> +u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
> +{
> +	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> +
> +	if (nested_cpu_has(vmcs12, CPU_BASED_USE_TSC_OFFSETTING))
> +		return vmcs12->tsc_offset;
> +
> +	return 0;
> +}
> +
> +u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
> +{
> +	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> +
> +	if (nested_cpu_has(vmcs12, CPU_BASED_USE_TSC_OFFSETTING) &&
> +	    nested_cpu_has2(vmcs12, SECONDARY_EXEC_TSC_SCALING))
> +		return vmcs12->tsc_multiplier;
> +
> +	return kvm_default_tsc_scaling_ratio;

> +}
> +
>  static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  {
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> @@ -7700,6 +7721,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  
>  	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
>  
> +	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
> +	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
>  	.write_l1_tsc_offset = vmx_write_l1_tsc_offset,
>  
>  	.load_mmu_pgd = vmx_load_mmu_pgd,
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 16e4e457ba23..aa97c82e3451 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -404,6 +404,9 @@ void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
>  void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>  void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>  
> +u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
> +u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
> +
>  static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>  					     int type, bool value)
>  {

Looks great.
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



