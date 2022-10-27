Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676C160F2A3
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 10:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbiJ0Ijo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 04:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234516AbiJ0Ijn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 04:39:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2089.outbound.protection.outlook.com [40.107.94.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CF417051;
        Thu, 27 Oct 2022 01:39:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZGZHpOcy/nELP3Rj/Io1TX7g0+sSCZLgKS4Y5Bc4iNtAiBjg9cCgXP8UJt8H4/f4dfH8XVMVcAglkcjZ+cnYT9YhJzsR7kn1AuSRNqlpcEoThvAwCEOTLlbivXRqPqicH2Ze+T7HZaaF1HRiE4jb2xNf9O0oXJ4x8kJkZ0dxuoeQvBXuYa/h5ZGP7PG/H9CPkqIV+xOsYneeCyIIqKKYOWQNtNMVBOmkgUdKx1UwYjRenYKnYykssIZSD4Qe/U+gUaWUmCINdbHNmDHq+BmV53PhCF8gES9+8o+pCTgqgKkxT2W5yL2SAGNaKn+mk0E+sIKjYpKxx6st5wJWIai6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zc1VLzQ8oGYMy0WgKioKJ1QWarF5XnyHYDysuvrnN1U=;
 b=afkbn5YOHFHnDSSYpls3yg6oXrEWaqjMK8GlL4bpgl/Fm4qF1XxD47Obwq3No/YpsugDED14bQ199JBPyTexAGPBVPCWKKYh8Pku/mQ6ZHyKIKJ/pKu1Zl9MlvgDnugl1cOVmORedEIt9/8XCGKagV+ojs1SvzrxalsTaGzdozCCU+ojfzdhcZzQB/j/cmjWTl9i4hmo3uavEKAAnX917y+eCBEmUR76PHugm/4CbBD2KnIVntXaYsyH0CtlYFxo0JBMy0DzvsXfaTlXyYtIjdLbH0t4RimWIDRKuIMVAMGTKGxduVHYEMoVn4XB0dUAIN+RrDY9b42G5LZOeDnsIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zc1VLzQ8oGYMy0WgKioKJ1QWarF5XnyHYDysuvrnN1U=;
 b=lgMaxBndbuos7XT+ttJEe+0RgxkXsOCKzbYPEDSJllRb0xqS9QBzn4i7a99u0WDQ6USLc/+iUnGIz4hvPcXE+0yNVzHlFcQpb+PCyxh4nYjyfl1TQZnuJ8Bv5NMkrCdLSHAO1bW+bzdr9cIUtZUs2AUhwbxIz54VSwwdkLwco4A=
Received: from BN8PR12CA0003.namprd12.prod.outlook.com (2603:10b6:408:60::16)
 by MN0PR12MB5906.namprd12.prod.outlook.com (2603:10b6:208:37a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 08:39:36 +0000
Received: from BN8NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::69) by BN8PR12CA0003.outlook.office365.com
 (2603:10b6:408:60::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.29 via Frontend
 Transport; Thu, 27 Oct 2022 08:39:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT111.mail.protection.outlook.com (10.13.177.54) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 27 Oct 2022 08:39:36 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 03:39:31 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv5 1/8] x86/cpu: Add CPUID feature bit for VNMI
Date:   Thu, 27 Oct 2022 14:08:24 +0530
Message-ID: <20221027083831.2985-2-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221027083831.2985-1-santosh.shukla@amd.com>
References: <20221027083831.2985-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT111:EE_|MN0PR12MB5906:EE_
X-MS-Office365-Filtering-Correlation-Id: 12ac81ff-9715-4269-805f-08dab7f6c75c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eFYT+IQhOhwfAJCemTOzPl8a/Y4jpVoqelH4o2eEXQvscAurkMfJIE3rW4bwTH+oYy0dJfs+XUht2w30yyZt734jjdS+wLR6VhhoJEiTQ4eTPH63WRUIHc2rOeUmpJQNACXS2RU5qmYqrRaFj+eflZvv9wCuHdHWFO281eA2Vit5jfnKN9aauMjJAHF7Xe2LeDBF2OXTAX5kFmjMoRfF+lpKMrqB0qAvGRokEfbNIp1xqUGEVH5qfDtkBTTPo1ByxpkqJdg8i8WYhdHbyvvilVewIDvwnD0vCtyoUKUo76xc5Cfsr1bzt3bbgZRwz37IY6Npkmot3y0YwcnlH88Uszt/1HUsKZmTH/mLnQj0emcoSR0FtzCv6vpp4iTxWh/Z81/gz9rK1/cxRuFAsAjhQORu9K28u3Pj6iU9/zzzRuCHWh1iVyZtcygZ9BfnPgb0H1wzwCYHGXcJxc5GmuhzXk6+8I7KN+bORiqSw/v56TjVW+Ao8KVfYcsfdLPsNFs2YdIZPOA4maQh5z6tcwhMhKE/PqZF4Lfz1/8x13F4kF16uQvVHE6cZkZXruc8/VNTOqd8aaPzWomrANqjbFGJe6d0IouEzfxJaUb9cYlaYecWgteYe7atBpWYQvrWTgqSoDaCg2wlON+8T2n5xR/rdYDVQDhkwWtnicaz+cCya08LzXl3hrEIOGA9B/IHe70NCRJy0FV8PAol4kbIsV6wh0byrq4aRhLqlGF5Edp++OASUsCl+fdzb9T08C//Oqpwmsrn7I689P2OYSti6i36FhSRDrFVlFl1d0zlBNhyHv7L02cLzFBVEtXfZfeMpIj4
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199015)(36840700001)(46966006)(40470700004)(8936002)(5660300002)(41300700001)(81166007)(26005)(40460700003)(82310400005)(36860700001)(356005)(336012)(82740400003)(86362001)(16526019)(44832011)(2906002)(1076003)(186003)(2616005)(36756003)(47076005)(426003)(40480700001)(478600001)(8676002)(4326008)(316002)(70586007)(70206006)(110136005)(6666004)(54906003)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 08:39:36.0443
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12ac81ff-9715-4269-805f-08dab7f6c75c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5906
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
v5:
 - Rename s/X86_FEATURE_V_NMI/X86_FEATURE_AMD_VNMI

 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index b71f4f2ecdd5..23bd69848d27 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -356,6 +356,7 @@
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
 #define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
+#define X86_FEATURE_AMD_VNMI		(15*32+25) /* Virtual NMI */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
-- 
2.25.1

