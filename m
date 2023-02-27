Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8716A3D80
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjB0IyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjB0Ixh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:53:37 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC62D1DBA5;
        Mon, 27 Feb 2023 00:46:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auPiX5rHe4PtXAzvoKekv7yWbcq279Eiv98LoiQymWgto1EyQSjGmaiiCM+8t68g9SSsBIwlBInKFp01WLCAueGc6A7ZFQjWepfqV+OLNdq2PKrp4K+a1yU9gEwctORppbYIPiCdvXD70FW97dPHA+V1AmON40MG6on7UOdOLb5ooWn/7iiZQ87NEth2+Zs3hSxhO4b/4lrajEZ++fNKUXK6qr9OCL4A6oHrJtt+5hDt44uHazdRABJvE8N9WOr/g584TMpYnPiVt4nMFSCcAwfckSRmIHgmtNEUVLoBIvHpV+mVMyHZkjeh3p9Z6hViWm5DyJjUc6xEN4QOOtoeLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJxDAL7B6BGNFzhYPk2HQCW6NU5Grxu1KnAxytCZ7Ss=;
 b=IgIF5qVdYv4lzqdHeMw0k8sZWtSgzwHc4HvIuQ6jAZeyD3FVzfKWRbzWzcast6D875XqciTLEXFlgw93yIcgTmsc1Rn9viF1mvgzUw7/t4Kq7sesng/9jqnUYCB66EH8lFclEenImmvr6uQmCfKbQhM+jB8G4pWzaEpG4nUci9sLcInFo5UdIdLQ+NIAu6MJRCTemL77bIKQhXoG8tftFpWviKisE0D7/nFGWbTrlXug6hyXGE+xksKLqiNT1q+Je//532B55I25viilkHy2lPVEWYAktzj0hlM8370jv6y7awRFsi9gJB+PiBsar0V2y6o7haeiJLB+naxL2R0PqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJxDAL7B6BGNFzhYPk2HQCW6NU5Grxu1KnAxytCZ7Ss=;
 b=hbWjXnIn9kJZQ6osko5SunrhlntJNsbBdFr7y6xMISiqdkQr8BuiHXnlQVhp5yOyPOz7SwTYgwaTwV2dulhkq39v1n8J4XxdCV+258qyZp0cWWqg4yymh4p0pfnULI6QDlovsODyyMxNmRWsQRg0IXOmpN3r0DnbCAaFrwJ+HE4=
Received: from MW4PR03CA0077.namprd03.prod.outlook.com (2603:10b6:303:b6::22)
 by SA1PR12MB7038.namprd12.prod.outlook.com (2603:10b6:806:24d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 08:43:40 +0000
Received: from CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::5e) by MW4PR03CA0077.outlook.office365.com
 (2603:10b6:303:b6::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29 via Frontend
 Transport; Mon, 27 Feb 2023 08:43:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT087.mail.protection.outlook.com (10.13.174.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.12 via Frontend Transport; Mon, 27 Feb 2023 08:43:39 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Feb
 2023 02:43:36 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv4 07/11] KVM: x86: Save/restore all NMIs when multiple NMIs are pending
Date:   Mon, 27 Feb 2023 14:10:12 +0530
Message-ID: <20230227084016.3368-8-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230227084016.3368-1-santosh.shukla@amd.com>
References: <20230227084016.3368-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT087:EE_|SA1PR12MB7038:EE_
X-MS-Office365-Filtering-Correlation-Id: 143a2865-3a76-42e5-7d1b-08db189eb99b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vFnjTaS2X330dNXgu8CpJO7SCaxNe6Jm8ryo1eZPhzCxlG/kdZBWpBLLYUy8DFL8ekdeHAVocROOBUKP7BlwF/zkLDsA9tekf0Yg90/nosvDeSTQdsROXuNtj4h/1CgtO9Qpdi3aiLQiIc+7jQ0STlcPFQVO0E2O4HBOUCto97jbZgeACr/6LD8bZIn2btUEFFsmHl4f3OhsRoLADhG+ZRUpwanQLt3M4WUnt6G9Mtjq3Su3B1cyUETG0nLzJ09pEYOij1c5j0/gFgQJauEUHQtSfjr4ZuHoaOydgIzoKa4vv8nQdjUC2FysKXqco4MQKlL+0UAbQsqJsKLvqZ3UrJ31bFIgZeOlNuj3e3aQrHxKxZXt7qIGxcipX2EaV3fnSCOsfZdDbd5woXbaXj7zgpByXi+eIlphTVpBqTTeTvL718Vs+dBe3NxqqbHi9NZDz++11+3sUUmyHSfc7/AuMfngPZbmIOIZXB17RxiRD/mYI8a2QS6TmP+C0diqR//62le3oacC3a0T+CgDML0Rq/k/x3QTZtUtVnMiOu6hPblsez2bUMVG3CapxnY5uUa49zXCyVkKPYZZaNvhdQUdauudSjb7EyGd/RyJEXHjQoxFkTpuuK5FQksWTxWdGnwR8D/imolI/gPct/DPJ56SROjoQ8+XtUcGUV5wfuHfurxUHihYRZzFO515qIOeGuRo3k6SdsXWy7pKnxpgG5X7+jbICiYcJdvxKNDiIC0Fw4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199018)(40470700004)(36840700001)(46966006)(81166007)(82740400003)(316002)(36860700001)(2906002)(36756003)(44832011)(40460700003)(5660300002)(8936002)(40480700001)(86362001)(1076003)(70206006)(70586007)(16526019)(186003)(26005)(4326008)(110136005)(54906003)(8676002)(41300700001)(356005)(2616005)(336012)(82310400005)(83380400001)(47076005)(426003)(478600001)(7696005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 08:43:39.9525
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 143a2865-3a76-42e5-7d1b-08db189eb99b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7038
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Save all pending NMIs in KVM_GET_VCPU_EVENTS, and queue KVM_REQ_NMI if one
or more NMIs are pending after KVM_SET_VCPU_EVENTS in order to re-evaluate
pending NMIs with respect to NMI blocking.

KVM allows multiple NMIs to be pending in order to faithfully emulate bare
metal handling of simultaneous NMIs (on bare metal, truly simultaneous
NMIs are impossible, i.e. one will always arrive first and be consumed).
Support for simultaneous NMIs botched the save/restore though.  KVM only
saves one pending NMI, but allows userspace to restore 255 pending NMIs
as kvm_vcpu_events.nmi.pending is a u8, and KVM's internal state is stored
in an unsigned int.

Fixes: 7460fb4a3400 ("KVM: Fix simultaneous NMIs")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Santosh Shukla <Santosh.Shukla@amd.com>
---

v3:
- There is checkpatch warning about the Fixes tag like below

 WARNING: Unknown commit id '7460fb4a3400', maybe rebased or not pulled?
 #19:
 Fixes: 7460fb4a3400 ("KVM: Fix simultaneous NMIs")

 total: 0 errors, 1 warnings, 20 lines checked

Although this patch is part of kernel v3.2 onwards

 arch/x86/kvm/x86.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 16590e094899..b22074f467e0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5113,7 +5113,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
 
 	events->nmi.injected = vcpu->arch.nmi_injected;
-	events->nmi.pending = vcpu->arch.nmi_pending != 0;
+	events->nmi.pending = vcpu->arch.nmi_pending;
 	events->nmi.masked = static_call(kvm_x86_get_nmi_mask)(vcpu);
 
 	/* events->sipi_vector is never valid when reporting to user space */
@@ -5200,8 +5200,11 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 						events->interrupt.shadow);
 
 	vcpu->arch.nmi_injected = events->nmi.injected;
-	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING)
+	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
 		vcpu->arch.nmi_pending = events->nmi.pending;
+		if (vcpu->arch.nmi_pending)
+			kvm_make_request(KVM_REQ_NMI, vcpu);
+	}
 	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SIPI_VECTOR &&
-- 
2.25.1

