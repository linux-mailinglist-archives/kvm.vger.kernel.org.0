Return-Path: <kvm+bounces-6913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5734683B7D9
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:29:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C360FB23413
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D80856FB2;
	Thu, 25 Jan 2024 03:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NaY9bhw7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AB711185
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153297; cv=none; b=Cg1Ke2X+bgJ+FwysjnpPm3Mwapx27saupBA3vyIxytG5vPKg3HE60UPtZezJtB/oM5EbNWARaQFW5lQjHfmQxbkvtrxX5HUTD87zI3Hr1//xJfPdoF4CQhAaUWfzA971q8/3UItjTMfzAXVnPtc99X3JX+gaElnhgRsaMhabn5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153297; c=relaxed/simple;
	bh=JJ7DfZYPfF53P59ZPLA5hFKttXpMbcVvDC2Fx+eVoTw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tocxG3/qI06Xc+BvhL8i0gl4bf4mfhV5Ra2oo7/zSDkLRF1GUlYOHd6YgNS9YG17WkuUxwL7TWDSkb78X6OuT6Dl0owsj+Q+Pbl9t5WcUKRKANdrgq5LQFV2nL/t1CrN+vF65MnO4Wp4GBmF7khAWILjL0rT0AXPO5iMS8NEZq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NaY9bhw7; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153295; x=1737689295;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JJ7DfZYPfF53P59ZPLA5hFKttXpMbcVvDC2Fx+eVoTw=;
  b=NaY9bhw7z6Jru7B++J1gXO54IPv5Ky82hRO2j/pn1Alw4TK/Viel5IPa
   DSIS9ME0p7hUqTSPezJJxxWuVf6irwdq0dntRl65eM2LoHFdhmveo8Rvw
   4EpCVI3atKHJoV7cfjgzOa3Kwu6Dr2yyoXOTXMrrQgpFGq+DV8so9R57b
   4QIywGmOvS9ndvmemQPnQ5whpqrT/ywZ9M5gbVPpDMeHbzd+VyyqsKivd
   YNXOLeJI8oCpejiacCdP9SfwxMQf52BlkO8+F1I4s8nCYDkqee6zIuTsV
   E6blCpLuBOsG4OnmcQgjvF5QKfPm6dv3i6k1z3xZ2fxTGNBclMtgB4HZ5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9428155"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9428155"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:24:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2084814"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:24:32 -0800
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
Subject: [PATCH v4 11/66] i386: Introduce tdx-guest object
Date: Wed, 24 Jan 2024 22:22:33 -0500
Message-Id: <20240125032328.2522472-12-xiaoyao.li@intel.com>
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

Introduce tdx-guest object which implements the interface of
CONFIDENTIAL_GUEST_SUPPORT, and will be used to create TDX VMs (TDs) by

  qemu -machine ...,confidential-guest-support=tdx0	\
       -object tdx-guest,id=tdx0

It has only one member 'attributes' with fixed value 0 and not
configurable so far.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Markus Armbruster <armbru@redhat.com>
---
Changes in v4:
 - update the new qapi `since` filed from 8.2 to 9.0

Changes in v1
 - make @attributes not user-settable
---
 configs/devices/i386-softmmu/default.mak |  1 +
 hw/i386/Kconfig                          |  5 +++
 qapi/qom.json                            | 12 +++++++
 target/i386/kvm/meson.build              |  2 ++
 target/i386/kvm/tdx.c                    | 40 ++++++++++++++++++++++++
 target/i386/kvm/tdx.h                    | 19 +++++++++++
 6 files changed, 79 insertions(+)
 create mode 100644 target/i386/kvm/tdx.c
 create mode 100644 target/i386/kvm/tdx.h

diff --git a/configs/devices/i386-softmmu/default.mak b/configs/devices/i386-softmmu/default.mak
index 598c6646dfc0..9b5ec59d65b0 100644
--- a/configs/devices/i386-softmmu/default.mak
+++ b/configs/devices/i386-softmmu/default.mak
@@ -18,6 +18,7 @@
 #CONFIG_QXL=n
 #CONFIG_SEV=n
 #CONFIG_SGA=n
+#CONFIG_TDX=n
 #CONFIG_TEST_DEVICES=n
 #CONFIG_TPM_CRB=n
 #CONFIG_TPM_TIS_ISA=n
diff --git a/hw/i386/Kconfig b/hw/i386/Kconfig
index a1846be6f761..c0ccf50ac3ef 100644
--- a/hw/i386/Kconfig
+++ b/hw/i386/Kconfig
@@ -10,6 +10,10 @@ config SGX
     bool
     depends on KVM
 
+config TDX
+    bool
+    depends on KVM
+
 config PC
     bool
     imply APPLESMC
@@ -26,6 +30,7 @@ config PC
     imply QXL
     imply SEV
     imply SGX
+    imply TDX
     imply TEST_DEVICES
     imply TPM_CRB
     imply TPM_TIS_ISA
diff --git a/qapi/qom.json b/qapi/qom.json
index 95516ba325e5..5b3c3146947f 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -895,6 +895,16 @@
             'reduced-phys-bits': 'uint32',
             '*kernel-hashes': 'bool' } }
 
+##
+# @TdxGuestProperties:
+#
+# Properties for tdx-guest objects.
+#
+# Since: 9.0
+##
+{ 'struct': 'TdxGuestProperties',
+  'data': { }}
+
 ##
 # @ThreadContextProperties:
 #
@@ -974,6 +984,7 @@
     'sev-guest',
     'thread-context',
     's390-pv-guest',
+    'tdx-guest',
     'throttle-group',
     'tls-creds-anon',
     'tls-creds-psk',
@@ -1041,6 +1052,7 @@
       'secret_keyring':             { 'type': 'SecretKeyringProperties',
                                       'if': 'CONFIG_SECRET_KEYRING' },
       'sev-guest':                  'SevGuestProperties',
+      'tdx-guest':                  'TdxGuestProperties',
       'thread-context':             'ThreadContextProperties',
       'throttle-group':             'ThrottleGroupProperties',
       'tls-creds-anon':             'TlsCredsAnonProperties',
diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
index 84d9143e6029..6ea0ce27b757 100644
--- a/target/i386/kvm/meson.build
+++ b/target/i386/kvm/meson.build
@@ -9,6 +9,8 @@ i386_kvm_ss.add(when: 'CONFIG_XEN_EMU', if_true: files('xen-emu.c'))
 
 i386_kvm_ss.add(when: 'CONFIG_SEV', if_false: files('sev-stub.c'))
 
+i386_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'))
+
 i386_system_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
 
 i386_system_ss.add_all(when: 'CONFIG_KVM', if_true: i386_kvm_ss)
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
new file mode 100644
index 000000000000..d3792d4a3d56
--- /dev/null
+++ b/target/i386/kvm/tdx.c
@@ -0,0 +1,40 @@
+/*
+ * QEMU TDX support
+ *
+ * Copyright Intel
+ *
+ * Author:
+ *      Xiaoyao Li <xiaoyao.li@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory
+ *
+ */
+
+#include "qemu/osdep.h"
+#include "qom/object_interfaces.h"
+
+#include "tdx.h"
+
+/* tdx guest */
+OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
+                                   tdx_guest,
+                                   TDX_GUEST,
+                                   CONFIDENTIAL_GUEST_SUPPORT,
+                                   { TYPE_USER_CREATABLE },
+                                   { NULL })
+
+static void tdx_guest_init(Object *obj)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    tdx->attributes = 0;
+}
+
+static void tdx_guest_finalize(Object *obj)
+{
+}
+
+static void tdx_guest_class_init(ObjectClass *oc, void *data)
+{
+}
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
new file mode 100644
index 000000000000..415aeb5af746
--- /dev/null
+++ b/target/i386/kvm/tdx.h
@@ -0,0 +1,19 @@
+#ifndef QEMU_I386_TDX_H
+#define QEMU_I386_TDX_H
+
+#include "exec/confidential-guest-support.h"
+
+#define TYPE_TDX_GUEST "tdx-guest"
+#define TDX_GUEST(obj)  OBJECT_CHECK(TdxGuest, (obj), TYPE_TDX_GUEST)
+
+typedef struct TdxGuestClass {
+    ConfidentialGuestSupportClass parent_class;
+} TdxGuestClass;
+
+typedef struct TdxGuest {
+    ConfidentialGuestSupport parent_obj;
+
+    uint64_t attributes;    /* TD attributes */
+} TdxGuest;
+
+#endif /* QEMU_I386_TDX_H */
-- 
2.34.1


