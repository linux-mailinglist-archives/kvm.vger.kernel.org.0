Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AF1519861
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345660AbiEDHh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345647AbiEDHgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:36:01 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2042.outbound.protection.outlook.com [40.107.101.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6542458F;
        Wed,  4 May 2022 00:32:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uw/bTeQThEFLVh1A8LjzYXHJgYSwm/ByEe3UJvPv1KkkANT+vtosntgsjHC6cwMxiRuVvp9diJea49kjI2JSE6pEvmCqawryrSbw9Vs9T9bJip0Ifk85NC8TqS2UBIulPvkzjP332nxX4UvympWewQLsxg910GDC+/0njJ2Lkvyh4xzLm57nxABlnrc3LXvZZ6qtQszyrKOXNPZHz3ilWYbcKIGVtgsMUHzCMUDZiSTJaZGOV65M1glfCob78DH446HD2s8vphYAnZIgAeAhbG16bawekQLwUzItUabrvmivwLSbXSz42R/YkOkTG6jp8ZumCTYR7w4hhw5kULKhVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DxEMAog8PiX4aUmttmMw2zb33gcOgtkamYN8hfraxhs=;
 b=b1YiaSSYEOSkIgIF+QDMiLuXAeL0dYtaiK03zWbUjz/XuxHH178iTX3mafB/SDySVhU7FF8zaeWdAg0i5zkAfs5Pg4J3JkRQN0Ag+gBxRZ6JW8FP5USRWBDh7aN9qWqHqRolcMpuEpXrNWgLwH7RtVPAcN9P/IAPxWEFOLdk4F58ChTvGN9aZwXV0QrmeEx5NEeGEe/i2mQHZTrtZUh/ukEBcWBQwbiT9zDLtubtlwy6+8UQDbC+wnkAHv50Y4+mAiXAOUoxLgivAgzDfDMktiUbjXiy4njUEQoJwRA4CAjkT2Y6pQvsD4parnx3yG6OW0wA9JVuW6IDcpQpCvmzcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxEMAog8PiX4aUmttmMw2zb33gcOgtkamYN8hfraxhs=;
 b=4EFRfwhLiKtsSIQU+laktbkIpZj0pqwHMvuoWadZtSV54TmQd0hqK5ZKlYMTH4nme2UdX41VLob+/hTamHDiA13Y/rPaIa5IC2ocqhWaxxogeDBOOs1XcqilToGIWXlFP7n9tDs1n/3+Q8Z2N6RfnnyeEqceDnY9tbd+pt5sM5U=
Received: from BN9PR03CA0420.namprd03.prod.outlook.com (2603:10b6:408:111::35)
 by BN8PR12MB3012.namprd12.prod.outlook.com (2603:10b6:408:64::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:32:07 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::a9) by BN9PR03CA0420.outlook.office365.com
 (2603:10b6:408:111::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25 via Frontend
 Transport; Wed, 4 May 2022 07:32:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 07:32:07 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 02:32:02 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 13/14] KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible
Date:   Wed, 4 May 2022 02:31:27 -0500
Message-ID: <20220504073128.12031-14-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8a638e13-6231-4d7d-7ac7-08da2da031a3
X-MS-TrafficTypeDiagnostic: BN8PR12MB3012:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3012C25AE0768FA247944404F3C39@BN8PR12MB3012.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cidlAzT1tvY4NZFYB2HoaNgm0vriXyo4v1MWoJC8U8SgB30dSbztfNOiGWaAA9dy05R2eDXyAPE5+QQYrJawWOepcKQ2UI+WA9V45b31vQbzxLW437YloOOwAhWlYzLuKwGPmV8pEHSmxjXvFYeATS6fZQVNcyf/PU/RTTDS800znV5lWBGARsB1WtjM8t+IpLx5TQWXM9Ed4joltyvtmfe6yN2p3VyspxgEZqwL62pPo2V9zw2sUUAvP5cH+6esUqK29MHGFHMhT0PMFrwIA9FVZYrEjfOAuQF5hQ1QRYQzL687mdhAhJgTudLWyKwiVWE/ZVDae2ZuSf2JKASUGiMNid75tgebEeI9wVCGXFddPCwYqpU7Zj1ruzJQ/OluhoWLIh5CmN5MO/+yiyC6lsDWJ73/GorQqepSOgwyIGHjRY10gqP2aI8ybbR1FL4bRFBrWcCcuOPyx8+v3CY//eg7DyXF7Tc0MBs6WC8dfJDVh5BjS+zIyiU/JUnEfYzbXSAkXF+MMDFgynbMEMILtFTh9Qu/ZnYHO4qkcS0wG66EFMcTkKnyN1f8K651JQrZ2XkaXySFOlmzfmbGSVVgqIl6wyndM+jvUXh1DesK+MbBAIjf3CMGSLJnoCgCrnys7lSBn9vTJiPxnBYGXIcPUImN9D02JFcCTEKJwdLk2ahRxJ72xY0NvOy/BGkJLfdQMR7h5fipXtmIIVkVBPHe4w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(70206006)(47076005)(336012)(4326008)(426003)(40460700003)(81166007)(70586007)(83380400001)(8676002)(36860700001)(110136005)(54906003)(2616005)(16526019)(1076003)(186003)(316002)(82310400005)(86362001)(2906002)(26005)(36756003)(6666004)(356005)(44832011)(5660300002)(7696005)(8936002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:32:07.6536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a638e13-6231-4d7d-7ac7-08da2da031a3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3012
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For x2AVIC, the index from incomplete IPI #vmexit info is invalid
for logical cluster mode. Only ICRH/ICRL values can be used
to determine the IPI destination APIC ID.

Since QEMU defines guest physical APIC ID to be the same as
vCPU ID, it can be used to quickly identify the target vCPU to deliver IPI,
and avoid the overhead from searching through all vCPUs to match the target
vCPU.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3b6a96043633..a526fbc60bbd 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -377,7 +377,26 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 			/* For xAPIC logical mode, the index is for logical APIC table. */
 			apic_id = avic_logical_id_table[index] & 0x1ff;
 		} else {
-			return -EINVAL;
+			/* For x2APIC logical mode, cannot leverage the index.
+			 * Instead, calculate physical ID from logical ID in ICRH.
+			 */
+			int apic;
+			int first = ffs(icrh & 0xffff);
+			int last = fls(icrh & 0xffff);
+			int cluster = (icrh & 0xffff0000) >> 16;
+
+			/*
+			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0]) contains zero
+			 * or more than 1 bits, we cannot match just one vcpu to kick for
+			 * fast path.
+			 */
+			if (!first || (first != last))
+				return -EINVAL;
+
+			apic = first - 1;
+			if ((apic < 0) || (apic > 15) || (cluster >= 0xfffff))
+				return -EINVAL;
+			apic_id = (cluster << 4) + apic;
 		}
 	}
 
-- 
2.25.1

