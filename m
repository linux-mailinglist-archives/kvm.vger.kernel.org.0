Return-Path: <kvm+bounces-9123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A926685B168
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 04:30:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D546C1C21833
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 03:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE6358AA9;
	Tue, 20 Feb 2024 03:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lFdUtbP5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66F95820E;
	Tue, 20 Feb 2024 03:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708399784; cv=none; b=lvrCiXnsqL88SCIPgp0gOj7JG1G4Cyk3/VpjPxyroU8Fk+2da+3mRMDze23fC5HBjuc9z5xaZejNmMq6ICIMeOpvQPhAlMMNiYO9MY+F3hU9z2cNr8PyWT8stVqT9y/4T60owmAGyUE9Zq5gEImCK6dtv2wf7FLmcLM0+k+ZZWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708399784; c=relaxed/simple;
	bh=AHf7nRY3vfpNNK+tkeq80dZDoVsayvhUuKbnKLUDsK4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=EqWtSNOnRay9HqLyOo+PPAxWOkJuIiVEaePrKP3nliMnsR24VNLvlTiKeYxU0A3rulUskQHNVnLHNGrSsRbok6CtyyCLd9xb5e25Sk0ZGwWjqmA0IcqOflyZ/6wx0KPhnMOSX218z6bELVv6D8XQRy8hPTW5kkpD7AqAIxxt5sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lFdUtbP5; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708399783; x=1739935783;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=AHf7nRY3vfpNNK+tkeq80dZDoVsayvhUuKbnKLUDsK4=;
  b=lFdUtbP5ulRFM6qOhxXQSj4MEyo/YWQ5ljYsWqxoUFyfwJ7fGeISIAM8
   4YKNTnh0xLrAyE5U/4cvM2vfBTMlDxeGf2Mw+5I+mE/m3HBSeXKEHkLjZ
   ucjf2r/jmFB2a5anxp9no9DPKQMybaPFhdlmZNxcBEaILdsa8SJgXYZjT
   2dwEJYYPDASaROBXPT71mO4Mq10EaHzRH8mx9H6zZBO/EeGTlPHeopgsb
   aF6PW5sb1NHaIH0n5eOTaEyh/UgVu6y65Q/WEseECrApq+lr7INljAWLj
   8Dj37XG4VWLiML/5rpoMGkYOtcIVQXqRqr1ak3wchwRkNuOptHYeEhwEK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2354095"
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="2354095"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2024 19:29:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="9302086"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa003.jf.intel.com with ESMTP; 19 Feb 2024 19:29:39 -0800
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
Subject: [PATCH v2 05/10] crypto: qat - rename get_sla_arr_of_type()
Date: Tue, 20 Feb 2024 11:20:47 +0800
Message-Id: <20240220032052.66834-6-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240220032052.66834-1-xin.zeng@intel.com>
References: <20240220032052.66834-1-xin.zeng@intel.com>
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


