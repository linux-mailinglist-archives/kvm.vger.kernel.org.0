Return-Path: <kvm+bounces-62484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCFDC44F1A
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 06:03:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC1D63B090C
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 05:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046BC2E7651;
	Mon, 10 Nov 2025 05:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fFA1wVqd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFEF34D395;
	Mon, 10 Nov 2025 05:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762751018; cv=none; b=g0H4Vue6XPWMRsZE0x8YiaQjk+vc4l2CkLOD4NxnLumSc364QThVQDi0d4ICAlX6hFInejtoUj+wKOU5RunGtJx6lTG9uZnhRh8DQpn2E/uTu8vLeE71ap2btqeh6DCV+2Uz2hqVE8Nb2+dNHDV4znLUYKjAU0s+8QXv5O/cgjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762751018; c=relaxed/simple;
	bh=3GT022IDl51OJ3HfZWkBX/7wSTp7WCuq70lx/F2NMGU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QJR4SZh4v5wdCDd5VXqk917ZrHO0CBsKZNZAiOhITsHu/U6Y+9jybeLZ8BikG07+OdDBT7DEXQiTfQMEpeYU1+dOlOuRFQFaNXSlh6357mjohdOVRZZsDs4UmA4crO80LVhSN8smcksbaKUAFCefF1NIrY2LJBpwV8wdOPlO9fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fFA1wVqd; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762751016; x=1794287016;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3GT022IDl51OJ3HfZWkBX/7wSTp7WCuq70lx/F2NMGU=;
  b=fFA1wVqd6LXcQMEQy4Ch7YB1Tne4+N+2Fx03IDMY0b3y579T9De4EgPl
   fWO/REZp4k+81tnbWx8ULksL5b0HeNDfuvpo9ojBNL6SQiDNlBeUMw4AD
   XV0WGixQrLtb5K6vv2U4fHe3NThr45xOmi8kPicBRtjMoQ60E1xUAUY4l
   7uUhN66agohog4XhiW2aa+okbAy6KiC+mnkTjTIW+mvn+2SM0ckVvXPBe
   dKyHoFf2x6fgE6ByfkWMT/wBHzpzIlClZCav+B/iRc18ryyxWsTaZTPvh
   n8EhiAzwAt8oTssVTA5Sn6hsQMG9AWbHy/wuTWFJ7TQc1FTPDYa68/+2/
   w==;
X-CSE-ConnectionGUID: 1gRIsznvT9yiJ8iTvjJHyA==
X-CSE-MsgGUID: 83WrxgQ8RBWqNqcCbBJCrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11608"; a="68440706"
X-IronPort-AV: E=Sophos;i="6.19,292,1754982000"; 
   d="scan'208";a="68440706"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 21:03:35 -0800
X-CSE-ConnectionGUID: Hvdkg7nxRCmSTSVjE7LqvA==
X-CSE-MsgGUID: 3s+bEmmlQp264ZTqeIHwDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,292,1754982000"; 
   d="scan'208";a="188321481"
Received: from litbin-desktop.sh.intel.com ([10.239.159.60])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 21:03:34 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com
Subject: [PATCH v2] KVM: x86: Add a helper to dedup loading guest/host XCR0 and XSS
Date: Mon, 10 Nov 2025 13:05:39 +0800
Message-ID: <20251110050539.3398759-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add and use a helper, kvm_load_xfeatures(), to dedup the code that loads
guest/host xfeatures.

Opportunistically return early if X86_CR4_OSXSAVE is not set to reduce
indentations.

No functional change intended.

Suggested-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
v2:
- Pass a bool to distinguish guest/host. [Chao, Xiaoyao]
- Fix a typo in the short log. [Chao]
- Opportunistically return early if X86_CR4_OSXSAVE is not set to reduce
  indentations.

v1:
- https://lore.kernel.org/kvm/20251106101138.2756175-1-binbin.wu@linux.intel.com
---
 arch/x86/kvm/x86.c | 33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9c2e28028c2b..2c521902e2c6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1219,34 +1219,21 @@ void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_lmsw);
 
-static void kvm_load_guest_xfeatures(struct kvm_vcpu *vcpu)
+static void kvm_load_xfeatures(struct kvm_vcpu *vcpu, bool load_guest)
 {
 	if (vcpu->arch.guest_state_protected)
 		return;
 
-	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
-		if (vcpu->arch.xcr0 != kvm_host.xcr0)
-			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
-
-		if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
-		    vcpu->arch.ia32_xss != kvm_host.xss)
-			wrmsrq(MSR_IA32_XSS, vcpu->arch.ia32_xss);
-	}
-}
-
-static void kvm_load_host_xfeatures(struct kvm_vcpu *vcpu)
-{
-	if (vcpu->arch.guest_state_protected)
+	if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE))
 		return;
 
-	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
-		if (vcpu->arch.xcr0 != kvm_host.xcr0)
-			xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
+	if (vcpu->arch.xcr0 != kvm_host.xcr0)
+		xsetbv(XCR_XFEATURE_ENABLED_MASK,
+		       load_guest ? vcpu->arch.xcr0 : kvm_host.xcr0);
 
-		if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
-		    vcpu->arch.ia32_xss != kvm_host.xss)
-			wrmsrq(MSR_IA32_XSS, kvm_host.xss);
-	}
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
+	    vcpu->arch.ia32_xss != kvm_host.xss)
+		wrmsrq(MSR_IA32_XSS, load_guest ? vcpu->arch.ia32_xss : kvm_host.xss);
 }
 
 static void kvm_load_guest_pkru(struct kvm_vcpu *vcpu)
@@ -11333,7 +11320,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_fpu.xfd_err)
 		wrmsrq(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 
-	kvm_load_guest_xfeatures(vcpu);
+	kvm_load_xfeatures(vcpu, true);
 
 	if (unlikely(vcpu->arch.switch_db_regs &&
 		     !(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))) {
@@ -11429,7 +11416,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
-	kvm_load_host_xfeatures(vcpu);
+	kvm_load_xfeatures(vcpu, false);
 
 	/*
 	 * Sync xfd before calling handle_exit_irqoff() which may

base-commit: 9052f4f6c539ea1fb7b282a34e6bb33154ce0b63
-- 
2.46.0


