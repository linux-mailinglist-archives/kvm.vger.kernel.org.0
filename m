Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C47F1BF325
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgD3ImT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:42:19 -0400
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:25472
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726412AbgD3ImS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:42:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPz+E/DZMwKeMn6p8/u1SsMjJAfxGZ0Ed2Ey0U9a1vriMbfb9Eq8OZh5FVFhb+8o9f7uTTshumXIvDzyDqGQLy944fB0TISRdtxLoKt8JABFYDdW0wgIzxC0Engazm8M/gu8k2NB5pwDrCMagynabF6mG98xx5zc0ayMv9XgTuV9+YP+r8Ql+nRIz+lRe3XK+186wDOHTRyO9dIDjsST1dW8QxSXRMSiKk2ERzXz+MuBsSMy6ZUfatx04u294+tqnpFgQpuA4PCax4InAqMv0OiiMf6XijSf0o1BY4jMh1E5ka6yFWt+T/LZGHpCzXvnsVssp/mGoHqZ2MTsR0mmWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/H/Y28SnmelHNh6Ay33aqWw4exMfXpw0rMmSi3rnEOc=;
 b=CyrhtQNdEqid4zHVlUnoDkrbOnYvrJdEhaWqeHHD9tVozAsTyPeF485xUjDvy9G5a3Y3ii1gWRayKVzEvYflt7uv03Eso3RokKn/a0bgq8LdqJ8DtTXER7EiOmxe7SaaIf2drTSCkou7mnj2zEk/57akW8kflGy0Ry2av3I2REgfkie5GDBAHU/cvTJDNyg83/wLKj7Gi4shLiCe6zasLiXDYrHEY1/o0dwloHl6Pd/Gxh7n/d5ibuGqoYT++f49Hobz61Y1R8k/f4Ig9LWA4m84dD9GzZNp55KSLRUPkWrtKWqI6rlh6K0A/4d5WPT8ptRrx6gG3YC8dWeDEV1Teg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/H/Y28SnmelHNh6Ay33aqWw4exMfXpw0rMmSi3rnEOc=;
 b=T+wvdE98l4ttcJt6fK+6qpvNzPdfdyuwRPbpVFjHFYvK/w7BX/tOjHQrwrW6ncGpCfh2v7/EuzmclNSMWJ4ItP05C7PzZUNFGzf2AMKTx5dUsPFp5w3qYXgOXS5HgXmUFjj5uWYAUi455JbSVece6T3+xITgHwK/QR1H795zFek=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1194.namprd12.prod.outlook.com (2603:10b6:3:6e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 08:42:14 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:42:14 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 04/18] KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
Date:   Thu, 30 Apr 2020 08:42:02 +0000
Message-Id: <c446e7802559c3b274b174769814369ed1d5e912.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR16CA0054.namprd16.prod.outlook.com
 (2603:10b6:805:ca::31) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR16CA0054.namprd16.prod.outlook.com (2603:10b6:805:ca::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 08:42:13 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d0ed2ab8-05bc-4ac3-85ef-08d7ece261e2
X-MS-TrafficTypeDiagnostic: DM5PR12MB1194:|DM5PR12MB1194:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB119460167052369E4AB08E6E8EAA0@DM5PR12MB1194.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(4326008)(6486002)(6916009)(66574012)(66476007)(66946007)(52116002)(186003)(36756003)(7696005)(6666004)(316002)(5660300002)(26005)(86362001)(2906002)(8676002)(478600001)(66556008)(8936002)(956004)(2616005)(7416002)(16526019)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +q91FRugWzuM6vCoyWCaAdW63uGEbXRoxoKMQjeMJAXUq1rZi5w/GmMJIwxNAYntCl7hMK1OR5f3APiufFaKQB49kcjFyKRLzKp1HTLVnFykMtpgKB9rKukkD1O5d+930UzC41J0G50v9j8ABn90M/Q4lcE9lpqwB9qCp5BboA4yDpwbkisizgubHt8HJRCkzh+QaYRuddgvPDelWJs3ZkT7DoeoHjFEmwwyGtIyrOIvlplGUQ8REqvITW18Fh3w97UgBRbQzZ7zZUP8cWwhS7/9m3lG9Ow2P7uyWKgerDAIp8+PhZAqPBjedQ5WGy94BT97Qs0wSRq8FqTIZdAHwdpEfT0cDOn+8tQTLqMibH1QquPn87lwwA7ONFaE260nRr9ZHp0g1yz6Bd5le+6oV5oVJ3KNWvuLMsg7GAPhCjcwFQESEBmA3Qd7N2ZfTW02FhLy6JxLpYYD6vbPOibRqCvob5lVPtVX2eTmwkCV/2fUApxgZ/rtd2gr/OwvxHl4
X-MS-Exchange-AntiSpam-MessageData: UQR6TNj5bF3Ikxon+Pz7P70cQPuDOZQ3ay5bh0UmbeZWZ89vX0ZoVslkGoZOml5jD5al1pYPzzB32OqGNZb3Fo9qnBloF0JbSShLGX7zv9Zt5cqgXhlf869KjO/c2HTQbs9qOTRDDEod1zS3SQ9XWzdCni67fvlg/QQPrZDy1gcjepSEhtwyH8xt1zklLVI3EbJqtd6fH1Rhkyzy/i1rYgYiO5d4YphRcSx6Yctrmn3cw0ufZp8rinqSvdOFzSJ9dfbFoyDKnsgr3IQUkI1640fcjwRNBEuVH2dLT05WRxphKLoUgyGG3Q2qPsyiOrCVcEf3wK5XoPUlFhNQKnKy0zOPdyJNG5OPxvOmxCm+MkmNK3bPvDTGhi4lYJTfg6VXeDBy7Avl9UzzlkAJjhC7A+zEaVjf3m1OOtyYjcyZymRRx08bN8v20YFI0jySV5kD/KZxW9S6aSsl6zj7SDxRCy4PIkT7jGVHA/CGVB9nhK8E6oz4in/fs6Yjci3e8UDoCVQGyrfvNNZY39B1J6aZASbfOi78H25z1spZP2qg4+A5BKpib92QB3ASgBnh9+pnxYUrVtxxqJNVq0YXkU06BrhNtsFUI7vwZRIg2MvH0HzkUtSVrq5S54Q6IuzVqMQvtdwTcvtLIAUPzreBAQPqfrfDzoeMIWRWyRNOARBtw4I2XSFMRMrHvVsMGuDvTefIf8zGb6gbb6ULSho6JWP+cQmmnies6zlphNs3awLXV553I+36BYr9hmzEJYW8pcb48Y/TikVh47BBfeA5fWdGTGZJCqhpD5g6CwnlUfKsi5A=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0ed2ab8-05bc-4ac3-85ef-08d7ece261e2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:42:14.7412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QDb/xVdmu5Z4ZLFFSR92iMvPeFfloizZ6W7cZlWgDwn2f8JO5s+BFwL0Gc52y6OyquD49q1bhElieEPpqnJRjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1194
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
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 81d661706d31..74a847c9106d 100644
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

