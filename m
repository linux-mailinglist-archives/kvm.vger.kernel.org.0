Return-Path: <kvm+bounces-63991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DB306C769DA
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:32:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 85FE23467ED
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C09020C48A;
	Thu, 20 Nov 2025 23:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vfIahbkF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463A236D51C
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763681514; cv=none; b=cij2SCOWPKmu7+xY3/+pO+DNgON+lxiHdlhu9FsPTcve088jC5OFUUS6SbVUULuIUesbCA8QnuW7nClgko4S/A6VBfaWzBBq5S3f67r7ZmR0fwpt8jecPll4JrBFMHMy82CSexXxYkha1eIO9pWqR8JSjTkvlItoDCuRPO3UYxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763681514; c=relaxed/simple;
	bh=OaTEP/5ZpIHRqm2EhrZHsnPrChHYKRiR2aaQ23DP/WM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tRhIjSEsi3HIHEw+OItPgExLhfbhdHLmx/TIh8aQCJ4UpXEwUmadbNF3jnKWwUsoDRvsMlwjzklBZu8X93Y5QajxcIf1pRdZSj6TqF80r9kDgJroqifP/FdYK9zkoe4c9KzUzt+wPp5Des2iXwUoNGNLxRsSOdoBBONBebCOoUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vfIahbkF; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2982b47ce35so15549225ad.2
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763681512; x=1764286312; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=egzEkXHj91PVZ1/2W8WxBCrxD23pMUDzcnxBTutPPDA=;
        b=vfIahbkFPcZws5QRphC0byzXfXwmDlgzGnpI1S7mFn/g84JJN6vmuINlFVm1R+LoeM
         QF3JNqk1I8TT8C+TbRJGyiLHIcHOB7GjatrIIdcCr+8L3A+5UY/QTWFLr/XnIwAmhD9q
         XtjLK7yAQkl9akRFjKvIYgbxYkWT5OnhdxJls9H31Y15um1/P2M/zOCS9PRMAg/6BfMQ
         AO9dtH7iBvaNVcURS8Y2WKZMi5zcYGke1vlzzfHV9SuhU51SaxQbCmtZwA4NWwQvFCU3
         B+NXPFYw2+Z6FmkgPC3WuY9ljdkWI4qlNM0ItI+8vewUFQ4Q1boX4ioEr6eOO0ygZBxH
         OfEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763681512; x=1764286312;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=egzEkXHj91PVZ1/2W8WxBCrxD23pMUDzcnxBTutPPDA=;
        b=rUFeXgVYnC29fnlNWX7aagvPgwbICN1FtzJTnCeab0Z5wcUpBivwxlDlL27EYJ875J
         1xdm5bUUSC33vXA7PsjHnrsoDwVAwma+/8HHm7T4qqWJ2zjwDFXycshgn6sIJlgseu6k
         lR5rQW2yrMF0mpriT60SpaOpspHYYn7wzMuwJMTZqVQxhaXl/iZ+h0Udx2HUsCgyD4z/
         pO7LY1wwnDJm6cysHaGA1mtLtzk1cSOV7c5PEJdfIvP785R+v7SFypeMkxWZXF42waPF
         eNs0jX6lWCoDYBHk7qD4EiAoqpaIfstdXCmGpqerl6ceyF3oZz9gItqh4giTdk7wHHs6
         TXBw==
X-Gm-Message-State: AOJu0YxZiWtJkbLqkrpo95Z/hPAi0a06icInBB6c9OIYBVvJjrdY7ys8
	Pv4CV5TS1VV+rICrogj3BcQsRAsZqYL2Y8uovg3+6bMBQqvLJGD7/SInmgHBv+3nJRUXiULP+tn
	94vUxWg==
X-Google-Smtp-Source: AGHT+IFutbUAewZ7mPs3FRNlnKDHsr9e+9ZpSX9AfQDQPvAiylpTXaOUknIQ4H0fahUxvk1jzmHUF37uRW0=
X-Received: from plrd9.prod.google.com ([2002:a17:902:aa89:b0:298:223a:861])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d484:b0:297:c4b0:8d58
 with SMTP id d9443c01a7336-29b6c6904b4mr3138475ad.46.1763681512548; Thu, 20
 Nov 2025 15:31:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Nov 2025 15:31:41 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251120233149.143657-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 0/8] x86/pmu: Fix test errors on GNR/SRF/CWF
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Yi Lai <yi1.lai@intel.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Refreshed version of Dapeng's series to address minor flaws in v3.

This patchset fixes the pmu test errors on Granite Rapids (GNR), Sierra
Forest (SRF) and Clearwater Forest (CWF).

GNR and SRF start to support the timed PEBS. Timed PEBS adds a new
"retired latency" field in basic info group to show the timing info and
the PERF_CAPABILITIES[17] called "PEBS_TIMING_INFO" bit is added
to indicated whether timed PEBS is supported. KVM module doesn't need to
do any specific change to support timed PEBS except a perf change adding
PERF_CAP_PEBS_TIMING_INFO flag into PERF_CAP_PEBS_MASK[1]. The patch 7/7
supports timed PEBS validation in pmu_pebs test.

On Intel Atom platforms, the PMU events "Instruction Retired" or
"Branch Instruction Retired" may be overcounted for some certain
instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
and complex SGX/SMX/CSTATE instructions/flows[2].

In details, for the Atom platforms before Sierra Forest (including
Sierra Forest), Both 2 events "Instruction Retired" and
"Branch Instruction Retired" would be overcounted on these certain
instructions, but for Clearwater Forest only "Instruction Retired" event
is overcounted on these instructions.

As the overcount issue, pmu test would fail to validate the precise
count for these 2 events on SRF and CWF. Patches 1-4/7 detects if the
platform has this overcount issue, if so relax the precise count
validation for these 2 events.

Besides it looks more LLC references are needed on SRF/CWF, so adjust
the "LLC references" event count range.

Tests:
  * pmu tests passed on SPR/GNR/SRF/CWF.
  * pmu_lbr tests is skiped on SPR/GNR/SRF/CWF since mediated vPMU based
    arch-LBR support is not upstreamed yet.
  * pmu_pebs test passed on SPR/GNR/SRF and skiped on CWF since CWF
    introduces architectural PEBS and mediated vPMU based arch-PEBS
    support is not upstreamed yet.

v4:
 - Track the errata in pmu_caps so that the information is available to all
   tests (even though non-PMU tests are unlikely to care).
 - Keep the measure_for_overflow() call for fixed counters.
 - Handle errata independently for precise checks.

v3:
 - https://lore.kernel.org/all/20250903064601.32131-1-dapeng1.mi@linux.intel.com
 - Fix the emulated instruction validation error on SRF/CWF. (Patch 5/8)

v2:
 - Fix the flaws on x86_model() helper (Xiaoyao).
 - Fix the pmu_pebs error on GNR/SRF.

Dapeng Mi (3):
  x86/pmu: Relax precise count check for emulated instructions tests
  x86: pmu_pebs: Remove abundant data_cfg_match calculation
  x86: pmu_pebs: Support to validate timed PEBS record on GNR/SRF

dongsheng (5):
  x86/pmu: Add helper to detect Intel overcount issues
  x86/pmu: Relax precise count validation for Intel overcounted
    platforms
  x86/pmu: Fix incorrect masking of fixed counters
  x86/pmu: Handle instruction overcount issue in overflow test
  x86/pmu: Expand "llc references" upper limit for broader compatibility

 lib/x86/pmu.c       | 39 ++++++++++++++++++++++++
 lib/x86/pmu.h       | 11 +++++++
 lib/x86/processor.h | 26 ++++++++++++++++
 x86/pmu.c           | 72 ++++++++++++++++++++++++++++++---------------
 x86/pmu_pebs.c      |  9 +++---
 5 files changed, 129 insertions(+), 28 deletions(-)


base-commit: de952a4bf26cb2e93c634445034645523f65d28b
-- 
2.52.0.rc2.455.g230fcf2819-goog


