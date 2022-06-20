Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43B755278B
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346047AbiFTXFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346250AbiFTXEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:04:54 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46175220FA;
        Mon, 20 Jun 2022 16:04:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUZBHIG29wv6Ry88fXRxMG4F72tZIEjEUh/3wA/g1BaGfg9U9z5PXkPuzTgb6OtIP4mjACg/s0tI6sDy2LHa3e0m62WPds9xu1wf1XbEIyNfNzY9gIWv/MgNZBwTvdUZ/EmIVkUhRxW2qWc2a1sfGps9ED/NZHnZunEP5rgJOIXmDMTNyOx/evAStArkfMXqtzgMajXFK4qI+4jvmj2Rj5V6jDBVSklMnpLaerjBc6moKG6oLR6fJ9deNOAlVyQN9AqUcdJxXGmhT0LAEE0KbjuCJQWR8Fb9mOILoKoXpsiCw5mb2XQj+A6BN2dE/ZFj+/oEyvdFfge4T9SAoWfyQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4TzXRpqxmsWIFrvbENJ7JCK8S9OXGnOPgetHzcxZxA=;
 b=EWHLDRIZxNwIn+Ydmae2XUIEA1HCYNcYPye67uhp1FkPdD2zBby8MMrhtB9i/rdIUzFd3shaDgu5P3Nz8/AKxfndCZ+9i2xGmSRYH5oQVcjz3gPt5guTKccDSaNLlDM3aCqPgTDiIbtDyfHW3fsilPkF56D7o3zzEBMWJtlGpKieijC0d5tCycMGDZzrav0WsL8e5M2cvytpV6ldhLkMh+KSfZogBvP4DXv5/9LWpqfO/sVNnnzJ1UkOtORscaTfIaWK6YeuDNd6G8I7tHQqniSYZ/WVAECU/oWfEB3/cIgAA5COTBnCUpZ/MQwK2e5K5WzPrmWZfw3UiND7WIeaEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4TzXRpqxmsWIFrvbENJ7JCK8S9OXGnOPgetHzcxZxA=;
 b=kv6Y2/+SN8b74JabfQScd1L7gZJSW2qx59GYR2r2uBB8wP9JaGHFy+ajNCiOuyH3imIhJ0aDa1t8nOyAX4Zi09kJKDQ+pkDx7dIyujWnKf8O+rGProfFRez9pSqi5Enk/pT5XDYbDJ6NIdg9RrCz1s5wyWJ0/5im0dIXf2WHepY=
Received: from SA1PR03CA0024.namprd03.prod.outlook.com (2603:10b6:806:2d3::25)
 by BL0PR12MB4849.namprd12.prod.outlook.com (2603:10b6:208:1c2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 20 Jun
 2022 23:04:41 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:806:2d3:cafe::90) by SA1PR03CA0024.outlook.office365.com
 (2603:10b6:806:2d3::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:04:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:04:40 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:04:38 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 12/49] crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
Date:   Mon, 20 Jun 2022 23:04:29 +0000
Message-ID: <87a0481526e66ddd5f6192cbb43a50708aee2883.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea96ad5e-83d6-45ac-6bff-08da5311418e
X-MS-TrafficTypeDiagnostic: BL0PR12MB4849:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB4849B97BC1AE9931B09A3F9D8EB09@BL0PR12MB4849.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dOEDVSWsjviwPMpaJtUXlesxwtl//w4tMSwdNUt1pQDi8bxfrTAbByDt8YXpff3xbUn82UEZDNexdUo3MnLehd+nlClDHJ2cMPTNhtWiN/1pxR+w48QoDmkl6UH8OVmdXoqCV3lERJ2WC8TlX/zZdVu5S+VG3uL2GscsjftlutOikhjBGfI+e2sjnRAT7b1Aq8FvBY/knvsa+qio5C5KZ6FkgQDK5LMfX3N76ZAYyd53TUMn4dzh2arVyJQ8/2k61AcOs6tu0cpUDY0NGHqOf/cFzPV6qRlrvoPRVuEC4mrxdKw50aJyaUgePpGEZHmgfwaiYUfyLj7TqkETXalKHaEOSSi2kwXPzbwiit152mUENVWhm9Y88bUuez0lQicCcIxJgD4PLbPesqrMTiTFGBoV2vDgPIDheHVzYSzSTOLgDgCRWYrgm4Zm3eZoni5745G2uoyuh4PPcO6vXmWJytz9agFZ4/jqMo9GjIBEU1iiT5puqtzUtGvAYPWSaP7fnN8viVr5ULfQr95VQ0+9zeFRHZjsxABmGewkWUzkOZRfdKQpOPnsgaYEHTZvCNZ2/MJ1Qt8gTeSBIY9BojOEb7meSFm1Di2/E2eG/BZRN7C1i6f8/xVsAj9aSLsbpDIkT/chFjd3BDW+aZzTWPA0FfzTGNXVNLxumiK6YroKhzyzfhsRk0SBvB448xv/UFpsgYIfDjNUVB+DWYYslxT0QcowmVlAVvvLFxRKOQBC/mKyrKcj0h/L8cR2Aq0MDg29MBPT7cIIIeB2uuLd4weiKby98pZvAf7Ti5977mL8Juc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(346002)(376002)(40470700004)(36840700001)(46966006)(356005)(26005)(2616005)(7696005)(86362001)(47076005)(82740400003)(6666004)(426003)(40460700003)(41300700001)(81166007)(83380400001)(16526019)(336012)(316002)(186003)(7416002)(70206006)(8676002)(110136005)(4326008)(5660300002)(8936002)(7406005)(82310400005)(36756003)(40480700001)(478600001)(2906002)(70586007)(54906003)(36860700001)(2101003)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:04:40.4655
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea96ad5e-83d6-45ac-6bff-08da5311418e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4849
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Before SNP VMs can be launched, the platform must be appropriately
configured and initialized. Platform initialization is accomplished via
the SNP_INIT command. Make sure to do a WBINVD and issue DF_FLUSH command
to prepare for the first SNP guest launch after INIT.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 121 +++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |   2 +
 include/linux/psp-sev.h      |  16 +++++
 3 files changed, 139 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9cb3265f3bef..f1173221d0b9 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -33,6 +33,10 @@
 #define SEV_FW_FILE		"amd/sev.fw"
 #define SEV_FW_NAME_SIZE	64
 
+/* Minimum firmware version required for the SEV-SNP support */
+#define SNP_MIN_API_MAJOR	1
+#define SNP_MIN_API_MINOR	51
+
 static DEFINE_MUTEX(sev_cmd_mutex);
 static struct sev_misc_dev *misc_dev;
 
@@ -775,6 +779,98 @@ static int sev_update_firmware(struct device *dev)
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
+	if (sev->snp_inited)
+		return 0;
+
+	/*
+	 * The SNP_INIT requires the MSR_VM_HSAVE_PA must be set to 0h
+	 * across all cores.
+	 */
+	on_each_cpu(snp_set_hsave_pa, NULL, 1);
+
+	/* Issue the SNP_INIT firmware command. */
+	rc = __sev_do_cmd_locked(SEV_CMD_SNP_INIT, NULL, error);
+	if (rc)
+		return rc;
+
+	/* Prepare for first SNP guest launch after INIT */
+	wbinvd_on_all_cpus();
+	rc = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
+	if (rc)
+		return rc;
+
+	sev->snp_inited = true;
+	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
+
+	return rc;
+}
+
+int sev_snp_init(int *error)
+{
+	int rc;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENODEV;
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
+	if (!sev->snp_inited)
+		return 0;
+
+	/* SHUTDOWN requires the DF_FLUSH */
+	wbinvd_on_all_cpus();
+	__sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
+
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN, NULL, error);
+	if (ret) {
+		dev_err(sev->dev, "SEV-SNP firmware shutdown failed\n");
+		return ret;
+	}
+
+	sev->snp_inited = false;
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
@@ -1231,6 +1327,8 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 			   get_order(NV_LENGTH));
 		sev_init_ex_buffer = NULL;
 	}
+
+	sev_snp_shutdown(NULL);
 }
 
 void sev_dev_destroy(struct psp_device *psp)
@@ -1287,6 +1385,26 @@ void sev_pci_init(void)
 		}
 	}
 
+	/*
+	 * If boot CPU supports the SNP, then first attempt to initialize
+	 * the SNP firmware.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP)) {
+		if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
+			dev_err(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
+				SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
+		} else {
+			rc = sev_snp_init(&error);
+			if (rc) {
+				/*
+				 * If we failed to INIT SNP then don't abort the probe.
+				 * Continue to initialize the legacy SEV firmware.
+				 */
+				dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
+			}
+		}
+	}
+
 	/* Obtain the TMR memory area for SEV-ES use */
 	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
 	if (!sev_es_tmr)
@@ -1302,6 +1420,9 @@ void sev_pci_init(void)
 		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
 			error, rc);
 
+	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_inited ?
+		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
+
 	return;
 
 err:
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 666c21eb81ab..186ad20cbd24 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -52,6 +52,8 @@ struct sev_device {
 	u8 build;
 
 	void *cmd_buf;
+
+	bool snp_inited;
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 01ba9dc46ca3..ef4d42e8c96e 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -769,6 +769,20 @@ struct sev_data_snp_init_ex {
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
@@ -876,6 +890,8 @@ sev_platform_status(struct sev_user_data_status *status, int *error) { return -E
 
 static inline int sev_platform_init(int *error) { return -ENODEV; }
 
+static inline int sev_snp_init(int *error) { return -ENODEV; }
+
 static inline int
 sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENODEV; }
 
-- 
2.25.1

