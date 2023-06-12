Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1EE72B66F
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbjFLEaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbjFLE36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:29:58 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F1D19A6;
        Sun, 11 Jun 2023 21:29:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QB5gB7E7JZbWL5dBsZrTMV9nkBDPKPIvjmirCxurVZNmEFEVb3vKqLRewFYWroO+iY7crn78wn8NRlWNPCN2ltCTGMqbtW4H5ZtWgOt/a3Ismd8kqHIQOQ83jL56SuvQxKgKYJS4gm9ajJzSJf6SmT2f7HArC/PNtF0A3EIzHYtr3RUZEbLt0kgdVy5SmTqyzPIvtFjezH7eE8DEYYfhM78mcFPk86hOKfS0gvgvpOzet8xmk8Kc8Tgtm3X3fiF50YPhjUKOaWWBq5pjpfucCb4WTmXYIqd95PxH8KFdTdmPs6PsHi/smKY1ACRkLqzRMPb29Oy5WRuM4QISdhtY7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0d3dQu/aF3mwtDoMAmT2kZoy0ldEPLwmCUnZfhjJTkU=;
 b=fMKwPt7SBgqPmsvESGp2q35mWSdClXs2Pj/+CDpFCSGzeLN+XqJgeQYkMf4p1pYlAaqNWlGFNs8cX+vz3vO4H8jXy9oJmsIQvYKHhXvniAUufuhtGdldcOkW6IfQzPVmarQmR4tr0VyVG+zOVPKOteTu74V0DxufoMDELCCLndi4rmVqnGb1H/fjHTyW5ZUwPi/4crSuGOQm1p0qOnRrkDpawEhcC1Ayx44rZr8akl8XHsJ8irqMFK7CY9m7mGYTyzzSI++wk5IAEwsvDpZ/I3lLiLI2pzZr8SCDWTFIRm8kSfF2lpFZUZjbpJ8EINsjnNHOfaLd12lS0Y1VdCd0HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0d3dQu/aF3mwtDoMAmT2kZoy0ldEPLwmCUnZfhjJTkU=;
 b=z5K4dPyKhy/4yFKD2LCylE3xg5Fmxyx3XXi8TKox4EGKWgVYu/Jdfu+ZNV1lBlkL8L3sPk7HmM1NdypyZg0pTQPT4ml47uFF/qUoHWiR6ITJ34SHyfxpx6RsohniHD6PJkhmxVmfK3t3KtHPbcwkN9WFtCHhfQq27gpvWChu06w=
Received: from DS7PR05CA0059.namprd05.prod.outlook.com (2603:10b6:8:2f::32) by
 PH7PR12MB8828.namprd12.prod.outlook.com (2603:10b6:510:26b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.41; Mon, 12 Jun
 2023 04:29:36 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:8:2f:cafe::2d) by DS7PR05CA0059.outlook.office365.com
 (2603:10b6:8:2f::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.21 via Frontend
 Transport; Mon, 12 Jun 2023 04:29:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 04:29:36 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:29:35 -0500
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
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko.sakkinen@profian.com>
Subject: [PATCH RFC v9 13/51] x86/fault: Handle RMP page faults for user addresses
Date:   Sun, 11 Jun 2023 23:25:21 -0500
Message-ID: <20230612042559.375660-14-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|PH7PR12MB8828:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c459862-4178-4799-b1b5-08db6afda10b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yqxNPlB2qGzRvl/LTI4VOTNiZ5WbycA91BY4M8iNOfGbc1bZ0/bpqyP7WQ/Me002DIp90WL/wGSSaFiBUoRC+O8FzjP1i/rXZW2oprDkBDN5qydg8/fzjdjpL39dtykKYfZ+pKfDh41EGnIgrerTLYhc+3ZY0bzCYqBWYM/Oq+EzKPyQKi92qG/qwAf2FG2LPWicnWJ7sSgOnPk1UMa2C7tFfEaUwZUcscl2rYLDxljx3IRr7RPM9hQnrIFQqwCc58BCQqG1MGoUBUtmO5oV8NrV3IKhflcYYoUIyXIDcyEAfGMdjrX0wnbZ79YV0gqhN08qX67sbWGgbtnWnrJ2F6fHpVwTC2tYIliphRZYifK4eTe5RM8d2sC21BEcQQh5dvqz3EAOJzOOlUanw2mb4PdPXVbAC34bfJHs4ohkKR0ysYFT/wZgXIxG93EYfv9/NI2w7h9/1djsz1t18x1tNyQY0qgyw0BnxvvYZQfalVSqfczrGpCLAddKk/yJnTKFyq/ToysBOUqsscoHMyp+YWYCj42zH+xQ+Sx+pFmRuveFAkZmm0ffc1yY3HPhOldbFQQq5em28TV4a5YOdN4LF7MSWM+YCMQX17mBfUpzwSPGs9ba2YRN//IOBQipFPddC/hoyrM7vRLxyxjniVE/Li1QfJceJAjkczRvfNPfzloAq+ADZezooKbeofM6k584u9TnbYlAF9VrY9WnNzMJONCwQyMTiz2jUTma9WuAwkGPDq9TxAXivmWGQxRSlVhA2X1dALiEa7PFFy1xGy5fWQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(40470700004)(36840700001)(46966006)(316002)(40460700003)(41300700001)(336012)(82310400005)(40480700001)(16526019)(186003)(26005)(44832011)(7416002)(47076005)(86362001)(7406005)(36860700001)(2616005)(2906002)(83380400001)(1076003)(81166007)(82740400003)(356005)(426003)(36756003)(8936002)(5660300002)(8676002)(70206006)(70586007)(54906003)(478600001)(6666004)(4326008)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:29:36.2818
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c459862-4178-4799-b1b5-08db6afda10b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8828
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

When SEV-SNP is enabled globally, a write from the host is subject to
checks performed by the hardware against the RMP table (APM2 15.36.10)
at the end of a page walk:

  1. Assigned bit in the RMP table is not set (i.e page is shared).
  2. Immutable bit in the RMP table is not set.
  3. If the page table entry that gives the sPA indicates that the
     target page size is a large page, then all RMP entries for the 4KB
     constituting pages of the target must have the assigned bit 0.

Nothing constructive can come of an attempt by userspace to violate case
1) (which will result in writing garbage due to page encryption) or case
2) (userspace should not ever need or be allowed to write to a page that
the host has specifically needed to mark immutable).

Case 3) is dependent on the hypervisor. In case of KVM, due to how
shared/private pages are partitioned into separate memory pools via
restricted/guarded memory, there should never be a case where a page in
the private pool overlaps with a shared page: either it is a
hugepage-sized allocation and all the sub-pages are private, or it is a
single-page allocation, in which case it cannot overlap with anything
but itself.

Therefore, for all 3 cases, it is appropriate to simply kill the
userspace process if it ever generates an RMP #PF. Implement that logic
here.

Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@profian.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@profian.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
[mdr: drop all previous page-splitting logic since it is no longer
 needed with restricted/guarded memory, update commit message
 accordingly]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/mm/fault.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index d46b9cf832b9..6465bff9d1ba 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1329,6 +1329,13 @@ void do_user_addr_fault(struct pt_regs *regs,
 	if (error_code & X86_PF_INSTR)
 		flags |= FAULT_FLAG_INSTRUCTION;
 
+	if (error_code & X86_PF_RMP) {
+		pr_err("Unexpected RMP page fault for address 0x%lx, terminating process\n",
+		       address);
+		do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
+		return;
+	}
+
 #ifdef CONFIG_X86_64
 	/*
 	 * Faults in the vsyscall page might need emulation.  The
-- 
2.25.1

