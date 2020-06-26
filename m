Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCA020AD0B
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 09:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgFZHZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 03:25:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60693 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728754AbgFZHZD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 03:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593156301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QmNnecrT39lVR4Bp2/c3LMLoPQ+59/grE+6VbMTWmoQ=;
        b=VhiHc9Hy5kieJg25l7F+L5vaZoYA15oPVOv4zuzY9+ZIrW/Hrh7RoqCYbJdDrb2QrqcZgv
        Cs8lIgj0MQKoCgSD+ErwqMi1rbXpfBK/iI7E9L8xEa9Ke9MKqKNO2yNi9IG8JxLwo4wvOX
        ONoPsQN8zqfNHadCTyQrfb5hP6eHOMg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-KBLvVDFfOyqsur8TUK_7QQ-1; Fri, 26 Jun 2020 03:25:00 -0400
X-MC-Unique: KBLvVDFfOyqsur8TUK_7QQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8ED451800D4A;
        Fri, 26 Jun 2020 07:24:58 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-35.ams2.redhat.com [10.36.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0B151C8;
        Fri, 26 Jun 2020 07:24:52 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Sergio Lopez <slp@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "qemu-arm @ nongnu . org" <qemu-arm@nongnu.org>
Subject: [PATCH v5 21/21] numa: Auto-enable NUMA when any memory devices are possible
Date:   Fri, 26 Jun 2020 09:22:48 +0200
Message-Id: <20200626072248.78761-22-david@redhat.com>
In-Reply-To: <20200626072248.78761-1-david@redhat.com>
References: <20200626072248.78761-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's auto-enable it also when maxmem is specified but no slots are
defined. This will result in us properly creating ACPI srat tables,
indicating the maximum possible PFN to the guest OS. Based on this, e.g.,
Linux will enable the swiotlb properly.

This avoids having to manually force the switolb on (swiotlb=force) in
Linux in case we're booting only using DMA memory (e.g., 2GB on x86-64),
and virtio-mem adds memory later on that really needs the swiotlb to be
used for DMA.

Let's take care of backwards compatibility if somebody has a setup that
specifies "maxram" without "slots".

Reported-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Cc: Sergio Lopez <slp@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: qemu-arm@nongnu.org <qemu-arm@nongnu.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/arm/virt.c       |  2 ++
 hw/core/numa.c      | 11 ++++++-----
 hw/i386/microvm.c   |  1 +
 hw/i386/pc.c        |  1 +
 hw/i386/pc_piix.c   |  1 +
 hw/i386/pc_q35.c    |  1 +
 include/hw/boards.h |  1 +
 7 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 402c362c14..3865804681 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2323,6 +2323,7 @@ static void virt_machine_class_init(ObjectClass *oc, void *data)
     mc->numa_mem_supported = true;
     mc->nvdimm_supported = true;
     mc->auto_enable_numa_with_memhp = true;
+    mc->auto_enable_numa_with_memdev = true;
     mc->default_ram_id = "mach-virt.ram";
 
     object_class_property_add(oc, "acpi", "OnOffAuto",
@@ -2434,6 +2435,7 @@ static void virt_machine_5_0_options(MachineClass *mc)
 {
     virt_machine_5_1_options(mc);
     compat_props_add(mc->compat_props, hw_compat_5_0, hw_compat_5_0_len);
+    mc->auto_enable_numa_with_memdev = false;
 }
 DEFINE_VIRT_MACHINE(5, 0)
 
diff --git a/hw/core/numa.c b/hw/core/numa.c
index ca0b2e5fa7..a78fc4e59e 100644
--- a/hw/core/numa.c
+++ b/hw/core/numa.c
@@ -681,8 +681,9 @@ void numa_complete_configuration(MachineState *ms)
     NodeInfo *numa_info = ms->numa_state->nodes;
 
     /*
-     * If memory hotplug is enabled (slots > 0) but without '-numa'
-     * options explicitly on CLI, guestes will break.
+     * If memory hotplug is enabled (slot > 0) or memory devices are enabled
+     * (ms->maxram_size > ram_size) but without '-numa' options explicitly on
+     * CLI, guests will break.
      *
      *   Windows: won't enable memory hotplug without SRAT table at all
      *
@@ -697,9 +698,9 @@ void numa_complete_configuration(MachineState *ms)
      * assume there is just one node with whole RAM.
      */
     if (ms->numa_state->num_nodes == 0 &&
-        ((ms->ram_slots > 0 &&
-        mc->auto_enable_numa_with_memhp) ||
-        mc->auto_enable_numa)) {
+        ((ms->ram_slots && mc->auto_enable_numa_with_memhp) ||
+         (ms->maxram_size > ms->ram_size && mc->auto_enable_numa_with_memdev) ||
+         mc->auto_enable_numa)) {
             NumaNodeOptions node = { };
             parse_numa_node(ms, &node, &error_abort);
             numa_info[0].node_mem = ram_size;
diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index 5e931975a0..81d0888930 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -464,6 +464,7 @@ static void microvm_class_init(ObjectClass *oc, void *data)
     mc->max_cpus = 288;
     mc->has_hotpluggable_cpus = false;
     mc->auto_enable_numa_with_memhp = false;
+    mc->auto_enable_numa_with_memdev = false;
     mc->default_cpu_type = TARGET_DEFAULT_CPU_TYPE;
     mc->nvdimm_supported = false;
     mc->default_ram_id = "microvm.ram";
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index f2a18a3276..bc36a4efe7 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1975,6 +1975,7 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     mc->get_default_cpu_node_id = x86_get_default_cpu_node_id;
     mc->possible_cpu_arch_ids = x86_possible_cpu_arch_ids;
     mc->auto_enable_numa_with_memhp = true;
+    mc->auto_enable_numa_with_memdev = true;
     mc->has_hotpluggable_cpus = true;
     mc->default_boot_order = "cad";
     mc->hot_add_cpu = pc_hot_add_cpu;
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 1497d0e4ae..33f3b58f3d 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -443,6 +443,7 @@ static void pc_i440fx_5_0_machine_options(MachineClass *m)
     m->is_default = false;
     compat_props_add(m->compat_props, hw_compat_5_0, hw_compat_5_0_len);
     compat_props_add(m->compat_props, pc_compat_5_0, pc_compat_5_0_len);
+    m->auto_enable_numa_with_memdev = false;
 }
 
 DEFINE_I440FX_MACHINE(v5_0, "pc-i440fx-5.0", NULL,
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 46cd06524c..d831b3359a 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -371,6 +371,7 @@ static void pc_q35_5_0_machine_options(MachineClass *m)
     m->alias = NULL;
     compat_props_add(m->compat_props, hw_compat_5_0, hw_compat_5_0_len);
     compat_props_add(m->compat_props, pc_compat_5_0, pc_compat_5_0_len);
+    m->auto_enable_numa_with_memhp = false;
 }
 
 DEFINE_Q35_MACHINE(v5_0, "pc-q35-5.0", NULL,
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 18815d9be2..426ce5f625 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -207,6 +207,7 @@ struct MachineClass {
     const char **valid_cpu_types;
     strList *allowed_dynamic_sysbus_devices;
     bool auto_enable_numa_with_memhp;
+    bool auto_enable_numa_with_memdev;
     void (*numa_auto_assign_ram)(MachineClass *mc, NodeInfo *nodes,
                                  int nb_nodes, ram_addr_t size);
     bool ignore_boot_device_suffixes;
-- 
2.26.2

