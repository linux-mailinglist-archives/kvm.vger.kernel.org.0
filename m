Return-Path: <kvm+bounces-42-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A25D7DB386
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:38:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D94F71F21594
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 542BF6AC0;
	Mon, 30 Oct 2023 06:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nktWZ6ne"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8156AA7
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 06:38:09 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2380CA7;
	Sun, 29 Oct 2023 23:38:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3Deh/kLSoaViUfgfhSxKGMlvhIvXynCiDpACUiDjgNpj4Y0IqQSkhyDdTawMD8xESBZZKQP0wfMeaW7A8lCPgJO655zb87LNT33qt4f9Gn1YWg/0ihWxBabvaxQxyEqR5ooeq5RiFCaJpLnEVhulVTrY15ynTErqxJIQ61MskgbIFGWq8SG4SEimg+/s/KV+CM9yeCgaKLycb45V/Z/IrHRmU2qgVcWJw9JwwxDFe17dkOtZ9aJDZswpPB04FWkapY1wKysOeNY0fi5Nr8RzAATJuYN5wxkPqCFvXpRQKhchKQ/xPyTldkaDt3eaXoZXDNRlYiJTJW14cgrV19PDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xtDY/Cbo5PqLUEs7gYmvOhTmBJrfa5I+8NRVgowavig=;
 b=GVE3R3PA2D4A9ytDlAAWEf16jXCdmFMcKxRCuQVfqAMXSntRh6GLVIRzEqT9BROTVhXrVuPZBcV7WThhbtLzKUo0A/a8qGPTNY62XjAUz7hMmDqLh2lmi568JmJPUy4GPP7ePWqz6pJseV3mYzf09b6/j/R8VO3wJXaFQywwc2I5u5QenKVeMYG8lcuR0asNj2Drz+RxAR3yML4Agv6KErYf4CSBWTfnPgwXBT9YbcIueilbJtNfu0TYoQ5pDWw017Oj3xwJQe5punAc3Qkst1nfbeSve5dRtlDjJ2yYdf3H66W4tRKIvREVIOML7WihppvzKK1Vzl8w95jiUpHDPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtDY/Cbo5PqLUEs7gYmvOhTmBJrfa5I+8NRVgowavig=;
 b=nktWZ6neOa9duuFv4KAYl6n/JB4K2xXef+df0p2ZgrpV3o7pO7Yka7Je33PHniBgiXXtoYJHImTxgt/Fnoey25PzfxnhWpL3WkW2iPwcyeAgXz9/54+s7f7y1vEhuFZNi42UGbHZ45XH8D0bgDO97m5kJK28yUoSBErsoXIySg4=
Received: from BL1PR13CA0001.namprd13.prod.outlook.com (2603:10b6:208:256::6)
 by MW5PR12MB5621.namprd12.prod.outlook.com (2603:10b6:303:193::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 30 Oct
 2023 06:38:05 +0000
Received: from BL6PEPF0001AB71.namprd02.prod.outlook.com
 (2603:10b6:208:256:cafe::2c) by BL1PR13CA0001.outlook.office365.com
 (2603:10b6:208:256::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.15 via Frontend
 Transport; Mon, 30 Oct 2023 06:38:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB71.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.22 via Frontend Transport; Mon, 30 Oct 2023 06:38:05 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Mon, 30 Oct
 2023 01:37:25 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v5 03/14] virt: sev-guest: Replace dev_dbg with pr_debug
Date: Mon, 30 Oct 2023 12:06:41 +0530
Message-ID: <20231030063652.68675-4-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030063652.68675-1-nikunj@amd.com>
References: <20231030063652.68675-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB71:EE_|MW5PR12MB5621:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ae6e751-21c7-4b11-b5f9-08dbd912c5fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KipdYn5V6LFfgskhLo0gR5FvGwFj++4M3lOJo5QKve49THXc33hgHOZGPcCEVukho5IzG3qMig8jfUZ1JL6sV79QQ8CbWr+rT6oxWxTcc69i0upFOCBcXofGs2vhkFApG/1xCoAuIYWDARBUlHZG0gYP4OyqgbKy6GAV4AEGuUVA84Jbu7onFeIJE81ojDGs7kMiwwv7jPtrlBx3nyQV9SgH/hQtcGGNosOCD4yb5YN9+VrXDsC3k1fl4r9RLBEen7ACsQ1B3fZ9ljV/qfBgyzcEiVZMzqJpK6K7EANeQSOzAU5BVYM990+wjJ+xTBerzjDcG0AuMnYXjvsNl4e0Uor1OkxqGa3MT8p21n/A9M9lTI6m5VrI9C7QxeregZxFd/58XyNxnPzO/COhlBYL0W3pwA0jA3N/Lsc0d0+H8dnPyVzZzKzgF8Xvb17p2R6OS7+gJXoxpqREreBPl3oNxOnixSvnYbeYlWkXXAhmer4khAHY94MtYFADb8pu7Za/rr6VfElbBp/s8rotryeETQapG26kYGg9RitFMMQUZUMVNQd6bNkrOmW09l+ECVe0bg8UUDo5JvyRFwneoLjVLwF3ZVv0DdpP//3UtpmaV8S9PcENIC1ymRF7sh045SrL7rssroNfjYAhBaL8Gwl4YgAmmdFb1NjzwAIhID7vwvNFnbnkNIyDosLaXC/YxBulrb+B4J5c+4TDbjQpc6jA8QrOl97AXoVM7SZFP3d33rdRYkPtmwlHGyIezLLZPs1xjnYYpdcvCNmjRZmvNXhH2w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(136003)(376002)(39860400002)(230922051799003)(82310400011)(64100799003)(186009)(1800799009)(451199024)(46966006)(36840700001)(40470700004)(6666004)(4326008)(8936002)(110136005)(5660300002)(8676002)(70206006)(54906003)(478600001)(1076003)(7696005)(2616005)(16526019)(7416002)(26005)(41300700001)(36860700001)(426003)(336012)(83380400001)(316002)(70586007)(2906002)(47076005)(82740400003)(40460700003)(81166007)(356005)(40480700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 06:38:05.7122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae6e751-21c7-4b11-b5f9-08dbd912c5fd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB71.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5621

In preparation of moving code to arch/x86/kernel/sev.c,
replace dev_dbg with pr_debug.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 85bda0c72a27..49bafd2e9f42 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -200,8 +200,9 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
 	struct snp_guest_msg_hdr *resp_hdr = &resp->hdr;
 	struct aesgcm_ctx *ctx = snp_dev->ctx;
 
-	dev_dbg(snp_dev->dev, "response [seqno %lld type %d version %d sz %d]\n",
-		resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version, resp_hdr->msg_sz);
+	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
+		 resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version,
+		 resp_hdr->msg_sz);
 
 	/* Copy response from shared memory to encrypted memory. */
 	memcpy(resp, snp_dev->response, sizeof(*resp));
@@ -247,8 +248,8 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	if (!hdr->msg_seqno)
 		return -ENOSR;
 
-	dev_dbg(snp_dev->dev, "request [seqno %lld type %d version %d sz %d]\n",
-		hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
+	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
+		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
 	return __enc_payload(snp_dev->ctx, req, payload, sz);
 }
-- 
2.34.1


