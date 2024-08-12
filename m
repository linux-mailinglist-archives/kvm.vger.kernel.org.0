Return-Path: <kvm+bounces-23911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8D694F9F4
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:53:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7189B22DAB
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E26D1A01D3;
	Mon, 12 Aug 2024 22:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E4i7RFAc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D142C19FA6B;
	Mon, 12 Aug 2024 22:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502925; cv=none; b=SB5udNhU0MxEfRF3ynHwhLVZVy2b7BRfeZ2VXiBJ5BlJig1E79IgdpGU2HT1TNKbwz3WJFWRx2WBYw7nPF+s3GtQl8DytYrWqA0NfxC85OGoP1ZkllYQiTwZsVFlZI5FYmT5ff0aKQyJWptgMzPxNqrnHxQ4w1jGPQBIKLbVmwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502925; c=relaxed/simple;
	bh=IeFL19qbpFuEDdYy6LJ6GkBeYN7B0Q4mmhVbQUcOmjk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Df3ZEoOx4J46GMww4n935G+ue8pQ6IjUNoVUDcOEx0QIb9Ui08/vAwNQyxpcrWv9dFCu6BxV0hynMk9ULLiEpcl1pAegdjsi9kfiUZHmgyEkgtwyg3REjn66qd86MDbHlOhQRzfhTLKGD0JufYgXgYfphUOps0omRBC4hS1VFF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E4i7RFAc; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502924; x=1755038924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IeFL19qbpFuEDdYy6LJ6GkBeYN7B0Q4mmhVbQUcOmjk=;
  b=E4i7RFAcmphhin37y5Uerzorh7wTEKNG9fSIC6KpasfjAtMFEdW0mKOs
   F7cxq4IpZ2lRr5myQHUjHetSLhlU/2U7Vbh2Ii9nzVS3GFyty+76tjLI9
   jxCY0YxlTx0C/XTr6naJj8fB+z0m02oqqNoVBmBMha2JHyZVGsYq67xLI
   PChPJlP/k+GGsgHlCGtNRy/zINu9kHyuGZGjgDDtE0izSxi8llAiygRNQ
   NnqygFN00uaaXKfGXadqfT6GFdnKsXgkqs69txThYgBgF5gdxtNY9FtBH
   Z/szaiQ022RUhdd9ihCfAjiX4pnNzLQ4USluX5atX/SzMp9bcavzI0m1B
   g==;
X-CSE-ConnectionGUID: ydsfM056QBy6+do1Ialsqg==
X-CSE-MsgGUID: Eg7Hb8+/T8+xZ8rYvtaKIQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041433"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041433"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:36 -0700
X-CSE-ConnectionGUID: MkgkZBn6SzK+nwHB2NRhLw==
X-CSE-MsgGUID: WPHKxZjvQVilvgUaiv2QUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008426"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:35 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH 16/25] KVM: TDX: Don't offline the last cpu of one package when there's TDX guest
Date: Mon, 12 Aug 2024 15:48:11 -0700
Message-Id: <20240812224820.34826-17-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Destroying TDX guest requires there's at least one cpu online for each
package, because reclaiming the TDX KeyID of the guest (as part of the
teardown process) requires to call some SEAMCALL (on any cpu) on all
packages.

Do not offline the last cpu of one package when there's any TDX guest
running, otherwise KVM may not be able to teardown TDX guest resulting
in leaking of TDX KeyID and other resources like TDX guest control
structure pages.

Add a tdx_arch_offline_cpu() and call it in kvm_offline_cpu() to provide
a placeholder for TDX specific check.  The default __weak version simply
returns 0 (allow to offline) so other ARCHs are not impacted.  Implement
the x86 version, which calls a new 'kvm_x86_ops::offline_cpu()' callback.
Implement the TDX version 'offline_cpu()' to prevent the cpu from going
offline if it is the last cpu on the package.

Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
uAPI breakout v1:
 - Remove nr_configured_keyid, use ida_is_empty() instead (Chao)
 - Change to use a simpler way to check whether the to-go-offline cpu is
   the last online cpu on the package. (Chao)
 - Improve the changelog (Kai)
 - Improve the patch title to call out "when there's TDX guest".  (Kai)
 - Significantly reduce the code by using TDX's own CPUHP callback,
   instead of hooking into KVM's.
 - Update changelog to reflect the change.

v18:
 - Added reviewed-by BinBin
---
 arch/x86/kvm/vmx/tdx.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a6c711715a4a..531e87983b90 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -921,6 +921,42 @@ static int tdx_online_cpu(unsigned int cpu)
 	return r;
 }
 
+static int tdx_offline_cpu(unsigned int cpu)
+{
+	int i;
+
+	/* No TD is running.  Allow any cpu to be offline. */
+	if (ida_is_empty(&tdx_guest_keyid_pool))
+		return 0;
+
+	/*
+	 * In order to reclaim TDX HKID, (i.e. when deleting guest TD), need to
+	 * call TDH.PHYMEM.PAGE.WBINVD on all packages to program all memory
+	 * controller with pconfig.  If we have active TDX HKID, refuse to
+	 * offline the last online cpu.
+	 */
+	for_each_online_cpu(i) {
+		/*
+		 * Found another online cpu on the same package.
+		 * Allow to offline.
+		 */
+		if (i != cpu && topology_physical_package_id(i) ==
+				topology_physical_package_id(cpu))
+			return 0;
+	}
+
+	/*
+	 * This is the last cpu of this package.  Don't offline it.
+	 *
+	 * Because it's hard for human operator to understand the
+	 * reason, warn it.
+	 */
+#define MSG_ALLPKG_ONLINE \
+	"TDX requires all packages to have an online CPU. Delete all TDs in order to offline all CPUs of a package.\n"
+	pr_warn_ratelimited(MSG_ALLPKG_ONLINE);
+	return -EBUSY;
+}
+
 static void __do_tdx_cleanup(void)
 {
 	/*
@@ -946,7 +982,7 @@ static int __init __do_tdx_bringup(void)
 	 */
 	r = cpuhp_setup_state_cpuslocked(CPUHP_AP_ONLINE_DYN,
 					 "kvm/cpu/tdx:online",
-					 tdx_online_cpu, NULL);
+					 tdx_online_cpu, tdx_offline_cpu);
 	if (r < 0)
 		return r;
 
-- 
2.34.1


