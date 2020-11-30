Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706BE2C92AC
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 00:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388893AbgK3XeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 18:34:08 -0500
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:11880
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388841AbgK3XeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 18:34:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOGYdSH/trEgIv+JkUeoYOISc/W13qiJnfUwvdYSEBYGWgMV6QBjxy4qGq28inlQoHrTqsEr6HuMxDTQulfrfjVZlG1uzSUmAAyzu5jIBLOT7WVdFvak/Z+tuulB3JmgKfey4VhTXMSJwgXgHmR9wfKtyBXGuzVwT7MwXx2GpbxB85NB5jdCVSyuHk+PgnL/oPujM+6+YN647SaVMtl3acQDXnvWiXgGSBawG/RwOfqv+gaJu4pAKRTsLe1GS1XEwAHyvhiyjITpmk3tVTFjub4iTz3VZovVq2nvNOLapBj24/WrJKnCawQFF3s3Tmt3o0FsDl3O1+HJ6WGxz946iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oq4xgEBXAXim7+gUnLYnR6taLJt7lkglAW3Retl8+Vs=;
 b=RFvVUWDr5QtEDFgoOLHlBJ5CWVkj/LvngIvB1gJb/DonBx1gWTLG1UZXYtATO+GqjulN68qnzqIEgmTCte0AlOk/P1cnLRh0lQZ01lxQpKfsuWr6tVILLULSXTSVtYpN/PYcR+ajwn/4nW0W7JwU6xDqSMh6BTZgZQDxj9ZVLBPI+2Zsj3NeVRw+lOl8ZEp2LK1VpdQsuUVkftF5rtJIn4uFFI8bD+QdhnCp2caeOLVFF7tbKUKtidjxHS47iNCV7D6MJbfSlWemHuR0UTrsRHDlGIdV+M2ld78IXGkApHi9SRhDN4/Y2sl1lLwYWibPGuyBP+H+claFt1Idfg7/1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oq4xgEBXAXim7+gUnLYnR6taLJt7lkglAW3Retl8+Vs=;
 b=EN7P5pNfd2VYutACtWzD2+QQ5U2lVHsSfN5rguSNks1PO1Gv1GakjksxBbeuISCrbW+4m+SvG4Ctjf4SozExACdIiGDJmS60P5vUlsd1y5EKQr6hwymDwwNjZFEn6te2Z5Rb7rDGAxFxzbfhn1p54XQVLwvQ/7TOz0hQg5RsC64=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 23:33:24 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 23:33:24 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH 6/9] KVM: SVM: Add support for static allocation of unified Page Encryption Bitmap.
Date:   Mon, 30 Nov 2020 23:33:14 +0000
Message-Id: <acc6c80aad1ed2e60f7eb35f92c589d57beb2636.1606633738.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606633738.git.ashish.kalra@amd.com>
References: <cover.1606633738.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0601CA0003.namprd06.prod.outlook.com
 (2603:10b6:803:2f::13) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0601CA0003.namprd06.prod.outlook.com (2603:10b6:803:2f::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Mon, 30 Nov 2020 23:33:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e6ea91d0-a0a8-473e-75ab-08d895885477
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45094A4D8026209B6765AA2F8EF50@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:267;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x2FE8KaiaA6ZDSKG07k5VfbKfKFDJRjFnDh+gupxgLXAPhcgx7Fkai149oonkuhCJAGGx8QNn7fFcO0xMZk4p6UktXrsr9JAq8QrfMyc82hl/1cVktzPyf+hkBKWNmskp53evfdI+ybiPG6mTQ0Szv2zGgchzycjdn2zy15hr5yGuqacq2AmkcFzFyKX45LwkDfbemxJbHnLtgwI4POpUCF9iXaBXEKQAT6yCmwpXOtJUQWx+mUZTCNzeLE55T2zyN0EncizHZZOPPZVDe2L69KtCUEsO3ycJPyz7p7G2n9ax/WEht5uxWShCWmjyXB9Oz2IB1xH275m6AqUY2NMZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(26005)(83380400001)(956004)(5660300002)(16526019)(7416002)(4326008)(86362001)(2616005)(186003)(316002)(7696005)(6916009)(2906002)(8936002)(6486002)(52116002)(8676002)(66946007)(478600001)(6666004)(66476007)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: arKRodgvCk88plhsrRH+3ov6fDQWCpDqI0nanTXhpGua1mJKvdJXMwL61zJkgMZTYhqSLdVg45wvfpDvlwLbUbyBH0skl/VjAeRo+wCu42jsHTk7aN9CpgXLcKXy3v/eREy5maBL3BIFB/ln/6wqtJS5SWW70/vTpAgq4f/HAbzT3XeTyqoL/ctMYCJ1bS/7IAstnl7xnJcxkxozDvReXBCuT98HzQOwTbKozPzprlcDA+M4C7ql0Qk4gDNwVLdjtpgeeAykXe2eX+MqOZXmOjiYMXhkJ9hCCGUxmcWlA2CV3LeSfuXXD1/fez7kZxcD/U7YTnilAz7drzIhM4UHnke1G1qI0h11uRnR+gdwlSA9o9NMd9qr/9l5ClQuHucf0NW2qI+b9IGl3J/Jp+ER2XbLQUzq0SkvIkuGB3IUA7GfVftCdBctW2tZPKa3Cv46EaPcpvEiQoZVTh4bz2dfW1MvDobz3VXMNqchSKgfZqnIfnyQ6XnFOxsxaAJlCYvCzGcVap6SUoI+zfxiOp62bjuR4oSvNOwKbYHR7YsUKyZgL/k/qJHFKI18sLFgUFAPOHsrPocqELQzwZdB+Y7Fp16Ew7YwfWzBC/Q/9CwUHT87Xlq/cGLEFmdQEVvIU5Tlc1VO8fC4TtsHuVpvWUb0Q2LSOyDAE/Gyfa+P1BmQRf5v8TEjzHJWhdpJwEWt6V+SK3Z0sqEdKxUo/g8JKtC+M2nXPyUHpTnEgYvGpcc89OtS3jQG1+EHaUpu+WuaiHaO
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ea91d0-a0a8-473e-75ab-08d895885477
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 23:33:24.2748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W40RsxBLZH+ZAt2Zycg0rMT3d/LHS/4hEL22nAZhpQsobCQyEIYp5yb6+xXLFUBm+8i4aUHHuJI4TZ+T4HhiDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add support for static allocation of the unified Page encryption bitmap by
extending kvm_arch_commit_memory_region() callack to add svm specific x86_ops
which can read the userspace provided memory region/memslots and calculate
the amount of guest RAM managed by the KVM and grow the bitmap based
on that information, i.e. the highest guest PA that is mapped by a memslot.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/sev.c          | 35 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              |  5 +++++
 5 files changed, 43 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 352ebc576036..91fc22d793e8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1282,6 +1282,7 @@ struct kvm_x86_ops {
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
+	void (*commit_memory_region)(struct kvm *kvm, enum kvm_mr_change change);
 	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
 				  unsigned long sz, unsigned long mode);
 	int (*get_page_enc_bitmap)(struct kvm *kvm,
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9fe9fba34e68..37cf12cfbde6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -957,6 +957,41 @@ static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
 	return 0;
 }
 
+void svm_commit_memory_region(struct kvm *kvm, enum kvm_mr_change change)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	gfn_t start, end = 0;
+
+	spin_lock(&kvm->mmu_lock);
+	if (change == KVM_MR_CREATE) {
+		slots = kvm_memslots(kvm);
+		kvm_for_each_memslot(memslot, slots) {
+			start = memslot->base_gfn;
+			end = memslot->base_gfn + memslot->npages;
+			/*
+			 * KVM memslots is a sorted list, starting with
+			 * the highest mapped guest PA, so pick the topmost
+			 * valid guest PA.
+			 */
+			if (memslot->npages)
+				break;
+		}
+	}
+	spin_unlock(&kvm->mmu_lock);
+
+	if (end) {
+		/*
+		 * NORE: This callback is invoked in vm ioctl
+		 * set_user_memory_region, hence we can use a
+		 * mutex here.
+		 */
+		mutex_lock(&kvm->lock);
+		sev_resize_page_enc_bitmap(kvm, end);
+		mutex_unlock(&kvm->lock);
+	}
+}
+
 int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 				  unsigned long npages, unsigned long enc)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6ebdf20773ea..7aa7858c8209 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4313,6 +4313,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.msr_filter_changed = svm_msr_filter_changed,
 
+	.commit_memory_region = svm_commit_memory_region,
 	.page_enc_status_hc = svm_page_enc_status_hc,
 	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
 	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2268c0ab650b..5a4656bad681 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -415,6 +415,7 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
                            unsigned long npages, unsigned long enc);
 int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
 int svm_set_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
+void svm_commit_memory_region(struct kvm *kvm, enum kvm_mr_change change);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3cf64a94004f..c1acbd397b50 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10717,6 +10717,11 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	/* Free the arrays associated with the old memslot. */
 	if (change == KVM_MR_MOVE)
 		kvm_arch_free_memslot(kvm, old);
+
+	if (change == KVM_MR_CREATE || change == KVM_MR_DELETE) {
+		if (kvm_x86_ops.commit_memory_region)
+			kvm_x86_ops.commit_memory_region(kvm, change);
+	}
 }
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
-- 
2.17.1

