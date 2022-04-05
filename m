Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0F54F5528
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455776AbiDFF3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451850AbiDFBQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 21:16:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E7850B15;
        Tue,  5 Apr 2022 16:09:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqeMKRNz2WlcrmexR5gBTAYln78O9TB1B0xDivZaGfXixZJpbMlCo3K4X7j/yIo3v69G63O9Smi7DRz/Dj1tVaUDF0lWZ+hn12xoCsQIwwGb0jMZ51fIbQ2yAWJdD+Ad1NyP45wvKYfxU2G+umbyqmTpUCl2xxaGyeNa4HAPxvyf//rTv94VPMkAbre0EE4KO4DlGe1cfHg6sFYaLHijcG438vJbuaXnlaJe/jFbSDi9WUvinHiPHynwdsrGww8Y+vBIuXo4gchHSphoSmL90SJi2HlIIH1bg/TbMFKR3WZE2j1tEw3LYsItDrfRDNOnNRpq303DSrz0Xr/0dnKfEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PyVmTvq7TmLrXfHAcliw4Pzv8MfbZuU//419V9+gXA0=;
 b=QrK5UAaaDCZUavb+nL+6Emj72GGpUgibTltC07TPV4+F31IijXpJYWoHUNSR9hsCdqMQ9j2QJBURxCeANrnOyAmBU5OlcO5gLBC2tPL7+C3edwY0aNoGtnws/fFYL7J6IK/KM5ulOW5Ue3yxfjXCyHGg0RYKMzBQDO4hna9JqxMQ9y9a148fVDwYM7gpdCff/07p7XbxOfna0Pd2lj6FK5D25Y4G8W4QoJRVVF8h8sIEAQ6NNTmw35zRfxyJxligd5rLCva/8m7R45JALq1pmlsskKMrl3ECfXoDMCQZbNCI9ETI8LTJflpSZMeqQnNz7tOvyL7a6WJVdC/YUUVGVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PyVmTvq7TmLrXfHAcliw4Pzv8MfbZuU//419V9+gXA0=;
 b=faDWfB7IGDsn1P7Y1J2K7rR2nuO494c+tbWogLKzS8iC52PA9O6w8YiihR9if/m6HvWIaNKLsoIqBaeTfX2U2vFKXe9unkRdbWklSIG7ZHElhndPf/cP1caEKQb5LsANHaLeQ+GPK5XQd8sRQWyyh1Uy7sq/AaCzNtjSfJpYzkM=
Received: from MW4PR04CA0075.namprd04.prod.outlook.com (2603:10b6:303:6b::20)
 by PH7PR12MB5832.namprd12.prod.outlook.com (2603:10b6:510:1d7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.30; Tue, 5 Apr
 2022 23:09:30 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::2f) by MW4PR04CA0075.outlook.office365.com
 (2603:10b6:303:6b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Tue, 5 Apr 2022 23:09:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 5 Apr 2022 23:09:30 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Apr
 2022 18:09:24 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 08/12] KVM: SVM: Update AVIC settings when changing APIC mode
Date:   Tue, 5 Apr 2022 18:08:51 -0500
Message-ID: <20220405230855.15376-9-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
References: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d12dad5-fa23-4102-d11b-08da1759572c
X-MS-TrafficTypeDiagnostic: PH7PR12MB5832:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB58327B2FD0F08C9CB331670BF3E49@PH7PR12MB5832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1/kHwlvzqPL8POO/6ccdRxhiqUqumKRt2T3IJSnvStLflJCbgDDRS4hr5AdPjEyTW9n/CBP652RfPjH4vvQ6pVGHetr4dXvTb5sHsgGadccm3pcezVT9b/jffqaL8bnb1akamkXSae1n0ccgaSjmprIlcNEkPlHSd/AVlvibaWkGN9nHZMTMPmb5oV8iuhuLQ1WKP29mJUVttOEyXQ78l2DYsQvYciHlrEVgvP32VkeK1wf91KrISrofrr2fWwL0a1rFc9Y/MPF2fKgbz3uZWOYSUR8ZQcUUM2Ajen7YXtD7aiZJ5m2nvQqc7BkysFHcGuLDpRoOTX2E30zkyjsAyNTR53yOmzjscvjCsWE5W0rlKe9RXx48SM2Cc0QGCIFUUR+xXwm/aq6xB1npYB2uZFS0KuPKhhLPa01a3Cg0ILap3re9WO7B/A5ImWS2p2OctplEcIz394qLthATIR+6dDXBFPJ5bmNjl7iLagP7nx/8BS0i96VGxTgj9f2utGXZPxUPg5kUd9krXCiDAGq7GCggFf4m59NqxKy4kqs+P4iOgwG4kI9W4Q70fShbJPodU3pOMxWKjx/FjvrI5T+RPzW0j04Fyz/998GhS9tgGP8GVvImrUa3iHnXNDhXegi7dxATaBBN0TOHO5YrrPRP+ukTQ1ChPWrZ+gskC9FFajxIGt13hryZV7aNGmGDZxT+WmbRSicqJiV8PW0eoyJu3A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(2906002)(81166007)(7696005)(70206006)(70586007)(8676002)(15650500001)(36756003)(82310400005)(356005)(4326008)(36860700001)(4744005)(7416002)(47076005)(186003)(110136005)(426003)(86362001)(1076003)(16526019)(83380400001)(8936002)(336012)(2616005)(316002)(44832011)(5660300002)(6666004)(54906003)(508600001)(40460700003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 23:09:30.6086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d12dad5-fa23-4102-d11b-08da1759572c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5832
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When APIC mode is updated (e.g. disabled, xAPIC, or x2APIC),
KVM needs to call kvm_vcpu_update_apicv() to update AVIC settings
accordingly.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f378f7810db7..58b58a327826 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -620,7 +620,17 @@ void avic_post_state_restore(struct kvm_vcpu *vcpu)
 
 void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 {
-	return;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
+		return;
+
+	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
+		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
+		return;
+	}
+
+	kvm_vcpu_update_apicv(&svm->vcpu);
 }
 
 void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
-- 
2.25.1

