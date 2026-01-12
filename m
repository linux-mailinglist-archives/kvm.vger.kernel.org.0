Return-Path: <kvm+bounces-67823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D88ED14C11
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 19:25:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BB19130E3C51
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512343876AD;
	Mon, 12 Jan 2026 18:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DAQm6xA/"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBA038759B
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 18:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768242071; cv=none; b=gVzK9xYkFF/7EUnifERsknEOmeueSsNszOZhmyI1sHmaTW57mnm+nhw9oxANSPY7jHohMxZsMWUn1GuR+0J0BPt+9FCGhar6O+qbUVZNn3a4tp79bLQ38vlnn/mZZ5VBxwNh0t32p11pz3QL8x9aHpqEB+ANQlnOdq6bFdw9dbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768242071; c=relaxed/simple;
	bh=paLl81ZDrSdPC2YX0JzCrCf9iMjOdsIGNAr+FQxYmEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szOx6umgiKLlJA6XCWQ3onFWT0UohOSqXq49mTB7Rq/4Pc33UTRb8qAhIIvfv2BFpB8m1CBKfoTU+Yur/vt/ckLBlrcoNy3V+0rAlO8JxlWygCuQZHyut9J+l8zZjqkjucKFUPKkrnUDoOmWyI7WCJBQaDPdpBdcrj7mrwQVmmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DAQm6xA/; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768242063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3gQGG4lYMFVZTiGWhLGCudMsA3FUWNVeNDSx6vxxvOk=;
	b=DAQm6xA/yj9sjnLz3ivBRni5r1p1PLyX6gZFU27e5mmalETUwvR6BQB0Y7Uh6nDFzuLIhT
	5sMn9vexfuDk+zD+cGPzOCwl7AYMBDd7mFMj2SGZ3V1PgQvrXB2W5JqLDp0i88EV6YjEpn
	o7maMFi2xP2Z1gaM/WI60zBs1Gr+VhE=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 2/3] KVM: nSVM: Rename recalc_intercepts() to clarify vmcb02 as the target
Date: Mon, 12 Jan 2026 18:20:21 +0000
Message-ID: <20260112182022.771276-3-yosry.ahmed@linux.dev>
In-Reply-To: <20260112182022.771276-1-yosry.ahmed@linux.dev>
References: <20260112182022.771276-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

recalc_intercepts() updates the intercept bits in vmcb02 based on vmcb01
and (cached) vmcb12. However, the name is too generic to make this
clear, and is especially confusing while searching through the code as
it shares the same name as the recalc_intercepts callback in
kvm_x86_ops.

Rename it to nested_vmcb02_recalc_intercepts() (similar to other
nested_vmcb02_* scoped functions), to make it clear what it is doing.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c |  4 ++--
 arch/x86/kvm/svm/sev.c    |  2 +-
 arch/x86/kvm/svm/svm.c    |  4 ++--
 arch/x86/kvm/svm/svm.h    | 10 +++++-----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2dda52221fd8..bacb2ac4c59e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -123,7 +123,7 @@ static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
 	return false;
 }
 
-void recalc_intercepts(struct vcpu_svm *svm)
+void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb01, *vmcb02;
 	unsigned int i;
@@ -918,7 +918,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	 * Merge guest and host intercepts - must be called with vcpu in
 	 * guest-mode to take effect.
 	 */
-	recalc_intercepts(svm);
+	nested_vmcb02_recalc_intercepts(svm);
 }
 
 static void nested_svm_copy_common_state(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..f50a95aa41bc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4604,7 +4604,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm, bool init_event)
 	if (!sev_vcpu_has_debug_swap(svm)) {
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
-		recalc_intercepts(svm);
+		nested_vmcb02_recalc_intercepts(svm);
 	} else {
 		/*
 		 * Disable #DB intercept iff DebugSwap is enabled.  KVM doesn't
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7041498a8091..485c2710d7a4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -635,7 +635,7 @@ static void set_dr_intercepts(struct vcpu_svm *svm)
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
 
-	recalc_intercepts(svm);
+	nested_vmcb02_recalc_intercepts(svm);
 }
 
 static void clr_dr_intercepts(struct vcpu_svm *svm)
@@ -644,7 +644,7 @@ static void clr_dr_intercepts(struct vcpu_svm *svm)
 
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
 
-	recalc_intercepts(svm);
+	nested_vmcb02_recalc_intercepts(svm);
 }
 
 static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7d28a739865f..330633291c57 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -357,7 +357,7 @@ struct svm_cpu_data {
 
 DECLARE_PER_CPU(struct svm_cpu_data, svm_data);
 
-void recalc_intercepts(struct vcpu_svm *svm);
+void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm);
 
 static __always_inline struct kvm_svm *to_kvm_svm(struct kvm *kvm)
 {
@@ -485,7 +485,7 @@ static inline void set_exception_intercept(struct vcpu_svm *svm, u32 bit)
 	WARN_ON_ONCE(bit >= 32);
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
 
-	recalc_intercepts(svm);
+	nested_vmcb02_recalc_intercepts(svm);
 }
 
 static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
@@ -495,7 +495,7 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
 	WARN_ON_ONCE(bit >= 32);
 	vmcb_clr_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
 
-	recalc_intercepts(svm);
+	nested_vmcb02_recalc_intercepts(svm);
 }
 
 static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
@@ -504,7 +504,7 @@ static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
 
 	vmcb_set_intercept(&vmcb->control, bit);
 
-	recalc_intercepts(svm);
+	nested_vmcb02_recalc_intercepts(svm);
 }
 
 static inline void svm_clr_intercept(struct vcpu_svm *svm, int bit)
@@ -513,7 +513,7 @@ static inline void svm_clr_intercept(struct vcpu_svm *svm, int bit)
 
 	vmcb_clr_intercept(&vmcb->control, bit);
 
-	recalc_intercepts(svm);
+	nested_vmcb02_recalc_intercepts(svm);
 }
 
 static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
-- 
2.52.0.457.g6b5491de43-goog


