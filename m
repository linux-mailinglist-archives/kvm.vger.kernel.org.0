Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004334804CD
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 22:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhL0VRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 16:17:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48264 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbhL0VRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 16:17:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B34661162
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 21:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0464C36AEC;
        Mon, 27 Dec 2021 21:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640639825;
        bh=tbsU5WM2/7sfTWA3R2CesoLJCU/BNsaWltw5ZW/N/wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwTP0H9zSsAWMrEX6rEx6GxsxQ7scxzIXrAErBb5sV3orqvsYjI11UvUxTePK4hSO
         s44HaL71Q5zmw0VRiRdtTYtQ9Wr6YvMVWFn++K0OTavShP11Kbd2il3WZWF/NEYAKY
         Se4+IysEjnqhg0jEO1C05ihiiRvfa70G+k5ejz7i+GCLtWVzlqoSTlpimFg3/KSZil
         AJOFtA8ZzJf52LbxHwnfxRmzm1Z3xFWYDxX8d2W+PwW8tnyytgKQzLc/oPvHPC/GLX
         tzGVCviMv+luuC5iEgVXpgPeL1XAHdAO7glvrmdjRHmlwgcvCLu1PTv5HaEC4/VM6J
         1sxxiVBtQd0eA==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n1xMd-00Ed4b-Uv; Mon, 27 Dec 2021 21:17:04 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: [PATCH v3 4/5] hw/arm/virt: Use the PA range to compute the memory map
Date:   Mon, 27 Dec 2021 21:16:41 +0000
Message-Id: <20211227211642.994461-5-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211227211642.994461-1-maz@kernel.org>
References: <20211227211642.994461-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, drjones@redhat.com, eric.auger@redhat.com, peter.maydell@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The highmem attribute is nothing but another way to express the
PA range of a VM. To support HW that has a smaller PA range then
what QEMU assumes, pass this PA range to the virt_set_memmap()
function, allowing it to correctly exclude highmem devices
if they are outside of the PA range.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 hw/arm/virt.c | 64 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 50 insertions(+), 14 deletions(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 84dd3b36fb..212079e7a6 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1660,10 +1660,10 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
     return arm_cpu_mp_affinity(idx, clustersz);
 }
 
-static void virt_set_memmap(VirtMachineState *vms)
+static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
 {
     MachineState *ms = MACHINE(vms);
-    hwaddr base, device_memory_base, device_memory_size;
+    hwaddr base, device_memory_base, device_memory_size, memtop;
     int i;
 
     vms->memmap = extended_memmap;
@@ -1678,11 +1678,9 @@ static void virt_set_memmap(VirtMachineState *vms)
         exit(EXIT_FAILURE);
     }
 
-    if (!vms->highmem &&
-        vms->memmap[VIRT_MEM].base + ms->maxram_size > 4 * GiB) {
-        error_report("highmem=off, but memory crosses the 4GiB limit\n");
-        exit(EXIT_FAILURE);
-    }
+    if (!vms->highmem)
+	    pa_bits = 32;
+
     /*
      * We compute the base of the high IO region depending on the
      * amount of initial and device memory. The device memory start/size
@@ -1695,7 +1693,12 @@ static void virt_set_memmap(VirtMachineState *vms)
     device_memory_size = ms->maxram_size - ms->ram_size + ms->ram_slots * GiB;
 
     /* Base address of the high IO region */
-    base = device_memory_base + ROUND_UP(device_memory_size, GiB);
+    memtop = base = device_memory_base + ROUND_UP(device_memory_size, GiB);
+    if (memtop > BIT_ULL(pa_bits)) {
+	    error_report("Addressing limited to %d bits, but memory exceeds it by %llu bytes\n",
+			 pa_bits, memtop - BIT_ULL(pa_bits));
+        exit(EXIT_FAILURE);
+    }
     if (base < device_memory_base) {
         error_report("maxmem/slots too huge");
         exit(EXIT_FAILURE);
@@ -1712,9 +1715,17 @@ static void virt_set_memmap(VirtMachineState *vms)
         vms->memmap[i].size = size;
         base += size;
     }
-    vms->highest_gpa = (vms->highmem ?
-                        base :
-                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
+
+    /*
+     * If base fits within pa_bits, all good. If it doesn't, limit it
+     * to the end of RAM, which is guaranteed to fit within pa_bits.
+     */
+    if (base <= BIT_ULL(pa_bits)) {
+        vms->highest_gpa = base - 1;
+    } else {
+        vms->highest_gpa = memtop - 1;
+    }
+
     if (device_memory_size > 0) {
         ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
         ms->device_memory->base = device_memory_base;
@@ -1905,12 +1916,38 @@ static void machvirt_init(MachineState *machine)
     unsigned int smp_cpus = machine->smp.cpus;
     unsigned int max_cpus = machine->smp.max_cpus;
 
+    possible_cpus = mc->possible_cpu_arch_ids(machine);
+
     /*
      * In accelerated mode, the memory map is computed earlier in kvm_type()
      * to create a VM with the right number of IPA bits.
      */
     if (!vms->memmap) {
-        virt_set_memmap(vms);
+        Object *cpuobj;
+        ARMCPU *armcpu;
+        int pa_bits;
+
+        /*
+         * Instanciate a temporary CPU object to find out about what
+         * we are about to deal with. Once this is done, get rid of
+         * the object.
+         */
+        cpuobj = object_new(possible_cpus->cpus[0].type);
+        armcpu = ARM_CPU(cpuobj);
+
+        if (object_property_get_bool(cpuobj, "aarch64", NULL)) {
+            pa_bits = arm_pamax(armcpu);
+        } else if (arm_feature(&armcpu->env, ARM_FEATURE_LPAE)) {
+            /* v7 with LPAE */
+            pa_bits = 40;
+        } else {
+            /* Anything else */
+            pa_bits = 32;
+        }
+
+        object_unref(cpuobj);
+
+        virt_set_memmap(vms, pa_bits);
     }
 
     /* We can probe only here because during property set
@@ -1992,7 +2029,6 @@ static void machvirt_init(MachineState *machine)
 
     create_fdt(vms);
 
-    possible_cpus = mc->possible_cpu_arch_ids(machine);
     assert(possible_cpus->len == max_cpus);
     for (n = 0; n < possible_cpus->len; n++) {
         Object *cpuobj;
@@ -2648,7 +2684,7 @@ static int virt_kvm_type(MachineState *ms, const char *type_str)
     max_vm_pa_size = kvm_arm_get_max_vm_ipa_size(ms, &fixed_ipa);
 
     /* we freeze the memory map to compute the highest gpa */
-    virt_set_memmap(vms);
+    virt_set_memmap(vms, max_vm_pa_size);
 
     requested_pa_size = 64 - clz64(vms->highest_gpa);
 
-- 
2.30.2

