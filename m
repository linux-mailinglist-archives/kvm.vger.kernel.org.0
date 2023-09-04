Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7018F791542
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238304AbjIDJ5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjIDJ5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:57:15 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49555CFB;
        Mon,  4 Sep 2023 02:56:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kdriV6gFBvMvBqu9+BeyLN/ieZwRnYHnHCquKgYHPqveaEsrDjMKWwZhGNa1EjeRuBYLlvOrvFh+nl1KFuTBPdc07GWFlMyzqVNNhlhnm9AC9S2tR8fok8wvFgkD37jXOiN0O1A//n1OLD5a2G0zh7qPGaFQpbW0i4XuB9Y49lvDMPViMw/bGPdLZMSl4l8l6q21YAEG6QcrlIeqRZnBthVj9Uja3A4Td1/B6NvUwtIcyMsd6YBZ3u93hukJg8J3xUNVfS6QyzsYB846QCpQORQpS3Kg8d5EAIBOVmfgZhx8QGkddiGnEE7iWu2Tya20x9v3ONvV0gXfiB+5gqrDRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y5L47jzyqqoqjdNfxPxN5+rqB4LfyWV+KPwY6WSAwxM=;
 b=RlCj2huxrPMZn4bxhtP4rpmN1XKw+hmpa8XBFdcgt4VaGar03OzRXqNpCOGOi9d20PCIA9ln28f0O9m2MRufiDXNltd+9/7Pzv5cjA2KlI49OrGYX6ezfhqlMNwnUrmefjlM+f8S7y7pTq2IjYoOi1NVmOEpH1p1DJpqYcHL8la8vwRHLsAWCfG/RnyI4E0cNFSFZHJ7XK6RLVQSoscSMp8RoFWkw372EnsIj66Prpa578iNYJkBsW0KxI7CcQBzS12rfYehJmJCiK/+ZqAmeR+nx/WWazzLbChWfzvzx/CaeV7NPvGYXyjLhZYbf7aH3a5oedhZhSMPyuS6PgTpKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5L47jzyqqoqjdNfxPxN5+rqB4LfyWV+KPwY6WSAwxM=;
 b=J9R6iGAR4rQDpvrdjSS1SuIl6gUY5prHdtjLn2mIM1PQwwXQzlItWvPr1pRQ6bDP5BeceUWmJUoB7GJlKlsDNyrcWGuwBKuDdbXmoUddKhasTx2JSkIuCx/SUYdfrxpyQE4rQEJtwcblzvZRMSzKy0YGTyY5E5y8upjrBy4+jlM=
Received: from PH8PR05CA0007.namprd05.prod.outlook.com (2603:10b6:510:2cc::18)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.30; Mon, 4 Sep
 2023 09:54:49 +0000
Received: from SN1PEPF0002529F.namprd05.prod.outlook.com
 (2603:10b6:510:2cc:cafe::51) by PH8PR05CA0007.outlook.office365.com
 (2603:10b6:510:2cc::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.25 via Frontend
 Transport; Mon, 4 Sep 2023 09:54:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002529F.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6768.25 via Frontend Transport; Mon, 4 Sep 2023 09:54:49 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 4 Sep
 2023 04:54:45 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <manali.shukla@amd.com>
Subject: [PATCH 07/13] KVM: SVM: Extend VMCB area for virtualized IBS registers
Date:   Mon, 4 Sep 2023 09:53:41 +0000
Message-ID: <20230904095347.14994-8-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529F:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 7317ebde-fd99-4047-8cac-08dbad2cfa7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UchAzi/p6bMtupLV2Kc6hPf/tsiE/B7oQ/08+FUUh7YSKw8hEl53K02mKfJR5vWfiXZYb2gyXMnGyAYa1cEXvvHyPqQy8/iwgUUK934ISobQHtpia6URRX28CJvaxVkeExVw6zGIFcknAyGp3OzW8ouaGQ9cEf69M/ev/nYSXo32IrSjskrqfWao/UX0MN6rvBu5LNBH6vD7x37cvHqDTcKiyDc0w4JRCmT99uWhDvX3XJgjTfIa5qNkM1HGFNGeMXtljA80TC398L5yXPv1l7/eYt+NNO1ilQ79RF5OWEZrZJ8hMTClS8oBZZBnrbpJuuqyW8I8yrKLyRrhD0P/lR4LmyCEylM9QaXFWr/pqumB/xnCBerKXxALtycfoAyDsafY9juxVa4EB63aN5YQFxFGdFkHl1c8D3SL5QxQFLdwh8Yb4PvHJPmLjs0xe++dcJDt9uoLUljXjgLpHyyxY50twty9eD+Qty9+6Rgr+9Y5/M9vbnXRxQIgIeCY33eorpm+2aPz0Gv/2lO2PHLCqxo034SuKvi6WSmRIBNXgHD4cytAk8A89KRX4BXjSkTqoYWdV8JQFrNwiUXTAQ+MrvoC0Tv/qXP2HHbTpDp+iHQlt0AGX6LNVWFgGMr2zmMb6omeT8THfnrKKh7gPHswA6Ss4v+sKO02mhM08IMz4qh3P5HUc18U8fMrYkzC5LBHJWuaF4s/y+qrfhNCtYpMEVGLspbx2L8RwCYbwLqEON+xi71YMn2J5vkc4QNmCoRPmxxE5KVONMMLrxlaH6hs3g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(39860400002)(396003)(376002)(186009)(1800799009)(82310400011)(451199024)(40470700004)(36840700001)(46966006)(40460700003)(41300700001)(478600001)(356005)(82740400003)(81166007)(6666004)(86362001)(2616005)(83380400001)(336012)(26005)(16526019)(1076003)(7696005)(36860700001)(40480700001)(426003)(47076005)(70206006)(70586007)(54906003)(2906002)(110136005)(36756003)(316002)(8936002)(5660300002)(8676002)(44832011)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:54:49.4933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7317ebde-fd99-4047-8cac-08dbad2cfa7a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002529F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609
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

VMCB state save is extended to hold guest values of the fetch and op
IBS registers.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/svm.h | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index dee9fa91120b..4096d2f68770 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -346,6 +346,19 @@ struct vmcb_save_area {
 	u64 last_excp_to;
 	u8 reserved_0x298[72];
 	u64 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
+	u8 reserved_0x2e8[904];
+	u8 lbr_stack_from_to[256];
+	u64 lbr_select;
+	u64 ibs_fetch_ctl;
+	u64 ibs_fetch_linear_addr;
+	u64 ibs_op_ctl;
+	u64 ibs_op_rip;
+	u64 ibs_op_data;
+	u64 ibs_op_data2;
+	u64 ibs_op_data3;
+	u64 ibs_dc_linear_addr;
+	u64 ibs_br_target;
+	u64 ibs_fetch_extd_ctl;
 } __packed;
 
 /* Save area definition for SEV-ES and SEV-SNP guests */
@@ -512,7 +525,7 @@ struct ghcb {
 } __packed;
 
 
-#define EXPECTED_VMCB_SAVE_AREA_SIZE		744
+#define EXPECTED_VMCB_SAVE_AREA_SIZE		1992
 #define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
 #define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1648
 #define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
@@ -537,6 +550,7 @@ static inline void __unused_size_checks(void)
 	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x180);
 	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x248);
 	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x298);
+	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x2e8);
 
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0xc8);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0xcc);
-- 
2.34.1

