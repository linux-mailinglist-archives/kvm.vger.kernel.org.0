Return-Path: <kvm+bounces-57267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9596B524DB
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 01:59:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68F44562A3A
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 23:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345A727B332;
	Wed, 10 Sep 2025 23:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ODTfIHH6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FC725C83A
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 23:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757548782; cv=none; b=gJXNwC378jUBZCUp+PawIjJvaXtHZQI+fwPCRGLDyCGQKdkXOKA3OksCsraERMajamBifsABtZ0OTMsDcHHkuwN6mXuauJCHap6+W07JYB4Uf2+nUy0lsvUWidT5ne5w+uWyCO9WNAgflO+OyWI1jK+Ixh6YBkQ9KRr+Rk2JWcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757548782; c=relaxed/simple;
	bh=z7UryU07ZsIwZtTkCIkX9YrgpajQBelPNfH3xWVgSdM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KyfmV/bhNeWj674MmdkFHWgLdpjvYAntSOZyQQ/lUjj7MiVN+evoSlCuxDX84tqRgOzPuEgWCHGpwvFsABbllKWhvUPvNZtjdYhtshMknLYG+kYodyNITL6gMM6MhdXTw9851jlcNY8H+h9ZVt0XLW+zp0Hj7VRBiS0NipFjuaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ODTfIHH6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329ee69e7f1so90954a91.1
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 16:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757548780; x=1758153580; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vx7kGraOjUOSMIvLZNOPm1UobesU6sM8FVf5K2vcg1I=;
        b=ODTfIHH6Pglhm17wuNMs8IFDU74HORq9zuLdtitoUeb98WtRoEkfkBw9e+EidwX27I
         7dKhntUXcQr5u45MEn9fsBmm+ACrhfxZEZBgP54Y1QFWtr5A/5DvNULPPZFScZM0vVZr
         HKmc2eCQJgdAcaXYkdPbJ16zTHogwkBNnVCbn74dRTvjs6tNkTEY96d0t24Ws0xBO5yE
         bw7n1Uo8vgyA7sQMmlBkp9PSpgyC4gtpccmuSRqSeM4jrxa97zWn6lAq1pFi9MFXuoCf
         baATsMDKIc7PWzUc1kI/lamay73vRlnAh1JjXSzmz2MHN5Qap7OcleQYp++0u24g8NtP
         dC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757548780; x=1758153580;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vx7kGraOjUOSMIvLZNOPm1UobesU6sM8FVf5K2vcg1I=;
        b=vtWzfc9wywWszQ02bZ5+dVexalPjii5Pe4cdbtadpnI5n8432TQaofEK3qePuABvqE
         d8JHsWeM80GWzL2AXlbVAEwM4YDhgAmgRakBZA09rRbFpJw+otYOZgVd8rsiD5Jo/BMG
         vdGaxHkn3wtoAFz/JMuYJRbHwMF075BBNL/nTdEGsNyyhVZ8iliuagni+fLLGAZQUGM7
         3dLVfY2NJbgG3+WCTjy70AcsX/rsYfHJti3p0WkDyO9QUFC+yHhK9UeQIORuqTl+H2zC
         T491gfJHXAtMO4eSDw4l5Xs9am65emTWtDVOcpMdJre2zvfxTjNFxJKar6tBwaoI5mWX
         dmdg==
X-Forwarded-Encrypted: i=1; AJvYcCW4YtQ+3WnzCvANF3LLMUJTQN7FNBh6Z/UMHsPbMsRTGyYwjQmiDLB6MgLsFAdqgKU2edM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2wViCf8z9RlAMfpxG4IXYWG2GFSkIlC+L12esjD6SVsOV+PlN
	xlPrp1e2DZql+4VGyF8uXJBiRHYY/GQU+lEFGdxAXqQhtxX0qHntYnscLWsiJfRvBJJ2swV+m/Z
	PJ21XZQ==
X-Google-Smtp-Source: AGHT+IFXfL3DI67mRFPeAT1+CJ61sTKzncJWkG1T8gDfTqa+a3NU9eacPijxo/6T0aQQyrMbgCaPjQ5/M6w=
X-Received: from pjj12.prod.google.com ([2002:a17:90b:554c:b0:325:9fa7:5d07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1343:b0:32b:58d4:e9d0
 with SMTP id 98e67ed59e1d1-32d43f98ca9mr22293045a91.23.1757548780201; Wed, 10
 Sep 2025 16:59:40 -0700 (PDT)
Date: Wed, 10 Sep 2025 16:59:38 -0700
In-Reply-To: <20250718001905.196989-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250718001905.196989-1-dapeng1.mi@linux.intel.com>
Message-ID: <aMIQ6vxYuHA2jVuN@google.com>
Subject: Re: [PATCH v2 0/5] Fix PMU kselftests errors on GNR/SRF/CWF
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Zide Chen <zide.chen@intel.com>, Das Sandipan <Sandipan.Das@amd.com>, 
	Shukla Manali <Manali.Shukla@amd.com>, Yi Lai <yi1.lai@intel.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 18, 2025, Dapeng Mi wrote:
> This patch series fixes KVM PMU kselftests errors encountered on Granite
> Rapids (GNR), Sierra Forest (SRF) and Clearwater Forest (CWF).
> 
> GNR and SRF starts to support the timed PEBS. Timed PEBS adds a new
> "retired latency" field in basic info group to show the timing info and
> the PERF_CAPABILITIES[17] called "PEBS_TIMING_INFO" bit is added
> to indicated whether timed PEBS is supported. KVM module doesn't need to
> do any specific change to support timed PEBS except a perf change adding
> PERF_CAP_PEBS_TIMING_INFO flag into PERF_CAP_PEBS_MASK[1]. The patch 2/5
> adds timed PEBS support in vmx_pmu_caps_test and fix the error as the
> PEBS caps field mismatch.
> 
> CWF introduces 5 new architectural events (4 level-1 topdown metrics
> events and LBR inserts event). The patch 3/5 adds support for these 5
> arch-events and fixes the error that caused by mismatch between HW real
> supported arch-events number with NR_INTEL_ARCH_EVENTS.
> 
> On Intel Atom platforms, the PMU events "Instruction Retired" or
> "Branch Instruction Retired" may be overcounted for some certain
> instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
> and complex SGX/SMX/CSTATE instructions/flows[2].
> 
> In details, for the Atom platforms before Sierra Forest (including
> Sierra Forest), Both 2 events "Instruction Retired" and
> "Branch Instruction Retired" would be overcounted on these certain
> instructions, but for Clearwater Forest only "Instruction Retired" event
> is overcounted on these instructions.
> 
> As this overcount issue, pmu_counters_test and pmu_event_filter_test
> would fail on the precise event count validation for these 2 events on
> Atom platforms.
> 
> To work around this Atom platform overcount issue, Patches 4-5/5 looses
> the precise count validation separately for pmu_counters_test and
> pmu_event_filter_test.
> 
> BTW, this patch series doesn't depend on the mediated vPMU support.
> 
> Changes:
>   * Add error fix for vmx_pmu_caps_test on GNR/SRF (patch 2/5).
>   * Opportunistically fix a typo (patch 1/5).
> 
> Tests:
>   * PMU kselftests (pmu_counters_test/pmu_event_filter_test/
>     vmx_pmu_caps_test) passed on Intel SPR/GNR/SRF/CWF platforms.
> 
> History:
>   * v1: https://lore.kernel.org/all/20250712172522.187414-1-dapeng1.mi@linux.intel.com/
> 
> Ref:
>   [1] https://lore.kernel.org/all/20250717090302.11316-1-dapeng1.mi@linux.intel.com/
>   [2] https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details
> 
> Dapeng Mi (4):
>   KVM: x86/pmu: Correct typo "_COUTNERS" to "_COUNTERS"
>   KVM: selftests: Add timing_info bit support in vmx_pmu_caps_test
>   KVM: Selftests: Validate more arch-events in pmu_counters_test
>   KVM: selftests: Relax branches event count check for event_filter test
> 
> dongsheng (1):
>   KVM: selftests: Relax precise event count validation as overcount
>     issue

Overall looks good, I just want to take a more infrastructure-oriented approach
for the errata.  I'll post a v3 tomorrow.  All coding is done and the tests pass,
but I want to take a second look with fresh eyes before posting it :-)

