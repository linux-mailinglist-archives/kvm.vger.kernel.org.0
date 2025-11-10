Return-Path: <kvm+bounces-62625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B2277C499E0
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:38:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C8F104F8CDC
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 22:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7B73469E3;
	Mon, 10 Nov 2025 22:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pTzAyI1G"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18162343D6F;
	Mon, 10 Nov 2025 22:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762813796; cv=none; b=NE7P0yLADE9MEyt57rVOavFoz8Gsnw4hXu7C7sWSfYxFahu96yKo9+avbf/rI0jfbublwQSrgvYVmzn5MfpcWDfO8UfiPnY6HTdIUmCqbdbW7XkM02j4J2hr4WuncytptBQ/RdaCQPjxP7mNILoK4JOBbes1hQBTyzG30IQfHpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762813796; c=relaxed/simple;
	bh=Cxffpccj5xFRhcWG0Ed5lwYp4MppoHShIW8aXH7ntGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V1mjyAONchwptIrziA1kiZTkBMaQAjaiHCeJYAlo+0R5fIbgHKNk6pVgDhtfY6/Jil658PE3AhyR29vMmc/MPfmO4d8F086Xb9VzGpPlHhNCcuYlgSZWoWFd8pAi77gDu+mAMNkGNqU3kPGchK9KnmKqhWt2jlEYEHANVB/N1Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pTzAyI1G; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762813792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L3Fblg04o99kVliEUA69thwScEzBmyTkPPe3+2CH9YU=;
	b=pTzAyI1GuhP5YHK2FctXI/Ml8OZ2oWaqIqzhepcKnk4b33UZzo5+Zc+eepxsOJ5n5HugAr
	jLD8k0X9hiPpq0xgaaB+BDLmsCM2XCf1IkAk8XECIVkkTvPm2QT8yqHszTp90FerXuA82/
	IOqoXWglxkCV2ZogdYQB7GvxeJOUk7I=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 06/13] KVM: nSVM: Add missing consistency check for event_inj
Date: Mon, 10 Nov 2025 22:29:15 +0000
Message-ID: <20251110222922.613224-7-yosry.ahmed@linux.dev>
In-Reply-To: <20251110222922.613224-1-yosry.ahmed@linux.dev>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
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

Defined exceptions could be different between virtual CPUs as new CPUs
define new vectors. In a best effort to dynamically define the valid
vectors, make all currently defined vectors as valid except those
obviously tied to a CPU feature: SHSTK -> #CP and SEV-ES -> #VC. As new
vectors are defined, they can similarly be tied to corresponding CPU
features.

Invalid vectors on specific (e.g. old) CPUs that are missed by KVM
should be rejected by HW anyway.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 51 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index abdaacb04dd9e..418d6aa4e32e8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -324,6 +324,54 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
 	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
 }
 
+static bool nested_svm_event_inj_valid_exept(struct kvm_vcpu *vcpu, u8 vector)
+{
+	/*
+	 * Vectors that do not correspond to a defined exception are invalid
+	 * (including #NMI and reserved vectors). In a best to define valid
+	 * exceptions based on the virtual CPU, make all exceptions always valid
+	 * except those obviously tied to a CPU feature.
+	 */
+	switch (vector) {
+	case DE_VECTOR: case DB_VECTOR: case BP_VECTOR: case OF_VECTOR:
+	case BR_VECTOR: case UD_VECTOR: case NM_VECTOR: case DF_VECTOR:
+	case TS_VECTOR: case NP_VECTOR: case SS_VECTOR: case GP_VECTOR:
+	case PF_VECTOR: case MF_VECTOR: case AC_VECTOR: case MC_VECTOR:
+	case XM_VECTOR: case HV_VECTOR: case SX_VECTOR:
+		return true;
+	case CP_VECTOR:
+		return guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+	case VC_VECTOR:
+		return guest_cpu_cap_has(vcpu, X86_FEATURE_SEV_ES);
+	}
+	return false;
+}
+
+/*
+ * According to the APM, VMRUN exits with SVM_EXIT_ERR if SVM_EVTINJ_VALID is
+ * set and:
+ * - The type of event_inj is not one of the defined values.
+ * - The type is SVM_EVTINJ_TYPE_EXEPT, but the vector is not a valid exception.
+ */
+static bool nested_svm_check_event_inj(struct kvm_vcpu *vcpu, u32 event_inj)
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
+	if (type == SVM_EVTINJ_TYPE_EXEPT &&
+	    !nested_svm_event_inj_valid_exept(vcpu, vector))
+		return false;
+
+	return true;
+}
+
 static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 					 struct vmcb_ctrl_area_cached *control,
 					 unsigned long l1_cr0)
@@ -353,6 +401,9 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 		return false;
 	}
 
+	if (CC(!nested_svm_check_event_inj(vcpu, control->event_inj)))
+		return false;
+
 	return true;
 }
 
-- 
2.51.2.1041.gc1ab5b90ca-goog


