Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E126A51EB0C
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447159AbiEHCob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447061AbiEHCn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:57 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2014811168;
        Sat,  7 May 2022 19:40:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgemcRA+QIjwnczxeh7/RxUhrC3LPM0UdhaPwYHI8Y/K1NB7gqAmIwj/ulheiDBhq9mDgMjQYpCV6ojDDDaDBW7rzfRuelrGMAkCjYC6Npr9Pfy9w64pq84JT3ipBJjQ4xXk44NDCRXuku8pwOA/oqBoea1BP/dadzkrXng6t+565FdRttKlvPUjkQr8Ly67RhVOKIKnh+CVKo+RebtiaxsXmR1CBb9PfOg17iAKG5QsgTM5DsI4VwIJXqSDgEeSPO2gDSPXprBEQC3G8WJOibAUMJYet0u474eMAJEvcvZ4JH0O7SskNX4AcCfPz4BwpTMWvQFvPBYLzBj25ciuLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jdyf6QfNWnobUEnIuwoHTDMZInm0rjNcd7dkL2SvxpU=;
 b=dbPrJoX5vFlQ8bNlcEk9u5epD/PyENu7TxqefQ+AC7dxkQqRY1NLar9ui1hWnR/vIziCihP4fPqhWcEPkyPSHdwUIAGrFacTpE4PlsCqJwtK6pAKj3DEuuLhI/YwuO+SLQLOIKtzzr26MHX649Ii5n1YvVV6iOSRlakJrH9zL4GAhZm+WPUYI8CydX6y0f7JuksI4oKkzlCI6kJpFVaFfTh4FV6aqyjzgHw1K+Hr6+GQ7lgXtBlDo/MvCfqtlPCygXgMyjrWZoX2qNkX3d9Dcqji3kqtyHlOnVwSVPDDUaAC45gmGLTMCoPFTzJYxcEtfbvEY504Fx7t502MVKoi1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdyf6QfNWnobUEnIuwoHTDMZInm0rjNcd7dkL2SvxpU=;
 b=zfsv4r3iR7RKiQnsl2EgLO6/db/byb98RunBn8HmqcFj9A8k8KuUPICzmswu3nWX7II6izZ5wMKrHoTDCUxNa5EBo/Yl3PiPhgAqk+sC0PelbU4RbSuWuf/xM/v271F/zsAKZfUHmy1cLeT2bYHW1Ye9H1oiVp8Sc7+rbcxufDE=
Received: from MW4PR04CA0054.namprd04.prod.outlook.com (2603:10b6:303:6a::29)
 by MWHPR12MB1325.namprd12.prod.outlook.com (2603:10b6:300:f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sun, 8 May
 2022 02:39:58 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::b0) by MW4PR04CA0054.outlook.office365.com
 (2603:10b6:303:6a::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22 via Frontend
 Transport; Sun, 8 May 2022 02:39:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:57 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:54 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 11/15] KVM: SVM: Do not throw warning when calling avic_vcpu_load on a running vcpu
Date:   Sat, 7 May 2022 21:39:26 -0500
Message-ID: <20220508023930.12881-12-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eae4dd54-8ecb-4e7e-e8ed-08da309c0ab3
X-MS-TrafficTypeDiagnostic: MWHPR12MB1325:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB13257E1BD0210D7831816CFDF3C79@MWHPR12MB1325.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 815Lju+MvyV6x4OoSFT4PXrzgoyWMoUs5fJXyv4Jo5czq2wb6e0SIs7HgDILOYuH1ubfHaagFCxiqTZHU4BUQuvJJ2U3ovS0be3vkx56FIQNjo2do8hIBjKxVhsP2RQhpe/gMkBqRK+oOYDhbZojSYgpz0ASQ6tOHqBWQ0XUJ6vY2tsjivReeB6uzzybhp4jrIZ6M62iVPCtCKHiLl8xn1vJJmQB7pRE+BMrJXY1DsYSdbtYJ/RtKm/FJW7dYZVW4jPJHDlDfIvl7bKZzowNanCJY2c6Tl0birdT9AEo/bx+uCnJZcJnabu7fZD56iPzMs4HtvFj8sAZZAembdJ5RWsIXx1Kw1OUlvrQQGuom1uOYYrWQOWxxV2u+YrWtYui5hJ55Xs3wq74jdtlqjzVB8iRLXy5Gb3WX+yQ6o9OVjJLUwk1U4fxIX0FvE7fu5f/j8eX1h57suM1lCi9mODVnUQBHKWjeuwCytugnmgwnGNsIHazs+1k4GUG+xsWBNN8UiYBR8jUq7AYmw3Xlq6tr3LFVkugOOMn8vkZTS1FHMmaBymM7FTar9wz9eIh1s60gAabxgeld6wIh6gC9go1QBaK3uSPPJDI2HTcXoWBp2dCc2a0+eFMylFzLqIsuXYCavXivOSNz7BMeJ5/LVP3pbTdQUocwqE7/k+mm+yr5mBb+TzroHf9fKywQ2cWDdIL011rYAY33Ut3rEvGHVRzOg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(86362001)(40460700003)(186003)(2616005)(1076003)(83380400001)(8936002)(54906003)(16526019)(110136005)(356005)(508600001)(26005)(336012)(7696005)(426003)(81166007)(316002)(47076005)(6666004)(36860700001)(82310400005)(36756003)(2906002)(70206006)(8676002)(70586007)(4326008)(5660300002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:57.7065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eae4dd54-8ecb-4e7e-e8ed-08da309c0ab3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1325
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Originalliy, this WARN_ON is designed to detect when calling
avic_vcpu_load() on an already running vcpu in AVIC mode (i.e. the AVIC
is_running bit is set).

However, for x2AVIC, the vCPU can switch from xAPIC to x2APIC mode while in
running state, in which the avic_vcpu_load() will be called from
svm_refresh_apicv_exec_ctrl().

Therefore, remove this warning since it is no longer appropriate.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ad2ef6c00559..8e90c659de2d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1059,7 +1059,6 @@ void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		return;
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-- 
2.25.1

