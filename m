Return-Path: <kvm+bounces-5501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92F7C82277A
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 04:14:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71A351C22DD7
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 03:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 544B51A286;
	Wed,  3 Jan 2024 03:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nOQoswZ/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F63E19BBA;
	Wed,  3 Jan 2024 03:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704251410; x=1735787410;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yfYuDnLnosyafof+2dmQ1VR1lM0gJ9NDYqFf6ZR3LWc=;
  b=nOQoswZ/XJISB+0KTz6EGPUrqXoJcFoyMF5bQxntCXKUB6D3hhWDbWax
   A0qvZqAwZZZJvjhq5ihfGx6y+fE+4DXkSLJqiIYpk4sjS7cL4oBymtVBu
   5Pw0Hp3ixDHWyPDGbjMZ4MHSxeqAx2EkJEFrcD/tBXLMDJ3Jyx/R9gEiJ
   9fwcCd+qwcbwrPJ4n5h4yIJIGOOsk9YDuBXVO5czEDaU7ghVDkP+TnCsx
   XJh4gM8X0Z7sqIvG8MQbbdHhrt+CImGPd74m13T5fH+X5+rpdd8P6Ywzg
   rrB4BY3lZbgPvNO5E+5jOUyHIv5D0bh5C0hYyoq9ozi/YoGxlNvN12YKu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="10343183"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="10343183"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 19:10:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="729666013"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="729666013"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by orsmga003.jf.intel.com with ESMTP; 02 Jan 2024 19:10:06 -0800
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v3 11/11] x86: pmu: Improve branch misses event verification
Date: Wed,  3 Jan 2024 11:14:09 +0800
Message-Id: <20240103031409.2504051-12-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since IBPB command is already leveraged to force one branch miss
triggering, the lower boundary of branch misses event can be set to 1
instead of 0 on IBPB supported processors. Thus the ambiguity from 0 can
be eliminated.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index c8d4a0dcd362..d5c3fcfaa84c 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -172,6 +172,16 @@ static void adjust_events_range(struct pmu_event *gp_events, int branch_idx)
 		gp_events[branch_idx].min = PRECISE_LOOP_BRANCHES;
 		gp_events[branch_idx].max = PRECISE_LOOP_BRANCHES;
 	}
+
+	/*
+	 * If HW supports IBPB, one branch miss is forced to trigger by
+	 * IBPB command. Thus overwrite the lower boundary of branch misses
+	 * event to 1.
+	 */
+	if (has_ibpb()) {
+		/* branch misses event */
+		gp_events[branch_idx + 1].min = 1;
+	}
 }
 
 volatile uint64_t irq_received;
-- 
2.34.1


