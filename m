Return-Path: <kvm+bounces-39182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D48A44E41
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:03:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C1F97A9705
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADCBB211A18;
	Tue, 25 Feb 2025 21:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NywiCT6N"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731B1DF59;
	Tue, 25 Feb 2025 21:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740517289; cv=fail; b=Tkyz+4mh7u/Ny4jHbOJH34ofl+bHDwFRxK7NAsVzD24/B5uloRNKcKztV7ICYgJqVxHBtstTZojsyGtvfQdqjElI4dYZglrn2IZu/va6jHQ61lvA+Y6JR4nQmfvRgZ9GdwqKKwFtpcSP/iaYq0S1/PzUERiZ0hcEm0LyzAOOsPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740517289; c=relaxed/simple;
	bh=S1XzVXX2dqyK3EWteJQ/1PlqYUCNIpHcTdad2QpZIMI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GIXCkBKQzp/kivA9Ueuxvk8RV0gWqAJly7m8TgFUgepuVmjWQ2y4D1rWX1dVUkpXmyb881nR2dffShwYite6bv3OgpuU7Bcf0Ab4oHvmZmV156GdQ7bjUH8AmJA1Z9Ize++b8jgx4Jj4jn3uOD4JnIoCYykMQi82gg/YrG11wN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NywiCT6N; arc=fail smtp.client-ip=40.107.223.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sDmpU/qzbA3lyCzPMcHnIOJo86lsRadVJiBrHXhxwx3kj9pbxmo4WusSzhJnih614z1aRpFZo3dqjqsfJD9sjpH4wpEmxvTh5+ONlqAUqBS9tZzHC2SLyPAHyeh/IjP4HWSB2/m6QfUPhAxHweHtqiz+EV9aHIUDn3CN+1tN8zA3/k5BVLEVLlEsqueehg/JTvOr35J6cSFnauEfXh4Oct00jeTlSU59EGYKvss6/52EnFN3g/m80yuXy1YKWEwSW/HDMUMMyTPbBzXMefliQKb412oIqr36hnPHCG5MXQyAkaogA3XCtORA5KNXWAEtKAwQ7M6tilTK+ozxNQlHIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+HUXffrGYivphFa/2BetKkVJO6oB/g6b3QXpQOCR8c=;
 b=QA+q+LhZIU4EEkRG5r8OIrzjx6ppjIHrDtce6pBRWApkzQl+zftgHlpoqbzZTw/fGfa0pLtStjl3lY5NbG3BZVuY2SZnp2kVKlhd2zBY5Kqy6INVdhfjuJrbPQCoEDP9Fp5lW93jP/I+kOu/Zmq6815CqqW25dxpaRu8D0XSvpBgTCiDsGy+FNl3jNGX5xRz95zhm1S5du5D54d6dZxOwQlddc2cBa2LhT0oymDMsY06WhbjXDOaSvQxDT1kVNDUguerWnzI12RmemsZVM+603t65r9ZyfKzcyI/zRcwdfCiyjWic3PCBSByaH1Zbte+ZMYm/3PTcKb2lP7dbkdEmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+HUXffrGYivphFa/2BetKkVJO6oB/g6b3QXpQOCR8c=;
 b=NywiCT6NJnxj25Gt8NFgDjLWasPRGIEva/05s9Vypssa0C7+UL3F6kcXn78LW/xFqC/AMHwA5CpY79sLYXYBqNC+UsoCh8QtO995CjNRAo18+/yIiJ0WSkPg3v/Z52Flp+wK4WfgOGntGIZUbVVrjLbxSyo4nravoXb6GXwhHXg=
Received: from BLAPR03CA0105.namprd03.prod.outlook.com (2603:10b6:208:32a::20)
 by DS0PR12MB9423.namprd12.prod.outlook.com (2603:10b6:8:192::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 21:01:23 +0000
Received: from BN1PEPF00006002.namprd05.prod.outlook.com
 (2603:10b6:208:32a:cafe::fc) by BLAPR03CA0105.outlook.office365.com
 (2603:10b6:208:32a::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Tue,
 25 Feb 2025 21:01:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00006002.mail.protection.outlook.com (10.167.243.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 21:01:22 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 25 Feb
 2025 15:01:21 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v5 5/7] crypto: ccp: Add new SEV/SNP platform shutdown API
Date: Tue, 25 Feb 2025 21:01:10 +0000
Message-ID: <3e78c6947fc5b061d67c77c107b594b3657c5b90.1740512583.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1740512583.git.ashish.kalra@amd.com>
References: <cover.1740512583.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00006002:EE_|DS0PR12MB9423:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d908941-1812-44aa-4764-08dd55df8f69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|7416014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V+xo6GOL+hAxoQi2BeRRTVctXg7ypu590czGOtP9hFKJRFLVMrQW6CqrG1rY?=
 =?us-ascii?Q?4+9Q/u5lBK7uU5lj63Rg98NgIERg2I6Q0ypcUGrVwi1HC1LjC+PwVsRpgqAN?=
 =?us-ascii?Q?feLC+01b73KmTOwJf0yvkzC8OmbFvG4Vzhk2t7xwY4e/eNPtG/QnU/VDpFJr?=
 =?us-ascii?Q?JY/F6JtuMsay45mijcWWbxyB9wZyg6OsWSdCBqECiSodAu/MWkVQVTXBp03p?=
 =?us-ascii?Q?GhZ3rJbOv+4O7I8DFrDJF37uA1QjscMjvYUHwUAR7/4oPFT/EsSo4bGDZ0lx?=
 =?us-ascii?Q?7+oW/7yVRt9bwv/INZxgDgYBtGcXcFEBscwQXtiB+J62wQWC4gn1eJiQ6qCb?=
 =?us-ascii?Q?tkY5TW/qXcRd+etj7DVo1Xdij98wKlmtARP0DYgwZ6MtqbK3S6LkwXXWYeTN?=
 =?us-ascii?Q?F07Z/kBECeZyZ0JzXP1Xa/hN7Q0sF6Q3HEzYYH/RbS1vP3XLZZXNVotWTlfH?=
 =?us-ascii?Q?Xc5Uwl/xjHX25fDj2lddO1wBx+y9THeJ5/jn0H7QS8vXkupjKGboNUDqBost?=
 =?us-ascii?Q?isPDp6iQIywKmOo5DC3Hj7SvBaIEWtOer2qKQYf5E4T9eJA1kISIxP69Tqi7?=
 =?us-ascii?Q?UDVy5RZ4h5maK3vEdD9sKxAoxsHe5/6mPwQAYf2MG9z5Wj6G1kikYojbq3Dl?=
 =?us-ascii?Q?RA6bGNR8VILKBGyWLVPSwXxdcJTNuCgFvDyDvcIDA32GFzWXBO2llMlguzYa?=
 =?us-ascii?Q?xVb0HzgbOoyqGphukdv3CR8ulyoktVQie9WV8dRqfu+KjHygS0WSbCEsji4S?=
 =?us-ascii?Q?S9aMBxNDzVb/3clubQW0LR1XRCw2GkSPlTkYdtmGozjsa4EMtbCG8mj1jzLr?=
 =?us-ascii?Q?oiTXQ0f8k+M6n691q+fXH4QGyCA/W7KKwkBk9XYvMfGFKzKXNJV+QwP7mVs5?=
 =?us-ascii?Q?EDVZHQ5O50Af11rXcSY9tmpsNsgh9htruhuSB9+bmd+GQ0eMHIdVdX9dvLTH?=
 =?us-ascii?Q?IynamTRVzXsUswWHsK7q0GadQ317gjQCVRBfr+5K+FxwGRjqxiqjZ7/LuS+/?=
 =?us-ascii?Q?HS3+TKk/nKxNKeGfwhdQ7G2BCa5vf+zStWxTAv9Cip7aRq8cpySQWEAebeO7?=
 =?us-ascii?Q?xapvreuXLv3sMVnLQaC2DwITnf+s+0GWBsVo40TjzCTQGqOEQuBDlt3amMp8?=
 =?us-ascii?Q?KPizWHAOLjNrjxmBpQhigP4KtbpS8LQbjc5eoQ69eNXQpTgIiFD/cCTG6BPp?=
 =?us-ascii?Q?hPQMvDIyC9eB93H+7cJLDVItrM1iAZ8lWqOKkSmCLCuIYHjG7TwutEPUB7jl?=
 =?us-ascii?Q?gYi6sMWjIvFIwl2BRicvLxYdjw5hyUgOcWG13k+gYyC6l2UZPShpfraEafd3?=
 =?us-ascii?Q?5COBxEOojIleDDXaWO1rWgjm4mR5UOvoEgP2z4L82j6URT6+fCkbtbLqGvg0?=
 =?us-ascii?Q?IvUKx9Zn89oWYV4TsCQniHQ4v1XYDll+Qx48LqhHbNfc7yZjCmHnhaFU4fJr?=
 =?us-ascii?Q?tUF/COzRdk2C9vbulSsqPhV4P6hxZ/LImSDlslPWiOgLe7K/PBtb+dYIj+NM?=
 =?us-ascii?Q?vEbop6EbwnAAaDLpvX0JAhCPbtBAwdWfLGfr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(7416014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 21:01:22.8119
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d908941-1812-44aa-4764-08dd55df8f69
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006002.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9423

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
index b3479a2896d0..cde6ebab589d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2460,6 +2460,15 @@ static void sev_firmware_shutdown(struct sev_device *sev)
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


