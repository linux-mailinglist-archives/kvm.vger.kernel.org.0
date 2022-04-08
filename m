Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E284F9643
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 14:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236035AbiDHNAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 09:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbiDHNAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 09:00:11 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784D010E8;
        Fri,  8 Apr 2022 05:58:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfWdGGxKkibHows+OObpcdt2AT3POb+e9MsPMTtsSrID6D1F9hmWdoNqo69aFy26hAtRcaupGkKEDhwPXPaienVt4mAyKo4L43+bPR1G6vMvL76g5a4C8SVp3XiGKFuJURN1P+1QvKuEvVwupa8gJi9YNLL7+Li0gE+IW6C8fMJkl542r4zzCJ/18hj6rRqa4q3TeOm2AcpvtxLo/I2OA+eKdu5PBEX4i2q0KH9IV8ZbzQjYNEaqM1fgaIhC+IE7ZcVE9TDYdZR9PFOdtpxSdTa0hMfe9zpjl6yrTkraCAFhdWEx8+ivBBHD0Y7S67tDmiVcobnCnf9nNxGSlt4zGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZCL8Mqtzmb1k1dA8bAd8IZrnchykILZD0XL0mJHJtw=;
 b=Np136gKq/M23wqa3widldqPnQB4qh2dzWWGtU1dqhZn8nZQngeWs3Fjfn9cxKhPfG3srPSHYbZ5i+qUxVj/rfmI5i4ew1BzIWy+GrQTD+5zBAEl5/xHF5QmGBE+QrQcSFMpYSE3R4PGSPMmPiesFkeVv6R0BFlVCAp400n0+Y0yeeemXECpfGZXcY8qmE+cVLi+LKstmRAOn4oeX7Zrg4IRvK3pCC2KkdKQJlRnufoUaQHmqLTnsM3NNFvNaZgdSEVXKxPoBQGb+IQlhAKe1/qXCl4cfsl4kwShJpAJKIugpCpAvuRx7Y+OY3lh05e4f8qfQgygi5YjoMl0nSJt7GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZCL8Mqtzmb1k1dA8bAd8IZrnchykILZD0XL0mJHJtw=;
 b=p9zelp5hEyquH66HooRNVoEwy5U6vbfi+8HHip7sNL+/sxdWpqw9loc5RaN+gIlBnOPfFYSSshe45rDSLOBvQzdNqgKlnlqB+zLNKcaswZe/kSjMiUipTLIRapT1QYhWQDcigEi/BXUhtk8AJ/BRm3h9oKvwpIJss7/dvB7iPqo=
Received: from MW4PR04CA0069.namprd04.prod.outlook.com (2603:10b6:303:6b::14)
 by DM5PR12MB1643.namprd12.prod.outlook.com (2603:10b6:4:11::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.26; Fri, 8 Apr 2022 12:58:05 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::41) by MW4PR04CA0069.outlook.office365.com
 (2603:10b6:303:6b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25 via Frontend
 Transport; Fri, 8 Apr 2022 12:58:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Fri, 8 Apr 2022 12:58:04 +0000
Received: from ethanolx5673host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 8 Apr
 2022 07:58:02 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <jon.grimm@amd.com>, <brijesh.singh@amd.com>,
        <thomas.lendacky@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2] KVM: SVM: Do not activate AVIC for SEV-enabled guest
Date:   Fri, 8 Apr 2022 08:37:10 -0500
Message-ID: <20220408133710.54275-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29973427-8219-4383-eda6-08da195f6bd8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1643:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1643BBFC402E99423BDB4B02F3E99@DM5PR12MB1643.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JMHgVtCzR/y557fLPQffwqX8s+Cc0CsgszsO03bix2krjR+yK0rqZaX87GUsfyrcFkOs/Qb4YrvT+JSK+xsAxIdsPYl5k8PLzZW4HaH9ap/D49Ed2CT49WKbluVMlTOvy3FKT3lwNRjI+cNHy1dX6Fthr9y9tesnyvFTOJ3fwCjD44Dkjyzr3uas1Wcbn9MJFjO8WPl8dJh6JznuiyfISDZxwseR1Zrsl5OPQM+8fLRBe1qbIiw1K4v2Rie8noEQnePgKaJJWScYdIYtCS+Hz9/4Vewb7EUw+WFnaDjgw4uFRrxFAiaDXx1YEgHDF8Nb2LXhxpOpmnU6oBKXKXa19ggiISZitqzqw1c20JVuIN1HfStP9+NWRBXu7rSqyGNNXsuAIj3qL6/iIjqXaLbgK8FdGomPyVgGu+x2f2xqQI5iW/qT/zeCk0GysoXZll/+pZ4RNiZ7wV6mTHXOTNU1I/+bbQARyzP6pr/RVEXge2l+OfBGj4/yq5q7Zd9mi+9DYHFfEmhP0RLyShuqgi2/abYINW1V8DzcAIgTIgeS0N39HrXn08gzzTXcWN4WRvgS227r285ZcWYpXQXeg1PMrQcQvqK8xIJXRl9D66Qyalv5FRy5sMpLYBCPDqm0oB9z8vHe1sfAw+dMSnvURr35dJAuyxi/8sx6Gt81CMqWf1DUwCXcs/af1C0KrmXNcr5sosN6JKZICfj8901g4E25CQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(70586007)(70206006)(4326008)(8676002)(2616005)(82310400005)(36756003)(7696005)(1076003)(316002)(81166007)(110136005)(54906003)(16526019)(26005)(186003)(36860700001)(44832011)(8936002)(83380400001)(336012)(6666004)(426003)(356005)(86362001)(5660300002)(40460700003)(508600001)(2906002)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 12:58:04.6281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29973427-8219-4383-eda6-08da195f6bd8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1643
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since current AVIC implementation cannot support encrypted memory,
inhibit AVIC for SEV-enabled guest.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/avic.c         | 3 ++-
 arch/x86/kvm/svm/sev.c          | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d23e80a56eb8..ee5b0589d2b3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1052,6 +1052,7 @@ enum kvm_apicv_inhibit {
 	APICV_INHIBIT_REASON_X2APIC,
 	APICV_INHIBIT_REASON_BLOCKIRQ,
 	APICV_INHIBIT_REASON_ABSENT,
+	APICV_INHIBIT_REASON_SEV,
 };
 
 struct kvm_arch {
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a1cf9c31273b..421619540ff9 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -837,7 +837,8 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
 			  BIT(APICV_INHIBIT_REASON_X2APIC) |
-			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
+			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
+			  BIT(APICV_INHIBIT_REASON_SEV);
 
 	return supported & BIT(reason);
 }
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75fa6dd268f0..6524409f8e07 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -260,6 +260,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	INIT_LIST_HEAD(&sev->regions_list);
 	INIT_LIST_HEAD(&sev->mirror_vms);
 
+	kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_SEV);
+
 	return 0;
 
 e_free:
-- 
2.17.1

