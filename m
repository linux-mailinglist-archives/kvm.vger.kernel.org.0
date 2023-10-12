Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EC17C7755
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 21:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442515AbjJLTwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 15:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344135AbjJLTwg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 15:52:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D81610CF
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 12:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697140276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lOqwqOHWyDl6wMyI0KpVfLtp4+Ja99+K4N0xxMHIh/M=;
        b=TYeJnfLVHQHAk2HRuFiyd+sOMf8QY8nCvHB/QGkcluLBI2xsX/Kqbg/2EnVwhzV/ifc2JN
        OjTqmpIkPVE+m6NHqK5vS0sUjhju0JF8UFSahlcjqrgKAM6REfe0SgwRpt0i7suoCxTFO5
        907KoGAVE4R0CJxz5jdvMpFLOeXItoM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-OLeprTyiPxauU54XwHCUzw-1; Thu, 12 Oct 2023 15:51:14 -0400
X-MC-Unique: OLeprTyiPxauU54XwHCUzw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30932d15a30so814071f8f.1
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 12:51:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697140273; x=1697745073;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lOqwqOHWyDl6wMyI0KpVfLtp4+Ja99+K4N0xxMHIh/M=;
        b=BOBMmFWaZDb7UXOfUwpIpxGI8TI+tV++uVgviWEFc23JPVYKt+czukoSByLdu02ChW
         fnkq/NEwHsiy+gZ/no08pr4uyCNgSlUVZZSrgWsxfjETNavJEiDLSyVAQxHGWXEg1+yW
         AEcWs77wj1W606AXfMOgKg4teVKifFFsHoWdzkq8EsYjXoWzJ3BrI0zbIY/0BMIeRhCb
         PF+2+25k9sZv21tsccWY/8OybPBZFVlsEz1i7cfvgz2tiNCNOb+RLIzv0crsLYAsghOd
         X+Z2GYJPSCsZ6gD8IXt1MoRmkKgKjfq3bh/xwwewLJfjEbtYOXtw0XjkaxnWfqhDjypc
         x4Og==
X-Gm-Message-State: AOJu0YzIvgU2+cE6e0LW5KDnSgpMMGomkjDMae7a+byCCscuKdGFgZB0
        jx/Qj2VlDh2KwZ37PCdTFaQgYrH2fyAsG5Z7ZUsURT+QVURG5A7JaZbAZDuE96aXCaYxa2EjRQ2
        CEmss9VXjOEZO
X-Received: by 2002:adf:f407:0:b0:323:2d1b:eaf6 with SMTP id g7-20020adff407000000b003232d1beaf6mr22482644wro.67.1697140273207;
        Thu, 12 Oct 2023 12:51:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIj2KoQ2zwk1oT18Xij01wgWM7WhS3YauGyDKvSfsJC7TXWU4So7oH2VOGUf3mA842wcRWsw==
X-Received: by 2002:adf:f407:0:b0:323:2d1b:eaf6 with SMTP id g7-20020adff407000000b003232d1beaf6mr22482637wro.67.1697140272850;
        Thu, 12 Oct 2023 12:51:12 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id z17-20020a5d4d11000000b0032d9548240fsm1732198wrt.82.2023.10.12.12.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 12:51:12 -0700 (PDT)
Message-ID: <ed2275e2e12260ea28d6f003be10c5eed69af8e7.camel@redhat.com>
Subject: Re: [PATCH RFC 09/11] KVM: nVMX: hyper-v: Introduce
 nested_vmx_evmcs() accessor
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Date:   Thu, 12 Oct 2023 22:51:10 +0300
In-Reply-To: <20231010160300.1136799-10-vkuznets@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
         <20231010160300.1136799-10-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-10-10 у 18:02 +0200, Vitaly Kuznetsov пише:
> There's a number of 'vmx->nested.hv_evmcs' accesses in nested.c, introduce
> 'nested_vmx_evmcs()' accessor to hide them all in !CONFIG_KVM_HYPERV case.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/hyperv.h |  8 ++++++++
>  arch/x86/kvm/vmx/nested.c | 33 ++++++++++++++++++---------------
>  2 files changed, 26 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
> index 6ca5c8c5be9c..b07131a23250 100644
> --- a/arch/x86/kvm/vmx/hyperv.h
> +++ b/arch/x86/kvm/vmx/hyperv.h
> @@ -25,6 +25,10 @@ struct vcpu_vmx;
>  
>  #ifdef CONFIG_KVM_HYPERV
>  static inline gpa_t nested_vmx_evmptr(struct vcpu_vmx *vmx) { return vmx->nested.hv_evmcs_vmptr; }
> +static inline struct hv_enlightened_vmcs *nested_vmx_evmcs(struct vcpu_vmx *vmx)
> +{
> +	return vmx->nested.hv_evmcs;
> +}
>  u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
>  uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
>  int nested_enable_evmcs(struct kvm_vcpu *vcpu,
> @@ -35,6 +39,10 @@ bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
>  void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
>  #else
>  static inline gpa_t nested_vmx_evmptr(struct vcpu_vmx *vmx) { return EVMPTR_INVALID; };
> +static inline struct hv_enlightened_vmcs *nested_vmx_evmcs(struct vcpu_vmx *vmx)
> +{
> +	return NULL;
> +}
>  static inline u64 nested_get_evmptr(struct kvm_vcpu *vcpu) { return EVMPTR_INVALID; }
>  static inline void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata) {}
>  static inline bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu) { return false; }
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e6476f8e2ccd..d539904d8f1e 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -574,7 +574,6 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  	int msr;
>  	unsigned long *msr_bitmap_l1;
>  	unsigned long *msr_bitmap_l0 = vmx->nested.vmcs02.msr_bitmap;
> -	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
>  	struct kvm_host_map *map = &vmx->nested.msr_bitmap_map;
>  
>  	/* Nothing to do if the MSR bitmap is not in use.  */
> @@ -590,10 +589,13 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  	 * - Nested hypervisor (L1) has enabled 'Enlightened MSR Bitmap' feature
>  	 *   and tells KVM (L0) there were no changes in MSR bitmap for L2.
>  	 */
> -	if (!vmx->nested.force_msr_bitmap_recalc && evmcs &&
> -	    evmcs->hv_enlightenments_control.msr_bitmap &&
> -	    evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP)
> -		return true;
> +	if (!vmx->nested.force_msr_bitmap_recalc) {
> +		struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
> +
> +		if (evmcs && evmcs->hv_enlightenments_control.msr_bitmap &&
> +		    evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP)
> +			return true;
> +	}
>  
>  	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), map))
>  		return false;
> @@ -1584,7 +1586,7 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
>  static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields)
>  {
>  	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
> -	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
> +	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(&vmx->vcpu);
>  
>  	/* HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE */
> @@ -1828,7 +1830,7 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
>  static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
>  {
>  	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
> -	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
> +	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
>  
>  	/*
>  	 * Should not be changed by KVM:
> @@ -2412,7 +2414,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>  
>  static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  {
> -	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
> +	struct hv_enlightened_vmcs *hv_evmcs = nested_vmx_evmcs(vmx);
>  
>  	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
>  			   HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2)) {
> @@ -2544,6 +2546,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  			  enum vm_entry_failure_code *entry_failure_code)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
>  	bool load_guest_pdptrs_vmcs12 = false;
>  
>  	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(nested_vmx_evmptr(vmx))) {
> @@ -2551,8 +2554,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  		vmx->nested.dirty_vmcs12 = false;
>  
>  		load_guest_pdptrs_vmcs12 = !evmptr_is_valid(nested_vmx_evmptr(vmx)) ||
> -			!(vmx->nested.hv_evmcs->hv_clean_fields &
> -			  HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
> +			!(evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
>  	}
>  
>  	if (vmx->nested.nested_run_pending &&
> @@ -2674,8 +2676,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	 * here.
>  	 */
>  	if (evmptr_is_valid(nested_vmx_evmptr(vmx)))
> -		vmx->nested.hv_evmcs->hv_clean_fields |=
> -			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
> +		evmcs->hv_clean_fields |= HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
>  
>  	return 0;
>  }
> @@ -3600,7 +3601,9 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  		return nested_vmx_failInvalid(vcpu);
>  
>  	if (evmptr_is_valid(nested_vmx_evmptr(vmx))) {
> -		copy_enlightened_to_vmcs12(vmx, vmx->nested.hv_evmcs->hv_clean_fields);
> +		struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
> +
> +		copy_enlightened_to_vmcs12(vmx, evmcs->hv_clean_fields);
>  		/* Enlightened VMCS doesn't have launch state */
>  		vmcs12->launch_state = !launch;
>  	} else if (enable_shadow_vmcs) {
> @@ -5335,7 +5338,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
>  					   vmptr + offsetof(struct vmcs12,
>  							    launch_state),
>  					   &zero, sizeof(zero));
> -	} else if (vmx->nested.hv_evmcs && vmptr == nested_vmx_evmptr(vmx)) {
> +	} else if (nested_vmx_evmcs(vmx) && vmptr == nested_vmx_evmptr(vmx)) {
>  		nested_release_evmcs(vcpu);
>  	}
>  
> @@ -5413,7 +5416,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>  			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
>  
>  		/* Read the field, zero-extended to a u64 value */
> -		value = evmcs_read_any(vmx->nested.hv_evmcs, field, offset);
> +		value = evmcs_read_any(nested_vmx_evmcs(vmx), field, offset);
>  	}
>  
>  	/*

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


