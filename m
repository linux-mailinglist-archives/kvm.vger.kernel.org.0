Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D579B1BF33F
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgD3Iny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:43:54 -0400
Received: from mail-mw2nam10on2088.outbound.protection.outlook.com ([40.107.94.88]:6064
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726420AbgD3Inx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:43:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVqjhxVLtiiBbnfQg29LliWknvSO4J+YiIhSQS56UbQefzZ2DzLZyQqh5+UNwOGVRHPmussgVpKdVVkks8sOYjeiSGTm5RgtrkPPrHjfAX1RRjvkDJhuJaYvDg7KRlidFXPrqoJI1eL9BqWvNoLAqHwgsaJPsiVnzuh6SxAu13+3B2CtqS23qEAMULYs2GiisKfx5KIgKGX7jal7oLtwDNpxxi5hgmbqvzxk4dRqmjl6Eq34lnpynzj+lZIvRWa5Cgeaz0bTxS+jx1VyoCuryYNDtS+vA0GEMJIxsTYXQl6/IFXSz1wI3jJB1nK3JsFH7Vvm8VhPAu3KqF2wEoBTQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jLb5iLrusH1EUXdHjpvbBVaxCR+QjOausPk4SriTzc=;
 b=BVy/ksvXUBscBO4wJfgW0Ib8M4jE+ZvUh9X5sJCDvrJisclI4kw4n3h4Gib3FnYYw9i6Yy05b+JHWFTQ/AXeDCrls5anGktEW5MeKIL5KmkB18fkkZM0vcZfjDcWt/K9STdo2k8h1G/7VFhwy2KCj2rTt+aMB6iAM5kEVKRL/9IrwUi7hwrCEHsFYcMvLUeHTyySwuY75xQgeLhUJWj0oe4u/76kka3ngFDFg0v8r5qMU2B32UUyHRMzpkh2PMQYT6m5HW9UeGQh1bk0XO0/NBne1tdSkZ9zZhRRne+pdfABTqWNSIt4WF8GFsJqF/bw52ttoDl+pEcr19iC8oFVQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jLb5iLrusH1EUXdHjpvbBVaxCR+QjOausPk4SriTzc=;
 b=oCcIzpj+mJt7+BCj54b44gZqFRcT3wrWu50UxEptSJ1MTpX1G9AS/VmoaxhJ4Z6BAc9c6KAqNTJ0OWc3h9ffL+MlUayS9kO05eBRhk0meb2Bk6nqLHYJkhykelB4tkpmKbVm2P51v+MfB+Q84qy62Unl5SNx/PiS0/gwX4Pfi0Q=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1883.namprd12.prod.outlook.com (2603:10b6:3:113::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Thu, 30 Apr 2020 08:43:50 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:43:50 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 09/18] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
Date:   Thu, 30 Apr 2020 08:43:40 +0000
Message-Id: <4f4246c58ab1ee7e61b72b0ef0a3b023d7976803.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR08CA0032.namprd08.prod.outlook.com
 (2603:10b6:805:66::45) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR08CA0032.namprd08.prod.outlook.com (2603:10b6:805:66::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 08:43:49 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 23cb389d-ad7f-4aa5-5b67-08d7ece29ae2
X-MS-TrafficTypeDiagnostic: DM5PR12MB1883:|DM5PR12MB1883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB18834D5AE97A99A5654CE39E8EAA0@DM5PR12MB1883.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(478600001)(86362001)(956004)(8936002)(26005)(2906002)(2616005)(6916009)(8676002)(36756003)(6486002)(7416002)(4326008)(16526019)(186003)(66574012)(7696005)(66476007)(5660300002)(66946007)(6666004)(52116002)(66556008)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cs4ONKTSZatzbWxtrFY3cOu1H2Tloa4Be1MFBHxVGvaLK36aprlcqemPb/5r5AEQk0aHFNUtfB3jvlcvBrJ/HGvJFWXW8bP11qz4yQVkTa2rV7iXIQoXpug6fczX7R+dcuHE5hgvnxZAG7x8CiaOMkUNM3Np/rYXE1BSuA42jga/5XYzZPEdP6R7yW8+9cvAtoaxAwqgNfLOyqFQwU3VpX5OzQBxmGg4ZmkOK6xBOjhu+KAMLoXtverJ61bDO//fRKT7oiTffwKubLTqTmE6haNCo3GN5YfdkIoEKHl03HEporgqErzNaYnz+YdIfCiK7/45cyeY8F7R4yCyCNgDdxWNof5yLy7+VRqhsdpuoTNJ2Ecb7VYrYmo1Y1apDvEhr3gdVTTHAPFHN6w4ThnwIhUrSydj7jrZQExoVrTGN7UXxL6rH/F5MlUtA7sVQudPkTifkBFz/1FrOHNVbzHWTo6LB15djqE/cwwUrUbITrON3S71A38qeYRxzhCcV739
X-MS-Exchange-AntiSpam-MessageData: C8fcHq5PcQQiLAuzeFVfKgVhArk/79Rkj8gzx7Oxh/exkIDFkjXe0hIVdVDrE87bvUbCExym7FZtaAvEPtnr7iG2Ye7x7cxecDfpztV5DFNeXU7TTNPYaonjtQLS8MI6yC1BfUIN2I/3nu+ToN7y06WY2tDytOXmmuqvoay+n4gpiGwiDL6mlPe+hH2cX923UeY4360Qcz58QPMYAcozZ2881GtOKFvs2o/v4YB0roETD5E0okPgKd9KYRLkjHzCkP1N788i8OAAA2ZTgMLaqcPiDgz45PYnTqSvDoxv/GCGXs4Po79NbZyEfRRHCgZvaWGjAbfY8EgsKXKmxxzA6l8QyMqDeOiSVTwE0sThGXb+Q85xyVN4PLvemQPNOgMr+rGaTklmvOUXHM0Sx1BjhUX9gfsYmYxoQ96e5L33zymWJ6Itf2YgTQuacTBkyH5UfuYf856ER9X9Bj4f4We8zDOtuXwYZK6cS1+vWoFdAt5TLbi45Ekm7j+J3a+4bvDJPKKTEbLLdXp7P4rDmaOh9bkGn85zqBsYBJ0wNcd6ghIZ2zcDaaQbOhf3M5T5Wzy7cZQrWiGe430WEk/faNrIzLkkIxjKhfWCHjfv06+dYGGDYuK+kg/JJNBv+wOu5niB9UtJQG13ulFyc0RDDV0KkfzXEiNZ4OtNOIMBWAf8+FCu6Qnsl6x00OwsShitcvJH0XjWxcAoKxcYK+7g+Q6OxuIlCioiUhqCpQkKynL/7CdqM9TErOBIrYIWY3N/LJDpfu1L7hfYh1yW6rGYeVGoBpFeTTRFkYwEO4nXprunOao=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23cb389d-ad7f-4aa5-5b67-08d7ece29ae2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:43:50.3253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dtqzgzLad4FRzy77yoFc0xqbLU/tStLcdFFP5mIwnX4m2YL3Sm5EaHpOg78EbCOGH0248SzDT1urArZO+9NWnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1883
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

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
index efbbe570aa9b..e2f0dd105b5c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4636,6 +4636,33 @@ This ioctl resets VCPU registers and control structures according to
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
+The encrypted VMs have concept of private and shared pages. The private
+page is encrypted with the guest-specific key, while shared page may
+be encrypted with the hypervisor key. The KVM_GET_PAGE_ENC_BITMAP can
+be used to get the bitmap indicating whether the guest page is private
+or shared. The bitmap can be used during the guest migration, if the page
+is private then userspace need to use SEV migration commands to transmit
+the page.
+
 
 4.125 KVM_S390_PV_COMMAND
 -------------------------
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4a8ee22f4f5b..9e428befb6a4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1256,6 +1256,8 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
 				  unsigned long sz, unsigned long mode);
+	int (*get_page_enc_bitmap)(struct kvm *kvm,
+				struct kvm_page_enc_bitmap *bmap);
 };
 
 struct kvm_x86_init_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7dc68db70405..73bbbffb3487 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1434,6 +1434,76 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
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
index 1013ef0f4ce2..588709a9f68e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4016,6 +4016,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.check_nested_events = svm_check_nested_events,
 
 	.page_enc_status_hc = svm_page_enc_status_hc,
+	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6a562f5928a2..f087fa7b380c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -404,6 +404,7 @@ int svm_check_nested_events(struct kvm_vcpu *vcpu);
 int nested_svm_exit_special(struct vcpu_svm *svm);
 int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 				  unsigned long npages, unsigned long enc);
+int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
 
 /* avic.c */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5f5ddb5765e2..937797cfaf9a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5208,6 +5208,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_SET_PMU_EVENT_FILTER:
 		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
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
index 0fe1d206d750..af62f2afaa5d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -505,6 +505,16 @@ struct kvm_dirty_log {
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
@@ -1518,6 +1528,8 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
+#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.17.1

