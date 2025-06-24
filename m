Return-Path: <kvm+bounces-50513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C768AAE6B42
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 17:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 305054A6303
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 15:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4ECD2E3394;
	Tue, 24 Jun 2025 15:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GbulfpFz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F2E2E2EFC
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 15:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750778410; cv=none; b=QoFE/tj5wE+ZUZlZ0wkYDbXrPIPP9k/PVI3A34i99Ua1ltGvOnm0+D3J497K4mDY0hok8jZm3/bWZvbxsvKBHN5cp0SwM8Jx84EtU9y3Wh9awz1cCSaMODW987+eqhkyzZlAYY3Hm5d3CzjRBVpomaNeyNv2YCOAWznAxjHbIiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750778410; c=relaxed/simple;
	bh=Vm3A6wHZ/yoyBgE0EAf83UZWXKbrAMUvq94GaHakSHk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aTarPWHXowbPFFQ8zD5mbYRIy64HjUQorRcsFv1q1HSWR6ETJNz3AvK3O5AUdNwRXBYjFuSic4qcRcpO3AAs+yu77XjjlSoY2cwnSciM6s5MS1+/kCGYAqohyOphgoHf7GdTexLXEK/miC8zMfQWTJjgpF4mfP3wRW/0G4z6OPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GbulfpFz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-315af0857f2so3025232a91.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 08:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750778409; x=1751383209; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vGRfoH9LdFtGM39WnIuEZlC9+8YFZhcusYM4kwtNz9g=;
        b=GbulfpFzVniqykzkj1T0Fwd4FIgupk9wVLQnjO1XZ0dHCI4paq6IWRzII0f4ADdtF6
         Vw5y8dzKjjy5hfkHoHo/Oraknp1ykeYbxZTOebR9g46Lx558voUmyyYhTQbj2WLOagRT
         2kw4zB5oXCKgahHLvdxVjVIPZhbRXF51t8MJxwARH8QNczaTsF+Hn+ghw03huk1j6mkb
         eXOyi88F59ApYjVABVDA/HEIUaQ9VN1cm2/UimCsVwwd3p3rnBXXFnjc+ryV0rwA0B1Y
         xz9nYsxjbeARbmbpa5Tn3xUwG63t0yutOK6hnrqWrpX5BWQNVRGm3P5yUOJH/UmHv5Px
         JLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750778409; x=1751383209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vGRfoH9LdFtGM39WnIuEZlC9+8YFZhcusYM4kwtNz9g=;
        b=ic7+oBUxMXwBmfVoF0ioUnoE79gRPnbOxIc+chRRJtkSmiUYx0sKVkna2dYnQZd74u
         DrZ5emRRNoe1wdC3gXXzkI3MCqF8YBSjuGabD+lGxd8VEbeOIUZNRQTCZbVZ1jLwsLiX
         Gb8XHKra6lI1b+YEbxM2aWeYVuXvp0g9pQKX9PAsWUfVqaSEcyxem9eJA3NyBCaa8YeK
         kJfaI82PFnNvk+rvyLd5UA25jKTm1ICbqRqYvdNKfevltWs/QouJkIeZAy+FpENgQJjB
         MiNYfWDt/5Y5FEfaDx22QH39LQqe1ygHObuuiIDp86URdg6vgU+u0Ix7XHllZeODMNUm
         cT5w==
X-Forwarded-Encrypted: i=1; AJvYcCVFB3+bmxZY92YmfkJ3YW4mEObZQhK5b8PAH6KyffA54R/j/tjzZLrORYwe2Ym/qFJmpO4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzItTBEEVPw4B1ALS2Zt8LzkvsYVaEuUiJ7ME6bmDnbzSpGlPjM
	UWZDQU6CeKocZ4cqntOlY02fi7U33RFhPnqtW99/MIRCqVhT8UQF6ZxulaGRb1Jot2lX58+O1VV
	xJgCzyA==
X-Google-Smtp-Source: AGHT+IGY1sNiClwBZTcmK97/eMChbdF+koURDQ4b/nqndAH0Pf6+wiOIfdVBF86RlKu8osKt9rWO6gJhKmc=
X-Received: from pjn14.prod.google.com ([2002:a17:90b:570e:b0:30a:7da4:f075])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c11:b0:312:26d9:d5b4
 with SMTP id 98e67ed59e1d1-3159d8c7e55mr28632166a91.17.1750778408771; Tue, 24
 Jun 2025 08:20:08 -0700 (PDT)
Date: Tue, 24 Jun 2025 08:20:07 -0700
In-Reply-To: <20250328171205.2029296-4-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328171205.2029296-1-xin@zytor.com> <20250328171205.2029296-4-xin@zytor.com>
Message-ID: <aFrCJzodXP0sT6Ny@google.com>
Subject: Re: [PATCH v4 03/19] KVM: VMX: Disable FRED if FRED consistency
 checks fail
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, andrew.cooper3@citrix.com, luto@kernel.org, 
	peterz@infradead.org, chao.gao@intel.com, xin3.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 28, 2025, Xin Li (Intel) wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Do not virtualize FRED if FRED consistency checks fail.
> 
> Either on broken hardware, or when run KVM on top of another hypervisor
> before the underlying hypervisor implements nested FRED correctly.
> 
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> ---
> 
> Change in v4:
> * Call out the reason why not check FRED VM-exit controls in
>   cpu_has_vmx_fred() (Chao Gao).
> ---
>  arch/x86/kvm/vmx/capabilities.h | 11 +++++++++++
>  arch/x86/kvm/vmx/vmx.c          |  3 +++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index b2aefee59395..b4f49a4690ca 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -400,6 +400,17 @@ static inline bool vmx_pebs_supported(void)
>  	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
>  }
>  
> +static inline bool cpu_has_vmx_fred(void)
> +{
> +	/*
> +	 * setup_vmcs_config() guarantees FRED VM-entry/exit controls
> +	 * are either all set or none.  So, no need to check FRED VM-exit
> +	 * controls.
> +	 */
> +	return cpu_feature_enabled(X86_FEATURE_FRED) &&

Drop the cpu_feature_enabled().  These helpers are all about checking raw CPU
support; whether or not the kernel is configured to support FRED is irrelevant.

[For these helpers; KVM obviously needs to account for FRED support in other
 paths, but that should be automagically handled by kvm_set_cpu_caps()]


> +		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_FRED);
> +}
> +
>  static inline bool cpu_has_notify_vmexit(void)
>  {
>  	return vmcs_config.cpu_based_2nd_exec_ctrl &
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e38545d0dd17..ab84939ace96 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8052,6 +8052,9 @@ static __init void vmx_set_cpu_caps(void)
>  		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
>  	}
>  
> +	if (!cpu_has_vmx_fred())
> +		kvm_cpu_cap_clear(X86_FEATURE_FRED);
> +
>  	if (!enable_pmu)
>  		kvm_cpu_cap_clear(X86_FEATURE_PDCM);
>  	kvm_caps.supported_perf_cap = vmx_get_perf_capabilities();
> -- 
> 2.48.1
> 

