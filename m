Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF9F75B843
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 21:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjGTTsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 15:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjGTTrz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 15:47:55 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196101BC1;
        Thu, 20 Jul 2023 12:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVW4vsVI/xUmjaCBpkqGOKDKVulA4Rr8aFJUv6snf98VcsOJ9+ELRgv8M7+mf63zfVraTvxevURe4NaCBQcnAIRKCmF5pp9jOJGYOQkgd4PaNwsRLvNIQoTSW4Tc5sR18yN5ayuKR0d5/6KVzUSOZBl4OIPbiLuHJReVLx+vd8V742igkEYbmLxkmym7YkXFsDGstCbbu8aB+pyebs/QWsFAVvPNocYwJpBQ+dDdTs1zv/C83X0wl8iok1D+4+44I4lnovoefKus/HYteDEz5UZRDLnKQDoVS52Q4BQ/S4s6NxWjCfM5YErOn4Fj59sYhYdl1A3gRv0sOUo1BajwGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pkcKh2u5enw7xFgbs4vv1vMUe4jKMjBKsFTlp0vPMXw=;
 b=hIkJ4QT3aB3QNlR3eD9YXAo+iD8hlWXfemDXyaSKk/sjqEVJhtCxtB28Si41YtKrZNsiSj5jJFtSIql7fl9f3d6rJgk3dxxD0cRNkNWzjqIMHBittEY0Crx26kH+io/YtHLPOQ8GPSgScK7mVfQGRSpoRGI/49OU3CDh3v0Pc+XiiuReDIyCRNh5hYB3/rFU9T5MRd+l+uAVQKCYmTnVsxbbP0qcnbKqMIA5xr4WIjb+r4qRCHcY1telwlmnZDtZ0h0bov5DyMasRUvRr3znAgCtirFH2fQiD3eSwkX9EStLQcKgvhIxTQMdYoOS1z4nWS72nQQW0LzQJKL8QpZoyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pkcKh2u5enw7xFgbs4vv1vMUe4jKMjBKsFTlp0vPMXw=;
 b=WpKRl8CR8xzE8WLkhEY6Q+S7UoW+3lObTyKL+lLkk5afthihHHzEqqbPJjAhbQbDU53DiQdeq/HIgPw5iY4hdQvZvj4KDtvYnzb6i5wGlL924nlSwn2q4WuYVy/kqPI1Y3UPNAz/HlOqyboHd3t9JjYE0JB7mJ6VhGa6pL8CfbE=
Received: from DM6PR08CA0055.namprd08.prod.outlook.com (2603:10b6:5:1e0::29)
 by BL3PR12MB6642.namprd12.prod.outlook.com (2603:10b6:208:38e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Thu, 20 Jul
 2023 19:47:51 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::93) by DM6PR08CA0055.outlook.office365.com
 (2603:10b6:5:1e0::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.25 via Frontend
 Transport; Thu, 20 Jul 2023 19:47:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6609.28 via Frontend Transport; Thu, 20 Jul 2023 19:47:50 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 20 Jul
 2023 14:47:48 -0500
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] x86/cpu: Enable STIBP if Automatic IBRS is enabled
Date:   Thu, 20 Jul 2023 14:47:27 -0500
Message-ID: <20230720194727.67022-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT034:EE_|BL3PR12MB6642:EE_
X-MS-Office365-Filtering-Correlation-Id: b7bff015-ab52-44fe-7893-08db895a3389
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VhfHClzs4RHBeiE2J9+8KlyX14MoDhVoZw76bPF/Kmk9ehPoVapVH8MplTC7XrDAwnHnoPS9qlSRPlHDJxsbFgExDqDHRLj2l6io0MpTUfJjTXZjVuHyAbGVhCCB9TXRkaa0HuDkLku1Ps/qrr9wmln/5nccFDpFHennEyCm1IeuqqdKzoFYmeAUV9X5D7HIE1DBt+7CTyBDWgyemFqxdj/RudKHOSh4kmYx3m2+Q/8jkpRqTGfSF3LKyI2IbJJl1rjiiDjKniSMRvfNSV6CVmN/ndztYSdoAub28ByMEEr9l1lwH92J7HV9kS/GmnLhAtzYSNUTS6T2qwhhLpcw6sRpy3lFpFswoJtH5JI9HIjyeefE71sL8oJrJj1yWag9xef+UzRdn9Wn+s83YN31k0QuwKbfZdP2GiiZdqpBfRUl4cZWsxIVeg5cthEw3kOe8IigFiL1FpjWlNBMogB3nQk4GAgqhnxJ9LqJBKeLcyVZumEC00cC4fCRnoirqfGjkqvyt3p7FDJ7Jxc655NK8Q5AGu8GRiGaOoMTs5sP0a62E5JaHfpSspKKsh4cJv/XKgNOH9ID7wLwsKBQGB5GYpD9oPEdIB49HqpEOKDDHvYSDuF/IMZSr3PmTr3bMAzyu2Uk2ngOM75+61p6L9gjsiut2/PHJX7V2A3AHmqfv2ThY5JGHXI4Z+LmEnpjSZLtMGeeqT+5Nn+eJgBBK0UGOrYVaDuJxojKCfUs9HdE+Qrf8qZkp2TJwj25x0Bj83lC
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39860400002)(346002)(82310400008)(451199021)(36840700001)(46966006)(40470700004)(36756003)(40460700003)(2616005)(47076005)(426003)(2906002)(8936002)(8676002)(41300700001)(7416002)(44832011)(5660300002)(6916009)(4326008)(83380400001)(316002)(70206006)(70586007)(36860700001)(40480700001)(186003)(6666004)(7696005)(966005)(1076003)(336012)(26005)(16526019)(81166007)(356005)(54906003)(82740400003)(86362001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 19:47:50.6985
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7bff015-ab52-44fe-7893-08db895a3389
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6642
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unlike Intel's Enhanced IBRS feature, AMD's Automatic IBRS does not
provide protection to processes running at CPL3/user mode [1].

Explicitly enable STIBP to protect against cross-thread CPL3
branch target injections on systems with Automatic IBRS enabled.

Also update the relevant documentation.

The first version of the original AutoIBRS patchseries enabled STIBP
always-on, but it got dropped by mistake in v2 and on.

[1] "AMD64 Architecture Programmer's Manual Volume 2: System Programming",
    Pub. 24593, rev. 3.41, June 2023, Part 1, Section 3.1.7 "Extended
    Feature Enable Register (EFER)" - accessible via Link.

Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
Fixes: e7862eda309e ("x86/cpu: Support AMD Automatic IBRS")
Link: https://bugzilla.kernel.org/attachment.cgi?id=304652
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 Documentation/admin-guide/hw-vuln/spectre.rst | 11 +++++++----
 arch/x86/kernel/cpu/bugs.c                    | 15 +++++++++------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/spectre.rst b/Documentation/admin-guide/hw-vuln/spectre.rst
index 4d186f599d90..32a8893e5617 100644
--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -484,11 +484,14 @@ Spectre variant 2
 
    Systems which support enhanced IBRS (eIBRS) enable IBRS protection once at
    boot, by setting the IBRS bit, and they're automatically protected against
-   Spectre v2 variant attacks, including cross-thread branch target injections
-   on SMT systems (STIBP). In other words, eIBRS enables STIBP too.
+   Spectre v2 variant attacks.
 
-   Legacy IBRS systems clear the IBRS bit on exit to userspace and
-   therefore explicitly enable STIBP for that
+   On Intel's enhanced IBRS systems, this includes cross-thread branch target
+   injections on SMT systems (STIBP). In other words, Intel eIBRS enables
+   STIBP, too.
+
+   AMD Automatic IBRS does not protect userspace, and Legacy IBRS systems clear
+   the IBRS bit on exit to userspace, therefore both explicitly enable STIBP.
 
    The retpoline mitigation is turned on by default on vulnerable
    CPUs. It can be forced on or off by the administrator
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 9e2a91830f72..95507448e781 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1150,19 +1150,21 @@ spectre_v2_user_select_mitigation(void)
 	}
 
 	/*
-	 * If no STIBP, enhanced IBRS is enabled, or SMT impossible, STIBP
+	 * If no STIBP, Intel enhanced IBRS is enabled, or SMT impossible, STIBP
 	 * is not required.
 	 *
-	 * Enhanced IBRS also protects against cross-thread branch target
+	 * Intel's Enhanced IBRS also protects against cross-thread branch target
 	 * injection in user-mode as the IBRS bit remains always set which
 	 * implicitly enables cross-thread protections.  However, in legacy IBRS
 	 * mode, the IBRS bit is set only on kernel entry and cleared on return
-	 * to userspace. This disables the implicit cross-thread protection,
-	 * so allow for STIBP to be selected in that case.
+	 * to userspace.  AMD Automatic IBRS also does not protect userspace.
+	 * These modes therefore disable the implicit cross-thread protection,
+	 * so allow for STIBP to be selected in those cases.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
 	    !smt_possible ||
-	    spectre_v2_in_eibrs_mode(spectre_v2_enabled))
+	    (spectre_v2_in_eibrs_mode(spectre_v2_enabled) &&
+	     !boot_cpu_has(X86_FEATURE_AUTOIBRS)))
 		return;
 
 	/*
@@ -2294,7 +2296,8 @@ static ssize_t mmio_stale_data_show_state(char *buf)
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled) &&
+	    !boot_cpu_has(X86_FEATURE_AUTOIBRS))
 		return "";
 
 	switch (spectre_v2_user_stibp) {
-- 
2.34.1

