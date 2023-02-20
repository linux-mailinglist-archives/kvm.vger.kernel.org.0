Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279F469D316
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjBTSrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbjBTSrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:47:45 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397F22194A;
        Mon, 20 Feb 2023 10:47:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVRjs2k+sxXg5GY29MPMYn3AhV7TtUEMEc+Eov3Fq1flr4YlFQp4e71aQHJH7B354wDn6IJfvbNr5Vy54jHzITFRRQfL3AARhes5/NTgS1YFc2A73TMBuBlzK3w+bI2v2nsjIH1ViT552WjGGaFlietZE+4Agn5CwadX7UMtGZTGpCf2DiGASN/+ai3Cm0GtWqCnHRY9lMj9g8bCjIGYpNRgH70zhUIz9UpLi4UvrT/oZ/rUeVIkgdY9jowo2gsdAfMHEteGfZW0b5s7+QPTr26MIqUt9OL5g/PjpEhPWY4jAJu5filRKGBob3HHxvy29pqKgqDrpGw0gpklKBhk2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bwGNNhr0BV8XU5gNur70iQYprV9zVRyFOKALIClyqYk=;
 b=dZxBmpghRAzFGqYnF13dvp+FEhJJxgFbjYsmitOriqEXm6hIJD4AhJXMAU4h5UwHzFXabEJox3QjUtmPJS6ZIMp7sx/GUzX2cXgrUeNum9cw9yvaUs37QHOrycs0LpipBVOphY3SDWvU8LSzQKXvqydhwATuGSmNByo63H+JH2fuLXMIm7prbE2/uqWcTtSOKbP1KYCKgQOai3NNj4Q6WA+Ob6zZnXzEarzOTRZFt4wuLGbT0nSmX7gBC5Svu0TNsv8++RJodGBelqQ7lixW8wKtbZ5xTzaRzVM7TzjB50LL/00B183RpCM4IxMBnMtYkCiLJ7TMjaJGJf3Uf0E/ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bwGNNhr0BV8XU5gNur70iQYprV9zVRyFOKALIClyqYk=;
 b=p3yYnq7NW2BQ6QCQ1WAVRrLCAI0g/VIjE0oTcmF5RJKXruLyMHR6k2O5zsqySzBpo5tqS6UQenn8JKcZ5QX9vCwEwUEr//BPsnpkqQzF2Z0h3jGMzHEqQRhuN5OBMuT6Y40iJQlN90gXCwgWEp89wHJy60RLHXK/Lv69yvMWUdU=
Received: from CY5PR15CA0054.namprd15.prod.outlook.com (2603:10b6:930:1b::20)
 by DM4PR12MB5264.namprd12.prod.outlook.com (2603:10b6:5:39c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:46:41 +0000
Received: from CY4PEPF0000C966.namprd02.prod.outlook.com
 (2603:10b6:930:1b:cafe::19) by CY5PR15CA0054.outlook.office365.com
 (2603:10b6:930:1b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:46:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C966.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:46:41 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:46:40 -0600
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
        Hugh Dickins <hughd@google.com>
Subject: [PATCH RFC v8 18/56] x86/fault: fix handle_split_page_fault() to work with memfd backed pages
Date:   Mon, 20 Feb 2023 12:38:09 -0600
Message-ID: <20230220183847.59159-19-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C966:EE_|DM4PR12MB5264:EE_
X-MS-Office365-Filtering-Correlation-Id: ba5fa676-5082-4d16-0e82-08db1372ce65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B7d/72wrsRpK+69U11y8f7soos0SsuWP+xMyNq08E54psX1/nQ4WL0L6VC9MUTK3rXt7gXXHCJfXuW0Xjwa+Dt2Osio0EoWKZv8leNvtsXtmc4+lOgBHjxVqbTOxN7tDQMD1rSo48LfsTk7Ua/WCVihXVNnbHZoshykNRgvrfaotk4Is05Fl7Op91tB7DXutFOflbN73S+Cy0c1w6Wa8AthKSewebo2L9xXduCiBfkIHVMnPk5GvE8QkXcP0/GGWUdiwcR3VGtgYv6LM2hmRD4G+TtNFyHG8GY1AtPTa91Jn0Qki9ShzymXykJWBHWRzF1V+Np6Ua7FcsRNRMBkl/+TfTasQxD2Kz3xuDoKk9MUB/jB5XdaSC94BRM8LS2Oq9t+Xp4v695l5PdV5cy/5hSlmTecCs7C6t8gvVN4QYvUWyrl9gVqEXW9q1vxcJ49NqZf+XgapBmL8ysg4qEhExE459i9v2B81wBVPt2dVj06/9F3aakZbsPVaCdEljCyEgirNCW1qzMY3hm2F5HgH5XJwRQxjeeWHLaquRGpBcFfz7AT7xC7CJMP59jlhvIxC1XWGFB0bcFoahPy1RoH8JUxnBfjjX38J3rWr+kPEUU0MN3ReAt7YLvncj7fEInKSzywbCGuwSrmvec9Oa9dHziCzxbqS57LPHkaYh39uhmzrMPHlB5QfUxtzfV/QIxPefi5n7stR7z0TYtAqLWQ1Ca65SlNSFKc0EVthNn/FJUw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199018)(36840700001)(40470700004)(46966006)(82740400003)(81166007)(82310400005)(36756003)(356005)(36860700001)(16526019)(40460700003)(40480700001)(6666004)(186003)(26005)(70206006)(1076003)(316002)(2906002)(2616005)(478600001)(54906003)(70586007)(336012)(8676002)(6916009)(4326008)(8936002)(5660300002)(83380400001)(86362001)(44832011)(7416002)(41300700001)(7406005)(426003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:46:41.1892
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba5fa676-5082-4d16-0e82-08db1372ce65
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C966.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5264
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

