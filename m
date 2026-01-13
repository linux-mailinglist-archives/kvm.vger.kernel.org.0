Return-Path: <kvm+bounces-67960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 839B4D1A8DF
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 18:16:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 36696300BA35
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AD54352C31;
	Tue, 13 Jan 2026 17:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RVmFyp+A"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0E024A06B
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 17:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768324521; cv=none; b=P8sHOXDJ/GJaK8Mf+ShKOeC+CbZmhTfB6CLdDUNmlSpleWfZfjMurgXaRf/hnfvw9Kokb6ydWF0nT4wF4Y5tj1re7fCj2GvIkE3jdwnqN0AEdVW8CqX69r7AT3+O/IN0UQjUSAGgLk60AyXGFZPXRmWqKzKevnV1Oy0HDewTuEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768324521; c=relaxed/simple;
	bh=smwIOKKDfU+zlQqkT9lxMIWGdq3x5ZirwJhSZgxdic8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iOUL8H3ER6tFY5wob+xvDFCJmwCl7Ans9GLe3Zv9qJuCe/5BHRNIBCJpjdY4f4OQtwL8h0HMJ8GDUOnvTWrLYRA/2VL1gkTFWfH2JasTDpIngu59uazex3OXwPKLwhxRYPTDh6D4hEXMMAIlJdkHx4iZZth4wWvPFwBcEa/5DUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RVmFyp+A; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768324516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EQQZXaQ7zNn8Xi4o5EQAOg0Zu49QQHPMXV9LU1700YM=;
	b=RVmFyp+AYShp5LernhT/wybmNVOE23bLP0gEa85yvadW/n9PbFfD/QYXsbrIu0Tc4wFl2Q
	+dlK74Dibg2426ymWHCuVaTmGWx5ldqrDOnLz74ZqGD6FxFBa445t1H/r+v2cccwm9yQOm
	jroUEvKMEXgHGRDrYfVHxyTeJFXpaFY=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH] KVM: selftests: Slightly simplify memstress_setup_nested()
Date: Tue, 13 Jan 2026 17:14:56 +0000
Message-ID: <20260113171456.2097312-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Instead of calling memstress_setup_ept_mappings() only in the first
iteration in the loop, move it before the loop.

The call needed to happen within the loop before commit e40e72fec0de
("KVM: selftests: Stop passing VMX metadata to TDP mapping functions"),
as memstress_setup_ept_mappings() used to take in a pointer to vmx_pages
and pass it into tdp_identity_map_1g() (to get the EPT root GPA). This
is no longer the case, as tdp_identity_map_1g() gets the EPT root
through stage2 MMU.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/lib/x86/memstress.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index 86f4c5e4c430..f53414ba7103 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -110,16 +110,13 @@ void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
 	TEST_REQUIRE(kvm_cpu_has_tdp());
 
 	vm_enable_tdp(vm);
+	memstress_setup_ept_mappings(vm);
 	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
 		if (kvm_cpu_has(X86_FEATURE_VMX))
 			vcpu_alloc_vmx(vm, &nested_gva);
 		else
 			vcpu_alloc_svm(vm, &nested_gva);
 
-		/* The EPTs are shared across vCPUs, setup the mappings once */
-		if (vcpu_id == 0)
-			memstress_setup_ept_mappings(vm);
-
 		/*
 		 * Override the vCPU to run memstress_l1_guest_code() which will
 		 * bounce it into L2 before calling memstress_guest_code().

base-commit: f62b64b970570c92fe22503b0cdc65be7ce7fc7c
-- 
2.52.0.457.g6b5491de43-goog


