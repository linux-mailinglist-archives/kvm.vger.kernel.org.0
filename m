Return-Path: <kvm+bounces-29852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 640129B318E
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 14:21:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28F462828F9
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F05B01DD860;
	Mon, 28 Oct 2024 13:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fNcN5dlF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF941DD0FE;
	Mon, 28 Oct 2024 13:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730121636; cv=none; b=FhYcfwa5NvjgWajs0ZxmEUQU4jN5LUFtxMSj22w5orO41soOLinjcOF5XjOyw5uZCyOSXIyjPDJqMaS+0l6XdiBYBsntPWfPucOTVVSFJb+Ts+tisnhStPVmxu6//g32gqE+2wgAddRDCD0VbEONvw/g3OArH7HTCIiv+pSuqNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730121636; c=relaxed/simple;
	bh=13344vxsdqZxXQjsXwnFs3FcFrd0V5S/i7X+xJ4Un9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPluzXrwU9B+0Xlz8fRQrJWq96q8IOYGlYrWc2IAVBukI9FSykgynYgwpELOOQVeXJyOuBOp1zH3rIC1i4VAhgFu2+VPUsPgtcnxaIr2bbttZzKN46VxO7NVTkS0ZQGxvC2lDM5tQLLQxuvRtDTSKQ1yOOOC1X3RkByYIKbn0kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fNcN5dlF; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730121634; x=1761657634;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=13344vxsdqZxXQjsXwnFs3FcFrd0V5S/i7X+xJ4Un9E=;
  b=fNcN5dlF6dL59UF0KeqEt4wyO2QHWA9pFXpYTBJwEjUZid7UShVkyrcq
   JrNfkUfSbIGryTdNN7A9Y0CArnLFXixIm1XA8/bcDTj5y+sbScOoKg60h
   Ywsl35LYmuqbhiXRtvIbhBu0okoKyKEInhsRqm3PRxMM7UVkbhk7Kx/xk
   hEkYsrOulaS7u6RJjPPVjebftBj1dbIitId4Ycgf+PJ8LILpmwSxV3PyL
   /y3ngXcp0U26TkrqPd9hm/8y9BWNrXi8aD67YHErwnj9xJxmReH6S9RHu
   0CgVpcoMbmvzdX4J4Wx8OhGzWCXXXiiCsjWOSgW/nb8VCbtZLQxfCSafy
   w==;
X-CSE-ConnectionGUID: zClUHYLkTFyunJlwPvrd0g==
X-CSE-MsgGUID: 6WkClmRpSkSt4Vuc35M5bA==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="29820973"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="29820973"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 06:20:34 -0700
X-CSE-ConnectionGUID: iO0Inx3ARvyetf5lNBxWnw==
X-CSE-MsgGUID: TmTGDDFTQJ2FBkDFrusY4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="86397239"
Received: from gargmani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.169])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 06:20:32 -0700
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
Subject: [PATCH 2/3] KVM: Export hardware virtualization enabling/disabling functions
Date: Tue, 29 Oct 2024 02:20:15 +1300
Message-ID: <4388864f91eb661a698bedf8bd910d18fda0daa6.1730120881.git.kai.huang@intel.com>
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

To support TDX, KVM will need to enabling TDX during KVM module loading
time.  Enabling TDX requires enabling hardware virtualization first so
that all online CPUs (and the new CPU going online) are in post-VMXON
state.

KVM by default enables hardware virtualization but that is done in
kvm_init(), which must be the last step after all initialization is done
thus is too late for enabling TDX.

Export functions to enabling/disable hardware virtualization so that TDX
code can use them to handle hardware virtualization enabling before
kvm_init().

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 include/linux/kvm_host.h |  8 ++++++++
 virt/kvm/kvm_main.c      | 18 ++++--------------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 02f0206fd2dc..024c91eef7db 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2557,4 +2557,12 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
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
index b1b10dc408a0..a0117390ea7f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -143,8 +143,6 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
 			.open		= kvm_no_compat_open
 #endif
-static int kvm_enable_virtualization(void);
-static void kvm_disable_virtualization(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -5523,7 +5521,7 @@ static struct syscore_ops kvm_syscore_ops = {
 	.shutdown = kvm_shutdown,
 };
 
-static int kvm_enable_virtualization(void)
+int kvm_enable_virtualization(void)
 {
 	int r;
 
@@ -5568,8 +5566,9 @@ static int kvm_enable_virtualization(void)
 	--kvm_usage_count;
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_enable_virtualization);
 
-static void kvm_disable_virtualization(void)
+void kvm_disable_virtualization(void)
 {
 	guard(mutex)(&kvm_usage_lock);
 
@@ -5580,6 +5579,7 @@ static void kvm_disable_virtualization(void)
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 	kvm_arch_disable_virtualization();
 }
+EXPORT_SYMBOL_GPL(kvm_disable_virtualization);
 
 static int kvm_init_virtualization(void)
 {
@@ -5595,21 +5595,11 @@ static void kvm_uninit_virtualization(void)
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


