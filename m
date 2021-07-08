Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5143BF2FE
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhGHA6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:27077 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230121AbhGHA6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209381421"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209381421"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:53 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423769995"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:52 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 04/44] vl: Introduce machine_init_done_late notifier
Date:   Wed,  7 Jul 2021 17:54:34 -0700
Message-Id: <80ac3e382a248bac13662d4052d17c41f1c21e3a.1625704980.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Introduce a new notifier, machine_init_done_late, that is notified after
machine_init_done.  This will be used by TDX to generate the HOB for its
virtual firmware, which needs to be done after all guest memory has been
added, i.e. after machine_init_done notifiers have run.  Some code
registers memory by machine_init_done().

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 hw/core/machine.c       | 26 ++++++++++++++++++++++++++
 include/sysemu/sysemu.h |  2 ++
 2 files changed, 28 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index ffc076ae84..66c39cf72a 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1278,6 +1278,31 @@ void qemu_remove_machine_init_done_notifier(Notifier *notify)
     notifier_remove(notify);
 }
 
+static NotifierList machine_init_done_late_notifiers =
+    NOTIFIER_LIST_INITIALIZER(machine_init_done_late_notifiers);
+
+static bool machine_init_done_late;
+
+void qemu_add_machine_init_done_late_notifier(Notifier *notify)
+{
+    notifier_list_add(&machine_init_done_late_notifiers, notify);
+    if (machine_init_done_late) {
+        notify->notify(notify, NULL);
+    }
+}
+
+void qemu_remove_machine_init_done_late_notifier(Notifier *notify)
+{
+    notifier_remove(notify);
+}
+
+
+static void qemu_run_machine_init_done_late_notifiers(void)
+{
+    machine_init_done_late = true;
+    notifier_list_notify(&machine_init_done_late_notifiers, NULL);
+}
+
 void qdev_machine_creation_done(void)
 {
     cpu_synchronize_all_post_init();
@@ -1311,6 +1336,7 @@ void qdev_machine_creation_done(void)
     if (rom_check_and_register_reset() != 0) {
         exit(1);
     }
+    qemu_run_machine_init_done_late_notifiers();
 
     replay_start();
 
diff --git a/include/sysemu/sysemu.h b/include/sysemu/sysemu.h
index 8fae667172..d44f8cf778 100644
--- a/include/sysemu/sysemu.h
+++ b/include/sysemu/sysemu.h
@@ -19,6 +19,8 @@ void qemu_remove_exit_notifier(Notifier *notify);
 void qemu_run_machine_init_done_notifiers(void);
 void qemu_add_machine_init_done_notifier(Notifier *notify);
 void qemu_remove_machine_init_done_notifier(Notifier *notify);
+void qemu_add_machine_init_done_late_notifier(Notifier *notify);
+void qemu_remove_machine_init_done_late_notifier(Notifier *notify);
 
 void configure_rtc(QemuOpts *opts);
 
-- 
2.25.1

