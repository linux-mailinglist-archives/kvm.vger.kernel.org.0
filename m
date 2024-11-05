Return-Path: <kvm+bounces-30636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9E19BC579
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:36:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EA4D1C2170A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FB9D1DB551;
	Tue,  5 Nov 2024 06:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nqaBC32f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642FC1F16B
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788592; cv=none; b=Qz0inysRl6TgtSJ1LV1UBKgA1W5be57ODc9NPXQdfttIKcjzLrilS36oWWMhcruwFVkMQ3IvC7B+kdmSY8frYlabrZvmKR8Sc7kB4gxXkgXewLnsZSUxESU47iLk81ASmk1oyByNGRa8RIrufMwdhEmICr+SmaY10RbMelfHycA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788592; c=relaxed/simple;
	bh=DWbz/FsnKhNwDGpwgnzLBuoDZpAUd28LILimRe0bFmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X/rOqbqF71DXhaN53GJIFNJz0uJdWkCsmKiqjRY/abfFyI1+qLALSDFAhofuHklQAf5HOycEFqkppTQ38uYo2EagIvsxZc0phCetF7zefK5oqmkjr1gNUlbbOsapAgB1cYM2sMe/EfE5XhZRniSsscunDVUGWyTnE23l4czTMW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nqaBC32f; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788590; x=1762324590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DWbz/FsnKhNwDGpwgnzLBuoDZpAUd28LILimRe0bFmc=;
  b=nqaBC32fezrDxquFKSxU3v1ApeO1cFHQik7IwsnhqdNAj6VFVWly2SRz
   57ygjwhrGZvbh6kLX0/wro5cK9WvZMOjltWiKciGm3KDi64BJSOOsaFFM
   8978gAuoZEDmeLytFq28iczNUhSAP2wdTboBwdXqoQR0xnEfWDsymG0Wj
   oMWuLgt5iuMy7CUbi2eb+TYigiQbS+hasyJ3xZmXTv4MhGpeJx6eZ5n77
   JHwahISSCQks/Kv9qFbRMa2DzUx9cyH5ytBiPZHXqD0KZbN2m/kuwSYqD
   w5f1Frcqskm0TzfKZPKo0Td63yrZpeRS6fbx3NnEB7H9AjIUe0WN7wbIj
   w==;
X-CSE-ConnectionGUID: GrBLPHPxQoun513gOeu75Q==
X-CSE-MsgGUID: w5h0LW2jQh6wHRedB4gEPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689220"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689220"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:36:30 -0800
X-CSE-ConnectionGUID: Tt4I96uARDOpGhbeK3+VRQ==
X-CSE-MsgGUID: 17l9xoadQhiPBHnWfFfj5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988564"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:36:26 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 02/60] i386: Introduce tdx-guest object
Date: Tue,  5 Nov 2024 01:23:10 -0500
Message-Id: <20241105062408.3533704-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce tdx-guest object which inherits X86_CONFIDENTIAL_GUEST,
and will be used to create TDX VMs (TDs) by

  qemu -machine ...,confidential-guest-support=tdx0	\
       -object tdx-guest,id=tdx0

It has one QAPI member 'attributes' defined, which allows user to set
TD's attributes directly.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Markus Armbruster <armbru@redhat.com>
---
Chanegs in v6:
 - Make tdx-guest inherits X86_CONFIDENTIAL_GUEST;
 - set cgs->require_guest_memfd;
 - allow attributes settable via QAPI;
 - update QAPI version to since 9.2;

Changes in v4:
 - update the new qapi `since` filed from 8.2 to 9.0

Changes in v1
 - make @attributes not user-settable
---
 configs/devices/i386-softmmu/default.mak |  1 +
 hw/i386/Kconfig                          |  5 +++
 qapi/qom.json                            | 15 ++++++++
 target/i386/kvm/meson.build              |  2 ++
 target/i386/kvm/tdx.c                    | 45 ++++++++++++++++++++++++
 target/i386/kvm/tdx.h                    | 19 ++++++++++
 6 files changed, 87 insertions(+)
 create mode 100644 target/i386/kvm/tdx.c
 create mode 100644 target/i386/kvm/tdx.h

diff --git a/configs/devices/i386-softmmu/default.mak b/configs/devices/i386-softmmu/default.mak
index 4faf2f0315e2..bc0479a7e0a3 100644
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
index 32818480d263..86bc10377c4f 100644
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
index 321ccd708ad1..129b25edf495 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -1008,6 +1008,19 @@
             '*host-data': 'str',
             '*vcek-disabled': 'bool' } }
 
+##
+# @TdxGuestProperties:
+#
+# Properties for tdx-guest objects.
+#
+# @attributes: The 'attributes' of a TD guest that is passed to
+#     KVM_TDX_INIT_VM
+#
+# Since: 9.2
+##
+{ 'struct': 'TdxGuestProperties',
+  'data': { '*attributes': 'uint64' } }
+
 ##
 # @ThreadContextProperties:
 #
@@ -1092,6 +1105,7 @@
     'sev-snp-guest',
     'thread-context',
     's390-pv-guest',
+    'tdx-guest',
     'throttle-group',
     'tls-creds-anon',
     'tls-creds-psk',
@@ -1163,6 +1177,7 @@
                                       'if': 'CONFIG_SECRET_KEYRING' },
       'sev-guest':                  'SevGuestProperties',
       'sev-snp-guest':              'SevSnpGuestProperties',
+      'tdx-guest':                  'TdxGuestProperties',
       'thread-context':             'ThreadContextProperties',
       'throttle-group':             'ThrottleGroupProperties',
       'tls-creds-anon':             'TlsCredsAnonProperties',
diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
index 3996cafaf29f..466bccb9cb17 100644
--- a/target/i386/kvm/meson.build
+++ b/target/i386/kvm/meson.build
@@ -8,6 +8,8 @@ i386_kvm_ss.add(files(
 
 i386_kvm_ss.add(when: 'CONFIG_XEN_EMU', if_true: files('xen-emu.c'))
 
+i386_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'))
+
 i386_system_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
 
 i386_system_ss.add_all(when: 'CONFIG_KVM', if_true: i386_kvm_ss)
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
new file mode 100644
index 000000000000..166f53d2b9e3
--- /dev/null
+++ b/target/i386/kvm/tdx.c
@@ -0,0 +1,45 @@
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
+                                   X86_CONFIDENTIAL_GUEST,
+                                   { TYPE_USER_CREATABLE },
+                                   { NULL })
+
+static void tdx_guest_init(Object *obj)
+{
+    ConfidentialGuestSupport *cgs = CONFIDENTIAL_GUEST_SUPPORT(obj);
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    cgs->require_guest_memfd = true;
+    tdx->attributes = 0;
+
+    object_property_add_uint64_ptr(obj, "attributes", &tdx->attributes,
+                                   OBJ_PROP_FLAG_READWRITE);
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
index 000000000000..de687457cae6
--- /dev/null
+++ b/target/i386/kvm/tdx.h
@@ -0,0 +1,19 @@
+#ifndef QEMU_I386_TDX_H
+#define QEMU_I386_TDX_H
+
+#include "confidential-guest.h"
+
+#define TYPE_TDX_GUEST "tdx-guest"
+#define TDX_GUEST(obj)  OBJECT_CHECK(TdxGuest, (obj), TYPE_TDX_GUEST)
+
+typedef struct TdxGuestClass {
+    X86ConfidentialGuestClass parent_class;
+} TdxGuestClass;
+
+typedef struct TdxGuest {
+    X86ConfidentialGuest parent_obj;
+
+    uint64_t attributes;    /* TD attributes */
+} TdxGuest;
+
+#endif /* QEMU_I386_TDX_H */
-- 
2.34.1


