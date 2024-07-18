Return-Path: <kvm+bounces-21847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DD9C934D80
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:53:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40F111C21ABD
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9106313C801;
	Thu, 18 Jul 2024 12:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oPFxtJ5O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442B154645
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307185; cv=fail; b=ZuCKo9h7cf46lZnW4ZeNvjXWNkOAr8/HUadB5i9SOoJSRqbkrVZnPrR8iLccAM3bhzchqkLkLXTaK6D3PLQeb4dn4DtDmyjAab96LY1BScenX6H5BeGZkQmdnFRaJtJYs5itPLQOvvY7kvirE0+qv9d8fNyyca5yzpB73iNHRgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307185; c=relaxed/simple;
	bh=ad3VCX+x6IEeGasCbAJ2S/7IVUpL3GPhJiY7fK8WaKM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uZMwSZqrzXd2HfSUnqD+/ObXMy8mvWMA0xQapLQ9Cd7+R94AY/WbTupEV6SyhO++5G3sQ5SGB+9XWIaQbmU2e3q5wj+OHOcDAqt2N3Rjs3IbLaWgAUGRGDMqtXTrFtjkaS6NbOsi/k3KOluD1wu8QL6XalsY8KWmSXnQtT5b4B0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oPFxtJ5O; arc=fail smtp.client-ip=40.107.237.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=skHguEAfqpkhpNhvel2w9dhL90k1gvxYXy4rI3yIFWwW3H1yE7SJ+FlY0NypVgQ6efCeqTIiD8InQdKeYQgC1YTklq+pU95hplTFg2tqBZV05wre7x4yMzd4dGJMmKohXvJdHMRwQH5rNlk70/oaaOmefN7Mck9hrcDat6rDhNjoAcKPa9oeTRMRI+skDAnvbzcvu0iE2nRR5MhGCO/JglvE/ZruPx0q6LluPQhtb5ZdOGPWhPMXakCR0RZCXP6cPSTLCHl6dnGHa90qbfJemO2AEaU+xm5OaMH+I95plrGXuJBBm8Fudd8e/EAmXjslro8brDpKIy83vB75GVPXGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g62FS4+P4qWN99S7nbwdU5rCLhCrkmIziqixYTR503Y=;
 b=NZVyKlTz5UDO0+IkChh5D1qcLoVrtB7n6gTM36uV5iNauzhMM3zRDFq6fvNWnRPBYihuJuoznF/I7uTxceau++vRDHXqpb7DgJ1s3AxLDSNL0LMu4W0eLuuPRz7Oazd+XJFFmNViuV2/vcjz5DYsrz/Oi6NYSF33ixYkwQirQOIa54m6m/6ASjWCfHRJeNiminlrSEfAmMfsEydcI+5VgrV+9c8svmYvRKC2DV7riOchtt7ZGefeu8YsFXoFU5hBj8FC9YiYquoliSwSV8aKGXWpD5EtH6trnkPua7CPlT8I8UZQRjL3EX0zwANclpupv4vGEXStFYHcm+yTy3XU/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g62FS4+P4qWN99S7nbwdU5rCLhCrkmIziqixYTR503Y=;
 b=oPFxtJ5Ou7WssNVnxGEy4m3RWp8DCvrKYaX8AA6uKgCry5vROhRQ017Tc701MVT+MjWYwi690Og9+eefoYMpuK9kuTU/7vmTrBUacD3L/pMwm/E88Gh6sGmseXhTrJrgQY3fVw7oD/I+4sYK+7EdNzU1Xr5m7dWhCc30luycEJc=
Received: from CH0PR13CA0046.namprd13.prod.outlook.com (2603:10b6:610:b2::21)
 by SJ0PR12MB6942.namprd12.prod.outlook.com (2603:10b6:a03:449::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Thu, 18 Jul
 2024 12:52:59 +0000
Received: from CH3PEPF00000018.namprd21.prod.outlook.com
 (2603:10b6:610:b2:cafe::1f) by CH0PR13CA0046.outlook.office365.com
 (2603:10b6:610:b2::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20 via Frontend
 Transport; Thu, 18 Jul 2024 12:52:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000018.mail.protection.outlook.com (10.167.244.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.5 via Frontend Transport; Thu, 18 Jul 2024 12:52:59 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:52:58 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 16/16] x86 AMD SEV-SNP: Inject random cur_page offsets for 2M ranges
Date: Thu, 18 Jul 2024 07:49:32 -0500
Message-ID: <20240718124932.114121-17-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718124932.114121-1-papaluri@amd.com>
References: <20240718124932.114121-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000018:EE_|SJ0PR12MB6942:EE_
X-MS-Office365-Filtering-Correlation-Id: c358a5d4-a957-4502-46b3-08dca7288d7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZbGP127ddEBaAeTPcLYqXJ4TJxoCqHV9nn5k2t71vdn6IzQBzZxwGwF4zQN3?=
 =?us-ascii?Q?Nl71bJAMoYyJoywQ3f+pzVe8D4+PfnXavefg6h2qqqMpR/6LttC8TPlh9LiL?=
 =?us-ascii?Q?/MBdaGeGSs+L9WVu6plK3Lmf7G47Nx3YSBq76b6CyTef1X3Qtk7LMNaZkBv0?=
 =?us-ascii?Q?1yLIArn9PxfAT2i59WkIdb38pjFUxvddFTDK1sJyv22PbuAFbvzHC5l5iN0E?=
 =?us-ascii?Q?00VhoIrwnPtcmNd5SteqaBr88fs+4rLoZ7bQDA3246RGtFz05HrD58Nauxsf?=
 =?us-ascii?Q?h07J2jG1UWswPe9kJnD2oddomCd8Ih8nHHwcnV9uSwK4y8asX7RuD+PQuGoT?=
 =?us-ascii?Q?r6ER/RVpwGUgDbsNR0t6USF0JiWyp97IKINkhKdzV3YqK3sNXT7Lg0YnylcY?=
 =?us-ascii?Q?5iWYVFFw70BzsHY46PST+1peMkpSguDLN/N9yTZN+ronHz1CqeaEgsfyOUU7?=
 =?us-ascii?Q?MlH7lV7eYnmZbwroq7L2gWxne58rdsArgsAajcZ8GFWT0y/S5QqALTnk32tw?=
 =?us-ascii?Q?01kaAiQqLxgdWaAXlXTTzypj93y11Z9fA0KqzVL51CZOHr1407KsZqngQuuN?=
 =?us-ascii?Q?xPfvi1Y2dfxuTYFJImxcv2eXtieHz3oHjZ9PV4MLBTO0CgFDzMsv9drXT5L8?=
 =?us-ascii?Q?O27PSmzMSIWWRt9Ty5hJl7z+7p7jeCHhsjeiM9nYKmc7Uce0eFrhiJD8Hk+w?=
 =?us-ascii?Q?9BdaKeDK2FnTSYraFJ1kzYUdpWe6PK+pNJ28aRHkh0sSqisRIXWhv7xn1qIb?=
 =?us-ascii?Q?tCg/85QYXm0KA6d6601f51RS6B18cmkn9RVNFGtZaFSv513ELUC1HJLc0s9s?=
 =?us-ascii?Q?EYpYtGiCvG/I5Dvd2xHTD+K7RioBM/rkOcdNf1ko7jmvroy2UHmno051JLz/?=
 =?us-ascii?Q?grlyYKIrj6dxIlv3v01l+DIbhfG3bP6jj/BDGMmmKkmn4CudHBJQ+9HTLhe3?=
 =?us-ascii?Q?jhUb+JkUraFFb5o6TOZG7XUBVfR3KfB6Vzs5h3+QmdV83oR/DMmRmOZFOeGl?=
 =?us-ascii?Q?WdO2V5W99o6VxHFDY2WNMui0AbjiWzLSB86gfopawdZojcQcmA6TAQX+tmOL?=
 =?us-ascii?Q?Ocj1Q8oi2hI2hty66lKLTb6DbarmBlleSG/1kqhQFD+pGwfdjvAFBus8MRlD?=
 =?us-ascii?Q?kloQP0MDA0Is9qBz8Kbsk+1ZQJXzmrmwagNYhaZTMrDeqhIMjJN3wZ2o9Z2R?=
 =?us-ascii?Q?m/qvg69p6b+/nmjj+eoh5ubrN83GTYxUUuIZlCLpNt1nL4B8FwY55EKEjR5R?=
 =?us-ascii?Q?JT57XwEiyavDEKzsbLUQ5FSOLjLvWNcnuQPt3zH3pMhVM0L3quKg8dAwLgHj?=
 =?us-ascii?Q?R5PU7OMS0FRPennwxK/N32mtLSMQglOA0eDrC98StDBA8OU7r4Yh9GxlUeS8?=
 =?us-ascii?Q?jIOR3GKGu1BNTIybL8L8q5KRsAld8MDX8cjh+m+3deoTxauKa1Zn733eszPb?=
 =?us-ascii?Q?GKoFtktUllYzfFSMTxTeIHNiZn+2N+Sg?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:52:59.3117
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c358a5d4-a957-4502-46b3-08dca7288d7a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000018.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6942

While issuing a page state change request using VMGEXIT for 2M large
ranges, a normal SEV-SNP guest usually sets cur_page offset as zero and
it is then the responsibility of the hypervisor to ensure all the 512 4K
pages within 2M range are successfully processed or not.

Introduce a test case where a malicious guest sets random cur_page
offsets to demonstrate how hypervisor handles such partial page state
change requests beginning at a random cur_page offset.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 x86/amd_sev.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index bd369e5cada7..c83862ea26f7 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -431,6 +431,63 @@ static void test_sev_snp_psmash(void)
 		       ghcb, true);
 }
 
+static void __test_sev_snp_page_offset(int cur_page_offset)
+{
+	struct ghcb *ghcb = (struct ghcb *)(rdmsr(SEV_ES_GHCB_MSR_INDEX));
+	struct snp_psc_desc desc = {0};
+	unsigned long vaddr, vaddr_start;
+	int ret, iter;
+
+	/* Allocate a 2M large page */
+	vaddr = (unsigned long)vmalloc_pages((SEV_ALLOC_PAGE_COUNT) / 2,
+					     SEV_ALLOC_ORDER - 1,
+					     RMP_PG_SIZE_2M);
+	/*
+	 * Create a PSC private->shared request where a non-zero
+	 * cur_page offset is set to examine how hypervisor handles such
+	 * requests.
+	 */
+	add_psc_entry(&desc, 0, SNP_PAGE_STATE_SHARED, vaddr, true,
+		      cur_page_offset);
+
+	ret = vmgexit_psc(&desc, ghcb);
+	assert_msg(!ret, "VMGEXIT failed with ret value: %d", ret);
+
+	/*
+	 * Conduct a re-validation test to examine if the pages within 1
+	 * to cur_page offset are still in their expected private state.
+	 */
+	vaddr_start = vaddr;
+	for (iter = 0; iter < cur_page_offset; iter++) {
+		ret = is_validated_private_page(vaddr_start, RMP_PG_SIZE_4K);
+		assert_msg(ret, "Page not in expected private state");
+		vaddr_start += PAGE_SIZE;
+	}
+
+	pvalidate_pages(&desc, &vaddr, true);
+
+	/* Free up the used pages */
+	snp_free_pages(SEV_ALLOC_ORDER - 1, (SEV_ALLOC_PAGE_COUNT) / 2,
+		       vaddr, ghcb, true);
+}
+
+static void test_sev_snp_page_offset(void)
+{
+	int iter;
+	/*
+	 * Set a pool of current page offsets such that all
+	 * possible edge-cases are covered in order to examine
+	 * how hypervisor handles PSC requests with non-zero cur_page
+	 * offsets.
+	 */
+	int cur_page_offsets[] = {0, 1, 256, 511, 512};
+
+	report_info("TEST: Injecting non-zero current page offsets");
+
+	for (iter = 0; iter < ARRAY_SIZE(cur_page_offsets); iter++)
+		__test_sev_snp_page_offset(cur_page_offsets[iter]);
+}
+
 int main(void)
 {
 	int rtn;
@@ -453,6 +510,7 @@ int main(void)
 		test_sev_psc_intermix_to_private();
 		test_sev_psc_intermix_to_shared();
 		test_sev_snp_psmash();
+		test_sev_snp_page_offset();
 	}
 
 	return report_summary();
-- 
2.34.1


