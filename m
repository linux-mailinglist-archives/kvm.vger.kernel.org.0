Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A556DDB82
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 15:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjDKNAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 09:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjDKNAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 09:00:16 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E044EE9;
        Tue, 11 Apr 2023 05:59:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfN3s/KEdLu+Sfgku4hUSXscrn4T24xd+ZezvULROuVt5daCnU1Rpew512BAB+dgCdfVimb1JClahGaJpkSsl2Nd2csB3nDQqU6tOfWzbsy9L1aCorvXBPoW8+JNQcu6x77//5qnuhN5xrdw8+oSmcN2bYVKXrzEUWeqJkTBuQBzblNbwxAiAzN9bxX/1qaokVvtABKHyWMoK1JV9C0Em9ZqFlhh9lGqXHAvsPd4JzYxj70URy0fjjifUHiO+komXLFCOUzEXbhq2Nn2VS9EleOOIoF5BLMq1h1wEFnZHSnKZPSPoctI9849xqMrsYWcbKG6zHBKyDYwTkfRAFsh0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IPeEDFdX5vcGUJlAVBsJQGUzndsU+cSaBOzQ3pLkLto=;
 b=k1NIYTyyXPt02B40gyncc2xZV9It1n4EYpQ3Af25ZuhHD0FGDIx3VAFfuHLoPtqQoiLXx5NNe69OiUGougv5jal1Hwm7+rjvXFx1q94P6ch2Ndcw6tbmljM9K44yadMCtwiHezLsF635La+JEFqEX//oSeHSsFIVfOUva7TMtw9AsEj5ef52pxeOXTQntkHsqTWN+I7ZiOIbbNFMztsZoybUElef0yEpDuCt32y6/+Sxr/WH47Um1k1YMw3nM5CewL5NcvKgsi8xYPm7SuKQh7uvk1I6mnUNNqSdMa2uMSt7AGQIYS0UIqvHNd4EJ+8RRDD0In3xiiGUgBOJvImjag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IPeEDFdX5vcGUJlAVBsJQGUzndsU+cSaBOzQ3pLkLto=;
 b=czmHmDERV05F1nvMC19XZUIoC3sE/mZkvL2nS7rVJ48tGUyRmdEwXkJgDIoaWHqijPXKNuimWNQypC+cR61SwENGQGRtZ9mqFamO9WBFyoDG4nTpnAIhswZqsQYCEp3Mwg1jK61CWJsqSHh58P84SPSOqlx1QVSyRnUEF0dpGg4=
Received: from MW4P221CA0022.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::27)
 by MN0PR12MB5737.namprd12.prod.outlook.com (2603:10b6:208:370::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 11 Apr
 2023 12:59:40 +0000
Received: from CO1NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::1a) by MW4P221CA0022.outlook.office365.com
 (2603:10b6:303:8b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.39 via Frontend
 Transport; Tue, 11 Apr 2023 12:59:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT069.mail.protection.outlook.com (10.13.174.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.28 via Frontend Transport; Tue, 11 Apr 2023 12:59:40 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 07:59:35 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Pankaj Gupta" <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        "Santosh Shukla" <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH kernel v5 6/6] x86/sev: Do not handle #VC for DR7 read/write
Date:   Tue, 11 Apr 2023 22:57:18 +1000
Message-ID: <20230411125718.2297768-7-aik@amd.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411125718.2297768-1-aik@amd.com>
References: <20230411125718.2297768-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT069:EE_|MN0PR12MB5737:EE_
X-MS-Office365-Filtering-Correlation-Id: 5225a93f-36af-4e7d-5e22-08db3a8c9cf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Qn9y2HpRL4+L8oLG3lE6w2LsrSwr0+trWD/4Xi/qvHTVKpUIj/hj8OEXbjrEnPB1sDxKzLKV+Fuo+Xhp4LBUy8YL2wugkl9G9gPyv72IvlJ+5IT7Wigf+4RnEZR3YyaV+NF4Tr0jI8LwnMibvL8DOseo5zpS6gvrvkQMZA2xjMcHAUwPXT7JDNqeU/O661TVfbUio8iBq64UEvrBacX3wuf+Oa3HpgpdbA1xxHKWG2XZh9fsXryy7nXrcXHxFSErgsfKU1YOv94ioYCuilwD2T99LaSOTIvYVswWbEeYSkG3z/IeD8unCH7R24BGxr/ZTwU5x+SAPxmfBP3qQ1a0tjX4/4GiuAIgK1F5yFeBjXqZFw/GCVE2Mf0v2RxiyHj9q/lmJhiDbJopFDWztKSFRk2MIAVXMY1Lzm+h6WnjYeM63F1mRBkxMoIW1Vw1NlqFMJ4WRelBcRLdnmJPKB5xTJGabvrD7I21DPKRiPC+d9FY1keA+/Bn8YXvMqgxOFQZDqHB0tsN7EgxGUqk6lbAXhi3v/0RUedsLzmmmUIil5Jt3JmtHRwIc6c+59OkbQ/rUR4VHq7aa+UIc21MZfxlL330L3rBozXpKcfj0AWWsaTKSE1AahKeg2SGP6HBdOgLLJ9plhtrpVjYJAkgbzPrpVZJ+BMl/BR8AoI7ylTYtHHkLjk8w2nEmOshCD/ouQntl48WnC1ZS4ib8JADYXZ4ztyd2Dxgjy1oSl2/0cjXOo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(47076005)(16526019)(83380400001)(5660300002)(8936002)(336012)(2906002)(478600001)(36860700001)(8676002)(1076003)(316002)(426003)(26005)(70206006)(6916009)(40480700001)(6666004)(4326008)(70586007)(54906003)(2616005)(186003)(41300700001)(356005)(82740400003)(81166007)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 12:59:40.4784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5225a93f-36af-4e7d-5e22-08db3a8c9cf7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5737
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With MSR_AMD64_SEV_DEBUG_SWAP enabled, the guest is not expected to
receive a #VC for reads or writes of DR7.

Update the SNP_FEATURES_PRESENT mask with MSR_AMD64_SNP_DEBUG_SWAP so
an SNP guest doesn't gracefully terminate during SNP feature negotiation
if MSR_AMD64_SEV_DEBUG_SWAP is enabled.

Since a guest is not expected to receive a #VC on DR7 accesses when
MSR_AMD64_SEV_DEBUG_SWAP is enabled, return an error from the #VC
handler in this situation.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Carlos Bilbao <carlos.bilbao@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
Changes:
v4:
* rebased on top of SNP feature negotiation

v2:
* use new bit definition
---
 arch/x86/boot/compressed/sev.c | 2 +-
 arch/x86/kernel/sev.c          | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 014b89c89088..f6123808be42 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -313,7 +313,7 @@ static void enforce_vmpl0(void)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT (0)
+#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
 
 void snp_check_features(void)
 {
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index b031244d6d2d..a515eb880970 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1620,6 +1620,9 @@ static enum es_result vc_handle_dr7_write(struct ghcb *ghcb,
 	long val, *reg = vc_insn_get_rm(ctxt);
 	enum es_result ret;
 
+	if (sev_status & MSR_AMD64_SNP_DEBUG_SWAP)
+		return ES_VMM_ERROR;
+
 	if (!reg)
 		return ES_DECODE_FAILED;
 
@@ -1657,6 +1660,9 @@ static enum es_result vc_handle_dr7_read(struct ghcb *ghcb,
 	struct sev_es_runtime_data *data = this_cpu_read(runtime_data);
 	long *reg = vc_insn_get_rm(ctxt);
 
+	if (sev_status & MSR_AMD64_SNP_DEBUG_SWAP)
+		return ES_VMM_ERROR;
+
 	if (!reg)
 		return ES_DECODE_FAILED;
 
-- 
2.39.1

