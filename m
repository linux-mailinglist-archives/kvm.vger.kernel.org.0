Return-Path: <kvm+bounces-71698-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qGAxJYcpnmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71698-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:43:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FCEE18D941
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:43:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B39FC31AD81B
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 789E43AA1AE;
	Tue, 24 Feb 2026 22:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kCh+TeJ5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6980E376491;
	Tue, 24 Feb 2026 22:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972470; cv=none; b=OFLWj2nQnQsbeLSKLP0/YDmaEhMJ0kwnoCcUgdnIwBDPonv0gLLYBiKEPCHjMnn/HehEymTIHgnS3NC1jlHdIN/FIhY9++GA10ey6kOcbxuZBX1JhudjpNu4f0uCl2QReBX+7gEi3GHhkXet/aa+Waj9jufBKPBnxckNWddnxeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972470; c=relaxed/simple;
	bh=DxoJTrYPRiCr+cybBN/3fLkSB0kroFFBYrVWTNY1gXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c9Gb2wG6MTOmorp8j4j+fa73JMeoePgFKBeXU3VtYtzfF57JlQHpR3Kfsuix9kYKZ4S8eEj/+T+ScpGqwUqSa53fMy4qUK9f4bOJaBMSHVL31DWKoJOrCvkI4MUQnVSIygsnfI6wXOV5OG8vC9yBrsTOR7awbuwBBlIjBUQK3k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kCh+TeJ5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A0CC116D0;
	Tue, 24 Feb 2026 22:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972470;
	bh=DxoJTrYPRiCr+cybBN/3fLkSB0kroFFBYrVWTNY1gXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCh+TeJ5zUhvVJ1VqQMFD9uDHyXOmKQ4lHReHeb8E8CdEjjViU1JJQvIGVrQZiM7r
	 6j6AWY2UKGUK0JGouYld8z8EDEw/mawk+rtJtu4AIDUb8XTLWw3GouL5cl1scOM69a
	 xbXO6ZvHNQE7cvyvf6cjSDnklZRtzYuykx6b1w0lKdJ5rvEDhU3rqcliPPkDMibO/E
	 8Z1i7BeFJRJ8eQXgb/IW8OPKOQmLD4+LR9oRIeVy7dkl/ic36F3P7u4yyj5uz9kda4
	 xqaZlBGZqJxW9Xi4QzGRx63dEioMKYgF7jj3JpBEyyHyB2vW0dFOJ+waLaK6zOGaAW
	 DLY+ZykEq4j0Q==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v6 22/31] KVM: nSVM: Add missing consistency check for EVENTINJ
Date: Tue, 24 Feb 2026 22:33:56 +0000
Message-ID: <20260224223405.3270433-23-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
In-Reply-To: <20260224223405.3270433-1-yosry@kernel.org>
References: <20260224223405.3270433-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71698-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3FCEE18D941
X-Rspamd-Action: no action

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

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 51 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2c852e94a9ad9..dc0e0ac881979 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -341,6 +341,54 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
 	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
 }
 
+static bool nested_svm_event_inj_valid_exept(struct kvm_vcpu *vcpu, u8 vector)
+{
+	/*
+	 * Vectors that do not correspond to a defined exception are invalid
+	 * (including #NMI and reserved vectors). In a best effort to define
+	 * valid exceptions based on the virtual CPU, make all exceptions always
+	 * valid except those obviously tied to a CPU feature.
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
 static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 				       struct vmcb_ctrl_area_cached *control,
 				       unsigned long l1_cr0)
@@ -370,6 +418,9 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 		return false;
 	}
 
+	if (CC(!nested_svm_check_event_inj(vcpu, control->event_inj)))
+		return false;
+
 	return true;
 }
 
-- 
2.53.0.414.gf7e9f6c205-goog


