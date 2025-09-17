Return-Path: <kvm+bounces-57855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 705A1B7F20B
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFB862A4939
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC88F37C10A;
	Wed, 17 Sep 2025 12:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="IakF6xb1"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6E6333A92
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 12:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113985; cv=none; b=Hbh6TIx/qi9d7rVI3rEBLSI+5AcSAob4qerwwHXJA80Q5yhFxptWXvz7CGVtmCOsciHvapKDZe4iskakIqpI6yxow78izGKDJIYveOiinrOQD3IPqIuGsMq77U+ATG+hI3cnc44YwZWjIjvPO2uv9+AR6ykBD65JA97aqdNn3UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113985; c=relaxed/simple;
	bh=PbZ0tM+EsK5vw3NSP1YP5YvasL7E11UptdYIspuqjng=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rlI+aqpnbX8DdB5CfVK6zoaLHCUw3pXeCD5HJKAveRo1kyRoNlsNc9qN/53B+Ak+NZXAowMUGNqez8ld9oUQIVDPpAJ38fqludvxYiNI2woK3ioOs6kFDtszmWtzs4uPapp0PTDuWig28VehY5BMkxbEkR+tbJMeXog9VDMEB0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=IakF6xb1 reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN7A008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:55 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=gwBe2d1SPiEG7iGelhRfKdE35+7XHfMINRwT4MKXiLM=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1758113816; v=1;
        b=IakF6xb1y6e3J++ELT8zmlhVoNMYHBM96451uoVilbwHdL9KQ+l3FBvVgicRvmGm
         6xkwood2776jSaTOLnKLhkDEHFHeVh4DZYcV0lZBFtbjumcS3OrU1nbFoQ0pegnA
         3FNRpQMnBN4CucKDdexGpxP0i3EjiedJQayy86a+Df2lZxwu8oJkUFkmCS1X7i2k
         eFERUKqRLCWqjZkE4LlmJJcApUYtqxNv0vJ+uV+ETn50NEosXa/nJugPNz1c2iwl
         fYyLQlZYfkVUf2FL96pYMoC/bNeGfjH/yyKvWhnSxDRGTjRGLxMWlIWD6meC5XzL
         ToV+oFyyI+cprwbWQIo4Sw==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 17 Sep 2025 21:56:42 +0900
Subject: [PATCH 30/35] hw/virtio: QOM-ify AddressSpace
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250917-qom-v1-30-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
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
 hw/virtio/virtio-iommu.c |  3 ++-
 hw/virtio/virtio-pci.c   | 12 ++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/hw/virtio/virtio-iommu.c b/hw/virtio/virtio-iommu.c
index d9713a38bfae..84c6076dc0e3 100644
--- a/hw/virtio/virtio-iommu.c
+++ b/hw/virtio/virtio-iommu.c
@@ -421,6 +421,7 @@ static AddressSpace *virtio_iommu_find_add_as(PCIBus *bus, void *opaque,
         char *name = g_strdup_printf("%s-%d-%d",
                                      TYPE_VIRTIO_IOMMU_MEMORY_REGION,
                                      mr_index++, devfn);
+        g_autofree char *as_name = g_strconcat(name, "-as", NULL);
         sdev = sbus->pbdev[devfn] = g_new0(IOMMUDevice, 1);
 
         sdev->viommu = s;
@@ -430,7 +431,7 @@ static AddressSpace *virtio_iommu_find_add_as(PCIBus *bus, void *opaque,
         trace_virtio_iommu_init_iommu_mr(name);
 
         memory_region_init(&sdev->root, OBJECT(s), name, UINT64_MAX);
-        address_space_init(&sdev->as, NULL, &sdev->root, TYPE_VIRTIO_IOMMU);
+        address_space_init(&sdev->as, OBJECT(s), &sdev->root, as_name);
         add_prop_resv_regions(sdev);
 
         /*
diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index a3cd8f642706..7b63829c6c56 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -2062,8 +2062,8 @@ static void virtio_pci_device_plugged(DeviceState *d, Error **errp)
         if (modern_pio) {
             memory_region_init(&proxy->io_bar, OBJECT(proxy),
                                "virtio-pci-io", 0x4);
-            address_space_init(&proxy->modern_cfg_io_as, NULL, &proxy->io_bar,
-                               "virtio-pci-cfg-io-as");
+            address_space_init(&proxy->modern_cfg_io_as, OBJECT(proxy),
+                               &proxy->io_bar, "io-as");
 
             pci_register_bar(&proxy->pci_dev, proxy->modern_io_bar_idx,
                              PCI_BASE_ADDRESS_SPACE_IO, &proxy->io_bar);
@@ -2199,8 +2199,8 @@ static void virtio_pci_realize(PCIDevice *pci_dev, Error **errp)
                        /* PCI BAR regions must be powers of 2 */
                        pow2ceil(proxy->notify.offset + proxy->notify.size));
 
-    address_space_init(&proxy->modern_cfg_mem_as, NULL, &proxy->modern_bar,
-                       "virtio-pci-cfg-mem-as");
+    address_space_init(&proxy->modern_cfg_mem_as, OBJECT(proxy),
+                       &proxy->modern_bar, "mem-as");
 
     if (proxy->disable_legacy == ON_OFF_AUTO_AUTO) {
         proxy->disable_legacy = pcie_port ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
@@ -2296,9 +2296,9 @@ static void virtio_pci_exit(PCIDevice *pci_dev)
         pci_is_express(pci_dev)) {
         pcie_aer_exit(pci_dev);
     }
-    address_space_destroy(&proxy->modern_cfg_mem_as);
+    object_unparent(OBJECT(&proxy->modern_cfg_mem_as));
     if (modern_pio) {
-        address_space_destroy(&proxy->modern_cfg_io_as);
+        object_unparent(OBJECT(&proxy->modern_cfg_io_as));
     }
 }
 

-- 
2.51.0


