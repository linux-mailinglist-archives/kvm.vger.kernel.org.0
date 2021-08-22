Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AF13F401A
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbhHVOpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232402AbhHVOpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:45:42 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79DF0610A3;
        Sun, 22 Aug 2021 14:45:01 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mHoiZ-006VES-TM; Sun, 22 Aug 2021 15:44:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: [PATCH 2/3] hw/arm/virt: Honor highmem setting when computing highest_gpa
Date:   Sun, 22 Aug 2021 15:44:40 +0100
Message-Id: <20210822144441.1290891-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210822144441.1290891-1-maz@kernel.org>
References: <20210822144441.1290891-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, drjones@redhat.com, eric.auger@redhat.com, peter.maydell@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even when the VM is configured with highmem=off, the highest_gpa
field includes devices that are above the 4GiB limit, which is
what highmem=off is supposed to enforce. This leads to failures
in virt_kvm_type() on systems that have a crippled IPA range,
as the reported IPA space is larger than what it should be.

Instead, honor the user-specified limit to only use the devices
at the lowest end of the spectrum.

Note that this doesn't affect memory, which is still allowed to
go beyond 4GiB with highmem=on configurations.

Cc: Andrew Jones <drjones@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 hw/arm/virt.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 81eda46b0b..bc189e30b8 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1598,7 +1598,7 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
 static void virt_set_memmap(VirtMachineState *vms)
 {
     MachineState *ms = MACHINE(vms);
-    hwaddr base, device_memory_base, device_memory_size;
+    hwaddr base, device_memory_base, device_memory_size, ceiling;
     int i;
 
     vms->memmap = extended_memmap;
@@ -1625,7 +1625,7 @@ static void virt_set_memmap(VirtMachineState *vms)
     device_memory_size = ms->maxram_size - ms->ram_size + ms->ram_slots * GiB;
 
     /* Base address of the high IO region */
-    base = device_memory_base + ROUND_UP(device_memory_size, GiB);
+    ceiling = base = device_memory_base + ROUND_UP(device_memory_size, GiB);
     if (base < device_memory_base) {
         error_report("maxmem/slots too huge");
         exit(EXIT_FAILURE);
@@ -1642,7 +1642,11 @@ static void virt_set_memmap(VirtMachineState *vms)
         vms->memmap[i].size = size;
         base += size;
     }
-    vms->highest_gpa = base - 1;
+    if (vms->highmem) {
+	    /* If we have highmem, move the IPA limit to the top */
+	    ceiling = base;
+    }
+    vms->highest_gpa = ceiling - 1;
     if (device_memory_size > 0) {
         ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
         ms->device_memory->base = device_memory_base;
-- 
2.30.2

