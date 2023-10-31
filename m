Return-Path: <kvm+bounces-173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE02F7DC957
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 10:22:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A60422817A2
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 995DE1944C;
	Tue, 31 Oct 2023 09:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ng6mG7EJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BAB18C29
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:22:00 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D77E110;
	Tue, 31 Oct 2023 02:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698744119; x=1730280119;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hGJvfX2hIKMvWkOHT5amNhhbAWNGgZop9FcOLKuXuaA=;
  b=Ng6mG7EJ4znXJ+IDS1nfquItUA+grbWRFMielJRLsPj/K6+x8rm9Ztw2
   rVvi50cEyUfdVcEtkLmuBBfzg/eoXZvZl+9DZlrKKU/JpwPar892mWq3U
   B4Rmh4AN2B1FA1xhSAqqqM3kmcacUmNCSymaIDoFx7ZG28S9gV/csx60d
   4sx9Ro62HOJY7kRXBGLtrMg4uI2hO9cFMmGTC51DXf7CqIl9qPDyo9/po
   I1EXWRMCoK/huf1HnABjbvw+Ke7kakRBqee9IKth9vaBjXYp5UIJTWgo3
   ZOsVdRl4V5ZE042yd67F5C3FW1BE9FuzKb1NhBB1wgG7pvgRyO+BleGF8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="385435983"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="385435983"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 02:21:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="877445531"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="877445531"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga002.fm.intel.com with ESMTP; 31 Oct 2023 02:21:55 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v2 4/5] x86: pmu: Support validation for Intel PMU fixed counter 3
Date: Tue, 31 Oct 2023 17:29:20 +0800
Message-Id: <20231031092921.2885109-5-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231031092921.2885109-1-dapeng1.mi@linux.intel.com>
References: <20231031092921.2885109-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel CPUs, like Sapphire Rapids, introduces a new fixed counter
(fixed counter 3) to counter/sample topdown.slots event, but current
code still doesn't cover this new fixed counter.

So this patch adds code to validate this new fixed counter can count
slots event correctly.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 6bd8f6d53f55..404dc7b62ac2 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -47,6 +47,7 @@ struct pmu_event {
 	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
 	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 500*N},
 	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 300*N},
+	{"fixed 4", MSR_CORE_PERF_FIXED_CTR0 + 3, 1*N, 5000*N},
 };
 
 char *buf;
-- 
2.34.1


