Return-Path: <kvm+bounces-7108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D0D83D69A
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:39:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27D26B22A42
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C3514690E;
	Fri, 26 Jan 2024 08:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aMlBu1CE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A590F2CCBA;
	Fri, 26 Jan 2024 08:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259443; cv=none; b=EDcB2aDflmrmz1EQQeqVydv+dm792GUXP/kdJHFLr/oGfnArGeWqnVkfDCUqpPB0s+I7mIOKoQ2oFOCBApZhjBpfYvpJHk+4EnE30C5vi9LgWOx8pr831PvXtYSzb/1dxtkpeSoTUoT4m2B6CdNEdJILQJEXlR+mJFXOcEI2050=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259443; c=relaxed/simple;
	bh=V0id36e60eND+On5Khb7B6IqZw2Pup4EU6AuAcO37IM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KLRTwCAwze99ts7mhquFelYlim1oFB9FXV4XLk/NbSr2Y77rBa7h9DeA4FWa2Sg/HvUOczDL1dQfPCJ4J5NZJ3r9QbIdv/dn7hBA4k7zgcon4fX8JWPGMdUIaDh6o4dQ9v1jEXFv5DVSWtqv/dTL/zyzxEHObdMPmWeNywIPskQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aMlBu1CE; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259443; x=1737795443;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V0id36e60eND+On5Khb7B6IqZw2Pup4EU6AuAcO37IM=;
  b=aMlBu1CEf7X00XIfXqywfqWgnrtGq4Nj6ZQx62OlZR4fQR+iHimjND7U
   G1UhXEVkaDIukeAS111U+MxB62qN7unjYFknCiwm0ud0XFPZfPIikAohm
   JJgTJ84umBFNOc/Vz0RWYyYofeVbdhujSNHtjVhdwlvLV1FlO3eLq3C0X
   lfiDT56bw10Ea2wFyQJEKzTpIH+DVAKY2/NaN9iDdMWbyuYp/6M3oOqZk
   O607sYmFryaKS7Km3HBqT00DDaj5uacr5u3vI8YXSZESgHaKGHxuJ0xwx
   /pPouLzv2S37/FI+Bg0GMWhVajIVRLjr7Z48gQCRvYvg6C2NbMHEpowIp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792649"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792649"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310116"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310116"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:17 -0800
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
	xiong.y.zhang@linux.intel.com
Subject: [RFC PATCH 21/41] KVM: x86/pmu: Introduce function prototype for Intel CPU to save/restore PMU context
Date: Fri, 26 Jan 2024 16:54:24 +0800
Message-Id: <20240126085444.324918-22-xiong.y.zhang@linux.intel.com>
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

Implement a PMU function prototype for Intel CPU.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 49df154fbb5b..0d58fe7d243e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -821,6 +821,14 @@ void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
 	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL, MSR_TYPE_RW, false);
 }
 
+static void intel_save_pmu_context(struct kvm_vcpu *vcpu)
+{
+}
+
+static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
+{
+}
+
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.hw_event_available = intel_hw_event_available,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
@@ -836,6 +844,8 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.cleanup = intel_pmu_cleanup,
 	.passthrough_pmu_msrs = intel_passthrough_pmu_msrs,
+	.save_pmu_context = intel_save_pmu_context,
+	.restore_pmu_context = intel_restore_pmu_context,
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = 1,
-- 
2.34.1


