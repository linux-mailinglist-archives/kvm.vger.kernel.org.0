Return-Path: <kvm+bounces-15193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B906D8AA768
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:48:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA0431C230FC
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C627836B00;
	Fri, 19 Apr 2024 03:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OwaoMflC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03102E41C;
	Fri, 19 Apr 2024 03:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498359; cv=none; b=Vuq/bnD14QOQl++oiv+7w7Q+j2YqWVoF/xjNqKYRE8sJ8Kx4vwg69yXYfparz7D0w2G5nzYs22AuoRETp2tiTm0zVWW5/SMgsONeNSiQcFq706ZX2ttZ6ytbisUjsj2nRuS3vY6kDro/89e+VQW3GJZMimUm21IT+jBAvBwl4QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498359; c=relaxed/simple;
	bh=bBwGEz/zSa/hCAv0OjbB+yO6hHyuL/TvJodBdVmlGns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fjCa67LKJLrcnBB3AzmDI4rui5wd2Kkp5k3GfzHKMluHSktQ9AuBHoSFQy/EkTLH7lt6Dh1GiBONPLlZmQ1btbze42VwBiXfP8i2JfZtbITsSLP+62rvdxUYI6G9h/wubT83YhL0WodFO1FyJHfjPFMF1ZcCiN/C8dCsN9jw3lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OwaoMflC; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498357; x=1745034357;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bBwGEz/zSa/hCAv0OjbB+yO6hHyuL/TvJodBdVmlGns=;
  b=OwaoMflC68rPwC2OH0zfCh919dhL4EmkP8zYPIPo7AJPlCMLvQXB0NUx
   sG0XxndfzOqOj2uZoNiA0Hk1ScsLa8kX7Jdeo15GFZKqIjG+gAt3N+emI
   5X3NlucI82DJX41IpeHMaquQqqnYSZnZYtja9iBKyH+LdL/bjFt2qh+cb
   LmUYgaKy1zWFecrkwNrh7D47rrc5tQKgqgdRmVGSyDgHnXHjErjYhQ2bq
   e86XeQfqNnjV4WgqSZE3okmssN2JhWm9F54lf8mld5ZlRUH+HfbZPA2Pa
   PYu7i/kzFuC9lKDJbyn+ZZUiekaPc7vmYTNYJrrvyX4mRbl50uaCXnJIY
   g==;
X-CSE-ConnectionGUID: d1MLEUJxTni4KxwK1+qysw==
X-CSE-MsgGUID: l1isJZncSe6c94aYBwn16A==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565457"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565457"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:45:57 -0700
X-CSE-ConnectionGUID: SmE3ZuSZR2W1MvQMgHjH9w==
X-CSE-MsgGUID: GswCXT3bTPqdfBgfgyD5eQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410171"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:45:54 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v4 08/17] x86: pmu: Use macro to replace hard-coded branches event index
Date: Fri, 19 Apr 2024 11:52:24 +0800
Message-Id: <20240419035233.3837621-9-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
References: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the branches event index is a hard-coded number. User could
add new events and cause the branches event index changes in the future,
but don't notice the hard-coded event index and forget to update the
event index synchronously, then the issue comes.

Thus, replace the hard-coded index to a macro.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 43ef7ecbcaea..fd1b22104fc4 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -49,6 +49,22 @@ struct pmu_event {
 	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
 };
 
+/*
+ * Events index in intel_gp_events[], ensure consistent with
+ * intel_gp_events[].
+ */
+enum {
+	INTEL_BRANCHES_IDX	= 5,
+};
+
+/*
+ * Events index in amd_gp_events[], ensure consistent with
+ * amd_gp_events[].
+ */
+enum {
+	AMD_BRANCHES_IDX	= 2,
+};
+
 char *buf;
 
 static struct pmu_event *gp_events;
@@ -481,7 +497,8 @@ static void check_emulated_instr(void)
 {
 	uint64_t status, instr_start, brnch_start;
 	uint64_t gp_counter_width = (1ull << pmu.gp_counter_width) - 1;
-	unsigned int branch_idx = pmu.is_intel ? 5 : 2;
+	unsigned int branch_idx = pmu.is_intel ?
+				  INTEL_BRANCHES_IDX : AMD_BRANCHES_IDX;
 	pmu_counter_t brnch_cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
 		/* branch instructions */
-- 
2.34.1


