Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2841C62C3
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgEEVPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:15:10 -0400
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:60735
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728853AbgEEVPJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:15:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkfgcTxLVBkgdAakAJGKBkYDc2rg0oLZTsCRRttTaXe+p0nTZ8gE8HBfYoHktFu42aQLakIXhikZCdEeMPa8Ezrhy7Qn4yIdaH1tVQmusNEyy7cD6po8ZAadCCxqwtKDokORMyGI+2sQvjWqE/tg+GpoHb3eQ0bRsw+yAB9lJ1+Nztzz+pBnyQ1JqIarWumX/mpFZQ/FXxx28mG5rjzcZ0uGTLyyB4kkQHGwrrNbeKxXWmmAILxzHJ1dUIu9PIwMVF/+CSc/uOywlf/sRLRrRERA6BjAbPshlu1Q3d7/3z1mlI+hMimiaUR4zw7McBDMgZ7cpCTVp/UHegfgXP4Ovg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0Lwc78YKNJodnIhCkdHYVmKyqIWhzRZLe8A4sNSd7M=;
 b=khnbvxOqzYCmbkN8D5f8JMSORWC6XNx0HFlRsAjYv6lAhbAox0MWtpIOrabSM6emqcYngveax3k3e4r+BjPto7VfJjQp6LdkPfxQZNHxDd3CNHXFJ0qtvqlWMPL1STEVhVzwqbIL8Sbkynaetuz2l02xKJfwTt26aF9IM8og+UUF9/s6gldudkeqT37k9Nzs9ocl9uBCatc2RE2EBTV0gaYz1UHp1MUWglLrA0ZcXC+tu7is2nF0TeVdBejMTssexpzPtj+JGkYu7tskVTW6fQ7Bw5ZOXMyFryC5E4EG3cvek9lO9v9OPkC60mQLAUvBSpeHxEfM2btUq6Y7uihN5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0Lwc78YKNJodnIhCkdHYVmKyqIWhzRZLe8A4sNSd7M=;
 b=GUX70gMrdTqI5d1H08MgBzgxNZCAAR28uuCCMePznRxK07ITYFoluCtGUYB3bW2rM9pCVE9mcO/wCVHyxuoMq5RIsA5gwzavbgwGj26suC5N1hFBBqseZtqNwErCDfOyhb7yR2K5ck+4GZcXGWsfUHWaGr9CvCOUkLaPpiXSKLQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:15:05 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:15:05 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 02/18] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Date:   Tue,  5 May 2020 21:14:54 +0000
Message-Id: <1f43054f423c956e5fdf9c0fbad0c18be4ea3935.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0063.namprd05.prod.outlook.com
 (2603:10b6:803:41::40) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0063.namprd05.prod.outlook.com (2603:10b6:803:41::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.14 via Frontend Transport; Tue, 5 May 2020 21:15:03 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cd5207fa-e991-433e-9a1b-08d7f13961bd
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB251804B4CBDEF9C3CB6AC3878EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yroXkSH2opnEriw8Dur4MA/eD2HTV645IAEXzkrw+yu+e8ixbYzIi6l5x9OS0QMpl7ClpGgdGfOgXObIoD/0O1S80RddowYTPG+rvHU6e1gpI4WLSaOZ2IQjAHGRgJDcBq/mjbIVa3ixWNuzF3xI+7AgtoF6tBbIC6mkPlYQv3y45QS6x9FJtrdX6Pqa0Kuu2rN/uhfZvoCxoavDS36EZDv9R2xvVWLTLN3lhKsMldSCQauNFLMk7hghJXuxCPg6qiMCkGGyFs9xQq2QWmmBsDBPJCns7zhooaBqzZQZB29R9x9qbJ6OqsblQjrEjTJM4kRfgqbDASXEjOxU69OOurzgLTwdrQmeVW6+gaEBSmb19S+vUPo0TrTOuMwJ39HR66Pniax/4oFnvMwo+JsYLDFKzweDTq7H9JTjWhAhiBaYPS1k1s6fl4kFJun9QV3tGWb+XRlF9t6oECAIS5Yk/482G5pAKd+DtjbeI7pT1Dq4hXDOgReiadQFA8o0RfSrpLCsXpnZB6E9VEKWUpVM5s/raT7qRwe9a3fqfLV8wm3GCGOE/6zje8xLxKXNoRQ7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(478600001)(6486002)(2906002)(5660300002)(6666004)(2616005)(66574013)(186003)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GIzo2DK4h3BTJ1+NDHb1fVKnl81DziBPDWkX42T/WN7wEFvTdYwWxXKwl1E+wTwkBChUwKhBYgcQBmB0CR85/yGa5p2c3X5k0Tv6EvHLxzlYQ6cR6p5yGWEnkItCuTFp5b22uNkj3CDqZ1uPGtjULar9V4SW+FzGLjtMNtbxJTTPmq3g2e+3nRg8rN8uKywedblAiMzghmhDP3tSIJVZo8AawjJ1rMPg7m4lbRj8ItY72Xiz7iLOf1IxzXvpxbXY8jlTe2nTK8cThRdYEGxZP44Fqw59OQ1s1osMtoFjOJbYQy21wt4LsJ2jlbDs4qnQhA+fyuzW+Row4iM56WWkK+/OpgyBNbqxYVL4R5K7tN/mZDcNgWWmC24+Csq3ZneUj29rmLmm8+O4SzuMEqFVSw7DX4ZgCSM97zbrU3fSyk2WrFePLM3Q+93wsZ+JiBcQyr3y0xYYA3IrvUbg6CDZ0g76B2ijN3AWgBOD5sclEEe0PHhchmEcVc4QSJoiJpRBrG3yiB/RAof4Ay3lcuFOu9yID+ixNpsMClWUXk0FXKKbiJL+tTpHgYyqOfRIhPWBUnUFLSOb+ruy3rjlNwY1T8APf62WuBg7fJV9kZHXZ3R14CjJt58iKqWRKPGOwT8OOAUfQa2A+9mSQsMG25ngV9cRZ5YeUDBBYP8x1SeUEPj2mZJ2GJAvjbf2eZ1FHw2JcVkB9Sc59IbjtnO4E+13r0JcKbbQy+cnUWiugfoccDfs2Nlqgw5Qm19u91HE0WXenjKQJ8gi0zwrdjzPWbmdkwvRCexwJbz9cwhvVN8dARY=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd5207fa-e991-433e-9a1b-08d7f13961bd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:15:05.4048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LS6AV3+W/vBtlmZDCm9gLKvwQNEBn+0rbsyq92unyHgvSEgsKmdIgAFv0rLhZzUxnnJ0Ruk+EKROz3iCUvFYtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

The command is used for encrypting the guest memory region using the encryption
context created with KVM_SEV_SEND_START.

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
Reviewed-by : Steve Rutherford <srutherford@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  24 ++++
 arch/x86/kvm/svm/sev.c                        | 135 +++++++++++++++++-
 include/uapi/linux/kvm.h                      |   9 ++
 3 files changed, 164 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 59cb59bd4675..d0dfa5b54e4f 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -290,6 +290,30 @@ Returns: 0 on success, -negative on error
                 __u32 session_len;
         };
 
+11. KVM_SEV_SEND_UPDATE_DATA
+----------------------------
+
+The KVM_SEV_SEND_UPDATE_DATA command can be used by the hypervisor to encrypt the
+outgoing guest memory region with the encryption context creating using
+KVM_SEV_SEND_START.
+
+Parameters (in): struct kvm_sev_send_update_data
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_launch_send_update_data {
+                __u64 hdr_uaddr;        /* userspace address containing the packet header */
+                __u32 hdr_len;
+
+                __u64 guest_uaddr;      /* the source memory region to be encrypted */
+                __u32 guest_len;
+
+                __u64 trans_uaddr;      /* the destition memory region  */
+                __u32 trans_len;
+        };
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5a15b43b4349..7031b660f64d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -23,6 +23,7 @@ static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
+static unsigned long sev_me_mask;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
@@ -1035,6 +1036,123 @@ static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+/* Userspace wants to query either header or trans length. */
+static int
+__sev_send_update_data_query_lengths(struct kvm *kvm, struct kvm_sev_cmd *argp,
+				     struct kvm_sev_send_update_data *params)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_send_update_data *data;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	data->handle = sev->handle;
+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, data, &argp->error);
+
+	params->hdr_len = data->hdr_len;
+	params->trans_len = data->trans_len;
+
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
+			 sizeof(struct kvm_sev_send_update_data)))
+		ret = -EFAULT;
+
+	kfree(data);
+	return ret;
+}
+
+static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_send_update_data *data;
+	struct kvm_sev_send_update_data params;
+	void *hdr, *trans_data;
+	struct page **guest_page;
+	unsigned long n;
+	int ret, offset;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			sizeof(struct kvm_sev_send_update_data)))
+		return -EFAULT;
+
+	/* userspace wants to query either header or trans length */
+	if (!params.trans_len || !params.hdr_len)
+		return __sev_send_update_data_query_lengths(kvm, argp, &params);
+
+	if (!params.trans_uaddr || !params.guest_uaddr ||
+	    !params.guest_len || !params.hdr_uaddr)
+		return -EINVAL;
+
+	/* Check if we are crossing the page boundary */
+	offset = params.guest_uaddr & (PAGE_SIZE - 1);
+	if ((params.guest_len + offset > PAGE_SIZE))
+		return -EINVAL;
+
+	/* Pin guest memory */
+	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
+				    PAGE_SIZE, &n, 0);
+	if (!guest_page)
+		return -EFAULT;
+
+	/* allocate memory for header and transport buffer */
+	ret = -ENOMEM;
+	hdr = kmalloc(params.hdr_len, GFP_KERNEL_ACCOUNT);
+	if (!hdr)
+		goto e_unpin;
+
+	trans_data = kmalloc(params.trans_len, GFP_KERNEL_ACCOUNT);
+	if (!trans_data)
+		goto e_free_hdr;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		goto e_free_trans_data;
+
+	data->hdr_address = __psp_pa(hdr);
+	data->hdr_len = params.hdr_len;
+	data->trans_address = __psp_pa(trans_data);
+	data->trans_len = params.trans_len;
+
+	/* The SEND_UPDATE_DATA command requires C-bit to be always set. */
+	data->guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) +
+				offset;
+	data->guest_address |= sev_me_mask;
+	data->guest_len = params.guest_len;
+	data->handle = sev->handle;
+
+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, data, &argp->error);
+
+	if (ret)
+		goto e_free;
+
+	/* copy transport buffer to user space */
+	if (copy_to_user((void __user *)(uintptr_t)params.trans_uaddr,
+			 trans_data, params.trans_len)) {
+		ret = -EFAULT;
+		goto e_free;
+	}
+
+	/* Copy packet header to userspace. */
+	ret = copy_to_user((void __user *)(uintptr_t)params.hdr_uaddr, hdr,
+				params.hdr_len);
+
+e_free:
+	kfree(data);
+e_free_trans_data:
+	kfree(trans_data);
+e_free_hdr:
+	kfree(hdr);
+e_unpin:
+	sev_unpin_memory(kvm, guest_page, n);
+
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1082,6 +1200,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SEND_START:
 		r = sev_send_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SEND_UPDATE_DATA:
+		r = sev_send_update_data(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -1238,16 +1359,22 @@ void sev_vm_destroy(struct kvm *kvm)
 int __init sev_hardware_setup(void)
 {
 	struct sev_user_data_status *status;
+	u32 eax, ebx;
 	int rc;
 
-	/* Maximum number of encrypted guests supported simultaneously */
-	max_sev_asid = cpuid_ecx(0x8000001F);
+	/*
+	 * Query the memory encryption information.
+	 *  EBX:  Bit 0:5 Pagetable bit position used to indicate encryption
+	 *  (aka Cbit).
+	 *  ECX:  Maximum number of encrypted guests supported simultaneously.
+	 *  EDX:  Minimum ASID value that should be used for SEV guest.
+	 */
+	cpuid(0x8000001f, &eax, &ebx, &max_sev_asid, &min_sev_asid);
 
 	if (!svm_sev_enabled())
 		return 1;
 
-	/* Minimum ASID value that should be used for SEV guest */
-	min_sev_asid = cpuid_edx(0x8000001F);
+	sev_me_mask = 1UL << (ebx & 0x3f);
 
 	/* Initialize SEV ASID bitmaps */
 	sev_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8827d43e2684..7aaed8ee33cf 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1610,6 +1610,15 @@ struct kvm_sev_send_start {
 	__u32 session_len;
 };
 
+struct kvm_sev_send_update_data {
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

