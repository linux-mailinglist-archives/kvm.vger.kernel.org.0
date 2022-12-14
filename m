Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D2564D063
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239160AbiLNTyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239145AbiLNTxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:53:33 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EA22C105;
        Wed, 14 Dec 2022 11:51:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UchcarU+H9/ZmcAR7+LfGzKny1oSjj9QUSWLi1NUtx1zvF1yeklFEfBS7M8yR4cMFZJg4Xsi1JYAuSK9jD57bAMYVOjRsh2/xLEtGqrE+57ChXKNaK0hEdR0Js79x1b9fccjMHg+FeRGiElcXF7zBrqcwPo0y+ap/bXz4SU8I1Zba2YHIy7qte304S/U2djgwyajEASxwNDBZc8l2zgyY7SRe0Ya0k15nnJ8S18BCqMQ4d/qp0iqZgTbLYJ/YPo40xsw7Jd2JemkROjag6WtRkrS8sxTMf4hqGb2nFWQyEXbe9sz3GrD+pv5ijQjrfiktgJkU22TRbwhyQ8Nz2AQDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bwGNNhr0BV8XU5gNur70iQYprV9zVRyFOKALIClyqYk=;
 b=GqDHuGh/jhffD0ZveL0Q9gXFuARcIh8GmJLg3AQIJFJCvOxifOOg6it6Ksc6HIG9HLKOB/ChPLC8TjeVGaSeTg2+bM87CjyeCDNyFm5b9NFatOFLBxM96JgbHSPDBV5nkZeO8X6xUEgIBp9wMwBvAxXtAKmhKzDr43cOChejZnVutbzd7MSdmXaRJ2sU41cA9coWq74mSLUXvJE6n6a8v7dQ9LILggs0QyVNwOXLVOss58J1Xeh/xIaHoJYdMWE6OpklGN9XumEYAJF3QvyC04qaZk0JyC1HdKojQ/EeiH9HMd/FsqSUibkkhSkYhEOmljsCdewQhXdd+M7SUMw/OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bwGNNhr0BV8XU5gNur70iQYprV9zVRyFOKALIClyqYk=;
 b=AbT63HwZtpfHA/VWHqJswLGecO43bGaBgxCZroLGMFmAgy18tDD2LUqVt1HsKrdHIH97ewUv6HNZe9nr5fKMUKQZaBHUeFFupdDJEaG3bQviij3AxYaMU8mR//b0iVYk5swkqJm5teeRCIrE2UBouR78Pa2YYTK93DKVrBltKA0=
Received: from CY5P221CA0004.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:b::12) by
 DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 19:51:38 +0000
Received: from CY4PEPF0000C978.namprd02.prod.outlook.com
 (2603:10b6:930:b:cafe::4f) by CY5P221CA0004.outlook.office365.com
 (2603:10b6:930:b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:51:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C978.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 19:51:38 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:51:37 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Hugh Dickins <hughd@google.com>
Subject: [PATCH RFC v7 21/64] x86/fault: fix handle_split_page_fault() to work with memfd backed pages
Date:   Wed, 14 Dec 2022 13:40:13 -0600
Message-ID: <20221214194056.161492-22-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C978:EE_|DM4PR12MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: a4bde643-db12-4646-ca78-08dade0c9d2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mFaTg346g8lcyFMW1cwlnoV+jQvmzSLRzmnUOb12LkhCFmmFRY9JlREPKL+VtpbgS7hvHwfechiK87qJMGnQHvGOvIM3vn+XIW+zztu8OHkm7eqgucuv3d3RdmY0Mag3WueRkWw2FAH0UrrlNDF47GsL52WI3AuQc6b5U9eSOFmMw4QtY62c2AbIZfeKzJPu3PFevA4+vK+H8IZDXqxLRcAnVuNrYBJFEcPISA1FYcmnfw4hCgzfY38ErWwh2ipsrDwqE+CNTNYJEHTgDMDslv2PayJmhZuLhVHMOKqViu5oIYXo6w4ekXuD/CpIyKItBpV4u7vNALAUMapHth5Jg/+5mmltYO3SFbmRs7fqfh8axDHGH5O5UnmE2KyjL79RCz4h+3qIT+HiCi2uW23VXayxBC6bfRouM9aHFLSL1FtSYaN0IM2coJYIJieriSk7vce99+xAvN+5gTr+/Pj3cQFmAedbJxuCZjWbNRpF6oe1g1vjqH3FUn/fCjpJsiR/xhIGa/tdgDfLGyWAiAV8FrJK1kcCRX7jDNG6fp4NzfaXt0P5vK39sN/O8sl8hUTX7sljQKR+RlQn4Kd91CWWGgijk+mVJXjg8+znJwQ+o5RB2P1lkoyqudulVSxw0fpKlKZejD4OTT6qO3/odlK6+3dD4oYkCIK/bJD/ZJsIEJJxZxPQX3wTYBEhp9OX/JT6BTnGtpzOExmrgqtlzbHH7e9VYsB43XG0RFVtnumqnV8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199015)(40470700004)(36840700001)(46966006)(7406005)(8936002)(41300700001)(4326008)(5660300002)(70586007)(44832011)(70206006)(8676002)(7416002)(36756003)(16526019)(1076003)(478600001)(54906003)(6916009)(2906002)(316002)(40460700003)(186003)(336012)(86362001)(2616005)(6666004)(426003)(26005)(40480700001)(83380400001)(82740400003)(81166007)(47076005)(356005)(82310400005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:51:38.2806
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4bde643-db12-4646-ca78-08dade0c9d2b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C978.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

When the address is backed by a memfd, the code to split the page does
nothing more than remove the PMD from the page tables. So immediately
install a PTE to ensure that any other pages in that 2MB region are
brought back as in 4K pages.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 mm/memory.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index e68da7e403c6..33c9020ba1f8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4999,6 +4999,11 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 static int handle_split_page_fault(struct vm_fault *vmf)
 {
 	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
+	/*
+	 * Install a PTE immediately to ensure that any other pages in
+	 * this 2MB region are brought back in as 4K pages.
+	 */
+	__pte_alloc(vmf->vma->vm_mm, vmf->pmd);
 	return 0;
 }
 
-- 
2.25.1

