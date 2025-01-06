Return-Path: <kvm+bounces-34599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E74AA025FD
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:51:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1833164D70
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFAC21DFD8B;
	Mon,  6 Jan 2025 12:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CrC/IkZ9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAF11DF98E;
	Mon,  6 Jan 2025 12:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167682; cv=fail; b=liR1i94cbleEsLdEMEEKY+ADIbCr8heykgXjTS6aBqbi7JAIyAxZDwhD62pTuSIiBu31V5gms3C4VfayPSc8pAAQwSamcaMl40YLFRESVuhwC2UdCdBQ7iyacog9nHUbNmMqFcJqE3dhS/J0FarJN5F5JMgwcRXI0XO1rV2/HWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167682; c=relaxed/simple;
	bh=J7ITyZv4fTZN+ZfiudI2wlQZ6XlSSdAR/6O3kPxxatE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IYCIBUKjOoXIuoirX9X+bF6M1SHfNCN4jylpsY3SfbUdFZVTjV5OqW8Vy3IE56Ml2U0VvyTXXE2DByjtXMK/uPHjq6KBMRysVhiMijcXub7DkKSXCbLzHsi4zvZkowO5v3ZmUMpI92pJShZCPcqKKxg2aJZUyfDoolZii9z0sD0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CrC/IkZ9; arc=fail smtp.client-ip=40.107.223.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GFoE4+ELcgTz7IopSlV73Jmb1F+PQOPGdo0sgvmV/9JWRTnR80S9tT8SoDvHgoWNA9JecMsAi/nn2wVTMTgu+j23KioeNGi/8W189vXG+kOv4PP8izLZQLTOhmYFqL33bcNa9ru2z/DSUUsC7/ETdTWbQPTTGtMX78Lyx3C7Vak2SJar2IxOdz5dVa1cXkp9oetIvRCJMDbJDzRXsJgy/hl44p/mRYxKb03zx96aorAQj7biJMG9rlO1eovsIpaOuROhB/lscxXp2ZlUwFkppfBG8GtFJ+QW6Glgj5o9Qap1SwqBd4E/o4obFuZeIK0EDLhEk3O8euhiXGlJUxDImA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atjBLt16IpratFsJbg/6ZonMoxx3kjKCKv65wzEaGEI=;
 b=sOv1NFFkCxxj/N2HUdAEkb7qnqGNsMwk4LgiKpTszpPLM0pDmjTSpKbM5Z9YDlhR3Wrq4fBzDqv6CCFj2R7Z1Ls0tHqkRpUmPvYM1KvN72Gi1NRn/IIwOKRv3sSiIXA5Hh12jLO3bhNbi8HaZft6mCPtDR8gtmav1bZ6pTAphwO54uvG1OaoApNx2iliCaXHDtUCjV8jTK/VaVi2ziBCE+ShvHQoFY3pfr4tKXmYbxRXDQVRjoIykWFh1kHRe6aEOdVCiGn6wzF7wVtVgPsR/w2rWNTRn9E/+HTuzjNKMSEiHjTpI0D7R6PA3p69IieBokgtregCYE+llGLMNF+Gdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atjBLt16IpratFsJbg/6ZonMoxx3kjKCKv65wzEaGEI=;
 b=CrC/IkZ9ZHdH4LrAqpAiQ+n/CWNI21jI2ooRzw3it0T/gfEYFo+mUKzf6brmaFj9Fy3qRGVfLrgj6Im6sLoRkMyeUZGBhzPDYlHqiyb8Sd/tdhvj6J513+7who3MuU+sm5QRiT3PECdNaAws4rRPFnCnKCZMma23QNpDuFjMTPY=
Received: from PH8PR07CA0012.namprd07.prod.outlook.com (2603:10b6:510:2cd::6)
 by SN7PR12MB6767.namprd12.prod.outlook.com (2603:10b6:806:269::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Mon, 6 Jan
 2025 12:47:53 +0000
Received: from CY4PEPF0000EDD5.namprd03.prod.outlook.com
 (2603:10b6:510:2cd:cafe::2c) by PH8PR07CA0012.outlook.office365.com
 (2603:10b6:510:2cd::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Mon,
 6 Jan 2025 12:47:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD5.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Mon, 6 Jan 2025 12:47:52 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 6 Jan
 2025 06:47:47 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>
CC: <kvm@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <pgonda@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <nikunj@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v16 13/13] x86/sev: Allow Secure TSC feature for SNP guests
Date: Mon, 6 Jan 2025 18:16:33 +0530
Message-ID: <20250106124633.1418972-14-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250106124633.1418972-1-nikunj@amd.com>
References: <20250106124633.1418972-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD5:EE_|SN7PR12MB6767:EE_
X-MS-Office365-Filtering-Correlation-Id: e638cc60-045a-4c5c-8028-08dd2e5055a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XImYx4pgoEyASgGNg2Cv59P0a9JiN+QANNNKedNisxeP4QWJxmRRdWXcYbGv?=
 =?us-ascii?Q?SJSabK1xAC/xXdX4o7DUtpfITaCNPkyIR1U7DM470o7J1k4QKbQPlXtfucKj?=
 =?us-ascii?Q?uBxUgkonF01HqySrJp/IVaiyZDyizr/5HozlbNsiKA1c5xynXEPEDYzCCJFb?=
 =?us-ascii?Q?LheZujIqRizwYZtUnzBHW1N29QxynL25nsgHqnjIsgY4i+L88jYwa0EQkiRe?=
 =?us-ascii?Q?nOjuayt/1YnktIOP5kgUuI0FYpReGqFcuHSTUtIqLmh2BA+aARICBtUyyXUS?=
 =?us-ascii?Q?aU3QgIZrxwXZ2mvmUDZQdf56SMCDuLOy7zwT/n0Pf58HFs85dlxB6jKk0jXk?=
 =?us-ascii?Q?bXGW3LUBmox0lmIRHDbu15OVkBCMGfPP8V3hSIC3KJX/+U+qFPes5OxCgaZ2?=
 =?us-ascii?Q?cNJdwC6V9BRYM59jvk5qd6BMTqrjdajcC63PMaxMtcjm/b3yEBx0QcYhZf/+?=
 =?us-ascii?Q?9LEBI+wial6DSO1jd8xF641iyRYN0MxpTCo5j+snobbWkwg6dqKfWGpPA3cS?=
 =?us-ascii?Q?A6gXJVxS854E4QfFmDkl/ig2rLCI/Cr+EDu99z2MQm6OS+dKYASm0xgxLFzs?=
 =?us-ascii?Q?5t1naotGdZa9kYZyRWfByoUA2EZi2M6t0WwpFRRPB/j09UN/iUAGkPcRAU65?=
 =?us-ascii?Q?vQ5ZQ8tKv2Ud4foi8JDFKzdztVEM1fBwgCEuGdWbpR+YX1o4eT213G1KOl/l?=
 =?us-ascii?Q?xAXz9ti7DtWukXcd6FVAFL+3wP+WVKfyxwt4rHu07D9AFq3E6qjKrKmhQwdX?=
 =?us-ascii?Q?iWdu1i48VCQFd/R42l+TfR5VYv/2FuofogesJnuUbNP3EqkkuldrB8BJs/jh?=
 =?us-ascii?Q?kYWiacCmua4gMiJj2H2Qnb3EbmaENX/iw5zdlp9Cexg+XT4r4PQT4NMEYm70?=
 =?us-ascii?Q?Ab3WVRGbDEz7191bAGWSBy4OWbX9Ne1xQTEIWccIoejE2xXvvdm9m9mdIh0O?=
 =?us-ascii?Q?c0rz/szYuVMtHoXMXEqSDlWyaPwauSHAAEdHQMGjD/WEdsE5XI+IywE4N4rc?=
 =?us-ascii?Q?KhNqLEPSGdYWe1m2pFWpn/mF1E+1eGnC4H6h94xY5EmHCzOzjKo+0lbPIzOw?=
 =?us-ascii?Q?coGNp7JITT5inIbdo9RszTsQB2JKHV83nyQ0nMSYlF7Anzvd0WeDnzZGE9hh?=
 =?us-ascii?Q?Czoaxllfwzv7e5AFCfpEA71O20rj5zxAb+CtIDR2qdQVUBVykoANL4yIMB7x?=
 =?us-ascii?Q?LPQwgaV6CMJFT0X/POxANElOdTc/e6m2j9p609ax4VBKM0chgCGQMjuBqa/L?=
 =?us-ascii?Q?Tpd7uWoFOzpxosOU0jtCyDDeuqwxMGa9PUn2sPgZWe20sYrtQG0oU5y0y//t?=
 =?us-ascii?Q?cX1sU4R1K4cwRAEpnvT3SEvMNZMv6/6Z747xgl2vLOWXJ0EdFfbSwlbW2xwD?=
 =?us-ascii?Q?L4pwDzw0Ow7NFX06xtfjqx2Dd27hwKj30MLqbXjatWS5RI+TqsUx9V6PFjqr?=
 =?us-ascii?Q?liyrdZTAaeO/zG4x6izd4IledUvrjQTRSJ7FnKt+BmngtYss5DISgJmqfilC?=
 =?us-ascii?Q?QpQ5pzPnOf2MHX0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:47:52.3865
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e638cc60-045a-4c5c-8028-08dd2e5055a4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6767

Now that all the required plumbing is done for enabling SNP Secure TSC
feature, add Secure TSC to SNP features present list.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/boot/compressed/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index cd44e120fe53..bb55934c1cee 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -401,7 +401,8 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
+#define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
+				 MSR_AMD64_SNP_SECURE_TSC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1


