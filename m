Return-Path: <kvm+bounces-20868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40225924D9A
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:14:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68F731C231E7
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA5F26AD7;
	Wed,  3 Jul 2024 02:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L5pJodwu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C175122315;
	Wed,  3 Jul 2024 02:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972767; cv=none; b=RKBny2ZBdweZwGbq457oOvfII91nJolUortFQslxqLgTqZmA+dl+D47H0W5RW5ZnXgurymWsOjtrlRZ3mp0jgJK5lYu0VsZkP/gE4eMdChYB0xog2hcoO0HWgSPj5Zux05FTw26cJL9O0ihK1EGEfI1hjz/x9PbmP9U9Hf+r0sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972767; c=relaxed/simple;
	bh=J8M0I4LP/AgsGW+cohnqQuEL47InULKRmzAJ+kd1JvY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JviXOVAyQ/mN90sdDX87S7TXa57RlmLJNcPPGiDiUug9vjHlb3t9PsMwN3FFbX9k+Ba4SzAKNJ0sXPC65ZQVtdj+ILQrxcvdPISYbXeGaUnfy3cUJHRt5x+e2qti/ON5EvZsClqcGhjZz29Pohq1khJw0s1iz1tZds+cMoMlBc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L5pJodwu; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972766; x=1751508766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J8M0I4LP/AgsGW+cohnqQuEL47InULKRmzAJ+kd1JvY=;
  b=L5pJodwukgMcpTASDKHLZvJpm+UxRqMLXmuepoZNfd0EmmOJu88QbzNG
   iuhbbsDjDRYWK5L2JmafaoT/XnrsHqEK7Y0O9JUgbbqKeeeOptSDtOkmx
   46Z1GE7aoNOtBO/Zk8tiqrSZEZ2/5TFDteE8hu8+mE1ec3xr3fno4rvQO
   neYfZnLKOF2gPaQTVVJrAFRJOiBAkUg4aBCIBA3e2ON1eSLtgP6I2UhvV
   y/GshLjPOso0lh483/uRr/BYpddmGwQt6msRwmgzgY+ze8MWsoh2HtKIE
   RpHxWIe6YIaLOam9sbrZvt9nN+yUrQfoYjAmIIrxKYcobJpyPXKm3/X7Z
   A==;
X-CSE-ConnectionGUID: 8179dXqFR8CmjZYB0M3nlA==
X-CSE-MsgGUID: JjW995yLSKSriVFn6v+z8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17310993"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17310993"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:12:45 -0700
X-CSE-ConnectionGUID: yvoNCg0JQvKFUst1oKMJ+g==
X-CSE-MsgGUID: CaGycblnS9CWHkiZ+dvlFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148578"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:12:43 -0700
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
Subject: [Patch v5 06/18] x86: pmu: Add asserts to warn inconsistent fixed events and counters
Date: Wed,  3 Jul 2024 09:57:00 +0000
Message-Id: <20240703095712.64202-7-dapeng1.mi@linux.intel.com>
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
index b4de2680..3e0bf3a2 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -113,8 +113,12 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
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
@@ -740,6 +744,8 @@ int main(int ac, char **av)
 	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
 	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
 
+	assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
+
 	apic_write(APIC_LVTPC, PMI_VECTOR);
 
 	check_counters();
-- 
2.40.1


