Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B0667E405
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbjA0Lrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:47:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbjA0LrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:47:19 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1e::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC94AD18;
        Fri, 27 Jan 2023 03:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcIXZq6ds6bP9ip4JE/j1qNlUvY5S7B0ErdLpFp4kKY=;
 b=gcTKPFAnKsEzwokxUHMc7fNUJCIcgW/URrg/UKVZsWeyNHbWhCudWBNVZ/JLpzyKlwMAX/58J8FxcAbp2gdElfUesI+GR0TjFy0oL3wOrpglhLY8pTTI/GoW35eCvRtDvUdWwqAelD61kVpWGsp3JPWp8hY658Pbvh4ldppoETw=
Received: from AM6PR10CA0092.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::33)
 by PAWPR08MB10240.eurprd08.prod.outlook.com (2603:10a6:102:366::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 11:42:30 +0000
Received: from AM7EUR03FT054.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8c:cafe::17) by AM6PR10CA0092.outlook.office365.com
 (2603:10a6:209:8c::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT054.mail.protection.outlook.com (100.127.140.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:42:30 +0000
Received: ("Tessian outbound 6e565e48ed4a:v132"); Fri, 27 Jan 2023 11:42:30 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 3bb6f51fcd59317f
X-CR-MTA-TID: 64aa7808
Received: from 0919c10c4366.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 528B6F7E-9C34-4A82-84C8-D670B97DE6B8.1;
        Fri, 27 Jan 2023 11:42:23 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0919c10c4366.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:42:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nKyVCRI1ZmXQagPfhGGMg2dWZH4SDmnP8zoBmgWf7OY/Cj+1Ea2dFoBS6LqJjxZ/m3j+OXK+wndZQJMTPk3cMzJc6ADbdlpJcqZZDJvufm61bkVI6JDQ5j2KsnVsHF2pL7HSS89M0C0+ohmAidvy9HQ6AS226rV+lcqRntgJx+SYpAoY8YHlPtHE67YgnD/7wFTYRIgXc8hKOUNM/wvE7roFPz4bEU9vz8lh+UrZkPHnd08p2g7tpYPS+xrWsyD3PHjElmB4e22pUwbt0uuc1QSHCADYrGGIK7HHN+sQ8Q9Ya2C6sNuIjmtZd+qf0dIDobRCJpomYI1h/OuxVCXvKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcIXZq6ds6bP9ip4JE/j1qNlUvY5S7B0ErdLpFp4kKY=;
 b=cnRLBERUTO/fWuXiWXqYZ+bhjKK8+d/3L/7Atb/EtLYdxVRfCh6s3wBdoIOyRmVhcSSCoeK/Cvk9jrsOPRExbPabICzJfdIlOehNuTy3vfPDcu2a/sU0NM9cjB4h0pbbkfwEQ7UuCdqkTeZsopRD2Ui+1gR4Gfd94sxMSNkL+0nAnJ5CZiu1T1gD7xS05x0djkJHwvRgu5Qoyf7g4OEUbxaqnnLlXVEJfej8SuyUvXwsC5Zg1gc1cAwi8PFGZtKwJresJg7yRiqtdCFTnYgnNZWxMLUr96PSb0QCgcBV6HkRRza694Z8O6Nts7Tol+YokzJdyOZscN0grVqUr5cn2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcIXZq6ds6bP9ip4JE/j1qNlUvY5S7B0ErdLpFp4kKY=;
 b=gcTKPFAnKsEzwokxUHMc7fNUJCIcgW/URrg/UKVZsWeyNHbWhCudWBNVZ/JLpzyKlwMAX/58J8FxcAbp2gdElfUesI+GR0TjFy0oL3wOrpglhLY8pTTI/GoW35eCvRtDvUdWwqAelD61kVpWGsp3JPWp8hY658Pbvh4ldppoETw=
Received: from DBBPR09CA0008.eurprd09.prod.outlook.com (2603:10a6:10:c0::20)
 by PA4PR08MB6269.eurprd08.prod.outlook.com (2603:10a6:102:ed::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:42:19 +0000
Received: from DBAEUR03FT012.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:c0:cafe::22) by DBBPR09CA0008.outlook.office365.com
 (2603:10a6:10:c0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DBAEUR03FT012.mail.protection.outlook.com (100.127.142.126) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:42:18 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:18 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:18 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:12 +0000
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
Subject: [RFC kvm-unit-tests 11/27] arm: realm: Early memory setup
Date:   Fri, 27 Jan 2023 11:40:52 +0000
Message-ID: <20230127114108.10025-12-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: DBAEUR03FT012:EE_|PA4PR08MB6269:EE_|AM7EUR03FT054:EE_|PAWPR08MB10240:EE_
X-MS-Office365-Filtering-Correlation-Id: 45178ec4-0369-4818-7a6d-08db005b92b1
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: WPtP+nScV3xsIsPYWNRpZ4Pmab10S9T5ZdEkXtMAiSUnJV6QXnlsaDENYHBGS96TIPhC7N3sEh5FgvLKL2qK3oUcx2eF9ub0+GBsLbQ3R3fRLALP4pKHAqeDWOQYFHItN1gp6nwWSgh4lCY6SvnjhH+qQutAEvDnwTfk8T/YtwTB8WlrP07C36IouBdPxFwwADUkUH9SOxf1V/kHlTxjBde3rAr70HXiHPldGUmTnI4bMgGaEJp7wGY6pHXlJFxAy9bqIcmsS2kZcy2YKd4vJYUjFC0iPK9KzdxyJdMpTTc3lUaS6vL6XnXYs4vE0ODp4RMb0ePlfr/0cP1S55qHBkkWeE1JlTEs4hmILGMRlet8Gk9Jqw/refcmEnjYtzHS9VG6c/c43Bh9Oavw7veconh6mtSSgHXgGVRmrwHSN1IhnLUF8EQa7TZ+f9mfDS2jHttjwh7URT2v4IbI4njTQ6i8VHc+XLAoRKwHHpr8z6RnWabHbJApwxIypjniBwhjK9iLdeKSFvdmW3AYRHRRUku3VsIRrqjZMPk4UX3bzf8HVwffXwjgJ4D0z/N6ai9zwV4IDfPtpHzRt6jZgjL9lbV8SS+lS9N6x+Ph5WsTpHb1tKDKl22w8fbLxqA2LdZYQynMHuRpuyoXqDxbap4HK2A3Iuil8N9ur1g4F0cySLZH1EL7kpslKSC4gT4X6skYxXBSWJ6x5rGtk8rE1DAE13S78Mx0U7uMjzaxEhXDn0gPLPl+LNacMsl5/i5hIpXI
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199018)(36840700001)(40470700004)(46966006)(478600001)(44832011)(40460700003)(36756003)(70586007)(4326008)(70206006)(83380400001)(36860700001)(54906003)(82740400003)(110136005)(8676002)(316002)(1076003)(186003)(26005)(7696005)(6666004)(7416002)(5660300002)(47076005)(82310400005)(81166007)(426003)(356005)(2616005)(336012)(86362001)(41300700001)(40480700001)(8936002)(2906002)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6269
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT054.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: f797dcb8-444f-4884-b7c7-08db005b8bbe
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B57wTu0X55caa9fFwBOKHuIXWo47uzAj0YXCaCWPtEMcIF9p26r64LSSh3kq3A8W+1zrb344H0wqM/2l9wQA7gkmq2MRr83qRJ55WYAuoNuFqAj1bXKYO5t8Jwtq8HO/tvpJRCDFJF0wW8gWLEOJJ9x3lwofbJQIK/MQtk22B0myfE7o760/Cf1daZnP4aml6NQFUg9r1Gt6HdH/AiF3FkufqX9CnSWVfi+F9wW+/w5djokhhrO5fr4LPH3wfB7mSjJZADzaFATMRW6FfxfGT07EB5AXuk9aK7h7ctvnSwxBn1PKHj7ipAeOPwQ6J1tJF7QSHPcShvpAYbK0yrU55g4EjcVeAZ7fZhGWPPa36pYD3FscShTpG5xOCu+rERq6Ut8SL1e71dzWRxaxTJxrbdYjMygYMgusxegw+KvERSRgAZWCRTFu9KVzpfF39IQRouzHmQCJUnqvcUO+d2p0QuUQ9DToa7I2mXZuAMIZPTqPvWf132XZ4T1VcQMSYnxb8lSFF9R5luzsa03yfTK9avM+Pm5EWPoyVC/vDN2FRwkibVAkpx4ez8msupKNFo1GGIzrWHTxuA+8Ri9xnhnm9pQg2fxPbGWihes+p6FtFA9GUiLzhl4q+4jpf3ohfyut8KC/jYp7BkQ+N4Sw8+Ms6bsnkZg22BM3cYvWqkGelMEjxdsZ4dvvvkfvuxUsdg+FKKKlSx+2r98gVqrm3WYHc+jwuo65YHtcNaWeyERfvGs=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199018)(36840700001)(46966006)(40470700004)(336012)(82740400003)(110136005)(426003)(26005)(8936002)(478600001)(7696005)(86362001)(41300700001)(450100002)(36756003)(2616005)(40480700001)(81166007)(82310400005)(44832011)(4326008)(40460700003)(1076003)(186003)(54906003)(70206006)(5660300002)(316002)(8676002)(6666004)(47076005)(2906002)(70586007)(83380400001)(36860700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:42:30.5404
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45178ec4-0369-4818-7a6d-08db005b92b1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT054.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10240
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

A Realm must mark areas of memory as RIPAS_RAM before an access is made.

The binary image is loaded by the VMM and thus the area is converted.
However, the file image may not cover tail portion of the "memory" image (e.g,
BSS, stack etc.). Convert the area touched by the early boot code to RAM
before the access is made in early assembly code.

Once, we land in the C code, we take care of converting the entire RAM region
to RIPAS_RAM.

Please note that this operation doesn't require the host to commit memory to
the Realm.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Co-developed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Co-developed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/cstart64.S | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index b689b132..b0861594 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -14,6 +14,7 @@
 #include <asm/pgtable-hwdef.h>
 #include <asm/thread_info.h>
 #include <asm/sysreg.h>
+#include <asm/smc-rsi.h>
 
 .macro zero_range, tmp1, tmp2
 9998:	cmp	\tmp1, \tmp2
@@ -61,6 +62,7 @@ start:
 	b	1b
 
 1:
+	bl	__early_mem_setup
 	/* zero BSS */
 	adrp	x4, bss
 	add	x4, x4, :lo12:bss
@@ -170,6 +172,76 @@ arm_smccc_hvc:
 arm_smccc_smc:
 	do_smccc_call smc
 
+__early_mem_setup:
+	/* Preserve x0 - x3 */
+	mov	x5, x0
+	mov	x6, x1
+	mov	x7, x2
+	mov	x8, x3
+
+	/*
+	 * Check for EL3, otherwise an SMC instruction
+	 * will cause an UNDEFINED exception.
+	 */
+	mrs	x9, ID_AA64PFR0_EL1
+	lsr	x9, x9, #12
+	and	x9, x9, 0b11
+	cbnz	x9, 1f
+	ret
+
+1:
+	/*
+	 * Are we a realm? Request the RSI ABI version.
+	 * If KVM is catching SMCs, it returns an error in x0 (~0UL)
+	 */
+	ldr	x0, =SMC_RSI_ABI_VERSION
+	smc	#0
+
+	ldr	x1, =RSI_ABI_VERSION
+	cmp	x0, x1
+	bne	3f
+
+	/*
+	 * For realms, we must mark area from bss
+	 * to the end of stack as memory before it is
+	 * accessed, as they are not populated as part
+	 * of the initial image. As such we can run
+	 * this unconditionally irrespective of whether
+	 * we are a normal VM or Realm.
+	 *
+	 * x1 = bss_start.
+	 */
+	adrp	x1, bss
+
+	/* x9 = (end of stack - bss_start) */
+	adrp	x9, (stacktop + PAGE_SIZE)
+2:
+	/* calculate the size as (end - start) */
+	sub	x2, x9, x1
+
+	/* x3 = RIPAS_RAM */
+	mov	x3, #1
+
+	/* x0 = SMC_RSI_IPA_STATE_SET */
+	movz	x0, :abs_g2_s:SMC_RSI_IPA_STATE_SET
+	movk	x0, :abs_g1_nc:SMC_RSI_IPA_STATE_SET
+	movk	x0, :abs_g0_nc:SMC_RSI_IPA_STATE_SET
+
+	/* Run the RSI request */
+	smc	#0
+
+	/* halt if there is an error */
+	cbnz x0, halt
+
+	cmp x1, x9
+	bne 2b
+3:
+	mov	x3, x8
+	mov	x2, x7
+	mov	x1, x6
+	mov	x0, x5
+	ret
+
 get_mmu_off:
 	adrp	x0, auxinfo
 	ldr	x0, [x0, :lo12:auxinfo + 8]
-- 
2.17.1

