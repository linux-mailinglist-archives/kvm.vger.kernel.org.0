Return-Path: <kvm+bounces-13286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D9C689445B
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 19:34:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 056492828A9
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 17:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2808C4D9E7;
	Mon,  1 Apr 2024 17:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BczwT7Hn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88FD481C6
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 17:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711992849; cv=none; b=FBrkoYSkjnfh2j9bsVE4FaVNn5JxEvuFsGjfAsoP90TLws50xuXPMvs+y8cFgGDfSYmoiqDPMxlTiqIZJ2+07g3poUvijhkii0dKRmej/hALl32+boE9Ur6asapAq53tEW/d7/HAMNnv0oJL4//Mv8sRoXWj1EO1BAPpJDAJU9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711992849; c=relaxed/simple;
	bh=P4VMtLD4MHQgQLa7fxwFwhu8Q+SccpMgs9qoMDxtil4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CjcigHg9c630zI/Pg8Pqs+joDNlrE3I5gwAAFE0Wjzkk9Qirh3XR/cqMBEMjWwj940Rh6z4ceA9I79UgS4OGTifqADSGvcosTmoS9JfZ3FBJJDSgF9pKNzr8VegUmCZCufL63GL9o5YbmwxCOPHPUbLAeEZkYT6VR8zWHWQVOqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BczwT7Hn; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cec090b2bdso3246248a12.0
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 10:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711992847; x=1712597647; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ch/Hd2ZyPY0fv17bf1ptjyL1HSJoGGPmHR088ksWFts=;
        b=BczwT7HnA1xw1O2Yy2Yai9lHkpkYYxcRRJ9eSWTtYBsyiNBjNDQlRckBwPn1ectjIt
         VWl9BTQHAE9PIlhggzOTv0Y31a+ESA6UcWQ85m49udCHsbdt3y4KSG13pf8kRV8qq7Yc
         qCNaTWZ3wmFreEh5yDC/T2y0/ksUx//Q7fupv88oFgYat5SRn5EutUDNQQTNKyj4p+WM
         CnykXBUjmws1hBO7Wt8jWeH/ulxbuRVdvoM4/B5dSTubbWPE1wKRDWIXb1Jfh1GkLkLQ
         pHm8SY76drNadIO67iidM+FymNNkitQ8ZURGugR/b0TRv+n7BmHzawTzLCxMyJmVSQSU
         mTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711992847; x=1712597647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ch/Hd2ZyPY0fv17bf1ptjyL1HSJoGGPmHR088ksWFts=;
        b=SFBPqAEqfMB6lWLF9epCNkDjwpJ7dJkdVGvPDhu1iBBHvsw+E3MTCq8JialOINr6MJ
         Kbqh0osCVxjzibXdvVzXPKJ/kz8CUaRCkyJo3sIorkW5q61oDZexqXL0I1e5oEuYm1Z0
         cDdzr+5tZFGZ7Z1TC/JnSa9H9p0KLEIGDPoBjRRPsPlzwma2JjIXx7HGWmCV7M4bjCDf
         kV7JFVyM0fLQw0fel/RqVGTQCIK0+eNL2jVqZi3aE2FFJ+YKUHty9hLQXLuFKIC9hw0J
         iaEUD1SecTKuGp6ZBwMAfaxhYCEW/cGzxVEN1gYJWARHvmSnCf3aBqHg60e9LTN9qs2B
         8wdQ==
X-Gm-Message-State: AOJu0YzwGpLYqZ44X0a0ZjMeFpngor3JApRDxM9FGmIbchu542g6esko
	CA6uhiRPZgkcgqiNzQDwzVr9IIkhIDCAZF2pLarPjSjLeT2JCMOGl9mA1+m68Dc14ypUHO8ZkVW
	H2w==
X-Google-Smtp-Source: AGHT+IGN40QhdZywCAMmYIpCJSDnW75wbQIV30jvYzzQS19jN2VTfhaV3xqPIcLIKqx/+82Q0XxO/xdU+O0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:5245:0:b0:5ce:474:352b with SMTP id
 q5-20020a655245000000b005ce0474352bmr28223pgp.5.1711992847055; Mon, 01 Apr
 2024 10:34:07 -0700 (PDT)
Date: Mon, 1 Apr 2024 10:34:05 -0700
In-Reply-To: <f6a80dd212e8c3fd14b40049eed33187008cf35a.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com> <f6a80dd212e8c3fd14b40049eed33187008cf35a.1708933498.git.isaku.yamahata@intel.com>
Message-ID: <ZgrwDbZLFqiyS_5e@google.com>
Subject: Re: [PATCH v19 069/130] KVM: TDX: Require TDP MMU and mmio caching
 for TDX
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> As TDP MMU is becoming main stream than the legacy MMU, the legacy MMU
> support for TDX isn't implemented.  TDX requires KVM mmio caching.  Disable
> TDX support when TDP MMU or mmio caching aren't supported.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c  |  1 +
>  arch/x86/kvm/vmx/main.c | 13 +++++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0e0321ad9ca2..b8d6ce02e66d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -104,6 +104,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
>   * If the hardware supports that we don't need to do shadow paging.
>   */
>  bool tdp_enabled = false;
> +EXPORT_SYMBOL_GPL(tdp_enabled);

I haven't looked at the rest of the series, but this should be unnecessary.  Just
use enable_ept.  Ah, the code is wrong.

>  static bool __ro_after_init tdp_mmu_allowed;
>  
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 076a471d9aea..54df6653193e 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -3,6 +3,7 @@
>  
>  #include "x86_ops.h"
>  #include "vmx.h"
> +#include "mmu.h"
>  #include "nested.h"
>  #include "pmu.h"
>  #include "tdx.h"
> @@ -36,6 +37,18 @@ static __init int vt_hardware_setup(void)
>  	if (ret)
>  		return ret;
>  
> +	/* TDX requires KVM TDP MMU. */

This is a useless comment (assuming the code is correctly written), it's quite
obvious from:

	if (!tdp_mmu_enabled)
		enable_tdx = false;

that the TDP MMU is required.  Explaining *why* could be useful, but I'd probably
just omit a comment.  In the not too distant future, it will likely be common
knowledge that the shadow MMU doesn't support newfangled features, and it _should_
be very easy for someone to get the info from the changelog.

> +	if (enable_tdx && !tdp_enabled) {

tdp_enabled can be true without the TDP MMU, you want tdp_mmu_enabled.

> +		enable_tdx = false;
> +		pr_warn_ratelimited("TDX requires TDP MMU.  Please enable TDP MMU for TDX.\n");

Drop the pr_warn(), TDX will presumably be on by default at some point, I don't
want to get spam every time I test with TDP disabled.

Also, ratelimiting this code is pointless (as is _once()), it should only ever
be called once per module module, and the limiting/once protections are tied to
the module, i.e. effectively get reset when a module is reloaded.

> +	}
> +
> +	/* TDX requires MMIO caching. */
> +	if (enable_tdx && !enable_mmio_caching) {
> +		enable_tdx = false;
> +		pr_warn_ratelimited("TDX requires mmio caching.  Please enable mmio caching for TDX.\n");

Same comments here.

> +	}
> +
>  	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);

All of the above code belongs in tdx_hardware_setup(), especially since you need
tdp_mmu_enabled, not enable_ept.

>  	if (enable_tdx)
>  		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
> -- 
> 2.25.1
> 

