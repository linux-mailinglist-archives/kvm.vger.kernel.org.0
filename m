Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00FC6A39DB
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 04:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjB0D4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 22:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjB0D4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 22:56:19 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2040.outbound.protection.outlook.com [40.107.100.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD9C1E1F2;
        Sun, 26 Feb 2023 19:55:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzKEUq72OyiHobnzaGF2Aqauu7qkOb6fWNpaoJD9rccL0mX1sH4oWDXuWo+SJ/ALPeI6S4XG+jy7cFKyP/BfRWAMLmEaflH+Lgjh2h8P2srIZ+t850niWRDsQ+Tinqsew/YXcsYTJUBQCKRBLvKxpNYKcNloDFKm6nldbne26eLjA7OsrOoPhn4sUiZAf6biRodo0IU+0s0Kz7gdsxZK2bjtfmsWLAr4tEdOagHpBNyUgHG1yOSS3mcZc4s7gckyHe6Em0OX6LjdB5rARRkTP8Z2aAeu3n/pjtgrDYgzSblV7O18EYo588BfbEByO4qjvUL+Hhp9tZUNzRARCAuCww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oR7zheTrX5qMmDFyKQ7qK0DSOkugApnTFBoUnooBEdU=;
 b=Pq7drIlduRhingl8Rxg770cTgeKQ0COBJYNj/nX8Lt0tM9iL7KJp/O8Six2dpPvZjSiEEoSL44lueLasxXKVD45jGJVhinZVq/6wV6k98VoaqvT+kADBvos4ClAFy8kCGm3CHWdp3/VgWSqDbFsjtX+PJd/BU5ausgdDPe7gvr1N86b5NJKWJwwPZU0yAfhpmzC2AJZCNUu6IVABhHcEAKTcwViG8JS9KOhyGYAnObrBUiTePaaJfrQTms+QC77h+yHh0Imt7vFRAi5GeVxZM8RXRk6vGHFERnN8MXYopoWEqB14fTk6AH85hhlhZU3uMhW294bXry2QfqOHslorpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oR7zheTrX5qMmDFyKQ7qK0DSOkugApnTFBoUnooBEdU=;
 b=st2iT19EZKSuCiGdFi8fjsh5YMxj2lTuaoDjYmDxj35Buw85MIGkslR8WsTfn52nFMyq+064Bad+jsLZ21CGoCTCxtJBI2OHki0bQEoga0LiilBqU8VRBb0o/cC/gZKSp6XP34ThwGHw2dJHS6JuqMzGM9RSDqlW/gClYTuKkAc=
Received: from DM6PR13CA0038.namprd13.prod.outlook.com (2603:10b6:5:134::15)
 by CY8PR12MB7217.namprd12.prod.outlook.com (2603:10b6:930:5b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Mon, 27 Feb
 2023 03:55:45 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::fd) by DM6PR13CA0038.outlook.office365.com
 (2603:10b6:5:134::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.16 via Frontend
 Transport; Mon, 27 Feb 2023 03:55:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.16 via Frontend Transport; Mon, 27 Feb 2023 03:55:45 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 26 Feb
 2023 21:55:41 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv3 05/10] KVM: x86: Tweak the code and comment related to handling concurrent NMIs
Date:   Mon, 27 Feb 2023 09:23:55 +0530
Message-ID: <20230227035400.1498-6-santosh.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT066:EE_|CY8PR12MB7217:EE_
X-MS-Office365-Filtering-Correlation-Id: 58129453-7f10-4673-956b-08db187680fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dNpwhXeYnKbsT+ugHgXmoVcDq07stbAmtnpcw8d8L5X9oZ8gydyWotwPv2BM5MAPcgnpSosqiUtUQ2L2voeoq8uyYcRfS3iQstnP8cbjY48XOw1ObnrCQtcDZtWXM7a6X8ImfhYVIgwtKzgnDhmiJ9jo4umDFcUI6+rJGuacG1cYgSGcF+EWQa7DzIe9bVEqUYXOBBTdtHsmIgbIdUEZZqKrpAxDmIAfY5cM6/46rVnSBlS6+tn/hlHT+xFh53JRN6kj0i0PlnUafDgaz61vmqjmBFz2+M4xEdAvTNDxP0BwqceGC28ZqW/0O7gGorZlA2Hfy9tH5w8hXBst1c0Af08IVdhszvdZmoIBhWzjb3GTD4r29PsK9XtE/DVIIokAFrAqFY1mZEMfStIW9RkarCBqt06ltxloT5vFdfP3keuhCV7d9KN6h2rNoqItSY6bWroBOkgPCIVuonuizOics8GG8I9cSxuSCmBr0DfSoQSKpVWxzZIk2d+sWpvWX+GmjuolPXoLiLL17hdwStVjdGgsAA45zU7NLhybdbKYuwGRCGXNoMsTe9xwi1LFzMtE5S6vZtedHKAJCL3hSm3ksZODWVC3VMVCWXROrpwLWhZLeyDP4ASLYpPTZXOv2OU5YKwrhuPvjIkjls92TlqrZbFn/CzSA5Y0DTObGP/0pCHeUIWtzSojRoQF/+wjTTY4gZBsVq2r7H7lm+BQzfQmaRuhA73UaRYUX92U+W/Sads=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199018)(36840700001)(40470700004)(46966006)(36756003)(40480700001)(40460700003)(86362001)(478600001)(41300700001)(356005)(8936002)(4326008)(70206006)(8676002)(110136005)(7696005)(82310400005)(70586007)(316002)(54906003)(5660300002)(186003)(2906002)(44832011)(36860700001)(83380400001)(82740400003)(81166007)(6666004)(47076005)(16526019)(26005)(1076003)(2616005)(426003)(336012)(966005)(66899018)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 03:55:45.1454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58129453-7f10-4673-956b-08db187680fb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7217
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

Tweak the code and comment that deals with concurrent NMIs to explicitly
call out that x86 allows exactly one pending NMI, but that KVM needs to
temporarily allow two pending NMIs in order to workaround the fact that
the target vCPU cannot immediately recognize an incoming NMI, unlike bare
metal.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Santosh Shukla <Santosh.Shukla@amd.com>
---
v3:
https://lore.kernel.org/all/Y9mtGV+q0P2U9+M1@google.com/
from Sean comment.

 arch/x86/kvm/x86.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1cd9cadc82af..16590e094899 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10136,15 +10136,22 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 
 static void process_nmi(struct kvm_vcpu *vcpu)
 {
-	unsigned limit = 2;
+	unsigned int limit;
 
 	/*
-	 * x86 is limited to one NMI running, and one NMI pending after it.
-	 * If an NMI is already in progress, limit further NMIs to just one.
-	 * Otherwise, allow two (and we'll inject the first one immediately).
+	 * x86 is limited to one NMI pending, but because KVM can't react to
+	 * incoming NMIs as quickly as bare metal, e.g. if the vCPU is
+	 * scheduled out, KVM needs to play nice with two queued NMIs showing
+	 * up at the same time.  To handle this scenario, allow two NMIs to be
+	 * (temporarily) pending so long as NMIs are not blocked and KVM is not
+	 * waiting for a previous NMI injection to complete (which effectively
+	 * blocks NMIs).  KVM will immediately inject one of the two NMIs, and
+	 * will request an NMI window to handle the second NMI.
 	 */
 	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
 		limit = 1;
+	else
+		limit = 2;
 
 	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
 	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
-- 
2.25.1

