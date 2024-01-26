Return-Path: <kvm+bounces-7096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 419CB83D664
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:33:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 746541C2827D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C8A13B7A4;
	Fri, 26 Jan 2024 08:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g7EmKPeY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC77713B793;
	Fri, 26 Jan 2024 08:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259383; cv=none; b=XjAMgP8CAlyKXI687umrdMeSWDw4/OzDCY+sOfHlPAGeuXKYMYzSBgKwHjPHRBOxFvXTbL2w6LXO0Wx/XfIOua8pocVJR+fj4rp/2epG9ujwWki73sU+gDak3sEaQ741F2IC60lTQw/LKWZOdCSQp/QSLU3sUM+jC53Msk5DZpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259383; c=relaxed/simple;
	bh=FNmnze51sS7ZRAsHO2TuBSH6BpqRtE5lEtl2KmvnGcA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qjF9+q535UMfVj7grO69igtWyJfPTrli6INiwMG8tvliz6G+gvjOsG2cusFmrH1OOExDXEtJWlMC5bwX/qM5rxOOfqsRfOCAJBID57wJVsEYs9+HB4B3XMS77HTVEtjHQ8XCnKMji3pVEdmrlfi+ChWyN0YtsRJyXyQkWa81ors=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g7EmKPeY; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259382; x=1737795382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FNmnze51sS7ZRAsHO2TuBSH6BpqRtE5lEtl2KmvnGcA=;
  b=g7EmKPeYYSDTkZ4GwviWXzK949kai9aDfRm7jnXcPzSGhi3o8ppL0I7O
   oUwkiaKvGdVQo2O50EEIRFzuax6aPSDZDN56RQLK6FGdZ+lmN5VXTi8bK
   FMHwSlqTTD3dptqanwfKHFTPOxYtSHzqWN3+vGAuLB4QH3zdXYlqUFQC5
   wI0ZviRvEQqJVpXHPlbu45hU3C8yiwnWlDXMuubCbkhNHZSpB5sZa8KBk
   rHguxyo8QeAC2u4wFJCs9/sXmCUFekqOPMkV71JFvs9cf9YSgl1Argjn9
   cPRVNu/Xbywq+pvUfyWjdr3lRJOhIcGgZs97M6YYJyj75YvxbE00rLBVf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792154"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792154"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930309964"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930309964"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:16 -0800
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
	xiong.y.zhang@linux.intel.com
Subject: [RFC PATCH 09/41] perf: core/x86: Forbid PMI handler when guest own PMU
Date: Fri, 26 Jan 2024 16:54:12 +0800
Message-Id: <20240126085444.324918-10-xiong.y.zhang@linux.intel.com>
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

From: Mingwei Zhang <mizhang@google.com>

If a guest PMI is delivered after VM-exit, the KVM maskable interrupt will
be held pending until EFLAGS.IF is set. In the meantime, if the logical
processor receives an NMI for any reason at all, perf_event_nmi_handler()
will be invoked. If there is any active perf event anywhere on the system,
x86_pmu_handle_irq() will be invoked, and it will clear
IA32_PERF_GLOBAL_STATUS. By the time KVM's PMI handler is invoked, it will
be a mystery which counter(s) overflowed.

When LVTPC is using KVM PMI vecotr, PMU is owned by guest, Host NMI let
x86_pmu_handle_irq() run, x86_pmu_handle_irq() restore PMU vector to NMI
and clear IA32_PERF_GLOBAL_STATUS, this breaks guest vPMU passthrough
environment.

So modify perf_event_nmi_handler() to check perf_is_in_guest_pasthrough(),
and if so, to simply return without calling x86_pmu_handle_irq().

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/events/core.c     | 17 +++++++++++++++++
 include/linux/perf_event.h |  1 +
 kernel/events/core.c       |  5 +++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index ece042cfb470..20a5ccc641b9 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1752,6 +1752,23 @@ perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 	u64 finish_clock;
 	int ret;
 
+	/*
+	 * When PMU is pass-through into guest, this handler should be forbidden from
+	 * running, the reasons are:
+	 * 1. After perf_guest_switch_to_kvm_pmi_vector() is called, and before cpu
+	 *    enter into non-root mode, NMI could happen, but x86_pmu_handle_irq()
+	 *    restore PMU to use NMI vector, which destroy KVM PMI vector setting.
+	 * 2. When VM is running, host NMI other than PMI causes VM exit, KVM will
+	 *    call host NMI handler (vmx_vcpu_enter_exit()) first before KVM save
+	 *    guest PMU context (kvm_pmu_save_pmu_context()), as x86_pmu_handle_irq()
+	 *    clear global_status MSR which has guest status now, then this destroy
+	 *    guest PMU status.
+	 * 3. After VM exit, but before KVM save guest PMU context, host NMI other
+	 *    than PMI could happen, x86_pmu_handle_irq() clear global_status MSR
+	 *    which has guest status now, then this destroy guest PMU status.
+	 */
+	if (perf_is_in_guest_passthrough())
+		return 0;
 	/*
 	 * All PMUs/events that share this PMI handler should make sure to
 	 * increment active_events for their events.
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9912d1112371..6cfa0f5ac120 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1716,6 +1716,7 @@ extern int perf_event_period(struct perf_event *event, u64 value);
 extern u64 perf_event_pause(struct perf_event *event, bool reset);
 extern void perf_guest_enter(void);
 extern void perf_guest_exit(void);
+extern bool perf_is_in_guest_passthrough(void);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void *
 perf_aux_output_begin(struct perf_output_handle *handle,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 59471eeec7e4..00ea2705444e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5848,6 +5848,11 @@ void perf_guest_exit(void)
 }
 EXPORT_SYMBOL_GPL(perf_guest_exit);
 
+bool perf_is_in_guest_passthrough(void)
+{
+	return __this_cpu_read(__perf_force_exclude_guest);
+}
+
 static inline int perf_force_exclude_guest_check(struct perf_event *event,
 						 int cpu, struct task_struct *task)
 {
-- 
2.34.1


