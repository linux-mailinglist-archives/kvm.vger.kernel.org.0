Return-Path: <kvm+bounces-49828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B135ADE637
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A347F188C81B
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 09:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA2827F163;
	Wed, 18 Jun 2025 09:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CzAplRgG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0401FA178
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 09:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750237382; cv=none; b=ifw3CpFGtY4XLdDFBpehsU6EDDacLmUldiyaUoTpovp4ovCDuNxA/hAs8bP5ZtLpl7ZkjjrrNDiYorCSAuR0WxoryHF+Ps1pyeJMP0M5CBeMgjfHzjjMbQS6ArciM6bwEMxQU8BI6j6KIckGXgo/bmD0HihdvkeaUH7VKNerlIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750237382; c=relaxed/simple;
	bh=bneFlm31Pd/Xfl3umVqeMKyb0kuHcqMPwyG8Y1qkajM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nsL9dcNA5GWX2oZ2kINXUtW46PEC8QBitsUdfuRMJ1NjtaYuNnZ8tvRuCXLbFwoAxCOtLFIcAp/U+Q6LGdALuEBbfTmc+252QipPtzhqWFbfFBuEef/BIPMPEj7E8ivT7kZqxJD408+z8Zsf07uksoHjFIc4oLsGWonP+psidtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CzAplRgG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750237379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rcn/LkxqL3L+wKUw0Rvs7ObcOPnZp08u4bi4thzRrzc=;
	b=CzAplRgG/G2Iry4XLkCAuCzf/6x5BNxIychPipyfvFohZAMTol3N/e1fgaOlif53nL48YQ
	q6ybQeLkEtos1Np2zKTx+T6yr9Uyt+by8/h9c95sayCuQJY+Tpw5RTQ7ixfxBwtxrh61jL
	5DYGdjtaI6vMismbziupWsoyMQoGauw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-Vf0oOprvNES9s3Cc5xT-SA-1; Wed, 18 Jun 2025 05:02:57 -0400
X-MC-Unique: Vf0oOprvNES9s3Cc5xT-SA-1
X-Mimecast-MFC-AGG-ID: Vf0oOprvNES9s3Cc5xT-SA_1750237377
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso40427625e9.0
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 02:02:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750237376; x=1750842176;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rcn/LkxqL3L+wKUw0Rvs7ObcOPnZp08u4bi4thzRrzc=;
        b=j3gMfXT+98HlAhILKZAeWqi5jZAyFF0gHHeKho5TGeSBGbKOCwagyEhAbPZ3cPwrLl
         ljdPM42JaMDAKWRMVzwbplZFImOKTRDRELRbSU6My+nidoAylVwMZBUiVbWeUOFoapkz
         yx3/dMn/2F0+aiOR/p2Jgrv19LveE9Any1ei64NqdPyMV+WCj995HzpFRkKJ+42nswI8
         A9vRxgF0fYgwoacONrMi3erzx3xMXgc/ApXKndqPJfpCLR6Z9cZ6OQYkp9MYWI0/o434
         uOcIeMBewK5lZNLeCwCuTfLQzwxFw98UsF/pi6Dvq9VDlHkLk3bcBhk5BGFbT74BZbBX
         i8pw==
X-Gm-Message-State: AOJu0Yz1D1nUAF3eML+bjGxiyQDdlaHpB0iNgqBsIEwTMV6+qGByEEME
	+m/cE/uvRFMfag5ObLzOSxqxHjUCnM8/RrTEn41p37WogElEKgHOsyfLHlrgPRhYMugYkEq2t2m
	MN46GFb7/2omLD38CG/NPwjgfqIsEvd24pe6UkdxaIIjKeRC+d32DxA==
X-Gm-Gg: ASbGnctfZ5zIq+k+mC3yUplM3nvxRLj7/ERcKtV/sCEuo4yqzE5RxYFdNuS0htTmoAY
	MlkYLmqb/XycUF2dXqj56I9L4wgcxBt3Vryv5hPrOFDIvVjA5ll89p4pWecsrYlzs2pyoE4Gbww
	KRStN9luqawL3d6wV89qYIeH6ZMjqhv65McoslYTBZOTILbiZYQFIQi7/DQE3evH12CoabY6Ffo
	7/yo18JBEli+dQEktZggz5Fb3cmEXLfwn0sv3uptscNoD0wSMttXN24bjQMb4jcq/0fmso/Vwf9
	z+2smfMnSYiJ6G81/g==
X-Received: by 2002:a05:600c:1d1f:b0:440:68db:9fef with SMTP id 5b1f17b1804b1-4534f9f165amr76162135e9.20.1750237376594;
        Wed, 18 Jun 2025 02:02:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHweVLH3+qQqzxN9lP0gvuWDUPk09sRaZGtlxPAesY7nOwT7neBaDVRHRs5uwT3SBz915xDtA==
X-Received: by 2002:a05:600c:1d1f:b0:440:68db:9fef with SMTP id 5b1f17b1804b1-4534f9f165amr76161785e9.20.1750237376101;
        Wed, 18 Jun 2025 02:02:56 -0700 (PDT)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532de8c50esm198439285e9.4.2025.06.18.02.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 02:02:55 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kai Huang
 <kai.huang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 04/18] KVM: x86: Drop superfluous kvm_hv_set_sint()
 => kvm_hv_synic_set_irq() wrapper
In-Reply-To: <20250611213557.294358-5-seanjc@google.com>
References: <20250611213557.294358-1-seanjc@google.com>
 <20250611213557.294358-5-seanjc@google.com>
Date: Wed, 18 Jun 2025 11:02:54 +0200
Message-ID: <87a565pgld.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> Drop the superfluous kvm_hv_set_sint() and instead wire up ->set() directly
> to its final destination, kvm_hv_synic_set_irq().  Keep hv_synic_set_irq()
> instead of kvm_hv_set_sint() to provide some amount of consistency in the
> ->set() helpers, e.g. to match kvm_pic_set_irq() and kvm_ioapic_set_irq().
>
> kvm_set_msi() is arguably the oddball, e.g. kvm_set_msi_irq() should be
> something like kvm_msi_to_lapic_irq() so that kvm_set_msi() can instead be
> kvm_set_msi_irq(), but that's a future problem to solve.
>
> No functional change intended.
>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Sorry for the delay,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

> ---
>  arch/x86/kvm/hyperv.c   | 10 +++++++---
>  arch/x86/kvm/hyperv.h   |  3 ++-
>  arch/x86/kvm/irq_comm.c | 18 +++---------------
>  3 files changed, 12 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 24f0318c50d7..f316e11383aa 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -497,15 +497,19 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
>  	return ret;
>  }
>  
> -int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vpidx, u32 sint)
> +int kvm_hv_synic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
> +			 int irq_source_id, int level, bool line_status)
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
> index 913bfc96959c..6ce160ffa678 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -103,7 +103,8 @@ static inline bool kvm_hv_hypercall_enabled(struct kvm_vcpu *vcpu)
>  int kvm_hv_hypercall(struct kvm_vcpu *vcpu);
>  
>  void kvm_hv_irq_routing_update(struct kvm *kvm);
> -int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vcpu_id, u32 sint);
> +int kvm_hv_synic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
> +			 int irq_source_id, int level, bool line_status);
>  void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector);
>  int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
>  
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 8dcb6a555902..28a8555ab58b 100644
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
> @@ -149,8 +137,8 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>  	switch (e->type) {
>  #ifdef CONFIG_KVM_HYPERV
>  	case KVM_IRQ_ROUTING_HV_SINT:
> -		return kvm_hv_set_sint(e, kvm, irq_source_id, level,
> -				       line_status);
> +		return kvm_hv_synic_set_irq(e, kvm, irq_source_id, level,
> +					    line_status);
>  #endif
>  
>  	case KVM_IRQ_ROUTING_MSI:
> @@ -302,7 +290,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  		break;
>  #ifdef CONFIG_KVM_HYPERV
>  	case KVM_IRQ_ROUTING_HV_SINT:
> -		e->set = kvm_hv_set_sint;
> +		e->set = kvm_hv_synic_set_irq;
>  		e->hv_sint.vcpu = ue->u.hv_sint.vcpu;
>  		e->hv_sint.sint = ue->u.hv_sint.sint;
>  		break;

-- 
Vitaly


