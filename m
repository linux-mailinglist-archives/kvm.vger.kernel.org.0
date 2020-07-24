Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEA122D27F
	for <lists+kvm@lfdr.de>; Sat, 25 Jul 2020 01:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgGXXzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 19:55:21 -0400
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:27873
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726572AbgGXXzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 19:55:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eFxczMChtqx73f86qXtF8jfoG9Rl/m7vO50i5eKgOHzHCM5NviWrB8m69eZ/BWyXyvb+u+iCEK1CJuarDoJjo08kt4MQWKJtaO7BLMGpIbB3h4g81Wb86BbhUnugmyYqdPAs0sCzzNDobldWnNjriwawQ8Fd1IXFlj6cC5rjZVfsFloc+zSrk54CpMwdAqS//Ke1BjGGmtA3JfzUXk5RaKURQUnwuchMCnr8yr6YPccag9o5/gFSVuccd7BmQclt7JmUndnso2fV41LcD5DEw6MzxbwTHrMURrIZHF0Srl89aIhh4oiBUvaG5spgooMybvQlEV+8PVhAnXgnibSjzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66uLHJXRMs2XLvi5M3/HZxwFdylUcSMlTxJJSADmM9A=;
 b=D4me1RBTd/ThQZiCgs56TwMlrucmYKNC2KAv/oo96jubeY+KFVZ1mF6GnouDBuvye0u7pAYLwmmgCsCgRpgyqEYMuq4skSBT+7mTsHpkzd4UAMc47mzuFSWBtddKaWVj/kjvOA0IyuFLijHD0czH4sq5MD6OjVFvECOMB94hFbDLNG4goqYjG1HMUyjMS+K3NkPgRIvFbqJjFV+34/xKrmuPca0Q2pjj19U3KMRNA8R5E0CmSBAZX08DC94lbfSl4xu35jT5ToOP/rXADUiRla6qlrhsqlcxPAWsscL3WvCKOZIVvIYwGOceM6kVZbmRQE6zqMzJaVpQOb3EybJdOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66uLHJXRMs2XLvi5M3/HZxwFdylUcSMlTxJJSADmM9A=;
 b=YA+dDUv6ysb/mREJ3i9WH+oa50Wfo95jfXwcSm1I9PfCGuZ7C0GvtvWDPOJ23lVnS01CEHV7KDnPcFWOAdrJGOa6t7TcPfmOmuKk864XmaXvMypKqQhkaveKn6Zht6V2VGtqMwlobcF8qMjarmm4r+Pfqnm6S54PGa/yuHDVBvs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM6PR12MB2652.namprd12.prod.outlook.com (2603:10b6:5:41::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Fri, 24 Jul 2020 23:55:09 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::815c:cab8:eccc:2e48]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::815c:cab8:eccc:2e48%8]) with mapi id 15.20.3216.026; Fri, 24 Jul 2020
 23:55:09 +0000
From:   eric van tassell <Eric.VanTassell@amd.com>
To:     kvm@vger.kernel.org
Cc:     bp@alien8.de, hpa@zytor.com, mingo@redhat.com, jmattson@google.com,
        joro@8bytes.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org,
        evantass@amd.com
Subject: [Patch 2/4] KVM:SVM: Introduce set_spte_notify support
Date:   Fri, 24 Jul 2020 18:54:46 -0500
Message-Id: <20200724235448.106142-3-Eric.VanTassell@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724235448.106142-1-Eric.VanTassell@amd.com>
References: <20200724235448.106142-1-Eric.VanTassell@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR19CA0033.namprd19.prod.outlook.com
 (2603:10b6:3:9a::19) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from evt-speedway-83bc.amd.com (165.204.78.2) by DM5PR19CA0033.namprd19.prod.outlook.com (2603:10b6:3:9a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Fri, 24 Jul 2020 23:55:08 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f6f339e6-dc53-4767-0db9-08d8302cff2e
X-MS-TrafficTypeDiagnostic: DM6PR12MB2652:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB265251D940A1A260A52B41CFE7770@DM6PR12MB2652.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h6+lhBisBR3w1d84UEOYo1CKuui1dWpdZb65XVgsLjG2wSXgAgdiPWRWXtZSQGzjH+nZeYeB/FJXIkBXOGxlGluq0llQbmAsHYdLjzUcefrHVVVfRk0eeM+id5cMAcPxuB3Oos/DlXB/19/A1TaVBoXc3ICLANlm3lRF2cpB9erImjmH+uv77apkCfAZWmHlNJShhtVGcfgB52dGT8SCCclVJneU0HFJVVR5GCCOJfNNceQyq6IVq8v9nrMlpgPbMINS4PREUiPhObvJfJ8k0zcWK4vX7YQiaZO6jBURExiJwtgohQnJjHdgPZYqtjWc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(6486002)(6916009)(36756003)(8936002)(8676002)(26005)(86362001)(7416002)(7696005)(16526019)(2906002)(316002)(186003)(478600001)(52116002)(83380400001)(66476007)(66556008)(66946007)(6666004)(2616005)(956004)(1076003)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ex5SaXzbg7MpukqRwdz6HXOJR+LNC1hQHruNEufE4yglvoB/b8NckrliWFhTofA4ca5BLsHgBh1TYQJWW6Jww/zc4MyNMHcKIK8EMO1aPLJpwpF88cFVd/a5Px8sWu6U+WpjUT3kP8V57fCd7ATTty/V04+hHpEVg/BTSiNpmi1tF2IyKDmN/rXDtyuuqELRR+RUoTDKAWACzgEFGOMvFoIvnyTp4D1IMY9FUI904GRhB0l5pFI5/sA9kw3mfpjcvpO6JGd1j24xYR/Afn3Jt055AsGEvxMKONvT9mEINGEXr0bUuc2SH4ebohuRIePrdNPUZ8WdffhbnGfIG2sHEhYTl08CXzUp0h5yRFmo3YuP1J6T3XE5fZgEG4BcL3iIIQzmoC1XEVsANdz5wXsrd5lsuDoRpZI1IunpUNxaHoBh7FgiEAWNTLu7b/kWzxU5WuwkjPh3Rnl/6VjS346E9vpAC7MKru+vIJep4HMDp8Y=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6f339e6-dc53-4767-0db9-08d8302cff2e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2020 23:55:09.2746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wAzq4m0wgNExD4VLRqOkF5voMfRxvLHvI9hlRMKc8bbfOti3HNK+BegpwNnHUv7WP5sDt47alvfgoeXjue5LNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2652
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve SEV guest startup time from O(n) to a constant by deferring
guest page pinning until the pages are used to satisfy nested page faults.

Implement the code to do the pinning (sev_get_page) and the notifier
sev_set_spte_notify().

Track the pinned pages with xarray so they can be released during guest
termination.

Signed-off-by: eric van tassell <Eric.VanTassell@amd.com>
---
 arch/x86/kvm/svm/sev.c | 71 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/svm/svm.h |  3 ++
 3 files changed, 76 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f7f1f4ecf08e..040ae4aa7c5a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -184,6 +184,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	sev->asid = asid;
 	INIT_LIST_HEAD(&sev->regions_list);
 
+	xa_init(&sev->pages_xarray);
+
 	return 0;
 
 e_free:
@@ -415,6 +417,42 @@ static unsigned long get_num_contig_pages(unsigned long idx,
 	return pages;
 }
 
+static int sev_get_page(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct xarray *xa = &sev->pages_xarray;
+	struct page *page = pfn_to_page(pfn);
+	int ret;
+
+	/* store page at index = gfn */
+	ret = xa_insert(xa, gfn, page, GFP_ATOMIC);
+	if (ret == -EBUSY) {
+		/*
+		 * If xa_insert returned -EBUSY, the  gfn was already associated
+		 * with a struct page *.
+		 */
+		struct page *cur_page;
+
+		cur_page = xa_load(xa, gfn);
+		/* If cur_page == page, no change is needed, so return 0 */
+		if (cur_page == page)
+			return 0;
+
+		/* Release the page that was stored at index = gfn */
+		put_page(cur_page);
+
+		/* Return result of attempting to store page at index = gfn */
+		ret = xa_err(xa_store(xa, gfn, page, GFP_ATOMIC));
+	}
+
+	if (ret)
+		return ret;
+
+	get_page(page);
+
+	return 0;
+}
+
 static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
@@ -1085,6 +1123,8 @@ void sev_vm_destroy(struct kvm *kvm)
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct list_head *head = &sev->regions_list;
 	struct list_head *pos, *q;
+	XA_STATE(xas, &sev->pages_xarray, 0);
+	struct page *xa_page;
 
 	if (!sev_guest(kvm))
 		return;
@@ -1109,6 +1149,12 @@ void sev_vm_destroy(struct kvm *kvm)
 		}
 	}
 
+	/* Release each pinned page that SEV tracked in sev->pages_xarray. */
+	xas_for_each(&xas, xa_page, ULONG_MAX) {
+		put_page(xa_page);
+	}
+	xa_destroy(&sev->pages_xarray);
+
 	mutex_unlock(&kvm->lock);
 
 	sev_unbind_asid(kvm, sev->handle);
@@ -1193,3 +1239,28 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
+
+int sev_set_spte_notify(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn,
+			int level, bool mmio, u64 *spte)
+{
+	int rc;
+
+	if (!sev_guest(vcpu->kvm))
+		return 0;
+
+	/* MMIO page contains the unencrypted data, no need to lock this page */
+	if (mmio)
+		return 0;
+
+	rc = sev_get_page(vcpu->kvm, gfn, pfn);
+	if (rc)
+		return rc;
+
+	/*
+	 * Flush any cached lines of the page being added since "ownership" of
+	 * it will be transferred from the host to an encrypted guest.
+	 */
+	clflush_cache_range(__va(pfn << PAGE_SHIFT), page_level_size(level));
+
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 535ad311ad02..9b304c761a99 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4130,6 +4130,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.set_spte_notify = sev_set_spte_notify,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 121b198b51e9..8a5c01516c89 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -65,6 +65,7 @@ struct kvm_sev_info {
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+	struct xarray pages_xarray; /* List of PFN locked */
 };
 
 struct kvm_svm {
@@ -488,5 +489,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 int __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
+int sev_set_spte_notify(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn,
+			int level, bool mmio, u64 *spte);
 
 #endif
-- 
2.17.1

