Return-Path: <kvm+bounces-59874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BAC18BD1AB5
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 08:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAE893A3262
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 06:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA512E2DCD;
	Mon, 13 Oct 2025 06:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gqFXs6W0"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012047.outbound.protection.outlook.com [40.93.195.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529BC2D6E58
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 06:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760336770; cv=fail; b=BzpJNQ906DtD+plmxayFMjcInmQKyw2/phFPYNOo9k4rIZEA+vqUk4X+avBoBILcm75XxqcF9mMUJp0czW+K/FTn/r6v19i9hPZypNqiTqZNkSl0XYh9sA98pa9b4HJYXgkuwk/1qqSxKodpqLEUuCJ/doy73FcX0wLT02Q0h7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760336770; c=relaxed/simple;
	bh=1e2xaZqYwBEbac6CGbOxxG2FkaTAeUnFisxab+egjHI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MFCgT7Zur+eixCCd7lskc5QYRXCTbScmDJPz+2mMqdt70BpnqdJTnJux+WxfOLnOfVURVXuCLP+hL6WAUK2X8whl14D1HEDYxjb6/9z/4QdhiAHxqa115G1YURjGncJNwgdXRJCGxiKWe6o1DJInfzvKk3jeC0KjHJMqfBUm3gM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gqFXs6W0; arc=fail smtp.client-ip=40.93.195.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=moBCaEoiKDRoiiNQUhMvGC91ynB7torGWdH5GaCk5LNfH/Tn8Fr1PefAqd5e61XD7OVKNHGj7P9U5KVs2T0dx4dhz+s6nZXy5YIXT7GEoj8AZnTlYzu2c0R24RIjUgvXCicxCn0FVwWg6Mf1urX3XI3PLBd0meui3aT9hO38NTNxswZg/Jad7p8wdmeGdPFrVfOCcOSRB7OrYKBFoWChGTM2iPRz6eDMkxjt8wllstJ2Lx4Pi8gwWK9dSoFPUEeE0/vRrEiPV3Nursb6CEdgRItokBJr0hCI6OZXpwKsa/vgI6jUu6XsOGcsf8TgHfTC7wv8VOezClRm4TJDGF7/fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TedXCrMNMNRlYJO9wd/ZtnoWixw6TWRCHKuCcNQRzeg=;
 b=WkN9JAr+twci6fHYaqNUxKSTzOKtnUqyGQ+wLWJGCpBUrRIpFtUJfQjKig5uW2fArb1YYlmNAa808SC5dEQ13Skt4IAHSNp5VfnKPVZnuIX8VzNHdfncRYY+DsHpNnN9SXZ7BfKcphD9juz1GVrWOlrrH1zjZdXX2mh3Vs3bSFzNmbDExKvfZeDhYurIGlKjzTwq4F3Tt0+20VSCYAaHbLFtAM8qf5uH3rBTaC2VG75Wfdiz+gYvyRd/jpJXWf8+lkAS0DqUXMdyNy0TdHAaDxSQkktY6nxWrEu33S9MPpHmvN1WAH5xHd+gh9vUiy6v3oKRVs4asE4xrhIRV3Uvqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TedXCrMNMNRlYJO9wd/ZtnoWixw6TWRCHKuCcNQRzeg=;
 b=gqFXs6W0Jl0wNDO9+2Nm7nOaCXzFWGsi/5BuszY3MUhYpYUJF/kpIsTibgnQ8ydiquHjbmTVdaWzzQfDR2UfpfFBjE+tfTQxERl5wDNGtgpNR5f9caBpNBPSVPqbUkHEtlRjL8GDCZ+M0l18DfXFZH3PbHYxbjSJsoSPj+vrk/k=
Received: from CH2PR08CA0018.namprd08.prod.outlook.com (2603:10b6:610:5a::28)
 by IA1PR12MB7613.namprd12.prod.outlook.com (2603:10b6:208:42a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 06:26:05 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:610:5a:cafe::11) by CH2PR08CA0018.outlook.office365.com
 (2603:10b6:610:5a::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.12 via Frontend Transport; Mon,
 13 Oct 2025 06:26:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Mon, 13 Oct 2025 06:26:04 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 12 Oct
 2025 23:25:59 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v4 6/7] KVM: SVM: Use BIT_ULL for 64-bit nested_ctl bit definitions
Date: Mon, 13 Oct 2025 06:25:14 +0000
Message-ID: <20251013062515.3712430-7-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251013062515.3712430-1-nikunj@amd.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|IA1PR12MB7613:EE_
X-MS-Office365-Filtering-Correlation-Id: f5ee9e01-71dc-41a5-b117-08de0a216353
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SmwvPAOlE4xcUSGyDJY2Ggd/z8vyDpkYlkRU+OO/xOFlj2NxyfdO174+Kk/v?=
 =?us-ascii?Q?rrqXK5rIFW0ajHUeAZ+LVnc/TFe2OsKsgAxhqmmUDnYX/yMRkB0aDbYC/d2l?=
 =?us-ascii?Q?4OQrgThCOxDSv+ZFWijULWQ2LeqhnXjAqrQUsqFeo03NnnLgh+kCwVqnbP+S?=
 =?us-ascii?Q?tp8KYeAx32GDWT6V+aWvIgbYgoMNgYCeUA1AA08R3SYCgzwVqn7BVcQJYK/B?=
 =?us-ascii?Q?hQDQud9Sy1cRKVgXGFjlAoztrjF3MHNn9u+VFhkYA4HLCVv5wj+LdqPEzunv?=
 =?us-ascii?Q?sknoaBPUZW31CdrChao/+S3EDLftaLwTZQPAOeHqi/pfVcc1N1X3hj3RddnW?=
 =?us-ascii?Q?xG+YwDfn0WxVLR0ijKHk59UNXbaJeuMAI/tE/caCJssbQjxoTdmltA2uNOpJ?=
 =?us-ascii?Q?VrrD32LNvr0hpCkzYhPDh5OhtsNhwjAjsmvv5gsMw1AigoBVYr+CKmL0B0D2?=
 =?us-ascii?Q?/UCbONbh4RfQNeIHQE5UHwXQl3IHVdjrM+m/Y6SUFAZO3vyJ2hunMP1Ze2BL?=
 =?us-ascii?Q?jsrP0Zqp3iDJAUGzybEGS0kCljIYGWDT3GiNY4IJSMRhpFVtxDOBnhj7UTK9?=
 =?us-ascii?Q?ukXNilaqHcLFj0Tbhi2g2aZajp/hJzsmG87ClTFChhiSja0Alj2t+jYiTAK1?=
 =?us-ascii?Q?f4Cm+neKvrkWy5YsF+P9cl9NTJQ8kYijk6JJT7CkS3a/ZsackWxn3QkH5Sc4?=
 =?us-ascii?Q?xxMkkoedSCV4kT5xmzRGTV8WQTRPOY1Hb367B0XDZe1FiNQONjO6S4d4v+dC?=
 =?us-ascii?Q?JtRhgr4GTjlvYR11RcDtSXPYcvoYus4uaw0XMESbNRQ2S+PIb62LASCKW8+R?=
 =?us-ascii?Q?/LdXvAuDfny3KjQQ60UYWWkuiRTEpvPbg9AVaqZWR+y/Gu4yzFU+rk2peT9Z?=
 =?us-ascii?Q?YaUuIkm4Xu2y+vu61edjL+IgaxM18mU9+MB8hqyn9RxPsErtNU6MAk28TEiB?=
 =?us-ascii?Q?30z6PjQRk0XVaOJTOV2T1FkHap6WMuLDbuSz+rAnFvmE68sd0lWMGcZ/WjIM?=
 =?us-ascii?Q?gaFVy6BSzheUM9ZwCwPtgWSYHvHxUUrW/V6+cKEMYN/bEUHJzPcA170y2Ntc?=
 =?us-ascii?Q?ydYYub4hbn5fPOQtNWoC8qSbehA60CQ9yK5SFl2a3X+92gXo+df+58Kp7SbE?=
 =?us-ascii?Q?yz3jBQhSaws3GNLnGotTRtbxk+kTW0PdkD/0RwOhoSGE5Dn2eFGQqyFuyuD0?=
 =?us-ascii?Q?U2R5FkRvms3ESzHnZq7gS6fF8H0cn/td7tubvCLoyX3scQIjPaO92G2lFWIz?=
 =?us-ascii?Q?HGDnBz2IYJJIHKG9Ti+yAKxNqNZNdrJc1xvbfGnlcRgAmptfgfIj0ScaIY81?=
 =?us-ascii?Q?2K/cMAsFsFTLohn7aFMz6Kg7frlVG4jzLj2D6jPF6vvZxlAkuqIocWL+unF0?=
 =?us-ascii?Q?heYseKf9hEO2NOMm19nHWdgcY/jvtw3Dd2QkksbwhjSjZtIsccXDY+AbDJ/1?=
 =?us-ascii?Q?WALtlW47rFP1w5iEofsq9r+CV/AxcQ1EiTvM1Ym05dQWEs4Yg8dDaknXEjUq?=
 =?us-ascii?Q?xuWx2x/hwswZcqBw9RSI9bxg1TUnkOL5AC8m3U+CCt2izq5p4EcVjCh3wQQA?=
 =?us-ascii?Q?ZuNmPtg4i+XlvbXOkVQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 06:26:04.9011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5ee9e01-71dc-41a5-b117-08de0a216353
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7613

Replace BIT() with BIT_ULL() for SVM nested control bit definitions
since nested_ctl is a 64-bit field in the VMCB control area structure.

No functional change intended.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 17f6c3fedeee..d2f1a495691c 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -236,9 +236,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
 #define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)
 
-#define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
-#define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
-#define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
+#define SVM_NESTED_CTL_NP_ENABLE	BIT_ULL(0)
+#define SVM_NESTED_CTL_SEV_ENABLE	BIT_ULL(1)
+#define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT_ULL(2)
 
 
 #define SVM_TSC_RATIO_RSVD	0xffffff0000000000ULL
-- 
2.48.1


