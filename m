Return-Path: <kvm+bounces-29851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4E79B318C
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 14:21:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52F5D1F22601
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53AE11DD525;
	Mon, 28 Oct 2024 13:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jDdBLuVE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE6C1DC06B;
	Mon, 28 Oct 2024 13:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730121633; cv=none; b=ALFe+g08U6DE3yTZxBOCApro4DLDJ769zmYpaaWGEOjWPVlFUr74rw2dqZMI5J5ssE40oMAWUzIFN5ghFtW+EDkmNKJRFQJexch3S/OV7+6nfcSdGc4TvtRAb9U8VUk9bdJo81o80FbxbgFWeCsJzRhcUbNaZif6N/Ii8YR2zO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730121633; c=relaxed/simple;
	bh=fAAeiIXSaCtiwEUxKsyPTFXz0tDGtTakDZBaBMRw4mI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uW7ucgMwzQBt9uFb4mlbmRSUM2X2DEwTSuTEITUEs0q2wmhXKBgQjvzRzsF/EocgeddlpcOq466VJNJOEDSwLRRQ9LOtB2cDbdKhbyedaRmtEsYq5DKzkJBrlIqxP51Argu61GelkMb3V+e57A2mriy6YmrO5x8Vcv13h+6xZ4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jDdBLuVE; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730121631; x=1761657631;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fAAeiIXSaCtiwEUxKsyPTFXz0tDGtTakDZBaBMRw4mI=;
  b=jDdBLuVEyo7wVkZ+IRj0DGsYD+FTK5BIZJzpb3M7lWjeZ4OY9HtFqm8O
   r0KvqT+Vn1jat2TPI0F7wfdJCdlFC732vviurBbByGv58QJnfv90MRt8P
   R8tybusWqLRgrxTwFncyiuGJIWQvr7whzwfZHiy9JXQBH3CzLE4SwlbZ5
   3zLK4E8djIY1wLwknq6oWAUbIP1rHE/sJswhcz7Y2p8oilslxS7U0KSN/
   lamjS1aDnoC5vJHPwGRNTHh8soij9fCx9U/DdDDgazVlyTARccL6QECgR
   CHjjXG2gSXTwpK2zUriMNx0wx/rw2bcL6fGvjpF8cv6qgYVWuF2seVP7Z
   w==;
X-CSE-ConnectionGUID: 4LuEB4YST7qBVzKdfsWO0g==
X-CSE-MsgGUID: qkKJQPQCQZWEChpP+88mQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="29820967"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="29820967"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 06:20:31 -0700
X-CSE-ConnectionGUID: WA+vo9OHS0G502fm1b0hxg==
X-CSE-MsgGUID: pMSxz1dwTKmYHbBGtLQX3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="86397223"
Received: from gargmani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.169])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 06:20:28 -0700
From: Kai Huang <kai.huang@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com
Cc: isaku.yamahata@intel.com,
	reinette.chatre@intel.com,
	binbin.wu@linux.intel.com,
	xiaoyao.li@intel.com,
	yan.y.zhao@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	kristen@linux.intel.com,
	linux-kernel@vger.kernel.org,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 1/3] KVM: VMX: Refactor VMX module init/exit functions
Date: Tue, 29 Oct 2024 02:20:14 +1300
Message-ID: <6e15578c9c2fd14b9a8fd02fda4df3843267dd13.1730120881.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730120881.git.kai.huang@intel.com>
References: <cover.1730120881.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add vt_init() and vt_exit() as the new module init/exit functions and
refactor existing vmx_init()/vmx_exit() as helper to make room for TDX
specific initialization and teardown.

To support TDX, KVM will need to enabling TDX during KVM module loading
time.  Enabling TDX requires enabling hardware virtualization first so
that all online CPUs (and the new CPU going online) are in post-VMXON
state.

Currently, the vmx_init() flow is:

 1) hv_init_evmcs(),
 2) kvm_x86_vendor_init(),
 3) Other VMX specific initialization,
 4) kvm_init()

The kvm_x86_vendor_init() invokes kvm_x86_init_ops::hardware_setup() to
do VMX specific hardware setup and calls kvm_update_ops() to initialize
kvm_x86_ops to VMX's version.

TDX will have its own version for most of kvm_x86_ops callbacks.  It
would be nice if kvm_x86_init_ops::hardware_setup() could also be used
for TDX, but in practice it cannot.  The reason is, as mentioned above,
TDX initialization requires hardware virtualization having been enabled,
which must happen after kvm_update_ops(), but hardware_setup() is done
before that.

Also, TDX is based on VMX, and it makes sense to only initialize TDX
after VMX has been initialized.  If VMX fails to initialize, TDX is
likely broken anyway.

So the new flow of KVM module init function will be:

 1) Current VMX initialization code in vmx_init() before kvm_init(),
 2) TDX initialization,
 3) kvm_init()

Split vmx_init() into two parts based above 1) and 3) so that TDX
initialization can fit in between.  Make part 1) as the new helper
vmx_init().  Introduce vt_init() as the new module init function which
calls vmx_init() and kvm_init().  TDX initialization will be added
later.

Do the same thing for vmx_exit()/vt_exit().

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/vmx/main.c | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c  | 23 ++---------------------
 arch/x86/kvm/vmx/vmx.h  |  3 +++
 3 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7668e2fb8043..433ecbd90905 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -166,3 +166,35 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 	.runtime_ops = &vt_x86_ops,
 	.pmu_ops = &intel_pmu_ops,
 };
+
+static void vt_exit(void)
+{
+	kvm_exit();
+	vmx_exit();
+}
+module_exit(vt_exit);
+
+static int __init vt_init(void)
+{
+	int r;
+
+	r = vmx_init();
+	if (r)
+		return r;
+
+	/*
+	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
+	 * exposed to userspace!
+	 */
+	r = kvm_init(sizeof(struct vcpu_vmx), __alignof__(struct vcpu_vmx),
+		     THIS_MODULE);
+	if (r)
+		goto err_kvm_init;
+
+	return 0;
+
+err_kvm_init:
+	vmx_exit();
+	return r;
+}
+module_init(vt_init);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f6900bec4874..976fe6579f62 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8587,23 +8587,16 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void __vmx_exit(void)
+void vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
 	vmx_cleanup_l1d_flush();
-}
 
-static void vmx_exit(void)
-{
-	kvm_exit();
-	__vmx_exit();
 	kvm_x86_vendor_exit();
-
 }
-module_exit(vmx_exit);
 
-static int __init vmx_init(void)
+int __init vmx_init(void)
 {
 	int r, cpu;
 
@@ -8647,21 +8640,9 @@ static int __init vmx_init(void)
 	if (!enable_ept)
 		allow_smaller_maxphyaddr = true;
 
-	/*
-	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
-	 * exposed to userspace!
-	 */
-	r = kvm_init(sizeof(struct vcpu_vmx), __alignof__(struct vcpu_vmx),
-		     THIS_MODULE);
-	if (r)
-		goto err_kvm_init;
-
 	return 0;
 
-err_kvm_init:
-	__vmx_exit();
 err_l1d_flush:
 	kvm_x86_vendor_exit();
 	return r;
 }
-module_init(vmx_init);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 40303b43da6c..ad9efe41e691 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -755,4 +755,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 	vmx->segment_cache.bitmask = 0;
 }
 
+int vmx_init(void);
+void vmx_exit(void);
+
 #endif /* __KVM_X86_VMX_H */
-- 
2.46.2


