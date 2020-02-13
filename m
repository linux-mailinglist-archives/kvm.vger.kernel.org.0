Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF72115B68A
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 02:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbgBMBR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 20:17:58 -0500
Received: from mail-eopbgr690088.outbound.protection.outlook.com ([40.107.69.88]:17888
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729413AbgBMBR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 20:17:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cybsCZ1xxSLKFs5hNZoeOvGh/AfEXOnZffdW4mPOFXCvDZrIjR9IGuwPLjcmGvHvlBBgHRQyvew25QVeHxmPTHTN0Q6d3Ty96/wT0ePwi5viZTVRIFcu16uoWt2E5EB6iwQWzqcMxnn82y3NvMSWesu0sZ8DACVvjgSZbnHQ3VDhBE/3JGZ4T4kEHTXhS9/n6ITy5nl6Ds0z1A/6GmPgUpx1q3/jxa45gkgu3TucIpK1ebPSJ1vEzPHT9NlfWys3Ev8ZS+RTFRThD/naKw1Vj29Jl+xen0T4AZFKaQW5GVjpjlRiwPUoMHh0lBuzc2dhNwSiscgyApk9M0pScZmWrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHxnM+bs6KpDAU/8+Q5i66FL7s4ujhpIJyoT7p2lz4U=;
 b=Z1wjN6qwEYFwURHEe8B8H/V05Kko5J5SPdK3az87ip7ZEOrhDwl+OVTdvkcmZXyjzAVrYwdVdAqHTxxsYveUWkd7WTud0PnPeOq9lIXZQ/yDSwEKp3CbMjcOhylIWZ4++50HV8XOe1wckhDOV2tBhv4WR6ld1zyNaJRQfTJbHiVWQqn0Yh+L6//agQPYBxw2EFGWMYd662dGreOR8bOkC+kYctgucB2KcCPJnpNmBpY9wKGngeyNgVpixfOG8csi+udBiCAmDYGkwp1AUJu9vjkZhwtuehCScxWNXr3V2UkbKTO9Uh2zPanp9Zyw5rr9Pjo262UYCMfqIvwis61Ztg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHxnM+bs6KpDAU/8+Q5i66FL7s4ujhpIJyoT7p2lz4U=;
 b=tRNKSoZhIo05JrccClSypCmuvw2T6AnQokx9psnz6Gq+yhW3XKuF5WNH2nKdJMVEjLBKH7j9racTBYjgbisi238oPQOP0bdN3i9l/VlLhxnuXRWP17Iur0Ib378Y69oyCI31sBJtIPBeRdoI1gScDDFUiM++EftapLv1kCc4WYU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (52.132.196.33) by
 SN1PR12MB2366.namprd12.prod.outlook.com (52.132.194.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 01:17:55 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2707.030; Thu, 13 Feb 2020
 01:17:54 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, rientjes@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
Date:   Thu, 13 Feb 2020 01:17:45 +0000
Message-Id: <efe6a4d829af0b2ed9fe1b58fd2dfb343f5b8de0.1581555616.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1581555616.git.ashish.kalra@amd.com>
References: <cover.1581555616.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR11CA0071.namprd11.prod.outlook.com
 (2603:10b6:5:14c::48) To SN1PR12MB2528.namprd12.prod.outlook.com
 (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR11CA0071.namprd11.prod.outlook.com (2603:10b6:5:14c::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Thu, 13 Feb 2020 01:17:53 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0756dadc-175b-4c8d-1eb8-08d7b0228d9f
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:|SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2366FF95AAD245B22641BBFB8E1A0@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(199004)(189003)(8936002)(5660300002)(66946007)(66476007)(66556008)(7416002)(2906002)(6916009)(6666004)(4326008)(7696005)(52116002)(316002)(36756003)(66574012)(6486002)(86362001)(956004)(2616005)(81156014)(478600001)(8676002)(81166006)(26005)(16526019)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2366;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N0pq7GkVxtzVbLa3T5JO62mmqItNzCiYGG8KMlmr8N5jhr2Kosv09otNH1ycmSZBkXJYRzym+7/YNgBPuwyyryocnrmRQMvISgKBB5LsLG4hyw5XsAWvoiuP/7hdsnPCY/wBgI0tHZGnmiBlOHzFaE5rwn5pxsjKUlWrxZuJm3+pkfitmAw9TvAf6ntcR7qN4H+eG+TXP422sBDDs8uRUQdWmN8zFsgxul4xNy5VMCivLzC8FEpN3Qs7z/YuQG5sx8IzRe0uqt3BzvDydQI956D3lmJBao1ryN5aGwhdm/1LDwpPd5nLDq8fAczRjwHOpyEtRlEySMvsPQi/BRoNcMsmOSxC8T1K9fr8t9rbEjhc0d8xqYigaXSX9c8xfnx+qf/KQpnaXNjfvcZSrtnvovbV4aW72KKlBlW6th7zhSkkFEc8iesnr76Ka2d7B4Zl
X-MS-Exchange-AntiSpam-MessageData: MV8cacVMqtdXyVfnevQYgscbLu9CqusvEv/CQPnb3HeLWGy+6ofYZNmjrKA8NjD1o0JYU6IZYKdt9o/ZPV2FwGPiSN2tOwRh4Ii/dqZ+U1opGjK5uL4F8VOgvKYNoDv5RkCHPjekz1z7GgX3QejgkA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0756dadc-175b-4c8d-1eb8-08d7b0228d9f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 01:17:54.8786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: egt25R6PkDAgHu2h9nWgtMBIJEdtthG+FoPwwGI+9c7i39mckYEEvIy8QB8i/3NfthwGouD9wquLosOU6juBhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The ioctl can be used to retrieve page encryption bitmap for a given
gfn range.

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
 Documentation/virt/kvm/api.txt  | 27 +++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm.c              | 43 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              | 12 +++++++++
 include/uapi/linux/kvm.h        | 12 +++++++++
 5 files changed, 96 insertions(+)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index c6e1ce5d40de..053aecfabe74 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -4213,6 +4213,33 @@ the clear cpu reset definition in the POP. However, the cpu is not put
 into ESA mode. This reset is a superset of the initial reset.
 
 
+4.120 KVM_GET_PAGE_ENC_BITMAP (vm ioctl)
+
+Capability: basic
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_page_enc_bitmap (in/out)
+Returns: 0 on success, -1 on error
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
+
 5. The kvm_run structure
 ------------------------
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4ae7293033b2..a6882c5214b4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1258,6 +1258,8 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
 				  unsigned long sz, unsigned long mode);
+	int (*get_page_enc_bitmap)(struct kvm *kvm,
+				struct kvm_page_enc_bitmap *bmap);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f09791109075..f1c8806a97c6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7673,6 +7673,48 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 	return ret;
 }
 
+static int svm_get_page_enc_bitmap(struct kvm *kvm,
+				   struct kvm_page_enc_bitmap *bmap)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	unsigned long gfn_start, gfn_end;
+	unsigned long *bitmap;
+	unsigned long sz, i;
+	int ret;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	gfn_start = bmap->start_gfn;
+	gfn_end = gfn_start + bmap->num_pages;
+
+	sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / 8;
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
+	if (copy_to_user(bmap->enc_bitmap, bitmap, sz))
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
@@ -8066,6 +8108,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
 	.page_enc_status_hc = svm_page_enc_status_hc,
+	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 298627fa3d39..e955f886ee17 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5213,6 +5213,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
index 4e80c57a3182..9377b26c5f4e 100644
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
 
+#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc2, struct kvm_page_enc_bitmap)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.17.1

