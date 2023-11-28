Return-Path: <kvm+bounces-2599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C5E77FBAAC
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:00:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E237A282BB7
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 13:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4021F57863;
	Tue, 28 Nov 2023 13:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tdCYZoW1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6AB10E6;
	Tue, 28 Nov 2023 05:00:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahWgjj2zt/ANCAZqSUEnnk4pS6HqewVMEhfx8tiAKy/c7n4IEb76exkAG8RJ7oTXPJuzV5XgBpQCnTl3+MUqe6pzrgj5wR/LUBKx4f2KyoeG4vYernRxOqlAdkTrmhpGSeXxYOkExbKN5LpwCda8uIADXxUHkWGfMZ+Y2ZWfznwdQjCwHhidGhCznRsrDNbgxNehiwX4hY9YYV/8FfgpVdkQYcu7v9i+ApX8FrL/ekNO6+uaHG8mzz3YPX4JZSXo8ZgqL1laTzkntXHHVbmO8j73SSHcLjTvApp2UwHe+06G7Gop2UcTErEvpYxG6FczMopxzazyOA47J61QUQ3+Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FobeKRIWyENJYRq0LgNYrV697tvGzj5iPJRquaePZc0=;
 b=nXkGoxqyvfWCKKHP5WmVAc4VhacGT7MlAPr2aMmgrARnPpS3IAClqvZAVcQ+VQZVOUU7aOKoCdv7Cg6b9jzU2BfYiGnUJGbXIS5INO7QLBdCi0NsHhVarcS5YRIC0zZsGsfiyFn1oZux49y4r+P4Mje+7lVXc2zZrLySSUDhTudZxF9ampOl+cejA2pKEakW+7cUNLHr9MgXbaTINd2yIZveyuVDCsLKZyjdznhvxPjWrRq3vCA+ggxqXmZ6h2Iw/N+KyzcOvVx43jELo9IuYZOJ69Uyrq1Biuvhwt0jA6Ca2gjvZJKVKOE74Ky02DGxjp++Wryi3cjJ5cLAJ4fIjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FobeKRIWyENJYRq0LgNYrV697tvGzj5iPJRquaePZc0=;
 b=tdCYZoW1E+KELHjEfIfzfSTnxJkHE+iqpYEB1gHq7zEeQaWQZzQa/ZJ6QSK6AJV23g+ckLWZTKiR8+fu3YEfz4uHk2QxJ/wkH6aW3OuPtTbqzl3HTZQVNcIvRi3fF95WqTfyL0IpWBMnHHXVoleRB6MsX8n0Whl1tDfFnwJ5jw8=
Received: from DM6PR07CA0117.namprd07.prod.outlook.com (2603:10b6:5:330::32)
 by DS7PR12MB8249.namprd12.prod.outlook.com (2603:10b6:8:ea::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Tue, 28 Nov
 2023 13:00:35 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:5:330:cafe::9) by DM6PR07CA0117.outlook.office365.com
 (2603:10b6:5:330::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Tue, 28 Nov 2023 13:00:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.17 via Frontend Transport; Tue, 28 Nov 2023 13:00:34 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 28 Nov
 2023 07:00:30 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v6 02/16] virt: sev-guest: Move mutex to SNP guest device structure
Date: Tue, 28 Nov 2023 18:29:45 +0530
Message-ID: <20231128125959.1810039-3-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|DS7PR12MB8249:EE_
X-MS-Office365-Filtering-Correlation-Id: d5394e54-e4f8-4e62-3f0a-08dbf01202c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	B8MM9UzWLfAzdVlba7i2mkzyYKbm37oiE/4zPcw69cp0Zq1jnXs/Kb3WFSBh7kiK4gqzP6LCirTGI6Chu1pJmHeRo31WOjkoQj3r53BY5oWLzQrCcBUpLmT76UnTLhQ9kLrZ48vK9KTHXq6UXzL5V+76ashd4AY8y7VfTl23mKncgr8W4Nd4hhSpVWu4xBTjYTRA7ukkrXn31OJ2OFiV79ylMfGhEfHVKwKikWtZnRNAc92/y6prqDkg16cULN7Lr0n3lYlaCObOux2CkNe41c+ghv5ezAcx8/kmsBBzVeH11hqj4Li2OPpjT4zE5M0X3Q+fCmi3o2Q5sZ6Cbus0J4W/JpYaOPvaNrJ7NEA8HWNs0MTKxoRGxPEDqy/7Ath50FfTXZLv7KA3laqgertzhPgBwVYhNPCl0O2mZ0F3n8aYrrBWR2m/76ZpF4LsHjLygwl3/mx8a1s21oaDLGjRL1HHByFPFHF5gTpj25UPQC9Q1LrE1pjGZbVs9oOSf/19KlneOtpnrnukhVpm609x+pqLItze2MGxS2+Ja1Pza2NIUJ442pIH77nx3gtbeE9DCwH3xMpH62fwkOvYy+VGPATS71qgeOF6ZtiFSxZqjemYuOf7aImPkgyt152j5jdgZ0DdygZ2V/h4bm67b7agviHGnp5HMZxuA3nFfWAJk5Y5rKau9q7UiQLLMntlfST5ZmDFeR6jgO3qSMIYtRD37du+aojFdTUj90fajKORnfji7Gfvn4fCQfBtHFlz8JJ63Mt9SMLSXWU2eFcAep9AVw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(396003)(136003)(346002)(230922051799003)(64100799003)(451199024)(186009)(82310400011)(1800799012)(36840700001)(46966006)(40470700004)(40460700003)(2616005)(1076003)(26005)(16526019)(6666004)(426003)(336012)(8676002)(5660300002)(8936002)(4326008)(82740400003)(7416002)(47076005)(70206006)(478600001)(316002)(110136005)(70586007)(54906003)(7696005)(36860700001)(83380400001)(356005)(81166007)(41300700001)(40480700001)(36756003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 13:00:34.8874
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5394e54-e4f8-4e62-3f0a-08dbf01202c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8249

In preparation for providing a new API to the sev-guest driver for sending
an SNP guest message, move the SNP command mutex to the snp_guest_dev
structure. Drop the snp_cmd_mutex.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index aedc842781b6..8382fd657e67 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -39,6 +39,9 @@ struct snp_guest_dev {
 	struct device *dev;
 	struct miscdevice misc;
 
+	/* Mutex to serialize the shared buffer access and command handling. */
+	struct mutex cmd_mutex;
+
 	void *certs_data;
 	struct aesgcm_ctx *ctx;
 	/* request and response are in unencrypted memory */
@@ -65,9 +68,6 @@ static u32 vmpck_id;
 module_param(vmpck_id, uint, 0444);
 MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
 
-/* Mutex to serialize the shared buffer access and command handling. */
-static DEFINE_MUTEX(snp_cmd_mutex);
-
 static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
 {
 	char zero_key[VMPCK_KEY_LEN] = {0};
@@ -107,7 +107,7 @@ static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 {
 	u64 count;
 
-	lockdep_assert_held(&snp_cmd_mutex);
+	lockdep_assert_held(&snp_dev->cmd_mutex);
 
 	/* Read the current message sequence counter from secrets pages */
 	count = *snp_dev->os_area_msg_seqno;
@@ -394,7 +394,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	struct snp_report_resp *resp;
 	int rc, resp_len;
 
-	lockdep_assert_held(&snp_cmd_mutex);
+	lockdep_assert_held(&snp_dev->cmd_mutex);
 
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
@@ -434,7 +434,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
 
-	lockdep_assert_held(&snp_cmd_mutex);
+	lockdep_assert_held(&snp_dev->cmd_mutex);
 
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
@@ -475,7 +475,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	int ret, npages = 0, resp_len;
 	sockptr_t certs_address;
 
-	lockdep_assert_held(&snp_cmd_mutex);
+	lockdep_assert_held(&snp_dev->cmd_mutex);
 
 	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
 		return -EINVAL;
@@ -564,12 +564,12 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
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
 
@@ -594,7 +594,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 		break;
 	}
 
-	mutex_unlock(&snp_cmd_mutex);
+	mutex_unlock(&snp_dev->cmd_mutex);
 
 	if (input.exitinfo2 && copy_to_user(argp, &input, sizeof(input)))
 		return -EFAULT;
@@ -702,7 +702,7 @@ static int sev_report_new(struct tsm_report *report, void *data)
 	if (!buf)
 		return -ENOMEM;
 
-	guard(mutex)(&snp_cmd_mutex);
+	guard(mutex)(&snp_dev->cmd_mutex);
 
 	/* Check if the VMPCK is not empty */
 	if (is_vmpck_empty(snp_dev)) {
@@ -837,6 +837,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		goto e_unmap;
 	}
 
+	mutex_init(&snp_dev->cmd_mutex);
 	platform_set_drvdata(pdev, snp_dev);
 	snp_dev->dev = dev;
 	snp_dev->layout = layout;
-- 
2.34.1


