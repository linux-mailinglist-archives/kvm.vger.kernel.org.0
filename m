Return-Path: <kvm+bounces-7092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B97F83D65C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:31:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24F82B27066
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7573B12FF8B;
	Fri, 26 Jan 2024 08:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OqaMtmt2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B8912FF79;
	Fri, 26 Jan 2024 08:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259362; cv=none; b=H/vDbSk7UZJdoHuYhwml8wlP440r4sdIMOB2LQRbo+XZnrDCMwcqHXeV3Q2uXBei2elRnEEdPn/0B5KjIXGDLTSRwwwGSp+Ycp7hgfUrrGIVWw3y92w/4uEsVtcQw6Z+y15uweB/H2pJ3S8lQo5bezCyAdFW1e1UK8vfp7yYAlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259362; c=relaxed/simple;
	bh=TOkzoJKyRiNbPO8hxKraBpbBRIKmwdH5yzAALhKlwf8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HMhNmIs8KERAfOejUFG7VQCBLc3G009lP9+FBWxZmyTU1V9dlskIfURh01+1mWEMi9fG12dgufT/0zD8iHiP+lCUsdF++2zkP+JCEZ/pazkAjT92b/TdfUxrCZt0i+3dYm9Uy2+9jU1JSZy1/28qKyjANF+CZ3o5DD6mHSti+lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OqaMtmt2; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259361; x=1737795361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TOkzoJKyRiNbPO8hxKraBpbBRIKmwdH5yzAALhKlwf8=;
  b=OqaMtmt2M9me4qgNg94fkFYxbrmzwKjwpEVUfmZQLQzznCIZZTXG6jt9
   T+UiWC194dP1d0i9ATlffMqgs2mmqMn4r6FzXliiGxwZd4Aj8onqlm5Qu
   LNt5PTph9ghyIl7uFueW/IxwuGXnSNDhkTR5Y6K+RkdsA4tanjkgZIPJa
   mTDTKknHUn46auycGWpIbBxNVlW6poAPjRXPoflo4FNoiZ44OeXFvSEIa
   5cq2E8a/1AV0uQId6EYNlLhxYIyxOMisJD7qpOsJ02N5K6iPI6J3LnIJi
   fp0Nppz0JxcE7dmwAkUjqAS2ZzOxOmeOG26P23hsqzGiAj4CcPSR2pcXI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792098"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792098"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930309850"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930309850"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:55:55 -0800
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
Subject: [RFC PATCH 05/41] KVM: x86/pmu: Register PMI handler for passthrough PMU
Date: Fri, 26 Jan 2024 16:54:08 +0800
Message-Id: <20240126085444.324918-6-xiong.y.zhang@linux.intel.com>
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

Add function to register/unregister PMI handler at KVM module
initialization and destroy time. This allows the host PMU with passthough
capability enabled switch PMI handler at PMU context switch time.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/x86.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c924075f6f1..4432e736129f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10611,6 +10611,18 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
 
+void kvm_passthrough_pmu_handler(void)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (!vcpu) {
+		pr_warn_once("%s: no running vcpu found!\n", __func__);
+		return;
+	}
+
+	kvm_make_request(KVM_REQ_PMI, vcpu);
+}
+
 /*
  * Called within kvm->srcu read side.
  * Returns 1 to let vcpu_run() continue the guest execution loop without
@@ -13815,6 +13827,7 @@ static int __init kvm_x86_init(void)
 {
 	kvm_mmu_x86_module_init();
 	mitigate_smt_rsb &= boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible();
+	kvm_set_vpmu_handler(kvm_passthrough_pmu_handler);
 	return 0;
 }
 module_init(kvm_x86_init);
@@ -13825,5 +13838,6 @@ static void __exit kvm_x86_exit(void)
 	 * If module_init() is implemented, module_exit() must also be
 	 * implemented to allow module unload.
 	 */
+	kvm_set_vpmu_handler(NULL);
 }
 module_exit(kvm_x86_exit);
-- 
2.34.1


