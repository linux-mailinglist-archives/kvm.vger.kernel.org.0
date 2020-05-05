Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653571C62E2
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgEEVSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:18:51 -0400
Received: from mail-bn8nam12on2050.outbound.protection.outlook.com ([40.107.237.50]:6270
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728076AbgEEVSv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:18:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WFKQhwLGo6JL2tQXAXucmHsYdBUNDlN8QQKcwh06KDlAR2Mol5pcda2niBJghkOA1yOBy0Iax0hZI3PTqtNWnwsfFH3flFhcxxgk/ZWO4DsmiRusPVNzzwPptx9Y+WPm95Wxx0x/geNokpCAC+NnXHF0+DbZO2Cqao3nD/RVN5gUiydQQDlGST3InACD6kPjMMaN+5MRrZsNeeZQTmj6CGUSOv1c9SNAyop8P4rmIbHuPQbn6TyuBDjaRZ11/+RPDp1fe3st3hMQb3crJ5FPabeQsx9XPUwgJbN9lM9wM1Mmtgit++fQ9AC3CKdIPkVdHPM+b6306BcQQGwMKbyLkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjHp0+pzexUmP/9EFqhPehoytBsTiu+D1qHk0K2efAQ=;
 b=k2cEvWv5E03nugT+w8XcDsfuBe7q5PJml0ZS/2T8gEXREt7pmKNmHRtpdvkRYAgCBigYdeVLsZlPiSLp9rocHqS8TMSOVT7Fz+nC/4WVvHBtV9LUR0fUwKo3vEP+06tiQGIIjFKmndxD4b6xgJ3XBpUAkp+bbjnF6tEINWFTg6ONJkBFMiw7bj0GkIbIRjYQXZ675k955sdIi2L0D9AZW/jIkPAe8jQFAvkcHok3tvxNlNJ98JxRoq1GhTwvO1tWFN2MSz8ieL7FASFdBmrn6QQmIZwgYp6mc0NlgoBINAvn/yt4it4nz+6aqf7BDncR/tdOVrUqeDNA/qIldExJZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjHp0+pzexUmP/9EFqhPehoytBsTiu+D1qHk0K2efAQ=;
 b=aCi0V9hVsJ92LHcyPEs/UJru6YpAKNbZYSReomTupsOiHq+ukOP5SOEypZaKHVbml2SYxYOqUWh/nF6Kjey0SJkkkAPVrSSfHxSOrz6n8cASe/I9JoKt6gKuQJufQQcDYZ4cSQVa8nhaSbPvMQl372G3jrq9/Dkp9cPkTPN0skE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:18:47 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:18:47 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 12/18] KVM: SVM: Add support for static allocation of unified Page Encryption Bitmap.
Date:   Tue,  5 May 2020 21:18:38 +0000
Message-Id: <17c14245a404ff679253313ffe899c5f4e966717.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0089.namprd07.prod.outlook.com
 (2603:10b6:4:ae::18) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR07CA0089.namprd07.prod.outlook.com (2603:10b6:4:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Tue, 5 May 2020 21:18:46 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f798c1ec-d64a-4ca7-cf84-08d7f139e634
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB251857B208FDF78B6F139C528EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:416;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: REVf5hw2Vukos678fcJtiHXrFAAz6eFpXeE2oFK+UoKyNvNrQTiYOEyVwgnxFkoonxhMP/6S76AfsYu4WzIuEAmUwuaX4bxtjxA6Yeu5N9VS+AzF5IRKhmnXlhqIaST0UsSnup8qz/5/VLTiyBWBiMkZxzKvv4kdc2mEeCFsEl4ntm17sVVsHxq1Gqi5Tn1eWNEei7u9SVVkF1miL8/7iBf4fHCAGRa9wxfNt0swo2WzcBI2Makvv4HsBJ9hSO6meiZIeTj0JJLsvHgnkcgcI/lgboFbh/xIxp9qEAM2gjESty6qljZrifvgQQ3FchDxcyoJkmxU8chUc+ZrBLGULbeg4p2gY91TjUwTOErLCsyQ55wno+TQW2a6RTlMZ4JlbbMtcYWp5aC1rDG8QClhmQgnjIx8Pei0fp7h7V7ZtSIsSQSr7zkeH4CKp3WA/yWUAnwlC53RM5lBZBB0EAqZxnEpZgvRLPVzblF3+3LZB5RtD7bw0255OTkaNFXk1ruQY9Ul1WGGtYZQj5x0dkojQnnbE0qU68OngI0Gve8Qn5GMT7rAgLrlJ6SjsDJd8K3Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(478600001)(6486002)(2906002)(5660300002)(6666004)(2616005)(186003)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: beUI8aZ6Jqa4Z2bVYfI4RgjdQfmSapUimtX+b5OP/Xu7+GRAcDns4h3rCs3we3wwCLph2H+PsPLIxtdqJ4Jk/nqpmIWHIMM42/TJu/J+NgvL0GLa01IlnqiBVai3a79fUV4EHGvOEYlA8cohKqcSYNmEG991T6/mbCfoW7/WIPg1FpgeA6bYKdyD5zX8OEy902gkl77nrMMeTsC7VLPSUOhaP9i71bqZUgZWn5m5J+U9jCZEWq0nTrY+uxM1CdyEaCsv0z/lHw2jSDkzUcJDj27BfkMTUuQ12Rx2YZHZCrSzyWDQ4GgkXmosZqaCcEt2dKsxFu6R2zhRxYGGIQJbKuvKmZJeQtC1LM+amKw5wJuzonUgLhCYQ8jdQBTv3OoSwaXtZN5oIQW+bOYwhM54eGPD+iKSgosLHH/txui0hngSzs/1fr6Ax9t93nmshrRVolaf/Zf0DMJALiHFTEP/xrKEO3QQgZSmqAfrEPJQIkIRfHdAdcSPt6C0GdeAC92r5VD5qszDWfaAaaJ99QQ/VIkY0J/opOESeA7ZxP/bGCjRrGkO5FbI1Cp2NWgeXtgvP8wX/21ehKJlqq7G+rh+5nR1CfyUbxo+gH8EQnMe9tbgNXQYk7nivlPeu/D/35JYmAX39fWQblo4JODH96DeNIISVwMaaCwR/sU9QE/fQnHER9+3cHrjH30wZ4V5VkSQFgSmu5YWG7O3PoEXqUGTX60m1MU4pBGYTD6we0JbkV7wMI9mbOPzSh0Dz7JAb2wNeTg5eqkVst55cJfPWjWWbK6KGpJUTDjdpvf158Wa8R4=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f798c1ec-d64a-4ca7-cf84-08d7f139e634
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:18:47.5864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y48TVJIDnm5JwTNePmnk0DVe+fGkQrSrD8GOPP74qHEfXGrMx7vL5apTtkuUg8Pfw6E7B0jzdX1lqOdNyE8FnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
Sender: kvm-owner@vger.kernel.org
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
index fc74144d5ab0..b573ea85b57e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1254,6 +1254,7 @@ struct kvm_x86_ops {
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
+	void (*commit_memory_region)(struct kvm *kvm, enum kvm_mr_change change);
 	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
 				  unsigned long sz, unsigned long mode);
 	int (*get_page_enc_bitmap)(struct kvm *kvm,
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 30efc1068707..c0d7043a0627 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1377,6 +1377,41 @@ static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
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
index 501e82f5593c..442adbbb0641 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4015,6 +4015,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.check_nested_events = svm_check_nested_events,
 
+	.commit_memory_region = svm_commit_memory_region,
 	.page_enc_status_hc = svm_page_enc_status_hc,
 	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
 	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2ebdcce50312..fd99e0a5417a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -406,6 +406,7 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 				  unsigned long npages, unsigned long enc);
 int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
 int svm_set_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
+void svm_commit_memory_region(struct kvm *kvm, enum kvm_mr_change change);
 
 /* avic.c */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c4166d7a0493..8938de868d42 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10133,6 +10133,11 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		kvm_mmu_change_mmu_pages(kvm,
 				kvm_mmu_calculate_default_mmu_pages(kvm));
 
+	if (change == KVM_MR_CREATE || change == KVM_MR_DELETE) {
+		if (kvm_x86_ops.commit_memory_region)
+			kvm_x86_ops.commit_memory_region(kvm, change);
+	}
+
 	/*
 	 * Dirty logging tracks sptes in 4k granularity, meaning that large
 	 * sptes have to be split.  If live migration is successful, the guest
-- 
2.17.1

