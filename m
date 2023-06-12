Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B8972B71C
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbjFLE6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235500AbjFLE6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:58:09 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEB02722;
        Sun, 11 Jun 2023 21:57:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSMM1sXVfktDwQu5Bw0PhsI5OLEzWTkpBZHZ364Ea5i4m7nou3FRlLghQ+gYmxAz/yXxAkVKqqCGW4Ka6ddFdrOYCWBRcGPWogi5NJ+KG5VKsggdPJ/2mDk+aw/qH9O0U1nkzbpKepOWVv9EaJLpHDxMIVH558oWGeEq7bYzyhvM76/hzkCSLARDorN0ifg1bJwKVPvx3bGz54GDHTRhDHN6+8BIH5ytetXG+5lAHMlZ5jnSd95DUXMyyeYrqtJKvjAWKnzZ1ab/cBCcAfWP/rURyWMFMtcWCWtuIfTeVDAdYVPxv9RPaKj9qgh7ObNRN5wRF/48H+Af83Nvh9TGgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s6CZtGI3H4GAYAVMJzlyGlbmtiu/olxIiSDrYkbBXYE=;
 b=TM1tUeqOjKRmDzl8XGPwzGl6ckRUP0QezfAjHkdwfyUteeDXfb6AaFIMIipt5lXoF2ZYt/5PeTArKA8/6XZoIfIz7f9xDM1iKB7N/hF52ZF1YB7zAmUpMMXWiqijPyEnnJdLvjVfDlrfNWcmMxHMqKiW19YFvKDfXkc24+lJ3tzajS+TnX311mvyd1h1a/Kw14MqFJMfeKKqFsnLxi36UJfN5QNgN35QGGiSSltymChqqw++Div4YG6KXwydTLIL2001BHWmFT1g6bNe7rHGvI8ftxsnRv9Tyh0yzsY6u1WYgHpzY1yaAQukU6mrmRkixyMbdgVOSxPkVix6QFGLrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6CZtGI3H4GAYAVMJzlyGlbmtiu/olxIiSDrYkbBXYE=;
 b=xMJCEKRtjEGKkQpanHWDrK8bUbDFvm0/4lpDnaYYJ6CA68hdqoVt7tVNkyfqsg6R3N5pYT9IJUOsPLcNnaL7JwuCptNOaUR5miS70VUl0RrdlKFRW01+hmINDK3UvUvEFogzvfuA+kT1eoPY2MxUAibf244aQKNzjBf1HBgFdJU=
Received: from DS7PR06CA0022.namprd06.prod.outlook.com (2603:10b6:8:2a::10) by
 CY8PR12MB7562.namprd12.prod.outlook.com (2603:10b6:930:95::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.44; Mon, 12 Jun 2023 04:57:08 +0000
Received: from CY4PEPF0000E9DA.namprd05.prod.outlook.com
 (2603:10b6:8:2a:cafe::c2) by DS7PR06CA0022.outlook.office365.com
 (2603:10b6:8:2a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:57:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9DA.mail.protection.outlook.com (10.167.241.79) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:57:07 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:56:46 -0500
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
Subject: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults using a configurable mask
Date:   Sun, 11 Jun 2023 23:25:12 -0500
Message-ID: <20230612042559.375660-5-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DA:EE_|CY8PR12MB7562:EE_
X-MS-Office365-Filtering-Correlation-Id: dd3dd272-df8a-4926-2570-08db6b017979
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OlfPSbJS/xpr/4TLPGEjKnOFjpnp/Juw8RbQsmQ1EqJnBCcdOz+FJzdlYDRAtml3CtOffVki5/hyyKRIrJIcRLOLIeQySe7h0Q2YeAL9TmWLc0RsRfwULdmSYSzshhKNQ9i4EIeZ+GeF/8u1m0j7ywv300fkBRkmjJULSGemQ8MXXKt0742UKsWgudd6Lxr++bEkCuBVNjpuBGHTiqcD6ai9/8gLm1sE+UkZpWbnvA2qGye0eEcBs2ZdbB2DP5i96d6AEjUrTH5zrIsTLodVUXCW8mWoWFzZzX0EQUDj7FCMyz7W1DjlKGwdpWFQ0krPtTLx7gUzFpmKG2+68z1JcKLR/NGrVG49O4KN/Ys1sd9AqdvdsSQ2AU+RVbRSVxfcbE8qB2mrMNWBXURBr1nK37ffQuG9E+XcHeW2EyyfQA3swhEGF4hg4SduFfRoPHremf9Bg+TrfslDXVz75mBqhU+Gamk74MjDSPPGpHW/GkhEmMzhD17wtDy3ORSOstDWpAi2gpo41JkSdXqpJdY02yttmDmsf1mSgXrnv3vLmlk2VMwZTWryJMuyE7hWtE3tLDJiCzq2rejGlGnJgpNIFoLX3RRYUogej7Gjb8i14WUQYnqL4HvmR7SeKSzNaAmRAseAR4mbYpJkemedGO0U/vo0H3x7mUDp8dBUaVC3sqZC60lYz9plI/3cDORElA6DRUWtQ5hUhvOAGXypurmB2HVCr8rQURnMo4AzhsM1cK02xXe9vuNUezt8AxX+jzyXpSpSOxeD3vocXDAc/C5Svg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199021)(36840700001)(40470700004)(46966006)(54906003)(5660300002)(6916009)(4326008)(7406005)(7416002)(8936002)(8676002)(44832011)(41300700001)(316002)(186003)(16526019)(2906002)(478600001)(70206006)(70586007)(6666004)(40460700003)(1076003)(356005)(82740400003)(81166007)(40480700001)(26005)(83380400001)(426003)(336012)(47076005)(36860700001)(36756003)(86362001)(82310400005)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:57:07.8929
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd3dd272-df8a-4926-2570-08db6b017979
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9DA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7562
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be used to determine whether or not an #NPF should be serviced
using a normal page vs. a guarded/gmem one.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +++++++
 arch/x86/kvm/mmu/mmu_internal.h | 35 ++++++++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b3bd24f2a390..c26f76641121 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1445,6 +1445,13 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+	/*
+	 * When set, used to determine whether a fault should be treated as
+	 * private in the context of protected VMs which use a separate gmem
+	 * pool to back private guest pages.
+	 */
+	u64 mmu_private_fault_mask;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 780b91e1da9f..9b9e75aa43f4 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -252,6 +252,39 @@ struct kvm_page_fault {
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
+static bool kvm_mmu_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 err)
+{
+	struct kvm_memory_slot *slot;
+	bool private_fault = false;
+	gfn_t gfn = gpa_to_gfn(gpa);
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot) {
+		pr_debug("%s: no slot, GFN: 0x%llx\n", __func__, gfn);
+		goto out;
+	}
+
+	if (!kvm_slot_can_be_private(slot)) {
+		pr_debug("%s: slot is not private, GFN: 0x%llx\n", __func__, gfn);
+		goto out;
+	}
+
+	if (kvm->arch.mmu_private_fault_mask) {
+		private_fault = !!(err & kvm->arch.mmu_private_fault_mask);
+		goto out;
+	}
+
+	/*
+	 * Handling below is for UPM self-tests and guests that treat userspace
+	 * as the authority on whether a fault should be private or not.
+	 */
+	private_fault = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
+
+out:
+	pr_debug("%s: GFN: 0x%llx, private: %d\n", __func__, gfn, private_fault);
+	return private_fault;
+}
+
 /*
  * Return values of handle_mmio_page_fault(), mmu.page_fault(), fast_page_fault(),
  * and of course kvm_mmu_do_page_fault().
@@ -301,7 +334,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
-		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
+		.is_private = kvm_mmu_fault_is_private(vcpu->kvm, cr2_or_gpa, err),
 	};
 	int r;
 
-- 
2.25.1

