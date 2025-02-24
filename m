Return-Path: <kvm+bounces-39027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AA51A429C2
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:31:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77B0A3A59E9
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0128264F9D;
	Mon, 24 Feb 2025 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nJdN0OUg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D86263F5F
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417980; cv=none; b=PbQH5Suxxez7wXJd1Pxa58X53bFOevykz5VXnlcM9BjBJEpyb6FjaHO5Ac7cb+mubgTi17RqxxLR3hAUaaIYefuF9wEW+73mQSocXnQsEFASDXoGocHhoqQKKyTempSQuNfnXKtGDA8dtThHCWHn8sg6ImUa+KUrPcodcqLPozY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417980; c=relaxed/simple;
	bh=TY41t8R5RHv8kmnjmK5dzy+xr7BH9RgoOiEPIeC4w0o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X5qIm6/6ETtCsH3S4ejYPUGJGCgUhfJ9ouljLMlSVxhM4HyGmAn1dtM+Wtyf5ljKIm4gRpawezhXMGyKmH7B079a2iIKS6KAwc7tW3IwsD5+hTXRKkWzJrqAb2BCmkdOICFYCeBSKVqjIdLNJApwULW4zVaVos5s2EXfADREEI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nJdN0OUg; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc43be27f8so15505377a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417978; x=1741022778; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CO4ECFGk0nuCQJyTl2dhtSVdd+PXhhF54f+97kGu+yU=;
        b=nJdN0OUgebgg75Nil2uG/gY6Dn+qPRmxI9ZvrTXan1g1Q9ng2smhedcA3VhzB5F6sg
         V0eAX24mQvf5W3PuA3HVH8aV8OWdFPXcbjeIlToB7r8NY2jlhd7U6hmPuztAfKmqxYn6
         mRtGzwWvQmngc7W9dFafxFmPY+qDLUBllNcFbfIDYPu+NI7jWBioFiA/d8ddvF+R57Rf
         3ChzQusquMFZ4dUZOSymWDatJMC+s0/tNGXmu4fgC1IjdzFiVb0PBU7HG4xtZPGMGqFz
         +KBMBrdMrjbIDyyIkt29pVN+V3KFXsvBSXPxKAsgOd23dlcMypbBv6VYbqo7mmKrAKSL
         45hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417978; x=1741022778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CO4ECFGk0nuCQJyTl2dhtSVdd+PXhhF54f+97kGu+yU=;
        b=cT8hHMpSvrBGGwn+ougzfosD000Qap/jJ763FhRceXXD03MNTaa8Jak1M8NxN0kBzk
         jIgNHf+ltq7qsYLrVWiJmEH71ypb64u/5en+JIhDkiC8ZkrNM/BoOIa+BxeLK96zGKE+
         yjYMwDomX5gmu063tEc60/A3FXjlHrKiDE8FKmxl0gikD+bnGdDsy+EXVP8gXyHRvYO+
         GUjd/iF8qW7MnuTCIdObcCrUHsXJwd75JOdk4TEPvRI7SR87yBJVAWh0dLbLSXbGn/Bz
         aPfTqcM/BrA8d1U9PeEAcT/Em+cqKJPfqFkYIbq7mm/uqRkDpQMSUPC8C4ApwhcYH570
         HfIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBVfDcCov9Z7+2xDcCFkcXw4SFsEyNxp5O5fjz7blu7sDnb3A1bgiei2jORvOfrgBP+a4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYj0sulFN+mC4PVvrxFdaHF5Fs54qSQvaGBAySAxudGiMeBEgE
	gKnYr3L6zlTrE75Kjrx9TUZ0JwWfPLbLcrCPXB3nUXKQe5m0D1hHAPshCOQ0Av3f+Wekb4rENcM
	UXA==
X-Google-Smtp-Source: AGHT+IFG/zdsijF0B0boJe5MmJ/K69oaTqYcRTYyuMEjVigITkHTGntGc7MOhKSjKVJFYSlWE+rOBMG8lfg=
X-Received: from pgjf6.prod.google.com ([2002:a63:dc46:0:b0:ad8:3be5:88d4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a0d:b0:1ee:be88:f5cf
 with SMTP id adf61e73a8af0-1eef3d92022mr30219642637.32.1740417977882; Mon, 24
 Feb 2025 09:26:17 -0800 (PST)
Date: Mon, 24 Feb 2025 09:24:15 -0800
In-Reply-To: <20241118225207.16596-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241118225207.16596-1-zide.chen@intel.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041749542.2351666.15343179210684942856.b4-ty@google.com>
Subject: Re: [kvm-unit-test PATCH 1/3] nVMX: fixed-function performance
 counters could be not contiguous
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, Zide Chen <zide.chen@intel.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 18 Nov 2024 14:52:05 -0800, Zide Chen wrote:
> The fixed counters may not be contiguous.  Intel SDM recommends how to
> use CPUID.0AH to determine if a Fixed Counter is supported:
> 	FxCtr[i]_is_supported := ECX[i] || (EDX[4:0] > i);
> 
> For example, it's perfectly valid to have CPUID.0AH.EDX[4:0] == 3 and
> CPUID.0AH.ECX == 0x77, but checking the fixed counter index against
> CPUID.0AH.EDX[4:0] only, will deem that FxCtr[6:4] are not supported.
> 
> [...]

Applied to kvm-x86 next (and now pulled by Paolo), thanks!

[1/3] nVMX: fixed-function performance counters could be not contiguous
      https://github.com/kvm-x86/kvm-unit-tests/commit/d5a6cfacc5ba
[2/3] x86/pmu: Fixed PEBS basic record parsing issue
      https://github.com/kvm-x86/kvm-unit-tests/commit/1006feddb2b6
[3/3] x86/pmu: Execute PEBS test only if PEBSRecordFormat >= 4
      https://github.com/kvm-x86/kvm-unit-tests/commit/e67ba872d947

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

