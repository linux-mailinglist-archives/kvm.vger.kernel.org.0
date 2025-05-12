Return-Path: <kvm+bounces-46266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 242FAAB4693
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 23:39:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E15F8C26B2
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 21:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A947299A8A;
	Mon, 12 May 2025 21:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xVTSTO1u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCD3256C87
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 21:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747085704; cv=none; b=HUZTRkMyH/mT4NzDGiZZl2BJJeMj7uMQ8mgsl9qc5AwwzD2LCjTjCfYVeoMhF9eA9RwLIIDQhyjDoyH73fGgbZ1BfiFp8My19EG4n9uTFzT/U7ZQCe0EiJyB1l95TRZ6ydEw1TGpfpi/UMDqgXdrRa7cQBSrf3ow88ptn1d6poA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747085704; c=relaxed/simple;
	bh=F4jUKxmmtFWbb0Phvnt982gTcM98ZUL8jjp2BIVdMn4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I6LNplGs/Msb6UFGyABHHQN7KqTkgWbnBDnxvU3b6Q+FO6aiRLdOmAIa3et+3NYu/koMu13SPXGktdweX1kysW++BxQKmRj3JfXU1wGqG7GVGhQzoBhv1noslaOiR8oG9z6q0KzT9Lvaj3XUe1IjyhNel7t0RvmerwcqDuVdgNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xVTSTO1u; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74041404f8dso3420445b3a.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 14:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747085702; x=1747690502; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qBVT+AOygf4X2VMb+/bmTXiVeZNYP5SVSUzgnTYp+ls=;
        b=xVTSTO1u2DZeGuKt4GSupMXvnD2FXdQpQPElY1+Dt+YmRnyHFrslSsV1i3Hlp7pcQc
         ahXpHIMn0l6B/zwEkTbtJ2Z74fYb0up0Ezf06c/ugXgNpJaog/Jt95EWR2eEBEhnE4AN
         DJhUkO0aUK0tAgrDnGVaDrT6VuBh0+3C41qYLVCPi0KUJUIjol+zrEdQgQN1wW7rhnla
         iJ/7dxOtlAMmbRBPiwIiEzlj9YkkBQSD4LNzBTqjgzcaHcp2ae3sYXMDRDYAuBmZpCav
         rofbdNkg8Da2NA5JXxagjQy090q74lFOgnUSzES0v8GjxIVwooOwyUhpY0I8lKJtu1+l
         prOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747085702; x=1747690502;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qBVT+AOygf4X2VMb+/bmTXiVeZNYP5SVSUzgnTYp+ls=;
        b=joayG3fuZLVuyc2PzvJR9kQdKEkGdhjTtnqrse+paKf7pMmTJ1qAQSl4dpzJ2B1gBC
         xVjqeeVyep2TJsr6maE2G05o5EkfFQQSZC+kJKZ2qPzuNmfmUNHD1nrr6/HHYzviKV2M
         Xu4JunMFGxB9ob06Avbr40j+KxY/QksfioDowMKk0WL34B3WJNFlzqecGTnRsC4Fc6en
         RSsLm2biOnFvQP/SCIJt8mCJKin2ntAXaXx3GqjKoHhx7aoT3IgWZ7Yiu4d+Nq+miKas
         djm+sEdgUjFkwAGmweFPINBo4lP0dTOIrenwYeiJ9HwYlIBJ30Q16+FD1LjvpZAN1Opw
         Z5Zw==
X-Forwarded-Encrypted: i=1; AJvYcCVHZhwSWmC96w900Ggg+ei79sVLJ+1kPAoYBag//APORRDOh5sUmLJ6lkfkGX/HFAPgVnE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNMbOSJ4P4WCHUppXtOkbne3I7jq5gtq7rsdZ238i/5tpoPeoE
	fwgEQHsK7uo9R79VTc0IUX1QmpkYgbIo+Bs0IFK1xM3w93XAOP7JEvzwBkW3u0dxhH7yiqknjXn
	GWw==
X-Google-Smtp-Source: AGHT+IETNOptff3WUn3HPebpVtrn0fYXqa0NJJ/42KObUUcNlvnkufd+zmnkR58KW5wpkU5tztpkleZHP6A=
X-Received: from pgww3.prod.google.com ([2002:a05:6a02:2c83:b0:b1f:dd75:de2a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:cf84:b0:1fe:6bbf:af22
 with SMTP id adf61e73a8af0-215abb4fd86mr19752252637.1.1747085702206; Mon, 12
 May 2025 14:35:02 -0700 (PDT)
Date: Mon, 12 May 2025 14:35:00 -0700
In-Reply-To: <20250313203702.575156-18-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-18-jon@nutanix.com>
Message-ID: <aCJphDlQLyWri9kR@google.com>
Subject: Re: [RFC PATCH 17/18] KVM: VMX: Allow MBEC with EVMCS
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 13, 2025, Jon Kohler wrote:
> Extend EVMCS1_SUPPORTED_2NDEXEC to understand MBEC enablement,
> otherwise presenting both EVMCS and MBEC at the same time will disable
> MBEC presentation into the guest.

A brief rundown on any relevant history of eVMCS support for MBEC would be
appreciated, if there is any.
 
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> 
> ---
>  arch/x86/kvm/vmx/hyperv.c       | 5 ++++-
>  arch/x86/kvm/vmx/hyperv_evmcs.h | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
> index fab6a1ad98dc..941a29c9e667 100644
> --- a/arch/x86/kvm/vmx/hyperv.c
> +++ b/arch/x86/kvm/vmx/hyperv.c
> @@ -138,7 +138,10 @@ void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *
>  		ctl_high &= evmcs_get_supported_ctls(EVMCS_EXEC_CTRL);
>  		break;
>  	case MSR_IA32_VMX_PROCBASED_CTLS2:
> -		ctl_high &= evmcs_get_supported_ctls(EVMCS_2NDEXEC);
> +		supported_ctrls = evmcs_get_supported_ctls(EVMCS_2NDEXEC);
> +		if (!vcpu->arch.pt_guest_exec_control)
> +			supported_ctrls &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;

No idea what you're trying to do, but I don't see how this is necessary in any
capacity.

> +		ctl_high &= supported_ctrls;
>  		break;
>  	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
>  	case MSR_IA32_VMX_PINBASED_CTLS:
> diff --git a/arch/x86/kvm/vmx/hyperv_evmcs.h b/arch/x86/kvm/vmx/hyperv_evmcs.h
> index a543fccfc574..930429f376f9 100644
> --- a/arch/x86/kvm/vmx/hyperv_evmcs.h
> +++ b/arch/x86/kvm/vmx/hyperv_evmcs.h
> @@ -87,6 +87,7 @@
>  	 SECONDARY_EXEC_PT_CONCEAL_VMX |				\
>  	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
>  	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
> +	 SECONDARY_EXEC_MODE_BASED_EPT_EXEC |				\
>  	 SECONDARY_EXEC_ENCLS_EXITING)
>  
>  #define EVMCS1_SUPPORTED_3RDEXEC (0ULL)
> -- 
> 2.43.0
> 

