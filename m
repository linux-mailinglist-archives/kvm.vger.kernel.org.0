Return-Path: <kvm+bounces-24846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5159B95BE6C
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 20:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09E982857FC
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 18:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA941D04A0;
	Thu, 22 Aug 2024 18:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uym6bvcl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58E71D048F
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 18:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724352245; cv=none; b=YFdHQtAMDsmw3XiR87zwrKBuUThdV4NtWlIjl8SngPfjzp4b0mssE/+E6WyD+7+nI6Jr+56Xhf/sJ/26XNfrkQ7teHL+fscKrPrshFzcrAL/j5Y9kKSkNo7xTyXvfRQjvVUZQpDshwzLdecd6stH04ESE1FWxulDlI6VN5/Q3lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724352245; c=relaxed/simple;
	bh=M3vqZCa5VDTPUUOyIj4G1gpeFjy7jpvdM/UN9H+yiCA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z2LDLsH90zd1E+UE9BTdItaJYvTd7wxnkE1xUTdoJrdVaXs+ke1AL+uSjr989/KMzfbh5pwjEDm9w4Y7bG+Hed+i0i27+GqCVhKk7eWvqczs8asr0hzc1sFHcmuWFqR0onsP39oQQbNsTPOHwV4tZwz39awUYFfcqoJvYN+dJNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uym6bvcl; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ad26d5b061so20448527b3.2
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 11:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724352243; x=1724957043; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IQxeqivJ6nMSCTNXsXrVfvK16zBHaJIgKV6XCEGAE0E=;
        b=uym6bvclfrMMx0Rv3CgciLIlZjAG8LHCf3jhyw7IW7yPcMEky3mTtxPR6tflbMph2I
         HNeZs9EZNqDJuBo3r0PEWP9UR2S2wFObpD6xgnxD0w5dGxFmxGNq4eQg4WxNCEvvBU2k
         a0p2zlVieLTffxlZE58qc8DGU/jAnm/IkM4LYAu4jvqfoaQTTzLRyTBYC/4kvJFBUS8p
         UMpxaLCbn572Dxq36kn2sE7EjTs9qQJaE9b7XMWqiXdrd5Pnw6rDSZE/sBSjcAp9VCbl
         9qZq7EBHTz76MC2Y4yQ5WPfkERYsI07DW8iYJV4v/hDa8u7d/YjU3RXNfbnRq0VUhvsB
         fGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724352243; x=1724957043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IQxeqivJ6nMSCTNXsXrVfvK16zBHaJIgKV6XCEGAE0E=;
        b=UCn/W/AzvaNVsndY9mGOqeMobr1YsyQD2NXQlPlmJARRpNpKjD4U/kV34Ts5umZMTI
         U1OCdINAR6aSncuWh3/G/cZHb55+GyQhSDV5AX/1+eV+BUHrGiPAaddayNL33aqOSHBj
         Uv/qBopIJJN5GtST30zar2iCaBGkgrdTNoABY505LVI+m+f58AEsZ/ICIRaTH5V4TpWF
         gs8GVmEplwndbNSVtmSNDv+mp7jjzSsdfV115YKBdQQJsHcvT06GHUPCdxXLainbkBzN
         IEEbf9AZEDyqX+to7SkF3ek/3hd/k2mEwWZ8yQAuTU6B2PVM75kMuof9j41oZxiCPKio
         2rhg==
X-Forwarded-Encrypted: i=1; AJvYcCV6ramsa+ANcHl9JPTnYb2wNn5mm542Z0EG8KU0tWM2EaZwlZdmbXSP0SYnBGcA3HlUJS0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXS/VAW5ux8e1cfm9MEyq0FWTojsHEjwLx5yvJAv8oRfvUBABn
	Zbv5yLJ0b4VhQh/gmvBtzQMmou2yRG+eWC4pVQXQtkFmcPKAZUBzixVK/dH4R4fbsbsDDRDZcoW
	vWw==
X-Google-Smtp-Source: AGHT+IHyVwyPWCotNwyxj1pKcsUVMUItHP4LmQr2HD4m2u4TmB9s487bSnXa/VZx7si7wpPEtvSNRuvZprI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4812:b0:691:41f5:7f42 with SMTP id
 00721157ae682-6c5be2bed7dmr64507b3.4.1724352242860; Thu, 22 Aug 2024 11:44:02
 -0700 (PDT)
Date: Thu, 22 Aug 2024 11:44:01 -0700
In-Reply-To: <20240719235107.3023592-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719235107.3023592-1-seanjc@google.com> <20240719235107.3023592-4-seanjc@google.com>
Message-ID: <ZseG8eQKADDBbat7@google.com>
Subject: Re: [PATCH v2 03/10] KVM: x86: Re-split x2APIC ICR into ICR+ICR2 for
 AMD (x2AVIC)
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"

+Tom

Can someone from AMD confirm that this is indeed the behavior, and that for AMD
CPUs, it's the architectural behavior?

A sanity check on the code would be appreciated too, it'd be nice to get this
into v6.12.

Thanks!

On Fri, Jul 19, 2024, Sean Christopherson wrote:
> Re-introduce the "split" x2APIC ICR storage that KVM used prior to Intel's
> IPI virtualization support, but only for AMD.  While not stated anywhere
> in the APM, despite stating the ICR is a single 64-bit register, AMD CPUs
> store the 64-bit ICR as two separate 32-bit values in ICR and ICR2.  When
> IPI virtualization (IPIv on Intel, all AVIC flavors on AMD) is enabled,
> KVM needs to match CPU behavior as some ICR ICR writes will be handled by
> the CPU, not by KVM.
> 
> Add a kvm_x86_ops knob to control the underlying format used by the CPU to
> store the x2APIC ICR, and tune it to AMD vs. Intel regardless of whether
> or not x2AVIC is enabled.  If KVM is handling all ICR writes, the storage
> format for x2APIC mode doesn't matter, and having the behavior follow AMD
> versus Intel will provide better test coverage and ease debugging.
> 
> Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
> Cc: stable@vger.kernel.org
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/lapic.c            | 42 +++++++++++++++++++++++----------
>  arch/x86/kvm/svm/svm.c          |  2 ++
>  arch/x86/kvm/vmx/main.c         |  2 ++
>  4 files changed, 36 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 950a03e0181e..edc235521434 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1726,6 +1726,8 @@ struct kvm_x86_ops {
>  	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
>  	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
>  	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
> +
> +	const bool x2apic_icr_is_split;
>  	const unsigned long required_apicv_inhibits;
>  	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
>  	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index d14ef485b0bd..cc0a1008fae4 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2473,11 +2473,25 @@ int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
>  	data &= ~APIC_ICR_BUSY;
>  
>  	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
> -	kvm_lapic_set_reg64(apic, APIC_ICR, data);
> +	if (kvm_x86_ops.x2apic_icr_is_split) {
> +		kvm_lapic_set_reg(apic, APIC_ICR, data);
> +		kvm_lapic_set_reg(apic, APIC_ICR2, data >> 32);
> +	} else {
> +		kvm_lapic_set_reg64(apic, APIC_ICR, data);
> +	}
>  	trace_kvm_apic_write(APIC_ICR, data);
>  	return 0;
>  }
>  
> +static u64 kvm_x2apic_icr_read(struct kvm_lapic *apic)
> +{
> +	if (kvm_x86_ops.x2apic_icr_is_split)
> +		return (u64)kvm_lapic_get_reg(apic, APIC_ICR) |
> +		       (u64)kvm_lapic_get_reg(apic, APIC_ICR2) << 32;
> +
> +	return kvm_lapic_get_reg64(apic, APIC_ICR);
> +}
> +
>  /* emulate APIC access in a trap manner */
>  void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>  {
> @@ -2495,7 +2509,7 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>  	 * maybe-unecessary write, and both are in the noise anyways.
>  	 */
>  	if (apic_x2apic_mode(apic) && offset == APIC_ICR)
> -		WARN_ON_ONCE(kvm_x2apic_icr_write(apic, kvm_lapic_get_reg64(apic, APIC_ICR)));
> +		WARN_ON_ONCE(kvm_x2apic_icr_write(apic, kvm_x2apic_icr_read(apic)));
>  	else
>  		kvm_lapic_reg_write(apic, offset, kvm_lapic_get_reg(apic, offset));
>  }
> @@ -3005,18 +3019,22 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
>  
>  		/*
>  		 * In x2APIC mode, the LDR is fixed and based on the id.  And
> -		 * ICR is internally a single 64-bit register, but needs to be
> -		 * split to ICR+ICR2 in userspace for backwards compatibility.
> +		 * if the ICR is _not_ split, ICR is internally a single 64-bit
> +		 * register, but needs to be split to ICR+ICR2 in userspace for
> +		 * backwards compatibility.
>  		 */
> -		if (set) {
> +		if (set)
>  			*ldr = kvm_apic_calc_x2apic_ldr(*id);
>  
> -			icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
> -			      (u64)__kvm_lapic_get_reg(s->regs, APIC_ICR2) << 32;
> -			__kvm_lapic_set_reg64(s->regs, APIC_ICR, icr);
> -		} else {
> -			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
> -			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
> +		if (!kvm_x86_ops.x2apic_icr_is_split) {
> +			if (set) {
> +				icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
> +				      (u64)__kvm_lapic_get_reg(s->regs, APIC_ICR2) << 32;
> +				__kvm_lapic_set_reg64(s->regs, APIC_ICR, icr);
> +			} else {
> +				icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
> +				__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
> +			}
>  		}
>  	}
>  
> @@ -3214,7 +3232,7 @@ static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data)
>  	u32 low;
>  
>  	if (reg == APIC_ICR) {
> -		*data = kvm_lapic_get_reg64(apic, APIC_ICR);
> +		*data = kvm_x2apic_icr_read(apic);
>  		return 0;
>  	}
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c115d26844f7..04c113386de6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5049,6 +5049,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.enable_nmi_window = svm_enable_nmi_window,
>  	.enable_irq_window = svm_enable_irq_window,
>  	.update_cr8_intercept = svm_update_cr8_intercept,
> +
> +	.x2apic_icr_is_split = true,
>  	.set_virtual_apic_mode = avic_refresh_virtual_apic_mode,
>  	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
>  	.apicv_post_state_restore = avic_apicv_post_state_restore,
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 0bf35ebe8a1b..a70699665e11 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -89,6 +89,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.enable_nmi_window = vmx_enable_nmi_window,
>  	.enable_irq_window = vmx_enable_irq_window,
>  	.update_cr8_intercept = vmx_update_cr8_intercept,
> +
> +	.x2apic_icr_is_split = false,
>  	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
>  	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
>  	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
> -- 
> 2.45.2.1089.g2a221341d9-goog
> 

