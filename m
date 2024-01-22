Return-Path: <kvm+bounces-6589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A5883797A
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D799128D46B
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE7756B81;
	Mon, 22 Jan 2024 23:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bB4uTl4F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C6854BE5;
	Mon, 22 Jan 2024 23:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967705; cv=none; b=OXr2wkZeATGOz2ghd+oQQWuFjPZNZY9fR+dJ5IlhfGDBoj4jb0Mo7F7uDE267XUvzNCg8ZqRzaks34j0KNUyXxaXM62SpPmSvkbZwo5Z/1Q2bI0YOJO8WXTA3hKDBcIpJL5q/MoTvSR3rjf2Uwj3miOwxYpRD3C0xeFdyXBfKxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967705; c=relaxed/simple;
	bh=1Lw47D62OYrYDhKcRN3J6hrodK9HQ5m6bVLI1xUrtr4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fWLBHumx2fK7RUCTB+NgJemJkK49U/MP8tcPIQQyfRe1WS5wHAsC20qxlkW+iR1YLIN7Dza7ltsv7z+Syd2IHGduCcfgHtuRtc8vaHn7vxw3nBGZqTXIAjQbdx0ywuj2n91jG5VZH84hnZ6apKWfexR0yThhLFB1V+kXdcQO6rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bB4uTl4F; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967704; x=1737503704;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Lw47D62OYrYDhKcRN3J6hrodK9HQ5m6bVLI1xUrtr4=;
  b=bB4uTl4F8Pg4ZypuDteo8+9nObw8ooCeGyvHtr9IhGPJLh1QOeHXXZVm
   dFRn2RRCKohxN71joH/8rGISGe0Ei5ruJRlFKrbdxyxBUu4EZ7CscxZHk
   b3IZgbhD9vdvPSMMmbVB+gFzZLVSZsu2BgRmaIubmimU6z6QNVWnlJh8a
   hbewFt33QFDYACsCK2GvgP/vhwdhs9Qb1CyF7GsV9wxXrYl/Q11K5QUTd
   W60p7d+oukw5ES+GRNe4r+GgSQ2mM3vIWA6GekFTLJ+T2lhX/ZNX9a3Wq
   grgNPsCRw8GAGa/bdRlYYZYFTJLtWPES2Xany4ukxS+JUZpDkczn1MyCq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1217881"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1217881"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1350188"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:03 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v18 016/121] KVM: TDX: Add helper functions to print TDX SEAMCALL error
Date: Mon, 22 Jan 2024 15:52:52 -0800
Message-Id: <0375033d320c599deee675c4232543c73233ce8b.1705965634.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add helper functions to print out errors from the TDX module in a uniform
manner.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
v18:
- Added Reviewed-by Binbin.
---
 arch/x86/kvm/Makefile        |  2 +-
 arch/x86/kvm/vmx/tdx_error.c | 21 +++++++++++++++++++++
 arch/x86/kvm/vmx/tdx_ops.h   |  5 +++++
 3 files changed, 27 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/vmx/tdx_error.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 5b85ef84b2e9..44b0594da877 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -24,7 +24,7 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 kvm-intel-$(CONFIG_KVM_HYPERV)	+= vmx/hyperv.o vmx/hyperv_evmcs.o
-kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
+kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o vmx/tdx_error.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
 			   svm/sev.o
diff --git a/arch/x86/kvm/vmx/tdx_error.c b/arch/x86/kvm/vmx/tdx_error.c
new file mode 100644
index 000000000000..42fcabe1f6c7
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_error.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+/* functions to record TDX SEAMCALL error */
+
+#include <linux/kernel.h>
+#include <linux/bug.h>
+
+#include "tdx_ops.h"
+
+void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out)
+{
+	if (!out) {
+		pr_err_ratelimited("SEAMCALL (0x%016llx) failed: 0x%016llx\n",
+				   op, error_code);
+		return;
+	}
+
+#define MSG	\
+	"SEAMCALL (0x%016llx) failed: 0x%016llx RCX 0x%016llx RDX 0x%016llx R8 0x%016llx R9 0x%016llx R10 0x%016llx R11 0x%016llx\n"
+	pr_err_ratelimited(MSG, op, error_code, out->rcx, out->rdx, out->r8,
+			   out->r9, out->r10, out->r11);
+}
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index f4c16e5265f0..cd12e9c2a421 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -10,6 +10,7 @@
 #include <asm/cacheflush.h>
 #include <asm/asm.h>
 #include <asm/kvm_host.h>
+#include <asm/tdx.h>
 
 #include "tdx_errno.h"
 #include "tdx_arch.h"
@@ -47,6 +48,10 @@ static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
 	return ret;
 }
 
+#ifdef CONFIG_INTEL_TDX_HOST
+void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out);
+#endif
+
 static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 {
 	struct tdx_module_args in = {
-- 
2.25.1


