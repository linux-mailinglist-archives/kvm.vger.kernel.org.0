Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791E21BF346
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgD3Ipw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:45:52 -0400
Received: from mail-co1nam11on2085.outbound.protection.outlook.com ([40.107.220.85]:6130
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726420AbgD3Ipw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:45:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZsL9ECMLuPbJ1fhUrc2/p5ZKZAKy3QLkz5UWZoHu7rN+lqSXGGodQWsKAjdLix7UsGSnP9CXcW20uz2fcmHpYaXK1pG6BxmIlADHFhQCTv7AiV07j+YLix/vqo6mR0E13kxwniB24sa22MFATk6u74FDITXzBJTNZfdqS0aMVqWKHVdKGny6G0GgTYma47FAMVGXkglG1irGo4G1JQNXSTJXv9UEMMuwiTQUU9Emda4g18oPcWQQz8PnsPyJu2nMjcqBNjB/MH/qwfwSj1E5u2YBupOM9DppXtT+pF0pNtbNP96z8P6TZURy04aj1/b29t2d9DaX/xSgMkQ+a4If6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zG1GNnsFAMpxrgSuUje/Rq2PgwImXbX2EmeBSMrLeCA=;
 b=n+tZBBctMtihzVlKh/ocuKyNU2eHoymXIE5t0H2vcImT96Cj2hn6WCJsSEsakABDl5/KelKhNtFmWuRKbW42zBlZKuWO9OXp/bAP7YV0DirIAFMwxWloP9y3o8e3hUB+mH61nAykL11NcaWq+AKHT0tqIHB3nYZygqlAAd7IMdSHoUIwVxXHAcEGF/cywDyufyxixABbYAfzP3dAXBndQu2rl5l0+EJAjWW1Egwy66y5/nn5O9QcNbxy3XKAhrN3Rvy+LJwnC9F/XHj9YNXQ4RMMP5iqIYf1PWg4Z8lHEqznYRfrf+wnd0/PwRKgct732dTj4uwYfxNvfhsxeVIiZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zG1GNnsFAMpxrgSuUje/Rq2PgwImXbX2EmeBSMrLeCA=;
 b=3RddnF9dHKpfsLSTELX4XM3kGgG3y2BCl6Qxd4HG8RQZBNw51yES3JjoKbIENMWT2bsBOmTt2JTzRXlP4ROKSNozifeUAxbBo90DrgJB4fzIFFsWWRAi+j82U7gr/Plgssx/o6Sowcm6GNqdNOgVkMdg3XivG2Xupo4AmS5vPwY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1465.namprd12.prod.outlook.com (2603:10b6:4:7::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 08:45:47 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:45:47 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 12/18] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
Date:   Thu, 30 Apr 2020 08:45:37 +0000
Message-Id: <6366a6d1ae1bdca23435949a8ce7d8bf62098f4f.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0701CA0045.namprd07.prod.outlook.com
 (2603:10b6:803:2d::21) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0701CA0045.namprd07.prod.outlook.com (2603:10b6:803:2d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 08:45:46 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5168120f-2d67-432c-c1db-08d7ece2e0b2
X-MS-TrafficTypeDiagnostic: DM5PR12MB1465:|DM5PR12MB1465:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1465BC18CE19434EE86708688EAA0@DM5PR12MB1465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(7416002)(66946007)(26005)(36756003)(86362001)(66556008)(66476007)(5660300002)(478600001)(186003)(8936002)(2906002)(66574012)(8676002)(16526019)(6916009)(7696005)(956004)(2616005)(52116002)(316002)(4326008)(6666004)(6486002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tvNgtsAKMTUZLhh4EY5Lk7f7zKzyNUAhTDX6EpBiEp9fco/p2tCM9VEdWMh4JkHA1q1fJ1MRglDOvZ2V5y/t/0Ri9DvrKRl0DRQW+dvGZla1A9mABl1eR7F8GXO4hk4GTwNca25cn0GDokTiUrsz61KNlLI9v8kw+f7fEbJxC/eECkzr7CDboDPx4TYAwUl6czsYnaaTWlmot++vipCI/AHvHlwYriScNcfxmqfgBTJL6OaY93ZoXBZje9fEynL7Wl38V6gW1gRjJIEE+U2xc5yatbQ4nJbrdy8byGy/71/vEiTA27e1vjJ3ZM9LuDMmDIur1h2XNEs7oyBCGBVp4xeTR0Dr3AgejYt2gg5wNTtfCBAOgOW3QLBdC9EDiqP3SOF+acgMbGHzP3nh5Wnv/UOgLqQ8y9rCilkAjIW7XNmLBHALzwFbJpAWhTqEYe/MV2Xf/ZUuzAWe6LUHDLMB4suD1MiwVe23nCpniQhTLhMfAyvtfeH6lOGPGZyZxZdY
X-MS-Exchange-AntiSpam-MessageData: yQX30PhtgOvZ5fFBwRS/+uMWZ+XoxvwDa8Tb1n5fndEmNfOeAn8mGS+10KSbe1DtAMNdmkQ3A2bNXwdGXU/zEzvB6i8vS+Ywh1UQzADIl8gvNWB7UigKbL62giVZtEcoQlPKokY4vHSFC3SPmo4lTH1meccxLJ2txyT0giDwCehMfmPPzN+o4KE1omoG96nS63BXtS2+nvHBMAkNXLqFZPQjtDml/V1UFiweYMX5/OBEI62qXu0CfJ9jBGLRC3LWt9LRByKDnA7xPP0bpsOvU6toKE86khY0IhIFHz0fiuAHlAZYkloITlVxLV7pC515Yp1PV6gs8YCeh41LWu4cZL+8CSpHJfJYMSwxiwZjcIqbA8YZBzS7edk7wWJ1loC5dEQxpXdJ3ftsBE6/fDWF2e0FCgaIcTWwCR6M8d4QzGkW/pGxM4GALS4rlYNXfrsBzAFg5jlvQ6ziZ2V57UsI4Y19surRBvbQ3g1C0QCp2wbXfzrhTaJ8BImG5nlWr6qrsaye0JERW+I2AyB1A5ZX2U8w+9aSuiDRqrkcDWiLCGYGP3YtDyBFyE5yeXJXn6e3G5h1dlXEvReT1C+kywfpj9ajns2Y6dJCfmlTebMNOxY9/yL6SBfBdnPtKHYBr39ExLaZskIVC6E3fBPiWdongcrfsEVnzjLgwkkz/aYWW4z0FAuWuskgijkFfSon8u9WrC/M2Xas+WbNXXiMRPuI/a0ia9m3RHa6+JKBcmnnI0sxIBmzwDBAmtEbWj8VaaejDMLQvI039cdc4LJ9G+qiVFzYrz+pt87cXUAP3vQtBMc=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5168120f-2d67-432c-c1db-08d7ece2e0b2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:45:47.4869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MEbyn913aEEOid6K7tffiqnifrzeORhXC4JOldZI8A87rCQ1YRVIxJ62TSSSoUxtElsHKTuTdsUB3CoIedmgxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1465
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
Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/api.rst  | 44 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/sev.c          | 48 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 12 +++++++++
 include/uapi/linux/kvm.h        |  1 +
 7 files changed, 109 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e2f0dd105b5c..56c934db2a96 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4663,6 +4663,28 @@ or shared. The bitmap can be used during the guest migration, if the page
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
 
 4.125 KVM_S390_PV_COMMAND
 -------------------------
@@ -4717,6 +4739,28 @@ KVM_PV_VM_VERIFY
   Verify the integrity of the unpacked image. Only if this succeeds,
   KVM is allowed to start protected VCPUs.
 
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
index 9e428befb6a4..fc74144d5ab0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1258,6 +1258,8 @@ struct kvm_x86_ops {
 				  unsigned long sz, unsigned long mode);
 	int (*get_page_enc_bitmap)(struct kvm *kvm,
 				struct kvm_page_enc_bitmap *bmap);
+	int (*set_page_enc_bitmap)(struct kvm *kvm,
+				struct kvm_page_enc_bitmap *bmap);
 };
 
 struct kvm_x86_init_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 73bbbffb3487..64ff51ec4933 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1504,6 +1504,54 @@ int svm_get_page_enc_bitmap(struct kvm *kvm,
 	return ret;
 }
 
+int svm_set_page_enc_bitmap(struct kvm *kvm,
+				   struct kvm_page_enc_bitmap *bmap)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	unsigned long gfn_start, gfn_end;
+	unsigned long *bitmap;
+	unsigned long sz;
+	int ret;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+	/* special case of resetting the complete bitmap */
+	if (!bmap->enc_bitmap) {
+		mutex_lock(&kvm->lock);
+		/* by default all pages are marked encrypted */
+		if (sev->page_enc_bmap_size)
+			bitmap_fill(sev->page_enc_bmap, sev->page_enc_bmap_size);
+		mutex_unlock(&kvm->lock);
+		return 0;
+	}
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
+	bitmap_copy(sev->page_enc_bmap + BIT_WORD(gfn_start), bitmap, (gfn_end - gfn_start));
+
+	ret = 0;
+unlock:
+	mutex_unlock(&kvm->lock);
+out:
+	kfree(bitmap);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 588709a9f68e..501e82f5593c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4017,6 +4017,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.page_enc_status_hc = svm_page_enc_status_hc,
 	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
+	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f087fa7b380c..2ebdcce50312 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -405,6 +405,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm);
 int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 				  unsigned long npages, unsigned long enc);
 int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
+int svm_set_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
 
 /* avic.c */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 937797cfaf9a..c4166d7a0493 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5220,6 +5220,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			r = kvm_x86_ops.get_page_enc_bitmap(kvm, &bitmap);
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
+		if (kvm_x86_ops.set_page_enc_bitmap)
+			r = kvm_x86_ops.set_page_enc_bitmap(kvm, &bitmap);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index af62f2afaa5d..2798b17484d0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1529,6 +1529,7 @@ struct kvm_pv_cmd {
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
 #define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
+#define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc7, struct kvm_page_enc_bitmap)
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.17.1

