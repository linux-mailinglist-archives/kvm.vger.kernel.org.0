Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94F819746D
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 08:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgC3GXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 02:23:09 -0400
Received: from mail-eopbgr760077.outbound.protection.outlook.com ([40.107.76.77]:37316
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729150AbgC3GXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 02:23:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9KYFOSN0co4I2QJXCDAZ0IF2JcHec/WKzwZb+LAXNLzjhFBhylNvzdXo5p/jZRMh7MQ2S6uGrz2Nponl3C+4c8azldTpgCJbuI6Uxy0gefOzxDX6TpXrGabzOyF59hMltUPTWOkdQKDl+KNOfTKlzGswZ7fEe8Z05Oge1qCYqUdPoTZPrzmGXPEPAOmkZ7g4al++O45EDyStcUFh0BYnaLR7RSkJJmdTiZhUMz7XMSOQ8Vxt7IdqEzzSkWWCOzGVtVUu8N0Z2tMedjr4lQfa0+NJujjFBzACmaQcOKrizfef+0yihiJKez/dfdH8+VddGl/V6EMdhGXFnDigpgJAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+UXpTgNHetydHNCBh1VcAiG2howxa6CXuo4e6BNI6Y=;
 b=bYFnISXRaU4oOAD6sLDkx4TbmsHhp07GIo/F/iUT6HIHlK664ztHuYNSTsahsEhZQYaM4L4q4rvBZGR+4LZtK4U4olwuK1p0P9o2aPI5VZHyldfBjGF7SEMoWs90NIwA2cEfwvZ/ZB5rIc/J33b5QZnLouZkS6156qR3ZQjJSWLVqYdpf27eUS9dngP3kL6LKQJIldcYLOluVkwOx4u+GEpvHbmZhRPtw5LwoP9n1ecHLE0JK8AyJboC7C4Zwg4tfReT5uF2CBsHnTihVg15OZQDw4ehB6Esza4aT+6J2P1AxxAYXV4V6q6xn2yKRL7P11v8JKb3RTUSfui0WWRtuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+UXpTgNHetydHNCBh1VcAiG2howxa6CXuo4e6BNI6Y=;
 b=tOP6OFr55d4E/K3pwc6VLYDMoMhmFfUMKd9zKfYv6mHK/P0SyQ+JHzy+1ZJEbgpLuFI46hrws021gCgx1smKXh7k+BqAkc6g0y8djOcRIhPC2mtJN4ANyre7+DJAXO4OQpHwIJOzp4GW+fGXfZQFXiztGumPhpUWjYcntajVYg0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1692.namprd12.prod.outlook.com (2603:10b6:4:5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Mon, 30 Mar 2020 06:23:05 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 06:23:04 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v6 11/14] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
Date:   Mon, 30 Mar 2020 06:22:55 +0000
Message-Id: <4d4fbe2b9acda82c04834682900acf782182ec23.1585548051.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585548051.git.ashish.kalra@amd.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR17CA0060.namprd17.prod.outlook.com
 (2603:10b6:3:13f::22) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR17CA0060.namprd17.prod.outlook.com (2603:10b6:3:13f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 06:23:04 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6a471f55-be14-44b5-b76c-08d7d472ce2f
X-MS-TrafficTypeDiagnostic: DM5PR12MB1692:|DM5PR12MB1692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB169256FF7AEC6ED8ADC2514E8ECB0@DM5PR12MB1692.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(66556008)(86362001)(66476007)(478600001)(2616005)(956004)(81166006)(52116002)(8676002)(66574012)(81156014)(6916009)(7696005)(8936002)(5660300002)(6666004)(6486002)(16526019)(186003)(26005)(66946007)(316002)(7416002)(2906002)(4326008)(36756003)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zS7qHa8bHAI/mP9FJlO+/43w5Des0qP1Dtf+82aE4835S2ELDEzRgVOZDTNBgSmi1IbCPq+WA9bC30tTWQkwm0xNmCyDw8v6S2JLAtBhc7OiCxJaACNLTJ7wrKIBC1C+RiLRRb6xOvXhF5XEiJ32W2gkxeyn1mTdVb420GoIJjabhWKXt7gl1LqzpsPQDD6WlqbndgAB8plVjr2AUPMeLvMv5h0anx3Vv+xWYT56rKBG9WV2tg8l40lb0lgQBapdcJK1oq6BqTdhj2HRzpWK6rCawEurAEycuZ9ZsgwpcEurhrhRQCeX704Yf2/fcv/+RMVmANOjqXyk9pcpDlPOie0dA2pw/B4WrjeBmC69Mdv/qz0eO8iVr4Jmed+pP69trNPmpRivM3rhlKy96lND2KLdafE0BL07Uctm1ESEENPjq1Mdwsib+E90cTIOYGP6WlIlfz2uZCUNz3x39jja5vtjUIgga/r/iVOKb0lx5uPZlgYrhj8DuRt5kUc6La0i
X-MS-Exchange-AntiSpam-MessageData: yJ0yC8oTIDmHTSJu+Dkd1P0bFB+ByKLwgixzjFSupsmq3KyvEPro/H+zf4hmPYhiRO3fcIt/HTIOKFtdg7O7PO5R9HNRdv8bxFdYD1/FqHLJjTTEPHQkZqbtdwnBGFOnXC/yX4tKi+93DFZeYKy74w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a471f55-be14-44b5-b76c-08d7d472ce2f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 06:23:04.8117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rnYI6H7eujoY2xHFL3mBFmID3dia3YD4/R5vNn7a+9PMRB6d1hmbRqoyVCS1a5if79wJNdZr50CZtCoe9WZp3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1692
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

The ioctl can be used to set page encryption bitmap for an
incoming guest.

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
 Documentation/virt/kvm/api.rst  | 22 +++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm.c              | 42 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              | 12 ++++++++++
 include/uapi/linux/kvm.h        |  1 +
 5 files changed, 79 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8ad800ebb54f..4d1004a154f6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4675,6 +4675,28 @@ or shared. The bitmap can be used during the guest migration, if the page
 is private then userspace need to use SEV migration commands to transmit
 the page.
 
+4.126 KVM_SET_PAGE_ENC_BITMAP (vm ioctl)
+---------------------------------------
+
+:Capability: basic
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_page_enc_bitmap (in/out)
+:Returns: 0 on success, -1 on error
+
+/* for KVM_SET_PAGE_ENC_BITMAP */
+struct kvm_page_enc_bitmap {
+	__u64 start_gfn;
+	__u64 num_pages;
+	union {
+		void __user *enc_bitmap; /* one bit per page */
+		__u64 padding2;
+	};
+};
+
+During the guest live migration the outgoing guest exports its page encryption
+bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
+bitmap for an incoming guest.
 
 5. The kvm_run structure
 ========================
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 27e43e3ec9d8..d30f770aaaea 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1271,6 +1271,8 @@ struct kvm_x86_ops {
 				  unsigned long sz, unsigned long mode);
 	int (*get_page_enc_bitmap)(struct kvm *kvm,
 				struct kvm_page_enc_bitmap *bmap);
+	int (*set_page_enc_bitmap)(struct kvm *kvm,
+				struct kvm_page_enc_bitmap *bmap);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bae783cd396a..313343a43045 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7756,6 +7756,47 @@ static int svm_get_page_enc_bitmap(struct kvm *kvm,
 	return ret;
 }
 
+static int svm_set_page_enc_bitmap(struct kvm *kvm,
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
+	ret = -EFAULT;
+	if (copy_from_user(bitmap, bmap->enc_bitmap, sz))
+		goto out;
+
+	mutex_lock(&kvm->lock);
+	ret = sev_resize_page_enc_bitmap(kvm, gfn_end);
+	if (ret)
+		goto unlock;
+
+	i = gfn_start;
+	for_each_clear_bit_from(i, bitmap, (gfn_end - gfn_start))
+		clear_bit(i + gfn_start, sev->page_enc_bmap);
+
+	ret = 0;
+unlock:
+	mutex_unlock(&kvm->lock);
+out:
+	kfree(bitmap);
+	return ret;
+}
+
 static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -8161,6 +8202,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.page_enc_status_hc = svm_page_enc_status_hc,
 	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
+	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3c3fea4e20b5..05e953b2ec61 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5238,6 +5238,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			r = kvm_x86_ops->get_page_enc_bitmap(kvm, &bitmap);
 		break;
 	}
+	case KVM_SET_PAGE_ENC_BITMAP: {
+		struct kvm_page_enc_bitmap bitmap;
+
+		r = -EFAULT;
+		if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
+			goto out;
+
+		r = -ENOTTY;
+		if (kvm_x86_ops->set_page_enc_bitmap)
+			r = kvm_x86_ops->set_page_enc_bitmap(kvm, &bitmap);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index db1ebf85e177..b4b01d47e568 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1489,6 +1489,7 @@ struct kvm_enc_region {
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
 #define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
+#define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.17.1

