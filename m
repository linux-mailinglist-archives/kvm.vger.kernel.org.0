Return-Path: <kvm+bounces-14341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 321D48A20D9
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7B581F236F8
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E85C3A8D8;
	Thu, 11 Apr 2024 21:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uoU5d5i4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CA23717B
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 21:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712870784; cv=none; b=LSItINM55COw/3Cm2maOPJhCiS1SYmtStCfJaY9G7s/prF7o0nRQC5iPjQ+UVgLhOun0wBpO7zcFOsYZuRMnZqZ/ug80oXGwiJisGRBtAv2vuIv9VdFr2IcYfT/ZvWrtrE1xZOGobdHMTkny4zRz+jKVLp6mYN/fojXcJ80nlrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712870784; c=relaxed/simple;
	bh=wd5HLscLEDiELJ0ZS76nEkXx2Pqd+QH6QZ5/zGGUrh4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jRJFoHJX6GAcatorx1g1a4CiGz6C/8X0ZZHFQ6bJafO6Zd/sA/6/xkbRNFsPu5HVUD9OT2tAYsuN4pFqfaLbQAGHx/xBh0rkkq0g7m5ktXsKtgTtpiGOR0/+lZ1Lod+Ti1eZc06kn+QvIx/mUJznqdhvM3klnx0wPDzmo8sO+Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uoU5d5i4; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61814249649so3440627b3.3
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712870782; x=1713475582; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WdgVI9xUvckPONDhFdSvuL71fgWc1Ta050v5yu5aktg=;
        b=uoU5d5i4dY6iLPoOw4Oao6TjLJvaGIWfMSy9DDt+HsNDtevOF1LQ4FpcavbaFTeuAq
         MrkVWNW/ljMXPlpsJsjydtSmwabSBoRGhAqfNFG4BV0bInSiGtKOzcxEU1z0Pn2613sU
         j3ebtJ8YWfxtZpZVfSwJF2HJnBbrXT8yx49k/MRTyCVKiE/BpI3KseTYclLXjl0liSd3
         QwiEBuQx6qF6BZIvzNTT2Bus+8LZk53uABsJv10BX6W8es/z/eFfwWh1q20ctRjZxyTg
         l8XHOSCQ48ltNROIIcn6eI38W95j4tv/UbPidLWDjRi2sL702aUuiCxgkfucXu3Xxayr
         pECA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712870782; x=1713475582;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WdgVI9xUvckPONDhFdSvuL71fgWc1Ta050v5yu5aktg=;
        b=pm+WDQF36VFlx4YqhSYyKP/KEm69D3CRypob6wLW/Joh7wZcFcp0OzO3eGeireMgLF
         3eji9MSq+vklDZt+n2SSBsC1NweKIHtED7HpbILioVtxoynS/7BmRlKUwwsInJ44iSuN
         VOrRHorVx4yDPtpB3aKbsKloTpxgo4cMT+vKgYVzVMCFc1vUSzfEhJ0rvP987gtrVz/t
         w50z5xxzOox/JLR06a2jA5RDY82+UayvwKXXgD+f2zEQCJiGNt9BIGiDlFg1/BnUTfux
         PesS4E99Q89DTCvdvQYIA4prF86ubP0v3TQqZuJyLjmtw9gO1Iz0cctvace487Cz7YAB
         X/Hg==
X-Forwarded-Encrypted: i=1; AJvYcCW6Bffj+IYBNwNlTChS8fq2TuYQUwOVrT+bCQvCCrG0f5DFWLYTwSkQv+Ecaf6MV0ZpXZ6DXSqS8GxiKu8WpVXaQE31
X-Gm-Message-State: AOJu0YzM3J0cUuafkXfKaneLYsZUc4LfpAd5qg4yrJtT+r7Mh5MHX5q5
	Nq2qEHA5xFAqjTiOWvX1byy3YXxbCgBQG69gZK7bbgFl2VYUytcocIxCB0NbtbUVpZG9dulhbBI
	EwA==
X-Google-Smtp-Source: AGHT+IERLT1fHmu0phRd1Cb5WaKzvHqAUsRSAXNTckY9QqvWHGzZwtnbcyq7lvIqiZ7x8IZjmTkQPM52S+A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ca07:0:b0:615:27b6:7624 with SMTP id
 m7-20020a0dca07000000b0061527b67624mr155166ywd.6.1712870782385; Thu, 11 Apr
 2024 14:26:22 -0700 (PDT)
Date: Thu, 11 Apr 2024 14:26:20 -0700
In-Reply-To: <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
Message-ID: <ZhhVfOhFBfOWtK8E@google.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
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
>  static void intel_save_pmu_context(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct kvm_pmc *pmc;
> +	u32 i;
> +
> +	if (pmu->version != 2) {
> +		pr_warn("only PerfMon v2 is supported for passthrough PMU");
> +		return;
> +	}
> +
> +	/* Global ctrl register is already saved at VM-exit. */
> +	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, pmu->global_status);
> +	/* Clear hardware MSR_CORE_PERF_GLOBAL_STATUS MSR, if non-zero. */
> +	if (pmu->global_status)
> +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_status);
> +
> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> +		pmc = &pmu->gp_counters[i];
> +		rdpmcl(i, pmc->counter);
> +		rdmsrl(i + MSR_ARCH_PERFMON_EVENTSEL0, pmc->eventsel);
> +		/*
> +		 * Clear hardware PERFMON_EVENTSELx and its counter to avoid
> +		 * leakage and also avoid this guest GP counter get accidentally
> +		 * enabled during host running when host enable global ctrl.
> +		 */
> +		if (pmc->eventsel)
> +			wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0);
> +		if (pmc->counter)
> +			wrmsrl(MSR_IA32_PMC0 + i, 0);
> +	}
> +
> +	rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> +	/*
> +	 * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage and
> +	 * also avoid these guest fixed counters get accidentially enabled
> +	 * during host running when host enable global ctrl.
> +	 */
> +	if (pmu->fixed_ctr_ctrl)
> +		wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> +		pmc = &pmu->fixed_counters[i];
> +		rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i, pmc->counter);
> +		if (pmc->counter)
> +			wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
> +	}

For the next RFC, please make that it includes AMD support.  Mostly because I'm
pretty all of this code can be in common x86.  The fixed counters are ugly,
but pmu->nr_arch_fixed_counters is guaranteed to '0' on AMD, so it's _just_ ugly,
i.e. not functionally problematic. 

