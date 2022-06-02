Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86D753BAC2
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 16:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbiFBO2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 10:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235955AbiFBO2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 10:28:46 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3477018C069;
        Thu,  2 Jun 2022 07:28:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmRsTHgxjM+qLW8VGUDQoIsXqkInz8oCSrpRKrp6HVhEFepSR3BKkjgixOgMeCB2JOlY/z1T1D3aCwXMRjy4R5kTRoNSOnUxSfqhSzsEy8OxTZBkfmeLP+7wEFNc/IV03TrLCbopt1dSzmzaFPtkJndiFjzWihYBnASgnOM2Z6u5W0sNqfMNAFycWFnhRx37euJHqTZCxstGiVmUvhtqwisSjTtY8GTZEsgrxV2Jzqfnyz48cJ7HrgXyM8tb/G5XeJdWSlspKVzy4qHk4glezZ8Da1YZe8SnOnSYeF6H60TlFq4hUAI9nb8ejhWrL8/q8XGzuCLhxKqfsQmC23YojA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4o5M/PHVM2K2EaB3FB0RY9K4/h4bIXBFz2A3qhlq/MU=;
 b=bEcRWrRH5OtgG/VlhxqDlGJqh8zrqhjayueAqk+OcMj7P1jQDBh1YoXZ11Rlsq30d/sGtm5ycwmxvrR/pbdQPj2JPfGnzGMFlpegOf0N4ImwQvofHkXaUPJPxweGD2vnxt/67lK/Np8nabdz+F6IKlcDgslKqWtAErh9XtQYGQUhUv/wJAVgSP4GoevcwxHzsTKuUkLSYdCe2DsMUc2OjUc7p0CjyiyeJgzQfaKJKcViX2/Sw8rdZ3lUJhWUEe+vPDVzCg4/E3szOH7ntfUvmLtHLXQLGRrVIUSfvhkGSWzbC/TRdDemudps+WkA/HOOulv2DAq5VXSbD5TM6haSyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4o5M/PHVM2K2EaB3FB0RY9K4/h4bIXBFz2A3qhlq/MU=;
 b=QUojEj1pX1csNDuxq9TqGyK1LhoLZzpOim7OusrgGb2VqjdqHgUppEkpcNwZgavG76aMiLszob5eaid/QkCcRVJ6/seSwszc1mf+TYgzPh4sMCp/Rtvj0OgHeGETFB30izqxCZ8dZnIfugFlI4dj1GaQaEYo2fp/cnmHAnNpiic=
Received: from BN9PR03CA0120.namprd03.prod.outlook.com (2603:10b6:408:fd::35)
 by DM4PR12MB5181.namprd12.prod.outlook.com (2603:10b6:5:394::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 14:28:35 +0000
Received: from BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::6c) by BN9PR03CA0120.outlook.office365.com
 (2603:10b6:408:fd::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.14 via Frontend
 Transport; Thu, 2 Jun 2022 14:28:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT067.mail.protection.outlook.com (10.13.177.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5314.12 via Frontend Transport; Thu, 2 Jun 2022 14:28:34 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 2 Jun
 2022 09:28:31 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCH 7/7] KVM: SVM: Enable VNMI feature
Date:   Thu, 2 Jun 2022 19:56:20 +0530
Message-ID: <20220602142620.3196-8-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220602142620.3196-1-santosh.shukla@amd.com>
References: <20220602142620.3196-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 037eec7a-2e42-4aa6-69e8-08da44a42d17
X-MS-TrafficTypeDiagnostic: DM4PR12MB5181:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5181F8EA4391115B068213D187DE9@DM4PR12MB5181.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vMATC3bz/hzMS/UFskpr0JlDqLicprtCqRWCMJP1y1C85wwCep6BN3lyZoMpaFInCw3/r1pUWg6BY9xz9QR9QhU+7r9zDAcQ/5fVrFhtc7eZdVVcQ+a6BJQV+fKlbD5Pe4J406dVICnH4F2NG8PXtC6PXLvFo28N0X0gZNW+PCohj2RwCudk8FznH9oWqOYZ2e4ftivYeCpFxVTdxCvqdwOPSE/0nbHGTr9HAtwSzBn1Et8eT1W4SA132zGV4eXsrDn7qo6x1AE4JB0/dyQD8ad3grSH5UfG7Akbmnar/VRVkexu5+ZihwM0VSsOPCC6cqCErFOavri7I9NybfqWtzwKedRwOi+QLDSbeTHQiaYjhkzXjzfYhh9l8zWuKoKvoXo83TugJiqMe3sS1SFfcfrrw/3IgQ+lhnsvwZYvqhz/1a13Ml1MnB6csNsie0nW5XqUN5l5+wnCNLwCtD+fPap9QDDsGFLtH8LUZdawIVepgju1Fst6RxWc092I+ig0GvGW1zsWDLQhwiKLcj0V3KXZkO4qzQdVfCeDn7D78GjNhr/avyD1+Pr7bomDZgbE2yQsmhDagewSznb0sahKnsUaREqS5b3zbQDkVTfmhuKTv8pgr8u7nATIq74LsUntYled3KXx3UK9zXbLIMX3VhbBmsvfYUBkUQoqFPxzA+Lh3rGGBgAWajRXGYnK2k8bVCde9S4ZVqKcGrLyzbBuag==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(70206006)(508600001)(8676002)(70586007)(6666004)(36860700001)(4326008)(316002)(86362001)(40460700003)(36756003)(336012)(426003)(186003)(16526019)(47076005)(1076003)(4744005)(82310400005)(8936002)(356005)(26005)(54906003)(6916009)(2616005)(7696005)(2906002)(81166007)(5660300002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 14:28:34.7399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 037eec7a-2e42-4aa6-69e8-08da44a42d17
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5181
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable the NMI virtualization (V_NMI_ENABLE) in the VMCB interrupt
control when the vnmi module parameter is set.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c91af728420b..69a98419203e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1205,6 +1205,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
+	if (vnmi)
+		svm->vmcb->control.int_ctl |= V_NMI_ENABLE;
+
 	if (vgif) {
 		svm_clr_intercept(svm, INTERCEPT_STGI);
 		svm_clr_intercept(svm, INTERCEPT_CLGI);
-- 
2.25.1

