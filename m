Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D809C38D25C
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhEVAVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:21:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:56018 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230268AbhEVAVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:21:20 -0400
IronPort-SDR: hsUlE92OGPdPQQIThVjWgpIyzua3uImWSBxNB6DRwrxxndKFqTNImptFtWXS7ZURqYwUfSlTnc
 ZVArNoZJ3ogg==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="199661193"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="199661193"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:56 -0700
IronPort-SDR: YkEtAZ80uK9zugMnOdyWsS4n8Nbrq7PRClYcodvuqx8oo6tcL9N6Azy5Gv+Rdi1/1KPKP80sfF
 dW1zVEhNOcrg==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="441149316"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:55 -0700
Subject: [PATCH v6 08/20] vfio/mdev: idxd: Add mdev device context
 initialization
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:19:54 -0700
Message-ID: <162164279478.261970.8966553743790451233.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support functions to initialize the vdcm context and the PCI
config space region and the MMIO region. These regions are to
support the emulation paths for the mdev.


Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/registers.h  |    3 +
 drivers/vfio/mdev/idxd/mdev.h |    4 +
 drivers/vfio/mdev/idxd/vdev.c |  214 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 220 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index c2d558e37baf..8ac2be4e174b 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -88,6 +88,9 @@ struct opcap {
 	u64 bits[4];
 };
 
+#define OPCAP_OFS(op) (op - (0x40 * (op >> 6)))
+#define OPCAP_BIT(op) (BIT_ULL(OPCAP_OFS(op)))
+
 #define IDXD_OPCAP_OFFSET		0x40
 
 #define IDXD_TABLE_OFFSET		0x60
diff --git a/drivers/vfio/mdev/idxd/mdev.h b/drivers/vfio/mdev/idxd/mdev.h
index e52b50760ee7..91cb2662abd6 100644
--- a/drivers/vfio/mdev/idxd/mdev.h
+++ b/drivers/vfio/mdev/idxd/mdev.h
@@ -16,6 +16,7 @@
 #define VIDXD_MSIX_TBL_SZ		0x90
 #define VIDXD_MSIX_PERM_TBL_SZ		0x48
 
+#define VIDXD_VERSION_OFFSET		0
 #define VIDXD_MSIX_PERM_OFFSET		0x300
 #define VIDXD_GRPCFG_OFFSET		0x400
 #define VIDXD_WQCFG_OFFSET		0x500
@@ -74,8 +75,9 @@ static inline u8 vidxd_state(struct vdcm_idxd *vidxd)
 
 int idxd_mdev_get_pasid(struct mdev_device *mdev, struct vfio_device *vdev, u32 *pasid);
 
+void vidxd_init(struct vdcm_idxd *vidxd);
 void vidxd_reset(struct vdcm_idxd *vidxd);
-
+void vidxd_mmio_init(struct vdcm_idxd *vidxd);
 int vidxd_cfg_read(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int count);
 int vidxd_cfg_write(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int size);
 #endif
diff --git a/drivers/vfio/mdev/idxd/vdev.c b/drivers/vfio/mdev/idxd/vdev.c
index 4ead50947047..78cc2377e637 100644
--- a/drivers/vfio/mdev/idxd/vdev.c
+++ b/drivers/vfio/mdev/idxd/vdev.c
@@ -21,6 +21,62 @@
 #include "idxd.h"
 #include "mdev.h"
 
+static u64 idxd_pci_config[] = {
+	0x0010000000008086ULL,
+	0x0080000008800000ULL,
+	0x000000000000000cULL,
+	0x000000000000000cULL,
+	0x0000000000000000ULL,
+	0x2010808600000000ULL,
+	0x0000004000000000ULL,
+	0x000000ff00000000ULL,
+	0x0000060000015011ULL, /* MSI-X capability, hardcoded 2 entries, Encoded as N-1 */
+	0x0000070000000000ULL,
+	0x0000000000920010ULL, /* PCIe capability */
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+};
+
+static void vidxd_reset_config(struct vdcm_idxd *vidxd)
+{
+	u16 *devid = (u16 *)(vidxd->cfg + PCI_DEVICE_ID);
+	struct idxd_device *idxd = vidxd->idxd;
+
+	memset(vidxd->cfg, 0, VIDXD_MAX_CFG_SPACE_SZ);
+	memcpy(vidxd->cfg, idxd_pci_config, sizeof(idxd_pci_config));
+
+	if (idxd->data->type == IDXD_TYPE_DSA)
+		*devid = PCI_DEVICE_ID_INTEL_DSA_SPR0;
+	else if (idxd->data->type == IDXD_TYPE_IAX)
+		*devid = PCI_DEVICE_ID_INTEL_IAX_SPR0;
+}
+
+static inline void vidxd_reset_mmio(struct vdcm_idxd *vidxd)
+{
+	memset(&vidxd->bar0, 0, VIDXD_MAX_MMIO_SPACE_SZ);
+}
+
+void vidxd_init(struct vdcm_idxd *vidxd)
+{
+	struct idxd_wq *wq = vidxd->wq;
+
+	vidxd_reset_config(vidxd);
+	vidxd_reset_mmio(vidxd);
+
+	vidxd->bar_size[0] = VIDXD_BAR0_SIZE;
+	vidxd->bar_size[1] = VIDXD_BAR2_SIZE;
+
+	vidxd_mmio_init(vidxd);
+
+	if (wq_dedicated(wq) && wq->state == IDXD_WQ_ENABLED)
+		idxd_wq_disable(wq);
+}
+
 void vidxd_send_interrupt(struct vdcm_idxd *vidxd, int vector)
 {
 	struct mdev_device *mdev = vidxd->mdev;
@@ -252,6 +308,163 @@ int vidxd_cfg_write(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsign
 	return 0;
 }
 
+static void vidxd_mmio_init_grpcap(struct vdcm_idxd *vidxd)
+{
+	u8 *bar0 = vidxd->bar0;
+	union group_cap_reg *grp_cap = (union group_cap_reg *)(bar0 + IDXD_GRPCAP_OFFSET);
+
+	/* single group for current implementation */
+	grp_cap->num_groups = 1;
+}
+
+static void vidxd_mmio_init_grpcfg(struct vdcm_idxd *vidxd)
+{
+	u8 *bar0 = vidxd->bar0;
+	struct grpcfg *grpcfg = (struct grpcfg *)(bar0 + VIDXD_GRPCFG_OFFSET);
+	struct idxd_wq *wq = vidxd->wq;
+	struct idxd_group *group = wq->group;
+	int i;
+
+	/*
+	 * At this point, we are only exporting a single workqueue for
+	 * each mdev.
+	 */
+	grpcfg->wqs[0] = BIT(0);
+	for (i = 0; i < group->num_engines; i++)
+		grpcfg->engines |= BIT(i);
+	grpcfg->flags.bits = group->grpcfg.flags.bits;
+}
+
+static void vidxd_mmio_init_wqcap(struct vdcm_idxd *vidxd)
+{
+	u8 *bar0 = vidxd->bar0;
+	struct idxd_wq *wq = vidxd->wq;
+	union wq_cap_reg *wq_cap = (union wq_cap_reg *)(bar0 + IDXD_WQCAP_OFFSET);
+
+	wq_cap->total_wq_size = wq->size;
+	wq_cap->num_wqs = 1;
+	wq_cap->dedicated_mode = 1;
+}
+
+static void vidxd_mmio_init_wqcfg(struct vdcm_idxd *vidxd)
+{
+	struct idxd_device *idxd = vidxd->idxd;
+	struct idxd_wq *wq = vidxd->wq;
+	u8 *bar0 = vidxd->bar0;
+	union wqcfg *wqcfg = (union wqcfg *)(bar0 + VIDXD_WQCFG_OFFSET);
+
+	wqcfg->wq_size = wq->size;
+	wqcfg->wq_thresh = wq->threshold;
+	wqcfg->mode = WQCFG_MODE_DEDICATED;
+	wqcfg->priority = wq->priority;
+	wqcfg->max_xfer_shift = idxd->hw.gen_cap.max_xfer_shift;
+	wqcfg->max_batch_shift = idxd->hw.gen_cap.max_batch_shift;
+}
+
+static void vidxd_mmio_init_engcap(struct vdcm_idxd *vidxd)
+{
+	u8 *bar0 = vidxd->bar0;
+	union engine_cap_reg *engcap = (union engine_cap_reg *)(bar0 + IDXD_ENGCAP_OFFSET);
+	struct idxd_wq *wq = vidxd->wq;
+	struct idxd_group *group = wq->group;
+
+	engcap->num_engines = group->num_engines;
+}
+
+static void vidxd_mmio_init_gencap(struct vdcm_idxd *vidxd)
+{
+	struct idxd_device *idxd = vidxd->idxd;
+	u8 *bar0 = vidxd->bar0;
+	union gen_cap_reg *gencap = (union gen_cap_reg *)(bar0 + IDXD_GENCAP_OFFSET);
+
+	gencap->overlap_copy = idxd->hw.gen_cap.overlap_copy;
+	gencap->cache_control_mem = idxd->hw.gen_cap.cache_control_mem;
+	gencap->cache_control_cache = idxd->hw.gen_cap.cache_control_cache;
+	gencap->cmd_cap = 1;
+	gencap->dest_readback = idxd->hw.gen_cap.dest_readback;
+	gencap->drain_readback = idxd->hw.gen_cap.drain_readback;
+	gencap->max_xfer_shift = idxd->hw.gen_cap.max_xfer_shift;
+	gencap->max_batch_shift = idxd->hw.gen_cap.max_batch_shift;
+	gencap->max_descs_per_engine = idxd->hw.gen_cap.max_descs_per_engine;
+}
+
+static void vidxd_mmio_init_cmdcap(struct vdcm_idxd *vidxd)
+{
+	u8 *bar0 = vidxd->bar0;
+	u32 *cmdcap = (u32 *)(bar0 + IDXD_CMDCAP_OFFSET);
+
+	*cmdcap |= BIT(IDXD_CMD_ENABLE_DEVICE) | BIT(IDXD_CMD_DISABLE_DEVICE) |
+		   BIT(IDXD_CMD_DRAIN_ALL) | BIT(IDXD_CMD_ABORT_ALL) |
+		   BIT(IDXD_CMD_RESET_DEVICE) | BIT(IDXD_CMD_ENABLE_WQ) |
+		   BIT(IDXD_CMD_DISABLE_WQ) | BIT(IDXD_CMD_DRAIN_WQ) |
+		   BIT(IDXD_CMD_ABORT_WQ) | BIT(IDXD_CMD_RESET_WQ) |
+		   BIT(IDXD_CMD_DRAIN_PASID) | BIT(IDXD_CMD_ABORT_PASID) |
+		   BIT(IDXD_CMD_REQUEST_INT_HANDLE) | BIT(IDXD_CMD_RELEASE_INT_HANDLE);
+}
+
+static void vidxd_mmio_init_opcap(struct vdcm_idxd *vidxd)
+{
+	struct idxd_device *idxd = vidxd->idxd;
+	u64 opcode;
+	u8 *bar0 = vidxd->bar0;
+	u64 *opcap = (u64 *)(bar0 + IDXD_OPCAP_OFFSET);
+
+	if (idxd->data->type == IDXD_TYPE_DSA) {
+		opcode = BIT_ULL(DSA_OPCODE_NOOP) | BIT_ULL(DSA_OPCODE_BATCH) |
+			 BIT_ULL(DSA_OPCODE_DRAIN) | BIT_ULL(DSA_OPCODE_MEMMOVE) |
+			 BIT_ULL(DSA_OPCODE_MEMFILL) | BIT_ULL(DSA_OPCODE_COMPARE) |
+			 BIT_ULL(DSA_OPCODE_COMPVAL) | BIT_ULL(DSA_OPCODE_CR_DELTA) |
+			 BIT_ULL(DSA_OPCODE_AP_DELTA) | BIT_ULL(DSA_OPCODE_DUALCAST) |
+			 BIT_ULL(DSA_OPCODE_CRCGEN) | BIT_ULL(DSA_OPCODE_COPY_CRC) |
+			 BIT_ULL(DSA_OPCODE_DIF_CHECK) | BIT_ULL(DSA_OPCODE_DIF_INS) |
+			 BIT_ULL(DSA_OPCODE_DIF_STRP) | BIT_ULL(DSA_OPCODE_DIF_UPDT) |
+			 BIT_ULL(DSA_OPCODE_CFLUSH);
+		*opcap = opcode;
+	} else if (idxd->data->type == IDXD_TYPE_IAX) {
+		opcode = BIT_ULL(IAX_OPCODE_NOOP) | BIT_ULL(IAX_OPCODE_DRAIN) |
+			 BIT_ULL(IAX_OPCODE_MEMMOVE);
+		*opcap = opcode;
+		opcap++;
+		opcode = OPCAP_BIT(IAX_OPCODE_DECOMPRESS) |
+			 OPCAP_BIT(IAX_OPCODE_COMPRESS);
+		*opcap = opcode;
+	}
+}
+
+static void vidxd_mmio_init_version(struct vdcm_idxd *vidxd)
+{
+	struct idxd_device *idxd = vidxd->idxd;
+	u32 *version;
+
+	version = (u32 *)(vidxd->bar0 + VIDXD_VERSION_OFFSET);
+	*version = idxd->hw.version;
+}
+
+void vidxd_mmio_init(struct vdcm_idxd *vidxd)
+{
+	u8 *bar0 = vidxd->bar0;
+	union offsets_reg *offsets;
+
+	memset(vidxd->bar0, 0, VIDXD_BAR0_SIZE);
+
+	vidxd_mmio_init_version(vidxd);
+	vidxd_mmio_init_gencap(vidxd);
+	vidxd_mmio_init_wqcap(vidxd);
+	vidxd_mmio_init_grpcap(vidxd);
+	vidxd_mmio_init_engcap(vidxd);
+	vidxd_mmio_init_opcap(vidxd);
+
+	offsets = (union offsets_reg *)(bar0 + IDXD_TABLE_OFFSET);
+	offsets->grpcfg = VIDXD_GRPCFG_OFFSET / 0x100;
+	offsets->wqcfg = VIDXD_WQCFG_OFFSET / 0x100;
+	offsets->msix_perm = VIDXD_MSIX_PERM_OFFSET / 0x100;
+
+	vidxd_mmio_init_cmdcap(vidxd);
+	memset(bar0 + VIDXD_MSIX_PERM_OFFSET, 0, VIDXD_MSIX_PERM_TBL_SZ);
+	vidxd_mmio_init_grpcfg(vidxd);
+	vidxd_mmio_init_wqcfg(vidxd);
+}
+
 static void idxd_complete_command(struct vdcm_idxd *vidxd, enum idxd_cmdsts_err val)
 {
 	u8 *bar0 = vidxd->bar0;
@@ -396,6 +609,7 @@ void vidxd_reset(struct vdcm_idxd *vidxd)
 		}
 	}
 
+	vidxd_mmio_init(vidxd);
 	vwqcfg->wq_state = IDXD_WQ_DISABLED;
 	gensts->state = IDXD_DEVICE_STATE_DISABLED;
 	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);


