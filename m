Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996176797C6
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbjAXMVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbjAXMVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:21:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B16D458A9
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=65x0N/Pgk83nByRn/hoWTJZmDuQU9n/WLtbKJv30Kmg=;
        b=KefWz0jXxzAZ6e2NdHEP2BbZfRXjZwuW4yjUA1Bo6K+ZGT7f3HKvFPqlo9QT7osUjeWZd+
        1Fa3MX+Y4n3uGXEEBBB1We8L3uVMnIGGaVTmXP3ECWdwccN5+4y/JrEpNqjG1Mnv80nNSt
        SoG2Bk7C3WD+gk8JOfpg2nD6mjfmRPM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-pF2BmGmgMYy31s4jWn5X2g-1; Tue, 24 Jan 2023 07:19:51 -0500
X-MC-Unique: pF2BmGmgMYy31s4jWn5X2g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A23E38123AF;
        Tue, 24 Jan 2023 12:19:51 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B61282166B32;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id D5E2421E6880; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, kraxel@redhat.com, kwolf@redhat.com,
        hreitz@redhat.com, marcandre.lureau@redhat.com,
        dgilbert@redhat.com, mst@redhat.com, imammedo@redhat.com,
        ani@anisinha.ca, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        philmd@linaro.org, wangyanan55@huawei.com, jasowang@redhat.com,
        jiri@resnulli.us, berrange@redhat.com, thuth@redhat.com,
        quintela@redhat.com, stefanb@linux.vnet.ibm.com,
        stefanha@redhat.com, kvm@vger.kernel.org, qemu-block@nongnu.org
Subject: [PATCH 28/32] monitor: Move target-dependent HMP commands to hmp-cmds-target.c
Date:   Tue, 24 Jan 2023 13:19:42 +0100
Message-Id: <20230124121946.1139465-29-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Target-independent hmp_gpa2hva(), hmp_gpa2hpa() move along to stay
next to hmp_gva2gpa().

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 include/monitor/hmp-target.h |   6 +
 monitor/hmp-cmds-target.c    | 380 +++++++++++++++++++++++++++++++++++
 monitor/misc.c               | 350 --------------------------------
 monitor/meson.build          |   3 +-
 4 files changed, 388 insertions(+), 351 deletions(-)
 create mode 100644 monitor/hmp-cmds-target.c

diff --git a/include/monitor/hmp-target.h b/include/monitor/hmp-target.h
index 1891a19b21..d78e979f05 100644
--- a/include/monitor/hmp-target.h
+++ b/include/monitor/hmp-target.h
@@ -51,5 +51,11 @@ void hmp_info_local_apic(Monitor *mon, const QDict *qdict);
 void hmp_info_sev(Monitor *mon, const QDict *qdict);
 void hmp_info_sgx(Monitor *mon, const QDict *qdict);
 void hmp_info_via(Monitor *mon, const QDict *qdict);
+void hmp_memory_dump(Monitor *mon, const QDict *qdict);
+void hmp_physical_memory_dump(Monitor *mon, const QDict *qdict);
+void hmp_info_registers(Monitor *mon, const QDict *qdict);
+void hmp_gva2gpa(Monitor *mon, const QDict *qdict);
+void hmp_gpa2hva(Monitor *mon, const QDict *qdict);
+void hmp_gpa2hpa(Monitor *mon, const QDict *qdict);
 
 #endif /* MONITOR_HMP_TARGET_H */
diff --git a/monitor/hmp-cmds-target.c b/monitor/hmp-cmds-target.c
new file mode 100644
index 0000000000..0d3e84d960
--- /dev/null
+++ b/monitor/hmp-cmds-target.c
@@ -0,0 +1,380 @@
+/*
+ * Miscellaneous target-dependent HMP commands
+ *
+ * Copyright (c) 2003-2004 Fabrice Bellard
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to deal
+ * in the Software without restriction, including without limitation the rights
+ * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
+ * copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
+ * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
+ * THE SOFTWARE.
+ */
+
+#include "qemu/osdep.h"
+#include "disas/disas.h"
+#include "exec/address-spaces.h"
+#include "monitor/hmp-target.h"
+#include "monitor/monitor-internal.h"
+#include "qapi/error.h"
+#include "qapi/qmp/qdict.h"
+#include "sysemu/hw_accel.h"
+
+/* Set the current CPU defined by the user. Callers must hold BQL. */
+int monitor_set_cpu(Monitor *mon, int cpu_index)
+{
+    CPUState *cpu;
+
+    cpu = qemu_get_cpu(cpu_index);
+    if (cpu == NULL) {
+        return -1;
+    }
+    g_free(mon->mon_cpu_path);
+    mon->mon_cpu_path = object_get_canonical_path(OBJECT(cpu));
+    return 0;
+}
+
+/* Callers must hold BQL. */
+static CPUState *mon_get_cpu_sync(Monitor *mon, bool synchronize)
+{
+    CPUState *cpu = NULL;
+
+    if (mon->mon_cpu_path) {
+        cpu = (CPUState *) object_resolve_path_type(mon->mon_cpu_path,
+                                                    TYPE_CPU, NULL);
+        if (!cpu) {
+            g_free(mon->mon_cpu_path);
+            mon->mon_cpu_path = NULL;
+        }
+    }
+    if (!mon->mon_cpu_path) {
+        if (!first_cpu) {
+            return NULL;
+        }
+        monitor_set_cpu(mon, first_cpu->cpu_index);
+        cpu = first_cpu;
+    }
+    assert(cpu != NULL);
+    if (synchronize) {
+        cpu_synchronize_state(cpu);
+    }
+    return cpu;
+}
+
+CPUState *mon_get_cpu(Monitor *mon)
+{
+    return mon_get_cpu_sync(mon, true);
+}
+
+CPUArchState *mon_get_cpu_env(Monitor *mon)
+{
+    CPUState *cs = mon_get_cpu(mon);
+
+    return cs ? cs->env_ptr : NULL;
+}
+
+int monitor_get_cpu_index(Monitor *mon)
+{
+    CPUState *cs = mon_get_cpu_sync(mon, false);
+
+    return cs ? cs->cpu_index : UNASSIGNED_CPU_INDEX;
+}
+
+void hmp_info_registers(Monitor *mon, const QDict *qdict)
+{
+    bool all_cpus = qdict_get_try_bool(qdict, "cpustate_all", false);
+    int vcpu = qdict_get_try_int(qdict, "vcpu", -1);
+    CPUState *cs;
+
+    if (all_cpus) {
+        CPU_FOREACH(cs) {
+            monitor_printf(mon, "\nCPU#%d\n", cs->cpu_index);
+            cpu_dump_state(cs, NULL, CPU_DUMP_FPU);
+        }
+    } else {
+        cs = vcpu >= 0 ? qemu_get_cpu(vcpu) : mon_get_cpu(mon);
+
+        if (!cs) {
+            if (vcpu >= 0) {
+                monitor_printf(mon, "CPU#%d not available\n", vcpu);
+            } else {
+                monitor_printf(mon, "No CPU available\n");
+            }
+            return;
+        }
+
+        monitor_printf(mon, "\nCPU#%d\n", cs->cpu_index);
+        cpu_dump_state(cs, NULL, CPU_DUMP_FPU);
+    }
+}
+
+static void memory_dump(Monitor *mon, int count, int format, int wsize,
+                        hwaddr addr, int is_physical)
+{
+    int l, line_size, i, max_digits, len;
+    uint8_t buf[16];
+    uint64_t v;
+    CPUState *cs = mon_get_cpu(mon);
+
+    if (!cs && (format == 'i' || !is_physical)) {
+        monitor_printf(mon, "Can not dump without CPU\n");
+        return;
+    }
+
+    if (format == 'i') {
+        monitor_disas(mon, cs, addr, count, is_physical);
+        return;
+    }
+
+    len = wsize * count;
+    if (wsize == 1) {
+        line_size = 8;
+    } else {
+        line_size = 16;
+    }
+    max_digits = 0;
+
+    switch(format) {
+    case 'o':
+        max_digits = DIV_ROUND_UP(wsize * 8, 3);
+        break;
+    default:
+    case 'x':
+        max_digits = (wsize * 8) / 4;
+        break;
+    case 'u':
+    case 'd':
+        max_digits = DIV_ROUND_UP(wsize * 8 * 10, 33);
+        break;
+    case 'c':
+        wsize = 1;
+        break;
+    }
+
+    while (len > 0) {
+        if (is_physical) {
+            monitor_printf(mon, HWADDR_FMT_plx ":", addr);
+        } else {
+            monitor_printf(mon, TARGET_FMT_lx ":", (target_ulong)addr);
+        }
+        l = len;
+        if (l > line_size)
+            l = line_size;
+        if (is_physical) {
+            AddressSpace *as = cs ? cs->as : &address_space_memory;
+            MemTxResult r = address_space_read(as, addr,
+                                               MEMTXATTRS_UNSPECIFIED, buf, l);
+            if (r != MEMTX_OK) {
+                monitor_printf(mon, " Cannot access memory\n");
+                break;
+            }
+        } else {
+            if (cpu_memory_rw_debug(cs, addr, buf, l, 0) < 0) {
+                monitor_printf(mon, " Cannot access memory\n");
+                break;
+            }
+        }
+        i = 0;
+        while (i < l) {
+            switch(wsize) {
+            default:
+            case 1:
+                v = ldub_p(buf + i);
+                break;
+            case 2:
+                v = lduw_p(buf + i);
+                break;
+            case 4:
+                v = (uint32_t)ldl_p(buf + i);
+                break;
+            case 8:
+                v = ldq_p(buf + i);
+                break;
+            }
+            monitor_printf(mon, " ");
+            switch(format) {
+            case 'o':
+                monitor_printf(mon, "%#*" PRIo64, max_digits, v);
+                break;
+            case 'x':
+                monitor_printf(mon, "0x%0*" PRIx64, max_digits, v);
+                break;
+            case 'u':
+                monitor_printf(mon, "%*" PRIu64, max_digits, v);
+                break;
+            case 'd':
+                monitor_printf(mon, "%*" PRId64, max_digits, v);
+                break;
+            case 'c':
+                monitor_printc(mon, v);
+                break;
+            }
+            i += wsize;
+        }
+        monitor_printf(mon, "\n");
+        addr += l;
+        len -= l;
+    }
+}
+
+void hmp_memory_dump(Monitor *mon, const QDict *qdict)
+{
+    int count = qdict_get_int(qdict, "count");
+    int format = qdict_get_int(qdict, "format");
+    int size = qdict_get_int(qdict, "size");
+    target_long addr = qdict_get_int(qdict, "addr");
+
+    memory_dump(mon, count, format, size, addr, 0);
+}
+
+void hmp_physical_memory_dump(Monitor *mon, const QDict *qdict)
+{
+    int count = qdict_get_int(qdict, "count");
+    int format = qdict_get_int(qdict, "format");
+    int size = qdict_get_int(qdict, "size");
+    hwaddr addr = qdict_get_int(qdict, "addr");
+
+    memory_dump(mon, count, format, size, addr, 1);
+}
+
+void *gpa2hva(MemoryRegion **p_mr, hwaddr addr, uint64_t size, Error **errp)
+{
+    Int128 gpa_region_size;
+    MemoryRegionSection mrs = memory_region_find(get_system_memory(),
+                                                 addr, size);
+
+    if (!mrs.mr) {
+        error_setg(errp, "No memory is mapped at address 0x%" HWADDR_PRIx, addr);
+        return NULL;
+    }
+
+    if (!memory_region_is_ram(mrs.mr) && !memory_region_is_romd(mrs.mr)) {
+        error_setg(errp, "Memory at address 0x%" HWADDR_PRIx "is not RAM", addr);
+        memory_region_unref(mrs.mr);
+        return NULL;
+    }
+
+    gpa_region_size = int128_make64(size);
+    if (int128_lt(mrs.size, gpa_region_size)) {
+        error_setg(errp, "Size of memory region at 0x%" HWADDR_PRIx
+                   " exceeded.", addr);
+        memory_region_unref(mrs.mr);
+        return NULL;
+    }
+
+    *p_mr = mrs.mr;
+    return qemu_map_ram_ptr(mrs.mr->ram_block, mrs.offset_within_region);
+}
+
+void hmp_gpa2hva(Monitor *mon, const QDict *qdict)
+{
+    hwaddr addr = qdict_get_int(qdict, "addr");
+    Error *local_err = NULL;
+    MemoryRegion *mr = NULL;
+    void *ptr;
+
+    ptr = gpa2hva(&mr, addr, 1, &local_err);
+    if (local_err) {
+        error_report_err(local_err);
+        return;
+    }
+
+    monitor_printf(mon, "Host virtual address for 0x%" HWADDR_PRIx
+                   " (%s) is %p\n",
+                   addr, mr->name, ptr);
+
+    memory_region_unref(mr);
+}
+
+void hmp_gva2gpa(Monitor *mon, const QDict *qdict)
+{
+    target_ulong addr = qdict_get_int(qdict, "addr");
+    MemTxAttrs attrs;
+    CPUState *cs = mon_get_cpu(mon);
+    hwaddr gpa;
+
+    if (!cs) {
+        monitor_printf(mon, "No cpu\n");
+        return;
+    }
+
+    gpa  = cpu_get_phys_page_attrs_debug(cs, addr & TARGET_PAGE_MASK, &attrs);
+    if (gpa == -1) {
+        monitor_printf(mon, "Unmapped\n");
+    } else {
+        monitor_printf(mon, "gpa: %#" HWADDR_PRIx "\n",
+                       gpa + (addr & ~TARGET_PAGE_MASK));
+    }
+}
+
+#ifdef CONFIG_LINUX
+static uint64_t vtop(void *ptr, Error **errp)
+{
+    uint64_t pinfo;
+    uint64_t ret = -1;
+    uintptr_t addr = (uintptr_t) ptr;
+    uintptr_t pagesize = qemu_real_host_page_size();
+    off_t offset = addr / pagesize * sizeof(pinfo);
+    int fd;
+
+    fd = open("/proc/self/pagemap", O_RDONLY);
+    if (fd == -1) {
+        error_setg_errno(errp, errno, "Cannot open /proc/self/pagemap");
+        return -1;
+    }
+
+    /* Force copy-on-write if necessary.  */
+    qatomic_add((uint8_t *)ptr, 0);
+
+    if (pread(fd, &pinfo, sizeof(pinfo), offset) != sizeof(pinfo)) {
+        error_setg_errno(errp, errno, "Cannot read pagemap");
+        goto out;
+    }
+    if ((pinfo & (1ull << 63)) == 0) {
+        error_setg(errp, "Page not present");
+        goto out;
+    }
+    ret = ((pinfo & 0x007fffffffffffffull) * pagesize) | (addr & (pagesize - 1));
+
+out:
+    close(fd);
+    return ret;
+}
+
+void hmp_gpa2hpa(Monitor *mon, const QDict *qdict)
+{
+    hwaddr addr = qdict_get_int(qdict, "addr");
+    Error *local_err = NULL;
+    MemoryRegion *mr = NULL;
+    void *ptr;
+    uint64_t physaddr;
+
+    ptr = gpa2hva(&mr, addr, 1, &local_err);
+    if (local_err) {
+        error_report_err(local_err);
+        return;
+    }
+
+    physaddr = vtop(ptr, &local_err);
+    if (local_err) {
+        error_report_err(local_err);
+    } else {
+        monitor_printf(mon, "Host physical address for 0x%" HWADDR_PRIx
+                       " (%s) is 0x%" PRIx64 "\n",
+                       addr, mr->name, (uint64_t) physaddr);
+    }
+
+    memory_region_unref(mr);
+}
+#endif
diff --git a/monitor/misc.c b/monitor/misc.c
index 7a0ba35923..6764d4f49f 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -27,9 +27,7 @@
 #include "monitor/qdev.h"
 #include "exec/gdbstub.h"
 #include "net/slirp.h"
-#include "disas/disas.h"
 #include "qemu/log.h"
-#include "sysemu/hw_accel.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/device_tree.h"
 #include "qapi/qmp/qdict.h"
@@ -137,94 +135,6 @@ static void monitor_init_qmp_commands(void)
                          QCO_ALLOW_PRECONFIG, 0);
 }
 
-/* Set the current CPU defined by the user. Callers must hold BQL. */
-int monitor_set_cpu(Monitor *mon, int cpu_index)
-{
-    CPUState *cpu;
-
-    cpu = qemu_get_cpu(cpu_index);
-    if (cpu == NULL) {
-        return -1;
-    }
-    g_free(mon->mon_cpu_path);
-    mon->mon_cpu_path = object_get_canonical_path(OBJECT(cpu));
-    return 0;
-}
-
-/* Callers must hold BQL. */
-static CPUState *mon_get_cpu_sync(Monitor *mon, bool synchronize)
-{
-    CPUState *cpu = NULL;
-
-    if (mon->mon_cpu_path) {
-        cpu = (CPUState *) object_resolve_path_type(mon->mon_cpu_path,
-                                                    TYPE_CPU, NULL);
-        if (!cpu) {
-            g_free(mon->mon_cpu_path);
-            mon->mon_cpu_path = NULL;
-        }
-    }
-    if (!mon->mon_cpu_path) {
-        if (!first_cpu) {
-            return NULL;
-        }
-        monitor_set_cpu(mon, first_cpu->cpu_index);
-        cpu = first_cpu;
-    }
-    assert(cpu != NULL);
-    if (synchronize) {
-        cpu_synchronize_state(cpu);
-    }
-    return cpu;
-}
-
-CPUState *mon_get_cpu(Monitor *mon)
-{
-    return mon_get_cpu_sync(mon, true);
-}
-
-CPUArchState *mon_get_cpu_env(Monitor *mon)
-{
-    CPUState *cs = mon_get_cpu(mon);
-
-    return cs ? cs->env_ptr : NULL;
-}
-
-int monitor_get_cpu_index(Monitor *mon)
-{
-    CPUState *cs = mon_get_cpu_sync(mon, false);
-
-    return cs ? cs->cpu_index : UNASSIGNED_CPU_INDEX;
-}
-
-static void hmp_info_registers(Monitor *mon, const QDict *qdict)
-{
-    bool all_cpus = qdict_get_try_bool(qdict, "cpustate_all", false);
-    int vcpu = qdict_get_try_int(qdict, "vcpu", -1);
-    CPUState *cs;
-
-    if (all_cpus) {
-        CPU_FOREACH(cs) {
-            monitor_printf(mon, "\nCPU#%d\n", cs->cpu_index);
-            cpu_dump_state(cs, NULL, CPU_DUMP_FPU);
-        }
-    } else {
-        cs = vcpu >= 0 ? qemu_get_cpu(vcpu) : mon_get_cpu(mon);
-
-        if (!cs) {
-            if (vcpu >= 0) {
-                monitor_printf(mon, "CPU#%d not available\n", vcpu);
-            } else {
-                monitor_printf(mon, "No CPU available\n");
-            }
-            return;
-        }
-
-        monitor_printf(mon, "\nCPU#%d\n", cs->cpu_index);
-        cpu_dump_state(cs, NULL, CPU_DUMP_FPU);
-    }
-}
-
 static void hmp_info_sync_profile(Monitor *mon, const QDict *qdict)
 {
     int64_t max = qdict_get_try_int(qdict, "max", 10);
@@ -304,266 +214,6 @@ static void hmp_gdbserver(Monitor *mon, const QDict *qdict)
     }
 }
 
-static void memory_dump(Monitor *mon, int count, int format, int wsize,
-                        hwaddr addr, int is_physical)
-{
-    int l, line_size, i, max_digits, len;
-    uint8_t buf[16];
-    uint64_t v;
-    CPUState *cs = mon_get_cpu(mon);
-
-    if (!cs && (format == 'i' || !is_physical)) {
-        monitor_printf(mon, "Can not dump without CPU\n");
-        return;
-    }
-
-    if (format == 'i') {
-        monitor_disas(mon, cs, addr, count, is_physical);
-        return;
-    }
-
-    len = wsize * count;
-    if (wsize == 1) {
-        line_size = 8;
-    } else {
-        line_size = 16;
-    }
-    max_digits = 0;
-
-    switch(format) {
-    case 'o':
-        max_digits = DIV_ROUND_UP(wsize * 8, 3);
-        break;
-    default:
-    case 'x':
-        max_digits = (wsize * 8) / 4;
-        break;
-    case 'u':
-    case 'd':
-        max_digits = DIV_ROUND_UP(wsize * 8 * 10, 33);
-        break;
-    case 'c':
-        wsize = 1;
-        break;
-    }
-
-    while (len > 0) {
-        if (is_physical) {
-            monitor_printf(mon, HWADDR_FMT_plx ":", addr);
-        } else {
-            monitor_printf(mon, TARGET_FMT_lx ":", (target_ulong)addr);
-        }
-        l = len;
-        if (l > line_size)
-            l = line_size;
-        if (is_physical) {
-            AddressSpace *as = cs ? cs->as : &address_space_memory;
-            MemTxResult r = address_space_read(as, addr,
-                                               MEMTXATTRS_UNSPECIFIED, buf, l);
-            if (r != MEMTX_OK) {
-                monitor_printf(mon, " Cannot access memory\n");
-                break;
-            }
-        } else {
-            if (cpu_memory_rw_debug(cs, addr, buf, l, 0) < 0) {
-                monitor_printf(mon, " Cannot access memory\n");
-                break;
-            }
-        }
-        i = 0;
-        while (i < l) {
-            switch(wsize) {
-            default:
-            case 1:
-                v = ldub_p(buf + i);
-                break;
-            case 2:
-                v = lduw_p(buf + i);
-                break;
-            case 4:
-                v = (uint32_t)ldl_p(buf + i);
-                break;
-            case 8:
-                v = ldq_p(buf + i);
-                break;
-            }
-            monitor_printf(mon, " ");
-            switch(format) {
-            case 'o':
-                monitor_printf(mon, "%#*" PRIo64, max_digits, v);
-                break;
-            case 'x':
-                monitor_printf(mon, "0x%0*" PRIx64, max_digits, v);
-                break;
-            case 'u':
-                monitor_printf(mon, "%*" PRIu64, max_digits, v);
-                break;
-            case 'd':
-                monitor_printf(mon, "%*" PRId64, max_digits, v);
-                break;
-            case 'c':
-                monitor_printc(mon, v);
-                break;
-            }
-            i += wsize;
-        }
-        monitor_printf(mon, "\n");
-        addr += l;
-        len -= l;
-    }
-}
-
-static void hmp_memory_dump(Monitor *mon, const QDict *qdict)
-{
-    int count = qdict_get_int(qdict, "count");
-    int format = qdict_get_int(qdict, "format");
-    int size = qdict_get_int(qdict, "size");
-    target_long addr = qdict_get_int(qdict, "addr");
-
-    memory_dump(mon, count, format, size, addr, 0);
-}
-
-static void hmp_physical_memory_dump(Monitor *mon, const QDict *qdict)
-{
-    int count = qdict_get_int(qdict, "count");
-    int format = qdict_get_int(qdict, "format");
-    int size = qdict_get_int(qdict, "size");
-    hwaddr addr = qdict_get_int(qdict, "addr");
-
-    memory_dump(mon, count, format, size, addr, 1);
-}
-
-void *gpa2hva(MemoryRegion **p_mr, hwaddr addr, uint64_t size, Error **errp)
-{
-    Int128 gpa_region_size;
-    MemoryRegionSection mrs = memory_region_find(get_system_memory(),
-                                                 addr, size);
-
-    if (!mrs.mr) {
-        error_setg(errp, "No memory is mapped at address 0x%" HWADDR_PRIx, addr);
-        return NULL;
-    }
-
-    if (!memory_region_is_ram(mrs.mr) && !memory_region_is_romd(mrs.mr)) {
-        error_setg(errp, "Memory at address 0x%" HWADDR_PRIx "is not RAM", addr);
-        memory_region_unref(mrs.mr);
-        return NULL;
-    }
-
-    gpa_region_size = int128_make64(size);
-    if (int128_lt(mrs.size, gpa_region_size)) {
-        error_setg(errp, "Size of memory region at 0x%" HWADDR_PRIx
-                   " exceeded.", addr);
-        memory_region_unref(mrs.mr);
-        return NULL;
-    }
-
-    *p_mr = mrs.mr;
-    return qemu_map_ram_ptr(mrs.mr->ram_block, mrs.offset_within_region);
-}
-
-static void hmp_gpa2hva(Monitor *mon, const QDict *qdict)
-{
-    hwaddr addr = qdict_get_int(qdict, "addr");
-    Error *local_err = NULL;
-    MemoryRegion *mr = NULL;
-    void *ptr;
-
-    ptr = gpa2hva(&mr, addr, 1, &local_err);
-    if (local_err) {
-        error_report_err(local_err);
-        return;
-    }
-
-    monitor_printf(mon, "Host virtual address for 0x%" HWADDR_PRIx
-                   " (%s) is %p\n",
-                   addr, mr->name, ptr);
-
-    memory_region_unref(mr);
-}
-
-static void hmp_gva2gpa(Monitor *mon, const QDict *qdict)
-{
-    target_ulong addr = qdict_get_int(qdict, "addr");
-    MemTxAttrs attrs;
-    CPUState *cs = mon_get_cpu(mon);
-    hwaddr gpa;
-
-    if (!cs) {
-        monitor_printf(mon, "No cpu\n");
-        return;
-    }
-
-    gpa  = cpu_get_phys_page_attrs_debug(cs, addr & TARGET_PAGE_MASK, &attrs);
-    if (gpa == -1) {
-        monitor_printf(mon, "Unmapped\n");
-    } else {
-        monitor_printf(mon, "gpa: %#" HWADDR_PRIx "\n",
-                       gpa + (addr & ~TARGET_PAGE_MASK));
-    }
-}
-
-#ifdef CONFIG_LINUX
-static uint64_t vtop(void *ptr, Error **errp)
-{
-    uint64_t pinfo;
-    uint64_t ret = -1;
-    uintptr_t addr = (uintptr_t) ptr;
-    uintptr_t pagesize = qemu_real_host_page_size();
-    off_t offset = addr / pagesize * sizeof(pinfo);
-    int fd;
-
-    fd = open("/proc/self/pagemap", O_RDONLY);
-    if (fd == -1) {
-        error_setg_errno(errp, errno, "Cannot open /proc/self/pagemap");
-        return -1;
-    }
-
-    /* Force copy-on-write if necessary.  */
-    qatomic_add((uint8_t *)ptr, 0);
-
-    if (pread(fd, &pinfo, sizeof(pinfo), offset) != sizeof(pinfo)) {
-        error_setg_errno(errp, errno, "Cannot read pagemap");
-        goto out;
-    }
-    if ((pinfo & (1ull << 63)) == 0) {
-        error_setg(errp, "Page not present");
-        goto out;
-    }
-    ret = ((pinfo & 0x007fffffffffffffull) * pagesize) | (addr & (pagesize - 1));
-
-out:
-    close(fd);
-    return ret;
-}
-
-static void hmp_gpa2hpa(Monitor *mon, const QDict *qdict)
-{
-    hwaddr addr = qdict_get_int(qdict, "addr");
-    Error *local_err = NULL;
-    MemoryRegion *mr = NULL;
-    void *ptr;
-    uint64_t physaddr;
-
-    ptr = gpa2hva(&mr, addr, 1, &local_err);
-    if (local_err) {
-        error_report_err(local_err);
-        return;
-    }
-
-    physaddr = vtop(ptr, &local_err);
-    if (local_err) {
-        error_report_err(local_err);
-    } else {
-        monitor_printf(mon, "Host physical address for 0x%" HWADDR_PRIx
-                       " (%s) is 0x%" PRIx64 "\n",
-                       addr, mr->name, (uint64_t) physaddr);
-    }
-
-    memory_region_unref(mr);
-}
-#endif
-
 static void do_print(Monitor *mon, const QDict *qdict)
 {
     int format = qdict_get_int(qdict, "format");
diff --git a/monitor/meson.build b/monitor/meson.build
index 435d8abd06..795a271545 100644
--- a/monitor/meson.build
+++ b/monitor/meson.build
@@ -7,4 +7,5 @@ softmmu_ss.add(files(
 ))
 softmmu_ss.add([spice_headers, files('qmp-cmds.c')])
 
-specific_ss.add(when: 'CONFIG_SOFTMMU', if_true: [files('misc.c'), spice])
+specific_ss.add(when: 'CONFIG_SOFTMMU',
+		if_true: [files( 'hmp-cmds-target.c', 'misc.c'), spice])
-- 
2.39.0

