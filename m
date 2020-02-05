Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC49153320
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbgBEOef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:34:35 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31871 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726208AbgBEOef (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 09:34:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580913273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4x0zaVZqPalHfutXUGZSJjZwFi0uFd+sMxuDFEuloP8=;
        b=CP6e4WSB+on4xNyIk6cWwkb7uAFsdrfu4iP3cobUgv8WHLb2pjlfnO7hnCL4KsySANfn2C
        nOXgDYAKuk48jTqc1ivRsYAuiPqsiwN6v1GFJst1d8fMmkXT72YZr/rbtdtfWawl3845zl
        Bfu6t8uZ4gUBZridRRt3PWrGo+0/4Tg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-nC-HtDd5M-GvIHHhbZIF0g-1; Wed, 05 Feb 2020 09:34:32 -0500
X-MC-Unique: nC-HtDd5M-GvIHHhbZIF0g-1
Received: by mail-wr1-f70.google.com with SMTP id w6so1265481wrm.16
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 06:34:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=4x0zaVZqPalHfutXUGZSJjZwFi0uFd+sMxuDFEuloP8=;
        b=ckZIJz9jOvLu6X/WYnpljLF+O5z5yQWbyeaRuKB25huKFkbBxOXQ9JpA7vLQsFGA1M
         w4F+yZUikfyJNEl2XhWeJ5Ci/r8VCti0W4gkwVKzV6ZaD7A3WsCQsr4XyKkpodis5bZB
         I5mDjTMEpCMecbRDOXJpi1zaPsa/tqtbKbAbXC44f7gvC73jQJe3cSUDm5ARjISX3sns
         LeRA4Xt4rPFLqFWrKRExPVLoFb6/dKJJ2iBPzqO3WlcG+gayVrz6UjMePxfLlKoIgwAr
         u0Rp/LwzVhJkrVYHSdQwazF+1RmrYlt46iHNzUqU4jbKBp15gD1WIpAN4Q+2gcVcg7r1
         2bpA==
X-Gm-Message-State: APjAAAW5BQxtLbFgS2+k3bsSp623I948P+iLNP2e/y7Cz6q8BFJDKTHb
        2ZjFHA7sMRsKD3oNAXcRZQ1rIDIABQJC+mVoHAHznHf+nhVODLAVASdokEz6GkugUub8DHG3oTi
        C3mCz22Nc8R5W
X-Received: by 2002:a1c:1f51:: with SMTP id f78mr6024692wmf.60.1580913271054;
        Wed, 05 Feb 2020 06:34:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqwnqgbr3vr2dJbjqKzRwcMQz7mTDyE+gvwSB8VMka8mhy7hsXtCQZ6gBnjep2BPLAschDKzgQ==
X-Received: by 2002:a1c:1f51:: with SMTP id f78mr6024669wmf.60.1580913270829;
        Wed, 05 Feb 2020 06:34:30 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q14sm3149wrj.81.2020.02.05.06.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 06:34:30 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 04/26] KVM: x86: Add a kvm_x86_ops hook to query virtualized MSR support
In-Reply-To: <20200129234640.8147-5-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com> <20200129234640.8147-5-sean.j.christopherson@intel.com>
Date:   Wed, 05 Feb 2020 15:34:29 +0100
Message-ID: <87eev9ksqy.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Add a hook, ->has_virtualized_msr(), to allow moving vendor specific
> checks into SVM/VMX and ultimately facilitate the removal of the
> piecemeal ->*_supported() hooks.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm.c              | 6 ++++++
>  arch/x86/kvm/vmx/vmx.c          | 6 ++++++
>  arch/x86/kvm/x86.c              | 2 ++
>  4 files changed, 15 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5c2ad3fa0980..8fb32c27fa44 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1050,6 +1050,7 @@ struct kvm_x86_ops {
>  	int (*hardware_setup)(void);               /* __init */
>  	void (*hardware_unsetup)(void);            /* __exit */
>  	bool (*cpu_has_accelerated_tpr)(void);
> +	bool (*has_virtualized_msr)(u32 index);
>  	bool (*has_emulated_msr)(u32 index);
>  	void (*cpuid_update)(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index a7b944a3a0e2..1f9323fbad81 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5985,6 +5985,11 @@ static bool svm_cpu_has_accelerated_tpr(void)
>  	return false;
>  }
>  
> +static bool svm_has_virtualized_msr(u32 index)
> +{
> +	return true;
> +}
> +
>  static bool svm_has_emulated_msr(u32 index)
>  {
>  	switch (index) {
> @@ -7379,6 +7384,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  	.hardware_enable = svm_hardware_enable,
>  	.hardware_disable = svm_hardware_disable,
>  	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
> +	.has_virtualized_msr = svm_has_virtualized_msr,
>  	.has_emulated_msr = svm_has_emulated_msr,
>  
>  	.vcpu_create = svm_create_vcpu,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f5bb1ad2e9fa..3f2c094434e8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6274,6 +6274,11 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
>  		*exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
>  }
>  
> +static bool vmx_has_virtualized_msr(u32 index)
> +{
> +	return true;
> +}
> +
>  static bool vmx_has_emulated_msr(u32 index)
>  {
>  	switch (index) {
> @@ -7754,6 +7759,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  	.hardware_enable = hardware_enable,
>  	.hardware_disable = hardware_disable,
>  	.cpu_has_accelerated_tpr = report_flexpriority,
> +	.has_virtualized_msr = vmx_has_virtualized_msr,
>  	.has_emulated_msr = vmx_has_emulated_msr,
>  
>  	.vm_init = vmx_vm_init,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3d4a5326d84e..94f90fe1c0de 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5279,6 +5279,8 @@ static void kvm_init_msr_list(void)
>  				continue;
>  			break;
>  		default:
> +			if (!kvm_x86_ops->has_virtualized_msr(msr_index))
> +				continue;
>  			break;
>  		}

Shouldn't break anything by itself, so

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

