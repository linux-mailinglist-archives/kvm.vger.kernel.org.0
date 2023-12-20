Return-Path: <kvm+bounces-4936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78A1081A1FC
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:15:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D7B11C22C0A
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3070F4120C;
	Wed, 20 Dec 2023 15:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vFukg1oZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2068.outbound.protection.outlook.com [40.107.101.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0112340C00;
	Wed, 20 Dec 2023 15:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPsiGpAiZ0gSHKGWBfoXIeKRNRZAVATUO2hX92EKSOCmd2t4wZIt1aSmm+mdd1fXm+fLFR1pmmqiIkc8jKlwY7tkD0Fy2Y0BLbIjtf+Hpg2h+QnXijDqiTVNc2VkMJjk+ZWHoQXZ71NU5dKDn6mcM1GB2VFZR7Zl6FxoNtKNErEA4RqZvEFDz0fSDqH6anfWu+SbwNgDN2UGCKIki/jtr5bmaLpAt3K1iL742uTKUIWp/ZeOBuHoYpBEwTvQHXOXZvLevlXcplGzTV2rlw61MdXAaJy9XjRA62IZJd86KxpVZEixXK6WE5rJIa30BfXD3fNdqz6cCh1r6KFXXERZxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRm9mK5LBrsBCeWxI4dAFR5WzTvfk4AbwNC7EEU84Zg=;
 b=RcrUYSQPst9RJAKXwJ9LMmg2z9Gd/k31bYlQ2Vblbp48wXCNEaLyXKrSFxok8YwfOq3rUELGt85AVLDy3RphDq7Z7SSnbNQa2gon3BJyFhTNEDPe/+eDvDJYYKSSk3p50wJXmLAPnU42wPYTgOmfLu/QPdpKhrxLfYA5f0bdmR3uQs/MVjml7xsloCHr9KMvWb+trLYGUeTW8o9k9jtjkCpnIhFYUaKHSHc0bXwzcpm5xcGIAMoElrxsE8Wne1t7QTz5FLtk4eUoImYhR1qNW/6dyCRT9eUNdK8esdRzxtsklWkg9ldiB8Mi3hIVEFxPidF8TgfYtQQ9RohDGRjTcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRm9mK5LBrsBCeWxI4dAFR5WzTvfk4AbwNC7EEU84Zg=;
 b=vFukg1oZEHRIZTbtNdKlcapQdquAwfUAQZEnKUGFt0OrLb6AbrDv+Cr5PUfA3/j3eBlpjmr84LpC5qZuRasGg82NuaFOQdiYl44ERKIrbTWsPsulP04oL+4qHV6NtAE1R0ebC+9+zxiaz9G5hdI71p8lAEMJFJ/pbn4ndzDvj8w=
Received: from DS7PR03CA0226.namprd03.prod.outlook.com (2603:10b6:5:3ba::21)
 by PH7PR12MB8123.namprd12.prod.outlook.com (2603:10b6:510:2bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Wed, 20 Dec
 2023 15:14:54 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:3ba:cafe::c) by DS7PR03CA0226.outlook.office365.com
 (2603:10b6:5:3ba::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Wed, 20 Dec 2023 15:14:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:14:54 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:14:50 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 02/16] virt: sev-guest: Replace dev_dbg with pr_debug
Date: Wed, 20 Dec 2023 20:43:44 +0530
Message-ID: <20231220151358.2147066-3-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220151358.2147066-1-nikunj@amd.com>
References: <20231220151358.2147066-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|PH7PR12MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: 9169b17f-92b8-4470-96a6-08dc016e6ba8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8C+CZHNHwilPdYGgEOkw05hkIix/dufHc8kMPxWmig2itsM5dpm8qcRsJq9TYte1M2/RB6LH9eTrNtrJ27j+NmdRzuWiYTgBnU7SysXUCrPvkbj0XCkzRJcethUZ7fMLDKPXhEyf+V5Xtow1dhvvvpn64Q6WdXyUb0fzZj4L97FBBTibs495U3GpwAkSlaCNmTcUg/EB7mWW42ScPC2GyKUAhzJ1zlQXbgN7azXzewVhiAMbntJEJA8phkfzDj9QcAkEgqDqGYWYH39j2lSDSjY+R998SBxCDoyXEhE1PxfwLzGNQxlV4PvJzG+H6sjGbc5s6/R0DvCFky+Y10j3t3DTcXYq82dB1gYEMpyFN/7Lf8HIlAysSNnhLhE6mhIYVbMkZsq8HDFcW96rzkCayRAPwaChKN7l2rocydeIGwPTAV+LOhrmgLMd6KZBvgKgzdLHsq4EYqAAqd36NLaieCk2IXEPSJHh6kb9AHysyxep8GRTs/x2UVSHWDOSjnXB4TV5yS6Mvy9cnkdCk7tSYz8jKreF0mdusew4BUqYCV8DCCU4qSq1bP/wevnbp+gobYsBkShAoxjBWcas7JH1qgd8KQ9K1+Xr9kEY3wb2EpZrauER7xBg5yKgIl294KHEYCXsfxZiakpUnOApzkZJFs8ys+X1tA1Ppcyl0TNAGJ+q5I50bsSQ4qjslEIPWuC5G+97iaqv45n6jvJKqOpo9+7e2VnPuSemxrSdF56Il08i3N2I8e7y6YXHVQ7QS6VQGiOg2G2LqEVzqzhXHhk6Ow==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(136003)(39860400002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(82310400011)(186009)(46966006)(36840700001)(40470700004)(36756003)(8676002)(316002)(83380400001)(2906002)(426003)(336012)(70206006)(110136005)(54906003)(40480700001)(70586007)(4326008)(47076005)(5660300002)(8936002)(36860700001)(7696005)(6666004)(7416002)(16526019)(1076003)(2616005)(478600001)(82740400003)(41300700001)(356005)(81166007)(26005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:14:54.3227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9169b17f-92b8-4470-96a6-08dc016e6ba8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8123

In preparation of moving code to arch/x86/kernel/sev.c,
replace dev_dbg with pr_debug.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index aedc842781b6..469e10d9bf35 100644
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


