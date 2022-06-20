Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C834A5527A2
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345821AbiFTXHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346218AbiFTXG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:06:57 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80A822B23;
        Mon, 20 Jun 2022 16:06:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjpD2i6+rbCQTelEqP/Ev2pl7WrNQbYnBIl4AEwQA9Wv/6oeoIN3PIdDJOPNWcmgMBbmvcTj2+j3IyO8q7CD6CatJRPNE1yqxcUm0vYaK/hYVf381s9X1plY9VfmYPlLRA9+kDrf/I3uBW/J2EflwpliapTXxVWAy/WgkzKpr4mlDGkrABGVPHZ1EAoOLLzo+84ZzhUVPfuTdut8wqWr/BJEwyhDCdnsWsyhtc8DZIJ0khmQawMO5E63umYcYkqz7rkZ0j1rICYSR4s/S/i39/URY/bpA3XMU1Q4bgofNd9vtaoO0VC3aqvcyY+tiHjNr2oXn/d5I8i9VNa/Zaxymg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNJky2ig5g3XY00irttWjlvM/y3Pvi8oO3HZdYacZcc=;
 b=fSDFr6IGP3x471sQwP6J1wepz+eDXRb2g14mgOibGHdgs+eJF130GFvyK7zMnI1aQIGhuYX4sqhrN7v/LdCaIydURkODeOLTiryzHVOVHJ/ejEmx9B4OgQzDKeepYniudNbd4NRmrYWZVSXadDbysvU0ultbRpSzrWCst2XoQvYLel/IRVzYo+cKFoo81NCKBr9fqTuNujiad7Si7aB6rF++RlWPQXMINIaftlqQZ2ZHVLfE4pSxyfCPLi+euUZS+tPl+o7uShCHqSDK+EjUNNsktaLiGtatkDRROyiiur+TxmOHC7H/s1gn03fLwQr2Om9sE8hkhda9jnjFeC98jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNJky2ig5g3XY00irttWjlvM/y3Pvi8oO3HZdYacZcc=;
 b=vUOUQ3eM3FXA+xswG/cxdUEUGYEJ/cTSgPh9t3qehqNLJJ4I7+DNtX2UdXizOCP/Ld0QG2RRPIAZSZJmAJBts31R/gwAb98NZuNNuDgynl3M8j9B/hxgVqIJxqyBlMI69FSHRHkzmQ9yakYedfbAHsQCX4kkr33x04OhzvqS5hE=
Received: from DM6PR01CA0011.prod.exchangelabs.com (2603:10b6:5:296::16) by
 BY5PR12MB4854.namprd12.prod.outlook.com (2603:10b6:a03:1d1::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.15; Mon, 20 Jun 2022 23:06:01 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::c4) by DM6PR01CA0011.outlook.office365.com
 (2603:10b6:5:296::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20 via Frontend
 Transport; Mon, 20 Jun 2022 23:06:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:06:01 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:05:58 -0500
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
Subject: [PATCH Part2 v6 17/49] crypto: ccp: Add the SNP_{SET,GET}_EXT_CONFIG command
Date:   Mon, 20 Jun 2022 23:05:50 +0000
Message-ID: <d325cb5d7961f015400999dda7ee8e08e4ca2ec6.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6ee0d2e0-6943-4329-1006-08da531171b3
X-MS-TrafficTypeDiagnostic: BY5PR12MB4854:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB48543D919DE7A0875A2508088EB09@BY5PR12MB4854.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mi5Toxe78ARw9kwBCElEsa8E/Am4HRNM0QlMBw3eAS7rk4szC6octAarhQfNZ/XFD87x/QS5b6sfw5awXpjC95wB6WNl12dlLZFXDHVSVz12Q1IzILpKlvZsRHD2SN8IS7AsWYBf3sqRSlU6vi9FyHOEizQCk8hpGpeT3yYr0bKJOkOV1erOHZCVbmWojwNxmmzD7kMXsTJDh6GMCWk5qsPtU15mNKt7TiQlCDmfRVTPgqW3fvqsMQRcewPwp1qtvmUySjxEOTPtfHRC6Ln+lMpsDTG7NJ1VQcyTJdN90YSpvspQiyEvp39VA6SqN0+DkePamibSyuBGYIgOnAd3lIeBvTB0T7cy7OqqiEB84rEOAUMwUtkuebRoOje0lmy1BCsYCruJaUzy1gocXXyPKbPySencKLMpftCo1LIabAW9s/ksnEdfumEtoMaLqSfmGXzRpQJCsrtjR2DmKIf/CoY0PRGoA+lOvrO2UQPITeVOTCnGJ7wK04vR5FPDxbpuVf38sHWReoySwt5pzauv2eDGjhvXrAFMhrUR8ciaQBYtbZOLvvLs/0edzVlOJQ8lMoH1j8D6J42/bYtd02B8gGI0mrBb6tBo0w2/1fsoH0gf3bppPNvm181khVAe8EVPEiBxvAiDcu440PUxZ3Y+9V4qnsiqCIYu63j2tsK+Y+IaMprcv2HzLlP6zpke15/pOp8XSCYCkIrh2fnbZM7P7s8wrg3rVZj238uouzZNQo+MKJSv84Rhe2CdZ2fTZG7wt6A8bHltmtCiN/KPqJrq1Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(136003)(396003)(46966006)(36840700001)(40470700004)(426003)(16526019)(5660300002)(47076005)(336012)(186003)(7406005)(7416002)(316002)(86362001)(82310400005)(2616005)(6666004)(36860700001)(41300700001)(83380400001)(8936002)(82740400003)(8676002)(4326008)(70586007)(40460700003)(81166007)(70206006)(2906002)(54906003)(40480700001)(36756003)(478600001)(110136005)(7696005)(356005)(26005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:06:01.2518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ee0d2e0-6943-4329-1006-08da531171b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4854
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

The SEV-SNP firmware provides the SNP_CONFIG command used to set the
system-wide configuration value for SNP guests. The information includes
the TCB version string to be reported in guest attestation reports.

Version 2 of the GHCB specification adds an NAE (SNP extended guest
request) that a guest can use to query the reports that include additional
certificates.

In both cases, userspace provided additional data is included in the
attestation reports. The userspace will use the SNP_SET_EXT_CONFIG
command to give the certificate blob and the reported TCB version string
at once. Note that the specification defines certificate blob with a
specific GUID format; the userspace is responsible for building the
proper certificate blob. The ioctl treats it an opaque blob.

While it is not defined in the spec, but let's add SNP_GET_EXT_CONFIG
command that can be used to obtain the data programmed through the
SNP_SET_EXT_CONFIG.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 Documentation/virt/coco/sevguest.rst |  27 +++++++
 drivers/crypto/ccp/sev-dev.c         | 115 +++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h         |   3 +
 include/uapi/linux/psp-sev.h         |  17 ++++
 4 files changed, 162 insertions(+)

diff --git a/Documentation/virt/coco/sevguest.rst b/Documentation/virt/coco/sevguest.rst
index 11ea67c944df..3014de47e4ce 100644
--- a/Documentation/virt/coco/sevguest.rst
+++ b/Documentation/virt/coco/sevguest.rst
@@ -145,6 +145,33 @@ The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
 status includes API major, minor version and more. See the SEV-SNP
 specification for further details.
 
+2.5 SNP_SET_EXT_CONFIG
+----------------------
+:Technology: sev-snp
+:Type: hypervisor ioctl cmd
+:Parameters (in): struct sev_data_snp_ext_config
+:Returns (out): 0 on success, -negative on error
+
+The SNP_SET_EXT_CONFIG is used to set the system-wide configuration such as
+reported TCB version in the attestation report. The command is similar to
+SNP_CONFIG command defined in the SEV-SNP spec. The main difference is the
+command also accepts an additional certificate blob defined in the GHCB
+specification.
+
+If the certs_address is zero, then previous certificate blob will deleted.
+For more information on the certificate blob layout, see the GHCB spec
+(extended guest request message).
+
+2.6 SNP_GET_EXT_CONFIG
+----------------------
+:Technology: sev-snp
+:Type: hypervisor ioctl cmd
+:Parameters (in): struct sev_data_snp_ext_config
+:Returns (out): 0 on success, -negative on error
+
+The SNP_SET_EXT_CONFIG is used to query the system-wide configuration set
+through the SNP_SET_EXT_CONFIG.
+
 3. SEV-SNP CPUID Enforcement
 ============================
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index b9b6fab31a82..97b479d5aa86 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1312,6 +1312,10 @@ static int __sev_snp_shutdown_locked(int *error)
 	if (!sev->snp_inited)
 		return 0;
 
+	/* Free the memory used for caching the certificate data */
+	kfree(sev->snp_certs_data);
+	sev->snp_certs_data = NULL;
+
 	/* SHUTDOWN requires the DF_FLUSH */
 	wbinvd_on_all_cpus();
 	__sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
@@ -1616,6 +1620,111 @@ static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static int sev_ioctl_snp_get_config(struct sev_issue_cmd *argp)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_user_data_ext_snp_config input;
+	int ret;
+
+	if (!sev->snp_inited || !argp->data)
+		return -EINVAL;
+
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
+
+	/* Copy the TCB version programmed through the SET_CONFIG to userspace */
+	if (input.config_address) {
+		if (copy_to_user((void * __user)input.config_address,
+				 &sev->snp_config, sizeof(struct sev_user_data_snp_config)))
+			return -EFAULT;
+	}
+
+	/* Copy the extended certs programmed through the SNP_SET_CONFIG */
+	if (input.certs_address && sev->snp_certs_data) {
+		if (input.certs_len < sev->snp_certs_len) {
+			/* Return the certs length to userspace */
+			input.certs_len = sev->snp_certs_len;
+
+			ret = -ENOSR;
+			goto e_done;
+		}
+
+		if (copy_to_user((void * __user)input.certs_address,
+				 sev->snp_certs_data, sev->snp_certs_len))
+			return -EFAULT;
+	}
+
+	ret = 0;
+
+e_done:
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
+static int sev_ioctl_snp_set_config(struct sev_issue_cmd *argp, bool writable)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_user_data_ext_snp_config input;
+	struct sev_user_data_snp_config config;
+	void *certs = NULL;
+	int ret = 0;
+
+	if (!sev->snp_inited || !argp->data)
+		return -EINVAL;
+
+	if (!writable)
+		return -EPERM;
+
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
+
+	/* Copy the certs from userspace */
+	if (input.certs_address) {
+		if (!input.certs_len || !IS_ALIGNED(input.certs_len, PAGE_SIZE))
+			return -EINVAL;
+
+		certs = psp_copy_user_blob(input.certs_address, input.certs_len);
+		if (IS_ERR(certs))
+			return PTR_ERR(certs);
+	}
+
+	/* Issue the PSP command to update the TCB version using the SNP_CONFIG. */
+	if (input.config_address) {
+		if (copy_from_user(&config,
+				   (void __user *)input.config_address, sizeof(config))) {
+			ret = -EFAULT;
+			goto e_free;
+		}
+
+		ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
+		if (ret)
+			goto e_free;
+
+		memcpy(&sev->snp_config, &config, sizeof(config));
+	}
+
+	/*
+	 * If the new certs are passed then cache it else free the old certs.
+	 */
+	if (certs) {
+		kfree(sev->snp_certs_data);
+		sev->snp_certs_data = certs;
+		sev->snp_certs_len = input.certs_len;
+	} else {
+		kfree(sev->snp_certs_data);
+		sev->snp_certs_data = NULL;
+		sev->snp_certs_len = 0;
+	}
+
+	return 0;
+
+e_free:
+	kfree(certs);
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -1670,6 +1779,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SNP_PLATFORM_STATUS:
 		ret = sev_ioctl_snp_platform_status(&input);
 		break;
+	case SNP_SET_EXT_CONFIG:
+		ret = sev_ioctl_snp_set_config(&input, writable);
+		break;
+	case SNP_GET_EXT_CONFIG:
+		ret = sev_ioctl_snp_get_config(&input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index fe5d7a3ebace..d2fe1706311a 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -66,6 +66,9 @@ struct sev_device {
 
 	bool snp_inited;
 	struct snp_host_map snp_host_map[MAX_SNP_HOST_MAP_BUFS];
+	void *snp_certs_data;
+	u32 snp_certs_len;
+	struct sev_user_data_snp_config snp_config;
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index ffd60e8b0a31..60e7a8d1a18e 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -29,6 +29,8 @@ enum {
 	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
 	SEV_GET_ID2,
 	SNP_PLATFORM_STATUS,
+	SNP_SET_EXT_CONFIG,
+	SNP_GET_EXT_CONFIG,
 
 	SEV_MAX,
 };
@@ -190,6 +192,21 @@ struct sev_user_data_snp_config {
 	__u8 rsvd[52];
 } __packed;
 
+/**
+ * struct sev_data_snp_ext_config - system wide configuration value for SNP.
+ *
+ * @config_address: address of the struct sev_user_data_snp_config or 0 when
+ *		reported_tcb does not need to be updated.
+ * @certs_address: address of extended guest request certificate chain or
+ *              0 when previous certificate should be removed on SNP_SET_EXT_CONFIG.
+ * @certs_len: length of the certs
+ */
+struct sev_user_data_ext_snp_config {
+	__u64 config_address;		/* In */
+	__u64 certs_address;		/* In */
+	__u32 certs_len;		/* In */
+};
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.25.1

