Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1590B3C7450
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhGMQWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:22:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231406AbhGMQWM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 12:22:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626193162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QXdViAzEq38Sqbq/iRur/uisrvoTQffbtfxp63NLQtU=;
        b=OJ0LidJAaGqWOBb/OPQbpmFFE6lWB7JgyOtaZsc6oH9+xSnlbUvz/C9unhZpVAFWt63r4j
        vNAEbA1/u57Tto9T9ZzZrA0DygATnwFM+9kOgBkAq5aKVp2Riq2mpZKNLrR9K4pBdUvgYb
        JyWAojXPmWkt2GnFI+c7R1ATG+mjegA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-APn_u8i4OvSt74SbhVdVfw-1; Tue, 13 Jul 2021 12:19:20 -0400
X-MC-Unique: APn_u8i4OvSt74SbhVdVfw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 818291B2C984;
        Tue, 13 Jul 2021 16:19:19 +0000 (UTC)
Received: from localhost (ovpn-113-28.rdu2.redhat.com [10.10.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41FC619C44;
        Tue, 13 Jul 2021 16:19:19 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PULL 02/11] i386: hardcode supported eVMCS version to '1'
Date:   Tue, 13 Jul 2021 12:09:48 -0400
Message-Id: <20210713160957.3269017-3-ehabkost@redhat.com>
In-Reply-To: <20210713160957.3269017-1-ehabkost@redhat.com>
References: <20210713160957.3269017-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Currently, the only eVMCS version, supported by KVM (and described in TLFS)
is '1'. When Enlightened VMCS feature is enabled, QEMU takes the supported
eVMCS version range (from KVM_CAP_HYPERV_ENLIGHTENED_VMCS enablement) and
puts it to guest visible CPUIDs. When (and if) eVMCS ver.2 appears a
problem on migration is expected: it doesn't seem to be possible to migrate
from a host supporting eVMCS ver.2 to a host, which only support eVMCS
ver.1.

Hardcode eVMCS ver.1 as the result of 'hv-evmcs' enablement for now. Newer
eVMCS versions will have to have their own enablement options (e.g.
'hv-evmcs=2').

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>
Message-Id: <20210608120817.1325125-4-vkuznets@redhat.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 docs/hyperv.txt       |  2 +-
 target/i386/kvm/kvm.c | 39 +++++++++++++++++++++++++++++++++++----
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/docs/hyperv.txt b/docs/hyperv.txt
index a51953daa83..000638a2fd3 100644
--- a/docs/hyperv.txt
+++ b/docs/hyperv.txt
@@ -170,7 +170,7 @@ Recommended: hv-frequencies
 3.16. hv-evmcs
 ===============
 The enlightenment is nested specific, it targets Hyper-V on KVM guests. When
-enabled, it provides Enlightened VMCS feature to the guest. The feature
+enabled, it provides Enlightened VMCS version 1 feature to the guest. The feature
 implements paravirtualized protocol between L0 (KVM) and L1 (Hyper-V)
 hypervisors making L2 exits to the hypervisor faster. The feature is Intel-only.
 Note: some virtualization features (e.g. Posted Interrupts) are disabled when
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a85035492fb..02216b70311 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1409,6 +1409,21 @@ static int hyperv_fill_cpuids(CPUState *cs,
 static Error *hv_passthrough_mig_blocker;
 static Error *hv_no_nonarch_cs_mig_blocker;
 
+/* Checks that the exposed eVMCS version range is supported by KVM */
+static bool evmcs_version_supported(uint16_t evmcs_version,
+                                    uint16_t supported_evmcs_version)
+{
+    uint8_t min_version = evmcs_version & 0xff;
+    uint8_t max_version = evmcs_version >> 8;
+    uint8_t min_supported_version = supported_evmcs_version & 0xff;
+    uint8_t max_supported_version = supported_evmcs_version >> 8;
+
+    return (min_version >= min_supported_version) &&
+        (max_version <= max_supported_version);
+}
+
+#define DEFAULT_EVMCS_VERSION ((1 << 8) | 1)
+
 static int hyperv_init_vcpu(X86CPU *cpu)
 {
     CPUState *cs = CPU(cpu);
@@ -1488,17 +1503,33 @@ static int hyperv_init_vcpu(X86CPU *cpu)
     }
 
     if (hyperv_feat_enabled(cpu, HYPERV_FEAT_EVMCS)) {
-        uint16_t evmcs_version;
+        uint16_t evmcs_version = DEFAULT_EVMCS_VERSION;
+        uint16_t supported_evmcs_version;
 
         ret = kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_ENLIGHTENED_VMCS, 0,
-                                  (uintptr_t)&evmcs_version);
+                                  (uintptr_t)&supported_evmcs_version);
 
+        /*
+         * KVM is required to support EVMCS ver.1. as that's what 'hv-evmcs'
+         * option sets. Note: we hardcode the maximum supported eVMCS version
+         * to '1' as well so 'hv-evmcs' feature is migratable even when (and if)
+         * ver.2 is implemented. A new option (e.g. 'hv-evmcs=2') will then have
+         * to be added.
+         */
         if (ret < 0) {
-            fprintf(stderr, "Hyper-V %s is not supported by kernel\n",
-                    kvm_hyperv_properties[HYPERV_FEAT_EVMCS].desc);
+            error_report("Hyper-V %s is not supported by kernel",
+                         kvm_hyperv_properties[HYPERV_FEAT_EVMCS].desc);
             return ret;
         }
 
+        if (!evmcs_version_supported(evmcs_version, supported_evmcs_version)) {
+            error_report("eVMCS version range [%d..%d] is not supported by "
+                         "kernel (supported: [%d..%d])", evmcs_version & 0xff,
+                         evmcs_version >> 8, supported_evmcs_version & 0xff,
+                         supported_evmcs_version >> 8);
+            return -ENOTSUP;
+        }
+
         cpu->hyperv_nested[0] = evmcs_version;
     }
 
-- 
2.31.1

