Return-Path: <kvm+bounces-6580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F3978379A6
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:44:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1421CB29A01
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A727C50A8B;
	Mon, 22 Jan 2024 23:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WpMiXcCJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D95C4F889;
	Mon, 22 Jan 2024 23:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967698; cv=none; b=sc7znzbiRsRCVe0O1VtMgBzWRqaBoZnt/4eNSVRTVlBLmxdU43N4qGmmnYh2ZRCNCITpVnkX7k64h0f2M5JmvbTLX4rWneCBAkNVT8QW4e1A+IfthDDfZRNgKH3X4ea6BTC74evsZy1tz5lHtZdOq500wuW1bkssYZtW9uRJOGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967698; c=relaxed/simple;
	bh=S2Wa8bd7Tpz6POIIKRT24KexX0AuVDEX8O8T80IsTQo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VyFWgaRa86SDDqEJdk9jS27mQSCJp+O7qbiJGzP2Nqsui4kzrHq051i+Fg3AyQlu0C+404BwTr8S3lkNXEGInXl9/x5c7Yk/DRM5lI8KWvRB5vql1u5w3wfByZcePuUkDliDMR0WKTX5vtytXgGKyoVcqWrvBLhvUnxVHSDWqaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WpMiXcCJ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967697; x=1737503697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S2Wa8bd7Tpz6POIIKRT24KexX0AuVDEX8O8T80IsTQo=;
  b=WpMiXcCJ3gr5C6CwYFm9/PnlH78aHLHazrphu0zOpMtzAm/Tpfk7ga+v
   AaPQj8hmgW+zQqHwfZhE2AkUKQtJxL1E3expvsLve6Hn9OUqM/o7QLjhL
   aIpq62HmcTIod+PpJrSRjh+hFlx4V5fLm12WxH0IoNOTBs8m6czvGWf84
   citOC21108Ut86Zbnl+2wUlTb9mYi+H5+kXkUqtdXh2HhFRtqot13TX2h
   07t3QiNZWHIvl2jST//qjKOh8d2ek2NZ5WYXBZ+yJBHA7IouUyReZ/ldV
   V+ROPbQ1JYYxSmNjyXV9ibTFe7Omrx8P+0kB44iMp8DgzBwV8Rxip58TP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1217826"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1217826"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1350130"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:55 -0800
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
	tina.zhang@intel.com
Subject: [PATCH v18 007/121] KVM: VMX: Reorder vmx initialization with kvm vendor initialization
Date: Mon, 22 Jan 2024 15:52:43 -0800
Message-Id: <411a0b38c1a6f420a88b51cabf16ee871d6ca80d.1705965634.git.isaku.yamahata@intel.com>
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

To match vmx_exit cleanup.  Now vmx_init() is before kvm_x86_vendor_init(),
vmx_init() can initialize loaded_vmcss_on_cpu.  Oppertunistically move it
back into vmx_init().

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v18:
- move the loaded_vmcss_on_cpu initialization to vmx_init().
- fix error path of vt_init(). by Chao and Binbin
---
 arch/x86/kvm/vmx/main.c    | 17 +++++++----------
 arch/x86/kvm/vmx/vmx.c     |  6 ++++--
 arch/x86/kvm/vmx/x86_ops.h |  2 --
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 18cecf12c7c8..443db8ec5cd5 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -171,7 +171,7 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 static int __init vt_init(void)
 {
 	unsigned int vcpu_size, vcpu_align;
-	int cpu, r;
+	int r;
 
 	if (!kvm_is_vmx_supported())
 		return -EOPNOTSUPP;
@@ -182,18 +182,14 @@ static int __init vt_init(void)
 	 */
 	hv_init_evmcs();
 
-	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
-	for_each_possible_cpu(cpu)
-		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
-
-	r = kvm_x86_vendor_init(&vt_init_ops);
-	if (r)
-		return r;
-
 	r = vmx_init();
 	if (r)
 		goto err_vmx_init;
 
+	r = kvm_x86_vendor_init(&vt_init_ops);
+	if (r)
+		goto err_vendor_init;
+
 	/*
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
@@ -207,9 +203,10 @@ static int __init vt_init(void)
 	return 0;
 
 err_kvm_init:
+	kvm_x86_vendor_exit();
+err_vendor_init:
 	vmx_exit();
 err_vmx_init:
-	kvm_x86_vendor_exit();
 	return r;
 }
 module_init(vt_init);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8efb956591d5..3f4dad3acb13 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -477,7 +477,7 @@ DEFINE_PER_CPU(struct vmcs *, current_vmcs);
  * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
  * when a CPU is brought down, and we need to VMCLEAR all VMCSs loaded on it.
  */
-DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
+static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
 
 static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
 static DEFINE_SPINLOCK(vmx_vpid_lock);
@@ -8528,8 +8528,10 @@ int __init vmx_init(void)
 	if (r)
 		return r;
 
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
+		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
 		pi_init_cpu(cpu);
+	}
 
 	cpu_emergency_register_virt_callback(vmx_emergency_disable);
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b936388853ab..bca2d27b3dfd 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -14,8 +14,6 @@ static inline __init void hv_init_evmcs(void) {}
 static inline void hv_reset_evmcs(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
-DECLARE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
-
 bool kvm_is_vmx_supported(void);
 int __init vmx_init(void);
 void vmx_exit(void);
-- 
2.25.1


