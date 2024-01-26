Return-Path: <kvm+bounces-7094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 63F8983D660
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:32:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8283B2A453
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5DC6137C59;
	Fri, 26 Jan 2024 08:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GLIs00vw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802EC137C42;
	Fri, 26 Jan 2024 08:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259373; cv=none; b=hcHKQF2SIbi26xtb+7ZXGvSl3+hZdRyzuSrMkoMdObVQWm4/iKzbof0sSVDemMkXFoNCAWZ31cFPIcGD6xehDvM51W/2STNcN76xM0St5YWMq1xdSNxuDjhF60fx6fC9IkqSPhJ+1k9UFM0hUazGZ4p/VZnc971f72f5xMZ0MGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259373; c=relaxed/simple;
	bh=54n0IWcah7YMnjD6TUF3R2BJoZpEbfLCDMdkjoA+y3o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g6B8LmW2oSZabohaH8WPF/ktZT4iCnlt1USw4erPwjD9q6xpIr0d73L2+EToQm8WoRCg9uYVm9NG/novJmUla/OxcRUEdinZXsuAvgXDKaBPbOAL8bXwnbapOg1dBXeghD9YcwrxskICC/tF3g7gA23IbLdziY9w71Ishj9pMw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GLIs00vw; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259372; x=1737795372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=54n0IWcah7YMnjD6TUF3R2BJoZpEbfLCDMdkjoA+y3o=;
  b=GLIs00vwmZUqDp1H2fIi9xNFQkkw8Ixd8rr6zySyQDtiZJJOeRSpJa8Y
   bWeymP8+ZzhHs1ZcOG7n6aEOjMpSOnyg/TtmR/EcluP9teRxZn1zLFQvP
   fq4pWyDjCF9m4/PXfUbZmNYi/+3bO1O16SbRF2/N6VCDeLN4DmRkrnsxh
   5Q122Jrowq/+YTrtdjnpmmb+jmXVAXKGfpQ32nXQmtRZCYnAGagopf+4J
   czdgoS1uDIFdVvW9U2bZtTsm9PY1xc5NZNSzCCTqwcHY3HdNdtOSlp6Nh
   MzRinM2TjcCPcRcqHxEpEdbh5XGlHxZM1oXyAMU9sgtYPj2iOJqDUaMYa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792118"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792118"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930309918"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930309918"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:06 -0800
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mizhang@google.com,
	kan.liang@intel.com,
	zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com,
	jmattson@google.com
Cc: kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com,
	eranian@google.com,
	irogers@google.com,
	samantha.alt@intel.com,
	like.xu.linux@gmail.com,
	chao.gao@intel.com,
	xiong.y.zhang@linux.intel.com,
	Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [RFC PATCH 07/41] perf/x86: Add interface to reflect virtual LVTPC_MASK bit onto HW
Date: Fri, 26 Jan 2024 16:54:10 +0800
Message-Id: <20240126085444.324918-8-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiong Zhang <xiong.y.zhang@intel.com>

When guest clear LVTPC_MASK bit in guest PMI handler at PMU passthrough
mode, this bit should be reflected onto HW, otherwise HW couldn't generate
PMI again during VM running until it is cleared.

This commit set HW LVTPC_MASK bit at PMU vecctor switching to KVM PMI
vector.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/events/core.c            | 9 +++++++--
 arch/x86/include/asm/perf_event.h | 2 +-
 arch/x86/kvm/lapic.h              | 1 -
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 3f87894d8c8e..ece042cfb470 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -709,13 +709,18 @@ void perf_guest_switch_to_host_pmi_vector(void)
 }
 EXPORT_SYMBOL_GPL(perf_guest_switch_to_host_pmi_vector);
 
-void perf_guest_switch_to_kvm_pmi_vector(void)
+void perf_guest_switch_to_kvm_pmi_vector(bool mask)
 {
 	lockdep_assert_irqs_disabled();
 
-	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_VPMU_VECTOR);
+	if (mask)
+		apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_VPMU_VECTOR |
+			   APIC_LVT_MASKED);
+	else
+		apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_VPMU_VECTOR);
 }
 EXPORT_SYMBOL_GPL(perf_guest_switch_to_kvm_pmi_vector);
+
 /*
  * There may be PMI landing after enabled=0. The PMI hitting could be before or
  * after disable_all.
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 021ab362a061..180d63ba2f46 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -574,7 +574,7 @@ static inline void perf_check_microcode(void) { }
 #endif
 
 extern void perf_guest_switch_to_host_pmi_vector(void);
-extern void perf_guest_switch_to_kvm_pmi_vector(void);
+extern void perf_guest_switch_to_kvm_pmi_vector(bool mask);
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0a0ea4b5dd8c..e30641d5ac90 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -277,5 +277,4 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
 {
 	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
 }
-
 #endif
-- 
2.34.1


