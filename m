Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A54F24A2AA
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 17:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgHSPSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 11:18:51 -0400
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:43520
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726899AbgHSPSG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 11:18:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c98hZ5t/E0/7Ty2ow6uPCljrFqsD1iDN+MzkAQ+/FsqND+MZIdvuOeZA60G8eNSaBB1qRnIPbooZ1I7PawvASpI2AgUJ7HSDNe/47gJ2u7TIyxa1jw/JxEFY7rSz6A8c00kmP4q+b6MeyYvd0tojvAgUADDrN4tD8yyS21nmhqDB637zdOkxterwLJAltGMg+UkIcx7gFUw9lawIPW93xkhLFfZsShKnPWSpmd0ru7lqFxpj943H25+oVqCHpxDXgt31Dc6O14dyBbe6JUlZRib6O9tdMS3PITEIyKwn3UAl26m01RneU+2PTZ4stXvzrZqFzHt8EkJLaMni4JVXLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rru6mtAXlN5E8gXsyipj4kkroTm6SYVGUkafE46L2y8=;
 b=WW+jQrhZjwkG2nHIeAWZrQ344bsIWZnuYQWScic4jIrdt6Uu2EEeSBELqtR6ovBDOzZFuc1Tqz1K5131OPpsP8WKvr0LHwghxc84R3oBR27n3Wh6gFRL630EY/5zEO+722AvkXXLK45LUPeDB62C37IWFbITZrWFeF4tc/pknSj96EjEZaBnHAR4Jtnfly+OtjZ5GTm+3Phc/OQqtsfEj9TngguOmL+4Vh02A5E2ekpYjjMd7PySZemfTBXLgBtj50poVg9Fwvd1tOrk6Hf2Gi+2/pSTcv4xc1b9/aEUx3kNQ/Xkxi/vFKzdm3kR9RCVxiS/1vgoANzgKm/h004mLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rru6mtAXlN5E8gXsyipj4kkroTm6SYVGUkafE46L2y8=;
 b=hKpJhA2cVT80aZLe/JPxY6n+LS1wmAiR2ebsL+afhTkgDwLpY4Ts72g4vmJ3eeYePI/Z+yhOMCrGC/7sFtpcE4bV/xKRfHyFi67p3DZPbvvRM9khaSYe5d61kmlDTLesPQNxF2UyUi32RONydyadxJPaBKNsWJX6BZ0fP9rHdDU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM6PR12MB3227.namprd12.prod.outlook.com (2603:10b6:5:18d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.24; Wed, 19 Aug 2020 15:17:01 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162%11]) with mapi id 15.20.3283.028; Wed, 19 Aug
 2020 15:17:01 +0000
From:   eric van tassell <Eric.VanTassell@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bp@alien8.de, hpa@zytor.com,
        mingo@redhat.com, jmattson@google.com, joro@8bytes.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org, rientjes@google.com, junaids@google.com,
        evantass@amd.com
Subject: [Patch v2 4/4] KVM:SVM: Remove struct enc_region and associated pinned page tracking.
Date:   Wed, 19 Aug 2020 10:17:42 -0500
Message-Id: <20200819151742.7892-5-Eric.VanTassell@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200819151742.7892-1-Eric.VanTassell@amd.com>
References: <20200819151742.7892-1-Eric.VanTassell@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR19CA0045.namprd19.prod.outlook.com
 (2603:10b6:3:9a::31) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from evt-speedway-83bc.amd.com (165.204.78.2) by DM5PR19CA0045.namprd19.prod.outlook.com (2603:10b6:3:9a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 15:17:00 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0fa65ef9-2ee5-4f31-08d4-08d84452ec36
X-MS-TrafficTypeDiagnostic: DM6PR12MB3227:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3227D3A455C3C2420847BDFBE75D0@DM6PR12MB3227.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Po+u5wpRRRHZQv4NTKs/khatu4hjcRFF683QnsERsGBw5XX+2+aeT69ooqRsuiC/Nkmvsu6J2JMI6WgJRv66eGwhx2CVbQNVBfkGWSus3r6QFDOPjCjSpbH2g7QI/YPhyJkIUALrR3ejRefaz1Z4POpJg4XgpJWxDvd1c88fY/kXjIMpWfozdc6sRChMssR7e7Fu5zjoXdK4MRXf6oTpwG8kOmK0bR7evlhjxxUbafwvh4VR6JB8nBuTJh4WRhG17CFM+qGNaalIiXtNht3WucK/rGrJFsn6VlopcGWhd/HssCm0dDfDBS0V3GOpvhhxF8saA8j46oYfbjXdoyXOiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(66556008)(66476007)(8676002)(66946007)(26005)(86362001)(1076003)(5660300002)(478600001)(6486002)(36756003)(316002)(83380400001)(6666004)(7416002)(2906002)(8936002)(6916009)(4326008)(2616005)(7696005)(16526019)(52116002)(186003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sCaN32J7itaeTySZkdVZXuD/v82Uq2nlIRuwQu6kvELKAr5xGmshp4JjxZOonuWhpr3oSK6mIDOgavZ52fO7KvSVbPQ1LKr8+1U4IHmkmnjT8OELTlyuMYoPfExhQIh+UZFpRq7V2u58JjU3g5izlBr4pkMDY24bf2/lPAvc41+F4dVGng0eXY4WfML7HyE+hEHI01q76PD+NpTsdADQsyG8Vt+KL2Vk/Ch5y2NGvT7NieXGJFRQ1UtUKYPnnOOlWPz09PrBFRvSA0Bimo3d6vr4qbppRayFUenGSuRl4LxtqnwKKvjFHuikDQ9WsnA7PTrag3nx/x1a6Q9dMVjPEKJwaRXfkOOvW6vc+YhXQuvnG3Sr1yyXSy38H6fNGzJzzEfHYaxGLONP2iCNnKRzeNWHekV43tO0w3udjAE5efwDIWlm2N65XZF8wki0IWZw3Kqt7zgAd8Hxc8duOwYQs5zm8KSsCuTswmfLqNIn0RxLN/rAcoLha+gRS5c9ldLV81qkYpUjV5jy8A7hp2tb5ePiIOZMJeCYTRsD5BeoUPn7C8JXjuaBVDgBYs/LTBkawLVjHiYIx73nL95Mwq9SDXqgn/8U5nFCZsl8ojj9z99/ZiY6Zf74Pi6nHKIL/wi9D0jSTSTAR78Wlb+/WhEYoA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fa65ef9-2ee5-4f31-08d4-08d84452ec36
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 15:17:01.7774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a7oGajuq7FdJ1aAGUMZuN6NwZ1+orhESBNSJPNTZrxognrLyzriRGD8i7mGQ4/Vxf5IX+zrE4PLQD4zoYvEqPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3227
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the enc_region structure definition and the code which maintained
it, as they are no longer needed in view of the xarray support we added in
the previous patch.

Leave svm_register_enc_region() and svm_unregister_enc_region() as stubs
since the ioctl is used by qemu and qemu will crash if they do not
return 0.

Co-developed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: eric van tassell <Eric.VanTassell@amd.com>
---
 arch/x86/kvm/svm/sev.c | 117 +----------------------------------------
 arch/x86/kvm/svm/svm.h |   1 -
 2 files changed, 1 insertion(+), 117 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4a0157254fef..635e15f01edb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -27,14 +27,6 @@ static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
-struct enc_region {
-	struct list_head list;
-	unsigned long npages;
-	struct page **pages;
-	unsigned long uaddr;
-	unsigned long size;
-};
-
 static int sev_flush_asids(void)
 {
 	int ret, error = 0;
@@ -182,7 +174,6 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	sev->active = true;
 	sev->asid = asid;
-	INIT_LIST_HEAD(&sev->regions_list);
 
 	xa_init(&sev->pages_xarray);
 
@@ -1074,113 +1065,18 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 int svm_register_enc_region(struct kvm *kvm,
 			    struct kvm_enc_region *range)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct enc_region *region;
-	int ret = 0;
-
-	if (!sev_guest(kvm))
-		return -ENOTTY;
-
-	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
-		return -EINVAL;
-
-	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
-	if (!region)
-		return -ENOMEM;
-
-	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
-	if (IS_ERR(region->pages)) {
-		ret = PTR_ERR(region->pages);
-		goto e_free;
-	}
-
-	/*
-	 * The guest may change the memory encryption attribute from C=0 -> C=1
-	 * or vice versa for this memory range. Lets make sure caches are
-	 * flushed to ensure that guest data gets written into memory with
-	 * correct C-bit.
-	 */
-	sev_clflush_pages(region->pages, region->npages);
-
-	region->uaddr = range->addr;
-	region->size = range->size;
-
-	mutex_lock(&kvm->lock);
-	list_add_tail(&region->list, &sev->regions_list);
-	mutex_unlock(&kvm->lock);
-
-	return ret;
-
-e_free:
-	kfree(region);
-	return ret;
-}
-
-static struct enc_region *
-find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
-{
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct list_head *head = &sev->regions_list;
-	struct enc_region *i;
-
-	list_for_each_entry(i, head, list) {
-		if (i->uaddr == range->addr &&
-		    i->size == range->size)
-			return i;
-	}
-
-	return NULL;
-}
-
-static void __unregister_enc_region_locked(struct kvm *kvm,
-					   struct enc_region *region)
-{
-	sev_unpin_memory(kvm, region->pages, region->npages);
-	list_del(&region->list);
-	kfree(region);
+	return 0;
 }
 
 int svm_unregister_enc_region(struct kvm *kvm,
 			      struct kvm_enc_region *range)
 {
-	struct enc_region *region;
-	int ret;
-
-	mutex_lock(&kvm->lock);
-
-	if (!sev_guest(kvm)) {
-		ret = -ENOTTY;
-		goto failed;
-	}
-
-	region = find_enc_region(kvm, range);
-	if (!region) {
-		ret = -EINVAL;
-		goto failed;
-	}
-
-	/*
-	 * Ensure that all guest tagged cache entries are flushed before
-	 * releasing the pages back to the system for use. CLFLUSH will
-	 * not do this, so issue a WBINVD.
-	 */
-	wbinvd_on_all_cpus();
-
-	__unregister_enc_region_locked(kvm, region);
-
-	mutex_unlock(&kvm->lock);
 	return 0;
-
-failed:
-	mutex_unlock(&kvm->lock);
-	return ret;
 }
 
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct list_head *head = &sev->regions_list;
-	struct list_head *pos, *q;
 	XA_STATE(xas, &sev->pages_xarray, 0);
 	struct page *xa_page;
 
@@ -1196,17 +1092,6 @@ void sev_vm_destroy(struct kvm *kvm)
 	 */
 	wbinvd_on_all_cpus();
 
-	/*
-	 * if userspace was terminated before unregistering the memory regions
-	 * then lets unpin all the registered memory.
-	 */
-	if (!list_empty(head)) {
-		list_for_each_safe(pos, q, head) {
-			__unregister_enc_region_locked(kvm,
-				list_entry(pos, struct enc_region, list));
-		}
-	}
-
 	/* Release each pinned page that SEV tracked in sev->pages_xarray. */
 	xas_for_each(&xas, xa_page, ULONG_MAX) {
 		put_page(xa_page);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 278c46bc52aa..98d3d7b299cb 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -64,7 +64,6 @@ struct kvm_sev_info {
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
-	struct list_head regions_list;  /* List of registered regions */
 	struct xarray pages_xarray; /* List of PFN locked */
 };
 
-- 
2.17.1

