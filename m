Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B43031899FC
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 11:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgCRKwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 06:52:54 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:49168 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726713AbgCRKwx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 06:52:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584528772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8zRWEh6dCTPH78DCDAt8FvaodGeFVLM/kUqJmF9kDWc=;
        b=T0IBSB7QWVWgAwi8LDT4iJ7jzx/rS044ufVKcQRVTwr5Dz85+GkgIrxHIZYX7I+5gjxIav
        r/eD1aB2rQorjHtgiQLDkf8mKqN1Sd/u1OFGqdcwGyVFKqFrBip9cJT7uiRME7L8N+c6p4
        O0lXY0UV9sjjZ9gwdBlMw/e4mKnXwyk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-o2_Htk09O6atp-hE2C2yvQ-1; Wed, 18 Mar 2020 06:52:50 -0400
X-MC-Unique: o2_Htk09O6atp-hE2C2yvQ-1
Received: by mail-wm1-f69.google.com with SMTP id z16so844996wmi.2
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 03:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8zRWEh6dCTPH78DCDAt8FvaodGeFVLM/kUqJmF9kDWc=;
        b=JgycReGyrViEE1w2LPgK/JEnF+IM1Gh1mT+Hn4SsBSCEMY9XON/eKrXFB/bnkkQra/
         cRnFg8/9QWsWRLMGt3BoUrhtb0TNKUmlZjfFK2bhnvQ4jZza+TlmokIhqiUYXHfm8vFI
         eqYGEUtqVSvxrKhuRG8dr5EmmXVuC/fGZRxcWuq9TfOQvTxBd/HDoNc+0dNGUwWviEqR
         detIc7Kvq2ajFpuC5prNP9M+foDaY6eoBy3/deTa8bJ8VS793m9eYgs+UNR11siG7uIv
         H2ymTTZ7T2RiK6amaK3dR4d6RTymuliuasaW4D8CDXrCSHDNrCTmEf8k1+iOGlgd5Xrp
         uDcg==
X-Gm-Message-State: ANhLgQ2yanvhN3Ol00wmh1Atmagcw8i4VLF2WuJRtCk+3SkIJ4+ymExR
        VarRsea3U/wGyFsAJMk56gAKZ6pt6Tzya+zvYiQhD/k2PjMoN8wnoYEYSsSTwB10Vd4u+ynDObF
        8oXqNBfwF15UA
X-Received: by 2002:a05:600c:d8:: with SMTP id u24mr4712835wmm.42.1584528769385;
        Wed, 18 Mar 2020 03:52:49 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuNeCy/40nU+HN9VgYqkuRRWRRJdGk90A3w/dvrXr7Kw8tqqcm+rdoBXcJQrNyxGOpyONsZ/w==
X-Received: by 2002:a05:600c:d8:: with SMTP id u24mr4712818wmm.42.1584528769102;
        Wed, 18 Mar 2020 03:52:49 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s127sm3412884wmf.28.2020.03.18.03.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 03:52:48 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: remove side effects from nested_vmx_exit_reflected
In-Reply-To: <1584468059-3585-1-git-send-email-pbonzini@redhat.com>
References: <1584468059-3585-1-git-send-email-pbonzini@redhat.com>
Date:   Wed, 18 Mar 2020 11:52:47 +0100
Message-ID: <87tv2m2av4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> The name of nested_vmx_exit_reflected suggests that it's purely
> a test, but it actually marks VMCS12 pages as dirty.  Move this to
> vmx_handle_exit, observing that the initial nested_run_pending check in
> nested_vmx_exit_reflected is pointless---nested_run_pending has just
> been cleared in vmx_vcpu_run and won't be set until handle_vmlaunch
> or handle_vmresume.
>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 18 ++----------------
>  arch/x86/kvm/vmx/nested.h |  1 +
>  arch/x86/kvm/vmx/vmx.c    | 19 +++++++++++++++++--
>  3 files changed, 20 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 8578513907d7..4ff859c99946 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3527,7 +3527,7 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
>  }
>  
>  
> -static void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
> +void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
>  {
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>  	gfn_t gfn;
> @@ -5543,8 +5543,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>  
> -	if (vmx->nested.nested_run_pending)
> -		return false;
> +	WARN_ON_ONCE(vmx->nested.nested_run_pending);
>  
>  	if (unlikely(vmx->fail)) {
>  		trace_kvm_nested_vmenter_failed(
> @@ -5553,19 +5552,6 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
>  		return true;
>  	}
>  
> -	/*
> -	 * The host physical addresses of some pages of guest memory
> -	 * are loaded into the vmcs02 (e.g. vmcs12's Virtual APIC
> -	 * Page). The CPU may write to these pages via their host
> -	 * physical address while L2 is running, bypassing any
> -	 * address-translation-based dirty tracking (e.g. EPT write
> -	 * protection).
> -	 *
> -	 * Mark them dirty on every exit from L2 to prevent them from
> -	 * getting out of sync with dirty tracking.
> -	 */
> -	nested_mark_vmcs12_pages_dirty(vcpu);
> -
>  	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason,
>  				vmcs_readl(EXIT_QUALIFICATION),
>  				vmx->idt_vectoring_info,
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index 21d36652f213..f70968b76d33 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -33,6 +33,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>  int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>  			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
>  void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
> +void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
>  bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
>  				 int size);
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b447d66f44e6..07299a957d4a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5851,8 +5851,23 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
>  	if (vmx->emulation_required)
>  		return handle_invalid_guest_state(vcpu);
>  
> -	if (is_guest_mode(vcpu) && nested_vmx_exit_reflected(vcpu, exit_reason))
> -		return nested_vmx_reflect_vmexit(vcpu, exit_reason);
> +	if (is_guest_mode(vcpu)) {
> +		/*
> +		 * The host physical addresses of some pages of guest memory
> +		 * are loaded into the vmcs02 (e.g. vmcs12's Virtual APIC
> +		 * Page). The CPU may write to these pages via their host
> +		 * physical address while L2 is running, bypassing any
> +		 * address-translation-based dirty tracking (e.g. EPT write
> +		 * protection).
> +		 *
> +		 * Mark them dirty on every exit from L2 to prevent them from
> +		 * getting out of sync with dirty tracking.
> +		 */
> +		nested_mark_vmcs12_pages_dirty(vcpu);
> +
> +		if (nested_vmx_exit_reflected(vcpu, exit_reason))
> +			return nested_vmx_reflect_vmexit(vcpu, exit_reason);
> +	}
>  
>  	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
>  		dump_vmcs();

The only functional difference seems to be that we're now doing
nested_mark_vmcs12_pages_dirty() in vmx->fail case too and this seems
superfluous: we failed to enter L2 so 'special' pages should remain
intact (right?) but this should be an uncommon case.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

