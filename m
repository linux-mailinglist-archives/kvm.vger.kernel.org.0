Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225474D0ED1
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 05:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiCHElw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 23:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343572AbiCHElt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 23:41:49 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789613BBD0;
        Mon,  7 Mar 2022 20:40:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uz9jUe/tkRdm7PjFyeUAPVPgka8dI+APL41DbBbEKl0i+GLd/ypOmnpG++ZQLrzkw04us6ab7GRbcyJIQUSdXrVyISrFJ0c0p2lGh1KB3eeognW8jay8NuJvldAPctwExv+NrG5h8Y/D3i8K6IHeNqhsPjyQKy2eG0giUxa/fnUHLp4guluSireU86FvrBwcJNjtLNRCYyxJ1Lb5/jQR2S/sft+ClhWuq9Pzfo2ZsB37jxQ5sd2BZlQvCIyxZD9Zqx6CUeXWGfX6eo86DCdyuw8fphilaRzc4nwdxPsU4hNtgPfmHve6usnhRhKi5RWSAG0T4bjlgPvOu6UhI+WEsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GvKfnx5pDMJVWTqfkckvKFX5tRfjiqPceq5Mk2APk9A=;
 b=AZZDM/ciAK+4R6mx5jnBwjcewg9aDb51VHKYan9sEQd5Hg8qD6GgXu21fIe8tHHFu5H2YQAnZNUsW3f8dln70a3BJY+KBAvkiURUCJeTdaMCasganxdwcriHtIbp7y/2yFRqPtPkwwpa818KwpWLtimGEq/GwZUl9jMm8AqljWxv3lvH7yiao0/Lsw3S2IO+N+ih1DIXvvnyMni3IKZJ3id5+/tu+GKsjSUfdxCTUlfoke/ql7mTAC0R/59HnavkboUDWOR5qVic/Bh6S/PmdIXv49k/xuY4KLHAfpVNDXi49GF3jPnB+uEvgHrFSYH8nqmqcDpNnqpjuPHaWNKqoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvKfnx5pDMJVWTqfkckvKFX5tRfjiqPceq5Mk2APk9A=;
 b=GpJz3+8KaJMb/MPeUBMAnztkAYTACbyfyM5Lp9eJD2CP2YVvNNhmKB8GjUpCfKFpXeaoO7kfHRsfxai1JQ1idAgAUPO9zPVdQTaO1+AQjtKid5Eq8i/wsT/ZRCh6yWERNbiBVBZGKxHxxfTtSaekLVpPrNM7Tkj3kHHCOlwvXIk=
Received: from DM5PR10CA0020.namprd10.prod.outlook.com (2603:10b6:4:2::30) by
 LV2PR12MB5848.namprd12.prod.outlook.com (2603:10b6:408:173::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 04:40:33 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:2:cafe::c) by DM5PR10CA0020.outlook.office365.com
 (2603:10b6:4:2::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 04:40:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 04:40:32 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 7 Mar
 2022 22:40:27 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        "David Hildenbrand" <david@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH RFC v1 6/9] KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by SEV/TDX
Date:   Tue, 8 Mar 2022 10:08:54 +0530
Message-ID: <20220308043857.13652-7-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220308043857.13652-1-nikunj@amd.com>
References: <20220308043857.13652-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf52e22b-5c41-4711-4829-08da00bdc804
X-MS-TrafficTypeDiagnostic: LV2PR12MB5848:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB5848A09E4D680324968932EFE2099@LV2PR12MB5848.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dphlwWKdQkXoxK98exJKSqVxlJFDTWEZqC2MvVH/wUVT7nZ+G6jXaHwdIPikoNzIB5Bm33hBO3X/3NgHG0hoeayFL0j3Mo1fIQXILDveKtgmLgTYcpF31QwDRddLqx/edWY01OKKdy/0X9QtVZCUidZXqvGl0v+KYSw7jXr317Fb41mtR0RotjdLrcCE4w7BvWf8SVE3vAkTKdKTEw+qhrEYXFXNHloVFeQeS03zpfTeAB9yci1I+C3r0hOYs9jJjC5szlys8LNX5g/Ap7Y2O/3Gcye//VGYAB+TLAv729wpddP2OQrhn7bSwrh6WSrSDf0TwLcHLTIxJpE1KmHWLziFsMR0hKvJLTEw7jIaWTmsz9Eb+F/oeakvJr2mOI9Bx0ndjc/KlJqOUpv/1heIfzdplmGbxdKLc+G4YAjAzQ0w02ETkU+gyVHEDbI4g76cks1Y4a/kr6SBuFv6o7gwOdlddZtl/qs3KmTCjXoaiHNC+F4c4exdPBz8Cu9oI1ThBisFBp4p/6R0ddYhxFXAvT4g4FJFkR5MAmNrECnsAn+NN2S4TCpwVz3c4jYPMXQZzed385Z5gQMYIor9z6xFMEI2+vZXyO/MqLWmYgTXTbsuZZfCF3a3eWTf/5HGAvXIEHGX6+yCSXCx7qaz/3jl9lA6lq00v6Bf2bOaBd9ipLnUPPeg3G2uDdmT0oW/CqAhrTQlr3+YhXVw5iiMScyORA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(356005)(81166007)(336012)(426003)(40460700003)(186003)(26005)(1076003)(16526019)(83380400001)(8936002)(5660300002)(36756003)(7416002)(2906002)(6916009)(54906003)(6666004)(4326008)(508600001)(70586007)(70206006)(7696005)(8676002)(2616005)(47076005)(316002)(82310400004)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 04:40:32.9795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf52e22b-5c41-4711-4829-08da00bdc804
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5848
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Introduce a helper to directly (pun intended) fault-in a TDP page
without having to go through the full page fault path. This allows
SEV/TDX to pin pages before booting the guest, provides the resulting
pfn to vendor code if should be needed in the future, and allows the
RET_PF_* enums to stay in mmu.c where they belong.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/mmu.h     |  3 +++
 arch/x86/kvm/mmu/mmu.c | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e9fbb2c8bbe2..0595891dd834 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -202,6 +202,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return vcpu->arch.mmu->page_fault(vcpu, &fault);
 }
 
+kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       u32 error_code, int max_level);
+
 /*
  * Currently, we have two sorts of write-protection, a) the first one
  * write-protects guest page to sync the guest modification, b) another one is
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b94e5e71653e..5f5da1a4e6be 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4134,6 +4134,44 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
+kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       u32 error_code, int max_level)
+{
+	int r;
+	struct kvm_page_fault fault = (struct kvm_page_fault) {
+		.addr = gpa,
+		.error_code = error_code,
+		.exec = error_code & PFERR_FETCH_MASK,
+		.write = error_code & PFERR_WRITE_MASK,
+		.present = error_code & PFERR_PRESENT_MASK,
+		.rsvd = error_code & PFERR_RSVD_MASK,
+		.user = error_code & PFERR_USER_MASK,
+		.prefetch = false,
+		.is_tdp = true,
+		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
+	};
+
+	if (mmu_topup_memory_caches(vcpu, false))
+		return KVM_PFN_ERR_FAULT;
+
+	/*
+	 * Loop on the page fault path to handle the case where an mmu_notifier
+	 * invalidation triggers RET_PF_RETRY.  In the normal page fault path,
+	 * KVM needs to resume the guest in case the invalidation changed any
+	 * of the page fault properties, i.e. the gpa or error code.  For this
+	 * path, the gpa and error code are fixed by the caller, and the caller
+	 * expects failure if and only if the page fault can't be fixed.
+	 */
+	do {
+		fault.max_level = max_level;
+		fault.req_level = PG_LEVEL_4K;
+		fault.goal_level = PG_LEVEL_4K;
+		r = direct_page_fault(vcpu, &fault);
+	} while (r == RET_PF_RETRY && !is_error_noslot_pfn(fault.pfn));
+	return fault.pfn;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
+
 static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
-- 
2.32.0

