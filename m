Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1378312A70
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 07:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBHGGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 01:06:40 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:51809 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhBHGGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 01:06:33 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DYwVs6k4Bz9sWF; Mon,  8 Feb 2021 17:05:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612764341;
        bh=V5VNS17scGWqP+jxJEkReu2iTvfK03mqfFhy2/XwomQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PndGJVRZPEY2+uaL2gTi7ciYS+FZoJ2BemEFIxreMPaPhB2cZn6KvPaCOiT/35aui
         nooHZXxpgoswHgyGJjCIBojaiHTMUv3rOI2HgTkXoOHyhe1XnN1TeZ8TeQgUVHxz1t
         SOYKGiEB4IHjn/gKVzOcQg8FxhkKORREOp5AY24s=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pasic@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, brijesh.singh@amd.com
Cc:     ehabkost@redhat.com, mtosatti@redhat.com, mst@redhat.com,
        jun.nakajima@intel.com, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, frankja@linux.ibm.com, andi.kleen@intel.com,
        cohuck@redhat.com, Thomas Huth <thuth@redhat.com>,
        borntraeger@de.ibm.com, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        qemu-ppc@nongnu.org, David Hildenbrand <david@redhat.com>,
        Greg Kurz <groug@kaod.org>, pragyansri.pathi@intel.com
Subject: [PULL v9 08/13] confidential guest support: Move SEV initialization into arch specific code
Date:   Mon,  8 Feb 2021 17:05:33 +1100
Message-Id: <20210208060538.39276-9-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208060538.39276-1-david@gibson.dropbear.id.au>
References: <20210208060538.39276-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While we've abstracted some (potential) differences between mechanisms for
securing guest memory, the initialization is still specific to SEV.  Given
that, move it into x86's kvm_arch_init() code, rather than the generic
kvm_init() code.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Greg Kurz <groug@kaod.org>
---
 accel/kvm/kvm-all.c   | 14 --------------
 accel/kvm/sev-stub.c  |  4 ++--
 target/i386/kvm/kvm.c | 20 ++++++++++++++++++++
 target/i386/sev.c     |  7 ++++++-
 4 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 226e1556f9..e72a19aaf8 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2180,20 +2180,6 @@ static int kvm_init(MachineState *ms)
 
     kvm_state = s;
 
-    /*
-     * if memory encryption object is specified then initialize the memory
-     * encryption context.
-     */
-    if (ms->cgs) {
-        Error *local_err = NULL;
-        /* FIXME handle mechanisms other than SEV */
-        ret = sev_kvm_init(ms->cgs, &local_err);
-        if (ret < 0) {
-            error_report_err(local_err);
-            goto err;
-        }
-    }
-
     ret = kvm_arch_init(ms, s);
     if (ret < 0) {
         goto err;
diff --git a/accel/kvm/sev-stub.c b/accel/kvm/sev-stub.c
index 512e205f7f..9587d1b2a3 100644
--- a/accel/kvm/sev-stub.c
+++ b/accel/kvm/sev-stub.c
@@ -17,6 +17,6 @@
 
 int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
-    /* SEV can't be selected if it's not compiled */
-    g_assert_not_reached();
+    /* If we get here, cgs must be some non-SEV thing */
+    return 0;
 }
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6dc1ee052d..4788139128 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -42,6 +42,7 @@
 #include "hw/i386/intel_iommu.h"
 #include "hw/i386/x86-iommu.h"
 #include "hw/i386/e820_memory_layout.h"
+#include "sysemu/sev.h"
 
 #include "hw/pci/pci.h"
 #include "hw/pci/msi.h"
@@ -2135,6 +2136,25 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     uint64_t shadow_mem;
     int ret;
     struct utsname utsname;
+    Error *local_err = NULL;
+
+    /*
+     * Initialize SEV context, if required
+     *
+     * If no memory encryption is requested (ms->cgs == NULL) this is
+     * a no-op.
+     *
+     * It's also a no-op if a non-SEV confidential guest support
+     * mechanism is selected.  SEV is the only mechanism available to
+     * select on x86 at present, so this doesn't arise, but if new
+     * mechanisms are supported in future (e.g. TDX), they'll need
+     * their own initialization either here or elsewhere.
+     */
+    ret = sev_kvm_init(ms->cgs, &local_err);
+    if (ret < 0) {
+        error_report_err(local_err);
+        return ret;
+    }
 
     if (!kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
         error_report("kvm: KVM_CAP_IRQ_ROUTING not supported by KVM");
diff --git a/target/i386/sev.c b/target/i386/sev.c
index f9e9b5d8ae..11c9a3cc21 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -664,13 +664,18 @@ sev_vm_state_change(void *opaque, int running, RunState state)
 
 int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
-    SevGuestState *sev = SEV_GUEST(cgs);
+    SevGuestState *sev
+        = (SevGuestState *)object_dynamic_cast(OBJECT(cgs), TYPE_SEV_GUEST);
     char *devname;
     int ret, fw_error;
     uint32_t ebx;
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
 
+    if (!sev) {
+        return 0;
+    }
+
     ret = ram_block_discard_disable(true);
     if (ret) {
         error_report("%s: cannot disable RAM discard", __func__);
-- 
2.29.2

