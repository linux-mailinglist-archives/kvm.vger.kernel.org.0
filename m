Return-Path: <kvm+bounces-41-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB9C7DB383
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9D20281457
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2552D612B;
	Mon, 30 Oct 2023 06:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jB1e2uUE"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0365664
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 06:37:31 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90121F2;
	Sun, 29 Oct 2023 23:37:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0UyENvAN8J95+HwPvS6eLX8ibu1kVvEzJ30Yx3vs6CTV76IoCi90lJfUEKg0O4YoV4dyKBp5vSqSxXPbsEEp5pFjLoyH9qor0WlCYgSJb5DRSoEnytD1KI/so3OZNXq6yGaD+oEs/7FptGTrJwM4gPQFDV9cgM1WxGa4h2Kn7j8tHFRCqJZ7umaMbBKfzlsk2whG5oWeO+imiRfPwK6FkuSJmk5YyZuIdSyaNk8taCqirMM9Y/aqccVItpUAeYIyXmq/SUKO+FwZRGZfHbVBXjJQnyiVor6wnizN3gc+N3viOZrJQlbowTwyQp+vnMIiV56pZgyBS/3VD2JihtIpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CuWu5xWIdMzKejTzmmHqo93fvMIeR7QVxrJdwTwWXrg=;
 b=D2frA3lr0lvZ2NH7Btqu/+K5hHR69m6XHV42AzchBPsziwwuYcyw8ay1bo8dZe8XtWccpxct7REXfnak8jcFjJtN4jDGvVpobEdTYHmg/is9ZH478SNZOkGKku7JlZvjRh5OqYOD6Ie4e75FOsHXDzFV2wJ0jX54059lRNfzryDXWZUCs2XG6Er0FUSTAEKbINTSzRf8rNYYM59zhddSmJ5ugjSlIoYqiIg2ZzIywEbydZDDPdc6bV2Tas0D+t1DVlSehkl74UCikJOPfH/KGQ+v/xk8WJV/uGxI5JZWTlBb0/Z66eECZy73tQdO/9YU4BHwdgF3oq4X+I3EOrwRjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuWu5xWIdMzKejTzmmHqo93fvMIeR7QVxrJdwTwWXrg=;
 b=jB1e2uUELervAlkxiF1fB5ZaCXSoxLSU/g+uBssNYGXvRTYmz2px0JMdsHAkJ5E1o55SMSSVllmWkMmm1dflx8MAxdjVKB7TLuygUtIMlvA3J2CDrTN66v8phmEOXXfRQaCa0+Izv4h6QbXjfhUYH1ugutvJg4Xw526B88RCajM=
Received: from BL0PR02CA0080.namprd02.prod.outlook.com (2603:10b6:208:51::21)
 by SN7PR12MB8146.namprd12.prod.outlook.com (2603:10b6:806:323::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.26; Mon, 30 Oct
 2023 06:37:25 +0000
Received: from BL6PEPF0001AB77.namprd02.prod.outlook.com
 (2603:10b6:208:51:cafe::fc) by BL0PR02CA0080.outlook.office365.com
 (2603:10b6:208:51::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28 via Frontend
 Transport; Mon, 30 Oct 2023 06:37:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB77.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.15 via Frontend Transport; Mon, 30 Oct 2023 06:37:25 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Mon, 30 Oct
 2023 01:37:21 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v5 02/14] virt: sev-guest: Move mutex to SNP guest device structure
Date: Mon, 30 Oct 2023 12:06:40 +0530
Message-ID: <20231030063652.68675-3-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB77:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: ece7b02c-8dba-49e7-363c-08dbd912ae11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	p7uQYf/kYXgxE57foITP+Es05GC/8Ydr+ZV+08mPT1FHFJB0ECSCTYVO4enR3/KelkNDjxsfcyvktXX7c4vR9kWBfaEoFpyU7rMtt5du/uOSQ0aibisHupDNKapoUwqPDbNW0COYOXmfGZbbLnDfKZh6HtWgbiT1EJPEbBTuAf3JfnvEKzA2Bpxw0MyuYFHS0AyxbfQiadoQjq0JeYDA9TCI5aPuGnKbCA1/JT0895445l1VlR1JhcNilCWwdsiR2u1/nvEJ5P8b/Sk/+Ve4hmG3orYut3dQyU7CJA7kASwTchV59Fq0rDuDC9ymOa1tkzOw3aFzOHURyFbVWy5mVurRDpocUKvhVWArdGTBntUJ1kJPfCvvGFqsZJSaZrQypbHy/+MI7wJFb7hfbQ3uBhW08jCyzk5OBOaDlnrO8lk+Z6FN7p6SNIzhcuDbai1aJkbYLYMmXeRleaTZ2ZVZv3uLNVvCkt4sNB5YSQPxkmGy0a5ha67LsvGNtnkzDcy8pSQikXZdflbUnfUGAU0Z2qSdXKGzTMKHh+xF0yhfnfT0JQ8F3Nm+vn805JXwhasAOvJ0jaLQFjPVH7ZUtoE8bYcUkjhnpDjchYPEhUYhaXzqCZcp1q1h1OxHRwPFga0TqpOU8mqxD62ieQa4Wh3SKOkP/ImLlcJ9jccDWxgHx2nKIAXfazT3KdG0jxeoRtqqtLrN54VrJ2gDR2cccUK2R2Iv++P/9KFF7LeGDHPLnxY0qvDjUqJJWoaIdOi5latQ5OgGMb4Qusz6Acrs7jno0Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(136003)(376002)(396003)(230922051799003)(451199024)(64100799003)(82310400011)(1800799009)(186009)(36840700001)(40470700004)(46966006)(36860700001)(82740400003)(81166007)(40480700001)(356005)(47076005)(478600001)(6666004)(7696005)(4326008)(8936002)(8676002)(54906003)(316002)(7416002)(2906002)(41300700001)(70206006)(110136005)(70586007)(83380400001)(16526019)(336012)(426003)(2616005)(26005)(1076003)(5660300002)(40460700003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 06:37:25.5590
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ece7b02c-8dba-49e7-363c-08dbd912ae11
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB77.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146

In preparation for providing a new API to the sev-guest driver for sending
an SNP guest message, move the SNP command mutex to the snp_guest_dev
structure.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 68044c436866..85bda0c72a27 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -35,6 +35,9 @@ struct snp_guest_dev {
 	struct device *dev;
 	struct miscdevice misc;
 
+	/* Mutex to serialize the shared buffer access and command handling. */
+	struct mutex cmd_mutex;
+
 	void *certs_data;
 	struct aesgcm_ctx *ctx;
 	/* request and response are in unencrypted memory */
@@ -98,7 +101,7 @@ static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 {
 	u64 count;
 
-	lockdep_assert_held(&snp_cmd_mutex);
+	lockdep_assert_held(&snp_dev->cmd_mutex);
 
 	/* Read the current message sequence counter from secrets pages */
 	count = *snp_dev->os_area_msg_seqno;
@@ -394,7 +397,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	struct snp_report_req req;
 	int rc, resp_len;
 
-	lockdep_assert_held(&snp_cmd_mutex);
+	lockdep_assert_held(&snp_dev->cmd_mutex);
 
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
@@ -434,7 +437,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
 
-	lockdep_assert_held(&snp_cmd_mutex);
+	lockdep_assert_held(&snp_dev->cmd_mutex);
 
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
@@ -472,7 +475,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	struct snp_report_resp *resp;
 	int ret, npages = 0, resp_len;
 
-	lockdep_assert_held(&snp_cmd_mutex);
+	lockdep_assert_held(&snp_dev->cmd_mutex);
 
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
@@ -557,12 +560,12 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 	if (!input.msg_version)
 		return -EINVAL;
 
-	mutex_lock(&snp_cmd_mutex);
+	mutex_lock(&snp_dev->cmd_mutex);
 
 	/* Check if the VMPCK is not empty */
 	if (is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
-		mutex_unlock(&snp_cmd_mutex);
+		mutex_unlock(&snp_dev->cmd_mutex);
 		return -ENOTTY;
 	}
 
@@ -580,7 +583,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 		break;
 	}
 
-	mutex_unlock(&snp_cmd_mutex);
+	mutex_unlock(&snp_dev->cmd_mutex);
 
 	if (input.exitinfo2 && copy_to_user(argp, &input, sizeof(input)))
 		return -EFAULT;
@@ -699,6 +702,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		goto e_unmap;
 	}
 
+	mutex_init(&snp_dev->cmd_mutex);
 	platform_set_drvdata(pdev, snp_dev);
 	snp_dev->dev = dev;
 	snp_dev->layout = layout;
-- 
2.34.1


