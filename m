Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6E74BD3C1
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 03:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343560AbiBUCXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 21:23:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343547AbiBUCXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 21:23:10 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2088.outbound.protection.outlook.com [40.107.236.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973863C703;
        Sun, 20 Feb 2022 18:22:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knpvPD6hjHAw1W1Owa95/MdLfcfp7K0ReWVSYZBwVWqVncxHOec8gVXvNTR0rlfh6oJJMYw/dtkxC9nBO+TVHpkCRkYTqj6p3ogFGF6nWb4ICygTLreUvnNrI6wMBvMuAVvpHqf3ppBXVaBgDvuTvbUX6UlGWgtSw/1+YD8J7sAYA9+ZseD+tGC6TQNMw0ZoRiQOZVT+S7ZmX9HaTCuJ88/BmPWIOyGSbWv4WcKYjMBg6q3d4f1yIrvEMCVVEqtU1N4lpEn2jhrZybvrGeK4B3fv6WTjeEhaImTvlxZ9+IMy4oOZQvglmGQfDfV7bBvgVOxL2cpT0bmVFiuGMCFdWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Vm3YWJSr9XgNlXi/0r156Izh3foBBIHrBhr9oeHIZU=;
 b=RGRNLy7Duv07So57tGqjQFSmkO3qW74It/09qfG9HHbTx/GcH3V6zMTq+lj8WdwNwGLYJJbMEiRK6MYchNzdtnsjMcd3k6DcwNf9/0LA+M9x25CxdGaM9CzsjkrZnvSIUfFWFR77POscuZR8WwU9ugQT3rzxrtlggQaMKQVpGxULYyK0LMCGDGrtMhWm8J+2VRFY2KPPT7czMMD/t+A+tFl70UmIE5x9LOWKG8QU/EtcaNSYrylQyjWuW98sAVPbQImi2fUECUu86nDtCRo9+YMuzVPPB3FtAaqUvS1jccXDlO+zJqPoKDESxW0sgAOOyAzPEc7SOR5QAa4VMHHXWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Vm3YWJSr9XgNlXi/0r156Izh3foBBIHrBhr9oeHIZU=;
 b=gDs3ZlvzrILXz1YvNJmgIt/MsachA/VWHjk1VMlz7cfJ2l/V9A/a7jntntXDYkXKUQIniPZ8dMLcaREV7pmWZbTohBAH4hf6A2o2Tht2etRnRPPa6vLBbQp7jYzEaVlVqkQrA2wexPeH+wL6nex26y0mvTKL8YZhw9gZ4whabGE=
Received: from MWHPR1401CA0008.namprd14.prod.outlook.com
 (2603:10b6:301:4b::18) by BL0PR12MB4994.namprd12.prod.outlook.com
 (2603:10b6:208:1ca::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Mon, 21 Feb
 2022 02:22:46 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::1c) by MWHPR1401CA0008.outlook.office365.com
 (2603:10b6:301:4b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.20 via Frontend
 Transport; Mon, 21 Feb 2022 02:22:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 02:22:45 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 20 Feb
 2022 20:22:43 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 02/13] x86/cpufeatures: Introduce x2AVIC CPUID bit
Date:   Sun, 20 Feb 2022 20:19:11 -0600
Message-ID: <20220221021922.733373-3-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32ab0b4d-5cda-4d35-755f-08d9f4e10c3a
X-MS-TrafficTypeDiagnostic: BL0PR12MB4994:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB4994EE9D82D2914C6661BF56F33A9@BL0PR12MB4994.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3oDA/84ehfMFSPGbT2Bd/151bF/Btv0jbMSHroYrQzcEHYn7yovlVrhZKPEz1NBcEaxBvTkdaajlAhHhHduPqeSnUQZ2J6pxpvTJPC6nevnCfQELOWF61H4nRrNNnxFhDmQFgCdjrwmjAhHsj1OZXjCcyBKjNDZNYJi6twVabbTxphuKhXVNufMo3EF1D+Ygxl190mR+XDKrSOUakGlrig8eMjk3naTMKY/2xTAyxtkUA3z4tc7oiLlf+9IadITtR3sVCG7GXFKS62BaDjOx7amqXbB/M1SA838giaoem51vHMoC7HP+Op7idRj5JG2lqPqQzzv6cdtml7SoZ3mY9lTxzkBhdRZ3lwj/b5S3VJHby5MSOd71PMkbgElqUJGEMrQlhq9Z9V9+q/pfsgCI1EAliDmdk87l2ajmWPJLfQn31lyayheLf3mmNzRr4ysj+LZKCKJhGxE/9zWIv3G+RRlKRhUNchKcoAN+uTJ+4P2yfnJ0Mp/3cYXoeIxlGQia57LC0RraH3G0kvSpoc9BtVlE3kKTEVLatClXbI5M76scNZPA/wzf3LRSE129rEuN7P1EOFOVp6GtqYzBk0uTFunZa8gTJgaDqFoD/H+tJ57lXjAP76Ox/2TMk3cuInwzFkRD6vpkGNTXdJLoM9EEHTbBvoSnXVD5O/KwZjP+kTWou69aQZg8jAP3jwuNkSWulo7XT2Xymee9euubzWRPIQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(47076005)(110136005)(426003)(54906003)(40460700003)(70586007)(6666004)(336012)(8676002)(508600001)(36756003)(4326008)(70206006)(7696005)(2616005)(8936002)(2906002)(5660300002)(81166007)(4744005)(1076003)(44832011)(316002)(82310400004)(36860700001)(186003)(26005)(356005)(16526019)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 02:22:45.7737
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32ab0b4d-5cda-4d35-755f-08d9f4e10c3a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4994
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new feature bit for virtualized x2APIC (x2AVIC) in
CPUID_Fn8000000A_EDX [SVM Revision and Feature Identification].

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 6db4e2932b3d..8c91a313668e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -345,6 +345,7 @@
 #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
 #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
+#define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
-- 
2.25.1

