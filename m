Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E9F69D346
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjBTSwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjBTSwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:52:09 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2063.outbound.protection.outlook.com [40.107.96.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189241EBD0;
        Mon, 20 Feb 2023 10:51:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VK2u2gU7jFnYi5+iOA26l2NtAnkVVXv4JC1jqsHo7JxW0MYzKeTiL/icOZFRz4wi7Kflu8CQ0QgtlcL/SMRB9YN8sE9rRvEVITCShTE8YOZAZqG/eDEjFf1z51+C1xC+PoGWGTlHc1tjCMl5JFDJaaQQxq8dWxXO4sfb6YEX9hjead2G/GLNuEeMLJBE1vD6P5oaYOh20feGjROmlTLwLg2DYwZeR2LzQ6e5BZwAXiB8PBb4kzjdqTBygLMdMgbbeyI0s5Gpk50uf/y5kkCihWTMyeYN18W+mlbLascbPoti3TfTza/n5X+PFaXTx0gXpJI+3p+8zXNtD95fFdoblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bu8MBPOdpq1dXgtI8ha3W3qrfw7vuEbfpB8WIhNoZrc=;
 b=mfSTPRX7ypF2MYo+5GnL8zViRwpF0WdN9WNGvnqQm4+B+dlP9ix3Apyf5D+GldBlJgl3M72U3pHCLudo5WITXDi5PS47UdnZhk8zyfJFSV3IZcgiJoIcdF3W5tuXR050PbCNG0qsZpXNFkvRs+50EmmE4kLzYcUwgnsip3on7GaexqppHX1TJzAZi2OVF1hje0eS/CuZOMHNQlQF2Or2Qc2PvKuXKHb/eYwOJoibJJN/DuwglPWTWN/pWM4xlm7aD5Ha6HBn2VXspz12rxrepea3u9ZFDWlA3b4UUAYnleXDEncmcHapyf3Wda5EzqWRhuGKkeJDxdmXQbZS9UqqDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bu8MBPOdpq1dXgtI8ha3W3qrfw7vuEbfpB8WIhNoZrc=;
 b=Ui0Z0zav+fkwyymdrqnt+bFZ4URC+FLH5kk85GEXB8YUmo9oc/n8y0vqCtcB3Nj3doVhVSDYLv/UiXbXUjXuDxvz9BK2YwWxSRkSFHbx1PlyUgY4eNpjBHxn7w0c/WGHwrl85rIOdrw2DLXPiaa415TC/BS6nwFthO3QsfB79D0=
Received: from CY5PR10CA0004.namprd10.prod.outlook.com (2603:10b6:930:1c::19)
 by CH3PR12MB7617.namprd12.prod.outlook.com (2603:10b6:610:140::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Mon, 20 Feb
 2023 18:50:12 +0000
Received: from CY4PEPF0000C966.namprd02.prod.outlook.com
 (2603:10b6:930:1c:cafe::5d) by CY5PR10CA0004.outlook.office365.com
 (2603:10b6:930:1c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:50:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C966.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:50:11 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:50:10 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 27/56] crypto: ccp: Add the SNP_{SET,GET}_EXT_CONFIG command
Date:   Mon, 20 Feb 2023 12:38:18 -0600
Message-ID: <20230220183847.59159-28-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C966:EE_|CH3PR12MB7617:EE_
X-MS-Office365-Filtering-Correlation-Id: f64c5fe2-11b0-4e2e-8ffd-08db13734bd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRNlhby/dnP/ajLaG2sOvEZHNl5BhnzK85xYePjSU/Lzxob1uvS7JOxCAA1r4UFAxw4mCe5NUCwV9Ac+Au6dsWNl+Muf+KvOs7ghV/b7GIrrZrIU/e+lhcQ7XGmDhns3xz0K0dYc4HiA7i6FOeolWIww/Jod/F3FK6Rp2ddP9ZC7FVoMBjXa+ceUNoZD0RvR0l6oYgoAYHhgF0lzj1Ks0UMGrD1H1u84nVpRPI6862B9wDd89ce0vmADwxzDshsBgXqbDNQMxvQRFZGeI7MVf1rIvJYKyjgfcv/Pws/N8W9WJEMxNttkMn2qwR0WTT1ne5bTFKl+AwAprgO5fTUZYa4tX/3QX5KV2w13ksTneD31iTL4T3ITjj96exhacVZPMuXVnzGrs9GyZzpEWs5tIfy/V6BEB/jvo9wdDQ+rCw5NbcGQUUkz9ShbjyVk2PDihfDM6pF1D1bzFHglbRE8xwsqTjcFiA8H9Yv+MH+raXzLHd6j7lW1hRua1ZcE+D5k2Jj7s0CMKpiD/IodI+pU+aHIQv2zgtO1ePbo9xPGyIDCGO+sO9o09fFekW6NgLhu+ucD166/sMRFUXAdGeiVvHK3JOaLm4z/dgbIAyjV3tQJWS52hqsYlDQlL7iGhSa99xL+DjE6OjqddgO1AddtXG1zNRVWrtcJdW0U9EFEE01118UcwweuxoVHSyrTpWwXoq/4RvJYNQ9VUaIoD+xY8MGlOyzHMGaGuZCQ4o7i3Ok=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199018)(40470700004)(36840700001)(46966006)(86362001)(81166007)(44832011)(82740400003)(36860700001)(2906002)(336012)(16526019)(478600001)(186003)(26005)(54906003)(82310400005)(6916009)(36756003)(47076005)(356005)(40480700001)(426003)(8676002)(83380400001)(5660300002)(70206006)(70586007)(40460700003)(4326008)(2616005)(41300700001)(316002)(8936002)(1076003)(7406005)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:50:11.6286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f64c5fe2-11b0-4e2e-8ffd-08db13734bd3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C966.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7617
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/coco/sev-guest.rst |  27 ++++++
 drivers/crypto/ccp/sev-dev.c          | 123 ++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h          |   4 +
 include/uapi/linux/psp-sev.h          |  17 ++++
 4 files changed, 171 insertions(+)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index 11ea67c944df..6cad4226c348 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
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
+If the certs_address is zero, then the previous certificate blob will deleted.
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
+The SNP_GET_EXT_CONFIG is used to query the system-wide configuration set
+through the SNP_SET_EXT_CONFIG.
+
 3. SEV-SNP CPUID Enforcement
 ============================
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 65e13a562f3b..b56b00ca2cd4 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1481,6 +1481,10 @@ static int __sev_snp_shutdown_locked(int *error)
 	data.length = sizeof(data);
 	data.iommu_snp_shutdown = 1;
 
+	/* Free the memory used for caching the certificate data */
+	kfree(sev->snp_certs_data);
+	sev->snp_certs_data = NULL;
+
 	wbinvd_on_all_cpus();
 
 retry:
@@ -1793,6 +1797,118 @@ static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static int sev_ioctl_snp_get_config(struct sev_issue_cmd *argp)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_user_data_ext_snp_config input;
+	int ret;
+
+	if (!sev->snp_initialized || !argp->data)
+		return -EINVAL;
+
+	memset(&input, 0, sizeof(input));
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
+	if (!sev->snp_initialized || !argp->data)
+		return -EINVAL;
+
+	if (!writable)
+		return -EPERM;
+
+	memset(&input, 0, sizeof(input));
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
+		memset(&config, 0, sizeof(config));
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
+	mutex_lock(&sev->snp_certs_lock);
+	if (certs) {
+		kfree(sev->snp_certs_data);
+		sev->snp_certs_data = certs;
+		sev->snp_certs_len = input.certs_len;
+	} else {
+		kfree(sev->snp_certs_data);
+		sev->snp_certs_data = NULL;
+		sev->snp_certs_len = 0;
+	}
+	mutex_unlock(&sev->snp_certs_lock);
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
@@ -1847,6 +1963,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
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
@@ -1962,6 +2084,7 @@ int sev_dev_init(struct psp_device *psp)
 		goto e_sev;
 
 	sev->cmd_buf_backup = (uint8_t *)sev->cmd_buf + PAGE_SIZE;
+	mutex_init(&sev->snp_certs_lock);
 
 	psp->sev_data = sev;
 
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 19d79f9d4212..41d5353d5bab 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -66,6 +66,10 @@ struct sev_device {
 
 	bool snp_initialized;
 	struct snp_host_map snp_host_map[MAX_SNP_HOST_MAP_BUFS];
+	void *snp_certs_data;
+	u32 snp_certs_len;
+	struct mutex snp_certs_lock;
+	struct sev_user_data_snp_config snp_config;
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 5adfaea7df97..c20d37586d21 100644
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
@@ -192,6 +194,21 @@ struct sev_user_data_snp_config {
 	__u8 rsvd1[52];
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

