Return-Path: <kvm+bounces-7090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F9F083D658
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A5A71C27434
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6528012F589;
	Fri, 26 Jan 2024 08:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I6uZZ9jo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327A612DD99;
	Fri, 26 Jan 2024 08:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259351; cv=none; b=PIb/nEbXblJIeLdTY6DiQ8gzJUW8NeFZpr0vgANDZrLlZKuTpc4TTMVDig7moRMvqjcnCVvgMEE8CEajarVC8txOiM5M3tpOSN01+mfp3PjSuQcif5AMJ7H3/f0t1B1v3ZmeKwPGa9hnPAfaF0SogEHOhEJm6QE+y8D8Q2/4eWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259351; c=relaxed/simple;
	bh=j+/uxe8eBjcxhFKmmV+TNL3Gnvy6/jWawY4A6DrZz/I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=blrLtUXYi9NxA2pLkhfQi2QVImbujXf49bmZuhKrU6iUVMuwRnIDCmXDdxc77DTfngr6o88gEL+x5C7Gh2IX+iZCWY6hY8yvekwCSaXeKdbTw8nSzFFvnmYhQqjQBCNtW28SZusIQel1hKxU1kalT2VIHPDCvxyfM5Gm/E4yhZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I6uZZ9jo; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259350; x=1737795350;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j+/uxe8eBjcxhFKmmV+TNL3Gnvy6/jWawY4A6DrZz/I=;
  b=I6uZZ9jooCMeYjMCVqPzsdoILxcvguc4p5jjXPeF8TEnpm7RAnt1OH71
   YPETNQqpqcCLxY+F+6dfOJWrHG/ZkIqlDMHtGhji4XCqyEADsv+R/OfEB
   0d/x+V356ZdJJsM+5dRzQ8sYnXjAhbupZKfx1jzZQ+qGhUW/hmKUAe4Te
   CyqDjejELDTc1BlwkUgZf5Z2LGxdS9s0kVGamyZaJyoPAPJVBpWwheP8P
   I1vF04JXeHvF/A9RjFpe0Y6u/TymfYaV2hi4/p5NbHXOZinnUjhvgv4BQ
   SMjhfzCK/ejkMXTQyFH+Payb1hmYKBEdWHKigQfwLM+Kc1M6AXqEu/JRv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792066"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792066"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:55:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930309817"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930309817"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:55:44 -0800
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mizhang@google.com,
	kan.liang@intel.com,
	zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com,
	jmattson@google.com
Cc: kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com,
	eranian@google.com,
	irogers@google.com,
	samantha.alt@intel.com,
	like.xu.linux@gmail.com,
	chao.gao@intel.com,
	xiong.y.zhang@linux.intel.com,
	Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [RFC PATCH 03/41] perf: Set exclude_guest onto nmi_watchdog
Date: Fri, 26 Jan 2024 16:54:06 +0800
Message-Id: <20240126085444.324918-4-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiong Zhang <xiong.y.zhang@intel.com>

The perf event for NMI watchdog is per cpu pinned system wide event,
if such event doesn't have exclude_guest flag, it will be put into
error state once guest with passthrough PMU starts, this breaks
NMI watchdog function totally.

This commit adds exclude_guest flag for this perf event, so this perf
event is stopped during VM running, but it will continue working after
VM exit. In this way the NMI watchdog can not detect hardlockups during
VM running, it still breaks NMI watchdog function a bit. But host perf
event must be stopped during VM with passthrough PMU running, current
no other reliable method can be used to replace perf event for NMI
watchdog.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 kernel/watchdog_perf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/watchdog_perf.c b/kernel/watchdog_perf.c
index 8ea00c4a24b2..c8ba656ff674 100644
--- a/kernel/watchdog_perf.c
+++ b/kernel/watchdog_perf.c
@@ -88,6 +88,7 @@ static struct perf_event_attr wd_hw_attr = {
 	.size		= sizeof(struct perf_event_attr),
 	.pinned		= 1,
 	.disabled	= 1,
+	.exclude_guest  = 1,
 };
 
 /* Callback function for perf event subsystem */
-- 
2.34.1


