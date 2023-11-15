Return-Path: <kvm+bounces-1744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C04E77EBD91
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:17:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EECAC1C20AF6
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3AFC8F67;
	Wed, 15 Nov 2023 07:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lQQ/zQYW"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A05B8F48
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:17:30 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E05AD1
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032649; x=1731568649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GknF7e6awGf/wHpOuYF3kWSKSu1b6I0gK2ef1wOlud8=;
  b=lQQ/zQYWoAxmoLz6F2OJgljzQumcxpvTBUDDKbirlD3XkNCPvp9C6ptJ
   ngfEJm6sjBKhKuoka+iSkg4gDbqI3Mgj6I7ZfDCbkp4tvFln0xiZFg59k
   RvYPfhynzIKWgSKAtW1A6p8mjT84fYLqwy04vA5nDoSnAccXpQpMGz40A
   WKjiRdQ1EIexkVx4wepAJQfpEeXxogse9NdP1uBhC9fUpe1jYRsZYyb24
   x7uDMFiJy15YAa0qDJx6p7QiaIRYV3O7JW7Xnj1cszAuzN9LwH9lSWfVC
   etoYXZ+y/9BztzLJmPZK4BtT89X/HyoDERw06keJIBXj0mnTGi/5meuDP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390622487"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390622487"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:17:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714797836"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714797836"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:17:23 -0800
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
Subject: [PATCH v3 17/70] i386/tdx: Implement tdx_kvm_init() to initialize TDX VM context
Date: Wed, 15 Nov 2023 02:14:26 -0500
Message-Id: <20231115071519.2864957-18-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce tdx_kvm_init() and invoke it in kvm_confidential_guest_init()
if it's a TDX VM.

Set ms->require_guest_memfd to require kvm guest memfd allocation for any
memory backend. More TDX specific initialization will be added later.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/kvm.c       | 15 ++++++---------
 target/i386/kvm/meson.build |  2 +-
 target/i386/kvm/tdx-stub.c  |  8 ++++++++
 target/i386/kvm/tdx.c       |  9 +++++++++
 target/i386/kvm/tdx.h       |  2 ++
 5 files changed, 26 insertions(+), 10 deletions(-)
 create mode 100644 target/i386/kvm/tdx-stub.c

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index dc69f4b7b196..7abcdebb1452 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -62,6 +62,7 @@
 #include "migration/blocker.h"
 #include "exec/memattrs.h"
 #include "trace.h"
+#include "tdx.h"
 
 #include CONFIG_DEVICES
 
@@ -2546,6 +2547,8 @@ static int kvm_confidential_guest_init(MachineState *ms, Error **errp)
 {
     if (object_dynamic_cast(OBJECT(ms->cgs), TYPE_SEV_GUEST)) {
         return sev_kvm_init(ms->cgs, errp);
+    } else if (object_dynamic_cast(OBJECT(ms->cgs), TYPE_TDX_GUEST)) {
+        return tdx_kvm_init(ms, errp);
     }
 
     return 0;
@@ -2560,16 +2563,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     Error *local_err = NULL;
 
     /*
-     * Initialize SEV context, if required
+     * Initialize confidential guest (SEV/TDX) context, if required
      *
-     * If no memory encryption is requested (ms->cgs == NULL) this is
-     * a no-op.
-     *
-     * It's also a no-op if a non-SEV confidential guest support
-     * mechanism is selected.  SEV is the only mechanism available to
-     * select on x86 at present, so this doesn't arise, but if new
-     * mechanisms are supported in future (e.g. TDX), they'll need
-     * their own initialization either here or elsewhere.
+     * It's a no-op if a non-SEV/non-tdx confidential guest support
+     * mechanism is selected, i.e., ms->cgs == NULL
      */
     ret = kvm_confidential_guest_init(ms, &local_err);
     if (ret < 0) {
diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
index 6ea0ce27b757..30a90b4d371d 100644
--- a/target/i386/kvm/meson.build
+++ b/target/i386/kvm/meson.build
@@ -9,7 +9,7 @@ i386_kvm_ss.add(when: 'CONFIG_XEN_EMU', if_true: files('xen-emu.c'))
 
 i386_kvm_ss.add(when: 'CONFIG_SEV', if_false: files('sev-stub.c'))
 
-i386_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'))
+i386_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'), if_false: files('tdx-stub.c'))
 
 i386_system_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
 
diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
new file mode 100644
index 000000000000..1d866d5496bf
--- /dev/null
+++ b/target/i386/kvm/tdx-stub.c
@@ -0,0 +1,8 @@
+#include "qemu/osdep.h"
+
+#include "tdx.h"
+
+int tdx_kvm_init(MachineState *ms, Error **errp)
+{
+    return -EINVAL;
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index d3792d4a3d56..621a05beeb4e 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -12,10 +12,19 @@
  */
 
 #include "qemu/osdep.h"
+#include "qapi/error.h"
 #include "qom/object_interfaces.h"
 
+#include "hw/i386/x86.h"
 #include "tdx.h"
 
+int tdx_kvm_init(MachineState *ms, Error **errp)
+{
+    ms->require_guest_memfd = true;
+
+    return 0;
+}
+
 /* tdx guest */
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    tdx_guest,
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 415aeb5af746..c8a23d95258d 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -16,4 +16,6 @@ typedef struct TdxGuest {
     uint64_t attributes;    /* TD attributes */
 } TdxGuest;
 
+int tdx_kvm_init(MachineState *ms, Error **errp);
+
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1


