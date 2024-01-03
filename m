Return-Path: <kvm+bounces-5492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 676B9822768
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 04:10:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6AA51C22D1C
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 03:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F21C182B5;
	Wed,  3 Jan 2024 03:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EF1M32V1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F3018050;
	Wed,  3 Jan 2024 03:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704251378; x=1735787378;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kfSCHGv/CfTNu74cuaUBe9OREwyoA2RBsBWS61xedrk=;
  b=EF1M32V11YXtj4z32ZUgMykRigj3I3rCzWbJPfOhoOXjOo3vSpJWTXQO
   g/UNX/fuaOwBOGLdNeaXI8CEePum9Bv5snsDEYT3pBmTitFu221rljvCl
   j01m1ikEgrZbVimS+4wPFEQYdCqFsHt0TH5P1UHEItBU/lyme3NiQcfNT
   Guf/+dNKdm2k5Qzsq92pcXuqMo/2He0hZX8SsP2ARKVoCLyfpnIC7gfRm
   hb3HtI+lfkwbZOpXiWWTaREzROa1M9iy3ks7Xuin+hdBNd/T2UhFitANu
   qUzMc1Gl5NJ3Y8jAeOcAMm2fbY4nndRc9/shuSwidT2gY71iMeXPPmeQq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="10343125"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="10343125"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 19:09:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="729665921"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="729665921"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by orsmga003.jf.intel.com with ESMTP; 02 Jan 2024 19:09:33 -0800
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
Subject: [kvm-unit-tests Patch v3 02/11] x86: pmu: Enlarge cnt[] length to 64 in check_counters_many()
Date: Wed,  3 Jan 2024 11:14:00 +0800
Message-Id: <20240103031409.2504051-3-dapeng1.mi@linux.intel.com>
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

Considering there are already 8 GP counters and 4 fixed counters on
latest Intel processors, like Sapphire Rapids. The original cnt[] array
length 10 is definitely not enough to cover all supported PMU counters on these
new processors even through currently KVM only supports 3 fixed counters
at most. This would cause out of bound memory access and may trigger
false alarm on PMU counter validation

It's probably more and more GP and fixed counters are introduced in the
future and then directly extends the cnt[] array length to 64 once and
for all.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 0def28695c70..a13b8a8398c6 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -254,7 +254,7 @@ static void check_fixed_counters(void)
 
 static void check_counters_many(void)
 {
-	pmu_counter_t cnt[10];
+	pmu_counter_t cnt[64];
 	int i, n;
 
 	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
-- 
2.34.1


