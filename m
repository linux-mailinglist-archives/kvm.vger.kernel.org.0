Return-Path: <kvm+bounces-56839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE3EB44505
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 20:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A42A16B015
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B70341669;
	Thu,  4 Sep 2025 18:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="akGGLk4h"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C19340DA0
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 18:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757009183; cv=none; b=Tz2EksI2EmR/ssYQWY1Kj0PIb9fs0mxA/rizvRBzWFnqeZj3b2YK7LN7Xsztp5m8+eCLqZqvC3hSFSw6PqbpnTvshLVW7+lYzp2bmMlFKQbDel2cqtIBurDOf1AQBk2D1FKMRq8u14u+isAmG0ZEnI83zDeOgMmE+NVdwWiTqbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757009183; c=relaxed/simple;
	bh=VVJ4tHWNmGolrTUhrc+/MpYbq1FrQ3NJgTmV91NqfzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obQg78y0/Bu7AcIPDn30M1jWC+rDA9lb2QUQzI6kug6DBtr3Fo6Lc7gUztGd55Atmvi51Y4EMZS0QmVFAtatkm+aqwAIvlzf9tWNf0kE0AQVQYhltXH3jDRmJJcPSLFDHCAhXB8/idJepkF67vL1DHcdHQKawSNQhd+M0jDe6KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=akGGLk4h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4839C4CEF0;
	Thu,  4 Sep 2025 18:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757009182;
	bh=VVJ4tHWNmGolrTUhrc+/MpYbq1FrQ3NJgTmV91NqfzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akGGLk4hzCtS6gRsRsT94kkhkLccDTBi39HhXFFwPW3a/virjRvboeI2FA480At7h
	 sPOr6d1WUEa1fW1pIBeFjlMZpljgJ+pErNV3STfHuxLoclMdavSnVBwdKPkCKSJBko
	 xWoiLI7ieGyvzdO2O+9weVM641JcnXdJn/t++fPYaeb9UKSa/owhMesVp4kyyO2IKk
	 1ivyNqV7N92axhcM7rAexGMixlmtorIrVA8kM0xeYqVuMiyNoeNivmD7PpHScWJ4xJ
	 +kK66iC5iVV8nNWDhrDh0LS53UExYQ+JEqh3NwUfdkXfUfoo/GTT9hbOMyVPakwjfc
	 VEeppEWzu2HCQ==
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
Subject: [RFC PATCH v2 4/5] KVM: SVM: Move 'force_avic' module parameter to svm.c
Date: Thu,  4 Sep 2025 23:30:41 +0530
Message-ID: <1a69b5a7a6eea24fc93f9dc5fb60bc9f434568d3.1756993734.git.naveen@kernel.org>
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

Move 'force_avic' module parameter from avic.c to svm.c so that all SVM
module parameters are consolidated in a single place.

No functional change.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/kvm/svm/svm.h  | 2 +-
 arch/x86/kvm/svm/avic.c | 5 +----
 arch/x86/kvm/svm/svm.c  | 5 ++++-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ec2e275829a6..d332930b3dae 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -802,7 +802,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG)	\
 )
 
-void avic_hardware_setup(void);
+void avic_hardware_setup(bool force_avic);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 620583b2ddd1..9fe1fd709458 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -64,9 +64,6 @@
 
 static_assert(__AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_IDX_MASK) == -1u);
 
-static bool force_avic;
-module_param_unsafe(force_avic, bool, 0444);
-
 /* Note:
  * This hash table is used to map VM_ID to a struct kvm_svm,
  * when handling AMD IOMMU GALOG notification to schedule in
@@ -1096,7 +1093,7 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
  * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
  * - The mode can be switched at run-time.
  */
-void avic_hardware_setup(void)
+void avic_hardware_setup(bool force_avic)
 {
 	bool enable = false;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d5854e0bc799..b66fbfd47d4c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -166,6 +166,9 @@ bool avic;
 module_param(avic, bool, 0444);
 module_param(enable_ipiv, bool, 0444);
 
+static bool force_avic;
+module_param_unsafe(force_avic, bool, 0444);
+
 module_param(enable_device_posted_irqs, bool, 0444);
 
 bool __read_mostly dump_invalid_vmcb;
@@ -5406,7 +5409,7 @@ static __init int svm_hardware_setup(void)
 			goto err;
 	}
 
-	avic_hardware_setup();
+	avic_hardware_setup(force_avic);
 
 	if (!enable_apicv) {
 		enable_ipiv = false;
-- 
2.50.1


