Return-Path: <kvm+bounces-56840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CDE47B44508
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 20:06:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BDFF1CC377A
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 199E334165E;
	Thu,  4 Sep 2025 18:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="INtRIx6O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6D720296E
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 18:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757009191; cv=none; b=gXnoU6iE0LhvkoiJaA81M1/Ycwb4V65zcV93klsHgO4b5ZuGEHelkNWrV5FONbxzazmFfJN1tytP7kaEev4Kd07jFjNKro4JlkSGIZYog2kHQsw3DX6zM3BBD70FhfpzgsS4TfvfcAt8aabf31x9AII+v6OmJ56k8sLHmK8GJLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757009191; c=relaxed/simple;
	bh=FLXw8p6D7vb9M+OdOvoZQxzdgFoDb1iseFgu9CNrQdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPyRQcMOvq2DNDGHs5efbF/hHp6FCkSVUu6FzWgOZd1Xj1zhjAe8YucP9OsLRo19GF0jpH8GR0gPuqNUnR6IXR59p2eGbtchm1PBQv8YgVEu4DVqHWKSSM0ruM6xpnLyCk/lUROt/qensRThcn12rzUJEBstv+ss+WTuo2oHgYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=INtRIx6O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8083DC4CEF0;
	Thu,  4 Sep 2025 18:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757009191;
	bh=FLXw8p6D7vb9M+OdOvoZQxzdgFoDb1iseFgu9CNrQdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INtRIx6Ow6NFTvPl1R0/qeYeMmKBYKb8Hc0/Vsdyb6HsS79Rl1dEbav7TqwnfeEYD
	 p4PXk5UDqY7QUhYQUEw/nnbumZlOlNnLxv7ktX92N51SGEmySqT2bF2wXzHx5KCpVX
	 cW4lvaz6B46JIo3VIRo5DfRelwsfud9WvfqWdOPKPsmTcrjUxLkPVqXQ/FaxhRWBNT
	 KEzinMH32NM+cjNdIUfE2YNk9s//WbyI9IEa3U7mN2KWC2/4y5Xq1jpTvtBwMOMuWT
	 BwRhttZoPo+GdHk8CXRVe89ePYaRzWeqPZS6I4V6Soj4QGq7LK3Q1mo2nrx9tgfoDH
	 7BFCLfjui++sQ==
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
Subject: [RFC PATCH v2 5/5] KVM: SVM: Enable AVIC by default from Zen 4
Date: Thu,  4 Sep 2025 23:30:42 +0530
Message-ID: <46b11506a6cf566fd55d3427020c0efea13bfc6a.1756993734.git.naveen@kernel.org>
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

AVIC and x2AVIC are fully functional since Zen 4, with no known hardware
errata. Enable it by default on those processors, but allow users to
continue passing 'avic' module parameter to explicitly enable/disable
AVIC.

Convert 'avic' to an integer to be able to identify if the user has
asked to explicitly enable or disable AVIC. By default, 'avic' is
initialized to -1 and AVIC is enabled if Zen 4+ processor is detected
(and other dependencies are satisfied).

So as not to break existing usage of 'avic' which was a boolean, switch
to using module_param_cb() and use existing callbacks which expose this
field as a boolean (so users can still continue to pass 'avic=on' or
'avic=off') but sets an integer value.

Finally, stop warning about missing HvInUseWrAllowed on SNP-enabled
systems if trying to enable AVIC by default so as not to spam the kernel
log. Users who specifically care about AVIC can explicitly pass
'avic=on' in which case the error is still printed.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/kvm/svm/svm.h  |  2 +-
 arch/x86/kvm/svm/avic.c |  8 +++++++-
 arch/x86/kvm/svm/svm.c  | 17 +++++++++++------
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d332930b3dae..0e87e2768a1f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -48,7 +48,7 @@ extern bool npt_enabled;
 extern int nrips;
 extern int vgif;
 extern bool intercept_smi;
-extern bool avic;
+extern int avic;
 extern bool x2avic_enabled;
 extern bool vnmi;
 extern int lbrv;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 9fe1fd709458..6bd5079a01f1 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1095,8 +1095,13 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
  */
 void avic_hardware_setup(bool force_avic)
 {
+	bool default_avic = (avic == -1);
 	bool enable = false;
 
+	/* Enable AVIC by default from Zen 4 */
+	if (default_avic)
+		avic = boot_cpu_data.x86 > 0x19 || cpu_feature_enabled(X86_FEATURE_ZEN4);
+
 	if (!avic || !npt_enabled)
 		goto out;
 
@@ -1105,7 +1110,8 @@ void avic_hardware_setup(bool force_avic)
 
 	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
 	    !boot_cpu_has(X86_FEATURE_HV_INUSE_WR_ALLOWED)) {
-		pr_warn("AVIC disabled: missing HvInUseWrAllowed on SNP-enabled system\n");
+		if (!default_avic)
+			pr_warn("AVIC disabled: missing HvInUseWrAllowed on SNP-enabled system\n");
 		goto out;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b66fbfd47d4c..3d4f1ef2ff76 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -158,12 +158,17 @@ module_param(lbrv, int, 0444);
 static int tsc_scaling = true;
 module_param(tsc_scaling, int, 0444);
 
-/*
- * enable / disable AVIC.  Because the defaults differ for APICv
- * support between VMX and SVM we cannot use module_param_named.
- */
-bool avic;
-module_param(avic, bool, 0444);
+static const struct kernel_param_ops avic_ops = {
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
+	.set = param_set_bint,
+	.get = param_get_bool,
+};
+
+/* enable/disable AVIC (-1 = auto) */
+int avic = -1;
+module_param_cb(avic, &avic_ops, &avic, 0444);
+__MODULE_PARM_TYPE(avic, "bool");
+
 module_param(enable_ipiv, bool, 0444);
 
 static bool force_avic;
-- 
2.50.1


