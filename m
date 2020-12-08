Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064972D35ED
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730854AbgLHWIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:08:47 -0500
Received: from mail-dm6nam10on2068.outbound.protection.outlook.com ([40.107.93.68]:52065
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730668AbgLHWIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:08:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ac5VNPQXC/3XV65sT8Q+mcHP9/U7yfpvUm2xG4y1orzyc2T1gNgjo+zd13liBKwW5wrj8n7QiT0ViS6V/TYBv5PpZAzngW03qF+vm7Bp0gKQrZ19q8rcKFkyfM8uQe0Pw56BYs2VA5VJoL/dKS7JRaU4YA0xbTRcVp1YH8t4AafwYSB98+EfgkvuBt9Olm7kUY1yPUJxp3CLHq9xuPadJsN+sr+KQo3I+PEWboJ0Rtyol1Scf06bq1ECoiJKh50+4T5McLGEMjiKVUsJ96g82QUqjYPPhEDXOvTJ2AC6nIFgpEl5L4Y6bhBmXtbCQOW+KYINm34OitNVzIfPQ9g4AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUad8WtavNRvjkOG6pfq/WlfOVALNJV8QAuHWl7VQHY=;
 b=C1SlrUZolPXfWGQ2+eRpoP1VF7s2mCnwJIFomTKhEMGQhfqTiQyTIShrDFDGjhHFgUonYPypeF6t9dd96YeYTmRL6wJSADbdet7VzV71TE6aAPRFhu1sUtVU+YgosxRcSsbsyjcCeADYR/drB0NBz4AIMZEulYnic+Rxj9qEomfJIjgcIBrVtVHiFyrX34sBMc/g7xY9r0fjG4SWeM8KZ0+1A06H5VSHGgW1Gtcq3cyaqYPegQL5ff5q8UJGTQ4LWnaXIwLBFOuFPfXp6wQ5bqghsh2Ok5K5uwX8fSsgAC0gaNHt2w842ptJxGRFR/Bqa1rPBV8HPYtfnEacrv1BrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUad8WtavNRvjkOG6pfq/WlfOVALNJV8QAuHWl7VQHY=;
 b=S+VxQ6c/wbQBe9s+GU3fY26yPJBpMs8KJWOLOenungVUmQXoUPWVcmjXRYORI9k+KZwFtT7dkrtJVzkPkGe83zVNFqGZzKi2LzLBDtDVco9e0ptTf1ITmRCC2Y0sQLD5uKCJ80Z6ZTSSAdeOTGmnHledidysN+b0ik6TEVdl8Yc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Tue, 8 Dec
 2020 22:07:49 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:07:49 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 12/18] KVM: SVM: Add support for static allocation of unified Page Encryption Bitmap.
Date:   Tue,  8 Dec 2020 22:07:39 +0000
Message-Id: <280944e548d7be754a36b037984633451828533b.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0147.namprd05.prod.outlook.com
 (2603:10b6:803:2c::25) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0147.namprd05.prod.outlook.com (2603:10b6:803:2c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Tue, 8 Dec 2020 22:07:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7880f250-8565-4b47-e7d6-08d89bc5b36d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44155561E5911355C7D288A98ECD0@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:565;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bEexBAWldCAFMwqgiZU37Mgv8vsWjCsssucjIIyOsxUtTjiH8kidewIFwGRIt/mrdq6uIbgZG18PnpKq3kVe1O+cew9ksYIV8VQGXPlev/LiEAxzsuUiKY2sApob5pqSsYh60beYY059sMU1mgqXuUwKC4JomZRwSnzamGsuW9wLd5TeEpAlP8TF0fYcF9H7DfjItGqfKKXXHS4gVXGSj9V3hky3uSwG0bALf0i2gzRLRgIEAt2n16qVF7HVwGCUr6k03DLA4JKKZOh75kU4vDRIp6YjYEccg8WqNKqEcl1cyOdr9MGsxJ8X7Q7+u0c3YOiAjiBOW01UtcBTRa0TOc5tzGj9RW/hbJ4VeA3zPncbQrlQORfMZ1xb+GXSfnpA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(34490700003)(83380400001)(186003)(4326008)(86362001)(6916009)(7416002)(16526019)(6486002)(5660300002)(66556008)(8676002)(8936002)(508600001)(7696005)(52116002)(66946007)(956004)(36756003)(2906002)(6666004)(26005)(66476007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?h5tywQhQdpyVJObJ2tx5D2ImLMrh9Lka2J+W92NRa38Yf2sgYpDmlwUdKGsG?=
 =?us-ascii?Q?CTaz3OjWel7NQx9NLuV7IASKNvmkM9xN2LYFykxML+Y4HpSnWAPKO1cbMdVR?=
 =?us-ascii?Q?kQyiewWDAgtcpxxToBgWd/VUBbju7Ymyu4g1IPqmCuI/dwrEJAyy1oDjrB3V?=
 =?us-ascii?Q?YkU+WR7itIPoGdX9ejNm1LJ9jbmGdTMI6g0Jfps0rjkkf9SZ1Ciq9Wtdc4VP?=
 =?us-ascii?Q?aGyvmhlPDAKJFOr+nkM5RibO3yHJcR3is28THDAfG6F3gsTKc5wSKv684dxn?=
 =?us-ascii?Q?KevCKtp5a53A2u+iVisj3cdMXZzarRCWjSI3e8dJw/FPs/kvbYGtOP+iQZhz?=
 =?us-ascii?Q?E5KOPvdS4miVTHHeO+hB9YPG0xcCZ0FxqTy0Ol1BINtcgGp5KJmZfIbGSRIp?=
 =?us-ascii?Q?82v9LHw1w4QjLzXEmOKxDBEvkG1xm0Nkh/rm/BgCMa7zrVgS/CaDuPi9s2qm?=
 =?us-ascii?Q?J3eB4QvHU08eVC72EhUd+9IOXoKrx4NuEP2wk2kTWc6r1gZgYop/ZYpIgydv?=
 =?us-ascii?Q?zCGuu5Z1krLZ1TL39cgq3uRmRzyLVo2VpglLeFQlxWJtqo1INBJWaF7Z1Y+y?=
 =?us-ascii?Q?jt3xwBOKLJY8Er83Sy0i9mBGN1PLppurxM+KPlO/C8yaArlg/qrQ0lmL+Xrf?=
 =?us-ascii?Q?r9rNByPQ5EesttKsBtUlFnhcEf8GisW5xJDWnjD96214SsrKtr7Cnrtisu1L?=
 =?us-ascii?Q?644yEFMaQlm56Bgmi3TJv5j4ufCXo0lo6bKmg6sIcE+AuniFvQf5Oyjk3q4T?=
 =?us-ascii?Q?DJmf+THh8k97uP70vP669vG1Ih3ygsNebsnS6RBhMJQOnfWk+Zk9y8kw6Ort?=
 =?us-ascii?Q?EJUjDkKFvmYIgAJOB+t0rpKcJ7jc9gSE8XXYlCxWXhNjYdG9bQ7FgW1fvl5P?=
 =?us-ascii?Q?S+WOH30uMwganzaRC6lGX5sW+YHbStFZ5Tb88RZiPRnQ3WPqoLj3Gse1nNiM?=
 =?us-ascii?Q?O5+K2A9NFmf6PkWiFg/6Mll0J8wS1V+ny0G7YHP6Q7x2F2dqyUPdGyaNvLCO?=
 =?us-ascii?Q?eNb9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:07:49.3512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 7880f250-8565-4b47-e7d6-08d89bc5b36d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vgizT2LgjS8PutTfmDHpPYlSwH/Z7SfW2v9V8B5rIwfE2/JcJ8M83Ckxdrj2Ob6wR/A+59upu8P7YkIFns/w7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add support for static allocation of the unified Page encryption bitmap by
extending kvm_arch_commit_memory_region() callack to add svm specific x86_ops
which can read the userspace provided memory region/memslots and calculate
the amount of guest RAM managed by the KVM and grow the bitmap based
on that information, i.e. the highest guest PA that is mapped by a memslot.

Earlier we used to dynamic resizing of the page encryption bitmap based on
the guest hypercall, but potentially a malicious guest can make a hypercall
which can trigger a really large memory allocation on the host side
and may eventually cause denial of service.

Hence now we don't do dynamic resizing of the page encryption bitmap as per
the hypercall and allocate it statically based on guest memory allocation
by walking through memslots and computing it's size.

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
index 6f34d0214440..b87b6225d2da 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1391,6 +1391,41 @@ static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
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

