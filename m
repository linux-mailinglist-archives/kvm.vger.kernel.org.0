Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434216A3D76
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbjB0IxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjB0Iwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:52:46 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20611.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::611])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8351EBF7;
        Mon, 27 Feb 2023 00:45:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VyB+WpaDaEiHX3Boil9LPddzHLuSofNHnHKxSCCjQX+YGhFRLo0+0O0pDV9RGyg4hnTJAuAq7HZSWECqb+ro3ccVo4XxHMaoXMhADYt5n4rp0dV4aPBEB7fp2/os4V+92AFRXxHNcVF+7PPtR7t8YnFOkVftrivhYtypqMfM6miS7y11O2z7OPqa08Ae4kgke3sVeoPkg2CJHg+RsDG9J0XvpveTOJs8hnG3UKeP9jAkwcsuePZYfPVhByrrStlhF/+6RiwzXlHO8/MBXvnOXb86PcPphMKDT6xKKls9JQjcHAfasKEP+x7NoP5uevFIHmDXI79P81hjU2pLiZcBog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZoJBnY5c1ZWHmeG/NH0VLZt3i7xb5uH/tahYI69Vkw=;
 b=HPmGlwMQTpsi1NMRsMXM3m/qlBNP2DyQ/ZI+HzRBMbVyhFcmDnsFgVhXQOvKeCw2q5BczDy9HjkVBWldg0eM0F6bmXi/9dUdT9+miRp+hMROXID2Uu/EbFqVZRSsfAcVkSCgAiyLb1TYtpUG2Ue+35/KBhsd4HJ79DrywJz9Wf5KqxGroeXaqhNUQlpdOOdNqWowdgLcCaArfpNSaRBFyonsI6gzEZLLlmSAf3ZUjSV2NYQ7Cj1JKngIcIZB+4f/BxNeU0mqLlWsSKrj+Y+x5Gg8JUqcy57v+8WKtcQ5N5uhPSHsmtNJ2eBjd+ZeUJLzvYJNr6QFZxUU/CW6rIM3fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZoJBnY5c1ZWHmeG/NH0VLZt3i7xb5uH/tahYI69Vkw=;
 b=2i+CezfS3JsBcqyB99gBSxOcLwZYFmzCY70cBrfQpXNAA6GTr5lRZ6pa6OIDdtsDJ1UaVcjg9d21g9PInxYV71j8S9uKO2QFzQEqTf6QVdZtL34vSNKJLwy3WiW59zmFlDjEXtXFb1rzs8ROHDFleKHJGq/244yv2MqhMM6AO0s=
Received: from MW4PR03CA0226.namprd03.prod.outlook.com (2603:10b6:303:b9::21)
 by PH8PR12MB8430.namprd12.prod.outlook.com (2603:10b6:510:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Mon, 27 Feb
 2023 08:43:59 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::78) by MW4PR03CA0226.outlook.office365.com
 (2603:10b6:303:b9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.28 via Frontend
 Transport; Mon, 27 Feb 2023 08:43:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.16 via Frontend Transport; Mon, 27 Feb 2023 08:43:58 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Feb
 2023 02:43:54 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv4 08/11] x86/cpu: Add CPUID feature bit for VNMI
Date:   Mon, 27 Feb 2023 14:10:13 +0530
Message-ID: <20230227084016.3368-9-santosh.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT033:EE_|PH8PR12MB8430:EE_
X-MS-Office365-Filtering-Correlation-Id: c0f226e7-fc0d-4ac6-a7e6-08db189ec4c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZKLCUgdd0JWRnhdxmsS3IgIIGlw5rAT8csXkbFWQTHNFxWxbjZaBUwNF+9I9Kvy8glrQClK6WYmQg1flVKPA1pXR/2oqEech7WDXiP7gxbSCXPsrx8YBORC017vLRX7knWhmJplFgA6q4L2IXe3WgmuYYdhp6wGZgvaF0pYf8b3Zq8PQJP3AKHGsPqzJtt6TGYsEXOyUYbFKD89wnif+R1P0wGhVrqowimPuwLI+DnkjeZIDEUOx5xk3L2PpDYRRgzO1dij1hOVXFinT9vDqS9LkJrueNTNxXsnHTQxQuBPk/daWUlCAEqA82l96qoHklOMq3Ho+On13s9sNeJYaQXTHxHW1wR0sNfat06kQDaHsHFgouQBTyv8t8AlL9Abhq7qWlhi/CnuvZ8ec+ALdTWP6A48RR8UdnD2fqk7t5lZKL4z1BbUVuY3Sfjw/QR6fX2Hfvg+kUNfAm5hSGh4S7wsdkHJzZiBuIsQGWWffjEDOjVohpZ6FsaJbNPyEm8Q1Mk0Qbt3UOvjCWrpI5np/MoM8kdKK4gmkazm1QVNRYJcWn8tALyqDqv5QelwzrinFRnqCrfLp/jprY7w37inKEg1Ziec5dyo1ntDz4kR6mKv8bQtu6pasmelzu+F32Q6h+Yg2aVfOxUnVPVwD84rOM6F7jeDbMJQgy0uYr9XNjQMCa/dC28E5ABT0VAQK6ZXJqrUfozRN2f034P4A4ncTUbJ0A7NIrp3f+ya7Tyr30ZI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199018)(36840700001)(46966006)(40470700004)(44832011)(36860700001)(82310400005)(426003)(8936002)(5660300002)(47076005)(82740400003)(2906002)(81166007)(336012)(2616005)(41300700001)(70586007)(70206006)(8676002)(356005)(186003)(16526019)(4326008)(6666004)(26005)(1076003)(36756003)(478600001)(7696005)(54906003)(110136005)(40480700001)(86362001)(316002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 08:43:58.6550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0f226e7-fc0d-4ac6-a7e6-08db189ec4c3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8430
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VNMI feature allows the hypervisor to inject NMI into the guest w/o
using Event injection mechanism, The benefit of using VNMI over the
event Injection that does not require tracking the Guest's NMI state and
intercepting the IRET for the NMI completion. VNMI achieves that by
exposing 3 capability bits in VMCB intr_cntrl which helps with
virtualizing NMI injection and NMI_Masking.

The presence of this feature is indicated via the CPUID function
0x8000000A_EDX[25].

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index cdb7e1492311..b3ae49f36008 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -365,6 +365,7 @@
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
 #define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
+#define X86_FEATURE_AMD_VNMI		(15*32+25) /* Virtual NMI */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
-- 
2.25.1

