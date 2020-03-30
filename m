Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1D8197217
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 03:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgC3BiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 21:38:10 -0400
Received: from mail-eopbgr750041.outbound.protection.outlook.com ([40.107.75.41]:37124
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728077AbgC3BiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Mar 2020 21:38:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ao1sMX19/Otpl51X5Y0gErsQyguqAlYyZx86EoMBLWS5Zc4b4dsWEJoetnCD8Th6EbUDuCvukB578bHaQSOeXZ+Ol20yql6amvLM263UUWKfR/GbJllX11ZzRnEIYSMWnALdCfC0Vg3bJDQORP6r4T1PpWM6S7IkXXiQlRSEpY6TkTtT7VDFPqCJ/XxE/XMVT16ZrlbpI8zSm/x0Zn/9vwnyCwhVFAQmcuPvh5/hRKDRPer/gUXoufHJP7k4MSlM8v+MgTF2fkaH3spxQ+eVqPy85rwI+NgfR4qGIv5Aj5knfsgNQCsS4IWNvzohMkBVbwcbU7kCVrqknYtnTTosAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+rutv8RNZ9J9zGk1iW3DhPnA3eOyfwyJx1isTHf35I=;
 b=TbzN03bF2DMJXHj7F1VtB2jcCubOVKtd12+R2jVL+r/VCXlGfZiU6SlTqrL0FfCg7RVc95rDKNu8yh6u8X6nRxMZWZO0coCSM1uuvesJtaAW7pbK0apuNA/By8nP4gMG44PaQm/SGSf6voM/xQd6BQv+wmNF70Lf5vvvBcydDbjTAl58CK9bG8odMkPB0VwfUOyfYJvK9hS+whRWvMRuAI3dmkomUX35iewocfehzd8z5I5UOhfr0IXPVKfImUjXA+q8vB0pVGScUMMXkY8jH5nIsTqngHDszoA5ZqJ75+MTr4MnyNTcVPHqgxvKOnmhMA42THqPrpcOPeA4wv9eRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+rutv8RNZ9J9zGk1iW3DhPnA3eOyfwyJx1isTHf35I=;
 b=h8leF/kPS+OGuW2dHVXrBbnf8+fj2Rum5MpwT9Oc4eteW8g1TUHcugdQHy4H6q07cR0rnp3BP3DqKtwN1BO74eGwLzrozE1Dp4wsKN1AAO1s9DkAZ0jx3DpNghQ/m+nB7H8XniWRI4Pd+g0ukFt8gA0XtDoUpkB3B9OoOeHxyko=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1387.namprd12.prod.outlook.com (2603:10b6:3:6c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 01:37:32 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 01:37:32 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v5 11/14] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
Date:   Mon, 30 Mar 2020 01:37:21 +0000
Message-Id: <ca84b8c580f3c1e411d4191b46e726f84ac25376.1585531159.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585531159.git.ashish.kalra@amd.com>
References: <cover.1585531159.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 01:37:31 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dbc3d5d6-0f4a-483b-d16a-08d7d44aeaab
X-MS-TrafficTypeDiagnostic: DM5PR12MB1387:|DM5PR12MB1387:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1387084D1F49D87F4A0545E28ECB0@DM5PR12MB1387.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(186003)(66574012)(66556008)(6666004)(66476007)(86362001)(6916009)(66946007)(316002)(4326008)(7696005)(52116002)(5660300002)(6486002)(16526019)(26005)(36756003)(478600001)(7416002)(81166006)(81156014)(8936002)(2616005)(8676002)(2906002)(956004)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /vhpTj95Fh+c0T0876c+Pv75GuMMUCgxCp59p5v87fqU/mB/FIp8Pvo4QPn/U7jwlcThL9EdUUcu8x8hXNoqzrz0HvIGoDtZBwlqFybV+YJXJphaIeWrA6v7NsR/cAIbqE8fOUA6hOoZoYxe5+nQQUFfAOGnnHg35lW/jrDN9P5DFJZiEQ7+E/Aw4n99C/jvAHv6eeBBvFv1CWH7ZJmbnEEacNyShPogjxGniCyN7IgPtWO3TiFD5BFdowkCVF7XXhom/GsZNJsWmlxVzfWti8Pp6RNfZyTCif1NZIT+d996Ambrv8lNfucx/IymXM/vb3MF4t5uJmLNewtq/ffbe06vqKraRPzx3M7PnSptzvSP35mlgED0XdB6ADS/QJM0S95oD8lNOL1eaxXcro+BXDIPX3TjuHpNV6GTcZz8AlQHRy4CLIrmvQyXn8ubWHCC9oG3WCZE7Xl/dQs+a4BEHQis3yLPlHbZJCdQ46UPtqrLrPEYFKGTxMvl2DVsYjGM
X-MS-Exchange-AntiSpam-MessageData: xkT3rTMRocpI3PLKSvwWNBLMcyEpFZcyxfkpdrowxJ7+2oUuGvI7OlWNtynmvjTry8chB2sgokrffUJdIw47TZobT/DefiIhm03ELYt8tns8fO6+foRrd8IvvIhfLPl2sbDo5z7wCUUkibq1bj4V+A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc3d5d6-0f4a-483b-d16a-08d7d44aeaab
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 01:37:32.7731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y52NFL86Tq+fysuGhueqgXvylS717lJHfM/ozgBK7flmUc/DL+jjQIBjQXwbgjTRmajcXqGJ8oBhE9OPoL6i1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1387
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
index c417b1bfb5bf..e7fa196f3de1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7755,6 +7755,47 @@ static int svm_get_page_enc_bitmap(struct kvm *kvm,
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
@@ -8160,6 +8201,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
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

