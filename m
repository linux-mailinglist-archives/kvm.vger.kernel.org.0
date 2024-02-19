Return-Path: <kvm+bounces-9021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EACB859D81
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:52:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB638B223FC
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A5FB2E835;
	Mon, 19 Feb 2024 07:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ElChzFnt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72ED20B28;
	Mon, 19 Feb 2024 07:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328871; cv=none; b=Vffat+IDOhyJq+W8vDTC/poDGfPJ8YkmFVvoa1WKpZ848yuGJpVHNe7jYFz+T8aTrjAP7rjWdUmNHDNZYSubW7Jh+wh/DdBFjiGdbdwDfM79qSWsWfbkFtA+U3RLoayO6fFoFztEGNbPISQXTosbKosWf5PYXw6Xp2LRTOtDylQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328871; c=relaxed/simple;
	bh=iFPryYlo0x9QbRdEVDhSTPJscWPbWs0HWCWU5SaS5aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nu1U1CjUbYB1X1QN7/kLQOyCys4NaNXi1Rl1UEVNxCzyr76Qvru4X2l9nDzJdK4kZolGIedjYUYw5nUAvPwWFT26xTNWEY3vzalOohHlB+eLnMBWuXWHcF4POPxLjOScjSFyOs/DkBqO1NpiQWQ5cXiMvaVmoO9zWpxeBDYQkck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ElChzFnt; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328869; x=1739864869;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iFPryYlo0x9QbRdEVDhSTPJscWPbWs0HWCWU5SaS5aI=;
  b=ElChzFntSW8JIgRMagpDXFfz68uUhmLpaoNhDhZ6daODrzQuIueRspVG
   yQfcacagbk3DHalM6g4atYJTNNvxQQ9EiVFDqw3YG38DkRyjtDiZ1lwk+
   cqvdFHBVVuLHAJ2C9ZuGd6pwUzVUiq5eGpIGM0CiunHmNdJwo4XniiBES
   3AVtD6XO14MyKsfIP7KfBKtKYKTAgFWqWIsrMtmfhJoFkBI9WbvvmSAbZ
   rN/8KQWKDi4pm0TLkcbXPOGbbg1PNcJQPGXKmfHjkTVEJl423h/7zLMKx
   0e+J0AL/0e6jX6axeh2/ybOkNSPuRPUi7VNjsqVUuuIa+C94653Js+sOR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535068"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535068"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966081"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966081"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:43 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 08/27] KVM: x86: Rework cpuid_get_supported_xcr0() to operate on vCPU data
Date: Sun, 18 Feb 2024 23:47:14 -0800
Message-ID: <20240219074733.122080-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Rework and rename cpuid_get_supported_xcr0() to explicitly operate on
vCPU state, i.e. on a vCPU's CPUID state, now that the only usage of
the helper is to retrieve a vCPU's already-set CPUID.

Prior to commit 275a87244ec8 ("KVM: x86: Don't adjust guest's CPUID.0x12.1
(allowed SGX enclave XFRM)"), KVM incorrectly fudged guest CPUID at runtime,
which in turn necessitated massaging the incoming CPUID state for
KVM_SET_CPUID{2} so as not to run afoul of kvm_cpuid_check_equal().
I.e. KVM also invoked cpuid_get_supported_xcr0() with the incoming CPUID
state, and thus without an explicit vCPU object.

Opportunistically move the helper below kvm_update_cpuid_runtime() to make
it harder to repeat the mistake of querying supported XCR0 for runtime
updates.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/cpuid.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index adba49afb5fe..d57a6255b19f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -247,21 +247,6 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 		vcpu->arch.pv_cpuid.features = best->eax;
 }
 
-/*
- * Calculate guest's supported XCR0 taking into account guest CPUID data and
- * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
- */
-static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
-{
-	struct kvm_cpuid_entry2 *best;
-
-	best = cpuid_entry2_find(entries, nent, 0xd, 0);
-	if (!best)
-		return 0;
-
-	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
-}
-
 static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
 				       int nent)
 {
@@ -312,6 +297,21 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
+/*
+ * Calculate guest's supported XCR0 taking into account guest CPUID data and
+ * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
+ */
+static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 0);
+	if (!best)
+		return 0;
+
+	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
+}
+
 static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
 {
 #ifdef CONFIG_KVM_HYPERV
@@ -361,8 +361,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_apic_set_version(vcpu);
 	}
 
-	vcpu->arch.guest_supported_xcr0 =
-		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
+	vcpu->arch.guest_supported_xcr0 = vcpu_get_supported_xcr0(vcpu);
 
 	kvm_update_pv_runtime(vcpu);
 
-- 
2.43.0


