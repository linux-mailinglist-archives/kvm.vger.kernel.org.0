Return-Path: <kvm+bounces-7116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E312183D6B5
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:44:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94DA01F2EEC7
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC9041C91;
	Fri, 26 Jan 2024 08:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b7hqy1ko"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4648B14C585;
	Fri, 26 Jan 2024 08:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259484; cv=none; b=CfvqVeceTiHtMA6rgSF4kUBTcSTgf8dlQhoGzi5mxcIF3aVHRMJvK3EY/lp/TXCSAYk3QscRTtiESb5MFceyTatxr0dvpyeUfCsswlzrMyaKZhqk/mat/cIEUmfWzpjXRp0h0Z27nktglDfgx97kSmyTnPgZMwoMMwMATjGBvLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259484; c=relaxed/simple;
	bh=Eomts/7yPf4NYVOQNKK9HqvKc0rom3Ij1FnDKzQqSyY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gbok3k2q0GhDMjFYala5PKUyX+A4vPZdNkktcX8CQRTOaPh2YXF0ZRH2cun5KYK40KpnAfPoVelZX9w0gVgDlXdSs6CIROMC/9jHc8vOkmtU0cS+etIay/xtJ1R8CPrzHim/+vPXrlPjsT11AcUivxQUfNsRQkCo/jV2+uTJCnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b7hqy1ko; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259483; x=1737795483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Eomts/7yPf4NYVOQNKK9HqvKc0rom3Ij1FnDKzQqSyY=;
  b=b7hqy1koJMii6q0kKycz9+3Fob03ZDcvTVmRBC1fBnH6gIkHZ0DtxIpp
   Kzez6LZVfbWdVFHpT4cj9cMOUoBvDzupleY9UAzdszp3zCcJ5E4CZhOSw
   oZTBVV0ngNWP0tVlnZzs78qfnlyZ/pdi+EZ+K5svYL64AJc36YcmCdYG8
   YHwcBGDbAXx5bTva2GKwpKYC3S5NrOd69ifQye3yfQhKY0cuSilKKEqsc
   UA7tp27F2dRCckBS44JgOFjEUrdXgFDK6OjB5qUHPVeI/oorfAY6CxQMh
   cG9kd/NVKJLiy6q9hTtRJ6O6prFgyzDPr/6dBWW57iYbrv/jwPcZk9zuy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792800"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792800"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310337"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310337"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:58 -0800
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
Subject: [RFC PATCH 29/41] KVM: x86/pmu: Exclude existing vLBR logic from the passthrough PMU
Date: Fri, 26 Jan 2024 16:54:32 +0800
Message-Id: <20240126085444.324918-30-xiong.y.zhang@linux.intel.com>
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

Excluding existing vLBR logic from the passthrough PMU because the it does
not support LBR related MSRs. So to avoid any side effect, do not call
vLBR related code in both vcpu_enter_guest() and pmi injection function.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 13 ++++++++-----
 arch/x86/kvm/vmx/vmx.c       |  2 +-
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ad0434646a29..9bbd5084a766 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -688,13 +688,16 @@ static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
 
 static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
-	u8 version = vcpu_to_pmu(vcpu)->version;
+	u8 version;
 
-	if (!intel_pmu_lbr_is_enabled(vcpu))
-		return;
+	if (!is_passthrough_pmu_enabled(vcpu)) {
+		if (!intel_pmu_lbr_is_enabled(vcpu))
+			return;
 
-	if (version > 1 && version < 4)
-		intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
+		version = vcpu_to_pmu(vcpu)->version;
+		if (version > 1 && version < 4)
+			intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
+	}
 }
 
 static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a9623351eafe..d28afa87be70 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7469,7 +7469,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	pt_guest_enter(vmx);
 
 	atomic_switch_perf_msrs(vmx);
-	if (intel_pmu_lbr_is_enabled(vcpu))
+	if (!is_passthrough_pmu_enabled(&vmx->vcpu) && intel_pmu_lbr_is_enabled(vcpu))
 		vmx_passthrough_lbr_msrs(vcpu);
 
 	if (enable_preemption_timer)
-- 
2.34.1


