Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF96F4804D0
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 22:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhL0VRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 16:17:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59208 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbhL0VRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 16:17:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD6D6B8113E
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 21:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA8CC36AEB;
        Mon, 27 Dec 2021 21:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640639825;
        bh=w5B4FKdW6ZAej5mWLvSTvLKVvqcT8OfEspAdnpMgodU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFJU9ao/gRvD3WtN4AQ4a4VApKXJ7FVoiJ0gOoyd/f8Ze3Xv67biNZ7oAbW/+ZQ8M
         U6Vaed+H/bMa8MBI0+ba2frwPBGPynD2oKBkI4SyOYRFu1vADnn4B5pcwzQ9RUpK7G
         0Q1hAjX8wnbLuP5bCYeLEIBOoqbTHm6A/aY1/XHkEQ8QTyRs3asMXAHhbnniKl/6GU
         ln7qqpG85/RdcOazfQLLcAx8jgOkuYHwSjiy4uYfg4Q+JYUljQtdesZYS0HBU1NCZM
         LxiYUA7gQ3RGIxvKMpjczvmeRweb36fSILBeH9HHY26eRGiJnDvpapplB1hVMYY1ly
         W+YIn9l1URzmw==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n1xMd-00Ed4b-IW; Mon, 27 Dec 2021 21:17:03 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: [PATCH v3 2/5] hw/arm/virt: Add a control for the the highmem redistributors
Date:   Mon, 27 Dec 2021 21:16:39 +0000
Message-Id: <20211227211642.994461-3-maz@kernel.org>
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

Just like we can control the enablement of the highmem PCIe region
using highmem_ecam, let's add a control for the highmem GICv3
redistributor region.

Similarily to highmem_ecam, these redistributors are disabled when
highmem is off.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 hw/arm/virt-acpi-build.c | 2 ++
 hw/arm/virt.c            | 3 +++
 include/hw/arm/virt.h    | 4 +++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index d04c107fd8..fcbff9d835 100644
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
index a54dc43175..8b600d82c1 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2105,6 +2105,8 @@ static void machvirt_init(MachineState *machine)
 
     virt_flash_fdt(vms, sysmem, secure_sysmem ?: sysmem);
 
+    vms->highmem_redists &= vms->highmem;
+
     create_gic(vms, sysmem);
 
     virt_cpu_post_init(vms, sysmem);
@@ -2802,6 +2804,7 @@ static void virt_instance_init(Object *obj)
     vms->gic_version = VIRT_GIC_VERSION_NOSEL;
 
     vms->highmem_ecam = !vmc->no_highmem_ecam;
+    vms->highmem_redists = true;
 
     if (vmc->no_its) {
         vms->its = false;
diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
index dc6b66ffc8..726623a176 100644
--- a/include/hw/arm/virt.h
+++ b/include/hw/arm/virt.h
@@ -143,6 +143,7 @@ struct VirtMachineState {
     bool secure;
     bool highmem;
     bool highmem_ecam;
+    bool highmem_redists;
     bool its;
     bool tcg_its;
     bool virt;
@@ -189,7 +190,8 @@ static inline int virt_gicv3_redist_region_count(VirtMachineState *vms)
 
     assert(vms->gic_version == VIRT_GIC_VERSION_3);
 
-    return MACHINE(vms)->smp.cpus > redist0_capacity ? 2 : 1;
+    return (MACHINE(vms)->smp.cpus > redist0_capacity &&
+            vms->highmem_redists) ? 2 : 1;
 }
 
 #endif /* QEMU_ARM_VIRT_H */
-- 
2.30.2

