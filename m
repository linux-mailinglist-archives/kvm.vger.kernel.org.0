Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155472B032B
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 11:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgKLKwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 05:52:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726776AbgKLKwo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 05:52:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605178363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KWLkvdYu5qBPyXknUznFKfkiFcfGzsGeIMaYr3uaes8=;
        b=BP/Yi1UUv5Evb/8B8RDgt4h7doGd35+Et7kJMXl9uZmF7+Zvj/uaywTIeAVnVmxeZwsD+2
        TOli5wDqfg/wBBsydXPMTvjiNn5Ozo2g8nA/fxEe3U+zI1UFN+yr6obrwM842z+hDWh/hJ
        E7J1qtbmC2FVkUblHeO8Zdvk616F7IY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-qPxL844SO-aSmQGLiPMCIw-1; Thu, 12 Nov 2020 05:52:41 -0500
X-MC-Unique: qPxL844SO-aSmQGLiPMCIw-1
Received: by mail-wm1-f72.google.com with SMTP id 8so1601929wmg.6
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 02:52:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KWLkvdYu5qBPyXknUznFKfkiFcfGzsGeIMaYr3uaes8=;
        b=Xck5Mz9vesyhgrk96gwP6jZMU78Njq+EbmTTcjzW2PZBxkoJkNNEo0qz5GYEI4JYon
         zI4Xki1zzhfQMMX7MKggMm87X0XM36DbCejAR5n6TU0JJ3/VaRanHfoTAQiLZWECstwF
         1CjXVw1Xd/AJ1flT2O7lVdaMNjJTJNz7KeTSavjCZbMc2YHEcvACRMTG39+kGOqhzvhm
         0BK88xpHhQLqO6DoPtsBPFKhMoE36mdcfma9P9JNh25Q/NEkTdqaovDtS0Mql5VpFjYW
         SQFRs07c+0lcBY8PAh8wpsr1DjowcURCm8vFJz+wFfIKNcP7+iDg+rgoeljMyKmN4bs2
         RGnw==
X-Gm-Message-State: AOAM531QbO02YIiuPs/jcrQUzfj6IKqE58Oi12tpDI3cf47zQMC8xUNz
        YdW3KJUvIdMSgjq09EgqKqLr9lZpZrw3VGl0zz3nMFWHVnPUnMf2k+Ej1BOqtsLpteNYkbnev9u
        1xGD7vCc0FhEa
X-Received: by 2002:a5d:4349:: with SMTP id u9mr34344550wrr.319.1605178360316;
        Thu, 12 Nov 2020 02:52:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFgS97tYQwTnuGzSyRyMkZ0TyJUtfa1aypyxDzT65eiZXRkYMnTO/oNXj1+XuclbpZpU22Gg==
X-Received: by 2002:a5d:4349:: with SMTP id u9mr34344537wrr.319.1605178360165;
        Thu, 12 Nov 2020 02:52:40 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o10sm6281915wma.47.2020.11.12.02.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 02:52:39 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/11] KVM: VMX: Define Hyper-V paravirt TLB flush
 fields iff Hyper-V is enabled
In-Reply-To: <20201027212346.23409-10-sean.j.christopherson@intel.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
 <20201027212346.23409-10-sean.j.christopherson@intel.com>
Date:   Thu, 12 Nov 2020 11:52:38 +0100
Message-ID: <87361ezw21.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Ifdef away the Hyper-V specific fields in structs kvm_vmx and vcpu_vmx
> as each field has only a single reference outside of the struct itself
> that isn't already wrapped in ifdeffery (and both are initialization).
>
> vcpu_vmx.ept_pointer in particular should be wrapped as it is valid if
> and only if Hyper-v is active, i.e. non-Hyper-V code cannot rely on it
> to actually track the current EPTP (without additional code changes).
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 5 ++++-
>  arch/x86/kvm/vmx/vmx.h | 4 ++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b684f45d6a78..5b7c5b2fd2c7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6955,8 +6955,9 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
>  	vmx->pi_desc.sn = 1;
>  
> +#if IS_ENABLED(CONFIG_HYPERV)
>  	vmx->ept_pointer = INVALID_PAGE;
> -
> +#endif
>  	return 0;
>  
>  free_vmcs:
> @@ -6973,7 +6974,9 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  
>  static int vmx_vm_init(struct kvm *kvm)
>  {
> +#if IS_ENABLED(CONFIG_HYPERV)
>  	spin_lock_init(&to_kvm_vmx(kvm)->ept_pointer_lock);
> +#endif
>  
>  	if (!ple_gap)
>  		kvm->arch.pause_in_guest = true;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index cecc2a641e19..2bd86d8b2f4b 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -276,7 +276,9 @@ struct vcpu_vmx {
>  	 */
>  	u64 msr_ia32_feature_control;
>  	u64 msr_ia32_feature_control_valid_bits;
> +#if IS_ENABLED(CONFIG_HYPERV)
>  	u64 ept_pointer;
> +#endif
>  
>  	struct pt_desc pt_desc;
>  
> @@ -295,8 +297,10 @@ struct kvm_vmx {
>  	bool ept_identity_pagetable_done;
>  	gpa_t ept_identity_map_addr;
>  
> +#if IS_ENABLED(CONFIG_HYPERV)
>  	hpa_t hv_tlb_eptp;
>  	spinlock_t ept_pointer_lock;
> +#endif
>  };
>  
>  bool nested_vmx_allowed(struct kvm_vcpu *vcpu);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

