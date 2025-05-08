Return-Path: <kvm+bounces-45934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EFEC3AAFE8D
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:11:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45AF21BC4DD1
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98004286400;
	Thu,  8 May 2025 15:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dmBvKARx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3936127A468
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716792; cv=none; b=fNLjzrv04BljV15wcUA++sZjXw5aVnuQgLYH8WdrlBQcXjC2qEhU5K4CRaZRc0XNL5wrI2LCtOMib9O1D49yae2wzT2W51FXFlSGdIiRvIJKuO4DZQN6LC5fWTEawEjhDnK7Ug+7aPAWP/AGlLM9jPqxeHKg9JOEgJ6sox228O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716792; c=relaxed/simple;
	bh=Ua3ZETS+iT290H+LO2Dg9TnqZFRwIQnJNoMCWUzIJ38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ziqc8hAE89clEVZfLI7PF8jemEQfuvyIYJ/nH1LZEEi+fsDoYQE7r7KqeRb8nXJZuojRZZXSeScsXCn9YtI0et4dvhtuWejuCyqgTO9/fxvUhHy6Su7Z6sGO2BbjFW+THiMTl1S5Pzz44JQAcu+P6TRsS5tiVgSaZSXKjfygm6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dmBvKARx; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716791; x=1778252791;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ua3ZETS+iT290H+LO2Dg9TnqZFRwIQnJNoMCWUzIJ38=;
  b=dmBvKARxhDZ7q3rRwePL+wanRh6dIWJJ9Ts5Uo4g+GIr7U8PDcV9O5ld
   oYKGfbX8WiCXZuiim3Rm0+gMQTSYpPGc74t5vWAUOqlgsGW6LRrU74qH9
   WRCPRwwF0kSG+Ji4E3+OmFM7H9PX8bjWmNmk7sJYdDt4t8OGlv3u4wONO
   Al0Z2bZhgSDswLDg0W92q472rTRyEmdnWPuKgnAvj9kol4ODf9EG8e2bI
   Z+EuotbmcBtNqNYtdLv6FAko54DN+kpBMn4v1zyE6QNgGKmB4Icdc3C1k
   lg7xgQoVFASnzw7XnB3QXQfUke4+hhR68f+yWog6u2aaaY5p45UC1unHw
   g==;
X-CSE-ConnectionGUID: YmUThV3hQmak8S9y4pMUTw==
X-CSE-MsgGUID: RiKP3IPMROWW5ZYYZsBkHQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888274"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888274"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:31 -0700
X-CSE-ConnectionGUID: OJjJQfX8Q62hzqaYYfem4Q==
X-CSE-MsgGUID: HS8g275/QTS3WHFg59Vvxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440129"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:28 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 31/55] i386/cpu: introduce x86_confidential_guest_cpu_instance_init()
Date: Thu,  8 May 2025 10:59:37 -0400
Message-ID: <20250508150002.689633-32-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To allow execute confidential guest specific cpu init operations.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v9:
 - use current_machine instead of qdev_get_machine(); (Zhao Liu)

Changes in v6:
 - new patch;
---
 target/i386/confidential-guest.h | 11 +++++++++++
 target/i386/cpu.c                |  8 ++++++++
 2 files changed, 19 insertions(+)

diff --git a/target/i386/confidential-guest.h b/target/i386/confidential-guest.h
index 164be7633a20..a86c42a47558 100644
--- a/target/i386/confidential-guest.h
+++ b/target/i386/confidential-guest.h
@@ -39,6 +39,7 @@ struct X86ConfidentialGuestClass {
 
     /* <public> */
     int (*kvm_type)(X86ConfidentialGuest *cg);
+    void (*cpu_instance_init)(X86ConfidentialGuest *cg, CPUState *cpu);
     uint32_t (*mask_cpuid_features)(X86ConfidentialGuest *cg, uint32_t feature, uint32_t index,
                                     int reg, uint32_t value);
 };
@@ -59,6 +60,16 @@ static inline int x86_confidential_guest_kvm_type(X86ConfidentialGuest *cg)
     }
 }
 
+static inline void x86_confidential_guest_cpu_instance_init(X86ConfidentialGuest *cg,
+                                                            CPUState *cpu)
+{
+    X86ConfidentialGuestClass *klass = X86_CONFIDENTIAL_GUEST_GET_CLASS(cg);
+
+    if (klass->cpu_instance_init) {
+        klass->cpu_instance_init(cg, cpu);
+    }
+}
+
 /**
  * x86_confidential_guest_mask_cpuid_features:
  *
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index add6430f7edd..ea73b2225282 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -36,6 +36,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/i386/topology.h"
 #ifndef CONFIG_USER_ONLY
+#include "confidential-guest.h"
 #include "system/reset.h"
 #include "qapi/qapi-commands-machine-target.h"
 #include "exec/address-spaces.h"
@@ -8504,6 +8505,13 @@ static void x86_cpu_post_initfn(Object *obj)
     }
 
     accel_cpu_instance_init(CPU(obj));
+
+#ifndef CONFIG_USER_ONLY
+    if (current_machine && current_machine->cgs) {
+        x86_confidential_guest_cpu_instance_init(
+            X86_CONFIDENTIAL_GUEST(current_machine->cgs), (CPU(obj)));
+    }
+#endif
 }
 
 static void x86_cpu_init_default_topo(X86CPU *cpu)
-- 
2.43.0


