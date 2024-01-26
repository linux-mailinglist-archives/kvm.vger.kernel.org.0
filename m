Return-Path: <kvm+bounces-7093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8943D83D65E
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:32:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A032B28949
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3761350E4;
	Fri, 26 Jan 2024 08:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LNSZxcwt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E93D134723;
	Fri, 26 Jan 2024 08:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259367; cv=none; b=mywH7FoCD05TNk08hFpA1/S6mtVl97HOSF+yJo64fqSpFqPx8Lep9LZs1A8YbSMPZ6q9DF2hvdW2shm+GKoczeS4jzBfFOV03hpXzV9QMMwqL6ab84uYn5oZGn+aOyc+LWmLoXGEEv2VocH6lyQflschzATVOxZWwG3ZhKoK0+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259367; c=relaxed/simple;
	bh=kVHV3ZSwtwRLr8yW+td2pN/gCXQtNZBGLrTpR864AJM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aG9McuJz2myxs9nzTabuYCaQvOhTe3CXvXtL8A61zaw9uPMoDl2O0tCTZRHQaZh/sAcQNVmuZPPN/rxB/rUo6UTcm7PCu6s7e4RIjwCKbIPP8Cc7uc0y/U62iyz5TKRF/TbrIYPcGHwOWK6EOg8aaVWu41FzHVKTPn+rDhKBDHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LNSZxcwt; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259366; x=1737795366;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kVHV3ZSwtwRLr8yW+td2pN/gCXQtNZBGLrTpR864AJM=;
  b=LNSZxcwten2bv9zG/oVczeIs57yKck4gaIfXKPMj05H+gmckJmhyPXyp
   g+14NQzd21P+iNX5eHbtVZ99Wdkn/qtCRQPGCfBtVxvxz5tMahqCq45bT
   SLJtGA5hg4yVRKziHXIqJw8HhtXjsM4OnSph6XxmqlpFYGP6Lx78VLxdD
   mQTLjqn9lOwDtrdbfmTjocFv69HQCpIkMFTG2zPE42LYv+AhsaOoJCtBi
   w8gWaIsm3tl+4/Tc172R10UIhc3K+ZqIClKgItiXrucYUjgAzpg4jp8Xi
   FfztQzCU4PzCmLEaTK/Ikfxu8aZq32ji5JGgctOZKwjC4cdmRhJ5+/TET
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792110"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792110"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930309897"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930309897"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:00 -0800
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
Subject: [RFC PATCH 06/41] perf: x86: Add function to switch PMI handler
Date: Fri, 26 Jan 2024 16:54:09 +0800
Message-Id: <20240126085444.324918-7-xiong.y.zhang@linux.intel.com>
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

Add function to switch PMI handler since passthrough PMU and host PMU will
use different interrupt vectors.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/events/core.c            | 15 +++++++++++++++
 arch/x86/include/asm/perf_event.h |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 40ad1425ffa2..3f87894d8c8e 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -701,6 +701,21 @@ struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
 }
 EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
 
+void perf_guest_switch_to_host_pmi_vector(void)
+{
+	lockdep_assert_irqs_disabled();
+
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+}
+EXPORT_SYMBOL_GPL(perf_guest_switch_to_host_pmi_vector);
+
+void perf_guest_switch_to_kvm_pmi_vector(void)
+{
+	lockdep_assert_irqs_disabled();
+
+	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_VPMU_VECTOR);
+}
+EXPORT_SYMBOL_GPL(perf_guest_switch_to_kvm_pmi_vector);
 /*
  * There may be PMI landing after enabled=0. The PMI hitting could be before or
  * after disable_all.
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 2618ec7c3d1d..021ab362a061 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -573,6 +573,9 @@ static inline void perf_events_lapic_init(void)	{ }
 static inline void perf_check_microcode(void) { }
 #endif
 
+extern void perf_guest_switch_to_host_pmi_vector(void);
+extern void perf_guest_switch_to_kvm_pmi_vector(void);
+
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
 extern void x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
-- 
2.34.1


