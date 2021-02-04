Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C1030E8A7
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhBDAis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:38:48 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:57185
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234122AbhBDAim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:38:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4hgKWDfV4YL7uPBCuj4Puaog7b8yAjZiZaBN0khxBv2wQKThLs78MrAmIxtekL27916RTWuwy30q2ZdOgC82gtr8LUlelaES0EIYRBRl5gRsNXX00qCEXbdaLrh6bu66eZH6NJmPAXrAMGj7GdHCV3MBSYoA2JnxvU5L3jmsT2G/KEHKpJv3AtMaBR+16oaZfHRHPczj/abhdzrmE3wBpb+SnQ99754OxNhHPqkAT+lEZXTuhDl5uofIunOAQboZZqVrvEAPjUUJveJBH/jhGi3jlrU7KKzffGsz5lsk57Lk4ILDCtN/rA1d8Tpb/hZTLs+lqmuPvWZcXWuXb+tKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caa+099V3/AL46PMO/Kd15N1J3cf0E9F3xaBsazqjns=;
 b=eezr7EkbaRlXWWwbCChAk0xr1rl6IF/r7StqYGmDltR6jaiNBseD6bHoeHX/KkySPx47bOpVsGb8DvPkiPfL34WI6q0FzTvuGPt1+dBNOGJROwSpaTZ/4rYZrmF3csouxyXEJaMj/6+n/pOAJUamzaxhEFxCLteVNTSoyEfu9pzu+2XaqwENVZnZYkPA6ePBvDUZpgY2RFee/lqiRgE1ni83lkGzW3H7MTUb7WPfcPWKOyJNzaa6h8NG6j1mwH4DjHc2Hz5XfLMVXACM8lh7wYMEKXZW4AdojXK5xaKkS5BUg/ks9wvXYXKATFzU00BuWUFHmuBdFRKh1Y9ynW0kOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caa+099V3/AL46PMO/Kd15N1J3cf0E9F3xaBsazqjns=;
 b=aAzaEsAb5vFxJskfQoJ9apgC4gx50+xvgZqVq8L0xA6/VNE6EWpt3xQR5YGJkJnuPfIsgWqWqUor2bJ5vM/VP2tdT1BpjaUEonAcqeAeJGKPxVTvUxIbnDnkkRvNZHYVOiApTMXinoEjKggJrHOfXTTGTXZDO64ieo+h7HqEocQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:37:39 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:37:39 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 04/16] KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
Date:   Thu,  4 Feb 2021 00:37:30 +0000
Message-Id: <cee7d10fc9a3dcc4f7ee951dbc493c95915f95b9.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR12CA0028.namprd12.prod.outlook.com
 (2603:10b6:806:6f::33) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR12CA0028.namprd12.prod.outlook.com (2603:10b6:806:6f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Thu, 4 Feb 2021 00:37:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f8767e1f-1192-4abe-140e-08d8c8a51330
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384300B1C53D6ED2FDA0A9E8EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: autB7i8NW+VCQ3MUK7wpimds+RM2Y6ky0prAiMbQiv12W6/yVl7h/uHDmqBr9Ej56VwdnwiyQNpsgzfrjff/5rcdwrIKOwj9G3Vughro6WNGpdMgsNh0Yf12QYcd6adIol94eke2Ysqm+McVnhUX0FfUHdg0Yr/Aw1qdT66tC2qwA0P1b/fQPjyWf6R/RU+4UzH9O01p9xheV3nUk7NhI5szmuvmZOrMjwumOTRHe/qQOrVfx8XYgMmH/Pl+Joq5GWlMseXSmPncht9GrmzBCVAk162IyDfOLXJp02urlYupOnhD9sC1aE4rp3YexHRzMK1gRnlcu/Yg5HJC9G3ifPGfjTLTz02hDtL5BUiEuYSf7QW5I3p0wWlxxRs+OQ4S8gyvo7DkuBbOQ4ngqExH2YQpWtN8s6IjawTUZg8DtyIziG1HKQhNg4TZs5hcHLtx6raks3uz7t+CUoTeJIQ2n35pAnG3Qtbg5qL/d2rZ2rgpD2II/bi/oXIZndvY65ZVaxbt+atK1nFyuFL0HaCVRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(83380400001)(8676002)(956004)(2616005)(66574015)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QXlJa1Y1Tk5yRTdqa3ExNlFtYnBjcVFiRkhuVGJ0ZnhQcHY5bEJsakFiMG5L?=
 =?utf-8?B?YUlvTGtGNnpJZDVCUDQ3a0J2Z2tYZ1ZrQ3hUcFlIQnN3V05BZitndEp1Y3Iz?=
 =?utf-8?B?SG12d3hxYlUzQkhCNENOWkNmWDBFaWZWTnFvZmVxQ1VEM3Z3bWt1NFp5NWtU?=
 =?utf-8?B?S0ZrZnM4RkhZNEpmb2R6NWVveFcvL0ZzUUZyRmRrVU8vcllydzJGLzA1M0Fa?=
 =?utf-8?B?a0hVYXgrcXlSOFJwZ3M3Sm1DRlVteCsvODRZSVY5RGJ6Ky8reWliTUVuM1ZU?=
 =?utf-8?B?cHJnMDZsaHJJQWZsQ2JCRWd2Q0Y4QnNhayszeCtYVjlBY3BpZi9IZDFkZzJS?=
 =?utf-8?B?cFFnR0FPalhlUGdRaTcyREVKdEMxZ285QTZjMWFCTGVrRUpSbitRcjFsb2hO?=
 =?utf-8?B?UzRKZVhBTit5Z1lqQ3J6a3RmQ09vSlhjaXlLSGVzVkhuc3U2NkRUQ0E4d25C?=
 =?utf-8?B?WTE5YkpnWDMwMkY1M3NETlFTZ2ticW5nUFdVZXF6aUk1aDFERk44ZzZpM05M?=
 =?utf-8?B?ZkQ5bHZtSm9aMjJsbEN0THBIZDI2OExNQ2x6QVo1ajljZFd0UnhtYVpXbmts?=
 =?utf-8?B?VzhYMkRFNGFTd2JTdTA2dXROUit6TDNjWk9yTDFnUXEvMVhheXdPQlVrcUd6?=
 =?utf-8?B?VStYUHdBTmptUVR3b1MvYTJvZXpzdzFRSHBLcWVCMkJoZXl6cS9BZVhjYzQw?=
 =?utf-8?B?UzYrbWZlamxlbGdWdFQ3VFdXTzg0eERUWiszQW5aWW52bGw5SXpZaTR3c1Vp?=
 =?utf-8?B?VUFSMXZ2bWZpRDJXQ3BQdkpqNmh6bXlqd1YwOFlmaEVvWW0xdWZqTUZmemVM?=
 =?utf-8?B?aUFIWlV2K3RnejVudXRiRllCelFVdFVONkx0OHo5U1dWbm9IMzFSc1Q3cTV6?=
 =?utf-8?B?NW5jcVlrdUM3bTRuRGNRNWxUZUlMekp5MDN0Z1YxWjNLQko2WGhXRnQxQW1L?=
 =?utf-8?B?VkdyMWVidVhRM0s0STllQnBQUlA0N1pESFAyS3d1VFY5LzJvUTltUzFzbVFv?=
 =?utf-8?B?YTkwaXRuYTlRM3o2dCtpdGV0SnAxTG1OYnBwSDZiMXlvVUorc3RMSnF2QnNw?=
 =?utf-8?B?dWNpMjlNdzIrMjZObFdYZVcreFRuMkFDY3lqTWhTRGVsMy83QzI2NVFtWGQr?=
 =?utf-8?B?RXZJU0FEUXJmSTE3Nnl0RDFQcll3Y3FkaTl0SGRnakRSTDVkMzJ6aTFydlZr?=
 =?utf-8?B?ODVYSHpRWWdHTGVEOFhWOWJIbWYyd1d4cUx0K2IyL0grOFo1VHNZOWU0OUpz?=
 =?utf-8?B?MlAvUm9OZDliNVFSQTFQdDFPcnNoK09Id3NtVVk4OHBxZUY3cVRqaWN0ODN4?=
 =?utf-8?B?bThjRjNSaGZ1b3plOWxjTC8xSDFyUkd5QUR1T2lid0MycnA5QW1LV0FiVkNO?=
 =?utf-8?B?Zkc4cnRMZzZuQVQxN2JjT2pmbWxkcGdjc3MydkgrK0svbnVweWJhRkxWV1lN?=
 =?utf-8?B?Nk8zVlNFMVlqYldNRGR5aHFUYXgrRnZCbElUOVhjdUxLRFJPS3NucHR1ZG4r?=
 =?utf-8?B?QzZ6ckdsaGN1UVNvWlJlUnJnQVNRc21Pd3FDVnpleDR2anNvRE9aci9MSGZE?=
 =?utf-8?B?OTN0L1NveVREN3NiSngvVHhDQlJvdGdZNWhBUXo4aWg1NGhrQVc0N01ZVW5T?=
 =?utf-8?B?NCtsQVVxUElvQjlMSzNITFJKWnVCeGhod0hjeElnME5BZXYydnZ1RFcxMUFV?=
 =?utf-8?B?QjhydmY4WXF1dzRWMUUwV0xFcERtTnQ3ejFObTNPNU9SMHdWQ2JlajduMTBv?=
 =?utf-8?Q?2M2NethmnFrb6ksUjtNCBIK8mI+BKgP+8uENU9E?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8767e1f-1192-4abe-140e-08d8c8a51330
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:37:39.1711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4TKWoO/beSKB7UK7hUd5p+lfVDe3r9u9HV2PECj45sGmeI+nyy8o5O3wahfDX4ya9u5i2lOpoBqnyW5cdd3NQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
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
index 0d117b1e6491..ec0d573cb09a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1299,6 +1299,84 @@ static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1358,6 +1436,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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
index 0ff7bed508fc..d2eea75de8b3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1666,6 +1666,15 @@ struct kvm_sev_send_update_data {
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

