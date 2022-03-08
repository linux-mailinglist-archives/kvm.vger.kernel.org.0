Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FB14D0EBF
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 05:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245270AbiCHElN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 23:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245130AbiCHElL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 23:41:11 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2046.outbound.protection.outlook.com [40.107.212.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3452CCA2;
        Mon,  7 Mar 2022 20:40:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHcB4mAttlyAfLapKjtaUtOLhfYTcKI6dTg0/WOmFRvh0TPtnNYJ85f9Vrcr0wlQP4sRfxLHukP2ZSE4OOScmEMalWiOAhIxQaofzMwC6lY4OP015TVtzh0xnAlSiXw4bPRM3f09WrM7atEc5bsnqM1WA+JrMjf2E2/HSpl/YRqOddF9/o2TmjJa+PxcaLPi4e8p+YcHJRFALbtSt+JquQ6aB6lpbVyxf7QgsO+V/uPfzZTU1dIPq9ATFt+R3AJCuCKUCpvFevhU1In120ilDEh8kjDXN8uhJ9/Mkz7TT53HktKG+y30dmeJBp5McikF+he2Rsm7QhKdf8JXj3dDYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AaLxSGDTdIod5jBkm0rL2cgPZM4JG2UMZfSouTwN0MU=;
 b=HiykpBLpbli+Q76sw9t8sO5gfNBzggLmnB46LzmpNELkA9ExhQCswMN22Zud4Sc+kuRvKfajm0q6tBtFWWZctSSUgXzkxuNy54s3/tnzziUnQDyzNnwHAJvw3oHAwR9r/8Wd15lxqWj4e9KhjLIOdJPCk2ZKpdkOgHR6/qIuzIMyDgukEU5x1Gt8K9S745QUwF8LnDL5gNJ2abbcbvcUjO/toBf7rsTTBKYH2wBTfPhH2baxKZcqr7SOF/2g2Jvo2cXlH7B+7p7/AwR1ty2jDCb+tw947E+qCCUVY8FN8qd9SFbUQ6GVAxuAnb/60wlwwUVqGdgArF23w9lxey1THg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AaLxSGDTdIod5jBkm0rL2cgPZM4JG2UMZfSouTwN0MU=;
 b=31HudVNOfaIwPCIp8XCAIBJkXZou+21qrdafNARVEwPgpbjMWNvAr3X9BxOlq2jf6zaszjbPNnTOhTBGRq68Qj790FKjh8pstbTTFqPB9JAPZaIXzXQRwwPykYErriQzZa5oAY+AABCDNxHbeHhM9XyVVqEcPjqan0n4YOHykz0=
Received: from DM6PR06CA0010.namprd06.prod.outlook.com (2603:10b6:5:120::23)
 by DM6PR12MB4957.namprd12.prod.outlook.com (2603:10b6:5:20d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 04:40:13 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::9c) by DM6PR06CA0010.outlook.office365.com
 (2603:10b6:5:120::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 04:40:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 04:40:12 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 7 Mar
 2022 22:40:06 -0600
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
Subject: [PATCH RFC v1 2/9] KVM: x86/mmu: Move hugepage adjust to direct_page_fault
Date:   Tue, 8 Mar 2022 10:08:50 +0530
Message-ID: <20220308043857.13652-3-nikunj@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 78621c51-c1a8-4ca4-b31a-08da00bdbbcb
X-MS-TrafficTypeDiagnostic: DM6PR12MB4957:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB495747A98DF8E3182C899A4EE2099@DM6PR12MB4957.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AV3viyRPMl8fC3JzrFbrLV+2JyPPACQZzaGi5A7vACOxdlWspxE2weXPvenGJnlnriVw8LH3f2g7IKXJ2chdTQJ1yQla0hhVrnbtoPxDlFlz9zPtQTj3I6NrPQfm7AWYZgf/D88USB5SN1emJbPm+S6pW4acN6HRyi8rqj/gq9BONqz2zeoPiFaPfVD+2ZWH62YCeNfQJMXZUsx7+IVIoDFnp1fxxTistUKsu8+OB5B3jyQVn4IKjbWst4JZ4T9yIhvM1Mv+KCLCMGTz4jROJMTUhbHr4NXb1/xlCHBaT127L+AoBIy0YjvWm1XujbhIQIRx/nlGZm3Lk62qRGX3zlphDIyNcpYIin1kQMZkFOTaxIPIgoT6IvDSfe0Fx9r+E3KtPTdaAOTK7Iq3ZGcDBXCYtKtFExmlw7siw7Vxx3XbrL8MCqz9tCNiRA+VCs1r+MqEJug9LIL302BQH1hfWfCVt1SgPvcvrUFHFtdNHlAHCdqLcyTIcbXz/eaRJsE7SZfgLaypykspSJNhQATpibEev3xXne+MZzo6COFwkDQwD9q3v1mZYiP3BYc/ER1RXErTyJg2K6DxTMfuKYpoptAmtn2rONO6uM/15bSaQClea6EUYqiHwtLxc/OrnkCdje8Dk8AX9BxrrvJOXn8VRNRBjUWBptXl54NPeG4wYLHhLePNbXoWeChPRtdmm8RlKjzZhe6ZWrP3CmpR6uicJw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(6916009)(54906003)(316002)(40460700003)(186003)(70206006)(81166007)(70586007)(356005)(8676002)(4326008)(36756003)(36860700001)(508600001)(26005)(1076003)(83380400001)(8936002)(6666004)(2616005)(7416002)(5660300002)(47076005)(7696005)(426003)(16526019)(336012)(82310400004)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 04:40:12.4760
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78621c51-c1a8-4ca4-b31a-08da00bdbbcb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4957
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both TDP MMU and legacy MMU do hugepage adjust in the mapping routine.
Adjust the pfn early in the common code. This will be used by the
following patches for pinning the pages.

No functional change intended.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/mmu/mmu.c     | 4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8e24f73bf60b..db1feecd6fed 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2940,8 +2940,6 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	int ret;
 	gfn_t base_gfn = fault->gfn;
 
-	kvm_mmu_hugepage_adjust(vcpu, fault);
-
 	trace_kvm_mmu_spte_requested(fault);
 	for_each_shadow_entry(vcpu, fault->addr, it) {
 		/*
@@ -4035,6 +4033,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 	r = RET_PF_RETRY;
 
+	kvm_mmu_hugepage_adjust(vcpu, fault);
+
 	if (is_tdp_mmu_fault)
 		read_lock(&vcpu->kvm->mmu_lock);
 	else
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bc9e3553fba2..e03bf59b2f81 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -959,8 +959,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	u64 new_spte;
 	int ret;
 
-	kvm_mmu_hugepage_adjust(vcpu, fault);
-
 	trace_kvm_mmu_spte_requested(fault);
 
 	rcu_read_lock();
-- 
2.32.0

