Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4B731C54F
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 03:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhBPCPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 21:15:50 -0500
Received: from mga06.intel.com ([134.134.136.31]:39372 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229870AbhBPCPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 21:15:36 -0500
IronPort-SDR: w0AE0MylSR8IYOc3R9MpYr8fCmwAs7gLFh5G/5IcUYRmRg9POyLXg2ghIaO8lTuMtDJP3ICJOL
 pD+rlQguwJ3w==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="244270198"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="244270198"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:51 -0800
IronPort-SDR: zEGjoawRi3ZRt6P5+XDlIjzOIGmlJirgA/g3GJrfQJ+woyXLSpWUkOjJoaBNU+nSjY55lvJ7P/
 +sik905utNdw==
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="591705395"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:50 -0800
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH 05/23] vl: Introduce machine_init_done_late notifier
Date:   Mon, 15 Feb 2021 18:13:01 -0800
Message-Id: <296dce1bb111d76de6c9ea86c705bed7e20b13dd.1613188118.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new notifier, machine_init_done_late, that is notified after
machine_init_done.  This will be used by TDX to generate the HOB for its
virtual firmware, which needs to be done after all guest memory has been
added, i.e. after machine_init_done notifiers have run.
some devices adds/updates memory region by machine_init_done notifier.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 hw/core/machine.c       | 26 ++++++++++++++++++++++++++
 include/sysemu/sysemu.h |  2 ++
 2 files changed, 28 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 970046f438..02be08f3d1 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1231,6 +1231,31 @@ void qemu_remove_machine_init_done_notifier(Notifier *notify)
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
@@ -1264,6 +1289,7 @@ void qdev_machine_creation_done(void)
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
2.17.1

