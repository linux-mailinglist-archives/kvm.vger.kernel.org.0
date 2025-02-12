Return-Path: <kvm+bounces-37936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0ABEA31B0A
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 02:10:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2387C1882A2C
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 01:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B962BD10;
	Wed, 12 Feb 2025 01:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yf3ZvrUF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF8F70830
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 01:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739322624; cv=none; b=ruIkg4YAciEq4MB8+IRa70CP/AURjIA0LfEKjdFRUmaIa1wOnX8JkCKBBsyM0k0Sk8t0t1K6Ml7ThYJLaH/E3duj/fG/hfHRHgwQskO+TmrNfVz9tetJ2bYbsPYR6mmwemkLIDVg1rucz26Svi2hpsl9Pjmnaz4REyWiG2D3Zbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739322624; c=relaxed/simple;
	bh=9vJ4sbWF+PvjO3c2ACDsNgfCbn3xFzNcXSQ9Mo1urFU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=haO4aPFL1bGaBFrcdFhoRufkiKWBN1SWLE5zua/SBMph8pu6o4Diq8gpubt0wnv9v7VzChzAV/hq09yB6qfkPsOdMfy3nAzdznfzjlfSxj+FlcawGlykX3dQmFe3eV1OYFn+ofzD5f15XJgEJz0/vIqTmTdefUFn/xlu79C+kIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yf3ZvrUF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fa228b4151so9977783a91.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 17:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739322622; x=1739927422; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h08LK4Aw2kCEKBhMPsRVmDrIjpqBjo9rcxaPnLKFHYA=;
        b=yf3ZvrUFrBT+J6DmQNQKt/6+XWFgyXzXztKggHuUBtq16LH2Xy3d37AeWtqT7r4byq
         a6pXozrPOdo8NpNscUjhkm0UuB94vE1fP9C7vhjB/trVvbyw4Kxox18ijgVc9wf7acux
         LPa6lXeZvD7Jo1jvjDSCuD0/O0VSbuR3zWIJE1PGnWi1kywTIqwNWsWJbKiLZpQ5v+Rs
         U0r5ZxKKHOs0SOMQ332qhHWGi1ezJHgjaYEYbUbVtcb+pv8o0yc8igqHGpcGIvHwG+UE
         cgrSqu3ShCQMqccNvN34en1Jiz1AWIh5/60TufX9qSvX194jKbyTouMhy2dbiGjlJxJp
         mllQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739322622; x=1739927422;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h08LK4Aw2kCEKBhMPsRVmDrIjpqBjo9rcxaPnLKFHYA=;
        b=TWRy2XGusX5i/FD+6/3mXa9nY1RFVhy7WaKm5DzI6jOsZY4wt5gBAlDqTvrEAP05x2
         UGlJ08GhPg/ZvZio8UGL6amWZG3d+r7FHVES6mvEUh0nVqTPv/tEhX4vBCEZZXK+nEPr
         CbfCMJYFBXUEn2Jo0BL0Bym3Pn0KdzHW40PSjsYYFHePmcF3G0jmhxx0Sgv/2q3WAyHp
         7XL7Qf8MvZFMK1py2R7WwQOm7pnPP8WW9evVghHN5JVRqg8+kigWDzAXSNpjOuEV+Iy8
         qc2lKjYreDOrpH0o0j5gupRI3sN9VPMB/4ew8QoyOMA2KhmyHOm88l+vwZUmZXRkrkiG
         cpUw==
X-Forwarded-Encrypted: i=1; AJvYcCUeoYN966CoxYjEU0tDo6EtxdVNhM/1KCB9wZZpoZ1eE/wvwBRM4uwyBLfaQ0Oq+rRkPj0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYz2ONGy5p4k5hsOhn8Ctyi4yBTUYJMlMimTDLcHQS0YO6zRHB
	J9BTIlj9S0+RJvjQ0Y2pRCWVjQl+mOXBLxSjOZz3GcfxVmAX7Mpmgx42/UZ4rjUgmDo8Q4QPywH
	iag==
X-Google-Smtp-Source: AGHT+IEISPNYjG0xgJVOU8QVq8eZ0AO8yNIMPE4WoCjZxZ1VZrgAar7sOFudeq3k15pkUTILuvWcNQJNFis=
X-Received: from pjg15.prod.google.com ([2002:a17:90b:3f4f:b0:2ef:786a:1835])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f0f:b0:2f8:b2c:5ef3
 with SMTP id 98e67ed59e1d1-2fbf5c0d99bmr2197992a91.14.1739322622587; Tue, 11
 Feb 2025 17:10:22 -0800 (PST)
Date: Tue, 11 Feb 2025 17:10:21 -0800
In-Reply-To: <20250211025828.3072076-16-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com> <20250211025828.3072076-16-binbin.wu@linux.intel.com>
Message-ID: <Z6v0_ZzleQWsw2_k@google.com>
Subject: Re: [PATCH v2 15/17] KVM: VMX: Add a helper for NMI handling
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@intel.com, isaku.yamahata@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 11, 2025, Binbin Wu wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 012649688e46..228a7e51b6a5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7212,6 +7212,20 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +noinstr void vmx_handle_nmi(struct kvm_vcpu *vcpu)
> +{
> +	if ((u16)vmx_get_exit_reason(vcpu).basic != EXIT_REASON_EXCEPTION_NMI ||
> +		!is_nmi(vmx_get_intr_info(vcpu)))

Align indentation.

> +		return;
> +
> +	kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
> +	if (cpu_feature_enabled(X86_FEATURE_FRED))
> +		fred_entry_from_kvm(EVENT_TYPE_NMI, NMI_VECTOR);
> +	else
> +		vmx_do_nmi_irqoff();
> +	kvm_after_interrupt(vcpu);
> +}

