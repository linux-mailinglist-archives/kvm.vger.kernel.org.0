Return-Path: <kvm+bounces-4147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC3B880E442
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 07:28:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82955282DE9
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 06:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99554171A1;
	Tue, 12 Dec 2023 06:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aVPtKyOT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3F7C7
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 22:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702362469; x=1733898469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kKP/LM2k0PR9JR6zCiSlhSnR/j7UD+H4pnkmqeamgBI=;
  b=aVPtKyOT1Use9qLCifdGucyxzt2XSCvCC2DrzXEVcBCsZCO0uw1ylJVZ
   Yt24LxtOmIUvl8SDqIjN0QShCN8ZIG1uZMEs5oXD05TpEvwbO4jRtFGm3
   uOTGsFt6nrPYf7yNgT1g/tYquGrpd3vBVPeNYFW7rA8lH0ivLn+RJQsJz
   uICrABuDbNv6L+VPur69P2AaeDYIss5TBN9tMru0+Cq6Q+8ww1RrbOMO6
   7V8vUGson8l9G0Lsq/TwzNjNCeips29EJIjc8HaEX6NH1Al8E7tQumcmU
   5T5KTGSmbHOi086xYQDPe6YynxfmClrLWCZKnanwNsv1nrnrggsrn91rd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="8128907"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="8128907"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 22:27:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="723109042"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="723109042"
Received: from spr-bkc-pc.jf.intel.com ([10.165.56.234])
  by orsmga003.jf.intel.com with ESMTP; 11 Dec 2023 22:27:48 -0800
From: Dan Wu <dan1.wu@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	dan1.wu@intel.com
Subject: [kvm-unit-tests PATCH v1 3/3] x86/asyncpf: Add CPUID feature bits check to ensure feature is available
Date: Tue, 12 Dec 2023 14:27:08 +0800
Message-Id: <20231212062708.16509-4-dan1.wu@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231212062708.16509-1-dan1.wu@intel.com>
References: <20231212062708.16509-1-dan1.wu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Asyncpf test only works for #PF-based 'page-ready' notification. This case
becomes invalid for KVM that starts to enumerate interrupt-based 'page-ready'
notification.

Add CPUID feature check at the beginning, and skip the test when KVM_FEATURE_ASYNC_PF
is not available or it enumerates KVM_FEATURE_ASYNC_PF_INT.

To run this test, add the QEMU option "-cpu host" to check CPUID, since
KVM_FEATURE_ASYNC_PF_INT can't be detected without "-cpu host".

Update the usage of how to setup cgroup for different cgroup versions.

Signed-off-by: Dan Wu <dan1.wu@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Unlike patch #2, this patch retains the original test without reducing the memory
access round from 2 to 1. If anyone thinks it worthes a go, please call out.
---
 x86/asyncpf.c     | 22 ++++++++++++++++++++--
 x86/unittests.cfg |  2 +-
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/x86/asyncpf.c b/x86/asyncpf.c
index a0bdefcf..e2cf9934 100644
--- a/x86/asyncpf.c
+++ b/x86/asyncpf.c
@@ -1,18 +1,26 @@
 /*
  * Async PF test. For the test to actually do anything it needs to be started
- * in memory cgroup with 512M of memory and with more then 1G memory provided
+ * in memory cgroup with 512M of memory and with more than 1G memory provided
  * to the guest.
  *
+ * To identify the cgroup version on Linux:
+ * stat -fc %T /sys/fs/cgroup/
+ *
+ * If the output is tmpfs, your system is using cgroup v1:
  * To create cgroup do as root:
  * mkdir /dev/cgroup
  * mount -t cgroup none -omemory /dev/cgroup
  * chmod a+rxw /dev/cgroup/
- *
  * From a shell you will start qemu from:
  * mkdir /dev/cgroup/1
  * echo $$ >  /dev/cgroup/1/tasks
  * echo 512M > /dev/cgroup/1/memory.limit_in_bytes
  *
+ * If the output is cgroup2fs, your system is using cgroup v2:
+ * mkdir /sys/fs/cgroup/cg1
+ * echo $$ >  /sys/fs/cgroup/cg1/cgroup.procs
+ * echo 512M > /sys/fs/cgroup/cg1/memory.max
+ *
  */
 #include "x86/msr.h"
 #include "x86/processor.h"
@@ -79,6 +87,16 @@ static void pf_isr(struct ex_regs *r)
 
 int main(int ac, char **av)
 {
+	if (!this_cpu_has(KVM_FEATURE_ASYNC_PF)) {
+		report_skip("KVM_FEATURE_ASYNC_PF is not supported\n");
+		return report_summary();
+	}
+
+	if (this_cpu_has(KVM_FEATURE_ASYNC_PF_INT)) {
+		report_skip("interrupt-based page-ready event is enumerated, use asyncpf-int instead.\n");
+		return report_summary();
+	}
+
 	int loop = 2;
 
 	setup_vm();
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 8735ba34..94a5c7c7 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -172,7 +172,7 @@ extra_params = -cpu max
 
 [asyncpf]
 file = asyncpf.flat
-extra_params = -m 2048
+extra_params = -cpu host -m 2048
 
 [asyncpf_int]
 file = asyncpf_int.flat
-- 
2.39.3


