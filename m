Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2F3347EA0
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbhCXRFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:42 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:50400
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237021AbhCXRFB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HxoCSNWs7xHF/VQDpAg8rjazhzEr8w4kTXJyATM4HqVKyxRq5RRKjTbB0Tf2OOvz6yRoeduaCg+4qKNOxlKOaqgzruvdsc6sRyyaslj553zJzzI338kEySLhLWlBzlbCDEF+9sTx7Dnn2UASeeKS18FEw9aGiIlhzsD85T86+6H9tqXQbtwSPd2VF1W0J0tBwqnFuTFiNQqYd1DMEzFkwdd+/VCnyhhFKOML+34qBAgT+cItz0in/H62oBNKOIiW5r9R8p0CKMhdr6THwqItru7yjL6bV2vSJbHRKXcw5Ob0+Bis1j79FIVDpzsjcsiOb/1W2tP42wFzDONgwA7DXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/EcTEZyk7jn3rjLoIyiG4fYKdTet59gdRvYdymkKwvc=;
 b=TS3IcVOxhbqoqaTCOnEQujxJ/Emu/b3o9RAnxssBE/pFypZaX4FB8X89YAkdPmjPr2LaWRXMqPyEIIbL3AGV8OtVRBaaVBGgCLKDlrKQ/6Y3e6UPlx664exHrn/pWWQQQfMRxEwoRtfBbbNFAaxm1j0vyYhCY7bCUL6fB8Umwl6/Y+kzzlIVFQr0jLAd1FXwFQxBs51+0tKyyJ8O3ltbnhOp14Say2gG+39IKOaBdBt7v2AYEqAabSF+zm0MlPeuM8kCjAN/ASIaK6FVzss2kXSIr/2FWRj8cFoqrmw3xnf2JFEJTsRWfQQTDT9O53FEWuR5RqAdR1hpU4il20fnZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/EcTEZyk7jn3rjLoIyiG4fYKdTet59gdRvYdymkKwvc=;
 b=R7Gp81rXLLjGRgQt0opF9uPoTGfPBT5BhegAWfA2yF1c7yGTFX3FNhaxAttve3OudBmwZ9SVQ3We8CnpNXrudrLPEj0PX5xsIos/0zYBcIr67SLE97K+UBpPjqNURFQ1ssNDIp0re4owXYegRAjMAlxKGLLuEj8YG3NVRL5Xmfc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 17:04:58 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:04:58 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part2 PATCH 09/30] crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
Date:   Wed, 24 Mar 2021 12:04:15 -0500
Message-Id: <20210324170436.31843-10-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:04:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0e7fda90-31a5-4bf1-e21e-08d8eee6f43d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45577E0C7AF17016E1FA8FBFE5639@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yl1yPvvYh+nxC+sW9QR2a1LofmL2DPSTjayBZabX2mJNg/jdnopsHzScbXDlhEcKLjSNOA7CmxpIx4HJAmpIjeYKAfW9RnrFB+VAwnqGVSjYX8APi1+eEXPOD2hUpVKqNPWGmCIb4lw727fZVSwptY4b2RVzChpEEBCpv7ueM8dxaBDLqt3HUGFLWgQMsaq1K9wHPebMURvfvWJmnmzP2wwWkDxzgVqeZYEc7cmoaE/B05hrWXx+klOeqbK3Ivq9O8iznjYgZisvZTVrwVLSLikrb7un8Im9MYYe8WnmxsOCTk7PAlmkAZytiVm8ocbzF483YWhtq7KjamFYxSRqkOaOK3GZTDpKIG2lLmy6t/Wg0DOP/cfJKOw8XPWdisl753TauQcsDQbjbAJ9D2eI4AJwesNFHv408B1G9quIDiDCTTLwFcZQ51/5r0gQ9Pkbj6j0/4D/SWP9eBc8okdGXh9KKO1Fp/b2sL54a0HB9oaCsulDZd+3r4EkaJdqCYAfEfFJpbFu6aVIX+1z0do3y8lfWDZkJNnx2/X7IniiANFXJTSo1kXB4b9O9kdeMrzvwMqNHUnvOrJwrj2nmnL6dutDT6lgcOFzUshjjkLEenAMXNN5WrSIDrP5abGS7re58rm9sVZbU1lIkkJWztbiZL4h2Yxt6kmgV/s2fRHQ33Nr3VjoBbVsI4B6MeLbcnz5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(86362001)(54906003)(186003)(44832011)(6666004)(4326008)(38100700001)(26005)(316002)(66476007)(8676002)(16526019)(1076003)(2616005)(83380400001)(5660300002)(6486002)(956004)(52116002)(8936002)(478600001)(7416002)(7696005)(66556008)(36756003)(66946007)(2906002)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7a5YSUo5oy4zenvCQE4V4uGb3HBQCL59aA1uGIVPH37lzBm+rpucfn0lYFhQ?=
 =?us-ascii?Q?Fek8ak/HP2GdkdZoqwfJuL4yfLRcoDlBi1RKtXLNQeuWRUilWVSd2jo/gJrs?=
 =?us-ascii?Q?nQz8dyvFy0MX0zAfHXzYm6dS5IW7h0WCdYtR5mFKkprH6ZfQlfCSQ0uzAKfH?=
 =?us-ascii?Q?/lOnF+1zOLewZoyZ82WVO67x58JKJ/9GGlaY0ej7FuuykGKdC2DQaDQjmPdF?=
 =?us-ascii?Q?hDQM5BsIFmWWJsZ6+SftuyqT9uyPDgfK3frhHDoNqhg1/fCNNCVWYO1qovOy?=
 =?us-ascii?Q?hQBi+ge86j6WHYP1rr9UXj/XQmg2F8XFwueA0qgtx//T3zt5jdoZLvmy5WNi?=
 =?us-ascii?Q?+Dt7BtEosVpesUkTz1v9WvG4nqu8gkJCOo0HRTcxwRDPWzi1i8NSMMPwWmpz?=
 =?us-ascii?Q?GRqCfwH0HKZe68yLfyVqXO8wHK36ftqeKSi1i7mP4VeIRq/x59h61uoSYGev?=
 =?us-ascii?Q?NbeNL1+koTydy/4ci5vpZJ/eFB+G2MD3r5jFkF1HqCVr+tRakadwgssBlCWo?=
 =?us-ascii?Q?y7NZY61GLVKeoBhFMlYQ0bwGGWAfq3K5z0+AR9WLse54/gNiftJIPnwXvZv+?=
 =?us-ascii?Q?nM85oRV+nLhvjwKpNNyF1FhF/g5zSPxNNx6RZBB6vlsk4dcl8WOxeq74Z1Qv?=
 =?us-ascii?Q?2pS4VH7f32IAjmzetllK4mzpl3nlzYc/r1VtK+yvBcK1Qwxmaf2+n94HHMg5?=
 =?us-ascii?Q?PAJk0KPQEpttTfVxxtYGYiUgQcGGhlLXQYDk9ZvkSKIJ8TIhCvfuZFkV7lqw?=
 =?us-ascii?Q?aAKBGdAKBXgWkoT5Ik33tnzrWnwynIZtFXA+X49wbOeiJVrnQuZO+SqOxONk?=
 =?us-ascii?Q?1vda1WVLKsqwKIGXSQkk+steanY6NsKwTT7pdKRBzFjKC5h+hInuiqHRWQhK?=
 =?us-ascii?Q?CpzQQuJbtUJq8CSgXL3E78yOamyrFVpqxKGNNSh3YBm2GdLWDjGO8K89/s5i?=
 =?us-ascii?Q?kvnXLis3zo7MdoF0iYoSEaG+DBCF88s8JumW5npkd2Sb5YLY+cfKridgxwcm?=
 =?us-ascii?Q?qZBP/TpolDVTSHS7AaErNLTChYdOjqgbdXVV3HmzYhovwY1qgwGuPVMlK+nc?=
 =?us-ascii?Q?DgGaU00ZDvDrVeN9m+/PwtE6jJDRCNVRugnDo6vAY447/UE/R9OkDGNj/Xo8?=
 =?us-ascii?Q?rbS10Qc1iVIQlVOsAIRIbq1dkfpE3sGmAElxZ9cUW42nQywI8aQ2VIbJ9ZfW?=
 =?us-ascii?Q?LGxvSwSWvbr/x3j4Itv/bbHuuAectFEt394l3FGcYToB7FjikzhQZ03Y0jZH?=
 =?us-ascii?Q?gwZJNJegewZ0km8eqj3u/h6RG3GmsX4qlHal6JzwcNN0Q5+6OQTASdDD++lz?=
 =?us-ascii?Q?2s5qV0CbtIL6x59wAP9TZDVe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e7fda90-31a5-4bf1-e21e-08d8eee6f43d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:04:58.1919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2YMHuDVYEfRoGPSqBIVD9FiAY/8tI2/wrh+xPExM/Jmrixx5WtESiBgWEm8IkZnmdM/RtE8Rl018qotTGJ+7Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before SNP VMs can be launched, the platform must be appropriately
configured and initialized. Platform initialization is accomplished via
the SNP_INIT command.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 164 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h |   2 +
 include/linux/psp-sev.h      |  16 ++++
 3 files changed, 179 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8a9fd843ad9e..c983a8b040c3 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -21,8 +21,10 @@
 #include <linux/ccp.h>
 #include <linux/firmware.h>
 #include <linux/gfp.h>
+#include <linux/mem_encrypt.h>
 
 #include <asm/smp.h>
+#include <asm/sev-snp.h>
 
 #include "psp-dev.h"
 #include "sev-dev.h"
@@ -30,6 +32,7 @@
 #define DEVICE_NAME		"sev"
 #define SEV_FW_FILE		"amd/sev.fw"
 #define SEV_FW_NAME_SIZE	64
+#define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
 static DEFINE_MUTEX(sev_cmd_mutex);
 static struct sev_misc_dev *misc_dev;
@@ -574,6 +577,93 @@ static int sev_update_firmware(struct device *dev)
 	return ret;
 }
 
+static void snp_set_hsave_pa(void *arg)
+{
+	wrmsrl(MSR_VM_HSAVE_PA, 0);
+}
+
+static int __sev_snp_init_locked(int *error)
+{
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
+	int rc = 0;
+
+	if (!psp || !psp->sev_data)
+		return -ENODEV;
+
+	sev = psp->sev_data;
+
+	if (sev->snp_inited && sev->state >= SEV_STATE_INIT)
+		return 0;
+
+	if (!snp_key_active()) {
+		dev_notice(sev->dev, "SNP is not enabled\n");
+		return -ENODEV;
+	}
+
+	/* SNP_INIT requires the MSR_VM_HSAVE_PA must be set to 0h across all cores. */
+	on_each_cpu(snp_set_hsave_pa, NULL, 1);
+
+	/* Prepare for first SEV guest launch after INIT */
+	wbinvd_on_all_cpus();
+
+	/* Issue the SNP_INIT firmware command. */
+	rc = __sev_do_cmd_locked(SEV_CMD_SNP_INIT, NULL, error);
+	if (rc)
+		return rc;
+
+	sev->snp_inited = true;
+	sev->state = SEV_STATE_INIT;
+	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
+
+	return rc;
+}
+
+int sev_snp_init(int *error)
+{
+	int rc;
+
+	mutex_lock(&sev_cmd_mutex);
+	rc = __sev_snp_init_locked(error);
+	mutex_unlock(&sev_cmd_mutex);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(sev_snp_init);
+
+static int __sev_snp_shutdown_locked(int *error)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	int ret;
+
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN, NULL, error);
+	if (ret)
+		return ret;
+
+	wbinvd_on_all_cpus();
+
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
+	if (ret)
+		dev_err(sev->dev, "SEV-SNP firmware DF_FLUSH failed\n");
+
+	sev->snp_inited = false;
+	sev->state = SEV_STATE_UNINIT;
+	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
+
+	return ret;
+}
+
+static int sev_snp_shutdown(int *error)
+{
+	int rc;
+
+	mutex_lock(&sev_cmd_mutex);
+	rc = __sev_snp_shutdown_locked(NULL);
+	mutex_unlock(&sev_cmd_mutex);
+
+	return rc;
+}
+
 static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1043,6 +1133,42 @@ int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
 }
 EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 
+static int sev_snp_firmware_state(void)
+{
+	struct sev_data_snp_platform_status_buf *buf = NULL;
+	struct page *status_page = NULL;
+	int state = SEV_STATE_UNINIT;
+	int rc, error;
+
+	status_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!status_page)
+		return -ENOMEM;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
+	if (!buf) {
+		__free_page(status_page);
+		return -ENOMEM;
+	}
+
+	buf->status_paddr = __sme_page_pa(status_page);
+	rc = sev_do_cmd(SEV_CMD_SNP_PLATFORM_STATUS, buf, &error);
+
+	/*
+	 * The status buffer is allocated as a hypervisor page. As per the SEV spec,
+	 * if the firmware is in INIT state then status buffer must be either a
+	 * the firmware page or the default page. Since our status buffer is in
+	 * the hypervisor page, so, if firmware is in INIT state then we should
+	 * fail with INVALID_PAGE_STATE.
+	 */
+	if (rc && error == SEV_RET_INVALID_PAGE_STATE)
+		state = SEV_STATE_INIT;
+
+	kfree(buf);
+	__free_page(status_page);
+
+	return state;
+}
+
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1052,8 +1178,20 @@ void sev_pci_init(void)
 	if (!sev)
 		return;
 
+	/* Check if the SEV feature is enabled */
+	if (!boot_cpu_has(X86_FEATURE_SEV)) {
+		dev_err(sev->dev, "SEV: Memory Encryption is disabled by the BIOS\n");
+		return;
+	}
+
 	psp_timeout = psp_probe_timeout;
 
+	/* check if SNP firmware is in INIT state, If so shutdown */
+	if (boot_cpu_has(X86_FEATURE_SEV_SNP)) {
+		if (sev_snp_firmware_state() == SEV_STATE_INIT)
+			sev_snp_shutdown(NULL);
+	}
+
 	if (sev_get_api_version())
 		goto err;
 
@@ -1086,6 +1224,21 @@ void sev_pci_init(void)
 			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
 	}
 
+	/*
+	 * If boot CPU supports the SNP, then let first attempt to initialize
+	 * the SNP firmware.
+	 */
+	if (boot_cpu_has(X86_FEATURE_SEV_SNP)) {
+		rc = sev_snp_init(&error);
+		if (rc) {
+			/*
+			 * If we failed to INIT SNP then don't abort the probe.
+			 * Continue to initialize the legacy SEV firmware.
+			 */
+			dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
+		}
+	}
+
 	/* Initialize the platform */
 	rc = sev_platform_init(&error);
 	if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
@@ -1105,8 +1258,8 @@ void sev_pci_init(void)
 		return;
 	}
 
-	dev_info(sev->dev, "SEV API:%d.%d build:%d\n", sev->api_major,
-		 sev->api_minor, sev->build);
+	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_inited ?
+		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
 	return;
 
@@ -1119,7 +1272,12 @@ void sev_pci_exit(void)
 	if (!psp_master->sev_data)
 		return;
 
-	sev_platform_shutdown(NULL);
+	if (boot_cpu_has(X86_FEATURE_SEV))
+		sev_platform_shutdown(NULL);
+
+	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
+		sev_snp_shutdown(NULL);
+
 
 	if (sev_es_tmr) {
 		/* The TMR area was encrypted, flush it from the cache */
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index dd5c4fe82914..18b116a817ff 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -52,6 +52,8 @@ struct sev_device {
 	u8 api_major;
 	u8 api_minor;
 	u8 build;
+
+	bool snp_inited;
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index df89f0207099..ec45c18c3b0a 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -709,6 +709,20 @@ struct sev_data_snp_guest_request {
  */
 int sev_platform_init(int *error);
 
+/**
+ * sev_snp_init - perform SEV SNP_INIT command
+ *
+ * @error: SEV command return code
+ *
+ * Returns:
+ * 0 if the SEV successfully processed the command
+ * -%ENODEV    if the SEV device is not available
+ * -%ENOTSUPP  if the SEV does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if the SEV returned a non-zero return code
+ */
+int sev_snp_init(int *error);
+
 /**
  * sev_platform_status - perform SEV PLATFORM_STATUS command
  *
@@ -816,6 +830,8 @@ sev_platform_status(struct sev_user_data_status *status, int *error) { return -E
 
 static inline int sev_platform_init(int *error) { return -ENODEV; }
 
+static inline int sev_snp_init(int *error) { return -ENODEV; }
+
 static inline int
 sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENODEV; }
 
-- 
2.17.1

