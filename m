Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE452D35DB
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731090AbgLHWGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:06:17 -0500
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:57249
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730486AbgLHWGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:06:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0swFEb4D4NZaMFYrBBCRaazF220c4Z2pBXiNpFHVKLDyVNA4FNfH6A9edlBGeCMd8SQZjpexDRbPLzxR2teQTr66HmddldbyeNFRDXmQN8JRMCf5jRpPgftsfworsMWnK492PrlqYv2TwKA8scpQKouzlJ65RN0INTqT8xl8jarAYYxsm4S7W0tM3hc1UbmyDa61gcG47nwgAvYlIvt+TKZKDJphCvOMaAMu7dC7nfrILAEA8ZLr4l3H7kv/K/+knrLrPM2B/mujkmJXiTB+VEt4dW5X8zh6Gh6vd9hrn4XBlAkZZhk4XXtIbMcDQI1YWUkqY/GT6ke/U/ZeTPh+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NAmR6CWsuJUlQeY7uPxGIgdpumtP2nA0+dUYjhT1NzI=;
 b=M/VXo7BTuUjBMuHYAM8BPi21rzbIuhuhR29t/Zy1g0cWyggTw4R9VEAPe5I7tVBtD+wJvLNcne4GiM7MCvLikA+ARVl6Z1r0o1G1UfOaInB297gFKcsMRhWssgDWZd4wgjXpIFFTKq3w0EN1/eBMIukPAbVSan68hisoQmLkKlfJZVQ458DLWtxlJ9tCm7I2VeAuX9uc+DKR2tDuxdzAAPXX6ibjunSXac669HakpFg36N6UNF6EXk64nkX7bmnK2TNmGL+G0RV9GMuWqNtR+G4G+zez/v5U4tdpiy1jEhCMKnatD9xe0miM3UYAC809q9JmE0IHB04PLlrTmLM9fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NAmR6CWsuJUlQeY7uPxGIgdpumtP2nA0+dUYjhT1NzI=;
 b=K16ZHoMT2NXB8vF/5WAnYx9u10+ITlUBfoUkD6CD9BDdjdh83cHCYd4dKtJILz3oC2S1+eN147sxCg1+bjiJmargEYbCwst3xySyRTm+He0wEiWmhRtMb8KUtEMyw0bitKQqB5RGY2LPQmJWOYtN7/sAKX+8YiupOayt04TvmCI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 22:05:14 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:05:14 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 04/18] KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
Date:   Tue,  8 Dec 2020 22:05:03 +0000
Message-Id: <f9bf367910b088b8b72b4540727f4b78aa2a0b59.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR19CA0030.namprd19.prod.outlook.com
 (2603:10b6:610:4d::40) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by CH2PR19CA0030.namprd19.prod.outlook.com (2603:10b6:610:4d::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 8 Dec 2020 22:05:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0b804054-7ff8-4a65-4a67-08d89bc55752
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26409664E4423982E0B0182F8ECD0@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: or/gCWIAtzcsQdksawbWSkq1cxm6dDhqLgRnhqpimwCT5DmfCQIO/thMHSSciyuwYZpqPNB8cj9g6qUuQKhkTXe9gnqy18ntLJ8nyYX95sO/9W6yID6NNJyfbroqjeNXtgUlpLVGSXgopc4vR/cOYXXmuFigHQ/nOcF8I58pvzRSXPIaLKtAXrobtoXuuW35VbKeSv+bwKqBgmhxcgBmRFME9iuUew+jS/lHF6YMeFQ4pzfJjIFzmK7gU5R1kicwx2eje47NpKI4189C88HB/JiipwkoO/0RH2uUIMpMbK3DHf1r+chtvLj5xjMuGck3GHRwL/Ie6nEsCzSUCX2d5Fj32NCvEBgHXeDVhd2i12UEa819fKhOnz7/h8HCUV9V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(2616005)(2906002)(66556008)(83380400001)(508600001)(4326008)(5660300002)(6916009)(52116002)(7416002)(66476007)(6486002)(66574015)(34490700003)(186003)(6666004)(8936002)(16526019)(8676002)(66946007)(86362001)(7696005)(26005)(956004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Njd1OGQzTjVqSmJJMk53c0c3YkJzMnBYenBORlBXSmRBM2pjbGFVSGpGbGx3?=
 =?utf-8?B?dE1TS1p2czIyS216NlIwWjlpZHMyUUtLNWhxaVF3SWNsbkN5WkVtZlhpcnJP?=
 =?utf-8?B?ZXpMRmxPREY4VDFFTDRDZDBVNmdKc0NWL3h2VTB3OEdRMjdJbEd2RU55eURI?=
 =?utf-8?B?ODNkcU5LaUc3czNOVjBKUmI1czNOSlhQMlVRcGFWZ2dLY3pmOFBvWEhFNk9J?=
 =?utf-8?B?RHpmZk9yQzU0RkluK3FENGFLZU1KQUtyNUdFWUhGdG00cW1hVDF4bUFtd2R2?=
 =?utf-8?B?WU80U1ZTTEl2M2doOHRkR09kRjQ0SHpOTHhLV0wybFdsMk1xNWgya1VTK1JZ?=
 =?utf-8?B?QjU2djhNOHZGazNESWVMVStzMEFkNTRLWk8vZlRpT0VSdlhYdEthTmtXRThh?=
 =?utf-8?B?UGZ6NG9rS1l0RTFQYzlDZ002OU1aUmNIT2ZiSnZ2WFNsNlh0aUhSOFc5cith?=
 =?utf-8?B?UjhuaytEV2g1eFpJR3BwVHZzYmpoaHNBazJTYzZoL2VZNksxUHhpZkQxT3Nx?=
 =?utf-8?B?M3d6clNRWnFNQ0J1K0NJN1d2ME8zaC81V3BIdWsrQXZuZC8yemxSa3lqVVVE?=
 =?utf-8?B?UmZ6NDdrUUhEMG10aXJKN3hSYmNmdmpId3RUbWRucmRYQ21jQXBkSVh6RVIw?=
 =?utf-8?B?VzRxelF5V3ZxQkQ3ZGRBYzRpaG9xT3FaOUs0ZmpFTForbVhBOGlLbDdiaWll?=
 =?utf-8?B?d3ZaUDZXMHNpZHJEZkZ2S3BtcWVtWEpScE00RUIrQm4rSzZzV3lGb2xRVzZa?=
 =?utf-8?B?V2RHU3JVVXJRek5YK2RmN0hWODl0OUhJOGo1K3d1SklkWjg5bmtRRm1KTnV0?=
 =?utf-8?B?U2cxN3NtOVE5d2FJSlltTWd6WFhMTkZwQjhGSGVPSWVQaVR1Qkw2ekcxSWph?=
 =?utf-8?B?R01mM0RpaERwaGZ4dlNocXZ0N0J1ZzZ0Q2hNL3Q5TVFBVG1XYXhiSVNXSTFL?=
 =?utf-8?B?elA3T3NQY1RRc2FUOTlCRkxVamU0K04rOWRtMis1NjhDSHlLMm5obWdMeTQx?=
 =?utf-8?B?UUNUVXJYekxjL0l0dDFGSnRIYXhDa0F1K2s2cWdaU3lhRkVGUkJYMGVMRzV6?=
 =?utf-8?B?T0RJUFVmNGxwbDlTTVAzMG1PYzFtc1BpMUpBZERrTEZDNldBTlZpUTV3ZkFW?=
 =?utf-8?B?d3lwcHN4Q0tSN0FPY0tiVWJ1MHI1NkNzVndPcmNkc3p5UThtZUQ0NHh4N2lW?=
 =?utf-8?B?WGxBN21VL1IwYkdEaUd5M1hBUHo5K2piekV2NENJcGZ3UE9IUzB3K0FKT2VL?=
 =?utf-8?B?cTRrNXBIeE1XT2kvMTlPUm1KNGc5VEVSNWlrU01CUE1qTTVzN2wxbHRhUWpm?=
 =?utf-8?Q?zOeZElgJPX+bA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:05:14.7179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b804054-7ff8-4a65-4a67-08d89bc55752
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7kcMu2O4sfgx6ZFwEzwVOth33yMMzZbwQK63lCXjij6HrZUcElLSB+/dRyLujol6PZsiXkbR1No6EG8ScEsmPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

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
 arch/x86/kvm/svm/sev.c                        | 81 +++++++++++++++++++
 include/uapi/linux/kvm.h                      |  9 +++
 3 files changed, 119 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 0da0c199efa8..079ac5ac2459 100644
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
+                __u64 pdh_uaddr;        /* userspace address pointing to the PDH key */
+                __u32 pdh_len;
+
+                __u64 session_uaddr;    /* userspace address which points to the guest session information */
+                __u32 session_len;
+        };
+
+On success, the 'handle' field contains a new handle and on error, a negative value.
+
+For more details, see SEV spec Section 6.12.
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 877780222378..25f869dc1448 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1187,6 +1187,84 @@ static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1240,6 +1318,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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
index c6f9d58b5a81..a9e6ffcfe7e2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1664,6 +1664,15 @@ struct kvm_sev_send_update_data {
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

