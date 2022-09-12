Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717D45B62FF
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 23:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiILVrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 17:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiILVrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 17:47:02 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C074D838;
        Mon, 12 Sep 2022 14:47:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNOc0W4fe118Lq+qjNp3CFCPF9OQWg6R7dSojfG3My06nHsIxuS402XfhPc/G4YITns94EDBaUdd9IUspVmgOOPoNgIolWyPcW7wCrp3jvcoddKYt/xD45SpI3dDdXO1jpx0TLnLNLVk+gmW3sJK2BKg6XgQd0cK1exzLqBRB1/Jh1/RRhazyz70saYBIs0DqhAAGLlL8lyr4BJ9UxmeGiUHyUiWAZ/0KPYnLBcZwhFCZre0K1bMcpz5oHNXPi8YPajVwe48dgAf40zE7tYfOLouyG1oNOxysnWCz+Oy01tljW0ubFaBRhCvJgYmAMq3SKxcjVidGnXHdvvh2g/9cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VM7E2ybbJYvJwT/it1c1P4gBvYGJJvYoQ2yKVw6Mp90=;
 b=G5kemSnGv5rjjoogFg672/HFGirFYDhmE9d4i3Y/m2Wcgba5ReyCTPGZ0RyDSXHwHdKMdH4yEV+3zYPj7nCmh/QkiFJbWd3uPcPZNxdltUz9PJgLR7VPmdPUEBUOJwuRiKSRpOfr5KtZLNlOlf96PMyeBAOFNfWjvJtMvf2yTapnT2egyBZulX8OuFnsMAJdq+bhBvnrL28ujzFXeiresSzmC7vesO2HeEM4eQ+HdbFjPuSz3/Ndee9pEaSwIijnN39SEDu+m4nEnD6k9PHZCsiwOHYBdX5xgwuaGo6SL0s4/hR2uPbO2mI4do8NCK6IxWlP1dABMKgCcPb/6vPIDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VM7E2ybbJYvJwT/it1c1P4gBvYGJJvYoQ2yKVw6Mp90=;
 b=yXcdBfT3xYUZ4bTFCD0l6Yt70bn4JxquERCiB+WYpHYqCMenpKJbbCJdZdOOo+EfO/+D4YcIo7NoO/dyy+1LjmyV2YeP8whhDvia33QkPuf/3dH4IzNloLiV94OWiQYQtLzyVaTF614tI+0dVzVITKkKGN/8Nb8RNDGy+5pCaTQ=
Received: from DM6PR11CA0014.namprd11.prod.outlook.com (2603:10b6:5:190::27)
 by CH0PR12MB5025.namprd12.prod.outlook.com (2603:10b6:610:d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 21:46:56 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::dc) by DM6PR11CA0014.outlook.office365.com
 (2603:10b6:5:190::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Mon, 12 Sep 2022 21:46:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5612.13 via Frontend Transport; Mon, 12 Sep 2022 21:46:56 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 12 Sep
 2022 16:46:55 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: SVM: Fix x2apic logical cluster mode decoding and sanity check
Date:   Mon, 12 Sep 2022 16:46:32 -0500
Message-ID: <20220912214632.14880-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT055:EE_|CH0PR12MB5025:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c817b3d-944f-4cce-7a35-08da9508504a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OTGAB31oymUecwdVfget/hK4JBGuC/ef/y1kIxJXmFH72xUbt/132eUCA5aCypRowXqa5sZ8hApk+Toq/5DlIunomNrXbt7WF/4JWt2NmAQv+GY3BYtm4tUeWHlMYi8UfVPwTuuCEnsRbkaI9+uXvc1m9rSAIdsc/PEjoHGtSpPRUx4Q+OvNJsDtHVWARjcUygmBYTDCiZ3fZlmcoGYVnOB4QqLlxrsZVOsjwx9y5LwrIr1Xt18vFgsPZqRs+GGSlzQCa6d36qpOrcUF6kl7gXwKlitsTOMj1bJY/SsYz5bKvYHbXQdlJRLVAh2Me+e9Jzomppk7cQ5h5sgYpPq1v5W9JNxULcK8Edp7UFBBpEAnNKGZmtQ+1dbvBZDSsjchSfWcMuK6rKA1tw8/7ix2Ww+gpMpBpLWBO230jD3CGgA+dj4KiMNApQzbNq5foOGxOGddeLovANdYo1aY8vwz8Fyj+f/t9uEZwAJQAzN/3rYUvXoxV0K+MrbhLaRUw12K/rhzmwcxJ1u8uh5df8ngYg/FTNDD9NnwSR61mXH4vxzkdp6+qBfdwmUXxDlwUj0rbE0brxXjMYW+wDW6TZHn4Orqbr8GtQrerVz/X1kN8iTMxhHe8EHTt6nhhu9igph2xkNkIc7Htr6is901vsQTIIYRqo5HT7BbMwCbHUKFtGOkxYKp1JoZe68dSus/wMJyOtV8SgA3uh66+cg593nEWLzQECOOl1puPkK3CnCSxKTCUKWD7x+/4SCJYoXOOKWnoiZI2AmsS3zqNKmccDgJpPqTeMbftt4ivS53jfwj6kbmtkSv6KKoLTUDIEX8B0+1
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199015)(40470700004)(36840700001)(46966006)(6666004)(41300700001)(5660300002)(54906003)(70586007)(8676002)(70206006)(4326008)(2616005)(186003)(1076003)(86362001)(47076005)(82310400005)(426003)(16526019)(2906002)(8936002)(82740400003)(316002)(36860700001)(478600001)(36756003)(44832011)(7696005)(356005)(110136005)(40480700001)(26005)(83380400001)(81166007)(40460700003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 21:46:56.4744
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c817b3d-944f-4cce-7a35-08da9508504a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5025
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When sending IPI in the X2APIC logical cluster mode, the destination
APIC ID is encoded as:

  * Cluster ID = ICRH[31:16]
  * Logical ID = ICRH[15:0]

Current logic incorrectly decode the ICRH, which causes VM running
with x2AVIC support to fail to boot. Therefore, fix the decoding logic.

The commit 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
also added a check for multiple logical destinations before using
the fast-path. However, the same logic is already existed prior to
the commit. Therefore, remove redundant checking logic.

Fixes: 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6919dee69f18..45ab49d1f0b8 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -378,8 +378,8 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 
 		if (apic_x2apic_mode(source)) {
 			/* 16 bit dest mask, 16 bit cluster id */
-			bitmap = dest & 0xFFFF0000;
-			cluster = (dest >> 16) << 4;
+			bitmap = dest & 0xffff;
+			cluster = (dest & 0xffff0000) >> 16;
 		} else if (kvm_lapic_get_reg(source, APIC_DFR) == APIC_DFR_FLAT) {
 			/* 8 bit dest mask*/
 			bitmap = dest;
@@ -387,7 +387,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 		} else {
 			/* 4 bit desk mask, 4 bit cluster id */
 			bitmap = dest & 0xF;
-			cluster = (dest >> 4) << 2;
+			cluster = (dest & 0xf0) >> 4;
 		}
 
 		if (unlikely(!bitmap))
@@ -420,18 +420,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 			 * For x2APIC logical mode, cannot leverage the index.
 			 * Instead, calculate physical ID from logical ID in ICRH.
 			 */
-			int cluster = (icrh & 0xffff0000) >> 16;
-			int apic = ffs(icrh & 0xffff) - 1;
-
-			/*
-			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0])
-			 * contains anything but a single bit, we cannot use the
-			 * fast path, because it is limited to a single vCPU.
-			 */
-			if (apic < 0 || icrh != (1 << apic))
-				return -EINVAL;
-
-			l1_physical_id = (cluster << 4) + apic;
+			l1_physical_id = (cluster << 4) + (ffs(bitmap) - 1);
 		}
 	}
 
-- 
2.34.1

