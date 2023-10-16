Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012D17CAA47
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbjJPNrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbjJPNrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:47:15 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2264B115;
        Mon, 16 Oct 2023 06:46:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOU3daugj8XRNXFPoBPtolhTof8P1FpFLXaOaIOlqkltQjGJtpeXH/y95/QmjHnVvKwwcMtdpQQ1DZMNYgrxIrhiU5pnqpNUOn+tjDNMddeAj1uq8eO2dvR6gDJlfGkRES7DD4nkuKaFLZtjza1wBVpACCqGuqDwt24PveZcBB8hJyAhlkhz5TebZxIt7t/MAkp+Cy6Uw3kD7ooCLqcdm5TF/22GwfYThPqqY+Edck1Sp3gl9KBRuifjVHm3xKk/mzWZo2DEKLX9fFQ54F/QG60FwYV5OPa44G/NJdR/ojgh/nL7G1jN024dultKoV1j+RPZcP/JsceS8pBMOJ11wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gFsydmQ2ndIxaav3q1fno1Hd8BL8fOrNy6ngmAARfqs=;
 b=h/G7zvK8Z/7zxHS8ViV9ee8D0w2zaPcQu2p7pYajBoH8XduG+l4uo+0NuYW0SoOTALjS7pQqX79KnMEDIY3PEZhb+0OWRR6bZt7G2TCrdYz3lnBxYNwFiPnBNXXMqlr+aA+IAm+K6oEgz0/Q2jGx31PLD0zQT8S0vkxpHjpLdfTddNfswHwm+2fREzGYmfUNppzfp3TThtusmDkIQ0BZHhYwRQmbyS+W56fufv1L2f3zIcOXn7lnRFcV298VGRrJ5x3XYLsJ1/DepmMcmJ47kiuu4OOAIa3JW+x4c6QUUHZcac8vp64GYYgMktDZoUfySh7MM1ECZF07hY8cTfo7Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFsydmQ2ndIxaav3q1fno1Hd8BL8fOrNy6ngmAARfqs=;
 b=14GEXMtsH5QmXB2g0s7FuOMOmVfyUksRtmEVicYm4//oqH2HZa+bj73D93YnWHcuMFUh4kX8AtaNtGJ3BN5a5n+xxMCoBwrgFEpddirlpRDYF/IF4/WM0XAz+GWgjzHZNoIC7UUSZltqdIs0vgfE8k1J3DAWFPuANsU0cBdL8Zg=
Received: from BL0PR0102CA0040.prod.exchangelabs.com (2603:10b6:208:25::17) by
 CH2PR12MB4277.namprd12.prod.outlook.com (2603:10b6:610:ae::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.38; Mon, 16 Oct 2023 13:46:42 +0000
Received: from MN1PEPF0000F0DE.namprd04.prod.outlook.com
 (2603:10b6:208:25:cafe::41) by BL0PR0102CA0040.outlook.office365.com
 (2603:10b6:208:25::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:46:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0DE.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:46:42 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:46:40 -0500
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
        Dionna Glaze <dionnaglaze@google.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH v10 47/50] x86/sev: Add KVM commands for per-instance certs
Date:   Mon, 16 Oct 2023 08:28:16 -0500
Message-ID: <20231016132819.1002933-48-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DE:EE_|CH2PR12MB4277:EE_
X-MS-Office365-Filtering-Correlation-Id: 8af17115-3d52-4395-7621-08dbce4e545e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HjRabIGdfB09RwFhe3AypUM+MK4q+DULofbUxycVT463BRTUuY8DSrNE99rtkyWrB3XXdmGbeT4IbDVKUHzCAv/EFB/23eterJbUFRWeX63aQCHmMCz+WcYvX0YSsUnL0//cq2QzGMVKeAijRbWUXCWdYjYYvBXgQRYghx9+TXZWppgpEpDraAhAgrhg/zDX2iifSDTAfx9z0HkFawOLHZrqMy9O7dNc9rop+XZeoe91qSWdg95wFf68E9qY66CwTct4XmYe9fh/sU4m2UlFVUAs+1w23d4b3ah+1A8lKZLeyNGWMNFgwwJ8TqRQh4v584oc6ZDwRjTufVfXu63CVvQSmyhFW2CBAR9iYjekHhpCVwQFl7HIvUhLNNjLZ8ElyMhsPLwIPrUuxtLU4pdlCZZdhww3Z8n387Je2n5BVHALZipP2qkTf5ze9smEgaWFKCWa6g8SqiBd1iswSSSL/FNgyCvJqdabOh3OGTLAH/Moj1NuG0nHY0BX/ogDHT8WLu8GesM7LuWpPLbpZyYLW5hNW9t4REkvTUppZKCZqPStNWaTRDjsyhLXRSqbQ+TNe2Gvo0GgCsZyVPlOUP2xfP2+NVGSuSrv4n+MWqFoXL8kj8FaL/w1e4lAAinQnGNNxYcQtspkFF30OP4gO7OG8ZYRp++/jQmk6qh+bdCRHTnQKOifU3iD7rp+wUbiEA47JDgb3qHmaVjKoEi+YLHDtckGKYjvfOp30PiSUdcDy/LOKKt6b/vcsPzjV63gqPnTWbr0GgfcaekvYs8nqicxLg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(136003)(396003)(230922051799003)(451199024)(64100799003)(82310400011)(1800799009)(186009)(46966006)(40470700004)(36840700001)(478600001)(40480700001)(6916009)(47076005)(356005)(16526019)(26005)(82740400003)(81166007)(83380400001)(8936002)(336012)(8676002)(4326008)(36860700001)(40460700003)(70206006)(1076003)(2906002)(2616005)(7416002)(44832011)(54906003)(426003)(5660300002)(316002)(41300700001)(70586007)(6666004)(7406005)(36756003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:46:42.0523
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af17115-3d52-4395-7621-08dbce4e545e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000F0DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4277
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index b89634cfcc06..2ce6c90f07d4 100644
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
index efe879524b6c..602aaf82eef3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2301,6 +2301,113 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -2400,6 +2507,12 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
@@ -2616,6 +2729,8 @@ static int snp_decommission_context(struct kvm *kvm)
 	snp_free_firmware_page(sev->snp_context);
 	sev->snp_context = NULL;
 
+	sev_snp_certs_put(sev->snp_certs);
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1fd90a88b0db..bdf792ba06e1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -97,6 +97,7 @@ struct kvm_sev_info {
 	u64 snp_init_flags;
 	void *snp_context;      /* SNP guest context page */
 	u64 sev_features;	/* Features set at VMSA creation */
+	struct sev_snp_certs *snp_certs;
 };
 
 struct kvm_svm {
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 3c605856ef4f..722e26d28d2f 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -14,7 +14,7 @@
 
 #include <uapi/linux/psp-sev.h>
 
-#define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
+#define SEV_FW_BLOB_MAX_SIZE	0x5000	/* 20KB */
 
 struct sev_snp_certs {
 	void *data;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3af546adb962..0444e122ac5e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1973,6 +1973,8 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_LAUNCH_START,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
 	KVM_SEV_SNP_LAUNCH_FINISH,
+	KVM_SEV_SNP_GET_CERTS,
+	KVM_SEV_SNP_SET_CERTS,
 
 	KVM_SEV_NR_MAX,
 };
@@ -2120,6 +2122,16 @@ struct kvm_sev_snp_launch_finish {
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

