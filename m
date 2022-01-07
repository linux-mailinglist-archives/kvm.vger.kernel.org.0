Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B62487A77
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 17:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348284AbiAGQeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 11:34:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54168 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348290AbiAGQeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 11:34:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60054B8265D
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 16:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134B5C36AF4;
        Fri,  7 Jan 2022 16:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641573241;
        bh=WmoIozEvGlNS3dJc+2DA44l+mzjupH6RhSJiIollmi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZAmRzkKz3TICIXaNfHBEW4S55KGkrCYfXEZ96oGuMwnh4l2WHwfYRFDqej3Jmk1I
         /hzOGVfyns2Vs0OeVSbp7KaPlJhdjcmQKXjHRbp1bNrq7juK7W4HcBgCc9doIKfiWy
         TqujOaGRqXIkxcspsA2WdaRIprygxFcnmDiDCyYtvAi/nU/RGrHnoO26VhdELJtVzK
         3PqZpSqFdMIKCCqc7vABBV2Rngy07PXEtqtnyJCfVhcSqroucs2imjNTMpdz5T/OhZ
         9mGwdRd5vEt/XeN5AkK/ggZbq6REVAV+Rr5okmP70ZI4Bw5v8kss8muaZIwwFy+tFG
         Ss3W039Y/l/bg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n5sBj-00GbiJ-6m; Fri, 07 Jan 2022 16:33:59 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v4 6/6] hw/arm/virt: Drop superfluous checks against highmem
Date:   Fri,  7 Jan 2022 16:33:24 +0000
Message-Id: <20220107163324.2491209-7-maz@kernel.org>
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

Now that the devices present in the extended memory map are checked
against the available PA space and disabled when they don't fit,
there is no need to keep the same checks against highmem, as
highmem really is a shortcut for the PA space being 32bit.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 hw/arm/virt-acpi-build.c | 2 --
 hw/arm/virt.c            | 5 +----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index 505c61e88e..cdac009419 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -946,8 +946,6 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
     acpi_add_table(table_offsets, tables_blob);
     build_fadt_rev5(tables_blob, tables->linker, vms, dsdt);
 
-    vms->highmem_redists &= vms->highmem;
-
     acpi_add_table(table_offsets, tables_blob);
     build_madt(tables_blob, tables->linker, vms);
 
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 70b4773b3e..641c6a9c31 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2170,9 +2170,6 @@ static void machvirt_init(MachineState *machine)
 
     virt_flash_fdt(vms, sysmem, secure_sysmem ?: sysmem);
 
-    vms->highmem_mmio &= vms->highmem;
-    vms->highmem_redists &= vms->highmem;
-
     create_gic(vms, sysmem);
 
     virt_cpu_post_init(vms, sysmem);
@@ -2191,7 +2188,7 @@ static void machvirt_init(MachineState *machine)
                        machine->ram_size, "mach-virt.tag");
     }
 
-    vms->highmem_ecam &= vms->highmem && (!firmware_loaded || aarch64);
+    vms->highmem_ecam &= (!firmware_loaded || aarch64);
 
     create_rtc(vms);
 
-- 
2.30.2

