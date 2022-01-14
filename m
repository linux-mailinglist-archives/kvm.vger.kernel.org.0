Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067AD48EB39
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 15:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241348AbiANOIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 09:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241319AbiANOIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 09:08:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF49AC061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 06:08:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D98461685
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 14:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE03FC36AEB;
        Fri, 14 Jan 2022 14:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642169285;
        bh=J8p1oxs0nGeqlmSeGlBKYJ/X1YzIZyUNxK+ulWeNgNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzZVZG9r6kp9C6WrM852w7CrdnR6PIprAum1ZCKr0ha8doJG/DgXpTaYYZ0ZtnZW3
         41xEFtpcFW1krQaIQbsnj1NAKlXC1WQWY4x+CYGp9g3DyhBrOZNpoHgrc3FkN3MDM4
         UUYcZgX0GrXnyqNqx5gqO7Cim7kxJBfflirfHXE2SAZHfjz37bSizl4vafFsBP9Un+
         5UtOWZaZbIK/EWChdDNwauT2H1trmipqL76O0exnWk49lhTEhOxaq09xe+T/+rWKDR
         e94FsetCYNweu5D01zuU+AG5oOcZoUWKq2kFvSQj1rFHyMfg5KS/BB/N/NxYNLBGnb
         JOhLLzyvpDe7A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n8NFL-000V8K-4r; Fri, 14 Jan 2022 14:08:03 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: [PATCH v5 2/6] hw/arm/virt: Add a control for the the highmem redistributors
Date:   Fri, 14 Jan 2022 14:07:37 +0000
Message-Id: <20220114140741.1358263-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220114140741.1358263-1-maz@kernel.org>
References: <20220114140741.1358263-1-maz@kernel.org>
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
 hw/arm/virt.c            | 2 ++
 include/hw/arm/virt.h    | 4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index 449fab0080..0757c28f69 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -947,6 +947,8 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
     acpi_add_table(table_offsets, tables_blob);
     build_fadt_rev5(tables_blob, tables->linker, vms, dsdt);
 
+    vms->highmem_redists &= vms->highmem;
+
     acpi_add_table(table_offsets, tables_blob);
     build_madt(tables_blob, tables->linker, vms);
 
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index ed8ea96acc..e734a75850 100644
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

