Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B13572B66D
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbjFLE30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbjFLE2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:28:55 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A006610E4;
        Sun, 11 Jun 2023 21:28:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctKXp3Rhh+jhEi4kRRRI+iMULRhZj219Og7fQrSvQ4YpY27fgmnKmM1wqngJkDv6atLXothVkz0yiNsaJ8oo/OzGW5pdMY0mHVLnRB9og4P2rqzhPl2L8ys4YFtQc1WaVW9YfXGa67DKL8iax1S7ebLkACCNkVjfwyMikiCGLPTkLvrnAbYnBs1q3s9AhBkRaVgmr1bcgEHRV+b89dSS6+zHtKb8OdlFUJybxiyUf2RwRUVswRnetEiI76wwfh+DQIj6/JXeezJxRkrUb+7ukO8hP0EGelSdpxVSf+DtKJR5Lwh8Ic0ym8uvgMQAhpNZQ5hL4NmMWOyRwWXriwDEdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jk9yzL0mP2Rv14wKUYtpBKvHMRw9BQjiMQ4iCXVZfbc=;
 b=Zcyp1GSOR8njiKd74DUV+FhDZ3g+Gzv/Uem3PHBu2x5bXLFHtTg3zcXblc3hQ/PGyxZo838wVlPfdW8aYu91PXLBf4h5CUe3e8w3bKegQ/Nx0nJQIaBkxF64Y3jz9TCUh+RJpy4pA4+UweunotntkI4vU0RhyvIU938X2R2D1HALx4G+ooico4MEIoQ4dZkbvE1FuiE6VUUZ7ZTjFVwx39d9vstbw0e687lPngQ1d94dVFXCHnWEsv7pTc6SVst2luSWd3a94+G9mD9pX5auOsD8WowseG9798MBTE8iDmuHWEJJQbkMgnAusBxa3bkElGXo90kAIXlArL1NFRRFDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jk9yzL0mP2Rv14wKUYtpBKvHMRw9BQjiMQ4iCXVZfbc=;
 b=dS7c9OclY+LS+q9vROLu/KQsyjmE9zu0vC5cNRkcxrvIjnA+Myqp0CvJ6coHDnZlVlCO2m6lDL+fqA7ZXlHEe0L1tGa8L9yZ7pzvvRZB/+NYOfwhftaazyOj5QqFW3hFFuqTfehGlrmFaaJFQelnif3lxQshfHJKmuelydM88Ao=
Received: from DM6PR11CA0029.namprd11.prod.outlook.com (2603:10b6:5:190::42)
 by MW4PR12MB7382.namprd12.prod.outlook.com (2603:10b6:303:22b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 04:28:41 +0000
Received: from CY4PEPF0000E9D0.namprd03.prod.outlook.com
 (2603:10b6:5:190:cafe::f4) by DM6PR11CA0029.outlook.office365.com
 (2603:10b6:5:190::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:28:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D0.mail.protection.outlook.com (10.167.241.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:28:41 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:28:40 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH RFC v9 12/51] x86/fault: Report RMP page faults for kernel addresses
Date:   Sun, 11 Jun 2023 23:25:20 -0500
Message-ID: <20230612042559.375660-13-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D0:EE_|MW4PR12MB7382:EE_
X-MS-Office365-Filtering-Correlation-Id: ebbc56db-f55d-489a-5d8f-08db6afd8041
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dVaVaCSnwHogKXOGyNX3sOMjlPnoUc4F31VjOHowW1uLQaNhgsnmm72zPDfSYO5we62CmLTKkURz727sx73JF5OFEi10FswjAvLJoQiTX0Ck/YJT1bU2InCXubJzqyKNpkvV9NgznC1pfYyleo/eLu18pUI7EJkD7ZkbOMRfLHDKHLDguG92ryGghWhjFctUjl45rA7NVT0cDIsMgXj0Z9FX5VxPg1qlDBOoz2VamFy6rslXKZgxFeuM44Lj5KKIhIHAspxxSLHkEPuOvKtPrxDFV9adNvl/1Aowm7E5woUPSCPSysuILi0b+PAma9wg8uJRh0i3niySO2IilnoKjvn8Y+JVNYqdVdiTEgKyWK4vWwK5mDAM0kaACchF9RVMbexuVYsKVy9P0l5qxrIEFOkP5+Z3Zlba4oeXQ9ZcHqoO5Sb2RKWp9YZ1a88c3oGUl6toYiejKmJDtbnh80G6nBw4cC0i9Y/Kk4QbMTvqGzVAybl41zonmKwb+gn44k1lbsQWW/uUlkQRtuCAl4+ROt0U+ONIUmJ9yYapCA1ULlVkGpHmind/4DAw1/Zo6YMU0IKkGM9WNyl4mmS/spAqEdbSiIsSaVmh+7HrHvBZS75Gs3jWJs3cTCpD+avo8dI49sxeHMOGQhemHLr1AUs4Telu8ImiAdyV9snrpYQjtg1TMeMj0rkzjYRZuRVLtJ1KvDspaXTiqw58IQmxfXhrawjtjNLLHhBZ/CbF5lDQQMXw3BcJyVNUxlSJ5TxGx/DWT8gyUWy/eXF2T1ECjKwT/A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(39860400002)(346002)(451199021)(36840700001)(40470700004)(46966006)(7406005)(81166007)(7416002)(70206006)(70586007)(6916009)(356005)(4326008)(316002)(41300700001)(8676002)(40460700003)(5660300002)(8936002)(86362001)(36756003)(82310400005)(2906002)(44832011)(40480700001)(16526019)(2616005)(186003)(478600001)(6666004)(1076003)(26005)(47076005)(54906003)(36860700001)(82740400003)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:28:41.2532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebbc56db-f55d-489a-5d8f-08db6afd8041
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7382
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
 arch/x86/mm/fault.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 95791071e3cd..d46b9cf832b9 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -33,6 +33,7 @@
 #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
 #include <asm/irq_stack.h>
+#include <asm/sev-host.h>		/* sev_dump_rmpentry()          */
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -579,6 +580,18 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 	}
 
 	dump_pagetable(address);
+
+	if (error_code & X86_PF_RMP) {
+		unsigned int level;
+		pgd_t *pgd;
+		pte_t *pte;
+
+		pgd = __va(read_cr3_pa());
+		pgd += pgd_index(address);
+		pte = lookup_address_in_pgd(pgd, address, &level);
+
+		sev_dump_rmpentry(pte_pfn(*pte));
+	}
 }
 
 static noinline void
-- 
2.25.1

