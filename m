Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8A955D48B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344546AbiF1LjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 07:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344348AbiF1LjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 07:39:19 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2044.outbound.protection.outlook.com [40.107.212.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563E91CB3C
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 04:39:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRr8jgJNYlJxsnRFXA9jqD5QgoZDeL303++eAi/Tg2wRmZGWC2vxtsqm4gc1GcXO7t6oxINHHgiYAXZRPLSS6u1wT8HpzPmOk6RAFxVynn34PkS8gbUeubiozpAHurTnC7/1FNg1BTPpA76G8clY3juSs84ZEleRNSZarqem/INbEH4EKPMDSCmcN0aGBrUaFGW2opqh2WjNv6Uix8YJv1IkD1/dWdJIDzCWzu1uKqEnBS3Vw/oZ5KuipOAnqX09EovIexn2sIbpEC1ZMDNPgfDvXneEPrb5Z7kUVr8/+SowKmV6EuvNWLeoN3r0PHKyFTeGPCfzxZjVBmVx19KTrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lx87yyICiFWPX9GOVxGvn49mdjLIF1DMANXyi1kddJ4=;
 b=Sq8iTyPyxAi//x+oQF0nBhfsHahRLXmoE3sd8OjVOW0XK+h5FOQLaBBDqyiY9ViOyZPUN0r7IRZxb0TiDobwEq8syEOqiWHzo9qfsSRyI/wkvRvy2mBgtYn+12Oq0yhqCrz2PG3HHdQXrJbxiSAurrHbaCqaTkgPgBej8yXYLqEC+0TOsSs1xuwSfD5Zm5xTFZ6VNQP+pxMVk0sWiooXdnAU8hDO4qR5XrvfYlvwgcrLkHBld1v/Ry181a47eCXAyLw9iSpmU3z1lwfOHakgjm1UJV9tQNI0iqHiDFnJ4rM1sJmSuCHc7FNUOlI9ukPY/Z2eDP24u3v7+kx06BNJjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lx87yyICiFWPX9GOVxGvn49mdjLIF1DMANXyi1kddJ4=;
 b=fUfc2IlnWDSpT4oJc321o4vzTRU2XGdQPqkYyUjdgsiP1wsnsNn+HZkRZN4CfdsG547THepxt+4FJbeO/1FOra9Zl+TmS1VL/KqusSfIAUjfhJ75Gs1tKqrNvvL9quVC5Cl3D0hiTCuH8RTZyy/oU1o39CrNMlOWcaGVd4weceg=
Received: from BN9PR03CA0740.namprd03.prod.outlook.com (2603:10b6:408:110::25)
 by DM6PR12MB4433.namprd12.prod.outlook.com (2603:10b6:5:2a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 11:39:12 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::c6) by BN9PR03CA0740.outlook.office365.com
 (2603:10b6:408:110::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Tue, 28 Jun 2022 11:39:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 11:39:12 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 28 Jun
 2022 06:39:10 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v5 0/8] Move npt test cases and NPT code improvements
Date:   Tue, 28 Jun 2022 11:38:45 +0000
Message-ID: <20220628113853.392569-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d50612c0-9bb2-4c2d-29c1-08da58fad284
X-MS-TrafficTypeDiagnostic: DM6PR12MB4433:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /seau68M2EkhkmkJ7NPBVBWTeeXKtkuv9mG3kcr8t3xoVtzuPIPKKPC3D8al3x/p+TuQIyHHjJ+sKMBd9cIQ8YBa1eQb6jc3vi1jCbSQlmUNwup4WH+0ssu9FZtXqC1RIjy7T4nJgOmSGeBE3AWNbiu9rS50uy7A78BaiN2h+J8+FpLB7vn+FbBtx1TvosJ18Awa6KbmpY+BQNhw5p20pG6h61J+h08hcC+WLGoIzq8jiUNOm1FORCJYX4/Nfp2xzOfieMJbZPd5bQ3A0bYnbhozoujBPXIyL4NjNxYN6siaiT116rFXx5FK18+/3Vs7FaGzFH7k6bcOwA/+OPxHw007zYlN0vA2iBDHcQE+WFZmY1L5Ll+Ftwzj2G3fk9ey7UnpGqWJeV0NZHn5CQM+NBoNv8B8ed7JbD4s61bgpKT6BBTpqHku+GVrGauE6CITqUUWz8gEm+72C3Pouck+WeXZKuLHTL8MI+BfgmuVMQC5AnMf0CN9kARtO1y2ziPbAqyO2qfHrSJqeZhQW865qOoL7PUGwaOvhlV5tMhFCv/m7Z5/yrHvu0hBrNT7r7JZgBxHwkBBJKA0heTMX1wX/ax7jiE8grlPWCrgdNiZjVdspOkkDbFEqDs8uCtY8cC3Njym1CyLZcUmzMsdzs+uHzuysCxhqCy5WWe5+oKyM+1Y1nweyR5MmUN66knxbZhcvy7zGGc3A+HaCHz7861GwIAKSQtfXcK7qIJOQzx7kBeS6KFtMIv6Tq2TVQ2rngCXAnxsbUamR8FHyiNLdV0RNePXjX9eI3PL6TXNfLfI8qcC06BAkTCnEqjQxEslOxacUbZmxSWXO09UUAwtul808A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(39860400002)(136003)(36840700001)(46966006)(40470700004)(8936002)(5660300002)(110136005)(70206006)(70586007)(44832011)(40460700003)(316002)(40480700001)(86362001)(36756003)(83380400001)(356005)(336012)(426003)(2616005)(186003)(47076005)(478600001)(82740400003)(82310400005)(2906002)(81166007)(4326008)(8676002)(36860700001)(41300700001)(16526019)(1076003)(6666004)(7696005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 11:39:12.2666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d50612c0-9bb2-4c2d-29c1-08da58fad284
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4433
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If __setup_vm() is changed to setup_vm(), KUT will build tests with PT_USER_MASK
set on all PTEs. It is a better idea to move nNPT tests to their own file so
that tests don't need to fiddle with page tables midway.

The quick approach to do this would be to turn the current main into a small
helper, without calling __setup_vm() from helper.

setup_mmu_range() function in vm.c was modified to allocate new user pages to
implement nested page table.

Current implementation of nested page table does the page table build up
statically with 2048 PTEs and one pml4 entry. With newly implemented routine,
nested page table can be implemented dynamically based on the RAM size of VM
which enables us to have separate memory ranges to test various npt test cases.

Based on this implementation, minimal changes were required to be done in
below mentioned existing APIs:
npt_get_pde(), npt_get_pte(), npt_get_pdpe().

v1 -> v2
Added new patch for building up a nested page table dynamically and did minimal
changes required to make it adaptable with old test cases.

v2 -> v3
Added new patch to change setup_mmu_range to use it in implementation of
nested page table.
Added new patches to correct indentation errors in svm.c, svm_npt.c and
svm_tests.c.
Used scripts/Lindent from linux source code to fix indentation errors.

v3 -> v4
Lindent script was not working as expected. So corrected indentation errors in
svm.c and svm_tests.c without using Lindent

v4 -> v5
Corrected commit messages for patches.
Incorporated comments provided in setup_mmu_range() function.

Manali Shukla (8):
  x86: nSVM: Move common functionality of the main() to helper
    run_svm_tests
  x86: nSVM: Move all nNPT test cases from svm_tests.c to a separate
    file.
  x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
  x86: Improve set_mmu_range() to implement npt
  x86: nSVM: Build up the nested page table dynamically
  x86: nSVM: Correct indentation for svm.c
  x86: nSVM: Correct indentation for svm_tests.c part-1
  x86: nSVM: Correct indentation for svm_tests.c part-2

 lib/x86/vm.c        |   25 +-
 lib/x86/vm.h        |    8 +
 x86/Makefile.common |    2 +
 x86/Makefile.x86_64 |    2 +
 x86/svm.c           |  227 ++-
 x86/svm.h           |    5 +-
 x86/svm_npt.c       |  391 +++++
 x86/svm_tests.c     | 3365 +++++++++++++++++++------------------------
 x86/unittests.cfg   |    6 +
 9 files changed, 2034 insertions(+), 1997 deletions(-)
 create mode 100644 x86/svm_npt.c

-- 
2.30.2

