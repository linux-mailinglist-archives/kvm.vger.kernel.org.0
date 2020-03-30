Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F2F19746A
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 08:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbgC3GWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 02:22:55 -0400
Received: from mail-bn8nam12on2082.outbound.protection.outlook.com ([40.107.237.82]:43296
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728682AbgC3GWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 02:22:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncaVFbmB52rxU/Pb0Sg2FMiQJwzyMN430RRXl4njpN8MmYn/7YBElI9aatmg0gSBUirTJJRCAlce5nyNeEDSP9dxJotlDLk3ArO3JAR34zjOX0JZ6OGpR2bbkyeZRJ+VKsQaXbf7ljHTkn9cB6yiE+rdbQrXOZM+mTm4vtT2WActwJd07IGT6s+spzRcnh/qoDdICHBZS7KF3mn+s2/luLxw7l293Z2I1e8C13cBdZwmtVqbX5M/ICKtRHtHnD746MAw0BDUCGjJS296f0e6x8Y74pmVkTt8GRQESC78VXlG9KnvIGNX2eZeAT2Yjrly2w2ArO9u4ja2ZvE1ciaDCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tONNDZE99a8KL+WQna5wYK2bH3j1EgUeZhElYDMWRis=;
 b=RMSTJ3lUnWhWDwGO1Kwf+mX6j58fFLeRLcoeoc66pRXR22Hgvfae3uZkVG5QAktgNyd5Cx06xC8vEAo9JnLMOGKmZ8xr8p6chWsABwPLjyC3T3H0exApoYtDJVvnp7UFs/X9pCVF8/ZTWtR/i21os9v7+zBZso0mBRiKibfr/M1zdKu0F0AWg+zF1nn/Ixs3aAgzKVaLhJTVKJ5L1Aq4/l1m2ca48jAb2rwfIuKqVqfulfnfNQbtWzRHD7Ra2wOrONjaxar1zBPsVQjdAqPQY96gizZWsEtnzVtsoHoUKVEO112cpd9C4HShJVlL/0BXOrgpD3fZP2ZZV/+Y+G9v3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tONNDZE99a8KL+WQna5wYK2bH3j1EgUeZhElYDMWRis=;
 b=IBGGkNq+hZEZFjxGeDdgku1bomcppB10P9w8oCxQi3pyQU0uiPZIU2N4SS16MzV1myCheG6R+f3vO6fT6tBs/ZvQAkVNR9PCiDsw8ZouhyHjWbaoTyb8YpqOyEjDp42B9wsF5cYBUKU+BE9cpNFDO4uXwozKOtSP81tRqOmdmo4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1692.namprd12.prod.outlook.com (2603:10b6:4:5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Mon, 30 Mar 2020 06:21:14 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 06:21:14 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v6 04/14] KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
Date:   Mon, 30 Mar 2020 06:21:04 +0000
Message-Id: <7753c183e9e571220fffe3663b1139c1f9030fbf.1585548051.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585548051.git.ashish.kalra@amd.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR16CA0041.namprd16.prod.outlook.com
 (2603:10b6:805:ca::18) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR16CA0041.namprd16.prod.outlook.com (2603:10b6:805:ca::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Mon, 30 Mar 2020 06:21:13 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a4dc175c-56e5-4c0a-3aec-08d7d4728c55
X-MS-TrafficTypeDiagnostic: DM5PR12MB1692:|DM5PR12MB1692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1692BB9E4545F4C40F66A9F68ECB0@DM5PR12MB1692.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(16526019)(186003)(26005)(5660300002)(6666004)(8936002)(6486002)(4326008)(2906002)(36756003)(7416002)(316002)(66946007)(66476007)(86362001)(66556008)(66574012)(8676002)(7696005)(81156014)(6916009)(2616005)(956004)(81166006)(52116002)(478600001)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xwgAevd4BOOu+4m8rgf42R7kufH3qZ73jOW9/vppCqpyz2F7HcxJxKNkRILYiEL32QfV41ueXlXeRU66iuxZwI9eGBLpbNtpnLdW5PZq6gFCkoWwu4GinlvfhWC51W1MJqR7ILLW1jsmCT8zNAu32g1J6eUeZVSAY8TcdS+nyODOYaZRYN2sQq0efLHT0IlAajPjqUdreaFYZP2GDoLgOJhh+1DXA66Pr2C0uGGjl2fqinal0Qz0Hia9KO5z+tHU/kdUvnstzs/rR0kFm9xrfukXCPFuFr+bPo+bTkBtC7rVAtBIkTavHTuOfH3SWl8ffUYIjxh4VvlSKEpT5EFeyzFjrz0rJiHDD8b+xFSjRBMYCIbAg4ILFGcT6yXAex6H1wA6WMhgUr1ZtHhcyNQB9hSYn3yFUH4D+AtZquvzHATrjo9EixDSF7pBN52Ki4WTLfTUPIXg1IVxkvnS5SiHB4lFGv/zq0HpA88XP31f9vneDTlzPpQrIXMwnpDHhu50
X-MS-Exchange-AntiSpam-MessageData: 2CB2lVyoFc54q4ExwcLrlDljQywR/eiGvfB3q5KSkg6jmK1av119eHYSAZMcGrhbpacCt3XLVnSysp1ROBiTSq1pNR6tlOnAVSzhgFxcM+l1Lrs1geItjnuBldw05dd7IKJJkIwi/ntMTUbXmzIcDA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4dc175c-56e5-4c0a-3aec-08d7d4728c55
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 06:21:14.3220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xnCnWCQHj3VKKJ3mgXW4jLZQ6pUqHgldhde2mkFN2F83069vsOz1E7rgkAmpTPVHxhYFW38jmVrKaXWtSZpqJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1692
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

The command is used to create the encryption context for an incoming
SEV guest. The encryption context can be later used by the hypervisor
to import the incoming data into the SEV guest memory space.

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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        | 29 +++++++
 arch/x86/kvm/svm.c                            | 81 +++++++++++++++++++
 include/uapi/linux/kvm.h                      |  9 +++
 3 files changed, 119 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index a45dcb5f8687..ef1f1f3a5b40 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -322,6 +322,35 @@ issued by the hypervisor to delete the encryption context.
 
 Returns: 0 on success, -negative on error
 
+13. KVM_SEV_RECEIVE_START
+------------------------
+
+The KVM_SEV_RECEIVE_START command is used for creating the memory encryption
+context for an incoming SEV guest. To create the encryption context, the user must
+provide a guest policy, the platform public Diffie-Hellman (PDH) key and session
+information.
+
+Parameters: struct  kvm_sev_receive_start (in/out)
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_receive_start {
+                __u32 handle;           /* if zero then firmware creates a new handle */
+                __u32 policy;           /* guest's policy */
+
+                __u64 pdh_uaddr;         /* userspace address pointing to the PDH key */
+                __u32 dh_len;
+
+                __u64 session_addr;     /* userspace address which points to the guest session information */
+                __u32 session_len;
+        };
+
+On success, the 'handle' field contains a new handle and on error, a negative value.
+
+For more details, see SEV spec Section 6.12.
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 71a4cb3b817d..038b47685733 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7419,6 +7419,84 @@ static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_receive_start *start;
+	struct kvm_sev_receive_start params;
+	int *error = &argp->error;
+	void *session_data;
+	void *pdh_data;
+	int ret;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	/* Get parameter from the userspace */
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			sizeof(struct kvm_sev_receive_start)))
+		return -EFAULT;
+
+	/* some sanity checks */
+	if (!params.pdh_uaddr || !params.pdh_len ||
+	    !params.session_uaddr || !params.session_len)
+		return -EINVAL;
+
+	pdh_data = psp_copy_user_blob(params.pdh_uaddr, params.pdh_len);
+	if (IS_ERR(pdh_data))
+		return PTR_ERR(pdh_data);
+
+	session_data = psp_copy_user_blob(params.session_uaddr,
+			params.session_len);
+	if (IS_ERR(session_data)) {
+		ret = PTR_ERR(session_data);
+		goto e_free_pdh;
+	}
+
+	ret = -ENOMEM;
+	start = kzalloc(sizeof(*start), GFP_KERNEL);
+	if (!start)
+		goto e_free_session;
+
+	start->handle = params.handle;
+	start->policy = params.policy;
+	start->pdh_cert_address = __psp_pa(pdh_data);
+	start->pdh_cert_len = params.pdh_len;
+	start->session_address = __psp_pa(session_data);
+	start->session_len = params.session_len;
+
+	/* create memory encryption context */
+	ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_RECEIVE_START, start,
+				error);
+	if (ret)
+		goto e_free;
+
+	/* Bind ASID to this guest */
+	ret = sev_bind_asid(kvm, start->handle, error);
+	if (ret)
+		goto e_free;
+
+	params.handle = start->handle;
+	if (copy_to_user((void __user *)(uintptr_t)argp->data,
+			 &params, sizeof(struct kvm_sev_receive_start))) {
+		ret = -EFAULT;
+		sev_unbind_asid(kvm, start->handle);
+		goto e_free;
+	}
+
+	sev->handle = start->handle;
+	sev->fd = argp->sev_fd;
+
+e_free:
+	kfree(start);
+e_free_session:
+	kfree(session_data);
+e_free_pdh:
+	kfree(pdh_data);
+
+	return ret;
+}
+
 static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -7472,6 +7550,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SEND_FINISH:
 		r = sev_send_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_RECEIVE_START:
+		r = sev_receive_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d9dc81bb9c55..74764b9db5fa 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1579,6 +1579,15 @@ struct kvm_sev_send_update_data {
 	__u32 trans_len;
 };
 
+struct kvm_sev_receive_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 pdh_uaddr;
+	__u32 pdh_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

