Return-Path: <kvm+bounces-66946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A585BCEEE51
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 16:40:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 798C830173AB
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 15:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C5A27B343;
	Fri,  2 Jan 2026 15:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H7MF+bRM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="duxQKhhq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8442773EE
	for <kvm@vger.kernel.org>; Fri,  2 Jan 2026 15:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767368411; cv=none; b=K/wX4pEELtdNxzSJ7wxIV5NgKs1WuhPFJeKoo7OKW2ZcKepUKslVTA6pswvRVvd4XzmYYMFVdAGUIaELvdd3kUAJl285EYM2AP8MVctwhNFmervTv8biWlP72eMXytTT3MhsNBlOcK1XFSZQkoWfugYs9OAA4m+EWIgYgsLo6xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767368411; c=relaxed/simple;
	bh=IBQ00UslAs5Lok7WESox5wn0+cSAkbMmOGLwasYuRRE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=TPkusqjtVEHgojoG/SiGevL6XP95COf0s5Ey9bu+EgnE/LXoMUNSEe0aVSA+vffHUSgkA537IoYCsFlSZaN0QenkYOtbGXGQuwQcLIV1JeDDORObtkRKL+l/YDUAuILOAaqFnHRi0HWM2fo69+No3aIKRMWgogeknSdD9WcxC1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H7MF+bRM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=duxQKhhq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767368408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AAiayzJRY4ItQKaVQXIlfsuuXXNsffQ7Fc+1hVjxa0I=;
	b=H7MF+bRM7JnlgRY9Z3R42nxniOKPb4jzNUfH6eNfDa/WnUoqMMvsucL45MH+GtRWkvpuBc
	DO5AySjwqnz2NfD1kRzCIBEjEIR0LaFTKpuPQASChdGIOEyjgbry0ah83yzZCF+j8wqhfK
	6ClwfjGbZI/rCezc7Tcqpq/5F3dk9Uo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-LqgwZL4XO6GXvyK4vr4WfQ-1; Fri, 02 Jan 2026 10:40:06 -0500
X-MC-Unique: LqgwZL4XO6GXvyK4vr4WfQ-1
X-Mimecast-MFC-AGG-ID: LqgwZL4XO6GXvyK4vr4WfQ_1767368406
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-430fcfe4494so11390159f8f.2
        for <kvm@vger.kernel.org>; Fri, 02 Jan 2026 07:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767368405; x=1767973205; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=AAiayzJRY4ItQKaVQXIlfsuuXXNsffQ7Fc+1hVjxa0I=;
        b=duxQKhhqPq2BGvJHOumXO4Yoe04tPFi5A4MgLEc78+n+Tuvb3puqgRDszkroYrHk8J
         0INd451ZMEWxc8uCvSt6W3bJuYUottMcln5v8aPnYasORiCRsLqrwSgmoIcQVDLoUJYp
         Ec39CmqatLEi3vD7x/1tQM73rlY11L+SVH27lzIGAbEzAhFrQzJlMsuBnmKGUkOjyKcI
         9qtY9/hxIEV9jy5RWMIOeIG/6549+BPuUBw3+lC3sOPw+ALMu+49rdkS0Vd6maF+RwQr
         OOSu/6MSP1Kz8TDwuv6hnQz+fle7Zm2qC/Vd0V+GfkrHi1xWAbk7mnBIFO84VSB1gNGu
         2Flg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767368405; x=1767973205;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AAiayzJRY4ItQKaVQXIlfsuuXXNsffQ7Fc+1hVjxa0I=;
        b=lRAa7IdM1GrI+W2VNa3WR3sExwyKBRRuPYcxMxW76WWJdNctNeo7tJCrGc9Z711QHV
         yUDl/VC0N2fLUf8vTKgStcLpA3R+JR01CHasKlf5IpYqJ9uWwThtaM6LBqvc++Std5wg
         nZf9wH8+sxoZsqSm72AwgnDCfoysx1LOwL9gX5yKOAe/DXyYLWCGBzkIBjUzGsC4ijnP
         nuUvWhmeAnkVm/NBtKEiSLYD6Lo+AUiqFi0eI7fOiilv+0YS+ozd9hzFyz/I19kGqKCl
         HiUxCflrYgHgQvC+zjGV2Ym+yKsWfxyr9vOL7KHdqwjTY6nm+fQoOqLePqemJz5bqPFP
         Hkgw==
X-Forwarded-Encrypted: i=1; AJvYcCWuiIj7vg7RuwRzoqgDsSNbvoqsYefEecxG0SJfnTMAboSNcYTCbwsMwEiL/cEZ1hbCM5M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6MnKZk/RjmIEz+0gfNoypj4t6QSwvpVm0bwTS1ZCuhyWF1QUx
	liaP6R33tlryL7anUVz1cmFkjtpYfq708/z2+zon1uBw9vjI674GQgYX+gnPswkWWCfpXa9xo2F
	tH3X8ek7p2dH+qqzpGArfiG0o6UTfKD+5tcm1FNpQdSynpW9hDZBO2w==
X-Gm-Gg: AY/fxX4UwJXVIHg/StOJeT21Dx/KvIKoZbIQBuw4OX8pLkX53D375DdQ5n30AOb8YY8
	1Rq6VK/qge3q9xaKtje7F+fxYYE6wavuUd924RsyaHkkaE0iY8KmkOheWOg2YvF3VELY83sdV5r
	5SZjK6LMOPr8wZ1d14gkUTLQ4v+93qYDvN6xeTC+0HNZEs63xGvn2gOqVSRQ9Jhm5XBY1XhK+zc
	fvD+uS2HklLpuG098J+o/FduMNGTFt+yI/JY6LItH/yZC8MVUtLiC+GqULoxa3e0+NZCzgKYxod
	Pnwc6Eco+QSCt3+WEkQA85Ym7yF6eDj/nqTc/UM35OZjwmAOHq/T8sCuirsc0uAs2K84MVWDGRx
	MA4QAlA==
X-Received: by 2002:a05:6000:2509:b0:42f:9f4d:a490 with SMTP id ffacd0b85a97d-4324e4c73e8mr60757712f8f.12.1767368405518;
        Fri, 02 Jan 2026 07:40:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEn5bxm6K3DZOY955faWJJP5hamKzqDm3+/kp9SotyMIyuzEKHtKcoLIsNhJV7Y4+/I3b/8rg==
X-Received: by 2002:a05:6000:2509:b0:42f:9f4d:a490 with SMTP id ffacd0b85a97d-4324e4c73e8mr60757670f8f.12.1767368405030;
        Fri, 02 Jan 2026 07:40:05 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa2bdfsm86129275f8f.32.2026.01.02.07.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 07:40:04 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Fred Griffoul <griffoul@gmail.com>, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, shuah@kernel.org,
 dwmw@amazon.co.uk, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Fred Griffoul <fgriffo@amazon.co.uk>
Subject: Re: [PATCH v4 06/10] KVM: nVMX: Cache evmcs fields to ensure
 consistency during VM-entry
In-Reply-To: <20260102142429.896101-7-griffoul@gmail.com>
References: <20260102142429.896101-1-griffoul@gmail.com>
 <20260102142429.896101-7-griffoul@gmail.com>
Date: Fri, 02 Jan 2026 16:40:03 +0100
Message-ID: <87a4ywaur0.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Fred Griffoul <griffoul@gmail.com> writes:

> From: Fred Griffoul <fgriffo@amazon.co.uk>
>
> Cache enlightened VMCS control fields to prevent TOCTOU races where the
> guest could modify hv_clean_fields or hv_enlightenments_control between
> multiple accesses during nested VM-entry.
>
> The cached values ensure consistent behavior across:
> - The evmcs-to-vmcs12 copy operations
> - MSR bitmap validation
> - Clean field checks in prepare_vmcs02_rare()
>
> This eliminates potential guest-induced inconsistencies in nested
> virtualization state management.

Could you please split the commit to simplify the review and bughunting
if (when?) issues are discovered? In particular, I would've split this
into at least:

- hv_flush_hypercall caching/handling
- hv_msr_bitmap caching/handling
- nested_vmx_is_evmptr12_valid() instead of vmx->nested.hv_evmcs checks
- adding 'bool copy' argument to nested_vmx_handle_enlightened_vmptrld()
and moving copy_enlightened_to_vmcs12() there from nested_vmx_run()
- hv_clean_fields caching/handling.

I want to be extra careful with clean fields. I may had forgotten the
details since I've implemented it but I still remember some pain over
inconsistent state upon migrations, namely

commit d6bf71a18c74de61548ddad44ff95306fe85f829
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Wed May 26 15:20:22 2021 +0200

    KVM: nVMX: Ignore 'hv_clean_fields' data when eVMCS data is copied in vmx_get_nested_state()

Unfortunatelly, I don't think we have good test coverage for all this in
'hyperv_evmcs' selftest :-( I've seen you added evmcs support to
'vmx_l2_switch_test' in this series, thanks a lot for doing that!

>
> Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
> ---
>  arch/x86/kvm/vmx/hyperv.c |  5 ++--
>  arch/x86/kvm/vmx/hyperv.h | 20 +++++++++++++
>  arch/x86/kvm/vmx/nested.c | 62 ++++++++++++++++++++++++---------------
>  arch/x86/kvm/vmx/vmx.h    |  5 +++-
>  4 files changed, 65 insertions(+), 27 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
> index fa41d036acd4..961b91b9bd64 100644
> --- a/arch/x86/kvm/vmx/hyperv.c
> +++ b/arch/x86/kvm/vmx/hyperv.c
> @@ -213,12 +213,11 @@ bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
>  
> -	if (!hv_vcpu || !evmcs)
> +	if (!hv_vcpu || !nested_vmx_is_evmptr12_valid(vmx))
>  		return false;
>  
> -	if (!evmcs->hv_enlightenments_control.nested_flush_hypercall)
> +	if (!vmx->nested.hv_flush_hypercall)
>  		return false;
>  
>  	return hv_vcpu->vp_assist_page.nested_control.features.directhypercall;
> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
> index 11a339009781..3c7fea501ca5 100644
> --- a/arch/x86/kvm/vmx/hyperv.h
> +++ b/arch/x86/kvm/vmx/hyperv.h
> @@ -52,6 +52,16 @@ static inline bool guest_cpu_cap_has_evmcs(struct kvm_vcpu *vcpu)
>  	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;
>  }
>  
> +static inline u32 nested_evmcs_clean_fields(struct vcpu_vmx *vmx)
> +{
> +	return vmx->nested.hv_clean_fields;
> +}
> +
> +static inline bool nested_evmcs_msr_bitmap(struct vcpu_vmx *vmx)
> +{
> +	return vmx->nested.hv_msr_bitmap;
> +}
> +
>  u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
>  uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
>  int nested_enable_evmcs(struct kvm_vcpu *vcpu,
> @@ -85,6 +95,16 @@ static inline struct hv_enlightened_vmcs *nested_vmx_evmcs(struct vcpu_vmx *vmx)
>  {
>  	return NULL;
>  }
> +
> +static inline u32 nested_evmcs_clean_fields(struct vcpu_vmx *vmx)
> +{
> +	return 0;
> +}
> +
> +static inline bool nested_evmcs_msr_bitmap(struct vcpu_vmx *vmx)
> +{
> +	return false;
> +}
>  #endif
>  
>  #endif /* __KVM_X86_VMX_HYPERV_H */
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index cb4b85edcb7a..5790e1a26456 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -236,6 +236,9 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
>  	kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map);
>  	vmx->nested.hv_evmcs = NULL;
>  	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
> +	vmx->nested.hv_clean_fields = 0;
> +	vmx->nested.hv_msr_bitmap = false;
> +	vmx->nested.hv_flush_hypercall = false;
>  
>  	if (hv_vcpu) {
>  		hv_vcpu->nested.pa_page_gpa = INVALID_GPA;
> @@ -737,10 +740,10 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  	 *   and tells KVM (L0) there were no changes in MSR bitmap for L2.
>  	 */
>  	if (!vmx->nested.force_msr_bitmap_recalc) {
> -		struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
> -
> -		if (evmcs && evmcs->hv_enlightenments_control.msr_bitmap &&
> -		    evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP)
> +		if (nested_vmx_is_evmptr12_valid(vmx) &&
> +		    nested_evmcs_msr_bitmap(vmx) &&
> +		    (nested_evmcs_clean_fields(vmx)
> +		     & HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP))
>  			return true;
>  	}
>  
> @@ -2214,10 +2217,11 @@ static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
>   * instruction.
>   */
>  static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
> -	struct kvm_vcpu *vcpu, bool from_launch)
> +	struct kvm_vcpu *vcpu, bool from_launch, bool copy)
>  {
>  #ifdef CONFIG_KVM_HYPERV
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	struct hv_enlightened_vmcs *evmcs;
>  	bool evmcs_gpa_changed = false;
>  	u64 evmcs_gpa;
>  
> @@ -2297,6 +2301,22 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
>  		vmx->nested.force_msr_bitmap_recalc = true;
>  	}
>  
> +	/* Cache evmcs fields to avoid reading evmcs after copy to vmcs12 */
> +	evmcs = vmx->nested.hv_evmcs;
> +	vmx->nested.hv_clean_fields = evmcs->hv_clean_fields;
> +	vmx->nested.hv_flush_hypercall = evmcs->hv_enlightenments_control.nested_flush_hypercall;
> +	vmx->nested.hv_msr_bitmap = evmcs->hv_enlightenments_control.msr_bitmap;
> +
> +	if (copy) {
> +		struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> +
> +		if (likely(!vmcs12->hdr.shadow_vmcs)) {
> +			copy_enlightened_to_vmcs12(vmx, vmx->nested.hv_clean_fields);
> +			/* Enlightened VMCS doesn't have launch state */
> +			vmcs12->launch_state = !from_launch;
> +		}
> +	}
> +
>  	return EVMPTRLD_SUCCEEDED;
>  #else
>  	return EVMPTRLD_DISABLED;
> @@ -2655,10 +2675,12 @@ static void vmcs_write_cet_state(struct kvm_vcpu *vcpu, u64 s_cet,
>  
>  static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  {
> -	struct hv_enlightened_vmcs *hv_evmcs = nested_vmx_evmcs(vmx);
> +	u32 hv_clean_fields = 0;
>  
> -	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
> -			   HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2)) {
> +	if (nested_vmx_is_evmptr12_valid(vmx))
> +		hv_clean_fields = nested_evmcs_clean_fields(vmx);
> +
> +	if (!(hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2)) {
>  
>  		vmcs_write16(GUEST_ES_SELECTOR, vmcs12->guest_es_selector);
>  		vmcs_write16(GUEST_CS_SELECTOR, vmcs12->guest_cs_selector);
> @@ -2700,8 +2722,7 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  		vmx_segment_cache_clear(vmx);
>  	}
>  
> -	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
> -			   HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1)) {
> +	if (!(hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1)) {
>  		vmcs_write32(GUEST_SYSENTER_CS, vmcs12->guest_sysenter_cs);
>  		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
>  			    vmcs12->guest_pending_dbg_exceptions);
> @@ -2792,7 +2813,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  			  enum vm_entry_failure_code *entry_failure_code)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
> +	struct hv_enlightened_vmcs *evmcs;
>  	bool load_guest_pdptrs_vmcs12 = false;
>  
>  	if (vmx->nested.dirty_vmcs12 || nested_vmx_is_evmptr12_valid(vmx)) {
> @@ -2800,7 +2821,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  		vmx->nested.dirty_vmcs12 = false;
>  
>  		load_guest_pdptrs_vmcs12 = !nested_vmx_is_evmptr12_valid(vmx) ||
> -			!(evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
> +			!(nested_evmcs_clean_fields(vmx)
> +			  & HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
>  	}
>  
>  	if (vmx->nested.nested_run_pending &&
> @@ -2929,7 +2951,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	 * bits when it changes a field in eVMCS. Mark all fields as clean
>  	 * here.
>  	 */
> -	if (nested_vmx_is_evmptr12_valid(vmx))
> +	evmcs = nested_vmx_evmcs(vmx);
> +	if (evmcs)
>  		evmcs->hv_clean_fields |= HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
>  
>  	return 0;
> @@ -3477,7 +3500,7 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
>  	if (guest_cpu_cap_has_evmcs(vcpu) &&
>  	    vmx->nested.hv_evmcs_vmptr == EVMPTR_MAP_PENDING) {
>  		enum nested_evmptrld_status evmptrld_status =
> -			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
> +			nested_vmx_handle_enlightened_vmptrld(vcpu, false, false);
>  
>  		if (evmptrld_status == EVMPTRLD_VMFAIL ||
>  		    evmptrld_status == EVMPTRLD_ERROR)
> @@ -3867,7 +3890,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	if (!nested_vmx_check_permission(vcpu))
>  		return 1;
>  
> -	evmptrld_status = nested_vmx_handle_enlightened_vmptrld(vcpu, launch);
> +	evmptrld_status = nested_vmx_handle_enlightened_vmptrld(vcpu, launch, true);
>  	if (evmptrld_status == EVMPTRLD_ERROR) {
>  		kvm_queue_exception(vcpu, UD_VECTOR);
>  		return 1;
> @@ -3893,15 +3916,8 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	if (CC(vmcs12->hdr.shadow_vmcs))
>  		return nested_vmx_failInvalid(vcpu);
>  
> -	if (nested_vmx_is_evmptr12_valid(vmx)) {
> -		struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
> -
> -		copy_enlightened_to_vmcs12(vmx, evmcs->hv_clean_fields);
> -		/* Enlightened VMCS doesn't have launch state */
> -		vmcs12->launch_state = !launch;
> -	} else if (enable_shadow_vmcs) {
> +	if (!nested_vmx_is_evmptr12_valid(vmx) && enable_shadow_vmcs)
>  		copy_shadow_to_vmcs12(vmx);
> -	}
>  
>  	/*
>  	 * The nested entry process starts with enforcing various prerequisites
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 90fdf130fd85..cda96196c56c 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -205,8 +205,11 @@ struct nested_vmx {
>  
>  #ifdef CONFIG_KVM_HYPERV
>  	gpa_t hv_evmcs_vmptr;
> -	struct kvm_host_map hv_evmcs_map;
> +	u32 hv_clean_fields;
> +	bool hv_msr_bitmap;
> +	bool hv_flush_hypercall;
>  	struct hv_enlightened_vmcs *hv_evmcs;
> +	struct kvm_host_map hv_evmcs_map;
>  #endif
>  };

-- 
Vitaly


