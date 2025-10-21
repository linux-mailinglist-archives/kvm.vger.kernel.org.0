Return-Path: <kvm+bounces-60647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C904BF5544
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:44:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5455C4F906B
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A90B8320A0A;
	Tue, 21 Oct 2025 08:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WoVKXUbo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0ED31A042
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036275; cv=none; b=Drh1/sacSkNLtgl0Pz1CVqXNLkxhc4/F3LgHjZDQRMmvu81Xd7f5qiPdrLUsz9SbhxGreRuUn08lgMSJmqZG6iapKXKilV3i4UPFin3+QFpbFezBF5VJN81ZtHY+ubuFN8DJjUS/I8xFTy+ywe3kQ3OxyArZLylmX+GnnSKgw7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036275; c=relaxed/simple;
	bh=pj3drzSAfaXqBen3HAGTGa+CGAzPHKvA3M3UrQRB6sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ut1FxDlKtcc4jToglHcn1gsdKrqIRJlsNfaYg4kfZl4P0DKog8Pl5ondcwfaFqSJ8PpdOZ4CvTB69M653uAGgDedwZ6Gr4YFIzl1S+9g2ciC66jaLeChbZe/HE8mXcNf8VVC7XjtzLjWAwYrhvKVR0ZAuePOpLdMzftWV9GyHGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WoVKXUbo; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3ece1102998so4551437f8f.2
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 01:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761036272; x=1761641072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hc11YiHtpmTqY0in4skO46MnwNo1SXkNGODEq2TMsMU=;
        b=WoVKXUbogZc61GEC7sqiJW3Fsr6xjHLPF9WBUVr8MnwIAYP/arIfzqRNTd/EFe+iUz
         s8OIAz90bWPdCWMVxPqrdMDtiu3lOERcnFW85rrLWYhO2gQxgxixWKjnB5FxLT8kMwcx
         zgnnrXYa0tT0g9s2St6UXJM5zfKQ/dX9tXTNlTDiayWNurDLFKHJ2g1JgGgdv4wPLfe3
         bh0b6KRFH0kTRe73wqKYSgv5pchhVYNwiVow1xpU9qfOcOUJpAuvWD7QNoAHCAhXAuF7
         R+macGVNHUzPXQlNkLzCnoPeHKLIlU1nODhLhIB/OC1TBiE4x+zHneZfAYBBnqSD9Q3I
         iN3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036272; x=1761641072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hc11YiHtpmTqY0in4skO46MnwNo1SXkNGODEq2TMsMU=;
        b=uizyU8pXfRyEEFNtVn6hL2oahURA4qx4u3rNbW4rTQMN6n5XN61LxxP/CzmjUpPOU1
         mQru+KTu/HCp+Gszltercbls43CIp1htFUA7gl1Vt+SDBswJwmc9hTUL3PA2ACohtgux
         +fIEYgR0nx5GAOt5bulUSUqjs10I2HTcXpDh9DzeSChoHN/ayG1oWF56ZEy6it3n7MOq
         Bim8X1tWih+HS7EfkjPFwA8QnaAhKtpCAaLqFXLXhEI7G3aLcUjOmkGaK73bjTIP6WHW
         u/Clr7DMnDZsqMNqCfmds8v8Ypc2PH6mt1yzkth1rcX2gKlTecwHP5I/zTtHYt1guQAR
         xHeQ==
X-Forwarded-Encrypted: i=1; AJvYcCW68SesUgUtayNToo59EeeNfKLotaUfaY4eT3oj4cS4rZHBwQodgATpGKCf8PqrzuHAVKs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKu7qnG0NywyBUWNN31jvikWx0r9oDashbSTrxCtzfVKtYvuS9
	WodP5H0annM/BIO5s5LirCy30kxKKvw4G3x4J1wiTPuz6koN7996kmBNsiH7byR1wmE=
X-Gm-Gg: ASbGnct1H03oUVrBYOu2pD451hiNbuGeJiHIJvizKMW9NFlAOzMy2xConkx1+2500Gw
	4e8Y4GOQ7CjHGlILG4gjarBDGI+5bJleOUW1XjqBDimTrDtld7+8ZX8BC4N4IDAjJVq3iF0zcDK
	WwMVjq9ZJJvMWyXm60k7J1Rcr2nFsvHKvbWOt9N2sZheFu8QtmNSqUjnemcQyGXy3qF8JrUyXRK
	L4f69nn2eLmqM9FQtVz/70UuwOCKJc+6zz+Vy0CosAtOmk4iSlUgzmIgg806od1mh9EmKqgvAft
	EBmhEcTmKlRWfA97MqpvS7KafHQRxHyWu5lbv1y7Y22EpBF6jWBn5AYXVEhiXbIsdp8/Z4cmOGe
	O72pouo4A++Fp36PJ0e3Ee898wlKJa+VdcrJVWY7chOndpOxUFP0ED79M8C2GwZLaHiHq3ZG0/R
	VYq1ggSAJ1Bcz2QkmxsxkZbV6wa0DQS06slVUpeidV0CKyFmNytPoWNdvUyj8zOMqMh0K0RXw=
X-Google-Smtp-Source: AGHT+IELZJiJfnJbVwdX1Os9p1hmB3XIZTwQOpbzRswBJhyGYUnWFGq++RhkpkJDYQ54jVhPBYkK3g==
X-Received: by 2002:a5d:64c7:0:b0:427:8bc:a3c5 with SMTP id ffacd0b85a97d-42708bca6b2mr8568193f8f.37.1761036272084;
        Tue, 21 Oct 2025 01:44:32 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a7dasm21117154f8f.25.2025.10.21.01.44.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 01:44:31 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Chinmay Rath <rathc@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 09/11] hw/ppc/spapr: Remove SpaprMachineClass::phb_placement callback
Date: Tue, 21 Oct 2025 10:43:43 +0200
Message-ID: <20251021084346.73671-10-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021084346.73671-1-philmd@linaro.org>
References: <20251021084346.73671-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The SpaprMachineClass::phb_placement callback was only used by
the pseries-4.0 machine, which got removed. Remove it as now
unused, directly calling spapr_phb_placement().
Move spapr_phb_placement() definition to avoid forward declaration.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h |   5 --
 hw/ppc/spapr.c         | 114 ++++++++++++++++++++---------------------
 2 files changed, 55 insertions(+), 64 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 58d31b096cd..bd783e92e15 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -147,11 +147,6 @@ struct SpaprMachineClass {
     bool pre_5_1_assoc_refpoints;
     bool pre_5_2_numa_associativity;
     bool pre_6_2_numa_affinity;
-
-    bool (*phb_placement)(SpaprMachineState *spapr, uint32_t index,
-                          uint64_t *buid, hwaddr *pio,
-                          hwaddr *mmio32, hwaddr *mmio64,
-                          unsigned n_dma, uint32_t *liobns, Error **errp);
     SpaprResizeHpt resize_hpt_default;
     SpaprCapabilities default_caps;
     SpaprIrq *irq;
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index deab613e070..97736bba5a1 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -4068,12 +4068,62 @@ int spapr_phb_dt_populate(SpaprDrc *drc, SpaprMachineState *spapr,
     return 0;
 }
 
+static bool spapr_phb_placement(SpaprMachineState *spapr, uint32_t index,
+                                uint64_t *buid, hwaddr *pio,
+                                hwaddr *mmio32, hwaddr *mmio64,
+                                unsigned n_dma, uint32_t *liobns, Error **errp)
+{
+    /*
+     * New-style PHB window placement.
+     *
+     * Goals: Gives large (1TiB), naturally aligned 64-bit MMIO window
+     * for each PHB, in addition to 2GiB 32-bit MMIO and 64kiB PIO
+     * windows.
+     *
+     * Some guest kernels can't work with MMIO windows above 1<<46
+     * (64TiB), so we place up to 31 PHBs in the area 32TiB..64TiB
+     *
+     * 32TiB..(33TiB+1984kiB) contains the 64kiB PIO windows for each
+     * PHB stacked together.  (32TiB+2GiB)..(32TiB+64GiB) contains the
+     * 2GiB 32-bit MMIO windows for each PHB.  Then 33..64TiB has the
+     * 1TiB 64-bit MMIO windows for each PHB.
+     */
+    const uint64_t base_buid = 0x800000020000000ULL;
+    int i;
+
+    /* Sanity check natural alignments */
+    QEMU_BUILD_BUG_ON((SPAPR_PCI_BASE % SPAPR_PCI_MEM64_WIN_SIZE) != 0);
+    QEMU_BUILD_BUG_ON((SPAPR_PCI_LIMIT % SPAPR_PCI_MEM64_WIN_SIZE) != 0);
+    QEMU_BUILD_BUG_ON((SPAPR_PCI_MEM64_WIN_SIZE % SPAPR_PCI_MEM32_WIN_SIZE) != 0);
+    QEMU_BUILD_BUG_ON((SPAPR_PCI_MEM32_WIN_SIZE % SPAPR_PCI_IO_WIN_SIZE) != 0);
+    /* Sanity check bounds */
+    QEMU_BUILD_BUG_ON((SPAPR_MAX_PHBS * SPAPR_PCI_IO_WIN_SIZE) >
+                      SPAPR_PCI_MEM32_WIN_SIZE);
+    QEMU_BUILD_BUG_ON((SPAPR_MAX_PHBS * SPAPR_PCI_MEM32_WIN_SIZE) >
+                      SPAPR_PCI_MEM64_WIN_SIZE);
+
+    if (index >= SPAPR_MAX_PHBS) {
+        error_setg(errp, "\"index\" for PAPR PHB is too large (max %llu)",
+                   SPAPR_MAX_PHBS - 1);
+        return false;
+    }
+
+    *buid = base_buid + index;
+    for (i = 0; i < n_dma; ++i) {
+        liobns[i] = SPAPR_PCI_LIOBN(index, i);
+    }
+
+    *pio = SPAPR_PCI_BASE + index * SPAPR_PCI_IO_WIN_SIZE;
+    *mmio32 = SPAPR_PCI_BASE + (index + 1) * SPAPR_PCI_MEM32_WIN_SIZE;
+    *mmio64 = SPAPR_PCI_BASE + (index + 1) * SPAPR_PCI_MEM64_WIN_SIZE;
+    return true;
+}
+
 static bool spapr_phb_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
                                Error **errp)
 {
     SpaprMachineState *spapr = SPAPR_MACHINE(OBJECT(hotplug_dev));
     SpaprPhbState *sphb = SPAPR_PCI_HOST_BRIDGE(dev);
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
     const unsigned windows_supported = spapr_phb_windows_supported(sphb);
     SpaprDrc *drc;
 
@@ -4092,12 +4142,10 @@ static bool spapr_phb_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
      * This will check that sphb->index doesn't exceed the maximum number of
      * PHBs for the current machine type.
      */
-    return
-        smc->phb_placement(spapr, sphb->index,
-                           &sphb->buid, &sphb->io_win_addr,
-                           &sphb->mem_win_addr, &sphb->mem64_win_addr,
-                           windows_supported, sphb->dma_liobn,
-                           errp);
+    return spapr_phb_placement(spapr, sphb->index,
+                               &sphb->buid, &sphb->io_win_addr,
+                               &sphb->mem_win_addr, &sphb->mem64_win_addr,
+                               windows_supported, sphb->dma_liobn, errp);
 }
 
 static void spapr_phb_plug(HotplugHandler *hotplug_dev, DeviceState *dev)
@@ -4345,57 +4393,6 @@ static const CPUArchIdList *spapr_possible_cpu_arch_ids(MachineState *machine)
     return machine->possible_cpus;
 }
 
-static bool spapr_phb_placement(SpaprMachineState *spapr, uint32_t index,
-                                uint64_t *buid, hwaddr *pio,
-                                hwaddr *mmio32, hwaddr *mmio64,
-                                unsigned n_dma, uint32_t *liobns, Error **errp)
-{
-    /*
-     * New-style PHB window placement.
-     *
-     * Goals: Gives large (1TiB), naturally aligned 64-bit MMIO window
-     * for each PHB, in addition to 2GiB 32-bit MMIO and 64kiB PIO
-     * windows.
-     *
-     * Some guest kernels can't work with MMIO windows above 1<<46
-     * (64TiB), so we place up to 31 PHBs in the area 32TiB..64TiB
-     *
-     * 32TiB..(33TiB+1984kiB) contains the 64kiB PIO windows for each
-     * PHB stacked together.  (32TiB+2GiB)..(32TiB+64GiB) contains the
-     * 2GiB 32-bit MMIO windows for each PHB.  Then 33..64TiB has the
-     * 1TiB 64-bit MMIO windows for each PHB.
-     */
-    const uint64_t base_buid = 0x800000020000000ULL;
-    int i;
-
-    /* Sanity check natural alignments */
-    QEMU_BUILD_BUG_ON((SPAPR_PCI_BASE % SPAPR_PCI_MEM64_WIN_SIZE) != 0);
-    QEMU_BUILD_BUG_ON((SPAPR_PCI_LIMIT % SPAPR_PCI_MEM64_WIN_SIZE) != 0);
-    QEMU_BUILD_BUG_ON((SPAPR_PCI_MEM64_WIN_SIZE % SPAPR_PCI_MEM32_WIN_SIZE) != 0);
-    QEMU_BUILD_BUG_ON((SPAPR_PCI_MEM32_WIN_SIZE % SPAPR_PCI_IO_WIN_SIZE) != 0);
-    /* Sanity check bounds */
-    QEMU_BUILD_BUG_ON((SPAPR_MAX_PHBS * SPAPR_PCI_IO_WIN_SIZE) >
-                      SPAPR_PCI_MEM32_WIN_SIZE);
-    QEMU_BUILD_BUG_ON((SPAPR_MAX_PHBS * SPAPR_PCI_MEM32_WIN_SIZE) >
-                      SPAPR_PCI_MEM64_WIN_SIZE);
-
-    if (index >= SPAPR_MAX_PHBS) {
-        error_setg(errp, "\"index\" for PAPR PHB is too large (max %llu)",
-                   SPAPR_MAX_PHBS - 1);
-        return false;
-    }
-
-    *buid = base_buid + index;
-    for (i = 0; i < n_dma; ++i) {
-        liobns[i] = SPAPR_PCI_LIOBN(index, i);
-    }
-
-    *pio = SPAPR_PCI_BASE + index * SPAPR_PCI_IO_WIN_SIZE;
-    *mmio32 = SPAPR_PCI_BASE + (index + 1) * SPAPR_PCI_MEM32_WIN_SIZE;
-    *mmio64 = SPAPR_PCI_BASE + (index + 1) * SPAPR_PCI_MEM64_WIN_SIZE;
-    return true;
-}
-
 static ICSState *spapr_ics_get(XICSFabric *dev, int irq)
 {
     SpaprMachineState *spapr = SPAPR_MACHINE(dev);
@@ -4606,7 +4603,6 @@ static void spapr_machine_class_init(ObjectClass *oc, const void *data)
     smc->resize_hpt_default = SPAPR_RESIZE_HPT_ENABLED;
     fwc->get_dev_path = spapr_get_fw_dev_path;
     nc->nmi_monitor_handler = spapr_nmi;
-    smc->phb_placement = spapr_phb_placement;
     vhc->cpu_in_nested = spapr_cpu_in_nested;
     vhc->deliver_hv_excp = spapr_exit_nested;
     vhc->hypercall = emulate_spapr_hypercall;
-- 
2.51.0


