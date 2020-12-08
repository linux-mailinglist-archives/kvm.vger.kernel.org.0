Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B269D2D35DF
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731116AbgLHWHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:07:02 -0500
Received: from mail-co1nam11on2072.outbound.protection.outlook.com ([40.107.220.72]:15073
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729512AbgLHWHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:07:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSghebjzTLB64Dy+MwgzW3M6rNqhlEc/EEd9S2WaKjzRbt/T0zSJTRuOP8x7QKf3JiJiIx3vSDZ2wjn+iJrUOOAqE7cL3aYA+HUCNFFgkb9+EzcfG3oav8Ztv+buuHkkBPRvkDckGOQeOUABFbx3hpw4hV90Tu78J8p4PdUN1x4Wa51tReG5hINEwE4vVKPNsPoJhQBFHEUQwkRXXDcJRXg9ZGhf65BtLlJqbMhHOimfV4aTn69JE5Zh/ey7PuHDEMy+W5FqXVREqzF5jyPbWlRrBnYMEyZFglZRpCzQZa/eFIW/Nz0PxjSG6jkypuY2si4uLqZhNwFerBfYUeVSig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GzUfptb1o9LpS39d6U0Vl8Zl4L1BADu/Gjsvh7RIEI=;
 b=T8ev5MYcgVN6Z+HKcEC6rY/5KL0vDZ73yg0AC1ORH+X1TqJZUq6lRrbU4MgGRqqltXXTy8vl+kXWhJQv7XB0BGFZ1aT/f1dxH5rp/3ePajiXW4ub/VMO6n/OsOy15cIj5LJPwTXyIkw16mvRb4YXFaDdyfyo3FM48xLVRnfZO9s0++u1oOCbm18r2ZiFQJA0+ehfZZzGZkFLMFaGmt6nF9ux4mpagpzrW3vPCWC5iu3FUNBnk50BUkbnIfgvvqLQzy5EESAVpKpRxeoJ/duz1v13v79JzUw9DbqCth/hXM89hjHGvBDUK71vq/pXHi0hXQh03/Kyb0S8kd6JkoNkEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GzUfptb1o9LpS39d6U0Vl8Zl4L1BADu/Gjsvh7RIEI=;
 b=xbG7KbV9WcCszAsQohT00NouK959YYgyCresodw40wktVKSvpIELEGoLcSKPW0RFLYFPPrrLSkixABPcDOiEh09KgQM5PQPx3UwiqJ2oYvzMSyDA2xtK/6G0JUlfh+dbtI2BGqMLGwuxqFU2ZmFTKMxkRIYS3XfLXnMn8x9z8Kc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 22:05:32 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:05:32 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 05/18] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
Date:   Tue,  8 Dec 2020 22:05:21 +0000
Message-Id: <50c8df07a4469bd121c335dbe6107c55d459259e.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH0PR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:610:b3::7) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by CH0PR03CA0032.namprd03.prod.outlook.com (2603:10b6:610:b3::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 22:05:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 99933383-f05e-4c4a-2dd6-08d89bc56214
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2640905291E7E8C0FFE56DA18ECD0@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VvM80az3OdRxAeoX2+5VTIShvCceSFmM1aWtB9WGrVwwVYhoT7eDKWCe1L42uSrCpfR/BCv1UwWvYu2mJUxBDn8ZplXdtRJsq84ToWqEYPqO7LbOaFMH+B3h6zk7Xzh/lsFZGZXrH6p8//QT9OEHuTLrcTL+1Pmb+rTpunvTKS6jWDfpHVBk6kRSAxMV15TGINQxVLrZ3LP5uDK75ddXsMhho4JZcnB4F9OHHrDNZ6ps9sy9HgRtydu+X5MUKqSKRx9Np0Wek0iQdCvp6Ybn73y4XKR5Ta2Vd9J2lkzXPTlbNzYEWUjSO+RUAq8zfwnzBMYgtVwAqlArnyuJsvdAKBG2iDqczJ9hyzECza+huYArrw2Awg0kQ5+WzwjtN76A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(2616005)(2906002)(66556008)(83380400001)(508600001)(4326008)(5660300002)(6916009)(52116002)(7416002)(66476007)(6486002)(66574015)(34490700003)(186003)(6666004)(8936002)(16526019)(8676002)(66946007)(86362001)(7696005)(26005)(956004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?czFJNlpydDFyNmpGcldIN3JOOTZJQ1phNjhDbk5FRnNMdzAxbC8vRWFTQVYz?=
 =?utf-8?B?dERPYytSZDF0Nms3VlVYQjE4M0t4Q05XQlMrVWRjN09RVFJlYURid2gwMHdS?=
 =?utf-8?B?L1FFem5nam8xL3RqVEN1cVdOZzJxMk84ZFB1N2l5bGRjK0wxcU0rQlV1YnlG?=
 =?utf-8?B?OFpTQks5bUhscjM4YkUrZWl2Wnc4TGNHNXVZbXM2L0JUU1pZQVJxeG9oUmhn?=
 =?utf-8?B?RWNKUVRONC9DZnMxWWZ2K3VwbWhtblF3ZitRajNvNXUyMmxnWGhCb0lxc2do?=
 =?utf-8?B?K2I3VXJNbkhCeWxQNUtjN2lrZFhJQWd4dHRFd2EwQTZVODNnSmRFZ25NanhX?=
 =?utf-8?B?TlVMMTZvREUxckxtZmI2SlhBaW9DVFd5OGlESU1yUDBxM2JPdE1iUzZNWWpj?=
 =?utf-8?B?VG9CTUxrU1NLaVByakxTQlArUUV5Z3JOSXFuWWJFZVd0S3lSa0R4YjkvNkM4?=
 =?utf-8?B?aFVhandWdkczT2xaMytkT0tFUTRxazZ6azA2RmY5SEVSY0g3bXVJaUh6bFJ0?=
 =?utf-8?B?bHpjL2h0UnVuc2N1aUhobHBTQjlmOXZkcGlNd3VabktNZUZrNXRIZzVyekZY?=
 =?utf-8?B?eFg3M0NqUXZiaUc5VndzOGtHWVZvYWtTRmw1VVErOWJ0bmNQNkJJUkE1bHRt?=
 =?utf-8?B?eEJEUjdLc3VhOVUybzI2UFpwZEFvK0JXeVV0YTBxelR0QlNYUFV1MEhYSWlG?=
 =?utf-8?B?bkp4dmtKUU5MQlI1Q2YrR1NVajFZQWQrZWZtYzE2RzRoSy9mYVZndGJBQTFR?=
 =?utf-8?B?Wkwyd0d5a2ZVVk14VVF6QnZNUjhuQzhJQnNudSsxYVY3RXFhL0VwODUrTk1m?=
 =?utf-8?B?R2pGUUV5U0FFMldkVG9zbDdpV2xXMEg2eU5aaW1SWnNxWlJkQnJQRWNCOENw?=
 =?utf-8?B?eE5XNmlXOUxjQlFZcGx1eCtNd0RVUkpKRlJoOElUaDlERDErWGxqckNCUmNp?=
 =?utf-8?B?S25TeDRxKzQ0SlNJLzh1anBoeFNId0RremdSeUZWRmxBMVNZdlFLcFRYNC9P?=
 =?utf-8?B?em1EWmpjeVk3MHM5WnZKZ1pQRzFkWldIOUR4bnNiZU9kOEt2MmNFRDU3eXNB?=
 =?utf-8?B?NHV2UjRKOHEwWC9md0szaVZoYTYvcXNRS3kvRzNaOXB1dVp1c1JRcVJIa2NC?=
 =?utf-8?B?aUhPOE1ZSXF6dldSTzd4My9NQlhPUGR6TVVOOUFuU0Q3dzRDVkQ3c0Mxcmwy?=
 =?utf-8?B?ZzNRc1BCekQyRXk2ZEZxM2NzT2E1RmEwcjhyRzYyeGNiQXd6NGZ1aURyWlVS?=
 =?utf-8?B?QW5Sd2JObW5BbHZTRGFJT3lUSEJST1IyaUJMU2VaOFZtZS91SjdGM0o5Q21K?=
 =?utf-8?Q?HbzMUZLpnawDE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:05:32.8208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 99933383-f05e-4c4a-2dd6-08d89bc56214
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWJsLadhdomjYCqT7vCQVlK0iicVx1G/jf5R2r2jW8U26u1uYG6E2ZWTvEi2ZiLhvSRPvn6b9RznyQVU7dptMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The command is used for copying the incoming buffer into the
SEV guest memory space.

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
Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
Reviewed-by: Steve Rutherford <srutherford@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        | 24 ++++++
 arch/x86/kvm/svm/sev.c                        | 79 +++++++++++++++++++
 include/uapi/linux/kvm.h                      |  9 +++
 3 files changed, 112 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 079ac5ac2459..da40be3d8bc2 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -351,6 +351,30 @@ On success, the 'handle' field contains a new handle and on error, a negative va
 
 For more details, see SEV spec Section 6.12.
 
+14. KVM_SEV_RECEIVE_UPDATE_DATA
+----------------------------
+
+The KVM_SEV_RECEIVE_UPDATE_DATA command can be used by the hypervisor to copy
+the incoming buffers into the guest memory region with encryption context
+created during the KVM_SEV_RECEIVE_START.
+
+Parameters (in): struct kvm_sev_receive_update_data
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_launch_receive_update_data {
+                __u64 hdr_uaddr;        /* userspace address containing the packet header */
+                __u32 hdr_len;
+
+                __u64 guest_uaddr;      /* the destination guest memory region */
+                __u32 guest_len;
+
+                __u64 trans_uaddr;      /* the incoming buffer memory region  */
+                __u32 trans_len;
+        };
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 25f869dc1448..34240c022042 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1265,6 +1265,82 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_receive_update_data params;
+	struct sev_data_receive_update_data *data;
+	void *hdr = NULL, *trans = NULL;
+	struct page **guest_page;
+	unsigned long n;
+	int ret, offset;
+
+	if (!sev_guest(kvm))
+		return -EINVAL;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			sizeof(struct kvm_sev_receive_update_data)))
+		return -EFAULT;
+
+	if (!params.hdr_uaddr || !params.hdr_len ||
+	    !params.guest_uaddr || !params.guest_len ||
+	    !params.trans_uaddr || !params.trans_len)
+		return -EINVAL;
+
+	/* Check if we are crossing the page boundary */
+	offset = params.guest_uaddr & (PAGE_SIZE - 1);
+	if ((params.guest_len + offset > PAGE_SIZE))
+		return -EINVAL;
+
+	hdr = psp_copy_user_blob(params.hdr_uaddr, params.hdr_len);
+	if (IS_ERR(hdr))
+		return PTR_ERR(hdr);
+
+	trans = psp_copy_user_blob(params.trans_uaddr, params.trans_len);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto e_free_hdr;
+	}
+
+	ret = -ENOMEM;
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		goto e_free_trans;
+
+	data->hdr_address = __psp_pa(hdr);
+	data->hdr_len = params.hdr_len;
+	data->trans_address = __psp_pa(trans);
+	data->trans_len = params.trans_len;
+
+	/* Pin guest memory */
+	ret = -EFAULT;
+	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
+				    PAGE_SIZE, &n, 0);
+	if (!guest_page)
+		goto e_free;
+
+	/* The RECEIVE_UPDATE_DATA command requires C-bit to be always set. */
+	data->guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) +
+				offset;
+	data->guest_address |= sev_me_mask;
+	data->guest_len = params.guest_len;
+	data->handle = sev->handle;
+
+	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, data,
+				&argp->error);
+
+	sev_unpin_memory(kvm, guest_page, n);
+
+e_free:
+	kfree(data);
+e_free_trans:
+	kfree(trans);
+e_free_hdr:
+	kfree(hdr);
+
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1321,6 +1397,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_START:
 		r = sev_receive_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_RECEIVE_UPDATE_DATA:
+		r = sev_receive_update_data(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a9e6ffcfe7e2..fc0a48c37aac 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1673,6 +1673,15 @@ struct kvm_sev_receive_start {
 	__u32 session_len;
 };
 
+struct kvm_sev_receive_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

