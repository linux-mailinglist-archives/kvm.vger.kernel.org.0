Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF142D35E5
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbgLHWHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:07:34 -0500
Received: from mail-mw2nam12on2074.outbound.protection.outlook.com ([40.107.244.74]:34912
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729455AbgLHWHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:07:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPIaB8kBT+1dWVqEp5nHvaPpkSdKVFDUKC6c4dyQcAZxbtcP2AP1jwnsd43NJzx5CR5RRV6fDGM1WdXV0PsaAbiLyt9WQGjaTuIOeYDurLG8P/ZWrxmaUi6uknXOmS4p4AdAAAuSRCZiBklZZ96+kS/UnoYBDHHLjM+PRrP2kxqGpICkXF3YLluFUoH0KSP5u+6nX9XqsQ487S807EuCRMuGt/IbQp/p4eNUsPFC8LECBMfnwGfPaDGG0bXF1rKvMrBPULVLx/5atflgp3e3hI92ybdjbTJYIDCuLOD4x4g6Va1jwh1ffG5WA9xhC9DjGJCPANoKK4u2K1K3q43CkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/ye5BF2QSmbj0xCHmJG8H4YTIhBT+GtTRwrQhIqe90=;
 b=a7Vs/n+twk2CIZAna4wbI/Zs6k6DX7kgXyqwpSzS6IJapbk01xtL1lXp6NPUxXr7joIxx1LtIzY+a2NTMYyBJ/g7/swAeE0AeZk6y+y2v/TDw7J+AjweFI1gNV/U6qyzIyHBlj9N/DLZumsD9nyFvV2B7XjlRkqz6NtWmRKzFnHOyzXtNkVE/ffrg/KbqiWVAeSqguzE2VBiJkbgqnl50Qe1wCiz90cArMMPmnhfl3Y9lWjt+SiXOrIGOwiSO+ABo39g4plm0u9Ij2WrsiO1WZnwrcXPUbFXFrSD5Jsmo0o0/MbkA+IBfdAjv5yrCvW9Mw6ce2TMtusr0Xz7swyeXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/ye5BF2QSmbj0xCHmJG8H4YTIhBT+GtTRwrQhIqe90=;
 b=qTDSZqYmR2OawDLLtsI1GdWgs4hL041Uzh79NAa/seUVSzs16gYPwvy5GlzDitSKk8DKXSNZhP/pphWpOMab+jiayF6xDhbpqEmd4Q5ULuWe2ltQXYrAheUgiWiZSXspQwGJSFwq8ya/nExtB5JI7vc+OgmUKkJw/twjZn9Fq+4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Tue, 8 Dec
 2020 22:06:48 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:06:48 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 09/18] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
Date:   Tue,  8 Dec 2020 22:06:35 +0000
Message-Id: <9f10ed65931287fbcb375cab9b8496b01782c346.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH0PR04CA0062.namprd04.prod.outlook.com
 (2603:10b6:610:74::7) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by CH0PR04CA0062.namprd04.prod.outlook.com (2603:10b6:610:74::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 8 Dec 2020 22:06:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 654ee23a-2c95-4539-710e-08d89bc58ee8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4415C5FD43F84E63F4DA985A8ECD0@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HOYX0sN3b+Jme5UPWaYEiHDyGIhwnx0AVaNjFdCAPUUb0C18gKCBDwyM+E4+2m4ycanGZ1tn2h+/nj4C/EHpFVcaMboYq2Ct1nBrzZecbzkURHiLYzwsKRqNu+2Po21zoxzP2DkmL+eNzVNUtsyXWf5DjaGIKuUWZ4rtgpRu9NkHtNZYzUxkqixjUZ3Fj5smp2qYUOY79qrfmymXgliq5RDD+bs9YShD1BgYOqvWnKcvdomRIVMUvkz2V3ZkpzhNkZ9kutRXNAL4EmXYiwpmhwnkw7gxdSDIXEvW3Gm30ENhc33vuHInU4/xPmymvYYkQ4utubYEo1TtDCH49BKeX0jaBhvi5NEgLjipu/7dDXzAzCQOwaB/elmY3Ls82UJl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(34490700003)(83380400001)(186003)(4326008)(86362001)(6916009)(7416002)(16526019)(6486002)(5660300002)(66556008)(8676002)(8936002)(508600001)(7696005)(52116002)(66574015)(66946007)(956004)(36756003)(2906002)(6666004)(26005)(66476007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QloxL3hmTlVSeXhuWXB6dEN3OG1wTzQ4dUN5b0I1a0VoaUFOdmdHNlM2TDNl?=
 =?utf-8?B?THlwWThOTWhpbHJFY0pGdHQ5cVp3M3FmOGNhOUN1ODE1eDJ2OXpJNGJLQVpH?=
 =?utf-8?B?QktLRnNGNmZYSkJyWlJIVVNGaHBNek5rV2xMWGJrK3lyQ1ZPbmE5ajdWYlhG?=
 =?utf-8?B?ZkZqQ01maTlpaklaM0lCdjRzQXhER0ZwYmdnM05SV01YK0JCcUJsQ2xMVXdB?=
 =?utf-8?B?dTcrRmh3OXVwVG5RS3B3cDJPYks4dHhSZ29yeHdITXgrMy9kOU4vTkN3ejRE?=
 =?utf-8?B?THdSNmM3WXVZRjdTR3JlZEZSQmlxeGZWRmRva1VxWFJ3c1lIbi84S2VBbU1J?=
 =?utf-8?B?WWFuVlprM3k5a0l0M0dtUXhOMmtZeXk4bHNQUWg3K2lJZjRsY2NRODlVNXc3?=
 =?utf-8?B?b1l5Vkg3WFNxQmRNMlMyUWUzTFlkOUdSN2lNVHpLL25MTXFneVNqaUthQ1Yv?=
 =?utf-8?B?RG5oQ21WQVp2VmtVOGZKd25YczRzSGtZdnhYeEt2WFVRdmN6bjRqVkw2TU9o?=
 =?utf-8?B?NjBBMis2bWVaSE5sY25Xb2d1Y0k5RC9YVU1YcWs5eVdwUzl6ODFocHRGWGVr?=
 =?utf-8?B?UDhZSUU3NCtxWk1sZGd1OFN2dzVHS2xzK01EUG5RMHVTV1VjZlpXV1g4SHFN?=
 =?utf-8?B?Q1ZiSitkbm5admp0ajBxTjJxcVFsbmMxNlRFcVY5UEo4T0xEcXJBdnB5TGhN?=
 =?utf-8?B?d3RjUnlURmNFOTA0MUI2L3RkaUlGalN4b203U1ZwVTlBNGl0dDg2K1gvMlJ1?=
 =?utf-8?B?UWFLYjZTaE9DVER3UW1lS3lwVlNrd0JEY1NFUm82and5R25FQzN1OHhaRDUw?=
 =?utf-8?B?ZjlaL3BlcXR4V1FXTThFbWNkMHI5ZFBVUGhiSGxRQXVyVElHSkozSVNEYkJ4?=
 =?utf-8?B?blU0Q1RVZUJZTFZRSXdnVWp3Mm5GbUMzb2dtQWFaelNxa2d6TldBek5jSlE1?=
 =?utf-8?B?cUc2eGNZcEcyZWpRdHl4OTBNaUY5SGNGenZTMm1PWVB5WmVBaFZTUWRwMmI4?=
 =?utf-8?B?elZKUzRMQ3BMSkJHMFZCK1A4VEg4ZjVCM0d0OWtvL093b0EwWWZvWEs1NjJR?=
 =?utf-8?B?VkJ0MkplOGNFWE1BRzc0d3pMVmpYalZhM25zWmpBeGNkZng4aXRkdUdmMkxt?=
 =?utf-8?B?VnNBQlFnYm1SQVFZTFlQZFM5WXVtMDZxNmV4cXU0N1pNUHUyQ2JuZnQraDlr?=
 =?utf-8?B?NWJKVGVtOGV3NkFTdkxoRWVRMzJvZkNPNUZZT0JoWE5URDRTUG9mR2t6VkMx?=
 =?utf-8?B?Q1FGNXBhTTJ3TVcveHI1VUs5WjNqa2VvTEV5cURqQ29xeVlhbDRWS3QxaC96?=
 =?utf-8?Q?r06RhnjuDM5U7Ppwock3z2blHOzkCqgHpG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:06:47.9886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 654ee23a-2c95-4539-710e-08d89bc58ee8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6WzO8i0N29Boj5F3UFc6J28JMCoM1VEFMzaBRmi5YvpoK450YSSAAgnMtQYkBH9/mJ4XfSuehW9Be3DrYOaJbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The ioctl can be used to retrieve page encryption bitmap for a given
gfn range.

Return the correct bitmap as per the number of pages being requested
by the user. Ensure that we only copy bmap->num_pages bits in the
userspace buffer, if bmap->num_pages is not byte aligned we read
the trailing bits from the userspace and copy those bits as is.

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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/api.rst  | 27 +++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/svm/sev.c          | 70 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 12 ++++++
 include/uapi/linux/kvm.h        | 12 ++++++
 7 files changed, 125 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 70254eaa5229..ae410f4332ab 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4671,6 +4671,33 @@ This ioctl resets VCPU registers and control structures according to
 the clear cpu reset definition in the POP. However, the cpu is not put
 into ESA mode. This reset is a superset of the initial reset.
 
+4.125 KVM_GET_PAGE_ENC_BITMAP (vm ioctl)
+---------------------------------------
+
+:Capability: basic
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_page_enc_bitmap (in/out)
+:Returns: 0 on success, -1 on error
+
+/* for KVM_GET_PAGE_ENC_BITMAP */
+struct kvm_page_enc_bitmap {
+	__u64 start_gfn;
+	__u64 num_pages;
+	union {
+		void __user *enc_bitmap; /* one bit per page */
+		__u64 padding2;
+	};
+};
+
+The encrypted VMs have the concept of private and shared pages. The private
+pages are encrypted with the guest-specific key, while the shared pages may
+be encrypted with the hypervisor key. The KVM_GET_PAGE_ENC_BITMAP can
+be used to get the bitmap indicating whether the guest page is private
+or shared. The bitmap can be used during the guest migration. If the page
+is private then the userspace need to use SEV migration commands to transmit
+the page.
+
 
 4.125 KVM_S390_PV_COMMAND
 -------------------------
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d035dc983a7a..8c2e40199ecb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1284,6 +1284,8 @@ struct kvm_x86_ops {
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
 	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
 				  unsigned long sz, unsigned long mode);
+	int (*get_page_enc_bitmap)(struct kvm *kvm,
+				struct kvm_page_enc_bitmap *bmap);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 134d7f330fed..4280da9dfea1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1448,6 +1448,76 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 	return 0;
 }
 
+int svm_get_page_enc_bitmap(struct kvm *kvm,
+				   struct kvm_page_enc_bitmap *bmap)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	unsigned long gfn_start, gfn_end;
+	unsigned long sz, i, sz_bytes;
+	unsigned long *bitmap;
+	int ret, n;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	gfn_start = bmap->start_gfn;
+	gfn_end = gfn_start + bmap->num_pages;
+
+	sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / BITS_PER_BYTE;
+	bitmap = kmalloc(sz, GFP_KERNEL);
+	if (!bitmap)
+		return -ENOMEM;
+
+	/* by default all pages are marked encrypted */
+	memset(bitmap, 0xff, sz);
+
+	mutex_lock(&kvm->lock);
+	if (sev->page_enc_bmap) {
+		i = gfn_start;
+		for_each_clear_bit_from(i, sev->page_enc_bmap,
+				      min(sev->page_enc_bmap_size, gfn_end))
+			clear_bit(i - gfn_start, bitmap);
+	}
+	mutex_unlock(&kvm->lock);
+
+	ret = -EFAULT;
+
+	n = bmap->num_pages % BITS_PER_BYTE;
+	sz_bytes = ALIGN(bmap->num_pages, BITS_PER_BYTE) / BITS_PER_BYTE;
+
+	/*
+	 * Return the correct bitmap as per the number of pages being
+	 * requested by the user. Ensure that we only copy bmap->num_pages
+	 * bits in the userspace buffer, if bmap->num_pages is not byte
+	 * aligned we read the trailing bits from the userspace and copy
+	 * those bits as is.
+	 */
+
+	if (n) {
+		unsigned char *bitmap_kernel = (unsigned char *)bitmap;
+		unsigned char bitmap_user;
+		unsigned long offset, mask;
+
+		offset = bmap->num_pages / BITS_PER_BYTE;
+		if (copy_from_user(&bitmap_user, bmap->enc_bitmap + offset,
+				sizeof(unsigned char)))
+			goto out;
+
+		mask = GENMASK(n - 1, 0);
+		bitmap_user &= ~mask;
+		bitmap_kernel[offset] &= mask;
+		bitmap_kernel[offset] |= bitmap_user;
+	}
+
+	if (copy_to_user(bmap->enc_bitmap, bitmap, sz_bytes))
+		goto out;
+
+	ret = 0;
+out:
+	kfree(bitmap);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7122ea5f7c47..bff89cab3ed0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4314,6 +4314,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.msr_filter_changed = svm_msr_filter_changed,
 
 	.page_enc_status_hc = svm_page_enc_status_hc,
+	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0103a23ca174..4ce73f1034b9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -413,6 +413,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm);
 void sync_nested_vmcb_control(struct vcpu_svm *svm);
 int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
                            unsigned long npages, unsigned long enc);
+int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3afc78f18f69..d3cb95a4dd55 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5695,6 +5695,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_X86_SET_MSR_FILTER:
 		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
 		break;
+	case KVM_GET_PAGE_ENC_BITMAP: {
+		struct kvm_page_enc_bitmap bitmap;
+
+		r = -EFAULT;
+		if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
+			goto out;
+
+		r = -ENOTTY;
+		if (kvm_x86_ops.get_page_enc_bitmap)
+			r = kvm_x86_ops.get_page_enc_bitmap(kvm, &bitmap);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index fc0a48c37aac..67cdb301ec4d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -532,6 +532,16 @@ struct kvm_dirty_log {
 	};
 };
 
+/* for KVM_GET_PAGE_ENC_BITMAP */
+struct kvm_page_enc_bitmap {
+	__u64 start_gfn;
+	__u64 num_pages;
+	union {
+		void __user *enc_bitmap; /* one bit per page */
+		__u64 padding2;
+	};
+};
+
 /* for KVM_CLEAR_DIRTY_LOG */
 struct kvm_clear_dirty_log {
 	__u32 slot;
@@ -1563,6 +1573,8 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_DIRTY_LOG_RING */
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
+#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc8, struct kvm_page_enc_bitmap)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.17.1

