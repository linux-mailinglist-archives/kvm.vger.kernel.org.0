Return-Path: <kvm+bounces-57873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F72B7F06A
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:11:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24C497B51F2
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FDB4332A55;
	Wed, 17 Sep 2025 13:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="Qkm+mSTN"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0190F30CB22
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114255; cv=none; b=fdtNG7extG6eV26cdy0WM4UpmkBC8+V6z5jUgmJ9IV/n6EsSh7lqvH6zvgZomSTGHAbd6Zn7VE5mNNBcbG8t5sAIvTTGB11tz21CmFCq+7YvQtGn4IoKi+SYltuakYnvbTViUDZr6c99h4e23gfhFsZgde1pD6P1EMQkRFiDkWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114255; c=relaxed/simple;
	bh=7aOTvsZQ0P9EW4EYG0ZrcYsOSYOXC2NWKFNCMDBrhY8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eqpuz4bkFHrFdqsEnAHCQ8o56qC21qSqI6LIVTOFsd3DF2MclFuhlFHPxUjNakl8RRO7STjw8j5PGXcrMwJIJesRkrSxPgJNoVOZ8pAfsG3CQEjPpFRB2zIIi+8Xw6Mdp4RcQrGi3Dzkayd+VW0172U4zHjdJLyEy09bnsBh+SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=Qkm+mSTN reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN6f008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:32 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=G6czMEoozkMVhsTtjAGPNBswbodfcurXUPpWNvEzgnQ=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1758113792; v=1;
        b=Qkm+mSTNmqpMwvcVdFKA/6whpu1p2DsK6FH9rIrfdPU947/RLU0/9YPlpjctZMdB
         tWcpwD/CgbUlfvYfUq6vnxmJ/nlgkkMaPlxRK+OgtMGW1BiY+Hz+P5iRpg0evSEU
         xPAfT/L/oVop1yqvYN5s1y1R+ygyjKpgIVUdrz49WNZqdRn0VWbMyE8hk0smDjrM
         MFrzjJ08VrNIIkV+tuLJXHl7ZYHKtP8+Nt1yyXUwdzYSJiuDeYOYhAilza4CkT7d
         nPkjMLGH4xpTyMDpLS/kXJ4q7neX80Obs+bxquQsIlZ2ALKXBUNYnX3X5HH2LMJG
         mt7P49Oa9w294QkKS1M+yQ==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 17 Sep 2025 21:56:13 +0900
Subject: [PATCH 01/35] memory: QOM-ify AddressSpace
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250917-qom-v1-1-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
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

For incremental conversion, address_space_init() keeps the original
behavior when the owner parameter is NULL, and all callers are changed
to pass NULL as the owner parameter.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 include/system/memory.h       | 19 +++++++++++-
 hw/alpha/typhoon.c            |  2 +-
 hw/arm/armv7m.c               |  2 +-
 hw/arm/aspeed_ast27x0.c       |  2 +-
 hw/arm/smmu-common.c          |  2 +-
 hw/display/artist.c           |  2 +-
 hw/display/bcm2835_fb.c       |  2 +-
 hw/dma/bcm2835_dma.c          |  2 +-
 hw/dma/pl080.c                |  3 +-
 hw/dma/pl330.c                |  2 +-
 hw/dma/rc4030.c               |  3 +-
 hw/dma/xilinx_axidma.c        |  2 +-
 hw/dma/xlnx-zdma.c            |  2 +-
 hw/dma/xlnx_csu_dma.c         |  2 +-
 hw/fsi/aspeed_apb2opb.c       |  2 +-
 hw/i2c/aspeed_i2c.c           |  2 +-
 hw/i386/amd_iommu.c           |  2 +-
 hw/i386/intel_iommu.c         |  3 +-
 hw/intc/arm_gicv3_common.c    |  2 +-
 hw/intc/pnv_xive.c            |  4 +--
 hw/loongarch/virt.c           |  2 +-
 hw/mem/cxl_type3.c            |  6 ++--
 hw/mem/memory-device.c        |  2 +-
 hw/misc/aspeed_hace.c         |  2 +-
 hw/misc/auxbus.c              |  2 +-
 hw/misc/bcm2835_mbox.c        |  3 +-
 hw/misc/bcm2835_property.c    |  3 +-
 hw/misc/max78000_gcr.c        |  2 +-
 hw/misc/tz-mpc.c              |  4 +--
 hw/misc/tz-msc.c              |  2 +-
 hw/misc/tz-ppc.c              |  2 +-
 hw/net/allwinner-sun8i-emac.c |  2 +-
 hw/net/cadence_gem.c          |  2 +-
 hw/net/dp8393x.c              |  2 +-
 hw/net/msf2-emac.c            |  2 +-
 hw/net/mv88w8618_eth.c        |  2 +-
 hw/nubus/nubus-bus.c          |  2 +-
 hw/pci-host/astro.c           |  2 +-
 hw/pci-host/designware.c      |  2 +-
 hw/pci-host/dino.c            |  2 +-
 hw/pci-host/gt64120.c         |  2 +-
 hw/pci-host/pnv_phb3.c        |  2 +-
 hw/pci-host/pnv_phb4.c        |  2 +-
 hw/pci-host/ppc440_pcix.c     |  2 +-
 hw/pci-host/ppce500.c         |  2 +-
 hw/pci-host/raven.c           |  2 +-
 hw/pci/pci.c                  |  2 +-
 hw/pci/pci_bridge.c           |  5 ++--
 hw/ppc/pnv_lpc.c              |  2 +-
 hw/ppc/pnv_xscom.c            |  2 +-
 hw/ppc/spapr_pci.c            |  2 +-
 hw/ppc/spapr_vio.c            |  2 +-
 hw/remote/iommu.c             |  2 +-
 hw/riscv/riscv-iommu.c        |  7 +++--
 hw/s390x/s390-pci-bus.c       |  2 +-
 hw/scsi/lsi53c895a.c          |  3 +-
 hw/sd/allwinner-sdhost.c      |  2 +-
 hw/sd/sdhci.c                 |  2 +-
 hw/sparc/sun4m_iommu.c        |  3 +-
 hw/sparc64/sun4u_iommu.c      |  3 +-
 hw/ssi/aspeed_smc.c           |  4 +--
 hw/usb/hcd-dwc2.c             |  2 +-
 hw/usb/hcd-xhci-sysbus.c      |  2 +-
 hw/virtio/virtio-iommu.c      |  2 +-
 hw/virtio/virtio-pci.c        |  4 +--
 system/memory.c               | 67 ++++++++++++++++++++++++++++++++-----------
 system/physmem.c              | 13 ++++++---
 target/i386/kvm/kvm.c         |  2 +-
 target/mips/cpu.c             |  2 +-
 target/xtensa/cpu.c           |  2 +-
 70 files changed, 163 insertions(+), 98 deletions(-)

diff --git a/include/system/memory.h b/include/system/memory.h
index e2cd6ed12614..5108e0fba339 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -47,6 +47,9 @@ typedef struct RamDiscardManager RamDiscardManager;
 DECLARE_OBJ_CHECKERS(RamDiscardManager, RamDiscardManagerClass,
                      RAM_DISCARD_MANAGER, TYPE_RAM_DISCARD_MANAGER);
 
+#define TYPE_ADDRESS_SPACE "address-space"
+OBJECT_DECLARE_SIMPLE_TYPE(AddressSpace, ADDRESS_SPACE)
+
 #ifdef CONFIG_FUZZ
 void fuzz_dma_read_cb(size_t addr,
                       size_t len,
@@ -1158,7 +1161,9 @@ typedef struct AddressSpaceMapClient {
  */
 struct AddressSpace {
     /* private: */
+    Object parent_obj;
     struct rcu_head rcu;
+    bool qom;
     char *name;
     MemoryRegion *root;
 
@@ -2706,11 +2711,13 @@ MemTxResult memory_region_dispatch_write(MemoryRegion *mr,
  * address_space_init: initializes an address space
  *
  * @as: an uninitialized #AddressSpace
+ * @parent: parent object
  * @root: a #MemoryRegion that routes addresses for the address space
  * @name: an address space name.  The name is only used for debugging
  *        output.
  */
-void address_space_init(AddressSpace *as, MemoryRegion *root, const char *name);
+void address_space_init(AddressSpace *as, Object *parent, MemoryRegion *root,
+                        const char *name);
 
 /**
  * address_space_destroy: destroy an address space
@@ -2723,6 +2730,16 @@ void address_space_init(AddressSpace *as, MemoryRegion *root, const char *name);
  */
 void address_space_destroy(AddressSpace *as);
 
+/**
+ * address_space_get_path: get the path to an address space
+ *
+ * @as: an initialized #AddressSpace
+ *
+ * Returns: The canonical path for an address space, newly allocated.
+ * Use g_free() to free it.
+ */
+char *address_space_get_path(AddressSpace *as);
+
 /**
  * address_space_remove_listeners: unregister all listeners of an address space
  *
diff --git a/hw/alpha/typhoon.c b/hw/alpha/typhoon.c
index 4c56f981d71c..d2307b076897 100644
--- a/hw/alpha/typhoon.c
+++ b/hw/alpha/typhoon.c
@@ -900,7 +900,7 @@ PCIBus *typhoon_init(MemoryRegion *ram, qemu_irq *p_isa_irq,
     memory_region_init_iommu(&s->pchip.iommu, sizeof(s->pchip.iommu),
                              TYPE_TYPHOON_IOMMU_MEMORY_REGION, OBJECT(s),
                              "iommu-typhoon", UINT64_MAX);
-    address_space_init(&s->pchip.iommu_as, MEMORY_REGION(&s->pchip.iommu),
+    address_space_init(&s->pchip.iommu_as, NULL, MEMORY_REGION(&s->pchip.iommu),
                        "pchip0-pci");
     pci_setup_iommu(b, &typhoon_iommu_ops, s);
 
diff --git a/hw/arm/armv7m.c b/hw/arm/armv7m.c
index cea3eb49ee59..7fa854bc14df 100644
--- a/hw/arm/armv7m.c
+++ b/hw/arm/armv7m.c
@@ -117,7 +117,7 @@ static void bitband_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    address_space_init(&s->source_as, s->source_memory, "bitband-source");
+    address_space_init(&s->source_as, NULL, s->source_memory, "bitband-source");
 }
 
 /* Board init.  */
diff --git a/hw/arm/aspeed_ast27x0.c b/hw/arm/aspeed_ast27x0.c
index 6aa3841b6911..f8c0ac5f87df 100644
--- a/hw/arm/aspeed_ast27x0.c
+++ b/hw/arm/aspeed_ast27x0.c
@@ -387,7 +387,7 @@ static bool aspeed_soc_ast2700_dram_init(DeviceState *dev, Error **errp)
     memory_region_init(&s->dram_container, OBJECT(s), "ram-container",
                        ram_size);
     memory_region_add_subregion(&s->dram_container, 0, s->dram_mr);
-    address_space_init(&s->dram_as, s->dram_mr, "dram");
+    address_space_init(&s->dram_as, NULL, s->dram_mr, "dram");
 
     /*
      * Add a memory region beyond the RAM region to emulate
diff --git a/hw/arm/smmu-common.c b/hw/arm/smmu-common.c
index 0dcaf2f58971..081c50750947 100644
--- a/hw/arm/smmu-common.c
+++ b/hw/arm/smmu-common.c
@@ -873,7 +873,7 @@ static AddressSpace *smmu_find_add_as(PCIBus *bus, void *opaque, int devfn)
         memory_region_init_iommu(&sdev->iommu, sizeof(sdev->iommu),
                                  s->mrtypename,
                                  OBJECT(s), name, UINT64_MAX);
-        address_space_init(&sdev->as,
+        address_space_init(&sdev->as, NULL,
                            MEMORY_REGION(&sdev->iommu), name);
         trace_smmu_add_mr(name);
         g_free(name);
diff --git a/hw/display/artist.c b/hw/display/artist.c
index 3c884c92437c..42905563ad49 100644
--- a/hw/display/artist.c
+++ b/hw/display/artist.c
@@ -1391,7 +1391,7 @@ static void artist_realizefn(DeviceState *dev, Error **errp)
     }
 
     memory_region_init(&s->mem_as_root, OBJECT(dev), "artist", ~0ull);
-    address_space_init(&s->as, &s->mem_as_root, "artist");
+    address_space_init(&s->as, NULL, &s->mem_as_root, "artist");
 
     artist_create_buffer(s, "cmap", &offset, ARTIST_BUFFER_CMAP, 2048, 4);
     artist_create_buffer(s, "ap", &offset, ARTIST_BUFFER_AP,
diff --git a/hw/display/bcm2835_fb.c b/hw/display/bcm2835_fb.c
index 820e67ac8bb4..c6710bdc0700 100644
--- a/hw/display/bcm2835_fb.c
+++ b/hw/display/bcm2835_fb.c
@@ -421,7 +421,7 @@ static void bcm2835_fb_realize(DeviceState *dev, Error **errp)
     s->initial_config.base = s->vcram_base + BCM2835_FB_OFFSET;
 
     s->dma_mr = MEMORY_REGION(obj);
-    address_space_init(&s->dma_as, s->dma_mr, TYPE_BCM2835_FB "-memory");
+    address_space_init(&s->dma_as, NULL, s->dma_mr, TYPE_BCM2835_FB "-memory");
 
     bcm2835_fb_reset(dev);
 
diff --git a/hw/dma/bcm2835_dma.c b/hw/dma/bcm2835_dma.c
index a2771ddcb523..ebef56d8d613 100644
--- a/hw/dma/bcm2835_dma.c
+++ b/hw/dma/bcm2835_dma.c
@@ -380,7 +380,7 @@ static void bcm2835_dma_realize(DeviceState *dev, Error **errp)
 
     obj = object_property_get_link(OBJECT(dev), "dma-mr", &error_abort);
     s->dma_mr = MEMORY_REGION(obj);
-    address_space_init(&s->dma_as, s->dma_mr, TYPE_BCM2835_DMA "-memory");
+    address_space_init(&s->dma_as, NULL, s->dma_mr, TYPE_BCM2835_DMA "-memory");
 
     bcm2835_dma_reset(dev);
 }
diff --git a/hw/dma/pl080.c b/hw/dma/pl080.c
index 277d9343223b..cf02a484d6a6 100644
--- a/hw/dma/pl080.c
+++ b/hw/dma/pl080.c
@@ -398,7 +398,8 @@ static void pl080_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    address_space_init(&s->downstream_as, s->downstream, "pl080-downstream");
+    address_space_init(&s->downstream_as, NULL, s->downstream,
+                       "pl080-downstream");
 }
 
 static void pl081_init(Object *obj)
diff --git a/hw/dma/pl330.c b/hw/dma/pl330.c
index a570bb08ec4c..4733799f4045 100644
--- a/hw/dma/pl330.c
+++ b/hw/dma/pl330.c
@@ -1569,7 +1569,7 @@ static void pl330_realize(DeviceState *dev, Error **errp)
         s->mem_as = &address_space_memory;
     } else {
         s->mem_as = g_new0(AddressSpace, 1);
-        address_space_init(s->mem_as, s->mem_mr,
+        address_space_init(s->mem_as, NULL, s->mem_mr,
                            memory_region_name(s->mem_mr));
     }
 
diff --git a/hw/dma/rc4030.c b/hw/dma/rc4030.c
index b6ed1d464336..cf76f90f4d3b 100644
--- a/hw/dma/rc4030.c
+++ b/hw/dma/rc4030.c
@@ -688,7 +688,8 @@ static void rc4030_realize(DeviceState *dev, Error **errp)
     memory_region_init_iommu(&s->dma_mr, sizeof(s->dma_mr),
                              TYPE_RC4030_IOMMU_MEMORY_REGION,
                              o, "rc4030.dma", 4 * GiB);
-    address_space_init(&s->dma_as, MEMORY_REGION(&s->dma_mr), "rc4030-dma");
+    address_space_init(&s->dma_as, NULL, MEMORY_REGION(&s->dma_mr),
+                       "rc4030-dma");
 }
 
 static void rc4030_unrealize(DeviceState *dev)
diff --git a/hw/dma/xilinx_axidma.c b/hw/dma/xilinx_axidma.c
index 2020399fd596..0f340abc2c6f 100644
--- a/hw/dma/xilinx_axidma.c
+++ b/hw/dma/xilinx_axidma.c
@@ -588,7 +588,7 @@ static void xilinx_axidma_realize(DeviceState *dev, Error **errp)
         ptimer_transaction_commit(st->ptimer);
     }
 
-    address_space_init(&s->as,
+    address_space_init(&s->as, NULL,
                        s->dma_mr ? s->dma_mr : get_system_memory(), "dma");
 }
 
diff --git a/hw/dma/xlnx-zdma.c b/hw/dma/xlnx-zdma.c
index 0c075e7d0d10..9b9ccd1e3c08 100644
--- a/hw/dma/xlnx-zdma.c
+++ b/hw/dma/xlnx-zdma.c
@@ -769,7 +769,7 @@ static void zdma_realize(DeviceState *dev, Error **errp)
         error_setg(errp, TYPE_XLNX_ZDMA " 'dma' link not set");
         return;
     }
-    address_space_init(&s->dma_as, s->dma_mr, "zdma-dma");
+    address_space_init(&s->dma_as, NULL, s->dma_mr, "zdma-dma");
 
     for (i = 0; i < ARRAY_SIZE(zdma_regs_info); ++i) {
         RegisterInfo *r = &s->regs_info[zdma_regs_info[i].addr / 4];
diff --git a/hw/dma/xlnx_csu_dma.c b/hw/dma/xlnx_csu_dma.c
index d8c7da1a501c..8b88392bb92b 100644
--- a/hw/dma/xlnx_csu_dma.c
+++ b/hw/dma/xlnx_csu_dma.c
@@ -653,7 +653,7 @@ static void xlnx_csu_dma_realize(DeviceState *dev, Error **errp)
         error_setg(errp, TYPE_XLNX_CSU_DMA " 'dma' link not set");
         return;
     }
-    address_space_init(&s->dma_as, s->dma_mr, "csu-dma");
+    address_space_init(&s->dma_as, NULL, s->dma_mr, "csu-dma");
 
     reg_array =
         register_init_block32(dev, xlnx_csu_dma_regs_info[!!s->is_dst],
diff --git a/hw/fsi/aspeed_apb2opb.c b/hw/fsi/aspeed_apb2opb.c
index 172ba16b0c05..8eda6f67cfd9 100644
--- a/hw/fsi/aspeed_apb2opb.c
+++ b/hw/fsi/aspeed_apb2opb.c
@@ -349,7 +349,7 @@ static void fsi_opb_init(Object *o)
     OPBus *opb = OP_BUS(o);
 
     memory_region_init(&opb->mr, 0, TYPE_FSI_OPB, UINT32_MAX);
-    address_space_init(&opb->as, &opb->mr, TYPE_FSI_OPB);
+    address_space_init(&opb->as, NULL, &opb->mr, TYPE_FSI_OPB);
 }
 
 static const TypeInfo opb_info = {
diff --git a/hw/i2c/aspeed_i2c.c b/hw/i2c/aspeed_i2c.c
index 83fb906bdc75..9d216b3f0ea3 100644
--- a/hw/i2c/aspeed_i2c.c
+++ b/hw/i2c/aspeed_i2c.c
@@ -1253,7 +1253,7 @@ static void aspeed_i2c_realize(DeviceState *dev, Error **errp)
             return;
         }
 
-        address_space_init(&s->dram_as, s->dram_mr,
+        address_space_init(&s->dram_as, NULL, s->dram_mr,
                            TYPE_ASPEED_I2C "-dma-dram");
     }
 }
diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
index 26be69bec8ae..af239390ba04 100644
--- a/hw/i386/amd_iommu.c
+++ b/hw/i386/amd_iommu.c
@@ -1522,7 +1522,7 @@ static AddressSpace *amdvi_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
                                  "amd_iommu", UINT64_MAX);
         memory_region_init(&amdvi_dev_as->root, OBJECT(s),
                            "amdvi_root", UINT64_MAX);
-        address_space_init(&amdvi_dev_as->as, &amdvi_dev_as->root, name);
+        address_space_init(&amdvi_dev_as->as, NULL, &amdvi_dev_as->root, name);
         memory_region_add_subregion_overlap(&amdvi_dev_as->root, 0,
                                             MEMORY_REGION(&amdvi_dev_as->iommu),
                                             0);
diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 83c5e444131a..1f40d904326e 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -4263,7 +4263,8 @@ VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus,
         vtd_dev_as->iova_tree = iova_tree_new();
 
         memory_region_init(&vtd_dev_as->root, OBJECT(s), name, UINT64_MAX);
-        address_space_init(&vtd_dev_as->as, &vtd_dev_as->root, "vtd-root");
+        address_space_init(&vtd_dev_as->as, NULL, &vtd_dev_as->root,
+                           "vtd-root");
 
         /*
          * Build the DMAR-disabled container with aliases to the
diff --git a/hw/intc/arm_gicv3_common.c b/hw/intc/arm_gicv3_common.c
index e438d8c042d6..169e0fcca828 100644
--- a/hw/intc/arm_gicv3_common.c
+++ b/hw/intc/arm_gicv3_common.c
@@ -429,7 +429,7 @@ static void arm_gicv3_common_realize(DeviceState *dev, Error **errp)
     }
 
     if (s->lpi_enable) {
-        address_space_init(&s->dma_as, s->dma,
+        address_space_init(&s->dma_as, NULL, s->dma,
                            "gicv3-its-sysmem");
     }
 
diff --git a/hw/intc/pnv_xive.c b/hw/intc/pnv_xive.c
index c2ca40b8be87..d14c26773021 100644
--- a/hw/intc/pnv_xive.c
+++ b/hw/intc/pnv_xive.c
@@ -2012,10 +2012,10 @@ static void pnv_xive_realize(DeviceState *dev, Error **errp)
 
     memory_region_init(&xive->ipi_mmio, OBJECT(xive), "xive-vc-ipi",
                        PNV9_XIVE_VC_SIZE);
-    address_space_init(&xive->ipi_as, &xive->ipi_mmio, "xive-vc-ipi");
+    address_space_init(&xive->ipi_as, NULL, &xive->ipi_mmio, "xive-vc-ipi");
     memory_region_init(&xive->end_mmio, OBJECT(xive), "xive-vc-end",
                        PNV9_XIVE_VC_SIZE);
-    address_space_init(&xive->end_as, &xive->end_mmio, "xive-vc-end");
+    address_space_init(&xive->end_as, NULL, &xive->end_mmio, "xive-vc-end");
 
     /*
      * The MMIO windows exposing the IPI ESBs and the END ESBs in the
diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
index b15ada20787b..0bace2f54b49 100644
--- a/hw/loongarch/virt.c
+++ b/hw/loongarch/virt.c
@@ -699,7 +699,7 @@ static void virt_init(MachineState *machine)
     /* Create IOCSR space */
     memory_region_init_io(&lvms->system_iocsr, OBJECT(machine), NULL,
                           machine, "iocsr", UINT64_MAX);
-    address_space_init(&lvms->as_iocsr, &lvms->system_iocsr, "IOCSR");
+    address_space_init(&lvms->as_iocsr, NULL, &lvms->system_iocsr, "IOCSR");
     memory_region_init_io(&lvms->iocsr_mem, OBJECT(machine),
                           &virt_iocsr_misc_ops,
                           machine, "iocsr_misc", 0x428);
diff --git a/hw/mem/cxl_type3.c b/hw/mem/cxl_type3.c
index be609ff9d031..1a726b834b02 100644
--- a/hw/mem/cxl_type3.c
+++ b/hw/mem/cxl_type3.c
@@ -770,7 +770,7 @@ static bool cxl_setup_memory(CXLType3Dev *ct3d, Error **errp)
         } else {
             v_name = g_strdup("cxl-type3-dpa-vmem-space");
         }
-        address_space_init(&ct3d->hostvmem_as, vmr, v_name);
+        address_space_init(&ct3d->hostvmem_as, NULL, vmr, v_name);
         ct3d->cxl_dstate.vmem_size = memory_region_size(vmr);
         ct3d->cxl_dstate.static_mem_size += memory_region_size(vmr);
         g_free(v_name);
@@ -798,7 +798,7 @@ static bool cxl_setup_memory(CXLType3Dev *ct3d, Error **errp)
         } else {
             p_name = g_strdup("cxl-type3-dpa-pmem-space");
         }
-        address_space_init(&ct3d->hostpmem_as, pmr, p_name);
+        address_space_init(&ct3d->hostpmem_as, NULL, pmr, p_name);
         ct3d->cxl_dstate.pmem_size = memory_region_size(pmr);
         ct3d->cxl_dstate.static_mem_size += memory_region_size(pmr);
         g_free(p_name);
@@ -837,7 +837,7 @@ static bool cxl_setup_memory(CXLType3Dev *ct3d, Error **errp)
         } else {
             dc_name = g_strdup("cxl-dcd-dpa-dc-space");
         }
-        address_space_init(&ct3d->dc.host_dc_as, dc_mr, dc_name);
+        address_space_init(&ct3d->dc.host_dc_as, NULL, dc_mr, dc_name);
         g_free(dc_name);
 
         if (!cxl_create_dc_regions(ct3d, errp)) {
diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index 1a432e9bd224..a4a8efdd869b 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -535,7 +535,7 @@ void machine_memory_devices_init(MachineState *ms, hwaddr base, uint64_t size)
 
     memory_region_init(&ms->device_memory->mr, OBJECT(ms), "device-memory",
                        size);
-    address_space_init(&ms->device_memory->as, &ms->device_memory->mr,
+    address_space_init(&ms->device_memory->as, NULL, &ms->device_memory->mr,
                        "device-memory");
     memory_region_add_subregion(get_system_memory(), ms->device_memory->base,
                                 &ms->device_memory->mr);
diff --git a/hw/misc/aspeed_hace.c b/hw/misc/aspeed_hace.c
index 726368fbbc2e..198363fd64fa 100644
--- a/hw/misc/aspeed_hace.c
+++ b/hw/misc/aspeed_hace.c
@@ -603,7 +603,7 @@ static void aspeed_hace_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    address_space_init(&s->dram_as, s->dram_mr, "dram");
+    address_space_init(&s->dram_as, NULL, s->dram_mr, "dram");
 
     sysbus_init_mmio(sbd, &s->iomem);
 }
diff --git a/hw/misc/auxbus.c b/hw/misc/auxbus.c
index 877f34560626..e5448ef3cc60 100644
--- a/hw/misc/auxbus.c
+++ b/hw/misc/auxbus.c
@@ -74,7 +74,7 @@ AUXBus *aux_bus_init(DeviceState *parent, const char *name)
     /* Memory related. */
     bus->aux_io = g_malloc(sizeof(*bus->aux_io));
     memory_region_init(bus->aux_io, OBJECT(bus), "aux-io", 1 * MiB);
-    address_space_init(&bus->aux_addr_space, bus->aux_io, "aux-io");
+    address_space_init(&bus->aux_addr_space, NULL, bus->aux_io, "aux-io");
     return bus;
 }
 
diff --git a/hw/misc/bcm2835_mbox.c b/hw/misc/bcm2835_mbox.c
index 603eaaa710d5..4bf3c59a40a1 100644
--- a/hw/misc/bcm2835_mbox.c
+++ b/hw/misc/bcm2835_mbox.c
@@ -310,7 +310,8 @@ static void bcm2835_mbox_realize(DeviceState *dev, Error **errp)
 
     obj = object_property_get_link(OBJECT(dev), "mbox-mr", &error_abort);
     s->mbox_mr = MEMORY_REGION(obj);
-    address_space_init(&s->mbox_as, s->mbox_mr, TYPE_BCM2835_MBOX "-memory");
+    address_space_init(&s->mbox_as, NULL, s->mbox_mr,
+                       TYPE_BCM2835_MBOX "-memory");
     bcm2835_mbox_reset(dev);
 }
 
diff --git a/hw/misc/bcm2835_property.c b/hw/misc/bcm2835_property.c
index a21c6a541c05..8bdde2d248b5 100644
--- a/hw/misc/bcm2835_property.c
+++ b/hw/misc/bcm2835_property.c
@@ -540,7 +540,8 @@ static void bcm2835_property_realize(DeviceState *dev, Error **errp)
 
     obj = object_property_get_link(OBJECT(dev), "dma-mr", &error_abort);
     s->dma_mr = MEMORY_REGION(obj);
-    address_space_init(&s->dma_as, s->dma_mr, TYPE_BCM2835_PROPERTY "-memory");
+    address_space_init(&s->dma_as, NULL, s->dma_mr,
+                       TYPE_BCM2835_PROPERTY "-memory");
 
     obj = object_property_get_link(OBJECT(dev), "otp", &error_abort);
     s->otp = BCM2835_OTP(obj);
diff --git a/hw/misc/max78000_gcr.c b/hw/misc/max78000_gcr.c
index fbbc92cca32d..0a0692c7cffe 100644
--- a/hw/misc/max78000_gcr.c
+++ b/hw/misc/max78000_gcr.c
@@ -320,7 +320,7 @@ static void max78000_gcr_realize(DeviceState *dev, Error **errp)
 {
     Max78000GcrState *s = MAX78000_GCR(dev);
 
-    address_space_init(&s->sram_as, s->sram, "sram");
+    address_space_init(&s->sram_as, NULL, s->sram, "sram");
 }
 
 static void max78000_gcr_class_init(ObjectClass *klass, const void *data)
diff --git a/hw/misc/tz-mpc.c b/hw/misc/tz-mpc.c
index a158d4a29445..b8be234630e3 100644
--- a/hw/misc/tz-mpc.c
+++ b/hw/misc/tz-mpc.c
@@ -550,9 +550,9 @@ static void tz_mpc_realize(DeviceState *dev, Error **errp)
     memory_region_init_io(&s->blocked_io, obj, &tz_mpc_mem_blocked_ops,
                           s, "tz-mpc-blocked-io", size);
 
-    address_space_init(&s->downstream_as, s->downstream,
+    address_space_init(&s->downstream_as, NULL, s->downstream,
                        "tz-mpc-downstream");
-    address_space_init(&s->blocked_io_as, &s->blocked_io,
+    address_space_init(&s->blocked_io_as, NULL, &s->blocked_io,
                        "tz-mpc-blocked-io");
 
     s->blk_lut = g_new0(uint32_t, s->blk_max);
diff --git a/hw/misc/tz-msc.c b/hw/misc/tz-msc.c
index af0cc5d47186..ed1c95e2e9fa 100644
--- a/hw/misc/tz-msc.c
+++ b/hw/misc/tz-msc.c
@@ -260,7 +260,7 @@ static void tz_msc_realize(DeviceState *dev, Error **errp)
     }
 
     size = memory_region_size(s->downstream);
-    address_space_init(&s->downstream_as, s->downstream, name);
+    address_space_init(&s->downstream_as, NULL, s->downstream, name);
     memory_region_init_io(&s->upstream, obj, &tz_msc_ops, s, name, size);
     sysbus_init_mmio(sbd, &s->upstream);
 }
diff --git a/hw/misc/tz-ppc.c b/hw/misc/tz-ppc.c
index e4235a846d40..28a1c27aa3cc 100644
--- a/hw/misc/tz-ppc.c
+++ b/hw/misc/tz-ppc.c
@@ -276,7 +276,7 @@ static void tz_ppc_realize(DeviceState *dev, Error **errp)
         name = g_strdup_printf("tz-ppc-port[%d]", i);
 
         port->ppc = s;
-        address_space_init(&port->downstream_as, port->downstream, name);
+        address_space_init(&port->downstream_as, NULL, port->downstream, name);
 
         size = memory_region_size(port->downstream);
         memory_region_init_io(&port->upstream, obj, &tz_ppc_ops,
diff --git a/hw/net/allwinner-sun8i-emac.c b/hw/net/allwinner-sun8i-emac.c
index 30a81576b4ce..27160c5ff2a4 100644
--- a/hw/net/allwinner-sun8i-emac.c
+++ b/hw/net/allwinner-sun8i-emac.c
@@ -820,7 +820,7 @@ static void allwinner_sun8i_emac_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    address_space_init(&s->dma_as, s->dma_mr, "emac-dma");
+    address_space_init(&s->dma_as, NULL, s->dma_mr, "emac-dma");
 
     qemu_macaddr_default_if_unset(&s->conf.macaddr);
     s->nic = qemu_new_nic(&net_allwinner_sun8i_emac_info, &s->conf,
diff --git a/hw/net/cadence_gem.c b/hw/net/cadence_gem.c
index 44446666deb2..3ba8ce017194 100644
--- a/hw/net/cadence_gem.c
+++ b/hw/net/cadence_gem.c
@@ -1734,7 +1734,7 @@ static void gem_realize(DeviceState *dev, Error **errp)
     CadenceGEMState *s = CADENCE_GEM(dev);
     int i;
 
-    address_space_init(&s->dma_as,
+    address_space_init(&s->dma_as, NULL,
                        s->dma_mr ? s->dma_mr : get_system_memory(), "dma");
 
     if (s->num_priority_queues == 0 ||
diff --git a/hw/net/dp8393x.c b/hw/net/dp8393x.c
index d49032059bb1..f65d8ef4dd45 100644
--- a/hw/net/dp8393x.c
+++ b/hw/net/dp8393x.c
@@ -908,7 +908,7 @@ static void dp8393x_realize(DeviceState *dev, Error **errp)
 {
     dp8393xState *s = DP8393X(dev);
 
-    address_space_init(&s->as, s->dma_mr, "dp8393x");
+    address_space_init(&s->as, NULL, s->dma_mr, "dp8393x");
     memory_region_init_io(&s->mmio, OBJECT(dev), &dp8393x_ops, s,
                           "dp8393x-regs", SONIC_REG_COUNT << s->it_shift);
 
diff --git a/hw/net/msf2-emac.c b/hw/net/msf2-emac.c
index 59045973ab95..59c380db30dc 100644
--- a/hw/net/msf2-emac.c
+++ b/hw/net/msf2-emac.c
@@ -526,7 +526,7 @@ static void msf2_emac_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    address_space_init(&s->dma_as, s->dma_mr, "emac-ahb");
+    address_space_init(&s->dma_as, NULL, s->dma_mr, "emac-ahb");
 
     qemu_macaddr_default_if_unset(&s->conf.macaddr);
     s->nic = qemu_new_nic(&net_msf2_emac_info, &s->conf,
diff --git a/hw/net/mv88w8618_eth.c b/hw/net/mv88w8618_eth.c
index 6f08846c81ca..1ea294bcced5 100644
--- a/hw/net/mv88w8618_eth.c
+++ b/hw/net/mv88w8618_eth.c
@@ -348,7 +348,7 @@ static void mv88w8618_eth_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    address_space_init(&s->dma_as, s->dma_mr, "emac-dma");
+    address_space_init(&s->dma_as, NULL, s->dma_mr, "emac-dma");
     s->nic = qemu_new_nic(&net_mv88w8618_info, &s->conf,
                           object_get_typename(OBJECT(dev)), dev->id,
                           &dev->mem_reentrancy_guard, s);
diff --git a/hw/nubus/nubus-bus.c b/hw/nubus/nubus-bus.c
index 44820f13a853..1d553be77662 100644
--- a/hw/nubus/nubus-bus.c
+++ b/hw/nubus/nubus-bus.c
@@ -94,7 +94,7 @@ static void nubus_realize(BusState *bus, Error **errp)
         return;
     }
 
-    address_space_init(&nubus->nubus_as, &nubus->nubus_mr, "nubus");
+    address_space_init(&nubus->nubus_as, NULL, &nubus->nubus_mr, "nubus");
 }
 
 static void nubus_init(Object *obj)
diff --git a/hw/pci-host/astro.c b/hw/pci-host/astro.c
index 859e308c577c..bb6b7d05582f 100644
--- a/hw/pci-host/astro.c
+++ b/hw/pci-host/astro.c
@@ -835,7 +835,7 @@ static void astro_realize(DeviceState *obj, Error **errp)
     memory_region_init_iommu(&s->iommu, sizeof(s->iommu),
                              TYPE_ASTRO_IOMMU_MEMORY_REGION, OBJECT(s),
                              "iommu-astro", UINT64_MAX);
-    address_space_init(&s->iommu_as, MEMORY_REGION(&s->iommu),
+    address_space_init(&s->iommu_as, NULL, MEMORY_REGION(&s->iommu),
                        "bm-pci");
 
     /* Create Elroys (PCI host bus chips).  */
diff --git a/hw/pci-host/designware.c b/hw/pci-host/designware.c
index f6e49ce9b8d2..d67211c9bc74 100644
--- a/hw/pci-host/designware.c
+++ b/hw/pci-host/designware.c
@@ -706,7 +706,7 @@ static void designware_pcie_host_realize(DeviceState *dev, Error **errp)
                        UINT64_MAX);
     memory_region_add_subregion(&s->pci.address_space_root,
                                 0x0, &s->pci.memory);
-    address_space_init(&s->pci.address_space,
+    address_space_init(&s->pci.address_space, NULL,
                        &s->pci.address_space_root,
                        "pcie-bus-address-space");
     pci_setup_iommu(pci->bus, &designware_iommu_ops, s);
diff --git a/hw/pci-host/dino.c b/hw/pci-host/dino.c
index 11b353be2eac..b78167fd2fcd 100644
--- a/hw/pci-host/dino.c
+++ b/hw/pci-host/dino.c
@@ -434,7 +434,7 @@ static void dino_pcihost_realize(DeviceState *dev, Error **errp)
     memory_region_add_subregion(&s->bm, 0xfff00000,
                                 &s->bm_cpu_alias);
 
-    address_space_init(&s->bm_as, &s->bm, "pci-bm");
+    address_space_init(&s->bm_as, NULL, &s->bm, "pci-bm");
 }
 
 static void dino_pcihost_unrealize(DeviceState *dev)
diff --git a/hw/pci-host/gt64120.c b/hw/pci-host/gt64120.c
index b1d96f62fe94..68ad885edbe4 100644
--- a/hw/pci-host/gt64120.c
+++ b/hw/pci-host/gt64120.c
@@ -1198,7 +1198,7 @@ static void gt64120_realize(DeviceState *dev, Error **errp)
     memory_region_init_io(&s->ISD_mem, OBJECT(dev), &isd_mem_ops, s,
                           "gt64120-isd", 0x1000);
     memory_region_init(&s->pci0_mem, OBJECT(dev), "pci0-mem", 4 * GiB);
-    address_space_init(&s->pci0_mem_as, &s->pci0_mem, "pci0-mem");
+    address_space_init(&s->pci0_mem_as, NULL, &s->pci0_mem, "pci0-mem");
     phb->bus = pci_root_bus_new(dev, "pci",
                                 &s->pci0_mem,
                                 get_system_io(),
diff --git a/hw/pci-host/pnv_phb3.c b/hw/pci-host/pnv_phb3.c
index 5d8383fac304..73592c9cbd3d 100644
--- a/hw/pci-host/pnv_phb3.c
+++ b/hw/pci-host/pnv_phb3.c
@@ -956,7 +956,7 @@ static AddressSpace *pnv_phb3_dma_iommu(PCIBus *bus, void *opaque, int devfn)
         memory_region_init_iommu(&ds->dma_mr, sizeof(ds->dma_mr),
                                  TYPE_PNV_PHB3_IOMMU_MEMORY_REGION,
                                  OBJECT(phb), "phb3_iommu", UINT64_MAX);
-        address_space_init(&ds->dma_as, MEMORY_REGION(&ds->dma_mr),
+        address_space_init(&ds->dma_as, NULL, MEMORY_REGION(&ds->dma_mr),
                            "phb3_iommu");
         memory_region_init_io(&ds->msi32_mr, OBJECT(phb), &pnv_phb3_msi_ops,
                               ds, "msi32", 0x10000);
diff --git a/hw/pci-host/pnv_phb4.c b/hw/pci-host/pnv_phb4.c
index 18992054e831..9db9268358d1 100644
--- a/hw/pci-host/pnv_phb4.c
+++ b/hw/pci-host/pnv_phb4.c
@@ -1469,7 +1469,7 @@ static AddressSpace *pnv_phb4_dma_iommu(PCIBus *bus, void *opaque, int devfn)
         memory_region_init_iommu(&ds->dma_mr, sizeof(ds->dma_mr),
                                  TYPE_PNV_PHB4_IOMMU_MEMORY_REGION,
                                  OBJECT(phb), name, UINT64_MAX);
-        address_space_init(&ds->dma_as, MEMORY_REGION(&ds->dma_mr),
+        address_space_init(&ds->dma_as, NULL, MEMORY_REGION(&ds->dma_mr),
                            name);
         memory_region_init_io(&ds->msi32_mr, OBJECT(phb), &pnv_phb4_msi_ops,
                               ds, "msi32", 0x10000);
diff --git a/hw/pci-host/ppc440_pcix.c b/hw/pci-host/ppc440_pcix.c
index 744b85e49cc4..3fe24d70ac30 100644
--- a/hw/pci-host/ppc440_pcix.c
+++ b/hw/pci-host/ppc440_pcix.c
@@ -502,7 +502,7 @@ static void ppc440_pcix_realize(DeviceState *dev, Error **errp)
 
     memory_region_init(&s->bm, OBJECT(s), "bm-ppc440-pcix", UINT64_MAX);
     memory_region_add_subregion(&s->bm, 0x0, &s->busmem);
-    address_space_init(&s->bm_as, &s->bm, "pci-bm");
+    address_space_init(&s->bm_as, NULL, &s->bm, "pci-bm");
     pci_setup_iommu(h->bus, &ppc440_iommu_ops, s);
 
     memory_region_init(&s->container, OBJECT(s), "pci-container", PCI_ALL_SIZE);
diff --git a/hw/pci-host/ppce500.c b/hw/pci-host/ppce500.c
index 975d191ccb8e..eda168fb5955 100644
--- a/hw/pci-host/ppce500.c
+++ b/hw/pci-host/ppce500.c
@@ -470,7 +470,7 @@ static void e500_pcihost_realize(DeviceState *dev, Error **errp)
     /* Set up PCI view of memory */
     memory_region_init(&s->bm, OBJECT(s), "bm-e500", UINT64_MAX);
     memory_region_add_subregion(&s->bm, 0x0, &s->busmem);
-    address_space_init(&s->bm_as, &s->bm, "pci-bm");
+    address_space_init(&s->bm_as, NULL, &s->bm, "pci-bm");
     pci_setup_iommu(b, &ppce500_iommu_ops, s);
 
     pci_create_simple(b, 0, TYPE_PPC_E500_PCI_BRIDGE);
diff --git a/hw/pci-host/raven.c b/hw/pci-host/raven.c
index fd45acb7ebd6..5564b51d6755 100644
--- a/hw/pci-host/raven.c
+++ b/hw/pci-host/raven.c
@@ -214,7 +214,7 @@ static void raven_pcihost_realize(DeviceState *d, Error **errp)
     memory_region_init_alias(mr, o, "bm-system", get_system_memory(),
                              0, 0x80000000);
     memory_region_add_subregion(bm, 0x80000000, mr);
-    address_space_init(&s->bm_as, bm, "raven-bm-as");
+    address_space_init(&s->bm_as, NULL, bm, "raven-bm-as");
     pci_setup_iommu(h->bus, &raven_iommu_ops, s);
 }
 
diff --git a/hw/pci/pci.c b/hw/pci/pci.c
index 2b408c7ec336..340384a8876a 100644
--- a/hw/pci/pci.c
+++ b/hw/pci/pci.c
@@ -1359,7 +1359,7 @@ static PCIDevice *do_pci_register_device(PCIDevice *pci_dev,
 
     memory_region_init(&pci_dev->bus_master_container_region, OBJECT(pci_dev),
                        "bus master container", UINT64_MAX);
-    address_space_init(&pci_dev->bus_master_as,
+    address_space_init(&pci_dev->bus_master_as, NULL,
                        &pci_dev->bus_master_container_region, pci_dev->name);
     pci_dev->bus_master_as.max_bounce_buffer_size =
         pci_dev->max_bounce_buffer_size;
diff --git a/hw/pci/pci_bridge.c b/hw/pci/pci_bridge.c
index 240d0f904de9..94b61b907ea2 100644
--- a/hw/pci/pci_bridge.c
+++ b/hw/pci/pci_bridge.c
@@ -388,12 +388,13 @@ void pci_bridge_initfn(PCIDevice *dev, const char *typename)
     sec_bus->map_irq = br->map_irq ? br->map_irq : pci_swizzle_map_irq_fn;
     sec_bus->address_space_mem = &br->address_space_mem;
     memory_region_init(&br->address_space_mem, OBJECT(br), "pci_bridge_pci", UINT64_MAX);
-    address_space_init(&br->as_mem, &br->address_space_mem,
+    address_space_init(&br->as_mem, NULL, &br->address_space_mem,
                        "pci_bridge_pci_mem");
     sec_bus->address_space_io = &br->address_space_io;
     memory_region_init(&br->address_space_io, OBJECT(br), "pci_bridge_io",
                        4 * GiB);
-    address_space_init(&br->as_io, &br->address_space_io, "pci_bridge_pci_io");
+    address_space_init(&br->as_io, NULL, &br->address_space_io,
+                       "pci_bridge_pci_io");
     pci_bridge_region_update(br, true);
     QLIST_INIT(&sec_bus->child);
     QLIST_INSERT_HEAD(&parent->child, sec_bus, sibling);
diff --git a/hw/ppc/pnv_lpc.c b/hw/ppc/pnv_lpc.c
index f6beba0917dd..373b5a8be573 100644
--- a/hw/ppc/pnv_lpc.c
+++ b/hw/ppc/pnv_lpc.c
@@ -799,7 +799,7 @@ static void pnv_lpc_realize(DeviceState *dev, Error **errp)
 
     /* Create address space and backing MR for the OPB bus */
     memory_region_init(&lpc->opb_mr, OBJECT(dev), "lpc-opb", 0x100000000ull);
-    address_space_init(&lpc->opb_as, &lpc->opb_mr, "lpc-opb");
+    address_space_init(&lpc->opb_as, NULL, &lpc->opb_mr, "lpc-opb");
 
     /*
      * Create ISA IO, Mem, and FW space regions which are the root of
diff --git a/hw/ppc/pnv_xscom.c b/hw/ppc/pnv_xscom.c
index fbfec829d5b6..58f86bcbd2a6 100644
--- a/hw/ppc/pnv_xscom.c
+++ b/hw/ppc/pnv_xscom.c
@@ -219,7 +219,7 @@ void pnv_xscom_init(PnvChip *chip, uint64_t size, hwaddr addr)
     memory_region_add_subregion(get_system_memory(), addr, &chip->xscom_mmio);
 
     memory_region_init(&chip->xscom, OBJECT(chip), name, size);
-    address_space_init(&chip->xscom_as, &chip->xscom, name);
+    address_space_init(&chip->xscom_as, NULL, &chip->xscom, name);
     g_free(name);
 }
 
diff --git a/hw/ppc/spapr_pci.c b/hw/ppc/spapr_pci.c
index b4043ee752c5..13fc5c9aa8f2 100644
--- a/hw/ppc/spapr_pci.c
+++ b/hw/ppc/spapr_pci.c
@@ -1902,7 +1902,7 @@ static void spapr_phb_realize(DeviceState *dev, Error **errp)
     memory_region_init(&sphb->iommu_root, OBJECT(sphb),
                        namebuf, UINT64_MAX);
     g_free(namebuf);
-    address_space_init(&sphb->iommu_as, &sphb->iommu_root,
+    address_space_init(&sphb->iommu_as, NULL, &sphb->iommu_root,
                        sphb->dtbusname);
 
     /*
diff --git a/hw/ppc/spapr_vio.c b/hw/ppc/spapr_vio.c
index 7759436a4f55..ebe4bad23668 100644
--- a/hw/ppc/spapr_vio.c
+++ b/hw/ppc/spapr_vio.c
@@ -529,7 +529,7 @@ static void spapr_vio_busdev_realize(DeviceState *qdev, Error **errp)
                                  "iommu-spapr-bypass", get_system_memory(),
                                  0, MACHINE(spapr)->ram_size);
         memory_region_add_subregion_overlap(&dev->mrroot, 0, &dev->mrbypass, 1);
-        address_space_init(&dev->as, &dev->mrroot, qdev->id);
+        address_space_init(&dev->as, NULL, &dev->mrroot, qdev->id);
 
         dev->tcet = spapr_tce_new_table(qdev, liobn);
         spapr_tce_table_enable(dev->tcet, SPAPR_TCE_PAGE_SHIFT, 0,
diff --git a/hw/remote/iommu.c b/hw/remote/iommu.c
index 3e0758a21ed6..aac5c178ec81 100644
--- a/hw/remote/iommu.c
+++ b/hw/remote/iommu.c
@@ -54,7 +54,7 @@ static AddressSpace *remote_iommu_find_add_as(PCIBus *pci_bus,
     if (!elem->mr) {
         elem->mr = MEMORY_REGION(object_new(TYPE_MEMORY_REGION));
         memory_region_set_size(elem->mr, UINT64_MAX);
-        address_space_init(&elem->as, elem->mr, NULL);
+        address_space_init(&elem->as, NULL, elem->mr, NULL);
     }
 
     qemu_mutex_unlock(&iommu->lock);
diff --git a/hw/riscv/riscv-iommu.c b/hw/riscv/riscv-iommu.c
index 96a7fbdefcf3..aed84d87a823 100644
--- a/hw/riscv/riscv-iommu.c
+++ b/hw/riscv/riscv-iommu.c
@@ -1221,7 +1221,8 @@ static AddressSpace *riscv_iommu_space(RISCVIOMMUState *s, uint32_t devid)
         memory_region_init_iommu(&as->iova_mr, sizeof(as->iova_mr),
             TYPE_RISCV_IOMMU_MEMORY_REGION,
             OBJECT(as), "riscv_iommu", UINT64_MAX);
-        address_space_init(&as->iova_as, MEMORY_REGION(&as->iova_mr), name);
+        address_space_init(&as->iova_as, NULL, MEMORY_REGION(&as->iova_mr),
+                           name);
 
         QLIST_INSERT_HEAD(&s->spaces, as, list);
 
@@ -2426,7 +2427,7 @@ static void riscv_iommu_realize(DeviceState *dev, Error **errp)
     /* Memory region for downstream access, if specified. */
     if (s->target_mr) {
         s->target_as = g_new0(AddressSpace, 1);
-        address_space_init(s->target_as, s->target_mr,
+        address_space_init(s->target_as, NULL, s->target_mr,
             "riscv-iommu-downstream");
     } else {
         /* Fallback to global system memory. */
@@ -2436,7 +2437,7 @@ static void riscv_iommu_realize(DeviceState *dev, Error **errp)
     /* Memory region for untranslated MRIF/MSI writes */
     memory_region_init_io(&s->trap_mr, OBJECT(dev), &riscv_iommu_trap_ops, s,
             "riscv-iommu-trap", ~0ULL);
-    address_space_init(&s->trap_as, &s->trap_mr, "riscv-iommu-trap-as");
+    address_space_init(&s->trap_as, NULL, &s->trap_mr, "riscv-iommu-trap-as");
 
     if (s->cap & RISCV_IOMMU_CAP_HPM) {
         s->hpm_timer =
diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index f87d2748b637..67fce1c133b0 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -628,7 +628,7 @@ static S390PCIIOMMU *s390_pci_get_iommu(S390pciState *s, PCIBus *bus,
                                         PCI_SLOT(devfn),
                                         PCI_FUNC(devfn));
         memory_region_init(&iommu->mr, OBJECT(iommu), mr_name, UINT64_MAX);
-        address_space_init(&iommu->as, &iommu->mr, as_name);
+        address_space_init(&iommu->as, NULL, &iommu->mr, as_name);
         iommu->iotlb = g_hash_table_new_full(g_int64_hash, g_int64_equal,
                                              NULL, g_free);
         table->iommu[PCI_SLOT(devfn)] = iommu;
diff --git a/hw/scsi/lsi53c895a.c b/hw/scsi/lsi53c895a.c
index 9ea4aa0a853a..ee21b3c0d08a 100644
--- a/hw/scsi/lsi53c895a.c
+++ b/hw/scsi/lsi53c895a.c
@@ -2356,7 +2356,8 @@ static void lsi_scsi_realize(PCIDevice *dev, Error **errp)
     s->ram_io.disable_reentrancy_guard = true;
     s->mmio_io.disable_reentrancy_guard = true;
 
-    address_space_init(&s->pci_io_as, pci_address_space_io(dev), "lsi-pci-io");
+    address_space_init(&s->pci_io_as, NULL, pci_address_space_io(dev),
+                       "lsi-pci-io");
     qdev_init_gpio_out(d, &s->ext_irq, 1);
 
     pci_register_bar(dev, 0, PCI_BASE_ADDRESS_SPACE_IO, &s->io_io);
diff --git a/hw/sd/allwinner-sdhost.c b/hw/sd/allwinner-sdhost.c
index 9d61b372e706..158d434e7fde 100644
--- a/hw/sd/allwinner-sdhost.c
+++ b/hw/sd/allwinner-sdhost.c
@@ -832,7 +832,7 @@ static void allwinner_sdhost_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    address_space_init(&s->dma_as, s->dma_mr, "sdhost-dma");
+    address_space_init(&s->dma_as, NULL, s->dma_mr, "sdhost-dma");
 }
 
 static void allwinner_sdhost_reset(DeviceState *dev)
diff --git a/hw/sd/sdhci.c b/hw/sd/sdhci.c
index 89b595ce4a5a..c6a203744463 100644
--- a/hw/sd/sdhci.c
+++ b/hw/sd/sdhci.c
@@ -1594,7 +1594,7 @@ static void sdhci_sysbus_realize(DeviceState *dev, Error **errp)
 
     if (s->dma_mr) {
         s->dma_as = &s->sysbus_dma_as;
-        address_space_init(s->dma_as, s->dma_mr, "sdhci-dma");
+        address_space_init(s->dma_as, NULL, s->dma_mr, "sdhci-dma");
     } else {
         /* use system_memory() if property "dma" not set */
         s->dma_as = &address_space_memory;
diff --git a/hw/sparc/sun4m_iommu.c b/hw/sparc/sun4m_iommu.c
index a7ff36ee78c1..7b8d78273b97 100644
--- a/hw/sparc/sun4m_iommu.c
+++ b/hw/sparc/sun4m_iommu.c
@@ -359,7 +359,8 @@ static void iommu_init(Object *obj)
     memory_region_init_iommu(&s->iommu, sizeof(s->iommu),
                              TYPE_SUN4M_IOMMU_MEMORY_REGION, OBJECT(dev),
                              "iommu-sun4m", UINT64_MAX);
-    address_space_init(&s->iommu_as, MEMORY_REGION(&s->iommu), "iommu-as");
+    address_space_init(&s->iommu_as, NULL, MEMORY_REGION(&s->iommu),
+                       "iommu-as");
 
     sysbus_init_irq(dev, &s->irq);
 
diff --git a/hw/sparc64/sun4u_iommu.c b/hw/sparc64/sun4u_iommu.c
index 14645f475a09..0a5703044e7a 100644
--- a/hw/sparc64/sun4u_iommu.c
+++ b/hw/sparc64/sun4u_iommu.c
@@ -298,7 +298,8 @@ static void iommu_init(Object *obj)
     memory_region_init_iommu(&s->iommu, sizeof(s->iommu),
                              TYPE_SUN4U_IOMMU_MEMORY_REGION, OBJECT(s),
                              "iommu-sun4u", UINT64_MAX);
-    address_space_init(&s->iommu_as, MEMORY_REGION(&s->iommu), "iommu-as");
+    address_space_init(&s->iommu_as, NULL, MEMORY_REGION(&s->iommu),
+                       "iommu-as");
 
     memory_region_init_io(&s->iomem, obj, &iommu_mem_ops, s, "iommu",
                           IOMMU_NREGS * sizeof(uint64_t));
diff --git a/hw/ssi/aspeed_smc.c b/hw/ssi/aspeed_smc.c
index e33496f50298..7e41d4210330 100644
--- a/hw/ssi/aspeed_smc.c
+++ b/hw/ssi/aspeed_smc.c
@@ -1191,9 +1191,9 @@ static void aspeed_smc_dma_setup(AspeedSMCState *s, Error **errp)
         return;
     }
 
-    address_space_init(&s->flash_as, &s->mmio_flash,
+    address_space_init(&s->flash_as, NULL, &s->mmio_flash,
                        TYPE_ASPEED_SMC ".dma-flash");
-    address_space_init(&s->dram_as, s->dram_mr,
+    address_space_init(&s->dram_as, NULL, s->dram_mr,
                        TYPE_ASPEED_SMC ".dma-dram");
 }
 
diff --git a/hw/usb/hcd-dwc2.c b/hw/usb/hcd-dwc2.c
index 83864505bb89..8aaa696dd4de 100644
--- a/hw/usb/hcd-dwc2.c
+++ b/hw/usb/hcd-dwc2.c
@@ -1351,7 +1351,7 @@ static void dwc2_realize(DeviceState *dev, Error **errp)
     obj = object_property_get_link(OBJECT(dev), "dma-mr", &error_abort);
 
     s->dma_mr = MEMORY_REGION(obj);
-    address_space_init(&s->dma_as, s->dma_mr, "dwc2");
+    address_space_init(&s->dma_as, NULL, s->dma_mr, "dwc2");
 
     usb_bus_new(&s->bus, sizeof(s->bus), &dwc2_bus_ops, dev);
     usb_register_port(&s->bus, &s->uport, s, 0, &dwc2_port_ops,
diff --git a/hw/usb/hcd-xhci-sysbus.c b/hw/usb/hcd-xhci-sysbus.c
index 244698e5f2b9..6d060062ab86 100644
--- a/hw/usb/hcd-xhci-sysbus.c
+++ b/hw/usb/hcd-xhci-sysbus.c
@@ -45,7 +45,7 @@ static void xhci_sysbus_realize(DeviceState *dev, Error **errp)
                              s->xhci.numintrs);
     if (s->xhci.dma_mr) {
         s->xhci.as =  g_malloc0(sizeof(AddressSpace));
-        address_space_init(s->xhci.as, s->xhci.dma_mr, NULL);
+        address_space_init(s->xhci.as, NULL, s->xhci.dma_mr, NULL);
     } else {
         s->xhci.as = &address_space_memory;
     }
diff --git a/hw/virtio/virtio-iommu.c b/hw/virtio/virtio-iommu.c
index 3500f1b0820c..d9713a38bfae 100644
--- a/hw/virtio/virtio-iommu.c
+++ b/hw/virtio/virtio-iommu.c
@@ -430,7 +430,7 @@ static AddressSpace *virtio_iommu_find_add_as(PCIBus *bus, void *opaque,
         trace_virtio_iommu_init_iommu_mr(name);
 
         memory_region_init(&sdev->root, OBJECT(s), name, UINT64_MAX);
-        address_space_init(&sdev->as, &sdev->root, TYPE_VIRTIO_IOMMU);
+        address_space_init(&sdev->as, NULL, &sdev->root, TYPE_VIRTIO_IOMMU);
         add_prop_resv_regions(sdev);
 
         /*
diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index 767216d79599..a3cd8f642706 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -2062,7 +2062,7 @@ static void virtio_pci_device_plugged(DeviceState *d, Error **errp)
         if (modern_pio) {
             memory_region_init(&proxy->io_bar, OBJECT(proxy),
                                "virtio-pci-io", 0x4);
-            address_space_init(&proxy->modern_cfg_io_as, &proxy->io_bar,
+            address_space_init(&proxy->modern_cfg_io_as, NULL, &proxy->io_bar,
                                "virtio-pci-cfg-io-as");
 
             pci_register_bar(&proxy->pci_dev, proxy->modern_io_bar_idx,
@@ -2199,7 +2199,7 @@ static void virtio_pci_realize(PCIDevice *pci_dev, Error **errp)
                        /* PCI BAR regions must be powers of 2 */
                        pow2ceil(proxy->notify.offset + proxy->notify.size));
 
-    address_space_init(&proxy->modern_cfg_mem_as, &proxy->modern_bar,
+    address_space_init(&proxy->modern_cfg_mem_as, NULL, &proxy->modern_bar,
                        "virtio-pci-cfg-mem-as");
 
     if (proxy->disable_legacy == ON_OFF_AUTO_AUTO) {
diff --git a/system/memory.c b/system/memory.c
index 56465479406f..7a77ba0f1797 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -3203,8 +3203,14 @@ void address_space_remove_listeners(AddressSpace *as)
     }
 }
 
-void address_space_init(AddressSpace *as, MemoryRegion *root, const char *name)
+void address_space_init(AddressSpace *as, Object *parent, MemoryRegion *root,
+                        const char *name)
 {
+    if (parent) {
+        object_initialize_child(parent, name, as, TYPE_ADDRESS_SPACE);
+    }
+
+    as->qom = parent;
     memory_region_ref(root);
     as->root = root;
     as->current_map = NULL;
@@ -3221,8 +3227,10 @@ void address_space_init(AddressSpace *as, MemoryRegion *root, const char *name)
     address_space_update_ioeventfds(as);
 }
 
-static void do_address_space_destroy(AddressSpace *as)
+static void do_address_space_destroy(struct rcu_head *head)
 {
+    AddressSpace *as = container_of(head, AddressSpace, rcu);
+
     assert(qatomic_read(&as->bounce_buffer_size) == 0);
     assert(QLIST_EMPTY(&as->map_client_list));
     qemu_mutex_destroy(&as->map_client_list_lock);
@@ -3235,6 +3243,11 @@ static void do_address_space_destroy(AddressSpace *as)
     memory_region_unref(as->root);
 }
 
+static void address_space_finalize(Object *obj)
+{
+    address_space_destroy(ADDRESS_SPACE(obj));
+}
+
 void address_space_destroy(AddressSpace *as)
 {
     MemoryRegion *root = as->root;
@@ -3250,7 +3263,20 @@ void address_space_destroy(AddressSpace *as)
      * values to expire before freeing the data.
      */
     as->root = root;
-    call_rcu(as, do_address_space_destroy, rcu);
+    call_rcu1(&as->rcu, do_address_space_destroy);
+}
+
+char *address_space_get_path(AddressSpace *as)
+{
+    char *path;
+
+    if (!as->qom) {
+        return as->name;
+    }
+
+    path = object_get_canonical_path(OBJECT(as));
+
+    return path ? path : g_strdup("orphan");
 }
 
 static const char *memory_region_type(MemoryRegion *mr)
@@ -3455,9 +3481,12 @@ static void mtree_print_flatview(gpointer key, gpointer value,
     ++fvi->counter;
 
     for (i = 0; i < fv_address_spaces->len; ++i) {
+        g_autofree char *path = NULL;
+
         as = g_array_index(fv_address_spaces, AddressSpace*, i);
+        path = address_space_get_path(as);
         qemu_printf(" AS \"%s\", root: %s",
-                    as->name, memory_region_name(as->root));
+                    path, memory_region_name(as->root));
         if (as->root->alias) {
             qemu_printf(", alias %s", memory_region_name(as->root->alias));
         }
@@ -3580,19 +3609,14 @@ struct AddressSpaceInfo {
 };
 
 /* Returns negative value if a < b; zero if a = b; positive value if a > b. */
-static gint address_space_compare_name(gconstpointer a, gconstpointer b)
+static gint address_space_compare_path(gconstpointer a, gconstpointer b)
 {
-    const AddressSpace *as_a = a;
-    const AddressSpace *as_b = b;
-
-    return g_strcmp0(as_a->name, as_b->name);
+    return g_strcmp0(a, b);
 }
 
-static void mtree_print_as_name(gpointer data, gpointer user_data)
+static void mtree_print_as_path(gpointer data, gpointer user_data)
 {
-    AddressSpace *as = data;
-
-    qemu_printf("address-space: %s\n", as->name);
+    qemu_printf("address-space: %s\n", (char *)data);
 }
 
 static void mtree_print_as(gpointer key, gpointer value, gpointer user_data)
@@ -3601,7 +3625,7 @@ static void mtree_print_as(gpointer key, gpointer value, gpointer user_data)
     GSList *as_same_root_mr_list = value;
     struct AddressSpaceInfo *asi = user_data;
 
-    g_slist_foreach(as_same_root_mr_list, mtree_print_as_name, NULL);
+    g_slist_foreach(as_same_root_mr_list, mtree_print_as_path, NULL);
     mtree_print_mr(mr, 1, 0, asi->ml_head, asi->owner, asi->disabled);
     qemu_printf("\n");
 }
@@ -3611,7 +3635,7 @@ static gboolean mtree_info_as_free(gpointer key, gpointer value,
 {
     GSList *as_same_root_mr_list = value;
 
-    g_slist_free(as_same_root_mr_list);
+    g_slist_free_full(as_same_root_mr_list, g_free);
 
     return true;
 }
@@ -3632,10 +3656,12 @@ static void mtree_info_as(bool dispatch_tree, bool owner, bool disabled)
     QTAILQ_INIT(&ml_head);
 
     QTAILQ_FOREACH(as, &address_spaces, address_spaces_link) {
+        char *path = address_space_get_path(as);
+
         /* Create hashtable, key=AS root MR, value = list of AS */
         as_same_root_mr_list = g_hash_table_lookup(views, as->root);
-        as_same_root_mr_list = g_slist_insert_sorted(as_same_root_mr_list, as,
-                                                     address_space_compare_name);
+        as_same_root_mr_list = g_slist_insert_sorted(as_same_root_mr_list, path,
+                                                     address_space_compare_path);
         g_hash_table_insert(views, as->root, as_same_root_mr_list);
     }
 
@@ -3797,11 +3823,18 @@ static const TypeInfo ram_discard_manager_info = {
     .class_size         = sizeof(RamDiscardManagerClass),
 };
 
+static const TypeInfo address_space_info = {
+    .parent             = TYPE_OBJECT,
+    .name               = TYPE_ADDRESS_SPACE,
+    .instance_finalize  = address_space_finalize
+};
+
 static void memory_register_types(void)
 {
     type_register_static(&memory_region_info);
     type_register_static(&iommu_memory_region_info);
     type_register_static(&ram_discard_manager_info);
+    type_register_static(&address_space_info);
 }
 
 type_init(memory_register_types)
diff --git a/system/physmem.c b/system/physmem.c
index e5dd760e0bca..6190eca7daed 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -782,7 +782,7 @@ void cpu_address_space_init(CPUState *cpu, int asidx,
 
     assert(mr);
     as_name = g_strdup_printf("%s-%d", prefix, cpu->cpu_index);
-    address_space_init(as, mr, as_name);
+    address_space_init(as, NULL, mr, as_name);
     g_free(as_name);
 
     /* Target code should have set num_ases before calling us */
@@ -812,6 +812,11 @@ void cpu_address_space_init(CPUState *cpu, int asidx,
     }
 }
 
+static void address_space_free(struct rcu_head *head)
+{
+    g_free(container_of(head, AddressSpace, rcu));
+}
+
 void cpu_address_space_destroy(CPUState *cpu, int asidx)
 {
     CPUAddressSpace *cpuas;
@@ -827,7 +832,7 @@ void cpu_address_space_destroy(CPUState *cpu, int asidx)
     }
 
     address_space_destroy(cpuas->as);
-    g_free_rcu(cpuas->as, rcu);
+    call_rcu1(&cpuas->as->rcu, address_space_free);
 
     if (asidx == 0) {
         /* reset the convenience alias for address space 0 */
@@ -2812,12 +2817,12 @@ static void memory_map_init(void)
     system_memory = g_malloc(sizeof(*system_memory));
 
     memory_region_init(system_memory, NULL, "system", UINT64_MAX);
-    address_space_init(&address_space_memory, system_memory, "memory");
+    address_space_init(&address_space_memory, NULL, system_memory, "memory");
 
     system_io = g_malloc(sizeof(*system_io));
     memory_region_init_io(system_io, NULL, &unassigned_io_ops, NULL, "io",
                           65536);
-    address_space_init(&address_space_io, system_io, "I/O");
+    address_space_init(&address_space_io, NULL, system_io, "I/O");
 }
 
 MemoryRegion *get_system_memory(void)
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 369626f8c8d7..2ce071dfafb2 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2725,7 +2725,7 @@ static void register_smram_listener(Notifier *n, void *unused)
         memory_region_set_enabled(smram, true);
     }
 
-    address_space_init(&smram_address_space, &smram_as_root, "KVM-SMRAM");
+    address_space_init(&smram_address_space, NULL, &smram_as_root, "KVM-SMRAM");
     kvm_memory_listener_register(kvm_state, &smram_listener,
                                  &smram_address_space, 1, "kvm-smram");
 }
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 1f6c41fd3401..b13df32e6479 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -505,7 +505,7 @@ static void mips_cpu_initfn(Object *obj)
     if (mcc->cpu_def->lcsr_cpucfg2 & (1 << CPUCFG2_LCSRP)) {
         memory_region_init_io(&env->iocsr.mr, OBJECT(cpu), NULL,
                                 env, "iocsr", UINT64_MAX);
-        address_space_init(&env->iocsr.as,
+        address_space_init(&env->iocsr.as, NULL,
                             &env->iocsr.mr, "IOCSR");
     }
 #endif
diff --git a/target/xtensa/cpu.c b/target/xtensa/cpu.c
index ea9b6df3aa24..26a1c87a7856 100644
--- a/target/xtensa/cpu.c
+++ b/target/xtensa/cpu.c
@@ -272,7 +272,7 @@ static void xtensa_cpu_initfn(Object *obj)
     env->system_er = g_malloc(sizeof(*env->system_er));
     memory_region_init_io(env->system_er, obj, NULL, env, "er",
                           UINT64_C(0x100000000));
-    address_space_init(env->address_space_er, env->system_er, "ER");
+    address_space_init(env->address_space_er, NULL, env->system_er, "ER");
 
     cpu->clock = qdev_init_clock_in(DEVICE(obj), "clk-in", NULL, cpu, 0);
     clock_set_hz(cpu->clock, env->config->clock_freq_khz * 1000);

-- 
2.51.0


