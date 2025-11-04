Return-Path: <kvm+bounces-62020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FCB9C32DB5
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 21:01:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C142718C4D1B
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 20:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4CE2FC00C;
	Tue,  4 Nov 2025 20:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Gu/cED9p"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA982E764D
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 20:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762286415; cv=none; b=F6qhzvZl155a97D7B1QDOVMa3eWiqhCGbZd+UwnrIqdf5S2N9HUApK/XP1MEg9A9WZiSQjB4PahcjbSkmnk35xlJPg3qmjo/iG7gfs/pXiGHWJOTB3Ev9RbElaId2It4ZcPLzjO+zeKHtS3BGFwoQrZUvF3kReVb4UC1oj/gVTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762286415; c=relaxed/simple;
	bh=3SZLZNF3cYTuUQGnWwham9Q9DCKPuYhxMLuTx+7LaW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tnm2xTEJM6nO0ricGxw4G+1iLio2OFRQorOHggZebWEsyPjY1Hb3SxuBC9llaQjv203ftdmjWZx8/u347+6hVkpXXKWZpTw8k0to62/b5Unj44mP27SJjP4sVG0xYniYPsokxzclKETf0ChAiygCI2rX10vYDWSMHucM8nQ9rX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Gu/cED9p; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762286410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HV4S+peGRoTsgN2fUfkCI3V0B36Ozd3fgJngLdVoJ/Q=;
	b=Gu/cED9pZMkmVdQ/WjoyBoCro0lpvlJHkfCqxg675YzvDEsVw+3y2P5W19XooOpySYD0sE
	egQXN9KOYewZyM7URD2SKX/jf1WfiXAxHRNFfNOMNmDvQmpxUwlcfZdB9YM5FK1Vi0Zx16
	g9p7c142dZYnFipUSesmLVtEdE3s1/8=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 03/11] KVM: nSVM: Add missing consistency check for event_inj
Date: Tue,  4 Nov 2025 19:59:41 +0000
Message-ID: <20251104195949.3528411-4-yosry.ahmed@linux.dev>
In-Reply-To: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
References: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

According to the APM Volume #2, 15.20 (24593—Rev. 3.42—March 2024):

  VMRUN exits with VMEXIT_INVALID error code if either:
  • Reserved values of TYPE have been specified, or
  • TYPE = 3 (exception) has been specified with a vector that does not
    correspond to an exception (this includes vector 2, which is an NMI,
    not an exception).

Add the missing consistency checks to KVM. For the second point, inject
VMEXIT_INVALID if the vector is anything but the vectors defined by the
APM for exceptions. Reserved vectors are also considered invalid, which
matches the HW behavior. Vector 9 (i.e. #CSO) is considered invalid
because it is reserved on modern CPUs, and according to LLMs no CPUs
exist supporting SVM and producing #CSOs.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/svm.h |  5 +++++
 arch/x86/kvm/svm/nested.c  | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e69b6d0dedcf0..3a9441a8954f3 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -633,6 +633,11 @@ static inline void __unused_size_checks(void)
 #define SVM_EVTINJ_VALID (1 << 31)
 #define SVM_EVTINJ_VALID_ERR (1 << 11)
 
+/* Only valid exceptions (and not NMIs) are allowed for SVM_EVTINJ_TYPE_EXEPT */
+#define SVM_EVNTINJ_INVALID_EXEPTS (NMI_VECTOR | BIT_ULL(9) | BIT_ULL(15) | \
+				    BIT_ULL(20) | GENMASK_ULL(27, 22) | \
+				    BIT_ULL(31))
+
 #define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
 #define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9866b2fd8f32a..8641ac9331c5d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -324,6 +324,36 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
 	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
 }
 
+/*
+ * According to the APM, VMRUN exits with SVM_EXIT_ERR if:
+ * - The type of event_inj is not one of the defined values.
+ * - The type is SVM_EVTINJ_TYPE_EXEPT, but the vector does not
+ *   correspond to an exception (no NMIs and no reserved values).
+ *
+ * These checks are only performed if SVM_EVTINJ_VALID is set.
+ */
+static bool nested_svm_check_event_inj(u32 event_inj)
+{
+	u32 type = event_inj & SVM_EVTINJ_TYPE_MASK;
+	u8 vector = event_inj & SVM_EVTINJ_VEC_MASK;
+
+	if (!(event_inj & SVM_EVTINJ_VALID))
+		return true;
+
+	if (type != SVM_EVTINJ_TYPE_INTR && type != SVM_EVTINJ_TYPE_NMI &&
+	    type != SVM_EVTINJ_TYPE_EXEPT && type != SVM_EVTINJ_TYPE_SOFT)
+		return false;
+
+	if (type == SVM_EVTINJ_TYPE_EXEPT) {
+		if (vector >= FIRST_EXTERNAL_VECTOR)
+			return false;
+
+		if ((1 << vector) & SVM_EVNTINJ_INVALID_EXEPTS)
+			return false;
+	}
+	return true;
+}
+
 static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 					 struct vmcb_ctrl_area_cached *control,
 					 unsigned long l1_cr0)
@@ -353,6 +383,9 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 		return false;
 	}
 
+	if (CC(!nested_svm_check_event_inj(control->event_inj)))
+		return false;
+
 	return true;
 }
 
-- 
2.51.2.1026.g39e6a42477-goog


