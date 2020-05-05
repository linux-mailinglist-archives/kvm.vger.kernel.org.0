Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19BC1C62DC
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbgEEVRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:17:49 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:11328
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729265AbgEEVRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:17:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+wkRg4P9n6H9eWtHk5d8t+Wc4xkHm2heHJGac+2G/Dw94CnmHTUoq2sfi8gkKvnfofDdPig86Vxvs7wfZaqh3o5Xg+jEnz9OgfZVQXuEFwXHqCdFtfL00vL5o9teqm6yBNSVkbb0Cta60zRkaCRJxpYMQm2aJB3fv0bjWrVRCXwlkKiij1GXCWfI1uEZ7dCbJrCls7PJS076p2/9JQ2TAnSDvgkxwVYKuHUFJYJy8w5jAr40VAEB5amMibHpqoJHZc2tEnqC6+DbeM3pzUv1pMkKkJhWEodD0m6uD6RyaVhCoRTn+cBMv1SK/DwiZuUfiR3aLvLfMyc/5Q2qoLiWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJkoKmVjJqkltyErVApWJjKqvxonYUARPOrvexVML0k=;
 b=YDfRRyeHS2XF/BQboigFgCxNY2NjdY7J2kwgCVfWyqA8gnh+boo474si1NYDpN1Cp7F9UA8odJQ57CLOOnhhT7MVxutw8GZzgIoojEfgU6fFC6ZfhnJrBIiKcH4a+crMTIH71SHhBMUfdXLI7Y2hqTXQeA+GMHLDBWf0VnVM9JX0cBFcRyLoCuh7Z+BtAtNVBqFdPV854ZfWocO5RNE1i7az44HCcpfi7WjxYSOxQ6xhjNGHH3Qa4HRfdv8VW7N5OFTgdvmqLA0a2bmKo3jd8Krd9DrNvBwgF+pr/LnMvpoj+4iLGXTNeBprauoxTzPxYLXxgk+4Cj1Ed2qZsEIEQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJkoKmVjJqkltyErVApWJjKqvxonYUARPOrvexVML0k=;
 b=H5xL3on712HTDl57jB6oF5c7teeH5PUBjTfVcrM0UQIOMEGJgyQP7Ka1P5WafplLUqrInZgnBmRPpl5+b+Fnrhgiz1L/4+tHRHiXkKyDb4SrLiY7qh4gHzUHC4mJ4kQmL8ojzVTM4zwj6FxcfZvohA/9IOxHpta5wQGcUW2Oi5E=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:17:45 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:17:45 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 09/18] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
Date:   Tue,  5 May 2020 21:17:35 +0000
Message-Id: <d4680b02ff88b2687cbb807afd8eb47784dd3a33.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR14CA0038.namprd14.prod.outlook.com
 (2603:10b6:5:18f::15) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR14CA0038.namprd14.prod.outlook.com (2603:10b6:5:18f::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Tue, 5 May 2020 21:17:44 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e673d749-ca8b-45b3-2109-08d7f139c0d6
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2518F4A477C2CD928A26811A8EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /qYqKWpnxwzVcKG5eLdPYLD5xiPGMb7UL6ZcEOSl3zeSoKMyrln8Yko98YycoyAp/xo2ULo/f2fCxLHD3FmD1Liju7jaJ+zY6HI7iVus3T/guNLmBJAvTsG+no6K9S+OCoVOTT5Eg9wqqKWRUxA3QSZu67upf2+jD3i+TRKWKv1NzcPoKhh+YJqZiI8JzEY6V/YDoq30WiK1MLeGnYyW5nSJOi3c6bjnBpofcGyVj3gpKugWrMvryi/wKYY6yIVzFu/pxT811Mr1jguxRV3l7j3Lt6dibybhopgYwzHwC24lpUw1r/mRMi+hzo7YnY8BLxy3h25GQAIxozTRGJBIVQm+5l2d63cVv6hbu5QZn66aTbP0WlU5+BjdBboZxL3btAXNgwQ6alZPmQ9sMLnDF3y1HSz3Um7EIHcdm0SvoYOOK9H5c6p2ffnvFpvBzczJBIuAvDfUXoliyLGtoFibwcdAw8SIxyiZUv+DBhsHWF4ocJt2QB8LnDowwbEWoEcezEHKUgwTHH/KfYji8VMpRvGOex4GcdyJlEZwUmHUiScNs5Wr/ZZTtRsNnKyzoFxT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(478600001)(6486002)(2906002)(5660300002)(6666004)(2616005)(66574013)(186003)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VQMmZeBVffnR0BYDA22nXJjEzMfhBlruEVTo86GM8eyY6HowQOJrCa5ewXyO+PmvRJFzOfE18liqgzs2yrfOGaxwHtK89GcVh5qm9embDdmxZOB/05+BttGlH/KvOyXmDqpdOM9sfn+HbO/r2M0qeNFTozyFXdTedIq3Vav0LYf0ZRuIWWeP6Y6lrenXRun7BUtwa0FSGahd2STOTmIb7NdtRjQ6TJfp6AI6Sf9z+Zgb8r/ctEOWDA7h+MGHyuh5eKFjmhoQCiJAwOBI/qtj8put6vi3nKDyWTm1ypJR6v5/Bopo8ljflFXDgnyKZrEEbeqQ6M/LFqjXBUPLKdpAm1/eJhmfaeiVoQcW6qt+7BGj99SDmmnlaAGCt6X+S6Rx9qaMGFbDLHEbWZXpPleNY4N3OBLV39qc1Khhr9mzjazE3qaj+LKkU6sTVeVrUlTIQ5xheirEVaEckhkQDZIeDemrV8kKn308hnzJ6lKP/R0X6yy0nULrb/rNXx29GvpVQOhb8+pW/HukREA0Xp88pgADPfhO8G/U4E5I+zdOePLG9Y7M8p9BO325Sl/+HZdTInCGC3DYNowwn3eO6jhZrNtKVv/lqxKHeCSmf718yiV14NHua2KCywNyJir+WnVUchq0FKb7o7VNC1guN/tHRsBzBqHeQat+54J1cvVUAP3alSV6crf/ltXXSylGNOPqmDIpKIDUd9TtFQBruKZDprMzxGcY6/1Haoa9bFbH3ZF49JB1HgI3RzcBpiPSnSJOuBUudiPnxv4oC3l+KCVVgf7Wqweh61HcKSMKFMPFdhg=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e673d749-ca8b-45b3-2109-08d7f139c0d6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:17:44.9281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vQhQDja0NlqonwwDUb/qYFQSZJ9jzhdkHXFBtJUxpoD2zqmKKrIUgmpQvWBVPhC1z6qkcDPSS9u3aJuEZbhQDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
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
index efbbe570aa9b..ecad84086892 100644
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
index f088467708f0..387045902470 100644
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

