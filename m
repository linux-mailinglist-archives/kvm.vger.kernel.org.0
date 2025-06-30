Return-Path: <kvm+bounces-51089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0866BAEDA2E
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 12:44:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41BCB176CB4
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 10:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E979D258CCB;
	Mon, 30 Jun 2025 10:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2z4AFUXY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD31D239E98
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 10:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751280292; cv=fail; b=P/3jth2sWjv1+iO0dJxBt2SCNKwP7CdSOj8tJ8wxL/L2lq6oAPXpr2AlbwsmolHIXPwk0lCZuzcuLpksi1riEQL1ulDvEv0ciTN3hBgn3OU1lSSWNuJ6n9ZPHmuh79wqp06BXkNCCIOw+Ri2pO9puBYErYPjWxyh0JgicZpjLTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751280292; c=relaxed/simple;
	bh=uSfpcQ9LkM6EQ0wnqY/9k5yEG0H/MaLR+rUh6+oTRQ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MMyZMM6HMXNVXtmdHhGtzTE7BsvNXF7Ur1a5sN5wLybTIt13FAxViGNbWdLGo7vST8+TZYAIk3wYHDXfkG8gkN0946fKUGvTulNh4h8HR6v7AeBI9fNExTj45Hh93GP5Y/tzrU4dMLp1A0wT5SukVWNCo1s5Yz1Xvn8R7GZjZ1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2z4AFUXY; arc=fail smtp.client-ip=40.107.92.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hDziibSHQH2Q5CKYveqCmJH+QbD6n1kO6C/CzdVA5x8+BsHUyeSPEX+zhIHW0+qAfe1aQPTItUDzg3KI8r7AQH4DJ4tZd+0uKx7DBi3mW7SKKxmxbcHuR7vnJu63ECUINFmuabVJ8bF9Y/WRO+hfXX2rHO+t1l5GOhhFhP8KIHjQSpz7Bn8WrL/1jN+7H5HqchHl+HtFTDt1NBHO11Q+qmBrF0AoRFyUL6+1E/O71NQY2e8CHwnHYhY5Z0x5d7A26/XGiiT3s6lLByu0AkXxLBUMCQd55ZVL8Wbcwm+DtQ+AuKHJuZoH8pxdXzYsNC7DlJtiYAuax8O58pkWu+Lw2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=baQ0HcVD2kUs/DSxUNDGgZqs0sXLgJHVUZ9CnZiZc8w=;
 b=YX7++YJ07IGKSXHWd7zhIgWxdCtfQXRsci5LzQmNcGewwdtQFKbM36snd7mSNrJVdfGHwdYc1qYbq6vnusQRlzG+e4I8WSqXPeg09iHq/QiLwwBnnRvn0QhA3e5egcz5g9VWwZM1fiYohK59AmwjI2zJVKHiUxCR0H22KWUxbCNlWzv8MMY8rXJxDZAaKpt93l2juBz19dYb/0z4gozxBUvdVOb7XKbWMsIH/3b09ucpeMOgqxD+NJBxweOh94ihPZ9+H82EMFvC0vLInDgEYw5Ju2IhF+YrKHZlH9wBMjQ+JnX15aOk2jMe+Rp2zAUOOwJFbikWnXoVW4Tqtw3jxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=baQ0HcVD2kUs/DSxUNDGgZqs0sXLgJHVUZ9CnZiZc8w=;
 b=2z4AFUXYaG981rQ+YMN5BIvgHlBVvaHXO9g30xAD0uYyRixcLDjfPcQUWkRFEV52VxjoKKmHzBhHwunu5Yb1peBcHAJIvPMVNX/7dVZ+/b0YSleXfA+Vnba4Zs8i+8k/iA52gueZROqZrED/02Nk5+xvh6vJpnj2vS7EMA4U4q0=
Received: from CH0PR03CA0088.namprd03.prod.outlook.com (2603:10b6:610:cc::33)
 by IA1PR12MB9532.namprd12.prod.outlook.com (2603:10b6:208:595::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.23; Mon, 30 Jun
 2025 10:44:46 +0000
Received: from CH1PEPF0000AD80.namprd04.prod.outlook.com
 (2603:10b6:610:cc:cafe::63) by CH0PR03CA0088.outlook.office365.com
 (2603:10b6:610:cc::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.31 via Frontend Transport; Mon,
 30 Jun 2025 10:44:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD80.mail.protection.outlook.com (10.167.244.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Mon, 30 Jun 2025 10:44:46 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 30 Jun
 2025 05:44:43 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>
Subject: [PATCH v7 1/2] x86/cpufeatures: Add SNP Secure TSC
Date: Mon, 30 Jun 2025 16:14:25 +0530
Message-ID: <20250630104426.13812-2-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250630104426.13812-1-nikunj@amd.com>
References: <20250630104426.13812-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD80:EE_|IA1PR12MB9532:EE_
X-MS-Office365-Filtering-Correlation-Id: 221cc6a1-440e-4cfc-a7d7-08ddb7c32178
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M8HfEhXHgZw9VSq0W/Pcvu9nPKrYv4hLY/REAnGCeRuiZpp0xSaDWx90Vp4D?=
 =?us-ascii?Q?/JwVCtsES8Ik32H9Hwy/qEZ9PRgDKa8ggxEm9qEI+AqsF0pIZ9yiU6dMe564?=
 =?us-ascii?Q?8UVhp0TkKgNGZq/Dhan59aQinrTnuspn9U85ZiCgBK5xbtNuuItqwQ5yDtlg?=
 =?us-ascii?Q?2BpFXQv62BNdr9ZQftYFhYI1X6WzX38Mgbkb8MzxRxo+VrFq3s4c/UulJsnw?=
 =?us-ascii?Q?Ipafx4CcYtLHaS6fi/HQfrDqDtidVxYd9lE4nG736niW36RFTmuRxZV7DWQE?=
 =?us-ascii?Q?XeezYdQQVTyxB5JLompPc+y1smnW64ttkq+Fe6Pu9k4cs5dlSv74x+4TTDax?=
 =?us-ascii?Q?x129nKT/KcLv5w3Fm+sQfq+vRbm+fdzjTmaLJ4aMSKERl5wouq4/8oTAD2x8?=
 =?us-ascii?Q?AYbzldVeD967OuBrO4oTgbxvI4dqhb1RjFuceWwB4KHcu+M4ibFMtcVbh+nW?=
 =?us-ascii?Q?EYWg5YIvJnkr5WvseZA9RNHuYeIGnr7Qfyf/EN9rs3x06RNxIw0yZEZuR+OA?=
 =?us-ascii?Q?oVinAY8quzjoPSrT0cxfw3JAaLBy20DxbBq2AUEZK3YYZSK/rxOQSitIYY1o?=
 =?us-ascii?Q?wN89lpA/x9gY5rPqA34cfYXUldPtuVVsLWUPzoquGUjYGRhHFrSO9O2+4/Tz?=
 =?us-ascii?Q?81P2u9chiZquK/j8gwk4bWMcT4PHLVXLxz0xAi9tSiWPmwqV7nMjpONGol3X?=
 =?us-ascii?Q?a7XIe5gj5DuDggMeT7TknGZ15AFMpWa86bU4N/fgcNprfNQLfHTjL9zxJ+FT?=
 =?us-ascii?Q?/sycQGNMawaiuCze9Ydi7b31MHfvk2F7xSorJDLPk7YM9v27XeSqkVtHhVKd?=
 =?us-ascii?Q?GUn4wtrDfJYMpi6qSMdKoaoJh/xnfyadJCB/rK59zntpcsp0ZgZWnX7ErTnE?=
 =?us-ascii?Q?ZdQT2ZNacPJW5hUGHv7OQ8LGf5GV/MRl9Z06YA9ZIONTRUELSStx59eakXOB?=
 =?us-ascii?Q?/LxuNfCdow1BN9sbQTfaPx+5vHvD+7whc3Ps2XtvgFNcSe/1H4g4SDbGe595?=
 =?us-ascii?Q?5zROn9VioovS65ULBiC8BoKNhwoFW/KMoVMD4Yc8Tt4mRHgy+QtUr6SbE0WS?=
 =?us-ascii?Q?TOcmNZN1WfYGlcVRs8IaSihM+HmOdzppbter4h2xrcqZSNv3g/aziLvrEX7r?=
 =?us-ascii?Q?Pq5JpViDMUGsWpQEU1we0k4WKvbt2F8ZagxvXy9nroZVl08q9ZeRrxIyh/TR?=
 =?us-ascii?Q?j6wXs6Y9cuil3AGN1PoyYFPJP2Ea2lOzWKgoeum9pLeMcyjvlrc/a0nZyEg1?=
 =?us-ascii?Q?ubidmF+WRD16HGV/WRFxFo9XGGg4iMICTNsVgjOG0AtGwlQ54c1O6WQT5zTq?=
 =?us-ascii?Q?r2h6J+ClF3dy/AR9owQ6a49lAWvfcrX2xOzJujOU2SGtGmkuaaHlH5/78z3M?=
 =?us-ascii?Q?nUeO+9jlfyq9Rysy/DNfK3Nyt13On5cBG/zHk1ghUPFyphzQ6OC/7KZdHhKK?=
 =?us-ascii?Q?ihFcQTLRFiQWGuKPTh91eORRp14mpURCxDJguW60Pzk9AfXtav0CVVpWKt4p?=
 =?us-ascii?Q?LH5Z/QtUeHF0PwXVfQohuoSmfrhneVWSAzQ/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 10:44:46.3983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 221cc6a1-440e-4cfc-a7d7-08ddb7c32178
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD80.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9532

The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
and RDTSCP instructions, ensuring that the parameters used cannot be
altered by the hypervisor once the guest is launched. For more details,
refer to the AMD64 APM Vol 2, Section "Secure TSC".

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Vaishali Thakkar <vaishali.thakkar@suse.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index ee176236c2be..e5001c3f7cd4 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -443,6 +443,7 @@
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* "sev_es" Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" Secure Encrypted Virtualization - Secure Nested Paging */
+#define X86_FEATURE_SNP_SECURE_TSC	(19*32+ 8) /* SEV-SNP Secure TSC */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
-- 
2.43.0


