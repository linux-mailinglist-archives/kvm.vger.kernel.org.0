Return-Path: <kvm+bounces-46748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 04782AB9381
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 03:10:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1D047B21CD
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 01:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 871ED215F52;
	Fri, 16 May 2025 01:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HgZBkbvX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4D6214A60
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 01:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747357820; cv=none; b=PwuVmnQUgs1h/IBRz/YwPyWxyqxEnMaurhsWWLGHbXGYJnTtvec5UKLMsaR+rEy+HFq1JEqBWw93VrDyNUQBaS8UgzgdUJAy5MfIFSzkCZIORZNqTtYYcgnVa2KknTRoXYIqY/H9QVYsQ5q3L+QOiIA1jp4SsCR8PMwt8vaX2bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747357820; c=relaxed/simple;
	bh=4OvX/SlIoZzCJCssk73J7YDq+IVGREhHUKEp5bnG8Fg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bVdh9H6QX2bJmGyWviFFe9hAjASpcDI0Pa0tmcKC1yvg+KSFq2axa7JmdAU0BCbrFFRX9iL+x5tIlnUqg3EVfviXNe0V/I4UUtgjH3cea8mBXYyYyACT6b5f+N9WN8jBIso0FRQ5SRZumv92q2mdrmRMyKeLO4+3Es3TQmdr0Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HgZBkbvX; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-73bfc657aefso1138103b3a.1
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 18:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747357818; x=1747962618; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BfYmymD4WqB6RcT+A7NSAJ3/ssCfFT/DbabI8Oq16WQ=;
        b=HgZBkbvXJBPZluMOUSlmAFz96Q7nBfMxQvCen6quVQ/3J7BJhWnm1toiw1CauxFFTU
         GQWihV2/GoUfsBszNsw+JxDrb9axKkX+eSN3CeH7P9l5Q2n0ypjbRWLPEPpP/MpQU889
         qtnCejcZaVOXJQjoZ4CXZQitVsNBQYHkdGv4ccMHwjaa4bWxvNG/rn9BakXXhRRPxIRV
         0zXw2oMYCLNFO+tHcAGdk5etFcouSglCCRK4VMjgiC2tZeZedOzDuNj9ie3vtboWm5FR
         Kv8C1QWccpkOveapivAg0kdO03mrVdkj5/TULUpv1ZPYqW8UCXIrme3VTO27VcCphcRC
         //Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747357818; x=1747962618;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BfYmymD4WqB6RcT+A7NSAJ3/ssCfFT/DbabI8Oq16WQ=;
        b=iZLUyv8vEtCbY2SfQZ6Rhbcq72GpOBvKAHv50PkW2I8jrH5+EP9+aLl9aB9yC0+XAd
         SaDBXrWqWgcZBWsMNfUgpZ5J7Xh5YZGb2Nv9OrkTK2D7XV3K1Kk9nXrxqw6KI43Pgd06
         EpBS5+xGwuprCYkQLd6BFqpM3TKw9qMPDXz9k4H4Lpc/mqAtqgO5NDmhejOei14/wspe
         Vhwpxr4smC4jzXFA2jw8Tv1B3r7mqjE7mBENo8SZ1YWMLvFae8+Wdtrfta2lxco1ob+J
         AFNfTLOY+Wco0cW1SnbthqEt1C/qGA9LF+kz7V5T2j3cgsCQmevTacN0FA7T+HBeMTiQ
         hfQw==
X-Forwarded-Encrypted: i=1; AJvYcCXZuYU+j3La4ZJC3Mn9TvCdjPom4M+/ipXIqrFDRSLmJshRycIW21q/Flxko16+FxTtN3U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuVs0rn6wfc8SJrowfIC0bM75RwOkAA5WIEMQcxs1n50pnSTNo
	Qy5RzWnJM1tZncEQ5gsvb81LVxmjy8aFFAHLD1zP546C7EEAM66RYctYv0HXcebjtp8qYr7zsg8
	CJm3gRg==
X-Google-Smtp-Source: AGHT+IFN6q5EEUT8mtkOVvJbhI1LPbC36AWs5ckYgMuXXlLBYgP2Ku77QbL5NxcjQXJ1Z0V89/x/Blxa6lU=
X-Received: from pfblr19.prod.google.com ([2002:a05:6a00:7393:b0:742:9ac3:9e04])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e89:b0:215:d4be:b0b2
 with SMTP id adf61e73a8af0-21621a02357mr2171784637.34.1747357818528; Thu, 15
 May 2025 18:10:18 -0700 (PDT)
Date: Thu, 15 May 2025 18:10:17 -0700
In-Reply-To: <20250324173121.1275209-31-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com> <20250324173121.1275209-31-mizhang@google.com>
Message-ID: <aCaQedEhZwj9BsVK@google.com>
Subject: Re: [PATCH v4 30/38] KVM: x86/pmu: Handle emulated instruction for
 mediated vPMU
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
>  static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
>  {
> -	pmc->emulated_counter++;
> -	kvm_pmu_request_counter_reprogram(pmc);
> +	struct kvm_vcpu *vcpu = pmc->vcpu;
> +
> +	/*
> +	 * For perf-based PMUs, accumulate software-emulated events separately
> +	 * from pmc->counter, as pmc->counter is offset by the count of the
> +	 * associated perf event. Request reprogramming, which will consult
> +	 * both emulated and hardware-generated events to detect overflow.
> +	 */
> +	if (!kvm_mediated_pmu_enabled(vcpu)) {
> +		pmc->emulated_counter++;
> +		kvm_pmu_request_counter_reprogram(pmc);
> +		return;
> +	}
> +
> +	/*
> +	 * For mediated PMUs, pmc->counter is updated when the vCPU's PMU is
> +	 * put, and will be loaded into hardware when the PMU is loaded. Simply
> +	 * increment the counter and signal overflow if it wraps to zero.
> +	 */
> +	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
> +	if (!pmc->counter) {

Ugh, this is broken for the fastpath.  If kvm_skip_emulated_instruction() is
invoked by handle_fastpath_set_msr_irqoff() or handle_fastpath_hlt(), KVM may
consume stale information (GLOBAL_CTRL, GLOBAL_STATUS and PMCs), and even if KVM
gets lucky and those are all fresh, the PMC and GLOBAL_STATUS changes won't be
propagated back to hardware.

The best idea I have is to track whether or not the guest may be counting branches
and/or instruction based on eventsels, and then bail from fastpaths that need to
skip instructions.  That flag would also be useful to further optimize
kvm_pmu_trigger_event().

> +		pmc_to_pmu(pmc)->global_status |= BIT_ULL(pmc->idx);
> +		if (pmc_pmi_enabled(pmc))
> +			kvm_make_request(KVM_REQ_PMI, vcpu);
> +	}
>  }
>  
>  static inline bool cpl_is_matched(struct kvm_pmc *pmc)
> -- 
> 2.49.0.395.g12beb8f557-goog
> 

