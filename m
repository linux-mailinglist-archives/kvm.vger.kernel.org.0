Return-Path: <kvm+bounces-66455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A0DA3CD3BEB
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A64230421A2
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767FD22D4DD;
	Sun, 21 Dec 2025 04:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z8XqKljB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2782222BF;
	Sun, 21 Dec 2025 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291514; cv=none; b=FsLYL4gDMB3nl8gvVO9+9L5whDIo8nS38f4oQ1owdbIYd158fdCVTw5Wg6mUMEZjXLRmAwvdk3dhn5KZuZnOx3QrI135J6wkIlT8nh3LyVbY1nkFcj7og3fcPuG+/SQyg77cKXkfJ2ux7LPFiBOAD2HQTRorPEEco9r1/OFWSao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291514; c=relaxed/simple;
	bh=weuoqRDDBv7ieJ0T20j9mdN3G7/5KPySgpcXMMnRAEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohRUEhNjn2xviTwG2Sp0amswqQskj/Xks/HYiocC8aP/s9eMqvi9iYZE4kEb2Szzo7PrSuZ/M5KbUGk1x3M1DND1edf8CSSGrKhEEj/1nlwRV+egOPrW0Zd6QzKvUa8NLC9Wz3xSDnJgKFBTLQAGlNt/5ikzs2mU3pbwcbERH/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z8XqKljB; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291512; x=1797827512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=weuoqRDDBv7ieJ0T20j9mdN3G7/5KPySgpcXMMnRAEw=;
  b=Z8XqKljBu7OjCF+zyIg+duZxbjboKP+Brlhe+cCXYYQxFlsb4Uorozkm
   WKb338dTJkiOd2VXKEsJyW6htqnVlaRcJLerMExh8OrfOayGj+5R4Ojto
   YXE3H0edG+QJMAYouziK08XsnnvVV1a1O+iQ+ieLHqd+zXcQiYXyIk5kp
   dJ/GyE6156X0KX4WI6GjuhB/kzI26sH5jsrRS6CYZBqKEjkuDDnCQEY0W
   QS4GMy6nKhNuVYoSToFkWZNWr53KDiHA3yx83onVdWqvetjuyP01lpb/h
   tNmQ8dBt73kGdoBGW2pxHLnRHdHORz9pBeJXKi7J/lesdbs5Kaxb18wuQ
   g==;
X-CSE-ConnectionGUID: iiqYcbiCRXqf3vy4viLxxw==
X-CSE-MsgGUID: gvn7kgbgRfysLY8faTEVbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132435"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132435"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:52 -0800
X-CSE-ConnectionGUID: ug/PgDjlQCWO+uaun9BSsg==
X-CSE-MsgGUID: 6dbNNaz5TsGV5ET3Qc2WlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229885048"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:52 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 13/16] KVM: x86: Guard valid XCR0.APX settings
Date: Sun, 21 Dec 2025 04:07:39 +0000
Message-ID: <20251221040742.29749-14-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251221040742.29749-1-chang.seok.bae@intel.com>
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prevent invalid XCR0.APX configurations in two cases: conflict with MPX
and lack of SVM support.

In the non-compacted XSAVE format, APX and MPX conflict on the same
offset. Although MPX is being deprecated in practice, KVM should
explicitly reject such configurations that set both bits.

At this point, only VMX supports EGPRs. SVM will require corresponding
extensions to handle EGPR indices.

The addition to the supported XCR0 mask should accompany guest CPUID
exposure, which will be done separately.

Link: https://lore.kernel.org/ab3f4937-38f5-4354-8850-bf773c159bbe@redhat.com
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
Changes since last version:
* Reject setting MPX and APX bits together in XCR0 (Paolo)
* Remove XCR0 dependency for extended instruction information (Paolo)
* Rewrite the changelog accordingly
---
 arch/x86/kvm/svm/svm.c | 7 ++++++-
 arch/x86/kvm/x86.c     | 4 ++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ca1dc2342134..85a150e763b2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5299,8 +5299,13 @@ static __init int svm_hardware_setup(void)
 	}
 	kvm_enable_efer_bits(EFER_NX);
 
+	/*
+	 * APX introduces EGPRs, which require additional VMCB support.
+	 * Disable APX until the necessary extensions are handled.
+	 */
 	kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
-				     XFEATURE_MASK_BNDCSR);
+				     XFEATURE_MASK_BNDCSR  |
+				     XFEATURE_MASK_APX);
 
 	if (boot_cpu_has(X86_FEATURE_FXSR_OPT))
 		kvm_enable_efer_bits(EFER_FFXSR);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index abbc9b8736e7..0c677af83ee4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1314,6 +1314,10 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	    (!(xcr0 & XFEATURE_MASK_BNDCSR)))
 		return 1;
 
+	/* MPX and APX conflict in the non-compacted XSAVE format */
+	if (xcr0 & XFEATURE_MASK_BNDREGS && xcr0 & XFEATURE_MASK_APX)
+		return 1;
+
 	if (xcr0 & XFEATURE_MASK_AVX512) {
 		if (!(xcr0 & XFEATURE_MASK_YMM))
 			return 1;
-- 
2.51.0


