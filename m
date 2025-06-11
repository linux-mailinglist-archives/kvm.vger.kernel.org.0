Return-Path: <kvm+bounces-48963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EF19AD49B4
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 05:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51EAD172BE2
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 03:50:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE57A21B9D3;
	Wed, 11 Jun 2025 03:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PzWE/LwE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A7D182B4;
	Wed, 11 Jun 2025 03:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749613741; cv=none; b=PNtifvpALCfxSV4teZKI/JC99nu1ajjLDkZIs7LZa2P974RGyoIAqANcC3ocQBxXITpAxsFoUUlAJLdB+By4ruji4KTsXwKyORxK4QX3IvwP/2KyXgha+WFc6lLDazkx6djH8nbMP6/U1+oP1/6tIRUvHumc3zc92x4POiPKMic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749613741; c=relaxed/simple;
	bh=LSbcy9Fqxg5HNHH4TDFafpQj4yGx1SwPwfWd9FU8XCk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LTPs19vZrqXT6zyEJACGP3Tx7BeOCQqb5t1/1DDzIHaepO+m+CUm6IJlHQGhUc7W3QbhNczsxxo+x5VSnnRW82zuR1o5DJDF++qScKlul9lrPWH2QAHwevftODdRye3HC9AmMj6FUohxwlpaMiWOaKC+fMkal9gz3NrhH677UqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PzWE/LwE; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749613740; x=1781149740;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LSbcy9Fqxg5HNHH4TDFafpQj4yGx1SwPwfWd9FU8XCk=;
  b=PzWE/LwE7dwAihJ5sVFwfpwNu6YN6UUdT+XUNWu/odoxRVD3RACZ9i5Z
   7biMbMIWmf7wIonf8o9vL5YGo2/LkUXRM+8/VpwGFmL2MLrHN1xF+Rexx
   CVNDb+yT7WMY8qV9lZNLeDEnH3Q8aEO120DT4Jc2/e9H3bkR4bM4pzoM9
   Dr6NHRulQ3HJeGyQBvOW55OPrlkODQizMZKqmf/HhhkYMO67BP1rEkq8a
   xeaBEHbFFToNKoiUH/P54VVtbN1k1KhfgRMKgVEyF2535/95bkTlYpIHF
   UN7fIXsWFvvO/GWVP+g74XsUYVr7sUTB/ZeS94FWUDJD+82ijea2meZ9k
   w==;
X-CSE-ConnectionGUID: hYJ7TwKuSwuiKf7DYQWZww==
X-CSE-MsgGUID: XA5KlGFfSLGZDjDzhBl0dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="63095717"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="63095717"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 20:49:00 -0700
X-CSE-ConnectionGUID: FEetEAYVRjapRGsjrhqHNg==
X-CSE-MsgGUID: 2zghLxYlSr+uR+cfcSSCCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="150884020"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa003.fm.intel.com with ESMTP; 10 Jun 2025 20:48:57 -0700
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
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests PATCH] x86/pmu: Verify all available GP counters in check_counters_many()
Date: Wed, 11 Jun 2025 07:58:42 +0000
Message-ID: <20250611075842.20959-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The intent of check_counters_many() is to verify all available counters
can count correctly at the same time. So an alternative event should be
picked to verify the avaialbe GP counter instead of skiping the counter
if the initial event is not available.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
Please notice this patch is based on Sean's "x86: Add CPUID properties,
 clean up related code" v2 patchset (https://lore.kernel.org/all/20250610195415.115404-1-seanjc@google.com/).

 x86/pmu.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 3987311c..a6b0cfcc 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -457,18 +457,34 @@ static void check_fixed_counters(void)
 	}
 }
 
+static struct pmu_event *get_one_event(int idx)
+{
+	int i;
+
+	if (pmu_arch_event_is_available(idx))
+		return &gp_events[idx % gp_events_size];
+
+	for (i = 0; i < gp_events_size; i++) {
+		if (pmu_arch_event_is_available(i))
+			return &gp_events[i];
+	}
+
+	return NULL;
+}
+
 static void check_counters_many(void)
 {
+	struct pmu_event *evt;
 	pmu_counter_t cnt[48];
 	int i, n;
 
 	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
-		if (!pmu_arch_event_is_available(i))
+		evt = get_one_event(i);
+		if (!evt)
 			continue;
 
 		cnt[n].ctr = MSR_GP_COUNTERx(n);
-		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR |
-			gp_events[i % gp_events_size].unit_sel;
+		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR | evt->unit_sel;
 		n++;
 	}
 	for (i = 0; i < fixed_counters_num; i++) {
-- 
2.43.0


