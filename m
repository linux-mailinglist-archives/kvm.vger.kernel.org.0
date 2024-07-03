Return-Path: <kvm+bounces-20870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1281B924D9E
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:15:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCC94288665
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8EA39AD6;
	Wed,  3 Jul 2024 02:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F7U8Y1E4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6078F8F49;
	Wed,  3 Jul 2024 02:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972772; cv=none; b=pACiiorrhXMVEBKvIwm3H4R1+98c9bMZRkoNswoa1mUELIhiovWlO+bmBPn2Ha9VF7a2dyZ0yCKwRir1/3DQ9zcP8BPu5bqfKXGqxlOqEshfPjyoyCYv3Nsoq1IajYod+8qqBVckPNvpYLb3/bEsFlrqWVbeGCQMiI4b8cTaOJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972772; c=relaxed/simple;
	bh=9J4gTUwUn2cWSw1SNih0bGr/MeYBF/9jYecIo0DiWaY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WwF+nCKczeX+zkzCbLr3JY5aeDvtwth3rpQq2gCZuxapGry3JY4Sfu8R52yugxFQZu9dzG8GrEb8d9VErtzVwi1hQNIPdug7+DDQvnq03jvhO9ju5e3kRUWv/w0COaSEOltX2Gtd+CC2mevJundPo/hYa765WsWWuRSYo36n/AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F7U8Y1E4; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972771; x=1751508771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9J4gTUwUn2cWSw1SNih0bGr/MeYBF/9jYecIo0DiWaY=;
  b=F7U8Y1E4HwC9XUr5PUETD0VsNR9tVFRz87OYzSEuUKQA1qnYXR+Jecnt
   TfIxiuh6tWfUkDqfjPd1VLPa/khWC3X1xubHbJjTgaeOglQxWh2/d8liF
   Tjqis1sTIMNGJBg5fLzz9f+Ud4UijnGKgzdYpd/XMyvHL3Fwj+kJZ6TlM
   jRT7dieJVuUZsNLdqd5g8NDNR29hgN7z2RFMD/4tQf54jdWpf/EPaH51J
   8xBgQvFdzPfoMilvLouM6Ym4GP9f0h2jN9Jk3zOlmf97oWtxdDbqGWzeq
   +3H7kkQ1kpptKU+kqEKXSYAVipCUp3czuSnbRpT194Y6iNXe9R647psk+
   g==;
X-CSE-ConnectionGUID: ZWvP1r+jTjC3oMwimzFz3w==
X-CSE-MsgGUID: jRW6TcOtR2qqF/8yvCJHqA==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17311022"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17311022"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:12:51 -0700
X-CSE-ConnectionGUID: jfwGEheERveVJfdaAz3uwA==
X-CSE-MsgGUID: 4M45Krs0S8uOe9oKdNXYrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148597"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:12:48 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [Patch v5 08/18] x86: pmu: Use macro to replace hard-coded branches event index
Date: Wed,  3 Jul 2024 09:57:02 +0000
Message-Id: <20240703095712.64202-9-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
References: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
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
index 1e028579..d2138567 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -50,6 +50,22 @@ struct pmu_event {
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
@@ -483,7 +499,8 @@ static void check_emulated_instr(void)
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
2.40.1


