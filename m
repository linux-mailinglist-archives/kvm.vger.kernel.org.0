Return-Path: <kvm+bounces-36502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB97A1B6F9
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:38:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D355A188C677
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005F678F23;
	Fri, 24 Jan 2025 13:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l6BdLleC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B263435947
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725887; cv=none; b=cHCp2aeIikBpz/Nb0nxWhaSFdTtBsHQ0308IM84SD/kjecehghj0tC8LQq357xVaIFXx5kaW6LIGD1xxiuv5gImZTbvkis1J7JaNRwnDlEy+npiKOeneAS3tAI1BAKAT6lmWujQrSjan4FD5Oso21Qstaq68fN3IUjOJEmDykwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725887; c=relaxed/simple;
	bh=KvZlxJMfHQpg+xP8PiG3vQkx+/0/ppfMQ8jqgGYNJts=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Urpkz2FyO7DeHsr2g0kNDbRNNXXqTOxAECZTjy674oq94EboiYNWo70iYxtdQscZujWOeUwiJWVOhNOa6Wo9lq3z1dm0UIJZP6JVv7rOaUOF7VWWFi+Dskf1majNWreMHbHzCXKqYIRdHWSRRTfefqCFZk+9myMr+ZexzERhOi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l6BdLleC; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725886; x=1769261886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KvZlxJMfHQpg+xP8PiG3vQkx+/0/ppfMQ8jqgGYNJts=;
  b=l6BdLleC0Mf6hwYc6XMOsCpJst4bNk/IK47mKv1WjZ8aMmAriejSpowI
   KGaaWnm//AMZSNd9ZuhiNVFJ2+OH9z9yNK2DrmQNlfGO3gHxFQP+FefL/
   J40w2DyX7oRuOtK7q2KlLtpCaCF6/iCm4DWx0LLpdInN5D5o6zqEXYqv3
   aP443hJB4wTh2Y1tlgUnfbQFYpw23ZZ31ZPfs4juQCWo/Y1MV6F4KRaCx
   GO7Z5mjkp4yb6kDuaf174bCFkR3LMMrJu3NX64ReDGVDQwp6zXB7LPab+
   Xk6W/C3JQjQATNPZr+kYOTBgLqlTBcULrd2zXxdq1CUbOcXX54GonfXKL
   A==;
X-CSE-ConnectionGUID: O8B1tUcRSKSuuDGUfDJ4lQ==
X-CSE-MsgGUID: 1eIvN8EhTzSQJNS0YtNw3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246338"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246338"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:38:06 -0800
X-CSE-ConnectionGUID: Fjlf3TCXTKe3sRoxDNFtaQ==
X-CSE-MsgGUID: XCvGpOWiQF6kwJIg5pwVLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804258"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:38:01 -0800
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
Subject: [PATCH v7 17/52] i386/tdx: Parse TDVF metadata for TDX VM
Date: Fri, 24 Jan 2025 08:20:13 -0500
Message-Id: <20250124132048.3229049-18-xiaoyao.li@intel.com>
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

After TDVF is loaded to bios MemoryRegion, it needs parse TDVF metadata.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 hw/i386/pc_sysfw.c         | 7 +++++++
 target/i386/kvm/tdx-stub.c | 5 +++++
 target/i386/kvm/tdx.c      | 5 +++++
 target/i386/kvm/tdx.h      | 3 +++
 4 files changed, 20 insertions(+)

diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index 1eeb58ab37f9..821396c16e91 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -37,6 +37,7 @@
 #include "hw/block/flash.h"
 #include "system/kvm.h"
 #include "target/i386/sev.h"
+#include "kvm/tdx.h"
 
 #define FLASH_SECTOR_SIZE 4096
 
@@ -280,5 +281,11 @@ void x86_firmware_configure(hwaddr gpa, void *ptr, int size)
         }
 
         sev_encrypt_flash(gpa, ptr, size, &error_fatal);
+    } else if (is_tdx_vm()) {
+        ret = tdx_parse_tdvf(ptr, size);
+        if (ret) {
+            error_report("failed to parse TDVF for TDX VM");
+            exit(1);
+        }
     }
 }
diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
index 2344433594ea..7748b6d0a446 100644
--- a/target/i386/kvm/tdx-stub.c
+++ b/target/i386/kvm/tdx-stub.c
@@ -8,3 +8,8 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
 {
     return -EINVAL;
 }
+
+int tdx_parse_tdvf(void *flash_ptr, int size)
+{
+    return -EINVAL;
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index f1c0553e6d4a..73f90b0a2217 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -370,6 +370,11 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     return 0;
 }
 
+int tdx_parse_tdvf(void *flash_ptr, int size)
+{
+    return tdvf_parse_metadata(&tdx_guest->tdvf, flash_ptr, size);
+}
+
 static bool tdx_guest_get_sept_ve_disable(Object *obj, Error **errp)
 {
     TdxGuest *tdx = TDX_GUEST(obj);
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index b73461b8d8a3..28a03c2a7b82 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -8,6 +8,7 @@
 #endif
 
 #include "confidential-guest.h"
+#include "hw/i386/tdvf.h"
 
 #define TYPE_TDX_GUEST "tdx-guest"
 #define TDX_GUEST(obj)  OBJECT_CHECK(TdxGuest, (obj), TYPE_TDX_GUEST)
@@ -32,6 +33,7 @@ typedef struct TdxGuest {
     char *mrownerconfig;    /* base64 encoded sha348 digest */
 
     MemoryRegion *tdvf_mr;
+    TdxFirmware tdvf;
 } TdxGuest;
 
 #ifdef CONFIG_TDX
@@ -42,5 +44,6 @@ bool is_tdx_vm(void);
 
 int tdx_pre_create_vcpu(CPUState *cpu, Error **errp);
 void tdx_set_tdvf_region(MemoryRegion *tdvf_mr);
+int tdx_parse_tdvf(void *flash_ptr, int size);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1


