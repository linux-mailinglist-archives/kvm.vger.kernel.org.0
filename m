Return-Path: <kvm+bounces-7101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 292D083D66E
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:34:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C4291C28963
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CBAD13DBB9;
	Fri, 26 Jan 2024 08:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZDZEQGzx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BA910A0F;
	Fri, 26 Jan 2024 08:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259412; cv=none; b=TB8PJLWiqjwseo736AK/haPzw++RBu0x/uWcm9p1Q+MydzdURLhRl0m/Ci9xu9E38beVFHqvTpOahLLFSz6IfX2DYSxhyxPWeEzjnzLh6prErdL7t1BR5l4M4gzMfWg6G+ZWGHJA7uDkzWBGN2hJseng6zWoG0MrgVaM6lfhsqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259412; c=relaxed/simple;
	bh=QglvaqOiccK1QoUItcblJF4VkLMkGcShw3WGx+q7c0A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g3zcOGotuFu8ibhhmCj1myU5tFVqxOC1A6GooKeHDozh4MiWbo7Fxh8LYwrnh2fVBWbljuFiWKnL7OX5pOjwx9oxP/bWNPQeQtStqPRrLvV99Pv2ojI8PLsR2uaM9kHbRCiusf46nxzP6MMg8l0Z0/NdYi161OqsObr7di6avSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZDZEQGzx; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259411; x=1737795411;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QglvaqOiccK1QoUItcblJF4VkLMkGcShw3WGx+q7c0A=;
  b=ZDZEQGzxB+DwqHhS/sTqW3jq9MTYXu33vQCrVeR4jMhp8b5VOGKQ2jgO
   ZtAQH+nGl0189cdIphReGwB66YfMjoG9pUUeA+uXG26tDoRofOheNWy1C
   IoWuW50m0ntHr/9cf5fxXYR79whdfi5OY3z0s9/2p2hOHb5PcdNCXYkcI
   YpnQJ+WrJ+m/OrVa8BxkbAW792gxrBJL/Edi1HuDwyCk3eOtsuX6vCyKN
   IZyYvQCVsMblvmCU88iL8K703xXWbWaPyRTzjC7lCUKZUmp4ddDIEl6Or
   7zqzsETNOWxzaZMLKIVoBSWY0VNvQjh6Iyw0yplyCrBa3CAVlmgBeTmfE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792278"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792278"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310047"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310047"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:41 -0800
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
Subject: [RFC PATCH 14/41] KVM: x86/pmu: Allow RDPMC pass through
Date: Fri, 26 Jan 2024 16:54:17 +0800
Message-Id: <20240126085444.324918-15-xiong.y.zhang@linux.intel.com>
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

Clear RDPMC_EXITING in vmcs cpu based execution control to allow rdpmc
instruction to proceed without VMEXIT. This gives performance to
passthrough PMU. Clear RDPMC in vmx_vcpu_after_set_cpuid() when guest
enables PMU and passthrough PMU is allowed.

The passthrough RDPMC allows guest to read several PMU MSRs including
unexposed counters like fixed counter 3 as well as IA32_PERF_METRICS.

To cope with this issue, these MSRs will be cleared in later commits when
context switching to VM guest.

Co-developed-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e4610b80e519..33cb69ff0804 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7819,6 +7819,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vmx->msr_ia32_feature_control_valid_bits &=
 			~FEAT_CTL_SGX_LC_ENABLED;
 
+	if (is_passthrough_pmu_enabled(&vmx->vcpu))
+		exec_controls_clearbit(vmx, CPU_BASED_RDPMC_EXITING);
+
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 }
-- 
2.34.1


