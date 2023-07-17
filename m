Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8886755A99
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 06:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjGQESO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 00:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjGQESM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 00:18:12 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8036109
        for <kvm@vger.kernel.org>; Sun, 16 Jul 2023 21:18:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPHAbhuG1hWZw8X5n6zvyF61rnouet0Z6HhSrSNs4y9zINailqGiRTe2Z3GWlPPGSVmHrPq5AI5a7K/sSwv6SfClVCyQzF566gB4/wra+q08dXLQ+7nQxXioqyZnX5+3TBPrnImARiJnLhIxMt+d/4doukBnnJKhQjicHI4lQqpIDyTr1MiLHEDYQihR5TXQqj3/aXvRRBvf7L9EH2+wAy8XlXWWZ1vHyB2oW8VCg08bFJf5Aq+NGtM8/lco1yIGd+mVwLBB5YzEVG6OiZEk9a7y359N9wGpevvy792CqIY7JIIzYFu0FBoIOu3KFs2EDdRqfb7+Y9veWMqIE59haw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y15gBd9HFVxPgjAEna6OHODzOOqskBmTtgT0X0n6rwM=;
 b=I2eqs9eDnOOOX94Ylmtp/MhVWvSH+Tx7Qxtq7PzQL7NESWwUPZb8VQh6TYotL6nc03hPvcR8XNcOTgIGSNYjIjgHG73qsFsU4g5A8Si0REhRZOoW9QrlkQ43pat57OPcO60kA3MxonF2z8yPBv46jeZACGUafaOXA0b75zeUeiFlF/oSmMvwazwzZR3t+k1n9R+/3YmQGS1cHw60pyANpC91R3DqLSL8z0lz9JAkEMmxwYTazc/fXJOVQetd0NKH+eDOVEz0Bt8zYijTavqawCJ5JxeUG5B8MKu6cmK93Hbo1ngUUmz8HpxlfT4sCB8e6P3uNUA+cgC/ie5q9Z3ZnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y15gBd9HFVxPgjAEna6OHODzOOqskBmTtgT0X0n6rwM=;
 b=GhOy3MMmVeN75Xnh/astMLTVEQfXCPYMfG9tLjjk27GgsfdCGPF5aDeAUd0HXJGZYagrTAfirHxJ/bU5HFF5CZIe/OQ313wcS/QngzhHrnV3XQWxflyeIxdlq2Daz1k6TYWYlhTgc4xrd457Yu1x035GDS09o8cq9rnb5L/PQh0=
Received: from BN9PR03CA0358.namprd03.prod.outlook.com (2603:10b6:408:f6::33)
 by BN9PR12MB5355.namprd12.prod.outlook.com (2603:10b6:408:104::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Mon, 17 Jul
 2023 04:18:08 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::45) by BN9PR03CA0358.outlook.office365.com
 (2603:10b6:408:f6::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32 via Frontend
 Transport; Mon, 17 Jul 2023 04:18:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6588.32 via Frontend Transport; Mon, 17 Jul 2023 04:18:08 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 16 Jul
 2023 23:18:06 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>,
        <thomas.lendacky@amd.com>
Subject: [PATCH] KVM: SVM: correct the size of spec_ctrl field in VMCB save area
Date:   Mon, 17 Jul 2023 04:19:03 +0000
Message-ID: <20230717041903.85480-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT032:EE_|BN9PR12MB5355:EE_
X-MS-Office365-Filtering-Correlation-Id: cde4fbfd-3a2b-48b7-65c6-08db867cd375
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9nDjLyVV/nAVtxDwLslI7171pGlUN/IbyLkDHlzcyED+x3vo7lnZWe8VLjc56jSwf5tVa5QEDydcLXmTYAnyPB3rzByuKTNw+pzs3Q1/zAgWGGaMRC6UEr/fOhLun3fE+q8ImWA/7O96yMkFRah35hTcVa+YVMZZbyZ1Uh00xYkbIw06VPu/tjW13khTI8qfruG7otifNl7H0hiA/56mGat6mZ/iFXNIXHT+NkgX3BfISDRHTKIrifkH0VdrhxDBnfAyHy/Pd5zpGUg+rGGkdjCDvdRRLtaP34o37zMdSSk9yi42pH0Ta9rK91CQlEAu1PcbbdmW7SVvKZpd1cbqRjFpFsQK7q9KI6nZ2aGvy+juWZVfWoIvT6Fq4D7kro6U+l0obvBqNKOCJmEV9FhWYScLh55YvuVLAP7/JjHkeHfJxDk3JqIuG0xdpYNuYZMMEXu0ChMdcEuK/5dd0DvBqhpY+PJDPyA+jo2+WaPSOAFKiN2BOsbGV6G5kZx4gzfgXaDa6iPZc1HOGIXZy5cJBt/3EKwlr2QLqvy3bA4v8LqXxK/ztKjoPuD5SNSpZ4hgveFxNBb5eIPqOc5zrzsFpV01QlxfKFQr589qu5JO0da/aa8Yj0xVwjSLqTWMVzYZ6O7217gnOdG3eSPJC04Q6NhtgHtqQs/x2O62OCNig3aga4qBz+KtUnaNnYD76NDnRQXcCzzOU80yzn0f7jvOuxlHzgVEAgvdw8OILOzgWaYUTnJVYLr6w8CvokX3aEFdQZN127zlYA0nI6kD/eZ6rA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199021)(82310400008)(46966006)(36840700001)(40470700004)(40480700001)(40460700003)(47076005)(54906003)(82740400003)(81166007)(356005)(7696005)(6666004)(70206006)(478600001)(41300700001)(5660300002)(8936002)(8676002)(6916009)(70586007)(316002)(4326008)(2616005)(426003)(336012)(16526019)(186003)(36860700001)(83380400001)(1076003)(26005)(86362001)(36756003)(44832011)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 04:18:08.4497
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cde4fbfd-3a2b-48b7-65c6-08db867cd375
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5355
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Correct the spec_ctrl field in the VMCB save area based on the AMD
Programmer's manual.

Originally, the spec_ctrl was listed as u32 with 4 bytes of reserved
area.  The AMD Programmer's Manual now lists the spec_ctrl as 8 bytes
in VMCB save area.

The Public Processor Programming reference for Genoa, shows SPEC_CTRL
as 64b register, but the AMD Programmer's Manual lists SPEC_CTRL as
32b register. This discrepancy will be cleaned up in next revision of
the AMD Programmer's Manual.

Since remaining bits above bit 7 are reserved bits in SPEC_CTRL MSR
and thus, not being used, the spec_ctrl added as u32 in the VMCB save
area is currently not an issue.

Fixes: 3dd2775b74c9 ("KVM: SVM: Create a separate mapping for the SEV-ES save area")
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/svm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e7c7379d6ac7..dee9fa91120b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -345,7 +345,7 @@ struct vmcb_save_area {
 	u64 last_excp_from;
 	u64 last_excp_to;
 	u8 reserved_0x298[72];
-	u32 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
+	u64 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
 } __packed;
 
 /* Save area definition for SEV-ES and SEV-SNP guests */
@@ -512,7 +512,7 @@ struct ghcb {
 } __packed;
 
 
-#define EXPECTED_VMCB_SAVE_AREA_SIZE		740
+#define EXPECTED_VMCB_SAVE_AREA_SIZE		744
 #define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
 #define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1648
 #define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
-- 
2.34.1

