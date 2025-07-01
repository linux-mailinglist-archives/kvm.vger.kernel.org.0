Return-Path: <kvm+bounces-51216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95CD1AF0470
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 22:15:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58CF34485FB
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 20:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D397D28507A;
	Tue,  1 Jul 2025 20:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="leEbNGyQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2072.outbound.protection.outlook.com [40.107.101.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B76283FD7;
	Tue,  1 Jul 2025 20:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751400903; cv=fail; b=dTv35v6rWENRKq7N5IZfRCJBd9a99MZdEudJmFNCRTuJGeM2dXTIM2lffbqU9shk4S7PyD50p42y6bsRwIpuObuLP9GuVxWUmddnvDRuTC6ZfdQPLCyACWLunycv9b20qGbGZA7aXWiXB9BgVppIzrXBvvlq3uzkw3F8j/o4Qhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751400903; c=relaxed/simple;
	bh=SB1wYF+yx0cHIZHraE2D44TLNggMmV9xD/BmgNIDs1s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rDtiH+QIpaHLxfgAj+dCwX4jkyt3vrVH3ykMZlXIgT+wgKrf/5FfyLqSdPFUG5rj6ivRNCz6gXEYVW8pIuQe1/fcJELhHOJpyPD08npne2kn6RpF6qIN85HjRVuP08fDMRq1xKkgHt4pj/w9OeY5K8KDExlT7tRz48DS0wFlkfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=leEbNGyQ; arc=fail smtp.client-ip=40.107.101.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h4yVC5z0PYnA6vJG9gbENkbkOwXQNNQcDM9pIGwDyLrR/Au9blj6WFfI+0rOZYXyDW0JN5COsUt8rpoki4kcHDsRxakAsIQClajrls0U6kLS7s2cDito1i6OG/qS92OH1FBDFZQY870qHpF/fT2hf3fhQbcyCF+jXjOBz5qj38cD0BzRs7zeC9V0uA3Vg+FPUv4/AV4rsPfAr3WyVlZ+n6b/cz2EyfwCUyaEriGQGC0MXGDyCVREBimTt7quQNqZS+yIUU6njPMYa9qLXZhiIhkWUbv7lLmpXUrEN0dOnxX2HirZWQy9P6KqtKWkCsC3qOXdm1ImqB3psOOojs10XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xkKLJnlF/78OEYVfLA8TArPEL2ti8EssOb2Dwys1WIY=;
 b=NFt+/p64MiUHQa+SP5aqrc0tTmkvmxW4iQzz7yxutpadmYyfkfBMpnJrmNWBCqVTfG+0PeuKxUMDaVNasSbKLjM9wjkML+Vl7G5YucUA6BY4g4naJp7VnZpHQ9rvbcMg2a92HCyevGzhKl9UAxPR+rQrWSO9Dl67c3aGHl2g1R4DfNM0+2DcZ0yg3R4e1k+2ydzhnkz5Hqdjaw01G6Fnoi19Mopc3xIHElhrTXquijmvnHAdBpEpdUOaqDYKBvApDMkOfIH4Wy+6KQi3on1U3flPgUI6lOPf2ntOWFCu3uZmzFa+eW9e4kwj+MFEaFj7V6GYEc5eMC/dYg8pNTEvbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xkKLJnlF/78OEYVfLA8TArPEL2ti8EssOb2Dwys1WIY=;
 b=leEbNGyQjDj0DIxZ58okuHcR3hNf3FD08JJMNeh+a5jEb/IkAN/9r4mz8RrLQJQzLZwDhJ16ByA+xLLDf362/aGOMg4VPn3zg8pG8HVY71z/shw538lH2LWIY491VqqhvF2ldTIDkz7L6zAiAxyCvtF0RcyWq7Aynb+4Ajhrxss=
Received: from BYAPR04CA0007.namprd04.prod.outlook.com (2603:10b6:a03:40::20)
 by DS7PR12MB5742.namprd12.prod.outlook.com (2603:10b6:8:71::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.30; Tue, 1 Jul
 2025 20:14:59 +0000
Received: from BY1PEPF0001AE1D.namprd04.prod.outlook.com
 (2603:10b6:a03:40:cafe::6) by BYAPR04CA0007.outlook.office365.com
 (2603:10b6:a03:40::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.20 via Frontend Transport; Tue,
 1 Jul 2025 20:14:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BY1PEPF0001AE1D.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Tue, 1 Jul 2025 20:14:58 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Jul
 2025 15:14:56 -0500
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
Subject: [PATCH v5 1/7] crypto: ccp - New bit-field definitions for SNP_PLATFORM_STATUS command
Date: Tue, 1 Jul 2025 20:14:46 +0000
Message-ID: <5ad6bebf6c530d214aeb9b3987cae6e31ad15579.1751397223.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1751397223.git.ashish.kalra@amd.com>
References: <cover.1751397223.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE1D:EE_|DS7PR12MB5742:EE_
X-MS-Office365-Filtering-Correlation-Id: 13fafa61-d558-4758-545e-08ddb8dbf3ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pYKS+ry/FdFU1Dan0zrZpPT9kyrNOxxItvinUUr+UlIZeqkq7L0qV5kvl251?=
 =?us-ascii?Q?NN1VAD5Z4a3JRMm5dwykJe5WAOxWNhZu5Vb5ROXwepmOdXy90HRpUpnYX/9F?=
 =?us-ascii?Q?uHKs7KktcayST18293rfgKqw5VS341UYVM0slDXnrfa5qK6bMSbw8IpLoT0n?=
 =?us-ascii?Q?BHgQ4aMmTSycoEqomP7vm2GMdvbGJRNFwzQMOmclYumySN4/9bE1WTh9p5Nr?=
 =?us-ascii?Q?7vUyz9YB32UD7schaWHWB5gKdin/B3fE9gRJEme0HoLI/H8SP5CBiXi1wD1O?=
 =?us-ascii?Q?W5FhqtsCLy/nfCD6ekj65N1jdZnSg8gHH/+LW70eWwvo58dFvzmCErH/MZAy?=
 =?us-ascii?Q?Dn+vpY4NGD32pOEM0Jgu0+0RC7Iwbz+pTpbVSUsbh6X6tIadCukwF4IItVAR?=
 =?us-ascii?Q?qzl5oXXvXIoQB8rwSXxDv6spiwdapdCmqD4xM1fTl+FfG9JwH5v/EeeInMhr?=
 =?us-ascii?Q?VbvbcrX9rOxcW2RIUUjdYHWpj4Qn5PUoCqT2IOfdcuqx9mer4MO0uvGIEzDJ?=
 =?us-ascii?Q?O5UlozAgqu154eB+Qd4mkMUARxCnZXJ3IiZGSLchGtL3oeBz4XJeisAZXfbx?=
 =?us-ascii?Q?P+HmUkRwGGp5cUILQg1SQ6QnLmNoDn7jLFMb2Sp3JXVhKf/0hE5QUG+JJJdB?=
 =?us-ascii?Q?MKVHVGO4S79SOxVa1RNPNQG+gpWK2MahC0n0C4U42nmbJJcRhGNrZWkoArPN?=
 =?us-ascii?Q?z3IGdui7qebcZKt4RaGGqvfI2479IY6rY32OKTxzY79xt7h0vdPcKvY2kzEZ?=
 =?us-ascii?Q?XBasyuSHl/InOO6I/z4egajMyJmXtB74GdHjXCajzSwUrYbD+8m+DG/MHHXv?=
 =?us-ascii?Q?/p6YFK9fEWi+q5Yc+ReSj7nVJ39xTvueezsARnjJrRlIR+iNQGtTn/rWMOe9?=
 =?us-ascii?Q?Sx0TtvoUhzdeL8itQHIcrqJoWooLh02KrumH7oo0wIeO3QEWyM1B6zs2YUbz?=
 =?us-ascii?Q?8dNlmbA2eIZc9xKIi0XmNfyY6uCr7TJ9kbf7gTuDjf9LqgyTrg6cDfMTisnL?=
 =?us-ascii?Q?6zfwH6JV+aeFpNctgQiL02cTNbLz7xQjLQnP9ex63m9X6wFhetsYEfNGbpxa?=
 =?us-ascii?Q?VlemGMbGwXTfVYZler17bBgQmLGnZTyDAMZNvEYBS+hGsmSAZqwcg82SdZGD?=
 =?us-ascii?Q?CS7Nw5RCSniCuklm40xhUY4m/+oqn2sPUZSoIv1PK5ijKYZvmFWWqaRzmkl+?=
 =?us-ascii?Q?0gSVTuGxiNA7c5gLvsAnZfEvOs7l7RoFG8m49gBZtexMTmjNEoH4fEm2sV6r?=
 =?us-ascii?Q?r2WuZKjSLG3iXbpI7Q27VZ9krCBjY5GdgtoYqPJEmYZZSQ2vjsLoRj/ZKotC?=
 =?us-ascii?Q?qpIXkJhmt+QVD4rVpQv/BGbEqtGIxu0xeU6dzDOLyvipRr5glIj9DaX2iJs8?=
 =?us-ascii?Q?pvtmU7uGNGQrrMpq5ByJTwLPDXN2DSudyKJiD6MhSaqSYBwuDXtmQ44wIhDN?=
 =?us-ascii?Q?4TjYDIasvpWTm/TDW7zD8wSaFS8B9Xx4nJ8gudxoZGh+h6TqpAcnF6K3Paui?=
 =?us-ascii?Q?+c5MdOZkwAyYR/66etLn7ERzDn94z663R+erAL1hXLoOOnrI/Q0/f1WZuA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 20:14:58.4903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13fafa61-d558-4758-545e-08ddb8dbf3ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE1D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5742

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


