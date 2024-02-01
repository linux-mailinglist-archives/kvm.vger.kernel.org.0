Return-Path: <kvm+bounces-7728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CBEE845BD8
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:42:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 917A61C23774
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC87177A06;
	Thu,  1 Feb 2024 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d8VjlzG6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8C2779F8;
	Thu,  1 Feb 2024 15:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706802131; cv=none; b=HdwZImUTNazqCN1o/6MCn+pJii9XJT9vo6UF6oY+fFPSuo+PPAFY7oIKVL6a5mmZUh/C0Num+op/BVwkVyutsXY4TRSBd3wO0jmgotIHyrMdihTE4QMWKy6lydpMf53FHa8CNhr2y4oBevX6QBgNFZmLp86jRjwfluKtb+ATUqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706802131; c=relaxed/simple;
	bh=kKbIxNomOg5IocogqlQI4qIKOM/SH9Yo81ie5EzLeEY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=fa8JPHLvB+klTC44bSD5GmSLi8+/Byhmw2awiO7QjC1BuuUe7IptsPgIKLUWFFvSYm1Jc/StX3p1zgln19YEroCsoQLdqMOAwx3x9k7Duv/0hDE4A43zIq6v15v63S1YbEbf8uFRxsvqkHQf9tP64zYAYEgSomRWFLkdtVzPMdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d8VjlzG6; arc=none smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706802129; x=1738338129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=kKbIxNomOg5IocogqlQI4qIKOM/SH9Yo81ie5EzLeEY=;
  b=d8VjlzG6ZZIUjbC2PotGrKXXOEQAaYGFrdVa/U9uvwm1kscAZBFEu+Nn
   cUF/kg5BlT6pNcvBljJaiMYyAd/xT3+TtH1WEsI6xMEFRL4ow6saa3bY6
   x9rBwtbtqnTHZYMyb9imRSIgFaKmmoozc9x6FB2bz1kL38QcZLH9+UbGo
   lekwuhxFSMeFF9S+niUxgHlXsQ9ITrCDjRPYk8CwqPjJTH5k6qiVTs6jL
   qwh/rLcyRKejZm5Wvb7FUcn3IQgvUACakbN2pYCKdlzhMXDvX0iQhLhnU
   fPldZoR3Wo2N0/s+Z4825nLAWBeb0Q+LleggST7BR/3hx6kU3/G+6gcDX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="401052942"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="401052942"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 07:42:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="133324"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa007.jf.intel.com with ESMTP; 01 Feb 2024 07:42:06 -0800
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
Subject: [PATCH 05/10] crypto: qat - rename get_sla_arr_of_type()
Date: Thu,  1 Feb 2024 23:33:32 +0800
Message-Id: <20240201153337.4033490-6-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240201153337.4033490-1-xin.zeng@intel.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
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
index de1b214dba1f..41017af1be68 100644
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
@@ -857,7 +857,7 @@ static int add_update_sla(struct adf_accel_dev *accel_dev,
 
 	if (!is_update) {
 		mark_rps_usage(sla, rl_data->rp_in_use, true);
-		get_sla_arr_of_type(rl_data, sla->type, &sla_type_arr);
+		adf_rl_get_sla_arr_of_type(rl_data, sla->type, &sla_type_arr);
 		sla_type_arr[sla->node_id] = sla;
 		rl_data->sla[sla->sla_id] = sla;
 	}
@@ -1047,7 +1047,7 @@ void adf_rl_remove_sla_all(struct adf_accel_dev *accel_dev, bool incl_default)
 
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


