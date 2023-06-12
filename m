Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CFE72B669
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbjFLE2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbjFLE1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:27:37 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2058.outbound.protection.outlook.com [40.107.95.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6F31A5;
        Sun, 11 Jun 2023 21:27:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVl++eSid4DAaBvxslCd3GmMmzrocTZ9rdLXfv/gpRqdyFisH9GVw3JZXXIV/G+lOSNk2OS34zp7TkWQPgykPQOzRFr0k9OcRwJ1eUqIdxbJAsyIJf6AYX7Hha6NV2HXBm1BXSwADJzHDIvYVlfUtT4wC37NliAz+xm3GV1GIIMBuC/e6tSR7rmq0WSmrrPCakFzuTD2tDd7ewMDEC/NoDm6RxkqJb5WhqWKiQ7sgbgGHwP+igb/XI0hSQLRn/0/679AcJWebHeYz9lhB4pg1iw45XBF92+WCl4qohWqEtyt6ohMLHCqOW1Errz/kxNLwcj1jwaD9iuJo44XgRROfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRmnZV9+q0iWnxivqpSKbZUlVCI+wjQITiyoM9Ekv08=;
 b=h/fHsJsQ7re9v4WUgZZs0GkMMv4KlRrW0H0vrSgb7fxhajkZ9Up0rHFCvt1o86Ds5r8lyH0NdarRExZgOAGDGfwwmM40daKajeVo8tJXnu47u47RVag7m6G8mp31iuXO7kS8R8kz4yXLZFh0wCRK9MD1h8Zpd52l7xoxfB9cCCYyJqIYPL0tHv9B1dMXfKWI7vPPt0VsRfLPIBZIZ0DiE0LXgWEg2Dt055BsgdMeGdhdZRAQW1hSVkyt7I93SpQb6hMb7kmWDDEQFA/KG5zF/3QBWuOIQggJ4zqF5bX86UqLl9YHALi8nDTekr1BRkIy6ypubrmyeWyEhdpvmFTpHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRmnZV9+q0iWnxivqpSKbZUlVCI+wjQITiyoM9Ekv08=;
 b=s48ASt0BZuLSJb9nucZ5nCuw/r7v7eUM5VGKcwEgMETM0TdMYhp3Da/iSy7jB7aIrqiw8GVRf5ueVKz37BO8w17h9P1E17ikLCnIUx/k9DL7vpT8nRjelC9sAczTLNmBrdn6nynKEBocT2Sy61OKwR+IbaWxoDjfavU5ykZOTNc=
Received: from CY5PR15CA0136.namprd15.prod.outlook.com (2603:10b6:930:68::24)
 by PH0PR12MB7840.namprd12.prod.outlook.com (2603:10b6:510:28a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 04:27:28 +0000
Received: from CY4PEPF0000E9D2.namprd03.prod.outlook.com
 (2603:10b6:930:68:cafe::26) by CY5PR15CA0136.outlook.office365.com
 (2603:10b6:930:68::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 04:27:28 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D2.mail.protection.outlook.com (10.167.241.145) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 04:27:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:27:25 -0500
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v9 10/51] x86/fault: Add helper for dumping RMP entries
Date:   Sun, 11 Jun 2023 23:25:18 -0500
Message-ID: <20230612042559.375660-11-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D2:EE_|PH0PR12MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ed0c52a-060f-4081-22ae-08db6afd53b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sCNboHJeVkb0hpgOeku8Xu7OKeC7TXZ2u1xhdTH7MQ2Y00/p7IcfXeDW/9Fgqr97oUI7x0XkoSGBfot4rJqw2VDQJRb21k4JtpizXwjWM5Mt1YGRXWvTxu6mpso/vTZQdkV7NpHB2IxrWmMieNGKKJ5vNMHbl8gTJfkrERd/tk/ezhWrU2ftgQIWGHHsYPZffmV/LnpUaPnncl1RF7jB3lcVlZ1e0nwkMQ1+ugCWc8JYEtVPLTfiQGISTfzWFFgbm4+Nn6WW9L9YF3yO5x0Hg4Ub7U1iksX56sIpA3lWM2mo3WQ9gljsJM0qgkx2DlPlIcpqNMXn2fAJbAVSxgslTldv4AFjDuHAc7idptaqkpHt5IrnEoQdXYt+iwIcmIyooqCflCgv8m2rbc5TAusCQQ0OO+rax6xUhCJBdiX+YMaCnFjcr5oUGxJ67bwrzg8L4QV/WtuJBQhLqxRgSVC2TLUPq0JuAEC8sovxMSQJglQH57Bh645fEAUaqsCDy85w3XbNwfmN/LfwDXxBv5axiny5KcRONq26ioxPUpfvV9hVtQXsf5u1MTHRS4/zDFhqGDk/qoLJCa/spJKY4yMqYCtmzZzrj+XoBWBj6IoAG/ox7VMlfBVml5B58sj6wbaw0fnI9gPAvtT4J1x6Gb00BGwV2StmCL6Uvohg55w8+YVIK0DfcD10PmH27Em0M+pMGycx3eoEKYibHsy+Q5E8GPkUkO/jG9xpzvwtYrfG4+/pRmWxuucF/n3P5NdJnJv7NK79LS/zNPw6li967hbyYw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(6666004)(47076005)(36756003)(63350400001)(426003)(336012)(83380400001)(63370400001)(2616005)(86362001)(82310400005)(82740400003)(81166007)(1076003)(26005)(356005)(40480700001)(36860700001)(186003)(16526019)(2906002)(5660300002)(54906003)(44832011)(8676002)(7406005)(7416002)(8936002)(316002)(41300700001)(6916009)(4326008)(70206006)(70586007)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:27:26.5235
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ed0c52a-060f-4081-22ae-08db6afd53b4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7840
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

This information will be useful for debugging things like page faults
due to RMP access violations and RMPUPDATE failures.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: move helper to standalone patch]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/coco/sev/host.c        | 43 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/sev-host.h |  2 ++
 2 files changed, 45 insertions(+)

diff --git a/arch/x86/coco/sev/host.c b/arch/x86/coco/sev/host.c
index 0cc5a6d11b25..d766b3bc6647 100644
--- a/arch/x86/coco/sev/host.c
+++ b/arch/x86/coco/sev/host.c
@@ -295,3 +295,46 @@ int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
+
+void sev_dump_rmpentry(u64 pfn)
+{
+	unsigned long pfn_end;
+	struct rmpentry e;
+	int level, ret;
+
+	ret = __snp_lookup_rmpentry(pfn, &e, &level);
+	if (ret) {
+		pr_info("Failed to read RMP entry for PFN 0x%llx, error %d\n", pfn, ret);
+		return;
+	}
+
+	if (rmpentry_assigned(&e)) {
+		pr_info("RMPEntry paddr 0x%llx: [high=0x%016llx low=0x%016llx]\n",
+			pfn << PAGE_SHIFT, e.high, e.low);
+		return;
+	}
+
+	/*
+	 * If the RMP entry at the faulting pfn was not assigned, then not sure
+	 * what caused the RMP violation. To get some useful debug information,
+	 * iterate through the entire 2MB region, and dump the RMP entries if
+	 * one of the bit in the RMP entry is set.
+	 */
+	pfn = pfn & ~(PTRS_PER_PMD - 1);
+	pfn_end = pfn + PTRS_PER_PMD;
+
+	while (pfn < pfn_end) {
+		ret = __snp_lookup_rmpentry(pfn, &e, &level);
+		if (ret) {
+			pr_info("Failed to read RMP entry for PFN 0x%llx\n", pfn);
+			pfn++;
+			continue;
+		}
+
+		if (e.low || e.high)
+			pr_info("RMPEntry paddr 0x%llx: [high=0x%016llx low=0x%016llx]\n",
+				pfn << PAGE_SHIFT, e.high, e.low);
+		pfn++;
+	}
+}
+EXPORT_SYMBOL_GPL(sev_dump_rmpentry);
diff --git a/arch/x86/include/asm/sev-host.h b/arch/x86/include/asm/sev-host.h
index 30d47e20081d..85cfe577155c 100644
--- a/arch/x86/include/asm/sev-host.h
+++ b/arch/x86/include/asm/sev-host.h
@@ -15,8 +15,10 @@
 
 #ifdef CONFIG_KVM_AMD_SEV
 int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
+void sev_dump_rmpentry(u64 pfn);
 #else
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return 0; }
+static inline void sev_dump_rmpentry(u64 pfn) {}
 #endif
 
 #endif
-- 
2.25.1

