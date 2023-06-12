Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5DD72B6C4
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbjFLEmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbjFLElh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:41:37 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9FF1724;
        Sun, 11 Jun 2023 21:41:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U681qMlhTPyX4zBte/1J08WgQdSXtpNRC8GHMG0lZwz6PaTHoR/NtPZddqCxvIKkJNbinV3auUC43G78ahxCQlVAzO4/LaB+MN/JutX4tTrpGoZARZ85v/SlxBMZl0XGGNDzoLqFi+ifT1D7yyqxfaCuF6QJtZlFamF7KG4Gkw+2wtRnh/38Ns3GhRPzX9VIytaxs04PcSOtWQWvz6OGKhiz2oVL7+h1PsFV8onvNjZhL/KnXMAwmG/mO3f8wbsN3cEpqX2dIuqn6oLVrQLbTEcEhGD6/QMDSW8+EB2Xkp4wqyW+1zXHlgNZhirHOegB0fWF6A0B6Nr+OkHr7YqIhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=28cE1nFtQUfuCs5Hi5DEX8uBfUlxeTHiFFKicSfKOZU=;
 b=TDBUsMiWw0LylSoax6yvRNF1u01EEn+zzdc/m5xR3B8uYHl9U+zBn0I/dUGy/mvxpffJjWx2x9h7BHgf5HdruSoNDP9KgDAUG1mKwFvcoVcMe/Uui1Pdkw/Ym3jKZeMiQku3yJwFdBkUROBDsCnb2dCMkZJHMML4UyynAynRTf9P+26RJCzuvTpS4uUIQnY9g1KCADh3o4HVjTfNrJyuvT6vJzFoAoCPmgqJhIXb3tr6gxs5Z1ntL34lgTE1TjX/5lv+GNdGUeLTywcqevh95zEIz9Xn2SKI+wxqJurANE1AEw0auOlNzWwjnNIkQ/7jS/4Q+v3GmPhYoT2J9TGTYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=28cE1nFtQUfuCs5Hi5DEX8uBfUlxeTHiFFKicSfKOZU=;
 b=P47QNxkfRU0oZJ6vNm7Wqx/m0Iu0Vsyv44k5mZOB4QiIDM6s+zu/0iVzPQIIBKAsTtkl08BMIk6V9Yaypy6ZwLoEzI1hX1KlKU63rUZuVqLv76eEoZW9aDKZmespl+2ZAIiI94DpLqCSiM93fLyWvUTP69ARxK3ATUAPGmlca+I=
Received: from MW4PR04CA0233.namprd04.prod.outlook.com (2603:10b6:303:87::28)
 by LV2PR12MB5752.namprd12.prod.outlook.com (2603:10b6:408:14d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 04:40:59 +0000
Received: from CO1PEPF000042A7.namprd03.prod.outlook.com
 (2603:10b6:303:87:cafe::4) by MW4PR04CA0233.outlook.office365.com
 (2603:10b6:303:87::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:40:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042A7.mail.protection.outlook.com (10.167.243.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:40:58 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:40:53 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH RFC v9 31/51] KVM: Split out memory attribute xarray updates to helper function
Date:   Sun, 11 Jun 2023 23:25:39 -0500
Message-ID: <20230612042559.375660-32-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A7:EE_|LV2PR12MB5752:EE_
X-MS-Office365-Filtering-Correlation-Id: 3062944b-838f-4225-c420-08db6aff37b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8k/qp+GwPlSpluzG5rMPQ0v1hvJXRBpRDZBx2Tg5D6MifWTeMcZ2SR3HqrxFSkvLXRA26DJNPHvCbQVwBrBLCGRn50F2N4qLClJA+r286oKWvPnDSXf0tTBXGCA9SUJUu6x97S3xD1CQ+KgRqws2Iu1tdDbZKysOt1tJ9OmsdXf1CUzqKuQLEZgTS95Z4NcblhCPFp3XhxdZyOyblNzTDB9XjEPBJheG7KohvRJhDBrShthEjDDPS8shnIpUpIQ2uYZ3ZhL5d3nPdb3RIF2j9Lvpp3ce7kILcpC48wig6kYAAK2c4H/GH03bnY3r12RXvBJxSPh5coprTwgb5kHZthirdLs85xPW5TNMvZReDmdDedLZsVfKFcNXSRK2XR/5KlUBSEpKZfZ3OKGPAIMUR2XGgyi+SIW5IEgH3cCbfvMYg5OLX9bjM/aEGJ0WgV7X6dLLzovqs6OWhqsYxmwTVKSb4xP9JWKAIXu7UyHpbe1l/ZCDqFp2Gfkp3SFgATcLpIl2vc+9ElnO1n77XQzZotqnQ+MeTSdaV3c0RBPblp8RGVpXuk8XEuGiLkkuCS53C4kfyr0jUkW1BG5zkIgi+hvAPZU1WgND++KqPZthR9dV1PzTLavAqFYoBkrNGxJiFzQAbJF6fK4rzlyjXxMjeH6ahpaQCrL+fQ7pwheAI0tY9UFOCsRySCXCuReBVfHGeMIAf3KAa4OCycgPVGRLTJRFmnaYDx4pCamG+taXZ2Et7pub069/Grv694eiVYgrmgSKJV6jehH+r7BrsWIu2g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199021)(46966006)(40470700004)(36840700001)(6916009)(4326008)(44832011)(316002)(7406005)(7416002)(70586007)(15650500001)(41300700001)(70206006)(186003)(16526019)(2906002)(54906003)(478600001)(8676002)(8936002)(5660300002)(6666004)(40460700003)(1076003)(82740400003)(356005)(81166007)(40480700001)(36860700001)(26005)(83380400001)(426003)(336012)(47076005)(36756003)(86362001)(82310400005)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:40:58.5776
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3062944b-838f-4225-c420-08db6aff37b9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042A7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5752
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be useful to other callers that need to update memory
attributes for things like setting up the initial private memory payload
for a guest.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 26 ++++++++++++++++++--------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9a9d4141ba74..56055692cdfa 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -991,6 +991,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module);
 void kvm_exit(void);
 
 void kvm_get_kvm(struct kvm *kvm);
+int kvm_vm_set_region_attr(struct kvm *kvm, gfn_t start, gfn_t end, u64 attributes);
 bool kvm_get_kvm_safe(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
 bool file_is_kvm(struct file *file);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 48beffca6b67..0c0a75affab6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2466,12 +2466,28 @@ static void kvm_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
 		kvm_flush_remote_tlbs(kvm);
 }
 
+int kvm_vm_set_region_attr(struct kvm *kvm, gfn_t start, gfn_t end,
+			   u64 attributes)
+{
+	gfn_t index;
+	void *entry;
+
+	entry = attributes ? xa_mk_value(attributes) : NULL;
+
+	for (index = start; index < end; index++)
+		if (xa_err(xa_store(&kvm->mem_attr_array, index, entry,
+				    GFP_KERNEL_ACCOUNT)))
+			break;
+
+	return index;
+}
+EXPORT_SYMBOL_GPL(kvm_vm_set_region_attr);
+
 static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 					   struct kvm_memory_attributes *attrs)
 {
 	gfn_t start, end;
 	unsigned long i;
-	void *entry;
 
 	/* flags is currently not used. */
 	if (attrs->flags)
@@ -2486,8 +2502,6 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	start = attrs->address >> PAGE_SHIFT;
 	end = (attrs->address + attrs->size - 1 + PAGE_SIZE) >> PAGE_SHIFT;
 
-	entry = attrs->attributes ? xa_mk_value(attrs->attributes) : NULL;
-
 	mutex_lock(&kvm->slots_lock);
 
 	KVM_MMU_LOCK(kvm);
@@ -2495,11 +2509,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	kvm_mmu_invalidate_range_add(kvm, start, end);
 	KVM_MMU_UNLOCK(kvm);
 
-	for (i = start; i < end; i++) {
-		if (xa_err(xa_store(&kvm->mem_attr_array, i, entry,
-				    GFP_KERNEL_ACCOUNT)))
-			break;
-	}
+	i = kvm_vm_set_region_attr(kvm, start, end, attrs->attributes);
 
 	KVM_MMU_LOCK(kvm);
 	if (i > start)
-- 
2.25.1

