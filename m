Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2403E56C99B
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 15:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiGINnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 09:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiGINnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 09:43:12 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6C62717C;
        Sat,  9 Jul 2022 06:43:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EAhp7Z68n2Qczj54cGhZlomNrUE8NLggS2s2H1W3Dwwc3baMVYGJzHlit5IbAEkNzEJtxg6N4TL/8IGH6/+NybqPlKPq9OAFlUXkltrppNCaSkJDCgCYU3p+VMkT9DR2Qi5SV1VtMUTBHSN6NJOF/z5r0jj9mR3cz5Ez0EWOhrXEtxz7aBCkYvnKsvNppoh+d1NcshtBpQoXjPjaFcGSzJ2FlRDYmeeOC2Dxh2muS7MUqGlQ55KLk6Z8OaXfWaoxGcmzXoXQeOmrLinKGNq3B+jEa6+Cpc2D5GQwp30f6J29vi0m+OzU7q6t4NeQhFNLaGkv8vSsflpg9zVsmGyJpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8uX1WWhMQFWuijUEv6WU4G+ruoPpAohX1CLqsKngrM=;
 b=AQCiVvlYT8ZFSArJ1VOFzK5IMEkAw5OQLBJLyJGCoOck+Jsk+/Dc29FCB4xL53lTF+64O4Tm/gPImqF5OGVg1/r9ieixPl9p/TIlvC5drG/3flWEP4o5DmjFogdt9LYMsZMlGZv9FAr2VNK/qaIATk3kXMpsxWvqKVzMaLPU9Kj2ZAazHS2Y5/r+t3uUTiH7qA72b/cVMkw5MzOvCa9aGIYcqrMXE7tD/gw6kz0tHLwP98q6lqtvVvzsBeUwimuepknCCCwnUMOJZ0ZvvZMNFyVMESK9DmTYinu41MCdEk3C7wFNMll1wfCnCAjwjNmfQiiierRUpjMVlmvKHYnKGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8uX1WWhMQFWuijUEv6WU4G+ruoPpAohX1CLqsKngrM=;
 b=anYL5pDLWz/suVp/RNX6CGVP1s4Y24EWt8n0wIzL0kSleDEpzLkaRtwGgXe+sXQfiWntXs5R4Sbg4b8UPDQc/VYZY/bt63ogQWJUH47374Qj/1ne1g7VZ/CQAFczr6p/JJWtPbiKYTEwoyWEyZUwwlX8KPwaoso1fCtkh/DfnPQ=
Received: from DM6PR17CA0031.namprd17.prod.outlook.com (2603:10b6:5:1b3::44)
 by DM6PR12MB4044.namprd12.prod.outlook.com (2603:10b6:5:21d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Sat, 9 Jul
 2022 13:43:08 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::a8) by DM6PR17CA0031.outlook.office365.com
 (2603:10b6:5:1b3::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.22 via Frontend
 Transport; Sat, 9 Jul 2022 13:43:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5417.15 via Frontend Transport; Sat, 9 Jul 2022 13:43:07 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Sat, 9 Jul
 2022 08:43:03 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCHv2 1/7] x86/cpu: Add CPUID feature bit for VNMI
Date:   Sat, 9 Jul 2022 19:12:24 +0530
Message-ID: <20220709134230.2397-2-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220709134230.2397-1-santosh.shukla@amd.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ce48386-0a0f-4760-7016-08da61b0f4f5
X-MS-TrafficTypeDiagnostic: DM6PR12MB4044:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GWyfXYGzz1elvdAgTsl981dMkqfi8RpXcds/lsQ1kqfpDtW+HBEu7pnbRAvtEzwuDzDUjhnq+KYvUIiBDHvU7QRPHIS8liulNQWm00RIS3KU/F88USS2CbnR8c5MaJNlf+5OIOScX98nrvrR/AwoAZ3dq5+V8yd2YVOjJ2jXbtHTohTmc5F3aqA3KSrhKMpR5iONsu0cZuX3/I2Uhglh5CVKy6S6DnOKuNJflxamnOAXuxu1kLECJ+VdzvjphC8VqjjtdiRuow6qbyK9UkY5IDrlcqbchCMpnCM1y+nkqeiVu2yvcf1eK1huPcqMYd82nsn30E1cxWBz1y/xU3WBg+fAOfaHAsEYgdse7sRCyq9bzdjQv2l8V1rf3+xWGqmFqItJqE7bWstwbek1l97GQ7gT4Y734YGQZttL4/Ey6H09Q8UPGk7NeTOCFlcdesvpmU6dm0w81QDF5WTJlMenq59mQIEdEy9uXeO0Yk6s/73GmS1gfNDx/peABrt8WSTyKjMBDrLIh1tbf4hUZvpWRPKGXPR2uspwwKkrvzIzVD4hfrgbOoBm7D6gtRdx0SsJXKTvnMPqjnMPq8p4MLXGyM2v70MgQEdLRZQIcsc/6sZad8H5P5DxGdHZCaNk7j+2OCQub9m2NOWaNSoA6lYD6AUhe6g+7gp4u4zN2F7PaVIGNTDW67F5WMBUVSiAEmGwh2WMS3NF/j/v8jHTUHBgxuOoTBWVwpBHcEPNup6wmC04ToDOF4KouHyrKK30LlMwvmdVmJdban0Xzd084nJNc0ZfJqa6eKVjqOZ4gX6MwRyfzxA1s1/oRRds5BAbrCJmd/+z14GsBx5NCOoawyFR2/TtBe0K6US5D33XiV5n1o1eenCgLt9E5AwrR3eErabr
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(376002)(136003)(46966006)(40470700004)(36840700001)(336012)(16526019)(47076005)(41300700001)(36860700001)(6666004)(40460700003)(1076003)(426003)(34020700004)(26005)(2616005)(316002)(7696005)(6916009)(54906003)(2906002)(5660300002)(8936002)(81166007)(44832011)(356005)(8676002)(40480700001)(70206006)(4326008)(36756003)(82740400003)(70586007)(186003)(82310400005)(86362001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2022 13:43:07.7116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce48386-0a0f-4760-7016-08da61b0f4f5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4044
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
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
v2:
- Added Maxim reviewed-by.

 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 03acc823838a..9a760236948c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -346,6 +346,7 @@
 #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
+#define X86_FEATURE_V_NMI		(15*32+25) /* Virtual NMI */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
-- 
2.25.1

