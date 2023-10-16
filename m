Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A878D7CA95F
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjJPN3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbjJPN3d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:29:33 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848DFF0;
        Mon, 16 Oct 2023 06:29:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/K7wvRMvsj6b4rlYfNzi4Gd2AELJSOiQ7nIFzSZ4v2ywghDzkx1z0oiylabI1iK11UOC6CqnpWnIGH5KyxYTepfIED9kRHAWePF13sp7+qmUnsV9qPhCdCaroyTVuKDnyRUCQTDdhNiaIBBzc29MbW2t4LVv/Cj2x9qDMzZUgTTT+bqVeVyM6VcLBuFJqdEBpKto6dvwBbJe+vxUCuMFWHMHLK8IMY55szvaQnz+AuWk2mqLZS4S5tUrw7csKWEcVJuXy5h+1lbm2P4oSwE213hZQymCEUVU4g+UyfgPP9boAV/MNW8vdWDkrEvv8cxMMXs31KyMHZxx+owHITNsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSrfszyDN0MVEcnDdRGYnVhbUsWlnIjoZwQuXE4U5P8=;
 b=CWwguQ1cBhy2EhVsDJnEn5I0WwaVUQveU8dkLvjuQOdun5rchjVP6QZfhwyTrT3iFecSdn+3v+gdzYZM5Y998km2FT2fnyg7srJMXPL0xliDifrBLH5Yx3aLHgkEVhmE9UMw2AVpKA4zV4l0N9eTm+Lcy9crKkV6TFtcTwSsJFuSCqjfEu6kfaLScdWEulnVpPgJZ6D28PWKaqWO3WxezDSD+7NkuwfJp68ABwRX03GWJWGkuV7HYm2aoOmpDfmCaOGE9s4zBpgAXFGsWebbZra9Tepht9q06r+VGooVUW29abP9U85kcb0iUpsUS436kSSofZmxRnazIkoEGF3PIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSrfszyDN0MVEcnDdRGYnVhbUsWlnIjoZwQuXE4U5P8=;
 b=ubfXJqKWPbIjHP3gseN+6u780hTNfHqI/owwnxOEfeE2TQM4PaJ8w4wPMTikL1vUASrkUHLkWbsIO8QlxDAz743zf13tPtddTgnJ0jCmCj0hxdwk2c3LVXVdt1g4kRWCT5lJzcwpSRPZhcRed5wM5EZUJHjSgw/HwDB+zmoktFA=
Received: from CY5PR15CA0031.namprd15.prod.outlook.com (2603:10b6:930:1b::33)
 by BN9PR12MB5083.namprd12.prod.outlook.com (2603:10b6:408:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:29:28 +0000
Received: from CY4PEPF0000E9DB.namprd05.prod.outlook.com (2603:10b6:930:1b::4)
 by CY5PR15CA0031.outlook.office365.com (2603:10b6:930:1b::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6886.35 via Frontend Transport; Mon, 16 Oct 2023 13:29:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9DB.mail.protection.outlook.com (10.167.241.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:29:27 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:29:26 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v10 10/50] x86/fault: Report RMP page faults for kernel addresses
Date:   Mon, 16 Oct 2023 08:27:39 -0500
Message-ID: <20231016132819.1002933-11-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DB:EE_|BN9PR12MB5083:EE_
X-MS-Office365-Filtering-Correlation-Id: 1585aa88-caec-4557-80f3-08dbce4beba9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YQaBtfwkenTDfWKT+Y6ba4Q0xRb6xQR+M07E5X2d23TdENIfAneLpechJSzJOs4quboeb5eMYPs3p4HBwMsCH2k2DTjE6ji5DGluQvWWil13SWDrIbutVcN+PwRrhiwSU0d526ZgYm2qvKEMxMB6SB9Ml5LIMiU7dIo/8aHBswdtYJJLSnIxW0ijVkgp7QvfP5IDyQSyxxnJfV5emxrnCavz07pji8vk/vqvuk3BtgQSnugtwHgRITHA0inbd5uxZAzKiplJR4EO5JU537/028DIevU9mqA6zXVhW9lF+xhmxWNJgCg1Tn7RjHUfA4pmf+G0vdhURJWHvEAH+rw+pglcU91OhOaHmOX5vJLpweHde1eKV1yXT7sCCW2MwM/nL1ZKIgDRcmxei7K0dsaaT2iAnKjh1lV68cth5qTTdgi5wZpGcQoIAH9H+U9CixdP1hEVfueg4ui72lAPxrVIEyy1bZHvlIJKNaOPsmlvJNB7yAyJg+C5IlDkiH1S5G77xq7Y2E2JDPFYxGtokZ33baUI/kVQcEuDP5ul07Bg3x7/dCQf2greYiaLWCKNwzx6dBCNhgvJAtCdAIAU1X6kQDytEpNVHGuG3HaMXvke3g2QVS7gdUtBsJ4Xu659SWV010fvB1AQ4vHoBjbs6ZHwuvRrcSRddHXyYuCGhMjHVwS48t7rGibxu/8QQCQ1B7PYVnIEoq9E6eVtPznCvEaMMXl051Px/8CbZano879lu3xkp06XglKyUGA0zSqN2de75irEeRPrphwsDRZ8kSuV1w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(376002)(346002)(136003)(230922051799003)(186009)(1800799009)(82310400011)(64100799003)(451199024)(40470700004)(36840700001)(46966006)(40460700003)(336012)(426003)(16526019)(36860700001)(1076003)(2616005)(4744005)(7406005)(7416002)(47076005)(54906003)(70206006)(8676002)(4326008)(316002)(8936002)(70586007)(6916009)(6666004)(41300700001)(44832011)(81166007)(5660300002)(478600001)(2906002)(82740400003)(356005)(40480700001)(86362001)(36756003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:29:27.3586
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1585aa88-caec-4557-80f3-08dbce4beba9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9DB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5083
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RMP #PFs on kernel addresses are fatal and should never happen in
practice. They indicate a bug in the host kernel somewhere, so dump some
information about any RMP entries related to the faulting address to aid
with debugging.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/mm/fault.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 7858b9515d4a..9f154beef9c7 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -34,6 +34,7 @@
 #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
 #include <asm/irq_stack.h>
+#include <asm/sev-host.h>		/* sev_dump_rmpentry()          */
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -580,6 +581,9 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 	}
 
 	dump_pagetable(address);
+
+	if (error_code & X86_PF_RMP)
+		sev_dump_hva_rmpentry(address);
 }
 
 static noinline void
-- 
2.25.1

