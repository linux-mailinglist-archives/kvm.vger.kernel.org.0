Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2B5730F9E
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 08:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbjFOGrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 02:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244092AbjFOGqV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 02:46:21 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2052.outbound.protection.outlook.com [40.107.95.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC9A30F7;
        Wed, 14 Jun 2023 23:44:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6pg/9dxoomqm0TjtEQIDJGL64OC57dDGXGlhXC3z9sKkuq6hI1Mhndw2CGg47Hjlj1At1vBMgShrTqQnaQrcPX39kB8lr8tg3dJZujoOW7bZybUZUX3uMxo/PNGLbisZL5oUf5HHi2UGncVxKWTe8QyX+j27QBo68HHrbRD8qQTmA0krOcRBKopefYnLyZO2fP1Y+zy3U74FNgoqa7ZKvkDXBEr7FBj+pnSjGDXGrwesu1tbCaXH6wR3Le839YTwPyW0G0q9QmaoPsuDw6wffJ6ymZbr8sMlXufU4l+cESZBmWZuFbpK4RXFJSmY+rOpjdPs9jcVwluIGGIZoiC7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WS0scFMuNZKYxG6m9F5MeX99/Qkd68KofPCTfz0PbfE=;
 b=QCzGaCnHuTznW7nkPixjMXsK280ItykwNjEvdWRwHjgJO2V1M1D/1bQaS//lkkUg8NFslkNC+Fh+nWZjcuDBEwq1QxeltZujOsrhwtThsmtEmDUzr2jl8FAiXTPdIxdhbQ3B4YWxYymRLPd97tjIwDOAq59h94AEieCZQFkWuoLTwbm8nJnVDijjyrAgiZgY1CFsWzYhB2HPiFA+NGRjXS9+kvg/gd5HZ3a+lHCOvFr1o3mUMcNwYh8uuFFDx7zH0mIQnCRWZur1yauAeJ5SiOq62LJkfkIDhLMFZDO4fzzZQoBcs8Ni+jIjoey1v9P9hMp1MrG/INo8k0QWa0XleQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WS0scFMuNZKYxG6m9F5MeX99/Qkd68KofPCTfz0PbfE=;
 b=k+CIcul7RS5/cCQiV+qT6KZf8LUbGvxWjGRcdrLYmWfiGuN+zDLVXcPdJ3784wtUkArgjIxqgKgmV85BLEV19fOx/s1oFxAT4Gyi+PtRquijWPZVYDkGEN/UYXwOCEELF5g+xdIVs6tev4gU/JtSxKT50j6wEeOczz2skWmKBFw=
Received: from PH8PR07CA0025.namprd07.prod.outlook.com (2603:10b6:510:2cf::13)
 by DS7PR12MB5910.namprd12.prod.outlook.com (2603:10b6:8:7b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.25; Thu, 15 Jun 2023 06:44:10 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:510:2cf:cafe::7a) by PH8PR07CA0025.outlook.office365.com
 (2603:10b6:510:2cf::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25 via Frontend
 Transport; Thu, 15 Jun 2023 06:44:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.27 via Frontend Transport; Thu, 15 Jun 2023 06:44:09 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 01:44:06 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Alexey Kardashevskiy" <aik@amd.com>
Subject: [PATCH kernel 7/9] KVM: SEV-ES: Eliminate #DB intercept when DebugSwap enabled
Date:   Thu, 15 Jun 2023 16:37:55 +1000
Message-ID: <20230615063757.3039121-8-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|DS7PR12MB5910:EE_
X-MS-Office365-Filtering-Correlation-Id: df6dc960-92d3-4b31-7e98-08db6d6bec69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /YWQ/5KtStHUn0whob3JsC1pB5RThqK08IdrJkosFm8WOWKVkYri02t4T8HyPaUy/R2zNfa91G/N8iZbcLLLo3rOGBbAKe72PN7njZjCQskD2bbrWyrTowU8hETdJRIW708cG0DQ42naqyizOGG0/5o/9voFV3QbN9M3HZ0pfs05sHZKMtpzGPAIBy1IiXR3vtlEmA01pkT3YMinOCITrYmN0owZj70Lp96OpLtEi+Xse2QUl2NmEKPnixY3O/OC0nw/4QqsS/ELsi9jp7o8ywLesXYUYBUvH8cS3H7FEAi6f7A+enNtVRBZMVOeGk3BVLeqHj0k+U8M5JPo+3fzS8hw7JEBqYcTtpf9obO+5EaELTBgSm43Tg+f8ro31ksONWpX1HzdMYxT7qLeQzG+RnJo1i8kcWQzQdX+2iiWy1QMeyZSEqe/jaGujkR6qMfByRNcCqMfGavtlUBLyIRQyI1I2YenbvbLrNmP7zsmZhDapayafwiAL4URjv35QUgQL//sJ3ll4NBVGiCzLqM60N/08J6Lxu8HSMqfM8HTDJFvdKEckK/Ci0FDsVStXv50DMtUTxZ/5KMP2MDwoT5gcIK88iqvGeQQnxaEaxXp4jkQ0EYpqB96B7LxDeoFnhK2usnNmnaHYu2+xlFKgofY6osbgVt4Ep+6kzmW8EoXz6O+/8ucWaUUtm7VO4tXF5tbuKKJmcloNYi5INqhHligs7P8KBSx4LV/y/w010tU6DWEGi6iwqoO1RpS7jrVor86yTWcgMq14c8DQIqS4kmzfw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199021)(36840700001)(46966006)(40470700004)(40460700003)(5660300002)(82740400003)(81166007)(356005)(336012)(2616005)(426003)(1076003)(186003)(16526019)(2906002)(4744005)(26005)(36860700001)(47076005)(478600001)(40480700001)(6666004)(6916009)(70206006)(316002)(8936002)(8676002)(41300700001)(82310400005)(70586007)(36756003)(4326008)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 06:44:09.7697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df6dc960-92d3-4b31-7e98-08db6d6bec69
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5910
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable #DB for SEV-ES guests when DebugSwap is enabled. There is no point
in such intercept as KVM does not allow guest debug for SEV-ES guests.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
Changes:
v6:
* new to the series
---
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index abc502ce7871..9c43cbdab022 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3000,6 +3000,8 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
 		recalc_intercepts(svm);
+	} else {
+		clr_exception_intercept(svm, DB_VECTOR);
 	}
 
 	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
-- 
2.40.1

