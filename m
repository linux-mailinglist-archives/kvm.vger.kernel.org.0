Return-Path: <kvm+bounces-68989-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6OVjBQSOc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68989-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:04:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E21607773A
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:04:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1CB86302626B
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69D0235CBB2;
	Fri, 23 Jan 2026 15:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cUHkHEbE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1D026F289;
	Fri, 23 Jan 2026 15:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180432; cv=none; b=IffqZxQwDSkpSOGElNOgXZuemlRrook8a0hqHpEPwBTmggLGMEoAfL6WmObtJbK+jICgDOMKi6J7OU8b3TTsNLwfsh4y+BBU//ZLGYPXw5XpV1X9oU/q3rmGqDgtulMCAeE17MvRWxkRMPvEkwunvqdPuG85yQzgtRsUubO2+CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180432; c=relaxed/simple;
	bh=pj80xMaMJyv6ytv5C3tFWZzqYHBt6ByJtfpSuegj9sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brexv5cRmQVJbpZl0Y8Kpge7JhuzK3zk9PmOdN3wPgUPwgxOIDEMl7m4PGaPPOMnEzz5pVFSmK7jxx42uosN36r0UdFHgFIzmr+0+LnFJiurrau+ZqzafoH5Xy8R+g4qLGSdabZcpBhnUJxGQgNhcxntryTK19npC/1xdQE5ZtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cUHkHEbE; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180430; x=1800716430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pj80xMaMJyv6ytv5C3tFWZzqYHBt6ByJtfpSuegj9sA=;
  b=cUHkHEbEkv6vGYdUJNeXqnVGyg8qMYapjbNON7iuBLcRfvXDmTE7jNWX
   NbhJvM0Ytncp3hRshNc0rxOE6P3pCRBVeF6DisMQu3OYy1rbFAnqUg8tS
   cZPhU9vn/AAVZl6vl+CH532YpxvLGvwqPP3fzuzOfWWmNOkT1CBd0ZuXT
   z09IORWzihl+VEy1UrPAhDssMwCGIapSG20Xr8HzxpvSR/KdhFLUgYnVW
   p15SJqdWsAfz6BQsj3lR9x1QgLmZP5YJqSA5nBQLzA04NzDGIYlDJNDM1
   vEf/M1AGz4WnFh2ono6WmzIRpO/I9OVtxBEhjSfO1daIFhLshO6hoNwV3
   A==;
X-CSE-ConnectionGUID: 5zRsVxuZSmO0p1uKbJQrAw==
X-CSE-MsgGUID: dRiOM+7+T1aO1H4HYA5EwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334440"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334440"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:15 -0800
X-CSE-ConnectionGUID: TgAQZjCnQeCw9Ab47JpCgQ==
X-CSE-MsgGUID: a0VuTPaYTd+Hi237MV2KXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697151"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:15 -0800
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org
Cc: reinette.chatre@intel.com,
	ira.weiny@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	sagis@google.com,
	vannapurve@google.com,
	paulmck@kernel.org,
	nik.borisov@suse.com,
	zhenzhong.duan@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	vishal.l.verma@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 14/26] x86/virt/seamldr: Introduce skeleton for TDX Module updates
Date: Fri, 23 Jan 2026 06:55:22 -0800
Message-ID: <20260123145645.90444-15-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123145645.90444-1-chao.gao@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68989-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: E21607773A
X-Rspamd-Action: no action

The P-SEAMLDR requires that no TDX Module SEAMCALLs are invoked during a
runtime TDX Module update.

But currently, TDX Module SEAMCALLs are invoked in various contexts and in
parallel across CPUs. Additionally, considering the need to force all vCPUs
out of guest mode, no single lock primitive, except for stop_machine(), can
meet this requirement.

Perform TDX Module updates within stop_machine() as it achieves the
P-SEAMLDR requirements and is an existing well understood mechanism.

TDX Module updates consist of several steps: shutting down the old
module, installing the new module, and initializing the new one and etc.
Some steps must be executed on a single CPU, others serially across all
CPUs, and some can be performed concurrently on all CPUs and there are
ordering requirements between steps. So, all CPUs need to perform the work
in a step-locked manner.

In preparation for adding concrete steps for TDX Module updates,
establish the framework by mimicking multi_cpu_stop(). Specifically, use a
global state machine to control the work done on each CPU and require all
CPUs to acknowledge completion before proceeding to the next stage.

Potential alternative to stop_machine()
=======================================
An alternative approach is to lock all KVM entry points and kick all
vCPUs.  Here, KVM entry points refer to KVM VM/vCPU ioctl entry points,
implemented in KVM common code (virt/kvm). Adding a locking mechanism
there would affect all architectures. And to lock only TDX vCPUs, new
logic would be needed to identify TDX vCPUs, which the common code
currently lacks. This would add significant complexity and maintenance
overhead for a TDX-specific use case.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
v2:
 - refine the changlog to follow context-problem-solution structure
 - move alternative discussions at the end of the changelog
 - add a comment about state machine transition
 - Move rcu_momentary_eqs() call to the else branch.
---
 arch/x86/virt/vmx/tdx/seamldr.c | 71 ++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index d136ef89cd36..06080c648b02 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -11,7 +11,9 @@
 #include <linux/cpumask.h>
 #include <linux/irqflags.h>
 #include <linux/mm.h>
+#include <linux/nmi.h>
 #include <linux/slab.h>
+#include <linux/stop_machine.h>
 #include <linux/types.h>
 
 #include <asm/seamldr.h>
@@ -223,6 +225,68 @@ static struct seamldr_params *init_seamldr_params(const u8 *data, u32 size)
 	return alloc_seamldr_params(module, module_size, sig, sig_size);
 }
 
+/*
+ * During a TDX Module update, all CPUs start from TDP_START and progress
+ * to TDP_DONE. Each state is associated with certain work. For some
+ * states, just one CPU needs to perform the work, while other CPUs just
+ * wait during those states.
+ */
+enum tdp_state {
+	TDP_START,
+	TDP_DONE,
+};
+
+static struct {
+	enum tdp_state state;
+	atomic_t thread_ack;
+} tdp_data;
+
+static void set_target_state(enum tdp_state state)
+{
+	/* Reset ack counter. */
+	atomic_set(&tdp_data.thread_ack, num_online_cpus());
+	/* Ensure thread_ack is updated before the new state */
+	smp_wmb();
+	WRITE_ONCE(tdp_data.state, state);
+}
+
+/* Last one to ack a state moves to the next state. */
+static void ack_state(void)
+{
+	if (atomic_dec_and_test(&tdp_data.thread_ack))
+		set_target_state(tdp_data.state + 1);
+}
+
+/*
+ * See multi_cpu_stop() from where this multi-cpu state-machine was
+ * adopted, and the rationale for touch_nmi_watchdog()
+ */
+static int do_seamldr_install_module(void *params)
+{
+	enum tdp_state newstate, curstate = TDP_START;
+	int ret = 0;
+
+	do {
+		/* Chill out and ensure we re-read tdp_data. */
+		cpu_relax();
+		newstate = READ_ONCE(tdp_data.state);
+
+		if (newstate != curstate) {
+			curstate = newstate;
+			switch (curstate) {
+			default:
+				break;
+			}
+			ack_state();
+		} else {
+			touch_nmi_watchdog();
+			rcu_momentary_eqs();
+		}
+	} while (curstate != TDP_DONE);
+
+	return ret;
+}
+
 DEFINE_FREE(free_seamldr_params, struct seamldr_params *,
 	    if (!IS_ERR_OR_NULL(_T)) free_seamldr_params(_T))
 
@@ -237,6 +301,7 @@ DEFINE_FREE(free_seamldr_params, struct seamldr_params *,
 int seamldr_install_module(const u8 *data, u32 size)
 {
 	const struct seamldr_info *info = seamldr_get_info();
+	int ret;
 
 	if (!info)
 		return -EIO;
@@ -258,7 +323,11 @@ int seamldr_install_module(const u8 *data, u32 size)
 		return -EBUSY;
 	}
 
-	/* TODO: Update TDX Module here */
+	set_target_state(TDP_START + 1);
+	ret = stop_machine_cpuslocked(do_seamldr_install_module, params, cpu_online_mask);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 EXPORT_SYMBOL_FOR_MODULES(seamldr_install_module, "tdx-host");
-- 
2.47.3


