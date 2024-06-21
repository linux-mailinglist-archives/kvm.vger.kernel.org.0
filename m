Return-Path: <kvm+bounces-20249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FED79125AB
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 226731F246A4
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58EEB156256;
	Fri, 21 Jun 2024 12:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Lb9Y35iQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2079.outbound.protection.outlook.com [40.107.101.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6136155732;
	Fri, 21 Jun 2024 12:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973577; cv=fail; b=KFNQyrls9MwGVqgJTK/Rncz99FVjqa8TRqL7YpqieiUC0A8L+lc4jrqgbSAUjVoMBUMCGLlOqk76bpq7yUe6H/Uzq8c5ILTY4YBNpknqXNB4WEr5o0TpbssN+BFOK7UAIomXEKdyxjZ/F9ZU07d3ijCLwLQGnRs3mVdhzt176Ro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973577; c=relaxed/simple;
	bh=Wna4lGwKQKv0OGFxdv4VelW+59GoPlAk0D8a2EE8X98=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CeBez22gp+f9yFGVbF2G3j0RW9fUblTYFNPtQussEqjDkCrXsI2pVbSKLYVeGb8GLji97ooqb1OU3bw4mMs6yCHQV7LJa7KGAsteruuq0PF6+I/V97eu+X3k+9GwujvQ6zd2ekh+d9rfsnPG/gBEEtjKz4heoGzSDSrcc5JYUac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Lb9Y35iQ; arc=fail smtp.client-ip=40.107.101.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNLWAeLUe0elN0PzaDm1uXJ0uFtGNF5Os3X76aHIVSiUvqKiztHSI3Ndqi9ROTKej20wGaV9DGhEsq6Jz2BkZ7fmkbFla32w8Dt4dPp4yHJ8wFHQ5ukHbW+/QuVMNadWLZ5TtFg/80+VbuRTGwOkKTsDjDTRctgl3KiPcvWufMzV+C6CbwXGdadN904ir35VXb9xZ2aW5KSEhw4LO6nNHLm4/h7VqooILrdj5tfFAEHxqZx2vVmLrDZQHwtahKMwyVAVDjj8OAvjmdN7dAotYGPlA8G59WwEFveiRq/0l3mF07Q0nKLL7koM8BN3rVTbS4CmHYPBGymdbD3W/sWJgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67mx2JNkNDBcCBCSKnQOT6kg9EWXwlovP8NOcK5meDA=;
 b=Ip+W2M9AO+BfeXQMjy244BvrRza3zoDj6NKpI73zpveB+o55rt3aRZB8tn3oyZ8x40Jk6SNLLJb+9YHVKgvxExUvWzAaS1iL3QkQbce1E8UU/q2uhg5Z7+0ljxDHZ9YlMFYHpbsPF0Bj2Bm3KGy769oYqqQbEWjcdtfl0K5rqVCotDeBJLxeSt7YgRcpz7BqahXq7M37G56Ro7RQ8JvkYQYNmvM7koC3KFLHb/slWtclAZ4dHFhvTuKpAB9qHG9W2260Lc63BZB2WDseGPJTh0eOy/zvPXgiHFwZqQYpoLRFbQsIgxfW1sz92Xsz8fzTvLk7xWgvYyicqQXV4z04Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67mx2JNkNDBcCBCSKnQOT6kg9EWXwlovP8NOcK5meDA=;
 b=Lb9Y35iQZkqX/lLiexLfQGp6VYBsvwghWCm5+CTQeUDD5FYpbhYsrL02JGSziQAc81Gq8atuCRHt1pfaeZzssUvSNb0gVzlh6dSXB58GQnuWxO89mJC0O86n6CI74VShdNh6kROHStI9GpllGFsPCAqiU3qOAfpUG0sH2zxa6vQ=
Received: from SN6PR05CA0024.namprd05.prod.outlook.com (2603:10b6:805:de::37)
 by MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.20; Fri, 21 Jun
 2024 12:39:33 +0000
Received: from SN1PEPF00036F3E.namprd05.prod.outlook.com
 (2603:10b6:805:de:cafe::6d) by SN6PR05CA0024.outlook.office365.com
 (2603:10b6:805:de::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.33 via Frontend
 Transport; Fri, 21 Jun 2024 12:39:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3E.mail.protection.outlook.com (10.167.248.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:39:33 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:39:28 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 02/24] virt: sev-guest: Replace dev_dbg with pr_debug
Date: Fri, 21 Jun 2024 18:08:41 +0530
Message-ID: <20240621123903.2411843-3-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240621123903.2411843-1-nikunj@amd.com>
References: <20240621123903.2411843-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3E:EE_|MN2PR12MB4206:EE_
X-MS-Office365-Filtering-Correlation-Id: d77502ac-f2de-48f3-8498-08dc91ef33f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|376011|7416011|36860700010|1800799021|82310400023;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IKTixGMmxmMVTFqRV8UV9IQ2upD8BjyVveDPqV7cmsYMgQO4QkXcrXOmA0Pl?=
 =?us-ascii?Q?NK3Vzo+e9n63+VoKc5F466OoiXlqBmwFL4Hzeg/Ib6yVz9OpT139CWjphsht?=
 =?us-ascii?Q?lCsGliZjXPy43lumC6zMBDQGhVZxhNzBMLXOsy9Pka2N2SZ1b5Z5Mp5H2LQD?=
 =?us-ascii?Q?URD/2yePOnb8GYKUDPn7oD3VtR4MbkQfH4p3OsV4e0/HFMzIv3WcOIHqN/yb?=
 =?us-ascii?Q?ZIbTFVFjN9TFbthuEPwgNtVFOuCUOZZX3EEGYj7bo0iLOct8i9RcrRxmG2fF?=
 =?us-ascii?Q?SnXsMvRjQVccZghcr1A/Jd50DwyJWIdMrk5UM90IgxguPnIOA4lrLgZXhL4Q?=
 =?us-ascii?Q?JdqHwY4QBcIC5q0IBqorhv/ngb3TuHtICArniLOUoRwVrqX1qy3m583Tm/gS?=
 =?us-ascii?Q?V5QNeb8va3Bp+GEYaxAg7OrAImh5Zz00zJJxf8RMbLANrlBsHDeQYdTyTlcM?=
 =?us-ascii?Q?y5iZZyzgOvAxr8drXc4tWo5hUt589AIca+yeJuYNnqEKLkoCnz3miI92RN3e?=
 =?us-ascii?Q?uccKPkpCZPq5z1sk7hCTS+2pDw9o36k53vcn6GaferERyWCV+MRlfoKAGLx0?=
 =?us-ascii?Q?6Xl63Gkk5nNCL+yBxwAAnlT+zetXzpMRNzPmDubiqAam6G5WXnXnnBm/FZbp?=
 =?us-ascii?Q?ZleuLhVZb0FWUHxo3zEqcsomrKdJ5oBa7tEo4TxZFkRmn7dXrDTB1gREqy/U?=
 =?us-ascii?Q?oTcj5ZOlpanfBWMgtTn9hDbaPVuGuJWQYLBa9w6NvMtwM52gCutdXGhVuFD7?=
 =?us-ascii?Q?epsd89oJ+Fzw7o9nKWP79Yjrwi8ogI9mJgW3gh6oYnPV+dmYw+mTjE9F/Bd5?=
 =?us-ascii?Q?ZaPWRxx8+uvpUdix/te2cAUAfVxFz509Y+yh256jEKB8CV41MPeljHsF1Z9O?=
 =?us-ascii?Q?IgkixUOvbz/CdtlcHGIXn/dCJQAXQgkov4XFHVxeH/JKOzI3lo4BSG5Y/Rfo?=
 =?us-ascii?Q?mRwmpRtVNKqDZ+TnWrpGm51dyNBvo/JTthogk1ZAjqlTZRw/CifPROmlXWc9?=
 =?us-ascii?Q?x5tK3elLELCCyNDRNLUedTOrcepOJM7VTXpBpcd1aBsOyX4js4ibTbqanp4i?=
 =?us-ascii?Q?Yj9Rr43O2PLkL8a6vxhBv0bJn1OKVX1OtWOp0ZQVU1FkIDdd2s8wxOTHiB8e?=
 =?us-ascii?Q?ZSQNeUKeRXN/5gAmob+X5WUAUI1k1HtaUUPJq7GyZaEpHzp4WYVAomAUQIQR?=
 =?us-ascii?Q?K9LkghGIHe8kVwASCMmpnDMBDynK9yOvYy6rqnHl+V9OoLDSBUSHXzLRFizM?=
 =?us-ascii?Q?KbNx9Fe3kWIG2+IV0mUnfKRp1IQ4SmGcHmWdmMh4Lf3cWQ16Z0popQ4xX9jw?=
 =?us-ascii?Q?lqcSAAkmEz+Sw13nJAMy++kQOlo/WlABS6y1DRFiT/YbLLsL1zMGkCN8etdN?=
 =?us-ascii?Q?Bo7fM1WDWY7qBp2ooYMTJpryDVzG1PsF/MtcprfH47XCXDoHAA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(376011)(7416011)(36860700010)(1800799021)(82310400023);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:39:33.3094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d77502ac-f2de-48f3-8498-08dc91ef33f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4206

In preparation of moving code to arch/x86/coco/sev/core.c,
replace dev_dbg with pr_debug.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index dcdbfc5e5af0..831a32e522b2 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -188,8 +188,9 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
 	struct aesgcm_ctx *ctx = snp_dev->ctx;
 	u8 iv[GCM_AES_IV_SIZE] = {};
 
-	dev_dbg(snp_dev->dev, "response [seqno %lld type %d version %d sz %d]\n",
-		resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version, resp_hdr->msg_sz);
+	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
+		 resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version,
+		 resp_hdr->msg_sz);
 
 	/* Copy response from shared memory to encrypted memory. */
 	memcpy(resp, snp_dev->response, sizeof(*resp));
@@ -242,8 +243,8 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
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


