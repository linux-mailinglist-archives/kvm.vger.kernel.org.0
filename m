Return-Path: <kvm+bounces-52825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09C75B09952
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 03:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6202C4A721A
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 01:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6C441E0DD8;
	Fri, 18 Jul 2025 01:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZXVjFL8F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67751DE8BE;
	Fri, 18 Jul 2025 01:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752802814; cv=none; b=ppC/ZV5z52Yhr3hB3Db6h7A44LbkY2SRYFkG/9sGQ6wnPkWzPraq2rowr7gyM1VtnuOUSd+urAHPoLNKWd7Duxr45Jc5jT0inybRNwPQ3mwr1nxFZnNpm12AhMK52U/Ftx4kSndcnLa5rA2e1zYH3DLwNJtHU44jY8cAm+FrZLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752802814; c=relaxed/simple;
	bh=4QUPfFjhBY0qsc2M2KLTWST4hhzTyiWf2rdYoO1kkPc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DpdaJ5RbwbfoswtaV/TODpf6IIhPrB6F/mAKX+raOLO3mxlzORTer7oloOU0VUqgFQyjALp87Mjxx/oGtnIOHhcU2XvmDE3bov044T0Wy536TX+pxJW4Gr5OV+R3iui+dC1O1St1QCb4VZUmAJulnFKvqfGtr90Z/iZ+Q7MG3KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZXVjFL8F; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752802813; x=1784338813;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4QUPfFjhBY0qsc2M2KLTWST4hhzTyiWf2rdYoO1kkPc=;
  b=ZXVjFL8FczK8XaZvVjtPy0tjW7s+t7EyjxfFTaUS9S2un9INct8akR1W
   NnLdYHRuT0rpZndw3kkxUB6GuVxQiti8aEHq9Gj8IzQ/pmco/UWLfSD45
   0W0dh7BeD4w76ofHXk0i9mGTAork249ywf0wMfHz2M0CiG9t3wP657mhZ
   smgd6I5tDPKtS8x+AIbkjoFGwincJyk/cX+lQ45+HD3qzGzgSeL9xblqJ
   TeWWvvKT+35p93/awyKaV640ERyfH1pACDpUn9RqD32HIGzr2EhWNmgYY
   7w97ORfWaFM8hJP4BTdqqr62+WQzz1URgMBArVs4tiuRKN+G9JWh9eyuZ
   g==;
X-CSE-ConnectionGUID: dMOBgshjQ1WjvlBtw7zbNg==
X-CSE-MsgGUID: x5UkO3VkQPqEKOBemZz6eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="54951512"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="54951512"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 18:40:13 -0700
X-CSE-ConnectionGUID: RrcKjjsPS/e4ClH0i+tWMQ==
X-CSE-MsgGUID: 2rXa9Ds8QtK9wqQu4KaAFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="188918415"
Received: from spr.sh.intel.com ([10.112.229.196])
  by fmviesa001.fm.intel.com with ESMTP; 17 Jul 2025 18:40:09 -0700
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
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v2 5/7] x86/pmu: Expand "llc references" upper limit for broader compatibility
Date: Fri, 18 Jul 2025 09:39:13 +0800
Message-Id: <20250718013915.227452-6-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250718013915.227452-1-dapeng1.mi@linux.intel.com>
References: <20250718013915.227452-1-dapeng1.mi@linux.intel.com>
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
2.34.1


