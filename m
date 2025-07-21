Return-Path: <kvm+bounces-52989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3540DB0C5FD
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:15:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FE937AE9D0
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC2F2DBF47;
	Mon, 21 Jul 2025 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qvJOTfvW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C869E1A2630;
	Mon, 21 Jul 2025 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753107256; cv=fail; b=a0+uz1mAghMDQ3b86SIkNiPbWK4xflyTh8bDLBfEMKMc728Ls6TcdECRRAqEmuqlMDoi/pILFqvL+HU88Cu9vqu1zyiR2VdFsVag+ekQMueEl5Q8xINWW0qntd0JrgmOX0RJ1ak5nAByayzvFz9jXk9+v+KohqyyJTvshOrY1Oc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753107256; c=relaxed/simple;
	bh=T8odUDrw3jrQRx4muJYSAGoWab5WpsmGqrRjbQSmT3g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z873RFsA/DfnwdFoN+vbovq/COg3lSsyiKHUvm7trW4r5L+2CB1hPVT7nBWcF80nJvqkWnK6vUfGCGw1mWxIhqX0PcGv35taYfOlyVJUtsmryXMaF+UHI+O6mPQziSkRBWdopIIa27JE37rNKawDFpiWJ6Z8Yu/aXN7rc2QNhhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qvJOTfvW; arc=fail smtp.client-ip=40.107.92.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DXZV3JNwMPR9bBQ5iqO5DX1i2ZApwD2kCjDM+CjonFNfzXUOqw6vZd6fTPSX+KPSXKeLMUO1JCz4NrWkHWMBcpzjWTymXBBFp7Upom8wYNBp9b0kaRzqviVDSnvtS+iAJU3fpzS1QCTCts0xnC0FuhR1Rcf3d7H2dHc9cTeKBnRDmSVnvLq0HfAPt74Wtn2S5wZcvUKjugHhdUg8CfdCMuZmTZbnqP+oUq1uycR4MzGbZmGc9/aRo1i5gEpgc193UP3XbWPsD7FuECJ1JcjOaGPp+S3tm41VPEBePFC4qGZ3Co6+SxVmKdp49RFLmI317FozLVbO8q6d/GKdZPtE2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtoUqRl/WtZQaD9y0Zh8so0rq4Yv74VmynkxQdA+VFQ=;
 b=RRL6nfJ5MyeqcwGI6Yt+JiCAc0I4IwL0q5eIPc1ZtEyx9F1kGd/fVI5m0+m5/8ORBmjuwQblElPeaXrTzb1pS4lqbP/mnfX8OjXLfSYicZN1913iry5oNS/RhCifdtDKYKFvncMntE7PvuTVvkPmlEiTsMlbLXrZTe1y/JhHxStmecoo68/0Zf/rNr7b4iv0sk4i0ch3LJDd7M63//NVaCzge5NWYU7dmWJASS+2RlUdqxUe7/ZE2iNx1EXUoMvix3NVSAKvCaSilGPnLRPAmvCyFLH7GCCXeGMQPnJkSfGPVnDtUKJnBggK/0bKSh2pmB0pgEyfYetjZXDq3DbbYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtoUqRl/WtZQaD9y0Zh8so0rq4Yv74VmynkxQdA+VFQ=;
 b=qvJOTfvWvYjkBOq39aFRTghphnXlTefSqg363dZBN92A4FlAFnOHYdd0GKpoL7dY7M4+sHpKZyaxw5G0xVF29jHvN2QDo45YdmNuBKHG4WNvhPNYwUW+e/6f2YlT2M9brVGdRiQHlNtNj6gEJjSLmwhm5HMlIRg4JshhOKWZmqE=
Received: from SJ0PR03CA0237.namprd03.prod.outlook.com (2603:10b6:a03:39f::32)
 by SJ2PR12MB7893.namprd12.prod.outlook.com (2603:10b6:a03:4cc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Mon, 21 Jul
 2025 14:14:09 +0000
Received: from MWH0EPF000A6731.namprd04.prod.outlook.com
 (2603:10b6:a03:39f:cafe::2) by SJ0PR03CA0237.outlook.office365.com
 (2603:10b6:a03:39f::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.29 via Frontend Transport; Mon,
 21 Jul 2025 14:14:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6731.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Mon, 21 Jul 2025 14:14:09 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Jul
 2025 09:14:06 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v7 5/7] crypto: ccp - Add support to enable CipherTextHiding on SNP_INIT_EX
Date: Mon, 21 Jul 2025 14:13:55 +0000
Message-ID: <727d1afc55ac4292d611da71d661a4cfe55fd5cd.1752869333.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752869333.git.ashish.kalra@amd.com>
References: <cover.1752869333.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6731:EE_|SJ2PR12MB7893:EE_
X-MS-Office365-Filtering-Correlation-Id: c498c03c-1640-4892-3d72-08ddc860dc6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cR3LoDuG4UbWZbOTD2mY+VxjpH1wXj5KZGM/VbasHbmzgJs66ddXZcjZ0BtW?=
 =?us-ascii?Q?9fn/FD61BAEJNcQumO31XTKtqmmx8wcrJ0VQVwRKdlk3MsiKM00hSg2wbNC7?=
 =?us-ascii?Q?b5ds2hRw7dlkZZjk615aKDpR2BRwmwQiDM5T1vhwL3/Od087/AMZobj2KOwK?=
 =?us-ascii?Q?hj/Z3uhClVLw7XGqCH0rKWsf3Umf57tF9ByK0PhzUGHJAyxwP7kMzj793faA?=
 =?us-ascii?Q?iIbWxGHs6LISHtMPJUxBJcw02UXQC8k37VSBr0oGKg8I1Q4BG0EAqg3VKHed?=
 =?us-ascii?Q?etCYj0dWwaSTFhu25Tgz+14CUv66FWGpS30ErOb+TT+OysHWcJSbLF0jvvml?=
 =?us-ascii?Q?KfrT050RQZ5G2lEpngko4K0/1Dbf+JA/3Bd1j56TJmeuKrkrawX8XlU9r+1d?=
 =?us-ascii?Q?VKO1lmXX4BQAMyHY+N3M96gT9Cva1FycKmp+IkSOlG2e9Mgbg8JLVvBcYnRa?=
 =?us-ascii?Q?N2UuPH5HWitMf0RAI/oRZyfGOATsGjXjFAg5u2D1TJMUfpdqRMEl1Gwn9qTp?=
 =?us-ascii?Q?O3+T+2jX5Ab3aSu60lrCqj9QaFCzITcdPtbHrTMwyd+jxf1LxF1FODmk8uqS?=
 =?us-ascii?Q?h8yF8mYBh1MQZ+IqTZyNOLqPtEKDNEJ/3UUSJOgiDOBQk5Igd3tmMqqhfEUm?=
 =?us-ascii?Q?oWf6b9i/mQy8cInYpHaZzcBbywVBgMERHfkdDP641ubThIIY3uX86AHCl1h4?=
 =?us-ascii?Q?VB7Ikix/5iCwrxAL5vX8Lw0taRkXm4uWhkaCLwH8mzmfQHkxkFDNgnt+7jDO?=
 =?us-ascii?Q?kIXhmq9//9kWmONVzugfUIfX+1rUS+v2MU3y+o2LXHDmvgheWD1PPfpcsSWM?=
 =?us-ascii?Q?fExchRd1lgkIMYEPVExEc+ynL3V9RNvZVoF6jQElyn0Ryx/90hE0XI11nGNX?=
 =?us-ascii?Q?xC+kmZS3/3limP5QN5H3w9gfDeaFGBKuj/MzqFFkYlLAiQRdUyuS937ahHU2?=
 =?us-ascii?Q?boa/vV24bEyRauG4Pw0V6yFO5y6V5xT5dI59Byce6bS36krDv3lESgPFduJ2?=
 =?us-ascii?Q?wJ2hm8sVybLuLDbfZfy0eU9dLJ9GiyHgjfvWaBpgj+HzgyX5/qwvs0PTc1jE?=
 =?us-ascii?Q?EROLrgONTH+6Jl58px40xY0r5cwNPNXzkVUpOivxbEC6dMrZl9zED5AK+E5W?=
 =?us-ascii?Q?1FtzAc2yWyWk3SdngjqCUi33vihQFmtYknOLMgaCZ24df5ZQ+L10RUCZtY2z?=
 =?us-ascii?Q?dyudIHcpzt9oxx61v74TmCTvVoe9CVVcFx1yALhWvETWUmM5wKeJKnAdRM9r?=
 =?us-ascii?Q?gODUk2vTyIptQiXkb0XE5FuMVsF00AealebdQeZUV1xf+mZrhIhlyPDafAIo?=
 =?us-ascii?Q?zaAzdiJLuDafhQ6cFrZL5hLTm9T0GM35HzM06Dm7wAdSsSp8ZJT16cDzbp3b?=
 =?us-ascii?Q?45gy9eWQxd2G4jith6p17yA41rtLcxrjrOPsUUU39uUFbHmYzndg28u5HOry?=
 =?us-ascii?Q?seJDU/BtC5jLslGnTbiAnjgZSEDUR3JR5XrBJgjn925ShtqoDfnfJVtjlzvK?=
 =?us-ascii?Q?bTT3RTaFLl4qxoK9xkjzjzAOR/vSNeYN8BfUFaD9dYAp2EeFpuxt/tVAlA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 14:14:09.5554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c498c03c-1640-4892-3d72-08ddc860dc6b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6731.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7893

From: Ashish Kalra <ashish.kalra@amd.com>

To enable ciphertext hiding, it must be specified in the SNP_INIT_EX
command as part of SNP initialization.

Modify the sev_platform_init_args structure, which is used as input to
sev_platform_init(), to include a field that, when non-zero,
indicates that ciphertext hiding should be enabled and specifies the
maximum ASID that can be used for an SEV-SNP guest.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 12 +++++++++---
 include/linux/psp-sev.h      | 10 ++++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 58c9e040e9ac..334405461657 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1186,7 +1186,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	return 0;
 }
 
-static int __sev_snp_init_locked(int *error)
+static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 {
 	struct psp_device *psp = psp_master;
 	struct sev_data_snp_init_ex data;
@@ -1247,6 +1247,12 @@ static int __sev_snp_init_locked(int *error)
 		}
 
 		memset(&data, 0, sizeof(data));
+
+		if (max_snp_asid) {
+			data.ciphertext_hiding_en = 1;
+			data.max_snp_asid = max_snp_asid;
+		}
+
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
 		data.list_paddr = __psp_pa(snp_range_list);
@@ -1433,7 +1439,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (sev->sev_plat_status.state == SEV_STATE_INIT)
 		return 0;
 
-	rc = __sev_snp_init_locked(&args->error);
+	rc = __sev_snp_init_locked(&args->error, args->max_snp_asid);
 	if (rc && rc != -ENODEV)
 		return rc;
 
@@ -1516,7 +1522,7 @@ static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
 {
 	int error, rc;
 
-	rc = __sev_snp_init_locked(&error);
+	rc = __sev_snp_init_locked(&error, 0);
 	if (rc) {
 		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
 		return rc;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index d83185b4268b..e0dbcb4b4fd9 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -748,10 +748,13 @@ struct sev_data_snp_guest_request {
 struct sev_data_snp_init_ex {
 	u32 init_rmp:1;
 	u32 list_paddr_en:1;
-	u32 rsvd:30;
+	u32 rapl_dis:1;
+	u32 ciphertext_hiding_en:1;
+	u32 rsvd:28;
 	u32 rsvd1;
 	u64 list_paddr;
-	u8  rsvd2[48];
+	u16 max_snp_asid;
+	u8  rsvd2[46];
 } __packed;
 
 /**
@@ -800,10 +803,13 @@ struct sev_data_snp_shutdown_ex {
  * @probe: True if this is being called as part of CCP module probe, which
  *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
  *  unless psp_init_on_probe module param is set
+ * @max_snp_asid: When non-zero, enable ciphertext hiding and specify the
+ *  maximum ASID that can be used for an SEV-SNP guest.
  */
 struct sev_platform_init_args {
 	int error;
 	bool probe;
+	unsigned int max_snp_asid;
 };
 
 /**
-- 
2.34.1


