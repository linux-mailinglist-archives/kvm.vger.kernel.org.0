Return-Path: <kvm+bounces-50841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CB2AEA1F9
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 17:08:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B58347BA912
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 15:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18BBC2EE613;
	Thu, 26 Jun 2025 15:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jY6WFcOd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4083B274FED;
	Thu, 26 Jun 2025 15:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750950020; cv=none; b=ddyGLdgX3kqmRZzsA3Z3JG4maTucAhjcOS3JHaqCdJtNPgkCDH1SYdmMew5ya6bnOCpHM3N/X//AkcTX5Dowp9xEk3Lom3UyCqLmi4ged1Zo1VNbcXZah+FRdgkMyO6ZwbBKLJPsyVqloIEr/npbNT8kYDmml5leK0y59FET6zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750950020; c=relaxed/simple;
	bh=NCW1/aOIcerxFsXM9RKk0cIz5hyj78/lxy0fK07wt7U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DKwpARzI708w2fMw469If5hQZ1BhqoDUgmLAZdjUXxnE0NVoRtVqkWsI/pvzFZxEHQkP/BpsaEVPWt54GKHcNiO7iK8ja+8/DX3eA4V3za7hQJEjfpkdT1j1QX4Pf1ltwOpdFam0ZQa9WaHZLKAfTnxGFdrcZbldIerPmzZMP6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jY6WFcOd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6497BC4CEEB;
	Thu, 26 Jun 2025 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750950019;
	bh=NCW1/aOIcerxFsXM9RKk0cIz5hyj78/lxy0fK07wt7U=;
	h=From:To:Cc:Subject:Date:From;
	b=jY6WFcOd1SGKGpGDrERjXC29gPUIPrTazpGKNCvI1U2hS6aC6UCUWA4CHC4AUp/K0
	 cb/rAlF5yM0g7vlYXFrQfkrVnTz0ZfuKZH5eUcnTisj1nTuDU4ZNq8jM8K7UrFc+D8
	 omjNMO0uJTdIJzDNPshyXS3AwgYRhXSGAYUSctH+0ncoS5EIsmcED122FfdUd4rf2u
	 KN2QZTQghyPHBhwVcfTKWU4JLRgzXgM8wHbU6jySSpe7x/elurMAd474kJziO/rPp1
	 6weQwqZwzYO7ApU/aGQaHb/24sRQxNHeqgMvDzGOLTq4LBsjFSqpQ1YOmpdKs84I1S
	 MPtVLzhyi//9w==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Cc: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [EARLY RFC] KVM: SVM: Enable AVIC by default from Zen 4
Date: Thu, 26 Jun 2025 20:21:22 +0530
Message-ID: <20250626145122.2228258-1-naveen@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is early RFC to understand if there are any concerns with enabling
AVIC by default from Zen 4. There are a few issues related to irq window
inhibits (*) that will need to be addressed before we can enable AVIC,
but I wanted to understand if there are other issues that I may not be
aware of. I will split up the changes and turn this into a proper patch
series once there is agreement on how to proceed.

AVIC (and x2AVIC) is fully functional since Zen 4, and has so far been
working well in our tests across various workloads. So, enable AVIC by
default from Zen 4.

CPUs prior to Zen 4 are affected by hardware errata related to AVIC and
workaround for those (erratum #1235) is only just landing upstream. So,
it is unlikely that anyone was using AVIC on those CPUs. Start requiring
users on those CPUs to pass force_avic=1 to explicitly enable AVIC going
forward. This helps convey that AVIC isn't fully enabled (so users are
aware of what they are signing up for), while allowing us to make
kvm_amd module parameter 'avic' as an alias for 'enable_apicv'
simplifying the code.  The only downside is that force_avic taints the
kernel, but if this is otherwise agreeable, the taint can be restricted
to the AVIC feature bit not being enabled.

Finally, stop complaining that x2AVIC CPUID feature bit is present
without basic AVIC feature bit, since that looks to be the way AVIC is
being disabled on certain systems and enabling AVIC by default will
start printing this warning on systems that have AVIC disabled.

(*) http://lkml.kernel.org/r/Z6JoInXNntIoHLQ8@google.com

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/kvm/svm/avic.c | 11 +++++------
 arch/x86/kvm/svm/svm.c  | 10 +++-------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a34c5c3b164e..bf7f91f41a6e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1101,12 +1101,11 @@ bool avic_hardware_setup(void)
 	if (!npt_enabled)
 		return false;
 
-	/* AVIC is a prerequisite for x2AVIC. */
-	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic) {
-		if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
-			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
-			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
-		}
+	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic)
+		return false;
+
+	if (!force_avic && (boot_cpu_data.x86 < 0x19 || boot_cpu_has(X86_FEATURE_ZEN3))) {
+		pr_warn("AVIC disabled due to hardware errata. Use force_avic=1 if you really want to enable AVIC.\n");
 		return false;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ab11d1d0ec51..9b5356e74384 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -158,12 +158,7 @@ module_param(lbrv, int, 0444);
 static int tsc_scaling = true;
 module_param(tsc_scaling, int, 0444);
 
-/*
- * enable / disable AVIC.  Because the defaults differ for APICv
- * support between VMX and SVM we cannot use module_param_named.
- */
-static bool avic;
-module_param(avic, bool, 0444);
+module_param_named(avic, enable_apicv, bool, 0444);
 module_param(enable_ipiv, bool, 0444);
 
 module_param(enable_device_posted_irqs, bool, 0444);
@@ -5404,7 +5399,8 @@ static __init int svm_hardware_setup(void)
 			goto err;
 	}
 
-	enable_apicv = avic = avic && avic_hardware_setup();
+	if (enable_apicv)
+		enable_apicv = avic_hardware_setup();
 
 	if (!enable_apicv) {
 		enable_ipiv = false;

base-commit: 7ee45fdd644b138e7a213c6936474161b28d0e1a
-- 
2.49.0


