Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFAF6A39DD
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 04:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjB0D4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 22:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjB0D4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 22:56:35 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AA9196BE;
        Sun, 26 Feb 2023 19:56:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+Td0OQH9n3QYdSrNPElC24NHrMzd72cZCJwmlSx0vp+8qQ07oopX/pcMEPt/rxK1UU0tTrhKJG0/jiv9Ef/es53LwUdDeKU+3PLy3YU39pMDRU9HymY8RBETTmdqHcxLRD0CI4A6jiI3riKn4dbmZZkM+bC0PDNh5RODPundScjs1w4WP5FEeFf5nO2w0TcfFEbDg01qo1dEshCPeEFCNeG2cJDGCSVRP7rMWhg8pzoZ3aCBkBkGldOIXe+UsLcHMf/nPqhtVxri389cZVvCqW/YkG540kaYtmxW+AExTZC2W8w6UjTyvJpxCfxccvySXKWMB1fjFbL6qNSYzwSHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKBFoj86dHZ+KfxyBEgxL1R8g8Ujxd/3fSsSU13nxSc=;
 b=O8GwzHm8934H6ZQw7ugbov6B4RnvyEuMiTHfVA6hKc9bWkWlYFfL5R8F9obYgh93hZXzwnHtwBOWuNe+s7ymBlxVVMiYwbjFJiDKnHymadDW/lwfT/JZHKfl/4PkyRQ4WSws/aGMRy+ekkEWS1zUKVVCPmdKGr6Z/dMDudtCmveDUloMKVucsHoglozNTuS6jQc7FEN0w+sKyPtmSsrTabNEHChAaZMBEKTkQvM7Vb59/OdiC0dki48Z8/nTu0QbHNymptLlBI84pw3CILRI7FwXlZPFXEEeXM9v4FVImSWxTDMOSZXqFZfHIsxVvYPcQT23sqkYOULuxKjjD0BwVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKBFoj86dHZ+KfxyBEgxL1R8g8Ujxd/3fSsSU13nxSc=;
 b=ooaGqyM2H1OjqD9o3f1ag+dxgXRsAqtCBqaY/VQJXi7B5dCALrZ++jAwaiB5lx24Q71r0hyzUT0H+yJc+Sz2oMGIcFaGsSAZQlt3+D9vdBxhp7rHh+EPn/3ozA2i0M4cROha30E4Q5rQS5lrZcg8AN1tCn94gENxB8Vm0SJ/DLE=
Received: from DM6PR06CA0086.namprd06.prod.outlook.com (2603:10b6:5:336::19)
 by CY8PR12MB7684.namprd12.prod.outlook.com (2603:10b6:930:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Mon, 27 Feb
 2023 03:56:02 +0000
Received: from DM6NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::6f) by DM6PR06CA0086.outlook.office365.com
 (2603:10b6:5:336::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.28 via Frontend
 Transport; Mon, 27 Feb 2023 03:56:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT105.mail.protection.outlook.com (10.13.173.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.16 via Frontend Transport; Mon, 27 Feb 2023 03:56:02 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 26 Feb
 2023 21:55:58 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv3 06/10] KVM: x86: Save/restore all NMIs when multiple NMIs are pending
Date:   Mon, 27 Feb 2023 09:23:56 +0530
Message-ID: <20230227035400.1498-7-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230227035400.1498-1-santosh.shukla@amd.com>
References: <20230227035400.1498-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT105:EE_|CY8PR12MB7684:EE_
X-MS-Office365-Filtering-Correlation-Id: 8917648e-41df-4ead-6468-08db18768b5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vgjr95Psn0XLEG2lchdKnXMpRaEPL+iJ4ylfV+Edh6limd+dARGVlCXk7vIXD6LlD2E0uGTOZazKxjWQckxsXAi+NKB4Q4Xjm01hj6FgYWW8fiQ8inQYJwmtryb1vY08HSbw++75lDRCKdnoBFOyMB28PGOBlRvQN6o/ZVo8ii366YZV/x95OdliGxrEF22cMuxNCIixOAvubk2jnzppfH84QUvBmQR5wFoGfdAZe3OCDI5rG/m3hR9AA9KTxIX+RxSi/OBarTc0Mr20TPSTHgCh8Y9AX76HcDA4jTfuio2KfFOmSQDng/twx7QLN14R63TD5SA1NzqJd7XWHWEzw6qmqQ9+HHY2v0gJYDi2nJfvtYOX8Q9GCcYKBOSYz5LAlolr/raemFoBZhUqq7iUc0Q4FTW76xlxiUpwH8oLahitgm6yCnLynRjX9ZL0QpHlVQsiSOQq34ZnHUw4Ii+J5zdaoFH6HFSjjI5Tio3wlM/8DnEyfqG/WPXcf92iqmzqtq2lv4fTXY4b3d5lYOMCdPxP9aVQNWWQjKlQFL5Iw7iyaFkHBOTb3RI+yr3DmT2tGxiwiLZQU+o0Ty8xrlEvu3xOdNHb6oyM/EqxZrznG6RaoECM/FRN6JIU1vtzLT0SzMhBi6IDMbFCQ+830FvOysBATC+PQibBfjWYIOnpVEjVBQqnEbf0Jkl8DSc05hjphCOAsUKmZ2nYcld13mHL8nPsDeWSzAHp/Wkba6mZob4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199018)(36840700001)(40470700004)(46966006)(40460700003)(16526019)(186003)(82740400003)(81166007)(83380400001)(316002)(356005)(8936002)(8676002)(4326008)(70206006)(41300700001)(70586007)(336012)(44832011)(2906002)(5660300002)(36860700001)(7696005)(40480700001)(478600001)(1076003)(426003)(26005)(47076005)(2616005)(110136005)(36756003)(82310400005)(86362001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 03:56:02.5727
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8917648e-41df-4ead-6468-08db18768b5c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7684
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

