Return-Path: <kvm+bounces-63325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 027FBC6221E
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:42:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4942135F34E
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 000E9257821;
	Mon, 17 Nov 2025 02:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="irVf+V3q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C38260583;
	Mon, 17 Nov 2025 02:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347168; cv=none; b=lDqrbCNef38dwulXTrUkK9OqHcrFMTyfWYWldz1u70ZYQ5iTi7/k88NCxNC/VcFExusVaHTjv20qlLSxjJhsFz7BA3yJYbTH54xYhB9bhJtu0ut2DajfAchHvhkyhDyCkMQZ5f6j1h017/zofi5KD0IzdkcMUR72KQ37MiLgnLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347168; c=relaxed/simple;
	bh=Y0FbFr6VOYpvByty6lrIHWjHZ4JZ8va9EernJJ27egY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d4JZYmYkGgVCL39f+eiBOGCCEVAUaKZFflHneo5dGD6ybk0gtuACGLUwQvx6iHUnzCTo3kdhA/5/K/BVA+Pc31Cy0Nnx8GkMAZKdlKdwl2jnyzK+UBJPOG1OWEckQpfqRuVUYCErTz0rSOYIdhUW1RC++MB6GiMKosM2mke92Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=irVf+V3q; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347167; x=1794883167;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y0FbFr6VOYpvByty6lrIHWjHZ4JZ8va9EernJJ27egY=;
  b=irVf+V3qyeCrqH7vOu/au9OwCDvmjizP+Gfd/XtNailH/i+Z9oCed5Gl
   FmAhY/75FpS0Rb3TBkHr1x8Bq7rsnOkuOeUQrZtVWv2usaDrAVRA9O+KL
   00btrdKMe1vxkcIiHtRHNGNZ5R2P6WStrBg7WvQHIEqpialENw/S37uyw
   Mrk55ugMZxSKe372wz0ThY51FxyB3BxYVPmb1+zkPG86HyFeQBvveifr/
   aqLv0j0ubVFS1rHJybCKy6WrZQJMtirxpNhThPfvkhm13SSvZoyS/4lNM
   JpwO+R5TRxCADPqYX+ziw+FpsBBa7Mln83fgR4TeKPVAP15jVQY0od8/u
   Q==;
X-CSE-ConnectionGUID: 9k9RXIUFS2ibQPeLOrntgQ==
X-CSE-MsgGUID: iGPQ98oARFezW3VfnPfe5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729634"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729634"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:39:26 -0800
X-CSE-ConnectionGUID: h2hI6A2eT3K+S76PBf1EUQ==
X-CSE-MsgGUID: fCGPU7UqQz6MaxJ+vIVdMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658531"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:39:22 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: chao.gao@intel.com,
	dave.jiang@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	dan.j.williams@intel.com,
	kas@kernel.org,
	x86@kernel.org
Subject: [PATCH v1 25/26] coco/tdx-host: Implement IDE stream setup/teardown
Date: Mon, 17 Nov 2025 10:23:09 +0800
Message-Id: <20251117022311.2443900-26-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implementation for a most straightforward Selective IDE stream setup.
Hard code all parameters for Stream Control Register. And no IDE Key
Refresh support.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/pci-ide.h               |   2 +
 drivers/pci/ide.c                     |   5 +-
 drivers/virt/coco/tdx-host/tdx-host.c | 225 ++++++++++++++++++++++++++
 3 files changed, 230 insertions(+), 2 deletions(-)

diff --git a/include/linux/pci-ide.h b/include/linux/pci-ide.h
index 37a1ad9501b0..2521a2914294 100644
--- a/include/linux/pci-ide.h
+++ b/include/linux/pci-ide.h
@@ -106,6 +106,8 @@ struct pci_ide {
 void pci_ide_set_nr_streams(struct pci_host_bridge *hb, u16 nr);
 struct pci_ide_partner *pci_ide_to_settings(struct pci_dev *pdev,
 					    struct pci_ide *ide);
+void pci_ide_stream_to_regs(struct pci_dev *pdev, struct pci_ide *ide,
+			    struct pci_ide_regs *regs);
 struct pci_ide *pci_ide_stream_alloc(struct pci_dev *pdev);
 void pci_ide_stream_free(struct pci_ide *ide);
 int  pci_ide_stream_register(struct pci_ide *ide);
diff --git a/drivers/pci/ide.c b/drivers/pci/ide.c
index f0ef474e1a0d..58246349178e 100644
--- a/drivers/pci/ide.c
+++ b/drivers/pci/ide.c
@@ -556,8 +556,8 @@ static void mem_assoc_to_regs(struct pci_bus_region *region,
  * @ide: registered IDE settings descriptor
  * @regs: output register values
  */
-static void pci_ide_stream_to_regs(struct pci_dev *pdev, struct pci_ide *ide,
-				   struct pci_ide_regs *regs)
+void pci_ide_stream_to_regs(struct pci_dev *pdev, struct pci_ide *ide,
+			    struct pci_ide_regs *regs)
 {
 	struct pci_ide_partner *settings = pci_ide_to_settings(pdev, ide);
 	int assoc_idx = 0;
@@ -586,6 +586,7 @@ static void pci_ide_stream_to_regs(struct pci_dev *pdev, struct pci_ide *ide,
 
 	regs->nr_addr = assoc_idx;
 }
+EXPORT_SYMBOL_GPL(pci_ide_stream_to_regs);
 
 /**
  * pci_ide_stream_setup() - program settings to Selective IDE Stream registers
diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
index 986a75084747..7f3c00f17ec7 100644
--- a/drivers/virt/coco/tdx-host/tdx-host.c
+++ b/drivers/virt/coco/tdx-host/tdx-host.c
@@ -65,6 +65,10 @@ struct tdx_link {
 	struct tdx_page_array *spdm_mt;
 	unsigned int dev_info_size;
 	void *dev_info_data;
+
+	struct pci_ide *ide;
+	struct tdx_page_array *stream_mt;
+	unsigned int stream_id;
 };
 
 static struct tdx_link *to_tdx_link(struct pci_tsm *tsm)
@@ -343,6 +347,218 @@ static void tdx_spdm_session_teardown(struct tdx_link *tlink)
 DEFINE_FREE(tdx_spdm_session_teardown, struct tdx_link *,
 	    if (!IS_ERR_OR_NULL(_T)) tdx_spdm_session_teardown(_T))
 
+enum tdx_ide_stream_km_op {
+	TDX_IDE_STREAM_KM_SETUP = 0,
+	TDX_IDE_STREAM_KM_REFRESH = 1,
+	TDX_IDE_STREAM_KM_STOP = 2,
+};
+
+static int tdx_ide_stream_km(struct tdx_link *tlink,
+			     enum tdx_ide_stream_km_op op)
+{
+	u64 r, out_msg_sz;
+	int ret;
+
+	do {
+		r = tdh_ide_stream_km(tlink->spdm_id, tlink->stream_id, op,
+				      tlink->in_msg, tlink->out_msg,
+				      &out_msg_sz);
+		ret = tdx_link_event_handler(tlink, r, out_msg_sz);
+	} while (ret == -EAGAIN);
+
+	return ret;
+}
+
+static struct tdx_link *tdx_ide_stream_key_program(struct tdx_link *tlink)
+{
+	int ret;
+
+	ret = tdx_ide_stream_km(tlink, TDX_IDE_STREAM_KM_SETUP);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return tlink;
+}
+
+static void tdx_ide_stream_key_stop(struct tdx_link *tlink)
+{
+	tdx_ide_stream_km(tlink, TDX_IDE_STREAM_KM_STOP);
+}
+
+DEFINE_FREE(tdx_ide_stream_key_stop, struct tdx_link *,
+	    if (!IS_ERR_OR_NULL(_T)) tdx_ide_stream_key_stop(_T))
+
+static void sel_stream_block_regs(struct pci_dev *pdev, struct pci_ide *ide,
+				  struct pci_ide_regs *regs)
+{
+	struct pci_dev *rp = pcie_find_root_port(pdev);
+	struct pci_ide_partner *setting = pci_ide_to_settings(rp, ide);
+
+	/* only support address association for prefetchable memory */
+	setting->mem_assoc = (struct pci_bus_region) { 0, -1 };
+	pci_ide_stream_to_regs(rp, ide, regs);
+}
+
+#define STREAM_INFO_RP_DEVFN		GENMASK_ULL(7, 0)
+#define STREAM_INFO_TYPE		BIT_ULL(8)
+#define  STREAM_INFO_TYPE_LINK		0
+#define  STREAM_INFO_TYPE_SEL		1
+
+static struct tdx_link *tdx_ide_stream_create(struct tdx_link *tlink,
+					      struct pci_ide *ide)
+{
+	u64 stream_info, stream_ctrl;
+	u64 stream_id, rp_ide_id;
+	unsigned int nr_pages = tdx_sysinfo->connect.ide_mt_page_count;
+	struct pci_dev *pdev = tlink->pci.base_tsm.pdev;
+	struct pci_dev *rp = pcie_find_root_port(pdev);
+	struct pci_ide_regs regs;
+	u64 r;
+
+	struct tdx_page_array *stream_mt __free(tdx_page_array_free) =
+		tdx_page_array_create(nr_pages);
+	if (!stream_mt)
+		return ERR_PTR(-ENOMEM);
+
+	stream_info = FIELD_PREP(STREAM_INFO_RP_DEVFN, rp->devfn);
+	stream_info |= FIELD_PREP(STREAM_INFO_TYPE, STREAM_INFO_TYPE_SEL);
+
+	/*
+	 * For Selective IDE stream, below values must be 0:
+	 *   NPR_AGG/PR_AGG/CPL_AGG/CONF_REQ/ALGO/DEFAULT/STREAM_ID
+	 *
+	 * below values are configurable but now hardcode to 0:
+	 *   PCRC/TC
+	 */
+	stream_ctrl = FIELD_PREP(PCI_IDE_SEL_CTL_EN, 0) |
+		      FIELD_PREP(PCI_IDE_SEL_CTL_TX_AGGR_NPR, 0) |
+		      FIELD_PREP(PCI_IDE_SEL_CTL_TX_AGGR_PR, 0) |
+		      FIELD_PREP(PCI_IDE_SEL_CTL_TX_AGGR_CPL, 0) |
+		      FIELD_PREP(PCI_IDE_SEL_CTL_PCRC_EN, 0) |
+		      FIELD_PREP(PCI_IDE_SEL_CTL_CFG_EN, 0) |
+		      FIELD_PREP(PCI_IDE_SEL_CTL_ALG, 0) |
+		      FIELD_PREP(PCI_IDE_SEL_CTL_TC, 0) |
+		      FIELD_PREP(PCI_IDE_SEL_CTL_ID, 0);
+
+	sel_stream_block_regs(pdev, ide, &regs);
+	if (regs.nr_addr != 1)
+		return ERR_PTR(-EFAULT);
+
+	r = tdh_ide_stream_create(stream_info, tlink->spdm_id,
+				  stream_mt, stream_ctrl,
+				  regs.rid1, regs.rid2, regs.addr[0].assoc1,
+				  regs.addr[0].assoc2, regs.addr[0].assoc3,
+				  &stream_id, &rp_ide_id);
+	if (r)
+		return ERR_PTR(-EFAULT);
+
+	tlink->stream_id = stream_id;
+	tlink->stream_mt = no_free_ptr(stream_mt);
+
+	pci_dbg(pdev, "%s stream id 0x%x rp ide_id 0x%llx\n", __func__,
+		tlink->stream_id, rp_ide_id);
+	return tlink;
+}
+
+static void tdx_ide_stream_delete(struct tdx_link *tlink)
+{
+	struct pci_dev *pdev = tlink->pci.base_tsm.pdev;
+	unsigned int nr_released;
+	u64 released_hpa, r;
+
+	r = tdh_ide_stream_block(tlink->spdm_id, tlink->stream_id);
+	if (r) {
+		pci_err(pdev, "ide stream block fail %llx\n", r);
+		goto leak;
+	}
+
+	r = tdh_ide_stream_delete(tlink->spdm_id, tlink->stream_id,
+				  tlink->stream_mt, &nr_released,
+				  &released_hpa);
+	if (r) {
+		pci_err(pdev, "ide stream delete fail %llx\n", r);
+		goto leak;
+	}
+
+	if (tdx_page_array_ctrl_release(tlink->stream_mt, nr_released,
+					released_hpa)) {
+		pci_err(pdev, "fail to release IDE stream metadata pages\n");
+		goto leak;
+	}
+
+	return;
+
+leak:
+	tdx_page_array_ctrl_leak(tlink->stream_mt);
+}
+
+DEFINE_FREE(tdx_ide_stream_delete, struct tdx_link *,
+	    if (!IS_ERR_OR_NULL(_T)) tdx_ide_stream_delete(_T))
+
+static struct tdx_link *tdx_ide_stream_setup(struct tdx_link *tlink)
+{
+	struct pci_dev *pdev = tlink->pci.base_tsm.pdev;
+	int ret;
+
+	struct pci_ide *ide __free(pci_ide_stream_release) =
+		pci_ide_stream_alloc(pdev);
+	if (!ide)
+		return ERR_PTR(-ENOMEM);
+
+	/* Configure IDE capability for RP & get stream_id */
+	struct tdx_link *tlink_create __free(tdx_ide_stream_delete) =
+		tdx_ide_stream_create(tlink, ide);
+	if (IS_ERR(tlink_create))
+		return tlink_create;
+
+	ide->stream_id = tlink->stream_id;
+	ret = pci_ide_stream_register(ide);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/*
+	 * Configure IDE capability for target device
+	 *
+	 * Some test devices work only with DEFAULT_STREAM enabled. For
+	 * simplicity, enable DEFAULT_STREAM for all devices. A future decent
+	 * solution may be to have a quirk table to specify which devices need
+	 * DEFAULT_STREAM.
+	 */
+	ide->partner[PCI_IDE_EP].default_stream = 1;
+	pci_ide_stream_setup(pdev, ide);
+
+	/* Key Programming for RP & target device, enable IDE stream for RP */
+	struct tdx_link *tlink_program __free(tdx_ide_stream_key_stop) =
+		tdx_ide_stream_key_program(tlink);
+	if (IS_ERR(tlink_program))
+		return tlink_program;
+
+	ret = tsm_ide_stream_register(ide);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* Enable IDE stream for target device */
+	ret = pci_ide_stream_enable(pdev, ide);
+	if (ret)
+		return ERR_PTR(ret);
+
+	retain_and_null_ptr(tlink_create);
+	retain_and_null_ptr(tlink_program);
+	tlink->ide = no_free_ptr(ide);
+
+	return tlink;
+}
+
+static void tdx_ide_stream_teardown(struct tdx_link *tlink)
+{
+	tdx_ide_stream_key_stop(tlink);
+	tdx_ide_stream_delete(tlink);
+	pci_ide_stream_release(tlink->ide);
+}
+
+DEFINE_FREE(tdx_ide_stream_teardown, struct tdx_link *,
+	    if (!IS_ERR_OR_NULL(_T)) tdx_ide_stream_teardown(_T))
+
 static int tdx_link_connect(struct pci_dev *pdev)
 {
 	struct tdx_link *tlink = to_tdx_link(pdev->tsm);
@@ -354,7 +570,15 @@ static int tdx_link_connect(struct pci_dev *pdev)
 		return PTR_ERR(tlink_spdm);
 	}
 
+	struct tdx_link *tlink_ide __free(tdx_ide_stream_teardown) =
+		tdx_ide_stream_setup(tlink);
+	if (IS_ERR(tlink_ide)) {
+		pci_err(pdev, "fail to setup ide stream\n");
+		return PTR_ERR(tlink_ide);
+	}
+
 	retain_and_null_ptr(tlink_spdm);
+	retain_and_null_ptr(tlink_ide);
 
 	return 0;
 }
@@ -363,6 +587,7 @@ static void tdx_link_disconnect(struct pci_dev *pdev)
 {
 	struct tdx_link *tlink = to_tdx_link(pdev->tsm);
 
+	tdx_ide_stream_teardown(tlink);
 	tdx_spdm_session_teardown(tlink);
 }
 
-- 
2.25.1


