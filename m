Return-Path: <kvm+bounces-47545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC8E4AC2044
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F08BA3A34A1
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A1D23BF9E;
	Fri, 23 May 2025 09:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gwl/jjbi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54A5227EA4;
	Fri, 23 May 2025 09:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994032; cv=none; b=DjbMTRkRPODO3obp3SwGU5HqXbiqqAY2SqkgiMIMTJGUkaYA1wdHHvcSiVGEmLWteRP8EJjwXSkqQ7NW+Fvs3PrEvPyRAGFioB7QQZ3l0VpYIPTrJpnzg7RBSUJDP7+gO0V7lhNE5ZSml4DDaxYVJ/CFQepsCFCy54s2NKGzG/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994032; c=relaxed/simple;
	bh=rDHJEMn78FhgXJR8YNVixNZDLTo+19F3bcivnngaor4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtBt9Q1m8F7lTRbf9DyvZsNxFWMi3kgEcENr1Yi+Fuybe46Y2dE8sgJR95izFfw6z3BXH5kAlRU4E1CMZGAkEhDQ1BvAIMS5fww12bV4X8zJrnBp0v9/I5QBu3uswyg5CY8j+hhAHpJqCQY0Dn/7K83BY+K2TwFltJOuVGYe8D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gwl/jjbi; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994031; x=1779530031;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rDHJEMn78FhgXJR8YNVixNZDLTo+19F3bcivnngaor4=;
  b=Gwl/jjbi++BZ9VeQF2cxcNMgGC0sqM0C2DRmZw6XjoRM1VU8XJPhPcNG
   Zh9KzK4VJsx1sBIE84E7Ehn8X8s91DDJ0LYX1gnUx2Jz3gbeIYlrAJs8X
   MCDqhS/m7pMKmblWaWWJf7WKd7cl6PxnsQ05UOt4bowyix5iU+OWpbH8T
   5Fgi+tRFxGnnsnCKZ7IErkzQuilZ04IyXpi+5tJ9e3bxCi5HnDElOW393
   zwsx1mnyYqZ3zbMXoarc2UyX3zBJ4n7c4zww6b5ZnIbXZIyfmHTgitrdf
   1WbgQzCWmiJppoANAI5J5GMAwBtKJisEUgOG9jQj6FdQSW3GICSo3yDFD
   Q==;
X-CSE-ConnectionGUID: KKqKNXOpQqKa9BEchkIwlA==
X-CSE-MsgGUID: W4+vr9IvQZOPmYQ4u7CJyQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444181"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444181"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:50 -0700
X-CSE-ConnectionGUID: Uo9z9jH9SmS3tWtEwnbnJg==
X-CSE-MsgGUID: 68SxmyUjT+SmOoR80T30Aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315069"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:50 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	kirill.shutemov@intel.com,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	elena.reshetova@intel.com,
	rick.p.edgecombe@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 10/20] x86/virt/seamldr: Introduce skeleton for TD-Preserving updates
Date: Fri, 23 May 2025 02:52:33 -0700
Message-ID: <20250523095322.88774-11-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250523095322.88774-1-chao.gao@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To perform TD-Preserving updates, the kernel must stop invoking any TDX
module SEAMCALLs. Currently, these SEAMCALLs can be invoked in various
contexts and in parallel across CPUs. Additionally, considering the need to
force all vCPUs out of guest mode, no single lock primitive, except for
stop_machine(), can meet this requirement.

A failed attempt is to lock all KVM entry points and kick all vCPUs. But it
cannot be done within KVM TDX code. And it needs to introduce new
infrastructure and maintenance burden outside of tdx for questionable
benefits.

Perform TD-Preserving updates within stop_machine() as it achieves the
seamldr requirements and is an existing well understood mechanism.

TD-Preserving updates consist of several steps: shutting down the old
module, installing the new module, and initializing the new one and etc.
Some steps must be executed on a single CPU, others serially across all
CPUs, and some can be performed concurrently on all CPUs and there are
ordering requirements between steps. So, all CPUs need to perform the work
in a step-locked manner.

In preparation for adding concrete steps for TD-Preserving updates,
establish the framework by mimicking multi_cpu_stop(). Specifically, use a
global state machine to control the work done on each CPU and require all
CPUs to acknowledge completion before proceeding to the next stage.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
instead of copy-pasting multi_cpu_stop(), would it be better to
abstract a common function and adapt it for TD-Preserving updates?
---
 arch/x86/virt/vmx/tdx/seamldr.c | 63 +++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index cdf85dff6d69..01dc2b0bc4a5 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -12,7 +12,9 @@
 #include <linux/gfp.h>
 #include <linux/kobject.h>
 #include <linux/mm.h>
+#include <linux/nmi.h>
 #include <linux/slab.h>
+#include <linux/stop_machine.h>
 #include <linux/sysfs.h>
 
 #include "tdx.h"
@@ -237,6 +239,62 @@ static struct seamldr_params *init_seamldr_params(const u8 *data, u32 size)
 	return alloc_seamldr_params(module, module_size, sig, sig_size);
 }
 
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
+static void set_state(enum tdp_state state)
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
+		set_state(tdp_data.state + 1);
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
+		}
+		rcu_momentary_eqs();
+	} while (curstate != TDP_DONE);
+
+	return ret;
+}
+
 /*
  * Temporary flag to guard TD-Preserving updates. This will be removed once
  * all necessary components for its support are integrated.
@@ -256,9 +314,8 @@ static int seamldr_install_module(const u8 *data, u32 size)
 	if (IS_ERR(params))
 		return PTR_ERR(params);
 
-	/* TODO: Install and initialize the new TDX module */
-
-	return 0;
+	set_state(TDP_START + 1);
+	return stop_machine(do_seamldr_install_module, params, cpu_online_mask);
 }
 
 static enum fw_upload_err tdx_fw_prepare(struct fw_upload *fwl,
-- 
2.47.1


