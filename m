Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5983C2C943B
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 01:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389189AbgLAAr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 19:47:57 -0500
Received: from mail-bn8nam12on2071.outbound.protection.outlook.com ([40.107.237.71]:20033
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730983AbgLAAr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 19:47:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQNikBy4xfVyyp+RCuRyjhelmfnXhheYI+MCnIqmNKoXeLnPyPXC7jlJki4ZpAuzKU1PN3lAbGRRego9Fzm3iR1a+TJNclNbCaqFMjB9IZajrxG7ISHUrDRWXAbWB9mKsDuNEOVyP6khZOBabe7kDJGuCQqHHSOXISmoBXs0GVrd4/DXSqk5rRG9uhNd4/mHorvERx/gu4CEalzwO+v6mPVnT47h3k/rGhILepxCxxeTIHIyDrQRtvAjQAGsvIYaU6RWlXZ3XxfWVATJlpyIdM+6f9n5/gnTzYI92qfiuWmRwlaW+5J7NXuhkawnPJu09e8F/VbQV85aHxTSGSRrLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHrJcBavywkH2wO9ZiQWc9kpSF4jp9r4aRlQxAiy7tc=;
 b=P6kUcdAM7YxnSdNKYVYG+mS09mMlZztR3ibNwhIAP9H+uADZefeXpJBNwEk0wgSYgUCo6NGVf9kKI+9GvxqVpi+nOYxY+Ygn9fVcBlN5+slx/shcAfheOWCuaeqxNY7Mmf9bWreyj5+cC68diw018jvwMYvjM2Q+Qd2P29zXcOaq1leh1JZhME64a3kDFNJE4b8BuQ1g6/MWJXQSzoiQfZr2QuqHOZhsvWXeKVlErluvomEE8/PkANcUQo+Hi+YwrYHgcmdDZNrS8Vofb1lmZk1W9IdqVUc4ELBonhvJped9HcS+t7dbm9FQVjrSs9nIyGPb5Z7IDsiGAuYRLdzn7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHrJcBavywkH2wO9ZiQWc9kpSF4jp9r4aRlQxAiy7tc=;
 b=DPSeIWWq+2Y615jinwq0w+0+EmRivyAYx8Rkzve8cKq2KwFNCsHX1jFI+ONQgsVBmMuRB5/yVsYXbd2wQ7T8THV0TTw66tKXa0HwZ9PbHZRm9ybbMNKVcYNSubrwuLjnc6e3fd9QwQ8iv8my0jaNy38owa3Gm8LuMB6/ymbTefY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4573.namprd12.prod.outlook.com (2603:10b6:806:9c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Tue, 1 Dec
 2020 00:47:14 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 00:47:14 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, brijesh.singh@amd.com,
        dovmurik@linux.vnet.ibm.com, tobin@ibm.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH v2 3/9] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
Date:   Tue,  1 Dec 2020 00:47:02 +0000
Message-Id: <9b9f786817ed2aaf77d44f257e468df800b999d0.1606782580.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606782580.git.ashish.kalra@amd.com>
References: <cover.1606782580.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR04CA0103.namprd04.prod.outlook.com
 (2603:10b6:805:f2::44) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR04CA0103.namprd04.prod.outlook.com (2603:10b6:805:f2::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Tue, 1 Dec 2020 00:47:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3c092cba-b0c5-488f-7cf4-08d89592a51c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45731F6253161FFB142629038EF40@SA0PR12MB4573.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XzwSnSe4nd05nFMg/7J+DZbY7U3EdR0/8Fh02WIiWrxGTGakUSURxSTTudA/Z32eQ8IHt20P44oZx1qdiNn6x4DsJfypCXU2rg8befqX7vyGiPDPbfMFgELZax9UhBiJhF8HZcAate8F2PA8CznfWVWtwv4Xep5aFdW2TqqdZV28N9jYo1k3B77P5Df9kESVzIbKx8B9HznJZs7YC/qiS/02bMDCAQWqm+v/KNuvk09WYCSQ3ZOProfDFPOpyn4YZkNI/tAxkqhL/TdlIbzP3Xo9+tLkclKl1sv/vyvNBFiqoClcxTS67jjrXHGAf2cNRuVFxfhYyfHF8WweDipbJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(478600001)(6486002)(7696005)(316002)(4326008)(956004)(6666004)(8676002)(186003)(16526019)(8936002)(52116002)(66946007)(5660300002)(7416002)(2616005)(83380400001)(86362001)(26005)(2906002)(36756003)(66556008)(6916009)(66574015)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eXo5Y3ZrSnlzdnMrRXVwZWFob2ZmdThMWEhVazBZdlk5M2swNEZlV1JmYUdz?=
 =?utf-8?B?Rk9wOC9WTTJrdEd0RTJ1SzhRSWZVZFMzZE11bjMyT3lMNHJ2ZlRBT3JyT1NU?=
 =?utf-8?B?UDg2VFlRamExMVY4SFZ5dU1JVjhVT2VLSWhBYkZFN2Vnb2NaYVZDTndoWmp2?=
 =?utf-8?B?dHpsZDZQcGRNZGxidnBLSlcwRU9EdnhwMUJmNlhvMFBESFBQVkE1eXlqbG94?=
 =?utf-8?B?NzZWMUVuelRWbmxITUpreiswRzFIeG5MUjBMZjZINVNlTWVXci84QkowMTUr?=
 =?utf-8?B?eFUvMTRYRXptNGhxV0g3cUpmdXE1T1BlM0tzUFB3YlFZZ0lxVU1PcjFQOVJk?=
 =?utf-8?B?dFpZM1VPMzhrYWpDajErZ0FsaG5KVE00M3VQNTBtQ2Q2dVVvQTdVQ0pySlhr?=
 =?utf-8?B?OUp4WFpUN2xmckhVNUNnMGd1b3FUczdoSXhWVTFUK2dYaWppQkNwYkQxb2ZS?=
 =?utf-8?B?dVRlanZITy9SblZrbVgwVGhLdXlSSjNZN3psZU5IWXYwa1hSYnZKdU8zSkpu?=
 =?utf-8?B?Mk1QVGZITndiT1o4WHYvZFBvVE9uSzkrQ3NIU0VqSTIwQ01Gbm1zRERoRktN?=
 =?utf-8?B?SCtvYmowbE9GRnd5L2ZKaWs1QzEyem9VRFJDeXE4TW4wOWhtZEEyNzVCaWhi?=
 =?utf-8?B?UzNFbi9YbG8zWU41ek5ia2x5Z0VCM05kcFg5M05PbmYrd2hlOVp4R09ETldq?=
 =?utf-8?B?eDI1bjNsUFpPeXNOMWpJY0xJcXlPdm91TlhzWlhFbHdqR0JnWGd3bGFYN3gw?=
 =?utf-8?B?Y2plUjl4RmN2QWVvZkVzV1kxNmJlSGhRODhyRCs5NjJsQlhFQzNINXkyWnJv?=
 =?utf-8?B?Rm03d1pZU1pmS0VkT3Rzc2RQSGN4SzRlbjNFTSt3Z0VLTWJscVRFZHk5Tis4?=
 =?utf-8?B?eWx5bTFJN2lKU2E0a3ROWG9mT1FhN1JWOThUTkgrMzBGejBQQ1Jsa3ErU2VL?=
 =?utf-8?B?dHl4Uy9ZQU9hQUtYYURDNUxjY1BKNzJYYll6K1Q4WlA3blA4V1h6SDVHaVBj?=
 =?utf-8?B?MmtDQkp5c2NhRGF1cmxVSHpWNk5NMURLWjVxc2gyU0g1UDF6eWwxSWNxWm5K?=
 =?utf-8?B?dDJUYjkyc1NnTFFnbE9iVzJqQlF5T1c5VGtCSVRGR0FobU90V0xOano2U2N0?=
 =?utf-8?B?UXRIN3NGTGZSZ0greXljamtPWmd2bWZtUGNxbHdCbnRGbnRMbkpKdVVybXF6?=
 =?utf-8?B?VUpNOXVIdkxMNm9OMGZ0ZEVNem5qYk1KOEQ4dUh0d3FQczlUMTNzQ0dZSG0y?=
 =?utf-8?B?cHM3c2t1TXlrUHZHUFZSNCtiZ1FBU05GL2ZsaW40WkxCSnFVSXpwRTFnd0k4?=
 =?utf-8?Q?DVrCrtqR11G1UxRoZ+7lPovfhvxbbn/v5P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c092cba-b0c5-488f-7cf4-08d89592a51c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 00:47:14.3635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FtHlDvswfPUKJmTLNtAL6lKcT0CCwI9I8LkGORTeBjO4zfFt3HVu6o8UYPn1P9goyE3vWCgdLQSb88d6Noo8WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4573
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The ioctl can be used to retrieve page encryption bitmap for a given
gfn range.

Return the correct bitmap as per the number of pages being requested
by the user. Ensure that we only copy bmap->num_pages bytes in the
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
index 6b8bc1297f9c..a6586dd29767 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1014,6 +1014,76 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
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
+	 * bytes in the userspace buffer, if bmap->num_pages is not byte
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
index 886802b8ffba..d0b9171bdb03 100644
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
 
+#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.17.1

