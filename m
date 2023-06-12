Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A991072B689
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbjFLEf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbjFLEeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:34:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE8A213C;
        Sun, 11 Jun 2023 21:34:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hn4q7mHD5BK0aeeOkBE8nYaypjBM5ndCIznV0RoHiQQycl+gJYsFhH+utIgi8HMLM8aOKu5FhIS6l+akwJZClL7bCKeb/WN8GwJzzkSlW1Tt4m89fiUZCZRHwT1VPzjf/uxw615CIWrA8aQAh7In5P8aicxJPzEISuW2U7lSrpipTQzUUfDwOiV8dmOpJEN32iM88b+vK1TjngH7C/YBWTf43XlxyoheY+LVc/n44G63eEHp3AWfv5Ka2LkVNAIY8bDi8/yBJQGjr904jETx/RSvR6bTjmePCjWIdSXtUDC6YegXqsqik4nXLC39q/DoSUTwN6JflrCIY196vyIR3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7xoPysbgoWBbQUpSlg9IvZXhRgyNb+X2UAvt5tpwug=;
 b=Qpg3o+o+tham3Y0PV6lXpigtQCRTiLczp7Le1wxEXfJvHwNMMVRb5GPMebBu4ziZOwG3vzAvgZ2eUW1TCsUMowxH9dnk3xk6Grg5F2Jno4Wfzm7ylMCAF+0HYMI/Mksrmu3rJh/mAEMjKtEdxDOhUwNhAZRjP2ntZPg4lGu0m2zcJEyIDibp3JurgjS3i6ZyqBHu3likKKyLwcSn+wYJml4ybwvc7hJ4PuyM9enn7PcjVZHwNQHc2mOwTPJMze/U20rQcbYv6+7YMGdHhDQsGSgoWF1zj6N8s9JZokJbEaN+l0UK7Z5nvZtWByewUIxxXvvvZVHPB6DerCguqP6CDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7xoPysbgoWBbQUpSlg9IvZXhRgyNb+X2UAvt5tpwug=;
 b=AGlzkRAtOa6UVTIK60KK83iTDr6noPf6Cc7x0QPYtclEZy8ukP3z/3yDbv6p5bEWo17vdjWTVl8Tu35tJF1kV9yB0Hww0NfQaPDBUi3hk2Cx8imhQX61ZxGCaw/QjZxpsazDsHFnyQM7/y1odkstbq5oJqregniLkoZzNvdj1sA=
Received: from DM6PR18CA0031.namprd18.prod.outlook.com (2603:10b6:5:15b::44)
 by CH0PR12MB5284.namprd12.prod.outlook.com (2603:10b6:610:d7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 04:34:03 +0000
Received: from DM6NAM11FT094.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::b7) by DM6PR18CA0031.outlook.office365.com
 (2603:10b6:5:15b::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:34:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT094.mail.protection.outlook.com (10.13.172.195) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 04:34:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:34:00 -0500
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
Subject: [PATCH RFC v9 01/51] KVM: x86: Add gmem hook for initializing private memory
Date:   Sun, 11 Jun 2023 23:25:09 -0500
Message-ID: <20230612042559.375660-2-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT094:EE_|CH0PR12MB5284:EE_
X-MS-Office365-Filtering-Correlation-Id: c5ebba7e-e173-429e-4a71-08db6afe4006
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CpsgVA9e1+4w7kD0JEz9Cl7ky/lBURcO1ZPvbF/ATtYS4+sY7MCZZ56Js2PbVIpzZQAmE2q3Yukxe6mO9sl8b3ifL32ZERyD8YSSeTCkw8M/uclClgFtN/g2j7ibIml6KXNG50VwgzAHKFY7rJrBUWrjIa+/uanHzJjLkSbUGa+5EU4sLWTRR1F+U5T/zhmdcyXlu9ahl/IMVf2pvYXtPX2BID6kDtVudRQ7LX+i0et0moDKAcdfucyGvgakaKX/UOFRFZJ3/7nRvcuJKaobgW3l0eI0S4cZk2+mx78u6DW8VvhmPP6f3QyD3vf0AcZ+Vs7UfFCmF30NK9CidxfUaBzGSvp1QJKkLjONPK2DKwqA4fsMJUwz73iwJE422v2M4at5DkI6bXWTwbCWO6AfA2y4K0FjkVeXrzaGh5NTZx+RxluMk73Ll89Lol1cLJK/tRcMc5ildl6tQnYExKsvXxwAEQ2OITDKIXqwQGMOYdoL8Mnhhn2jbkKW3yGyTV3mycpOHjsP01fHIE286xV4qkUIPE4wLnv0JpHvOs5FJis6MyP3S6HhYDFNdoSs/HzUBbowmRJ7X8Ebj4nfCl9V52WfSADAfJyEPvfJfDgp/6LCWJCfYpXpyKW+qO5Dv4LFh9IjeIwXMj4OHd0TArpUAz6StDEjujoyjO0OiGYmgcDJjC0Gg/mC8Yjg7QDBxC3dI5wX8Juw5IMwPsFI8pvrzBXMj4rzXJk9GBYf5puFpdLsXd3qxlrFmeSAPWKt0G0zbWu3f8tKLmVSPTqOY5jo6Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(40480700001)(36860700001)(426003)(336012)(47076005)(83380400001)(70206006)(6916009)(70586007)(1076003)(26005)(478600001)(2616005)(54906003)(16526019)(186003)(86362001)(44832011)(7406005)(7416002)(2906002)(8936002)(8676002)(5660300002)(40460700003)(316002)(36756003)(4326008)(82740400003)(81166007)(356005)(41300700001)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:34:03.0511
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ebba7e-e173-429e-4a71-08db6afe4006
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT094.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5284
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All gmem pages are expected to be 'private' as defined by a particular
arch/platform. Platforms like SEV-SNP require additional operations to
move these pages into a private state, so implement a hook that can be
used to prepare this memory prior to mapping it into a guest.

In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
2MB mapping in the guest's nested page table depends on whether or not
any subpages within the range have already been initialized as private
in the RMP table, so this hook will also be used by the KVM MMU to clamp
the maximum mapping size accordingly.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  3 +++
 arch/x86/kvm/mmu/mmu.c             | 11 ++++++++++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 13bc212cd4bc..439ba4beb5af 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -133,6 +133,7 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8ae131dc645d..bd03b6cf40fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1732,6 +1732,9 @@ struct kvm_x86_ops {
 	 * Returns vCPU specific APICv inhibit reasons
 	 */
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
+
+	int (*gmem_prepare)(struct kvm *kvm, struct kvm_memory_slot *slot,
+			    kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dc2b9a2f717c..c54672ad6cbc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4341,6 +4341,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 				   struct kvm_page_fault *fault)
 {
 	int order, r;
+	u8 max_level;
 
 	if (!kvm_slot_can_be_private(fault->slot))
 		return kvm_do_memory_fault_exit(vcpu, fault);
@@ -4349,7 +4350,15 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	if (r)
 		return r;
 
-	fault->max_level = min(kvm_max_level_for_order(order), fault->max_level);
+	max_level = kvm_max_level_for_order(order);
+	r = static_call(kvm_x86_gmem_prepare)(vcpu->kvm, fault->slot, fault->pfn,
+					      fault->gfn, &max_level);
+	if (r) {
+		kvm_release_pfn_clean(fault->pfn);
+		return r;
+	}
+
+	fault->max_level = min(max_level, fault->max_level);
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
 	return RET_PF_CONTINUE;
 }
-- 
2.25.1

