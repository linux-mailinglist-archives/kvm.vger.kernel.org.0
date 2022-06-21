Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CAD55371C
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353523AbiFUQAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 12:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353515AbiFUP7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:59:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8CB092CE18
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655827163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UjEldryvLCy/WHpx7p0LM+I4QvjiWXCdE7G7gkYSdrY=;
        b=ECbfGC3gCSl7+qTSvX8x9/A9xE4LGCgpKnWkQO4gcXp7v/J0ANeqdSHrZTkjtyYvM9zEJC
        ODnwhq+iUT3cSa6iHP+G0Se4TMryjEyHKp2K9nIIXGnJfq/NNMLM8Asx7K7gwI2nSeXXrm
        RrDYU0vwCKEiAsUvBGK568yCN9vsuKw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-7WDh9h20MUqEuFWu4B56Lw-1; Tue, 21 Jun 2022 11:59:17 -0400
X-MC-Unique: 7WDh9h20MUqEuFWu4B56Lw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F38D8956A5;
        Tue, 21 Jun 2022 15:59:15 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 715E72026D07;
        Tue, 21 Jun 2022 15:59:13 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH QEMU EXAMPLE] i386: Support Enlightened VMCS revisions
Date:   Tue, 21 Jun 2022 17:59:12 +0200
Message-Id: <20220621155912.60245-1-vkuznets@redhat.com>
In-Reply-To: <20220621155830.60115-1-vkuznets@redhat.com>
References: <20220621155830.60115-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 docs/system/i386/hyperv.rst |  4 ++++
 linux-headers/linux/kvm.h   |  3 ++-
 target/i386/cpu.c           |  1 +
 target/i386/cpu.h           |  1 +
 target/i386/kvm/kvm.c       | 17 ++++++++++++++---
 5 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/docs/system/i386/hyperv.rst b/docs/system/i386/hyperv.rst
index 2505dc4c86e0..967acc6814f6 100644
--- a/docs/system/i386/hyperv.rst
+++ b/docs/system/i386/hyperv.rst
@@ -278,6 +278,10 @@ Supplementary features
   feature alters this behavior and only allows the guest to use exposed Hyper-V
   enlightenments.
 
+``hv-evmcs-rev={revision}``
+  When Enlightened VMCS definitinon changes, KVM increases the supported
+  'revision' to make live migration to older hosts possible. Note:
+ ``hv-passthrough`` mode enables the latest supported revision.
 
 Useful links
 ------------
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 0d05d02ee4fe..425ec0d636df 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1097,7 +1097,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_NESTED_HV 160
 #define KVM_CAP_HYPERV_SEND_IPI 161
 #define KVM_CAP_COALESCED_PIO 162
-#define KVM_CAP_HYPERV_ENLIGHTENED_VMCS 163
+#define KVM_CAP_HYPERV_ENLIGHTENED_VMCS 163 /* Obsolete */
 #define KVM_CAP_EXCEPTION_PAYLOAD 164
 #define KVM_CAP_ARM_VM_IPA_SIZE 165
 #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166 /* Obsolete */
@@ -1150,6 +1150,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DISABLE_QUIRKS2 213
 /* #define KVM_CAP_VM_TSC_CONTROL 214 */
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
+#define KVM_CAP_HYPERV_ENLIGHTENED_VMCS2 220
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6a57ef13af86..0d8b43f570f8 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6994,6 +6994,7 @@ static Property x86_cpu_properties[] = {
                       HYPERV_FEAT_SYNDBG, 0),
     DEFINE_PROP_BOOL("hv-passthrough", X86CPU, hyperv_passthrough, false),
     DEFINE_PROP_BOOL("hv-enforce-cpuid", X86CPU, hyperv_enforce_cpuid, false),
+    DEFINE_PROP_UINT32("hv-evmcs-rev", X86CPU, hyperv_evmcs_rev, 1),
 
     /* WS2008R2 identify by default */
     DEFINE_PROP_UINT32("hv-version-id-build", X86CPU, hyperv_ver_id_build,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 82004b65b944..d7a069703943 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1805,6 +1805,7 @@ struct ArchCPU {
     uint64_t hyperv_features;
     bool hyperv_passthrough;
     OnOffAuto hyperv_no_nonarch_cs;
+    uint32_t hyperv_evmcs_rev;
     uint32_t hyperv_vendor_id[3];
     uint32_t hyperv_interface_id[4];
     uint32_t hyperv_limits[3];
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index e5331662b63b..490fa4582f8c 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1635,9 +1635,20 @@ static int hyperv_init_vcpu(X86CPU *cpu)
     if (hyperv_feat_enabled(cpu, HYPERV_FEAT_EVMCS)) {
         uint16_t evmcs_version = DEFAULT_EVMCS_VERSION;
         uint16_t supported_evmcs_version;
-
-        ret = kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_ENLIGHTENED_VMCS, 0,
-                                  (uintptr_t)&supported_evmcs_version);
+        uint32_t evmcs_revision =
+            cpu->hyperv_passthrough ? UINT32_MAX : cpu->hyperv_evmcs_rev;
+
+        if (kvm_check_extension(cs->kvm_state,
+                                KVM_CAP_HYPERV_ENLIGHTENED_VMCS2)) {
+            ret = kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_ENLIGHTENED_VMCS2, 0,
+                                      evmcs_revision,
+                                      (uintptr_t)&supported_evmcs_version);
+        } else if (cpu->hyperv_evmcs_rev == 1) {
+            ret = kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_ENLIGHTENED_VMCS, 0,
+                                      (uintptr_t)&supported_evmcs_version);
+        } else {
+            ret = -ENOTSUP;
+        }
 
         /*
          * KVM is required to support EVMCS ver.1. as that's what 'hv-evmcs'
-- 
2.35.3

