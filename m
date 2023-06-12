Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F6272B70A
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbjFLE71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235780AbjFLE6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:58:38 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5402510E7;
        Sun, 11 Jun 2023 21:58:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNVEd/9vqDK/M27AU3zQDh98UQpgronGZOS0Du7jbejSwaI4pzJduissWfAD4YGXjgVvYfdM0NyTpouiqy5cC0UFyNBnAXARMLdi+mWkEZ2UEBchVr60dILky9KlVHAYVONafBAq2ILD/NU9vs00+6MiDdFsCWNCtitEglIk+lY6SH+dtxNmiLyzKSMf5z9DZAMqtLf7GijeJAyELkbkA7BpiAk/DHEG3EuvvlpB5X1lHLcae4u+1BDnCTJlUqCzw/OZnNTDqcftglKxVcaQ3VAoL6FWd3sF5SaEyvepYejAz8a6yMJwN63xedFVrlsuzSaUha9Km4dlhdLYv/yhbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CeyhY905hNs52Bqq6Oa0uJDMuGrsDGEdsZEoDZbc4iM=;
 b=kKAOtqn8UgOEQAldoVX34sEwYtHW/PzvNGtPVbQn7KqIZdb4T13xWgBrr496MVlwzcmoCrZE1zp1M/BCpSIus2R2klaOnAcQUiOli77Ek3sFoEtQG7oudiHSmGB3k8DZOfN/L8suC4AHHXIkm6zlCqE+Q6FojjCVfRTvBV3FLcRbFinH1NLiJtVwDcwqFHC4rLKknQEi7RhXpxyY9EyVuFOLJNP+/4ll+DQ+t+9kBlUzkZ8WqcCsaGmmzkhJFmyvKwPvCP1aY2nbTCx5glDAp/caSwpddOyXM0BinHQSQzrm7hdSTP/kjkJcrOek2MdaRPoLh6G5vJ0AYK2hojqD+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeyhY905hNs52Bqq6Oa0uJDMuGrsDGEdsZEoDZbc4iM=;
 b=XWPixkjoXVP3U/qxiMxybV5lrJe6T4vufv2cusmsG8hmxvX2ZwDszUgxp9kJdI5I/OLVW84UdiGDWei+LtAV8xk3Nsd2m/NZyN5i3NEcOEHsLLwMunpJYblqDIyEQKQlTFaIWryUURlTNFxQsUXaNxtmbYUe0x9V/m9Aak0jnHo=
Received: from CY5PR04CA0015.namprd04.prod.outlook.com (2603:10b6:930:1e::9)
 by CY8PR12MB7099.namprd12.prod.outlook.com (2603:10b6:930:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 04:58:04 +0000
Received: from CY4PEPF0000E9D9.namprd05.prod.outlook.com
 (2603:10b6:930:1e:cafe::52) by CY5PR04CA0015.outlook.office365.com
 (2603:10b6:930:1e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 04:58:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D9.mail.protection.outlook.com (10.167.241.77) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 04:58:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:57:57 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH RFC v9 05/51] x86/coco: move CONFIG_HAS_CC_PLATFORM check down into coco/Makefile
Date:   Sun, 11 Jun 2023 23:25:13 -0500
Message-ID: <20230612042559.375660-6-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D9:EE_|CY8PR12MB7099:EE_
X-MS-Office365-Filtering-Correlation-Id: 74ea92ed-daa1-464e-f918-08db6b019aea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8Qtn5v8D3fN7nlKCmp3QF5sxzqZo38E/6vXvRNeh/UL9L8OyTg+68KT2Sn58QW1u5k60W6EWag526oFEIxqekXMPO0Qzgy1A/oqZ+Wjq6joklDfYCf5+ihIp41VPn44muVOd7tOtu2Hb99Qs8sDcrObyvj2E6cjgA2PP9jPjmgQtJSY5/UWTXAXsmRoT9M0oPbcksWWUeZhBr9Wr/Sa4q48RpZ7YSrhR/Fh+XWXLwIvRhww7I0zNiISeCdTsSJW/AzMtCBcWg+NHHqJToOiNRODXEVQ0Na4h/GUc51F9YU8RKwVK7p76D9tLbv/5qqVCFixIDOox/vy/T1KKNbaSKJGdRI8sMticR8Uzgwuda05EJ6PgSqPCdXLhBqOrTX61nEPCLj+fHnpP7HiYNoyRTysLfvY83dOiEf5yDPRe6FJDTg2y0p7+q7550rPkJJj2GoOBd3j/Zia79TUB+xblOcJYKZfw/8A3DhskUZEVV54MNwmc86sJbbQD2oupvbDpugggfGyEiA7GO5U60BJCTuKtW+urN9XvL5tEcPiXgAHjQWdLRlsqAsKbQ2d5cjsHcWwf5fv9z5j73A8jFDlr8O7Urvr5VxXkxJ20tqQM6Jo1DS7GwR9Ga4a2eSH59JsExClOIoWVbxw9d+9Siy/0FI99nVkKAdy9eQj2ZG82syMddR0NKQgFkZ2IclOqrXdgeyCzA0SNLnrzFw2zpF15Z3b3/kfHYNoEUgPwAHg9PlXYzkSaozSykLmuZiSt0twNwbWWnZ45dh0WB1fJOZEsg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(39860400002)(346002)(451199021)(40470700004)(46966006)(36840700001)(44832011)(7406005)(8676002)(7416002)(70206006)(316002)(8936002)(4326008)(70586007)(2906002)(6916009)(41300700001)(5660300002)(54906003)(6666004)(426003)(336012)(26005)(1076003)(186003)(36756003)(2616005)(16526019)(83380400001)(47076005)(36860700001)(82310400005)(478600001)(356005)(82740400003)(81166007)(40460700003)(40480700001)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:58:03.9724
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ea92ed-daa1-464e-f918-08db6b019aea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7099
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently CONFIG_HAS_CC_PLATFORM is a prereq for building anything in
arch/x86/coco, but that is generally only applicable for guest support.

For SEV-SNP, helpers related purely to host support will also live in
arch/x86/coco. To allow for CoCo-related host support code in
arch/x86/coco, move that check down into the Makefile and check for it
specifically when needed.

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/Kbuild        | 2 +-
 arch/x86/coco/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
index 5a83da703e87..1889cef48b58 100644
--- a/arch/x86/Kbuild
+++ b/arch/x86/Kbuild
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_ARCH_HAS_CC_PLATFORM) += coco/
+obj-y += coco/
 
 obj-y += entry/
 
diff --git a/arch/x86/coco/Makefile b/arch/x86/coco/Makefile
index c816acf78b6a..6aa52e719bf5 100644
--- a/arch/x86/coco/Makefile
+++ b/arch/x86/coco/Makefile
@@ -3,6 +3,6 @@ CFLAGS_REMOVE_core.o	= -pg
 KASAN_SANITIZE_core.o	:= n
 CFLAGS_core.o		+= -fno-stack-protector
 
-obj-y += core.o
+obj-$(CONFIG_ARCH_HAS_CC_PLATFORM) += core.o
 
 obj-$(CONFIG_INTEL_TDX_GUEST)	+= tdx/
-- 
2.25.1

