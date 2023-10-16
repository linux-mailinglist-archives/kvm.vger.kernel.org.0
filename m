Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1117CAA43
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbjJPNrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbjJPNrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:47:05 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2080.outbound.protection.outlook.com [40.107.101.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6446110C7;
        Mon, 16 Oct 2023 06:46:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MT6cCJHNOIqDZJLVWgmv87nTNr2m+SzluqVQUi/IMjataghc5OidFoRNWiVCrTmcfPL0eYJ/tbK2mTwl9c1EtuoYXPK536BkUHb8/WEq13ENm69e9VVWvy19MOb1p225PxyDAeCej3RnYiJD5hbzJod4aBq4Vshmb5zrZfE087aqW0bVhN3u9LyaliVmhuaAlnwRI7Zw9eclEQTsCLBKPiTGVEnOPB4saLpR/b5cB0Zg9DMLpylcOfQ5kFHAiXqrj6b6lSUofcKo+LisQ1bCd33bE3WYAdS4Otp408ylGvAZ+lFlUNh7ubcs0r2wLdapbBFB3DpfE3ku8OvSYKBfaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mwKOBMV2+HceIW5G1ZMmApNEa+sZfxzSj8CVZCmNOQ=;
 b=WuNoURYFem2DFNLr1EltxSBzFaPmSki1+7ZwDwlnyk798pKxtlBJjEn+YwttdKmYRRFFsX6uVyfhy3BW7IE4feEj4HUZYdFlwGz5X8a8n3tA6bTbiXfymApWkgNefJmqSKn4cL2yH2EA5PbeymYGXWzrIAhKLMCoANo4PTJR3+a5QOt9lAmCp9tPafty3zfark/szY8NrNtj4jw3nMwk4/FR59fmiWiJ2UqCIRA8IAlSmKw904BSzT9Bc5sQL++oPmcBk9h1NJMCf7A9p9Ku90a0PT9peTVnc32hR3xF+jFwVuV+jazIOpPp1aglOFAFh7PFE1jDWNjtOl43zX37qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mwKOBMV2+HceIW5G1ZMmApNEa+sZfxzSj8CVZCmNOQ=;
 b=0j3N74BUZZY+N3+1WwJgb1OAjMoa/9yXsUfdSz2m68ZlSfC/oshz3864O0VaHt2qvY7OZl2E+3ANTIU+rldXTJenz00NdW7u0Iw53Yxi9RsoQrPoaLaq5MdJN7pbCAcfxDeadmp4k3hwoBU0Rg6sS20SWlfqepK/REWsja95+gs=
Received: from BLAPR03CA0155.namprd03.prod.outlook.com (2603:10b6:208:32f::13)
 by SA3PR12MB8809.namprd12.prod.outlook.com (2603:10b6:806:31f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Mon, 16 Oct
 2023 13:46:16 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:208:32f:cafe::11) by BLAPR03CA0155.outlook.office365.com
 (2603:10b6:208:32f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:46:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:46:15 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:46:15 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>
Subject: [PATCH v10 46/50] crypto: ccp: Add the SNP_{SET,GET}_EXT_CONFIG command
Date:   Mon, 16 Oct 2023 08:28:15 -0500
Message-ID: <20231016132819.1002933-47-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|SA3PR12MB8809:EE_
X-MS-Office365-Filtering-Correlation-Id: f91b9876-9f71-4dda-76da-08dbce4e44a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eVGagLXMwTX7N5TBG6KBfI7u3wiy5uow15ggFUgAQy4ZNVDomqoAETvbd8ZNErGIzFVZ0K1XXHlYM32laJ1j2dbiOUqaYLzYWqjm2kZj21PCn8h7DtZkBOtnNK7+VrykRTNmI6iqzs+0crSg4T+FAuKdAIGGAC1Giq0juZCtK34ocAvKC3mMcqDECnr/cq3hSTo30j52vzNuVjwophO3shA8/nwzEh4L4YL4v0m1uszdbCiZ+ownxgV4KivzJuCiV8+LGfsnipzlXkoKROViyWdjUovunKCyuYq5tGwPZ4t2oGSi8eCuyGuUcYpIBCztLt09Md57JAomioFEuYgy+rDnEWuEK6NOd6bDpYIc93PgnDNCp1i2ky4/fB9TUKPX+wH4Bx+TxaUHAwyYzUP6J7UqTGy9prgIwij+Z23DEVZ65N7paZ4DOTGhs4dlOUBzf5eWdV6bVKCoDXs17P7b29cr/P5/k60+pJ8r6FoVPis7uWilRa556dx+xeGhaQYTs6hDh7feNXHwoe9BiBDGlRyMvT8P3LIVsnF84tXcf4SHZ8Jjba2Zw56pGX/ifDl1NfBGNMgJJbua0FrUHoNKD0CiNPNu0o8LNh2oQNzVq+pwCouptmlo7+WO86y8wYqkSa37MJ0ePsGawTTpFrcFopKbnQGbWrTZvnuNaOVVYLe4bGfBp5yc2roZ1E3CRNHd5c4949pvP2D6bkScGFEbZtET3It8TlQIu+s0udnoTb6JYtbqaD19r8Fg2y14qkZ6vNWxxdnga2agOZhP8SqelQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(396003)(136003)(230922051799003)(451199024)(1800799009)(82310400011)(64100799003)(186009)(36840700001)(46966006)(40470700004)(40480700001)(44832011)(41300700001)(7406005)(7416002)(4326008)(8936002)(8676002)(5660300002)(2906002)(40460700003)(30864003)(86362001)(36756003)(478600001)(356005)(1076003)(16526019)(82740400003)(26005)(2616005)(81166007)(83380400001)(426003)(336012)(6916009)(54906003)(70586007)(70206006)(316002)(36860700001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:46:15.5944
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f91b9876-9f71-4dda-76da-08dbce4e44a0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8809
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
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

Co-developed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Co-developed-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: squash in doc patch from Dionna]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/coco/sev-guest.rst |  27 ++++
 drivers/crypto/ccp/sev-dev.c          | 173 ++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h          |   2 +
 include/linux/psp-sev.h               |  10 ++
 include/uapi/linux/psp-sev.h          |  17 +++
 5 files changed, 229 insertions(+)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index e828c5326936..7cabf54395e5 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -151,6 +151,33 @@ The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
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
index 0626c0feff9b..4807ddd6ec52 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1496,6 +1496,10 @@ static int __sev_snp_shutdown_locked(int *error)
 	data.length = sizeof(data);
 	data.iommu_snp_shutdown = 1;
 
+	/* Free the memory used for caching the certificate data */
+	sev_snp_certs_put(sev->snp_certs);
+	sev->snp_certs = NULL;
+
 	wbinvd_on_all_cpus();
 
 retry:
@@ -1834,6 +1838,121 @@ static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static int sev_ioctl_snp_get_config(struct sev_issue_cmd *argp)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_user_data_ext_snp_config input;
+	struct sev_snp_certs *snp_certs;
+	int ret;
+
+	if (!sev->snp_initialized || !argp->data)
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
+	snp_certs = sev_snp_certs_get(sev->snp_certs);
+
+	/* Copy the extended certs programmed through the SNP_SET_CONFIG */
+	if (input.certs_address && snp_certs) {
+		if (input.certs_len < snp_certs->len) {
+			/* Return the certs length to userspace */
+			input.certs_len = snp_certs->len;
+
+			ret = -EIO;
+			goto e_done;
+		}
+
+		if (copy_to_user((void * __user)input.certs_address,
+				 snp_certs->data, snp_certs->len)) {
+			ret = -EFAULT;
+			goto put_exit;
+		}
+	}
+
+	ret = 0;
+
+e_done:
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
+		ret = -EFAULT;
+
+put_exit:
+	sev_snp_certs_put(snp_certs);
+
+	return ret;
+}
+
+static int sev_ioctl_snp_set_config(struct sev_issue_cmd *argp, bool writable)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_user_data_ext_snp_config input;
+	struct sev_user_data_snp_config config;
+	struct sev_snp_certs *snp_certs = NULL;
+	void *certs = NULL;
+	int ret;
+
+	if (!sev->snp_initialized || !argp->data)
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
+	if (input.certs_len) {
+		snp_certs = sev_snp_certs_new(certs, input.certs_len);
+		if (!snp_certs) {
+			ret = -ENOMEM;
+			goto e_free;
+		}
+	}
+
+	sev_snp_certs_put(sev->snp_certs);
+	sev->snp_certs = snp_certs;
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
@@ -1888,6 +2007,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
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
@@ -1936,6 +2061,54 @@ int sev_guest_df_flush(int *error)
 }
 EXPORT_SYMBOL_GPL(sev_guest_df_flush);
 
+static void sev_snp_certs_release(struct kref *kref)
+{
+	struct sev_snp_certs *certs = container_of(kref, struct sev_snp_certs, kref);
+
+	kfree(certs->data);
+	kfree(certs);
+}
+
+struct sev_snp_certs *sev_snp_certs_new(void *data, u32 len)
+{
+	struct sev_snp_certs *certs;
+
+	if (!len || !data)
+		return NULL;
+
+	certs = kzalloc(sizeof(*certs), GFP_KERNEL);
+	if (!certs)
+		return NULL;
+
+	certs->data = data;
+	certs->len = len;
+	kref_init(&certs->kref);
+
+	return certs;
+}
+EXPORT_SYMBOL_GPL(sev_snp_certs_new);
+
+struct sev_snp_certs *sev_snp_certs_get(struct sev_snp_certs *certs)
+{
+	if (!certs)
+		return NULL;
+
+	if (!kref_get_unless_zero(&certs->kref))
+		return NULL;
+
+	return certs;
+}
+EXPORT_SYMBOL_GPL(sev_snp_certs_get);
+
+void sev_snp_certs_put(struct sev_snp_certs *certs)
+{
+	if (!certs)
+		return;
+
+	kref_put(&certs->kref, sev_snp_certs_release);
+}
+EXPORT_SYMBOL_GPL(sev_snp_certs_put);
+
 static void sev_exit(struct kref *ref)
 {
 	misc_deregister(&misc_dev->misc);
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 2c2fe42189a5..71eac493fd56 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -66,6 +66,8 @@ struct sev_device {
 
 	bool snp_initialized;
 	struct snp_host_map snp_host_map[MAX_SNP_HOST_MAP_BUFS];
+	struct sev_snp_certs *snp_certs;
+	struct sev_user_data_snp_config snp_config;
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 9342cee1a1e6..3c605856ef4f 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -16,6 +16,16 @@
 
 #define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
 
+struct sev_snp_certs {
+	void *data;
+	u32 len;
+	struct kref kref;
+};
+
+struct sev_snp_certs *sev_snp_certs_new(void *data, u32 len);
+struct sev_snp_certs *sev_snp_certs_get(struct sev_snp_certs *certs);
+void sev_snp_certs_put(struct sev_snp_certs *certs);
+
 /**
  * SEV platform state
  */
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index b94b3687edbb..b70db9ab7e44 100644
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
@@ -208,6 +210,21 @@ struct sev_user_data_snp_config {
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
+} __packed;
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.25.1

