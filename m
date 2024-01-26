Return-Path: <kvm+bounces-7114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 815BC83D6B0
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:43:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 339931F2E748
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B77914AD07;
	Fri, 26 Jan 2024 08:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bLdBu+8T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE61A14AD05;
	Fri, 26 Jan 2024 08:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259474; cv=none; b=KROIeOWe3+MgedjtTftI9xA6c8joSFz1eBGO1oPR+rye7TF8fG2Jqn3ABBrk66hHEo6X+ZV6ks4LXWFVhGixknd6XCpf0LGI7phfUgdpMZkMQGEqE+vm4PkALI8MS+DDCrbCW4JdVXqoOmpvtqkvwB4soRMYoBiY9Bz/oSbUDx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259474; c=relaxed/simple;
	bh=vcN0M4Um3O96u875lU4oYcgL4lwYn/C625MrP4JrFdg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a6QR4cs4cwVnrX9SCW/csMvohA4COYINCXv6lXE/IKhQBpmX00RBhXml0KzH8TMyTTHYFQtRL0ikez+h6FtqjgmtcM4rsGcJ9bNhcscQ6VgYmZyj2uSHSO4kSD4JKemFoRF0sG8Ldjdr1iG0nxWjnw9D5DsRjpKo8Kb75PZyVmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bLdBu+8T; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259473; x=1737795473;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vcN0M4Um3O96u875lU4oYcgL4lwYn/C625MrP4JrFdg=;
  b=bLdBu+8TQPuf8H33P+FFoN2EbjgpDFieAqHCuJGnkztMbTNfDGTf5JfR
   bJFRb9JNd7ccc+xFw79t4ZO8zMWBxiWG8browrgxio0TX8gWwKIphD5Ph
   ZdSEb0pZpScDiDL3YR3bjek7obABeXKOOOgnEJulxN8G2OzaQgbKm5G6d
   UB0o26t2J4Vlk66dTgro6QS0pYOdnQ5j/Jir2fCh/a+/HpI/pXwv0+Pky
   ma3cIQXaNJCUsrb2DS4nMT/u/JGT1QPCtRq1kx19hIWttUSR0/pv9ttZC
   /xkLm9EuejL38OqDreshuLa5R8ise4ZtaPLS074g5keOKv/1tFxrf/YxS
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792757"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792757"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310275"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310275"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:47 -0800
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
Subject: [RFC PATCH 27/41] KVM: x86/pmu: Clear PERF_METRICS MSR for guest
Date: Fri, 26 Jan 2024 16:54:30 +0800
Message-Id: <20240126085444.324918-28-xiong.y.zhang@linux.intel.com>
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Since perf topdown metrics feature is not supported yet, clear
PERF_METRICS MSR for guest.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4b4da7f17895..ad0434646a29 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -916,6 +916,10 @@ static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
 	 */
 	for (i = pmu->nr_arch_fixed_counters; i < kvm_pmu_cap.num_counters_fixed; i++)
 		wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
+
+	/* Clear PERF_METRICS MSR since guest topdown metrics is not supported yet. */
+	if (kvm_caps.host_perf_cap & PMU_CAP_PERF_METRICS)
+		wrmsrl(MSR_PERF_METRICS, 0);
 }
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
-- 
2.34.1


