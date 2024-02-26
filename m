Return-Path: <kvm+bounces-10003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1A0868330
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 22:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5190F1C2532D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 21:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48AED1339BB;
	Mon, 26 Feb 2024 21:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ft8cRW1U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150E31339AA;
	Mon, 26 Feb 2024 21:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708983209; cv=fail; b=BgE0MR1qSlPIqKZBb88F0OfQxKC8WuMYOkuaKuKBco+C55fEV8FO0+rriqqHMWitBqI+Vx9QL+0IkQheDJJkciMRiK9yGEAnop7tgedP3mzCCZc2aWIO6qe3Rs2HrGrR8izOX8y40s4Wpe/THdKBr5HnhJieulYq2l6QKMoAxVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708983209; c=relaxed/simple;
	bh=adG/ABrWVrZE3MsUfOnn8zbLG0RC0aNV9+6dAwjY1X4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Agg2xUT9V9ITM4lr8srOcBdnTre9adBhCts781fg+u4pwdEPeyICIiTntPDRVcyJ93BFYEUS3QqHyKMX95K6RaaYHxBbR1UE6abSA14Ej0T7crVtrHgQY81kG/fzb7D1XHhZXPmB4W9ZgXMqe2snKgLl4eC6BReRTHXPYg4ykRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ft8cRW1U; arc=fail smtp.client-ip=40.107.223.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huUhrZGekS98don+sGRo1kGDmFA3+aVNc9L6+C8Upb2X8i0ph1JqXVJyMBS1vhfcvQfxvasMeDau+bxRcLbA4a692qLH+aNeOkEmUtQ22e2NkDq47aYqd97fpbqOj2gnRn+OIvX7oGhjW8ophdhEq70rCKseEAAMsnBYjfmAKrNS/PnnUMldd9v8ko2NrZCT71ifUeHhmqLGs04pz60pWoLUQDlReuvQ4CDaud6OKakRW9CbWT49PSUVxXwzeOkSPR1K0EZIQPeE3r+T3QYF5Oi1blEwPog0WDh17W6UQRwmyyHcl9Fb8s72mwwN4vv5/I80eBZ3NetMX9Nz9LnMpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+ddYQ0Pdno3LKSDluChSeYK84B+ZLWxt5OvWSAnbXw=;
 b=DF5Lrmr4nvw8DiLM6eXuEKB7dZoYoXLPI7fkRJRdUTKGd4+6FjffjAI4U4zc++ry7geBzieIpFWKfUT7DvW9sDLHzTQcV4txg56SfQEbzCSev7GD6J+WFYX6l8gDxvCfV8I3f+tF3aYuMlqLQ3N4rcf0zB61+LNylU2JNSFwfVP76murUDNu5DvDijZm1zQtP+I4cCslp+ppoB8Cj6k6fZlVwVO4WoLXL7gQhAEUNLuDqgeSCVcjxk5jA/Q5W48Fdw9T+rIGQeurLg6r3w85IW5EhtlK1RcFUkQ/Afmvcjc9cbRxPXyb3AP9bTjmuCoVOTmJpa+oXF/HLrPKJWOu4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+ddYQ0Pdno3LKSDluChSeYK84B+ZLWxt5OvWSAnbXw=;
 b=Ft8cRW1UHav82EJ5NN8TnskuAw+4yx1pZEghoVc2Aw7nvNtS1GgwgMmhn47/4n8x4YdCSiEpxZSPG5B4Eh1blRWIll1aZbaol9UzMQCbYmroDY1uYNKCv5ACqmE7FTQgqYEs2Tct4DnILfuRTu7rnzxTr8f+w7ckJtdLwrDamto=
Received: from CH5P223CA0013.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::8)
 by LV2PR12MB5918.namprd12.prod.outlook.com (2603:10b6:408:174::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.36; Mon, 26 Feb
 2024 21:33:24 +0000
Received: from CH3PEPF0000000A.namprd04.prod.outlook.com
 (2603:10b6:610:1f3:cafe::62) by CH5P223CA0013.outlook.office365.com
 (2603:10b6:610:1f3::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.49 via Frontend
 Transport; Mon, 26 Feb 2024 21:33:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000A.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Mon, 26 Feb 2024 21:33:24 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 26 Feb
 2024 15:33:23 -0600
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>
CC: <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<pbonzini@redhat.com>, <mlevitsk@redhat.com>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, John Allen <john.allen@amd.com>
Subject: [PATCH v2 5/9] KVM: SVM: Rename vmplX_ssp -> plX_ssp
Date: Mon, 26 Feb 2024 21:32:40 +0000
Message-ID: <20240226213244.18441-6-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240226213244.18441-1-john.allen@amd.com>
References: <20240226213244.18441-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000A:EE_|LV2PR12MB5918:EE_
X-MS-Office365-Filtering-Correlation-Id: df9f37ee-c7ba-428b-3c92-08dc37129012
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NDqGmE2K4GSwcgVY9ytcWKG8NupLCY9upjGHjxvWk1pSjPm9Wof3yonbsPa5uUR0Qo3OlvIAYRCMrDnkUuMXLHezAVaNXbjPlKlic1zke5GjVPV5mB1fETHgSgR//DjuuBEcPA4oX69V4iTvt/uZx29OQNvWZH9e+v8thFUNfygNr9CoGBsu3WJP5xqrXSIh/U2GaFTXPeOG2UcN+v4gcuqaKzojByyiWRbFA4nD6sFc1kK6CkYkWKzkhFNtFT7FIOAuiBOh4D2VJV18UOfcdxaxkTaSmQUsaSGuPhHR9bkVyyZPZNrA2bVnO7gKdnctDrsLHX18rbI13NNGUkAlmAk43NjxM0k5SQpom0zwKBWxzti5BdClkcelA+5lt/NT0s9Fha0PfDDdtQ4uCtxUVoh7w5CPYa5yaeQV/8+l2XNafhThFHRRFBn7h8NNLubLzfdh6yf09Dw6SSF9QZYs9pJ2+nK1LiLTh0piN0UaN4nZ132pq5gPJV9C0PT8elaSR/OoynPlnieypLsfGlD6XLd+j+ta78zwlEYcJ7wsIc5/UySGvBP3PIBB0sAwACg/7g64+vXezTrMRW9FpMw2qlTabyMCeIb7W/Q5jRTN+gBCtLlrsgRpSW4/EDE/1yle0DD07LE0EOCxdHM/Y0V9d2Sicm8IcdLH0fwj8PDyrYo6DK7KzBmISxZPtzHyuQ1v3mYq2vhEjOlu8Zh5/EHDhOy5hgeL4eBmDqA3a38thZWLjcL5zadWKTW4XfwzFbsN
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 21:33:24.5196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df9f37ee-c7ba-428b-3c92-08dc37129012
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5918

Rename SEV-ES save area SSP fields to be consistent with the APM.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/include/asm/svm.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 87a7b917d30e..728c98175b9c 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -358,10 +358,10 @@ struct sev_es_save_area {
 	struct vmcb_seg ldtr;
 	struct vmcb_seg idtr;
 	struct vmcb_seg tr;
-	u64 vmpl0_ssp;
-	u64 vmpl1_ssp;
-	u64 vmpl2_ssp;
-	u64 vmpl3_ssp;
+	u64 pl0_ssp;
+	u64 pl1_ssp;
+	u64 pl2_ssp;
+	u64 pl3_ssp;
 	u64 u_cet;
 	u8 reserved_0xc8[2];
 	u8 vmpl;
-- 
2.40.1


