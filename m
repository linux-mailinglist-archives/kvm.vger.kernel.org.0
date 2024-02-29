Return-Path: <kvm+bounces-10372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 85FDC86C0E9
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:41:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 164D1B2624E
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A822D3C697;
	Thu, 29 Feb 2024 06:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RFRTEvtF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC5E1EB3F
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188760; cv=none; b=PWPafiv9EBnpygjNLk5JhkZubzQHK2R5cmBYbSMnVjRUy21/73CxvyjOBC4Ll9d4y/rLfksXik/hTmCpWMXyuENVYiwzsjtSJc2k3EMDv0JvPpB73x1EM2BCzo4vEiSncbwv/ez91fPh4WlW1P8khrHdUXl6r5VZYa1m0ArOrkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188760; c=relaxed/simple;
	bh=QXoM18hmRrOEoybjuwFTeP4ts+XDoCapDnvGmQKflQ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EBqBs/vTVpfCuewKV7pquuUwhhsEtD7FtkmezAucsBhgvACKBDhprYt3+6kEEbkLEi/y8s+jIi4pnAKKYd9h3El8QGCMr9xqLZlcWB99dMrkG0TUnm5ZdGJdZlmvwz8eokgyvR1W3UZU5azTeRDcyByTsz5rBpOPVLHqpg0M6Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RFRTEvtF; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188759; x=1740724759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QXoM18hmRrOEoybjuwFTeP4ts+XDoCapDnvGmQKflQ0=;
  b=RFRTEvtFdxKQfLFuv+6n3/0XYArZvMx235CXykeeOfeJO8bD1bcKJ8dV
   oAyi0yimrEfwzQbM4CKo3g260dNvq5MGZo4gEj0Re50BSyP4bzRU1lNpF
   8kUWJKqgxQ/Vrw1iuJycBbUkjpJ/Zgzu7+7U0TEGWc8ZbBynBa7lRl83U
   sxeG8HrGzr30EkCCbAeIMq8XO7mPUOs/cR+PjYJyyuM2mIzckNQrvWcGL
   /bbOIEj14sEaHzHKjj/p/HyPfRrGzGYrGay/HMzBgPnyOwqN5rqAoj4l9
   AH6BmV0xscqfnHhUONwlUwJz5uuYVRuG/oZ9y4OXZvfZdxi74G1+BWK1e
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802625"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802625"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:39:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8075093"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:39:13 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 16/65] i386/tdx: Introduce is_tdx_vm() helper and cache tdx_guest object
Date: Thu, 29 Feb 2024 01:36:37 -0500
Message-Id: <20240229063726.610065-17-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
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
index 2b956450a083..756058f2ed4a 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -21,8 +21,16 @@
 #include "kvm_i386.h"
 #include "tdx.h"
 
+static TdxGuest *tdx_guest;
+
 static struct kvm_tdx_capabilities *tdx_caps;
 
+/* It's valid after kvm_arch_init()->kvm_tdx_init() */
+bool is_tdx_vm(void)
+{
+    return !!tdx_guest;
+}
+
 enum tdx_ioctl_level{
     TDX_VM_IOCTL,
     TDX_VCPU_IOCTL,
@@ -104,15 +112,20 @@ static int get_tdx_capabilities(Error **errp)
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
+    TdxGuest *tdx = TDX_GUEST(cgs);
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
index 415aeb5af746..d5b4c179fbf7 100644
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
@@ -16,4 +20,10 @@ typedef struct TdxGuest {
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


