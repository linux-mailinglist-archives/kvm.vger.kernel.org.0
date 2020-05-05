Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2531C62C9
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbgEEVP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:15:56 -0400
Received: from mail-bn7nam10on2049.outbound.protection.outlook.com ([40.107.92.49]:23149
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726593AbgEEVP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:15:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Do42VTnO6SJT+hb11q+b5Z9SKI1vh4BCXzmpkc5YexqF1TX/fCI5UB+/DF9+3cJ3CTkRVEyBsWHyZS5g0hxgTJV1QZFJcZUgSqoVBMkKC6c7iRLBhoGO8MjjqYmx7fJQH6qxSWZpF8Exy5tVlJWmVzy1d/bJQSx6R5aXhqqeOtrBOjtimXso0dZFWmY9vzHwc8aLEePnkflO3i27KK4JY+7THYtL/b2JC0kxtxJWpGguzS4f6WRUmMHUFFwp5/nXowWmKPeBJGvn+NOO2lyrw4MeiFeXaWLR5YXxGakGjN404mJYx8lnjt7WYlaTyfi0i+onhxFS72XcM30Ux/GebA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjJZixnJDfkhDsqg7fjk4XzPCgKAeabThStuu2/u8TQ=;
 b=mrA+zIceXlLhfzLYsTemkIebvEvcUEjnEjoiAFZMhAGbyfL/K4Y/Egpw1ZSpA2NgujqiNSnVe6P68DhGjm4O3gN9UbjGYmKWwWIUhzorDtbBYkqwGaGDAs/2grgLzejFJnONmNw3ANRe4A/g27UZB7X9TXlwVmQDBS9i/3dB1KxoGylPoQphPWKRHBJdmdU+clgX9v1fvsHTrnwEOMAfXIdrbBJC0tf6Ujivl/LWjmCJmsL12l+0V9jg1bo2RyyvdTO6DAaK50tLmX3P7IDt7gK1DGsU1X/TNoccOQNLaYHpphi1k0GeekZxx9GlQNWwnN1VyyrYjAZbLFYMXL5cXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjJZixnJDfkhDsqg7fjk4XzPCgKAeabThStuu2/u8TQ=;
 b=QKJVb7a7WBuht9pA35Dw0N6qHK6RO3mv3OEeMh5UkcJqaC5c0jk+DxzBWoX5AwFo+St7ugHjyc5cHJSIr/rKZHUPf5XSR/Mfcj+N+1pNc4NlJDBEkhaj4+mff1sPS95gdUdXa2FLh9+5b6oFexGL8Tso5Gnf18HGw2zt2o9sw/o=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:15:50 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:15:50 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 04/18] KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
Date:   Tue,  5 May 2020 21:15:40 +0000
Message-Id: <cdf08144fe1cea7775c8bb288ae761c4572f8c6c.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:806:6e::23) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR11CA0018.namprd11.prod.outlook.com (2603:10b6:806:6e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27 via Frontend Transport; Tue, 5 May 2020 21:15:49 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a45d0979-fac7-49c4-fe0a-08d7f1397cbb
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB251812891FBEB02FB327C3598EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ifnHq/jNjuPxG1XcFxsft7Ms9BDuiJeLcHWL1mU2EMroRwk0ExzgEXugFtKe92DrmQdgPmNRQvo90YYAF+j9knkFqZljtiGcQ4LZeGUHQjFMfFFNEPdx6JK9SWHNUjhhqntpBE2n9GjwBUqwhusm7D5IMloqtrIz8DW81u3m8I7Kybx4dHDBN00kThmVxmfU+OKDzuex+MGoz1Xn0MUbZjv+RyIGejiBD4JsKCmGj3atAB5PwcPLRDLISS5LdZ2k41+vn3DrKQoW18SCnAxVcPK0s0scvtEUzdCklyf/YZUIEEfUB6fWzQEWdOqGX9gtUuyxn+b4LBspH0ze3a4QhhbIzHhRnsqlMVoyWJ9o5p4ibPqMTxOR7soeMejhojeYqM6RWEj5e0WWtaPTkx3wiiXx6EW56OozMWieoOgG48eRCAOJG2mxtGnVVOtLpOf6X8Ulgfi0hK2SLvispFvAyAQxYQK+752QX0APXArQAmXXLuy2e+udwpwuLXtzvqhNtaZTT3DkaBFguoTWhBfjSnvo1wJ83n2q1h49uCqYswK1EagPaEXHCOSRLUbu6FTn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(478600001)(6486002)(2906002)(5660300002)(6666004)(2616005)(66574013)(186003)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: T4Ys+jKukfSH4ibltrFy2ejGOpCr0qP39co/YhPYJv/arue1wBIDNe5+GcsGvqSc1dY7dRPnLeUEhIpOdTqHnzeOnEknuUwdHB3oWIWgndqwcSVHgLrQow/7yqYqikObYUTxBHpkLQa/dojyiCB4/BdocqqWq4Mw7yfkJgva7bZI2d8c2rDckNqW42ygMLRj2EF8Qww33D3wt1/4ATkmcJSBUxQrh6xHpOI9dIYRFIXNAuyv8hgAZmG8RmN3uThlWVx7y6ua7PWaaMZCz0l18NDvnOnomQECSdJ1A7vW+kgtOtxRSNa1b02SJhFpTJcOPi5f+gSYhV5cLKrUMwpeS5hdKH3ymhwJH/XIsk8XFK//9zLuDEqN43X2Igssc6L28pGO6iTTC8seA6DBHnZyWcpyVYzg7uSUFydMXlPcS4mvbN6WbziyV97H9O+LADL54ZUdjEEPXARPkrHBJB9n2OzYlWBJFKGDepDMAzfj9tLeAMQGoBhdPU7VMuktZfKN9WOlDd8ed3SL/wEcdDZ+tZjPF/uBDRvW8CFaUjCwsDlJoBSCrvUPRUhfwjxh4DJMxL2m35k5pGpIdJbUzqIYf0hTvheoTtN/4fSx2vy0NzBd5enpLXdpeYnotaunTLEe3uEYEEGeSjQEs+WE1qFWA5LPgOoLjPYpKQb7TizoHypNon0JmEVwQg+u8TMqv/kNaSGcJ/2Z8hYrogNpQ+Q/OlrWofj1+LVOju29LlvasPM4Ls+hpQ2FA5J/BtAZLx977LUEHT9IK8yRNqFiI6KOz+Tm/Lfp5YXdhgQqVq5Qa+c=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a45d0979-fac7-49c4-fe0a-08d7f1397cbb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:15:50.6608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4L6fpWPLc0fqhLWwh4JGLphlDw1P57wfZN8RbxC/k5eJDcbJG6V7plFAOWDE9Aq7bceoqCWrAIZIz3Oeo6bmtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
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
 arch/x86/kvm/svm/sev.c                        | 81 +++++++++++++++++++
 include/uapi/linux/kvm.h                      |  9 +++
 3 files changed, 119 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 93884ec8918e..337bf6a8a3ee 100644
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
index 4d3031c9fdcf..b575aa8e27af 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1173,6 +1173,84 @@ static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1226,6 +1304,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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
index 7aaed8ee33cf..24ac57151d53 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1619,6 +1619,15 @@ struct kvm_sev_send_update_data {
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

