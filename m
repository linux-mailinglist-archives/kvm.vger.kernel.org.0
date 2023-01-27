Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496D567E49D
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjA0MGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjA0MF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:05:27 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20622.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::622])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A84A77DF7;
        Fri, 27 Jan 2023 03:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEWRpIx8pPCm3VGNmB1RktfHgDOJXJhOSH7ymvX+aDY=;
 b=QijpDHLf1S7AIRYCeP4ymRPTsGZVT1Na8po/1L+R7Kq5RJGA3tB0sExKHUL9IOkCSZ4mwp2F0edhiWtr+1g8UJqQXI4z8vf8pda+W7jw4X3447C++YrcW7f/bo4lgZ+PVuHWFen8a/jTHNLuWIYsFGJhz1YkV7c3wa08Ekb+ExM=
Received: from AM6PR10CA0080.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::21)
 by AS1PR08MB7513.eurprd08.prod.outlook.com (2603:10a6:20b:480::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Fri, 27 Jan
 2023 11:43:34 +0000
Received: from AM7EUR03FT030.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8c:cafe::45) by AM6PR10CA0080.outlook.office365.com
 (2603:10a6:209:8c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT030.mail.protection.outlook.com (100.127.140.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:43:33 +0000
Received: ("Tessian outbound baf1b7a96f25:v132"); Fri, 27 Jan 2023 11:43:33 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 8547e39c894ce2d8
X-CR-MTA-TID: 64aa7808
Received: from 9065332d4944.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id B8A202EF-BCA2-4FEB-9FAA-F49BDF7DB5E0.1;
        Fri, 27 Jan 2023 11:43:27 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 9065332d4944.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:43:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPQHEPmcjQCgOUs+rZTXzPiHo3SUgGR++eO5QktT/ulTmgqXFdN+CiMuKjgWawH3+f50UeXA4Ymx+5oGquSpalhqGWHtC1JCM4fkx5uBXhaLBKzekUSWpUu+oufWHyGz393ya56L1p4avYWMdQByOe8MJXgjxKUWoBarYbhOM/kYPHqE4mcczPzm/fCDFR/ZZlcVmYLSt3NcQ8iKf+CXl2ifDnekP1LHKP6vBBCgmPeCSsxNZdCTrK9hbI9sC+cRd+xWWt/oR2+S9efMLkB4hZ8hjmjGkzWp7ExrxnefeOOtSnXUsQ25CnpSCNAUOjpnHPlkz5ImtVRj6nVt7lMaXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEWRpIx8pPCm3VGNmB1RktfHgDOJXJhOSH7ymvX+aDY=;
 b=M5Zr0Mc5g0QGEj2GE1n93mLdeal23bSPW7BaD2e+p3gLEdPt7uLX1qDudQEfCNRjOfwomxVnMUKssFSdxCkF+0NUFfc0m63mQ437RH8ZsstzvpLF/7Bnf655kOF72Z8Z8wY4Aueqc20xiZ5ve/YZGielGLfyiSxoCaxmj3t6FM9OZyW6+A+db5/zHNjkxoGKLiyIVZZNQt9DIu5+pSIU/3CCtEj0dcHTuNaodsl6+gytAYqPR5P7cp0DYKD+dvGqJVyRt3RBhkvCo3peKSnYA5PoSiMZlHxKgMnnQwu1OKXF48mxu966VYmHtOsPKg6c6Uu0tGtVfThGlHKHuMlGRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEWRpIx8pPCm3VGNmB1RktfHgDOJXJhOSH7ymvX+aDY=;
 b=QijpDHLf1S7AIRYCeP4ymRPTsGZVT1Na8po/1L+R7Kq5RJGA3tB0sExKHUL9IOkCSZ4mwp2F0edhiWtr+1g8UJqQXI4z8vf8pda+W7jw4X3447C++YrcW7f/bo4lgZ+PVuHWFen8a/jTHNLuWIYsFGJhz1YkV7c3wa08Ekb+ExM=
Received: from AM6PR10CA0076.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::17)
 by PAVPR08MB8989.eurprd08.prod.outlook.com (2603:10a6:102:320::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:43:23 +0000
Received: from AM7EUR03FT030.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8c::4) by AM6PR10CA0076.outlook.office365.com
 (2603:10a6:209:8c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT030.mail.protection.outlook.com (100.127.140.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:43:23 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:43:20 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:14 +0000
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
        <linux-kernel@vger.kernel.org>,
        Mate Toth-Pal <mate.toth-pal@arm.com>
Subject: [RFC kvm-unit-tests 22/27] arm: Add a library to verify tokens using the QCBOR library
Date:   Fri, 27 Jan 2023 11:41:03 +0000
Message-ID: <20230127114108.10025-23-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT030:EE_|PAVPR08MB8989:EE_|AM7EUR03FT030:EE_|AS1PR08MB7513:EE_
X-MS-Office365-Filtering-Correlation-Id: d2ac3cb1-03e2-432d-e875-08db005bb865
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: JG/SDIufOcyXoKX632Nk329OirO+5TZEUer/0rXaBQvx2yFmIfZ8gohDxp9eY16hF106C1K3tmj0cbeUyB3HKGdEPl4YAMSXGKEjvUYT9e3I1FWSRdlFXlSsmCdKlxlUVD97rQeurszgvGP3LeMwa0n0nLMgK1Jy9ROma/YPsVKHUU4+FkFWNg0phM/iDwiJvYjBHAhCDlbi7gbVXJNLyHMIPijjYYWmvrPZXS4Pqta13PMp6YEtWcuRKmD1fQGs+hiUYz+3jPK47ZjRn53KGkruvlmbHfBQDVNmthR0EzZMNMtHTGK8i1/3rj5yocPzdtYUzJVpObRBu4Ky1fU/+8MpiXeZlncUg1daXjwRYQ8eMROgvhpT2awhzyT2L/vlQOz6/4xALbEgmeg/+EMQro3K0bI0f5/nhh1S50294XV4Y6OcB+rK+ojy0+JwVty62yyvfKWh/fVkaDwcgw0PXB5zzrWbZU/0GaGF8yxwIW2IYneHT3ahWd144L7RlGzaU6WPwHvEnLKuEqsUe0IWEzVwZYm8I/zUeLaWin27X4yBpM7l3fzlVAp1G7V5c2zasYmQc1ok2slMEfYid9/0+1oH4dEmcdo703XGbAc56HcWW5GGizm22SEyQV8Q+5OWu/c2d07+a43jIWBl16a4RKdZicRjg05IQ33SWyrfJI7/34+aUpZtzRoV9KmJIYRivZpcuFLdwl1pF2bHns9gj4KFmqPm8qrjrc58xlT1wCmCNggSuKU7xe+iKnu1wqFIrTJ9dbjdO6Phtap2ci2h18T5aBMoH4DyUIRdMVosU8Y=
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(336012)(8676002)(4326008)(1076003)(26005)(186003)(44832011)(40460700003)(82740400003)(316002)(7416002)(5660300002)(41300700001)(36860700001)(356005)(15974865002)(82310400005)(81166007)(86362001)(8936002)(40480700001)(47076005)(36756003)(2616005)(54906003)(110136005)(83380400001)(70206006)(70586007)(30864003)(426003)(478600001)(7696005)(15650500001)(2906002)(6666004)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB8989
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT030.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: d9d5f80a-5f48-4c3b-1912-08db005bb21f
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yK6m4MAn42Xp6b2Zh6xoWmgZ7ZvvMvcxcakw1L9wxvo5fU2hHRm+YTaw7L173tYeUHri/uukJ5clJQ8zfLNwopCMY9iEpVx8wNmS4YbzVEWAg6DGrtBbkXcPOwgHhHPDw6SaG29DXJrHohVGnFTpQnL0YfIKNi7IzXm4X1OMuBwEYt/Jlt531SCWziZ7Lirl1mjJ3gbaOAV+xImGVGI5bDqc2ZDM1ZO1mPdjtiUNNx+QbaS+5e8thcepF/9kiMLLtBIn7snRtkqwfIHLzvGWKMKbO1pyqncQraENu5dqUreoZNvM63niDx/fn1mJ/fwO4J/yurwmNI99WcUqRlQLqrG+60b8DDv2ueVH9FAy/F0eBl0KDkWLxXsoesB97ibXE0/mBUW2+CYovNohHMQ14yg+HajNRbbVl2uhyl4Yjex8fBNdq/+9jacENk6yaGmSKwd3etqqAqMkMTl2JKe06GVV/OVltuwOLtV3xvWr/8lZhg7Dmx2nW77/cwEZtDn3tk47WNodYPQUpfnSB4LrIM4ZuNStA2hEGtYyiyl3xzvoI0W7vIZ+lja1QhMPAMbR3OvmP744PeGu4uAJ3s5IxVKR+/Hr9491huE7Iz3lGutBl9Y+joa7hLhlrmx0eixEz3DBvWbN32UgElUM8SJlN9AnOVZfWSgLgDEGHt8DzyxEJL4tty3OnsCmmtD0ohu+UXHZc3vbZlxI7O34SRTcBlD1oGU0WnlmM/L8Puj0VB0qQivLKsvK8+RgWQnEyzBq
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(8936002)(26005)(186003)(6666004)(81166007)(478600001)(5660300002)(86362001)(2906002)(44832011)(54906003)(40480700001)(36756003)(15650500001)(30864003)(110136005)(7696005)(15974865002)(40460700003)(1076003)(316002)(8676002)(36860700001)(4326008)(47076005)(70586007)(70206006)(83380400001)(82310400005)(2616005)(41300700001)(450100002)(426003)(336012)(82740400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:43:33.7673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2ac3cb1-03e2-432d-e875-08db005bb865
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT030.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7513
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mate Toth-Pal <mate.toth-pal@arm.com>

Add a library wrapper around the QCBOR for parsing the Arm CCA attestation
tokens.

Signed-off-by: Mate Toth-Pal <mate.toth-pal@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64                  |   7 +-
 lib/token_verifier/attest_defines.h |  50 +++
 lib/token_verifier/token_dumper.c   | 158 ++++++++
 lib/token_verifier/token_dumper.h   |  15 +
 lib/token_verifier/token_verifier.c | 591 ++++++++++++++++++++++++++++
 lib/token_verifier/token_verifier.h |  77 ++++
 6 files changed, 897 insertions(+), 1 deletion(-)
 create mode 100644 lib/token_verifier/attest_defines.h
 create mode 100644 lib/token_verifier/token_dumper.c
 create mode 100644 lib/token_verifier/token_dumper.h
 create mode 100644 lib/token_verifier/token_verifier.c
 create mode 100644 lib/token_verifier/token_verifier.h

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 8d450de9..f57d0a95 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -11,6 +11,7 @@ arch_LDFLAGS += -z notext
 CFLAGS += -mstrict-align
 CFLAGS += -I $(SRCDIR)/lib/qcbor/inc
 CFLAGS += -DQCBOR_DISABLE_FLOAT_HW_USE -DQCBOR_DISABLE_PREFERRED_FLOAT -DUSEFULBUF_DISABLE_ALL_FLOAT
+CFLAGS += -I $(SRCDIR)/lib/token_verifier
 
 mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
 CFLAGS += $(mno_outline_atomics)
@@ -28,6 +29,9 @@ cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
 cflatobjs += lib/arm64/rsi.o
 cflatobjs += lib/qcbor/src/qcbor_decode.o lib/qcbor/src/UsefulBuf.o
+cflatobjs += lib/token_verifier/token_verifier.o
+cflatobjs += lib/token_verifier/token_dumper.o
+
 
 OBJDIRS += lib/arm64
 
@@ -44,4 +48,5 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
 arch_clean: arm_clean
 	$(RM) lib/arm64/.*.d		\
-	      lib/qcbor/src/.*.d
+	      lib/qcbor/src/.*.d	\
+	      lib/token_verifier/.*.d
diff --git a/lib/token_verifier/attest_defines.h b/lib/token_verifier/attest_defines.h
new file mode 100644
index 00000000..daf51c5f
--- /dev/null
+++ b/lib/token_verifier/attest_defines.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#ifndef __ATTEST_DEFINES_H__
+#define __ATTEST_DEFINES_H__
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#define TAG_COSE_SIGN1                       (18)
+#define TAG_CCA_TOKEN                       (399)
+
+#define CCA_PLAT_TOKEN                    (44234)    /* 0xACCA */
+#define CCA_REALM_DELEGATED_TOKEN         (44241)
+
+/* CCA Platform Attestation Token */
+#define CCA_PLAT_CHALLENGE                   (10)    /* EAT nonce */
+#define CCA_PLAT_INSTANCE_ID                (256)    /* EAT ueid */
+#define CCA_PLAT_PROFILE                    (265)    /* EAT profile */
+#define CCA_PLAT_SECURITY_LIFECYCLE        (2395)
+#define CCA_PLAT_IMPLEMENTATION_ID         (2396)
+#define CCA_PLAT_SW_COMPONENTS             (2399)
+#define CCA_PLAT_VERIFICATION_SERVICE      (2400)
+#define CCA_PLAT_CONFIGURATION             (2401)
+#define CCA_PLAT_HASH_ALGO_ID              (2402)
+
+/* CCA Realm Delegated Attestation Token */
+#define CCA_REALM_CHALLENGE                  (10)    /* EAT nonce */
+#define CCA_REALM_PERSONALIZATION_VALUE   (44235)
+#define CCA_REALM_HASH_ALGO_ID            (44236)
+#define CCA_REALM_PUB_KEY                 (44237)
+#define CCA_REALM_INITIAL_MEASUREMENT     (44238)
+#define CCA_REALM_EXTENSIBLE_MEASUREMENTS (44239)
+#define CCA_REALM_PUB_KEY_HASH_ALGO_ID    (44240)
+
+/* Software components */
+#define CCA_SW_COMP_MEASUREMENT_VALUE         (2)
+#define CCA_SW_COMP_VERSION                   (4)
+#define CCA_SW_COMP_SIGNER_ID                 (5)
+#define CCA_SW_COMP_HASH_ALGORITHM            (6)
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* __ATTEST_DEFINES_H__ */
diff --git a/lib/token_verifier/token_dumper.c b/lib/token_verifier/token_dumper.c
new file mode 100644
index 00000000..15f17956
--- /dev/null
+++ b/lib/token_verifier/token_dumper.c
@@ -0,0 +1,158 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#include <stdio.h>
+#include <inttypes.h>
+#include "attest_defines.h"
+#include "token_dumper.h"
+
+#define COLUMN_WIDTH "20"
+
+void print_raw_token(const char *token, size_t size)
+{
+	int i;
+	char byte;
+
+	printf("\r\nCopy paste token to www.cbor.me\r\n");
+	for (i = 0; i < size; ++i) {
+		byte = token[i];
+		if (byte == 0)
+			printf("0x%#02x ", byte);
+		else
+			printf("0x%02x ", byte);
+		if (((i + 1) % 8) == 0)
+			printf("\r\n");
+	}
+	printf("\r\n");
+}
+
+static void print_indent(int indent_level)
+{
+	int i;
+
+	for (i = 0; i < indent_level; ++i) {
+		printf("  ");
+	}
+}
+
+static void print_byte_string(const char *name, int index,
+			      struct q_useful_buf_c buf)
+{
+	int i;
+
+	printf("%-"COLUMN_WIDTH"s (#%d) = [", name, index);
+	for (i = 0; i < buf.len; ++i) {
+		printf("%02x", ((uint8_t *)buf.ptr)[i]);
+	}
+	printf("]\r\n");
+}
+
+static void print_text(const char *name, int index, struct q_useful_buf_c buf)
+{
+	int i;
+
+	printf("%-"COLUMN_WIDTH"s (#%d) = \"", name, index);
+	for (i = 0; i < buf.len; ++i) {
+		printf("%c", ((uint8_t *)buf.ptr)[i]);
+	}
+	printf("\"\r\n");
+}
+
+static void print_claim(struct claim_t *claim, int indent_level)
+{
+	print_indent(indent_level);
+	if (claim->present) {
+		switch (claim->type) {
+		case CLAIM_INT64:
+			printf("%-"COLUMN_WIDTH"s (#%" PRId64 ") = %" PRId64
+				"\r\n", claim->title,
+			claim->key, claim->int_data);
+			break;
+		case CLAIM_BOOL:
+			printf("%-"COLUMN_WIDTH"s (#%" PRId64 ") = %s\r\n",
+			claim->title, claim->key,
+			claim->bool_data?"true":"false");
+			break;
+		case CLAIM_BSTR:
+			print_byte_string(claim->title, claim->key,
+				claim->buffer_data);
+			break;
+		case CLAIM_TEXT:
+			print_text(claim->title, claim->key,
+				claim->buffer_data);
+			break;
+		default:
+			printf("* Internal error at  %s:%d.\r\n", __FILE__,
+				(int)__LINE__);
+			break;
+		}
+	} else {
+		printf("* Missing%s claim with key: %" PRId64 " (%s)\r\n",
+			claim->mandatory?" mandatory":"",
+			claim->key, claim->title);
+	}
+}
+
+static void print_cose_sign1_wrapper(const char *token_type,
+				     struct claim_t *cose_sign1_wrapper)
+{
+	printf("\r\n== %s Token cose header:\r\n", token_type);
+	print_claim(cose_sign1_wrapper + 0, 0);
+	/* Don't print wrapped token bytestring */
+	print_claim(cose_sign1_wrapper + 2, 0);
+	printf("== End of %s Token cose header\r\n\r\n", token_type);
+}
+
+void print_token(struct attestation_claims *claims)
+{
+	int i;
+
+	print_cose_sign1_wrapper("Realm", claims->realm_cose_sign1_wrapper);
+
+	printf("\r\n== Realm Token:\r\n");
+	/* print the claims except the last one. That is printed in detail
+	 * below.
+	 */
+	for (i = 0; i < CLAIM_COUNT_REALM_TOKEN; ++i) {
+		struct claim_t *claim = claims->realm_token_claims + i;
+
+		print_claim(claim, 0);
+	}
+
+	printf("%-"COLUMN_WIDTH"s (#%d)\r\n", "Realm measurements",
+		CCA_REALM_EXTENSIBLE_MEASUREMENTS);
+	for (i = 0; i < CLAIM_COUNT_REALM_EXTENSIBLE_MEASUREMENTS; ++i) {
+		struct claim_t *claim = claims->realm_measurement_claims + i;
+
+		print_claim(claim, 1);
+	}
+	printf("== End of Realm Token.\r\n");
+
+	print_cose_sign1_wrapper("Platform", claims->plat_cose_sign1_wrapper);
+
+	printf("\r\n== Platform Token:\r\n");
+	for (i = 0; i < CLAIM_COUNT_PLATFORM_TOKEN; ++i) {
+		struct claim_t *claim = claims->plat_token_claims + i;
+
+		print_claim(claim, 0);
+	}
+	printf("== End of Platform Token\r\n\r\n");
+
+	printf("\r\n== Platform Token SW components:\r\n");
+
+	for (i = 0; i < MAX_SW_COMPONENT_COUNT; ++i) {
+		struct sw_component_t *component =
+			claims->sw_component_claims + i;
+
+		if (component->present) {
+			printf("  SW component #%d:\r\n", i);
+			for (int j = 0; j < CLAIM_COUNT_SW_COMPONENT; ++j) {
+				print_claim(component->claims + j, 2);
+			}
+		}
+	}
+	printf("== End of Platform Token SW components\r\n\r\n");
+}
diff --git a/lib/token_verifier/token_dumper.h b/lib/token_verifier/token_dumper.h
new file mode 100644
index 00000000..96cc0744
--- /dev/null
+++ b/lib/token_verifier/token_dumper.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#ifndef __TOKEN_DUMPER_H__
+#define __TOKEN_DUMPER_H__
+
+#include "token_verifier.h"
+
+void print_raw_token(const char *token, size_t size);
+void print_token(struct attestation_claims *claims);
+
+#endif /* __TOKEN_DUMPER_H__ */
diff --git a/lib/token_verifier/token_verifier.c b/lib/token_verifier/token_verifier.c
new file mode 100644
index 00000000..ba2a89f6
--- /dev/null
+++ b/lib/token_verifier/token_verifier.c
@@ -0,0 +1,591 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#include <libcflat.h>
+#include <inttypes.h>
+#include <qcbor/qcbor_decode.h>
+#include <qcbor/qcbor_spiffy_decode.h>
+#include "attest_defines.h"
+#include "token_verifier.h"
+#include "token_dumper.h"
+
+#define SHA256_SIZE 32
+#define SHA512_SIZE 64
+
+#define RETURN_ON_DECODE_ERROR(p_context) \
+	do { \
+		QCBORError ret; \
+		ret = QCBORDecode_GetError(p_context); \
+		if (ret != QCBOR_SUCCESS) { \
+			printf("QCBOR decode failed with error at %s:%d." \
+				" err = %d\r\n", \
+				__FILE__, (int)__LINE__, (int)ret); \
+			return TOKEN_VERIFICATION_ERR_QCBOR(ret); \
+		} \
+	} while (0)
+
+static void init_claim(struct claim_t *claim,
+		       bool mandatory, enum claim_data_type type,
+		       int64_t key, const char *title, bool present)
+{
+	claim->mandatory = mandatory;
+	claim->type = type;
+	claim->key = key;
+	claim->title = title;
+	claim->present = present;
+}
+
+static int init_cose_wrapper_claim(struct claim_t *cose_sign1_wrapper)
+{
+	struct claim_t *c;
+
+	/* The cose wrapper looks like the following:
+	 *  - Protected header (bytestring).
+	 *  - Unprotected header: might contain 0 items. This is a map. Due to
+	 *    the way this thing is implemented, it is not in the below list,
+	 *    but is handled in the verify_token_cose_sign1_wrapping
+	 *    function.
+	 *  - Payload: Platform token (bytestring). The content is passed for
+	 *    verify_platform_token.
+	 *  - Signature.
+	 */
+	c = cose_sign1_wrapper;
+	/* This structure is in an array, so the key is not used */
+	init_claim(c++, true, CLAIM_BSTR, 0, "Protected header",  false);
+	init_claim(c++, true, CLAIM_BSTR, 0, "Platform token payload", false);
+	init_claim(c++, true, CLAIM_BSTR, 0, "Signature",  false);
+	if (c > cose_sign1_wrapper + CLAIM_COUNT_COSE_SIGN1_WRAPPER) {
+		return TOKEN_VERIFICATION_ERR_INIT_ERROR;
+	}
+	return 0;
+}
+
+static int init_claims(struct attestation_claims *attest_claims)
+{
+	int i;
+	int ret;
+	struct claim_t *c;
+	/* TODO: All the buffer overwrite checks are happening too late.
+	 * Either remove, or find a better way.
+	 */
+	c = attest_claims->realm_token_claims;
+	init_claim(c++, true, CLAIM_BSTR, CCA_REALM_CHALLENGE,             "Realm challenge",                false);
+	init_claim(c++, true, CLAIM_BSTR, CCA_REALM_PERSONALIZATION_VALUE, "Realm personalization value",    false);
+	init_claim(c++, true, CLAIM_TEXT, CCA_REALM_HASH_ALGO_ID,          "Realm hash algo id",             false);
+	init_claim(c++, true, CLAIM_TEXT, CCA_REALM_PUB_KEY_HASH_ALGO_ID,  "Realm public key hash algo id",  false);
+	init_claim(c++, true, CLAIM_BSTR, CCA_REALM_PUB_KEY,               "Realm signing public key",       false);
+	init_claim(c++, true, CLAIM_BSTR, CCA_REALM_INITIAL_MEASUREMENT,   "Realm initial measurement",      false);
+	/* Realm extensible measurements are not present here as they are
+	 * encoded as a CBOR array, and it is handled specially in
+	 * verify_realm_token().
+	 */
+	if (c > attest_claims->realm_token_claims + CLAIM_COUNT_REALM_TOKEN) {
+		return TOKEN_VERIFICATION_ERR_INIT_ERROR;
+	}
+
+	ret = init_cose_wrapper_claim(attest_claims->realm_cose_sign1_wrapper);
+	if (ret != 0) {
+		return ret;
+	}
+	ret = init_cose_wrapper_claim(attest_claims->plat_cose_sign1_wrapper);
+	if (ret != 0) {
+		return ret;
+	}
+
+	c = attest_claims->plat_token_claims;
+	init_claim(c++, true,  CLAIM_BSTR,  CCA_PLAT_CHALLENGE,            "Challenge",            false);
+	init_claim(c++, false, CLAIM_TEXT,  CCA_PLAT_VERIFICATION_SERVICE, "Verification service", false);
+	init_claim(c++, true,  CLAIM_TEXT,  CCA_PLAT_PROFILE,              "Profile",              false);
+	init_claim(c++, true,  CLAIM_BSTR,  CCA_PLAT_INSTANCE_ID,          "Instance ID",          false);
+	init_claim(c++, true,  CLAIM_BSTR,  CCA_PLAT_IMPLEMENTATION_ID,    "Implementation ID",    false);
+	init_claim(c++, true,  CLAIM_INT64, CCA_PLAT_SECURITY_LIFECYCLE,   "Lifecycle",            false);
+	init_claim(c++, true,  CLAIM_BSTR,  CCA_PLAT_CONFIGURATION,        "Configuration",        false);
+	init_claim(c++, true,  CLAIM_TEXT,  CCA_PLAT_HASH_ALGO_ID,         "Platform hash algo",   false);
+	if (c > attest_claims->plat_token_claims +
+		CLAIM_COUNT_PLATFORM_TOKEN) {
+		return TOKEN_VERIFICATION_ERR_INIT_ERROR;
+	}
+
+	for (i = 0; i < CLAIM_COUNT_REALM_EXTENSIBLE_MEASUREMENTS; ++i) {
+		c = attest_claims->realm_measurement_claims + i;
+		init_claim(c, true, CLAIM_BSTR, i,
+			"Realm extensible measurements", false);
+	}
+
+	for (i = 0; i < MAX_SW_COMPONENT_COUNT; ++i) {
+		struct sw_component_t *component =
+			attest_claims->sw_component_claims + i;
+
+		component->present = false;
+		c = component->claims;
+		init_claim(c++, false, CLAIM_TEXT, CCA_SW_COMP_HASH_ALGORITHM,    "Hash algo.",  false);
+		init_claim(c++, true,  CLAIM_BSTR, CCA_SW_COMP_MEASUREMENT_VALUE, "Meas. val.", false);
+		init_claim(c++, false, CLAIM_TEXT, CCA_SW_COMP_VERSION,           "Version",    false);
+		init_claim(c++, true,  CLAIM_BSTR, CCA_SW_COMP_SIGNER_ID,         "Signer ID",  false);
+		if (c > component->claims + CLAIM_COUNT_SW_COMPONENT) {
+			return TOKEN_VERIFICATION_ERR_INIT_ERROR;
+		}
+	}
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+static int handle_claim_decode_error(const struct claim_t *claim,
+				     QCBORError err)
+{
+	if (err == QCBOR_ERR_LABEL_NOT_FOUND) {
+		if (claim->mandatory) {
+			printf("Mandatory claim with key %" PRId64 " (%s) is "
+				"missing from token.\r\n", claim->key,
+				claim->title);
+			return TOKEN_VERIFICATION_ERR_MISSING_MANDATORY_CLAIM;
+		}
+	} else {
+		printf("Decode failed with error at %s:%d. err = %d key = %"
+			PRId64 " (%s).\r\n",  __FILE__, (int)__LINE__, err,
+			claim->key, claim->title);
+		return TOKEN_VERIFICATION_ERR_QCBOR(err);
+	}
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+/* Consume claims from a map.
+ *
+ * This function iterates on the array 'claims', and looks up items with the
+ * specified keys. If a claim flagged as mandatory is not found, an error is
+ * returned. The function doesn't checks for extra items. So if the map contains
+ * items with keys that are not in the claims array, no error is reported.
+ *
+ * The map needs to be 'entered' before calling this function, and be 'exited'
+ * after it returns.
+ */
+static int get_claims_from_map(QCBORDecodeContext *p_context,
+			       struct claim_t *claims,
+			       size_t num_of_claims)
+{
+	QCBORError err;
+	int token_verification_error;
+	int i;
+
+	for (i = 0; i < num_of_claims; ++i) {
+		struct claim_t *claim = claims + i;
+
+		switch (claim->type) {
+		case CLAIM_INT64:
+			QCBORDecode_GetInt64InMapN(p_context, claim->key,
+				&(claim->int_data));
+			break;
+		case CLAIM_BOOL:
+			QCBORDecode_GetBoolInMapN(p_context, claim->key,
+				&(claim->bool_data));
+			break;
+		case CLAIM_BSTR:
+			QCBORDecode_GetByteStringInMapN(p_context, claim->key,
+				&(claim->buffer_data));
+			break;
+		case CLAIM_TEXT:
+			QCBORDecode_GetTextStringInMapN(p_context, claim->key,
+				&(claim->buffer_data));
+			break;
+		default:
+			printf("Internal error at  %s:%d.\r\n",
+				__FILE__, (int)__LINE__);
+			return TOKEN_VERIFICATION_ERR_INTERNAL_ERROR;
+		}
+		err = QCBORDecode_GetAndResetError(p_context);
+		if (err == QCBOR_SUCCESS) {
+			claim->present = true;
+		} else {
+			token_verification_error =
+				handle_claim_decode_error(claim, err);
+			if (token_verification_error !=
+				TOKEN_VERIFICATION_ERR_SUCCESS) {
+				return token_verification_error;
+			}
+		}
+	}
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+/* Consume a single claim from an array and from the top level.
+ *
+ * The claim's 'key' and 'mandatory' attribute is not used in this function.
+ * The claim is considered mandatory.
+ */
+static int get_claim(QCBORDecodeContext *p_context, struct claim_t *claim)
+{
+	QCBORError err;
+
+	switch (claim->type) {
+	case CLAIM_INT64:
+		QCBORDecode_GetInt64(p_context, &(claim->int_data));
+		break;
+	case CLAIM_BOOL:
+		QCBORDecode_GetBool(p_context, &(claim->bool_data));
+		break;
+	case CLAIM_BSTR:
+		QCBORDecode_GetByteString(p_context, &(claim->buffer_data));
+		break;
+	case CLAIM_TEXT:
+		QCBORDecode_GetTextString(p_context, &(claim->buffer_data));
+		break;
+	default:
+		printf("Internal error at  %s:%d.\r\n",
+			__FILE__, (int)__LINE__);
+		break;
+	}
+	err = QCBORDecode_GetAndResetError(p_context);
+	if (err == QCBOR_SUCCESS) {
+		claim->present = true;
+		return TOKEN_VERIFICATION_ERR_SUCCESS;
+	}
+	printf("Decode failed with error at %s:%d. err = %d claim: \"%s\".\r\n",
+		__FILE__, (int)__LINE__, err, claim->title);
+	return TOKEN_VERIFICATION_ERR_QCBOR(err);
+}
+
+/* Consume claims from an array and from the top level.
+ *
+ * This function iterates on the array 'claims', and gets an item for each
+ * element. If the array or the cbor runs out of elements before reaching the
+ * end of the 'claims' array, then error is returned.
+ *
+ * The claim's 'key' and 'mandatory' attribute is not used in this function.
+ * All the elements considered mandatory.
+ */
+static int get_claims(QCBORDecodeContext *p_context, struct claim_t *claims,
+		      size_t num_of_claims)
+{
+	QCBORError err;
+	int i;
+
+	for (i = 0; i < num_of_claims; ++i) {
+		struct claim_t *claim = claims + i;
+
+		err = get_claim(p_context, claim);
+		if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+			return err;
+		}
+	}
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+static int verify_platform_token(struct q_useful_buf_c buf,
+				 struct attestation_claims *attest_claims)
+{
+	QCBORDecodeContext context;
+	int err;
+	int label, index;
+
+	QCBORDecode_Init(&context, buf, QCBOR_DECODE_MODE_NORMAL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	QCBORDecode_EnterMap(&context, NULL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	err = get_claims_from_map(&context,
+		attest_claims->plat_token_claims,
+		CLAIM_COUNT_PLATFORM_TOKEN);
+	if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return err;
+	}
+
+	label = CCA_PLAT_SW_COMPONENTS;
+	QCBORDecode_EnterArrayFromMapN(&context, label);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	index = 0;
+	while (1) {
+		QCBORDecode_EnterMap(&context, NULL);
+		if (QCBORDecode_GetError(&context) == QCBOR_ERR_NO_MORE_ITEMS) {
+			/* This is OK. We just reached the end of the array.
+			 * Break from the loop.
+			 */
+			break;
+		}
+
+		if (index >= MAX_SW_COMPONENT_COUNT) {
+			printf("Not enough slots in sw_component_claims.\r\n");
+			printf("Increase MAX_SW_COMPONENT_COUNT in %s.\r\n",
+				__FILE__);
+			return TOKEN_VERIFICATION_ERR_INTERNAL_ERROR;
+		}
+
+		err = get_claims_from_map(&context,
+			attest_claims->sw_component_claims[index].claims,
+			CLAIM_COUNT_SW_COMPONENT);
+		if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+			return err;
+		}
+		attest_claims->sw_component_claims[index].present = true;
+
+		QCBORDecode_ExitMap(&context);
+		RETURN_ON_DECODE_ERROR(&context);
+
+		++index;
+	}
+	/* We only get here if the decode error code was a
+	 * QCBOR_ERR_NO_MORE_ITEMS which is expected when the end of an array is
+	 * reached. In this case the processing must be continued, so clear the
+	 * error.
+	 */
+	QCBORDecode_GetAndResetError(&context);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	QCBORDecode_ExitArray(&context);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	QCBORDecode_ExitMap(&context);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	QCBORDecode_Finish(&context);
+
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+static bool verify_length_of_measurement(size_t len)
+{
+	size_t allowed_lengths[] = {SHA256_SIZE, SHA512_SIZE};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(allowed_lengths); ++i) {
+		if (len == allowed_lengths[i])
+			return true;
+	}
+
+	return false;
+}
+
+static int verify_realm_token(struct q_useful_buf_c buf,
+			     struct attestation_claims *attest_claims)
+{
+	QCBORDecodeContext context;
+	int err;
+	int i;
+
+	QCBORDecode_Init(&context, buf, QCBOR_DECODE_MODE_NORMAL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	QCBORDecode_EnterMap(&context, NULL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	err = get_claims_from_map(&context, attest_claims->realm_token_claims,
+		CLAIM_COUNT_REALM_TOKEN);
+	if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return err;
+	}
+
+	/* Now get the realm extensible measurements */
+	QCBORDecode_EnterArrayFromMapN(&context,
+					CCA_REALM_EXTENSIBLE_MEASUREMENTS);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	err = get_claims(&context,
+		attest_claims->realm_measurement_claims,
+		CLAIM_COUNT_REALM_EXTENSIBLE_MEASUREMENTS);
+	if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return err;
+	}
+
+	for (i = 0; i < CLAIM_COUNT_REALM_EXTENSIBLE_MEASUREMENTS; ++i) {
+		struct claim_t *claims =
+			attest_claims->realm_measurement_claims;
+		struct q_useful_buf_c buf = claims[i].buffer_data;
+
+		if (!verify_length_of_measurement(buf.len)) {
+			return TOKEN_VERIFICATION_ERR_INVALID_CLAIM_LEN;
+		}
+	}
+
+	QCBORDecode_ExitArray(&context);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	QCBORDecode_ExitMap(&context);
+	QCBORDecode_Finish(&context);
+
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+/* Returns a pointer to the wrapped token in: 'token_payload'.
+ * Returns the claims in the wrapper in cose_sign1_wrapper.
+ */
+static int verify_token_cose_sign1_wrapping(
+				  struct q_useful_buf_c token,
+				  struct q_useful_buf_c *token_payload,
+				  struct claim_t *cose_sign1_wrapper)
+{
+	QCBORDecodeContext context;
+	QCBORItem item;
+	int err;
+
+	QCBORDecode_Init(&context, token, QCBOR_DECODE_MODE_NORMAL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	/* Check COSE tag. */
+	QCBORDecode_PeekNext(&context, &item);
+	if (!QCBORDecode_IsTagged(&context, &item,
+		TAG_COSE_SIGN1)) {
+		return TOKEN_VERIFICATION_ERR_INVALID_COSE_TAG;
+	}
+
+	QCBORDecode_EnterArray(&context, NULL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	/* Protected header */
+	err = get_claim(&context, cose_sign1_wrapper);
+	if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return err;
+	}
+
+	/* Unprotected header. The map is always present, but may contain 0
+	 * items.
+	 */
+	QCBORDecode_EnterMap(&context, NULL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+		/* Skip the content for now. */
+
+	QCBORDecode_ExitMap(&context);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	/* Payload */
+	err = get_claim(&context, cose_sign1_wrapper + 1);
+	if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return err;
+	}
+
+	/* Signature */
+	err = get_claim(&context, cose_sign1_wrapper + 2);
+	if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return err;
+	}
+
+	QCBORDecode_ExitArray(&context);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	*token_payload = cose_sign1_wrapper[1].buffer_data;
+
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+static int verify_cca_token(struct q_useful_buf_c  token,
+			    struct q_useful_buf_c *platform_token,
+			    struct q_useful_buf_c *realm_token)
+{
+	QCBORDecodeContext context;
+	QCBORItem item;
+	QCBORError err;
+
+	QCBORDecode_Init(&context, token, QCBOR_DECODE_MODE_NORMAL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	/* ================== Check CCA_TOKEN tag =========================== */
+	QCBORDecode_PeekNext(&context, &item);
+	if (!QCBORDecode_IsTagged(&context, &item, TAG_CCA_TOKEN)) {
+		return TOKEN_VERIFICATION_ERR_INVALID_COSE_TAG;
+	}
+
+	/* ================== Get the the platform token ==================== */
+	QCBORDecode_EnterMap(&context, NULL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	/*
+	 * First element is the CCA platfrom token which is a
+	 * COSE_Sign1_Tagged object. It has byte stream wrapper.
+	 */
+	QCBORDecode_GetByteStringInMapN(&context, CCA_PLAT_TOKEN,
+					platform_token);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	/* ================== Get the the realm token ======================= */
+	/*
+	 * Second element is the delegated realm token which is a
+	 * COSE_Sign1_Tagged object. It has byte stream wrapper.
+	 */
+	QCBORDecode_GetByteStringInMapN(&context, CCA_REALM_DELEGATED_TOKEN,
+					realm_token);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	QCBORDecode_ExitMap(&context);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	/* Finishing up the decoding of the top-level wrapper */
+	err = QCBORDecode_Finish(&context);
+	if (err != QCBOR_SUCCESS) {
+		printf("QCBOR decode failed with error at %s:%d. err = %d\r\n",
+			__FILE__, (int)__LINE__, (int)err);
+		return TOKEN_VERIFICATION_ERR_QCBOR(err);
+	}
+
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+/*
+ * This function expect two COSE_Sing1_Tagged object wrapped with a tagged map:
+ *
+ * cca-token = #6.44234(cca-token-map) ; 44234 = 0xACCA
+ *
+ * cca-platform-token = COSE_Sign1_Tagged
+ * cca-realm-delegated-token = COSE_Sign1_Tagged
+ *
+ * cca-token-map = {
+ *   0 => cca-platform-token
+ *   1 => cca-realm-delegated-token
+ * }
+ *
+ * COSE_Sign1_Tagged = #6.18(COSE_Sign1)
+ */
+int verify_token(const char *token, size_t size,
+		 struct attestation_claims *attest_claims)
+{
+	/* TODO: do signature check */
+	/* TODO: Add tag check on tokens */
+	struct q_useful_buf_c buf = {token, size};
+	int ret;
+	struct q_useful_buf_c realm_token;
+	struct q_useful_buf_c realm_token_payload;
+	struct q_useful_buf_c platform_token;
+	struct q_useful_buf_c platform_token_payload;
+
+	ret = init_claims(attest_claims);
+	if (ret != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return ret;
+	}
+
+	/* Verify top-level token map and extract the two sub-tokens */
+	ret = verify_cca_token(buf, &platform_token, &realm_token);
+	if (ret != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return ret;
+	}
+
+	/* Verify the COSE_Sign1 wrapper of the realm token */
+	ret = verify_token_cose_sign1_wrapping(realm_token,
+		&realm_token_payload,
+		attest_claims->realm_cose_sign1_wrapper);
+	if (ret != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return ret;
+	}
+	/* Verify the payload of the realm token */
+	ret = verify_realm_token(realm_token_payload, attest_claims);
+	if (ret != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return ret;
+	}
+
+	/* Verify the COSE_Sign1 wrapper of the platform token */
+	ret = verify_token_cose_sign1_wrapping(platform_token,
+		&platform_token_payload,
+		attest_claims->plat_cose_sign1_wrapper);
+	if (ret != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return ret;
+	}
+	/* Verify the payload of the platform token */
+	ret = verify_platform_token(platform_token_payload, attest_claims);
+	if (ret != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return ret;
+	}
+
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
diff --git a/lib/token_verifier/token_verifier.h b/lib/token_verifier/token_verifier.h
new file mode 100644
index 00000000..ec3ab9c9
--- /dev/null
+++ b/lib/token_verifier/token_verifier.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#ifndef __TOKEN_VERIFIER_H__
+#define __TOKEN_VERIFIER_H__
+
+#include <qcbor/qcbor_decode.h>
+
+#define TOKEN_VERIFICATION_ERR_SUCCESS                 0
+#define TOKEN_VERIFICATION_ERR_INIT_ERROR              1
+#define TOKEN_VERIFICATION_ERR_MISSING_MANDATORY_CLAIM 2
+#define TOKEN_VERIFICATION_ERR_INVALID_COSE_TAG        3
+#define TOKEN_VERIFICATION_ERR_INVALID_CLAIM_LEN       4
+#define TOKEN_VERIFICATION_ERR_INTERNAL_ERROR          5
+#define TOKEN_VERIFICATION_ERR_QCBOR(qcbor_err)        (1000 + qcbor_err)
+
+/* Number of realm extensible measurements (REM) */
+#define REM_COUNT 4
+
+#define MAX_SW_COMPONENT_COUNT 16
+
+#define CLAIM_COUNT_REALM_TOKEN 6
+#define CLAIM_COUNT_COSE_SIGN1_WRAPPER 3
+#define CLAIM_COUNT_PLATFORM_TOKEN 8
+#define CLAIM_COUNT_REALM_EXTENSIBLE_MEASUREMENTS REM_COUNT
+#define CLAIM_COUNT_SW_COMPONENT 4
+
+/* This tells how the data should be interpreted in the claim_t struct, and not
+ * necessarily is the same as the item's major type in the token.
+ */
+enum claim_data_type {
+	CLAIM_INT64,
+	CLAIM_BOOL,
+	CLAIM_BSTR,
+	CLAIM_TEXT,
+};
+
+struct claim_t {
+	/* 'static' */
+	bool mandatory;
+	enum claim_data_type type;
+	int64_t key;
+	const char *title;
+
+	/* filled during verification */
+	bool present;
+	union {
+		int64_t int_data;
+		bool bool_data;
+		/* Used for text and bytestream as well */
+		/* TODO: Add expected length check as well? */
+		struct q_useful_buf_c buffer_data;
+	};
+};
+
+struct sw_component_t {
+	bool present;
+	struct claim_t claims[CLAIM_COUNT_SW_COMPONENT];
+};
+
+struct attestation_claims {
+	struct claim_t realm_cose_sign1_wrapper[CLAIM_COUNT_COSE_SIGN1_WRAPPER];
+	struct claim_t realm_token_claims[CLAIM_COUNT_REALM_TOKEN];
+	struct claim_t realm_measurement_claims[CLAIM_COUNT_REALM_EXTENSIBLE_MEASUREMENTS];
+	struct claim_t plat_cose_sign1_wrapper[CLAIM_COUNT_COSE_SIGN1_WRAPPER];
+	struct claim_t plat_token_claims[CLAIM_COUNT_PLATFORM_TOKEN];
+	struct sw_component_t sw_component_claims[MAX_SW_COMPONENT_COUNT];
+};
+
+/* Returns TOKEN_VERIFICATION_ERR* */
+int verify_token(const char *token, size_t size,
+	struct attestation_claims *attest_claims);
+
+#endif /* __TOKEN_VERIFIER_H__ */
-- 
2.17.1

