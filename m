Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A744169D3E5
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbjBTTLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbjBTTL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:11:28 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6746D2203F;
        Mon, 20 Feb 2023 11:10:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksXqVaG6dcqy+bSUh2sWfOqFJmPxKJttm1ZQ8SF1v0vlBTBp58gfU8gPX61KFPljORHCPoWSXFYdjY8KVg1ERCdPj+0fbEKs5DssgLYRLsixzj+cMmtLa6oBYaM76bHU+bFK5JweU/qJ/WgzIaKvSftbiNe18J2aZGd0mXnjTn2ao3xSF93idSAZhFxr8bW7+gG6sr2O3j1X8VjjSlg3TLGdPJXBaa3NPqF61RQ+/pAlqybTrFmHCarXntqf2O+Qt4vfDOGp/h4SVXeMtD5n6TDkpjoz/ALW9BZXOAwYN2V95TxraQA/C3BV1USxlV+BiEVZeCQTnTcCx+ZMDl7Row==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zs2dlCK3kpBp+DHzyao4L2xJnXTs0oWXM++0nWxwyeo=;
 b=DjkN/nvcQ6xFOa5js+kbLAMEAmUpq9e2Rl2JTdHDo887Ysh8Cg0O7qcdkvk860+qsJVgbBxj3vnLUrzm7i0cDv0QzuvdYj5cY+Im2lHOEVH42SUgrUlnniEJGZ4DnORg5x2QqvcMkxr/cQZUPlQpKVx1nUwHr/gxIXjRxmNMtaQhxvlxZ3kwm0uHNhxoPurdH8mlJiN6dTJqqRDt/+5ML6dGhRSCqjDG+N7iT9u/oUoNcIu6pTZhC0S8235gjH9NdFIVdLnEfFK5M8MmLEWQUrr5ChfLaXyvtGWI3D7AIAOziW9zN6svo8bNtB0sTw5bCF6UqgBhb07Vt0J3WOYBpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zs2dlCK3kpBp+DHzyao4L2xJnXTs0oWXM++0nWxwyeo=;
 b=gcl8KJLBnJifPUe/cgPkkyaC+XdvUxI9YdFiNUpIFRrYauEmdpZu9w3h0KJNbNHi1SSJgkzJl678RY50Dz/YwEz76BwcGgEN8nh/kTQwOoqv17+Hk+YWMw3daWNpkTVj35LXDvv3RjypvxFO+kcnrWjmGqDHQRqXYh8XD901BFk=
Received: from MW4PR03CA0263.namprd03.prod.outlook.com (2603:10b6:303:b4::28)
 by SJ2PR12MB8181.namprd12.prod.outlook.com (2603:10b6:a03:4f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 19:02:48 +0000
Received: from CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::f9) by MW4PR03CA0263.outlook.office365.com
 (2603:10b6:303:b4::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 19:02:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT071.mail.protection.outlook.com (10.13.175.56) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.20 via Frontend Transport; Mon, 20 Feb 2023 19:02:47 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 13:02:46 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH RFC v8 08/56] KVM: SEV: Rename sev_{pin,unpin}_memory
Date:   Mon, 20 Feb 2023 12:37:59 -0600
Message-ID: <20230220183847.59159-9-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT071:EE_|SJ2PR12MB8181:EE_
X-MS-Office365-Filtering-Correlation-Id: 931c97d0-2a5a-4d25-f2b1-08db13750e93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LoIj0soWdNR/1b+30MySf9izMeGQlhDgtu4AgXT2YAz19Pyo8D9r4PHbnGA9VGxQhBRQWl1PGm9N6OoeyuFZUlL7fT+MC4GEq1G5NvGixjRbz8r1UajMmTAW3YulaHUZtThHuI08Cn4pmYklfoCZO46U4bf8Alxs9dBzAKEB3lZrTxw/xB51Y5kSa87//u5lwu6MwktIqLSFOZISv6nF9IcWUUaP45oQf42nHmUd4uUbw+DUlX3ZXcLjgO6vDlnv6YMd1H7ATbQDq0QVpwGlhXFmjA5bO+lGTIXoKqMO7fxMIEr+m7H6oxPPvu+0SvRK8hVmtjq46cy+VsK6IEVr+SGHPHmpn8G/zdyTN6Cns3UA5bnJzI3WKuh1jlb7EehfDQgPv9MZqiHwonTHpwJoKnbkdZwkwqvttf0BTm35lT2tG2h5Gwx/7PuZ77GqejWDlZcvuILcA+1dxf/TpO/SKwyiQjwYQqqZhvuMgQueezmdLLyL6RZoFa5ZsZlUSETnLQYq3MMoZGKPhzN6vZmMx0jxuwqg2KIuQxgOxfnx7XztW4+0EjEbSSQLg/NEy9IN+yCeU8t1oFEIYrXX5mxKXwLHyRZWYhkgWVT4ABrYJCwVi8r43PqsAjy2slspJSwjz/ZQS8eHITN+RfQ95e46Iv8/byIaXts34c8WbVKfjoe8nWqCjG89uKmXgSLn1hAZQ5jQKnXrgP3vVLX0eVLW/MevC0bXpVhFHIouONeCE6w=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199018)(40470700004)(36840700001)(46966006)(82740400003)(44832011)(81166007)(36860700001)(5660300002)(7406005)(86362001)(82310400005)(2906002)(7416002)(356005)(36756003)(478600001)(336012)(47076005)(186003)(16526019)(26005)(40480700001)(426003)(70586007)(316002)(54906003)(83380400001)(40460700003)(70206006)(8676002)(1076003)(2616005)(6916009)(6666004)(41300700001)(4326008)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 19:02:47.7235
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 931c97d0-2a5a-4d25-f2b1-08db13750e93
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8181
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nikunj A Dadhania <nikunj@amd.com>

Rename sev_{pin|unpin}_memory to sev_memory_{get|put}_pages. Apart
from pinning the pages, sev_pin_memory also populates the pages array
which is used by its callers. SEV guest using restricted memfd do not
to pin the memory but will require the pages array to be populated.
Rename the function appropriately.

No functional change intended.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 62 ++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index fad7fb34ef9e..523c78bbff3f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -383,9 +383,13 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
-static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
-				    unsigned long ulen, unsigned long *n,
-				    int write)
+/*
+ * Legacy SEV guest pin the pages and return the array populated with pinned
+ * pages.
+ */
+static struct page **sev_memory_get_pages(struct kvm *kvm, unsigned long uaddr,
+					  unsigned long ulen, unsigned long *n,
+					  int write)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	unsigned long npages, size;
@@ -446,8 +450,8 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	return ERR_PTR(ret);
 }
 
-static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
-			     unsigned long npages)
+static void sev_memory_put_pages(struct kvm *kvm, struct page **pages,
+				 unsigned long npages)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 
@@ -517,7 +521,7 @@ static int sev_launch_update_shared_gfn_handler(struct kvm *kvm,
 	vaddr_end = vaddr + size;
 
 	/* Lock the user memory. */
-	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
+	inpages = sev_memory_get_pages(kvm, vaddr, size, &npages, 1);
 	if (IS_ERR(inpages))
 		return PTR_ERR(inpages);
 
@@ -548,20 +552,20 @@ static int sev_launch_update_shared_gfn_handler(struct kvm *kvm,
 		data.address = __sme_page_pa(inpages[i]) + offset;
 		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_DATA, &data, &argp->error);
 		if (ret)
-			goto e_unpin;
+			goto e_put_pages;
 
 		size -= len;
 		next_vaddr = vaddr + len;
 	}
 
-e_unpin:
+e_put_pages:
 	/* content of memory is updated, mark pages dirty */
 	for (i = 0; i < npages; i++) {
 		set_page_dirty_lock(inpages[i]);
 		mark_page_accessed(inpages[i]);
 	}
 	/* unlock the user pages */
-	sev_unpin_memory(kvm, inpages, npages);
+	sev_memory_put_pages(kvm, inpages, npages);
 	return ret;
 }
 
@@ -1028,13 +1032,13 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		int len, s_off, d_off;
 
 		/* lock userspace source and destination page */
-		src_p = sev_pin_memory(kvm, vaddr & PAGE_MASK, PAGE_SIZE, &n, 0);
+		src_p = sev_memory_get_pages(kvm, vaddr & PAGE_MASK, PAGE_SIZE, &n, 0);
 		if (IS_ERR(src_p))
 			return PTR_ERR(src_p);
 
-		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, 1);
+		dst_p = sev_memory_get_pages(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, 1);
 		if (IS_ERR(dst_p)) {
-			sev_unpin_memory(kvm, src_p, n);
+			sev_memory_put_pages(kvm, src_p, n);
 			return PTR_ERR(dst_p);
 		}
 
@@ -1068,8 +1072,8 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 						     (void __user *)dst_vaddr,
 						     len, &argp->error);
 
-		sev_unpin_memory(kvm, src_p, n);
-		sev_unpin_memory(kvm, dst_p, n);
+		sev_memory_put_pages(kvm, src_p, n);
+		sev_memory_put_pages(kvm, dst_p, n);
 
 		if (ret)
 			goto err;
@@ -1098,7 +1102,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
 		return -EFAULT;
 
-	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, 1);
+	pages = sev_memory_get_pages(kvm, params.guest_uaddr, params.guest_len, &n, 1);
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
@@ -1114,7 +1118,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	 */
 	if (get_num_contig_pages(0, pages, n) != n) {
 		ret = -EINVAL;
-		goto e_unpin_memory;
+		goto e_put_pages;
 	}
 
 	memset(&data, 0, sizeof(data));
@@ -1126,7 +1130,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	blob = psp_copy_user_blob(params.trans_uaddr, params.trans_len);
 	if (IS_ERR(blob)) {
 		ret = PTR_ERR(blob);
-		goto e_unpin_memory;
+		goto e_put_pages;
 	}
 
 	data.trans_address = __psp_pa(blob);
@@ -1147,13 +1151,13 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 e_free_blob:
 	kfree(blob);
-e_unpin_memory:
+e_put_pages:
 	/* content of memory is updated, mark pages dirty */
 	for (i = 0; i < n; i++) {
 		set_page_dirty_lock(pages[i]);
 		mark_page_accessed(pages[i]);
 	}
-	sev_unpin_memory(kvm, pages, n);
+	sev_memory_put_pages(kvm, pages, n);
 	return ret;
 }
 
@@ -1383,8 +1387,8 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -EINVAL;
 
 	/* Pin guest memory */
-	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
-				    PAGE_SIZE, &n, 0);
+	guest_page = sev_memory_get_pages(kvm, params.guest_uaddr & PAGE_MASK,
+					  PAGE_SIZE, &n, 0);
 	if (IS_ERR(guest_page))
 		return PTR_ERR(guest_page);
 
@@ -1392,7 +1396,7 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	ret = -ENOMEM;
 	hdr = kzalloc(params.hdr_len, GFP_KERNEL_ACCOUNT);
 	if (!hdr)
-		goto e_unpin;
+		goto e_put_pages;
 
 	trans_data = kzalloc(params.trans_len, GFP_KERNEL_ACCOUNT);
 	if (!trans_data)
@@ -1431,8 +1435,8 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	kfree(trans_data);
 e_free_hdr:
 	kfree(hdr);
-e_unpin:
-	sev_unpin_memory(kvm, guest_page, n);
+e_put_pages:
+	sev_memory_put_pages(kvm, guest_page, n);
 
 	return ret;
 }
@@ -1579,8 +1583,8 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	data.trans_len = params.trans_len;
 
 	/* Pin guest memory */
-	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
-				    PAGE_SIZE, &n, 1);
+	guest_page = sev_memory_get_pages(kvm, params.guest_uaddr & PAGE_MASK,
+					  PAGE_SIZE, &n, 1);
 	if (IS_ERR(guest_page)) {
 		ret = PTR_ERR(guest_page);
 		goto e_free_trans;
@@ -1602,7 +1606,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, &data,
 				&argp->error);
 
-	sev_unpin_memory(kvm, guest_page, n);
+	sev_memory_put_pages(kvm, guest_page, n);
 
 e_free_trans:
 	kfree(trans);
@@ -2037,7 +2041,7 @@ int sev_mem_enc_register_region(struct kvm *kvm,
 		return -ENOMEM;
 
 	mutex_lock(&kvm->lock);
-	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
+	region->pages = sev_memory_get_pages(kvm, range->addr, range->size, &region->npages, 1);
 	if (IS_ERR(region->pages)) {
 		ret = PTR_ERR(region->pages);
 		mutex_unlock(&kvm->lock);
@@ -2084,7 +2088,7 @@ find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
 static void __unregister_enc_region_locked(struct kvm *kvm,
 					   struct enc_region *region)
 {
-	sev_unpin_memory(kvm, region->pages, region->npages);
+	sev_memory_put_pages(kvm, region->pages, region->npages);
 	list_del(&region->list);
 	kfree(region);
 }
-- 
2.25.1

