Return-Path: <kvm+bounces-52366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB5D3B04ACF
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:39:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF29A4A4B83
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 22:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E5CA256C9E;
	Mon, 14 Jul 2025 22:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vanPR930"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2060.outbound.protection.outlook.com [40.107.236.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE74E54F81;
	Mon, 14 Jul 2025 22:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752532786; cv=fail; b=ZPp4VuM6GwPZ/mkPQIKWDHDt3Z5V3sf8bTSgAJCTHCZE+fvzAcnmdanJFSre2dmd4qynD3u0TLDDSRX+YcNPuQ5VHkKv+sij9lx3Zs08kIubEGgjGLOqI5xthDbY0FsHpnjQ6aoi7R8EFXlhFDwZLSvIipIgkEvt3rtEjGAIZ6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752532786; c=relaxed/simple;
	bh=SB1wYF+yx0cHIZHraE2D44TLNggMmV9xD/BmgNIDs1s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LJSGMIWmo2MfUrVZTuzGlRqugvs+14AayHag5FpmChFmbs837JJ8ALoaghmL0q+w96c3PGfz/k8GAPl0zcOAkISo0ZLnJ8VQhvEnhT+H5JJawK333+H+ynRUEl86vL9p8yc8xDRNg91lebIwRzxD/Z5mUiUL+MY7UN9nfjqSlI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vanPR930; arc=fail smtp.client-ip=40.107.236.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uBU/N6Sn41J1gzrdgHaofdiUMwGNpDBLhwtBKUu2xPk/w72f0QuI561xWYr5+wXlgxoc2eX0CnLBGNbv5KnFlP1q4aSuSG15byldmTdyILgXNqccY5HzzWr1JBVVaWFcg3XbuqYlPMbwFMKH/1CFWpVuxmDf8Kg1R6lei1jU7rKzXo8cGs2ZwXTYHy5CPs4bVQOsWDCGV1jBe6uHil6bJPl9UmqNa/whYR+BCz35V1rWI+lUI2M/bWeE02J6pQX9XLzqcvS0kGIdKd6U8igxDgLKGbZfpuV+3Oo8hPwRIYWHK/Rk9xta7ztSl2YmkEK+dyl8FR0s4iFaUb6qgYoPIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xkKLJnlF/78OEYVfLA8TArPEL2ti8EssOb2Dwys1WIY=;
 b=pqJmK1AprkCskQR7IFE9O+OtX0yBDG5IOFONEt3MD9qrpb76Raer69AizFTaSCVCQHmJ/jiYWO9GWEn1LNQtEohkUhXstP9BpEbOJznCcx4ynTo8Uj1s7kq1SgGMllX0fIxjtJ3gDgTjiKituXk+xG96qt9qXfOoYBrg9RYGUhxqTb07OfrTJANcaSlBpstiOhXuUAmUfnsBR4SPCwM1MsiYk5psEYNqHOHaK3nlTG67jRH99dnz/KfBAG5ICjOlZNC6oNuv54UfM+MuHbSTlfzrp534h630RqrJt7RcX6BP9TVJ+KnqcoO/DjXB1oPVKwTEAB5tFNUNKTJ0iBg3+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xkKLJnlF/78OEYVfLA8TArPEL2ti8EssOb2Dwys1WIY=;
 b=vanPR930j6BTLxQ+mJtXXXimNyrj5HRmRo0bQpsSge1U9vp8CjY9ui8gnZXjGT3ymZYFEheaWbREPxEEHNI9rDKz8DroWxIwPLAXICDoi4PlzKfPzmTfyFMGB29LVHtuTKaVj63g+YUsvS2vTyoixagu0eLQcofOm3mMwkBQy1Y=
Received: from SN7PR04CA0227.namprd04.prod.outlook.com (2603:10b6:806:127::22)
 by CY5PR12MB9053.namprd12.prod.outlook.com (2603:10b6:930:37::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Mon, 14 Jul
 2025 22:39:39 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10b6:806:127:cafe::84) by SN7PR04CA0227.outlook.office365.com
 (2603:10b6:806:127::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.32 via Frontend Transport; Mon,
 14 Jul 2025 22:39:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Mon, 14 Jul 2025 22:39:37 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 14 Jul
 2025 17:39:35 -0500
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
Subject: [PATCH v6 1/7] crypto: ccp - New bit-field definitions for SNP_PLATFORM_STATUS command
Date: Mon, 14 Jul 2025 22:39:25 +0000
Message-ID: <eca9d3a924b6be5a11090c88dc4934ac66a36bb2.1752531191.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752531191.git.ashish.kalra@amd.com>
References: <cover.1752531191.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|CY5PR12MB9053:EE_
X-MS-Office365-Filtering-Correlation-Id: f1777250-b31f-4ad6-f917-08ddc327507e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8iuc6IWDrIqbmVdsOXU2ZYEgMupUMzphSqfdSDnSULJYDoVofNH7gqHKgTUQ?=
 =?us-ascii?Q?cUHXRrTSB8GkQRRhfnqGOEnQA4U/OEsvBxXu5X07zj1KI5gd87F/TM5unAZr?=
 =?us-ascii?Q?e303npCzCI87unHgpy/ZmuZ6C83W0qAvlg/ASjNJ11xwNuYLDnSNvg5N7M/c?=
 =?us-ascii?Q?VLgS4yrxJKiltGcyXTYVFPGPLxB2dbvcgbGyq0dou8F0ikHDWNe10rUdLm7p?=
 =?us-ascii?Q?bX1y3/9eGwc6dkNBQKnxYRmXLpOXdYmQuNbqy7u62fdFsXVVm2s/O1wqnsQL?=
 =?us-ascii?Q?RIs9utl3v2YEcKm9pk71Fn/svW3RPkS+yiriPfJgYHl4kQR5h8V4cN4rnOwd?=
 =?us-ascii?Q?cTJz+qpnn8/5LcoGZ6QpHWSH3E7EbybzIJZopUR/FPDeWaltXoX8TR4HbUMm?=
 =?us-ascii?Q?KnmQRdT03FZdceEkLjtTIz4vXhhxUmqv5jrU4Movq1GDVcvc/NCnf7jiVCKQ?=
 =?us-ascii?Q?c8CDIMc2vlANFPhsQxVgmJ2SORHrRt3FoLLUqD4pMJy9q2uXinwgl6fwlHBf?=
 =?us-ascii?Q?Zp7iX20ODHOSD/8Io5CYHUAwDdvs1hOszSQQXdwtqJwe3+FsUF//ozXlgD+a?=
 =?us-ascii?Q?3YH/fZjSvueODBe+m9t/DPa+Jzee/igbETX3YlV19fE5MvbCb2OOJHMIRzZn?=
 =?us-ascii?Q?7THWiDlTQNuEXa9Zoz6fNNvjtlwcsfUHK5TONcHzLTnuXd4c8OqAoCaYuYb5?=
 =?us-ascii?Q?xbtGIRdS3UxqVfVKVkmynVtV8s6/Mouj9cyouOuANf4xfHnhPrApSYpVMSPb?=
 =?us-ascii?Q?ApAx+WVbBUUuhN60n8wV56SMZ3Q7vixbfMmdc8JoyfijeLbrKokRwb2643tb?=
 =?us-ascii?Q?AqLkUGdpZhJ2P3APp3RHfj9Ok+2OaFElvFHtrkIwfvWocTdz+6HU/1nAAzbU?=
 =?us-ascii?Q?sekVIwfEOc4HWERQTaZWKkUzZud/BK/zQgI7xGkHWnrU5+Rm+NdAkBhKXnDn?=
 =?us-ascii?Q?yKNgNwmQ4Yhzcmsq074SMPArRxJC2vHmVhChnXnyDIrQ9EjBiVSboKKoIj5V?=
 =?us-ascii?Q?PA2lkgyTrTlH6G7KapvKoRg1RYfwEuk209vr4p32LXla3cW1uxxBSGrCOxfY?=
 =?us-ascii?Q?fFdSuJ9n6NJOfULS5qLDv5aXN5BK6q5NKgywsfW8CU60DJbMOAfKRNulO/Cw?=
 =?us-ascii?Q?SiiXGmljJNxIeJU0hAhb6yJjQmJWSiwlyUJIWr/RCtdKnwE3qoBIcrN+4oZn?=
 =?us-ascii?Q?PvyQG2+qpZNjTmHMnZ86o/R0u/L4jg1FStSPTJN2woAnkf2P/m1MVxWYWDoX?=
 =?us-ascii?Q?VJBVR//xRtoYZZIkACf0FZKFUFIOlwSwwMx+zupCTS8rMBeyCUaHhyfpKDFe?=
 =?us-ascii?Q?Wv21Xhoy2VOEyThBFj59NFtZd2linMg6Mktl0Mat9GzthzC+MuNaEPzeUDjO?=
 =?us-ascii?Q?7qUU33FdWxdfABB0Sz94HKy4LoLQjHrxAkFlqGQtvTTx+2L+XXtQA8BKAM/J?=
 =?us-ascii?Q?NF1S+9RcfsYJU6/OZ7OOkzEodcehA9OgThxOKzOPMKlGaGb1PUD1zxdqy/tN?=
 =?us-ascii?Q?G9oeGIHKhKYGKDnj7RR0Nzt1LjJvfpWSAxTZ35N4mzI6LMQsfaBtFVJUEw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 22:39:37.7466
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1777250-b31f-4ad6-f917-08ddc327507e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB9053

From: Ashish Kalra <ashish.kalra@amd.com>

Define new bit-field definitions returned by SNP_PLATFORM_STATUS command
such as new capabilities like SNP_FEATURE_INFO command availability,
ciphertext hiding enabled and capability.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 include/uapi/linux/psp-sev.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index eeb20dfb1fda..c2fd324623c4 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -185,6 +185,10 @@ struct sev_user_data_get_id2 {
  * @mask_chip_id: whether chip id is present in attestation reports or not
  * @mask_chip_key: whether attestation reports are signed or not
  * @vlek_en: VLEK (Version Loaded Endorsement Key) hashstick is loaded
+ * @feature_info: whether SNP_FEATURE_INFO command is available
+ * @rapl_dis: whether RAPL is disabled
+ * @ciphertext_hiding_cap: whether platform has ciphertext hiding capability
+ * @ciphertext_hiding_en: whether ciphertext hiding is enabled
  * @rsvd1: reserved
  * @guest_count: the number of guest currently managed by the firmware
  * @current_tcb_version: current TCB version
@@ -200,7 +204,11 @@ struct sev_user_data_snp_status {
 	__u32 mask_chip_id:1;		/* Out */
 	__u32 mask_chip_key:1;		/* Out */
 	__u32 vlek_en:1;		/* Out */
-	__u32 rsvd1:29;
+	__u32 feature_info:1;		/* Out */
+	__u32 rapl_dis:1;		/* Out */
+	__u32 ciphertext_hiding_cap:1;	/* Out */
+	__u32 ciphertext_hiding_en:1;	/* Out */
+	__u32 rsvd1:25;
 	__u32 guest_count;		/* Out */
 	__u64 current_tcb_version;	/* Out */
 	__u64 reported_tcb_version;	/* Out */
-- 
2.34.1


