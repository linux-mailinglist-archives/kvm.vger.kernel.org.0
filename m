Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C09652C01B
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240179AbiERQ14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240205AbiERQ1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:23 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE09B36DA;
        Wed, 18 May 2022 09:27:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dfy9562bWFNuej34ofpqBbEnJLvln1pJTuAV6CgYi1A5745b45+ONuj17HYvvXeXAxUyAbwKgmnEmP2Le2XZa/XysB0XNn1ZQ3XiKT4/Od6/2s46nDjnfSYbWpeZ879B6Bfhp3Uqqguec+n4+k8mNQe00mHsr8U5r4U/CL0MTXFAUf9ERttWlCKvcKgErDnLeeFjLDcvmUciGoHF0uvad76jcruCiFLdnKuzO52Jxn0+WzaOlqOzuKvZK0v8rUeSsiw48iYAuAYlup4lArScpTCkppzT3/1PoT8I/jhUh9zQWz1m2sKLLo70oPe8spVGUbVYqs20b37CTa3Da/zDng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=An59Audd9Wb4f9DlFPkPLOYObyXGIgmHhDYd1Z0I8EI=;
 b=QWWaWUT8A92FheNfn18WVPQED6zKVlr/DuDbyrOWYqkRNLjyr5LsvEMlMa5+PcGq+O08Jrrbie/8GCzqGsUzHmYmAZtKcGY19mgyfNmqTZA5+WEmPfBO3twSQhvR9TPDRmSFZxs8SWhVGVgFhsAjd8jLFqY4Xs5/7kx5qAKtyT3+VcnZLwMd4HzwLBZp2V/u4l1/+wY58ku3USvwdIZFc74wTovOTL6Zld0eEU21YhjIcbO/k16/cgOwWaSKYddbhvGXbJbeZkkUiyZO7NBFDqNqCCfVUPlHrhDDP8khpLusBw0MPUeaW5EQsIebEN16EKGF8Z5WoVooKC1MZN0qxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=An59Audd9Wb4f9DlFPkPLOYObyXGIgmHhDYd1Z0I8EI=;
 b=Cm03bWFe0ILAbOZ0tlFCB6qLL9soTApgCtV8lsu7nmm5tUZf+3k1nT6qZagbUoIFuUMDDZENRratQ+X5Jvsp4FMKgK1ZI+j516iMeQ7sT2eYLjo4DknHYC7m6V8enr8PatxUMrNDg+ZgSwOkkvTuyKilWclIbturYw5Y2a3ces8=
Received: from BN0PR04CA0161.namprd04.prod.outlook.com (2603:10b6:408:eb::16)
 by MN0PR12MB5716.namprd12.prod.outlook.com (2603:10b6:208:373::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 16:27:17 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::76) by BN0PR04CA0161.outlook.office365.com
 (2603:10b6:408:eb::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15 via Frontend
 Transport; Wed, 18 May 2022 16:27:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:17 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:15 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 13/17] KVM: x86: Warning APICv inconsistency only when vcpu APIC mode is valid
Date:   Wed, 18 May 2022 11:26:48 -0500
Message-ID: <20220518162652.100493-14-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
References: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c596a9e2-da21-4362-a017-08da38eb4675
X-MS-TrafficTypeDiagnostic: MN0PR12MB5716:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB5716F2B43BB62ACCDA3BA915F3D19@MN0PR12MB5716.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HaNo7N7woNoZ2hBvKHo8YKQ7PpvJnlLZV0BfKH7nJ2NaX6ip8Auyc1DL1fo8TFfP+nCBdvMUI4QnZ9DW9MOkEkGWvUjk/Tk/drR0hJmlvoTvq7yJaMp/rA/atTtrUn26TFEEAXf5QCViOIIFG/gCY8ezeg0EPoCBYn4wOZWcWvZ+GHJGwRKrZIXIDHQIAIQwr4vrLduajX9vkb2lUbFZqojO1n+6kmAkELZTegMRVfIQmATQkdFq1xGhdkgfC4Jeq3DvRtKAdYntxZpDWpGXsmZwllhcHkxKJP4qj/X+ydGQvuRaERY7qrO8f6+MXh1EliY1lbxPnI1aZVDPGlviccAxjyQj8pV5DOi3N9aQCxWo0yBQ72wTzzUqpZhM4bB+8Do3Wyc4lHMNthKDApECphwcDds9IzoE3D73cpG3WPjhkWplx/XZvXK3IH6vs8HJrVc/hT6fXzF65QUS9YULizeRyzRqN7p7iCy8vTLTorMJV0BzUUkqqeV3p5HEst4LiK29nvM6PXdm6Rz7MuOJiNbFpuu/7qZc39cjfGElpHhDCVnnndqTtJTI9HZoX/pa+QWw45G27xkSgPZZS7N/8yJA7M6J1kZy0aS+VhgIzKhmfcJ4A9/dTvmw+IOjFHU7pAy9Xo79Wyt2ldVhLUkAQZ4e/wiiNvdHM3IT/aqNqUF+ctRNlcJknlq462tIdRQn/r6Lty7IbwXQWmXtV0beWQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36756003)(8936002)(70206006)(82310400005)(70586007)(6666004)(26005)(4326008)(8676002)(44832011)(7696005)(508600001)(110136005)(2906002)(54906003)(316002)(86362001)(186003)(1076003)(336012)(426003)(16526019)(2616005)(40460700003)(36860700001)(47076005)(83380400001)(81166007)(5660300002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:17.6149
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c596a9e2-da21-4362-a017-08da38eb4675
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5716
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When launching a VM with x2APIC and specify more than 255 vCPUs,
the guest kernel can disable x2APIC (e.g. specify nox2apic kernel option).
The VM fallbacks to xAPIC mode, and disable the vCPU ID 255 and greater.

In this case, APICV is deactivated for the disabled vCPUs.
However, the current APICv consistency warning does not account for
this case, which results in a warning.

Therefore, modify warning logic to report only when vCPU APIC mode
is valid.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 77e49892dea1..0febaca80feb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10242,7 +10242,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		 * per-VM state, and responsing vCPUs must wait for the update
 		 * to complete before servicing KVM_REQ_APICV_UPDATE.
 		 */
-		WARN_ON_ONCE(kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu));
+		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
+			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
 
 		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
-- 
2.25.1

