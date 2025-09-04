Return-Path: <kvm+bounces-56838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E236B44501
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 20:06:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05FFF17C244
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2BA2341653;
	Thu,  4 Sep 2025 18:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOES5dvO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17311335BA5
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 18:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757009169; cv=none; b=trqca+8sNc169zJURiaw/EZpOu7Z+Wd5CsnXPQhZ67zemhD7JsL+y1+J+PtNKH9B0i1LnECN5s4L0ci1lctXlNckPrDhkuEBWrB9f6j9HY3kF2F6EQDSnHXPs/VSUEmeaZci6AnKJQrPpop7R/earPe4DHllMFPu7KFb5d6SK+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757009169; c=relaxed/simple;
	bh=p7AD3XCyaJUJpSGFNpQq9k95t0kU+MzoM+n2JU1tl7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=um+BBmJ/8z+xOBpFfWY69i+E3Bml5+9Ye/Ic/4Uls+eFmZarw0dlosLsTgyGTxtOsr3/T0P5gDnXsd8t9wuvQ6jhBS9bKbqYMzYo8VXgkc5gYPBk1ArCSnqrhzGFxvwqT1K3/bUx+Ent9+Y0zdp+v605O352T8LHpwavoIN7EwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IOES5dvO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD6AC4CEF0;
	Thu,  4 Sep 2025 18:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757009169;
	bh=p7AD3XCyaJUJpSGFNpQq9k95t0kU+MzoM+n2JU1tl7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOES5dvOtzl2Tnb4h0hLj02s3bvvKEnEX2uCYwb0myyfQuHSYLCZmM2ETW4pBUNkp
	 +jF9P/rvWNOVSg1vIEVbU6mRDmj1CBpxfre8/rvQU04HDc1HmJUcb7v8GIIk3A4iSJ
	 hIJVVI8Q4UTj738jnAIhVGVLD3r8z568qmRwENRD1DOt4Q3+XS5y+fw1ZII8W7fB3/
	 I6xfxBo0QcQyVcLftry2Cg9Ty54XJq0USrTJXdN1OaTBRxX7HFJBTj0Ae5ILeNl1+v
	 oekrGkTpYDduAxyufIhzHdGuMQadIQNLQGPGwVOsOeuE+sLJPL53GA52H8OnBadaBw
	 yFNjeedia9k7A==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [RFC PATCH v2 3/5] KVM: SVM: Move all AVIC setup to avic_hardware_setup()
Date: Thu,  4 Sep 2025 23:30:40 +0530
Message-ID: <aa7c82543158f6ac27c7aff8feaf6c7830236894.1756993734.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756993734.git.naveen@kernel.org>
References: <cover.1756993734.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consolidate all AVIC-related setup in avic_hardware_setup() to match
other SVM setup functions (sev_hardware_setup() et al).

No functional change.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/kvm/svm/svm.h  |  3 ++-
 arch/x86/kvm/svm/avic.c | 17 +++++++++++------
 arch/x86/kvm/svm/svm.c  |  4 ++--
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3c7f208b7935..ec2e275829a6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -48,6 +48,7 @@ extern bool npt_enabled;
 extern int nrips;
 extern int vgif;
 extern bool intercept_smi;
+extern bool avic;
 extern bool x2avic_enabled;
 extern bool vnmi;
 extern int lbrv;
@@ -801,7 +802,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG)	\
 )
 
-bool avic_hardware_setup(void);
+void avic_hardware_setup(void);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3faed85fcacd..620583b2ddd1 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1096,20 +1096,23 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
  * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
  * - The mode can be switched at run-time.
  */
-bool avic_hardware_setup(void)
+void avic_hardware_setup(void)
 {
-	if (!npt_enabled)
-		return false;
+	bool enable = false;
+
+	if (!avic || !npt_enabled)
+		goto out;
 
 	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic)
-		return false;
+		goto out;
 
 	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
 	    !boot_cpu_has(X86_FEATURE_HV_INUSE_WR_ALLOWED)) {
 		pr_warn("AVIC disabled: missing HvInUseWrAllowed on SNP-enabled system\n");
-		return false;
+		goto out;
 	}
 
+	enable = true;
 	pr_info("AVIC enabled%s\n", cpu_feature_enabled(X86_FEATURE_AVIC) ? "" :
 				    " (forced, your system may crash and burn)");
 
@@ -1128,5 +1131,7 @@ bool avic_hardware_setup(void)
 
 	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 
-	return true;
+out:
+	avic = enable;
+	enable_apicv = avic;
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cb4f81be0024..d5854e0bc799 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -162,7 +162,7 @@ module_param(tsc_scaling, int, 0444);
  * enable / disable AVIC.  Because the defaults differ for APICv
  * support between VMX and SVM we cannot use module_param_named.
  */
-static bool avic;
+bool avic;
 module_param(avic, bool, 0444);
 module_param(enable_ipiv, bool, 0444);
 
@@ -5406,7 +5406,7 @@ static __init int svm_hardware_setup(void)
 			goto err;
 	}
 
-	enable_apicv = avic = avic && avic_hardware_setup();
+	avic_hardware_setup();
 
 	if (!enable_apicv) {
 		enable_ipiv = false;
-- 
2.50.1


