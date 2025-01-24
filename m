Return-Path: <kvm+bounces-36491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D07F7A1B6E7
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:37:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D87E0188C7CF
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 132DC4207F;
	Fri, 24 Jan 2025 13:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CnooZ1Di"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA61370820
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725845; cv=none; b=UigSsx4TYVe10JxKqTKNepRDxkvDrtMZac4GBf8ypfu+Um6snGn1BpzxIUwAlA3m3Gfw9qXSeQsUW1M/gtdJhQNHLhdxMeeLoZ/XqTM2PwHWDaXZz6hkikSK6D5Q9O7D09LIEnEeboAUVha32K2KZR/4itBztkU/JzFa1+MZY8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725845; c=relaxed/simple;
	bh=kOLxy+1q1FMsBAjiiHfhF45L2YtjT1s5c0pCcuUrZl8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k4LL2YEwvPPWs4vsuYI2jBtGaC6HsrUUa6hILAPD+gg0ldEYqjMSfs9muaIHi1wN5wEvqGoLcAFqaW3OxfDQbh7PVF1dupqV3jPsQ7Ux8rmEDaThgzTgdbB9PTWYcceVrvP1mv7sOHbHl5stdjujOZJd0kxBNpB3eBk623X+6Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CnooZ1Di; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725844; x=1769261844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kOLxy+1q1FMsBAjiiHfhF45L2YtjT1s5c0pCcuUrZl8=;
  b=CnooZ1DibK+gZL9qX03i1Oz+hBgvJkqusVIb+IihqUgy4h0j8Lzd7LDl
   cfe+tj8CEaLpRaRG/4q6UMFqnwJBb42rl9b5fKeFYs2ggVQdEA6HMEh4w
   7qIA9VIeGCvXpLtAHwkVzyt7heg0ODs/YmPOUfZMswVVnxJNvrJBiFgXN
   Ztv4yFWwof7Vu/0IcMaltQqj/ppsYaEsTbyYlNSUc3Fg2psyB0rR8A0ze
   dlXrzHnPCj6B/aGohjyqntUkt8YBlT3ZkgYfD5hMngnXi3BKvbPck70Kt
   C3ZpDixU2dL8KryVzRP/Lo6BwArzJnFdtC1v90/bz3NvTjD6cZ1WmRbOz
   w==;
X-CSE-ConnectionGUID: kMgTdTi0QC66M+9P1Pfb7A==
X-CSE-MsgGUID: MtJWugQaQEamwxNWdemKeA==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246215"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246215"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:37:24 -0800
X-CSE-ConnectionGUID: D8KtQIbUT/Gawb5IdLWJKQ==
X-CSE-MsgGUID: Ac6D1dICQUeA26wOEa8tZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804160"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:37:20 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 06/52] i386/tdx: Introduce is_tdx_vm() helper and cache tdx_guest object
Date: Fri, 24 Jan 2025 08:20:02 -0500
Message-Id: <20250124132048.3229049-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It will need special handling for TDX VMs all around the QEMU.
Introduce is_tdx_vm() helper to query if it's a TDX VM.

Cache tdx_guest object thus no need to cast from ms->cgs every time.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
changes in v3:
- replace object_dynamic_cast with TDX_GUEST();
---
 target/i386/kvm/tdx.c | 15 ++++++++++++++-
 target/i386/kvm/tdx.h | 10 ++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index bd212abab865..53eec6553333 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -18,8 +18,16 @@
 #include "kvm_i386.h"
 #include "tdx.h"
 
+static TdxGuest *tdx_guest;
+
 static struct kvm_tdx_capabilities *tdx_caps;
 
+/* Valid after kvm_arch_init()->confidential_guest_kvm_init()->tdx_kvm_init() */
+bool is_tdx_vm(void)
+{
+    return !!tdx_guest;
+}
+
 enum tdx_ioctl_level {
     TDX_VM_IOCTL,
     TDX_VCPU_IOCTL,
@@ -117,15 +125,20 @@ static int get_tdx_capabilities(Error **errp)
 
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
+    TdxGuest *tdx = TDX_GUEST(cgs);
     int r = 0;
 
     kvm_mark_guest_state_protected();
 
     if (!tdx_caps) {
         r = get_tdx_capabilities(errp);
+        if (r) {
+            return r;
+        }
     }
 
-    return r;
+    tdx_guest = tdx;
+    return 0;
 }
 
 static int tdx_kvm_type(X86ConfidentialGuest *cg)
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index f3b725336161..de8ae9196163 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -3,6 +3,10 @@
 #ifndef QEMU_I386_TDX_H
 #define QEMU_I386_TDX_H
 
+#ifndef CONFIG_USER_ONLY
+#include CONFIG_DEVICES /* CONFIG_TDX */
+#endif
+
 #include "confidential-guest.h"
 
 #define TYPE_TDX_GUEST "tdx-guest"
@@ -18,4 +22,10 @@ typedef struct TdxGuest {
     uint64_t attributes;    /* TD attributes */
 } TdxGuest;
 
+#ifdef CONFIG_TDX
+bool is_tdx_vm(void);
+#else
+#define is_tdx_vm() 0
+#endif /* CONFIG_TDX */
+
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1


