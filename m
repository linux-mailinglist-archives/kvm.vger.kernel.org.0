Return-Path: <kvm+bounces-52459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F269B054FB
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:33:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F170178D27
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:33:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C382D5C8E;
	Tue, 15 Jul 2025 08:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="btkodKuJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1462D4B47;
	Tue, 15 Jul 2025 08:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752568320; cv=none; b=Pv2WpH8RathtqZoftQmrpDrQI6p1jTU2PM8feXyDv6VwlUwlxTyIUD7VU6nIW7+GQL1h66JiWLKhJQtjU4XlnQaWiyVEELdQzLhtif1H0Z2hDC+8kIXAoIuiSj7ho1YbT6L4c1vbmJeUEh9oB18Dl4P/Wer3nBjY2V9GLY4upRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752568320; c=relaxed/simple;
	bh=wB6hEFFzvmOcnpBZLYTMSOsSPCn29ml9ZB1Zmap4zqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5Af1NdwtliVSyfrBlrk+eDd0VTcmGxa6CMzFrzh1BhAXFiZAgbWkUnZJ9rDJPJaga+9Qj3deurBvDGNwFYJvFsuPOGxKYjvrVc1AK/gHPV8WhCmPxCQrj3LbCFS73DGKQnUymutecI60rKH2A/sH6eMOCJLQXzaD9OwfSfmc9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=btkodKuJ; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752568320; x=1784104320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wB6hEFFzvmOcnpBZLYTMSOsSPCn29ml9ZB1Zmap4zqg=;
  b=btkodKuJJsBumquyM8UTsmY93elcYYG/LJhFN/kh0Bi3K/q/k5R/DZJg
   aEDOw5ETu7jte7P70rgmLC3ZMU1G26GWJOQzT/H9O2a3+TJDkPY0+wtBp
   uaAZSAYNC028W2ZyzkwY8g21jBGTklf+KqxVFH5Znva2YmeXvX56hVwG0
   IAoXkYUpZqx6C8x0qbAKlTdo9n0On1VEiwncupeOP2yVzsa/zL5oP+4XW
   Jco2WYRsELYk2Z7QgU9YDDO7WR+drtJOEeeZnjogTfrZxGfQRcQTVOBtZ
   sOcFrp15PjfPxt7ntL9+xLlagzIWMgtKjnRfVcpdIsLulJZix0KSkxCJU
   w==;
X-CSE-ConnectionGUID: 81rBu93kRRKJ36qGvrcZ/w==
X-CSE-MsgGUID: Da+TjxOwSoyfHAfWbBkpxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54632125"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54632125"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 01:31:59 -0700
X-CSE-ConnectionGUID: 85HYvWqASsWSDK7lGaxF2A==
X-CSE-MsgGUID: SgsKgsojRpu7AnERVa8LMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="156572604"
Received: from emr.sh.intel.com ([10.112.229.56])
  by orviesa010.jf.intel.com with ESMTP; 15 Jul 2025 01:31:55 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Yi Lai <yi1.lai@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch 5/5] x86/pmu: Expand "llc references" upper limit for broader compatibility
Date: Sat, 12 Jul 2025 17:49:15 +0000
Message-ID: <20250712174915.196103-6-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250712174915.196103-1-dapeng1.mi@linux.intel.com>
References: <20250712174915.196103-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: dongsheng <dongsheng.x.zhang@intel.com>

Increase the upper limit of the "llc references" test to accommodate
results observed on additional Intel CPU models, including CWF and
SRF.
These CPUs exhibited higher reference counts that previously caused
the test to fail.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index c54c0988..445ea6b4 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -116,7 +116,7 @@ struct pmu_event {
 	{"core cycles", 0x003c, 1*N, 50*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
 	{"ref cycles", 0x013c, 1*N, 30*N},
-	{"llc references", 0x4f2e, 1, 2*N},
+	{"llc references", 0x4f2e, 1, 2.5*N},
 	{"llc misses", 0x412e, 1, 1*N},
 	{"branches", 0x00c4, 1*N, 1.1*N},
 	{"branch misses", 0x00c5, 1, 0.1*N},
-- 
2.43.0


