Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50ECC16B2FD
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 22:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgBXVn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 16:43:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56202 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727421AbgBXVn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 16:43:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582580605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2ZTIZjXSpWgQEjNf7zkISWcKkdhFuO/dpS7p5N+PWmY=;
        b=AZZQBgPssL0UVRSABmgpnuAINdUPi9XKPkgmDypzIg/PEKhIkt1qgHBs2C+E5V6T93z2fR
        szNxX5h0LmKtdy9DQauc5PKnk0jTx7uuz3CHWEkuf88oWTl0ha3mwZvdrMyCVLXDbl0hk1
        OCdmu1AsTEh9T2qCr3UwJ0BTYvYMpXQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-VmPEkwT1PLqflq48V85tSg-1; Mon, 24 Feb 2020 16:43:24 -0500
X-MC-Unique: VmPEkwT1PLqflq48V85tSg-1
Received: by mail-wm1-f70.google.com with SMTP id y125so256560wmg.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 13:43:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2ZTIZjXSpWgQEjNf7zkISWcKkdhFuO/dpS7p5N+PWmY=;
        b=ZnL+Tj7/rcI0ZTmsqltAnx8b85ar96IQBRzfiHd+bkZq8Np3FW7eztPB2wmL73FXCz
         WT2UJDOeSdy5YX/hC+elFJYhMszMm993RG9R3QWrvukwsQyG/xnb0TjNzvrGJwvEzGWP
         /zdznvMlAWfzKRsNcb/o7VONfwBGC3JZVGFGi884PML6/+uciUqMlmsHkZx3tdwVyuh8
         Igh9HmXUdam4Z7zTN90RONpqR8H7W70zEkaAsNgPVq8zr4cJogB7GDXzZbz+BVAmQ9rC
         DJeazTvcUw+YIQtbUbR4RvzcopRjPb1V9/BWZ/ImHwawNV8OjvCUiFKcnEtU5dFwQeOS
         tLIg==
X-Gm-Message-State: APjAAAV3jypmfIdfkMxmmkfS/vp6VCnOs6e+CKk5l315JetPbDgKZrwj
        7EhBXC4Q46FE8u7GjijEjuFxmJpxkENEumYYeXsuR+fL7pimuBv5e6/746GG3r3KKipD6uYYFLN
        qYRr7b1luQ4Qs
X-Received: by 2002:adf:ee4c:: with SMTP id w12mr141253wro.310.1582580603021;
        Mon, 24 Feb 2020 13:43:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqxfUQpyKHaWhH8NpLQgO8sQ2P6mnJ1qvsJ2nyTxYMe6mzd0IBSOhbjFl56D51dU32ArURO5eg==
X-Received: by 2002:adf:ee4c:: with SMTP id w12mr141245wro.310.1582580602825;
        Mon, 24 Feb 2020 13:43:22 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t131sm1077916wmb.13.2020.02.24.13.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:43:22 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 41/61] KVM: x86: Move XSAVES CPUID adjust to VMX's KVM cpu cap update
In-Reply-To: <20200201185218.24473-42-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-42-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 22:43:20 +0100
Message-ID: <878skroe4n.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move the clearing of the XSAVES CPUID bit into VMX, which has a separate
> VMCS control to enable XSAVES in non-root, to eliminate the last ugly
> renmant of the undesirable "unsigned f_* = *_supported ? F(*) : 0"
> pattern in the common CPUID handling code.
>
> Drop ->xsaves_supported(), CPUID adjustment was the only user.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 -
>  arch/x86/kvm/cpuid.c            | 4 ----
>  arch/x86/kvm/svm.c              | 6 ------
>  arch/x86/kvm/vmx/vmx.c          | 5 ++++-
>  4 files changed, 4 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ba828569cda5..dd690fb5ceca 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1163,7 +1163,6 @@ struct kvm_x86_ops {
>  	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
>  		enum exit_fastpath_completion *exit_fastpath);
>  
> -	bool (*xsaves_supported)(void);
>  	bool (*umip_emulated)(void);
>  	bool (*pt_supported)(void);
>  
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index c2a4c9df49a9..77a6c1db138d 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -626,10 +626,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  			goto out;
>  
>  		cpuid_entry_mask(entry, CPUID_D_1_EAX);
> -
> -		if (!kvm_x86_ops->xsaves_supported())
> -			cpuid_entry_clear(entry, X86_FEATURE_XSAVES);
> -
>  		if (entry->eax & (F(XSAVES)|F(XSAVEC)))
>  			entry->ebx = xstate_required_size(supported_xcr0, true);
>  		else
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index f98a192459f7..7cb05945162e 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -6080,11 +6080,6 @@ static bool svm_rdtscp_supported(void)
>  	return boot_cpu_has(X86_FEATURE_RDTSCP);
>  }
>  
> -static bool svm_xsaves_supported(void)
> -{
> -	return boot_cpu_has(X86_FEATURE_XSAVES);
> -}
> -
>  static bool svm_umip_emulated(void)
>  {
>  	return false;
> @@ -7455,7 +7450,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  	.cpuid_update = svm_cpuid_update,
>  
>  	.rdtscp_supported = svm_rdtscp_supported,
> -	.xsaves_supported = svm_xsaves_supported,
>  	.umip_emulated = svm_umip_emulated,
>  	.pt_supported = svm_pt_supported,
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bae915431c72..cfd0ef314176 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7131,6 +7131,10 @@ static __init void vmx_set_cpu_caps(void)
>  	    boot_cpu_has(X86_FEATURE_OSPKE))
>  		kvm_cpu_cap_set(X86_FEATURE_PKU);
>  
> +	/* CPUID 0xD.1 */
> +	if (!vmx_xsaves_supported())
> +		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
> +
>  	/* CPUID 0x80000001 */
>  	if (!cpu_has_vmx_rdtscp())
>  		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
> @@ -7886,7 +7890,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  
>  	.check_intercept = vmx_check_intercept,
>  	.handle_exit_irqoff = vmx_handle_exit_irqoff,
> -	.xsaves_supported = vmx_xsaves_supported,
>  	.umip_emulated = vmx_umip_emulated,
>  	.pt_supported = vmx_pt_supported,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

