Return-Path: <kvm+bounces-72457-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KKbmGPIspmncLgAAu9opvQ
	(envelope-from <kvm+bounces-72457-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:36:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C27201E72EC
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:36:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DE5F530D2D63
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC3623BF9B;
	Tue,  3 Mar 2026 00:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuN8aMxw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FFB21883E;
	Tue,  3 Mar 2026 00:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498072; cv=none; b=Epn4kZ40+xLAX90d7URngoCvqvqPfJAWToq3eF3NFf6n7mKAXDq1bSqT9HZLR7KK+6gQwV+YmvRzbkvVA5b3iQ7MsSIEC4P02Wq/grFjrud3uvugZq5Mb6Akr+tRvflSO5wIA6rAGrhudCA9uVP8dG3MbxENJ46YFHFnNb8x1iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498072; c=relaxed/simple;
	bh=wtmh9IxPpm9GtrspXY0nCDingbw85AxM/W+Q+IOm3VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTOEm+/m/EixVwqwsFxVI1BDCWgJ25OGxOit5i6LD68D6A6dGvWpo406ucj7xsC0T7KoQJR6iVtQ5FamkkJrT2R1NKcrG+O1OxfQIW7N2V9b7JovqTI79UX3NC2yGsiyudZkW6wfUwCqtauM/kdfFBUVy1qSBGG3Q4xzzLe8/yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuN8aMxw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A09FC2BC9E;
	Tue,  3 Mar 2026 00:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498072;
	bh=wtmh9IxPpm9GtrspXY0nCDingbw85AxM/W+Q+IOm3VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NuN8aMxwKLt+eWsh9H5mMM6FkvwRtRE0KayVGnP0edSIMftI+tS+KvovqFS4jEbPk
	 HNlaarGWWghKTTVdMkDce/yhrCLHe8oJRgSnk1vEGEGMTAPHZuHOFEhQ3ogujnkrYJ
	 z9x0op5I0Qv6nCIASREg73uCtnWFy74AWFrbA1JjqWIdTdT6cpkBRM9t/cZoitGCQ+
	 xz0dyMuSaDaX/gx9TL+FD9YIHrz3NPm9tK76Or59Gfqrj24R/zZntOMvWuWaVFRWIY
	 S6PpC8ozmfOzsWWtVNIe//SrIYVYw+x9aUXm/nra1o8mz4m0mlPUSBnPlPLjlVra9y
	 yk/V5CrDF69Qg==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v7 02/26] KVM: SVM: Switch svm_copy_lbrs() to a macro
Date: Tue,  3 Mar 2026 00:33:56 +0000
Message-ID: <20260303003421.2185681-3-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260303003421.2185681-1-yosry@kernel.org>
References: <20260303003421.2185681-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C27201E72EC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72457-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

In preparation for using svm_copy_lbrs() with 'struct vmcb_save_area'
without a containing 'struct vmcb', and later even 'struct
vmcb_save_area_cached', make it a macro.

Macros are generally not preferred compared to functions, mainly due to
type-safety. However, in this case it seems like having a simple macro
copying a few fields is better than copy-pasting the same 5 lines of
code in different places.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c |  8 ++++----
 arch/x86/kvm/svm/svm.c    |  9 ---------
 arch/x86/kvm/svm/svm.h    | 10 +++++++++-
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a31f3be1e16ec..f7d5db0af69ac 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -709,10 +709,10 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
 		 * svm_set_msr's definition of reserved bits.
 		 */
-		svm_copy_lbrs(vmcb02, vmcb12);
+		svm_copy_lbrs(&vmcb02->save, &vmcb12->save);
 		vmcb02->save.dbgctl &= ~DEBUGCTL_RESERVED_BITS;
 	} else {
-		svm_copy_lbrs(vmcb02, vmcb01);
+		svm_copy_lbrs(&vmcb02->save, &vmcb01->save);
 	}
 	vmcb_mark_dirty(vmcb02, VMCB_LBR);
 	svm_update_lbrv(&svm->vcpu);
@@ -1234,9 +1234,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
 		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
-		svm_copy_lbrs(vmcb12, vmcb02);
+		svm_copy_lbrs(&vmcb12->save, &vmcb02->save);
 	} else {
-		svm_copy_lbrs(vmcb01, vmcb02);
+		svm_copy_lbrs(&vmcb01->save, &vmcb02->save);
 		vmcb_mark_dirty(vmcb01, VMCB_LBR);
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a2452b8ec49db..f52e588317fcf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -841,15 +841,6 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 	 */
 }
 
-void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
-{
-	to_vmcb->save.dbgctl		= from_vmcb->save.dbgctl;
-	to_vmcb->save.br_from		= from_vmcb->save.br_from;
-	to_vmcb->save.br_to		= from_vmcb->save.br_to;
-	to_vmcb->save.last_excp_from	= from_vmcb->save.last_excp_from;
-	to_vmcb->save.last_excp_to	= from_vmcb->save.last_excp_to;
-}
-
 static void __svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
 	to_svm(vcpu)->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ebd7b36b1ceb9..44d767cd1d25a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -713,8 +713,16 @@ static inline void *svm_vcpu_alloc_msrpm(void)
 	return svm_alloc_permissions_map(MSRPM_SIZE, GFP_KERNEL_ACCOUNT);
 }
 
+#define svm_copy_lbrs(to, from)					\
+do {								\
+	(to)->dbgctl		= (from)->dbgctl;		\
+	(to)->br_from		= (from)->br_from;		\
+	(to)->br_to		= (from)->br_to;		\
+	(to)->last_excp_from	= (from)->last_excp_from;	\
+	(to)->last_excp_to	= (from)->last_excp_to;		\
+} while (0)
+
 void svm_vcpu_free_msrpm(void *msrpm);
-void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
 void svm_enable_lbrv(struct kvm_vcpu *vcpu);
 void svm_update_lbrv(struct kvm_vcpu *vcpu);
 
-- 
2.53.0.473.g4a7958ca14-goog


