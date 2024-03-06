Return-Path: <kvm+bounces-11139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B2D873873
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 15:08:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4E5A1F22E41
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 14:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED39313340D;
	Wed,  6 Mar 2024 14:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DPqne4kW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C15131E27;
	Wed,  6 Mar 2024 14:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709734075; cv=none; b=UfOns+0ePVHdaqCpuRCeNL11GMmewaZF5Ot0JJYX/m6dA/pVNhKnNCqPW9E4NvfHl6QIN9Bt2GzIfRjR935HQQW9K45wuLzgu+kydfRx91mWu4dZAC7sKOfxw2/eQczrDb66QZAInRf6+HkPeEy62PSK+XfUQNAgo+u2RxpZvhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709734075; c=relaxed/simple;
	bh=KHiFCrGFQg+WrReBqW+YMqU0GJq5r/0uJnWuBZ3jKCY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=fG1UdEbh87jZpsHDigcK/AtyQ3j1/KvgeQX+8eJdjndYNCo/tD5yMXorP/6KeK+rHAXgqAAuCA4FI4apPdSn+d/ZAMI/H5/MWymQKDGibHhFtgTbtFHmNba4Tc3+5/e3yn0jdk6GIAPBkJxa7PY+fF2CmkmXTkUJWN6SasczGuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DPqne4kW; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709734074; x=1741270074;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=KHiFCrGFQg+WrReBqW+YMqU0GJq5r/0uJnWuBZ3jKCY=;
  b=DPqne4kW3EqVRSxyWo0CG58+dLgH0Rl0k76DAn9bC225iTT6u5/0dKs7
   2iddqmdA1W5h0kJ9R7D8GcimeL4q3+H6CoQxfAwPEViNwsBYyprgDJEZz
   TCbsa3m+iluZWVTXtHHXmyLrm8+Q10ZP5lduj3Bg+wDq155y8UvU47FHV
   jUdWPlb7OSIy2q82zpnUjE2O8m1K9sKXwfqOwvi+xpRY9DwN74MPlKmAY
   ATA/Iljk2e21SrhcuwCr7hqgvGJS0kuTW+8V3nZbJYuzNeB/LYCsnYe7G
   Tm+UCnv2FRZlqlODWnuNZG+5M8IVeXA5OZ8yaAnm+Gul0oFvFB4zYQMLU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="15490378"
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="15490378"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 06:07:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="10192174"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa007.jf.intel.com with ESMTP; 06 Mar 2024 06:07:50 -0800
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
Subject: [PATCH v5 05/10] crypto: qat - rename get_sla_arr_of_type()
Date: Wed,  6 Mar 2024 21:58:50 +0800
Message-Id: <20240306135855.4123535-6-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240306135855.4123535-1-xin.zeng@intel.com>
References: <20240306135855.4123535-1-xin.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Siming Wan <siming.wan@intel.com>

The function get_sla_arr_of_type() returns a pointer to an SLA type
specific array.
Rename it and expose it as it will be used externally to this module.

This does not introduce any functional change.

Signed-off-by: Siming Wan <siming.wan@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c | 10 +++++-----
 drivers/crypto/intel/qat/qat_common/adf_rl.h |  2 ++
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index d4f2db3c53d8..65f752f4792a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -183,14 +183,14 @@ static enum adf_cfg_service_type srv_to_cfg_svc_type(enum adf_base_services rl_s
 }
 
 /**
- * get_sla_arr_of_type() - Returns a pointer to SLA type specific array
+ * adf_rl_get_sla_arr_of_type() - Returns a pointer to SLA type specific array
  * @rl_data: pointer to ratelimiting data
  * @type: SLA type
  * @sla_arr: pointer to variable where requested pointer will be stored
  *
  * Return: Max number of elements allowed for the returned array
  */
-static u32 get_sla_arr_of_type(struct adf_rl *rl_data, enum rl_node_type type,
+u32 adf_rl_get_sla_arr_of_type(struct adf_rl *rl_data, enum rl_node_type type,
 			       struct rl_sla ***sla_arr)
 {
 	switch (type) {
@@ -778,7 +778,7 @@ static void clear_sla(struct adf_rl *rl_data, struct rl_sla *sla)
 		rp_in_use[sla->ring_pairs_ids[i]] = false;
 
 	update_budget(sla, old_cir, true);
-	get_sla_arr_of_type(rl_data, sla->type, &sla_type_arr);
+	adf_rl_get_sla_arr_of_type(rl_data, sla->type, &sla_type_arr);
 	assign_node_to_parent(rl_data->accel_dev, sla, true);
 	adf_rl_send_admin_delete_msg(rl_data->accel_dev, node_id, sla->type);
 	mark_rps_usage(sla, rl_data->rp_in_use, false);
@@ -875,7 +875,7 @@ static int add_update_sla(struct adf_accel_dev *accel_dev,
 
 	if (!is_update) {
 		mark_rps_usage(sla, rl_data->rp_in_use, true);
-		get_sla_arr_of_type(rl_data, sla->type, &sla_type_arr);
+		adf_rl_get_sla_arr_of_type(rl_data, sla->type, &sla_type_arr);
 		sla_type_arr[sla->node_id] = sla;
 		rl_data->sla[sla->sla_id] = sla;
 	}
@@ -1065,7 +1065,7 @@ void adf_rl_remove_sla_all(struct adf_accel_dev *accel_dev, bool incl_default)
 
 	/* Unregister and remove all SLAs */
 	for (j = RL_LEAF; j >= end_type; j--) {
-		max_id = get_sla_arr_of_type(rl_data, j, &sla_type_arr);
+		max_id = adf_rl_get_sla_arr_of_type(rl_data, j, &sla_type_arr);
 
 		for (i = 0; i < max_id; i++) {
 			if (!sla_type_arr[i])
diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.h b/drivers/crypto/intel/qat/qat_common/adf_rl.h
index 269c6656fb90..bfe750ea0e83 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.h
@@ -151,6 +151,8 @@ struct rl_sla {
 	u16 ring_pairs_cnt;
 };
 
+u32 adf_rl_get_sla_arr_of_type(struct adf_rl *rl_data, enum rl_node_type type,
+			       struct rl_sla ***sla_arr);
 int adf_rl_add_sla(struct adf_accel_dev *accel_dev,
 		   struct adf_rl_sla_input_data *sla_in);
 int adf_rl_update_sla(struct adf_accel_dev *accel_dev,
-- 
2.18.2


