Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1FE46F67E
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 23:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhLIWMw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 17:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhLIWMv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 17:12:51 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65607C0617A2
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 14:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=aF2VJz818y4HgBgf3CkuDSyw9YreBIt/kI+rCIY9Axk=; b=pd83DsM8isN2L7/F5QSmaEuF8w
        Cb72uwtBkx3wLjoJxWtntmtw3vlWCIQD3LoMV3uZkgm5+D45etOzfA7zmbtGEqdFyCMyAm0S+I7Vr
        b+bMWQr4naWZOfB6WQ9UzAtcCqasZdd3muv8LHwnS9AoaIN4AZ4m0lluZx1QMA+eSTCEimtM6Ervu
        8TG+R81UWgdBwL8ATQ27MndeLeU9tai/Eg8EP8i1ouSbEwd8STErcItqyiQTO9y4QEJe960w11DcP
        RbSVgEGQtk2nEN+UAEAmpq3d5AHOxBUn9bafB+bDbmRCU/mv/98/VJZl7dX1XGLRGAUGwtuJq4QIt
        i6Th7hDg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvRaj-000RNe-Aq; Thu, 09 Dec 2021 22:08:50 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvRai-0003su-UJ; Thu, 09 Dec 2021 22:08:40 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 1/4] target/i386: Fix sanity check on max APIC ID / X2APIC enablement
Date:   Thu,  9 Dec 2021 22:08:37 +0000
Message-Id: <20211209220840.14889-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The check on x86ms->apic_id_limit in pc_machine_done() had two problems.

Firstly, we need KVM to support the X2APIC API in order to allow IRQ
delivery to APICs >= 255. So we need to call/check kvm_enable_x2apic(),
which was done elsewhere in *some* cases but not all.

Secondly, microvm needs the same check. So move it from pc_machine_done()
to x86_cpus_init() where it will work for both.

The check in kvm_cpu_instance_init() is now redundant and can be dropped.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Claudio Fontana <cfontana@suse.de>
---
 hw/i386/pc.c              |  8 --------
 hw/i386/x86.c             | 16 ++++++++++++++++
 target/i386/kvm/kvm-cpu.c |  2 +-
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index a2ef40ecbc..9959f93216 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -736,14 +736,6 @@ void pc_machine_done(Notifier *notifier, void *data)
         /* update FW_CFG_NB_CPUS to account for -device added CPUs */
         fw_cfg_modify_i16(x86ms->fw_cfg, FW_CFG_NB_CPUS, x86ms->boot_cpus);
     }
-
-
-    if (x86ms->apic_id_limit > 255 && !xen_enabled() &&
-        !kvm_irqchip_in_kernel()) {
-        error_report("current -smp configuration requires kernel "
-                     "irqchip support.");
-        exit(EXIT_FAILURE);
-    }
 }
 
 void pc_guest_info_init(PCMachineState *pcms)
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index b84840a1bb..f64639b873 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -39,6 +39,7 @@
 #include "sysemu/replay.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/cpu-timers.h"
+#include "sysemu/xen.h"
 #include "trace.h"
 
 #include "hw/i386/x86.h"
@@ -136,6 +137,21 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
      */
     x86ms->apic_id_limit = x86_cpu_apic_id_from_index(x86ms,
                                                       ms->smp.max_cpus - 1) + 1;
+
+    /*
+     * Can we support APIC ID 255 or higher?
+     *
+     * Under Xen: yes.
+     * With userspace emulated lapic: no
+     * With KVM's in-kernel lapic: only if X2APIC API is enabled.
+     */
+    if (x86ms->apic_id_limit > 255 && !xen_enabled() &&
+        (!kvm_irqchip_in_kernel() || !kvm_enable_x2apic())) {
+        error_report("current -smp configuration requires kernel "
+                     "irqchip and X2APIC API support.");
+        exit(EXIT_FAILURE);
+    }
+
     possible_cpus = mc->possible_cpu_arch_ids(ms);
     for (i = 0; i < ms->smp.cpus; i++) {
         x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id, &error_fatal);
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index d95028018e..c60cb2dafb 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -165,7 +165,7 @@ static void kvm_cpu_instance_init(CPUState *cs)
         /* only applies to builtin_x86_defs cpus */
         if (!kvm_irqchip_in_kernel()) {
             x86_cpu_change_kvm_default("x2apic", "off");
-        } else if (kvm_irqchip_is_split() && kvm_enable_x2apic()) {
+        } else if (kvm_irqchip_is_split()) {
             x86_cpu_change_kvm_default("kvm-msi-ext-dest-id", "on");
         }
 
-- 
2.31.1

