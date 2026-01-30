Return-Path: <kvm+bounces-69656-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aNNQALQSfGm4KQIAu9opvQ
	(envelope-from <kvm+bounces-69656-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 03:08:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C534B654C
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 03:08:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D93DE301AD39
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 02:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CD63312812;
	Fri, 30 Jan 2026 02:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ko/KcRKr"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1DC274B48;
	Fri, 30 Jan 2026 02:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769738902; cv=none; b=U9C95OlY2+cxSeIQLiX7uU1qPGELh+SptgYzZsNovO9V1epYBmqlVF7Y3tmMEG7YJcHe3aYkrYW2ag1Rsho0w5T9TSaVXclMeNM+D1p+U7iIRbXEnGGxpJzJiFyfm6l9ZS8J1IR/6J4p/G4XcgPOuWDMp1g2H2i2XWFKPlNIVQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769738902; c=relaxed/simple;
	bh=O1QRrPqKg5mC648xLFRpHLgL7eVY2iM8HRp/SF3TDwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuU+MuEnyGBFrXcvrzOdbE2xe2AQR53jOnfzYLh7FKVzK03Vq8JTVTMif5AiFipUzwaOZ6/J17zhc8mTtm/IFo4OHgMeqiG2+ELOiAPWUm955/pkjr/CI0kxGVRJZaS1BsRzA94Ezabe22057Gye3pVCJgxI+u9dYq2WsySTy7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ko/KcRKr; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769738898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JF31oSFpVl5RgizgjEqu47HRxbHu0UtARVtac3Gefbo=;
	b=Ko/KcRKr2eYc9pI3f0n/Chw4f0qQvFPzrh7H7ugX5S2u8AMdajPYVdi8//6UWiN4wwWzdl
	7CYmZC53LKGz92fnojo0oRk07Yl0MRvprJFVozgAYIChPjaSZNv8R7PPkhoO+P73X0z+pc
	kB8a+0EF28dp7JcmEQmu6ccks+dWA4k=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 1/3] KVM: SVM: Refactor EFER.SVME switching logic out of svm_set_efer()
Date: Fri, 30 Jan 2026 02:07:33 +0000
Message-ID: <20260130020735.2517101-2-yosry.ahmed@linux.dev>
In-Reply-To: <20260130020735.2517101-1-yosry.ahmed@linux.dev>
References: <20260130020735.2517101-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69656-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email,linux.dev:dkim,linux.dev:mid]
X-Rspamd-Queue-Id: 9C534B654C
X-Rspamd-Action: no action

Move the logic of switching EFER.SVME in the guest outside of
svm_set_efer(). This makes it possible to easily check the skip
conditions separately (and add more) and reduce indentation level.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 72 ++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5f0136dbdde6b..4575a6a7d6c4e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -200,11 +200,49 @@ static int get_npt_level(void)
 #endif
 }
 
+static int svm_set_efer_svme(struct kvm_vcpu *vcpu, u64 old_efer, u64 new_efer)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int r;
+
+	if ((old_efer & EFER_SVME) == (new_efer & EFER_SVME))
+		return 0;
+
+	if (new_efer & EFER_SVME) {
+		r = svm_allocate_nested(svm);
+		if (r)
+			return r;
+
+		/*
+		 * Never intercept #GP for SEV guests, KVM can't decrypt guest
+		 * memory to workaround the erratum.
+		 */
+		if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
+			set_exception_intercept(svm, GP_VECTOR);
+	} else {
+
+		svm_leave_nested(vcpu);
+		/* #GP intercept is still needed for vmware backdoor */
+		if (!enable_vmware_backdoor)
+			clr_exception_intercept(svm, GP_VECTOR);
+
+		/*
+		 * Free the nested guest state, unless we are in SMM.  In this
+		 * case we will return to the nested guest as soon as we leave
+		 * SMM.
+		 */
+		if (!is_smm(vcpu))
+			svm_free_nested(svm);
+	}
+	return 0;
+}
+
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 old_efer = vcpu->arch.efer;
 	vcpu->arch.efer = efer;
+	int r;
 
 	if (!npt_enabled) {
 		/* Shadow paging assumes NX to be available.  */
@@ -214,36 +252,10 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 			efer &= ~EFER_LME;
 	}
 
-	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
-		if (!(efer & EFER_SVME)) {
-			svm_leave_nested(vcpu);
-			/* #GP intercept is still needed for vmware backdoor */
-			if (!enable_vmware_backdoor)
-				clr_exception_intercept(svm, GP_VECTOR);
-
-			/*
-			 * Free the nested guest state, unless we are in SMM.
-			 * In this case we will return to the nested guest
-			 * as soon as we leave SMM.
-			 */
-			if (!is_smm(vcpu))
-				svm_free_nested(svm);
-
-		} else {
-			int ret = svm_allocate_nested(svm);
-
-			if (ret) {
-				vcpu->arch.efer = old_efer;
-				return ret;
-			}
-
-			/*
-			 * Never intercept #GP for SEV guests, KVM can't
-			 * decrypt guest memory to workaround the erratum.
-			 */
-			if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
-				set_exception_intercept(svm, GP_VECTOR);
-		}
+	r = svm_set_efer_svme(vcpu, old_efer, efer);
+	if (r) {
+		vcpu->arch.efer = old_efer;
+		return r;
 	}
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
-- 
2.53.0.rc1.225.gd81095ad13-goog


