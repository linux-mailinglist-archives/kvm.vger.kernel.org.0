Return-Path: <kvm+bounces-62370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 209B7C4225F
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 01:46:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFE884267C8
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 00:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72F6286422;
	Sat,  8 Nov 2025 00:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j+PEvx3q"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA7618DB26;
	Sat,  8 Nov 2025 00:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762562755; cv=none; b=iNZ05PyhwaahPXw9rbr1X7FPAsmWmaBNgv5c98VHO3mciSy2WGk4QGA77nQXNt/6SdS/xExElyXpayXcdd5nooHDUitd7vBKhpMp4pZOlRme6+pFwXc6WMF1x529M4w3eZSyrZmt4yebR38feQ0fa2p3RyTUNCDqvY6SWDqRSho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762562755; c=relaxed/simple;
	bh=Hsqc59LHEZr6vRsViG4HA9mssxxXrUhOeveBVu79iD8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZOF7dAZtM3qrMe5nQSdu04tUu4FraimyYGplJ59e0GV2KgaCdhSjMse5yW+EnN0EbaAZwL5OZcrFE+4O0JDs0iRqNkwCY3twNVcNdSCtoJMEEA0yuNcyTmdu3YC1vLHlMs4/ZfBkvCnU7MRToExwHMT3fmNWDhe3am3m5/Iepag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j+PEvx3q; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762562749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=y8OjT80dzDQbAAfR+kGSDqcO/L4H9alEphnOquJBA7c=;
	b=j+PEvx3qhym64yqATfF6VPTA3eEK37PtUUhLoE6akGSIJ9DhUXMXkinkNqb3Qsn83uTnzo
	4fI60aDvBZJJFugWq6BkbqGWnOVBNPSff+sz0ECHF/lP3Uu0r6TPTtkzpXj9xec6V3fLhp
	1iE7pxfRAsyXJz26c2NNbKgiD0S0pog=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 0/6] KVM: SVM: LBR virtualization fixes
Date: Sat,  8 Nov 2025 00:45:18 +0000
Message-ID: <20251108004524.1600006-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This series fixes multiple problems with LBR virtualization, including a
fun problem that leads to L1 reading the host's LBR MSRs. It also
considerably simplifies the code.

The series has a selftest in the end that verifies that save/restore
work correctly. I will send a couple of new kvm-unit-tests separately
that exercise the bugs fixed by patches 2 & 3.

Yosry Ahmed (6):
  KVM: SVM: Mark VMCB_LBR dirty when MSR_IA32_DEBUGCTLMSR is updated
  KVM: nSVM: Always recalculate LBR MSR intercepts in svm_update_lbrv()
  KVM: nSVM: Fix and simplify LBR virtualization handling with nested
  KVM: SVM: Switch svm_copy_lbrs() to a macro
  KVM: SVM: Add missing save/restore handling of LBR MSRs
  KVM: selftests: Add a test for LBR save/restore (ft. nested)

 arch/x86/kvm/svm/nested.c                     |  31 ++--
 arch/x86/kvm/svm/svm.c                        |  98 ++++++-----
 arch/x86/kvm/svm/svm.h                        |  10 +-
 arch/x86/kvm/x86.c                            |   3 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/include/x86/processor.h     |   5 +
 .../selftests/kvm/x86/svm_lbr_nested_state.c  | 155 ++++++++++++++++++
 7 files changed, 236 insertions(+), 67 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c

-- 
2.51.2.1041.gc1ab5b90ca-goog


