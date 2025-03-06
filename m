Return-Path: <kvm+bounces-40296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC7E6A55AC4
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 00:11:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDAAE176ED3
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3C527EC78;
	Thu,  6 Mar 2025 23:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aHjV/cey"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2040.outbound.protection.outlook.com [40.107.96.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFFB27D776;
	Thu,  6 Mar 2025 23:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302663; cv=fail; b=VkPHZmiN43yKMStRgHs9gJ61tSgXouXA3cfxPDSOyY9A4Yfc485AGCaosiefIRiwH9GEHUXlcacYS/B5Yp1TBSS7jnDRcZq3W3VJFdEVThX97TeYOZDZyA5y0LzVbW0TI1Jiiri8bTbP2FbrMbhaVgeomUel4QGVwpazrqRtVss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302663; c=relaxed/simple;
	bh=D1h0iXoB6QY3u4U8OTYe6FPW+XQ8kRSQmpYXbv/yAfE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c8yuNYLSjPykR/tmkca1ZIqv0EiIq3MC76Q3cV7hPZEznMdy8bs+jawGuD8CoVJucQ2naT2i4/24ecqnwsvau182IQjCiex+vWUriM8ciloGVOUL6xgtXns3aJuoGJW163C0ml2Gox1EEDhCvVJvel4cFLxb2zMI/lIftDrp1ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aHjV/cey; arc=fail smtp.client-ip=40.107.96.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A89alWA5R3UtZWy/M75Zn9y+9tbA35gCzxRvgL4jD1lqhpW0jruNagjQQv2dVwcA8NcZaTF4ArMSGAD3NVfLfJFFTNS5qFqj+0imaZ0qW7ob2Wpy6dxNGorfXu+Vd8TJDsGUxvJgX03X/mgT8pOfCBMxKzlYLOc0uzXNPNbeRKoal6oPtWO7Kxo7ZbZcCHTun7zwNsE7VKScWuhcX1L2lIEn3FkwLxNnhY9+R/uA2MiSXGn2uSIxIiIdtSyb5IRNPCkidpcvQSHad0U60LcmoN24YwDlEJC0QeMe9d32zRhTy99W4mkwf0YYJHwifEa6wGI3rUBP/JkwVyauRuiDzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VK/ic4GADChmHiP2vA3I1ncWU2HoC068SbraXg09fPM=;
 b=b3e0RBKUL8ENwuTYrl92buh7COZ8JqYkouS2LwffzS/DbnGyRlwqPgxXruWXrDrIbvAEAE56lwOPdtCfgTYc0SObNHTD5R73EMKhu4G4K/07nbOy4FqufKX8m+Q61cxTWC4+IBD94DcgvI3w4MxRtWhxp0JFzIDRwBe71MVYVfa3n4g/WIb/hFHFdgo+yaMB7+RWSVt0MpHOKLNlCsyzkGTFz63jN2LsNW89CBHNIdeoIiN0O3bFOZfN/qypP2JUGG6ml/rnMRXcMJdK8xCUEBPKoSUpzAXIEky8iXxNldUpFqxrcJnWHr7wO0uWORc1/GJSKnG+0/nED314PXUtTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VK/ic4GADChmHiP2vA3I1ncWU2HoC068SbraXg09fPM=;
 b=aHjV/cey/TIL4XaKdBaLa1vJQp5+M9XGdYv/iST/sNp14wUq+iC6tv0LHStbIj9ev9mWZSoKex4Zxjna9AA0VW6F/fbsc4Lu1A059j7Af9yc+TVp+244ueo+9DuNjkI9qS9BuyJkO82noM7rgi1Ftvm7YkOWaIL4lJ6JsYYVYRM=
Received: from SN7PR04CA0179.namprd04.prod.outlook.com (2603:10b6:806:125::34)
 by DM4PR12MB5722.namprd12.prod.outlook.com (2603:10b6:8:5d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Thu, 6 Mar
 2025 23:10:58 +0000
Received: from SN1PEPF000397B4.namprd05.prod.outlook.com
 (2603:10b6:806:125:cafe::b5) by SN7PR04CA0179.outlook.office365.com
 (2603:10b6:806:125::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.18 via Frontend Transport; Thu,
 6 Mar 2025 23:10:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B4.mail.protection.outlook.com (10.167.248.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Thu, 6 Mar 2025 23:10:56 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Mar
 2025 17:10:55 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v6 6/8] crypto: ccp: Add new SEV/SNP platform shutdown API
Date: Thu, 6 Mar 2025 23:10:46 +0000
Message-ID: <adf8e5ed133da6fdcbd795b10cf2a06310a6a5f4.1741300901.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1741300901.git.ashish.kalra@amd.com>
References: <cover.1741300901.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B4:EE_|DM4PR12MB5722:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c928fbe-e39c-4cec-3bf7-08dd5d0426c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AgVrrhdM9ZJuwIJQovSaIrcOOphDWuqNd/lCHndqpxxuveYS+hXCT734CYMt?=
 =?us-ascii?Q?GDsU1dRpwpaknxcOl/JY1H3Zgoi8FnGBgh6ePNvmFL/nTvthahXLF7j1hOfc?=
 =?us-ascii?Q?+7WaEC9Y3edzUx7mj3bTZaHCdP9itDfDQUWisv9ydWfsPmwi7JZXHgPVLKQ+?=
 =?us-ascii?Q?Sx2uAm9Z+HhA6p2mfxjYLvNFod8q4BZy3m+7VjkqXlYjGAoRVJ3Kg9J9Qi5z?=
 =?us-ascii?Q?k19Q7jQIs+YLQESdvxKHyRva6eFakvXc6035c94r0BybQ+XJ8evmMwDjEuZf?=
 =?us-ascii?Q?SsQv50o3st75wBk+nCZf5U95l/FH7bMaerE/H5tB7sIYgbZW3nAUEpftDrRn?=
 =?us-ascii?Q?nGgzIbpK0Jx03xPaUVjMYFwBCXUWEW7n43m5IXr/lOqdL8RNNXby8U3FnsG4?=
 =?us-ascii?Q?noavVUDSFfHiagT10WX7qIHvoRM/BE7N7EXYxipN9n5RM36vB0NE/R66Ppy0?=
 =?us-ascii?Q?EpNk28WvhE27qzXZw94+KoZMVQEmOCE4dSAUaZp+xqXYIdGmy8z6ceMgQTgA?=
 =?us-ascii?Q?oHwFA2NN8ztOgTM1ExLo6f0+8SBCDYCxk0q1mOO/Cael+9AYj3uLVvbBQGtK?=
 =?us-ascii?Q?UsONw3SAkiTTefOl04AdxmBgdC95atqYOzGWR1e1B5UssUB176T/GQSxwYxa?=
 =?us-ascii?Q?IsSgV3raeYf3yxbDtF88gniGgs102VIe5C6Zt+xez1GYU3KNJVfANFrzA18b?=
 =?us-ascii?Q?f0zni5Rp3x7sJMBx+U4JEvw1O2s7r0RRU/VFcjEtwM70jLq4zf4K+TWh+pj/?=
 =?us-ascii?Q?MIqCcacla8WAyDFHqjHZOOCWu2a1HtZ71d7exaDc+eVJ+meuxNo6WfcHD/Fc?=
 =?us-ascii?Q?SKDqQEzjC/tcS8YGyAAVwL+WRlzfxCvFWRmTxkQ+Vv7lpqp+qpvM+r7pPo+N?=
 =?us-ascii?Q?GC0utGOhpdYR+IkJ8pZRyy5Yg52NVae2ySUGPXjVXVDwsYqGW3DBt1RktKXj?=
 =?us-ascii?Q?w43nX77nPgjsNyREJcUMXPqibJCOIrs+wGzgybsR1HxPO2d3jnvQBnIEQGkE?=
 =?us-ascii?Q?PYU8Ftx9ZDQoGsQn/YCaF9Clb4ZL9ejz5RUCqGuXPr5kQ8A1S8mU7lHBIkCz?=
 =?us-ascii?Q?Al6dxQLczPxxdYZxTlaj3kFzNCTfi7TCAnyC51Cml7xg43/5jIsEfUo1TPrH?=
 =?us-ascii?Q?QLjCfEhCCzjM/+PmTrejFj8DrZn+bXnCtpDmgKw2zKbjPnAJxkbjZgI1vRae?=
 =?us-ascii?Q?iyVGVdEhO5XB+cPYePYLolVpVSVdemlX3WPIsnj10miE+E+U+40wzjpNRl0f?=
 =?us-ascii?Q?MIRUhJOz020/9R58PsUsj2i/MpNiGZ0cso5kMCC+IXW9cAfiNV1aDRp6OhPC?=
 =?us-ascii?Q?v36oHVhGLr9d1qeMkq8WPk+1pked0CTBN7Ha4gMfvyZ7sOWAAfnOao+22vIE?=
 =?us-ascii?Q?AidFHcWtCmQuJ8D8yJaP1gRs5XSxQN0JCjkjHGBaU0FZsp0nezJBnsNXqLtV?=
 =?us-ascii?Q?GVJyUJLwHJj8y9x0tuDE/Xzv4pbONwoNCsKuHjvh6iOT7RGzakuZVIJMvSLV?=
 =?us-ascii?Q?R2ReQx3Rh3iUJFXEiNq9KchX4uN6VM2QyG8t?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 23:10:56.7671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c928fbe-e39c-4cec-3bf7-08dd5d0426c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5722

From: Ashish Kalra <ashish.kalra@amd.com>

Add new API interface to do SEV/SNP platform shutdown when KVM module
is unloaded.

Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 9 +++++++++
 include/linux/psp-sev.h      | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6fdbb3bf44b5..671347702ae7 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2468,6 +2468,15 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 	mutex_unlock(&sev_cmd_mutex);
 }
 
+void sev_platform_shutdown(void)
+{
+	if (!psp_master || !psp_master->sev_data)
+		return;
+
+	sev_firmware_shutdown(psp_master->sev_data);
+}
+EXPORT_SYMBOL_GPL(sev_platform_shutdown);
+
 void sev_dev_destroy(struct psp_device *psp)
 {
 	struct sev_device *sev = psp->sev_data;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index f3cad182d4ef..0b3a36bdaa90 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -954,6 +954,7 @@ int sev_do_cmd(int cmd, void *data, int *psp_ret);
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
+void sev_platform_shutdown(void);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -988,6 +989,8 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
 
 static inline void snp_free_firmware_page(void *addr) { }
 
+static inline void sev_platform_shutdown(void) { }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.34.1


