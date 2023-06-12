Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434F772B70C
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbjFLE4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbjFLE4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:56:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA6910E9;
        Sun, 11 Jun 2023 21:55:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CSD00ODkgqyobCVqRS1vYYyrFCgTP8o4093ZMeDcaibuqeRvmwHumD5vzX6yezdpOO2mzhSfUZ1lrQEeDTktTY0HrEJckoUpzp045985lgbyw4/oQnzYGCz38za+9IX+wOGI5f9N+dR1L/Dvji2q+VNnyPOXpXkGXsT9ib/xBH7hEbKbS/yos7IMXZDqv0eiF8ilI0TUp56iirXN2dupTTqv5fH3o1a1KWB+KP2Za3BaJUCH7edAWV3PN57Fyz5x27GjXiId76NwWkZo7H5VzoSIXZUZg4xvLHvoyLZzHDjAbnmHZzU1ERflzL6JGkTxzPB8iaJMccNtzh7q/nNH3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQtuNY0mUB1m5WmhFOnk56WbAk95FDsuLAXhADtmTW0=;
 b=kr3QIuBLsiU01pkN+Wtq0aN/mHAyP/xQ8lPl8QOnnrqgJ/7IuhwsRjSgqozcoVdwFXdA5fmWpAHnwxM+9mQM4X5a4cZNd64xr4FWFmCPeUmP+UB5+wgEUNYGFRqD0BfuWYd27zxVlTp5gi9e1MU9wWdc5NfQlc1QRIkkR9uHjx8IVQ4YZxH90P0rJEDKOgEPI6+oaCalqYhaC9/qQZK9y9xXHK2ewdVfa+sLap2tR03MOdD/90gz6Xp2coQPZaXbFkN/bhQ+JqO4RDqCpFBcAg/mEw+Q8RFyxLCuFtoGZwRrWL06xPLQvQ82vwQ2kJBbIdePSsMVHO9Oh6CZT/cuIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQtuNY0mUB1m5WmhFOnk56WbAk95FDsuLAXhADtmTW0=;
 b=lBmrpuM4H3c1DDHbphwQ2dN2HGj1tNbjcqUB1HBVEYhMgSWGf9iJWA1u1R2a/cYSo3nSkwe+S2o4PlwjbrLZ5KUOafgao71AFG3+DkZTNGBUGek4NE5b21D/Gtet9EbE97jtw7oJpkDhgH5DxK+ZRvuzZ0X4LzZdOPj0CkWJcuk=
Received: from DM5PR08CA0052.namprd08.prod.outlook.com (2603:10b6:4:60::41) by
 BN9PR12MB5146.namprd12.prod.outlook.com (2603:10b6:408:137::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 04:55:32 +0000
Received: from CY4PEPF0000E9DB.namprd05.prod.outlook.com
 (2603:10b6:4:60:cafe::11) by DM5PR08CA0052.outlook.office365.com
 (2603:10b6:4:60::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:55:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9DB.mail.protection.outlook.com (10.167.241.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:55:31 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:55:30 -0500
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
        Dionna Glaze <dionnaglaze@google.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH RFC v9 49/51] x86/sev: Add KVM commands for per-instance certs
Date:   Sun, 11 Jun 2023 23:25:57 -0500
Message-ID: <20230612042559.375660-50-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DB:EE_|BN9PR12MB5146:EE_
X-MS-Office365-Filtering-Correlation-Id: 81a20d62-19de-453a-ae5a-08db6b014041
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6gqrwROaIbuwPJnGKntokR4IBQyuRdnfX70ONMTqzwn3+buydpoI8Lfr4bUSvkDhWNj6lc8K127WhiiypW7dQWFvX8MN6sYcFtstLH/jUK8SpcH4RKAxCcpPHl4yqvgh4HNGdSV3Y1dw8qIwVbk6jMwyKSovWmBszo/oBTddu+J9Dq2TM6bwjlBDgZUfS/3JW1TzoZgfwRlDlYTaup1gCz1hqrnkPrSjFf7hw50LMHhO/p49j8vENN867EY+xa1u14fx03xDNAJDeIDBM/VsfAhWEfOgFEiD8K3edUr0KzpAL9Zs43O0yakzXzDkG1ET1nPc4LrNjbIxIRQcKuqExaZ8JcY8nVWum7Nnw/G38ZXu+7jFQT8yzAbQMUajLa5V1Q0/4KPoPZYT+vfW+Q29OIj3xuPN+YfWTwpvijhlVMuItGjAKT0PoZOQk4kv6hWR19/mFn9kne8bvXo+eBBwItxvqPai8be0kiiO3Y1iamrRJv96LSWu1dCDLixW1lFyuMPGdO9lje1GZmRZ8KDrkxrtqzA4m9XjhWh/V2WxGqv1HlN+iixM0ElmjvMuxuIqZH7V20fyyCJVQuX7SOHq0lmaTg3io35uzHksauhxE186DBkILoJ0alhRGipQrBaszMPM3NnOs1mA5pE6DwPxCTRdBoQVXEpTF8px4J8kJ5wr6KwCDCGTs+U2lp7sp87F6lvmngkA+B1UYTDbHWoxtsc4Bp7q1YTbjhzWpNxlEOCEpWsGP1QNXYpug5/6ev4jHVA5OfpcJnW8egjVcE9Mhg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199021)(36840700001)(40470700004)(46966006)(54906003)(5660300002)(6916009)(4326008)(7406005)(7416002)(8936002)(8676002)(44832011)(41300700001)(316002)(2906002)(186003)(16526019)(478600001)(70586007)(70206006)(6666004)(40460700003)(1076003)(356005)(82740400003)(81166007)(40480700001)(26005)(83380400001)(426003)(336012)(47076005)(36756003)(36860700001)(86362001)(82310400005)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:55:31.8680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a20d62-19de-453a-ae5a-08db6b014041
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9DB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5146
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dionna Glaze <dionnaglaze@google.com>

The /dev/sev device has the ability to store host-wide certificates for
the key used by the AMD-SP for SEV-SNP attestation report signing,
but for hosts that want to specify additional certificates that are
specific to the image launched in a VM, a different way is needed to
communicate those certificates.

Add two new KVM ioctl to handle this: KVM_SEV_SNP_{GET,SET}_CERTS

The certificates that are set with this command are expected to follow
the same format as the host certificates, but that format is opaque
to the kernel.

The new behavior for custom certificates is that the extended guest
request command will now return the overridden certificates if they
were installed for the instance. The error condition for a too small
data buffer is changed to return the overridden certificate data size
if there is an overridden certificate set installed.

Setting a 0 length certificate returns the system state to only return
the host certificates on an extended guest request.

Also increase the SEV_FW_BLOB_MAX_SIZE another 4K page to allow space
for an extra certificate.

Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: remove used of "we" and "this patch" in commit log, squash in
      documentation patch]
Signed-off-by: Michael Roth <michael.roth@amd.com>
[aik: snp_handle_ext_guest_request() now uses the CCP's cert object
      without copying things over, only refcounting needed.]
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  44 +++++++
 arch/x86/kvm/svm/sev.c                        | 115 ++++++++++++++++++
 arch/x86/kvm/svm/svm.h                        |   1 +
 include/linux/psp-sev.h                       |   2 +-
 include/uapi/linux/kvm.h                      |  12 ++
 5 files changed, 173 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index cd77a19577fe..21c1894d78ef 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -537,6 +537,50 @@ Returns: 0 on success, -negative on error
 
 See SEV-SNP specification for further details on launch finish input parameters.
 
+22. KVM_SEV_SNP_GET_CERTS
+-------------------------
+
+After the SNP guest launch flow has started, the KVM_SEV_SNP_GET_CERTS command
+can be issued to request the data that has been installed with the
+KVM_SEV_SNP_SET_CERTS command.
+
+Parameters (in/out): struct kvm_sev_snp_get_certs
+
+Returns: 0 on success, -negative on error
+
+::
+
+	struct kvm_sev_snp_get_certs {
+		__u64 certs_uaddr;
+		__u64 certs_len
+	};
+
+If no certs have been installed, then the return value is -ENOENT.
+If the buffer specified in the struct is too small, the certs_len field will be
+overwritten with the required bytes to receive all the certificate bytes and the
+return value will be -EINVAL.
+
+23. KVM_SEV_SNP_SET_CERTS
+-------------------------
+
+After the SNP guest launch flow has started, the KVM_SEV_SNP_SET_CERTS command
+can be issued to override the /dev/sev certs data that is returned when a
+guest issues an extended guest request. This is useful for instance-specific
+extensions to the host certificates.
+
+Parameters (in/out): struct kvm_sev_snp_set_certs
+
+Returns: 0 on success, -negative on error
+
+::
+
+	struct kvm_sev_snp_set_certs {
+		__u64 certs_uaddr;
+		__u64 certs_len
+	};
+
+The certs_len field may not exceed SEV_FW_BLOB_MAX_SIZE.
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index adbe8c242d81..bdf32aa971d8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2277,6 +2277,113 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int snp_get_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_snp_get_certs params;
+	struct sev_snp_certs *snp_certs;
+	int rc = 0;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			   sizeof(params)))
+		return -EFAULT;
+
+	snp_certs = sev_snp_certs_get(sev->snp_certs);
+	/* No instance certs set. */
+	if (!snp_certs)
+		return -ENOENT;
+
+	if (params.certs_len < sev->snp_certs->len) {
+		/* Output buffer too small. Return the required size. */
+		params.certs_len = sev->snp_certs->len;
+
+		if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
+				 sizeof(params)))
+			rc = -EFAULT;
+		else
+			rc = -EINVAL; /* May be ENOSPC? */
+	} else {
+		if (copy_to_user((void __user *)(uintptr_t)params.certs_uaddr,
+				 snp_certs->data, snp_certs->len))
+			rc = -EFAULT;
+	}
+
+	sev_snp_certs_put(snp_certs);
+
+	return rc;
+}
+
+static void snp_replace_certs(struct kvm_sev_info *sev, struct sev_snp_certs *snp_certs)
+{
+	sev_snp_certs_put(sev->snp_certs);
+	sev->snp_certs = snp_certs;
+}
+
+static int snp_set_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	unsigned long length = SEV_FW_BLOB_MAX_SIZE;
+	struct kvm_sev_snp_set_certs params;
+	struct sev_snp_certs *snp_certs;
+	void *to_certs;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			   sizeof(params)))
+		return -EFAULT;
+
+	if (params.certs_len > SEV_FW_BLOB_MAX_SIZE)
+		return -EINVAL;
+
+	/*
+	 * Setting a length of 0 is the same as "uninstalling" instance-
+	 * specific certificates.
+	 */
+	if (params.certs_len == 0) {
+		snp_replace_certs(sev, NULL);
+		return 0;
+	}
+
+	/* Page-align the length */
+	length = ALIGN(params.certs_len, PAGE_SIZE);
+
+	to_certs = kmalloc(length, GFP_KERNEL | __GFP_ZERO);
+	if (!to_certs)
+		return -ENOMEM;
+
+	if (copy_from_user(to_certs,
+			   (void __user *)(uintptr_t)params.certs_uaddr,
+			   params.certs_len)) {
+		ret = -EFAULT;
+		goto error_exit;
+	}
+
+	snp_certs = sev_snp_certs_new(to_certs, length);
+	if (!snp_certs) {
+		ret = -ENOMEM;
+		goto error_exit;
+	}
+
+	snp_replace_certs(sev, snp_certs);
+
+	return 0;
+error_exit:
+	kfree(to_certs);
+	return ret;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2376,6 +2483,12 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_FINISH:
 		r = snp_launch_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_GET_CERTS:
+		r = snp_get_instance_certs(kvm, &sev_cmd);
+		break;
+	case KVM_SEV_SNP_SET_CERTS:
+		r = snp_set_instance_certs(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2591,6 +2704,8 @@ static int snp_decommission_context(struct kvm *kvm)
 	snp_free_firmware_page(sev->snp_context);
 	sev->snp_context = NULL;
 
+	sev_snp_certs_put(sev->snp_certs);
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0d4c29a4300a..72be0c440b16 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -95,6 +95,7 @@ struct kvm_sev_info {
 	u64 snp_init_flags;
 	void *snp_context;      /* SNP guest context page */
 	u64 sev_features;	/* Features set at VMSA creation */
+	struct sev_snp_certs *snp_certs;
 };
 
 struct kvm_svm {
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 2191d8b5423a..7b65dd5808a1 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -22,7 +22,7 @@
 #define __psp_pa(x)	__pa(x)
 #endif
 
-#define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
+#define SEV_FW_BLOB_MAX_SIZE	0x5000	/* 20KB */
 
 struct sev_snp_certs {
 	void *data;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 175b958f103f..fa1c300303d6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1937,6 +1937,8 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_LAUNCH_START,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
 	KVM_SEV_SNP_LAUNCH_FINISH,
+	KVM_SEV_SNP_GET_CERTS,
+	KVM_SEV_SNP_SET_CERTS,
 
 	KVM_SEV_NR_MAX,
 };
@@ -2084,6 +2086,16 @@ struct kvm_sev_snp_launch_finish {
 	__u8 pad[6];
 };
 
+struct kvm_sev_snp_get_certs {
+	__u64 certs_uaddr;
+	__u64 certs_len;
+};
+
+struct kvm_sev_snp_set_certs {
+	__u64 certs_uaddr;
+	__u64 certs_len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.25.1

