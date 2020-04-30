Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466B81BF34A
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgD3IqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:46:07 -0400
Received: from mail-co1nam11on2078.outbound.protection.outlook.com ([40.107.220.78]:6046
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726757AbgD3IqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:46:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgCfRQcCZyC62B1ZDUjGouFlOSjQMG4ibMjfe5M0OylWJOmapxELgHsekZvZMGOICi2Cs7gL6MuzarApmJmmdrSbO4dNwlh6fjrQoUSPOCYZtD5Z7Ll9hdhqN3E9qtyt0Q5UZy4KsxapdDXs9V5KtH2Zy2vu0pdn7Z1SyFPJ2mTyGBxVaI++u9UbBIOy+tHxUrnLyeWjb9ter48G17CPf27MgcFYql6cLJUDC81TIT6ueK7Fg7m16UWOekRSAwSSOGUCSZq9JVba01bb0ZsP99Ic2w5NG+vZwqJamX/p39JfCE9TR7D38fFHHpA7rm9ZdddLSDqntQQWuK8euakAYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzwMzHX60rxpYIUI4KqsiBfs2p/n4Z3+Gd9M0tG7y7s=;
 b=icOErLzvhupaPmhCh/DwjqxbXmB2IFMuKpoGo0zAkC2cbFnzcc1VikzTWSwYpV9mgeso0oiypjx0JkE/ll6rR+3X8pLoeRL529X99u5XxUsstn5Q3GWGs3cEOBL8V/zC6g0O2UZUvS3kdf28wQkpNutQvzhdjRa0Ip+uj+W+HBZQ7xVNrVDMUKTeiWLCytHEGtU5Rr7rcxnR+ATEiIg0++iD393Ct3SeCaWHLSbu6e68pnAIa4TN3xTPWkTUqGAMA9rEvAq3Ms9Lhrkbd+2Sqj9XBNpi8FyB6rVm7M1QO8wLPWxcPpy/bTXnRCPVJRmOqu5O4T/0L9aumMYO5KfCqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzwMzHX60rxpYIUI4KqsiBfs2p/n4Z3+Gd9M0tG7y7s=;
 b=weuv39b2H2BaD4D/q1Pcn+Z5pA4v134+rN7dhJpc7EfQUkL8LWvUNbMzdmkrf/ZgTvEuw+hwt5lowHstE3AFNT5IIginr9CiP59e9VckZwj1Xc94WaVBEIn39M92A43UKjfo/aLQ069umJ53hm1CiQJuqI8Q6vsVLlRnfg2qYsg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1465.namprd12.prod.outlook.com (2603:10b6:4:7::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 08:46:04 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:46:04 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 13/18] KVM: SVM: Add support for static allocation of unified Page Encryption Bitmap.
Date:   Thu, 30 Apr 2020 08:45:54 +0000
Message-Id: <47996d4b5feb7ee8572120dc19bbc5bb9962a979.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0701CA0043.namprd07.prod.outlook.com
 (2603:10b6:803:2d::11) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0701CA0043.namprd07.prod.outlook.com (2603:10b6:803:2d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 08:46:03 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 99eddf84-8793-4fc9-5df5-08d7ece2ea83
X-MS-TrafficTypeDiagnostic: DM5PR12MB1465:|DM5PR12MB1465:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1465B8BA5657D0F3E9AFBB868EAA0@DM5PR12MB1465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:416;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(7416002)(66946007)(26005)(36756003)(86362001)(66556008)(66476007)(5660300002)(478600001)(186003)(8936002)(2906002)(8676002)(16526019)(6916009)(7696005)(956004)(2616005)(52116002)(316002)(4326008)(6666004)(6486002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t8N29pZhULQHi8Us8v0k8sA4Ob7vmhOxAmsAADVHyJyb4TsipJL73LOuJCJeVSJINAmwBKLvc11mwBrmIZOBBUWA4b0KWdKJV5VKIwnydd6ZxXVuiHHh3Ljs1cf5wRSG9ZEPRo3dTsQ3lFqvFrFc/5IEb9rhQC5kJ+blOWmJN0WNwjiEvFhgzlJqWpzVtEkFMC3ALhA/qYpXLvm/SsiW5+KirjMWAA5RRQ52lXwC/rR5hRtBNHYFWVPT02Zzkg/B91fYp0PzXb4Rlxg/71/UvEHaRwjSFjC2haAqSGwR8E9rrQIsWE77iVPIuHlfwTlsgYY7ZKoQlNbExGETevF0oofjUHs+E5sV8nwr55ffeN1a4KOzTqdlAKrlIrSZCbt2gSBxH5Z3tG/lf6t8xBBzPzht4qytG00gEJ7YPCsnislU13xfabHKpT9zV5VZQS+pj3bpvJB7UoGHptlpwxREKLqfbfO9oiiAyKlgE8hKYdlF2ryge10FlTWUq+YPl0J+
X-MS-Exchange-AntiSpam-MessageData: Fbl7PNFu6nvfph7e2P6YGsPsM24TCS7YS6bpGxi2yxpbrNIdHUH26Fnrr3p9zNKGvi4g23WC5EqcOkpjfEREQTDbHr3meCmF2E+xjoxqyuLQZwb8btqTAkVxSHbsmRRXy0yv4KQnuuL12QoGwjyQ178CEeJ5xhwYtbz73LBaol2XUW/1vn3G+5QrTtUwQI3XJZCZ6zLVlH4lDP4HfLqpIeXBLyHrv4GXzFbI2mHN4NAkMOOOKAV7jbffb7REqWs2J1Vd30bvF3zkjbVSyq5mVfTvNtLlA+uaSTcwDAEEL48aXL09xuASXlwYBtl6BbVnHA45v18ydTCermqU4uYNR40gPwX6zBxlSewR7eaPC030Gw6l9fTzVKGZjZtAlZap73aNsHlDd7ROIhVub1Fcqw4VER1vlsAShN2Ka8ZSxFIn6WFzkAlJ95vGAXQhZJKIl7eJp5WmqK0OVPWvx6ba1W/OWF5dOE0hRdO0nD+PH8FJTYuutJzVbhvmkKMjMkQMlTaRwVGNr50Pizfs6msc3BJvPIKW4Rk2O4yOXBuT3G74hlXTIo5x6tp2l+2zhpqNzw8Agp+6M3H6lthcfl7lSdy9qQc+6IqOEDIGIurz5D8pwTtvGZfDwujZDf6v7fP2AZKGvAmLLrgJ06SSIYXv69H+dlHuAOU0Xzi5xMVP02aoK5QiEFKcDz5BomvK+Q2iSstfThHkFwA2uzvxLwrtg1mcR4FExavTfYk+cq74bWOvKaNy+jqe0JgYXTzGYPBt+hPQsRdCIz9r5hOu6iKTESafigbXjDUn5q8Pp/jlbxU=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99eddf84-8793-4fc9-5df5-08d7ece2ea83
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:46:03.9345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0GK0ElkGLXg5Oier4gz+1ToA550csMnKzTL2ByPzZRYwCEHkXY1RjVr9/C9qJM90ve0mRzCm8vpLaluFc0kuVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1465
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
index 64ff51ec4933..ba5ecd1de644 100644
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

