Return-Path: <kvm+bounces-31924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 71D959CDBE4
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 10:53:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12B81B25A10
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 09:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF1701AA786;
	Fri, 15 Nov 2024 09:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qesv9QrJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0141C199921;
	Fri, 15 Nov 2024 09:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731664380; cv=none; b=oneVclyd7UD2g6wLECAEdpZPPcgc+e8CXc8+aiW10S8NKvPjwY2odM/kLBztnptz3PZuvV8HUZeWe+bAioo6nGSy4b0lUqYkDpYn8Hb79G476r1hmKtStUn/wGjbhFFI5woOoGTRGQ6A7T+CdlYP1aMVDCKeEKsWJEz7UZr1XH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731664380; c=relaxed/simple;
	bh=JuKSfw+R0jUAZ+TWdRzjTinnZdSmStvT5RhNMySiuNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MacfgzKrYJ6Ngrxln4RgUFcDA8iDFTGrsjY5+6VQiRYQ1YezsK0mv/dWlYjJFQCRVdmqxGamgw6SYIpbCpTtNODK6NT3KTdQ3x3EQBXjJtWBD8a0/2YIYSGpYMfhqNsr7HmGgZCt4FAjeoPFR34/lY2UQLyUsOEnFM57nKC+R+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qesv9QrJ; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731664379; x=1763200379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JuKSfw+R0jUAZ+TWdRzjTinnZdSmStvT5RhNMySiuNA=;
  b=Qesv9QrJErhzPOMEFn9fB8x4YV78jfCJkMHQuNZd8ENAkQ4lLGwy715Q
   yln6h6UDXrTN8EG+DZ8HT28rATORY+kUKRENGO4bssCi7Y4fjwyMNnenU
   WAfzaUdv7N+qHIfFI6gDTeAVJv2UmwrJMHMv6HjMZeQdz33ezG6sfJiUA
   D/XuaZsWRGtCah38mkL7LXwmAQWE9stAaaWj109vdxYodfdt7ktE4F0PD
   32012zeVF90N//SNA1qBrYGGy9KO7DgQnst/c/TNs+JvQJKSEA/czz3Rs
   vv0reAFcJ/PvSdtTF8vOmpTrkSR18SI6xEzmDxAfe+fKYYHzH0OiR2Kr/
   A==;
X-CSE-ConnectionGUID: aLH8lz7LQCyaxJ4Pzedvcg==
X-CSE-MsgGUID: EUru0IRWTWuYenyGocLtiw==
X-IronPort-AV: E=McAfee;i="6700,10204,11256"; a="31584842"
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="31584842"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 01:52:59 -0800
X-CSE-ConnectionGUID: agMgbAkRTIqhvXfdgoRy2g==
X-CSE-MsgGUID: DX9iS7iOTEKTzkhkvZ8PHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="93584337"
Received: from kinlongk-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.135])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 01:52:56 -0800
From: Kai Huang <kai.huang@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	reinette.chatre@intel.com,
	binbin.wu@linux.intel.com,
	xiaoyao.li@intel.com,
	yan.y.zhao@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	kristen@linux.intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] KVM: Export hardware virtualization enabling/disabling functions
Date: Fri, 15 Nov 2024 22:52:40 +1300
Message-ID: <dfe17314c0d9978b7bc3b0833dff6f167fbd28f5.1731664295.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1731664295.git.kai.huang@intel.com>
References: <cover.1731664295.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To support TDX, KVM will need to enable TDX during KVM module loading
time.  Enabling TDX requires enabling hardware virtualization first so
that all online CPUs (and the new CPU going online) are in post-VMXON
state.

KVM by default enables hardware virtualization but that is done in
kvm_init(), which must be the last step after all initialization is done
thus is too late for enabling TDX.

Export functions to enable/disable hardware virtualization so that TDX
code can use them to handle hardware virtualization enabling before
kvm_init().

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 include/linux/kvm_host.h |  8 ++++++++
 virt/kvm/kvm_main.c      | 18 ++++--------------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 401439bb21e3..6bb564c976e8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2553,4 +2553,12 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
 #endif
 
+#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+int kvm_enable_virtualization(void);
+void kvm_disable_virtualization(void);
+#else
+static inline int kvm_enable_virtualization(void) { return 0; }
+static inline void kvm_disable_virtualization(void) { }
+#endif
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 22c145a99efe..e625e43c15c9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -143,8 +143,6 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
 			.open		= kvm_no_compat_open
 #endif
-static int kvm_enable_virtualization(void);
-static void kvm_disable_virtualization(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -5538,7 +5536,7 @@ static struct syscore_ops kvm_syscore_ops = {
 	.shutdown = kvm_shutdown,
 };
 
-static int kvm_enable_virtualization(void)
+int kvm_enable_virtualization(void)
 {
 	int r;
 
@@ -5583,8 +5581,9 @@ static int kvm_enable_virtualization(void)
 	--kvm_usage_count;
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_enable_virtualization);
 
-static void kvm_disable_virtualization(void)
+void kvm_disable_virtualization(void)
 {
 	guard(mutex)(&kvm_usage_lock);
 
@@ -5595,6 +5594,7 @@ static void kvm_disable_virtualization(void)
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 	kvm_arch_disable_virtualization();
 }
+EXPORT_SYMBOL_GPL(kvm_disable_virtualization);
 
 static int kvm_init_virtualization(void)
 {
@@ -5610,21 +5610,11 @@ static void kvm_uninit_virtualization(void)
 		kvm_disable_virtualization();
 }
 #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
-static int kvm_enable_virtualization(void)
-{
-	return 0;
-}
-
 static int kvm_init_virtualization(void)
 {
 	return 0;
 }
 
-static void kvm_disable_virtualization(void)
-{
-
-}
-
 static void kvm_uninit_virtualization(void)
 {
 
-- 
2.46.2


