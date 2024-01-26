Return-Path: <kvm+bounces-7119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCBEB83D6C5
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:47:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53398B2870C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4C514E2CA;
	Fri, 26 Jan 2024 08:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A4IhCEFW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EBC44C78;
	Fri, 26 Jan 2024 08:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259500; cv=none; b=HYFnAXrXHy54TZudiY0byakOfvMJ4TmMa3nic5thSvB2vwtJG/QUkg173K87GI6ZuneEq+Fqdv9JTzhiL6TfV3C7lKCxz+qKjo3lz7y+bHaPLSVFYb9Xe0HDQus2tk52g9Tpv0Y2RxlyLmXd3Odt5/nCnJ+RAUGx0YsRrPSL0fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259500; c=relaxed/simple;
	bh=DJFzjL1uqbqtFpO07Bney0dZeYiSOvnd7xtSkhQaCpM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FC4JDmgwUdOH7sVNzDvm7Xh24kwNdLPY9ylYwRv6fdzabowWlanZiKgewPme6qpUFrI3WlBB7GsDeTPp3ijsTbY2+JoY8kD5quKw3NrbQwc1sezbd0xrg79ZDdY3rgx5k/5qbD0rBo/8pWq1Y30hYlXEgPWYXD1JXkaOsNyw6T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A4IhCEFW; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259499; x=1737795499;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DJFzjL1uqbqtFpO07Bney0dZeYiSOvnd7xtSkhQaCpM=;
  b=A4IhCEFWX5t7TRs6NydvdsqBBpw8UAzOBZkqDXEGlXCDzWPnvDiZ8YsX
   CAjPh0GUeETVywKhGYJL/y1bkOVPECy1/i+rvcIglxv4jjsO0yiZUA0q7
   yoc71J/HrnzbsKFL/BKWFt49UVKelmowSLZ/71kKl6eGEmrTofGkrMyPX
   Je+ATi4Ru7MO8+i/Ww8vsJVLgDFl2TCHFq6P+I03nCVZLN0SueCg66kT9
   lDF/+2TVDXa8u5K89XIN0D/wlhfgKYzQdQ9Nr0adaelTqyyQsRdA14ewK
   EOpuMVs0gnPOPpxofrQXS8jJCCKOPXm/TJU5WI/CoFmFEA8BrfbKUI7pg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792895"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792895"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310409"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310409"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:13 -0800
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
Subject: [RFC PATCH 32/41] KVM: x86/pmu: Add support for PMU context switch at VM-exit/enter
Date: Fri, 26 Jan 2024 16:54:35 +0800
Message-Id: <20240126085444.324918-33-xiong.y.zhang@linux.intel.com>
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

Add correct PMU context switch at VM_entry/exit boundary.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 074452aa700d..fe7da1a16c3b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10898,6 +10898,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(0, 7);
 	}
 
+	if (is_passthrough_pmu_enabled(vcpu))
+		kvm_pmu_restore_pmu_context(vcpu);
+
 	guest_timing_enter_irqoff();
 
 	for (;;) {
@@ -10926,6 +10929,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		++vcpu->stat.exits;
 	}
 
+	if (is_passthrough_pmu_enabled(vcpu))
+		kvm_pmu_save_pmu_context(vcpu);
+
 	/*
 	 * Do this here before restoring debug registers on the host.  And
 	 * since we do this before handling the vmexit, a DR access vmexit
-- 
2.34.1


