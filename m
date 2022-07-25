Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1669D57F87D
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 05:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiGYDgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Jul 2022 23:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiGYDgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Jul 2022 23:36:02 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA87E9FD5;
        Sun, 24 Jul 2022 20:36:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgWC84I/In1KoiolmvjTb0winfQsxNXMvSltcKkjjQUD343Hod/l36WZhVeQTUuwwP+gTE3OUULkFYso+wkVe7KVCOyPdZK+iYlobFUjPgE++pyeDGlOlUrP2EVIeBYs10N+vp3x+qEUXLr/4M9TwJUxi9HMljwIDE/bHMO9B5lFrHe/C4WGGk4/TNfk3qjmq0uCAS+CEw+zPnNw7Vrb+2bvwinmGPTGjs1zzseiWLL/a29IiqdkAAyp/bq6U5qZPceZUg+d+sYA4yuYXeiqU8bsS2ND4uYFKG4tGNm62ePlYJJ+KdAE4ddCcorcmFWVrUPNSQV2kgKtMZtF0UKqew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XF69tEqsepldP4zQsazJx8J8n7hNI3Mg/MtUAmVDPQE=;
 b=JKbibDcmLFc/6dmCweH5UnIKqBM5nTY5Z7EjllEibOOSi3JPxJUrZTZaQpHPZXTMLVqoq5MnVBYoKkK+dnhTTRvaRYgU95odWT7EbFsbuCScTSoT4omy23dhIablqLHvcQcOA3o8EjXyNxNtmDY/l/4o61F5Mj/PS7Lzp5DIqlZEemF/wQ55wreiYdUzspLdOp1IDxtHPDvZnafckR2s7x020PktvEsvEr1rdFT+8bAlzAY1gcgeTm/w+eQIX7VxrtBM5lBQqdOagl5aZx5F/2vj/JW8VX997DaHMqZYsMlEai4Zlf9nlxk1xAaqpFYL7FUPBczs9klU21zm5R/AgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XF69tEqsepldP4zQsazJx8J8n7hNI3Mg/MtUAmVDPQE=;
 b=yhPtvNnBEgmDqPXjbaONbQs25pofnyCeJFD73L6x/kehqLZpaKE60sFCC4n7ooD98XHmSBCnRFNFSNqb13ixy7JCmqrX1xrLGMpA+g/KzJShCsSPn/1EHN0GTVwaO0xnuhWgkXrX4SpmAeKhk2qQIibqZcqK6/3dHPX1PhUfqmA=
Received: from DM6PR11CA0067.namprd11.prod.outlook.com (2603:10b6:5:14c::44)
 by CH0PR12MB5060.namprd12.prod.outlook.com (2603:10b6:610:e3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 03:35:58 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::1e) by DM6PR11CA0067.outlook.office365.com
 (2603:10b6:5:14c::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21 via Frontend
 Transport; Mon, 25 Jul 2022 03:35:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Mon, 25 Jul 2022 03:35:58 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Sun, 24 Jul
 2022 22:35:53 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] KVM: SVM: Do not virtualize MSR accesses for APIC LVTT register
Date:   Sun, 24 Jul 2022 22:34:28 -0500
Message-ID: <20220725033428.3699-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26bc5cd5-e7fb-447f-0f54-08da6deeca29
X-MS-TrafficTypeDiagnostic: CH0PR12MB5060:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OMQTW/TWle0fL0pCN2LyVQoCI0Ji91f8lfzkZ8dFEBaqJUxYCmxi7YdIqPQxsBenYXr++b0dHjszBMh2Be8jOfYoG25a01MDisCgnYNlnETS/THBZ9Cv1WJxc/SU2axt7QmuHTV82iQIZlFDqlxT/gwXtGMNXLvJSINYrg5nFWeONduAkKbRn6APM+EmBlQWiP4kuIUGZA32GAbJP+WFx3hSVzUK06QdYCXVIDwjDtoNpHXBkrfM3skPbHorrk6ExWs6sCRMEvSmxmB8Iw4l308siNLTkE6leCauBxU4Q2PlV6PLejaK1xhn1EaqgVza3O/+oAl33/EvSciFvTRvuZzvwEf5a25Gjaic31mdmpqwxdkxyt8sQF8mK9UP901ydLMSXmfFwY5K41bqGEATMtfhlTX8HXvPh4h4CzEHVYct6Fq12QQYE0UPLRMylve2300w2bFYDIMD+AicaABNGvEKOEqlNxE6Rhkh6wQgbKhaHNDztELPX0aq9qHvhGbAlScznS8RWk1+9+H81ZcO9erhDhi1IR09rKHFMfzr+jWiGl7o9khsLAr/Naj8ZhSc1xx6zCrSC0U1L70IfWDXqYa5feqSoUrzElHSFozefWFJq1OgMGSPLe3YKyvWqY6cdFOimhX4XfqYAW93CtlWGDu5RzAU3t2ow9u2nSgajIucQ4TMWXn9UaLtLKOpOiJjgsgHMfzn3g3TGDd0PTWWquK6dFl7ajmi9htLkcSw5fC3xZS4b+X4zzeehAbLfILO5ItUs59QQerrfBpxPs0p5Y2OEr+rNLKueGazWYaDB2p2aBjqC6NqxRMowuKVVxsms2qnB76S0DMGbMs9Pcdn/Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(396003)(346002)(36840700001)(46966006)(40470700004)(82740400003)(356005)(54906003)(110136005)(81166007)(316002)(82310400005)(36756003)(2616005)(70586007)(70206006)(8676002)(4326008)(8936002)(40480700001)(16526019)(478600001)(36860700001)(1076003)(5660300002)(86362001)(41300700001)(6666004)(2906002)(186003)(83380400001)(40460700003)(47076005)(44832011)(7696005)(336012)(426003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 03:35:58.6585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26bc5cd5-e7fb-447f-0f54-08da6deeca29
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5060
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD does not support APIC TSC-deadline timer mode. AVIC hardware
will generate GP fault when guest kernel writes 1 to bits [18]
of the APIC LVTT register (offset 0x32) to set the timer mode.
(Note: bit 18 is reserved on AMD system).

Therefore, always intercept and let KVM emulate the MSR accesses.

Fixes: f3d7c8aa6882 ("KVM: SVM: Fix x2APIC MSRs interception")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/svm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index aef63aae922d..3e0639a68385 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -118,7 +118,14 @@ static const struct svm_direct_access_msrs {
 	{ .index = X2APIC_MSR(APIC_ESR),		.always = false },
 	{ .index = X2APIC_MSR(APIC_ICR),		.always = false },
 	{ .index = X2APIC_MSR(APIC_ICR2),		.always = false },
-	{ .index = X2APIC_MSR(APIC_LVTT),		.always = false },
+
+	/*
+	 * Note:
+	 * AMD does not virtualize APIC TSC-deadline timer mode, but it is
+	 * emulated by KVM. When setting APIC LVTT (0x832) register bit 18,
+	 * the AVIC hardware would generate GP fault. Therefore, always
+	 * intercept the MSR 0x832, and do not setup direct_access_msr.
+	 */
 	{ .index = X2APIC_MSR(APIC_LVTTHMR),		.always = false },
 	{ .index = X2APIC_MSR(APIC_LVTPC),		.always = false },
 	{ .index = X2APIC_MSR(APIC_LVT0),		.always = false },
-- 
2.34.1

