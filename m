Return-Path: <kvm+bounces-9324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 887DC85E253
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 17:01:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACA211C20C08
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 16:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB3283A0C;
	Wed, 21 Feb 2024 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KEFHBicn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9071F82D93;
	Wed, 21 Feb 2024 15:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708531165; cv=none; b=Hvuf3+Rg7+UwtnDXdlmn15AX3RuKqPCPGIGdoJT/YGFwFDLBg3xJd3/vsZKwgNKhF0Ibn5+bMdglCiJX9rR6ZrwwA9OEi2NRA1hcm3CgQZPPIFiD/X+cWI1zPGc1lof5TJPYR0OsPDpD3S463D+2L/ouLmnNl5IcuPjYIvDXwck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708531165; c=relaxed/simple;
	bh=KEK0FEozIL73ZuOeLnQa3DLqwbNOPhPfu+23pbtSSA0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=YCXXDdczIUrvypzTvuLsqhCn4u4yRsQdcZDZ8MW7k/hpaGwDtWyyP8Atci6kdfERif89vbDL8hIKGetD8/sVOB9gu4q15L0HYA4vs/4jkPVSZio7AW9WzNIjaHqZHbeSAyHrFxn7A38FbCslu5Z6UZJUSfLcHNJlA8zPtgdVns0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KEFHBicn; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708531164; x=1740067164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=KEK0FEozIL73ZuOeLnQa3DLqwbNOPhPfu+23pbtSSA0=;
  b=KEFHBicnPqrVWIRd+GIAMfuyjS4PIo8nrTsNbGSaNAaY5WkKuJT0T5q7
   qjCl/PGa8nW649J3cs/2WkrgxmYb24vGCCrinJrpLCDt7WdAsVAzSNAPu
   IG2g3XHB0Xaf5mpc1L3PanqJAd8f6i47BpqnRN6cJwGdc0YBtspnlUHXA
   iKiffr+nfa1RIyiG60isLM29nBlbkfXLaKH4Se3HyA05d19UGkA3r/Fb1
   lv+4/xWY45D97LWXDd+I+/QZ4WXRXSQVEl1vC0tj2C8bu2MtOtbyudhBh
   GrY+jHuCmD+gzwIKh/IOMr2ebvtxxDMqel8iZOaFJb7eQo0Nh8oNX9GV0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="2568855"
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="2568855"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 07:59:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="9760918"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmviesa004.fm.intel.com with ESMTP; 21 Feb 2024 07:58:58 -0800
From: Xin Zeng <xin.zeng@intel.com>
To: herbert@gondor.apana.org.au,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com
Cc: linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org,
	qat-linux@intel.com,
	Siming Wan <siming.wan@intel.com>,
	Xin Zeng <xin.zeng@intel.com>
Subject: [PATCH v3 06/10] crypto: qat - expand CSR operations for QAT GEN4 devices
Date: Wed, 21 Feb 2024 23:50:04 +0800
Message-Id: <20240221155008.960369-7-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240221155008.960369-1-xin.zeng@intel.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Siming Wan <siming.wan@intel.com>

Extend the CSR operations for QAT GEN4 devices to allow saving and
restoring the rings state.

The new operations will be used as a building block for implementing the
state save and restore of Virtual Functions necessary for VM live
migration.

This adds the following operations:
 - read ring status register
 - read ring underflow/overflow status register
 - read ring nearly empty status register
 - read ring nearly full status register
 - read ring full status register
 - read ring complete status register
 - read ring exception status register
 - read/write ring exception interrupt mask register
 - read ring configuration register
 - read ring base register
 - read/write ring interrupt enable register
 - read ring interrupt flag register
 - read/write ring interrupt source select register
 - read ring coalesced interrupt enable register
 - read ring coalesced interrupt control register
 - read ring flag and coalesced interrupt enable register
 - read ring service arbiter enable register
 - get ring coalesced interrupt control enable mask

Signed-off-by: Siming Wan <siming.wan@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Xin Zeng <xin.zeng@intel.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
---
 .../intel/qat/qat_common/adf_accel_devices.h  |  27 ++++
 .../qat/qat_common/adf_gen4_hw_csr_data.c     | 130 ++++++++++++++++++
 .../qat/qat_common/adf_gen4_hw_csr_data.h     |  93 ++++++++++++-
 3 files changed, 249 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 08658c3a01e9..d1f3f5a822ff 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -150,22 +150,49 @@ struct adf_hw_csr_ops {
 				  u32 ring);
 	void (*write_csr_ring_tail)(void __iomem *csr_base_addr, u32 bank,
 				    u32 ring, u32 value);
+	u32 (*read_csr_stat)(void __iomem *csr_base_addr, u32 bank);
+	u32 (*read_csr_uo_stat)(void __iomem *csr_base_addr, u32 bank);
 	u32 (*read_csr_e_stat)(void __iomem *csr_base_addr, u32 bank);
+	u32 (*read_csr_ne_stat)(void __iomem *csr_base_addr, u32 bank);
+	u32 (*read_csr_nf_stat)(void __iomem *csr_base_addr, u32 bank);
+	u32 (*read_csr_f_stat)(void __iomem *csr_base_addr, u32 bank);
+	u32 (*read_csr_c_stat)(void __iomem *csr_base_addr, u32 bank);
+	u32 (*read_csr_exp_stat)(void __iomem *csr_base_addr, u32 bank);
+	u32 (*read_csr_exp_int_en)(void __iomem *csr_base_addr, u32 bank);
+	void (*write_csr_exp_int_en)(void __iomem *csr_base_addr, u32 bank,
+				     u32 value);
+	u32 (*read_csr_ring_config)(void __iomem *csr_base_addr, u32 bank,
+				    u32 ring);
 	void (*write_csr_ring_config)(void __iomem *csr_base_addr, u32 bank,
 				      u32 ring, u32 value);
+	dma_addr_t (*read_csr_ring_base)(void __iomem *csr_base_addr, u32 bank,
+					 u32 ring);
 	void (*write_csr_ring_base)(void __iomem *csr_base_addr, u32 bank,
 				    u32 ring, dma_addr_t addr);
+	u32 (*read_csr_int_en)(void __iomem *csr_base_addr, u32 bank);
+	void (*write_csr_int_en)(void __iomem *csr_base_addr, u32 bank,
+				 u32 value);
+	u32 (*read_csr_int_flag)(void __iomem *csr_base_addr, u32 bank);
 	void (*write_csr_int_flag)(void __iomem *csr_base_addr, u32 bank,
 				   u32 value);
+	u32 (*read_csr_int_srcsel)(void __iomem *csr_base_addr, u32 bank);
 	void (*write_csr_int_srcsel)(void __iomem *csr_base_addr, u32 bank);
+	void (*write_csr_int_srcsel_w_val)(void __iomem *csr_base_addr,
+					   u32 bank, u32 value);
+	u32 (*read_csr_int_col_en)(void __iomem *csr_base_addr, u32 bank);
 	void (*write_csr_int_col_en)(void __iomem *csr_base_addr, u32 bank,
 				     u32 value);
+	u32 (*read_csr_int_col_ctl)(void __iomem *csr_base_addr, u32 bank);
 	void (*write_csr_int_col_ctl)(void __iomem *csr_base_addr, u32 bank,
 				      u32 value);
+	u32 (*read_csr_int_flag_and_col)(void __iomem *csr_base_addr,
+					 u32 bank);
 	void (*write_csr_int_flag_and_col)(void __iomem *csr_base_addr,
 					   u32 bank, u32 value);
+	u32 (*read_csr_ring_srv_arb_en)(void __iomem *csr_base_addr, u32 bank);
 	void (*write_csr_ring_srv_arb_en)(void __iomem *csr_base_addr, u32 bank,
 					  u32 value);
+	u32 (*get_int_col_ctl_enable_mask)(void);
 };
 
 struct adf_cfg_device_data;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.c
index 652ef4598930..6609c248aaba 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.c
@@ -30,57 +30,166 @@ static void write_csr_ring_tail(void __iomem *csr_base_addr, u32 bank, u32 ring,
 	WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value);
 }
 
+static u32 read_csr_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_STAT(csr_base_addr, bank);
+}
+
+static u32 read_csr_uo_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_UO_STAT(csr_base_addr, bank);
+}
+
 static u32 read_csr_e_stat(void __iomem *csr_base_addr, u32 bank)
 {
 	return READ_CSR_E_STAT(csr_base_addr, bank);
 }
 
+static u32 read_csr_ne_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_NE_STAT(csr_base_addr, bank);
+}
+
+static u32 read_csr_nf_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_NF_STAT(csr_base_addr, bank);
+}
+
+static u32 read_csr_f_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_F_STAT(csr_base_addr, bank);
+}
+
+static u32 read_csr_c_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_C_STAT(csr_base_addr, bank);
+}
+
+static u32 read_csr_exp_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_EXP_STAT(csr_base_addr, bank);
+}
+
+static u32 read_csr_exp_int_en(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_EXP_INT_EN(csr_base_addr, bank);
+}
+
+static void write_csr_exp_int_en(void __iomem *csr_base_addr, u32 bank,
+				 u32 value)
+{
+	WRITE_CSR_EXP_INT_EN(csr_base_addr, bank, value);
+}
+
+static u32 read_csr_ring_config(void __iomem *csr_base_addr, u32 bank,
+				u32 ring)
+{
+	return READ_CSR_RING_CONFIG(csr_base_addr, bank, ring);
+}
+
 static void write_csr_ring_config(void __iomem *csr_base_addr, u32 bank, u32 ring,
 				  u32 value)
 {
 	WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value);
 }
 
+static dma_addr_t read_csr_ring_base(void __iomem *csr_base_addr, u32 bank,
+				     u32 ring)
+{
+	return READ_CSR_RING_BASE(csr_base_addr, bank, ring);
+}
+
 static void write_csr_ring_base(void __iomem *csr_base_addr, u32 bank, u32 ring,
 				dma_addr_t addr)
 {
 	WRITE_CSR_RING_BASE(csr_base_addr, bank, ring, addr);
 }
 
+static u32 read_csr_int_en(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_INT_EN(csr_base_addr, bank);
+}
+
+static void write_csr_int_en(void __iomem *csr_base_addr, u32 bank, u32 value)
+{
+	WRITE_CSR_INT_EN(csr_base_addr, bank, value);
+}
+
+static u32 read_csr_int_flag(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_INT_FLAG(csr_base_addr, bank);
+}
+
 static void write_csr_int_flag(void __iomem *csr_base_addr, u32 bank,
 			       u32 value)
 {
 	WRITE_CSR_INT_FLAG(csr_base_addr, bank, value);
 }
 
+static u32 read_csr_int_srcsel(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_INT_SRCSEL(csr_base_addr, bank);
+}
+
 static void write_csr_int_srcsel(void __iomem *csr_base_addr, u32 bank)
 {
 	WRITE_CSR_INT_SRCSEL(csr_base_addr, bank);
 }
 
+static void write_csr_int_srcsel_w_val(void __iomem *csr_base_addr, u32 bank,
+				       u32 value)
+{
+	WRITE_CSR_INT_SRCSEL_W_VAL(csr_base_addr, bank, value);
+}
+
+static u32 read_csr_int_col_en(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_INT_COL_EN(csr_base_addr, bank);
+}
+
 static void write_csr_int_col_en(void __iomem *csr_base_addr, u32 bank, u32 value)
 {
 	WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value);
 }
 
+static u32 read_csr_int_col_ctl(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_INT_COL_CTL(csr_base_addr, bank);
+}
+
 static void write_csr_int_col_ctl(void __iomem *csr_base_addr, u32 bank,
 				  u32 value)
 {
 	WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value);
 }
 
+static u32 read_csr_int_flag_and_col(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_INT_FLAG_AND_COL(csr_base_addr, bank);
+}
+
 static void write_csr_int_flag_and_col(void __iomem *csr_base_addr, u32 bank,
 				       u32 value)
 {
 	WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value);
 }
 
+static u32 read_csr_ring_srv_arb_en(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_RING_SRV_ARB_EN(csr_base_addr, bank);
+}
+
 static void write_csr_ring_srv_arb_en(void __iomem *csr_base_addr, u32 bank,
 				      u32 value)
 {
 	WRITE_CSR_RING_SRV_ARB_EN(csr_base_addr, bank, value);
 }
 
+static u32 get_int_col_ctl_enable_mask(void)
+{
+	return ADF_RING_CSR_INT_COL_CTL_ENABLE;
+}
+
 void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
 {
 	csr_ops->build_csr_ring_base_addr = build_csr_ring_base_addr;
@@ -88,14 +197,35 @@ void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
 	csr_ops->write_csr_ring_head = write_csr_ring_head;
 	csr_ops->read_csr_ring_tail = read_csr_ring_tail;
 	csr_ops->write_csr_ring_tail = write_csr_ring_tail;
+	csr_ops->read_csr_stat = read_csr_stat;
+	csr_ops->read_csr_uo_stat = read_csr_uo_stat;
 	csr_ops->read_csr_e_stat = read_csr_e_stat;
+	csr_ops->read_csr_ne_stat = read_csr_ne_stat;
+	csr_ops->read_csr_nf_stat = read_csr_nf_stat;
+	csr_ops->read_csr_f_stat = read_csr_f_stat;
+	csr_ops->read_csr_c_stat = read_csr_c_stat;
+	csr_ops->read_csr_exp_stat = read_csr_exp_stat;
+	csr_ops->read_csr_exp_int_en = read_csr_exp_int_en;
+	csr_ops->write_csr_exp_int_en = write_csr_exp_int_en;
+	csr_ops->read_csr_ring_config = read_csr_ring_config;
 	csr_ops->write_csr_ring_config = write_csr_ring_config;
+	csr_ops->read_csr_ring_base = read_csr_ring_base;
 	csr_ops->write_csr_ring_base = write_csr_ring_base;
+	csr_ops->read_csr_int_en = read_csr_int_en;
+	csr_ops->write_csr_int_en = write_csr_int_en;
+	csr_ops->read_csr_int_flag = read_csr_int_flag;
 	csr_ops->write_csr_int_flag = write_csr_int_flag;
+	csr_ops->read_csr_int_srcsel = read_csr_int_srcsel;
 	csr_ops->write_csr_int_srcsel = write_csr_int_srcsel;
+	csr_ops->write_csr_int_srcsel_w_val = write_csr_int_srcsel_w_val;
+	csr_ops->read_csr_int_col_en = read_csr_int_col_en;
 	csr_ops->write_csr_int_col_en = write_csr_int_col_en;
+	csr_ops->read_csr_int_col_ctl = read_csr_int_col_ctl;
 	csr_ops->write_csr_int_col_ctl = write_csr_int_col_ctl;
+	csr_ops->read_csr_int_flag_and_col = read_csr_int_flag_and_col;
 	csr_ops->write_csr_int_flag_and_col = write_csr_int_flag_and_col;
+	csr_ops->read_csr_ring_srv_arb_en = read_csr_ring_srv_arb_en;
 	csr_ops->write_csr_ring_srv_arb_en = write_csr_ring_srv_arb_en;
+	csr_ops->get_int_col_ctl_enable_mask = get_int_col_ctl_enable_mask;
 }
 EXPORT_SYMBOL_GPL(adf_gen4_init_hw_csr_ops);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.h
index 08d803432d9f..6f33e7c87c2c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.h
@@ -12,13 +12,22 @@
 #define ADF_RING_CSR_RING_UBASE		0x1080
 #define ADF_RING_CSR_RING_HEAD		0x0C0
 #define ADF_RING_CSR_RING_TAIL		0x100
+#define ADF_RING_CSR_STAT		0x140
+#define ADF_RING_CSR_UO_STAT		0x148
 #define ADF_RING_CSR_E_STAT		0x14C
+#define ADF_RING_CSR_NE_STAT		0x150
+#define ADF_RING_CSR_NF_STAT		0x154
+#define ADF_RING_CSR_F_STAT		0x158
+#define ADF_RING_CSR_C_STAT		0x15C
+#define ADF_RING_CSR_INT_FLAG_EN	0x16C
 #define ADF_RING_CSR_INT_FLAG		0x170
 #define ADF_RING_CSR_INT_SRCSEL		0x174
+#define ADF_RING_CSR_INT_COL_EN		0x17C
 #define ADF_RING_CSR_INT_COL_CTL	0x180
 #define ADF_RING_CSR_INT_FLAG_AND_COL	0x184
+#define ADF_RING_CSR_EXP_STAT		0x188
+#define ADF_RING_CSR_EXP_INT_EN		0x18C
 #define ADF_RING_CSR_INT_COL_CTL_ENABLE	0x80000000
-#define ADF_RING_CSR_INT_COL_EN		0x17C
 #define ADF_RING_CSR_ADDR_OFFSET	0x100000
 #define ADF_RING_BUNDLE_SIZE		0x2000
 #define ADF_RING_CSR_RING_SRV_ARB_EN	0x19C
@@ -33,9 +42,41 @@
 	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_RING_TAIL + ((ring) << 2))
+#define READ_CSR_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_STAT)
+#define READ_CSR_UO_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_UO_STAT)
 #define READ_CSR_E_STAT(csr_base_addr, bank) \
 	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_E_STAT)
+#define READ_CSR_NE_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_NE_STAT)
+#define READ_CSR_NF_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_NF_STAT)
+#define READ_CSR_F_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_F_STAT)
+#define READ_CSR_C_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_C_STAT)
+#define READ_CSR_EXP_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_EXP_STAT)
+#define READ_CSR_EXP_INT_EN(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_EXP_INT_EN)
+#define WRITE_CSR_EXP_INT_EN(csr_base_addr, bank, value) \
+	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_EXP_INT_EN, value)
+#define READ_CSR_RING_CONFIG(csr_base_addr, bank, ring) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_RING_CONFIG + ((ring) << 2))
 #define WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
@@ -57,6 +98,25 @@ do { \
 		   ADF_RING_CSR_RING_UBASE + ((_ring) << 2), u_base);	\
 } while (0)
 
+static inline u64 read_base(void __iomem *csr_base_addr, u32 bank, u32 ring)
+{
+	u32 l_base, u_base;
+
+	/*
+	 * Use special IO wrapper for ring base as LBASE and UBASE are
+	 * not physically contigious
+	 */
+	l_base = ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) +
+			    ADF_RING_CSR_RING_LBASE + (ring << 2));
+	u_base = ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) +
+			    ADF_RING_CSR_RING_UBASE + (ring << 2));
+
+	return (u64)u_base << 32 | (u64)l_base;
+}
+
+#define READ_CSR_RING_BASE(csr_base_addr, bank, ring) \
+	read_base((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, (bank), (ring))
+
 #define WRITE_CSR_RING_HEAD(csr_base_addr, bank, ring, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
@@ -65,28 +125,59 @@ do { \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_RING_TAIL + ((ring) << 2), value)
+#define READ_CSR_INT_EN(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_INT_FLAG_EN)
+#define WRITE_CSR_INT_EN(csr_base_addr, bank, value) \
+	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_INT_FLAG_EN, (value))
+#define READ_CSR_INT_FLAG(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_INT_FLAG)
 #define WRITE_CSR_INT_FLAG(csr_base_addr, bank, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_INT_FLAG, (value))
+#define READ_CSR_INT_SRCSEL(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_INT_SRCSEL)
 #define WRITE_CSR_INT_SRCSEL(csr_base_addr, bank) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_INT_SRCSEL, ADF_BANK_INT_SRC_SEL_MASK)
+#define WRITE_CSR_INT_SRCSEL_W_VAL(csr_base_addr, bank, value) \
+	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_INT_SRCSEL, (value))
+#define READ_CSR_INT_COL_EN(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_INT_COL_EN)
 #define WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_INT_COL_EN, (value))
+#define READ_CSR_INT_COL_CTL(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_INT_COL_CTL)
 #define WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_INT_COL_CTL, \
 		   ADF_RING_CSR_INT_COL_CTL_ENABLE | (value))
+#define READ_CSR_INT_FLAG_AND_COL(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_INT_FLAG_AND_COL)
 #define WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_INT_FLAG_AND_COL, (value))
 
+#define READ_CSR_RING_SRV_ARB_EN(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_RING_SRV_ARB_EN)
 #define WRITE_CSR_RING_SRV_ARB_EN(csr_base_addr, bank, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
-- 
2.18.2


