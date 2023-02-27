Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B1A6A39D6
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 04:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjB0Dzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 22:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjB0Dzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 22:55:46 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0FC16337;
        Sun, 26 Feb 2023 19:55:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IN4SkgnBEbhq4Z7iHNhqOkk70IH1LUNyarCnqPdvqnxtWwHmyNdCq63Hh/6uM7/gBXVqAi+JUJintXZQQ95KBYg5j6Oo5Udg5yEoZoO+f5HAey7QwPNj5WfC5prSL61kS1FvDU4FeXo8bDAYJAx+K8TYm0sGiwvT5Pg2OobBIt/Erm30EgIpsln+Ecn35Bth2hZ57uvqJbTbBVI6SoD8sQ2oqbj/KfFE041zAnVkDV/RsNx/nRJgsFDmTh7Mcyx6whbzE5lOO55YxXezierU4glAi3EP6Zr2ky80QNlSuM0NfXZ25dpDHTnhOIZBn5RbgTCiWgr01UfuxvtliXS+0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hu+vMnSbb0fu9eWMd7S5gFKKGtAFLqJlHCvzrvVxW1U=;
 b=IdCkxW/nFq7jC/uu35odKo4ub/zoi2Bbn+Q7QRWIKrJEIM4CfYVm7C+EcF+G9YTwGn2OvCxawqIGlJBAKX3AAUtoCJy7HzS9dTGTRAtLw3hmFsR9qRT8uERwYK0VYvDJzAWFgg93EjnTGOaVY5UOFOPKvD0sNFmj5efGZxRqRnO1rwXEyoIbQkuKsO5vKAm09WlTnCgxNOuRwSqqNxMmrrIzlk8WjNzmdYBYsd4HuKGpnOSkYauG8LXsFHgEyAeCgSl2Umxk+fpv73S2t3csN/eE7nXiw4QpwLaOVSW2G5VewDS/gouY+gKCum6xyC7O+kH89ocGhZ//LX57WU20Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hu+vMnSbb0fu9eWMd7S5gFKKGtAFLqJlHCvzrvVxW1U=;
 b=ezVjtalx2ZyCs4DXbsMp3Pg9zA0095Cu5EP8kM7CMCQ91189tuYSOAjNEVTDlJ8K5IcVezfq9DQwPiHVoa2Z0QqTyK9Zut9zhP/Bp2xlGtKTr7Hd5z85o0QNa98GF9sISnHhvh/uq1tDZ1Zo/vpMTFyXGgGm9zalANDyvk/Q0SY=
Received: from DM6PR02CA0069.namprd02.prod.outlook.com (2603:10b6:5:177::46)
 by IA0PR12MB7775.namprd12.prod.outlook.com (2603:10b6:208:431::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Mon, 27 Feb
 2023 03:55:28 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::7f) by DM6PR02CA0069.outlook.office365.com
 (2603:10b6:5:177::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.28 via Frontend
 Transport; Mon, 27 Feb 2023 03:55:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.12 via Frontend Transport; Mon, 27 Feb 2023 03:55:28 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 26 Feb
 2023 21:55:24 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv3 04/10] KVM: x86: Raise an event request when processing NMIs if an NMI is pending
Date:   Mon, 27 Feb 2023 09:23:54 +0530
Message-ID: <20230227035400.1498-5-santosh.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT037:EE_|IA0PR12MB7775:EE_
X-MS-Office365-Filtering-Correlation-Id: 774d1f8d-a8bd-492c-953a-08db1876772e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y89NWt7OnLgBOSmr2OE2MWgpYCf7cqiZbe3aVaUzG+pU2A4YQfFscRuCNNiJkzmNPTu7YqNP8T9Mj/K9ZQoa5lWOcfiD2r6jRUcLJbgmPGgG7UdhfltvBGseyqKeuq/X+IE8PJ0WZSEi4wMLiZ8qeLLMtg6jNl5WnHKpf3ztGAzB1lU7lKnXa7y+jKidIXohMebSOXK1fkZ8oEJLh+UWT6Xw8JCi6ccpEcmzBLOmr0DuvPFTejIzpzqOgkAY1Anu68ZqH+0UzHZAHQ4y88HT/KzeaY2xVdfJK+AKEHcdgo7WpJIOSQAJWeh88XubbuB2zHWP29UNUAA5l4C1HNFU8XO5X5yeoK3vNuJGOBuCjJXyNqI0MesvMzC5MYcdZSXFQDW/P1XsZKeq1n8FAYsfVNaVu1WbYNsWLYkdn4dUv4h/gCNyJc7h+emVfFfNToVzYRzYzqxIa9N/azbaJ9yFu2HG8CcV8/eAs1lhcGd0A/me15kdMt/1vznQxfMVQnjU6iV3a5XdqyZUyiaRarGArKK7AnDRhHrAJhAD3rAKjdONreJd9MQ0aA6h8W1gah5+TjvTOshtVLN3Pr8KYE8bm4wI+Mv3kBLzTLoiurnLipPVXhuH7hA1rHIjgrRWhS/VWzfx07ZjJhbf7WseK78yhDHnFadYekE7COoBbZgvJih8hVNWQkNptLNCkolfwX9DZE5bvEbMMStVqa2LJgeVF0y9N2UInIedeOYgIFa9RYk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199018)(46966006)(40470700004)(36840700001)(40460700003)(83380400001)(36860700001)(47076005)(2616005)(82310400005)(82740400003)(356005)(81166007)(41300700001)(4326008)(2906002)(8676002)(70206006)(40480700001)(8936002)(70586007)(1076003)(26005)(5660300002)(6666004)(16526019)(44832011)(966005)(186003)(7696005)(316002)(426003)(336012)(36756003)(478600001)(86362001)(54906003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 03:55:28.7025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 774d1f8d-a8bd-492c-953a-08db1876772e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7775
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

Don't raise KVM_REQ_EVENT if no NMIs are pending at the end of
process_nmi().  Finishing process_nmi() without a pending NMI will become
much more likely when KVM gains support for AMD's vNMI, which allows
pending vNMIs in hardware, i.e. doesn't require explicit injection.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Santosh Shukla <Santosh.Shukla@amd.com>
---
v3:
- renamed iret_intercept API
https://lore.kernel.org/all/a5d8307b-ffe6-df62-5e22-dffd19755baa@amd.com/

 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f706621c35b8..1cd9cadc82af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10148,7 +10148,9 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
 	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
-	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+	if (vcpu->arch.nmi_pending)
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 
 void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
-- 
2.25.1

