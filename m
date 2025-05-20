Return-Path: <kvm+bounces-47098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC317ABD3FD
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 11:57:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 754BC17DD58
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 09:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECDAE26A0AB;
	Tue, 20 May 2025 09:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WtGLu+62"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4A11DA61B
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 09:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747735029; cv=none; b=Z8a6hiJbEUKV/p0ruzzABrPrlzwUYRHbKcYRpTuE0B3TIDQiM+9vE7FCjynmOyAq5A9fxdeRgkq8eeBqyVIfOD+6OEeeRf9csQHeaqMrPofKEPeARZf+A+aUZb+gAkY7WX93ZzEi6OfofZuYAW9jwa4GQwoKNvDidFzI0V1WVsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747735029; c=relaxed/simple;
	bh=GarkuXCkr5IXxh7NckX9YQfEQNudMTCDgtz11JyIWrk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=grkcinWvHhReHxroF10uzqDiYpzayv5aHNek1TmfGG/D5PxUDj8uSfYMR+r3q20rJ3jtvZ8wfploH3eGeJbi+ygkF2DQTIsbgAhCDYkel0djADaQmg+3Uc/G7+B9oPuIrhCHDz7MKAN0Asg4j2yUzHvDMX+nWXd4BwumPCoOlAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WtGLu+62; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747735026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QaNix5hwG/O2KInAPWrv41TuCAhnMcb8Uiy5ln7GJXQ=;
	b=WtGLu+62CM4SN7CF7D/Za8eN6WRxDb6vrQdhhfZhwX14DzwFi4ID4qYybjS9bQ1PHmqoE0
	hAKk7NkxqFm72jIRO6UcIlaL3kbH8hWHpt9+5Ejmn+OCHjUSdrZB9aNVidLb+oZYK2S6Ja
	PPe5+0IAfO+hxT3sic6gGAehpeXdjHs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-LwovygVwOAe8GMS6H4-l7A-1; Tue, 20 May 2025 05:57:03 -0400
X-MC-Unique: LwovygVwOAe8GMS6H4-l7A-1
X-Mimecast-MFC-AGG-ID: LwovygVwOAe8GMS6H4-l7A_1747735022
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a3561206b3so1623297f8f.2
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 02:57:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747735022; x=1748339822;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QaNix5hwG/O2KInAPWrv41TuCAhnMcb8Uiy5ln7GJXQ=;
        b=LRtKb2n9SGbzlHaOd1RoYezsPGwTKFBYjE8cvPOzm0ogRxMTCUezKN0CqIaE2XN1J5
         W1/MlcFAtvWC6DicaFLjS+2dx0HoJfLVpDnoGx5wjN5GrUXSRQ3trp3J4dzeMllb3yZj
         Eb2iEKE9gv+L5+scCXO1d5tJNXXiWhSQPm4CNfhJSrBUQn4Ulz0T31vYceeFBEqI7qjJ
         Tx32kScyyw+AKIIPbQkK5CdXBOkg96huCH6zORm4FjWL9Y39ne7airocpB4J7gm8AOS+
         pQCgBr9piz6ZnBXI2uHukDhERSAU14XO2YdO2zJvlV0vpvMky0WrQk7GvjI+sC9ARzMB
         tFbg==
X-Gm-Message-State: AOJu0YzukmVfTaNWSGRK1AAml4Ki4Xt5l0H3r8M6n9YUYx7BtAtMOhiB
	23b2v1Clkst6lHfdVKwYMEixRZWcqwEKtlTohctilZN2LXkR+0M54G5lHxCldiWKmDSW5g49DnS
	TnSh0ApHGmuKU0PePzXL6aOHN6G5nc2a4Nura2pCLc3lzPquYON7mNQ==
X-Gm-Gg: ASbGnctwZOEKu4OCqm5kYyZmy+zl9l8sX7/leAQ1o7KHcdAA+LsnzerQ6TSHZhg1EDA
	2UtjetiMGV8MMEut0KGzDWYDfmNwpOHxhcz87KzWQHgaauJUP91GAkhQa3YnLqNb5TgMZDBfXOt
	8+Xm7giTZ12xPaezQtZuHf64dZ7T/xWuRp4QPMQhrYsq3lcEt/jCZ/VDfNafyi2Ib5h7syMqlRz
	3JvEP5nf0Fc5AXSHdI/rKHzvwJBRm2viGyIr3ninIn8nBInwiMeing7SkYG9rXTMPDkwBd7/BcW
	wJP3l4Q=
X-Received: by 2002:a05:6000:3103:b0:3a3:6415:96c8 with SMTP id ffacd0b85a97d-3a364159712mr10826925f8f.41.1747735021857;
        Tue, 20 May 2025 02:57:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdStSqCIzuerJKIl5wmWHsWUCUxWeb0WiHCpo/dsDDXM6ixiV/uDzmbbJVpFK8aJrjTl1MAg==
X-Received: by 2002:a05:6000:3103:b0:3a3:6415:96c8 with SMTP id ffacd0b85a97d-3a364159712mr10826905f8f.41.1747735021519;
        Tue, 20 May 2025 02:57:01 -0700 (PDT)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f18251adsm25481865e9.2.2025.05.20.02.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 02:57:01 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>
Subject: Re: [PATCH 04/15] KVM: x86: Drop superfluous kvm_hv_set_sint() =>
 kvm_hv_synic_set_irq() wrapper
In-Reply-To: <20250519232808.2745331-5-seanjc@google.com>
References: <20250519232808.2745331-1-seanjc@google.com>
 <20250519232808.2745331-5-seanjc@google.com>
Date: Tue, 20 May 2025 11:57:00 +0200
Message-ID: <87iklvob9v.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> Drop the superfluous kvm_hv_set_sint() and instead wire up ->set() directly
> to its final destination.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Nitpick: synic_set_irq() still has trace_kvm_hv_synic_set_irq() but
kvm_hv_synic_set_irq() is now gone, I think it may make sense to rename
it to e.g. 'trace_kvm_hv_set_sint' or 'trace_synic_set_irq' to avoid any
confusion.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

> ---
>  arch/x86/kvm/hyperv.c   | 10 +++++++---
>  arch/x86/kvm/hyperv.h   |  3 ++-
>  arch/x86/kvm/irq_comm.c | 12 ------------
>  3 files changed, 9 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 24f0318c50d7..7f565636edde 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -497,15 +497,19 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
>  	return ret;
>  }
>  
> -int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vpidx, u32 sint)
> +int kvm_hv_set_sint(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
> +		    int irq_source_id, int level, bool line_status)
>  {
>  	struct kvm_vcpu_hv_synic *synic;
>  
> -	synic = synic_get(kvm, vpidx);
> +	if (!level)
> +		return -1;
> +
> +	synic = synic_get(kvm, e->hv_sint.vcpu);
>  	if (!synic)
>  		return -EINVAL;
>  
> -	return synic_set_irq(synic, sint);
> +	return synic_set_irq(synic, e->hv_sint.sint);
>  }
>  
>  void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector)
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 913bfc96959c..4ad5a0749739 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -103,7 +103,8 @@ static inline bool kvm_hv_hypercall_enabled(struct kvm_vcpu *vcpu)
>  int kvm_hv_hypercall(struct kvm_vcpu *vcpu);
>  
>  void kvm_hv_irq_routing_update(struct kvm *kvm);
> -int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vcpu_id, u32 sint);
> +int kvm_hv_set_sint(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
> +		    int irq_source_id, int level, bool line_status);
>  void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector);
>  int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
>  
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 8dcb6a555902..b85e4be2ddff 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -127,18 +127,6 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>  	return kvm_irq_delivery_to_apic(kvm, NULL, &irq, NULL);
>  }
>  
> -#ifdef CONFIG_KVM_HYPERV
> -static int kvm_hv_set_sint(struct kvm_kernel_irq_routing_entry *e,
> -		    struct kvm *kvm, int irq_source_id, int level,
> -		    bool line_status)
> -{
> -	if (!level)
> -		return -1;
> -
> -	return kvm_hv_synic_set_irq(kvm, e->hv_sint.vcpu, e->hv_sint.sint);
> -}
> -#endif
> -
>  int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>  			      struct kvm *kvm, int irq_source_id, int level,
>  			      bool line_status)

-- 
Vitaly


