Return-Path: <kvm+bounces-36158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26028A18262
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:58:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C53F3A26EF
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C5D11F4E3A;
	Tue, 21 Jan 2025 16:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gi+X6+QY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A9E1487E1;
	Tue, 21 Jan 2025 16:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737478711; cv=none; b=PhaOEKxxNeke/C0XOMF5oacZcGhEIYX5e+yj8U2bOH607ri0dVwS3sdlsbxC9cxFbvAq4BL1QCXxfphnQQSH+TPqbzSTcaubPdSrL2pgAtHlPa/5fgfsvsc1JkZr9x1wANYnlbORN1mwpIeItaYshIzeufVOUajbHmvDdn/+bRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737478711; c=relaxed/simple;
	bh=1qj1Z7qZjLWMICIl/DvpFySD52Czjkyh0RcZ8KYgRho=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=UzDOPfZJmgvXfwt9uQklHXYjjJGFMnDUe3vLKrnHNAwIhVrNoKRV6r/Ng3bGgoQW3900EqMgUUnFR2Ai+7K1LUqDwUSt+eu1hoewgUaK20FnZIh3+Q3er1o7wpYyT45Zj7FtW9QnEcTprJom7k+ILmCaUTqYa6EYOnz58lm6sDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gi+X6+QY; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ab39f84cbf1so706526866b.3;
        Tue, 21 Jan 2025 08:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737478708; x=1738083508; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=doSIOSoCzjXwkVt78c52kzRTsfNi+ZFQxvkXJliSGTU=;
        b=gi+X6+QYUNfgeiyQfVf10/ox/6ORUm06gbfpkA7rV13PLcZPcWD8OzZJ+A9CRYTsvI
         aO3Mmn/jkRfmAvNmTEdWgIr8JtXky4ZrazZSlcKtkBwSf5mPttMeTb6xUjmslYiFikWa
         G+g2HUAColVi8E4oUTs8Z80xHUBasDAJBu5Ripw/54B1FybcZSapVDzz9+gW3fdcFYZv
         bVqaanwBco/XWPii12mwY94X3sWol42rw294DiRBL1xFDdZgvqLpDnmZN5gFUZ0TLFBY
         Foku5sDUXXp7EncrPY2CPBeXMbQmOuzg+k8t8qTEalAtsRcMhMERUXVwISUoe0SGzsat
         fqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737478708; x=1738083508;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=doSIOSoCzjXwkVt78c52kzRTsfNi+ZFQxvkXJliSGTU=;
        b=Bys5pnQpOeF/qdnRHXsgngsKDLuZvJ68OW5KxCJVIcG9VdtTKNzARkXPemml3ccOpZ
         rAb6sGNGZHz+zL8kxTq7y9msMSB92lhvtBLXogYaST3DqWc2G/VsFS0curQzcFaVlBTo
         P/GZ/3w3DhQP04XF9f5cE1vBWxFa/sRKal2HPaoJ+Tflhn5Da4UrHjbMqmcEJUqG0OYf
         /ZjgujzJVChfwZw0jSONogWtZGK6F3B79XnDqcg7XBxNUb3Ylh74lv185xlSgF471hpM
         HeM8DyBRnaKYB9JkDNbwAO7EHZiVhanLECahCnG+xnYFQkK9NJ27YZF7PCrhrQm4NH0y
         et+Q==
X-Forwarded-Encrypted: i=1; AJvYcCX/epVUyqdz0EU0frr1b1tFWPC9FZIyu+aWzXweft/yHzaEDT9qDuIojkgFYiafLNg5NVv0xRVXTTmt/EU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyW3al63FQCZF9pC34g6YOMa5e3fRJifQ9IYXENHCfJE/N0c/sJ
	oT+QlLe6tYRbyiZYz19rjEjZwGsxic6D6JOeUle0hIA5HwjRjW0U
X-Gm-Gg: ASbGncsodW8nGxlPAEwo/Py7Dk9mwwYV11jLVMNbsJZGOASgTACOn2aFpR8HQxOqpQd
	674QbRU7H3qP+46e6OxiTN2Y2LK1mEUm3HnGc8/77/c2pGhKvezhKiv8GlXMRL1Cwru82SrJgIP
	VDTL4s0aDBhHeCK/pnl5rIzZLkX0c77izX+kNB1/7uyizp52O/4ngBtXagaDFVo4d79t6gkL7RI
	m2sDfS9XQIQANTDUr+WXmpuItS1glw7K+E8+Wscq1uSHfZGY6TgNrHff7jr98Bds8JAYf4/rPHO
	AF9k00JqhUObxntWXLNc1ZOY9g==
X-Google-Smtp-Source: AGHT+IH6E0iXyO6ZX3ruX7+MIvGHpwSsfWHJ0CBFOG5SlgPu+dJK7mvF4gOyTPjmom9p/9NrsyJ9/w==
X-Received: by 2002:a17:907:3f95:b0:aac:1b56:324a with SMTP id a640c23a62f3a-ab38b161425mr1642509566b.26.1737478707608;
        Tue, 21 Jan 2025 08:58:27 -0800 (PST)
Received: from [192.168.19.15] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f22c75sm765478766b.88.2025.01.21.08.58.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 08:58:27 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <06482c0e-e519-47ca-9f70-da3ab12ed2e4@xen.org>
Date: Tue, 21 Jan 2025 16:58:26 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 06/10] KVM: x86/xen: Use guest's copy of pvclock when
 starting timer
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250118005552.2626804-1-seanjc@google.com>
 <20250118005552.2626804-7-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250118005552.2626804-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/01/2025 00:55, Sean Christopherson wrote:
> Use the guest's copy of its pvclock when starting a Xen timer, as KVM's
> reference copy may not be up-to-date, i.e. may yield a false positive of
> sorts.  In the unlikely scenario that the guest is starting a Xen timer
> and has used a Xen pvclock in the past, but has since but turned it "off",
> then vcpu->arch.hv_clock may be stale, as KVM's reference copy is updated
> if and only if at least pvclock is enabled.
> 
> Furthermore, vcpu->arch.hv_clock is currently used by three different
> pvclocks: kvmclock, Xen, and Xen compat.  While it's extremely unlikely a
> guest would ever enable multiple pvclocks, effectively sharing KVM's
> reference clock could yield very weird behavior.  Using the guest's active
> Xen pvclock instead of KVM's reference will allow dropping KVM's
> reference copy.
> 
> Fixes: 451a707813ae ("KVM: x86/xen: improve accuracy of Xen timers")
> Cc: Paul Durrant <pdurrant@amazon.com>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/xen.c | 58 ++++++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 53 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index a909b817b9c0..b82c28223585 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -150,11 +150,46 @@ static enum hrtimer_restart xen_timer_callback(struct hrtimer *timer)
>   	return HRTIMER_NORESTART;
>   }
>   
> +static int xen_get_guest_pvclock(struct kvm_vcpu *vcpu,
> +				 struct pvclock_vcpu_time_info *hv_clock,
> +				 struct gfn_to_pfn_cache *gpc,
> +				 unsigned int offset)
> +{
> +	struct pvclock_vcpu_time_info *guest_hv_clock;
> +	unsigned long flags;
> +	int r;
> +
> +	read_lock_irqsave(&gpc->lock, flags);
> +	while (!kvm_gpc_check(gpc, offset + sizeof(*guest_hv_clock))) {
> +		read_unlock_irqrestore(&gpc->lock, flags);
> +
> +		r = kvm_gpc_refresh(gpc, offset + sizeof(*guest_hv_clock));
> +		if (r)
> +			return r;
> +
> +		read_lock_irqsave(&gpc->lock, flags);
> +	}
> +

I guess I must be missing something subtle... What is setting 
guest_hv_clock to point at something meaningful before this line?

> +	memcpy(hv_clock, guest_hv_clock, sizeof(*hv_clock));
> +	read_unlock_irqrestore(&gpc->lock, flags);
> +
> +	/*
> +	 * Sanity check TSC shift+multiplier to verify the guest's view of time
> +	 * is more or less consistent.
> +	 */
> +	if (hv_clock->tsc_shift != vcpu->arch.hv_clock.tsc_shift ||
> +	    hv_clock->tsc_to_system_mul != vcpu->arch.hv_clock.tsc_to_system_mul)
> +		return -EINVAL;
> +	return 0;
> +}
> +
>   static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs,
>   				bool linux_wa)
>   {
> +	struct kvm_vcpu_xen *xen;
>   	int64_t kernel_now, delta;
>   	uint64_t guest_now;
> +	int r = -EOPNOTSUPP;
>   
>   	/*
>   	 * The guest provides the requested timeout in absolute nanoseconds
> @@ -173,10 +208,22 @@ static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs,
>   	 * the absolute CLOCK_MONOTONIC time at which the timer should
>   	 * fire.
>   	 */
> -	if (vcpu->arch.hv_clock.version && vcpu->kvm->arch.use_master_clock &&
> -	    static_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
> +	do {
> +		struct pvclock_vcpu_time_info hv_clock;
>   		uint64_t host_tsc, guest_tsc;
>   
> +		if (!static_cpu_has(X86_FEATURE_CONSTANT_TSC) ||
> +		    !vcpu->kvm->arch.use_master_clock)
> +			break;
> +
> +		if (xen->vcpu_info_cache.active)
> +			r = xen_get_guest_pvclock(vcpu, &hv_clock, &xen->vcpu_info_cache,
> +						offsetof(struct compat_vcpu_info, time));
> +		else if (xen->vcpu_time_info_cache.active)
> +			r = xen_get_guest_pvclock(vcpu, &hv_clock, &xen->vcpu_time_info_cache, 0);
> +		if (r)
> +			break;
> +
>   		if (!IS_ENABLED(CONFIG_64BIT) ||
>   		    !kvm_get_monotonic_and_clockread(&kernel_now, &host_tsc)) {
>   			/*
> @@ -197,9 +244,10 @@ static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs,
>   
>   		/* Calculate the guest kvmclock as the guest would do it. */
>   		guest_tsc = kvm_read_l1_tsc(vcpu, host_tsc);
> -		guest_now = __pvclock_read_cycles(&vcpu->arch.hv_clock,
> -						  guest_tsc);
> -	} else {
> +		guest_now = __pvclock_read_cycles(&hv_clock, guest_tsc);
> +	} while (0);
> +
> +	if (r) {
>   		/*
>   		 * Without CONSTANT_TSC, get_kvmclock_ns() is the only option.
>   		 *


