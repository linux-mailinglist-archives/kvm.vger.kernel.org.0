Return-Path: <kvm+bounces-14354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74E8D8A218D
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 00:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4ED31C23E10
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 22:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 068E83D393;
	Thu, 11 Apr 2024 22:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mTapYdtW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AA93F9C5
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 22:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712873002; cv=none; b=aILTW555JuyKNFDZPdTpu/MEr1QD+zFro+Q7VupMmDjzQOX3FqFL0Rv+zovXSKdsuDCHWPitsva5FJJyAsXYEdO8S9ZgHj76fk49w/5HBPx4L7Mvr3JoiBVBbYsWKF+Uee55KOEZj9BMQS5QT0MpiexJCYf4qKUYDFUVIw7jRG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712873002; c=relaxed/simple;
	bh=r3S1D7D1d5u7lgkAMt1Th9wNRtELr7qcxpz5RqhzGs0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T1CaK9NIgnXecq68E6fXacpQtdiLI3+AlOT/cA+5kpXtwcMlCNRCmr38S7OeKhwzYtCqIYAnT53SswLnWrixP95+1pcoi2Fl6r8Zf/LRVT4w+YjiTC0EHkgkxQ+BGxBxW11xAAwfFTH5s69QQkaws7BezjA5RiKU9PUC3QNaGcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mTapYdtW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a4b48d7a19so196365a91.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 15:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712872999; x=1713477799; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jmy317IqZY3AD7OCatKfL9RjqB6+hhlcNYc+DoqXhi8=;
        b=mTapYdtWdm3i434LgU4hFhF2wiCjOtJiPIcPZnTVPCRFnPVUrPEwXohKZ2X9vEH+i7
         EywWDGnh6kVMl2a0gwyESAfNzJRTtluJRIwcsFT8/mlL4c/PJ89MjWDt+4H6+Eac1Y4x
         AIVJsyx98fbmt21kVIx/IiDBJVov8pP4IsOhDDhCuyyqa6jpqfuxy0LgUTvFMtAUm8oD
         r10cAB7GOKVjM9ryzXM22X2SEMRJQogHa1YEltDnUK98I2bvd8sq4dO4iGSS6kSWE8ud
         TJbf85zscaPIRaPJoSveYAT2hI3E4HnVbNludHHN+MdRqqwARYPzdMZwM+MSOHk9NBO3
         e/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712872999; x=1713477799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jmy317IqZY3AD7OCatKfL9RjqB6+hhlcNYc+DoqXhi8=;
        b=XZoPOr+nCcn0f6Pj75/StXdEEDMaQAP+CmgG3fg1jbe+QYDvXlGVDScHVa2zPLyhTC
         r/fHbB3RyXTbRLgyfbB1cHu6lYjrpWZ3SNXsrEun+SBE/NvvlcnvfcB5G5IlqI1AGM8K
         XN0tWYByRDANJWGnGb4S/F2YjWmHT8SZrbHOsjarYun83zqJ1RFbDZyz/Xfkpgq4wOfe
         PFg/urbKzbPIL5a53lcndhJUDZy85aG3OYjkrzuot5PxOWKeHhwBMVOQzcF7WC4eKrED
         dHQdiZqMaBeZLp34wMpPEF07sGj8jMBTwgeFbYE/yslANR0ANIjlRN5SEFV7jy57R4Le
         qX8A==
X-Forwarded-Encrypted: i=1; AJvYcCUmSPMLr1jW0m877NnfVJlcuVilEAJFbJ1lflYca3Iht2wlkE4SG9aimDQdIeyHxcTGXOm8sVJ2ergxHcAjU+AjPKnt
X-Gm-Message-State: AOJu0YyzygyhEgP8b+hrIvFaNDggTnKJxTI47gdrS27vp8yyM2JfXhQr
	2NEWx9093avZuObGKGY7LE6Y0dMtrLxa20kkuASZ+6N+o3GW4Y9fdI6sOnrXedVa6wll1geYPbu
	qvQ==
X-Google-Smtp-Source: AGHT+IF9RN5OfQ3beoF3WDDZ3ue3mGb491uf8WF4DGDBox30e34jVKBmA/PdiWN/+r4zc3Csa8hJIU6BeT4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:90:b0:2a6:dbca:b80f with SMTP id
 bb16-20020a17090b009000b002a6dbcab80fmr1287pjb.0.1712872999220; Thu, 11 Apr
 2024 15:03:19 -0700 (PDT)
Date: Thu, 11 Apr 2024 15:03:17 -0700
In-Reply-To: <20240126085444.324918-38-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-38-xiong.y.zhang@linux.intel.com>
Message-ID: <ZhheJUWRhCmmYa_F@google.com>
Subject: Re: [RFC PATCH 37/41] KVM: x86/pmu: Allow writing to fixed counter
 selector if counter is exposed
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Xiong Zhang wrote:
> From: Mingwei Zhang <mizhang@google.com>
> 
> Allow writing to fixed counter selector if counter is exposed. If this
> fixed counter is filtered out, this counter won't be enabled on HW.
> 
> Passthrough PMU implements the context switch at VM Enter/Exit boundary the
> guest value cannot be directly written to HW since the HW PMU is owned by
> the host. Introduce a new field fixed_ctr_ctrl_hw in kvm_pmu to cache the
> guest value.  which will be assigne to HW at PMU context restore.
> 
> Since passthrough PMU intercept writes to fixed counter selector, there is
> no need to read the value at pmu context save, but still clear the fix
> counter ctrl MSR and counters when switching out to host PMU.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/vmx/pmu_intel.c    | 28 ++++++++++++++++++++++++----
>  2 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index fd1c69371dbf..b02688ed74f7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -527,6 +527,7 @@ struct kvm_pmu {
>  	unsigned nr_arch_fixed_counters;
>  	unsigned available_event_types;
>  	u64 fixed_ctr_ctrl;
> +	u64 fixed_ctr_ctrl_hw;
>  	u64 fixed_ctr_ctrl_mask;

Before introduce more fields, can someone please send a patch/series to rename
the _mask fields?  AFAIK, they all should be e.g. fixed_ctr_ctrl_rsvd, or something
to that effect.

Because I think we should avoid reinventing the naming wheel, and use "shadow"
instead of "hw", because KVM developers already know what "shadow" means.  But
"mask" also has very specific meaning for shadowed fields.  That, and "mask" is
a freaking awful name in the first place.

>  	u64 global_ctrl;
>  	u64 global_status;
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 713c2a7c7f07..93cfb86c1292 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -68,6 +68,25 @@ static int fixed_pmc_events[] = {
>  	[2] = PSEUDO_ARCH_REFERENCE_CYCLES,
>  };
>  
> +static void reprogram_fixed_counters_in_passthrough_pmu(struct kvm_pmu *pmu, u64 data)

We need to come up with shorter names, this ain't Java.  :-)  Heh, that can be
another argument for "mediated", it saves three characters.

And somewhat related, kernel style is <scope>_<blah>, i.e.

static void mediated_pmu_reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)

