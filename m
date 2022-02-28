Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8A84C62DA
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 07:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbiB1GSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 01:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbiB1GSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 01:18:37 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA32DF5D
        for <kvm@vger.kernel.org>; Sun, 27 Feb 2022 22:17:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pv2KSbwo3OK70jXYK/E/nKdo8iSroAS69iu1UdovgmuFE3pwFNa6fT5nOCdNJDoh2XSR8yneRgOvcohCDhFLXNjzYmgU+50sXanpXK+SOqmKkPiWKgrsBzW3lrwB+bHIWlwU0QxZPCriUfsOe3LrAHT06xoQfPbTFIo4j3/GHpPTGequ3VzszdB8BHuK2oo/G/hFzzybfpCQDvzq9jQVORns+GoHVXqmnxdRK99srBGLtk2uQ+c+ji/IzGywV4oXia1HbVqImkULvlhC0Z2FhhJhG1IfhgOXuf1L0A4/Go1x8Igog8PD3hn7XcwdJcHhnp+G+Ff48DSbuoWBntr6Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuypQLGm+vDqYqcSrtNFpykjWfJ80D9vVjL1PuWRxjw=;
 b=MaEjAh0DXYersiH81FCeDq0RmaAjGKra28+zRiUge2lybJpQe4L7LPz8jOiG09WtUIuoKF1X7JiUMOH1ic5njeEnZf+vAQcj6QiPVrtbuuXp5Wj6XlVd2Le+A5RAKpi6NifhaBv4ar73Sbf2SzmR3eKkUkj2cebs2AR2DV7OqhISV1tIEceTiT8PyT8Jz/CF/A/stFlL5XFGIf8WvIKc+M+M2ZdT3OJfrhstRF5uzAvqzUQouyOlbQ2i32R9MEJcuTZmNSO4n+ds/VNU3nbWzOf6GZbKXBnm9H6REWA704UcFZBM+HrQS4wQc1jCl7HNF+s2eE1D7r5PZkO3YPQO5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuypQLGm+vDqYqcSrtNFpykjWfJ80D9vVjL1PuWRxjw=;
 b=jvvhGmyjbJRpFdOQcURN7Wg1rBmaYlMHbltr72K8H69vHfu6AsXBPutMfzizI30Lczgn46Cx251+iaY3ctDbdnbAoDC81k7qAPXQfdmonRGcvy/r1F2OdZhSHzxq5LLAegkIHCYEGeUlIw8ulAmWf1mkrfa6xTyuCgcw0oNaeRE=
Received: from BN6PR13CA0024.namprd13.prod.outlook.com (2603:10b6:404:10a::34)
 by PH7PR12MB5620.namprd12.prod.outlook.com (2603:10b6:510:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Mon, 28 Feb
 2022 06:17:56 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:10a:cafe::3a) by BN6PR13CA0024.outlook.office365.com
 (2603:10b6:404:10a::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.9 via Frontend
 Transport; Mon, 28 Feb 2022 06:17:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Mon, 28 Feb 2022 06:17:56 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 28 Feb
 2022 00:17:54 -0600
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH 0/3] Move nNPT test cases to a seperate file 
Date:   Mon, 28 Feb 2022 06:17:34 +0000
Message-ID: <20220228061737.22233-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01214297-94d6-41fb-d8f7-08d9fa820f8c
X-MS-TrafficTypeDiagnostic: PH7PR12MB5620:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB5620B5A0A4F34F06F45E6377FD019@PH7PR12MB5620.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rjfnu/eueZUVrUawgxLUdhPLt8dWmTRZWJ+6XM1jRwFuuunUxpO59lE19HDlacPCbhC5Ip17lHXpXYpPMu1oVqW0o8gOwVTLasp2Xol0m8tOKgZOgKokIFX631NSuTE1LdT19cxAq4syYzbkyivvrS5ciiQPFEnLV0wUhr5eCqMU1EqNzSNMs7w0DzfIAvcPn4IX58t79SKqxAFDArluSqHhjl4x6LaNcD6PesFv5ZH/a+RwM9ebL+iX+0sHI9gtA/pjAIMwYOPFKzwQ5m7MKQHRdj+VnjeBxyKpHQhfhDSC42SgX5c246e+e4clGpiKd6AfDnsLdDyrOm7c543kt68Rqxq1QRGgwOse/T43IeAGuQMESf7RDz7ECtc+ahnlXJXc7X73/lTWBf1rrv4r3IP26ggGr1En7cZr/Yo1WuL3Ul2pH5gTAvbBMhEn/FOJSAcD4ROv6wePZRakn7qu7htON/VxnM9wyES7NDPdd/War2EJgVEXIepXRvXA+UTzFfkDMjsasdysEmkikAvPcw+HzQmAypmzY7Vn4szlMftTwmRnbOqPpsYAMrU+ybc/30fKh2elzk0kC6NsV+IF/rUuuYazov/ZO5K6mPbM6mVPeU8VOUKO5EIno7K1VvLUN253wzeyaQm2SihUcBpxYflRQ/tEZwd2NKHnXTY974/aXg957BR6dQwxazVlVwzJ4790Zv/yaEwSdRehM9dwEw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(1076003)(6666004)(82310400004)(36860700001)(81166007)(356005)(7696005)(83380400001)(2616005)(426003)(336012)(26005)(186003)(16526019)(5660300002)(2906002)(4743002)(86362001)(44832011)(40460700003)(47076005)(8936002)(316002)(54906003)(508600001)(110136005)(36756003)(4326008)(70586007)(8676002)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 06:17:56.2592
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01214297-94d6-41fb-d8f7-08d9fa820f8c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5620
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 916635a813e975600335c6c47250881b7a328971
(nSVM: Add test for NPT reserved bit and #NPF error code behavior)
clears PT_USER_MASK for all svm testcases. Any tests that requires
usermode access will fail after this commit.

If __setup_vm() is changed to setup_vm(), KUT will build tests with
PT_USER_MASK set on all PTEs. It is a better idea to move nNPT tests
to  their own file so that tests don't need to fiddle with page tables
midway.

The quick approach to do this would be to turn the current main into a small
helper, without calling __setup_vm() from helper.

There are three patches in this patch series
1) Turned current main into helper function minus setup_vm()
2) Moved all nNPT test cases from svm_tests.c to svm_npt.c
3) Change __setup_vm to setup_vm() on svm_tests.c

Manali Shukla (3):
  x86: nSVM: Move common functionality of the main() to helper
    run_svm_tests
  x86: nSVM: Move all nNPT test cases from svm_tests.c to a seperate
    file.
  x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled

 x86/Makefile.common |   2 +
 x86/Makefile.x86_64 |   2 +
 x86/svm.c           |   6 +-
 x86/svm.h           |   1 +
 x86/svm_npt.c       | 386 ++++++++++++++++++++++++++++++++++++++++++++
 x86/svm_tests.c     | 369 +-----------------------------------------
 6 files changed, 398 insertions(+), 368 deletions(-)
 create mode 100644 x86/svm_npt.c

-- 
2.30.2

