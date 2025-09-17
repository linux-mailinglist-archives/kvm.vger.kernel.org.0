Return-Path: <kvm+bounces-57879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 755EFB7F373
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:25:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2F3E4A641C
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2170133594B;
	Wed, 17 Sep 2025 13:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="FvaXOvL0"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BCF2DA76C
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114319; cv=none; b=TwAANqYWRuunTtmZMVSbc2dDJH3szI1sGXTGZklagLExtERPH6x6LCeW7Pv7wBdUItwSyK+PHSBpyZDsqTn4MNJhbdAZgi6kBA1/5vgTK2fibOjuu+vLQ0kLzGL5CuBiUyONPHKmL6188dddTOr0pdws2bDiooQM8VqC2j78TD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114319; c=relaxed/simple;
	bh=Ma/aT/zI25HF3XELS3bMHPy9KF48thbpCNP2uxl5mAs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oDGVG738zpdMn+ypaYgqSIYC3K/8VHkDgFvufn7AdUXIqufWCv/LA/cL2UVIZKxti13lF79ibkO7hkM46cWaWX/mcFchaf8NXbwxL2YQS4VXuopw0SeJxE2ZLG+mzxNORN0PpapIuKBSQUDEF8/pnWh8E1sOZT/sYGPMci9R4/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=FvaXOvL0 reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN6x008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:46 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=2k1RXsuysZJUUbooF4SQHx4mO+9R1oof00yibd4tPt8=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1758113807; v=1;
        b=FvaXOvL0NzIYuie5l9DQdrEVrjLdBmVmO2Z5k3XIcvMFwZzDcBEwIZaN2DUwCRf9
         TmpX9robixIPy+LNyaFa60g9E1eZrfW/ygqhDOD+6e5VOk1+j+FCwAsKGqGFZpYg
         RTMTEikUoYBvo6ihFgFS4J1f/lE0L65s0MRSZANMhV+vHphVLaypaKAkFOW+7t3B
         +g45JKUixe7q7xlyuh2MH3yPwty6t3xOsLG2tTrTemCQrVtsgXUMjLa9jVTK3ITv
         opFWLFKv3yRuB/V/6TgY/MKGRni25HSzwYN5CWeU3aFp3S3jU1B4cl2RN5yehiod
         kR4HtnZxXPba6n+ID0vytg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 17 Sep 2025 21:56:31 +0900
Subject: [PATCH 19/35] hw/ppc: QOM-ify AddressSpace
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250917-qom-v1-19-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
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
 hw/ppc/pnv_lpc.c   | 2 +-
 hw/ppc/pnv_xscom.c | 2 +-
 hw/ppc/spapr_pci.c | 5 ++---
 hw/ppc/spapr_vio.c | 2 +-
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/hw/ppc/pnv_lpc.c b/hw/ppc/pnv_lpc.c
index 373b5a8be573..304f01e240db 100644
--- a/hw/ppc/pnv_lpc.c
+++ b/hw/ppc/pnv_lpc.c
@@ -799,7 +799,7 @@ static void pnv_lpc_realize(DeviceState *dev, Error **errp)
 
     /* Create address space and backing MR for the OPB bus */
     memory_region_init(&lpc->opb_mr, OBJECT(dev), "lpc-opb", 0x100000000ull);
-    address_space_init(&lpc->opb_as, NULL, &lpc->opb_mr, "lpc-opb");
+    address_space_init(&lpc->opb_as, OBJECT(dev), &lpc->opb_mr, "as");
 
     /*
      * Create ISA IO, Mem, and FW space regions which are the root of
diff --git a/hw/ppc/pnv_xscom.c b/hw/ppc/pnv_xscom.c
index 58f86bcbd2a6..353eb9b14e29 100644
--- a/hw/ppc/pnv_xscom.c
+++ b/hw/ppc/pnv_xscom.c
@@ -219,7 +219,7 @@ void pnv_xscom_init(PnvChip *chip, uint64_t size, hwaddr addr)
     memory_region_add_subregion(get_system_memory(), addr, &chip->xscom_mmio);
 
     memory_region_init(&chip->xscom, OBJECT(chip), name, size);
-    address_space_init(&chip->xscom_as, NULL, &chip->xscom, name);
+    address_space_init(&chip->xscom_as, OBJECT(chip), &chip->xscom, "as");
     g_free(name);
 }
 
diff --git a/hw/ppc/spapr_pci.c b/hw/ppc/spapr_pci.c
index 13fc5c9aa8f2..41bf65b291de 100644
--- a/hw/ppc/spapr_pci.c
+++ b/hw/ppc/spapr_pci.c
@@ -1759,7 +1759,7 @@ static void spapr_phb_unrealize(DeviceState *dev)
      * address space.
      */
     address_space_remove_listeners(&sphb->iommu_as);
-    address_space_destroy(&sphb->iommu_as);
+    object_unparent(OBJECT(&sphb->iommu_as));
 
     qbus_set_hotplug_handler(BUS(phb->bus), NULL);
     pci_unregister_root_bus(phb->bus);
@@ -1902,8 +1902,7 @@ static void spapr_phb_realize(DeviceState *dev, Error **errp)
     memory_region_init(&sphb->iommu_root, OBJECT(sphb),
                        namebuf, UINT64_MAX);
     g_free(namebuf);
-    address_space_init(&sphb->iommu_as, NULL, &sphb->iommu_root,
-                       sphb->dtbusname);
+    address_space_init(&sphb->iommu_as, OBJECT(sphb), &sphb->iommu_root, "as");
 
     /*
      * As MSI/MSIX interrupts trigger by writing at MSI/MSIX vectors,
diff --git a/hw/ppc/spapr_vio.c b/hw/ppc/spapr_vio.c
index ebe4bad23668..5f8dd153dedf 100644
--- a/hw/ppc/spapr_vio.c
+++ b/hw/ppc/spapr_vio.c
@@ -529,7 +529,7 @@ static void spapr_vio_busdev_realize(DeviceState *qdev, Error **errp)
                                  "iommu-spapr-bypass", get_system_memory(),
                                  0, MACHINE(spapr)->ram_size);
         memory_region_add_subregion_overlap(&dev->mrroot, 0, &dev->mrbypass, 1);
-        address_space_init(&dev->as, NULL, &dev->mrroot, qdev->id);
+        address_space_init(&dev->as, OBJECT(dev), &dev->mrroot, "as");
 
         dev->tcet = spapr_tce_new_table(qdev, liobn);
         spapr_tce_table_enable(dev->tcet, SPAPR_TCE_PAGE_SHIFT, 0,

-- 
2.51.0


