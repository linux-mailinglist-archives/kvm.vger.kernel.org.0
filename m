Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E493487A6E
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 17:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240148AbiAGQeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 11:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348282AbiAGQeB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 11:34:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C388C06173E
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 08:34:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED6F961F0F
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 16:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5906AC36AEF;
        Fri,  7 Jan 2022 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641573240;
        bh=kMM7H7e4NWLd0x88NZ2XUsacDPPAG7dNUs5nG4cFy6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHw6j0Fmtwgf0fsoAKqeeev5KP1Kx5Ez6QYDIastpIs0OPQ/U5MDIa7SxXm2Qi64e
         F01tAVyiJAD6VQApcrpDI3NCMHnHNXkQhSmsqaOTvdSKaOVF23gZLXtiWycKSJD1lZ
         O7ieBBmsDhvRUrumSKQ9OAJGvDdLb7kxDY0pIo8gY1EORSbjRunN23lBoU147IvwsZ
         qCotKK+8KcYYHevCfs0N5r/3J+fC04C66Mp1aOm2wayylKcqDRxtlDVIy1WQnsCebS
         q1BQtmTaZpvjDOcLDyk1GlmMeU1IwYv9+NM8hPUpFT4Pfro6UIKxI7haTSDj2h1VXL
         Rcompvy7sa3fA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n5sBi-00GbiJ-F6; Fri, 07 Jan 2022 16:33:58 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v4 2/6] hw/arm/virt: Add a control for the the highmem redistributors
Date:   Fri,  7 Jan 2022 16:33:20 +0000
Message-Id: <20220107163324.2491209-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220107163324.2491209-1-maz@kernel.org>
References: <20220107163324.2491209-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com, drjones@redhat.com, eric.auger@redhat.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just like we can control the enablement of the highmem PCIe region
using highmem_ecam, let's add a control for the highmem GICv3
redistributor region.

Similarily to highmem_ecam, these redistributors are disabled when
highmem is off.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 hw/arm/virt-acpi-build.c | 2 ++
 hw/arm/virt.c            | 2 ++
 include/hw/arm/virt.h    | 4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index cdac009419..505c61e88e 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -946,6 +946,8 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
     acpi_add_table(table_offsets, tables_blob);
     build_fadt_rev5(tables_blob, tables->linker, vms, dsdt);
 
+    vms->highmem_redists &= vms->highmem;
+
     acpi_add_table(table_offsets, tables_blob);
     build_madt(tables_blob, tables->linker, vms);
 
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index b9ce81f4a1..4d1d629432 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2106,6 +2106,7 @@ static void machvirt_init(MachineState *machine)
     virt_flash_fdt(vms, sysmem, secure_sysmem ?: sysmem);
 
     vms->highmem_mmio &= vms->highmem;
+    vms->highmem_redists &= vms->highmem;
 
     create_gic(vms, sysmem);
 
@@ -2805,6 +2806,7 @@ static void virt_instance_init(Object *obj)
 
     vms->highmem_ecam = !vmc->no_highmem_ecam;
     vms->highmem_mmio = true;
+    vms->highmem_redists = true;
 
     if (vmc->no_its) {
         vms->its = false;
diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
index 9c54acd10d..dc9fa26faa 100644
--- a/include/hw/arm/virt.h
+++ b/include/hw/arm/virt.h
@@ -144,6 +144,7 @@ struct VirtMachineState {
     bool highmem;
     bool highmem_ecam;
     bool highmem_mmio;
+    bool highmem_redists;
     bool its;
     bool tcg_its;
     bool virt;
@@ -190,7 +191,8 @@ static inline int virt_gicv3_redist_region_count(VirtMachineState *vms)
 
     assert(vms->gic_version == VIRT_GIC_VERSION_3);
 
-    return MACHINE(vms)->smp.cpus > redist0_capacity ? 2 : 1;
+    return (MACHINE(vms)->smp.cpus > redist0_capacity &&
+            vms->highmem_redists) ? 2 : 1;
 }
 
 #endif /* QEMU_ARM_VIRT_H */
-- 
2.30.2

