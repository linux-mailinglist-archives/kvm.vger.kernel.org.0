Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307D0791536
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352702AbjIDJyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352716AbjIDJyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:54:20 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2053.outbound.protection.outlook.com [40.107.95.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B50210EB;
        Mon,  4 Sep 2023 02:54:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXk1K2vNlzGaEyw53aJVLQ7DhXtqi9go/WKJwoUpbMqOxu8ze6erYlsmXRwBm4ItaPyGCNeLE1KAEkAXE2jpt4ooBifPjRdHeuwpYKxTrXuwN3W0/mW5DhYcbtnDhUyXQTOhFP5tUAKuYzYhL3iQxuhkKzkYYZ3vOSTIue906oTMlaNDKVZlV4NjR57kiiqXDjX0gE/0uToNbrxDcOGWRWIkNHsKFNOBV73vn3WT1ZhlgtTee+ikA+iqzpVF+3ruAAcWPLjT1jwRYgZ77qXzCG0CF9ONrblgC8M/i91/kNLZK2AP4QmK6JEUwVFNdncWhOSGbCiY7x/1CcLDqIwPmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Q6LNu/5ClsQhSnReOrPbTdIDenfiu9se9dsmIlvtns=;
 b=Of4Rh2EcnMBtrExQJuwMFWkvTHkdr3w9JEd3RVZcUofYzlSTBeBDaViT4hd4fNPAgngUqNFJNWKaLqco1xC5wLhEqrfaRey1j4eZXCVhvwAv+DAloOvCbl1k2Q7sGiIPiu8j1ExFXtKKAwr27G6KKlA6tnXIwMSQWyuQl8gQdjsMsYePRPAcbhPKrb9Y5CnhekNX6pBLJJclTxTvOPTd9m+welWeM1DFQr/f6d4cqt+SdxHiyAt2fKEw0Sx2HRMHPRxfy5e4Oj6CFxjmdL47zXLEt6OBTK3rgDxe23frbeJLLv4qpdf9CD7WdcJg/8qHR2ZGmHenpw+JxP8JtPEQrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Q6LNu/5ClsQhSnReOrPbTdIDenfiu9se9dsmIlvtns=;
 b=SJoVnhsuCmXL6JMXekBF5owvq6uaGbFpSOwJY1LXGkcU/8rlSz8UGCg0Rw1U3qX+uNq3pdEVn1K8Upx9dM7IAT6Y+jWHp2vN8mARBEuiGIvGj1MlC4AJiQP7ktKx5Usb6Kw0uajZu650mKLRXWPPC1+xfaBYFSGFp7gUfQq9L2o=
Received: from MW4PR03CA0156.namprd03.prod.outlook.com (2603:10b6:303:8d::11)
 by SN7PR12MB7855.namprd12.prod.outlook.com (2603:10b6:806:343::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.30; Mon, 4 Sep
 2023 09:54:02 +0000
Received: from CO1PEPF000042A9.namprd03.prod.outlook.com
 (2603:10b6:303:8d:cafe::62) by MW4PR03CA0156.outlook.office365.com
 (2603:10b6:303:8d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32 via Frontend
 Transport; Mon, 4 Sep 2023 09:54:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042A9.mail.protection.outlook.com (10.167.243.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6768.25 via Frontend Transport; Mon, 4 Sep 2023 09:54:01 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 4 Sep
 2023 04:53:24 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <manali.shukla@amd.com>
Subject: [PATCH 04/13] x86/cpufeatures: Add CPUID feature bit for virtualized IBS
Date:   Mon, 4 Sep 2023 09:53:38 +0000
Message-ID: <20230904095347.14994-5-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A9:EE_|SN7PR12MB7855:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f0afed9-9949-4c5e-db51-08dbad2cde2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mMJjJUEAsiHG/bYY0/uIYkDT5/uUbDfSp/S+UNxFFdO/nuGwpqjb6p4hYfumpgZrC51Ae4GiA4gvxp3oDTEepgZI4rbGNYUm2Dm3ZUbJBOkK6gW4d9JqTR2FWp4EYQWEUysCwPcczFk2V9AAScGVQ1eyUFCqxb+eutmlVqwp3s240ZljQff+0Z7d9hmApMfYCoYHT9Yq3khU3BxOTNxVYX4Rsrd9Ww/S+2DZI1jW7CtF8NeT5feG6bvtZ0yaj7DCf/fzor1i8WS46B/duM/EmNDk7mRfy0wB0HlyShznVXGGFdZEd2u+AG4hEP4rT40C06t1ow6/ENMU3AgNY2A417a3B4laiHts4Ej4uDuH4DYds3Y2tIXenDnQbVYqEyINU+5qkJ0k/s9klpkYT2lB8foPbPNJY/Wsa56/tQ5Wzq7bg7ZYEY+7P5N/kdx52RaR+eJH1aqcl+KaMLdestGC1izmKQYo8sDZ8aNRAdblhr4x82VL5vp99U4wKHLLaFOYo16FFIfxE8AYC6GgVlos+prWdJ4fPUv4QRXHOHgzyjZ7px2anSAsgNr7IHfRldOPpzEHFf8MnOHLFi9alm+OdpTaP2UHtrj1DizLRrK03XnrYB+9z9p+yL+l+8et2msyUG2jrKXKbNq5m+D8/Y4/uOOTEe4gZZ7zetmsKuRon1/4lAe8L6cxd7RM8CZuNiW+0R8ZqFk3qI2+hb0gTnzvD7DCnTvZ4XoFUHbipwumDvp2AR/7cAbXEQ07YkvpTOqspwoSrxR1WfIWOX7wahBZnw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(346002)(376002)(396003)(1800799009)(82310400011)(451199024)(186009)(36840700001)(46966006)(40470700004)(8676002)(8936002)(5660300002)(316002)(2906002)(54906003)(36756003)(110136005)(70586007)(70206006)(4326008)(44832011)(40460700003)(41300700001)(7696005)(36860700001)(26005)(16526019)(426003)(1076003)(336012)(40480700001)(47076005)(81166007)(82740400003)(6666004)(356005)(478600001)(2616005)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:54:01.9208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f0afed9-9949-4c5e-db51-08dbad2cde2d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042A9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7855
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

The virtualized IBS (VIBS) feature allows the guest to collect IBS
samples without exiting the guest.

Presence of the VIBS feature is indicated via CPUID function
0x8000000A_EDX[26].

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 2e4624fa6e4e..8f92fa6d8319 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -374,6 +374,7 @@
 #define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
 #define X86_FEATURE_VNMI		(15*32+25) /* Virtual NMI */
+#define X86_FEATURE_VIBS		(15*32+26) /* "" Virtual IBS */
 #define X86_FEATURE_EXTLVT		(15*32+27) /* "" EXTLVT */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
-- 
2.34.1

