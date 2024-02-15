Return-Path: <kvm+bounces-8748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F5085619B
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 505E52816D2
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4AAA12BEB1;
	Thu, 15 Feb 2024 11:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LaIGwZQ7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F23E12B15E;
	Thu, 15 Feb 2024 11:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996729; cv=fail; b=HCJmg3R0MENvt4EY88Sp0V3pFsEguQn9CAQQZctbLGHS154GXQUSSPpLzGPZ5/lXJI7shfuChVXqq8w+5vKTUnRtMOIIweWfIj8/FyXDpzEVlPSdApT2G3ijC5CFdLmZECo+o+9/BguG75tg2ShNmIvdwUU0LkWCtavEiztM8M8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996729; c=relaxed/simple;
	bh=gzglIyIej4OfDYBTWZwipB9tBf5y9FvwUMbwEMrkBPs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h+FoaDYAAORhocplEfObZd/akpzmgouvFHaxUpdFvp5rEkpC4pqgkE/Rq71Ie0pRVYMlZwuN+VrLPTHqPNDNoNznllXlTyayhlAdk3PXHQUaJmvTJ6AmKVr88JBsDMFM2OGaYnz8bM0qqgPf2a+JJdrAfF+z+Xn8JxDNbtfMZaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LaIGwZQ7; arc=fail smtp.client-ip=40.107.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBBxU7BOG8Hgpcy7C2xCLoMqc1FIMsLhly/nBEgeWx97474CE1SgvsMrHIj9/9dN1KFNFX8zxsw4aOxtL1XsPXKpv04+NF1BDDrWDmosBskb7NzcJnzA0unveJN1V4H19KQUwQT6eBVCwDEMvFu7aKRd3e4w7WBTOkzsq7d9+Muq/eKbl2268AGepE2ZnDG4q/TUXs0eAnCT9TaTUdolxCIOxbiCzYltaT0szDE2w99RW0TrZXsnzZVDt06FSUMAoAM9K31mKqq8NswRMEWCzQ8v1XtVEBl/rYfl9SHlQAYJIOAXI2RCWPKj97KJCcsJYr3bCJNqtM4OmVKqRLP3UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3g3yqKYaWr06VB7dsG4GGQwGmiHgQOjJVFTiwt8+WP4=;
 b=oBMlz/C3rroXTpHC/KRfDIA51AqFvkLPM2CRe5hc0EP0GMcAwJJxGrUGUV8xZbweey3SOVvsmR2hifiRO2butn3RdFfSCBMWgNdqrHWu6U+lChJi+6fGxNbEzhjFzIqb7GBTv3GZYSyCgiPN6EJQPBxI+oT/46kekQ++QohegIwtjDvybdOR3kDj5arNCS7AVQ5cFhofyfGfpf8kTyH7ITKnJKMSfL8C7JH2KH4TUe5hzxm3GGkMeNml1O4h6DnFkjVLD/M50aqj7LN8xXE445KuDukpVD9gL3IsCs3/XYqt2RaLLe97+mIdmsIkGK/Kgpjne3I/tgxLeRTIAErEXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3g3yqKYaWr06VB7dsG4GGQwGmiHgQOjJVFTiwt8+WP4=;
 b=LaIGwZQ7BxLmCrxsVAjiIHSPYmhEQyo6W278m1mQog1p8DQbXPLdJ2HMDoboiZdWBddKv7vCUSm4eRArmumnYc0Y666+htnw6Bwk6DHYfo3pfj9gV3TNCNKGeO3X6J1hIcSk+XVtL5QbO3jrvGkrNqBKQnJVZWrHdp7xeAlIQd8=
Received: from BLAPR03CA0103.namprd03.prod.outlook.com (2603:10b6:208:32a::18)
 by CH2PR12MB4118.namprd12.prod.outlook.com (2603:10b6:610:a4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.12; Thu, 15 Feb
 2024 11:32:05 +0000
Received: from BL02EPF0001A0FA.namprd03.prod.outlook.com
 (2603:10b6:208:32a:cafe::b7) by BLAPR03CA0103.outlook.office365.com
 (2603:10b6:208:32a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.40 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FA.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:05 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:01 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 02/16] virt: sev-guest: Replace dev_dbg with pr_debug
Date: Thu, 15 Feb 2024 17:01:14 +0530
Message-ID: <20240215113128.275608-3-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240215113128.275608-1-nikunj@amd.com>
References: <20240215113128.275608-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FA:EE_|CH2PR12MB4118:EE_
X-MS-Office365-Filtering-Correlation-Id: 448d196f-1866-4adf-092f-08dc2e19bcc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sLDzYIHOen+85dOBeHjarU873paWQ3slxBXbTIlfzRbzv98vAePRJVyeT3rvj5iOumH0vESnFyCPSn52798hUE1z+FWnYQa1tMsQgo+5dIfVENALycU9gcNFS2kqYZdqqsxMqQStQWEp0T1jCLaAw7w6sPiTwXTH1I5iaLQbuPO53HgJuj6kUYLg7yUa2AtJIV8euNIy61cEbMSaK0gCw083POQ9BkMVKcT/mavgQdu4ndmgXsXobOuBvE6mD4LzSIWsfgtFFU9fMgdViUhY2tgOfxhd7PcRxAF9cLo/M2WlPFCydgZmb7AaC+in/VAlNyk61PMerVBpzzw9GAMpL04TQ3IEQv5fitdhk7IpTTXj7FrbsleL96JHSr9DA1iqAmvCTZuoK9QuEt+hBIifbXUHff0r1BmFbAweQ8YH6l+qsUxCqpfGZPmh9F0EeRoKXsAgFMRgakI57msyG3zmbVtEfOIjhkP5JgsFTzmAMy1/QY2+JxcdsNMC5pxf4+gxvRBosRgzPpIKq+HLe59m9FehJie3fh7l3B1de0w4+twVSW+R3Q8yfJ4f6HYB2sB6Bz7u19FMm3CDAxlX4/KW59m/XTAmclKXlWs8xPVzPH4TKgvtNwOi2J39UtEMviYR1cq7GwdY23dXRZ0VbvHoF8UyYq2pIDoF1ZbDHLwJi18=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(136003)(396003)(376002)(230922051799003)(451199024)(82310400011)(186009)(36860700004)(1800799012)(64100799003)(40470700004)(46966006)(2616005)(7696005)(478600001)(41300700001)(7416002)(2906002)(8936002)(5660300002)(4326008)(8676002)(110136005)(70586007)(70206006)(6666004)(316002)(16526019)(26005)(1076003)(83380400001)(36756003)(336012)(81166007)(426003)(356005)(82740400003)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:05.5282
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 448d196f-1866-4adf-092f-08dc2e19bcc1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4118

In preparation of moving code to arch/x86/kernel/sev.c,
replace dev_dbg with pr_debug.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index af35259bc584..01b565170729 100644
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


