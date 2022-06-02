Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913AA53BAAB
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 16:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235865AbiFBO1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 10:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235858AbiFBO06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 10:26:58 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2059.outbound.protection.outlook.com [40.107.96.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D0E986E1;
        Thu,  2 Jun 2022 07:26:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFii0umRjz4bWQlyKuh/eYZqppXFyBYPLHd7mahq01+38yxDA7roIm4X/VteuYTuEMhdpFH9n2WxDi289UX2yHB8+ghQapcUUJ/7DW5+bEPELCXmNYk/xxdHaA+Gf8ZcgMT/Nh24kAKtqST/bIUdk+U8x7q2ojINk3xwEj3FGfQcpxBzs6kxS9eVgvFMB+/qyga+EYMz6368IxGWqA9JQ6+h0ANKLMpCAJdLFxUZaN1lw+g1baFArbDNK7qSnmzlBw5MmG/M4i8XQ5Plow0GTM5AkTBCjiyXII4P9b8e39FXKtdNDplnptmw9DxyuHNS0eisNaC5gMB37JD8gsiURw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYmY8+gZNr9jBAMVyQG5J95vwz/PgYc3/Xb/dnLa+C4=;
 b=A+wMjfeXkW+w3u0Z3DtDBDcc1tIjZVvUO+hXYIT5jTYmYORDsgnb7sgW4LRAoyiFP3+KgmY3Ug2LSdxr7/59expvX8uh22SXsvbM6WScVRrE1V5GSlAxd5x/ytjCxe4RjiJ18K89a+ibnO1TyEDw+mV0udehceIVpDChJo8UNXRBUaeMMoGt1LcP/hTgzHrKcoxswYwxctuLvMOR5bpO01wnaU601PYo3JsF51JFmr2nUQAPVZfAMI/NBs70wik1H9J08nSAXWxPZ8IdjY7naqSmtdLrmgKa1K0Y/8KvsJezeddJTk9IRSqNyWLEA/2rgnMtn29DCMK54jr2rSUoLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYmY8+gZNr9jBAMVyQG5J95vwz/PgYc3/Xb/dnLa+C4=;
 b=VLrRDbh+wlemyq/woTeCxRyRsB6IltWNKdkztbpDqNYIA0ffYL829Am/CSVatvDH7qm/THLv5EXRy7fR8gr3XfEAbFD8j34yJFeWELZh2KYcxAwAYzAhy5gwf5yh/iqVnHV7tbSWl86lSP7VJoJTyC4MsQiPTZXd83aIgnJpSQ0=
Received: from BN9PR03CA0158.namprd03.prod.outlook.com (2603:10b6:408:f4::13)
 by IA1PR12MB6211.namprd12.prod.outlook.com (2603:10b6:208:3e5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 14:26:53 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::44) by BN9PR03CA0158.outlook.office365.com
 (2603:10b6:408:f4::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12 via Frontend
 Transport; Thu, 2 Jun 2022 14:26:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5314.12 via Frontend Transport; Thu, 2 Jun 2022 14:26:53 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 2 Jun
 2022 09:26:50 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCH 1/7] x86/cpu: Add CPUID feature bit for VNMI
Date:   Thu, 2 Jun 2022 19:56:14 +0530
Message-ID: <20220602142620.3196-2-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220602142620.3196-1-santosh.shukla@amd.com>
References: <20220602142620.3196-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7adf057-53d0-4811-cb3a-08da44a3f0e4
X-MS-TrafficTypeDiagnostic: IA1PR12MB6211:EE_
X-Microsoft-Antispam-PRVS: <IA1PR12MB621187FCE18FFA4D0CF167D387DE9@IA1PR12MB6211.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s5vABvsx7oZLJ1jEuIrj+mWzH0Coo1CjHilOyCcyhk7jWcuah/pi2j1UNBUKNtuTZ/qclJvOvVnxBxUAdZ+S4QTDlJvb0kvjFb89+vEJkmSzBecqxLUsCOx4DQLrB9SZsXliv/0gXVtq1XNVNWHk8DxfpsPuffuyTXVe+cy38EWN/mmlF5YhbaO4jlS9h0zI2benQnwCXnQMaBat15tsHy31x7k5Ly481bTkhGAB9G31Utct0c8RmiL9f16e4O8pN3zlhi+WGm6JYt6WSi7tw7KasaaHUbRGAm9X8nVHnXuE3ohiLBtp3Akf79eEPK0aMxk4JVPmSbOCmaYOQ0KWTuv47geKfVHfbOphIvUX/hTSql4XKRKVYVESwhPaPy6CL7YcB9XbrMTeylOaH9iePP9J8DdY7RKr77KzT99/q9dhv8zYMWEWXdGQgwUku19buvN0Kg0lFxMCE+cb80228VLJm/c7E5y05Bd0F0m5ULZ5whhQBOpLAGD+54DCsVcPeCL+nlfdJbwOId6i5oUVgLWxNUzwI4XWBtv9Uu+hPemPLQCaiN7Py4GA3SA4jDH4FE0cP1go3PY9Bk36y8vKaYUqyF5+Lyo5aHy6MJZkMb1VNRfXWHNql5VIGZPrlexwjRpPq+jN1/tEJk4hT7ou9je6QxPcUe3hvuvnFIlY7eRgQ9uj8Qub8xrjnPzWZzQT84heX6a6XX8Ruf49mlFVJg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(356005)(40460700003)(44832011)(82310400005)(7696005)(336012)(47076005)(36756003)(426003)(316002)(2616005)(81166007)(16526019)(6666004)(186003)(1076003)(8936002)(2906002)(5660300002)(86362001)(6916009)(70586007)(70206006)(4326008)(54906003)(26005)(8676002)(36860700001)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 14:26:53.7449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7adf057-53d0-4811-cb3a-08da44a3f0e4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6211
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

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 393f2bbb5e3a..c8775b25856b 100644
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

