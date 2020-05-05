Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780191C62C0
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgEEVO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:14:56 -0400
Received: from mail-bn7nam10on2087.outbound.protection.outlook.com ([40.107.92.87]:6075
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728569AbgEEVOz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:14:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9FpM6g/rRwk3sVqXhwRn7zdSMoumI1GWw2A/n6/O6ifSkbI+nmZxBNOaxt6aYXuhpcUVGWSK4EGw7OmGcKGOLmN2bCLTpwaSGEmDYEUfQKlfniwJ6WKYwBUFrgOzHMhvwrb7lnDiW+Vvvnvi/y9F8IyeAdscv5qxB7ziY9a4op/U6TpRzE77qBMbGsYOIbqnuYsI5yrOS4VtR2EE9aT6Kayw1+14kaxFYgd1uZP7ZiibbagYrEqJ6N+Ip4oQsbjGF7b7w7VCgepNwdEbMFB4DxCp32NRpSIZaUWibmJmx8PvOrwuqCtjFytKUEkhaIbf1PcC/ywd0ba7v3ieocpJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDgfuQklGju4Gg05clXYxpilK8eFCAieFKUU9qqubCY=;
 b=gjRFnCR3xqVdg47wg9E4cvxZyDcL9asVJ1ATI077ivNdBtJLHkAahfVxoPa3BgAbTvSFVPFHvQgklCVoKaafLIf6SdfIarjOO9h7wAGimVGQEicMiHDgctDtx6+C8Qih2Et/9jFirCAwITTm+4Dd2rV9vbq38Q8OEhXAbn1gXsd5vUuT4f3KzKUlj8tt4EaTL81GkXMPZD6o69dksJGo1ZdN9211NJB7UItxoC7XOmx0yituEDIOTecPrxJ9qkVoaKdw3CYXtV8x5RO+3osK5zAXeASTfJwcKbubiUx0nKFZtrBUUxadrdYC1JYy7qqcFZsYftajD+IAO/4j/8hGaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDgfuQklGju4Gg05clXYxpilK8eFCAieFKUU9qqubCY=;
 b=rjp5I1TzxdWXXhWmDlLDeJwVv+fxZYX+xaNrsn9/NV1pPHZkt3ybzcNznvHgA0QbjEwAYgij/sGpafjTin/3YOCBIGqJLiQM3CN25ZpYLwRnJa5yP8a/sW9v2oQW51DsYy7tQywsYmTt6Q3bAGTAVnRPV7qDzCfzIPldJhe9fvA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:14:49 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:14:49 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 01/18] KVM: SVM: Add KVM_SEV SEND_START command
Date:   Tue,  5 May 2020 21:14:39 +0000
Message-Id: <58e0fb4c4d207028ec3b13cc3c20503224c95b86.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR16CA0024.namprd16.prod.outlook.com
 (2603:10b6:3:c0::34) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR16CA0024.namprd16.prod.outlook.com (2603:10b6:3:c0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 5 May 2020 21:14:48 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 01520af0-e10f-4e37-65c2-08d7f1395827
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB25187474BD0D35C70EF2B8398EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a5qzEWZXhMAHEa7UdKaM5lL/1aCLrVc8ntehAqrYWMX6jwzOShsO2+wTb+P/+df4ZpGApCdIwB0m/MN1wWvBC+LCRiEc6S6Zpvdbdj8q6CUHbc1ShgqTy3CrDle6xsjRPq14GgKK1XOwXZA9LayyrMInqtbHkE/y9C2N09hXQOGxZ/bwwxZ0KzBeAYcX0I8rv39CbcKd8S2p48LzrQs8YYOD/k8iPo3fM7p3FJmfIQUT0MogGfDd1vy7dkj9aMrpbXcXupAvmZfNyaADFaUnmmykg+46cAVO0mX/EnrQ9ndsSgSBRGezBHiFfKb0QxTGbXOD8OYtl0nPDSHrmqC7Kdr98B7M5nMB27evgsZmowzbQoLVuY5M2Ec89kncjUZ8NnmBYP8f0GJveyzWB7AehHhgsfS2TIzcifUp4QwicWHrgSNtQS0qNAcm3SsycfBP5IdiJoShaCbOVc+hL8zJxwwVwwEeJaHGfqhHpkqDu1RxtCv8hrYbKjwIC6tjiVyc1+TP+FPBov9yqHdBZ47rqZR4E5se3aGReNZafzs+KwpFKonP5s37ARr68ajGeKxi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(478600001)(6486002)(2906002)(5660300002)(6666004)(2616005)(66574013)(186003)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uKY+IUi2QMDMTfdLkZAabxByr9M0k0AJpSScir1ZA82S7FwLYRsQd4gt2fHiFIIhiHuwZ2QvUVsqV9n8Y020PFXwotNUxrrowAAjjlLXtYX/bWG1Utpa2P6m7sj0ClhcJqaDXHN+kZkloxgQhkpf9D1Cz/NSeu+SZ9izx82uWHKYKyB5U8p7HTAXGfOFh1hS5jTjTN6ZWLQXLEUnETZhi/iWcWbyAGv+JoKYDIif8z9yS5HN4laSzYIYrL45omROHAR//J5wNc+iyMX0lPJabuumBuRtiep96McnjKQPU0zyqx4ZVSoYwXH9SnOWAUHflT5qa5YecBIGBDEhg210s9pUz2PFy1gGeuhih876cmfG4nFkhUWTi94Cog3M4ZSaGMrgjYV8oG2ijugLlP1JUTLNO1zjt0qBNqBKLpeIZnQeeltbkp1pfMqqY+SB4lahXHiewJD67WXXgKxMr93pBG6urZCxywYOz24hay6qb/7FTkhdWMFxpbQamoYkudY83GxZFkMhbfvEdVGpxp4o2UUzDnNyoUVVtjsk5KGwDNne4vF28RQ/pHrj99I4IjGCO4vN/5wBosmZHHlz2QWeTannuALz0xiUmf6FVMa82BzGJ4wmR7ST1EcdHF+6Vl87eGqly7hvaLK0yhRgHQUPUMm547YdNl/No1blPmP813+2VcqAwhql1p886MW83MtLriKdgdAlkXoTu+KdghzcegSKbpd6bdZ+gredLm1B9pVIZmjTejwYXaRzQemQsLONJsnczS29S8L3XJDixy038gCymFcc2m+bjJtSMaBZTT0=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01520af0-e10f-4e37-65c2-08d7f1395827
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:14:49.5169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2P10ktXDd9SRJANM5lX6ZVaDu0PsPjHHKpvmhCmdl58jk3nBx4ljkrRH1RlCgzPcwp5NY1UVx+WzWjg9e2aDnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

The command is used to create an outgoing SEV guest encryption context.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Steve Rutherford <srutherford@google.com>
Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  27 ++++
 arch/x86/kvm/svm/sev.c                        | 125 ++++++++++++++++++
 include/linux/psp-sev.h                       |   8 +-
 include/uapi/linux/kvm.h                      |  12 ++
 4 files changed, 168 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index c3129b9ba5cb..59cb59bd4675 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -263,6 +263,33 @@ Returns: 0 on success, -negative on error
                 __u32 trans_len;
         };
 
+10. KVM_SEV_SEND_START
+----------------------
+
+The KVM_SEV_SEND_START command can be used by the hypervisor to create an
+outgoing guest encryption context.
+
+Parameters (in): struct kvm_sev_send_start
+
+Returns: 0 on success, -negative on error
+
+::
+        struct kvm_sev_send_start {
+                __u32 policy;                 /* guest policy */
+
+                __u64 pdh_cert_uaddr;         /* platform Diffie-Hellman certificate */
+                __u32 pdh_cert_len;
+
+                __u64 plat_certs_uaddr;        /* platform certificate chain */
+                __u32 plat_certs_len;
+
+                __u64 amd_certs_uaddr;        /* AMD certificate */
+                __u32 amd_certs_len;
+
+                __u64 session_uaddr;          /* Guest session information */
+                __u32 session_len;
+        };
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cf912b4aaba8..5a15b43b4349 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -913,6 +913,128 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+/* Userspace wants to query session length. */
+static int
+__sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
+				      struct kvm_sev_send_start *params)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_send_start *data;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (data == NULL)
+		return -ENOMEM;
+
+	data->handle = sev->handle;
+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
+
+	params->session_len = data->session_len;
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
+				sizeof(struct kvm_sev_send_start)))
+		ret = -EFAULT;
+
+	kfree(data);
+	return ret;
+}
+
+static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_send_start *data;
+	struct kvm_sev_send_start params;
+	void *amd_certs, *session_data;
+	void *pdh_cert, *plat_certs;
+	int ret;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+				sizeof(struct kvm_sev_send_start)))
+		return -EFAULT;
+
+	/* if session_len is zero, userspace wants to query the session length */
+	if (!params.session_len)
+		return __sev_send_start_query_session_length(kvm, argp,
+				&params);
+
+	/* some sanity checks */
+	if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
+	    !params.session_uaddr || params.session_len > SEV_FW_BLOB_MAX_SIZE)
+		return -EINVAL;
+
+	/* allocate the memory to hold the session data blob */
+	session_data = kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
+	if (!session_data)
+		return -ENOMEM;
+
+	/* copy the certificate blobs from userspace */
+	pdh_cert = psp_copy_user_blob(params.pdh_cert_uaddr,
+				params.pdh_cert_len);
+	if (IS_ERR(pdh_cert)) {
+		ret = PTR_ERR(pdh_cert);
+		goto e_free_session;
+	}
+
+	plat_certs = psp_copy_user_blob(params.plat_certs_uaddr,
+				params.plat_certs_len);
+	if (IS_ERR(plat_certs)) {
+		ret = PTR_ERR(plat_certs);
+		goto e_free_pdh;
+	}
+
+	amd_certs = psp_copy_user_blob(params.amd_certs_uaddr,
+				params.amd_certs_len);
+	if (IS_ERR(amd_certs)) {
+		ret = PTR_ERR(amd_certs);
+		goto e_free_plat_cert;
+	}
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (data == NULL) {
+		ret = -ENOMEM;
+		goto e_free_amd_cert;
+	}
+
+	/* populate the FW SEND_START field with system physical address */
+	data->pdh_cert_address = __psp_pa(pdh_cert);
+	data->pdh_cert_len = params.pdh_cert_len;
+	data->plat_certs_address = __psp_pa(plat_certs);
+	data->plat_certs_len = params.plat_certs_len;
+	data->amd_certs_address = __psp_pa(amd_certs);
+	data->amd_certs_len = params.amd_certs_len;
+	data->session_address = __psp_pa(session_data);
+	data->session_len = params.session_len;
+	data->handle = sev->handle;
+
+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
+
+	if (!ret && copy_to_user((void __user *)(uintptr_t)params.session_uaddr,
+			session_data, params.session_len)) {
+		ret = -EFAULT;
+		goto e_free;
+	}
+
+	params.policy = data->policy;
+	params.session_len = data->session_len;
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
+				sizeof(struct kvm_sev_send_start)))
+		ret = -EFAULT;
+
+e_free:
+	kfree(data);
+e_free_amd_cert:
+	kfree(amd_certs);
+e_free_plat_cert:
+	kfree(plat_certs);
+e_free_pdh:
+	kfree(pdh_cert);
+e_free_session:
+	kfree(session_data);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -957,6 +1079,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_LAUNCH_SECRET:
 		r = sev_launch_secret(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SEND_START:
+		r = sev_send_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 5167bf2bfc75..9f63b9d48b63 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -323,11 +323,11 @@ struct sev_data_send_start {
 	u64 pdh_cert_address;			/* In */
 	u32 pdh_cert_len;			/* In */
 	u32 reserved1;
-	u64 plat_cert_address;			/* In */
-	u32 plat_cert_len;			/* In */
+	u64 plat_certs_address;			/* In */
+	u32 plat_certs_len;			/* In */
 	u32 reserved2;
-	u64 amd_cert_address;			/* In */
-	u32 amd_cert_len;			/* In */
+	u64 amd_certs_address;			/* In */
+	u32 amd_certs_len;			/* In */
 	u32 reserved3;
 	u64 session_address;			/* In */
 	u32 session_len;			/* In/Out */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 428c7dde6b4b..8827d43e2684 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1598,6 +1598,18 @@ struct kvm_sev_dbg {
 	__u32 len;
 };
 
+struct kvm_sev_send_start {
+	__u32 policy;
+	__u64 pdh_cert_uaddr;
+	__u32 pdh_cert_len;
+	__u64 plat_certs_uaddr;
+	__u32 plat_certs_len;
+	__u64 amd_certs_uaddr;
+	__u32 amd_certs_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

