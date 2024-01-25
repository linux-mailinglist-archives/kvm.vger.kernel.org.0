Return-Path: <kvm+bounces-6918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE8C483B7E1
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:29:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 777C9B2365D
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8994811721;
	Thu, 25 Jan 2024 03:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fqkhsPdk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6D7111AE
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153306; cv=none; b=Gph9v8xjp9nlhM9Y3gJVRSXNDsbwgciFuwTQa8t9nJoNAYPJo4dJrG/eKrTTWHYga1TBONGX1PxCS4xwt0mDoVQ2FEOuAgu4G0Vlw7fdanD3vfAXrgas5DIJZNk1/uLTvNCzDSMugxZxUjAFsvp8HN74xR+vAltxr2u667P0w0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153306; c=relaxed/simple;
	bh=JSQZf9fpW+EfTuHXiZKh9ow2uMXtChqYfdgZMLqBnzA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E9vO1+zdqhHge4nSMWOgx/Vl8xZnvr7j2Jmp8iLTBwZGaaWUwKPJxw+hA+qASiKGG3Z9jB0a+UsH2XGysUD+stjJzNemjH9vsYNn9ZZg3yg7baLb7HLEWj8htd0IObPCHCK6tnJzyBaEDY350kL1IJEDGTUckwN6GoavdPK2njg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fqkhsPdk; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153305; x=1737689305;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JSQZf9fpW+EfTuHXiZKh9ow2uMXtChqYfdgZMLqBnzA=;
  b=fqkhsPdkmQe9P6L3fBdXC1yJIiiBJwj+lRBdAH82ecT7fkjaY9Fs6ey4
   JxqaFpPydkbHQHD1NudV1FpojzLkmKIy27hl2YqwVZ5VTFMuBp+EsQU6G
   umKIswyx41y9QA6SPW2faqLKQUOPgNrOM+1zViYkCkvVkrTEC26CInR+o
   HBKV0nc6uSaKKldq3JB03xsnEjLT4dOH+CyArH8qGPzBpMtSYPNRpKJNC
   vGs4ujXYgsStt6/UPKisrB6l/Qafc/YDu16ZOAG/cpzVdn4TJL8iZdcI2
   ZBd9XM2BjI2LWXZ7cULZCv8LaVloBOo3ZF3G8WoNO2UNO0Hi4ZjQVQD8l
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9428384"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9428384"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:25:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2085086"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:25:00 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 16/66] i386/tdx: Introduce is_tdx_vm() helper and cache tdx_guest object
Date: Wed, 24 Jan 2024 22:22:38 -0500
Message-Id: <20240125032328.2522472-17-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
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
index ad76abd58373..3c59b3b45419 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -21,8 +21,16 @@
 #include "kvm_i386.h"
 #include "tdx.h"
 
+static TdxGuest *tdx_guest;
+
 static struct kvm_tdx_capabilities *tdx_caps;
 
+/* It's valid after kvm_confidential_guest_init()->kvm_tdx_init() */
+bool is_tdx_vm(void)
+{
+    return !!tdx_guest;
+}
+
 enum tdx_ioctl_level{
     TDX_VM_IOCTL,
     TDX_VCPU_IOCTL,
@@ -103,15 +111,20 @@ static int get_tdx_capabilities(Error **errp)
 
 int tdx_kvm_init(MachineState *ms, Error **errp)
 {
+    TdxGuest *tdx = TDX_GUEST(OBJECT(ms->cgs));
     int r = 0;
 
     ms->require_guest_memfd = true;
 
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
 
 /* tdx guest */
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index c8a23d95258d..4036ca2f3f99 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -1,6 +1,10 @@
 #ifndef QEMU_I386_TDX_H
 #define QEMU_I386_TDX_H
 
+#ifndef CONFIG_USER_ONLY
+#include CONFIG_DEVICES /* CONFIG_TDX */
+#endif
+
 #include "exec/confidential-guest-support.h"
 
 #define TYPE_TDX_GUEST "tdx-guest"
@@ -16,6 +20,12 @@ typedef struct TdxGuest {
     uint64_t attributes;    /* TD attributes */
 } TdxGuest;
 
+#ifdef CONFIG_TDX
+bool is_tdx_vm(void);
+#else
+#define is_tdx_vm() 0
+#endif /* CONFIG_TDX */
+
 int tdx_kvm_init(MachineState *ms, Error **errp);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1


