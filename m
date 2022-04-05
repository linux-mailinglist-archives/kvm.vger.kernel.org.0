Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F094F49A4
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443487AbiDEWU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457511AbiDEQDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 12:03:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 455251BF
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 08:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649174201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gmuRoHXaTHpPcPTj8ETPBX6hhTtRBA/qrQtbWbW3tDY=;
        b=IX9EmpX+B+9j8jOeBZ1kzUw32f9uh7afyQlg3V4UMH4/du4j4ZfYgvQpcinyvFixhnbNWu
        hDmB6xY2mgFG5XjS6gIZthrwkM7woFoTqJHiTkgD1WPwpeIzgMJ+KsVfl9MipndFMGKLpc
        OqxmBlaYIPqNTf6ScjjSvsdJfq0dCnw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-0fw-QJ5aMSuKk8gZcLpVWw-1; Tue, 05 Apr 2022 11:56:40 -0400
X-MC-Unique: 0fw-QJ5aMSuKk8gZcLpVWw-1
Received: by mail-wr1-f69.google.com with SMTP id e4-20020adfa444000000b002060b7347f8so1708310wra.6
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 08:56:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gmuRoHXaTHpPcPTj8ETPBX6hhTtRBA/qrQtbWbW3tDY=;
        b=O6Q8+F1zCDBZ4N5Rjut76jB9DEwL58f1Ti0uwVOuhTg2IS9zyP4Gy4rGndDFV1OlyL
         GzXSdSRgviGl+Y7EVLPfG/4ARqEWB6I0YsFR+ULMQwOTfjeoEXm//e/14ke6ImE9mJ27
         y2nkpUUsy3Jq30N+x5db4j0ror0234/peA/LjnNO+H50YqA9K67OTXbVxIVRifdWRWpU
         3cwS7+akgW+dYYDMAAQr9PuKzEUj1CX8Eu5KlfwwZEJgZFmhJjnagrsGLRqX/9hp1OYN
         0YzBihmrQD+LwafkDYWRp3BvNNPdcvVyahhg20E9qqQaY4U2N5zR8NZzPSH/0rc6PoHJ
         vkCg==
X-Gm-Message-State: AOAM532TvTkIvYLswy4QHE6xI2rGUz+oKwBOz2wrsvmse15xzVdI7lAJ
        u800qgutL/eLhTC2POvY/CE57jam7EiIaED+erp94KPY61NVk+fSY2n+DOuUNlDzNjcBclz/SVE
        cLCvbxwHeQAqW
X-Received: by 2002:a05:6000:1848:b0:204:e90:cb55 with SMTP id c8-20020a056000184800b002040e90cb55mr3274865wri.58.1649174198637;
        Tue, 05 Apr 2022 08:56:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMPibbKbnYLtaPKgZboCgqLkimBA42X3YZds5n801/e78EzRVhl3kf3Tof29SLPBj5wAWtqw==
X-Received: by 2002:a05:6000:1848:b0:204:e90:cb55 with SMTP id c8-20020a056000184800b002040e90cb55mr3274840wri.58.1649174198299;
        Tue, 05 Apr 2022 08:56:38 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id p8-20020a5d59a8000000b00204178688d3sm14178920wrr.100.2022.04.05.08.56.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 08:56:37 -0700 (PDT)
Message-ID: <7ec77c3c-7819-38bb-96ac-ca249e2e0f42@redhat.com>
Date:   Tue, 5 Apr 2022 17:56:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 102/104] KVM: TDX: Add methods to ignore accesses
 to CPU state
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <3a278829a8617b86b36c32b68a82bc727013ace8.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <3a278829a8617b86b36c32b68a82bc727013ace8.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> TDX protects TDX guest state from VMM.  Implements to access methods for
> TDX guest state to ignore them or return zero.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

For most of these, it would be interesting to see which paths actually 
can be hit.  For SEV, it's all cut out by

         if (vcpu->arch.guest_state_protected)
                 return 0;

in functions such as __set_sregs_common.  Together with the fact that 
TDX does not get to e.g. handle_set_cr0, this should prevent most such 
calls from happening.  So most of these should be KVM_BUG_ON or WARN_ON, 
not just returns.

Thanks,

Paolo

> ---
>   arch/x86/kvm/vmx/main.c    | 465 +++++++++++++++++++++++++++++++++----
>   arch/x86/kvm/vmx/tdx.c     |  44 ++++
>   arch/x86/kvm/vmx/x86_ops.h |  17 ++
>   3 files changed, 483 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index de9b4a270f20..0515998f7fa5 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -228,6 +228,46 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
>   	vmx_enable_smi_window(vcpu);
>   }
>   
> +static bool vt_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
> +				       void *insn, int insn_len)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return false;
> +
> +	return vmx_can_emulate_instruction(vcpu, emul_type, insn, insn_len);
> +}
> +
> +static int vt_check_intercept(struct kvm_vcpu *vcpu,
> +				 struct x86_instruction_info *info,
> +				 enum x86_intercept_stage stage,
> +				 struct x86_exception *exception)
> +{
> +	/*
> +	 * This call back is triggered by the x86 instruction emulator. TDX
> +	 * doesn't allow guest memory inspection.
> +	 */
> +	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
> +		return X86EMUL_UNHANDLEABLE;
> +
> +	return vmx_check_intercept(vcpu, info, stage, exception);
> +}
> +
> +static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return true;
> +
> +	return vmx_apic_init_signal_blocked(vcpu);
> +}
> +
> +static void vt_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_set_virtual_apic_mode(vcpu);
> +
> +	return vmx_set_virtual_apic_mode(vcpu);
> +}
> +
>   static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu))
> @@ -236,6 +276,31 @@ static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>   	return vmx_apicv_post_state_restore(vcpu);
>   }
>   
> +static void vt_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	return vmx_hwapic_irr_update(vcpu, max_irr);
> +}
> +
> +static void vt_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	return vmx_hwapic_isr_update(vcpu, max_isr);
> +}
> +
> +static bool vt_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
> +{
> +	/* TDX doesn't support L2 at the moment. */
> +	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
> +		return false;
> +
> +	return vmx_guest_apic_has_interrupt(vcpu);
> +}
> +
>   static int vt_sync_pir_to_irr(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu))
> @@ -272,6 +337,179 @@ static void vt_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>   	kvm_vcpu_deliver_sipi_vector(vcpu, vector);
>   }
>   
> +static void vt_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	return vmx_vcpu_after_set_cpuid(vcpu);
> +}
> +
> +static void vt_update_exception_bitmap(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_update_exception_bitmap(vcpu);
> +}
> +
> +static u64 vt_get_segment_base(struct kvm_vcpu *vcpu, int seg)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_get_segment_base(vcpu, seg);
> +
> +	return vmx_get_segment_base(vcpu, seg);
> +}
> +
> +static void vt_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
> +			      int seg)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_get_segment(vcpu, var, seg);
> +
> +	vmx_get_segment(vcpu, var, seg);
> +}
> +
> +static void vt_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
> +			      int seg)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_set_segment(vcpu, var, seg);
> +}
> +
> +static int vt_get_cpl(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_get_cpl(vcpu);
> +
> +	return vmx_get_cpl(vcpu);
> +}
> +
> +static void vt_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_get_cs_db_l_bits(vcpu, db, l);
> +}
> +
> +static void vt_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_set_cr0(vcpu, cr0);
> +}
> +
> +static void vt_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_set_cr4(vcpu, cr4);
> +}
> +
> +static int vt_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return 0;
> +
> +	return vmx_set_efer(vcpu, efer);
> +}
> +
> +static void vt_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		memset(dt, 0, sizeof(*dt));
> +		return;
> +	}
> +
> +	vmx_get_idt(vcpu, dt);
> +}
> +
> +static void vt_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_set_idt(vcpu, dt);
> +}
> +
> +static void vt_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		memset(dt, 0, sizeof(*dt));
> +		return;
> +	}
> +
> +	vmx_get_gdt(vcpu, dt);
> +}
> +
> +static void vt_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_set_gdt(vcpu, dt);
> +}
> +
> +static void vt_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_set_dr7(vcpu, val);
> +}
> +
> +static void vt_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * MOV-DR exiting is always cleared for TD guest, even in debug mode.
> +	 * Thus KVM_DEBUGREG_WONT_EXIT can never be set and it should never
> +	 * reach here for TD vcpu.
> +	 */
> +	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
> +		return;
> +
> +	vmx_sync_dirty_debug_regs(vcpu);
> +}
> +
> +static void vt_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_cache_reg(vcpu, reg);
> +		return;
> +	}
> +
> +	vmx_cache_reg(vcpu, reg);
> +}
> +
> +static unsigned long vt_get_rflags(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_get_rflags(vcpu);
> +
> +	return vmx_get_rflags(vcpu);
> +}
> +
> +static void vt_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_set_rflags(vcpu, rflags);
> +}
> +
> +static bool vt_get_if_flag(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return false;
> +
> +	return vmx_get_if_flag(vcpu);
> +}
> +
>   static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu))
> @@ -388,6 +626,15 @@ static u32 vt_get_interrupt_shadow(struct kvm_vcpu *vcpu)
>   	return vmx_get_interrupt_shadow(vcpu);
>   }
>   
> +static void vt_patch_hypercall(struct kvm_vcpu *vcpu,
> +				  unsigned char *hypercall)
> +{
> +	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
> +		return;
> +
> +	vmx_patch_hypercall(vcpu, hypercall);
> +}
> +
>   static void vt_inject_irq(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu))
> @@ -396,6 +643,14 @@ static void vt_inject_irq(struct kvm_vcpu *vcpu)
>   	vmx_inject_irq(vcpu);
>   }
>   
> +static void vt_queue_exception(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_queue_exception(vcpu);
> +}
> +
>   static void vt_cancel_injection(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu))
> @@ -428,6 +683,130 @@ static void vt_request_immediate_exit(struct kvm_vcpu *vcpu)
>   	vmx_request_immediate_exit(vcpu);
>   }
>   
> +static void vt_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_update_cr8_intercept(vcpu, tpr, irr);
> +}
> +
> +static void vt_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
> +{
> +	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
> +		return;
> +
> +	vmx_set_apic_access_page_addr(vcpu);
> +}
> +
> +static void vt_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> +{
> +	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
> +		return;
> +
> +	vmx_refresh_apicv_exec_ctrl(vcpu);
> +}
> +
> +static void vt_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_load_eoi_exitmap(vcpu, eoi_exit_bitmap);
> +}
> +
> +static int vt_set_tss_addr(struct kvm *kvm, unsigned int addr)
> +{
> +	if (is_td(kvm))
> +		return 0;
> +
> +	return vmx_set_tss_addr(kvm, addr);
> +}
> +
> +static int vt_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
> +{
> +	if (is_td(kvm))
> +		return 0;
> +
> +	return vmx_set_identity_map_addr(kvm, ident_addr);
> +}
> +
> +static u64 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		if (is_mmio)
> +			return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
> +		return  MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> +	}
> +
> +	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
> +}
> +
> +static u64 vt_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
> +{
> +	/* TDX doesn't support L2 guest at the moment. */
> +	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
> +		return 0;
> +
> +	return vmx_get_l2_tsc_offset(vcpu);
> +}
> +
> +static u64 vt_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
> +{
> +	/* TDX doesn't support L2 guest at the moment. */
> +	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
> +		return 0;
> +
> +	return vmx_get_l2_tsc_multiplier(vcpu);
> +}
> +
> +static void vt_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> +{
> +	/* In TDX, tsc offset can't be changed. */
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_write_tsc_offset(vcpu, offset);
> +}
> +
> +static void vt_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
> +{
> +	/* In TDX, tsc multiplier can't be changed. */
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_write_tsc_multiplier(vcpu, multiplier);
> +}
> +
> +static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_update_cpu_dirty_logging(vcpu);
> +}
> +
> +#ifdef CONFIG_X86_64
> +static int vt_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
> +			      bool *expired)
> +{
> +	/* VMX-preemption timer isn't available for TDX. */
> +	if (is_td_vcpu(vcpu))
> +		return -EINVAL;
> +
> +	return vmx_set_hv_timer(vcpu, guest_deadline_tsc, expired);
> +}
> +
> +static void vt_cancel_hv_timer(struct kvm_vcpu *vcpu)
> +{
> +	/* VMX-preemption timer can't be set.  Set vt_set_hv_timer(). */
> +	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
> +		return;
> +
> +	vmx_cancel_hv_timer(vcpu);
> +}
> +#endif
> +
>   static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
>   			u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
>   {
> @@ -480,29 +859,29 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vcpu_load = vt_vcpu_load,
>   	.vcpu_put = vt_vcpu_put,
>   
> -	.update_exception_bitmap = vmx_update_exception_bitmap,
> +	.update_exception_bitmap = vt_update_exception_bitmap,
>   	.get_msr_feature = vmx_get_msr_feature,
>   	.get_msr = vt_get_msr,
>   	.set_msr = vt_set_msr,
> -	.get_segment_base = vmx_get_segment_base,
> -	.get_segment = vmx_get_segment,
> -	.set_segment = vmx_set_segment,
> -	.get_cpl = vmx_get_cpl,
> -	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
> -	.set_cr0 = vmx_set_cr0,
> +	.get_segment_base = vt_get_segment_base,
> +	.get_segment = vt_get_segment,
> +	.set_segment = vt_set_segment,
> +	.get_cpl = vt_get_cpl,
> +	.get_cs_db_l_bits = vt_get_cs_db_l_bits,
> +	.set_cr0 = vt_set_cr0,
>   	.is_valid_cr4 = vmx_is_valid_cr4,
> -	.set_cr4 = vmx_set_cr4,
> -	.set_efer = vmx_set_efer,
> -	.get_idt = vmx_get_idt,
> -	.set_idt = vmx_set_idt,
> -	.get_gdt = vmx_get_gdt,
> -	.set_gdt = vmx_set_gdt,
> -	.set_dr7 = vmx_set_dr7,
> -	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
> -	.cache_reg = vmx_cache_reg,
> -	.get_rflags = vmx_get_rflags,
> -	.set_rflags = vmx_set_rflags,
> -	.get_if_flag = vmx_get_if_flag,
> +	.set_cr4 = vt_set_cr4,
> +	.set_efer = vt_set_efer,
> +	.get_idt = vt_get_idt,
> +	.set_idt = vt_set_idt,
> +	.get_gdt = vt_get_gdt,
> +	.set_gdt = vt_set_gdt,
> +	.set_dr7 = vt_set_dr7,
> +	.sync_dirty_debug_regs = vt_sync_dirty_debug_regs,
> +	.cache_reg = vt_cache_reg,
> +	.get_rflags = vt_get_rflags,
> +	.set_rflags = vt_set_rflags,
> +	.get_if_flag = vt_get_if_flag,
>   
>   	.tlb_flush_all = vt_flush_tlb_all,
>   	.tlb_flush_current = vt_flush_tlb_current,
> @@ -516,10 +895,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.update_emulated_instruction = vmx_update_emulated_instruction,
>   	.set_interrupt_shadow = vt_set_interrupt_shadow,
>   	.get_interrupt_shadow = vt_get_interrupt_shadow,
> -	.patch_hypercall = vmx_patch_hypercall,
> +	.patch_hypercall = vt_patch_hypercall,
>   	.set_irq = vt_inject_irq,
>   	.set_nmi = vt_inject_nmi,
> -	.queue_exception = vmx_queue_exception,
> +	.queue_exception = vt_queue_exception,
>   	.cancel_injection = vt_cancel_injection,
>   	.interrupt_allowed = vt_interrupt_allowed,
>   	.nmi_allowed = vt_nmi_allowed,
> @@ -527,39 +906,39 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.set_nmi_mask = vt_set_nmi_mask,
>   	.enable_nmi_window = vt_enable_nmi_window,
>   	.enable_irq_window = vt_enable_irq_window,
> -	.update_cr8_intercept = vmx_update_cr8_intercept,
> -	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
> -	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
> -	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
> -	.load_eoi_exitmap = vmx_load_eoi_exitmap,
> +	.update_cr8_intercept = vt_update_cr8_intercept,
> +	.set_virtual_apic_mode = vt_set_virtual_apic_mode,
> +	.set_apic_access_page_addr = vt_set_apic_access_page_addr,
> +	.refresh_apicv_exec_ctrl = vt_refresh_apicv_exec_ctrl,
> +	.load_eoi_exitmap = vt_load_eoi_exitmap,
>   	.apicv_post_state_restore = vt_apicv_post_state_restore,
>   	.check_apicv_inhibit_reasons = vmx_check_apicv_inhibit_reasons,
> -	.hwapic_irr_update = vmx_hwapic_irr_update,
> -	.hwapic_isr_update = vmx_hwapic_isr_update,
> -	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
> +	.hwapic_irr_update = vt_hwapic_irr_update,
> +	.hwapic_isr_update = vt_hwapic_isr_update,
> +	.guest_apic_has_interrupt = vt_guest_apic_has_interrupt,
>   	.sync_pir_to_irr = vt_sync_pir_to_irr,
>   	.deliver_interrupt = vt_deliver_interrupt,
>   	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
>   	.apicv_has_pending_interrupt = vt_apicv_has_pending_interrupt,
>   
> -	.set_tss_addr = vmx_set_tss_addr,
> -	.set_identity_map_addr = vmx_set_identity_map_addr,
> -	.get_mt_mask = vmx_get_mt_mask,
> +	.set_tss_addr = vt_set_tss_addr,
> +	.set_identity_map_addr = vt_set_identity_map_addr,
> +	.get_mt_mask = vt_get_mt_mask,
>   
>   	.get_exit_info = vt_get_exit_info,
>   
> -	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
> +	.vcpu_after_set_cpuid = vt_vcpu_after_set_cpuid,
>   
>   	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
>   
> -	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
> -	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
> -	.write_tsc_offset = vmx_write_tsc_offset,
> -	.write_tsc_multiplier = vmx_write_tsc_multiplier,
> +	.get_l2_tsc_offset = vt_get_l2_tsc_offset,
> +	.get_l2_tsc_multiplier = vt_get_l2_tsc_multiplier,
> +	.write_tsc_offset = vt_write_tsc_offset,
> +	.write_tsc_multiplier = vt_write_tsc_multiplier,
>   
>   	.load_mmu_pgd = vt_load_mmu_pgd,
>   
> -	.check_intercept = vmx_check_intercept,
> +	.check_intercept = vt_check_intercept,
>   	.handle_exit_irqoff = vt_handle_exit_irqoff,
>   
>   	.request_immediate_exit = vt_request_immediate_exit,
> @@ -567,7 +946,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.sched_in = vt_sched_in,
>   
>   	.cpu_dirty_log_size = PML_ENTITY_NUM,
> -	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
> +	.update_cpu_dirty_logging = vt_update_cpu_dirty_logging,
>   
>   	.pmu_ops = &intel_pmu_ops,
>   	.nested_ops = &vmx_nested_ops,
> @@ -576,8 +955,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.start_assignment = vmx_pi_start_assignment,
>   
>   #ifdef CONFIG_X86_64
> -	.set_hv_timer = vmx_set_hv_timer,
> -	.cancel_hv_timer = vmx_cancel_hv_timer,
> +	.set_hv_timer = vt_set_hv_timer,
> +	.cancel_hv_timer = vt_cancel_hv_timer,
>   #endif
>   
>   	.setup_mce = vmx_setup_mce,
> @@ -587,8 +966,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.leave_smm = vt_leave_smm,
>   	.enable_smi_window = vt_enable_smi_window,
>   
> -	.can_emulate_instruction = vmx_can_emulate_instruction,
> -	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> +	.can_emulate_instruction = vt_can_emulate_instruction,
> +	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
>   	.migrate_timers = vmx_migrate_timers,
>   
>   	.msr_filter_changed = vmx_msr_filter_changed,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 7bbf6271967b..55a6fd218fc7 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3,6 +3,7 @@
>   #include <linux/mmu_context.h>
>   
>   #include <asm/fpu/xcr.h>
> +#include <asm/virtext.h>
>   #include <asm/tdx.h>
>   
>   #include "capabilities.h"
> @@ -1717,6 +1718,49 @@ void tdx_enable_smi_window(struct kvm_vcpu *vcpu)
>   	vcpu->arch.smi_pending = false;
>   }
>   
> +void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> +{
> +	/* Only x2APIC mode is supported for TD. */
> +	WARN_ON_ONCE(kvm_get_apic_mode(vcpu) != LAPIC_MODE_X2APIC);
> +}
> +
> +int tdx_get_cpl(struct kvm_vcpu *vcpu)
> +{
> +	return 0;
> +}
> +
> +void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
> +{
> +	kvm_register_mark_available(vcpu, reg);
> +	switch (reg) {
> +	case VCPU_REGS_RSP:
> +	case VCPU_REGS_RIP:
> +	case VCPU_EXREG_PDPTR:
> +	case VCPU_EXREG_CR0:
> +	case VCPU_EXREG_CR3:
> +	case VCPU_EXREG_CR4:
> +		break;
> +	default:
> +		KVM_BUG_ON(1, vcpu->kvm);
> +		break;
> +	}
> +}
> +
> +unsigned long tdx_get_rflags(struct kvm_vcpu *vcpu)
> +{
> +	return 0;
> +}
> +
> +u64 tdx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
> +{
> +	return 0;
> +}
> +
> +void tdx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
> +{
> +	memset(var, 0, sizeof(*var));
> +}
> +
>   static int tdx_capabilities(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>   {
>   	struct kvm_tdx_capabilities __user *user_caps;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 19d793609cc4..7cd29b586e43 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -163,6 +163,14 @@ int tdx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection);
>   int tdx_enter_smm(struct kvm_vcpu *vcpu, char *smstate);
>   int tdx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate);
>   void tdx_enable_smi_window(struct kvm_vcpu *vcpu);
> +void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
> +
> +int tdx_get_cpl(struct kvm_vcpu *vcpu);
> +void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
> +unsigned long tdx_get_rflags(struct kvm_vcpu *vcpu);
> +bool tdx_is_emulated_msr(u32 index, bool write);
> +u64 tdx_get_segment_base(struct kvm_vcpu *vcpu, int seg);
> +void tdx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
>   
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> @@ -203,10 +211,19 @@ static inline void tdx_get_exit_info(
>   static inline bool tdx_is_emulated_msr(u32 index, bool write) { return false; }
>   static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
>   static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
> +
>   static inline int tdx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection) { return false; }
>   static inline int tdx_enter_smm(struct kvm_vcpu *vcpu, char *smstate) { return 0; }
>   static inline int tdx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate) { return 0; }
>   static inline void tdx_enable_smi_window(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu) {}
> +
> +static inline int tdx_get_cpl(struct kvm_vcpu *vcpu) { return 0; }
> +static inline void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg) {}
> +static inline unsigned long tdx_get_rflags(struct kvm_vcpu *vcpu) { return 0; }
> +static inline u64 tdx_get_segment_base(struct kvm_vcpu *vcpu, int seg) { return 0;}
> +static inline void tdx_get_segment(
> +	struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg) {}
>   
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }

