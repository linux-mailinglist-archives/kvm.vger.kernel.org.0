Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590A75527C6
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346694AbiFTXJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347522AbiFTXJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:09:07 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D9D220DC;
        Mon, 20 Jun 2022 16:08:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AH0RNtbF5W8UZLMVQwC3DP9j+/fPhVAU22GbXYNoXkQIFwoRoBa/6CZbx2cNjLGdaY+56IkpvaOAFncAvbMiBhsTNsNImCO7d0Gu3lQfXsbs6yfWSfB5lHoLbxzBgvX9nD4XIPOIFsc8+wkMYlW8f4JakjwQl3+iT0wVBLF+wFGGHu5e69U7PFwcrHeoS9nPN/AYXgQhaFyuZpakEF0RccNyJKJZDOVxaDZ607uwpGGZ2hFUQIOK3WLwR0BIpRY+HnXKlLcvZclxeM3Asdf4r+CsnQvXIzs4N15dhVSERpDyfO2Dyl8sfoOCE+QY7/qANPQgXWCA7yMxeRhUxJxDcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H+oYMireA9QI91ofC6K7xSJOx1TFGeE4Gv/InEOiFyE=;
 b=DJbe/ZIAEPzjXa+cd5YKHCSfXluZ6LbHENC3zQ32KsbPlmXDeifxu9CP0vMCh5/pY/919mjFwAl0xP7UCjg9PqBBSlX5jDJS4B7VKyfAQBucwINC8ptwVD/moGeCbhEfbAp2QJDdBZODntJPtOWD/u9d/NdcQnZZgLvGu3VA5QPEpha93MZDKY6SbJ4YbvGwsacMPh6Wc9S7WBeum/2X7WdwD8KuUKZGyNH6UkHhE5uUHm0NZPra+LrKZFvGAvHKfzNdwyRXH1rTTm8bJBPRDlp4MZGU8GiwEQ0uEsPXKNsJQaT0ei1CEHkSEelpEgkKRVznEhst2lBWxUvb7AXVYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+oYMireA9QI91ofC6K7xSJOx1TFGeE4Gv/InEOiFyE=;
 b=SrYUSpQ9xiY45c89MN1BQfXCaQLZ4ASTTPvI0l/yRAo9TFtLurZxnBGhGXoUzYBU9T/3Bvx1Bt/zz6RNcTmFvaO5pywfIWLsF4vxoU62jZoaRTGjRYp5bzHj4UNRWP29Nq7R//+7szQAbkl3mXYc0K0yxTv4bbsMEQS5onA48+Q=
Received: from DM5PR22CA0013.namprd22.prod.outlook.com (2603:10b6:3:101::23)
 by DS7PR12MB5909.namprd12.prod.outlook.com (2603:10b6:8:7a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 23:08:33 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:101:cafe::9f) by DM5PR22CA0013.outlook.office365.com
 (2603:10b6:3:101::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22 via Frontend
 Transport; Mon, 20 Jun 2022 23:08:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:08:33 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:08:30 -0500
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
Subject: [PATCH Part2 v6 27/49] KVM: SVM: Mark the private vma unmerable for SEV-SNP guests
Date:   Mon, 20 Jun 2022 23:08:22 +0000
Message-ID: <bb10f0a4c5eb13a5338f77ef34f08f1190d4ae30.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: f7f3ec63-4cf7-43b1-a9dc-08da5311cc52
X-MS-TrafficTypeDiagnostic: DS7PR12MB5909:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB5909AF9CAC67C6310EEB410E8EB09@DS7PR12MB5909.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1+t0By4GHFwdoPeYBJxiXSk170uhFT3f44xCklVSjwVyT3rkjH6d/OM4BmcQJy+Kgq1P5ZVqubhSEqBlJGve7NU5WJxs7svtEiyksK0MgT3TZNbn473sqWrBEmAho6CqoKqE6lGtBYW/3r18uA9EVYAvPZe2HKiVGZJIoodBNtmmrWwf3M5jHALd6ZBPJy65QK/ChTsDYccq3vFWTe+tfYdBI3uoG9lKQ5YG6NyE5e9rnXx++jX0l9+4qgBG2je6OhS8hvreLVbivqK4mJ8gkCdoob8nprldV8MgmG+Q6oSWkc5p5LS4h9PvnfY+DhUejojwTBTrJbSYXtJdF6Hic7xytK09P8kT8PGeRCslqPMesJ4ojPgPHAjjr/CNUhHLVFkda++pqJiOyj6a9C4yR57VXpcBmbzUuXbcQQ533ogkziBUMhre0CH9U/9MWLHAMZBA4Dx/RqvO1yl2NLEx+Jkla26jpRPVQpZXBakAOoJ27o4IaOdJg0A2KnrmIQWrjkryd4bT0KF6ZdIP24BCJOH9/sqaCDyecxQjS0v0rrIh9NJwwUrqgvrqHtIUO8q+RPzob3SsdPkdcQ+p4jZQSce/47s49P14L41O/sar+Zt6q9CcmKHMyLpT2XQi9cygWf26aBpi6WjGih280sVNu0tJbcLPY7OUay1Kpqlaww/jkcNrpCtDg1MeJVByzTvBsRq7X4TSiHGIAW7rUUaVDhKtG0scB29zdxK8TTCPdWEjuNUQ7VGFuCbyMtAwRbRCfPqydC45j5yJ+8jc+AGeFQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(136003)(39860400002)(36840700001)(46966006)(40470700004)(16526019)(47076005)(40480700001)(70206006)(86362001)(7696005)(83380400001)(70586007)(26005)(40460700003)(82740400003)(110136005)(316002)(356005)(4326008)(81166007)(6666004)(54906003)(426003)(7416002)(2906002)(82310400005)(336012)(36860700001)(186003)(8936002)(478600001)(7406005)(8676002)(2616005)(36756003)(41300700001)(5660300002)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:08:33.2771
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7f3ec63-4cf7-43b1-a9dc-08da5311cc52
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5909
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

When SEV-SNP is enabled, the guest private pages are added in the RMP
table; while adding the pages, the rmp_make_private() unmaps the pages
from the direct map. If KSM attempts to access those unmapped pages then
it will trigger #PF (page-not-present).

Encrypted guest pages cannot be shared between the process, so an
userspace should not mark the region mergeable but to be safe, mark the
process vma unmerable before adding the pages in the RMP table.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b5f0707d7ed6..a9461d352eda 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -19,11 +19,13 @@
 #include <linux/trace_events.h>
 #include <linux/hugetlb.h>
 #include <linux/sev.h>
+#include <linux/ksm.h>
 
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
 #include <asm/sev.h>
+#include <asm/mman.h>
 
 #include "x86.h"
 #include "svm.h"
@@ -1965,6 +1967,30 @@ static bool is_hva_registered(struct kvm *kvm, hva_t hva, size_t len)
 	return false;
 }
 
+static int snp_mark_unmergable(struct kvm *kvm, u64 start, u64 size)
+{
+	struct vm_area_struct *vma;
+	u64 end = start + size;
+	int ret;
+
+	do {
+		vma = find_vma_intersection(kvm->mm, start, end);
+		if (!vma) {
+			ret = -EINVAL;
+			break;
+		}
+
+		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
+				  MADV_UNMERGEABLE, &vma->vm_flags);
+		if (ret)
+			break;
+
+		start = vma->vm_end;
+	} while (end > vma->vm_end);
+
+	return ret;
+}
+
 static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -1989,6 +2015,12 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (!is_hva_registered(kvm, params.uaddr, params.len))
 		return -EINVAL;
 
+	mmap_write_lock(kvm->mm);
+	ret = snp_mark_unmergable(kvm, params.uaddr, params.len);
+	mmap_write_unlock(kvm->mm);
+	if (ret)
+		return -EFAULT;
+
 	/*
 	 * The userspace memory is already locked so technically we don't
 	 * need to lock it again. Later part of the function needs to know
-- 
2.25.1

