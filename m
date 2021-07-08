Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5426E3BF318
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhGHA7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:59:02 -0400
Received: from mga03.intel.com ([134.134.136.65]:19087 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230262AbhGHA6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209462014"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209462014"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:58 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770101"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:58 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 34/44] target/i386/tdx: set reboot action to shutdown when tdx
Date:   Wed,  7 Jul 2021 17:55:04 -0700
Message-Id: <d1afced8a92c01367d0aed7c6f82659c9bf79956.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

In TDX CPU state is also protected, thus vcpu state can't be reset by VMM.
It assumes -action reboot=shutdown instead of silently ignoring vcpu reset.

TDX module spec version 344425-002US doesn't support vcpu reset by VMM.  VM
needs to be destroyed and created again to emulate REBOOT_ACTION_RESET.
For simplicity, put its responsibility to management system like libvirt
because it's difficult for the current qemu implementation to destroy and
re-create KVM VM resources with keeping other resources.

If management system wants reboot behavior for its users, it needs to
 - set reboot_action to REBOOT_ACTION_SHUTDOWN,
 - set shutdown_action to SHUTDOWN_ACTION_PAUSE optionally and,
 - subscribe VM state change and on reboot, (destroy qemu if
   SHUTDOWN_ACTION_PAUSE and) start new qemu.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 target/i386/kvm/tdx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 1316d95209..0621317b0a 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -25,6 +25,7 @@
 #include "qapi/qapi-types-misc-target.h"
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/sysemu.h"
+#include "sysemu/runstate-action.h"
 #include "sysemu/kvm.h"
 #include "sysemu/kvm_int.h"
 #include "sysemu/tdx.h"
@@ -363,6 +364,19 @@ static void tdx_guest_init(Object *obj)
 
     qemu_mutex_init(&tdx->lock);
 
+    /*
+     * TDX module spec version 344425-002US doesn't support reset of vcpu by
+     * VMM.  VM needs to be destroyed and created again to emulate
+     * REBOOT_ACTION_RESET.  For simplicity, put its responsibility to
+     * management system like libvirt.
+     *
+     * Management system should
+     *  - set reboot_action to REBOOT_ACTION_SHUTDOWN
+     *  - set shutdown_action to SHUTDOWN_ACTION_PAUSE
+     *  - subscribe VM state and on reboot, destroy qemu and start new qemu
+     */
+    reboot_action = REBOOT_ACTION_SHUTDOWN;
+
     tdx->debug = false;
     object_property_add_bool(obj, "debug", tdx_guest_get_debug,
                              tdx_guest_set_debug);
-- 
2.25.1

