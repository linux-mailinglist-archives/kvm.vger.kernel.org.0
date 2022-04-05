Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5B04F5517
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447620AbiDFF2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452803AbiDFBQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 21:16:58 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF76250E2E;
        Tue,  5 Apr 2022 16:09:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvGiD/E/OeefShMHc3Msbp0rnscet85wT6fhHN017oEhXtXiPLNgC8J1Ia8jEg1WRLh2HtflZDzYlnfhJZrn/eQ31mhEL7WiOog0gaks4NVpok1HAozxAoncAJrJ5U1mi8fku3EdhL0hufSIk9+l75nXxDIgiP/ycgv/Ka5S2rJUsiADVqIxAFT0wnknhzxtNGRJpnCuoFWBXhSmUDYkDXXaMg9mW5s5YICMtcLvG/y83RHBLxuNxZlZ2LydkSJe2EqA0Pi95pVpu+E5I3W/QigiIjzP0JLqLrLS+/HEpFft/Fl2UHQi4+tiiGrX/qfBlT+CJ3PS2BtQh+rPH885Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yacE6OKEKnx+/koW7G342VZeET2TD803Nk7WjnEfy3c=;
 b=HlqLFrIgpB9zgoc45EhMrtjCQEqiatEmRs5AhTXwRlpPWa7bIZlZqqFAMWj9cY2CZSNWxe2ne5HH9KaDqzXqRLRYFORyA/bw+uSlkRERb1Vtx90njlC/IQmCM4JdVtzcQEJx6aAhNIzoXAMrfoWZHVelZB5cryQDaRHo70/l3gQ5v0xq4DytPbynJy8dPzWE+kBO76KeRoXM628uD0EhpJS8z1QQsxSg7F2wkFawQqMJZflYqr3dpGZW9Jz9WzhE3cfmFRv/HP5TVQ48lAdVRCBsuiRAFWAlrjzPrAPzpsln1kfdQDPi2j9u9HsHq7oosslK4sKLkBxza2Kv5UOdAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yacE6OKEKnx+/koW7G342VZeET2TD803Nk7WjnEfy3c=;
 b=KX4dtUGFINVHH2tqICoFmIL+drr3Ys6RN0cPHjO5OVaGg/QixS3loTHuNWpSKzXgjS+w0APMXISaUDitUFoIRGb7y46o47etrMtTSJEZjhjt2PcRpOwRuLQbKW79+ZjF0WrxhPaVJAvX0N4mInX5mmpuhcdrQjqHGEo0kL5kru8=
Received: from MW4PR04CA0086.namprd04.prod.outlook.com (2603:10b6:303:6b::31)
 by BN6PR12MB1138.namprd12.prod.outlook.com (2603:10b6:404:20::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 23:09:33 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::a7) by MW4PR04CA0086.outlook.office365.com
 (2603:10b6:303:6b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Tue, 5 Apr 2022 23:09:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 5 Apr 2022 23:09:32 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Apr
 2022 18:09:26 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 10/12] KVM: SVM: Do not throw warning when calling avic_vcpu_load on a running vcpu
Date:   Tue, 5 Apr 2022 18:08:53 -0500
Message-ID: <20220405230855.15376-11-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
References: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05e0645d-dda4-42eb-7194-08da17595835
X-MS-TrafficTypeDiagnostic: BN6PR12MB1138:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1138FF56B9473FFBED33EF0BF3E49@BN6PR12MB1138.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cS3LulhUXuUFayerPHhkqoknXxbV/se4n/tlUTbZX3hnC1MzfIwmZHx1yVEBxvNJTM1cKGp3o3v3BFfDy+eL2LHXlX2wyPh8KKirkMpjuVmau2StJaDjk4Vr5AQvRh+UZCFBs2ZbtR0yRKor0mJ2jVSIRXb9cnYiEMY7h0G7MwmxfqSAP71Da+N3+aO0+KV67/Ik09alIbRLBUXbbMi1GFjw9ZJ8FMaB6NgVX7n9NnFzcPLB8Z5gbOnPx8ZRCeQpj3TvmNLr0yAzaHTACPlNxALQs3WWYp7928b/Rx6+W6S9GsVCX3sBfNZzJvuY2kOjC9EtGlNePxlH6WlNhxOEFyXB5repCaSd4RL7MKRvNLxDYHbsdMex1ZQNEMREZ1kzCKIWimEntTG9ltiirIGkt2y8a41JTMuiRjFXeVz+eRQ0YrH4X8DdMtF2v0hkmkEOww6hyx6IU84+cgBSrniXBF053J3Vxjuc0T+x44SPFi18t5Fkw5w6XlHuzZrJRgGDdGiTO+70ZA1/xaiQrXkD6YmNS4S9CgwkDSptu13zGxGwQyRA2UgSvg0mWMndK1HxFNLe7WFJ7raoMcGgEEc8wmIPYIJLeUkBC4hfCl8sfJ/O0i2LZCFTvu3YiW5tYWwh4Nd4d94lWd4sofPWWIrKPPQvn39PoYH/T762l7709pOg1Qe9F+LTFY4etT5ofkj4Mf6KUjl5qNQFNq5exRNF4A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(26005)(336012)(2616005)(1076003)(16526019)(186003)(83380400001)(36860700001)(40460700003)(2906002)(81166007)(86362001)(426003)(356005)(47076005)(8936002)(508600001)(6666004)(44832011)(110136005)(316002)(82310400005)(54906003)(36756003)(5660300002)(70206006)(7416002)(7696005)(4326008)(70586007)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 23:09:32.3428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05e0645d-dda4-42eb-7194-08da17595835
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1138
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
index 4f9990526485..a6e161d62837 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1030,7 +1030,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		return;
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-- 
2.25.1

