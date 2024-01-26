Return-Path: <kvm+bounces-7125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D22E583D6C7
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:48:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FC1D1C2C83B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:48:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47FCC151CCF;
	Fri, 26 Jan 2024 08:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K4PbeDQ3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D64145C1F;
	Fri, 26 Jan 2024 08:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259531; cv=none; b=Otexncu2M/LOj3YmQG9mL2LKZfCN+mz/WkXjN/g/NjL7GJVOHtlZrFFWYDyZpEmQD2/L6idCRENjInGXXQ6+1Wz5sa1bK6DQFV+XOA7MMJv++n/EW9eg8EMwwv7v23QG31zePAH09UNSn/BT2I64em9FtQqZiLcg0Ou5HBCnN5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259531; c=relaxed/simple;
	bh=p9S5KED8WuoSV/G4Ddkqt0eIdsqyB+al3BlwWfdDgS4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=djgL9uzKijQOo2IdQ4BLZKU2oQJ2fPtwNiFNlNJInzI5p7brX1cyuZWKeRHMp+OgYFOECJGfNC8PsHfZNQ4YkOGeNvRdX86YCdfsuxWpFSOAfUkhuPrjxwKbROdc+41KQh2p03L/xMgaae9cSj1/UjJhkmeb19iPzkl+XVZZ/0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K4PbeDQ3; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259530; x=1737795530;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p9S5KED8WuoSV/G4Ddkqt0eIdsqyB+al3BlwWfdDgS4=;
  b=K4PbeDQ3AelyQe/fQT9GVtXNW1i1lDeJ1pw0Bt/7RR49bBzwIelSMf//
   1BOawB0WKKGSU9RjAokFgDdWpVwySfkbkh83DMdxqN7Ku1qgXo1/mR4T5
   viokzlSqaIec8h3A1uLIqjQq0xGj5iaiTETTqbxu148fSZwIDrOaqu5DO
   GhffTbL0mME1jdri3YaPiFIJ61RbhYkH3kiOwnWXwYg5GiJSADZ2AQCfk
   WVHu2X+K4WVeTKYtJHc0MhLtqJqPFnpzqj0XY6ayyOLubMta5nMcDudqj
   w5TUUKrPZmANna/udJ90/F4AjiCGqb2BLaiEfirTh6wTuaJQcvl82UVDg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9793069"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9793069"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310492"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310492"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:44 -0800
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
Subject: [RFC PATCH 38/41] KVM: x86/pmu: Introduce PMU helper to increment counter
Date: Fri, 26 Jan 2024 16:54:41 +0800
Message-Id: <20240126085444.324918-39-xiong.y.zhang@linux.intel.com>
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

Introduce PMU helper to increment counter for passthrough PMU because it is
able to conveniently return the overflow condition instead of deferring the
overflow check to KVM_REQ_PMU in original implementation. In addition, this
helper function can hide architecture details.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b02688ed74f7..869de0d81055 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -501,6 +501,7 @@ struct kvm_pmc {
 	bool is_paused;
 	bool intr;
 	u64 counter;
+	u64 emulated_counter;
 	u64 prev_counter;
 	u64 eventsel;
 	u64 eventsel_hw;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e7ad97734705..7b0bac1ac4bf 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -434,6 +434,21 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 	pmc->prev_counter = 0;
 }
 
+static bool kvm_passthrough_pmu_incr_counter(struct kvm_pmc *pmc)
+{
+	if (!pmc->emulated_counter)
+		return false;
+
+	pmc->counter += pmc->emulated_counter;
+	pmc->emulated_counter = 0;
+	pmc->counter &= pmc_bitmask(pmc);
+
+	if (!pmc->counter)
+		return true;
+
+	return false;
+}
+
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-- 
2.34.1


