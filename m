Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583655A46E2
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 12:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiH2KNR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 06:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiH2KMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 06:12:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A63560683;
        Mon, 29 Aug 2022 03:12:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwSF41Z6EOScUNvJL77uqGyFspbLr17yuK3kyxnmrkfepqUo4ZGa9PwKkrceSkHKSbuOdRAHaZFl0KYLZGnvrsBV75RZzNBV1fAzPszEKWfBcAWXBRT4+Dc6Gbe91JolRdM5vF2uBz3KAW/kHZGMaRY7+ckBXXVRx/fRE+foXz8cqleTDZYQE5NHLwZs2sTk+KPVVmc6+GmidVMhOWbDWss5URqBCWInEbxLmX/DZG6zi+InEW/6ajmiUzuN2sw1zYMIpq6VvWO9BKCrJxhz2rZ3kHGaeBq18qe8GB2A8ZrQbCBERg/WUtdVyBcNOinomO3E4j8nNRHw+znKIbFksA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6EZG/lz1SUy56FBbUHo27pkj4aikMggVHur0m7qvhnw=;
 b=eIk46hUOohYANPVhCAWzjF3VqwnSn5a5wLq0vKoRCRKEbvaaYLojt7FmUkIiqRZcvRMLYJdZ/WXoktvYiHEI7IBntLT/p3cm+u8p8/JzlMsH3uzHWj3Aj/K6Zu9RO4+DBBUuCQnjjvS0M75eu5pi3GcLcEsCAaRBzq/WucOUhKfePuWVrQehuXh5f6AEIDUHPAfYePwUHb+nVkHx7MIcorEF2I9BFez/BbkYSyxh2kv93ZLJGbEC8mcYifbDxQ9DKETcide0wOXhFJ3X71rfwLFccxtQoFjpR/nZGzqBpxm5UFTepMXNLYVadLWY5nKXF+e4AYSH7UsE/1XqQnmQXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6EZG/lz1SUy56FBbUHo27pkj4aikMggVHur0m7qvhnw=;
 b=42lLqhGUiibh/IZSKl0XI/9iMyM/07j7bUjig+lMbUNHJRBPasmbyfxD562jfZOyOKq/OC9tBGWo3oQTmpOww3xlBCEOBPdqEHGLX4vG0LE+w6v6Es+rExaiaQcaXRsDy+lh1GOJ1RTbudVrIzx9H6pATAbmsum1CilKjRGuTnc=
Received: from MW4PR04CA0259.namprd04.prod.outlook.com (2603:10b6:303:88::24)
 by BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 10:12:34 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::ca) by MW4PR04CA0259.outlook.office365.com
 (2603:10b6:303:88::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14 via Frontend
 Transport; Mon, 29 Aug 2022 10:12:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5566.15 via Frontend Transport; Mon, 29 Aug 2022 10:12:34 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 29 Aug
 2022 05:12:28 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>, <mail@maciej.szmigiero.name>
Subject: [PATCHv4 8/8] KVM: SVM: Enable VNMI feature
Date:   Mon, 29 Aug 2022 15:38:50 +0530
Message-ID: <20220829100850.1474-9-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220829100850.1474-1-santosh.shukla@amd.com>
References: <20220829100850.1474-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df736ec9-864d-4474-a0f5-08da89a6fdf8
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gKVEjZ6wzsETItt+MGa6sEH7ST+TtL/SqjingZc7A1ITc2seBXJvcUl+MdxMisd7gR19C3KMA/vMUorybc2/BwL23+FLdtucXSh66mpL6tHcBj2QAaeLprBmPVuxPjVp0MtpuvWYgdT9o1uMOzxPFq2CHUA2PGT5EvU9E8rc9KkCWwBmucqA4M9qbj8I9dgUjVIcCjBv/QXJ+JVYmWNlF2gqvXaHurotaQ0BLt9tE406wXZlxHPpl6TanYKKDfGQbCMR1FrpuBbU0Rxdx0OGSNv264jQJ9farcDHwxXodXfYLRqZMcgvT7GB5eWx5dHHHODF6wlTZyZrTea0e6DST51PX4VPhJY349t1fVnCgSKZ0eeiFCPVpI5oP4M90FFWUdI/t9WNxW/aQ4UG8eY8pz3WwOdqC8pJqhPAgtRtLtqaqx+Xknfh2+ZEDTk8F3I9aQlpKzeJq94or8hC+BTc0nWOHzF2EXd+wMCpKrZKwohvYIO8a8cEbHDBwGEE/cQdLddGQ6MtWpfHpDjz+3823lrwBiB+eLzKBCD2VYU6mh3XoD7cS/KyIZ7BIbgr+IwXJONpItX82U2oobsEIx/streStD6aLCvarRKkaNawZe3R6bOcPipem63IWAxaiqEuhvvWnipMq+p7GZFmLFBaaLmv3oCtHIekinf+kCoG5cWLd76bPfzVv1AxQkwstHg3TNkad+8PDpAGMyp+9S+GzaOcWqWDux+LQOFSF9vrv21VXkH8YH4HXEogXIYXDkq6Pi1VkoB+MH8gGJbqWPdthCJ6ar/8dd5453bylq44YXJCeDnTX2oxfIJeMv7nxQbY
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(46966006)(36840700001)(40470700004)(81166007)(40460700003)(16526019)(86362001)(36860700001)(1076003)(47076005)(186003)(426003)(336012)(2616005)(356005)(44832011)(82740400003)(5660300002)(36756003)(4326008)(8676002)(70586007)(70206006)(2906002)(82310400005)(40480700001)(41300700001)(478600001)(7696005)(8936002)(4744005)(6666004)(26005)(54906003)(316002)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 10:12:34.2977
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df736ec9-864d-4474-a0f5-08da89a6fdf8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3587
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
index 2e50a7ab32db..cb1ad6c6d377 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1309,6 +1309,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
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

