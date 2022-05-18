Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06EB52C019
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240166AbiERQ1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240209AbiERQ1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:23 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF41D8E1A3;
        Wed, 18 May 2022 09:27:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cgkx5RyqjxD9DcH0L2k5xWeTXfb6l6vpP9NPYVTp2frMhi0jOgHsxQHpZDKrKFyUJrtkkgI5abvJUnE7dWfbyOkfmBN54nzXNHBez6VHJG5cXgv3k5h9+oj6FXbl2WnvaQ5GfkXkf9RjdQUJqQAp93+A5HrJ+S3uExvXZpMXpOvELlPmVe7BlHSFU7JD11rWTERM5G9Tl0xFPuKseRvwGdRrjwsFahf/CONRq1qsAmEfg/tfktlN/y8HzulHU7rwQd1Ym4gMU0a7L3yOprge2fCrFKf2FbP4qfwrCMD7Xqx76Fr5Tl/9Tn57G/M30UYGl6jfeV2M6wTeX07ViP0OgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mDW86IJiGH34cAr0v8eFBvuoANA/E9jIPQE627h34BM=;
 b=H0fY5ib1etcSbQGwlsmRviABf7JzeIcf54krT60azL/fIN7M9OVZyLR/SeAmrtzFG4LWZObtzLCWqpSW7hv9ltnW8yrfpjTYWPUavAEw3nC7whr++qrVLhB52upx/xhK52xFItSuhA6gFNHkFkOhHypZEEXuEG4mg8UIvqplLOl9TlvU1CpnneVvBPfFezD61ihNnSOf0RKJAOliSoMObCf9GsWgWCtfZeRcq6Zb7bo6JkW2ZcaZnT3b7kTFAXJpWyFQ1UnUimIZCD+Z+53Bb4bJCk7LM0upBe0YkLaJxSNilVKzsLgavEDDW9r5f5dUhxWQ+z1WKVuhtP0DYy7Rew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDW86IJiGH34cAr0v8eFBvuoANA/E9jIPQE627h34BM=;
 b=cwQMZ4CwjSvGK1Dh1glTEFVMGXlUR6AGPYOnOxHny1Bwt3MqBBcR2+fWXf+d5UlJ/UYiT2/gE+ByyKEnr9BGR89k1WQxuObhcDKWSjR9rcwaNRDoWLVHuhL7SzdU8n/nZmhvMYkhfCF2B+OqhwG9luk+Qy+KNgTd0sJBVUWRYSQ=
Received: from BN0PR04CA0168.namprd04.prod.outlook.com (2603:10b6:408:eb::23)
 by IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 16:27:16 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::bb) by BN0PR04CA0168.outlook.office365.com
 (2603:10b6:408:eb::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13 via Frontend
 Transport; Wed, 18 May 2022 16:27:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:16 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:11 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 08/17] KVM: x86: Deactivate APICv on vCPU with APIC disabled
Date:   Wed, 18 May 2022 11:26:43 -0500
Message-ID: <20220518162652.100493-9-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
References: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a30c9ac2-26dc-4461-c28b-08da38eb4590
X-MS-TrafficTypeDiagnostic: IA1PR12MB6163:EE_
X-Microsoft-Antispam-PRVS: <IA1PR12MB6163B76706C51A165EB8008EF3D19@IA1PR12MB6163.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MXc900e6szwthgUSLjg/nOKNAzow4MKNavHAxU7cr9bfcDnKFImq0ni1YpeNXisl6PLKbnCavzYFZM3uIJ4e6MVASDNRBUlFjfBERQG+Yv2Vl4JhwHRSS13rQQMpRROYmbPWuPd4UZvvJucQUNLaHTXGgEDYe0zDCtdQBkQ+N1lcr9D8w9Nq9RlMKMeGrz0yd6Tyzdxplp9vb8Clh2fyBOUG0rN2T2HboW+JGFIkTJT65dATsM65jaTbxyNm3LNoi336Abq2URUBasWimXoN2qPMJAtQ3YUNDAjsWxzRgPzl70BeyAU7C8QKEn2/FyTL4ScyAWeMQcXZwx/yzYaz41VPyKLoir4//ZTvDNbSdQzuNPs2bNU9fPeNkmIPul/1S7BOzh1Vj/6lj8XYkhgZqZY2HXIiITvuisdZDF7tg8J30l4z6xjTQsktdZYYbww9G4KP5uPU17UdpAFRGY+MFmjOJTFaOII2xM8Q0Xw8R5HbW0tT3gDCrZFerX/hI4XcFxeOaqvR4JzSzRGHFtK1am1XnbkM2VW4Wc8lKCwlkQStWw4AzfmofKrp5EXDClAniSfQDQZu4TM4WuA8oFmlLptPpSLlU7PxYOar6mVqcwlu/YQP9/oKeWs2OOmfO2LB8Cxp+WtwVTj7oHP/XkPeK9yOQBrRWdATAt381ho4kpCthlB+r+VwznpQDITR1ZSmH+Ij/vRBwm9iNScY+mtUuw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36860700001)(47076005)(316002)(83380400001)(336012)(54906003)(426003)(82310400005)(1076003)(2906002)(2616005)(356005)(36756003)(26005)(40460700003)(110136005)(7696005)(81166007)(70206006)(70586007)(86362001)(5660300002)(16526019)(8676002)(4326008)(6666004)(508600001)(186003)(8936002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:16.1150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a30c9ac2-26dc-4461-c28b-08da38eb4590
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6163
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

APICv should be deactivated on vCPU that has APIC disabled.
Therefore, call kvm_vcpu_update_apicv() when changing
APIC mode, and add additional check for APIC disable mode
when determine APICV activation,

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/lapic.c | 4 +++-
 arch/x86/kvm/x86.c   | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8b8c4a905976..680824d7aa0d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2346,8 +2346,10 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
 		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
 
-	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE))
+	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
+		kvm_vcpu_update_apicv(vcpu);
 		static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);
+	}
 
 	apic->base_address = apic->vcpu->arch.apic_base &
 			     MSR_IA32_APICBASE_BASE;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ee8c91fa762..77e49892dea1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9836,7 +9836,9 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 
 	down_read(&vcpu->kvm->arch.apicv_update_lock);
 
-	activate = kvm_vcpu_apicv_activated(vcpu);
+	/* Do not activate APICV when APIC is disabled */
+	activate = kvm_vcpu_apicv_activated(vcpu) &&
+		   (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED);
 
 	if (vcpu->arch.apicv_active == activate)
 		goto out;
-- 
2.25.1

