Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8210C197468
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 08:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgC3GWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 02:22:54 -0400
Received: from mail-dm6nam12on2059.outbound.protection.outlook.com ([40.107.243.59]:6140
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728981AbgC3GWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 02:22:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvB6ME2BtO6G66U0vVv/zm5HXwXrgJGvL2Eto72+pOrMbnQQgB4OO3A0PmtrMDBHO6JYwXNS2fzAufEs+pn2+d/gpQqNKTYlEVAZWYsWvMwRKNENlMZElMzo+PshQggCCqJ8G489IetFp21qgFk0MqH+BTXanBfUFY8z1E1uZg7eFHbGdVpxPcL6rZ/C8HTTpLn9H6GF1yCNVeX9CF+Z+UeGQYbWlqH6UbFb1VVxW9yvalkNTeI5YIvvpRycuVbQsfeSCdwYPJD2i5uyGqwS7N1Sw0NnhnpRbHtm5xIZMwFI3n8uHKDs1cj5RUBm4UQeufz4hRozpbWf7VRXZfk8sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzFGZPR+Su1a4EocaL/Opsnx+ZVHxKTEx2mik9aZpaQ=;
 b=TFWVoisEJJG2jUBS0msuWtqRQV2xYgpocVtit5nwbtbjHIL1dk37vUh0/2dZr+5jsAHKK3JyNkumCNOiwFUcVAFyygR81Da9dhg43ajOQnFZjkjkIBKMQ9e3nntab/7F417paMLWpTQXv3Ta3sJiKIgl5xfXrKhpw8lAjxOyEUJjVIiBA9enwG4s5I9Nhke/PfLhE+VJOubM79EVjhKbSeoyms1hR7iGAw9iqIdi5USKIMDOh34W9P3QznzdbEGGXEvqUsXgOMNihiElOYf6pA/NVRBffN3lR0ZLOMBeaw/OWT+DmeQ2H7NdqRYFuYwFo06850jGQwv0zY5bLSn5YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzFGZPR+Su1a4EocaL/Opsnx+ZVHxKTEx2mik9aZpaQ=;
 b=OPJ6fwU7Vd5wMMoR4k8IvCTAol3Jw0cg3Zq9N2MVAPG5yygQy4uZthLdUZEUsAV/6zPJiTO2mLKfVV6lQqIMIXWqL/C9OPA4je4++yO/4piHgXkx0nxsyFNGCALghESqM8nJuA3wPAL3E+AC2blzqunjxxlqvCebmW1QE7q6Pow=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1692.namprd12.prod.outlook.com (2603:10b6:4:5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Mon, 30 Mar 2020 06:22:32 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 06:22:32 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v6 09/14] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
Date:   Mon, 30 Mar 2020 06:22:23 +0000
Message-Id: <388afbf3af3a10cc3101008bc9381491cc7aab2f.1585548051.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585548051.git.ashish.kalra@amd.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:3:ef::13) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR04CA0051.namprd04.prod.outlook.com (2603:10b6:3:ef::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 06:22:31 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 157f1985-e2f1-4b16-d337-08d7d472baa5
X-MS-TrafficTypeDiagnostic: DM5PR12MB1692:|DM5PR12MB1692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB16929645D4EFFECFA428C7E78ECB0@DM5PR12MB1692.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(66556008)(86362001)(66476007)(478600001)(2616005)(956004)(81166006)(52116002)(8676002)(66574012)(81156014)(6916009)(7696005)(8936002)(5660300002)(6666004)(6486002)(16526019)(186003)(26005)(66946007)(316002)(7416002)(2906002)(4326008)(36756003)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E9uEXEoLXr8bG0aU33qdwxgHd7VnOW8aV2mR8F95Q5Gkk9IwBzapXkWu/fxQyHZd46YwMQANOSP0aIsHbmEOkDPz2DPD2x753LeEPrVlPnY8JPH4eSTdQz7IOC8EJesuchnwrCJX1rQ9mzatUrNfW7wU0/tSQevLAX8fQXwqxFkNhBi/q5m0GwGnrxNzJ0JmN9vxcSeG6nKLxSYXigemoumkfs7qpFcwNP0/AAgcV97/bH/1NzoW0S252nQPzsZaFPgfhqzPSKI4LKuETPb3wr7TR+uDNNCHtImWgzmIQQUxVoGtWzN8tld9wvMrhn6xzV3obVf+g8h9/ytcv3b4Kl05sxl8Ves6RwLMMMzqyJtSi8w7Azgs+XSXEHTct/wCUGjXkYFHvi8kJgBRk1PUz37xsFC5OVl8G+iP9xU7ZQPKDcOteFw4m+7yRQ8Os0Q+gOKrIB+KNvOP4c8NTyNbiHMJ2eS602J0iTpPBE1zsaaDQC/ymWGgir4Tk9GhGnRN
X-MS-Exchange-AntiSpam-MessageData: QuVwFms6SHOYfzplYqbIBS1bd6srO2oY2hECQwZHq+REljiBQxCYC09rSFw/mUHBX9doxG/1Vuovjlmy6EvtWjyB24VSqWW39cBZ3FpuWFRo8EiYQIrJ9HUMOXcxgf6jcAEM7eOutBbPjbM0V+b4CQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 157f1985-e2f1-4b16-d337-08d7d472baa5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 06:22:32.0333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KYBZeOJDHwjecsQ3xXR5U/gNs1JuttloBK/mcDm25v2unzJlb7S9PQDReqaIbB0ibpZRWQRUGXo54WD/0viD1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1692
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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/api.rst  | 27 +++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/svm.c              | 71 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              | 12 ++++++
 include/uapi/linux/kvm.h        | 12 ++++++
 5 files changed, 124 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ebd383fba939..8ad800ebb54f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4648,6 +4648,33 @@ This ioctl resets VCPU registers and control structures according to
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
 
 5. The kvm_run structure
 ========================
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 90718fa3db47..27e43e3ec9d8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1269,6 +1269,8 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
 				  unsigned long sz, unsigned long mode);
+	int (*get_page_enc_bitmap)(struct kvm *kvm,
+				struct kvm_page_enc_bitmap *bmap);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1d8beaf1bceb..bae783cd396a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7686,6 +7686,76 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 	return ret;
 }
 
+static int svm_get_page_enc_bitmap(struct kvm *kvm,
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
 static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -8090,6 +8160,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
 	.page_enc_status_hc = svm_page_enc_status_hc,
+	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 68428eef2dde..3c3fea4e20b5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5226,6 +5226,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
+		if (kvm_x86_ops->get_page_enc_bitmap)
+			r = kvm_x86_ops->get_page_enc_bitmap(kvm, &bitmap);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4e80c57a3182..db1ebf85e177 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -500,6 +500,16 @@ struct kvm_dirty_log {
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
@@ -1478,6 +1488,8 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
+#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.17.1

