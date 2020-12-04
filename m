Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3052CE7B5
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 06:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgLDFpn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 00:45:43 -0500
Received: from ozlabs.org ([203.11.71.1]:48203 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728178AbgLDFpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 00:45:42 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CnM8h3nJ0z9sVw; Fri,  4 Dec 2020 16:44:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607060660;
        bh=pnJf0W657ZqIQCAsU+SbMXMq/ij/zS+RJqdmVHy+dx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKkxc8iV11JrVmF6RVkWAi412yYd8//9vWGcbEhH6VeDetkjlJIxok/U4bUqGlqTV
         GHcdr5a2Mw0HrE0iN5YtpCspvp/t43OqHQoOMh8fgEiRUu2CJlB1mFe0PEaAzuONkT
         4WwL1hKy7zWBcwkc/m2dv6QUtcQoNgVEeTzNztEE=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, David Gibson <david@gibson.dropbear.id.au>,
        cohuck@redhat.com, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        pasic@linux.ibm.com
Subject: [for-6.0 v5 09/13] securable guest memory: Move SEV initialization into arch specific code
Date:   Fri,  4 Dec 2020 16:44:11 +1100
Message-Id: <20201204054415.579042-10-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201204054415.579042-1-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
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
---
 accel/kvm/kvm-all.c | 14 --------------
 target/i386/kvm.c   | 12 ++++++++++++
 target/i386/sev.c   |  7 ++++++-
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 724e9294d0..1b676da6c2 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2178,20 +2178,6 @@ static int kvm_init(MachineState *ms)
 
     kvm_state = s;
 
-    /*
-     * if memory encryption object is specified then initialize the memory
-     * encryption context.
-     */
-    if (ms->sgm) {
-        Error *local_err = NULL;
-        /* FIXME handle mechanisms other than SEV */
-        ret = sev_kvm_init(ms->sgm, &local_err);
-        if (ret < 0) {
-            error_report_err(local_err);
-            goto err;
-        }
-    }
-
     ret = kvm_arch_init(ms, s);
     if (ret < 0) {
         goto err;
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index a2934dda02..8e3617f3cd 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -42,6 +42,7 @@
 #include "hw/i386/intel_iommu.h"
 #include "hw/i386/x86-iommu.h"
 #include "hw/i386/e820_memory_layout.h"
+#include "sysemu/sev.h"
 
 #include "hw/pci/pci.h"
 #include "hw/pci/msi.h"
@@ -2110,6 +2111,17 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     uint64_t shadow_mem;
     int ret;
     struct utsname utsname;
+    Error *local_err = NULL;
+
+    /*
+     * if memory encryption object is specified then initialize the
+     * memory encryption context (no-op otherwise)
+     */
+    ret = sev_kvm_init(ms->sgm, &local_err);
+    if (ret < 0) {
+        error_report_err(local_err);
+        return ret;
+    }
 
     if (!kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
         error_report("kvm: KVM_CAP_IRQ_ROUTING not supported by KVM");
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 022ce5fc3a..8c19f4aea6 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -628,13 +628,18 @@ sev_vm_state_change(void *opaque, int running, RunState state)
 
 int sev_kvm_init(SecurableGuestMemory *sgm, Error **errp)
 {
-    SevGuestState *sev = SEV_GUEST(sgm);
+    SevGuestState *sev
+        = (SevGuestState *)object_dynamic_cast(OBJECT(sgm), TYPE_SEV_GUEST);
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
2.28.0

