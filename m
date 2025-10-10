Return-Path: <kvm+bounces-59755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D5AF8BCB4ED
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 02:55:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2864A4E620C
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 00:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AD3C218AAF;
	Fri, 10 Oct 2025 00:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PXa1Sw83"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115BB1A275;
	Fri, 10 Oct 2025 00:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760057694; cv=none; b=k9vtxERRq36VI9jbsCnzkA6MEwS3zgKm2Jrs5smUh+Bma7pshKWZ3DU/bAdaGMKdoxh+5c4dtdogL01Ry6zf8oAfG/eW1IJZpuqpBRiIOsqBMq7nhfWP8QzLJsv8i+FEL0VbrlySes2iIfcE6i9ZrnmDh3mzClAKCw8swp6TJ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760057694; c=relaxed/simple;
	bh=6tpVfeUi64SDfpD/TuMnOGOY+QIUVrneL+7BKB6uK44=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U4G9YCNx6B9lVHcOv6p1Gh3SOepMxTLj+PIay95QL9LpaNsGWfqVOciNZjJoqkppbmQIsyqx3HvnwgyXeCxXgjb84GxjACysS8P2gvVZCJDgbwFSMKFfn8pFObBNQiKSwdKvux9ptWAUGUGuxUx8fKOKZbqGW7+hZKCVA23yJX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PXa1Sw83; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760057692; x=1791593692;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6tpVfeUi64SDfpD/TuMnOGOY+QIUVrneL+7BKB6uK44=;
  b=PXa1Sw83afvtftQWkXnW33aEauUqID3jHfXYXdioOqI2lXmaVXUgMhpX
   5y3tpl4JkNtCyfNZsSdwrtEvDnh1DN0Xku+gDZocv808hYY504ccWg+9O
   7Rgb6k2Es5gzMgpxtbLIOWXmmCvoY+Tr/GONCYvGlbElDX03WkroDmb8P
   hkpr7a63IBydaqbWwDBaBf02vZ1cqo0i8QFoNRP0lktAShiosjBMm4SQY
   hmd5x1Q5//0R027H3hg2YfaMRZn1tVfl/OK5LkvSg8gHCKETBlwOqwcQK
   vwU/M5Ee3QdTNU7JxWDk+sLe0hPK/58JiY+xWLe/4iqg5qaelTttuSgkj
   A==;
X-CSE-ConnectionGUID: MrpsMRTNR5CEjLD1akvmyg==
X-CSE-MsgGUID: D1ShDY/sSEyPfYA2nTJthQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62215204"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62215204"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 17:54:51 -0700
X-CSE-ConnectionGUID: aCNHoqA/RcKb+ydGBo+VMw==
X-CSE-MsgGUID: DRqfLx2aSEGOPeJ70WoBpw==
X-ExtLoop1: 1
Received: from spr.sh.intel.com ([10.112.230.239])
  by fmviesa003.fm.intel.com with ESMTP; 09 Oct 2025 17:54:48 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Subject: [PATCH] KVM: x86/pmu: Fix the warning in perf_get_x86_pmu_capability()
Date: Fri, 10 Oct 2025 08:52:39 +0800
Message-Id: <20251010005239.146953-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When load KVM module in Intel hybrid platforms, the warning below is
observed.

<4>[   10.973827] ------------[ cut here ]------------
<4>[   10.973841] WARNING: arch/x86/events/core.c:3089 at
perf_get_x86_pmu_capability+0xd/0xc0, CPU#15: (udev-worker)/386
...
<4>[   10.974028] Call Trace:
<4>[   10.974030]  <TASK>
<4>[   10.974033]  ? kvm_init_pmu_capability+0x2b/0x190 [kvm]
<4>[   10.974154]  kvm_x86_vendor_init+0x1b0/0x1a40 [kvm]
<4>[   10.974248]  vmx_init+0xdb/0x260 [kvm_intel]
<4>[   10.974278]  ? __pfx_vt_init+0x10/0x10 [kvm_intel]
<4>[   10.974296]  vt_init+0x12/0x9d0 [kvm_intel]
<4>[   10.974309]  ? __pfx_vt_init+0x10/0x10 [kvm_intel]
<4>[   10.974322]  do_one_initcall+0x60/0x3f0
<4>[   10.974335]  do_init_module+0x97/0x2b0
<4>[   10.974345]  load_module+0x2d08/0x2e30
<4>[   10.974349]  ? __kernel_read+0x158/0x2f0
<4>[   10.974370]  ? kernel_read_file+0x2b1/0x320
<4>[   10.974381]  init_module_from_file+0x96/0xe0
<4>[   10.974384]  ? init_module_from_file+0x96/0xe0
<4>[   10.974399]  idempotent_init_module+0x117/0x330
<4>[   10.974415]  __x64_sys_finit_module+0x73/0xe0

The root cause is the helper perf_get_x86_pmu_capability() is called
unconditionally but it's supposed to be called only on non-hybrid
platforms.

This patch fixes this warning by only calling
perf_get_x86_pmu_capability() on non-hybrid platforms.

Reported-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Closes: https://lore.kernel.org/all/70b64347-2aca-4511-af78-a767d5fa8226@intel.com/
Fixes: 51f34b1e650f ("KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabilities")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/pmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 40ac4cb44ed2..487ad19a236e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -108,16 +108,18 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
 	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
 
-	perf_get_x86_pmu_capability(&kvm_host_pmu);
-
 	/*
 	 * Hybrid PMUs don't play nice with virtualization without careful
 	 * configuration by userspace, and KVM's APIs for reporting supported
 	 * vPMU features do not account for hybrid PMUs.  Disable vPMU support
 	 * for hybrid PMUs until KVM gains a way to let userspace opt-in.
 	 */
-	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
+	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) {
 		enable_pmu = false;
+		memset(&kvm_host_pmu, 0, sizeof(kvm_host_pmu));
+	} else {
+		perf_get_x86_pmu_capability(&kvm_host_pmu);
+	}
 
 	if (enable_pmu) {
 		/*
-- 
2.34.1


