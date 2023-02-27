Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245AD6A39E2
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 04:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjB0D5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 22:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjB0D4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 22:56:55 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80801E1EB;
        Sun, 26 Feb 2023 19:56:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hsw2B1meAKB6lO8Hovo1RsR3ZfDBVPN2QqrtReyexMKR2F/jqFnMvgg4Nnch1Q9HR73zH7LR+jHJmTquI2DcNvxknLQ4L0LeED7yb8+wOB98hq0zPM6NHqLhYX4p2eNh8jHyFF5KnkfYipc54I4s4hNQQ9ZiKZJAzsHxR634g849mp7LlhS+/Rol8QeLYfgQLjuyEuCgKfCUG2ktqgPGCSTAaY3AAWaNA1X15/duKRFlCDNp5QO/cPpmEaNRsxDBg87qTOqyiD7a7r8hxkavgMRquS5DY8Qaq3AJ8mTZmxJNe0eNPO3ewuYo92Su60F7cbNoxKegCJ0T90iyC0u1tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZoJBnY5c1ZWHmeG/NH0VLZt3i7xb5uH/tahYI69Vkw=;
 b=aLy5nQLhdHnxb+7hyQ88NIBMlHH9CbbUk7t+vgU7qbAIOLvHim4yo1t2xADn0kkXqOfi7MxGsfHKVUS5Lz5UxoLhuWA1NUD58D9AFZMCOhuTCDwbvZBCYtY/fyl9vOM4DFYpBkNzxHNIo3dLtF4eHuoc3eNbLw9XJoBcO1hcD7ELkv//p/HWO6I2b5CHEuOw3gKUgj/R1ZJzMXxOTR1ehVOKjzG2fdk0mkmb3e6Di3yNCOBshqm7FMqdINSMsJRsfrPiM6jkV1IYu4bGjyow+b0XlcL8kz1f7iKZOBnc16ThAjrbiysVGIcCvjU87YzkjCZrfkmCAI6QF7/eg2hO8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZoJBnY5c1ZWHmeG/NH0VLZt3i7xb5uH/tahYI69Vkw=;
 b=EviJGANcFCZI4Yp+ksOITCuH7QLXGrkLU91xVCYQ1UoHJ7MVJ7J4LRsoNdK7F7jqE6ZEmTF3IuiKX6wgjkcOQAWYFmJ/8lCTg9yF3EtNHd4oDPlbC5+3XQtJxgOJCXnfhhO4spqKEWsAdGqgASx0uOir6L4X4j1005pce4Y88LM=
Received: from DS7PR03CA0090.namprd03.prod.outlook.com (2603:10b6:5:3bb::35)
 by DM4PR12MB5391.namprd12.prod.outlook.com (2603:10b6:5:39a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Mon, 27 Feb
 2023 03:56:19 +0000
Received: from DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3bb:cafe::ec) by DS7PR03CA0090.outlook.office365.com
 (2603:10b6:5:3bb::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27 via Frontend
 Transport; Mon, 27 Feb 2023 03:56:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT109.mail.protection.outlook.com (10.13.173.178) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.16 via Frontend Transport; Mon, 27 Feb 2023 03:56:19 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 26 Feb
 2023 21:56:15 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv3 07/10] x86/cpu: Add CPUID feature bit for VNMI
Date:   Mon, 27 Feb 2023 09:23:57 +0530
Message-ID: <20230227035400.1498-8-santosh.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT109:EE_|DM4PR12MB5391:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e8beeda-8746-4dac-1c58-08db1876958b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nNMglUPfGCHA/eHrWiUowsCW/jjHVmDGqnKRTuU0NNi1ZOExPtUPEPMg/DNhPx0FqoQLAzWLtS9Ne/LrkoBg90buEptbF6t16ZrMTBeBmAZd8Di2D22FW8CcuGmzrKvWOhj5OGhMrjZRAMtKV/SUVSktfPPTB3XTxjyD9roi/q3wh/CZeeM219c3UG6SF+1B4aTznfVazKnoQngLU2qtzXm8SDLxEX+q3rB1NB1wQ8fhvTxXUtfcUmLAeEIhM/9GWqNGDqas3OQVRUfeaxhgYjpS3x1a7K8HcXIkWgE5pM9Gmmqm+rzSzL1HUY0w/1p2kv2gopU5bN/PoPZqSOCHUED5txAbQRKTYWszkRm9mxkiYVX0bbpTVybyrQFje12i2W1MvQbhogwZy7G3K2qyMdOR+RxOUHJBnFDRnPBdXW3AoQcXCc9JLHoudp2vnw4q6LscMm/VpMzfX4CaHJq5atUPslyUAka4pfhDoo9DrEa1z0J5I2i37A1x3LYzhGZ6mzJD1r+ZwdzeKn4agIYN6lk++SHqSBT7qqtrHcY5Prb31mLE2KtJ9Au7Lb+ttcjiWcNROy3nmIBoc+AGf5yJIc66Z14QZ3gVuTyiIyEYZfseLfdo58mDVB7151MbBI41q5JVHcLm+UW85Se3uNx3TzuRSoykN6ZNjIAFgjxXW0grdp+dj8FzDmFYCwzBBOLshOWYmTCXpLQV5LVvnbwpc9h7P0O2SC58tF4/DGYwPX8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199018)(40470700004)(46966006)(36840700001)(186003)(16526019)(26005)(36860700001)(44832011)(70206006)(70586007)(4326008)(8676002)(478600001)(356005)(40460700003)(7696005)(54906003)(86362001)(110136005)(316002)(40480700001)(1076003)(8936002)(5660300002)(36756003)(82740400003)(41300700001)(81166007)(6666004)(336012)(2906002)(2616005)(47076005)(426003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 03:56:19.6405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8beeda-8746-4dac-1c58-08db1876958b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5391
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

