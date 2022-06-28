Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA0455C58E
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343934AbiF1Lk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 07:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiF1LkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 07:40:25 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2071.outbound.protection.outlook.com [40.107.101.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A612E9D1
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 04:40:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdIsWgHZfXkODHjWymOdYhv31GY7b3VKdP7grgnDBcARo17dBXzmmGFU5SrmheBkgNdAnpzLZ4qDGK5su4Y5xS3q9dmaasWuYFPIqzxaNnN5t2qBBxdUODCLXTvVZnDhOE1NIJ7KYHxmeICorQ8eoRkVdwN21UCU6ZzSdnDxMKBLXPnpOZgAsQYE+9biPBeaVWqIkwSe4geqdWg1i9ikt963JcCoqzY1tGtFDNEkukMpTRM/4OtXL3kxQ+DQj0X38NKQYcgw7r9Jto2MWp/SLDyrgXmqMT7Hkap4B/9+9lkECBKnJh4nrpMqm9QCgmKubUzheqGzKo10LosirXu6pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vikDCO8PlHmYkpTMybBvJ/Bj2MpOt7/psYgsi6IutU=;
 b=Mb+jur7Nmrh6JubpEJCQtO2p9bWuBzr5vnjpbEnHltDLxAcfmilYATuyrpp9Zdw92d1MDluBw17SJTcgmNHZqnRepUyyKaUf1w7ozrJ+xTJm56UgfDQLQ8QPThmz8WQl3D2KSEwJ1XAIcikjLQcwVqPI9embBmK3SOU2d6uw2mQemhnijbj/aem3F0Y89I5QP/JSNiPN2ShoWKHrnwTlNaZd7YN1cGyUzmBGZLn4oD47BYdITexIu1dS0udSVEgIBzLrOCgJmbCF2/45BLYs+Mh/zmfTtNmCv5lW3mGOQFE/QcipOpp0/hA0qNjes1fJt4nysWS1eZhySeDtkMiBeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vikDCO8PlHmYkpTMybBvJ/Bj2MpOt7/psYgsi6IutU=;
 b=uF+xKViGmq31UAfcePAFg3bdZCBvmkL14oaSberQlEsdjEAzWGhcokJSfxAlUPGYmSqa6wvvKvArYlPpEbZNN95T7h+GnLxS04G6e7cAabQiMFce9gz9aUqGEDplvNIfR7GSKtYrfrf14a9RFnJS5kJaa3jVYxBoXb9NuAItEQg=
Received: from BN1PR13CA0006.namprd13.prod.outlook.com (2603:10b6:408:e2::11)
 by MN2PR12MB3742.namprd12.prod.outlook.com (2603:10b6:208:16a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 11:40:22 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::9e) by BN1PR13CA0006.outlook.office365.com
 (2603:10b6:408:e2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.13 via Frontend
 Transport; Tue, 28 Jun 2022 11:40:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 11:40:22 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 28 Jun
 2022 06:40:20 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v5 3/8] x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
Date:   Tue, 28 Jun 2022 11:38:48 +0000
Message-ID: <20220628113853.392569-4-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628113853.392569-1-manali.shukla@amd.com>
References: <20220628113853.392569-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18ba9912-f4bb-4800-24d1-08da58fafc17
X-MS-TrafficTypeDiagnostic: MN2PR12MB3742:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eUitJf5hLaFnIBrYm1g8HI4ZMDi7BgXunSDrtuQ0dSTXxwWZVbIDvDaiokRyid2VmJhbP3wjCcEAs8jvxIDhDc5R8DuP542VO+3Mo6azkny1a28x0WUwHzovSUA3LEUc5yPE64fDYwZQaOpMAtRvTIodcOgfQL9lnlkmv5krAahVU9pJPnjO61zreI2F5QMVlltbo+rIwn3fvhYXE0FV5cGnDvslleUbafvTC/ZiE5bhubOpHpTKoeg3JLrtmzeZ+Ma9MgXxvh3q4TFXJ+9onvAH7AuhBWeWtNEhw1DmVkaundgXARwxDWP+yRivlE+5qxgPv07TGkrAvNM/UooGFmRY9u5yoXYlvj7FZUahNltG6wwo56TjvRzl+tw6jmFGux5xVqal9POfBT0VAvHHMgOIqkvQERc9A+OhhhDmxCEsgHZ4nxT3RdPzTan+iqJ7l4lEW2hd8MsGqWKOWfakArWS1zvQvJwM9fUDYj1LvweX3n9WoukVeQs42G/JhCxOvqeeBnEu8uU23d8ZVNXwx2zTcYC3cEkIwKUSNpsHIdr4iVPQpU9BevGHnzLlCd8EJyOd+WnadV5yV0HBTw66vEoyaJuPQYDHiO6BJtH8VTWfZtP71LTC2+0NcRt88MziqNNYxF+mV95QfYsxNIwyK7G96zxiXNl+Exqzb6JjnxThOYNfb5d2MZGcRuDWCSo6cwIj6gF1sseSZyUPVWizwxQdM9UhYIw6w1Sk+531KFUkRCjeMXECqV88Z0SlXFTNz6d+FDq3oE/H40P6o8uEQPG656Z7oIhwA7VRDKsw9O2b81PBGi6LZMte/z2kEDrk08lDiMvqGP4HI+KpdzLaVw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(46966006)(40470700004)(36840700001)(83380400001)(110136005)(47076005)(36860700001)(86362001)(81166007)(5660300002)(26005)(6666004)(16526019)(1076003)(336012)(82740400003)(44832011)(316002)(356005)(7696005)(2906002)(4744005)(426003)(36756003)(4326008)(478600001)(186003)(41300700001)(2616005)(40480700001)(8676002)(70586007)(82310400005)(8936002)(70206006)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 11:40:22.0165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ba9912-f4bb-4800-24d1-08da58fafc17
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3742
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that nNPT testcases, which need to run without USER page tables, live
in their own test, use the default setup_vm() to create the page tables with
the USER bit set so that usermode testcases can be added in the future.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm_tests.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 37ca792..1692912 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -10,7 +10,6 @@
 #include "isr.h"
 #include "apic.h"
 #include "delay.h"
-#include "vmalloc.h"
 
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
 
@@ -3297,9 +3296,7 @@ static void svm_intr_intercept_mix_smi(void)
 
 int main(int ac, char **av)
 {
-    pteval_t opt_mask = 0;
-
-    __setup_vm(&opt_mask);
+    setup_vm();
     return run_svm_tests(ac, av);
 }
 
-- 
2.30.2

