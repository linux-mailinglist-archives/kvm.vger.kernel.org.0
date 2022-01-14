Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E85648EB45
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 15:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241444AbiANOIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 09:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241424AbiANOIJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 09:08:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD5BC06161C
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 06:08:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE531B825FD
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 14:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C043DC36AE5;
        Fri, 14 Jan 2022 14:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642169285;
        bh=M8Cd2nEinA8ZwFjNff4KGOaxdFUznBmA2VZZ9jWgOeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Euw0JHQJDj5DxbVGy/QeI27q2H1xV59vAQBaqTgglbXdGq7+0DDKME7He05ee4DkU
         wq3HRntqXZzFKYUn89Abo+Ep7tPAQwdQniUtGVKf1iNSOT50pwTQ+Z56mE9o+iXCXr
         NwChYObjEopccPjbNr0HapByMrVPptZazX6YMJcVziqowP5sb/gE1JhBLVHjPtyai2
         dXTvehcWf//KTL2E5ZMKucG3Zmdk7s+QPmdBKt1NIoMUzkBrhC6EQLZe1VGCp+pYSC
         Xs6PQA/ohx8jrnNdsSpLQZDEuS4/3Wo+AmJw0BpIUw31bmWf/q7bA5bGPqCOHMhhMm
         b59Ctb9PGSbfA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n8NFL-000V8K-Qw; Fri, 14 Jan 2022 14:08:03 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: [PATCH v5 6/6] hw/arm/virt: Drop superfluous checks against highmem
Date:   Fri, 14 Jan 2022 14:07:41 +0000
Message-Id: <20220114140741.1358263-7-maz@kernel.org>
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

Now that the devices present in the extended memory map are checked
against the available PA space and disabled when they don't fit,
there is no need to keep the same checks against highmem, as
highmem really is a shortcut for the PA space being 32bit.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 hw/arm/virt-acpi-build.c | 2 --
 hw/arm/virt.c            | 5 +----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index 0757c28f69..449fab0080 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -947,8 +947,6 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
     acpi_add_table(table_offsets, tables_blob);
     build_fadt_rev5(tables_blob, tables->linker, vms, dsdt);
 
-    vms->highmem_redists &= vms->highmem;
-
     acpi_add_table(table_offsets, tables_blob);
     build_madt(tables_blob, tables->linker, vms);
 
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 053791cc44..4524f3807d 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2171,9 +2171,6 @@ static void machvirt_init(MachineState *machine)
 
     virt_flash_fdt(vms, sysmem, secure_sysmem ?: sysmem);
 
-    vms->highmem_mmio &= vms->highmem;
-    vms->highmem_redists &= vms->highmem;
-
     create_gic(vms, sysmem);
 
     virt_cpu_post_init(vms, sysmem);
@@ -2192,7 +2189,7 @@ static void machvirt_init(MachineState *machine)
                        machine->ram_size, "mach-virt.tag");
     }
 
-    vms->highmem_ecam &= vms->highmem && (!firmware_loaded || aarch64);
+    vms->highmem_ecam &= (!firmware_loaded || aarch64);
 
     create_rtc(vms);
 
-- 
2.30.2

