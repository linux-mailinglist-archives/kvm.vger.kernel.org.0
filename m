Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB745527B6
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345670AbiFTXJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347130AbiFTXIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:08:52 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2076.outbound.protection.outlook.com [40.107.100.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7AF24BC3;
        Mon, 20 Jun 2022 16:08:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ay7lcFWWTXpcuaEHJKRT5hgqY5jzNW8QdbQsCl3yVEuxUzdOILSAGuncIhSpXpRA99gttVBuR4dHH5VbdS0c6qdMdNIHIFMn92e1Wou5BTI2+jnzw0nR0Sp6aaLlvHVAghrXU9DZsbrwLdkqc8UxmrX5wChhyfmMUzf95AAc9kpJUCdNkXP5c+BnCdzuXsjo1Hyb7XR0g1PEiSdXoNWe04ZHJXlR/LUBva7+iDVe8+pI+diMsc1TB/AF0UWlp4EUBFcxFff+ZN5qP7BzvzhGaWAX4helBVMrX/JpdzeO61jyj9DMmCvKtM+CqhrcppQsxNSCWUyVtOBpZnm96rWE0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRMZ3HOdoZp8bsZg9WKNaitB9a5oUh93d6JbWV+hoo0=;
 b=EASEPg2dUTK0nMmMpCf48p5tpNrHY8elEcMUT3lC8MzHsupz7t6iR1Urovzs/QE1SfmuCGOyU3m2Q4TmjxRhFB9OOX6+O0l2Ms7TyPGLZASN8kh+pK0FDrUBFLEqrAxuCMiOYdoP7MLrctSTUW8zeyLJ2bI3T/wuRgmlPwO6vzUdXjETGeoxOZ9vxzfIyFW+XPS/mqGZDeeQSc8F+saNI5C0q19181Mq+FwcsZuRELrMR2TozN5EiaXddcI1ZmtkcXDBirTMgj4qmLTjFy6XOM460capE9JgTXQKNbWK1Skr1fQYHFK6t3iLQnyVb79tzyo2jiMmtHizwcQI/6rb8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRMZ3HOdoZp8bsZg9WKNaitB9a5oUh93d6JbWV+hoo0=;
 b=hv+Yt4NDEjkr4JkUX72OH0JV3B9taAgtFL6LGN3Sg0Ts3rAm5CqeqWXzNVJmZwirOFhJkeM/IpsTkGSgpSZWlzycF20HOTxdINP8YL6WYU581VQAKvBRpkUhbP5XMlJkWKg6tBuqVK2wQ62411XrrhToRcm1CeKMnJmq0IWzAQU=
Received: from DM5PR12CA0065.namprd12.prod.outlook.com (2603:10b6:3:103::27)
 by PH7PR12MB5594.namprd12.prod.outlook.com (2603:10b6:510:134::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 23:08:01 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::20) by DM5PR12CA0065.outlook.office365.com
 (2603:10b6:3:103::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:08:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:08:01 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:07:59 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 25/49] KVM: SVM: Disallow registering memory range from HugeTLB for SNP guest
Date:   Mon, 20 Jun 2022 23:07:50 +0000
Message-ID: <b32e0daab8af130a1bda76eb06ecd2546e8478bb.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7da90927-e7e2-4d32-0d8b-08da5311b961
X-MS-TrafficTypeDiagnostic: PH7PR12MB5594:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB5594324BB3B4A60AC40C2BE68EB09@PH7PR12MB5594.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dgHtmBIJk7ALoh7ui3/FAxCpKuG/7TOWCDGxU5acAbyAmB9bcB3oDJ5rTsZ6VUANgUNBNXgwTATueFSK66Wf7O2OtEycKSjhWBsnFXPFA6iPZSHbKirRSMyprqCBtV12FSx2n+mzFuEoUbzGTtGgJFRF5ho1ezkXHWhchrRJW0JJMqykoeCKUo5eHL0LcF4vErkwccW0L/3JXblo8asbr3a9dqohfGf12WWN9J/2jJ7Kl5NkouY+9VgzAQGZPC72Xwl2XtF+NtZII92r7eHc/K0R3F+nillHFUq1xVQ6qvJsGt3TYEkYPUl05oO3Mx6d+vEg27AVZO9ItZTSS0oEw4Q3tyAgmFub4R9mQ+62DNzsi/klwUO+cqc07NEJhb8Wmc0tZSqQVram58LNXfgkAkFWaWA/F0eOlhwt4qXLeNDS/b1mCHwgF2bHevj7mbvgEs4UKnmYG0bBQvjLqxYnAFXqNauCmOnvVNlnJaW3WmhsTHteyYp8mzDolg3cqOetwi84YuZjOh+f8VBc2Lc62SUkSQNsSl4o9/pUo0M6g1a+t/EJFg70zQZy6LJsd3RA3Kddp1vNqzBl96HiOnhgOgeLZItHiqT+Bww4TLOybuoFPMr+F1kZ2xVLUkfjukF8i7d0AoHEvDk0fOZlu9eVd7UiWlEwEBQGQp19mXRpa6Ee+QeuNNI3SXaslXiXmvoyWw8jIa2gq2Y8b9bd8VXNTtt1aHN5rWtEMzz4kBmxSQMvUMEn4yaEz5EDVlMAOmDsCTUEZW7I/g38a1DG3VrAIw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(376002)(136003)(40470700004)(36840700001)(46966006)(2616005)(40460700003)(70206006)(186003)(478600001)(336012)(8676002)(82310400005)(41300700001)(6666004)(83380400001)(316002)(4326008)(8936002)(54906003)(70586007)(40480700001)(7416002)(26005)(36756003)(47076005)(110136005)(82740400003)(16526019)(2906002)(5660300002)(7406005)(426003)(36860700001)(86362001)(81166007)(7696005)(356005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:08:01.4947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da90927-e7e2-4d32-0d8b-08da5311b961
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5594
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

While creating the VM, userspace call the KVM_MEMORY_ENCRYPT_REG_REGION
ioctl to register the memory regions for the guest. This registered
memory region is typically used as a guest RAM. Later, the guest may
issue the page state change (PSC) request that will require splitting
the large page into smaller page. If the memory is allocated from the
HugeTLB then hypervisor will not be able to split it.

Do not allow registering the memory range backed by the HugeTLB until
the hypervisor support is added to handle the case.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9e6fc7a94ed7..41b83aa6b5f4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -17,6 +17,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
+#include <linux/hugetlb.h>
 
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
@@ -2007,6 +2008,35 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
+static bool is_range_hugetlb(struct kvm *kvm, struct kvm_enc_region *range)
+{
+	struct vm_area_struct *vma;
+	u64 start, end;
+	bool ret = true;
+
+	start = range->addr;
+	end = start + range->size;
+
+	mmap_read_lock(kvm->mm);
+
+	do {
+		vma = find_vma_intersection(kvm->mm, start, end);
+		if (!vma)
+			goto unlock;
+
+		if (is_vm_hugetlb_page(vma))
+			goto unlock;
+
+		start = vma->vm_end;
+	} while (end > vma->vm_end);
+
+	ret = false;
+
+unlock:
+	mmap_read_unlock(kvm->mm);
+	return ret;
+}
+
 int sev_mem_enc_register_region(struct kvm *kvm,
 				struct kvm_enc_region *range)
 {
@@ -2024,6 +2054,13 @@ int sev_mem_enc_register_region(struct kvm *kvm,
 	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
 		return -EINVAL;
 
+	/*
+	 * SEV-SNP does not support the backing pages from the HugeTLB. Verify
+	 * that the registered memory range is not from the HugeTLB.
+	 */
+	if (sev_snp_guest(kvm) && is_range_hugetlb(kvm, range))
+		return -EINVAL;
+
 	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
 	if (!region)
 		return -ENOMEM;
-- 
2.25.1

