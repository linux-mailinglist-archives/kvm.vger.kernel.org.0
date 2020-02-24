Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86BC316B39B
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 23:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgBXWNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 17:13:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46366 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726651AbgBXWNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 17:13:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582582425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iUc8WY+gnsCmYrkD/dUcGcDzuOer8ITJ6cRC9/JT5TY=;
        b=E5XmAmCDTp2oKnzh4N5ByQqmb2QfipZ011rnB9GqvmZMuUbF3o0KsNauwQYanXd37gals0
        DPTbZ3jrpL51pi3+rYaHEbadPWMBdLasq6+w1dczmtX1Sn/QZJnKI4pKXw5EW/erCbTXsd
        DaDfiKugGbp7VSe9WMTAvO2GUpar8wg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-z0BIk9h-MqGslRenJgZfcA-1; Mon, 24 Feb 2020 17:13:41 -0500
X-MC-Unique: z0BIk9h-MqGslRenJgZfcA-1
Received: by mail-wm1-f70.google.com with SMTP id b8so269622wmj.0
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 14:13:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=iUc8WY+gnsCmYrkD/dUcGcDzuOer8ITJ6cRC9/JT5TY=;
        b=aKDFYKiCFD42fqYKJT97TAs6o9p6/ToRWmuBCislmWIR8oop4PJE0/3Jk5WpUmN6BF
         38Ax/lpiDScuezgg7Q/EZeGRJb5pjz0eN9RdvS93Bk7F9QR+KfUQhlITAJqPLSfqLYIa
         x6I9RrKtMwzcQstG5pdIrUuOi2+lfXOYLcOnFm3Tiw1gZIL+7se0sVQvw4+HpRsJwFnD
         Jjt9yDggyitd0Iy2RS5mgzKlnjOpD6ro5WKdZoZbLh8fXAtxkfmTNWsdOoc2oPxXoKN/
         z53n2tjW2litw6nWLoUdCi88UVrlhoEhfTj4kEaGXQmSULYpHHgclx7bhS23rjiCwU4v
         Tgjw==
X-Gm-Message-State: APjAAAXY/9gvamKcrdHcPFuQA0hNgLJu4cWuPgNrrofY5yJhG3vk9qpX
        HeLA/tuxt4I5rWSxCRfUv1z8/ldqDVeypAlIDneHwBFj76XFUU5l0RuUNp7s+AgKwxS0BRb8a6g
        DaWGND/ccDdcr
X-Received: by 2002:a1c:b603:: with SMTP id g3mr1085711wmf.130.1582582419964;
        Mon, 24 Feb 2020 14:13:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqzLFFJ7TXLWA9KtHwshX/lvtpNzok+t05kHS2aITtdvR9bhgqTzFRHcp9FRPyq3p4zar53dlA==
X-Received: by 2002:a1c:b603:: with SMTP id g3mr1085689wmf.130.1582582419689;
        Mon, 24 Feb 2020 14:13:39 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g2sm19989962wrw.76.2020.02.24.14.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 14:13:39 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 44/61] KVM: x86: Use KVM cpu caps to track UMIP emulation
In-Reply-To: <20200201185218.24473-45-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-45-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 23:13:37 +0100
Message-ID: <87zhd7my5q.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Set UMIP in kvm_cpu_caps when it is emulated by VMX, even though the
> bit will be effectively be dropped 

Redundant 'be'

> by do_host_cpuid().  This allows checking for UMIP emulation via
> kvm_cpu_caps instead of a dedicated kvm_x86_ops callback.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 -
>  arch/x86/kvm/svm.c              | 6 ------
>  arch/x86/kvm/vmx/vmx.c          | 8 +++++++-
>  arch/x86/kvm/x86.c              | 2 +-
>  4 files changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index dd690fb5ceca..113b138a0347 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1163,7 +1163,6 @@ struct kvm_x86_ops {
>  	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
>  		enum exit_fastpath_completion *exit_fastpath);
>  
> -	bool (*umip_emulated)(void);
>  	bool (*pt_supported)(void);
>  
>  	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index defb2c0dbf8a..e1ed5726964c 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -6079,11 +6079,6 @@ static bool svm_rdtscp_supported(void)
>  	return boot_cpu_has(X86_FEATURE_RDTSCP);
>  }
>  
> -static bool svm_umip_emulated(void)
> -{
> -	return false;
> -}
> -
>  static bool svm_pt_supported(void)
>  {
>  	return false;
> @@ -7449,7 +7444,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  	.cpuid_update = svm_cpuid_update,
>  
>  	.rdtscp_supported = svm_rdtscp_supported,
> -	.umip_emulated = svm_umip_emulated,
>  	.pt_supported = svm_pt_supported,
>  
>  	.set_supported_cpuid = svm_set_supported_cpuid,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cecf59225136..cd5a624610c9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7103,6 +7103,10 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>  {
>  	switch (entry->function) {
>  	case 0x7:
> +		/*
> +		 * UMIP needs to be manually set even though vmx_set_cpu_caps()
> +		 * also sets UMIP since do_host_cpuid() will drop it.
> +		 */
>  		if (vmx_umip_emulated())
>  			cpuid_entry_set(entry, X86_FEATURE_UMIP);
>  		break;
> @@ -7129,6 +7133,9 @@ static __init void vmx_set_cpu_caps(void)
>  	if (enable_ept && boot_cpu_has(X86_FEATURE_OSPKE))
>  		kvm_cpu_cap_check_and_set(X86_FEATURE_PKU);
>  
> +	if (vmx_umip_emulated())
> +		kvm_cpu_cap_set(X86_FEATURE_UMIP);
> +
>  	/* CPUID 0xD.1 */
>  	if (!vmx_xsaves_supported())
>  		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
> @@ -7888,7 +7895,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  
>  	.check_intercept = vmx_check_intercept,
>  	.handle_exit_irqoff = vmx_handle_exit_irqoff,
> -	.umip_emulated = vmx_umip_emulated,
>  	.pt_supported = vmx_pt_supported,
>  
>  	.request_immediate_exit = vmx_request_immediate_exit,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cb40737187a1..a6d5f22c7ef6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -915,7 +915,7 @@ static u64 kvm_host_cr4_reserved_bits(struct cpuinfo_x86 *c)
>  	if (kvm_cpu_cap_has(X86_FEATURE_LA57))
>  		reserved_bits &= ~X86_CR4_LA57;
>  
> -	if (kvm_x86_ops->umip_emulated())
> +	if (kvm_cpu_cap_has(X86_FEATURE_UMIP))
>  		reserved_bits &= ~X86_CR4_UMIP;
>  
>  	return reserved_bits;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

