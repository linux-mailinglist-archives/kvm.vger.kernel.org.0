Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4189730FA5
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 08:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244342AbjFOGsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 02:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243833AbjFOGr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 02:47:27 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07652D73;
        Wed, 14 Jun 2023 23:45:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+eGVH8AKE2F4zQrZsE6YVis1zrKs741KNUWPUEyq8j6bLjFXZIkD3Cc2x/ZrlJYPcX4kk1hxc820MWuLYhs2v6JNi3UrEvlpaX1sf3FW6ADsxVx1TPC9ga/xSXZgN50+nkmgLaGxdodGI9ewAkVHvsItRLDk3/arkbTYqjAdEnzswD4dMuO+CIX1LcIKH9Iw78V6dLa2HUKFR2ofaQzwmQPE/TvRXHmBI19JEw0BlRjZ5/cg7peCRbCrPm/VKf3mVlxB3yjjedPbwCIEEanIwnfvdsFX4Kde+8d00D32uFx6QGh4sfhJwk+uZhoTG0juf7+Fp0gcFbkQfpVlwHqFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BU8usJu9FWlNapYkideYsZqh/0lbBgQTMVI09v776vM=;
 b=OZ/9Lf/Bh4aY1MYHOj28Cz8Pb471ARDyrv5eFPu+MxbqCCmqTu3F8EGyptGPffuuDUMaLJ+Q/HG8477tLfuflgpvtJJbaOFritYFj6dvSX0ywyt7rKt5/v/Vqo6atSUs9bwE7vro1RC9jRsKpGX/usa95xEg62K/ISCx7qDLKbRfWKhbq/w7s95tZf0khlag1RnTk+8rJKIWOEuqyOVrS+kuzXdxeTyiX0Qw8CYmgfSAilh+ICYjYoBzHXA9Laone+98Prd99UyIqeLTwZSetq5yOFQSEHqQcT8AfUfSzdjIZjZmvKi0Sf5ul5icwrah7Da3lRAsWSuh9mKYCFwbMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BU8usJu9FWlNapYkideYsZqh/0lbBgQTMVI09v776vM=;
 b=CsccAJ84eIYBvbGdcm2md5XOnYNaPPbB5rxKpi3YVz5ydPReJ8/gF+/C3Y2Bj9KymaDIxec5vZ8MWImM6SBMa2fF7R/A7qSjiVrPhh2TtLzyoAoc4hnQkIdsxMaO177ySKkE9wciyE9i5li3MxMIYIPLEuVNWW3H/Qk04aYj+fg=
Received: from PH8PR07CA0004.namprd07.prod.outlook.com (2603:10b6:510:2cd::13)
 by DM4PR12MB6397.namprd12.prod.outlook.com (2603:10b6:8:b4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 06:45:54 +0000
Received: from SN1PEPF000252A1.namprd05.prod.outlook.com
 (2603:10b6:510:2cd:cafe::57) by PH8PR07CA0004.outlook.office365.com
 (2603:10b6:510:2cd::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37 via Frontend
 Transport; Thu, 15 Jun 2023 06:45:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A1.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.27 via Frontend Transport; Thu, 15 Jun 2023 06:45:54 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 01:45:50 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Alexey Kardashevskiy" <aik@amd.com>
Subject: [PATCH kernel 9/9] KVM: SVM: Don't try to pointlessly single-step SEV-ES guests for NMI window
Date:   Thu, 15 Jun 2023 16:37:57 +1000
Message-ID: <20230615063757.3039121-10-aik@amd.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615063757.3039121-1-aik@amd.com>
References: <20230615063757.3039121-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A1:EE_|DM4PR12MB6397:EE_
X-MS-Office365-Filtering-Correlation-Id: 37b20135-383b-40aa-e660-08db6d6c2ab4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wdbAKxL95S0WRAWLCF/G6GtFVaAs39K1D4rTp9zNFuslMq0C+xMDqlAtuvX/T4HhNvoxDuXX9c+uIfx7lYSh16mFmkUD66vJX1pv/WjOGVYpfdyFjKUgqWRFasQy4Of1aQdfjZlpr3L7cAXx5wnRroTDc0jvEMD5Ua4X3L6OJdNefgKgbIqONo4wkMKRxCODDrByag9JaN/lASbIV39Y9b2IBsoB+7SWFrmwcJy34Hz+7BxoTdBKgwrI85DPvE60qIJpPtVgfF9RROuPLNtCOeYZCUXarimueEXxqcLNvqVz8K9StqtIZ47B0mfXLNlgW6nmsHtN9n1I7nhubEjHkZzPB94x4odio87yirjc5/wnPR9IDQXtPBezETozEDjuhedl2XRdEh8dg0H8coZr2abv+Q5cAVQ/CqZN1W7PGd1a7NjlZ6giNX/mt7hQp1UXI0Zjlf3mdNKwMjjIOVWstNumh71y3ki3lPngP7HPq1ZkLyZnRQYld+NEZ4GKC7Vpouq/fqJB0GVLXWN8lnsLqTmkZLL8Jrxp5MGtlS0pa+vY25BHsTHo04NGMambr5+FVXoOc9fAxlaAnRRPAJpX33Bu/AJNCocaOdsY6V1FLPQpoyUHGAW1XaF2uW3Ii5PwsnBmIzCh8r4hu2Q+3kkwDQq+HOYviTtDxGjhzaGJXB44Yhxv2WxxdiXeASs59DcbYu1CtdKnVlWGT9BQTo4xVPqdqDL5IZOJThfS34Fgo9NAkmHgHQUINgdiDJVQ+XLM2DS4s86W+crjSkw0h7xHuQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199021)(46966006)(36840700001)(40470700004)(1076003)(26005)(478600001)(16526019)(36756003)(186003)(40480700001)(40460700003)(2906002)(316002)(41300700001)(356005)(82310400005)(81166007)(5660300002)(8936002)(8676002)(82740400003)(336012)(426003)(54906003)(83380400001)(47076005)(2616005)(6916009)(70586007)(70206006)(4326008)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 06:45:54.2826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b20135-383b-40aa-e660-08db6d6c2ab4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF000252A1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6397
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Bail early from svm_enable_nmi_window() for SEV-ES guests without trying
to enable single-step of the guest, as single-stepping an SEV-ES guest is
impossible and the guest is responsible for *telling* KVM when it is ready
for an new NMI to be injected.

Functionally, setting TF and RF in svm->vmcb->save.rflags is benign as the
field is ignored by hardware, but it's all kinds of confusing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[aik: removed the clause about "KVM suppresses EFER.SVME (see efer_trap())"]
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
Changes:
v6:
* new to the series
---
 arch/x86/kvm/svm/svm.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 52f1d88e82a0..c9837a8667b7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3824,6 +3824,19 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 	if (svm_get_nmi_mask(vcpu) && !svm->awaiting_iret_completion)
 		return; /* IRET will cause a vm exit */
 
+	/*
+	 * SEV-ES guests are responsible for signaling when a vCPU is ready to
+	 * receive a new NMI, as SEV-ES guests can't be single-stepped, i.e.
+	 * KVM can't intercept and single-step IRET to detect when NMIs are
+	 * unblocked (architecturally speaking).  See SVM_VMGEXIT_NMI_COMPLETE.
+	 *
+	 * Note, GIF is guaranteed to be '1' for SEV-ES guests as hardware
+	 * ignores SEV-ES guest writes to EFER.SVME *and* CLGI/STGI are not
+	 * supported NAEs in the GHCB protocol.
+	 */
+	if (sev_es_guest(vcpu->kvm))
+		return;
+
 	if (!gif_set(svm)) {
 		if (vgif)
 			svm_set_intercept(svm, INTERCEPT_STGI);
-- 
2.40.1

