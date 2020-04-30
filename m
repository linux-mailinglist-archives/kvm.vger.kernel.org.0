Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D56D1BF316
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgD3IlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:41:05 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:6149
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726745AbgD3IlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:41:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/l1+CWmwFPYjf3z5M8hyxyEbTaQ55gjSIwFdq7+Fhx4eAK1y9wAtsDYA4hjN56MXr6zdUeacKERATj1F+WqZljIa72JvpgqXoTVAuNul3gVnRqCTS5gsTw3BoouH8AGi1sT82kz4QffsCbZUFiNdxCq33OWqNy1ppbEI3VYu4apX5pP9bwRX+WSR5G/AssFoPAY3poW1An5wkvYSkD3HZkHBnR3+pYXUKQHwPDy1M0piitqrNSpEPMLO5F/uRUHLI2yEEQkw2wsFy2jLTFNLn7MUcTe5ksx3wVvwRIAG3Jm8V87Ke8AhWwCj7+ktZw19mioQ4znwZxlsCnEoEvtHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44QDKHsa4qasKw8Lcijcs9cSFGs51YW3G2Xs1RZrv5g=;
 b=g4zHn2PHvK7/qdN7oc6Sjc4awcfWnj7WhxgAtLqo9+7ab2y38qUEzBNfl0CVyOiso2+HMlAIUInlPYN08ZScF62KgQO0x1pEEGfNp+Ir2ZzfFT8X8FIsxkGAgCchx75gnhOhnxqB+G8tIjxkHOF4rPcDjEnB2NstftLkdfdHJ1ITkjbkCic10jGMRWQJOSbrM8D6kBGA1O2BxZZyZw7rUq088GNryss95FvotIRSWpFmn6011UeV2IVpoUs3cl3n9Gzj6kAbmayNhLa3z6c0zyklHmCwv6r8TTqhMd2bdXwYgjYcL8dRziM8bwZxXq7md9pATXQNwVwgqSjKy11qvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44QDKHsa4qasKw8Lcijcs9cSFGs51YW3G2Xs1RZrv5g=;
 b=lf2feP0R0AcCEHVdtKObN8UmIcrcvd5vmqBMyispVEhZRskCSznTh7cy1gJGgncP+dYLZc7wvtQIyVGoCllV95WCsPtn+TloCzA1tB2Wy+QUCRsooNqpkS//pjtBMlVEqkc7W78ggncGaQEn1uucg1WEn7izANt5rQxKta9+tkk=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1194.namprd12.prod.outlook.com (2603:10b6:3:6e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 08:40:59 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:40:59 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 02/18] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Date:   Thu, 30 Apr 2020 08:40:50 +0000
Message-Id: <8d336fdd83e9b698354b5572d5f2bd1660879fc4.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR20CA0015.namprd20.prod.outlook.com
 (2603:10b6:3:93::25) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR20CA0015.namprd20.prod.outlook.com (2603:10b6:3:93::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 08:40:58 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a6b82b8b-c1d7-4436-21de-08d7ece23533
X-MS-TrafficTypeDiagnostic: DM5PR12MB1194:|DM5PR12MB1194:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1194D3FFC541630977E8A4098EAA0@DM5PR12MB1194.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(4326008)(6486002)(6916009)(66574012)(66476007)(66946007)(52116002)(186003)(36756003)(7696005)(6666004)(316002)(5660300002)(26005)(86362001)(2906002)(8676002)(478600001)(66556008)(8936002)(956004)(2616005)(7416002)(16526019)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GAsbBh0kA9WPiUy1+Srsgc2EDqs0oTMqYUmII9J0H0R8NvzCLBzyESj8ZnIqHvZva1TiVaBNvAybURtLaUbJ2AGSe8kbLIws1LGygUyVwlibITntzsSyu0/Yrlo9VZF7eszAPlWrh93Q36CAaUoqK+tyCSsQwtpZS0Aj7TRxXTQiZ3eKbLM9ipEHxvherhQNFoaFXKpAghhfjLvDV9j7et3OEyppogKLlaepd10SxkQrc58RdKtBemHNroeqj3qe+jM0rDlkl7pothh4tYkxFkBhaX8CUW5ayTNsfevk8OR3ge6vgMFFYL3n/Cxp6DfBReotH4OPgHxr/ejLhzl7VtJURmxDYuMh9HiKT1nZZkjm1RJrYlNvWPf94quG9DalMab7QJXkSoLAWMYOgwUYBOy8N3JPhgitCNd/f8Rs/oI96ir6qVUaze9EDRVSYZA0Hc4M9FAxMOM3IJiKt0TmKpCM+y0pJCobtBwe4gxkcTrl+P2SayhFntNyM0mBv19w
X-MS-Exchange-AntiSpam-MessageData: TSvucj60dSn/samwtUeJ/cd2pGjWVSezNLs3ksvvDkK33OwMg/x/1QjHKV4kjmrKKAZrnnSd2R+YxLrLqY9V6s4rCVxOEOYDHEWujSX+1rA7x9uZom6MLzAwBkoUEE8zrvFbdKGXtE/q+flA5UPO4pjy/WyDD27QuNw+XGFogDYvLaybRdGH/a+7z6aFlMes5KualVf7MoylpJnWE974e7zyr0txWbO0LYSYVQVT8hXTE3mh8c/uIrGfJu+FvgG8JHgsmqoPmZ4E931myqWLp4KCHNSOOffUqr4L3hH0euX34I+01LYNDbHrGoCg1o/OkPqWYl5SXOGh0P9NCR5wzJM8tBJ4YpKvkm31wlfxY5nN2gjprLb8uyaNOtOHWQ7JQJDpNs+q40xYOY2O3z/L0gbZ1FGK5mHARS+tfx8dg/rkGntP9eLDz13Gz6jim9TyfohXDYQlEOU7AhDO9KlNs8WeBVKzgiXz4j0L+N7ni8owtO1ev6gP7JF74sFF9VXFPX6JU5pzaRMxmPI20ID8vQ23Nep5n0vz1ZmrRajwx9xS+tEfon0FUMwX73MWH0pifWOXOYIDLH2RIpcVNH4WpUGbkTG6KaaLR1oscwqcSu57aRmdE3j6ga6PQVMFT5mQpRoUh90u3GEXINPCeR77x7f/vAvabDzmh1xUx6ZIV2zaMk+0dCTKEHn9de2KmxediHeTJrVM3w9Ds99V0FIuZEOE4gMc1X2PetYj1X5WM0ezhBMpo6kTGaWD1vlU20CIduhQwxQ3cTqsdYfhQKJsYgtDm0AugdQqjHVMySemUsE=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6b82b8b-c1d7-4436-21de-08d7ece23533
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:40:59.7721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: naVY8FbRz9vPmRUuXl1i8mgGdBbHaUm3AP8AvLp0fZzDg+d7quCdaKGjAcwva3XcTPImwv3TKFkwMyb36Ge3oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1194
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
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5a15b43b4349..0c92c16505ab 100644
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

