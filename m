Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF1B67E41D
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbjA0LtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbjA0LtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:49:04 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on20603.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe13::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97C682401;
        Fri, 27 Jan 2023 03:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3BxKu6BJE8qZ6I03nBKWIFNYzAPdRnt9qPajUqJGwM=;
 b=S7vhYZkRh7qtQpktPriryJ6LvUGXIAWo8r9+MFfE9uSWEoCW0czcadZgWA9vEgaCXSN+0Y+7EZDsyTdzQWVhS1RW+8LZoA+O4/GFdAf2nvI60Vm0t6OEoLO2bfufqCMnZT4D1tONfWRXejN7h2EePOxmRAreeAF8sjy8o9d1mco=
Received: from AM6PR04CA0019.eurprd04.prod.outlook.com (2603:10a6:20b:92::32)
 by AM9PR08MB6066.eurprd08.prod.outlook.com (2603:10a6:20b:2d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:43:35 +0000
Received: from AM7EUR03FT062.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:92:cafe::a4) by AM6PR04CA0019.outlook.office365.com
 (2603:10a6:20b:92::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT062.mail.protection.outlook.com (100.127.140.99) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:43:35 +0000
Received: ("Tessian outbound 3ad958cd7492:v132"); Fri, 27 Jan 2023 11:43:35 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 1d3e6b00f409edc4
X-CR-MTA-TID: 64aa7808
Received: from 131ed2a06443.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 7DCA80C0-13CF-4AE6-B5D4-D72A3EAB71AC.1;
        Fri, 27 Jan 2023 11:43:29 +0000
Received: from EUR03-DBA-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 131ed2a06443.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:43:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByFG4Nk17rGaWCblIHRcgiVJkQEgXKT8zhDsW/YZzK6QvQTUjU4+wL5sQkGgcfxij1JCLfw5T6TFwBkyO/Qd2IwO/2gKEzV7pQVVQTc42gO/tkuQAESEW6cSi3i2Yz9uCRuAw/SxEpbx1kQ8KaekoZIpAkgJJmrVVV1k6lLRRAi8IDqRflw89ZlLcusMu27Uqcn+ycFEc15xosxWqB98a/yAVWmw6kXEV9Qg3T8eAJbeHQVTrQvWF0s6+3mkSWmfLLX4wdSCS26d3So14/y/sUzt1m+omOsorU6SQr50uFKwF8N7CClZX7LkeK5yBmvoO0WllLd+0fGNwU8AKq2PTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k3BxKu6BJE8qZ6I03nBKWIFNYzAPdRnt9qPajUqJGwM=;
 b=hc79aTeFD4DuoguIn2iYz/5UQ/B792J9/kaGHRc2kxG3fsYXCkAXq8U8H2p+d4lJtrYoooKz6ZA6252BEWUgrul3esX0KXCi87kzSx3i3AVy7agcBkr8BbMozfNRm2lEXE5uUc9ISd6lR+xi2fdqpKtJdrxWKb3UOejrs5kW0VbZhF/1NwhZJgxlOzrV9dGbPXakePaa0vIOBY8pMiOl98gQ47K+RzsWJUp3TAAllmvbuCJqQgw2SDTIbbD8Nk+G3rLCFnyFML66RLOAdICRlV+YxtjARqpwXD9AGJ2UZxrI7Lzyfxz4btDhKs408Xewjk6UBGE66vJ7ww7cO4703w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3BxKu6BJE8qZ6I03nBKWIFNYzAPdRnt9qPajUqJGwM=;
 b=S7vhYZkRh7qtQpktPriryJ6LvUGXIAWo8r9+MFfE9uSWEoCW0czcadZgWA9vEgaCXSN+0Y+7EZDsyTdzQWVhS1RW+8LZoA+O4/GFdAf2nvI60Vm0t6OEoLO2bfufqCMnZT4D1tONfWRXejN7h2EePOxmRAreeAF8sjy8o9d1mco=
Received: from AS9PR05CA0072.eurprd05.prod.outlook.com (2603:10a6:20b:499::16)
 by AM9PR08MB6145.eurprd08.prod.outlook.com (2603:10a6:20b:2dd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Fri, 27 Jan
 2023 11:43:27 +0000
Received: from AM7EUR03FT011.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:499:cafe::2b) by AS9PR05CA0072.outlook.office365.com
 (2603:10a6:20b:499::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT011.mail.protection.outlook.com (100.127.140.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:43:27 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:43:26 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:20 +0000
From:   Joey Gouly <joey.gouly@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>, <kvmarm@lists.linux.dev>,
        <kvm@vger.kernel.org>
CC:     <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Thomas Huth" <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        <linux-coco@lists.linux.dev>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC kvm-unit-tests 23/27] arm: realm: add RSI interface for attestation measurements
Date:   Fri, 27 Jan 2023 11:41:04 +0000
Message-ID: <20230127114108.10025-24-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT011:EE_|AM9PR08MB6145:EE_|AM7EUR03FT062:EE_|AM9PR08MB6066:EE_
X-MS-Office365-Filtering-Correlation-Id: d7238b0d-bd1f-479b-ebcd-08db005bb98c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: uIMHWBPkHbxsn+FyzF/JcxVx1gihl/Wr2KBG+rmbMsKaKqCFqg5YxBejF1xoFXCptctMVzbvyHahZen4knsmc2kyh7VG3Ozi1o3VZSV08+C/ylm8ZgIj6fdYis9+ddrERF69QN61rZFKzohedDe6qgaKndB1TUmPqYcO+MuZ2NpS2VSDvx04ekQA2qZOHLRukqN5AOoB6nuXpsh5rJv43u+jJAYPKox1EsDTJCKnZg0FBTGFQ8l4hyg5hXWWXd6lZy3eeSFbcGSoOqmEfPGf1DKQtIZqLqxGBhtZU51SE5K1F8aDU9Xj+jbqn0gSCRV96ZKcQCwxfBlIqgn+q5uAcBIw4HCm5HWfZRiVjpEv0p4FJDr3pQdNp/OhqcRjcB/u2UUveOPtSPKs68meMQ8R5JoRhEnQ8MONz/zNiL4SW7//5/J0IG5jawCDcKvIJAlm7LTldszx2hbO5LLSi8FL7LcXoyAsda0ElRpCExCxmuO0cvueuNvf84XPsvx9LxProE9ux8oXss8vSWy5TVNbWq2BcPrWEpyHB3QeugnpUccR0qtHDtGpd0hOxciJdZArntC6r5pEFbfZQeUNXkwoPuToxYzhWHnhjI406jRkgvG4YeF07++UF1SIKL0KDYZaFGjL2z1IUWkZCjkg+lz0bkg8ukMI2o4RVNyrwbTMbO03IcWxyhfOwMNcqE/02tW5pU07DnEX4hNK0P7jrRjXYxt2/S4l8Hu0y90EYd4fmnLvEsmBrfgJENOyw9e/8hKN
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199018)(40470700004)(46966006)(36840700001)(36756003)(40480700001)(81166007)(2616005)(8676002)(44832011)(5660300002)(7416002)(8936002)(2906002)(26005)(40460700003)(86362001)(7696005)(186003)(1076003)(4326008)(6666004)(478600001)(70206006)(70586007)(82740400003)(47076005)(426003)(36860700001)(356005)(336012)(110136005)(316002)(54906003)(41300700001)(82310400005)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6145
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT062.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 37468ccd-c3db-4c78-4dd5-08db005bb45c
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gUF+1eRpfz8+k/msAqT9jMdl5ISMCmgrJz7BVHPH+j3EKgrqN/9El7hx2uoLnMZKOk+5OaACZikbxoPUj2C+NyWs8/8n1vCblebBfTDMJAZ26oEP13cWFeFo1pltjDo/D+A6hbhDRnUsd7gqo4Yvj9t0p3/dF2RceO2wLohbTLqRaXt9FF72kDlNfRlShyuFkOzVK6HCOqG+V3LK3YrWcZaYUJHMG1FFxYtcDPUodZ6HseNlcgUN+rOc0xKIK7ynOUNndQoaQQyBqlDI8oCCZ+5tuaNQCRYsl3Qoywu9BIObgrGCbrIs9Ryy2pqcINfQi9UQXVsG6yA0q5hW70DEkhBd4/MV1YKYSiyAfZY/4CKSY5GuOUNd4NbWceqyeigCVyNpuY5B1BCxkFFVS/b6g47ML5klEHLAQiZ423oqkzUkFFV23FvXBuZZ0pCMFoOXSSVJUgSShahKlaabvgAkuqhBJ9+RoM0shajSHgyapvBaKf9/yn35OtTlHKdLO/+IiJeTM0/6Hfr7EZGZgEiz0sBxpseNafVV22vpTet2lh10vi2EZ5bdAt3Xeda6qpgRV9QneQdYMJhG+WnYDs/8v00VkKcrkPR4LY24t/VXYcgQSAH2/QNpz9M+8YTsu2ZfuSRQeFKoNz0q2r0Vp9rrF9tTiIE8YT80Y9uaIVaZ4rdysXjC5nVfgqkgX4Mfeyne9vYo+IfZRUCC8BWtQsMw0VaYYRfl6/RclLlHGnnipsE=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(450100002)(4326008)(8676002)(70586007)(5660300002)(70206006)(316002)(426003)(82740400003)(81166007)(40480700001)(41300700001)(8936002)(86362001)(336012)(82310400005)(54906003)(40460700003)(2616005)(36860700001)(47076005)(110136005)(36756003)(44832011)(6666004)(478600001)(7696005)(26005)(2906002)(186003)(1076003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:43:35.7320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7238b0d-bd1f-479b-ebcd-08db005bb98c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT062.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6066
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Add wrappers for the Attestation and measurement related RSI calls.
These will be later used in the test cases

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm64/asm/rsi.h |  7 +++++++
 lib/arm64/rsi.c     | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/lib/arm64/asm/rsi.h b/lib/arm64/asm/rsi.h
index c8179341..50bab993 100644
--- a/lib/arm64/asm/rsi.h
+++ b/lib/arm64/asm/rsi.h
@@ -27,6 +27,13 @@ int rsi_invoke(unsigned int function_id, unsigned long arg0,
 	       struct smccc_result *result);
 
 int rsi_get_version(void);
+void rsi_attest_token_init(phys_addr_t addr, unsigned long *challenge,
+			   struct smccc_result *res);
+void rsi_attest_token_continue(phys_addr_t addr, struct smccc_result *res);
+void rsi_extend_measurement(unsigned int index, unsigned long size,
+			    unsigned long *measurement,
+			    struct smccc_result *res);
+void rsi_read_measurement(unsigned int index, struct smccc_result *res);
 
 static inline bool is_realm(void)
 {
diff --git a/lib/arm64/rsi.c b/lib/arm64/rsi.c
index 08c77889..63d0620a 100644
--- a/lib/arm64/rsi.c
+++ b/lib/arm64/rsi.c
@@ -66,6 +66,38 @@ void arm_rsi_init(void)
 	prot_ns_shared = (1UL << phys_mask_shift);
 }
 
+void rsi_attest_token_init(phys_addr_t addr, unsigned long *challenge,
+			   struct smccc_result *res)
+{
+	rsi_invoke(SMC_RSI_ATTEST_TOKEN_INIT, addr,
+		   challenge[0], challenge[1], challenge[2],
+		   challenge[3], challenge[4], challenge[5],
+		   challenge[6], challenge[7], 0, 0, res);
+}
+
+void rsi_attest_token_continue(phys_addr_t addr, struct smccc_result *res)
+{
+	rsi_invoke(SMC_RSI_ATTEST_TOKEN_CONTINUE, addr,
+		   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, res);
+}
+
+void rsi_extend_measurement(unsigned int index, unsigned long size,
+			    unsigned long *measurement, struct smccc_result *res)
+{
+	rsi_invoke(SMC_RSI_MEASUREMENT_EXTEND, index, size,
+		   measurement[0], measurement[1],
+		   measurement[2], measurement[3],
+		   measurement[4], measurement[5],
+		   measurement[6], measurement[7],
+		   0, res);
+}
+
+void rsi_read_measurement(unsigned int index, struct smccc_result *res)
+{
+	rsi_invoke(SMC_RSI_MEASUREMENT_READ, index, 0,
+		   0, 0, 0, 0, 0, 0, 0, 0, 0, res);
+}
+
 static unsigned rsi_set_addr_range_state(unsigned long start, unsigned long size,
 					 enum ripas_t state, unsigned long *top)
 {
-- 
2.17.1

