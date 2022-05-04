Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398A5519850
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345494AbiEDHfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345477AbiEDHfc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:35:32 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65638186F1;
        Wed,  4 May 2022 00:31:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZinvk+Jb/2WBxTttvtfD2e+meLm7QRts2TNhL289gnGXwYhiXqXFBqLjg2k9uAiQenH4lQmk+ycBo2EjhCDED/OOyFIUdOt3qsydjCPzXvpZxRep2QDrVF8K4oj62Nioxfi8TzDzwtShyyDvbA8hguE7n5yIUMS3I7UIGkTdcK+B7xI4NlTh1NdMd6pjhTSsTscQs6argLWpvWUZmWZKmPIBP8I3/AxdUcMUYIv+mawcmiPnHEnT1gWxXNZVGyd5XEkK1SZAojreTx6UYsnWyk0zEX+Xw6y26QaaW0mS5MLm5AimoCoK6GWMCDRS82+Vq3K34cQdYFjRQU6p6/Wgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Iph4iB4yyIthTKApkOheSs+Byc7LO1j1IQqr3s/6F4=;
 b=gRD/yC25EWTPLCR6NpNbuxZfYemsZjySK57ncEbUgw709a7bM23W+7aIwEJ7kNHKRHS8r4A8tbzQrc/IXGyzy6bHh7b3oQoU18Lfypjj+dt8T8+XBq5Ot6Fy9ii//weTJCyxWeh/ckT8SbJLCjM77aoo5kzLxsAPLpSeVLH/Xs1aguYTUb/qUs3n+WZES/AOxQEUuWhOjKt7nUosAeLWfEVKGtgzwUwVUh4DqF6AWDpkDqrtTCq8RFQKwKFOrFg7MhZU9AHsppDjIqTw3MflJmNZsSQXY2+LfgVsLiEDJLjrHp5rzyVZh0m/V0/riaROnnHy4Ccu4VGFngCwLvchHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Iph4iB4yyIthTKApkOheSs+Byc7LO1j1IQqr3s/6F4=;
 b=EzfcZXEVhPNGY9s4uE2eh7l+dX6DiEez6aJ5Pj4i1HXHc5qE4VHTva09t6EJxbyGV9wnUvEIb2qg+xUI0AXpXP56MvYdOG9obOpjl+knmesohF6eujHgCQmAaCs6/639HCH0yIB2UWv/9r0BzMHONdq3Noe4lG6aY/W2G31bwCE=
Received: from BN0PR07CA0002.namprd07.prod.outlook.com (2603:10b6:408:141::17)
 by MW3PR12MB4491.namprd12.prod.outlook.com (2603:10b6:303:5c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:31:55 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::c8) by BN0PR07CA0002.outlook.office365.com
 (2603:10b6:408:141::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Wed, 4 May 2022 07:31:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 07:31:54 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 02:31:53 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 05/14] KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
Date:   Wed, 4 May 2022 02:31:19 -0500
Message-ID: <20220504073128.12031-6-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f28d9c5a-814f-4f87-f31e-08da2da029f2
X-MS-TrafficTypeDiagnostic: MW3PR12MB4491:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB44913EC7759B4AD3A8110F70F3C39@MW3PR12MB4491.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AEI0lh+9WtbHZv7BjWHrtxN3EDt/Gzour4Q6PEN25xSsufI03ImFqij06w2mpEFiOKqYfq+Fq5tSw0NUGp+lmadjKe9mOjLVYc/VZmZLdUj5WiewE3jIlfEr+g3wokjU1rBz1Zulf4X1gDdkdYQkahVmhcgucodf6ZtXVtPnK6O98dbcQ6ft1U0W3bLVS22x8NiCnxTSsf/a+cO0pBQBm1bXqPaWU9wlfAeAvxT6a5f9qDBqKCvuqAhNHoznLH0NZMg5guoCj8WwZTlgdFPodvXdM55uUM8+zjFU/Zf0/UTVx3phFAII/m1mrBMQoHr3jGxZKzqp+SrN0A0qbSrIpc3U9V7wJVTCQ11Su16PTUcYEIwIkjg/paL739jBYpaZt3jjQZx/8nYfBJLI0K6kGBVHgTqpjknFBuz1Af6f5tHjHxVkdfxsPv7+C/QfgBbjWuRx0VLwfbP2iLuqHBF3ICWmuuLR6Wjcr9b0c7Y+4mA3fAjsaZeUwaGTgpUjrQwMwE53QEJGthY6ru4IIb4Va8QTEGMdWMjkuTDlpeeKy2KuAkE69Qr60yWXBRwUQAxa319R1OrS8ATwaHZxYsDr/cfQBoQrU2tFB7WD0JfqIOdYmA3krQnrwQiELGmrRqfe6IVRABruTUbQWqA6/6OqhGXAqT/dcb347jSBRk4tmlhswh1Ajl/mZWLJj9u/zCzTuHF2LgLr6wQxYYflS4TwBQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(70206006)(47076005)(336012)(4326008)(426003)(40460700003)(81166007)(70586007)(83380400001)(8676002)(36860700001)(110136005)(54906003)(2616005)(16526019)(1076003)(186003)(316002)(82310400005)(86362001)(2906002)(15650500001)(26005)(36756003)(6666004)(356005)(44832011)(5660300002)(7696005)(8936002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:31:54.7526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f28d9c5a-814f-4f87-f31e-08da2da029f2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4491
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In x2APIC mode, ICRH contains 32-bit destination APIC ID.
So, update the avic_kick_target_vcpus() accordingly.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 182f4891c7ef..9213e9d113dd 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -375,9 +375,15 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 * since entered the guest will have processed pending IRQs at VMRUN.
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
+		u32 dest;
+
+		if (apic_x2apic_mode(vcpu->arch.apic))
+			dest = icrh;
+		else
+			dest = GET_XAPIC_DEST_FIELD(icrh);
+
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
-					GET_XAPIC_DEST_FIELD(icrh),
-					icrl & APIC_DEST_MASK)) {
+					dest, icrl & APIC_DEST_MASK)) {
 			vcpu->arch.apic->irr_pending = true;
 			svm_complete_interrupt_delivery(vcpu,
 							icrl & APIC_MODE_MASK,
-- 
2.25.1

