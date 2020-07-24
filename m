Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D458622D282
	for <lists+kvm@lfdr.de>; Sat, 25 Jul 2020 01:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgGXXzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 19:55:25 -0400
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:27873
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726493AbgGXXzZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 19:55:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3sOX+mMJiMgBJ51MKdolpdtyl7tRIz67iV+5eCD40vmJ1uIascgFsHkX4u9hbrG/ud+Ls6qDcedHBWUFLxQ3m9u5DGfaL1/f0uNUgCRlWVDXtAia/eNvmNRxvTL4EuepmJ3ENPjQyy+8mDiYjrTc84LCUFRG33GMvH48V2mfUuGqEjYcYXx2Xz6R3f+m+eYivbdx6bZsUoPGWsxBZq2LMOs7Nspi87F1ZS6f8oZndfELmcP3KhvK2402psFemMcjY+OTHf4Vwm86q/yBFfvgJ0iGPKGCEypIzeouhEa9sJ/+7F05rlyMfcw3U5Kw00++GjJkqtwy0ewJPTENRlwNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pm6gQRIDXaYFoy92KwyswP2isjXpYMm/gMPGYfTeRNM=;
 b=SAbDGBrdhJFzMunI1CIQKGDVnkGFVQmIaHVjUfqL7cghy6QLevyr9VThEBHkWGVVXkQJAG7tAnwRbGKWJP/c+486SJgoJtatiXgoVrqIjtasQkEq55g1HHe/0DEtIasXc4aDmr/oIydSjFnAIEu7uRj+KGa2ilQHF80AwKB2c26UPCzw5aUtvg4Ltlf8XYRmZ03YJnfFoHCbVdHUaXDWfFazZmz1nYPdzIp5wbmj8LpVylO5doh8w2yotIVu7IiLKMj9nrt8dashLbjTICu+eWJsDZub/+Jx4jh6xxGBCwtDlfFfDKseK6KuKxZv4M+Ej8TumGLU5GNa///LNQcGFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pm6gQRIDXaYFoy92KwyswP2isjXpYMm/gMPGYfTeRNM=;
 b=TA22sGcRAZo+JQyIEqaNKX5ZKnR2lGvpj4USxbcoNt4JO7Mh0yL0qn/WAGGVH8wzf0SPqnzBqfBF5I9JdCr6zqt6wMG2gOLfRGt5IZxRT9sps9LXmra54Qj4sNPLuWV4s1jB0gIj1F2VdXHodsn98WTpUQEXuoWEqamFgumm494=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM6PR12MB2652.namprd12.prod.outlook.com (2603:10b6:5:41::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Fri, 24 Jul 2020 23:55:11 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::815c:cab8:eccc:2e48]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::815c:cab8:eccc:2e48%8]) with mapi id 15.20.3216.026; Fri, 24 Jul 2020
 23:55:11 +0000
From:   eric van tassell <Eric.VanTassell@amd.com>
To:     kvm@vger.kernel.org
Cc:     bp@alien8.de, hpa@zytor.com, mingo@redhat.com, jmattson@google.com,
        joro@8bytes.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org,
        evantass@amd.com
Subject: [Patch 4/4] KVM:SVM: Remove struct enc_region and associated pinned page tracking.
Date:   Fri, 24 Jul 2020 18:54:48 -0500
Message-Id: <20200724235448.106142-5-Eric.VanTassell@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724235448.106142-1-Eric.VanTassell@amd.com>
References: <20200724235448.106142-1-Eric.VanTassell@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR19CA0033.namprd19.prod.outlook.com
 (2603:10b6:3:9a::19) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from evt-speedway-83bc.amd.com (165.204.78.2) by DM5PR19CA0033.namprd19.prod.outlook.com (2603:10b6:3:9a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Fri, 24 Jul 2020 23:55:10 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1e0ae8ec-9e2b-4a9d-0b2b-08d8302d004a
X-MS-TrafficTypeDiagnostic: DM6PR12MB2652:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB26527874710066671A9BD480E7770@DM6PR12MB2652.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gUEbr3xhXxzt21cMSMmFY9LoxVGdS0Tg6IfVt+f21nuIN3dJ4CbnYJgKyK46A1Vfbp+d/ivxJD+tvQ3SxuqONnzSRHjQ/vRjrW6EGT1YJ7ebiGlN7qbQn0DSgjvxrpzfx71Jh6PWHJwCJqzt62MC6LR0ctJEcCWbRQZ5M+f1IwpgB1oSR6b1eL7gzKBfVNQqHJXtXrWbmatcKr0KO7qVOEAeFXJBEFToDwjparUdSDtIP2vcHgk7fzq4CEkNfjxSg9OaSq0vm2jjJhuC5HNLSbf16vDQV1ZVVQOzoSygIzoFSoPQo0VzOECYsTpr0Jd839WDdnUXeZkCAj+1/G4a6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(6486002)(6916009)(36756003)(8936002)(8676002)(26005)(86362001)(7416002)(7696005)(16526019)(2906002)(316002)(186003)(478600001)(52116002)(83380400001)(66476007)(66556008)(66946007)(6666004)(2616005)(956004)(1076003)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IdZIYVidEBHm/n3y1ds9GMAa0CPADK/sknRweoGQnXTEB94fxKbBLJYBJ3bkIumkrOJJznz9jDIFQlyQYrVqlfR0Ej8MLzkt5nDPUqDlEYXMuX2wF4sNiPKp/6sqW6UeMADycMJH0akK88Kj0O6BudTgLjDEdL5OUwVOg/uOKNFMHBt+57QxhaM3kdGtmp1pJXqCBnMii5BgWnKgZyG+OVaz/+r8OyimesviRGZ6N3zIL7Zz99+jx96ZRTvPL8YmBmhDNC+dBkDTPD+aSkW7I/Xt1I+Jq2K24L/15zVPkk8awfKXChKjgjza02D+SXxUssz8ecLeluX/8P1EeNmLR1Wm7U4myDu0rlo1U1ERIyWzYXr8devLCmzwuj173DC8EtoPCwnBFszFEhKYdEuwRXdh5Pcvl770gh7meilQoLbAgwWvpXOz6+Jywon5yiJqWO4beYHsvgSZ5lZPGXWHY56KirL8iBMBKJJZPxoyOP0=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e0ae8ec-9e2b-4a9d-0b2b-08d8302d004a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2020 23:55:11.1408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ae7ZySBM8rOFUJRx+9YKULoXdvkYtJGAgld6tG9hga/OLzevSNG/clxqrW2Ctv544T9uQkHrwKdhVPgK2FZ8Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2652
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

Signed-off-by: eric van tassell <Eric.VanTassell@amd.com>
---
 arch/x86/kvm/svm/sev.c | 117 +----------------------------------------
 arch/x86/kvm/svm/svm.h |   1 -
 2 files changed, 1 insertion(+), 117 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e0eed9a20a51..7ca5d043d908 100644
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
 
@@ -1064,113 +1055,18 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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
 
@@ -1186,17 +1082,6 @@ void sev_vm_destroy(struct kvm *kvm)
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
index 8a5c01516c89..ed6311768030 100644
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

