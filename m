Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2507C1BF313
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgD3Ikt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:40:49 -0400
Received: from mail-dm6nam12on2076.outbound.protection.outlook.com ([40.107.243.76]:14610
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726754AbgD3Ikt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:40:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOdjiy7b794A6y+z8gEsAI61X6skaOPZMD53BgfCC1zziI5yE9tmNhFlnBQkWrDZIh7Q47G41bnpyMHE4KRnX/X50hOEocIRqGdRsjxMOvdYozrPeaSvh6D0/Q65WSLB5Ps6itCSHu3/VoHnKoHkS4KqjyCRh6ZHkxX3aZJesWtC5he+IUOa5cypjx6HJLRxSi2NXJfsqCKLPiuUkw/bupMQFgH4MHvl5ROVNYI0le0jFwu80RhQ81GvLGbyAUYvr9g+puMLF61/5nlKzbSRabqutBNZBSpzdCZhTgbBRT5EHEsjm+raHUdJLJxQ+XxlpFxP1JalprAzo8G7gUkLNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RN28DlwIc8RRI8Uq6lrkfx+zWgbR9fO57VBxpIVyYE=;
 b=ZSNMWARCMNb7bfMqpMpuWkiDD1Ec0bx7vx1fozAm7xKNRTGs0yPdFUafDRzpGKreBA16tFXnqbGEqIb2MV70fYczXz7V116ntUiKPk7jDhm1ULMwMn0A8+yWEOGTREMeX7wIWYeDCa4uydDHlcZsm72DI+LXgVBksK37ad53EjEGclzy9iCewW1wFXa/KWDQQLU61RiRP8Y2TuTNp78V2nQIoqr1OI+vFDU1Q/NNPQ4D1+nwwFjHeJXLtAeh0zuxlMmgjnpVEtWiVh0mr8dkh28XGXjReHu8F5B9RZDwg42Q1yve36IZJVb4SZ1IPnzSUOwJYR9n229EUVv/zMYaEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RN28DlwIc8RRI8Uq6lrkfx+zWgbR9fO57VBxpIVyYE=;
 b=uyO8BceXHViSbKMRqqUFyrOUl96VzqLtJn2ebHtVBrcueRDT4ZqCoc9It48xJKE6kcUmv2carrtB+z4S+rN+B/9tWc0BgapWZcvoQYunqzxdBxBfP6at5UH2sZSbmRwYd3E7/bFT3sheuDetEfYjNlV8WHX9PRusgb0k4mJT2oQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1194.namprd12.prod.outlook.com (2603:10b6:3:6e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 08:40:45 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:40:45 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 01/18] KVM: SVM: Add KVM_SEV SEND_START command
Date:   Thu, 30 Apr 2020 08:40:34 +0000
Message-Id: <6473e5803d8c47d9b207810e8015c3066c39f17d.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0012.namprd08.prod.outlook.com
 (2603:10b6:803:29::22) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0801CA0012.namprd08.prod.outlook.com (2603:10b6:803:29::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 08:40:43 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e1042b79-54a1-4432-5929-08d7ece22c43
X-MS-TrafficTypeDiagnostic: DM5PR12MB1194:|DM5PR12MB1194:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB11940496187FF24302381B698EAA0@DM5PR12MB1194.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(4326008)(6486002)(6916009)(66574012)(66476007)(66946007)(52116002)(186003)(36756003)(7696005)(6666004)(316002)(5660300002)(26005)(86362001)(2906002)(8676002)(478600001)(66556008)(8936002)(956004)(2616005)(7416002)(16526019)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KintJ+iMvXU4o8iu2vQ/fgcGA19w0Ufkg90/gUL4Nu8ypfpu43+XrYvuUgdhBGXH+qzoXo3CMBZDgGvWcCX15HBvy4840UKnCnmGduaOrf2G7CFii5SAAhFVF8GAQ9IKv0QlDtsh3siyrWp6pyKepImWdl8qgABf682qSqnFXzLf3wc6IEtEa+RPupq29m8P8aJg+L0Pu4xVaY9wfRQoWN9PNfkyxzwRn/V8uebKJbiBxLF/wtbQbtc4o8UaFZ+t+ISOjQOkoCYIFsWwKiPx6O0bpR0mTe4tlyouDrd7LdTmAMeSQcOF2TwyJxtldYa4idrD5iWTjfQhzP5AlhqXAakJRgeBDHoeSDyCHb97r9A7dW2oRoHpSBNwqTQZ11ppIteThtR12ukNsZYvylY5c3U+mwhA1yyEcFu777gejOU3BovTag+kXHIi891FsljcGDbMiWKt4m8obPpsiII41dskl/z4glwBkC4EAJiGz4MtwF8P1jvqLw2cepkAIwsh
X-MS-Exchange-AntiSpam-MessageData: 1KO4DvalnBEgzG2luYDHNEVm81x+1v7KcshDqUznuJocVinprSg2mlyelpEPJT1mOzCQXPPNkNouMmvPoa0YUqTrAYHJPGuSgEL0ksIVsFOOWPrBamr8/oqpYTmVj1/bJp27c5AVumNniXY/IcYUDJnsLEuowGUldIwLyrdumW8Db/I1s/JCVeuSZcIR/X8wtChVm67osSsLG+k4faw21HuiR8ImyiPVYnm4pqY0Sc5l6HB1e17VrrnvjkP/lTupXqALemjpPFsuqAKPm3+rfiyZSTt+nf5Mq+ofSTV94igpBXuk9za0zq/kPaUS9TeM/IFokd9KRs15Yb40e/V8gRxHtVSeid7EiYyMNRV2F6DWVVldD+bT660WMBLrhEDz4iQBUVy7cwLaXPKLQ3pw0s1K2LpXmjrfylJ25rKtOvkLQVTuVFARNXLG/qXw5fBBGnzFWiOEGaVProRxWlwqX18qOJXWAQP81jh+vr8SZh+l+fekgrwvFqvudp9AZG71GQWV5iSFKcRzAsBIackjdm/Mu6wt53Oeb1oUHSB/+nTmxEJhrnd4ORy4/LPmvaJaBiVBVNL2sOKgLpoZIutlMSzQQQv6envWcIprAwdWrlYowzFciSogl0DKPgsusHK9FbapDyQRu+XxarAjlClXC7c3YoeH2wDrF3yQIBTNrvd1gOCacoxF7wzQXdB0dMXxVAAyGLyg74aINH/ucbpfTAUxUx2WYnThVg6MAVorY86MZy+BasOGXKSfRWnQq4xzS97TW7RrcpslniyawX9i49sWwwTMpI6odkMX3l+dG14=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1042b79-54a1-4432-5929-08d7ece22c43
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:40:44.8838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SQJl8X2SPL1qVRQ7wCDwtTm2O4vuHhpe21JzGk2AWWhmAKeST/SEFxBcNTOeTvLRoWY+JbkBJN1bDwFVUv+tkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1194
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
index c3129b9ba5cb..4fd34fc5c7a7 100644
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
+                __u64 plat_certs_uadr;        /* platform certificate chain */
+                __u32 plat_certs_len;
+
+                __u64 amd_certs_uaddr;        /* AMD certificate */
+                __u32 amd_cert_len;
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

