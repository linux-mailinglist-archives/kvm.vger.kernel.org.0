Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE99619745C
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 08:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgC3GUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 02:20:48 -0400
Received: from mail-bn8nam12on2046.outbound.protection.outlook.com ([40.107.237.46]:6067
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729008AbgC3GUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 02:20:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3lUOkR9BxYfRN5S/7DHl3QAdEK7UTF7RwRKscUQsXdoM8zoHAe+9Eub7PWEMgVbGDnonTC/5wK2chCz0w1AKy0lp3KMc53cDUxvoluHaWrimgUSswCcRjhoDZ4YYaHA483l0boKKX+lR8AR2cgo0BS3g9aEeBo4lyw7BIx5WK35CxSTx3l7vJnD3NccHOC7BsNNY4O83iQu7+tmOd2G4gy+t+02+8rB4mW+3WbAmtR6HwDaeRl/9tsIWfxCIG06ATS3hWvYvt1vHLwyKgxGDkxd1aEsRnP63o26YAB0CM6GhOfO+U5vpkPL6JwxF07XtR2n4qgpJVPJrxPMmjXrDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Px3DaSAofM8+jNq45/Y/o5vN7ooFf4B+voinsjKnm1c=;
 b=OspmkXNnylTQFTmwN516cR8Xz0JAJc7mMib5cV48kLGBXXWG5T1mZN7gek6z/jMq7WX4WBxF0+AeVTHs9f2pSh3gmThwsoPnlKYHV5fZk3bbYuJ1Qle3iAdG3weo3P1wmbAeZEUww9z5Y9pnwJ76lWdV9Yn4TCokoAnIWa5/ysQ+e5vsVPAx2A/P1j6LgksTvyR9bZO+Kvzk+BIf9bHCi6uqvDRDuHys68G+tMZvtxPQvC9eyv/5mRx2nL3iBwXlZ7RHoJcxlB9jJ5PevNXkTj4fQJkFSAcE5SJ3vbL4Ecx9DscT3QqJT1YGYckvJJc2GpWehu9QInK26q5ym/DqGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Px3DaSAofM8+jNq45/Y/o5vN7ooFf4B+voinsjKnm1c=;
 b=f5se8Ea73zT5xvx0jvMzhVb0Xlpx7ao5rq81lLgqX6NDM0MTWORM7Hg8FpKNvUB61ISoxW51MaP3+BXl6E8Ggd4PH7Ksk58bYQra/+jSuWOsffCZ5Q+9lu2Ssng5x8gaRYeTg0JOr8f9wCHeehYT21SAc58OqLNmI07CGEUoshw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1692.namprd12.prod.outlook.com (2603:10b6:4:5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Mon, 30 Mar 2020 06:20:43 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 06:20:43 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v6 02/14] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Date:   Mon, 30 Mar 2020 06:20:33 +0000
Message-Id: <7ea65c7852543a7cd4fb904db751bed859735a84.1585548051.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585548051.git.ashish.kalra@amd.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR16CA0062.namprd16.prod.outlook.com
 (2603:10b6:805:ca::39) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR16CA0062.namprd16.prod.outlook.com (2603:10b6:805:ca::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 06:20:42 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ab1cf759-36f1-48cf-ac05-08d7d47279da
X-MS-TrafficTypeDiagnostic: DM5PR12MB1692:|DM5PR12MB1692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1692AB457A89814D219A8D0C8ECB0@DM5PR12MB1692.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(16526019)(186003)(26005)(5660300002)(6666004)(8936002)(6486002)(4326008)(2906002)(36756003)(7416002)(316002)(66946007)(66476007)(86362001)(66556008)(66574012)(8676002)(7696005)(81156014)(6916009)(2616005)(956004)(81166006)(52116002)(478600001)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oNWwglI1Roqlusvioyz3gvLYATRSkPpMShBevshYjIwp7Js1OpWXt+HgRITy74G4//dUSzTCpqt73QPhNlwZ9ph8aQCNSXh+39gdjxrPck1dsJGJBmv70hAnBwzcavfNkJFUrFEATrvMZ7/X44O9CAoa6u9mzX71JwCj1gHxhzKdC7zKnWCND7nI43Ankq7v3tvYTrYLsKbeXtgklE0zQFHM7fic/19y4kTzCbq1J256R2JFVeTK8ztKhAZ29vyvVz3Mg3plZZp9F9wsdX2HpBcK3khcrgb5aw944HEEM0xRaNdq168+tH+XiE1rOH4tNDAbWBgLrIbfre14IB9Z43YZrMNdpbwT5iiPajGTharlhXFFw5JBhfxa3J/svSY4syZ5k+R/jpYUY15Bzmz7v+uGfn5bvV6FVRVZlx8mrKPlEEWczO4RRNin+QUz7vLw2OLScatwmT9Y/wfa7SKdSeJtgRoWGQ3zyE+v9a5YaazFE88JfcH+5X5vfyQIfISE
X-MS-Exchange-AntiSpam-MessageData: WZxzxJ3TirHoLtnxEpLv8SJE3iQnFrCwAz/7C3AH64MrwuKcKvZ7ugn/0N+h2dCt/q+W15GVbFRMxCTNeAG1Y8013EdjJSqP4zjOLlFybypTOcFNunZ/6TqhOA7vcdO14IerdvvlqVY7Y6UmOWpNvw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab1cf759-36f1-48cf-ac05-08d7d47279da
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 06:20:43.3138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cl4vidWNXZTib1ELLyJkC+f3EYlm7/szLWY3PlPl3ne6FaufMWP3bKVuuiCUL8j+Nq42/VtQUK5G1w2Mspv2gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1692
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
 arch/x86/kvm/svm.c                            | 136 +++++++++++++++++-
 include/uapi/linux/kvm.h                      |   9 ++
 3 files changed, 165 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 4fd34fc5c7a7..f46817ef7019 100644
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
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 63d172e974ad..8561c47cc4f9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -428,6 +428,7 @@ static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 static unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
+static unsigned long sev_me_mask;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
@@ -1232,16 +1233,22 @@ static int avic_ga_log_notifier(u32 ga_tag)
 static __init int sev_hardware_setup(void)
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
 
 	if (!max_sev_asid)
 		return 1;
 
-	/* Minimum ASID value that should be used for SEV guest */
-	min_sev_asid = cpuid_edx(0x8000001F);
+	sev_me_mask = 1UL << (ebx & 0x3f);
 
 	/* Initialize SEV ASID bitmaps */
 	sev_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
@@ -7274,6 +7281,124 @@ static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
+		goto e_unpin;
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
 static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -7321,6 +7446,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SEND_START:
 		r = sev_send_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SEND_UPDATE_DATA:
+		r = sev_send_update_data(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 17bef4c245e1..d9dc81bb9c55 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1570,6 +1570,15 @@ struct kvm_sev_send_start {
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

