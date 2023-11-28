Return-Path: <kvm+bounces-2600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F10B7FBAAF
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:01:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDAEF282E49
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 13:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B5057889;
	Tue, 28 Nov 2023 13:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ya0s0xEi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DF51702;
	Tue, 28 Nov 2023 05:00:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYOSo6KdqDl4mkVBuOZPAVzmxzj2iewSYf9xTzqeQ4s5Gmka7qyWtOaEhFje4Lv5sdENsm91DqZ9HYoJZ5m+lhupsBQ63mlSRQV421fn1RNQUhwEu8ln4oLWRv0HGj380zW4EpI2qd56lZZL/7za7ZxO6qFWfg8Xk/b7fcwQlMMuacEbMzsRbLHqsdU08MamhVNwzhXbgRig1OLkcLOMvva2B+3WsUlyFQOMpBRPx6a3EIdrM5DmxzNT3kCP41vVnpI3LSAomYHbem6lV+BY1oJnVtJYXwzcMTpQtUt2nluDrhiR1+XgCmOOvO30uSH8M55+bW+E5ceIKnmMaMskaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=umd0BtZh8h70YPkvnUqmLlRivnCav1cJRD2MEsZFvOI=;
 b=lZ9s+fTT/D1l7xwQTyyn77IPom+wsTkox5WAHQB1eLo1HJS8oU8nS1xqpMQysaOOWECeo5X1L2jPmib1VCmSz3JJVkTYJTldp85pEHkNopCNVjfEb+glQSRv+dp7tbhRXxljXOW1E+0cNlOahAY7Q6XbWs83lo5FPQK0N8jPcUs02QLS9hQsK4U738PD4+HMmz0Z6+aVEekgHzFIh5KoE4ejKPTo6jB+yTHVE2PPaXpnuj98AI762Rj+m5FTO+poFxn54koqGCi9EDmAL9hnZoSrW9CNCVWHZY1CXjdojDcVKMRIVX4un5CCttFvAoM63bwpc55PBdmu1dtZ0n4OfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umd0BtZh8h70YPkvnUqmLlRivnCav1cJRD2MEsZFvOI=;
 b=ya0s0xEiKLR+hqUMfXma/lb1FrldaKN1o/IWwZwSAfEklB5z36Nj7WyuBowemlTNQU6XZtaNWhKlbo9b0NlRWtJb3tGDSESwK2UN0RljBOKb41+s/JGFlKQcmMUhczPCFVWqKzSeqJflB34wNkKEFJyv6gvODRtGVVJ1/YGul/M=
Received: from CH2PR20CA0017.namprd20.prod.outlook.com (2603:10b6:610:58::27)
 by SA3PR12MB9160.namprd12.prod.outlook.com (2603:10b6:806:399::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Tue, 28 Nov
 2023 13:00:39 +0000
Received: from CY4PEPF0000EE33.namprd05.prod.outlook.com
 (2603:10b6:610:58:cafe::b7) by CH2PR20CA0017.outlook.office365.com
 (2603:10b6:610:58::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.22 via Frontend
 Transport; Tue, 28 Nov 2023 13:00:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE33.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.17 via Frontend Transport; Tue, 28 Nov 2023 13:00:38 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 28 Nov
 2023 07:00:34 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v6 03/16] virt: sev-guest: Replace dev_dbg with pr_debug
Date: Tue, 28 Nov 2023 18:29:46 +0530
Message-ID: <20231128125959.1810039-4-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128125959.1810039-1-nikunj@amd.com>
References: <20231128125959.1810039-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE33:EE_|SA3PR12MB9160:EE_
X-MS-Office365-Filtering-Correlation-Id: b72bd33c-a6b5-49e6-73fa-08dbf01204fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FceRks+WbgOE6yuMuo4Oa/I3AG7m1+cdEP0Ay00RcjSg8UIkQlibkxmp03OawXSt+oZy77fzEI8rIzGC0GddDRPX16Kspm+GvlpxhBONIR4bm42xq/++mZMf+0AmFBv1hM9rVSBwRLSf1bf4oFnoxtrNdF3oDNGHChRchX1IUpje7SEZc72i+9dWEsY/UqsiicVs6m1Hmn6FtSiM73uMlFvN2FkUREsm/50PwDZfidWpYZ5pGAwN6X/GZ7dm72JbyV1VooXE1yWnaW5UT4H6CUNcXOZYSZ5VF0etdhIEAty8z+mzbU8KDRlBM3EOjslppsTs3R6jtVY0XAIvuYgnHluYvdGjJd13ikRDS6sHeajyF9EVpnpRhf/pRsfv7bydicuSmdxfZg/h69qiKwHvv8lK3ovNS1BqMTNdnG7wlCk/v/8IdUESgaIByqC03KqfdWV/NUc7dYj5lCM6TO3Kgfmqkgg/UQ2K4PL6E5wnhmYrfUrjCYyeejyeVBPkAhnahLCHG214UpCznIwgjKAML4OKgruNYjbSsT9DJY/kV61r6u9htvZeX4bxfqwdSMJHrqJAXko5nPAUPP2A+TVsK2XLLXuTLalvrZTCjjbDwVWdNgNHjnf11/cbdYIw3DUJ/T2xAy/vLzTpmE5ZgsMkVfg5L/ZXt5nox/kQxFaSQl42YGmCAAucNhw2zlc7CGfuTuHmtSCrDrGJseMJZtAFa/vnadRYpndCskY0KBIju4uc2DDyEaBA4XVqY4JRVYd6aN54/iw1gkkO8JEq2imCWg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(136003)(396003)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(82310400011)(46966006)(36840700001)(40470700004)(82740400003)(356005)(81166007)(40460700003)(36756003)(478600001)(316002)(110136005)(70586007)(26005)(5660300002)(16526019)(1076003)(54906003)(70206006)(426003)(6666004)(7696005)(2616005)(336012)(4326008)(2906002)(7416002)(41300700001)(8676002)(8936002)(36860700001)(40480700001)(83380400001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 13:00:38.5669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b72bd33c-a6b5-49e6-73fa-08dbf01204fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE33.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9160

In preparation of moving code to arch/x86/kernel/sev.c,
replace dev_dbg with pr_debug.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 8382fd657e67..917c19e9e5ed 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -178,8 +178,9 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
 	struct aesgcm_ctx *ctx = snp_dev->ctx;
 	u8 iv[GCM_AES_IV_SIZE] = {};
 
-	dev_dbg(snp_dev->dev, "response [seqno %lld type %d version %d sz %d]\n",
-		resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version, resp_hdr->msg_sz);
+	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
+		 resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version,
+		 resp_hdr->msg_sz);
 
 	/* Copy response from shared memory to encrypted memory. */
 	memcpy(resp, snp_dev->response, sizeof(*resp));
@@ -232,8 +233,8 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	if (!hdr->msg_seqno)
 		return -ENOSR;
 
-	dev_dbg(snp_dev->dev, "request [seqno %lld type %d version %d sz %d]\n",
-		hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
+	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
+		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
 	if (WARN_ON((sz + ctx->authsize) > sizeof(req->payload)))
 		return -EBADMSG;
-- 
2.34.1


