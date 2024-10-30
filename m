Return-Path: <kvm+bounces-30098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B3F7E9B6CB3
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:09:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C2A7B20DA1
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 948FC2281EF;
	Wed, 30 Oct 2024 19:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZUOxsa5W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8BA227366;
	Wed, 30 Oct 2024 19:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314878; cv=none; b=cgtbHhpxQzV0j+DagLDi7dBbXZgO3zTt0rfy4k/Q5b81bfH+fkXLC5RtQEbn+yPKV2jhiedPAKbEUe9xcUsZAFgbr7ICSPfPzFhDyJ3157aZ5hOLNRjxsmry7EmWMbV/5ZZRTt1CjaHzlS0HN2BHbdpE75yl+1IQVtnAsQmvhOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314878; c=relaxed/simple;
	bh=jqkj4Hb7DRvcZMExIzjynTbXnLXSSlyhjX7U93N28yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOmQop/vURyCRz9m33e0/NoXqexUwu13p+zQQAabal2sSitiK2ApIYufQ5g6cus1+97ov2mtp5UtXnpURUk+2QKngnOByvS5hXt804/mdPLh1/1DST7TGeEvDX/pDJi3xtB8bzOuIQCO2pB5sEeNrPyRqgkozF4UzktyYi9kpyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZUOxsa5W; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314876; x=1761850876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jqkj4Hb7DRvcZMExIzjynTbXnLXSSlyhjX7U93N28yw=;
  b=ZUOxsa5WDgWGJxjzmgnuZfVA2bOoQnArsEWJPyXQw6j7w7rnySSF/hgp
   AoqpiT54+AS7I8cONG3B53FsP1hIRjXPEOseUTfoM2c48GqdDybFdAmVf
   QfZYQEW+rFY87yTbWYcOaxWGIGxTBuhvn3gxlDI6lWNTHEX01fHUOzd7n
   3bduxb9Csse0RbFu2s++N4C5jC85Bb+KvJ2rfM3NF2HxxjSeldcGNrVqH
   LXg0mQsEt+m8Ss+CfjCbLNh7KRg8t2P66UDfiGrKj4IHDdn9teN/TAb6I
   ZLoXxHbCEPmPLrfpv3xjFBj9aqEyU8mdwtSALuOyGclFaUrJCb1fNRz6Q
   g==;
X-CSE-ConnectionGUID: S9Efz8FZTzeEEpy1GkGnGg==
X-CSE-MsgGUID: L/U978McQRenQq2h2GgD5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678836"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678836"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:07 -0700
X-CSE-ConnectionGUID: Ww617W06Ty+o0ciM4QW+Dg==
X-CSE-MsgGUID: 2CCMq2zgS3eRXqqEoDd9Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499448"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:06 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v2 21/25] KVM: TDX: Don't offline the last cpu of one package when there's TDX guest
Date: Wed, 30 Oct 2024 12:00:34 -0700
Message-ID: <20241030190039.77971-22-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
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

Implement the TDX version 'offline_cpu()' to prevent the cpu from going
offline if it is the last cpu on the package.

Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
uAPI breakout v2:
 - Update description to leave out stale part (Binbin)
 - Add some local hkid tracking on KVM side, now that the allocator is
   in arch/x86 code (Kai)

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
 arch/x86/kvm/vmx/tdx.c | 43 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ac224d79ba1e..17df857ae4c1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -122,6 +122,8 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
  */
 static DEFINE_MUTEX(tdx_lock);
 
+static atomic_t nr_configured_hkid;
+
 /* Maximum number of retries to attempt for SEAMCALLs. */
 #define TDX_SEAMCALL_RETRIES	10000
 
@@ -134,6 +136,7 @@ static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
 {
 	tdx_guest_keyid_free(kvm_tdx->hkid);
 	kvm_tdx->hkid = -1;
+	atomic_dec(&nr_configured_hkid);
 }
 
 static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
@@ -612,6 +615,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 		return ret;
 	kvm_tdx->hkid = ret;
 
+	atomic_inc(&nr_configured_hkid);
+
 	va = __get_free_page(GFP_KERNEL_ACCOUNT);
 	if (!va)
 		goto free_hkid;
@@ -913,6 +918,42 @@ static int tdx_online_cpu(unsigned int cpu)
 	return r;
 }
 
+static int tdx_offline_cpu(unsigned int cpu)
+{
+	int i;
+
+	/* No TD is running.  Allow any cpu to be offline. */
+	if (!atomic_read(&nr_configured_hkid))
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
@@ -938,7 +979,7 @@ static int __init __do_tdx_bringup(void)
 	 */
 	r = cpuhp_setup_state_cpuslocked(CPUHP_AP_ONLINE_DYN,
 					 "kvm/cpu/tdx:online",
-					 tdx_online_cpu, NULL);
+					 tdx_online_cpu, tdx_offline_cpu);
 	if (r < 0)
 		return r;
 
-- 
2.47.0


