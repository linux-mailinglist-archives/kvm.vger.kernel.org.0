Return-Path: <kvm+bounces-16118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A7B648B4936
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 04:29:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4314F1F21955
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 02:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A642810FF;
	Sun, 28 Apr 2024 02:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bDD+i5Tc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5778D65C
	for <kvm@vger.kernel.org>; Sun, 28 Apr 2024 02:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714271365; cv=none; b=rQqwl7uAfNDsV/eAxKvJhveD9EqewM/+25sqHTNaXenoucuQq7KpDQ0b1pgQJdcx8hDynuhBkZqt1d4oBQSkikveRD5tNHC/s9JrGBvc2ByOE6pjof9Tqg+vt8JuTqjsWdOcd4j1mDsDoqm2fRLz3EaAJ4ciAikWqdj0WdJZd9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714271365; c=relaxed/simple;
	bh=12dyaC4UZmyX/i1r3m+SiwpIZlk37zcFPT/a3X1IcKo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CMNkm5J92eUR6lWP3qo7/O9FXC31IOZm2Xdl3uQixtJ95yiqgAXeO7cjThUqPzzzE4Bnu+hsQ1PfdZ0S39bKSxD7jvM2v4CJfZ9SowsE8ffF7h5FEOjd5F4q7J/LvAoOEuDuVw8jBB3HuWJCMpWRmGtQMcXzLmxUdzWDDfQpfzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bDD+i5Tc; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714271364; x=1745807364;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=12dyaC4UZmyX/i1r3m+SiwpIZlk37zcFPT/a3X1IcKo=;
  b=bDD+i5TcOFkzHtKMxb43QwJUqfcsJJgoODgUpPgZYKWD7ljnrwrkH1+u
   8w417zFLGiL5x1ofTGMG2U8kvaP7Bl7Wbl4w2VJ9JUbjqnY/Wnq1rTbfN
   Iuj989umzlKWZdJgmSpC53Rer/rLmgLXn5CxqTuDDXV2evRm517fHHYJg
   YE1/agooufMoMaWkrFNHQMEICxGUJiApH85aiEqDAIRUCeocDxdWFAyUP
   53TxQoKOYTfpHHlDq+W99YRp1JzHfAcnixoORDoS41H0TZVeSE4dTSfWH
   rRp+XUE8ewzrpe735qjM42xjjXxXPLhWDkTzhgT8zu8RxgJeAZCr8y/TG
   A==;
X-CSE-ConnectionGUID: 2eo+zqoAR1SF1GlKYHuHeA==
X-CSE-MsgGUID: b9RZQbMqQXy/t8O7GKIj+g==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="21376171"
X-IronPort-AV: E=Sophos;i="6.07,236,1708416000"; 
   d="scan'208";a="21376171"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2024 19:29:23 -0700
X-CSE-ConnectionGUID: Yj2s/KwYRjGz+MKH/3PUFg==
X-CSE-MsgGUID: 8YIbgK+PQ9+XkCO/gmXgjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,236,1708416000"; 
   d="scan'208";a="25653674"
Received: from sqa-gate.sh.intel.com (HELO spr-2s3.tsp.org) ([10.239.48.212])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2024 19:29:21 -0700
From: Yao Yuan <yuan.yao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org,
	yuan.yao@linux.intel.com,
	yuan.yao@intel.com
Subject: [kvm-unit-tests PATCH 1/1] x86/apic: Fix test_apic_timer_one_shot() random failure
Date: Sun, 28 Apr 2024 10:29:06 +0800
Message-Id: <20240428022906.373130-1-yuan.yao@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Explicitly clear TMICT to avoid test_apic_timer_one_shot()
negative failure.

Clear TMICT to disable any enabled but masked local timer.
Otherwise timer interrupt may occur after lvtt_handler() is
set as handler and **before** TDCR or TIMCT is set to new
value, lead this test failure. Log comes from UEFI mode:

PASS: PV IPIs testing
PASS: pending nmi
Got local timer intr before write to TDCR / TMICT
old tmict:0x989680 old lvtt:0x30020 tsc2 - tsc1 = 0xb68
          ^^^^^^^^          ^^^^^^^
FAIL: APIC LVT timer one shot

Fixes: 9f815b293961 ("x86: apic: add LVT timer test")
Signed-off-by: Yao Yuan <yuan.yao@intel.com>
---
 x86/apic.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/x86/apic.c b/x86/apic.c
index dd7e7834..2052e864 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -480,6 +480,13 @@ static void test_apic_timer_one_shot(void)
 	uint64_t tsc1, tsc2;
 	static const uint32_t interval = 0x10000;
 
+	/*
+	 * clear TMICT to disable any enabled but masked local timer.
+	 * Otherwise timer interrupt may occur after lvtt_handler() is
+	 * set as handler and **before** TDCR or TIMCT is set to new value,
+	 * lead this test failure.
+	 */
+	apic_write(APIC_TMICT, 0);
 #define APIC_LVT_TIMER_VECTOR    (0xee)
 
 	handle_irq(APIC_LVT_TIMER_VECTOR, lvtt_handler);

base-commit: 9cab58249f98adc451933530fd7e618e1856eb94
-- 
2.27.0


