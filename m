Return-Path: <kvm+bounces-5349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE2B1820736
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:25:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48C881F21D99
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B82C13C;
	Sat, 30 Dec 2023 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QmX/Yjqr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2050.outbound.protection.outlook.com [40.107.100.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081BFFBFE;
	Sat, 30 Dec 2023 16:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3wus2I+oZfeiTMGyAW0MKraHBbIyn5xzi+mrdSUcfagUHN+CrTSQf2HQrS/lWEbPRbIUWFQpeb+Wvs8cmr/PPPOPozW60+YX0uvQqMV/jU3m9fp+Va6TehKP87gDBni9ve4EjaZzUiRccj9/wjXidFy//ujervMqcoWQ6HiGI9u9xZ0QtT0d3CncE6V1m/IUoKQ5Z1uyoEIQJdU7KY247ESt3XuPRiJa08LNvgT/qWIgKcuWE3jbCZ4rXf9Hd3QrRzQQdvYs9XUM2BjCvTaiPrz5/wEgUOGo+aCcmHrn0wDJQOgHEIGl06JFdpw/QDjwuYrG+glGW6mWd4hTrpUUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEk0+IzwZGy9xFQjrjfBF8jkhlEhy3f8QRJ7bygRWC0=;
 b=jbcd08JI8E4VbfsehsUYn54Ma4bJzgcZdzq0qHo1nem+TuSjGV4yp53cC/yFCsuobRrPfAF7kU0rIIXOPhl9+o3/QnBOEp/MclYCx7KPE3tcEpd1P/1AQqy2TXc3cjqpoJiO8dL4Kwi5MR9kPb2cvFvQ1BbZAMVgQbvLjjErxRBT26JBWyKk34WTMxYi9w9wXdig7V394H5F5oVevG+KsIY9kLnxIjxfkFRWMWeLZPzf95UUWZa5dvVWnrWQuFabEPoYBZ/t/H6n6WxSUlhqswZeNqo3mEYXWKBG0hbthTwrX139kHcm57DMofEZvRh0uR+BNQjK3rtWH2kRejd+VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEk0+IzwZGy9xFQjrjfBF8jkhlEhy3f8QRJ7bygRWC0=;
 b=QmX/YjqrP7oQvCb8eBeOFlGJ+IshFPV9qshiVhvEAOcKliWeslfnmPEwcwaBIPv3bDhScXt5AIFISAYClNbSVpY4cBYZW1cgnEl104WBcmtu44P0QDyivQvV2uB9lOXijMc0AVBz/sOR68vjJtwC/BJA4rD4ABXBLMJIrejJr6Y=
Received: from DM6PR13CA0007.namprd13.prod.outlook.com (2603:10b6:5:bc::20) by
 CY5PR12MB6081.namprd12.prod.outlook.com (2603:10b6:930:2b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.20; Sat, 30 Dec 2023 16:23:30 +0000
Received: from DS3PEPF000099E2.namprd04.prod.outlook.com
 (2603:10b6:5:bc:cafe::7a) by DM6PR13CA0007.outlook.office365.com
 (2603:10b6:5:bc::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.7 via Frontend
 Transport; Sat, 30 Dec 2023 16:23:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E2.mail.protection.outlook.com (10.167.17.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:23:30 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:23:29 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v1 14/26] crypto: ccp: Provide API to issue SEV and SNP commands
Date: Sat, 30 Dec 2023 10:19:42 -0600
Message-ID: <20231230161954.569267-15-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230161954.569267-1-michael.roth@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E2:EE_|CY5PR12MB6081:EE_
X-MS-Office365-Filtering-Correlation-Id: e76e24b9-bb9e-465e-f901-08dc0953a93b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	O6WPOImbkKCsKrgxBHsMsTyxPXaDxeXZuQTCwT/59hI1Lp4/JDQJGg+aW+Y9sv92Ln/al7BL9bureRuxNwmUntnrbMjwpQW9zKy/sIsRviIlw4mGjWzyJjBt2sGmiykv2VdFzTpI3aUHtQRejj8CoRUMeikXC17nkxgX+FbVHvmQd0b3Jz95BI94WgT4GYQEVxZiXM4AQBZb1LFQm2Ilk3xq213oX9wZFT5zqFkShv6y+Hhhy4/O0wJ+CVdnexdOzJrVbY58ZrQAlHJE61zZFSajDLHSfTpJ592Ab4k3hTVluACuqHbwAZNAER6hZJc5t3Dh4brAuGlmglJdn/jy8D/ZBWZ5E3izIZrfCOlqQgmvF2pK7VBZez13dQNsx+8WPNzEt+poNwGKVPH670YCH3cqyOv1bKRXOlWbZVFivyse9Eq06sM2yMIJp3N0hX6ew7hMVjFqiHgc6xWnKVsFsTH0Bo4N9UQ2tECWb2Qkl1RSw9dwHeqXQvjezBV8UJySS6/xu4zYZ9aGVJwHEEbfSvYH66pLo+anVbzz6ZZ4qNi6dU0+esCP9cZqByKzksBKKFzFvkX3/MvQbveK6E5Uxwb9wUqSJy8nDSt3nFvtSDHkT1dZ2FWJXv/4YWjhkc+HeuXcmUXGm8o1/oIeXQJpFugAQIlNngVg2Axm6zCusOA/UEdSqpTVMJGak+hYR6LWup6IvsJ4Yqujtl1zjdjSU3VvZA+jLV05l+kG5MjOsekdAozif99VAb+cde8iPleQJQtw2eedWcVJjYJxyCbot3DV17ncRVgxFmS/tJ7vT+c=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(39860400002)(346002)(396003)(230922051799003)(82310400011)(64100799003)(186009)(451199024)(1800799012)(36840700001)(46966006)(40470700004)(36756003)(40480700001)(40460700003)(6916009)(70206006)(70586007)(86362001)(6666004)(1076003)(81166007)(82740400003)(356005)(26005)(8936002)(2616005)(41300700001)(83380400001)(47076005)(426003)(5660300002)(7416002)(2906002)(4326008)(44832011)(7406005)(478600001)(36860700001)(316002)(336012)(8676002)(54906003)(16526019)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:23:30.5201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e76e24b9-bb9e-465e-f901-08dc0953a93b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6081

From: Brijesh Singh <brijesh.singh@amd.com>

Export sev_do_cmd() as a generic API for the hypervisor to issue
commands to manage an SEV and SNP guest. The commands for SEV and SNP
are defined in the SEV and SEV-SNP firmware specifications.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: kernel-doc fixups]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c |  3 ++-
 include/linux/psp-sev.h      | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 85634d4f8cfe..767f0ec3d5bb 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -431,7 +431,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	return ret;
 }
 
-static int sev_do_cmd(int cmd, void *data, int *psp_ret)
+int sev_do_cmd(int cmd, void *data, int *psp_ret)
 {
 	int rc;
 
@@ -441,6 +441,7 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(sev_do_cmd);
 
 static int __sev_init_locked(int *error)
 {
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index a39a9e5b5bc4..0581f194cdd0 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -914,6 +914,22 @@ int sev_guest_df_flush(int *error);
  */
 int sev_guest_decommission(struct sev_data_decommission *data, int *error);
 
+/**
+ * sev_do_cmd - issue an SEV or an SEV-SNP command
+ *
+ * @cmd: SEV or SEV-SNP firmware command to issue
+ * @data: arguments for firmware command
+ * @psp_ret: SEV command return code
+ *
+ * Returns:
+ * 0 if the SEV successfully processed the command
+ * -%ENODEV    if the PSP device is not available
+ * -%ENOTSUPP  if PSP device does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if PSP device returned a non-zero return code
+ */
+int sev_do_cmd(int cmd, void *data, int *psp_ret);
+
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
@@ -929,6 +945,9 @@ sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENO
 static inline int
 sev_guest_decommission(struct sev_data_decommission *data, int *error) { return -ENODEV; }
 
+static inline int
+sev_do_cmd(int cmd, void *data, int *psp_ret) { return -ENODEV; }
+
 static inline int
 sev_guest_activate(struct sev_data_activate *data, int *error) { return -ENODEV; }
 
-- 
2.25.1


