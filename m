Return-Path: <kvm+bounces-39472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3817CA47194
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:49:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BC621891CC0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D5F1ACEB5;
	Thu, 27 Feb 2025 01:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Xo90jfJQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29901A8F63
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619660; cv=none; b=oHpm8K/R9MPbMrTOrWSq5ZgoWmDnHEPZK00ZjfgHVS/d6Q/DR2LbFBS/Thtm8540kjaeXLmHrO+OajDIeF+ehiQe21iiWp57YAHYrTV142bcFn3BNRJD+DNSzgTYt1Oh08DyUlrXcVden/+YuvEAo1gCHUaRW3vHBU3vVZ4BhPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619660; c=relaxed/simple;
	bh=2uWNJyLE/fPfNS/X5kdWITQ7IT+PtRDuhmlomQPWapw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AazcYqY+v5wU8UlFJombaeeK9Fpde7RF4/XulnpjX1UAqLox2Og+1z8ER/WRT8NB4NeSr0lX82Rs4MDEp5xkvE65hmLCG1XJ0yo/7GaG+e/+usYbI1kFvWNKNiNZRr7ytljnXTrmSrwdE3xxeWj6Md1leSf+5Oz3YyERaAu24/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Xo90jfJQ; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740619646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ghLAZ7EfQwchk3+f9xBhx3Ovo8d5rd9VHnfEcZf1+LE=;
	b=Xo90jfJQf9mpTGMUIR4VqhjCAoKoFYgJYMI6FmN+cCTBxKtrTsaYMFREFWZEBgMsEkTaka
	fzLeJTW4N+Or7CHyk60AQqyIVorqE3Qji9uJAoP3pAVHZDV5PQmXTlQvJGIZltshLDK5DA
	aoz0+vkzvw+wyZXSQCNMAJPeEATaV7E=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: x86@kernel.org,
	Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 0/6] IBPB cleanups and a fixup
Date: Thu, 27 Feb 2025 01:27:06 +0000
Message-ID: <20250227012712.3193063-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This series removes X86_FEATURE_USE_IBPB, and fixes a KVM nVMX bug in
the process. The motivation is mostly the confusing name of
X86_FEATURE_USE_IBPB, which sounds like it controls IBPBs in general,
but it only controls IBPBs for spectre_v2_mitigation. A side effect of
this confusion is the nVMX bug, where virtualizing IBRS correctly
depends on the spectre_v2_user mitigation.

The feature bit is mostly redundant, except in controlling the IBPB in
the vCPU load path. For that, a separate static branch is introduced,
similar to switch_mm_*_ibpb.

We should also unify indirect_branch_prediction_barrier() with
entry_ibpb() to have a single IBPB primitive that always stuffs the RSB
if needed. Josh will be sending follow up changes for that.

v1 -> v2:
- Collected Ack/Review tags (thanks everyone!).
- Combined the if statements in vmx_vcpu_load_vmcs() and moved the
  static branch check ahead (Sean Christopherson).
- Renamed the static branch to switch_vcpu_ibpb (Sean Christopherson).
- Fixed a typo in the commit message (Jim Mattson).

Yosry Ahmed (6):
  x86/bugs: Move the X86_FEATURE_USE_IBPB check into callers
  x86/mm: Remove X86_FEATURE_USE_IBPB checks in cond_mitigation()
  x86/bugs: Remove the X86_FEATURE_USE_IBPB check in ib_prctl_set()
  x86/bugs: Use a static branch to guard IBPB on vCPU switch
  KVM: nVMX: Always use IBPB to properly virtualize IBRS
  x86/bugs: Remove X86_FEATURE_USE_IBPB

 arch/x86/include/asm/cpufeatures.h       | 1 -
 arch/x86/include/asm/nospec-branch.h     | 4 +++-
 arch/x86/kernel/cpu/bugs.c               | 6 +++++-
 arch/x86/kvm/svm/svm.c                   | 3 ++-
 arch/x86/kvm/vmx/vmx.c                   | 3 ++-
 arch/x86/mm/tlb.c                        | 3 +--
 tools/arch/x86/include/asm/cpufeatures.h | 1 -
 7 files changed, 13 insertions(+), 8 deletions(-)

-- 
2.48.1.658.g4767266eb4-goog


