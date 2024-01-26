Return-Path: <kvm+bounces-7099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7BC483D669
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:34:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6516528DCA1
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7271013D514;
	Fri, 26 Jan 2024 08:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XXvL5DVv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9A713D4FA;
	Fri, 26 Jan 2024 08:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259398; cv=none; b=fPvkLTKSXxqQDoOAqfFc3w7BfoN7bFZqBP+9L5CRzt32/IIgx83nIf10jtGnwn/tTIQ12Z90s8zYsfOKmSQ3wwVjSDzdm8k+okuDXn03upWyf8Lc7Fk6l0GEEm4NqRpIeEm8zmFI8QuzM87NgHm+FAL4NrxQA1xQObCk83GGMQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259398; c=relaxed/simple;
	bh=4CDJXW+Iqla+g6XKfF9G2UkkPi35sYQa5Y0bL/jzoKY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FMbe0q0QqRG/j2f9dTWxgfsn9y7OVGxPZ7IGTdpVaOWD5FR1bGeXutcsNIPJnVJ2yBr7+hyk6Emd8nQHIJ1PQT7s8RX9TkwpbcC8TNvk2OVVWZsFO8dM8TiETvvvvpzNeCA+yXG/jCoOP59LoxruR2j3JaHxKAdrxkQMnomgAZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XXvL5DVv; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259397; x=1737795397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4CDJXW+Iqla+g6XKfF9G2UkkPi35sYQa5Y0bL/jzoKY=;
  b=XXvL5DVvyJ9NtQLOaVElfGQOow/3u3Ai07UeQ3k0aYjTpFJsaXSZuQaZ
   Co5++pvO1A1d7qIiU2NcFzmo5JUdTasWzZuEgxlYskdBtzXahSXfeMvQv
   RX1T0j/hoWKnP6N73cgVN1U98HWwr7Da4CVRa2n5bjUDvhJh/rac7XnLR
   VJVE4yAVcEBAWmBUJo5cUJLwwandQqnCwLuEMEkLsa/72E/t6DXHtb/oU
   +BbXO3vXb2GzmaM77C6bJZMXC/qAnn85+2/FGznpU2xwK9DFpoEJ9KcvW
   0oy5vwon0hfeuJEfemKEI5MrIGS4UnzXZotPpJC96dRITXiJOlwFArYsz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792232"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792232"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310020"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310020"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:31 -0800
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
Subject: [RFC PATCH 12/41] KVM: x86/pmu: Plumb through passthrough PMU to vcpu for Intel CPUs
Date: Fri, 26 Jan 2024 16:54:15 +0800
Message-Id: <20240126085444.324918-13-xiong.y.zhang@linux.intel.com>
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

From: Mingwei Zhang <mizhang@google.com>

Plumb through passthrough PMU setting from kvm->arch into kvm_pmu on each
vcpu created. Note that enabling PMU is decided by VMM when it sets the
CPUID bits exposed to guest VM. So plumb through the enabling for each pmu
in intel_pmu_refresh().

Co-developed-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/pmu.c              |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 10 ++++++++--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f2e73e6830a3..ede45c923089 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -575,6 +575,8 @@ struct kvm_pmu {
 	 * redundant check before cleanup if guest don't use vPMU at all.
 	 */
 	u8 event_count;
+
+	bool passthrough;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 9ae07db6f0f6..1853739a59bf 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -665,6 +665,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_pmu_init)(vcpu);
 	pmu->event_count = 0;
 	pmu->need_cleanup = false;
+	pmu->passthrough = false;
 	kvm_pmu_refresh(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 820d3e1f6b4f..15cc107ed573 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -517,14 +517,20 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa);
-	if (!entry || !vcpu->kvm->arch.enable_pmu)
+	if (!entry || !vcpu->kvm->arch.enable_pmu) {
+		pmu->passthrough = false;
 		return;
+	}
 	eax.full = entry->eax;
 	edx.full = entry->edx;
 
 	pmu->version = eax.split.version_id;
-	if (!pmu->version)
+	if (!pmu->version) {
+		pmu->passthrough = false;
 		return;
+	}
+
+	pmu->passthrough = vcpu->kvm->arch.enable_passthrough_pmu;
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 kvm_pmu_cap.num_counters_gp);
-- 
2.34.1


