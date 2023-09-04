Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0437479151A
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352709AbjIDJxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352694AbjIDJw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:52:56 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2060.outbound.protection.outlook.com [40.107.102.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89C810F9;
        Mon,  4 Sep 2023 02:52:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PwPTtfaRy6hRQrmOXLQmcfn1j1WmIt7i/0w6wlCy1hBpXdrEMJfYTHarOKKL4WfskHjFqc1OqrIHKdufkLUfrhi7tGRj4ppHjJIxQa6hvRUNaJIRYRs8Zf1IHJMIZLZM1hMg1RxJD9goT7X7RmUneAbg318/lxOeY5VPdZ/sQs/KQruFi1dDx9QiGAddvWY2xq1Dyttv0QKalb47WjSKBsFqGygioCwrBQuAytD1usvl72mxfMj73hHY3nIO4smvZkwXOYs3NxZEAHAu4iyuII7G94Sl7z4xdboaAdFCHKTq0V6y2a4ucgF41QBe/OpGGXvmpgUkws1K+c0pQnP6Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5wTaJ7P68HKOj3AH+oBfUjG8XkAAZaN3Ywkkd8MnCk=;
 b=htNI+LwPmYgt36TzMoxqLjgbnG/VwHETiULFBttCPb1J/E3YViUucbNlcYuF/Blb7yETBDtBVkYmYD1FwxxnBF1RwjxTrf9o+9nl4DzOGg3OZOIwi2PIVzjje0RMUXsPTzVvwp9RnoTqFLn+U9dpGGIwZuObDv//JCfC5V3f1VpkR81IWmmAlcnGq2LufT3/eEzwtcKQYxoDGMculnz+FXvPS/y05IWbpTT+75Qa1yVMZ10si7TkcPdwqcwKQK5J6FL4iGWhVmG0mmYqq2yCfaiet+hVKLsp3KuROODYAfFQMQwzkrcomXkrVbp2cdG7KZMLFQ+tXDy2vutIC+I5UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5wTaJ7P68HKOj3AH+oBfUjG8XkAAZaN3Ywkkd8MnCk=;
 b=ONptbe+iWRY7mtdmfD5k9TwcV3/1s2WsGbZpJZh/VfKBhiuHm4RA3/vEj+ezJvdf7aK8McDGr35dS7zhCH6O2o+uXqKhDA97GQ7szg7GMy1XBTw/IjrDiEtm6de3IRB2LGW3XvX0s5n2MigAr4JMMpKNcA8gwsBlZmoJHxbWjLg=
Received: from MW4PR04CA0309.namprd04.prod.outlook.com (2603:10b6:303:82::14)
 by DM6PR12MB4418.namprd12.prod.outlook.com (2603:10b6:5:28e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32; Mon, 4 Sep
 2023 09:52:46 +0000
Received: from CO1PEPF000042A7.namprd03.prod.outlook.com
 (2603:10b6:303:82:cafe::75) by MW4PR04CA0309.outlook.office365.com
 (2603:10b6:303:82::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33 via Frontend
 Transport; Mon, 4 Sep 2023 09:52:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042A7.mail.protection.outlook.com (10.167.243.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6768.25 via Frontend Transport; Mon, 4 Sep 2023 09:52:46 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 4 Sep
 2023 04:52:41 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <manali.shukla@amd.com>
Subject: [PATCH 02/13] x86/cpufeatures: Add CPUID feature bit for Extended LVT
Date:   Mon, 4 Sep 2023 09:53:36 +0000
Message-ID: <20230904095347.14994-3-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904095347.14994-1-manali.shukla@amd.com>
References: <20230904095347.14994-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A7:EE_|DM6PR12MB4418:EE_
X-MS-Office365-Filtering-Correlation-Id: 63e5f8ce-f26b-48e0-41a4-08dbad2cb134
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0AH+0GwY8cepTTeS1bDgmaSLbCogdHXWsiaDjuerwzAJlnhqPo/7I1C50K72kQzE3QdcnQNXNo+eB0fQkhA9C+yb7k8W5jK9KphzJjJuFmdmlPobKSzcvTOtPa3XhbBmlI7NZMCk88CJMaP8JT22vLcE+HosY7kddTwjK/MzqacQkspjgn5LBy4+FTTTMXwfuFs26RlkNmju1gJrs9JpgbDLYD2PijIgOfHZx7/Zdk8bUoIVjwoWMGQeoUuN5tAJxNUUKSdRzMnUIb33C61aCnaenBrbSFN3D8mzooK2ckR/6M+Yi8+XVDfXOA3xl6ThUXT3OJOBfU3+bmkYW0F2S+tXKwBq4h6R2v3/ZKlrKlF+1nres9sattQ/r3/2jluNxZXVq+zT85TQ3/sK4mArTG4ZeK23eQTLrzDupULamsr6oSA28wiHVrpNWsbu53h9I9fYiiNLGMOiRZsM16FA1V/9tNQ2Pf5gg335vr+ky6XsBHIiT5fBtu3MKVIe3JcBEa06BAh/WOUo8nQUCimgdcyQopkjfbRc3pzA0rEfL42I6ioZfDiPZvfuMQhF5Y1OGARFv8aj7wurbJIsL1duiodcsc5lqB2w0slqRou51R5WYHA0C3BXgL3S3NZMBtcFdYsJH0fDAw6UyCB9OnzD8K0nfGfNjXxMLot7NcUt1negpVF2qNmF+zdZJ9iEEb5XCUolIFs5X2aF4uhlozlUDw5Kq+58w2duvH5BA8oevFBNiEDxTDm2XrtT7zB1X0b7U0ABcIMMagrYIz4QqUuiRA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(136003)(376002)(396003)(1800799009)(186009)(82310400011)(451199024)(40470700004)(36840700001)(46966006)(7696005)(40460700003)(41300700001)(54906003)(81166007)(82740400003)(356005)(966005)(2906002)(36756003)(86362001)(316002)(110136005)(70586007)(478600001)(70206006)(6666004)(40480700001)(4326008)(8676002)(8936002)(16526019)(44832011)(426003)(336012)(26005)(83380400001)(2616005)(5660300002)(1076003)(36860700001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:52:46.4652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63e5f8ce-f26b-48e0-41a4-08dbad2cb134
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042A7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4418
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Santosh Shukla <santosh.shukla@amd.com>

Local interrupts can be extended to include more LVT registers in
order to allow additional interrupt sources, like Instruction Based
Sampling (IBS).

The Extended APIC feature register indicates the number of extended
Local Vector Table(LVT) registers in the local APIC.  Currently, there
are 4 extended LVT registers available which are located at APIC
offsets (500h-530h).

The EXTLVT feature bit changes the behavior associated with reading
and writing an extended LVT register. When the EXTLVT feature is
enabled, a write to an extended LVT register changes from a fault
style #VMEXIT to a trap style #VMEXIT and a read of an extended LVT
register no longer triggers a #VMEXIT.

Please refer to Section 16.4.5 in AMD Programmer's Manual Volume 2 for
more details on EXTLVT.
https://bugzilla.kernel.org/attachment.cgi?id=304653

Presence of the EXTLVT feature is indicated via CPUID function
0x8000000A_EDX[27].

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 7b4ecbf78d8b..2e4624fa6e4e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -374,6 +374,7 @@
 #define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
 #define X86_FEATURE_VNMI		(15*32+25) /* Virtual NMI */
+#define X86_FEATURE_EXTLVT		(15*32+27) /* "" EXTLVT */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
-- 
2.34.1

