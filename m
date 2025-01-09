Return-Path: <kvm+bounces-34931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26B0DA07C1D
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 16:38:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 524303A5A3D
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 15:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CB9021D583;
	Thu,  9 Jan 2025 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M6FjxVlj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CAD14F98
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 15:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736437122; cv=none; b=bP34L6az9efQYupjohq5dio8Xk8gKQLjWVkW+CmsacrMfN/TEEbVBwTvot62Ibj71Eij9OJasR75alDSy/9sXayTiRkkj7EETp/NwgVk3aoIxEuNEy53BPQSCzjPtmnvr6gEFRNoVv4S1zss/yhVEfx3mUxI4S2+TZ0PepAoYD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736437122; c=relaxed/simple;
	bh=LFdktPPjXhLTQhmFfmtdllkEcEDeVDSJl9EsWALqWCI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ABDw76zIdsbjy2Ir2rEzg/U4xMlheotMPApwNU2jXV8Wl32h+6upwRHmAV7k8ihlcLCTPNwEu09tQ/djUyocraVHDnrQLaqZgCYBRtQO4PHr1Q2RMGJBSGYGKtuEiOsDdRPe96Y6dOWlqzpMHa4r+w3QVVsAIrLxWlT7dRZfPX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M6FjxVlj; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4361f664af5so13275885e9.1
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 07:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736437118; x=1737041918; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yLy325AUOiqV6ZCCFMYvVTZpyhigu94q9qDp0u9niZc=;
        b=M6FjxVljXfbrj5v8Hha8J7dWXianUb6zQcea9urEBT35qGQYqSgbsvLSrjiQ9HlGQa
         6nZsDBOU7w3lZTYbtd/glK9evlt2cH/+U/NqxV8L+0zv9XuMs3bpASR1+iRf3g7n7GDX
         tv+9FcByK9aIQzmw48RYjoURGQxbH85cCPY4ObMOABMCQYIZpSe3qInJMiV8lBj5Q0cA
         jx+SsFQb5Hv4bXha42mE0I/NY/ObtI+EBjV4Xz73OoHU857WJLiJDEl6OI6zCOjTtk6q
         rq0xTz5BontvtO1qX/qutR6az9FOPQOpKWxKY9K+CpID1x1K3OhREbIpm9hq7ijtfTaz
         cSSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736437118; x=1737041918;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yLy325AUOiqV6ZCCFMYvVTZpyhigu94q9qDp0u9niZc=;
        b=E8SVanYBSeGdC3NQHYDqBcgHqteY3H8h2J3ZpOL0Q7BlwTQv5XBiR3yRYtDVgbQYdM
         0d+KTSluGCyQgIt86t6LjL6/JG25ROz/vz9Nhv+SsiF6E5F8lqFyNKT9Y4vXTgWGPumB
         XolozEiOQTWJehMBMZtJNZn+SqFA+4VPBvcMUKNAhzImHcacZkDOjy+7m5qCqzY76DtN
         HFjPHpNCEGQ6fDKYVfafjzF3Pr2KEOaZcAZHuInP6ADdT42R0C+PycbMZN2+B6DGEk67
         XFn1/RHwnm6hg22bBB803Kl7XqWc+L4bWuK/Dp4CSBJYr/8hlzdh1syxOn/N8NBsZKg6
         xXAQ==
X-Forwarded-Encrypted: i=1; AJvYcCW26NiBZNL6lLwRfabj96SW0X9hf9YDg6IWLS85krsUKV+Nk3JYGXuKC8Ms+g4hXVNa5gU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYtn6+8XC4kkgJoiBZA31HJfR53mF6hZevw7dBaP9GLYfD/LNE
	QK6Wnv0jM7QNMnx/0uliYHGON5VyMtHKw5+m3Oco7WuPlm7a3plmYnZzPt1W6aI=
X-Gm-Gg: ASbGncuwMMZTkGag1Uixi9+lYfZ77rtN76r1sIwDkGjGpKbiSqHyCAxkis+1C278ZC9
	JYyaPxVxZ893lCryqZi+N3qXJO37+xlY1FXOpZHr7OS6H+qgitm/IcLQVNQGjafkbXNxcEOsxHT
	PoJGlFFDDW+a37RHBwbuKnBuXPSCR0RwJSOXrWjLfcbxZBxTVZLdFzRu80qsQ00qnstm8hB+Udz
	yTmH/ueWJZiTTdXFHaKvK2zb5Ei8reCW/6XxdhqI0u0YMFIG5KXP6Pt7wgkYA==
X-Google-Smtp-Source: AGHT+IEiniSHvExZnT2lQmtb7twwNs+mSHQUVNaNPEf+nv+GbFJKHMawc6EzKMGwxqNYmMel3oSjnQ==
X-Received: by 2002:adf:a19b:0:b0:38a:88a0:2235 with SMTP id ffacd0b85a97d-38a88a02276mr5145562f8f.37.1736437118231;
        Thu, 09 Jan 2025 07:38:38 -0800 (PST)
Received: from [192.168.0.20] ([212.21.159.176])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9e03ffcsm24419325e9.20.2025.01.09.07.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 07:38:38 -0800 (PST)
Message-ID: <5d1d421c-3123-455e-aba1-1baf7f12e89e@suse.com>
Date: Thu, 9 Jan 2025 17:38:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/16] KVM: TDX: Add support for find pending IRQ in a
 protected local APIC
To: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-2-binbin.wu@linux.intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <20241209010734.3543481-2-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9.12.24 г. 3:07 ч., Binbin Wu wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Add flag and hook to KVM's local APIC management to support determining
> whether or not a TDX guest as a pending IRQ.  For TDX vCPUs, the virtual
> APIC page is owned by the TDX module and cannot be accessed by KVM.  As a
> result, registers that are virtualized by the CPU, e.g. PPR, cannot be
> read or written by KVM.  To deliver interrupts for TDX guests, KVM must
> send an IRQ to the CPU on the posted interrupt notification vector.  And
> to determine if TDX vCPU has a pending interrupt, KVM must check if there
> is an outstanding notification.
> 
> Return "no interrupt" in kvm_apic_has_interrupt() if the guest APIC is
> protected to short-circuit the various other flows that try to pull an
> IRQ out of the vAPIC, the only valid operation is querying _if_ an IRQ is
> pending, KVM can't do anything based on _which_ IRQ is pending.
> 
> Intentionally omit sanity checks from other flows, e.g. PPR update, so as
> not to degrade non-TDX guests with unnecessary checks.  A well-behaved KVM
> and userspace will never reach those flows for TDX guests, but reaching
> them is not fatal if something does go awry.
> 
> Note, this doesn't handle interrupts that have been delivered to the vCPU
> but not yet recognized by the core, i.e. interrupts that are sitting in
> vmcs.GUEST_INTR_STATUS.  Querying that state requires a SEAMCALL and will
> be supported in a future patch.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> TDX interrupts breakout:
>   - Dropped vt_protected_apic_has_interrupt() with KVM_BUG_ON(), wire in
>     tdx_protected_apic_has_interrupt() directly. (Rick)
>   - Add {} on else in vt_hardware_setup()
> ---
>   arch/x86/include/asm/kvm-x86-ops.h | 1 +
>   arch/x86/include/asm/kvm_host.h    | 1 +
>   arch/x86/kvm/irq.c                 | 3 +++
>   arch/x86/kvm/lapic.c               | 3 +++
>   arch/x86/kvm/lapic.h               | 2 ++
>   arch/x86/kvm/vmx/main.c            | 3 +++
>   arch/x86/kvm/vmx/tdx.c             | 6 ++++++
>   arch/x86/kvm/vmx/x86_ops.h         | 2 ++
>   8 files changed, 21 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index ec1b1b39c6b3..d5faaaee6ac0 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -114,6 +114,7 @@ KVM_X86_OP_OPTIONAL(pi_start_assignment)
>   KVM_X86_OP_OPTIONAL(apicv_pre_state_restore)
>   KVM_X86_OP_OPTIONAL(apicv_post_state_restore)
>   KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
> +KVM_X86_OP_OPTIONAL(protected_apic_has_interrupt)
>   KVM_X86_OP_OPTIONAL(set_hv_timer)
>   KVM_X86_OP_OPTIONAL(cancel_hv_timer)
>   KVM_X86_OP(setup_mce)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 37dc7edef1ca..32c7d58a5d68 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1811,6 +1811,7 @@ struct kvm_x86_ops {
>   	void (*apicv_pre_state_restore)(struct kvm_vcpu *vcpu);
>   	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
>   	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
> +	bool (*protected_apic_has_interrupt)(struct kvm_vcpu *vcpu);
>   
>   	int (*set_hv_timer)(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
>   			    bool *expired);
> diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
> index 63f66c51975a..f0644d0bbe11 100644
> --- a/arch/x86/kvm/irq.c
> +++ b/arch/x86/kvm/irq.c
> @@ -100,6 +100,9 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
>   	if (kvm_cpu_has_extint(v))
>   		return 1;
>   
> +	if (lapic_in_kernel(v) && v->arch.apic->guest_apic_protected)
> +		return static_call(kvm_x86_protected_apic_has_interrupt)(v);
> +
>   	return kvm_apic_has_interrupt(v) != -1;	/* LAPIC */
>   }
>   EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 65412640cfc7..684777c2f0a4 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2920,6 +2920,9 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
>   	if (!kvm_apic_present(vcpu))
>   		return -1;
>   
> +	if (apic->guest_apic_protected)
> +		return -1;
> +
>   	__apic_update_ppr(apic, &ppr);
>   	return apic_has_interrupt_for_ppr(apic, ppr);
>   }
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 1b8ef9856422..82355faf8c0d 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -65,6 +65,8 @@ struct kvm_lapic {
>   	bool sw_enabled;
>   	bool irr_pending;
>   	bool lvt0_in_nmi_mode;
> +	/* Select registers in the vAPIC cannot be read/written. */
> +	bool guest_apic_protected;

Can't this member be eliminated and instead  is_td_vcpu() used as it 
stands currently that member is simply a proxy value for "is this a tdx 
vcpu"?

<snip>

