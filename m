Return-Path: <kvm+bounces-37793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43939A301DB
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:58:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A91E0188B71A
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FB421D5178;
	Tue, 11 Feb 2025 02:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IlKNBTe1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAF81D6DA1;
	Tue, 11 Feb 2025 02:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242636; cv=none; b=Mf6LycFY8q2+bg9+Wmv1nz5+ENGmPBwA7tDue4w9Fn0pefoAJvAS8/g/B8EnwVBG3m9ukjJPJYWdLRPbLoxxGvXr2n7WkjvhvjJlsmJ/LlZPoxCYl/3zTPxY05gBKCW+H82KMlJjFN1kkqGoZUlX9EBxY3ioiluhR9keile6qZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242636; c=relaxed/simple;
	bh=yimWQ+EEwX+8F65ZkkQuoLulaubPyI0A9vTUIqSC1WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOnK/OvCYqpvajovg18VfXp36co51Vw0llpEp5DkYcinlE7SyjZtc1rlVcYj4NgRuugsUAOnwq26n4HqHP27muFMNTTVgDccaNCmYnPTrSlXuS91i2z9q5CEnyI3Y35K1klbRp0ceiLwUBKFUy9P/BIsr9CU6fWqsKgiuc85d3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IlKNBTe1; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242635; x=1770778635;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yimWQ+EEwX+8F65ZkkQuoLulaubPyI0A9vTUIqSC1WU=;
  b=IlKNBTe1hheEK1ZD7c23a8GCFmziKOtdtY53T9pjJIhXn5Ey7WSIyS3c
   rgyjM7pvd0akvDI9BaFo8Fh37f1k3MxNF4OnSdtYfn6hP/UA4qyeUjY0V
   hBSvTurP34Yb6y39m4Wqlr20E4Ym9dQqEsZywr7UthbJ51FSxRRZNxuPm
   hCl5D3IME8sP/Z2tsRioON+gvr8NlQiWuLz3GBycpoLikzVgMOK+XgYbf
   NnNRkilwet25Is2kZNSdr2eU9UNQ/+S9c99plM+hA7ZjgErk40FHxddqo
   sHw5U0eMe6eBeYw+rigkEuRzdzFw3Ivm9w2it0wTr0KhYO7DKNFmC2hwr
   A==;
X-CSE-ConnectionGUID: 47yXsCHWQwWkIBX1PIuXNw==
X-CSE-MsgGUID: cTs62oVnSbWKPg2lUgPXyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612448"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612448"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:11 -0800
X-CSE-ConnectionGUID: p2aIhJ+UThmb0FhLjH2EhA==
X-CSE-MsgGUID: fcbKFOr9RlOdX2Qyya1AeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355308"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:05 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 05/17] KVM: x86: Assume timer IRQ was injected if APIC state is protected
Date: Tue, 11 Feb 2025 10:58:16 +0800
Message-ID: <20250211025828.3072076-6-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

If APIC state is protected, i.e. the vCPU is a TDX guest, assume a timer
IRQ was injected when deciding whether or not to busy wait in the "timer
advanced" path.  The "real" vIRR is not readable/writable, so trying to
query for a pending timer IRQ will return garbage.

Note, TDX can scour the PIR if it wants to be more precise and skip the
"wait" call entirely.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts v2:
- No change.

TDX interrupts v1:
- Renamed from "KVM: x86: Assume timer IRQ was injected if APIC state is proteced"
  to "KVM: x86: Assume timer IRQ was injected if APIC state is protected", i.e.,
  fix the typo 'proteced'.
---
 arch/x86/kvm/lapic.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index bbdede07d063..bab5c42f63b7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1797,8 +1797,17 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 static bool lapic_timer_int_injected(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 reg = kvm_lapic_get_reg(apic, APIC_LVTT);
+	u32 reg;
 
+	/*
+	 * Assume a timer IRQ was "injected" if the APIC is protected.  KVM's
+	 * copy of the vIRR is bogus, it's the responsibility of the caller to
+	 * precisely check whether or not a timer IRQ is pending.
+	 */
+	if (apic->guest_apic_protected)
+		return true;
+
+	reg  = kvm_lapic_get_reg(apic, APIC_LVTT);
 	if (kvm_apic_hw_enabled(apic)) {
 		int vec = reg & APIC_VECTOR_MASK;
 		void *bitmap = apic->regs + APIC_ISR;
-- 
2.46.0


