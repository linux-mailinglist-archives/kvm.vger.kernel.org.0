Return-Path: <kvm+bounces-20862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BEC0924D87
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8D4B1F23CAE
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:13:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4037C153;
	Wed,  3 Jul 2024 02:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jIFIDyPh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A21523A;
	Wed,  3 Jul 2024 02:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972754; cv=none; b=eqr+FeXedqotXeEerrpKvqT23dQ1Z54sG5/U6+m/ko47WMIs+3x+lXpitxHn/6tDX9PlplPCWlHRrz5wXuRIF9fwE9hfFmfTFf93RMZdf2aFnFp+7o5XK3zhVxE041DjfbYQKUANnckt1YIBUFkFVx/GCwDo/X1j7uBD/r8MLZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972754; c=relaxed/simple;
	bh=+M4vonICc0ZyeTSp/xqG/2je7Rme8lCHPlZ6Y/9HccU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d+Y386IjFyeJw1AwiDUnCt+66wrOJzEEGMAFMWBhy2mEaXqaEVbITQ+aD7XV5vyoWNCrou0Xx7nLc4mweTeTzf3WpTtL2YF6BvflO4gVS9C3nnomM7t2rCUsBhm+2y9dUWE3ON7Tp8nUeb6G0welLgNEwbpODiQskArbELN+bOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jIFIDyPh; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972752; x=1751508752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+M4vonICc0ZyeTSp/xqG/2je7Rme8lCHPlZ6Y/9HccU=;
  b=jIFIDyPhzEbHcuYYNEJl0T3ifIJ63j+cJEV/HgP3G5gtM61nkdcbsaRQ
   OvYEFNLi5HMSujDUYmRmdmPm9+gpvzei2xCeTujZ9DhaBTOGMdiz7AXw1
   3sCz+TTKBiJ+SN0tLWqngesd35kwQ/YjyKMjEhgF4i04WequRlTFcfqpi
   5ln9gLzraBQTEZU2fGmg8qqbiaGiynmBgJ1r1n8ya7MNISQbLxinUUiSn
   xmWBc1yx/O1fJhy14OHIdqhwMlSMzs1mwZpsRjKJWuMsFTHmwF7/FiM4X
   bzLEGo2amTRejYwHH3dtUZUc+K2xcMHY+/B/ggCoBbkUlU1H9tsVT5FjA
   A==;
X-CSE-ConnectionGUID: 3XX55UmdS9C6eVxRSyBYrg==
X-CSE-MsgGUID: X7xPt3hrRAukM/oi5wNYDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17310938"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17310938"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:12:32 -0700
X-CSE-ConnectionGUID: D3TLjYn4Trit92MbBgXieA==
X-CSE-MsgGUID: oYgzusVBQM65mVobeEPraQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148510"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:12:29 -0700
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
Subject: [Patch v5 01/18] x86: pmu: Remove duplicate code in pmu_init()
Date: Wed,  3 Jul 2024 09:56:55 +0000
Message-Id: <20240703095712.64202-2-dapeng1.mi@linux.intel.com>
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

From: Xiong Zhang <xiong.y.zhang@intel.com>

There are totally same code in pmu_init() helper, remove the duplicate
code.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 lib/x86/pmu.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 0f2afd65..d06e9455 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -16,11 +16,6 @@ void pmu_init(void)
 			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
 		}
 
-		if (pmu.version > 1) {
-			pmu.nr_fixed_counters = cpuid_10.d & 0x1f;
-			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
-		}
-
 		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
 		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
 		pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
-- 
2.40.1


