Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947C351EB0B
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447117AbiEHCoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387887AbiEHCnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D706C11146;
        Sat,  7 May 2022 19:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EnrkHQp88xnO+WSQ3YyFOi154++tJ/bopOC0s32bezPw7E5yAnI76Mb8fgCETyZgpg7Kz5erHAQdnXUOZh0lON3WGu/KxtkSx2PpQEHJNwKDP7WJfAw9o+103TCubPh0ndi2oz7o8Dm+taE6m8leELRStQDRckx1glaZOjEsi/k++C/BEGq7NG0WcCr8loF8kkjiJ6jyWxXjR8YBMV4UMCFrBpR7GRntu9vSbaZb5ptx6xhtab0n8S9CxByQAJ/YBAhfVs9fjkTdolDMlbhbyoUQq8X9l+CVDnJmoLQCtAD3XfScf4GXvN1VgcDThcMlRbejHS7cOFj2LQt3kuO1yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1yK4Qa0zeGPeiFYUjxGppQ/ALcBU/cbha+9o1LSDrRI=;
 b=YGZvKBHl+BREhHug+CygE2oaE8YX3hItpa+tM414LDNe/g0Amnpb534jfMBvFLCKvDwWY4fH95vFbKbOLoFS6pR/Z8Q1gx56TmXAtUpIW21nNqkAMAHIl+HYBxOyrXHjkAWvHlbQGcw+x8islTRd4ykskdOs2v7eQj4+nsVzTy71/JAnsLlEGMoT4t+2UWlAPinPaRYAKknwVEPbo+PkFQr9NhqFB6UEHKLcKT5OZ4mFo2sPYVZXRDyqqgzmkNShSocLp3Hrpp8WHPwm2AiEVowrt2zMWYHFivD6q8TlX9nErHhb5h2bi7iOzEzsXaaS6mlZWzOxvFLB3EVQBogbnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1yK4Qa0zeGPeiFYUjxGppQ/ALcBU/cbha+9o1LSDrRI=;
 b=wauChpFf0wOwz5SPZolYgrQye9Ie2SRZOUPOlJTvQ6Az6/QBY6gqdFKv0zuuJEMUebldvC0jaV2n8awgjEMe/LlCNKPWxTsKQJeXJQq0M02zcwmd/w0WimHz/RDr1PB+m4DCp+CzzeF3LTxcFJsZDum9FpH2RMYM409XEZBY3MY=
Received: from MW2PR2101CA0005.namprd21.prod.outlook.com (2603:10b6:302:1::18)
 by BN6PR1201MB0259.namprd12.prod.outlook.com (2603:10b6:405:58::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 02:39:59 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::5f) by MW2PR2101CA0005.outlook.office365.com
 (2603:10b6:302:1::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.3 via Frontend
 Transport; Sun, 8 May 2022 02:39:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:58 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:56 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 14/15] KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible
Date:   Sat, 7 May 2022 21:39:29 -0500
Message-ID: <20220508023930.12881-15-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92763385-2e29-4d18-74b3-08da309c0b55
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0259:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0259379EF3C69164AC27627BF3C79@BN6PR1201MB0259.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IGkJeJYL4z61q/gGNPFYTuRrgOv8LC/p1/UmmveAiFOSjAbw2BhgH/jWi9k1STUF8eqzQwJDlkLTVZDu3FCcxbcKlxG1vP3OIQw76ydM9xEQhCsryaglovTdKSjvMxQb2JNKf5TcCjnLJvevWeX3gVirbimLxJauozncvTqKnFC/1bz2mOnG+7jKG4rsSrswKP1oHXyLWqY62P/yaIjv3EgTIXiozAFEgU0KQNpWsXfubzmwCNecoHE5V466GPTg/KRTDtUWXBeEkmhbac22GqMoWHl9ElEdhFoinh3V0/fmLvwQA0PEoVa+rjOaSBQl4JPZomWlVED8TDfTF8gojjB7nHqqraCBmNpL6brYQ8/dtaChhs4YG6dxD3d3ptrznhiYTVZTvCrzuCJHAy87IDsX2FlAQaHdQWmO6Q2RcP5y5UIZSgGXm6DXLVYMQEN/Jj2ak9sZ9GnYq2B5Sicaq/LY7nLk6d1kF+lNtwt+Yt0wOCZOyj3zPHFyWB7lsQWOk5CqHwwImCYCxRLkgy0UGvTLm3RUJWIdVRd9scOyIe7GDmfm4RyPp8MVIYtZ971ovcM/G1hBgBMOKaUKqpjVoZxKqn0xC/ps4ZuITVE2KOT/Bkg24PlH2V59Oeh03ewPxTSDkuSvQjIEIFrFUrUCO1CM9VmZ8grqVF9lqnRSYtNCWUIpJz+xkF8yXOMfiuLhnVmBp1XwPUhzh9tW37JruA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36860700001)(2906002)(82310400005)(36756003)(70586007)(5660300002)(44832011)(8676002)(70206006)(4326008)(16526019)(54906003)(8936002)(1076003)(83380400001)(110136005)(40460700003)(86362001)(186003)(2616005)(7696005)(26005)(336012)(316002)(47076005)(426003)(81166007)(6666004)(356005)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:58.7652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92763385-2e29-4d18-74b3-08da309c0b55
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0259
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ceed4b39b884..617dd4732a9a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -379,7 +379,26 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
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

