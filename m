Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B725672B723
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbjFLE4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235606AbjFLEzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:55:45 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A644319B5;
        Sun, 11 Jun 2023 21:55:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gihk28j4nlJGaBEvpAa1Hj3qp6RG9Yd6XHd2k5l+xJPcsMwLNOiocflDSP3twRmZLVakf9J+rQuvNBsul/BftsbVmStAe+Q9G5yF9bfeLmoRF/0F3hObTKwkpFYTqauTh1bQJQwGD/faZYuwLKH7TMnEf2DvR+IJo+ACZkzN4mZTHVuBXzzDosLFNCtHdv2eHgywBi+EAoXtTU7r5Hdk037K7mfmVFiUW/rwvaGXpqSF1mM9rGVpxR1ICl4elXRV2DULB/Y669blLgqQ9699Aa+Iw9fIrd0GVQZ0SvA/UAQYIbj6aGgTuBXMmbXuiuHvaD05kDljZBYCHCZzIwn9IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Em/p9x32Hb3bLzmcXjcCKuGKc6huNvCGbDR3djc9uMo=;
 b=kriR/W6+TjqLimipN0d+jkYB5m/bvTZD76GdkRxKzUVX73qLGHkamrNonPxqMYsG4TRrCVAwW/icvEcl9NmzVG7GNzXon4sDw9ChyM9tRXTNxrcloJopxBTOXkFNtt3snmVdkhi0KyKCkq4GdM3HiZwgL3KXzxdaQSZ1sKTjD0YtsjJF/qC4iDZAg07HQk41ADnRrFjA+3jKeUosYoEvN36+AeemWqy9+RUeGu4h5DcnnpzPwnQGQXGHaoIiEIHUrd8LwnGGOGuLTOXU8nY/6dxtZSJUNfMbnBBcCCIrwamdPzxud7bVyixe4TMsfJXvbJ9a3r4c+Go8AdPjaTHyBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Em/p9x32Hb3bLzmcXjcCKuGKc6huNvCGbDR3djc9uMo=;
 b=Fljl715eY0mSF1DjWxiyfEmAbYjMZ46WVo4c4w0YbYEL0pwvBV4wksgqqhZtKP10i3646cyDIWYUmx5xXN9ywBtynQLLKflauh9I/4jjI54YI1xKmBFTYULi+5h4scPZwWXod4fCFi0mRuI9paMhXf+7fAMRAxaEuKiEDA/ihQw=
Received: from CYXPR03CA0095.namprd03.prod.outlook.com (2603:10b6:930:d3::6)
 by DS0PR12MB7557.namprd12.prod.outlook.com (2603:10b6:8:130::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Mon, 12 Jun
 2023 04:55:05 +0000
Received: from CY4PEPF0000E9D6.namprd05.prod.outlook.com
 (2603:10b6:930:d3:cafe::3b) by CYXPR03CA0095.outlook.office365.com
 (2603:10b6:930:d3::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 04:55:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D6.mail.protection.outlook.com (10.167.241.80) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:55:04 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:54:58 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>
Subject: [PATCH RFC v9 48/51] crypto: ccp: Add the SNP_{SET,GET}_EXT_CONFIG command
Date:   Sun, 11 Jun 2023 23:25:56 -0500
Message-ID: <20230612042559.375660-49-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D6:EE_|DS0PR12MB7557:EE_
X-MS-Office365-Filtering-Correlation-Id: 1439d436-96b9-4ba9-0e0c-08db6b01302d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IbMju/P4XXqkxJKDm5mlOOpvJe/nMzOQPC/YYKab8FAUWZ8ZdJOnHi6iqBQFESk0Cvlj0UZ+nPThdMXdfGoJNRwvUxPZMLypALZViFjiiF8WN46UKpC5aCJd8xV3/qZAEm+sy8RaAsoSCZM2vrJWV0V0evmame1KCzOb8VlXvkutOl8AeGyHJRJdrJrKb6c+5lnJs7mMXiyoaZ9+b0mjjOpd/8fIu7q/8aXbVMvbcE2hCeA0yxdSHu11LY5XmMxMuJkC3GM4lPsIdKean4PT0zu31IqhOrJpSTbLIgwtKrqKPz5SEALHdMF/gVBEkYngSRzaZ1xYTVKAMM9o5jBSsogNYflKEcmH1x5MCKKW1b93CF42NTiyMnw8j5mJYSS1gwvprTx9bBYBmzNouWS6b0hrRL8upFwjIWTriza1zBaWBSt5cfjJvjPgxFgeVq4s1stOfjvhYDU8sdBbAsqUYRH+hZEHmblaFwnhD8P+P6aoUfph6XdsyI39nhn4Xt3XVtsNiniRRLz0n4RPhh109KLGvHvHM61lpdeMPx/c/kZI5P3t+4qx6jcKTZEMw3wmzhQHwrH/+Zh/chm/lAkRv3Smk10vyKrj//P5KXynl6MzlGvFYR0VRB67VOTMUebY3vemDLyy1GcUumKTsAMTWBGoP4HF0XWAsOnMzkC2lkhF1HtrV4DHNiiUsPFXV38ysHVdNl6lvds2tZS6y6ofawGbELHHvP9o6QBCOUGtG8oU5CjVjKK+1OH95FM5ynuahbrLmhNDv7fC1DqgKWlzkA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(39860400002)(136003)(451199021)(40470700004)(36840700001)(46966006)(40480700001)(40460700003)(81166007)(54906003)(82740400003)(478600001)(356005)(8676002)(70586007)(2616005)(5660300002)(316002)(4326008)(6916009)(8936002)(41300700001)(70206006)(336012)(426003)(16526019)(36860700001)(186003)(47076005)(83380400001)(26005)(1076003)(82310400005)(86362001)(7416002)(44832011)(36756003)(7406005)(2906002)(30864003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:55:04.9205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1439d436-96b9-4ba9-0e0c-08db6b01302d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7557
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
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
 drivers/crypto/ccp/sev-dev.c          | 178 ++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h          |   2 +
 include/linux/psp-sev.h               |  10 ++
 include/uapi/linux/psp-sev.h          |  17 +++
 5 files changed, 234 insertions(+)

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
index b8e8c4da4025..175c24163ba0 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1491,6 +1491,10 @@ static int __sev_snp_shutdown_locked(int *error)
 	data.length = sizeof(data);
 	data.iommu_snp_shutdown = 1;
 
+	/* Free the memory used for caching the certificate data */
+	sev_snp_certs_put(sev->snp_certs);
+	sev->snp_certs = NULL;
+
 	wbinvd_on_all_cpus();
 
 retry:
@@ -1829,6 +1833,126 @@ static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
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
@@ -1883,6 +2007,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
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
@@ -1931,6 +2061,54 @@ int sev_guest_df_flush(int *error)
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
index 19d79f9d4212..22374f3d3e2e 100644
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
index 5ae61de96e44..2191d8b5423a 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -24,6 +24,16 @@
 
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
index 4dc6a3e7b3d5..d1e6a0615546 100644
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
@@ -201,6 +203,21 @@ struct sev_user_data_snp_config {
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

