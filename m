Return-Path: <kvm+bounces-59306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5571BB0EAD
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED86C320488
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B06A30AAD7;
	Wed,  1 Oct 2025 14:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PxYdpL8H"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5F8307ADD
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 14:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759330731; cv=none; b=WdNpZNWXgnKaLPRiYYbeAwtnheXo1q2o+ah/ngGlabWUEpM1fvVFxfX18aF+pd3IsZC0aSP3ZvNhzB/Ru7XspgXjSNLc68VhXRh+wjn1Dc9eheMu6rk7GaCbtr3GGGMv7uJkRx/Pmq12Y2C2x5pRUZtpk9g55GmF4XVgUjYrcNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759330731; c=relaxed/simple;
	bh=6SGHwTCW76SAXH2tSGEBWFouR6y2PQD5qeTAYrlPQ58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYIFrXqkdI3Pt43QM4KL7HPck0lPgLQEGyGWAZhDUkKzmp7fgQSlpbgAsrtVwyA0VKvy+EuffQfncfpXFXKujpXSn9BKWoiAY0BP1NGYlfWazcbwe/t6HQeGmyI3KhnubnYfXAuil0O7201jA60ah8KG4lbpYCUwfyy8BKIwArM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PxYdpL8H; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759330727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FhGl9Un/NM4vpn3T/c8IJ7g/Ysq6DiXQ9SLpXMtc+aI=;
	b=PxYdpL8Hwwq+VUp+nIpiOmktruiQuvbM5oIi2D8W8vSFgso+QFCfDFJkeay+wxDNZRROz1
	W9dmeQa7iWqNKbvRrTGy+BgQgNIOsTett4r4qvoFqzrmIbpXUmRNqd73WzsyNkBVnB6F3u
	Jvg0lMbEotnxglC/qfJ2GOPrNbb0DFw=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosryahmed@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 05/12] KVM: selftests: Remove invalid CR3 test from vmx_tsc_adjust_test
Date: Wed,  1 Oct 2025 14:58:09 +0000
Message-ID: <20251001145816.1414855-6-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Yosry Ahmed <yosryahmed@google.com>

Checking that VMLAUNCH fails with an invalid CR3 is irrelevant to this
test. Remove it to simplify the test a little bit before generalizing it
to cover SVM.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
index 2ceb5c78c4427..2dcc0306a0d9b 100644
--- a/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
@@ -77,7 +77,6 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	uint32_t control;
-	uintptr_t save_cr3;
 
 	GUEST_ASSERT(rdtsc() < TSC_ADJUST_VALUE);
 	wrmsr(MSR_IA32_TSC, rdtsc() - TSC_ADJUST_VALUE);
@@ -94,15 +93,6 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 	vmwrite(CPU_BASED_VM_EXEC_CONTROL, control);
 	vmwrite(TSC_OFFSET, TSC_OFFSET_VALUE);
 
-	/* Jump into L2.  First, test failure to load guest CR3.  */
-	save_cr3 = vmreadz(GUEST_CR3);
-	vmwrite(GUEST_CR3, -1ull);
-	GUEST_ASSERT(!vmlaunch());
-	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) ==
-		     (EXIT_REASON_FAILED_VMENTRY | EXIT_REASON_INVALID_STATE));
-	check_ia32_tsc_adjust(-1 * TSC_ADJUST_VALUE);
-	vmwrite(GUEST_CR3, save_cr3);
-
 	GUEST_ASSERT(!vmlaunch());
 	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
 
-- 
2.51.0.618.g983fd99d29-goog


