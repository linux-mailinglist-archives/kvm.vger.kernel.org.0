Return-Path: <kvm+bounces-7022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 679ED83C7C1
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 17:20:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6309C1C23CFC
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 16:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F342F1292F3;
	Thu, 25 Jan 2024 16:20:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1146EB4A
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 16:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.28.154.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706199615; cv=none; b=Mp30JWRybpGJqLsVZMxX4nF46ROGiJGUkYIdwhJDGRzyFhUpoERVoX2e6jjV96uuNI0Vymn9b8MNLQli50uXqEJFNfsKu9uYOUUAxtLME4sbC56SeuwM1XUtgWU01PG6Z9Sm6AVWcqgWr9VnMZVSHhqNw7g/9G3FLL0iPnYr3xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706199615; c=relaxed/simple;
	bh=R++UGAsv8v6gU6sigjLZpQYu8a3guVkPaLJjcV7TN84=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EUsQl8iDNQop9Adcf4WZyCmvQT3BwRRMFB58g+/G5WKzyPr58dEtWNXUDWyJ0/n1kvH83pWPfUE8EIZyNKfw/39AeglYAfqGiJvCJSM3mTMLHU7VwuzonEIh3b383ga8KzIeuYrY9HpiuzEOWjdlajpCweI+utDO7ry706CM4/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=maciej.szmigiero.name; arc=none smtp.client-ip=37.28.154.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maciej.szmigiero.name
Received: from MUA
	by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <mail@maciej.szmigiero.name>)
	id 1rT2SK-0008LY-Lx; Thu, 25 Jan 2024 17:19:56 +0100
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH] vmbus: Print a warning when enabled without the recommended set of features
Date: Thu, 25 Jan 2024 17:19:50 +0100
Message-ID: <e2d961d56d795fe42ea54f1272c7157e40aeae1e.1706198618.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Some Windows versions crash at boot or fail to enable the VMBus device if
they don't see the expected set of Hyper-V features (enlightenments).

Since this provides poor user experience let's warn user if the VMBus
device is enabled without the recommended set of Hyper-V features.

The recommended set is the minimum set of Hyper-V features required to make
the VMBus device work properly in Windows Server versions 2016, 2019 and
2022.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 hw/hyperv/hyperv.c            | 12 ++++++++++++
 hw/hyperv/vmbus.c             |  6 ++++++
 include/hw/hyperv/hyperv.h    |  4 ++++
 target/i386/kvm/hyperv-stub.c |  4 ++++
 target/i386/kvm/hyperv.c      |  5 +++++
 target/i386/kvm/hyperv.h      |  2 ++
 target/i386/kvm/kvm.c         |  7 +++++++
 7 files changed, 40 insertions(+)

diff --git a/hw/hyperv/hyperv.c b/hw/hyperv/hyperv.c
index 57b402b95610..2c91de7ff4a8 100644
--- a/hw/hyperv/hyperv.c
+++ b/hw/hyperv/hyperv.c
@@ -947,3 +947,15 @@ uint64_t hyperv_syndbg_query_options(void)
 
     return msg.u.query_options.options;
 }
+
+static bool vmbus_recommended_features_enabled;
+
+bool hyperv_are_vmbus_recommended_features_enabled(void)
+{
+    return vmbus_recommended_features_enabled;
+}
+
+void hyperv_set_vmbus_recommended_features_enabled(void)
+{
+    vmbus_recommended_features_enabled = true;
+}
diff --git a/hw/hyperv/vmbus.c b/hw/hyperv/vmbus.c
index 380239af2c7b..f33afeeea27d 100644
--- a/hw/hyperv/vmbus.c
+++ b/hw/hyperv/vmbus.c
@@ -2631,6 +2631,12 @@ static void vmbus_bridge_realize(DeviceState *dev, Error **errp)
         return;
     }
 
+    if (!hyperv_are_vmbus_recommended_features_enabled()) {
+        warn_report("VMBus enabled without the recommended set of Hyper-V features: "
+                    "hv-stimer, hv-vapic and hv-runtime. "
+                    "Some Windows versions might not boot or enable the VMBus device");
+    }
+
     bridge->bus = VMBUS(qbus_new(TYPE_VMBUS, dev, "vmbus"));
 }
 
diff --git a/include/hw/hyperv/hyperv.h b/include/hw/hyperv/hyperv.h
index 015c3524b1c2..d717b4e13d40 100644
--- a/include/hw/hyperv/hyperv.h
+++ b/include/hw/hyperv/hyperv.h
@@ -139,4 +139,8 @@ typedef struct HvSynDbgMsg {
 } HvSynDbgMsg;
 typedef uint16_t (*HvSynDbgHandler)(void *context, HvSynDbgMsg *msg);
 void hyperv_set_syndbg_handler(HvSynDbgHandler handler, void *context);
+
+bool hyperv_are_vmbus_recommended_features_enabled(void);
+void hyperv_set_vmbus_recommended_features_enabled(void);
+
 #endif
diff --git a/target/i386/kvm/hyperv-stub.c b/target/i386/kvm/hyperv-stub.c
index 778ed782e6fc..3263dcf05d31 100644
--- a/target/i386/kvm/hyperv-stub.c
+++ b/target/i386/kvm/hyperv-stub.c
@@ -52,3 +52,7 @@ void hyperv_x86_synic_reset(X86CPU *cpu)
 void hyperv_x86_synic_update(X86CPU *cpu)
 {
 }
+
+void hyperv_x86_set_vmbus_recommended_features_enabled(void)
+{
+}
diff --git a/target/i386/kvm/hyperv.c b/target/i386/kvm/hyperv.c
index 6825c89af374..f2a3fe650a18 100644
--- a/target/i386/kvm/hyperv.c
+++ b/target/i386/kvm/hyperv.c
@@ -149,3 +149,8 @@ int kvm_hv_handle_exit(X86CPU *cpu, struct kvm_hyperv_exit *exit)
         return -1;
     }
 }
+
+void hyperv_x86_set_vmbus_recommended_features_enabled(void)
+{
+    hyperv_set_vmbus_recommended_features_enabled();
+}
diff --git a/target/i386/kvm/hyperv.h b/target/i386/kvm/hyperv.h
index 67543296c3a4..e3982c8f4dd1 100644
--- a/target/i386/kvm/hyperv.h
+++ b/target/i386/kvm/hyperv.h
@@ -26,4 +26,6 @@ int hyperv_x86_synic_add(X86CPU *cpu);
 void hyperv_x86_synic_reset(X86CPU *cpu);
 void hyperv_x86_synic_update(X86CPU *cpu);
 
+void hyperv_x86_set_vmbus_recommended_features_enabled(void);
+
 #endif
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index e88e65fe014c..d3d01b3cf82d 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1650,6 +1650,13 @@ static int hyperv_init_vcpu(X86CPU *cpu)
         }
     }
 
+    /* Skip SynIC and VP_INDEX since they are hard deps already */
+    if (hyperv_feat_enabled(cpu, HYPERV_FEAT_STIMER) &&
+        hyperv_feat_enabled(cpu, HYPERV_FEAT_VAPIC) &&
+        hyperv_feat_enabled(cpu, HYPERV_FEAT_RUNTIME)) {
+        hyperv_x86_set_vmbus_recommended_features_enabled();
+    }
+
     return 0;
 }
 

