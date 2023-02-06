Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A110468B469
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 04:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjBFDOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Feb 2023 22:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjBFDOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Feb 2023 22:14:09 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C47F10259;
        Sun,  5 Feb 2023 19:14:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJOA/7ZnxbUpiM4uYsCgAnNlJQ8vFO81RwDbzWtPWEFsAl4Or3jC4a8HvaaIxR+QQqtBZxd3wvb2RIqxbm+lqMNJc0X4Y2c9ToL041ec6y7ZNEDs5Zi4nQgbsNvXrWleTx55qyf+i8hNAmTBuBPAA92pOobsUZoKF1kPS5Bba8UgG7j9u24ahxGzonLLMPA/KwC6ejMOOLS1FlhKYiPhKjnDjSXdH6EsfExmGFC5qwRdNUZdH89UN+BSLV2pKr4G0BNmeVbqqB8yq1EIEbUV0kjZ1ot0n3PCJxBuokbrZOMMbh3Zyuus/m67G4z+fhgXsNq9aB2OrsJIaZH+UGC+7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qDJSdtPugYF9PWcgt1UJE7Mb0NILKxGJA4ktdbw50LE=;
 b=U45QbGWDeXFFay/mUTZ++0B3EpWydJs0Ijl+JgRCk09KcqlUP1JvXazdDBchSt4z/onEVh0t0tgBm56xWdSzHEomiKRtj8+jo/SalbJFmVPsLB/6sq13aecyo01Rl49cJ2tTILYsuFGgXqiNY7Uv7IvIXQb685hT/JrIxDlUq8c59pLGFvFkGHY7bEKuKPejqnjJmWm+BijXBWSNMAWP+GxtKEK6p7bFBqg0e+msYaBVHDS1O7KvbG+LAXRyO/2bK/tmNdlThpOUFoW/ESk+tW1bZctR4NbDRslFNFkST9bL6qTVmWF2VkD+rjOfA3r1cJTMqFMtW89kNQiSIhgoUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDJSdtPugYF9PWcgt1UJE7Mb0NILKxGJA4ktdbw50LE=;
 b=gIQF50bp9nUXeRHQtri2KIAHcogt3wfCVwAmjXorgLY3sLNsJxbKZsSQnc+9MjpQQ2vPAwj7QA4IxJxFojxCgg0Rgsv0MxqMx6G1Saoffq3zS3Z8yLNcEMhFdTPa1OqhjfYfN1U8fxNmJbGP2vLEtecobSnCOW7ZKgZ1Pf1KVfA=
Received: from BN9PR03CA0865.namprd03.prod.outlook.com (2603:10b6:408:13d::30)
 by PH0PR12MB7908.namprd12.prod.outlook.com (2603:10b6:510:28e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 03:14:04 +0000
Received: from BN8NAM11FT074.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::c7) by BN9PR03CA0865.outlook.office365.com
 (2603:10b6:408:13d::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 03:14:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT074.mail.protection.outlook.com (10.13.176.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.32 via Frontend Transport; Mon, 6 Feb 2023 03:14:04 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 5 Feb
 2023 21:13:54 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        John Allen <john.allen@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dionna Glaze <dionnaglaze@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Brijesh Singh" <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Ashish Kalra <ashish.kalra@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH kernel] KVM: SVM: Fix SVM_VMGEXIT_EXT_GUEST_REQUEST to follow the rest of API
Date:   Mon, 6 Feb 2023 14:13:43 +1100
Message-ID: <20230206031343.1646916-1-aik@amd.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <81037a58-6b5c-cde4-79fe-3686d9b8a551@amd.com>
References: <81037a58-6b5c-cde4-79fe-3686d9b8a551@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT074:EE_|PH0PR12MB7908:EE_
X-MS-Office365-Filtering-Correlation-Id: 67f83024-e629-4cd4-b124-08db07f033ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l+f6O8sv2uXbD8fJjwkqoYoxRnJpmrSXzTjj2yL0WgsDubyikAnMaqnJJpkbM9AhGVPYKW9y1eU8LgawDnczdPtZDh2HIlsy1xuCR19P6VBhfPXOfeZUwlBt+ZEkK0TZt/kge+601h55AmAT98EQ2cVYW6/yC7qFFyI2M9R3M4llcUPpWpdrIKME0B5cr6lxsCTddIGuFq51SuiNAFcQsevcYsU/vJGRt1PWiQTnq1yvZ9PafRTf/xqdd/q9rjQ2/NvT5hboEbvOZbFq9iYgVtngcVVfy3y0R80LkorWbiNb3STUd9I9LYPBFrevQjdda8L0nicWlzWuGCGDTAUgPZAPqi2IXFL6itlizlM4xnwFDQ2JNHDinK97Uim3EOH0SBjRZf2WqYZBYulAIxN0L+Xc/Hi/mtuz9OuK69HbBYD6QaI4fGXU0I4ZEoz//cIODx7+a6P7PEibOFv2mtrpguOCn5pIjGNnpmrHnQZjGroCu18vt2osONHjViS0mfhWB31QJns15aDECXVp1pyTovc6Kfrnh7kksXowOr22MRz9zKJYld6VmPpuxiS49T4yF5R1aWPfjDGWMifr2S4goLTHdb0MKOVkorrdOhM3GOyO7OdAkglXVpFK05ZuJQ+FVnsW0Ix/c2trR4gPlc7/48ZOVLaVF14lloMfjCRANvgac0Hb4ZludDOydkzjtW/W9TVZKoIesz0cmH9p+EWWUalcC/e6RRQJi3/HP/UxrrLD8HE24cx5DKGQ/inONJPmvvQAP+X8LEB0VqJR1mPTop+xW0zB4fxLv9BlZX4J8r8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199018)(40470700004)(46966006)(36840700001)(40480700001)(36756003)(82740400003)(81166007)(356005)(82310400005)(40460700003)(2906002)(316002)(54906003)(966005)(478600001)(41300700001)(8936002)(7416002)(8676002)(70206006)(70586007)(5660300002)(6666004)(6916009)(4326008)(83380400001)(36860700001)(1076003)(16526019)(186003)(26005)(47076005)(336012)(426003)(2616005)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 03:14:04.3220
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67f83024-e629-4cd4-b124-08db07f033ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT074.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7908
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SVM VM is up, KVM uses sev_issue_cmd_external_user() with an open
/dev/sev fd which ensures that the SVM initialization was done correctly.
The only helper not following the scheme is snp_guest_ext_guest_request()
which bypasses the fd check.

Change the SEV API to require passing a file.

Handle errors with care in the SNP Extended Guest Request handler
(snp_handle_ext_guest_request()) as there are actually 3 types of errors:
- @rc: return code SEV device's sev_issue_cmd() which is int==int32;
- @err: a psp return code in sev_issue_cmd(), also int==int32 (probably
a mistake but kvm_sev_cmd::error uses __u32 for some time now);
- (added by this) @exitcode: GHCB's exit code sw_exit_info_2, uint64.

Use the right types, remove cast to int* and return ENOSPC from SEV
device for converting it to the GHCB's exit code
SNP_GUEST_REQ_INVALID_LEN==BIT(32).

Fixes: 17f1d0c995ac ("KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event")
While at this, preserve the original error in snp_cleanup_guest_buf().

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---

This can easily be squashed into what it fixes.

The patch is made for
https://github.com/AMDESE/linux/commits/upmv10-host-snp-v7-rfc
---
 include/linux/psp-sev.h      | 62 +++++++++++---------
 arch/x86/kvm/svm/sev.c       | 50 +++++++++++-----
 drivers/crypto/ccp/sev-dev.c | 11 ++--
 3 files changed, 73 insertions(+), 50 deletions(-)

diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 970a9de0ed20..466b1a6e7d7b 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -848,6 +848,36 @@ int sev_platform_status(struct sev_user_data_status *status, int *error);
 int sev_issue_cmd_external_user(struct file *filep, unsigned int id,
 				void *data, int *error);
 
+/**
+ * sev_issue_cmd_external_user_cert - issue SEV command by other driver with a file
+ * handle and return certificates set onto SEV device via SNP_SET_EXT_CONFIG;
+ * intended for use by the SNP extended guest request command defined
+ * in the GHCB specification.
+ *
+ * @filep - SEV device file pointer
+ * @cmd - command to issue
+ * @data - command buffer
+ * @vaddr: address where the certificate blob need to be copied.
+ * @npages: number of pages for the certificate blob.
+ *    If the specified page count is less than the certificate blob size, then the
+ *    required page count is returned with ENOSPC error code.
+ *    If the specified page count is more than the certificate blob size, then
+ *    page count is updated to reflect the amount of valid data copied in the
+ *    vaddr.
+ *
+ * @error: SEV command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ * -%ENOSPC    if the specified page count is too small
+ */
+int sev_issue_cmd_external_user_cert(struct file *filep, unsigned int cmd, void *data,
+				     unsigned long vaddr, unsigned long *npages, int *error);
+
 /**
  * sev_guest_deactivate - perform SEV DEACTIVATE command
  *
@@ -945,32 +975,6 @@ void snp_free_firmware_page(void *addr);
  */
 void snp_mark_pages_offline(unsigned long pfn, unsigned int npages);
 
-/**
- * snp_guest_ext_guest_request - perform the SNP extended guest request command
- *  defined in the GHCB specification.
- *
- * @data: the input guest request structure
- * @vaddr: address where the certificate blob need to be copied.
- * @npages: number of pages for the certificate blob.
- *    If the specified page count is less than the certificate blob size, then the
- *    required page count is returned with error code defined in the GHCB spec.
- *    If the specified page count is more than the certificate blob size, then
- *    page count is updated to reflect the amount of valid data copied in the
- *    vaddr.
- *
- * @sev_ret: sev command return code
- *
- * Returns:
- * 0 if the sev successfully processed the command
- * -%ENODEV    if the sev device is not available
- * -%ENOTSUPP  if the sev does not support SEV
- * -%ETIMEDOUT if the sev command timed out
- * -%EIO       if the sev returned a non-zero return code
- */
-int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
-				unsigned long vaddr, unsigned long *npages,
-				unsigned long *error);
-
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
 static inline int
@@ -1013,9 +1017,9 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
 
 static inline void snp_free_firmware_page(void *addr) { }
 
-static inline int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
-					      unsigned long vaddr, unsigned long *n,
-					      unsigned long *error)
+static inline int sev_issue_cmd_external_user_cert(struct file *filep, unsigned int cmd,
+						   void *data, unsigned long vaddr,
+						   unsigned long *npages, int *error)
 {
 	return -ENODEV;
 }
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d0e58cffd1ed..b268c35efab4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -394,6 +394,23 @@ static int sev_issue_cmd(struct kvm *kvm, int id, void *data, int *error)
 	return __sev_issue_cmd(sev->fd, id, data, error);
 }
 
+static int sev_issue_cmd_cert(struct kvm *kvm, int id, void *data,
+			      unsigned long vaddr, unsigned long *npages, int *error)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct fd f;
+	int ret;
+
+	f = fdget(sev->fd);
+	if (!f.file)
+		return -EBADF;
+
+	ret = sev_issue_cmd_external_user_cert(f.file, id, data, vaddr, npages, error);
+
+	fdput(f);
+	return ret;
+}
+
 static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -3587,11 +3604,11 @@ static void snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data, unsig
 	int ret;
 
 	ret = snp_page_reclaim(pfn);
-	if (ret)
+	if (ret && (*rc == SEV_RET_SUCCESS))
 		*rc = SEV_RET_INVALID_ADDRESS;
 
 	ret = rmp_make_shared(pfn, PG_LEVEL_4K);
-	if (ret)
+	if (ret && (*rc == SEV_RET_SUCCESS))
 		*rc = SEV_RET_INVALID_ADDRESS;
 }
 
@@ -3638,8 +3655,9 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
 	struct kvm *kvm = vcpu->kvm;
 	unsigned long data_npages;
 	struct kvm_sev_info *sev;
-	unsigned long rc, err;
+	unsigned long exitcode;
 	u64 data_gpa;
+	int err, rc;
 
 	if (!sev_snp_guest(vcpu->kvm)) {
 		rc = SEV_RET_INVALID_GUEST;
@@ -3669,17 +3687,16 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
 	 */
 	if (sev->snp_certs_len) {
 		if ((data_npages << PAGE_SHIFT) < sev->snp_certs_len) {
-			rc = -EINVAL;
-			err = SNP_GUEST_REQ_INVALID_LEN;
+			rc = -ENOSPC;
 			goto datalen;
 		}
-		rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &req,
-				   (int *)&err);
+		rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &req, &err);
 	} else {
-		rc = snp_guest_ext_guest_request(&req,
-						 (unsigned long)sev->snp_certs_data,
-						 &data_npages, &err);
+		rc = sev_issue_cmd_cert(kvm, SEV_CMD_SNP_GUEST_REQUEST, &req,
+					(unsigned long)sev->snp_certs_data,
+					&data_npages, &err);
 	}
+
 datalen:
 	if (sev->snp_certs_len)
 		data_npages = sev->snp_certs_len >> PAGE_SHIFT;
@@ -3689,27 +3706,30 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
 		 * If buffer length is small then return the expected
 		 * length in rbx.
 		 */
-		if (err == SNP_GUEST_REQ_INVALID_LEN)
+		if (rc == -ENOSPC) {
 			vcpu->arch.regs[VCPU_REGS_RBX] = data_npages;
+			exitcode = SNP_GUEST_REQ_INVALID_LEN;
+			goto cleanup;
+		}
 
 		/* pass the firmware error code */
-		rc = err;
+		exitcode = err;
 		goto cleanup;
 	}
 
 	/* Copy the certificate blob in the guest memory */
 	if (data_npages &&
 	    kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, data_npages << PAGE_SHIFT))
-		rc = SEV_RET_INVALID_ADDRESS;
+		exitcode = SEV_RET_INVALID_ADDRESS;
 
 cleanup:
-	snp_cleanup_guest_buf(&req, &rc);
+	snp_cleanup_guest_buf(&req, &exitcode);
 
 unlock:
 	mutex_unlock(&sev->guest_req_lock);
 
 e_fail:
-	svm_set_ghcb_sw_exit_info_2(vcpu, rc);
+	svm_set_ghcb_sw_exit_info_2(vcpu, exitcode);
 }
 
 static kvm_pfn_t gfn_to_pfn_restricted(struct kvm *kvm, gfn_t gfn)
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6c4fdcaed72b..73f56c20255c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2070,8 +2070,8 @@ int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *erro
 }
 EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt_page);
 
-int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
-				unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
+int sev_issue_cmd_external_user_cert(struct file *filep, unsigned int cmd, void *data,
+				     unsigned long vaddr, unsigned long *npages, int *error)
 {
 	unsigned long expected_npages;
 	struct sev_device *sev;
@@ -2093,12 +2093,11 @@ int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
 	expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
 	if (*npages < expected_npages) {
 		*npages = expected_npages;
-		*fw_err = SNP_GUEST_REQ_INVALID_LEN;
 		mutex_unlock(&sev->snp_certs_lock);
-		return -EINVAL;
+		return -ENOSPC;
 	}
 
-	rc = sev_do_cmd(SEV_CMD_SNP_GUEST_REQUEST, data, (int *)fw_err);
+	rc = sev_issue_cmd_external_user(filep, cmd, data, error);
 	if (rc) {
 		mutex_unlock(&sev->snp_certs_lock);
 		return rc;
@@ -2115,7 +2114,7 @@ int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
 	mutex_unlock(&sev->snp_certs_lock);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(snp_guest_ext_guest_request);
+EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user_cert);
 
 static void sev_exit(struct kref *ref)
 {
-- 
2.39.1

