Return-Path: <kvm+bounces-23870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9AC94F586
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 19:01:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69D4AB2226D
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 17:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A096187874;
	Mon, 12 Aug 2024 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S03aHcDh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344B118754E
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 17:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723482072; cv=none; b=pdgEP8ibNa2C9YZJKYE8mobfoFMON36YTUxBNHJVUwWy6PuXQ+eRfrDyWlCtAEet+v6pn5m3IhTpEjBh5aTpaxZ6nH4fdUk0zLgqQz/C5nka+CX8d1afNu7leip8fCnDw/knRTu4O476cNw6Gdp/7/8Edo9j5c2Kn7WjPBQBiAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723482072; c=relaxed/simple;
	bh=9yD2wqDT2Mop99yksTX1dFdmRxZltC3bWYh9TrZpW0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnHwT+nUapvRacP2MatQ86nTgdbyT2mljdu4xeaxT1hjTdLZCwT+bAZvmyaCw6Fe1dYfpgfHYl5ewsmf9Ofw7SKghmueonQAgcM+B/CP3oK1tEk86GkW1h57+YSgkExCwzuhHP5UZS1dms47prYkK8iEt24z/YLbV9CjsrdFKV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S03aHcDh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723482069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=txjL7gyTCaBaIS2b7VHNdB5sZhpJ5otOJCWiL+k/cBM=;
	b=S03aHcDhl6cPaqtYrtMqEFcGv6cvytYMcXWsefN7iq/P645dbuIKHMZjd8Hayv65fW7xC9
	4oHG2yC0T++/5zSWjvEqWj4UAgjfsvvMMFMdSghqwhPgBA8d2P2oZ3kTcT+EtJwKfUnmLw
	4gHJhtPs+ThQgguCRBjR72HPjEvGRAY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-PpkfIwlEMKW7XZqOtDniFA-1; Mon,
 12 Aug 2024 13:01:06 -0400
X-MC-Unique: PpkfIwlEMKW7XZqOtDniFA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28C17195609E;
	Mon, 12 Aug 2024 17:01:03 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.16.191])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2982219560A3;
	Mon, 12 Aug 2024 17:00:56 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	quic_bqiang@quicinc.com,
	kvalo@kernel.org,
	prestwoj@gmail.com,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	dwmw2@infradead.org,
	iommu@lists.linux.dev,
	jgg@ziepe.ca,
	kernel@quicinc.com,
	johannes@sipsolutions.net,
	jtornosm@redhat.com
Subject: [PATCH RFC/RFT] vfio/pci-quirks: Quirk for ath wireless
Date: Mon, 12 Aug 2024 11:00:40 -0600
Message-ID: <20240812170045.1584000-1-alex.williamson@redhat.com>
In-Reply-To: <adcb785e-4dc7-4c4a-b341-d53b72e13467@gmail.com>
References: <adcb785e-4dc7-4c4a-b341-d53b72e13467@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

These devices have an embedded interrupt controller which is programmed
with guest physical MSI address/data, which doesn't work.  We need
vfio-pci kernel support to provide a device feature which disables
virtualization of the MSI capability registers.  Then we can do brute
force testing for writes matching the MSI address, from which we can
infer writes of the MSI data, replacing each with host physical values.

This has only been tested on ath11k (0x1103), ath12k support is
speculative and requires testing.  Note that Windows guest drivers make
use of multi-vector MSI which requires interrupt remapping support in
the host.

NB. The #define for the new vfio feature is temporary for RFC/RFT, a
formal proposal will include a proper linux-headers update.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216055
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 hw/vfio/pci-quirks.c | 236 +++++++++++++++++++++++++++++++++++++++++++
 hw/vfio/trace-events |   3 +
 2 files changed, 239 insertions(+)

diff --git a/hw/vfio/pci-quirks.c b/hw/vfio/pci-quirks.c
index 39dae72497e0..5ba37bee3b36 100644
--- a/hw/vfio/pci-quirks.c
+++ b/hw/vfio/pci-quirks.c
@@ -23,6 +23,7 @@
 #include "qapi/visitor.h"
 #include <sys/ioctl.h>
 #include "hw/nvram/fw_cfg.h"
+#include "hw/pci/msi.h"
 #include "hw/qdev-properties.h"
 #include "pci.h"
 #include "trace.h"
@@ -1159,6 +1160,240 @@ static void vfio_probe_rtl8168_bar2_quirk(VFIOPCIDevice *vdev, int nr)
     trace_vfio_quirk_rtl8168_probe(vdev->vbasedev.name);
 }
 
+#define PCI_VENDOR_ID_QCOM 0x17cb
+
+/*
+ * ath11k wireless adapters do not support INTx and appear to have an interrupt
+ * controller embedded into the hardware.  By default the interrupt controller
+ * is programmed with the MSI guest physical address, which doesn't work.
+ * Instead we need to trap and insert the host physical address and data.
+ *
+ * By default vfio-pci virtualizes the MSI address and data registers, providing
+ * a writable buffer, where reads simply return the buffer.  QEMU writes
+ * everything through to hardware, so this only holds the guest MSI address.
+ * Therefore we first need to invoke a device feature that disables this
+ * emulation of the MSI address and data registers, allowing access to the host
+ * physical address and data.
+ *
+ * Next, where do these values get written?  If we disable mmap support and
+ * trace accesses, we get this:
+ *
+ * # grep -A2 region0.*0xfee00000 typescript
+ * vfio_region_write  (0000:01:00.0:region0+0x80048, 0xfee00000, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x8004c, 0x100, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x80050, 0x21, 4)
+ * --
+ * vfio_region_write  (0000:01:00.0:region0+0x83048, 0xfee00000, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x8304c, 0x100, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x83050, 0x21, 4)
+ * --
+ * vfio_region_write  (0000:01:00.0:region0+0x830a0, 0xfee00000, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x830a4, 0x100, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x830a8, 0x21, 4)
+ * --
+ * vfio_region_write  (0000:01:00.0:region0+0x85048, 0xfee00000, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x8504c, 0x100, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x85050, 0x21, 4)
+ * --
+ * vfio_region_write  (0000:01:00.0:region0+0x850a0, 0xfee00000, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x850a4, 0x100, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x850a8, 0x21, 4)
+ * --
+ * vfio_region_write  (0000:01:00.0:region0+0x86048, 0xfee00000, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x8604c, 0x100, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x86050, 0x21, 4)
+ * --
+ * vfio_region_write  (0000:01:00.0:region0+0x8b048, 0xfee00000, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x8b04c, 0x100, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x8b050, 0x21, 4)
+ * --
+ * vfio_region_write  (0000:01:00.0:region0+0x8b0a0, 0xfee00000, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x8b0a4, 0x100, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x8b0a8, 0x21, 4)
+ * --
+ * vfio_region_write  (0000:01:00.0:region0+0x8e048, 0xfee00000, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x8e04c, 0x100, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0x8e050, 0x21, 4)
+ * --
+ * vfio_region_write  (0000:01:00.0:region0+0xb4968, 0xfee00000, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0xb496c, 0x100, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0xb4970, 0x21, 4)
+ * --
+ * vfio_region_write  (0000:01:00.0:region0+0xb4a70, 0xfee00000, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0xb4a74, 0x100, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0xb4a78, 0x21, 4)
+ * --
+ * vfio_region_write  (0000:01:00.0:region0+0xb849c, 0xfee00000, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0xb84a0, 0x100, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0xb84a4, 0x21, 4)
+ * --
+ * vfio_region_write  (0000:01:00.0:region0+0xb85a4, 0xfee00000, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0xb85a8, 0x100, 4)
+ * vfio_region_write  (0000:01:00.0:region0+0xb85ac, 0x21, 4)
+ *
+ * We can find in this example trace that the MSI capability is programmed as:
+ *
+ * vfio_pci_write_config  (0000:01:00.0, @0x54, 0xfee00000, len=0x4)
+ * vfio_pci_write_config  (0000:01:00.0, @0x58, 0x21, len=0x2)
+ *
+ * This is a 32-bit MSI capability based at 0x50, so the MSI address is
+ * 0xfee00000 with data 0x21.  So we see writes of the MSI address, followed
+ * 8-bytes later by what appears to be the MSI data.  There's no obvious
+ * pattern in the device address where these are being written.
+ *
+ * We therefore come up with a really crude quirk that looks for values
+ * written to the ATH11K_PCI_WINDOW (defined in Linux driver as starting at
+ * 0x80000 with an 18-bit mask, ie. 256k) that match the guest MSI address.
+ * When found we replace the data with the host physical address and set a
+ * cookie to match the MSI data write, again replacing with the host value and
+ * clearing the cookie.
+ *
+ * Amazingly, this seems sufficient to work, and the trapped window only seems
+ * to be used during initialization, so this should introduce minimal overhead.
+ *
+ * The Windows driver makes use of multi-vector MSI, where our sanity test
+ * of the MSI data value must then mask off the vector offset for comparison
+ * and add it back to the host base data value on write.
+ *
+ * Only 4- and 8-byte accesses are observed to the PCI window, and MSI access
+ * are only observed with 4-byte width.
+ */
+
+// Temporary, include updated Linux headers
+#define VFIO_DEVICE_FEATURE_PCI_MSI_NOVIRT 11
+
+typedef struct VFIOQAthQuirk {
+    VFIOPCIDevice *vdev;
+    uint32_t pci_window_base;
+    uint32_t msi_data_addr;
+} VFIOQAthQuirk;
+
+static uint64_t vfio_ath_quirk_read(void *opaque, hwaddr addr, unsigned size)
+{
+    VFIOQAthQuirk *ath = opaque;
+    VFIOPCIDevice *vdev = ath->vdev;
+
+    return vfio_region_read(&vdev->bars[0].region,
+                            addr + ath->pci_window_base, size);
+}
+
+static void vfio_ath_quirk_write(void *opaque, hwaddr addr,
+                                 uint64_t data, unsigned size)
+{
+    VFIOQAthQuirk *ath = opaque;
+    VFIOPCIDevice *vdev = ath->vdev;
+
+    if (size == 4 && msi_enabled(&vdev->pdev)) {
+        uint32_t phys = 0;
+
+        if (data == pci_get_long(vdev->pdev.config +
+                                 vdev->pdev.msi_cap + PCI_MSI_ADDRESS_LO)) {
+            pread(vdev->vbasedev.fd, &phys, 4, vdev->config_offset +
+                  vdev->pdev.msi_cap + PCI_MSI_ADDRESS_LO);
+            trace_vfio_quirk_ath_write_address(vdev->vbasedev.name,
+                                               addr + ath->pci_window_base,
+                                               data, phys);
+            data = phys;
+            ath->msi_data_addr = addr + 8;
+        } else if (ath->msi_data_addr && ath->msi_data_addr == addr) {
+            uint32_t mask = msi_nr_vectors_allocated(&vdev->pdev) - 1;
+            uint32_t nr = data & mask;
+
+            if ((data & ~mask) == pci_get_word(vdev->pdev.config +
+                                               vdev->pdev.msi_cap +
+                                               PCI_MSI_DATA_32)) {
+                pread(vdev->vbasedev.fd, &phys, 2, vdev->config_offset +
+                      vdev->pdev.msi_cap + PCI_MSI_DATA_32);
+                phys += nr;
+                trace_vfio_quirk_ath_write_data(vdev->vbasedev.name,
+                                                addr + ath->pci_window_base,
+                                                data, phys);
+                data = phys;
+            }
+            ath->msi_data_addr = 0;
+        }
+    }
+
+    vfio_region_write(&vdev->bars[0].region, addr + ath->pci_window_base,
+                      data, size);
+}
+
+static const MemoryRegionOps vfio_ath_quirk = {
+    .read = vfio_ath_quirk_read,
+    .write = vfio_ath_quirk_write,
+    .valid = {
+        .min_access_size = 4,
+        .max_access_size = 8,
+        .unaligned = false,
+    },
+    .endianness = DEVICE_LITTLE_ENDIAN,
+};
+
+static bool vfio_pci_msi_novirt(VFIOPCIDevice *vdev)
+{
+    uint64_t buf[DIV_ROUND_UP(sizeof(struct vfio_device_feature),
+                              sizeof(uint64_t))] = {};
+    struct vfio_device_feature *feature = (struct vfio_device_feature *)buf;
+
+    feature->argsz = sizeof(buf);
+    feature->flags = VFIO_DEVICE_FEATURE_SET |
+                     VFIO_DEVICE_FEATURE_PCI_MSI_NOVIRT;
+
+    return !ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feature);
+}
+
+static void vfio_probe_ath_bar0_quirk(VFIOPCIDevice *vdev, int nr)
+{
+    VFIOQuirk *quirk;
+    VFIOQAthQuirk *ath;
+    uint32_t pci_window_base, pci_window_size;
+
+    if (nr != 0 ||
+        vdev->vendor_id != PCI_VENDOR_ID_QCOM || !msi_present(&vdev->pdev)) {
+        return;
+    }
+
+    switch (vdev->device_id) {
+    case 0x1101: /* Untested */
+    case 0x1103:
+    case 0x1104: /* Untested */
+        /* Devices claimed by ath11k_pci_id_table in Linux driver as of v6.10 */
+        pci_window_base = 0x80000; /* ATH11K_PCI_WINDOW_START */
+        pci_window_size = 0x40000; /* ATH11K_PCI_WINDOW_RANGE_MASK (256k)*/
+        break;
+    case 0x1107: /* Untested */
+    case 0x1109: /* Untested */
+        /* Devices claimed by ath12k_pci_id_table in Linux driver as of v6.10 */
+        pci_window_base = 0x1e00000; /* PCI_BAR_WINDOW0_BASE */
+        pci_window_size = 0x80000; /* ~PCI_BAR_WINDOW0_END (512k) */
+        break;
+    default:
+        return;
+    }
+
+    if (!vfio_pci_msi_novirt(vdev)) {
+        warn_report("Found device matching Atheros wireless quirk, but host "
+                    "does not support vfio device feature required for quirk. "
+                    "Device is known not to work with device assignment "
+                    "without this quirk.  Please update host kernel.");
+        return;
+    }
+
+    quirk = vfio_quirk_alloc(1);
+    quirk->data = ath = g_malloc0(sizeof(*ath));
+    ath->vdev = vdev;
+    ath->pci_window_base = pci_window_base;
+
+    memory_region_init_io(&quirk->mem[0], OBJECT(vdev), &vfio_ath_quirk,
+                          ath, "vfio-ath-quirk", pci_window_size);
+    memory_region_add_subregion_overlap(vdev->bars[nr].region.mem,
+                                        pci_window_base, &quirk->mem[0], 1);
+
+    QLIST_INSERT_HEAD(&vdev->bars[nr].quirks, quirk, next);
+
+    trace_vfio_quirk_ath_bar0_probe(vdev->vbasedev.name);
+}
+
 #define IGD_ASLS 0xfc /* ASL Storage Register */
 
 /*
@@ -1261,6 +1496,7 @@ void vfio_bar_quirk_setup(VFIOPCIDevice *vdev, int nr)
 #ifdef CONFIG_VFIO_IGD
     vfio_probe_igd_bar4_quirk(vdev, nr);
 #endif
+    vfio_probe_ath_bar0_quirk(vdev, nr);
 }
 
 void vfio_bar_quirk_exit(VFIOPCIDevice *vdev, int nr)
diff --git a/hw/vfio/trace-events b/hw/vfio/trace-events
index 98bd4dcceadc..3d1154785157 100644
--- a/hw/vfio/trace-events
+++ b/hw/vfio/trace-events
@@ -82,6 +82,9 @@ vfio_ioeventfd_exit(const char *name, uint64_t addr, unsigned size, uint64_t dat
 vfio_ioeventfd_handler(const char *name, uint64_t addr, unsigned size, uint64_t data) "%s+0x%"PRIx64"[%d] -> 0x%"PRIx64
 vfio_ioeventfd_init(const char *name, uint64_t addr, unsigned size, uint64_t data, bool vfio) "%s+0x%"PRIx64"[%d]:0x%"PRIx64" vfio:%d"
 vfio_pci_igd_opregion_enabled(const char *name) "%s"
+vfio_quirk_ath_bar0_probe(const char *name) "%s"
+vfio_quirk_ath_write_address(const char *name, uint64_t addr, uint64_t data, uint32_t phys) "%s[0x%"PRIx64"]: Replacing MSI address 0x%"PRIx64" with value 0x%x"
+vfio_quirk_ath_write_data(const char *name, uint64_t addr, uint64_t data, uint32_t phys) "%s[0x%"PRIx64"]: Replacing MSI data 0x%"PRIx64" with value 0x%x"
 
 # igd.c
 vfio_pci_igd_bar4_write(const char *name, uint32_t index, uint32_t data, uint32_t base) "%s [0x%03x] 0x%08x -> 0x%08x"
-- 
2.45.2


