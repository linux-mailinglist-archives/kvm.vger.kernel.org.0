Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993255527D2
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346972AbiFTXK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346932AbiFTXKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:10:43 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C50F23BDA;
        Mon, 20 Jun 2022 16:09:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BcqbFbdND+X5REWRj4jy2MyCqQma+5iTbtKLXZ6k5hHhijLh3yR9a24ETMsV2vcTat2zsTXEo0cSHY4DIy7Q9NiZb5CR9EnwCyFFIS9iK/yQ1Uz1O2to+tv7ffEhWm5QNbmxEvGfNUsy/vmGMD7+SZTHtf9boldLuYkDYdZ2urxDJ38gZkm2VZl9Fzb2qIbRBMcKTV14V8fiDfxFZLi/VdujjgbqAvHgqxBs4T0wFXGUylEdiyOx6DsrdHrPEMsiizhPm1kULFQz7QjMNGWrLVb2V8YDLOeZ/SIxSpzCQuV8zRDDoavhUlqVh524IX3EY4hsKNHwPYXlCxN++7c2XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Be/1Bvr7DJ9InVod01OnZjZtFYzKNNLJKg3st53dlWg=;
 b=G9TlEp+mTJoAxORDcwlqzstqY2oWJL3j2PJzm5qVFp3y6JdZatNxmrNPaVDIVh3kJfWL2yPo8j5gry/oP0wVVyG8PCqxEUDEnIo6rVfl3C9XeZBOkReMToxI2d3noMveNnOy6sKREAVXP4BFI1uHICQfgoBEOv921I/WSnutONVRPpsLpfyab/8pyWSyo5rsUa/VHJT2Xyx1WGrqNFRm1AdhxVvtzDhtVvfq04VADN3EGjqLlY/tjBWl0GrOLIeJXxf53nu2EvJco/kO3gQ2/4W6DM3DC8lcMaoiPrlb07DWOd8LHCv4f0uWzGDs8C6NI8ftMeQpgmA8kVnm1uTUfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Be/1Bvr7DJ9InVod01OnZjZtFYzKNNLJKg3st53dlWg=;
 b=Zxmrt6ygmkaACwUcAyUrKL/uaEu7/KGYT6C0hi/mWpSkwgg83jmSQvByNKOYpHvKEVth1hBCyTzsLC9nhzSn6CnrMvzZe8a/Tn4QsCXg0GLPBYxLZNvYWd8zYEQcjTfgMF3HahkeH7mZKoMX2+am3uhDB1NLe30scC8Oq7jt+1g=
Received: from CO2PR05CA0101.namprd05.prod.outlook.com (2603:10b6:104:1::27)
 by MW2PR12MB2412.namprd12.prod.outlook.com (2603:10b6:907:b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Mon, 20 Jun
 2022 23:09:36 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:1:cafe::dc) by CO2PR05CA0101.outlook.office365.com
 (2603:10b6:104:1::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Mon, 20 Jun 2022 23:09:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:09:36 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:09:34 -0500
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
Subject: [PATCH Part2 v6 30/49] KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX and SNP
Date:   Mon, 20 Jun 2022 23:09:20 +0000
Message-ID: <e2dfa28678c8bde0249a60ad7c8abbc193a74d3d.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: cb8b2099-c262-482a-d2d9-08da5311f20b
X-MS-TrafficTypeDiagnostic: MW2PR12MB2412:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB2412B680DFE2AA0B2AB858208EB09@MW2PR12MB2412.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQ7jshNKgzy0rR/fj7dczFK8u+sVIf6UnDiYSXWaWcAYCQ/ASIyJeEtFttxmeXWQAad+pXbn0dYGpJVnxfu0oAz4rYwCPCl81fZwZMogrXyN9S/qxoYoLw+VVbLxUNJVLdJFFu7dnLWAXRFWAGYqFHQrIDsGSp3KYL1KboIQr3GTnz+dLt9RooyCUuqKXXLLYxIHpMD/NrpNizVD27jxpXjyENi017RLU4RaEkdP5BmxKDY97eJ9paNj4MMA+d3yPNWjOrTjFqaxi3m5qOxCCGywGW9E3Uksq01i5ABqGF1EgFA1JbsdvFcU+EifW7qLDt9+tkffxpolPziQVZKxs4kzjrUhFvCAatYEHvlyWBqWmjW7ql8DqmjONWv7sxRFCOOL7yGju33AFmuNrgasyuugPEeaSXskc3vBrW8yT9gkBfwOl4CtciURsACOkfJBUh9mnbGMpyW/19b6QelnBZbVG8iNUz5HNXA2rZwa+fFjM3yeCdsGvUKJXLDeeRaw+UjNHGqLPvjtCrzw+UZmOE6SxCB0gLnaof7+DUksxSVjRPSc12HchSsdEM/2RCXrVpbJlXwH1USoD5tx7CyMdEtl6gjY0EiIN6RxA6iJVqYFPCz1uPzcn6ux1YaSfh8y2pTK5KKTSIXqnzcqU3KxIQTK+JdqNfhnBAn9vryKi5sfIMHk1QaUImQ+EBi26pfILIydGw8Os0Mo1RW62mOme++VVDPBFhTf+BkYwgQmPVkWnsE3giXv0TAYN8uDh5v+1sMYfHYqHYm30C7jGJGVVg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(376002)(136003)(396003)(40470700004)(36840700001)(46966006)(8936002)(5660300002)(7416002)(478600001)(83380400001)(7406005)(16526019)(186003)(40460700003)(2616005)(40480700001)(26005)(7696005)(41300700001)(86362001)(110136005)(426003)(47076005)(356005)(54906003)(81166007)(6666004)(2906002)(336012)(8676002)(4326008)(316002)(82740400003)(82310400005)(36860700001)(36756003)(70206006)(70586007)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:09:36.5819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb8b2099-c262-482a-d2d9-08da5311f20b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2412
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
without having to go through the full page fault path.  This allows
TDX to get the resulting pfn and also allows the RET_PF_* enums to
stay in mmu.c where they belong.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/mmu.h     |  3 +++
 arch/x86/kvm/mmu/mmu.c | 51 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e6cae6f22683..c99b15e97a0a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -204,6 +204,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return vcpu->arch.mmu->page_fault(vcpu, &fault);
 }
 
+kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       u32 error_code, int max_level);
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 997318ecebd1..569021af349a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4100,6 +4100,57 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
+kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       u32 err, int max_level)
+{
+	struct kvm_page_fault fault = {
+		.addr = gpa,
+		.error_code = err,
+		.exec = err & PFERR_FETCH_MASK,
+		.write = err & PFERR_WRITE_MASK,
+		.present = err & PFERR_PRESENT_MASK,
+		.rsvd = err & PFERR_RSVD_MASK,
+		.user = err & PFERR_USER_MASK,
+		.prefetch = false,
+		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
+		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
+
+		.max_level = max_level,
+		.req_level = PG_LEVEL_4K,
+		.goal_level = PG_LEVEL_4K,
+	};
+	int r;
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
+		/*
+		 * TODO: this should probably go through kvm_mmu_do_page_fault(),
+		 * but we need a way to control the max_level, so maybe a direct
+		 * call to kvm_tdp_page_fault, which will call into
+		 * direct_page_fault() when appropriate.
+		 */
+		//r = direct_page_fault(vcpu, &fault);
+#if CONFIG_RETPOLINE
+		if (fault.is_tdp)
+			r = kvm_tdp_page_fault(vcpu, &fault);
+#else
+		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
+#endif
+	} while (r == RET_PF_RETRY && !is_error_noslot_pfn(fault.pfn));
+	return fault.pfn;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
+
 static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
-- 
2.25.1

