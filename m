Return-Path: <kvm+bounces-172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5D287DC956
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 10:22:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E66471C20C28
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3341218AEA;
	Tue, 31 Oct 2023 09:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iWx4M9u/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8813D182A4
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:21:57 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA494F5;
	Tue, 31 Oct 2023 02:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698744115; x=1730280115;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UFdm8PB2RMdMC4FZjkejhXgoSvo9XB2tTzL2mbbsxug=;
  b=iWx4M9u/9A9OWr3wBgyb7kE2Du0NZCDOL0eH9IQaQpiwvTtQuXt6m36Q
   CSWkZWhJtmKfyZBybPIV/3riyz0IXZQqxL7fE1VnAgjX9lNEjpsra0w7u
   pKzGtHjCTjfKySWSs6wimh5WkeJ61bydumltAL4YKhs91cUwlpLrvVsBI
   05APr/LxjkdaJ5DexTyrCFVKkbiZNDLHCWW9QhuhfsDxD3QQVOy9ko8N8
   AJGlKmPFWxAHCu3fIMsKHBTvtFiG89ygXTZXDanuycdJo+VIhXrQOgjju
   7N58szOrVQf+rz3GRBj7VV+CgbRCDFvtRUSE7yXvfjAp68WZOelLyj9u1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="385435973"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="385435973"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 02:21:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="877445527"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="877445527"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga002.fm.intel.com with ESMTP; 31 Oct 2023 02:21:53 -0700
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
Subject: [kvm-unit-tests Patch v2 3/5] x86: pmu: Enlarge cnt array length to 64 in check_counters_many()
Date: Tue, 31 Oct 2023 17:29:19 +0800
Message-Id: <20231031092921.2885109-4-dapeng1.mi@linux.intel.com>
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

Considering there are already 8 GP counters and 4 fixed counters on
latest Intel CPUs, like Sapphire Rapids. The original cnt array length
10 is definitely not enough to cover all supported PMU counters on these
new CPUs and it would cause PMU counter validation failures.

It's probably more and more GP and fixed counters are introduced in the
future and then directly extends the cnt array length to 64.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 1df5794b7ef8..6bd8f6d53f55 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -259,7 +259,7 @@ static void check_fixed_counters(void)
 
 static void check_counters_many(void)
 {
-	pmu_counter_t cnt[10];
+	pmu_counter_t cnt[64];
 	int i, n;
 
 	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
-- 
2.34.1


