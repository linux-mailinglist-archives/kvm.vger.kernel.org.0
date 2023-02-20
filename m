Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82B169D3B6
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbjBTTDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbjBTTDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:03:05 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946B121947;
        Mon, 20 Feb 2023 11:02:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djcn8ThIoyrU41bEYDWLwFYChKAW8DTjTqlwK0dDvJkV4m94JIgWSL31ckuhe01MBG06R2O3thrUUYbSmpSiK5b5tBcucu6jBLmbtV0du5w0tur2dbOOU6TB+sfIUi7Zu6xp15qouWz5nH925yTzrWhj1N4vKOqgx/VDlDCWsZ6tvMiyNfK3DEZUKT418pjyd65Oy/7yF+brcJybNXPwiCYGA7RgA8YeJKApSfWMaZj6RrpwQNFA+3UiHoEwQ6zsd4EQyQiuK7Gyzp0bPv3788W1FLM1ba5X6agjPwyQPWdvRmJh0T8M+L2kEAZiCXxHSja5jqSyMrP3iKEbqUX7Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2M6hrAR8Ctx+uOCboGePLQAUWptiNchqX1bNzjVjiko=;
 b=CjKLVTE2cYJQAqkZBrXNecAvg3H5/4Z+D3YBt/9EERpk7C8S4QVMBhYoKWHWfZnOu8RwgjGKWU7/MGWImyeCfUzT8DFCLqdy/NVgSJ6EttIS2yOnYosG1GomiHuOMrpijONwbs/9NQDBEh1JXlhdwIC3OAyOwJlboemEN1V9fr6UqXHYi0n+cmYtuKUGwK8OAEDzA16mA1TpHoOSffU5LtWN5U+3pMtnPetxhcwwbkiOlUDm+p6N3vyrxLnWQ1DIGtx3FaOLuWSYxpYwWXfOlhFslJj4zK7v4NV3J4zliUQpSOHH6yoPcsqNpojHAzuNwLEpc63gzQDtyZn0LoOslQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2M6hrAR8Ctx+uOCboGePLQAUWptiNchqX1bNzjVjiko=;
 b=KWQmPL8bu1lqQm+OY+FOyE0MbFhzno8IgkEoNzsWMh3guGApBwDcApX/QwAh1pad0AdVm5YW//qj1WySSx0wf7y7DYSay6AZkY2dHHlFa+iwXRf40Nv0R4BGvl0Rpnw1YLIrGIb5Wqm0uSoMhtPvwgNSm6duSw7JhjRNBnrATSg=
Received: from MW4PR03CA0056.namprd03.prod.outlook.com (2603:10b6:303:8e::31)
 by DM4PR12MB6208.namprd12.prod.outlook.com (2603:10b6:8:a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 19:00:41 +0000
Received: from CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::54) by MW4PR03CA0056.outlook.office365.com
 (2603:10b6:303:8e::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19 via Frontend
 Transport; Mon, 20 Feb 2023 19:00:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT077.mail.protection.outlook.com (10.13.175.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.19 via Frontend Transport; Mon, 20 Feb 2023 19:00:41 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 13:00:40 -0600
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
        Dionna Glaze <dionnaglaze@google.com>,
        "Tom Lendacky" <Thomas.Lendacky@amd.com>
Subject: [PATCH RFC v8 54/56] x86/sev: Add KVM commands for instance certs
Date:   Mon, 20 Feb 2023 12:38:45 -0600
Message-ID: <20230220183847.59159-55-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT077:EE_|DM4PR12MB6208:EE_
X-MS-Office365-Filtering-Correlation-Id: c4025751-8b34-4a24-1238-08db1374c32d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qERWmM6kAcyem68EePiJhnI2MMVSFNyShOfMpsEtP20IEyzXsj2L4q46HzSC4z9D/EMB+9MFQHhN6cHg+Z+WhHDL1zVVtEYKO0o6wunc540vElz/3e3g/ZPAay/1RXdCA6x5hcspBK1JUH3FMB0vTQcHFzm/2VTNxMRmt6TbrM4Z22j1AeK2I0QPULdwrI1foiOXuqdvwJKxUDno297eRmaCJm4ys5IclnRaAm0LBZ0RfRI3E/mqb+fIhOODJdHmKvRRGRFUmd5M5oT5ptNXyU2XhjjgaTK6faa5zBPMgdNfjMXWaFN/QxNlTTyzzxsB6Q5k3V+wySyof/tetC7HCWgJyZR+qK2evF/C1Tf7t1lyPMwarzFIHOVlHduANBH4akO13yWSH+dqsKupcMBi5sCMblFalCBWpBvTPNGzzPjMpsjXa8X7j7lbmVPu/mFpksft2zeOSX5sbt9MwFRYalF/3ABQxuezgD9p2dnj+CTxTec8R2e1gLxp0H6CpOQ3kR8SoRAu1WomECWwLZ14RXJlBGKLAC/Jbm2MMyd4FX8EaziQRdfNS1fuBzqD1uatt3YmPJsSrlyNZSMqCVlmGNGaDGMs5lKJ/3UrVQd2cQ+sqByoZJGpVVtveA0Rulwj4SNgB7truWRE31jESp+1W8YCNCDPYbdZprG9qpYcLoTnWTcmmNc1Y7hy+/JEMa0E31B87plsUX6LCG4I3hFVal2V8nGtemsKT1dKgbx2wYY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199018)(36840700001)(40470700004)(46966006)(336012)(478600001)(36860700001)(2616005)(47076005)(81166007)(426003)(70206006)(1076003)(2906002)(83380400001)(186003)(6916009)(316002)(40460700003)(16526019)(8676002)(70586007)(54906003)(36756003)(7416002)(82310400005)(40480700001)(356005)(8936002)(86362001)(26005)(4326008)(5660300002)(44832011)(41300700001)(7406005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 19:00:41.3139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4025751-8b34-4a24-1238-08db1374c32d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6208
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
[mdr: remove used of "we" and "this patch" in commit log]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 111 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h   |   1 +
 include/linux/psp-sev.h  |   2 +-
 include/uapi/linux/kvm.h |  12 +++++
 4 files changed, 123 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 70d5650d8d95..18b64b7005e7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2089,6 +2089,7 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free;
 
 	sev->snp_certs_data = certs_data;
+	sev->snp_certs_len = 0;
 
 	return context;
 
@@ -2404,6 +2405,86 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int snp_get_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_snp_get_certs params;
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
+	/* No instance certs set. */
+	if (!sev->snp_certs_len)
+		return -ENOENT;
+
+	if (params.certs_len < sev->snp_certs_len) {
+		/* Output buffer too small. Return the required size. */
+		params.certs_len = sev->snp_certs_len;
+
+		if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
+				 sizeof(params)))
+			return -EFAULT;
+
+		return -EINVAL;
+	}
+
+	if (copy_to_user((void __user *)(uintptr_t)params.certs_uaddr,
+			 sev->snp_certs_data, sev->snp_certs_len))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int snp_set_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	unsigned long length = SEV_FW_BLOB_MAX_SIZE;
+	void *to_certs = sev->snp_certs_data;
+	struct kvm_sev_snp_set_certs params;
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
+		sev->snp_certs_len = 0;
+		return 0;
+	}
+
+	/* Page-align the length */
+	length = (params.certs_len + PAGE_SIZE - 1) & PAGE_MASK;
+
+	if (copy_from_user(to_certs,
+			   (void __user *)(uintptr_t)params.certs_uaddr,
+			   params.certs_len)) {
+		return -EFAULT;
+	}
+
+	sev->snp_certs_len = length;
+
+	return 0;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2503,6 +2584,12 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
@@ -3550,8 +3637,28 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
 	if (rc)
 		goto unlock;
 
-	rc = snp_guest_ext_guest_request(&req, (unsigned long)sev->snp_certs_data,
-					 &data_npages, &err);
+	/*
+	 * If the VMM has overridden the certs, then change the error message
+	 * if the size is inappropriate for the override. Otherwise, use a
+	 * regular guest request and copy back the instance certs.
+	 */
+	if (sev->snp_certs_len) {
+		if ((data_npages << PAGE_SHIFT) < sev->snp_certs_len) {
+			rc = -EINVAL;
+			err = SNP_GUEST_REQ_INVALID_LEN;
+			goto datalen;
+		}
+		rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &req,
+				   (int *)&err);
+	} else {
+		rc = snp_guest_ext_guest_request(&req,
+						 (unsigned long)sev->snp_certs_data,
+						 &data_npages, &err);
+	}
+datalen:
+	if (sev->snp_certs_len)
+		data_npages = sev->snp_certs_len >> PAGE_SHIFT;
+
 	if (rc) {
 		/*
 		 * If buffer length is small then return the expected
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 221b38d3c845..dced46559508 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -94,6 +94,7 @@ struct kvm_sev_info {
 	u64 snp_init_flags;
 	void *snp_context;      /* SNP guest context page */
 	void *snp_certs_data;
+	unsigned int snp_certs_len; /* Size of instance override for certs */
 	struct mutex guest_req_lock; /* Lock for guest request handling */
 
 	u64 sev_features;	/* Features set at VMSA creation */
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 92116e2b74fd..3b28b78938f6 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -22,7 +22,7 @@
 #define __psp_pa(x)	__pa(x)
 #endif
 
-#define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
+#define SEV_FW_BLOB_MAX_SIZE	0x5000	/* 20KB */
 
 /**
  * SEV platform state
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6e684bf5f723..ad7e24e43547 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1928,6 +1928,8 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_LAUNCH_START,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
 	KVM_SEV_SNP_LAUNCH_FINISH,
+	KVM_SEV_SNP_GET_CERTS,
+	KVM_SEV_SNP_SET_CERTS,
 
 	KVM_SEV_NR_MAX,
 };
@@ -2075,6 +2077,16 @@ struct kvm_sev_snp_launch_finish {
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

