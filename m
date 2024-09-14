Return-Path: <kvm+bounces-26896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD1A978E97
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84A8B2887E7
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 686511CDFC1;
	Sat, 14 Sep 2024 07:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bIKHnhip"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C6978297;
	Sat, 14 Sep 2024 07:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297274; cv=none; b=G7Je6MdxOy1D01YCIgm1xYYyB62muwiKrYirDMFX0gUqpAhXNntOfL4hQk9obMkdOh7e0u+v/NP9ViUAz1jf9J9XbAN15n0f3ijDfc5+jm3tm4bkmkP2oGXcBStJ2nalgE/tTonrSCh1YCn8389WVv1+yIEkB86NWdXwHLVJ1L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297274; c=relaxed/simple;
	bh=+M4vonICc0ZyeTSp/xqG/2je7Rme8lCHPlZ6Y/9HccU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QmrY6Ao5Oe8cYVGw0qgLvuHROlztPfP10kexznqasnh8XTr+2R+KGNJg57Rjyljj47QANor5n39jYcc2sRUEL7KBFt9SWkjz0HvNp3fR0Q1wBRj7Q0ber7Y7gfR3ZOKZjyLpegJbPDVlcLhySmTmwPUkuEwP7sew6qOgMAfHUDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bIKHnhip; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297273; x=1757833273;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+M4vonICc0ZyeTSp/xqG/2je7Rme8lCHPlZ6Y/9HccU=;
  b=bIKHnhipoMSTm4hVKy6vLPNGqQnTs+5r48hFHTsUNlNJO1dhm4IeBVyl
   XqNhBls371u/FvjdjFX4PB0JRoiXfZbOQJsO9P3cvsJDwtbCVLqN5riZq
   f+pYp2H7T8XF7DUKBmmVoAwLJRN4KVV4jrvYQTWGXGONDA21mwp7G8wID
   +wzMoIxDnV+NNAA248kVEtQUdUFI6YecvcHHrbg8Lm6Nc3XqytfbUmFaX
   H6Qe/dIYA5qq9+lCiOX2GMFc4WNuTK7awZtxkQyHlQdgKRDdXfMertCbj
   0vNZb0DZK54y2IEX/hR9Qpvt0xf6Wz92GJcZVVWkdwjMEVMxpHgq1V47q
   A==;
X-CSE-ConnectionGUID: mIQcrvotTfOD0tFlhQ7FhQ==
X-CSE-MsgGUID: 6q2qLKEISdqY+a/loV1H3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778735"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778735"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:12 -0700
X-CSE-ConnectionGUID: NHXS/7ozSLy3bXFZzs4eng==
X-CSE-MsgGUID: SQ7eiUSBQKCtPEdmF2Ddaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950673"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:00:58 -0700
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
	Yongwei Ma <yongwei.ma@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v6 01/18] x86: pmu: Remove duplicate code in pmu_init()
Date: Sat, 14 Sep 2024 10:17:11 +0000
Message-Id: <20240914101728.33148-2-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
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


