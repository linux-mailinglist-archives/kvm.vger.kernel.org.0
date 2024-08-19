Return-Path: <kvm+bounces-24544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EB459570A9
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 18:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D9621C20C70
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 16:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40393177998;
	Mon, 19 Aug 2024 16:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Bhfv68Wb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711E21A270
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 16:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724085979; cv=none; b=O1NlvNCO/9NbqV014F4uqgtmdkfYWJMO4Bm+Po3NoT/z1ZQHxuUZNoK+Nzevc0CdGHkNo/fK3OKhokzqQOfwSn8mu0e+YmABrERGFBzyKnL9MaMEZApJ8tazK4a7M2O+PqfsoXqQgMqFhqzxd8PPMHYcJU35FcuuUlrCjqW2f/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724085979; c=relaxed/simple;
	bh=4Zm2aY38wQUKInxgHuMrVp3FTi32iwRINTkf8PLyzIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X44PuhGkLF01N5O9FcDMf4zM5SHVQlhNml1cvzCbkDVfMKZ3i3pXaUo/vO1jJT/vMscIS+9KAE6pnV5fBSfH8wWs13jmO+zINHjkrLyeejAv4IM+YmGIQZ2VIMxSXRLI1p29rhzy9sQ9OsvZkuCLkbUds+tjJ6roa9GBHRwZU6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Bhfv68Wb; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2ef2d96164aso53520061fa.3
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 09:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724085975; x=1724690775; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Z7g9H1uuN368sbZwFL2P/UunOJpGy+71L7MEI5Gqco=;
        b=Bhfv68Wbv9Smj0Llmr2FCqT2yK0fyMG8+cCqauvogxQyMcYGzt/corJd4Awfrt984J
         EwHRlpT4DJ1ZIlmKuowlw11RyrfgDHp+xnVIIpcyxlb6pGb1pof/7e0lhGyxhew9fgol
         B/xQo5kqR4x3AECNUDgzlNVO/TJ+NpL2Nqn8V5RoUCOuYvDzaBLiNHwtc4KQ4Nv5puBE
         s7FdbG9iD8GVxIvB8gbvBhHHff6hRsONYisSoBK9DR4HeRdXVPvQAYP4eAIt8v/4CtUd
         PnzDVtCeFUXlz557ySU1moYc9B5L1G4UKkJH7+GBM3qvVoBRxAp2p5YAUrJfh3yaS20M
         WVrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724085975; x=1724690775;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Z7g9H1uuN368sbZwFL2P/UunOJpGy+71L7MEI5Gqco=;
        b=siJsrde+/hjhzy8lwRCziEwftGx+SFp1AlkixHNepOzKMmTMv0F48xzZIIAllDqd7T
         qJoqi0iI0rae2B/l85PjcLFGHltzm5kkaWbb8UAsXWZtCR5jG8l+gkF6z7rkbD9BDwKt
         E9OTZwdzql2/DeN7xSU+0b5Rzi+peqJC7Hx0MOBoxzvpcmRsFfm0GAHAj/GOh8w+IeZw
         rMtyZlm1q/hCi9NS1TquaUsBp6JfPBIpRBCczVVuJh1xgn4dNhP4FM1a0gjtnfjd+6cx
         C7A2LETioEJ7RXAVTSDcJigAFQtTRVrr4ZyJQS+hXqVl3nL2Mpy8ppA9lSSOEM0C+/uZ
         O+Zw==
X-Forwarded-Encrypted: i=1; AJvYcCWERkcSCZPxhuzXu1farYh2jjpdDjdy0G0YsOX+TkPiQc9xK9lNWc32RWlFK4AdObrpEpmfMQrH8bEMv/4oYHwBT7P6
X-Gm-Message-State: AOJu0Yx8l+pGso28rA3ByBTWdlexKuwxzObHkcd8WzXOqeRbpkztUprY
	vmvHG0kiEZ9Zv2Ot7Kbvq8bwSy52HXyVjeCU15GhFZoTcVqLaEszdxcsHHdIB5Q=
X-Google-Smtp-Source: AGHT+IGuv7SyKEaIn/yQTA5OF0LPxA1KQdVqiDZ65XXA3A41gdwd0QgZ27gUJmx+DBdupjL/FSj4UA==
X-Received: by 2002:a05:651c:544:b0:2f1:a7f8:810f with SMTP id 38308e7fff4ca-2f3be5de18cmr80508331fa.36.1724085975365;
        Mon, 19 Aug 2024 09:46:15 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7717:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7717:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bebbbe29a6sm5772026a12.13.2024.08.19.09.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 09:46:15 -0700 (PDT)
Message-ID: <4fcff880-30e2-44f8-aa45-6444a3eaa398@suse.com>
Date: Mon, 19 Aug 2024 19:46:13 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/25] KVM: TDX: create/free TDX vcpu structure
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-18-rick.p.edgecombe@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <20240812224820.34826-18-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 13.08.24 г. 1:48 ч., Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Implement vcpu related stubs for TDX for create, reset and free.
> 
> For now, create only the features that do not require the TDX SEAMCALL.
> The TDX specific vcpu initialization will be handled by KVM_TDX_INIT_VCPU.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v1:
>   - Dropped unnecessary WARN_ON_ONCE() in tdx_vcpu_create().
>     WARN_ON_ONCE(vcpu->arch.cpuid_entries),
>     WARN_ON_ONCE(vcpu->arch.cpuid_nent)
>   - Use kvm_tdx instead of to_kvm_tdx() in tdx_vcpu_create() (Chao)
> 
> v19:
>   - removed stale comment in tdx_vcpu_create().
> 
> v18:
>   - update commit log to use create instead of allocate because the patch
>     doesn't newly allocate memory for TDX vcpu.
> 
> v16:
>   - Add AMX support as the KVM upstream supports it.
> --
> 2.46.0
> ---
>   arch/x86/kvm/vmx/main.c    | 44 ++++++++++++++++++++++++++++++++++----
>   arch/x86/kvm/vmx/tdx.c     | 41 +++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h | 10 +++++++++
>   arch/x86/kvm/x86.c         |  2 ++
>   4 files changed, 93 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index c079a5b057d8..d40de73d2bd3 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -72,6 +72,42 @@ static void vt_vm_free(struct kvm *kvm)
>   		tdx_vm_free(kvm);
>   }
>   
> +static int vt_vcpu_precreate(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return 0;
> +
> +	return vmx_vcpu_precreate(kvm);
> +}
> +
> +static int vt_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_vcpu_create(vcpu);
> +
> +	return vmx_vcpu_create(vcpu);
> +}
> +
> +static void vt_vcpu_free(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_vcpu_free(vcpu);
> +		return;
> +	}
> +
> +	vmx_vcpu_free(vcpu);
> +}
> +
> +static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_vcpu_reset(vcpu, init_event);
> +		return;
> +	}
> +
> +	vmx_vcpu_reset(vcpu, init_event);
> +}
> +
>   static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	if (!is_td(kvm))
> @@ -108,10 +144,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vm_destroy = vt_vm_destroy,
>   	.vm_free = vt_vm_free,
>   
> -	.vcpu_precreate = vmx_vcpu_precreate,
> -	.vcpu_create = vmx_vcpu_create,
> -	.vcpu_free = vmx_vcpu_free,
> -	.vcpu_reset = vmx_vcpu_reset,
> +	.vcpu_precreate = vt_vcpu_precreate,
> +	.vcpu_create = vt_vcpu_create,
> +	.vcpu_free = vt_vcpu_free,
> +	.vcpu_reset = vt_vcpu_reset,
>   
>   	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
>   	.vcpu_load = vmx_vcpu_load,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 531e87983b90..18738cacbc87 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -377,6 +377,47 @@ int tdx_vm_init(struct kvm *kvm)
>   	return 0;
>   }
>   
> +int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +
> +	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> +	if (!vcpu->arch.apic)
> +		return -EINVAL;

nit: Use kvm_apic_present()

<snip>

