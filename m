Return-Path: <kvm+bounces-38876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76FD2A3FBB7
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 17:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5464863438
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 16:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7699F205514;
	Fri, 21 Feb 2025 16:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZP7TW8mV"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE1F1F2388;
	Fri, 21 Feb 2025 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740155649; cv=none; b=AWxhjA7WhD9Je1DyvxhhdkxiOAGkP/Ef01o9/N3M3IPO4a5zveqVFGsqm7ehgCXpN+ZWlTBJ9O16oJQ4Iy/8m+x5e9ThJf2b+tV1fvEnPTLe/YzX1kF541SrxbhPwKt9Wza/CPUHCiAUPMErsa4a7YCsvIam22M1HSi1rQM/1SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740155649; c=relaxed/simple;
	bh=RxJEcWVghd6bkxuIVDva9OU4RyA6+Bg4Hi5HSAYu1rc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R7huQuFWJlXhNlHzzW+uYxD8w9Py/7khsykJ7RSyrTZNb+pAPPZsltFofmmzCqPGqf2x3ip2vAqUs7BZztNKw8b2XEOy2V7OhBTQmhtewGYhMoEPaSx7YjsYG9B685/ahAxFU7SdTAarO+hf/cBvzNMakb6/Ozgvuy5ET2DuCdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZP7TW8mV; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740155644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tww/0JdYvqBk8GNo5pHsseQ85ix+/4SFx2hfJ+jbOFI=;
	b=ZP7TW8mVi5VAc5KxB0+BV072B6Lkvp8h1XR717F6U/3P6O/9duyp1Oez2eXiuTh42SKsNj
	4l4BzkptA/sTnD04LvRClU517WMbbwwQKCle50B0e0r/Pzn8qyFZ7MDthUplEJCetXbGiS
	rQuByUXnPJogjQp7D62hrTnrkqh1Mms=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: x86@kernel.org,
	Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	"Kaplan, David" <David.Kaplan@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 0/3] Unify IBRS virtualization
Date: Fri, 21 Feb 2025 16:33:49 +0000
Message-ID: <20250221163352.3818347-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To properly virtualize IBRS on Intel, an IBPB is executed on emulated
VM-exits to provide separate predictor modes for L1 and L2.

Similar handling is theoretically needed for AMD, unless IbrsSameMode is
enumerated by the CPU (which should be the case for most/all CPUs
anyway). For correctness and clarity, this series generalizes the
handling to apply for both Intel and AMD as needed.

I am not sure if this series would land through the kvm-x86 tree or the
tip/x86 tree.

Yosry Ahmed (3):
  x86/cpufeatures: Define X86_FEATURE_AMD_IBRS_SAME_MODE
  KVM: x86: Propagate AMD's IbrsSameMode to the guest
  KVM: x86: Generalize IBRS virtualization on emulated VM-exit

 arch/x86/include/asm/cpufeatures.h       |  1 +
 arch/x86/kvm/cpuid.c                     |  1 +
 arch/x86/kvm/svm/nested.c                |  2 ++
 arch/x86/kvm/vmx/nested.c                | 11 +----------
 arch/x86/kvm/x86.h                       | 18 ++++++++++++++++++
 tools/arch/x86/include/asm/cpufeatures.h |  1 +
 6 files changed, 24 insertions(+), 10 deletions(-)

-- 
2.48.1.601.g30ceb7b040-goog


