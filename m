Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7186218472A
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 13:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgCMMrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 08:47:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50765 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726216AbgCMMrG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 08:47:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584103625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cVGvYp8s4tIYmQbZbCv3pyCVPMIadQ3rGV3wCFwPiPQ=;
        b=P0wQf7g95cE1OYv4e0N0SL9yEmMHyf9bB0s8rMxvri45V8Q7+h3O5AMtKNBx43F1A6XaO5
        az2PpdTasrhJiPjI9ec6XvCaO+SQy8F+DJk4Um3SAam1v8CScTlsontBFOSJcOQM6iKp8Z
        EGcbWHxSEGmH/hEegYC5cYTtkBzvOys=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-8ZVEkCPUMAyxS-QthqqELg-1; Fri, 13 Mar 2020 08:47:04 -0400
X-MC-Unique: 8ZVEkCPUMAyxS-QthqqELg-1
Received: by mail-wr1-f72.google.com with SMTP id i7so4241606wru.3
        for <kvm@vger.kernel.org>; Fri, 13 Mar 2020 05:47:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=cVGvYp8s4tIYmQbZbCv3pyCVPMIadQ3rGV3wCFwPiPQ=;
        b=JUqt9UycxN2bkJBXFLwTHnYcDXsuOHqQNQDPIQYRPU78f4gemAg1bkPqwWIYbT++NX
         Wc1+KKzH1/lyud7z61rP3CNXlL40Sz/J3RF9ZvA2SpkaRZ3QnSlBGO7a7Yi+dzI1nnTe
         ZY3Fu0vmdJorV/LjX07ovTVveYZT0Ivsuftpreztgj+O9pRKDM5C6XrskyPMHuv/cJHY
         OZXi0Ol/Wptv4Yhoi/ESaTEGbYeNtqv0IDGPkP6c6cNl6NxP8yA+4F3fzqy//fp2/lZ2
         uFa2y/snVgOd83Nmy4EFo0RpgyXNpFrmKURq91fmxeuE5sTqF2gvp8dqvVE7l548dohg
         i+ng==
X-Gm-Message-State: ANhLgQ0+JPVzzmCW5Me+x7O7htB8zxD9dYukyf8y1urUsShMwCb0pud5
        tm0H9tLQb7N3JqJjmtBaH1/NqMzps+bUnBVn0/0A1CAO/8C50rZ7+1pxggydmDGvEJAOleWtT6v
        JDodIwGoYW/b9
X-Received: by 2002:a1c:f21a:: with SMTP id s26mr10738922wmc.39.1584103623171;
        Fri, 13 Mar 2020 05:47:03 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuB2U9pYEH4d9F0BJmVdxxrIWk5xI3GpDU0d8J7LIDQTOvO+P2YVyz1UPOYDpy7EcUGXaBvAQ==
X-Received: by 2002:a1c:f21a:: with SMTP id s26mr10738899wmc.39.1584103622905;
        Fri, 13 Mar 2020 05:47:02 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id l18sm9773424wrr.17.2020.03.13.05.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 05:47:01 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 04/10] KVM: VMX: Convert local exit_reason to u16 in nested_vmx_exit_reflected()
In-Reply-To: <20200312184521.24579-5-sean.j.christopherson@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com> <20200312184521.24579-5-sean.j.christopherson@intel.com>
Date:   Fri, 13 Mar 2020 13:47:01 +0100
Message-ID: <87a74kpgl6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Store only the basic exit reason in the local "exit_reason" variable in
> nested_vmx_exit_reflected().  Except for tracing, all references to
> exit_reason are expecting to encounter only the basic exit reason.
>
> Opportunistically align the params to nested_vmx_exit_handled_msr().
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index cb05bcbbfc4e..1848ca0116c0 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5374,7 +5374,7 @@ static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
>   * MSR bitmap. This may be the case even when L0 doesn't use MSR bitmaps.
>   */
>  static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
> -	struct vmcs12 *vmcs12, u32 exit_reason)
> +					struct vmcs12 *vmcs12, u16 exit_reason)
>  {
>  	u32 msr_index = kvm_rcx_read(vcpu);
>  	gpa_t bitmap;
> @@ -5523,7 +5523,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu)
>  	u32 intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> -	u32 exit_reason = vmx->exit_reason;
> +	u16 exit_reason;
>  
>  	if (vmx->nested.nested_run_pending)
>  		return false;
> @@ -5548,13 +5548,15 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu)
>  	 */
>  	nested_mark_vmcs12_pages_dirty(vcpu);
>  
> -	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason,
> +	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), vmx->exit_reason,
>  				vmcs_readl(EXIT_QUALIFICATION),
>  				vmx->idt_vectoring_info,
>  				intr_info,
>  				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
>  				KVM_ISA_VMX);
>  
> +	exit_reason = vmx->exit_reason;
> +
>  	switch (exit_reason) {
>  	case EXIT_REASON_EXCEPTION_NMI:
>  		if (is_nmi(intr_info))

If the patch is looked at by itself (and not as part of the series) one
may ask to add a comment explaining that we do the trunctation
deliberately but with all patches of the series it is superfluous.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

