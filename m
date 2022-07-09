Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC6656C9A2
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 15:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiGINod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 09:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiGINoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 09:44:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6DF10E2;
        Sat,  9 Jul 2022 06:44:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwsivmXYgOssrqXdzQp3yvY7QBXeKdatiVgqs5WGlg2JFiiQMXkbSXKRHJSq62e8Giq8hF8nG6LK64SlBKACjsNaaNBLLCXTrkk7hfM+GNrY9/I5nnN9JocezKFW9sKwXye6ToUmWFVSZWghO6kryIUEhV3ariBwpaacoqzYnKalMz5DG0yg/O4goNGPxTjt7qnCZM58cEglBDMVlAgwRngwB8x4K0Jl+3emTgscooptSydPnv2YR8EFAIYoFFloR9KigSp9DqZ4acRL4RfrbB9a2WrXzAkoeA9LKlTMFHSqLbrEHPIyEA9FmYHyhWIcKF+AdCke9zsRkY8HIy2xGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ur8roISX+gf2f8n23sGGeG3gFOxcLKKYFkZ20+r20aM=;
 b=Stw0kaTpRkMVgcT9mSNz2aaGvmduPxM8J1A9y4YNOlDClkXYiN3utqNQu8IP/x7LnLMfvYC7mq377g0x7uNsvCSDPMt1i7kW2hzkrsrmrQMJNtaKBNgohWiTHqG1WybRd/4GlSLyBQL8f/EuSdPqa+fJZWrujlbItP5S7uVLSC60PYbsHDtS73/ZU8CEXkGCcBd9cK5dgDwKQMh1U7Vo3Ig0jefmIerx95PhQC6pgxgvZi5iZn4/rch7NnHOkCWZ67cImw2G5DH0aTB+0k0d+rIlx1x5yUzaIn/0VORngdY0ufQoSbZcYo43W/A9QNMFhArg9I9AfQqdrleQQ0aUeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ur8roISX+gf2f8n23sGGeG3gFOxcLKKYFkZ20+r20aM=;
 b=OUV0NvyvUgt08TZNKgELEfd3NNCWyX1oqPVeCEbyiHSBkMMcVE4GBJI9o7rnocNFWTky9G4b7dY9l/51XfMQ3iJxpTEBBCEG8V8UJEAaAbhnPodFcLR314Kfn8LOg+OPhMvmh7q5OxbRyjm+msjrn77r7Ey9ABE0g4MQKjkcNJM=
Received: from DM6PR06CA0099.namprd06.prod.outlook.com (2603:10b6:5:336::32)
 by BL0PR12MB5524.namprd12.prod.outlook.com (2603:10b6:208:1cd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Sat, 9 Jul
 2022 13:44:20 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::5d) by DM6PR06CA0099.outlook.office365.com
 (2603:10b6:5:336::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.17 via Frontend
 Transport; Sat, 9 Jul 2022 13:44:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5417.15 via Frontend Transport; Sat, 9 Jul 2022 13:44:19 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Sat, 9 Jul
 2022 08:44:15 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCHv2 5/7] KVM: SVM: Add VNMI support in inject_nmi
Date:   Sat, 9 Jul 2022 19:12:28 +0530
Message-ID: <20220709134230.2397-6-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220709134230.2397-1-santosh.shukla@amd.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4d9786e-881b-421c-7763-08da61b11fc0
X-MS-TrafficTypeDiagnostic: BL0PR12MB5524:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dMTBE8XNVNyN2/2v7mNPcsyIlyk3hPSy9f9DsOdRcbii5D4zWEdSIDGVJ6BgOo0ieWlMpwnp1gnLH0mAvUcaaRy/wiGagHeC4/1Hk+CG+1BDWl0LA88UynQwKoum1VQrftyGePvMR8xjo5EKQs68plZaJbI7e3HYSn5vHsgNjv5WPsI4b6Icqmlo6Qw5nRhOl/9ILBIUqyfOnBs3uZVTea8NhdoWmujBleHxNZGpj6YIexw1R7ymv4QhjuXxLxMrbh5kNCL2ywjvHHKu++ZdqlaII3yDPnUfUSmZQRZJ+T1WLenqo5ug+RCakWqDEXk6p2sbG4hX9X3Y3PpTSmYkIHoXBhJnXpD513hlHLayHEAh8thNsObNd8JdF0aSFwKNilTfPZ2tUzkYWV7QhHiGnhA5JIfNXU+xdCxosg3u++7e+NnvpvfhyS8LzWfmEDtUo2zoQcSfw8jtUGEDKK+t8BXosuWtobQJZLvgIjFvFH7xulc+55GrWknM6YNsgeNrT9QBmIRiMOavmCROJxTudCfsj/gBV5gO8U+nWkaFjCCQymMT7bWiLvxmcK7BkwuU0NgAFzesowMLCCuLfJEKTGN5UBjAzI88WTk5K6lKDjWAYNcXOWFCX0Qi2tELrLKnqrCVRbWhUyIC+M4DF8AiRFqvoM20Kb704/TZ7X0cICCwNkqRkWRQIymfM3zzXRlcjOB9POMGNUNdT5QavSem12tfnfd/6Xi9lv8BxrqmGnO52UJaSg0qF3du9F7uuq3jD/E+pUn2EUO3XAfXMadOnIIjR3spHqzgKCPWA3ElRYBaAFJ0INbATo9vDMf432bt+ozn+guZvL+eMuqIViIjsB85xXRvX54OVJU09PIB2bbnvlKcZHc57i7OMFsjGnmG
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(396003)(376002)(46966006)(36840700001)(40470700004)(34020700004)(356005)(40480700001)(36860700001)(7696005)(81166007)(86362001)(82740400003)(54906003)(2906002)(82310400005)(6666004)(6916009)(316002)(36756003)(426003)(44832011)(47076005)(41300700001)(83380400001)(40460700003)(70206006)(26005)(70586007)(336012)(186003)(8936002)(5660300002)(4326008)(2616005)(478600001)(8676002)(1076003)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2022 13:44:19.5221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d9786e-881b-421c-7763-08da61b11fc0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5524
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
will clear V_NMI to acknowledge processing has started and will keep the
V_NMI_MASK set until the processor is done with processing the NMI event.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v2:
- Added WARN_ON check for vnmi pending.
- use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.

 arch/x86/kvm/svm/svm.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 44c1f2317b45..c73a1809a7c7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3375,12 +3375,20 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
 static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = NULL;
+
+	++vcpu->stat.nmi_injections;
+	if (is_vnmi_enabled(svm)) {
+		vmcb = get_vnmi_vmcb(svm);
+		WARN_ON(vmcb->control.int_ctl & V_NMI_PENDING);
+		vmcb->control.int_ctl |= V_NMI_PENDING;
+		return;
+	}
 
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 	vcpu->arch.hflags |= HF_NMI_MASK;
 	if (!sev_es_guest(vcpu->kvm))
 		svm_set_intercept(svm, INTERCEPT_IRET);
-	++vcpu->stat.nmi_injections;
 }
 
 static void svm_inject_irq(struct kvm_vcpu *vcpu)
-- 
2.25.1

