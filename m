Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857C63E1DA1
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 22:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241387AbhHEUz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 16:55:28 -0400
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:5014
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241061AbhHEUz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 16:55:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUBaIbHUE8lm+28JSZ4v1SqeR1YXBO7sARhsKdLGEUN8JBsRJjriraFGpQooZllB4PviKaxSZFrRXq/opX7im9wdSPAgihlV2D+dXz7RgHsLhiftQB8eIw6YVSum9b24g+UKMXFYXhTsUFQyNnTJgcjH38rEvNfPXYwECGq5NkI/fJ/Pl8YTrxvB3TZUhRBTEjUaJpZDf/EBhGXvtB5TfQcw+eZSGe+G0K0VpcdLujWCJyNhIlrhC22f7sfAs30uuLvsif59AJbSLpRDrW0XkF9GcZ42g3Lg43Qmx7EXME8dzUyGVLjBIEiCwYMqUM3EH8X2tDKZaF2OBcw6nVULUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UM/sEPFxzYzHFWfMopjtVvkHRepBpyKVzFJASlzLlQ=;
 b=ej/of163xYop5vRwSUUloZWhBDj1jb4OGY023J3oF54yYN+qng9vzHvuaBhooDvXDmJd91TgSLQV97VhNllDipJ4q5VgBkS0pO+bZftaJH9CG5oLnq5eL3slR8AJvFBkKHya0Z0RNZYOAp6VAKzw23qiEm9G1iBRtQAIPoL9FQxHr4QRFzIbS+I3RSbyynDdyFJMzqlyknoCo+WusCG67L6MfcL/xNC3a+BDZvMI7mC+xPWNpJULR1IFAlt54VzH9UiMw7sPHoC4BTu17uKWpMviRkosQMVPdIcPnmfOGeQX/DzAGnQampzO/FvOGYkj3qssLVul0LVrLUwfJLo9lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UM/sEPFxzYzHFWfMopjtVvkHRepBpyKVzFJASlzLlQ=;
 b=LokdF26wdzGr8nDa7AFNsqnZ/ZHzc/NHTNOOLWSi47umsa+xi9Tnh5Hdg1wuhBYaYT+U+R6QdGrhkiN6Y4JgWwBhgY6vcKNSfspighAWMXau9j6kNGWhG9lEyUAsWhxgrEpeUHxGQsU+GEcCYVVwwoxzYFJgdkqWNMin+WH3oUM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM6PR12MB4010.namprd12.prod.outlook.com (2603:10b6:5:1ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.22; Thu, 5 Aug
 2021 20:55:11 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 20:55:11 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        wei.huang2@amd.com
Subject: [PATCH v1 0/3] SVM 5-level page table support
Date:   Thu,  5 Aug 2021 15:55:01 -0500
Message-Id: <20210805205504.2647362-1-wei.huang2@amd.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0078.namprd04.prod.outlook.com
 (2603:10b6:805:f2::19) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from weiserver.amd.com (165.204.77.1) by SN6PR04CA0078.namprd04.prod.outlook.com (2603:10b6:805:f2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Thu, 5 Aug 2021 20:55:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1ee9554-884a-4a82-408c-08d958535093
X-MS-TrafficTypeDiagnostic: DM6PR12MB4010:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4010127C14B1E9442909526CCFF29@DM6PR12MB4010.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OSc7VU/e5KHkXz/dvlejOCKrKbFcIM697WYRzHMSjrN56aunwby5PDAxuM2vsGmK3hseLfSBmTu2kOmnLxGTQj89I6CJeNI8zwut2hLwCL8cECf2GPaAmk2n2+6aWiFbhNwi1rvX33/UKLt3cLJE434CsmoglgNaXjmoGZlYijrfIb/6SfrDFBZl1IiWadQjWCfyGq8glkRyHUx7QtTUicYRufrkeIPzn3YgmFObNxGbvaU0FDXjrNWU3z5sT205a2sRM2ETaHZDW3ocfHUwvE0UNEgbFdazBJCImXdnSyo/4WQR5LpiilXACwCekA1+GwFNn9AUoriZCGPdd0J799P4yEKCaWvxZTixe4RPT67J/afivjHkzfQPu+DFsRzThC7aoNu06F0sk5xJRfbTMkYe/F4n/vUqeJ4gxToROb0YDGVzkbk0EdOmf9YnfKXjnbwGLtqMWAFGX4vwSN48oq4bm4rTQRvaGKEAJnABDysrrOqomahrgQak6R3yKvpZVuNeufbx45m6WJMedOgIsLae5rYelP0MnzCFElQzBn6SwUaw0DFNZiZA4IyontLZ6t/xeMgG0acZNM5FYu5M9rdYjVXGyT/udHgNeGwXyDSXXorESmj8TNdOdnY3EQT20yW/swzx/k7lHHsBcjWIo7h70M43RnMMYlrz2GpvIulVevteL3vLeWo5m1lAclKIVBI391X+YWR8BfBYr/e3Ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(86362001)(1076003)(186003)(66556008)(8936002)(8676002)(66476007)(7416002)(26005)(956004)(66946007)(316002)(2616005)(4326008)(38100700002)(5660300002)(4744005)(6916009)(6666004)(2906002)(7696005)(52116002)(36756003)(83380400001)(38350700002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mo/V64MJfudBOgxy7nX6dVjErNYuIVJ9R60ZeSwCdMfRYdwuG1Mh77N5npDg?=
 =?us-ascii?Q?I/okCZ7dKI/A+yHs/ycV6jvFTOoXIuYYmL8T3G9NSl9K28wgUa5I66eppJxE?=
 =?us-ascii?Q?bStw0MPqh5CVG/lTlF6FW6KMp/fNLvNO/5LFNXhwPaSgDHg2+MeEtDvy4+aR?=
 =?us-ascii?Q?ZtOWjJceIRV+PeVdGV9wabZulNTKGDjbsrxArPKjkDy/2UtSzY5brYEl1Qh1?=
 =?us-ascii?Q?S5ae1xwOg88q1Q0eBSz3jiNKDO4+GPVH0dZfHH4phWbDEAV0ZhJPhc4mw3ty?=
 =?us-ascii?Q?KK7tqjnW35kP540jmn3zfWw7lwO6M7e/0TlaffUqc1jgfG2F60XrTvjY4MBE?=
 =?us-ascii?Q?biT6+ZdbOkVO9uLcRlgVfofbXompR8WfBgIbw9lJTGFX69dwV7dq0Bc5DGTz?=
 =?us-ascii?Q?hf7phLXFmzWLQwIOrNrRzGIn4I8JHD9gQh3W6z4VX4fA6SYJ6RdyTGTz8J0e?=
 =?us-ascii?Q?9CN5sU9O3+/TnBpcxptCoPNROAPWsn+O/xnLP6Ttp5F2IUOWpaA1wFxj9j9c?=
 =?us-ascii?Q?vggb+grES4bpfzPCks60Y2RXN4sbUO6B4Sx7t0pggeTzCGuR4JoIJ3HLbNRT?=
 =?us-ascii?Q?g3NzNfAYJOFMz1rbGp677edJoxP33KH5LcomBW9LzVZn7IL3D/DQBK7H9y+n?=
 =?us-ascii?Q?z3J8k0ZMenZbN/1TIAoek0DaR8hCDCgaWKsJ/Owa5pFpaHlSnohwKuIClWGj?=
 =?us-ascii?Q?Szj/OZX4SIvIyY67uDvErHanBxVNcyNHDwO95o5P3IIngZn3OSlxdJEoc6Uz?=
 =?us-ascii?Q?L/SdJeYkdbARnGD0fjYhFwyPcsswq6nH5Hb8rfnY99eSncc45adla4ZVy67G?=
 =?us-ascii?Q?bBD0YSpcF63aHTFhtSIM2ZAACvhAhjqOya9KJKVqzp5m1xOCx1gWnjSQ7o+4?=
 =?us-ascii?Q?wtxjIqAs3I0RsKjz/r10d9/YMHohLLKFPiEyEioMfSRqEDF/1spbA8VkQwqA?=
 =?us-ascii?Q?0nefPc7aGoJeE8ce/25ze/EFYpMj6H1OqlGTJcLpOUPXlMW+zlfjOpO2chbW?=
 =?us-ascii?Q?hZxfg+nfdVFwI+8yNySPk/jQkB9mR48VEpUZwMzuzVbtIO8pqqsP0Bm4Fx3Y?=
 =?us-ascii?Q?8GyCQ0tf8c6m7hPoLYtDd8VrslDTxfHCHq3UvXMI0a/O5OYOMw2QCM89KQ/p?=
 =?us-ascii?Q?gTS1JAPbYNQ0jgBLHB22plImmk1UAQ7t4Xpg3AAU+HzMYMlKYZ8EdSTeO3Eq?=
 =?us-ascii?Q?GoXK3wlB5xwwCJMT32VcUKf95U4MS4iGkUbJM+eGVJArhMN1tCeIcM21/6BJ?=
 =?us-ascii?Q?WWeo5ZoOpRlTqOoKxKoF0r+OtoUn0EIjpD/s/oMkcuIELJ7RceK4NItCcibX?=
 =?us-ascii?Q?UCjsy6a5vV5fAxUOdEPefGv5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ee9554-884a-4a82-408c-08d958535093
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 20:55:10.9322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B76mucORqkRorseMEV2BZEu3SAYqQe7SsPt9ReBGD4qZEZz1gatqq/VFIlWkP5KR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4010
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set adds 5-level page table support for AMD SVM. When the
5-level page table is enabled on host OS, the nested page table for guest
VMs will use the same format as host OS (i.e. 5-level NPT). These patches
were tested with various combination of different settings (nested/regular
VMs, AMD64/i686 kernels, etc.)

Thanks,
-Wei

Wei Huang (3):
  KVM: x86: Convert TDP level calculation to vendor's specific code
  KVM: x86: Handle the case of 5-level shadow page table
  KVM: SVM: Add 5-level page table support for SVM

 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  6 +--
 arch/x86/kvm/mmu/mmu.c             | 68 +++++++++++++++++-------------
 arch/x86/kvm/svm/svm.c             | 14 +++---
 arch/x86/kvm/vmx/vmx.c             |  7 +--
 5 files changed, 52 insertions(+), 44 deletions(-)

-- 
2.31.1

