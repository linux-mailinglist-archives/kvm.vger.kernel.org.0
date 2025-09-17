Return-Path: <kvm+bounces-57878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84C1DB7F21D
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 537A7188D4E7
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E485632BC0E;
	Wed, 17 Sep 2025 13:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="wEKO9sNx"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BF131960D
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114319; cv=none; b=XdvazMBkAW+2uNLokgyfnmNo80xgSWtxdWSkQIjwniQznhgGvGOwCQAKQJpp36Wh0VbZ8gtFwbXQdvBTSwNJiKcOQGbT4fsf0PzyHGv0otqNoOhhS8DAIQh3pQxvNCagYHFvJ2ucYfnFV4saIS/hAa0kp1zCmKqh2OHBme4TMvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114319; c=relaxed/simple;
	bh=kmBG/9qtlFvKjd58yyTRn7VgQyMpUqXmndENU5lET2w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pkQDJ+1RsyRq3dn8EzgINs9abPaX3PV6gJKPfSVKeiRL/2WLITmGfuTD50P2YOhI9ks4D3G9f+Yd/EBo86HcFMlHPMntkbfW+81jNVV1fPmkSOWQi1Qn7s9CtUaHn3d6pnUgKp8DrzUnjs6JWonA2Hkm9FteT2C7PqwzTEFmHYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=wEKO9sNx reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN6w008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:46 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=5Zk0Ocd+QwOh+s35lDkbenDI0KEEnwyHPaEenyfugGE=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1758113806; v=1;
        b=wEKO9sNxGPBX8w4kyKsEykeTFzHjov4MPkIsIUG+KOHhBAyrzgfFwYHAPOu7U1Cv
         2Dgx0JTk3yFxQ3KaPQDheJ13tPZUF30uml5QbOlwSEYBqiXXy5JbJf5ldcewt+gJ
         IDVoHgHf46gpPx5ljbUvIaQFqITzsSFJYXrnRh0EzlANvUFX8Zx54KQAycMG0c7d
         G4cVcmDIQoYIuvSSd2zbaI+0ALgVK0AMVk22SC0laW9jQ51s7WZ0RVMrnqHMzWvs
         c+FometxxqeREWqQdNxlHHQvNWJg2wDbPap/ggFBwRwh1YLAky7uY4/TMmL23BUO
         yAwStcwFUKmjixKxuNJqUg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 17 Sep 2025 21:56:30 +0900
Subject: [PATCH 18/35] hw/pci-host: QOM-ify AddressSpace
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250917-qom-v1-18-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
References: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Steven Lee <steven_lee@aspeedtech.com>, Troy Lee <leetroy@gmail.com>,
        Jamin Lin <jamin_lin@aspeedtech.com>,
        Andrew Jeffery <andrew@codeconstruct.com.au>,
        Joel Stanley <joel@jms.id.au>, Eric Auger <eric.auger@redhat.com>,
        Helge Deller <deller@gmx.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?utf-8?q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <arikalo@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Alistair Francis <alistair@alistair23.me>,
        Ninad Palsule <ninad@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Yi Liu <yi.l.liu@intel.com>,
        =?utf-8?q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Aditya Gupta <adityag@linux.ibm.com>,
        Gautam Menghani <gautam@linux.ibm.com>, Song Gao <gaosong@loongson.cn>,
        Bibo Mao <maobibo@loongson.cn>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Fan Ni <fan.ni@samsung.com>, David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Subbaraya Sundeep <sundeep.lkml@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>, Laurent Vivier <laurent@vivier.eu>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Bernhard Beschow <shentey@gmail.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Weiwei Li <liwei1518@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        Bin Meng <bmeng.cn@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>, Peter Xu <peterx@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
        qemu-block@nongnu.org, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.15-dev-179e8

Make AddressSpaces QOM objects to ensure that they are destroyed when
their owners are finalized and also to get a unique path for debugging
output.

The name arguments were used to distinguish AddresSpaces in debugging
output, but they will represent property names after QOM-ification and
debugging output will show QOM paths. So change them to make them more
concise and also avoid conflicts with other properties.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 hw/pci-host/astro.c       | 3 +--
 hw/pci-host/designware.c  | 5 ++---
 hw/pci-host/dino.c        | 4 ++--
 hw/pci-host/gt64120.c     | 2 +-
 hw/pci-host/pnv_phb3.c    | 4 ++--
 hw/pci-host/pnv_phb4.c    | 4 ++--
 hw/pci-host/ppc440_pcix.c | 2 +-
 hw/pci-host/ppce500.c     | 2 +-
 hw/pci-host/raven.c       | 2 +-
 9 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/hw/pci-host/astro.c b/hw/pci-host/astro.c
index bb6b7d05582f..19f6a7ac88f4 100644
--- a/hw/pci-host/astro.c
+++ b/hw/pci-host/astro.c
@@ -835,8 +835,7 @@ static void astro_realize(DeviceState *obj, Error **errp)
     memory_region_init_iommu(&s->iommu, sizeof(s->iommu),
                              TYPE_ASTRO_IOMMU_MEMORY_REGION, OBJECT(s),
                              "iommu-astro", UINT64_MAX);
-    address_space_init(&s->iommu_as, NULL, MEMORY_REGION(&s->iommu),
-                       "bm-pci");
+    address_space_init(&s->iommu_as, OBJECT(s), MEMORY_REGION(&s->iommu), "as");
 
     /* Create Elroys (PCI host bus chips).  */
     for (i = 0; i < ELROY_NUM; i++) {
diff --git a/hw/pci-host/designware.c b/hw/pci-host/designware.c
index d67211c9bc74..a542f6e9b1b1 100644
--- a/hw/pci-host/designware.c
+++ b/hw/pci-host/designware.c
@@ -706,9 +706,8 @@ static void designware_pcie_host_realize(DeviceState *dev, Error **errp)
                        UINT64_MAX);
     memory_region_add_subregion(&s->pci.address_space_root,
                                 0x0, &s->pci.memory);
-    address_space_init(&s->pci.address_space, NULL,
-                       &s->pci.address_space_root,
-                       "pcie-bus-address-space");
+    address_space_init(&s->pci.address_space, OBJECT(s),
+                       &s->pci.address_space_root, "as");
     pci_setup_iommu(pci->bus, &designware_iommu_ops, s);
 
     qdev_realize(DEVICE(&s->root), BUS(pci->bus), &error_fatal);
diff --git a/hw/pci-host/dino.c b/hw/pci-host/dino.c
index b78167fd2fcd..d213478c86ce 100644
--- a/hw/pci-host/dino.c
+++ b/hw/pci-host/dino.c
@@ -434,14 +434,14 @@ static void dino_pcihost_realize(DeviceState *dev, Error **errp)
     memory_region_add_subregion(&s->bm, 0xfff00000,
                                 &s->bm_cpu_alias);
 
-    address_space_init(&s->bm_as, NULL, &s->bm, "pci-bm");
+    address_space_init(&s->bm_as, OBJECT(s), &s->bm, "as");
 }
 
 static void dino_pcihost_unrealize(DeviceState *dev)
 {
     DinoState *s = DINO_PCI_HOST_BRIDGE(dev);
 
-    address_space_destroy(&s->bm_as);
+    object_unparent(OBJECT(&s->bm_as));
 }
 
 static void dino_pcihost_init(Object *obj)
diff --git a/hw/pci-host/gt64120.c b/hw/pci-host/gt64120.c
index 68ad885edbe4..89c4cf0bd5f8 100644
--- a/hw/pci-host/gt64120.c
+++ b/hw/pci-host/gt64120.c
@@ -1198,7 +1198,7 @@ static void gt64120_realize(DeviceState *dev, Error **errp)
     memory_region_init_io(&s->ISD_mem, OBJECT(dev), &isd_mem_ops, s,
                           "gt64120-isd", 0x1000);
     memory_region_init(&s->pci0_mem, OBJECT(dev), "pci0-mem", 4 * GiB);
-    address_space_init(&s->pci0_mem_as, NULL, &s->pci0_mem, "pci0-mem");
+    address_space_init(&s->pci0_mem_as, OBJECT(s), &s->pci0_mem, "as");
     phb->bus = pci_root_bus_new(dev, "pci",
                                 &s->pci0_mem,
                                 get_system_io(),
diff --git a/hw/pci-host/pnv_phb3.c b/hw/pci-host/pnv_phb3.c
index 73592c9cbd3d..554ad034b6f4 100644
--- a/hw/pci-host/pnv_phb3.c
+++ b/hw/pci-host/pnv_phb3.c
@@ -956,8 +956,8 @@ static AddressSpace *pnv_phb3_dma_iommu(PCIBus *bus, void *opaque, int devfn)
         memory_region_init_iommu(&ds->dma_mr, sizeof(ds->dma_mr),
                                  TYPE_PNV_PHB3_IOMMU_MEMORY_REGION,
                                  OBJECT(phb), "phb3_iommu", UINT64_MAX);
-        address_space_init(&ds->dma_as, NULL, MEMORY_REGION(&ds->dma_mr),
-                           "phb3_iommu");
+        address_space_init(&ds->dma_as, OBJECT(phb), MEMORY_REGION(&ds->dma_mr),
+                           "as");
         memory_region_init_io(&ds->msi32_mr, OBJECT(phb), &pnv_phb3_msi_ops,
                               ds, "msi32", 0x10000);
         memory_region_init_io(&ds->msi64_mr, OBJECT(phb), &pnv_phb3_msi_ops,
diff --git a/hw/pci-host/pnv_phb4.c b/hw/pci-host/pnv_phb4.c
index 9db9268358d1..0d7643e36036 100644
--- a/hw/pci-host/pnv_phb4.c
+++ b/hw/pci-host/pnv_phb4.c
@@ -1469,8 +1469,8 @@ static AddressSpace *pnv_phb4_dma_iommu(PCIBus *bus, void *opaque, int devfn)
         memory_region_init_iommu(&ds->dma_mr, sizeof(ds->dma_mr),
                                  TYPE_PNV_PHB4_IOMMU_MEMORY_REGION,
                                  OBJECT(phb), name, UINT64_MAX);
-        address_space_init(&ds->dma_as, NULL, MEMORY_REGION(&ds->dma_mr),
-                           name);
+        address_space_init(&ds->dma_as, OBJECT(phb), MEMORY_REGION(&ds->dma_mr),
+                           "as");
         memory_region_init_io(&ds->msi32_mr, OBJECT(phb), &pnv_phb4_msi_ops,
                               ds, "msi32", 0x10000);
         memory_region_init_io(&ds->msi64_mr, OBJECT(phb), &pnv_phb4_msi_ops,
diff --git a/hw/pci-host/ppc440_pcix.c b/hw/pci-host/ppc440_pcix.c
index 3fe24d70ac30..6500871f48ae 100644
--- a/hw/pci-host/ppc440_pcix.c
+++ b/hw/pci-host/ppc440_pcix.c
@@ -502,7 +502,7 @@ static void ppc440_pcix_realize(DeviceState *dev, Error **errp)
 
     memory_region_init(&s->bm, OBJECT(s), "bm-ppc440-pcix", UINT64_MAX);
     memory_region_add_subregion(&s->bm, 0x0, &s->busmem);
-    address_space_init(&s->bm_as, NULL, &s->bm, "pci-bm");
+    address_space_init(&s->bm_as, OBJECT(s), &s->bm, "as");
     pci_setup_iommu(h->bus, &ppc440_iommu_ops, s);
 
     memory_region_init(&s->container, OBJECT(s), "pci-container", PCI_ALL_SIZE);
diff --git a/hw/pci-host/ppce500.c b/hw/pci-host/ppce500.c
index eda168fb5955..94d5c53f328a 100644
--- a/hw/pci-host/ppce500.c
+++ b/hw/pci-host/ppce500.c
@@ -470,7 +470,7 @@ static void e500_pcihost_realize(DeviceState *dev, Error **errp)
     /* Set up PCI view of memory */
     memory_region_init(&s->bm, OBJECT(s), "bm-e500", UINT64_MAX);
     memory_region_add_subregion(&s->bm, 0x0, &s->busmem);
-    address_space_init(&s->bm_as, NULL, &s->bm, "pci-bm");
+    address_space_init(&s->bm_as, OBJECT(s), &s->bm, "as");
     pci_setup_iommu(b, &ppce500_iommu_ops, s);
 
     pci_create_simple(b, 0, TYPE_PPC_E500_PCI_BRIDGE);
diff --git a/hw/pci-host/raven.c b/hw/pci-host/raven.c
index 5564b51d6755..5bf87bdffa26 100644
--- a/hw/pci-host/raven.c
+++ b/hw/pci-host/raven.c
@@ -214,7 +214,7 @@ static void raven_pcihost_realize(DeviceState *d, Error **errp)
     memory_region_init_alias(mr, o, "bm-system", get_system_memory(),
                              0, 0x80000000);
     memory_region_add_subregion(bm, 0x80000000, mr);
-    address_space_init(&s->bm_as, NULL, bm, "raven-bm-as");
+    address_space_init(&s->bm_as, o, bm, "as");
     pci_setup_iommu(h->bus, &raven_iommu_ops, s);
 }
 

-- 
2.51.0


