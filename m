Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C84492444
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238830AbiARLHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:07:08 -0500
Received: from mail-bn7nam10on2053.outbound.protection.outlook.com ([40.107.92.53]:27488
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238757AbiARLHE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 06:07:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WniC4Kvp+xXlkKAPLA4qsmfbZRZjDEy0FDagskJYWJM3uMJ0klcjw6wxlbTrnN20JP9HbklnN2oJE/ii+EV+Q95bNcPf53RseSFFdt1D/1x5qIYXWm5XsqevGuFVU/qS+40YVwYqNPWHtQ9LMtRh3a5i2DoJokZ8Fg136gAcd0T+lpRKVzaJlDrdabi5vYz6oiU9ke3BRT9+4SArF1R4Uqct57ro7ub2qpY+aeXZCYBlN8yPwJ7k4dSucTPTG3eYw9VaA5YqI7KZS2xeRMVhqhkyYTVNXLRKvws0niAClh3K20QxsZqGe6cQ5gLq1kJQSzLgUwXWoi51ZaEY0cW3Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIjQgW+CjX+2R5ZsqvkdIeFD4XfzQrKHWkgE3XXhzA4=;
 b=JQzF7q8YFulzw9ldnG1ZxcdXGO9HXNjaDW6XwMwbz6YgoS7c9Ls3F4eO9hYV4u87CFznsuJQYp6etTqK7lMAKvjmtxVgEuCpZ88n4zmi78oK4Sg7cdsWaGmhOV0SEyI71+aSl25iCIGJNownQLOb/uE7f3I9BqguHyQ1mqzgM8py/eBpbhrSY8NGUSRBG8G6PmQPLvU4mSA8r5zu9YzdKpmLW7ggpUTbmGNUH+JG9xEZkam3FwS3YZ6RKmy9NgLtQq7oBsxsx6pi5R83cCNVe48lf3sj7wjbulKbE2AqjnOcykV8XzUXIRwbDPDj6USERlbZCEU/HGiT9DCA7aOlrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIjQgW+CjX+2R5ZsqvkdIeFD4XfzQrKHWkgE3XXhzA4=;
 b=y8TnGxQSeqfu3R5iHbFlxcGuIvw0yadWNSC16PfsJXeWQoVSiXkoy678zbtwkXeLU4VNVZfK10uBYirSFNNVMay52z3zalJujc5a7c3iLva+kSqGaRNj1jTJk26DgJ+/acrsmAwr7MNYpshoPw0B0D/cn/2ScT8jI92cJ19N5HE=
Received: from CO1PR15CA0077.namprd15.prod.outlook.com (2603:10b6:101:20::21)
 by BY5PR12MB4210.namprd12.prod.outlook.com (2603:10b6:a03:203::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Tue, 18 Jan
 2022 11:07:02 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:20:cafe::bf) by CO1PR15CA0077.outlook.office365.com
 (2603:10b6:101:20::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Tue, 18 Jan 2022 11:07:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4888.9 via Frontend Transport; Tue, 18 Jan 2022 11:07:02 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 18 Jan
 2022 05:06:57 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nikunj A Dadhania <nikunj@amd.com>
Subject: [RFC PATCH 4/6] KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by SEV/TDX
Date:   Tue, 18 Jan 2022 16:36:19 +0530
Message-ID: <20220118110621.62462-5-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220118110621.62462-1-nikunj@amd.com>
References: <20220118110621.62462-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8235127c-47c7-4af2-39ba-08d9da72a795
X-MS-TrafficTypeDiagnostic: BY5PR12MB4210:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB42101F47B1D71507F5A7E631E2589@BY5PR12MB4210.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qGA4X84u7BcxAz7pacm46ed0MlxmlTF+KXHJTJjjYQLgom9MpXgKkB+5We9HFMlGPrc2IigXoBoV2GbC8XBXzrMUf68q3Bhyw1dcaa/oHljR3isECSugVUEMWBdHvkyXAn8XjHUPhS8Jsp3yYrNsWySYjOibrD6XrpcrJeBN4HgpJE8+ghhz3X7um3cPzZ5BCnRC1vA8gpDNSt/fIDAcf/LbJ/NwHmiIZUGRKruzarbpEB9A//mV5VrGFFefY0v/3nvFD2//te3g282DU4umRW8Roq4tVdiKnE/iMbU5pSw5NluPv1aUps23tSSZ84YogqwqLLD8HWLNiiJtvXZ8kDkgwM2xn9RnEKCGqdV6tJTJBEGsMW4z5cRyqGRGfpTvBErxIGzbdhIaYb6n45dT8aLM21NGjUcITIq6NbZYHE6GOMZ31XYI6Lp89zrX7htFt9m89rz1YvZi487ruEDYfFuLdihuOtHxmfBLL9lU2bMtQrQiyr5946C+YyvW/IAiqt9TC8fDV1mJ9KOIayIhlenX3m+aXMI5cauWa/QceVBbpxNri1E8WqONZzFiVp7slY5/HD0v4mH8bggUEHkgeg4xXP3cCulW6CuF8EGmr2noBIv6F8BdzrW8B3LFTYZ10qNJp9HV5IX3WIvJKmemyow0f7KmIZWytES6GWu8ia2fGaHRHeVZwlenhSbVdLC2in+9iUzZDGO/1M6/NnI/0iEAp2X6i+zmJ5oFf/HZ+sNfe6xpWV+frSpHgZvEQP1FBBFzta+/llKnC+JhN11lkwZUqrl6Fw0+J1X2MbzYA4s=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(6666004)(40460700001)(26005)(82310400004)(1076003)(16526019)(8936002)(426003)(6916009)(36756003)(8676002)(5660300002)(508600001)(4326008)(2616005)(70586007)(70206006)(336012)(81166007)(356005)(54906003)(47076005)(83380400001)(2906002)(316002)(7696005)(186003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 11:07:02.0618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8235127c-47c7-4af2-39ba-08d9da72a795
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4210
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
index 62dda588eb99..de5d390e0dcc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4111,6 +4111,44 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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

