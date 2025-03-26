Return-Path: <kvm+bounces-42069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7334DA71F89
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:49:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74F0E3B5D2E
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F9E2580F2;
	Wed, 26 Mar 2025 19:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EWULYkf9"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D6E255E32
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743018308; cv=none; b=VAYMx58RrUzB+LE/JaO7VPIUvGctxawBMv92+xV2NI29oar3OX4X8XY0GYHYdFhjfrU29Qmw9PG75f64cmUS3GwgpjZw4e2Ov6vcMKg9BkmAe7njl89/0ql5mlcN3jFbQvx2sSMOWSm3ecfHDr6qoUZFNrCLbP9zK0BPCbJPhnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743018308; c=relaxed/simple;
	bh=UeVHYpmQSDO76eE41wf9EKaMRSdXPXbn7WRLWP2Qsn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArpBzE79qRSAfuIz3hD0uBI60DoqtyuAk0V7BQUsnhzJtqgeoFE3OjzzBCMBMrFqc1amLHGHgDBqmJJVg3ChD0tPMkDdq3xSSNlaSk8ikJfZxKJsh3eSZztxHqDQEQ3FRtKqwWn6JeqNNqicHRBhjG+yk6v0MXFQeuzizbjONc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EWULYkf9; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743018305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mC9adyeMRha61zAgAYp8mHu/RuLTfUqFd1dxgCKdmws=;
	b=EWULYkf9OLzgzfxEi3t8FEHJOcvrOeq3/BlyQY9R4x4wibs58G0WVnj+hADDUkaYQQ31Tq
	s2ezRVLKbGIpXO0zcZWtvVZUnD/QJ/+qIWyIg+SW0USxXDVbe3I2mJ3T6Xp+aszml2uXkq
	gsDff4OZA2cdWISGnsPmVAbsSf6ZdUM=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 23/24] KVM: nSVM: Allocate a new ASID for nested guests
Date: Wed, 26 Mar 2025 19:44:22 +0000
Message-ID: <20250326194423.3717668-4-yosry.ahmed@linux.dev>
In-Reply-To: <20250326194423.3717668-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326194423.3717668-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Now that nested TLB flushes are properly tracked, start allocating a
separate ASID for nested guests. This allows dropping the unconditional
TLB flushes on nested transitions and doing finer grained TLB flushing
when necessary.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 11 +++++++++--
 arch/x86/kvm/svm/svm.c    |  5 +++--
 arch/x86/kvm/svm/svm.h    |  3 +++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 544913461693c..0c887c91bd50d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1204,6 +1204,7 @@ int svm_allocate_nested(struct vcpu_svm *svm)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
 	struct page *vmcb02_page;
+	unsigned int asid;
 
 	if (svm->nested.initialized)
 		return 0;
@@ -1221,8 +1222,14 @@ int svm_allocate_nested(struct vcpu_svm *svm)
 
 	svm->nested.initialized = true;
 
-	if (!kvm_svm->nested_asid)
-		kvm_svm->nested_asid = kvm_svm->asid;
+	if (!kvm_svm->nested_asid) {
+		asid = kvm_tlb_tags_alloc(&svm_asids);
+		if (asid && !svm_register_asid(asid)) {
+			kvm_tlb_tags_free(&svm_asids, asid);
+			asid = 0;
+		}
+		kvm_svm->nested_asid = asid ?: fallback_asid;
+	}
 
 	return 0;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4b95fd6b501e6..196f5bca57a0e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -249,8 +249,8 @@ static unsigned long iopm_base;
 
 DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
 
-static struct kvm_tlb_tags svm_asids;
-static unsigned int fallback_asid;
+struct kvm_tlb_tags svm_asids;
+unsigned int fallback_asid;
 
 /*
  * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switched via
@@ -5127,6 +5127,7 @@ static void svm_vm_destroy(struct kvm *kvm)
 	avic_vm_destroy(kvm);
 	sev_vm_destroy(kvm);
 	kvm_tlb_tags_free(&svm_asids, kvm_svm->asid);
+	kvm_tlb_tags_free(&svm_asids, kvm_svm->nested_asid);
 }
 
 static int svm_vm_init(struct kvm *kvm)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0c44133bc05ca..220d10d2b1a5c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -630,6 +630,9 @@ static inline void svm_vmgexit_no_action(struct vcpu_svm *svm, u64 data)
 
 extern bool dump_invalid_vmcb;
 
+extern struct kvm_tlb_tags svm_asids;
+extern unsigned int fallback_asid;
+
 u32 svm_msrpm_offset(u32 msr);
 u32 *svm_vcpu_alloc_msrpm(void);
 void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);
-- 
2.49.0.395.g12beb8f557-goog


