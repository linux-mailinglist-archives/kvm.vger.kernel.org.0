Return-Path: <kvm+bounces-15191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 745848AA764
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:47:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30F4F2848EB
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB9B82AE87;
	Fri, 19 Apr 2024 03:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BZRjxdVc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D709F2837B;
	Fri, 19 Apr 2024 03:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498353; cv=none; b=hr7/bkSvg3zkYmKApfQAUMM9u15FLq7Nn/GaVoliT3VMcnDEDi2KLQeObt2liu5v8h9v+3OgiM5B89pTQDdiqr+rttm6aSH4OmePFzxd3s0BcOfZTC4XtiG3e4g6jakw2CDVkmwSkqtCovzWRU4rgiGnl80urfNLXz8yvFO9ZLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498353; c=relaxed/simple;
	bh=xJIfGxQUiFH95XrF4Oof2nG2cWZnTQoaCXLtcOAi5sY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YDaOZm0AW56w4ULzlrXFqDM6ZpmHgSQClP7i7MFn0hMH7C42vxmmVzCHOUEvEoFKXmt+dQMo8FC1YSubA/f74uy13q4afPMjU101XhfIjqnrFeAl2ziJgihM0XDTfdt1546u6J18zRO/WaC5Wxc1g8tYJPaI4Ic3CEbGM5b+Zno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BZRjxdVc; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498352; x=1745034352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xJIfGxQUiFH95XrF4Oof2nG2cWZnTQoaCXLtcOAi5sY=;
  b=BZRjxdVccrWgQ984QoY3IPt4imRQJvnatuDVrXV0Jh3mo712crxyH5aD
   pj/osOAPaXTcf6lLkhMetvxHKVLnxjAz6dBOwX50bxVztGlX/lRX4a134
   MmRu+8I/yAuD0gwIYwz59zokeynaiuBL7OdOVNMkUK4SFkBfJUTXovETb
   qprm5Hjf05M/kSSt3X7OjaJUre4+7sDYJ9VB3nr4UDNNixPZt0NzkIeJp
   O4mKWVFioCwau6QS40rTXsgWxELeg1258ESGV6h2pzF8rwppvENttwDAf
   99JePXQBKJ45v4fARASHPms/39Zw+/PQ3x0ElKTGYCCFbxwG5R+nqhgVM
   Q==;
X-CSE-ConnectionGUID: vP5B/sC0QleaS0vU4lBJ2w==
X-CSE-MsgGUID: P/ecdxjbRciDkxkrFxElRQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565443"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565443"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:45:51 -0700
X-CSE-ConnectionGUID: nzqB9zqrR4iITSAUJjbcjw==
X-CSE-MsgGUID: WY5nL+qURCGpqKn6hd6Y1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410156"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:45:48 -0700
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
Subject: [kvm-unit-tests Patch v4 06/17] x86: pmu: Add asserts to warn inconsistent fixed events and counters
Date: Fri, 19 Apr 2024 11:52:22 +0800
Message-Id: <20240419035233.3837621-7-dapeng1.mi@linux.intel.com>
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

Current PMU code deosn't check whether PMU fixed counter number is
larger than pre-defined fixed events. If so, it would cause memory
access out of range.

So add assert to warn this invalid case.

Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 494af4012e84..461a4090d475 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -111,8 +111,12 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 		for (i = 0; i < gp_events_size; i++)
 			if (gp_events[i].unit_sel == (cnt->config & 0xffff))
 				return &gp_events[i];
-	} else
-		return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CTR0];
+	} else {
+		unsigned int idx = cnt->ctr - MSR_CORE_PERF_FIXED_CTR0;
+
+		assert(idx < ARRAY_SIZE(fixed_events));
+		return &fixed_events[idx];
+	}
 
 	return (void*)0;
 }
@@ -738,6 +742,8 @@ int main(int ac, char **av)
 	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
 	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
 
+	assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
+
 	apic_write(APIC_LVTPC, PMI_VECTOR);
 
 	check_counters();
-- 
2.34.1


