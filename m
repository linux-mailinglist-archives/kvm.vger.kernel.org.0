Return-Path: <kvm+bounces-46806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 450C2AB9D9E
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 15:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C92AB4E51F5
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 13:35:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 702B278F49;
	Fri, 16 May 2025 13:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XCZwYujY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4686560B8A
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 13:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402546; cv=none; b=o2RAod/gYThDwwtPutB0XtpE03h6Ucco/J2yGU8ma+SO1i8VyEJHoGqmPVEJAzkmCryczocyYVD5blBkkKui15EAAbO1v1HhBy2hlKprWCYyWOqOaFj3eXxFYRPgOQm6f5OpzA2J35ggPKr1ntreGedDisxtuoh7W7PiTw4D03c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402546; c=relaxed/simple;
	bh=mbNJO6rbhRMwuIoVTU8ZDSG2mOIuj9eAx47BnBtUGTw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=row8toJT/HqLQze+yl3wNASY12dHZbXVCmWSFXEFBctOSQLq01qztdGtdgHlZ3WZcmV4rt+vWG+BHUVqUTMF5miA44055cXQS3owQlcrQgLHpozFqP8pD9ac21VX9+FmO6HCj0etTdFOOiOvd6ARkTKDyN5UG2oR441vZJAw9XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XCZwYujY; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22e816139b8so18630875ad.3
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 06:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402544; x=1748007344; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LnEPS5xIYcZ/9QBFlM2YvgXWlEvCitmvF/+QPuGAd2E=;
        b=XCZwYujYQfYJsx/wj/myE0yvEc3xR3IA8lSVucuBObUMrXF0cIxgmbGCIv0rkbooja
         xSeje9BnYXphJu5V8YW6g3C+pEvb9XPeeRzWczYqzkNtme49LMmGawLHABx5QNK2Kzur
         TLzRs5MURdmLNJ3sDfhFVD+RIIg1TgxHKgbhMKfcvQyycJvB/G5/0dADnJiOugPh45gH
         srDS0nC447YKE2NFgChNM9iNTe34/ArNk43WTAkuB03R8jFIL7yOgef67XMZUUaTaNLt
         nNEr4dE+N7eyVAcFYZxfCJImugtEfmd4CtbLkmBbZAYaDOHz+Qok1Fhu3poTvbDrxmqQ
         ZXkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402544; x=1748007344;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LnEPS5xIYcZ/9QBFlM2YvgXWlEvCitmvF/+QPuGAd2E=;
        b=XWOTcmu3UKyjca0VxV4VQBR1Kiayt8LYMbz3/pVqVX0O8jMI6vAbTIYIhnTE26pZig
         Yh2MszHrSol0s0LikkOiz5EcvkDT7AipC/qoN7+DOUVUWbFGNP1lBgcWXAGdhfYu1faC
         9E88TpAFJ/vx7vfTciUmz4Dhvp970UWtXM6Kx41JJ/lwPFaBzfmCQGZ6C/jCT3sOyMAm
         iNSb4te2XnaBnc+edAAvdcSencEyplrvSzMdme8k10POWcZHuUs15lwhHWXULmhpToAf
         0jhAMeM5lE5tpDQ1uyAUEYmwTJBs6nUGFAKzbjE5qmA6Lfzm3dQu5yrL0w1P54Mnys3X
         5oig==
X-Forwarded-Encrypted: i=1; AJvYcCVoHL11J/zlghgWvxnnoLs9cNNFCTphJnAA7DMx2egYHZOrCCXdu6i2p2+a0lIKO3TWrT4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzdh4oY9bTxmQkEFXLXfeJmq6sG+yw8hCqXvRKI0vavCTFtT4hV
	OczTWYrvyuRx5BZZaOVRHV+wU1fm1mfdnCi88Nkh0SstH2NDf7NNQN818mgKUWWwfVS7FXqITYk
	MjZcVZw==
X-Google-Smtp-Source: AGHT+IGYPJLPbPNyk9fQYDfhkPqOAQlx8+ac872IbMGJ++7mqndtzn4UY6HAjcLA0ay95SrGo+cLkFm5AkA=
X-Received: from plblm14.prod.google.com ([2002:a17:903:298e:b0:220:ca3c:96bc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1ca:b0:221:78a1:27fb
 with SMTP id d9443c01a7336-231d438a223mr46909995ad.11.1747402544334; Fri, 16
 May 2025 06:35:44 -0700 (PDT)
Date: Fri, 16 May 2025 06:35:42 -0700
In-Reply-To: <20250324173121.1275209-25-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com> <20250324173121.1275209-25-mizhang@google.com>
Message-ID: <aCc_LmORNibXBt8V@google.com>
Subject: Re: [PATCH v4 24/38] KVM: x86/pmu: Exclude PMU MSRs in vmx_get_passthrough_msr_slot()
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yongwei Ma <yongwei.ma@intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Sandipan Das <sandipan.das@amd.com>, Zide Chen <zide.chen@intel.com>, 
	Eranian Stephane <eranian@google.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 24, 2025, Mingwei Zhang wrote:
> Reject PMU MSRs interception explicitly in
> vmx_get_passthrough_msr_slot() since interception of PMU MSRs are
> specially handled in intel_passthrough_pmu_msrs().
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 38ecf3c116bd..7bb16bed08da 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -165,7 +165,7 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
>  
>  /*
>   * List of MSRs that can be directly passed to the guest.
> - * In addition to these x2apic, PT and LBR MSRs are handled specially.
> + * In addition to these x2apic, PMU, PT and LBR MSRs are handled specially.
>   */
>  static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
>  	MSR_IA32_SPEC_CTRL,
> @@ -691,6 +691,16 @@ static int vmx_get_passthrough_msr_slot(u32 msr)
>  	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
>  	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>  		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
> +	case MSR_IA32_PMC0 ...
> +		MSR_IA32_PMC0 + KVM_MAX_NR_GP_COUNTERS - 1:
> +	case MSR_IA32_PERFCTR0 ...
> +		MSR_IA32_PERFCTR0 + KVM_MAX_NR_GP_COUNTERS - 1:
> +	case MSR_CORE_PERF_FIXED_CTR0 ...
> +		MSR_CORE_PERF_FIXED_CTR0 + KVM_MAX_NR_FIXED_COUNTERS - 1:
> +	case MSR_CORE_PERF_GLOBAL_STATUS:
> +	case MSR_CORE_PERF_GLOBAL_CTRL:
> +	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> +		/* PMU MSRs. These are handled in intel_passthrough_pmu_msrs() */
>  		return -ENOENT;
>  	}

This belongs in the patch that configures interception.  A better split would be
to have an Intel patch and an AMD patch, not three patches with logic splattered
all over.

