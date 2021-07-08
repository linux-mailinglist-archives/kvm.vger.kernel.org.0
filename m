Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6FC3BF31B
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhGHA7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:59:05 -0400
Received: from mga14.intel.com ([192.55.52.115]:57295 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230244AbhGHA6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209239180"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209239180"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:58 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770108"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:58 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 36/44] hw/i386: add eoi_intercept_unsupported member to X86MachineState
Date:   Wed,  7 Jul 2021 17:55:06 -0700
Message-Id: <d6257e409d9da8e64f0a7d96f36db702d6071f23.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a new bool member, eoi_intercept_unsupported, to X86MachineState with
default value false.  Set true when tdx kvm type.  Inability to intercept
eoi causes impossibility to emulate level triggered interrupt to be
re-injected when level is still kept active.  which affects interrupt
controller emulation. Such new behavior will be introduced later.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 hw/i386/x86.c         | 1 +
 include/hw/i386/x86.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index ed15f6f2cf..9862fe5bc9 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1311,6 +1311,7 @@ static void x86_machine_initfn(Object *obj)
     x86ms->oem_id = g_strndup(ACPI_BUILD_APPNAME6, 6);
     x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
     x86ms->bus_lock_ratelimit = 0;
+    x86ms->eoi_intercept_unsupported = false;
 
     object_property_add_str(obj, "kvm-type",
                             x86_get_kvm_type, x86_set_kvm_type);
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index a450b5e226..6eff42550f 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -63,6 +63,7 @@ struct X86MachineState {
     unsigned pci_irq_mask;
     unsigned apic_id_limit;
     uint16_t boot_cpus;
+    bool eoi_intercept_unsupported;
 
     OnOffAuto smm;
     OnOffAuto acpi;
-- 
2.25.1

