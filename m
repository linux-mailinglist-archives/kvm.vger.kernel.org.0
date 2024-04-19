Return-Path: <kvm+bounces-15187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2058AA75C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:46:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96153283AED
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B51D10A28;
	Fri, 19 Apr 2024 03:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RVL+eOL9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513A9DDD9;
	Fri, 19 Apr 2024 03:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498341; cv=none; b=T8e9XPIRZo6dgxOjwvgT+peIBUiayXQAnq419lp2mCZnCpe7Ebh8pHi0EddCW6ZzfCJztcHgdLBEMg2hVAo1L4M2fZswCo4DsxmDVrWE3fxMEs4e4FKLKUIwpT5usbtEV6tvAaTD6OcqGqayO+pc3Yi36KqPzLw7jzQhb7jxsQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498341; c=relaxed/simple;
	bh=LxFSjPHK2sa2aihQ51xpIpnx2+ypI2jC3yBIVvG0fmI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aW4XgJnS7cfOFozrheML1dAkOKTmuio3yqvmp4Epi4vCkVC4bBbDcm9AsWGMq+hOEzhA0Hz9DsN6hVokIRY/y/Omqvu9T4CwBG3B8SoZI+TM3xoaIQjE58mlCdG/+f5fMHZJbqkQEWmvHWqdBcQwVY7G39Q8eWD3UdDtTPok8Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RVL+eOL9; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498340; x=1745034340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LxFSjPHK2sa2aihQ51xpIpnx2+ypI2jC3yBIVvG0fmI=;
  b=RVL+eOL9Xs8tis0BQU5msN6ChDcpLSWWJ8gkY4qQnTHjlsSvEWDmbx8A
   2AUKCvafcUK1smlIbiAnhFIN7Arwx5ke8u/LRib7tP1zyF+nqmQ8R2Rv1
   E2aHK4YiarCgV/oW+WPH/wLKr9tAS+lO4LYl55hq9ZGc8Tjv/e30nXAVj
   TSXucDcmY1DnFmL/qmAa1RiSnPWAmwEYuXzYLoaCyTPZu6ktR0ZYzZ3LJ
   YaIMM7g4e2VKYjY+UiHbkNbgYpwBa8s/UVhNmrr4thmugtWvlZFIZ3xYc
   6ZKRg6AKHEbPJIak8ul4dSnLRl8KgSvey9IkRZkT85mA1zlRREK4IWR9H
   w==;
X-CSE-ConnectionGUID: 0+LRJzFsSIKmhLOGHqW+XQ==
X-CSE-MsgGUID: 9ca9CsGWRf2xJQM+/Bc8rA==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565404"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565404"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:45:40 -0700
X-CSE-ConnectionGUID: +1gYnQlRSTKa25/eYYd33g==
X-CSE-MsgGUID: zl6nGItwS+mIbwFsyK0fkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410114"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:45:37 -0700
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
Subject: [kvm-unit-tests Patch v4 02/17] x86: pmu: Remove blank line and redundant space
Date: Fri, 19 Apr 2024 11:52:18 +0800
Message-Id: <20240419035233.3837621-3-dapeng1.mi@linux.intel.com>
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

code style changes.

Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 47a1a602ade2..4847a424f572 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -203,8 +203,7 @@ static noinline void __measure(pmu_counter_t *evt, uint64_t count)
 static bool verify_event(uint64_t count, struct pmu_event *e)
 {
 	// printf("%d <= %ld <= %d\n", e->min, count, e->max);
-	return count >= e->min  && count <= e->max;
-
+	return count >= e->min && count <= e->max;
 }
 
 static bool verify_counter(pmu_counter_t *cnt)
-- 
2.34.1


