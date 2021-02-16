Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831EF31C550
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 03:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhBPCPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 21:15:51 -0500
Received: from mga18.intel.com ([134.134.136.126]:63533 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhBPCPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 21:15:43 -0500
IronPort-SDR: 69LaTacoGnAk2Uzpm+LIPjXCO2+q8rVbUYu8arIbKSsg0lfKl1DRKx7knNyzJvQ8YG4a/n2mvZ
 GeGwtj/SdqjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="170454370"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="170454370"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:54 -0800
IronPort-SDR: gHmUyr11fBp2QtsyUExysJOR1o7DMdVzpPdWOdtiU41UT+vJ/ns3dagW289B7ehtoSVVSnZgza
 E0eJEnP6mlPg==
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="591705454"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:53 -0800
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 22/23] i386/tdx: Force x2apic mode and routing for TDs
Date:   Mon, 15 Feb 2021 18:13:18 -0800
Message-Id: <99972768126128546e54fca3445c9673a527b67f.1613188118.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX requires x2apic and "resets" vCPUs to have x2apic enabled.  Model
this in QEMU and unconditionally enable x2apic interrupt routing.

This fixes issues where interrupts from IRQFD would not get forwarded to
the guest due to KVM silently dropping the invalid routing entry.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 hw/intc/apic_common.c           | 12 ++++++++++++
 include/hw/i386/apic.h          |  1 +
 include/hw/i386/apic_internal.h |  1 +
 target/i386/kvm/tdx.c           |  7 +++++++
 4 files changed, 21 insertions(+)

diff --git a/hw/intc/apic_common.c b/hw/intc/apic_common.c
index 97dd96dffa..6a69027377 100644
--- a/hw/intc/apic_common.c
+++ b/hw/intc/apic_common.c
@@ -263,6 +263,15 @@ void apic_designate_bsp(DeviceState *dev, bool bsp)
     }
 }
 
+void apic_force_x2apic(DeviceState *dev)
+{
+    if (dev == NULL) {
+        return;
+    }
+
+    APIC_COMMON(dev)->force_x2apic = true;
+}
+
 static void apic_reset_common(DeviceState *dev)
 {
     APICCommonState *s = APIC_COMMON(dev);
@@ -271,6 +280,9 @@ static void apic_reset_common(DeviceState *dev)
 
     bsp = s->apicbase & MSR_IA32_APICBASE_BSP;
     s->apicbase = APIC_DEFAULT_ADDRESS | bsp | MSR_IA32_APICBASE_ENABLE;
+    if (s->force_x2apic) {
+        s->apicbase |= MSR_IA32_APICBASE_EXTD;
+    }
     s->id = s->initial_apic_id;
 
     apic_reset_irq_delivered();
diff --git a/include/hw/i386/apic.h b/include/hw/i386/apic.h
index da1d2fe155..7d05abd7e0 100644
--- a/include/hw/i386/apic.h
+++ b/include/hw/i386/apic.h
@@ -19,6 +19,7 @@ void apic_init_reset(DeviceState *s);
 void apic_sipi(DeviceState *s);
 void apic_poll_irq(DeviceState *d);
 void apic_designate_bsp(DeviceState *d, bool bsp);
+void apic_force_x2apic(DeviceState *d);
 int apic_get_highest_priority_irr(DeviceState *dev);
 
 /* pc.c */
diff --git a/include/hw/i386/apic_internal.h b/include/hw/i386/apic_internal.h
index c175e7e718..eda0b5a587 100644
--- a/include/hw/i386/apic_internal.h
+++ b/include/hw/i386/apic_internal.h
@@ -187,6 +187,7 @@ struct APICCommonState {
     DeviceState *vapic;
     hwaddr vapic_paddr; /* note: persistence via kvmvapic */
     bool legacy_instance_id;
+    bool force_x2apic;
 };
 
 typedef struct VAPICState {
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 007d33989b..b4bd157fe1 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -137,6 +137,11 @@ int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     tdx_caps->nr_cpuid_configs = TDX1_MAX_NR_CPUID_CONFIGS;
     tdx_ioctl(KVM_TDX_CAPABILITIES, 0, tdx_caps);
 
+    if (!kvm_enable_x2apic()) {
+        error_report("Failed to enable x2apic in KVM");
+        exit(1);
+    }
+
     qemu_add_machine_init_done_late_notifier(&tdx_machine_done_late_notify);
     return 0;
 }
@@ -279,6 +284,8 @@ void tdx_post_init_vcpu(CPUState *cpu)
 
     hob = tdx_get_hob_entry(tdx);
     _tdx_ioctl(cpu, KVM_TDX_INIT_VCPU, 0, (void *)hob->address);
+
+    apic_force_x2apic(X86_CPU(cpu)->apic_state);
 }
 
 static bool tdx_guest_get_debug(Object *obj, Error **errp)
-- 
2.17.1

