Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7AD715B68E
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 02:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgBMBS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 20:18:27 -0500
Received: from mail-eopbgr680063.outbound.protection.outlook.com ([40.107.68.63]:21351
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729406AbgBMBS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 20:18:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCKkN7i+eHbuAMFXnZRxgam0yHvYdX68fpGnGiq4wwAKFgOK6hx1FILlhbaaiI+QgxcLXCG+BLnH74q1nuf+piiNAEVl4PGTw5JKGjhEox7H8te3EWHWKj1AEpddkbGkAoGphjK2N0nuj/dIa8glosb/VNf+D3GVt+N3SLXdqjsc9EtZX2zQmSNxnxsgwpuSPjzhJ0rvD2d8gyO25VqUehlARs4M3B97EPcwZ9xOAWcwyH5vSw5YoRh/YKhgY7G9asFCR40PKlFTVDN2h4hXeGdlXKQ/UsdkpC4yJ2IrIrcHVNqDL9Iu9BsYpc3bT7eTB5C3SI2i40au2G1a+3tMdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0e2OOOGS4uzuP8PKCCU9X70EtGN1XdBeQMH/uQys93g=;
 b=lx2mPAqU/GqbVchQ0EGd2vD9bySp3x+s1LVdzyF8MXesnD7AgGsKa61ZT6dMNvBZYuRbti6Ik3bYiRzaIOxTYPnrCn9fxMFul7aBnsszQil6GXs4wF/81/aH6EwDDhXIzMI/xuOHsLtYXlrUKnX29SrymXC+MeOptTbkZU6+mgFT7YE3zyha1l7bfIPvnZsI/HrxgzIcoUAdtHs+k7l/RJvfBrrGlfj0ET/OQJC9bBiyPcVRCVhy2W6HNiXKcstaKcU4qVZwetqTC5SGLh4n8x8AH0B8pdZt05014W/AEshBGnTIwb0LMM24b9qL1nTUQA3P+yPlZwWEsUVby/7mDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0e2OOOGS4uzuP8PKCCU9X70EtGN1XdBeQMH/uQys93g=;
 b=lHihTi/+Z1dLtsVBUCHO8cDORRXWjUm3Wnoh2+yYeqltusNr9UignlBVpxFxbfHjRJDVbJq1W0J4kptQQ1nLT+w/KSeqwd+l2gxJHmdB+HIh05m9lNgxJ5cT1RswzwgyxploMaO9rCbW/0ggkBdSvqkSMGlLZSI1hcrzfebTedQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (52.132.196.33) by
 SN1PR12MB2366.namprd12.prod.outlook.com (52.132.194.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 01:18:23 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2707.030; Thu, 13 Feb 2020
 01:18:23 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, rientjes@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
Date:   Thu, 13 Feb 2020 01:18:14 +0000
Message-Id: <b0d93327199829d47df9c1167f22356b5309a4af.1581555616.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1581555616.git.ashish.kalra@amd.com>
References: <cover.1581555616.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN2PR01CA0043.prod.exchangelabs.com (2603:10b6:800::11) To
 SN1PR12MB2528.namprd12.prod.outlook.com (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN2PR01CA0043.prod.exchangelabs.com (2603:10b6:800::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Thu, 13 Feb 2020 01:18:23 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 10b2c5d4-3c29-4b73-fdc7-08d7b0229eb9
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:|SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2366B39CE9B968B0151900C98E1A0@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(199004)(189003)(8936002)(5660300002)(66946007)(66476007)(66556008)(7416002)(2906002)(6916009)(6666004)(4326008)(7696005)(52116002)(316002)(36756003)(66574012)(6486002)(86362001)(956004)(2616005)(81156014)(478600001)(8676002)(81166006)(26005)(16526019)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2366;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WexVBGfk0rWNX9zMqYe1BR7vj1hcB5+c2kCWRpuIp202NwkNYdFI/4yJYKYRSuunaorhL5kV2W3H851XfZU3I8P8Gu9/kFir7HX3HHtYv1f2BIGLfX/3MVsxug0Xh7RW2qyrhXLQvEDQNcvn2wICWw/MGHB3+JELWs4fNo6kIqp6CQTN8lZyT54FKQrV7C0hb0rKo7Kdz5RHyCK0fo30fEA21IqgWWzGv3M9or9Vnk6r3QGIjB2KV9zclvW3VHOiVowkWUzfSut5uzt8KYtqY5JJ0xnFFpqGTUjDd1sYVawYfz1F7AfUlfCMFMyxPPmhMh9nYwDbO2YnRlQ2dWcSsu5FLgIDufSaNFEHyxNJ/bNItaJSuGwcpNRWHQ16y//b5e3HAWOcusqJYrDZi2jPuW1cU/FmTKI885tdiYN9jDtgWYiHaINRY25ZOAvEop4x
X-MS-Exchange-AntiSpam-MessageData: 0nW57U/TV3rFVhgmjP6dIMa0mypnXk7r47gVKwSx4Q5KGHS1I1Wp5ETkXrl8bw8LLunBe+IRslaMzG5QZ7wktuw17JnG2pqAV1TpQUWXWszPCa0fyUvFyxZqyqZFpIVlvpgu3KUMLQ/MGxfladJg6Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b2c5d4-3c29-4b73-fdc7-08d7b0229eb9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 01:18:23.5679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A2mcun8SdJECEFSM8tyAMrC4C4/VJO9gjKs3ppyJgdSJTPHdrjBoqJJVfv3nm5GvNF1uhRUvTdSzi8zdsjHLBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

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
 Documentation/virt/kvm/api.txt  | 21 +++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm.c              | 42 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              | 12 ++++++++++
 include/uapi/linux/kvm.h        |  1 +
 5 files changed, 78 insertions(+)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 053aecfabe74..d4e29a457e80 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -4239,6 +4239,27 @@ or shared. The bitmap can be used during the guest migration, if the page
 is private then userspace need to use SEV migration commands to transmit
 the page.
 
+4.121 KVM_SET_PAGE_ENC_BITMAP (vm ioctl)
+
+Capability: basic
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_page_enc_bitmap (in/out)
+Returns: 0 on success, -1 on error
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
 ------------------------
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a6882c5214b4..698ea92290af 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1260,6 +1260,8 @@ struct kvm_x86_ops {
 				  unsigned long sz, unsigned long mode);
 	int (*get_page_enc_bitmap)(struct kvm *kvm,
 				struct kvm_page_enc_bitmap *bmap);
+	int (*set_page_enc_bitmap)(struct kvm *kvm,
+				struct kvm_page_enc_bitmap *bmap);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f1c8806a97c6..a710a6a2d18c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7715,6 +7715,47 @@ static int svm_get_page_enc_bitmap(struct kvm *kvm,
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
@@ -8109,6 +8150,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.page_enc_status_hc = svm_page_enc_status_hc,
 	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
+	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e955f886ee17..a1ac5b8c5cd7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5225,6 +5225,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
index 9377b26c5f4e..2f36afd11e0e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1489,6 +1489,7 @@ struct kvm_enc_region {
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
 #define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc2, struct kvm_page_enc_bitmap)
+#define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc3, struct kvm_page_enc_bitmap)
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.17.1

