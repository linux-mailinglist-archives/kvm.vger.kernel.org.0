Return-Path: <kvm+bounces-10263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 812A686B213
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:43:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FE501F2553A
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 14:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4ABF15CD42;
	Wed, 28 Feb 2024 14:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tfn67eid"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBE815B988;
	Wed, 28 Feb 2024 14:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709131382; cv=none; b=Z1aSACTmaZ+zVkc0hBOsPVLsXj7JILFQ0YOnnE01DoxwyuVPX4bnGLCj7in7pucioU6/pHruBuggrDi8E3iovqDk9W6e6ltClx+7jETHZ2os2ZvgyKgANgtRO6ngCZKOgaB3Kq22D3WIQRtiqM9yh6kotosfB5aJKsdDLenJvzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709131382; c=relaxed/simple;
	bh=AHf7nRY3vfpNNK+tkeq80dZDoVsayvhUuKbnKLUDsK4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Opz0dAfIsgI1W9D3Txr+6DJ/30BBmareNajcnVN8CMH0Y5GBarYaOxAIhluxC+hgxiNkKD7uhjrg+BTs/bf1bdIc7Qp9gcLUubhqTis9fVI5yHTKXds+doZGPOY3eefiz4fUZABvV7alm3qFGEiBwlk2Rg1t5Q4r54ndYlZKGCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tfn67eid; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709131380; x=1740667380;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=AHf7nRY3vfpNNK+tkeq80dZDoVsayvhUuKbnKLUDsK4=;
  b=Tfn67eidDw/9UGUwWLQZPutPnEIfsPFQvrThMCznrtBnzHGdHdDGVUOe
   wJZSEPNsWBZX5qsGeMDAFK5taXwtOCwTjeMcQvgC533tRyo0QiS7xCkpu
   wPZs+jNJQy9iG/qJUvn9tYDKkzQ5GV0x9CXjtICshzMB/CPr03pQVXmPO
   m1g1vFpXOYuAdolG+qboHWAb0hkVe90FLarnlZ3zOa8Zvk9q2upOW3d5X
   NWnVEbhpveHBv2sgjPQ8yADKjSwx9DTrSeS9oraOo81LNSWB6POQDlta+
   esn5RMRudz21fzIdjx5Q4Si2uqwl8inccE9Sz7iKq5Dq4BNYDDkEOqI+H
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="14951001"
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="14951001"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 06:43:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="11994715"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmviesa005.fm.intel.com with ESMTP; 28 Feb 2024 06:42:57 -0800
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
Subject: [PATCH v4 05/10] crypto: qat - rename get_sla_arr_of_type()
Date: Wed, 28 Feb 2024 22:33:57 +0800
Message-Id: <20240228143402.89219-6-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240228143402.89219-1-xin.zeng@intel.com>
References: <20240228143402.89219-1-xin.zeng@intel.com>
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
Reviewed-by: Xin Zeng <xin.zeng@intel.com>
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


